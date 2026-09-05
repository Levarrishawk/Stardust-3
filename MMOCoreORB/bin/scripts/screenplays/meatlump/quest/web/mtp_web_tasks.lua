--[[
	Meatlump web-quest helpers.

	ruling 2026-09-04

	go_to_location and comm_player are not in MtpQuestEngine.
	This screenplay attaches active areas after grant and finishes those tasks.
	SOURCED: questlist mtp_meatlump_king_story QUEST_REWARD_LOOT_NAME
	item_mtp_king_corellia_times_story -- granted when that quest completes.
]]

MtpWebTasks = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MtpWebTasks",
}

registerScreenPlay("MtpWebTasks", true)

function MtpWebTasks:start()
end

function MtpWebTasks.grant(pPlayer, name)
	if (not MtpQuestEngine.grantByName(pPlayer, name)) then
		return false
	end

	MtpWebTasks.attach(pPlayer, name)
	return true
end

function MtpWebTasks.attach(pPlayer, name)
	local sp = MtpQuestEngine.byName(name)

	if (sp == nil or pPlayer == nil) then
		return
	end

	createObserver(LOGGEDIN, "MtpWebTasks", "notifyLoggedIn", pPlayer)

	local guard = 0

	while (guard < 12) do
		guard = guard + 1
		local progressed = false

		-- quest_shuttle_comlink / shuttle event are absent from this engine (not Lua items).
		if (name == "mtp_hideout_retrieve_delivery") then
			if (MtpQuestEngine.isTaskActive(sp, pPlayer, "useComlink")) then
				MtpQuestEngine.sendSignal(sp, pPlayer, "shuttleTooHotCommSignal")
				progressed = true
			end

			if (MtpQuestEngine.isTaskActive(sp, pPlayer, "shuttleLanded")) then
				MtpQuestEngine.sendSignal(sp, pPlayer, "shuttleLandedDelivery")
				progressed = true
			end
		end

		for i = 1, #sp.tasks do
			local task = sp.tasks[i]

			if (task.type == "comm_player" and MtpQuestEngine.hasId(MtpQuestEngine.getActive(sp, pPlayer), task.id)) then
				if (task.title ~= nil and task.title ~= "") then
					CreatureObject(pPlayer):sendSystemMessage(task.title)
				end

				MtpQuestEngine.finishTask(sp, pPlayer, task.id)
				progressed = true
			elseif (task.type == "go_to_location" and MtpQuestEngine.hasId(MtpQuestEngine.getActive(sp, pPlayer), task.id)) then
				MtpWebTasks.spawnArea(pPlayer, sp, task)
			end
		end

		if (not progressed) then
			break
		end
	end
end

function MtpWebTasks.spawnArea(pPlayer, sp, task)
	if (task.planet == nil or task.planet == "" or task.x == nil) then
		return
	end

	if (not isZoneEnabled(task.planet)) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. ":mtpWebArea:" .. sp.questName .. ":" .. tostring(task.id)
	local old = tonumber(readData(key)) or 0

	if (old ~= 0) then
		local pOld = getSceneObject(old)

		if (pOld ~= nil) then
			return
		end
	end

	local z = getWorldFloor(task.x, task.z, task.planet)

	if (z == nil or z == 0) then
		z = task.y or 0
	end

	local pArea = spawnActiveArea(task.planet, "object/active_area.iff", task.x, z, task.z, task.radius or 32, 0)

	if (pArea == nil) then
		return
	end

	local oid = SceneObject(pArea):getObjectID()
	writeData(key, oid)
	writeStringData(oid .. ":mtpWebQuest", sp.questName)
	writeData(oid .. ":mtpWebTask", task.id)
	writeData(oid .. ":mtpWebPlayer", SceneObject(pPlayer):getObjectID())
	createObserver(ENTEREDAREA, "MtpWebTasks", "notifyEnteredArea", pArea)
end

function MtpWebTasks:notifyEnteredArea(pActiveArea, pPlayer)
	if (pActiveArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local oid = SceneObject(pActiveArea):getObjectID()
	local owner = readData(oid .. ":mtpWebPlayer")

	if (owner ~= SceneObject(pPlayer):getObjectID()) then
		return 0
	end

	local questName = readStringData(oid .. ":mtpWebQuest")
	local taskId = readData(oid .. ":mtpWebTask")
	local sp = MtpQuestEngine.byName(questName)

	if (sp == nil or not MtpQuestEngine.hasId(MtpQuestEngine.getActive(sp, pPlayer), taskId)) then
		return 0
	end

	MtpQuestEngine.finishTask(sp, pPlayer, taskId)
	SceneObject(pActiveArea):destroyObjectFromWorld()
	return 1
end

function MtpWebTasks:notifyLoggedIn(pPlayer, pGhost)
	if (pPlayer == nil) then
		return 0
	end

	for _, sp in pairs(MtpQuestEngine.quests) do
		if (MtpQuestEngine.isActive(sp, pPlayer)) then
			MtpWebTasks.attach(pPlayer, sp.questName)
		end
	end

	return 0
end

function MtpWebTasks.giveStoryReward(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInv == nil) then
		return
	end

	-- SOURCED: questlist mtp_meatlump_king_story QUEST_REWARD_LOOT_NAME
	-- item_mtp_king_corellia_times_story QUEST_REWARD_LOOT_COUNT=1.
	-- OURS: the fork-side analogue:
	local template = "object/tangible/meatlump/hideout/mtp_king_story.iff"

	if (getContainerObjectByTemplate(pInv, template, true) ~= nil) then
		return
	end

	giveItem(pInv, template, -1, true)
end

local origCompleteQuest = MtpQuestEngine.completeQuest

function MtpQuestEngine.completeQuest(sp, pPlayer)
	local giveStory = (sp ~= nil and sp.questName == "mtp_meatlump_king_story" and MtpQuestEngine.isActive(sp, pPlayer))

	origCompleteQuest(sp, pPlayer)

	if (giveStory) then
		MtpWebTasks.giveStoryReward(pPlayer)
	end
end
