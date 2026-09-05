--[[
	Meatlump hideout-access task engine.

	ruling 2026-09-04

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client
	ships the strings but NOT the .qst; the journal row comes from the
	integration branch later. Do not call the journal module.

	Task types: wait_for_signal, destroy_multi, retrieve_item, wait_for_tasks,
	show_message_box, complete_quest, wave_event_player, nothing, clear_quest.
]]

MtpQuestEngine = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MtpQuestEngine",
	TIER_LEVEL = 82, -- OURS-pending (Pre-CU has no CL 82/90)
	-- OURS appearance: object/custom_content/tangible/loot/creature_loot/collections/eow_meatlump_lump.lua
	-- (client shared_eow_meatlump_lump.iff). SOURCED count is questlist QUEST_REWARD_LOOT_COUNT.
	-- Shipped static item_meatlump_lump_01_01 (master_item.tab:5620) uses
	-- object/tangible/loot/dungeon/meatlump/meatlump_lump.iff, which is absent from the client.
	LUMP_TEMPLATE = "object/tangible/loot/creature/loot/collections/eow_meatlump_lump.iff",
	-- Core3 has no quest_combat / quest_general. Unknown types cap at 2000 once
	-- (PlayerObjectImplementation.cpp:740-753). combat_general is the Mustafar
	-- substitution (mustafar_quest_xp.lua).
	XP_TYPE = "combat_general",
}

MtpQuestEngine.quests = {}

registerScreenPlay("MtpQuestEngine", false)

function MtpQuestEngine.install(sp)
	MtpQuestEngine.quests[sp.questName] = sp

	if (sp.TIER_LEVEL == nil) then
		sp.TIER_LEVEL = MtpQuestEngine.TIER_LEVEL
	end

	registerScreenPlay(sp.screenplayName, true)

	function sp:start()
	end

	function sp:getState(pPlayer)
		return MtpQuestEngine.getState(self, pPlayer)
	end

	function sp:setState(pPlayer, value)
		MtpQuestEngine.setState(self, pPlayer, value)
	end

	function sp:getRuns(pPlayer)
		return MtpQuestEngine.getRuns(self, pPlayer)
	end

	function sp:isActive(pPlayer)
		return MtpQuestEngine.isActive(self, pPlayer)
	end

	function sp:hasCompleted(pPlayer)
		return MtpQuestEngine.hasCompleted(self, pPlayer)
	end

	function sp:isTaskActive(pPlayer, taskName)
		return MtpQuestEngine.isTaskActive(self, pPlayer, taskName)
	end

	function sp:hasCompletedTask(pPlayer, taskName)
		return MtpQuestEngine.hasCompletedTask(self, pPlayer, taskName)
	end

	function sp:canGrantQuest(pPlayer)
		return MtpQuestEngine.canGrantQuest(self, pPlayer)
	end

	function sp:grantQuest(pPlayer)
		return MtpQuestEngine.grantQuest(self, pPlayer)
	end

	function sp:clearQuest(pPlayer)
		return MtpQuestEngine.clearQuest(self, pPlayer)
	end

	function sp:sendSignal(pPlayer, signalName)
		return MtpQuestEngine.sendSignal(self, pPlayer, signalName)
	end

	function sp:notifyKilledCreature(pPlayer, pVictim)
		return MtpQuestEngine.notifyKilledCreature(self, pPlayer, pVictim)
	end

	function sp:notifyMessageBox(pPlayer, pSui, eventIndex, args)
		return MtpQuestEngine.notifyMessageBox(self, pPlayer, pSui, eventIndex, args)
	end

	function sp:notifyWaveSpawn(pPlayer)
		return MtpQuestEngine.notifyWaveSpawn(self, pPlayer)
	end
end

function MtpQuestEngine.read(sp, pPlayer, key)
	if (sp == nil or pPlayer == nil) then
		return nil
	end

	return readScreenPlayData(pPlayer, sp.screenplayName, key)
