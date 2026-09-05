--[[
	Collect Items from Avatar  --  ep3_avatar_return

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_avatar_return.qst and string/en/quest/ground/ep3_avatar_return.stf.

	THE TASK TREE
		task 0  Nothing
		task 1  Retrieve Item   object/tangible/quest/avatar_storage_case.iff   (Tube of Greyish Tar)
		task 2  Retrieve Item   object/tangible/quest/avatar_warm_storage.iff   (Vial of Smoke)
		task 3  Retrieve Item   object/tangible/quest/avatar_foot_locker.iff    (Baggy of Green Powder)
		task 4  Retrieve Item   object/tangible/quest/avatar_cold_storage.iff   (Case of Unmarked Bottles)
		task 5  Retrieve Item   object/tangible/quest/avatar_locker_sr71.iff    (Unlabled Sack)
		task 6  Wait for Tasks  all five retrieve tasks
		task 7  Wait for Signal rewardValmont  -- Valmont conversation turn-in
		task 8  Reward          Bank Credits 10000

	All five iff templates are in the repo. Spawn rows are the dungeon object
	rows of ep3_avatar_platform.tab. Not spawned here.

	OPEN: grant gate hasCompletedQuest(ep3_trando_hssissk_zssik_10) is
	defined by the arc that owns ep3_trando_hssissk_zssik_10; guarded when that screenplay is absent.

	Giver ep3_marium_valmont already stands via kashyyyk_static_npcs.lua.
	conversationTemplate was empty; attached here.

	NO JOURNAL: the journal engine is not in this tree. The client already
	ships quest/ep3_avatar_return.qst. Do not call the journal API.

	XP: LEVEL 85 TIER -1 passthrough of stored 1000. See avatar_quest_xp.lua.
]]

avatarReturnScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "avatarReturnScreenPlay",
	repeatable = true,
	rewardCredits = 10000,
	devices = {
		{ template = "object/tangible/quest/avatar_storage_case.iff", key = "d1", title = "@quest/ground/ep3_avatar_return:task01_journal_entry_title" },
		{ template = "object/tangible/quest/avatar_warm_storage.iff",  key = "d2", title = "@quest/ground/ep3_avatar_return:task02_journal_entry_title" },
		{ template = "object/tangible/quest/avatar_foot_locker.iff",   key = "d3", title = "@quest/ground/ep3_avatar_return:task03_journal_entry_title" },
		{ template = "object/tangible/quest/avatar_cold_storage.iff",  key = "d4", title = "@quest/ground/ep3_avatar_return:task04_journal_entry_title" },
		{ template = "object/tangible/quest/avatar_locker_sr71.iff",   key = "d5", title = "@quest/ground/ep3_avatar_return:task05_journal_entry_title" },
	},
}

registerScreenPlay("avatarReturnScreenPlay", true)

function avatarReturnScreenPlay:start()
end

function avatarReturnScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function avatarReturnScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function avatarReturnScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function avatarReturnScreenPlay:hasDevice(pPlayer, key)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) == 1
end

function avatarReturnScreenPlay:deviceCount(pPlayer)
	local n = 0

	for i = 1, #self.devices do
		if (self:hasDevice(pPlayer, self.devices[i].key)) then
			n = n + 1
		end
	end

	return n
end

-- defined by the arc that owns ep3_trando_hssissk_zssik_10; guarded when that screenplay is absent
function avatarReturnScreenPlay:hasDestroyedAvatar(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	if (trandoHssisskZssik10ScreenPlay == nil) then
		return false
	end

	return (tonumber(readScreenPlayData(pPlayer, "trandoHssisskZssik10ScreenPlay", "runs")) or 0) > 0
end

function avatarReturnScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	if (not self:hasDestroyedAvatar(pPlayer)) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function avatarReturnScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	for i = 1, #self.devices do
		deleteScreenPlayData(pPlayer, self.screenplayName, self.devices[i].key)
	end

	self:setStage(pPlayer, 0)
end

function avatarReturnScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_return:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_return:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_return:task06_journal_entry_title")

	return true
end

function avatarReturnScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	KashyyykAvatarQuestXp:award(pPlayer, "ep3_avatar_return")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

	return true
end

function avatarReturnScreenPlay:getRadialText(pPlayer, key)
	if (self:getStage(pPlayer) ~= 1 or key == nil or key == "") then
		return nil
	end

	for i = 1, #self.devices do
		if (self.devices[i].key == key and not self:hasDevice(pPlayer, key)) then
			return self.devices[i].title
		end
	end

	return nil
end

function avatarReturnScreenPlay:collectDevice(pPlayer, key)
	if (self:getRadialText(pPlayer, key) == nil) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_return:task06_journal_entry_title")

	if (self:deviceCount(pPlayer) >= #self.devices) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):playMusicMessage("sound/music_themequest_acc_criminal.snd")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_return:task07_journal_entry_title")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_return:task07_journal_entry_description")
	end

	return true
end

KashAvatarReturnMenuComponent = {}

function KashAvatarReturnMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashAvatarReturn")
	local text = avatarReturnScreenPlay:getRadialText(pPlayer, key)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function KashAvatarReturnMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashAvatarReturn")

	avatarReturnScreenPlay:collectDevice(pPlayer, key)

	return 0
end