end

function MtpQuestEngine.write(sp, pPlayer, key, value)
	writeScreenPlayData(pPlayer, sp.screenplayName, key, tostring(value))
end

function MtpQuestEngine.delete(sp, pPlayer, key)
	deleteScreenPlayData(pPlayer, sp.screenplayName, key)
end

function MtpQuestEngine.getRuns(sp, pPlayer)
	if (sp == nil or pPlayer == nil) then
		return 0
	end

	return tonumber(MtpQuestEngine.read(sp, pPlayer, "runs")) or 0
end

function MtpQuestEngine.isActive(sp, pPlayer)
	if (sp == nil or pPlayer == nil) then
		return false
	end

	return MtpQuestEngine.read(sp, pPlayer, "state") == "active"
end

function MtpQuestEngine.hasCompleted(sp, pPlayer)
	return MtpQuestEngine.getRuns(sp, pPlayer) > 0
end

function MtpQuestEngine.splitList(s)
	local out = {}

	if (s == nil or s == "") then
		return out
	end

	for part in string.gmatch(s, "[^,]+") do
		local n = tonumber(part)

		if (n ~= nil) then
			out[#out + 1] = n
		end
	end

	return out
end

function MtpQuestEngine.joinList(list)
	local s = ""

	for i = 1, #list do
		if (i > 1) then
			s = s .. ","
		end

		s = s .. tostring(list[i])
	end

	return s
end

function MtpQuestEngine.hasId(list, id)
	for i = 1, #list do
		if (list[i] == id) then
			return true
		end
	end

	return false
end

function MtpQuestEngine.getActive(sp, pPlayer)
	return MtpQuestEngine.splitList(MtpQuestEngine.read(sp, pPlayer, "active"))
end

function MtpQuestEngine.getDone(sp, pPlayer)
	return MtpQuestEngine.splitList(MtpQuestEngine.read(sp, pPlayer, "done"))
end

function MtpQuestEngine.setActive(sp, pPlayer, list)
	MtpQuestEngine.write(sp, pPlayer, "active", MtpQuestEngine.joinList(list))
end

function MtpQuestEngine.setDone(sp, pPlayer, list)
	MtpQuestEngine.write(sp, pPlayer, "done", MtpQuestEngine.joinList(list))
end

function MtpQuestEngine.findTask(sp, taskName)
	if (sp == nil or sp.tasks == nil) then
		return nil
	end

	for i = 1, #sp.tasks do
		if (sp.tasks[i].name == taskName) then
			return sp.tasks[i]
		end
	end

	return nil
end

function MtpQuestEngine.isTaskActive(sp, pPlayer, taskName)
	if (sp == nil or pPlayer == nil) then
		return false
	end

	if (not MtpQuestEngine.isActive(sp, pPlayer)) then
		return false
	end

	local task = MtpQuestEngine.findTask(sp, taskName)

	if (task == nil) then
		return false
	end

	return MtpQuestEngine.hasId(MtpQuestEngine.getActive(sp, pPlayer), task.id)
end

function MtpQuestEngine.hasCompletedTask(sp, pPlayer, taskName)
	if (sp == nil or pPlayer == nil) then
		return false
	end

	local task = MtpQuestEngine.findTask(sp, taskName)

	if (task == nil) then
		return false
	end

	if (MtpQuestEngine.hasId(MtpQuestEngine.getDone(sp, pPlayer), task.id)) then
		return true
	end

	return MtpQuestEngine.hasCompleted(sp, pPlayer)
end

function MtpQuestEngine.canGrantQuest(sp, pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (MtpQuestEngine.isActive(sp, pPlayer)) then
		return false
	end

	return sp.repeatable or MtpQuestEngine.getRuns(sp, pPlayer) == 0
end

function MtpQuestEngine.playerLevel(pPlayer)
	if (pPlayer == nil) then
		return 0
	end

	return CreatureObject(pPlayer):getLevel()
end

function MtpQuestEngine.tierGrant(pPlayer, lowName, highName)
	if (MtpQuestEngine.playerLevel(pPlayer) >= MtpQuestEngine.TIER_LEVEL) then
		return MtpQuestEngine.grantByName(pPlayer, highName)
	end

	return MtpQuestEngine.grantByName(pPlayer, lowName)
end

function MtpQuestEngine.byName(name)
	return MtpQuestEngine.quests[name]
end

function MtpQuestEngine.grantByName(pPlayer, name)
	local sp = MtpQuestEngine.byName(name)

	if (sp == nil) then
		return false
	end

	return MtpQuestEngine.grantQuest(sp, pPlayer)
end

function MtpQuestEngine.isQuestActive(pPlayer, name)
	local sp = MtpQuestEngine.byName(name)

	if (sp == nil) then
		return false
	end

	return MtpQuestEngine.isActive(sp, pPlayer)
end

function MtpQuestEngine.isQuestComplete(pPlayer, name)
	local sp = MtpQuestEngine.byName(name)

	if (sp == nil) then
		return false
	end

	return MtpQuestEngine.hasCompleted(sp, pPlayer)
end

function MtpQuestEngine.isQuestActiveOrComplete(pPlayer, name)
	return MtpQuestEngine.isQuestActive(pPlayer, name) or MtpQuestEngine.isQuestComplete(pPlayer, name)
end

function MtpQuestEngine.grantQuest(sp, pPlayer)
	if (not MtpQuestEngine.canGrantQuest(sp, pPlayer)) then
		return false
	end

	MtpQuestEngine.clearQuest(sp, pPlayer)
	MtpQuestEngine.write(sp, pPlayer, "state", "active")
	MtpQuestEngine.setActive(sp, pPlayer, {})
	MtpQuestEngine.setDone(sp, pPlayer, {})

	if (sp.tasks[1].title ~= nil and sp.tasks[1].title ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(sp.tasks[1].title)
	elseif (sp.tasks[1].type == "nothing") then
		-- invisible root
	end

	MtpQuestEngine.activateTask(sp, pPlayer, 0)

	return true
end

function MtpQuestEngine.clearQuest(sp, pPlayer)
	if (pPlayer == nil) then
		return
	end

	MtpQuestEngine.detachKillObserver(sp, pPlayer)
	MtpQuestEngine.despawnAll(sp, pPlayer)
	MtpQuestEngine.delete(sp, pPlayer, "active")
	MtpQuestEngine.delete(sp, pPlayer, "done")
	MtpQuestEngine.delete(sp, pPlayer, "state")
	MtpQuestEngine.delete(sp, pPlayer, "waveTask")
	MtpQuestEngine.delete(sp, pPlayer, "boxTask")

	for i = 1, #sp.tasks do
		MtpQuestEngine.delete(sp, pPlayer, "kills_" .. tostring(i - 1))
		MtpQuestEngine.delete(sp, pPlayer, "got_" .. tostring(i - 1))
	end
end

function MtpQuestEngine.completeQuest(sp, pPlayer)
	if (pPlayer == nil or not MtpQuestEngine.isActive(sp, pPlayer)) then
		return
	end

	if ((sp.rewardCredits or 0) > 0) then
		CreatureObject(pPlayer):addBankCredits(sp.rewardCredits, true)
	end

	if ((sp.rewardXp or 0) > 0) then
		CreatureObject(pPlayer):awardExperience(MtpQuestEngine.XP_TYPE, sp.rewardXp, true)
	end

	MtpQuestEngine.grantLumps(pPlayer, sp.lumpCount or 0)

	MtpQuestEngine.write(sp, pPlayer, "runs", tostring(MtpQuestEngine.getRuns(sp, pPlayer) + 1))
	MtpQuestEngine.clearQuest(sp, pPlayer)
end

function MtpQuestEngine.grantLumps(pPlayer, count)
	if (pPlayer == nil or count == nil or count <= 0) then
		return
	end

	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return
	end

	for i = 1, count do
		giveItem(pInventory, MtpQuestEngine.LUMP_TEMPLATE, -1)
	end
end

function MtpQuestEngine.walkTemplateCount(pContainer, template)
	if (pContainer == nil) then
		return 0
	end

	local n = 0
	local size = SceneObject(pContainer):getContainerObjectsSize()

	if (size == nil) then
		return 0
	end

	for i = 0, size - 1 do
		local pObj = SceneObject(pContainer):getContainerObject(i)

		if (pObj ~= nil) then
			if (SceneObject(pObj):getTemplateObjectPath() == template) then
				n = n + 1
			end

			n = n + MtpQuestEngine.walkTemplateCount(pObj, template)
		end
	end

	return n
end

function MtpQuestEngine.countTemplate(pPlayer, template)
	if (pPlayer == nil or template == nil or template == "") then
		return 0
	end

	local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")

	return MtpQuestEngine.walkTemplateCount(pInv, template)
end

function MtpQuestEngine.removeTemplate(pPlayer, template, count)
	if (pPlayer == nil or template == nil or template == "" or count == nil or count <= 0) then
		return false
	end

	local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInv == nil) then
		return false
	end

	for i = 1, count do
		local pObj = getContainerObjectByTemplate(pInv, template, true)

		if (pObj == nil) then
			return false
		end

		SceneObject(pObj):destroyObjectFromWorld()
		SceneObject(pObj):destroyObjectFromDatabase()
	end

	return true
end

function MtpQuestEngine.activateTask(sp, pPlayer, id)
	if (MtpQuestEngine.hasId(MtpQuestEngine.getDone(sp, pPlayer), id)) then
		return
	end

	local active = MtpQuestEngine.getActive(sp, pPlayer)

	if (not MtpQuestEngine.hasId(active, id)) then
		active[#active + 1] = id
		MtpQuestEngine.setActive(sp, pPlayer, active)
	end

	local task = sp.tasks[id + 1]

	if (task == nil) then
		return
	end

	if (task.title ~= nil and task.title ~= "" and task.visible) then
		CreatureObject(pPlayer):sendSystemMessage(task.title)
	end

	if (task.description ~= nil and task.description ~= "" and task.visible) then
		CreatureObject(pPlayer):sendSystemMessage(task.description)
	end

	if (task.type == "nothing") then
		MtpQuestEngine.finishTask(sp, pPlayer, id)
	elseif (task.type == "complete_quest") then
		MtpQuestEngine.finishTask(sp, pPlayer, id)
		MtpQuestEngine.completeQuest(sp, pPlayer)
	elseif (task.type == "clear_quest") then
		MtpQuestEngine.clearQuest(sp, pPlayer)
	elseif (task.type == "show_message_box") then
		MtpQuestEngine.showBox(sp, pPlayer, task)
	elseif (task.type == "retrieve_item") then
		MtpQuestEngine.spawnRetrieve(sp, pPlayer, task)
	elseif (task.type == "destroy_multi") then
		MtpQuestEngine.spawnDestroy(sp, pPlayer, task)
		MtpQuestEngine.attachKillObserver(sp, pPlayer)
	elseif (task.type == "wave_event_player") then
		MtpQuestEngine.write(sp, pPlayer, "waveTask", tostring(id))

		local delay = task.waveDelay or 0

		if (task.startMessage ~= nil and task.startMessage ~= "") then
			CreatureObject(pPlayer):sendSystemMessage(task.startMessage)
		end

		if (delay <= 0) then
			MtpQuestEngine.notifyWaveSpawn(sp, pPlayer)
		else
			createEvent(delay * 1000, sp.screenplayName, "notifyWaveSpawn", pPlayer, "")
		end
	elseif (task.type == "wait_for_tasks") then
		MtpQuestEngine.checkWaitForTasks(sp, pPlayer, task)
	end
end

function MtpQuestEngine.finishTask(sp, pPlayer, id)
	if (not MtpQuestEngine.isActive(sp, pPlayer)) then
		return
	end

	if (MtpQuestEngine.hasId(MtpQuestEngine.getDone(sp, pPlayer), id)) then
		return
	end

	local task = sp.tasks[id + 1]
	local active = MtpQuestEngine.getActive(sp, pPlayer)
	local nextActive = {}

	for i = 1, #active do
		if (active[i] ~= id) then
			nextActive[#nextActive + 1] = active[i]
		end
	end

	MtpQuestEngine.setActive(sp, pPlayer, nextActive)

	local done = MtpQuestEngine.getDone(sp, pPlayer)
	done[#done + 1] = id
	MtpQuestEngine.setDone(sp, pPlayer, done)

	-- Wave NPCs stay until the conversation despawns them (SOE makeNpcDisappear).
	if (task == nil or task.type ~= "wave_event_player") then
		MtpQuestEngine.despawnTask(sp, pPlayer, id)
	end

	if (task ~= nil and task.type == "destroy_multi") then
		MtpQuestEngine.maybeDetachKill(sp, pPlayer)
	end

	if (task ~= nil) then
		for i = 1, #task.onComplete do
			MtpQuestEngine.activateTask(sp, pPlayer, task.onComplete[i])
		end
	end

	MtpQuestEngine.checkAllWaitForTasks(sp, pPlayer)

	if (task ~= nil and #task.onComplete == 0 and task.type ~= "complete_quest" and task.type ~= "clear_quest" and task.type ~= "nothing") then
		-- Terminal wait_for_signal with no successor: complete the quest.
		local hasCompleteTask = false

		for i = 1, #sp.tasks do
			if (sp.tasks[i].type == "complete_quest") then
				hasCompleteTask = true
			end
		end

		if (not hasCompleteTask) then
			MtpQuestEngine.completeQuest(sp, pPlayer)
		end
	end
end

function MtpQuestEngine.sendSignal(sp, pPlayer, signalName)
	if (pPlayer == nil or not MtpQuestEngine.isActive(sp, pPlayer)) then
		return false
	end

	local active = MtpQuestEngine.getActive(sp, pPlayer)
	local hit = false

	for i = 1, #active do
		local task = sp.tasks[active[i] + 1]

		if (task ~= nil and task.type == "wait_for_signal" and task.signal == signalName) then
			MtpQuestEngine.finishTask(sp, pPlayer, active[i])
			hit = true
		end
	end

	return hit
end

function MtpQuestEngine.sendSignalAny(pPlayer, signalName)
	local hit = false

	for _, sp in pairs(MtpQuestEngine.quests) do
		if (MtpQuestEngine.sendSignal(sp, pPlayer, signalName)) then
			hit = true
		end
	end

	return hit
end

function MtpQuestEngine.checkWaitForTasks(sp, pPlayer, task)
	if (task.watches == nil or #task.watches == 0) then
		return
	end

	for i = 1, #task.watches do
		if (not MtpQuestEngine.hasCompletedTask(sp, pPlayer, task.watches[i])) then
			return
		end
	end

	MtpQuestEngine.finishTask(sp, pPlayer, task.id)
end

function MtpQuestEngine.checkAllWaitForTasks(sp, pPlayer)
	local active = MtpQuestEngine.getActive(sp, pPlayer)

	for i = 1, #active do
		local task = sp.tasks[active[i] + 1]

		if (task ~= nil and task.type == "wait_for_tasks") then
			MtpQuestEngine.checkWaitForTasks(sp, pPlayer, task)
		end
	end
end

function MtpQuestEngine.showBox(sp, pPlayer, task)
	MtpQuestEngine.write(sp, pPlayer, "boxTask", tostring(task.id))

	local sui = SuiMessageBox.new(sp.screenplayName, "notifyMessageBox")
	sui.setTitle(task.boxTitle or "")
	sui.setPrompt(task.boxText or "")
	sui.hideCancelButton()
	sui.sendTo(pPlayer)
end

function MtpQuestEngine.notifyMessageBox(sp, pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local id = tonumber(MtpQuestEngine.read(sp, pPlayer, "boxTask"))

	MtpQuestEngine.delete(sp, pPlayer, "boxTask")

	if (id == nil) then
		return
	end

	MtpQuestEngine.finishTask(sp, pPlayer, id)
end

function MtpQuestEngine.floorZ(planet, x, y, z)
	local wz = getWorldFloor(x, y, planet)

	if (wz == nil or wz == 0) then
		return z
	end

	return wz
end

function MtpQuestEngine.storeSpawn(sp, pPlayer, taskId, oid)
	local key = "spawn_" .. tostring(taskId)
	local cur = MtpQuestEngine.read(sp, pPlayer, key)

	if (cur == nil or cur == "") then
		MtpQuestEngine.write(sp, pPlayer, key, tostring(oid))
	else
		MtpQuestEngine.write(sp, pPlayer, key, cur .. "," .. tostring(oid))
	end
end

function MtpQuestEngine.spawnRetrieve(sp, pPlayer, task)
	if (task.item == nil or task.item == "" or task.planet == nil or task.planet == "") then
		return
	end

	if (not isZoneEnabled(task.planet)) then
		return
	end

	-- Shared world objects (Kashyyyk survey-data shape). Spawn once; do not despawn on complete.
	local flag = "mtpRetrieve:" .. sp.questName .. ":" .. tostring(task.id)

	if (readData(flag) == 1) then
		return
	end

	writeData(flag, 1)

	local n = task.count or 1

	for i = 1, n do
		local ox = (task.x or 0) + math.cos((i - 1) * 2.2) * 2
		local oy = (task.z or 0) + math.sin((i - 1) * 2.2) * 2
		local oz = MtpQuestEngine.floorZ(task.planet, ox, oy, task.y or 0)
		local pObj = spawnSceneObject(task.planet, task.item, ox, oz, oy, 0, 0)

		if (pObj ~= nil) then
			local oid = SceneObject(pObj):getObjectID()
			writeStringData(oid .. ":mtpQuest", sp.questName)
			writeStringData(oid .. ":mtpTask", tostring(task.id))
			SceneObject(pObj):setObjectMenuComponent("MtpQuestItemMenuComponent")
		end
	end
end

function MtpQuestEngine.spawnDestroy(sp, pPlayer, task)
	if (task.mapped == nil or task.mapped == "" or task.planet == nil or task.planet == "") then
		return
	end

	if (not isZoneEnabled(task.planet)) then
		return
	end

	local n = task.count or 1

	for i = 1, n do
		local ox = (task.x or 0) + math.cos((i - 1) * 1.1) * 4
		local oy = (task.z or 0) + math.sin((i - 1) * 1.1) * 4
		local oz = MtpQuestEngine.floorZ(task.planet, ox, oy, task.y or 0)
		local pMob = spawnMobile(task.planet, task.mapped, 0, ox, oz, oy, 0, 0)

		if (pMob ~= nil) then
			local oid = SceneObject(pMob):getObjectID()
			writeData(oid .. ":mtpQuestKill", 1)
			MtpQuestEngine.storeSpawn(sp, pPlayer, task.id, oid)
		end
	end
end

function MtpQuestEngine.notifyWaveSpawn(sp, pPlayer)
	if (pPlayer == nil or not MtpQuestEngine.isActive(sp, pPlayer)) then
		return
	end

	local id = tonumber(MtpQuestEngine.read(sp, pPlayer, "waveTask"))

	if (id == nil) then
		return
	end

	local task = sp.tasks[id + 1]

	if (task == nil or task.waveMapped == nil or task.waveMapped == "") then
		MtpQuestEngine.finishTask(sp, pPlayer, id)
		return
	end

	local planet = SceneObject(pPlayer):getZoneName()
	local x = SceneObject(pPlayer):getWorldPositionX()
	local y = SceneObject(pPlayer):getWorldPositionY()
	local z = SceneObject(pPlayer):getWorldPositionZ()
	local radius = task.waveRadius or 3
	local pMob = spawnMobile(planet, task.waveMapped, 0, x + radius, z, y, 0, 0)

	if (pMob ~= nil) then
		local oid = SceneObject(pMob):getObjectID()
		writeData(oid .. ":mtpWavePlayer", SceneObject(pPlayer):getObjectID())
		MtpQuestEngine.storeSpawn(sp, pPlayer, id, oid)

		if (task.utterance ~= nil and task.utterance ~= "") then
			spatialChat(pMob, task.utterance)
		end
	end

	MtpQuestEngine.finishTask(sp, pPlayer, id)
end

function MtpQuestEngine.despawnTask(sp, pPlayer, taskId)
	local key = "spawn_" .. tostring(taskId)
	local cur = MtpQuestEngine.read(sp, pPlayer, key)

	if (cur == nil or cur == "") then
		return
	end

	for part in string.gmatch(cur, "[^,]+") do
		local oid = tonumber(part)

		if (oid ~= nil) then
			local pObj = getSceneObject(oid)

			if (pObj ~= nil) then
				SceneObject(pObj):destroyObjectFromWorld()
			end
		end
	end

	MtpQuestEngine.delete(sp, pPlayer, key)
end

function MtpQuestEngine.despawnAll(sp, pPlayer)
	for i = 1, #sp.tasks do
		if (sp.tasks[i].type ~= "wave_event_player") then
			MtpQuestEngine.despawnTask(sp, pPlayer, i - 1)
		end
	end
end

function MtpQuestEngine.attachKillObserver(sp, pPlayer)
	if ((tonumber(MtpQuestEngine.read(sp, pPlayer, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, sp.screenplayName, "notifyKilledCreature", pPlayer)
	MtpQuestEngine.write(sp, pPlayer, "observer", "1")
end

function MtpQuestEngine.detachKillObserver(sp, pPlayer)
	dropObserver(KILLEDCREATURE, sp.screenplayName, "notifyKilledCreature", pPlayer)
	MtpQuestEngine.delete(sp, pPlayer, "observer")
end

function MtpQuestEngine.maybeDetachKill(sp, pPlayer)
	local active = MtpQuestEngine.getActive(sp, pPlayer)

	for i = 1, #active do
		local task = sp.tasks[active[i] + 1]

		if (task ~= nil and task.type == "destroy_multi") then
			return
		end
	end

	MtpQuestEngine.detachKillObserver(sp, pPlayer)
end

function MtpQuestEngine.notifyKilledCreature(sp, pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (not MtpQuestEngine.isActive(sp, pPlayer)) then
		MtpQuestEngine.delete(sp, pPlayer, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil) then
		return 0
	end

	local active = MtpQuestEngine.getActive(sp, pPlayer)

	for i = 1, #active do
		local task = sp.tasks[active[i] + 1]

		if (task ~= nil and task.type == "destroy_multi" and task.mapped == victimTemplate) then
			local key = "kills_" .. tostring(task.id)
			local kills = (tonumber(MtpQuestEngine.read(sp, pPlayer, key)) or 0) + 1
			MtpQuestEngine.write(sp, pPlayer, key, tostring(kills))

			if (task.title ~= nil and task.title ~= "") then
				CreatureObject(pPlayer):sendSystemMessage(task.title)
			end

			if (kills >= (task.count or 1)) then
				MtpQuestEngine.finishTask(sp, pPlayer, task.id)
			end

			return 0
		end
	end

	return 0
end

function MtpQuestEngine.tryCollect(pPlayer, taskId, questName)
	local sp = MtpQuestEngine.byName(questName)

	if (sp == nil or not MtpQuestEngine.isActive(sp, pPlayer)) then
		return false
	end

	if (not MtpQuestEngine.hasId(MtpQuestEngine.getActive(sp, pPlayer), taskId)) then
		return false
	end

	local task = sp.tasks[taskId + 1]

	if (task == nil or task.type ~= "retrieve_item") then
		return false
	end

	local key = "got_" .. tostring(taskId)
	local got = (tonumber(MtpQuestEngine.read(sp, pPlayer, key)) or 0) + 1
	MtpQuestEngine.write(sp, pPlayer, key, tostring(got))

	if (task.itemName ~= nil and task.itemName ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(task.itemName)
	end

	if (got >= (task.count or 1)) then
		MtpQuestEngine.finishTask(sp, pPlayer, taskId)
	end

	return true
end

function MtpQuestEngine.clearRunScopedState(pPlayer, playerID, spawnOids)
	if (pPlayer ~= nil) then
		if (playerID == nil or playerID == 0) then
			playerID = SceneObject(pPlayer):getObjectID()
		end

		local names = {
			"mtp_hideout_instance_kill_all_droids",
			"mtp_hideout_instance_kill_all_droids_fail",
			"mtp_hideout_instance_kill_all_droids_success",
			"mtp_hideout_instance_kill_specific_droids",
			"mtp_hideout_instance_kill_specific_droids_fail",
			"mtp_hideout_instance_kill_specific_droids_success",
			"mtp_hideout_instance_recover_supplies",
			"mtp_hideout_instance_recover_supplies_fail",
			"mtp_hideout_instance_recover_supplies_success",
			"mtp_hideout_instance_escort_trapped_meatlump",
			"mtp_hideout_instance_escort_trapped_meatlump_fail",
			"mtp_hideout_instance_escort_trapped_meatlump_success",
		}

		for n = 1, #names do
			local sp = MtpQuestEngine.byName(names[n])

			if (sp ~= nil) then
				for i = 1, #sp.tasks do
					MtpQuestEngine.delete(sp, pPlayer, "kills_" .. tostring(i - 1))
					MtpQuestEngine.delete(sp, pPlayer, "got_" .. tostring(i - 1))
				end
			end
		end
	end

	if (playerID ~= nil and playerID ~= 0 and spawnOids ~= nil) then
		for i = 1, #spawnOids do
			if (spawnOids[i] ~= nil and spawnOids[i] ~= 0) then
				deleteData(playerID .. ":mtpGot:" .. tostring(spawnOids[i]))
			end
		end
	end
end

MtpQuestItemMenuComponent = {}

function MtpQuestItemMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local questName = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mtpQuest")
	local taskId = tonumber(readStringData(SceneObject(pSceneObject):getObjectID() .. ":mtpTask"))
	local sp = MtpQuestEngine.byName(questName)

	if (sp == nil or taskId == nil or not MtpQuestEngine.hasId(MtpQuestEngine.getActive(sp, pPlayer), taskId)) then
		return
	end

	local task = sp.tasks[taskId + 1]
	local text = "@collect"

	if (task ~= nil and task.retrieveText ~= nil and task.retrieveText ~= "") then
		text = task.retrieveText
	elseif (task ~= nil and task.title ~= nil and task.title ~= "") then
		text = task.title
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
end

function MtpQuestItemMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local questName = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mtpQuest")
	local taskId = tonumber(readStringData(SceneObject(pSceneObject):getObjectID() .. ":mtpTask"))

	if (taskId ~= nil) then
		local oid = SceneObject(pSceneObject):getObjectID()
		local pflag = SceneObject(pPlayer):getObjectID() .. ":mtpGot:" .. tostring(oid)

		if (readData(pflag) ~= 1) then
			if (MtpQuestEngine.tryCollect(pPlayer, taskId, questName)) then
				writeData(pflag, 1)
			end
		end
	end

	return 0
end
