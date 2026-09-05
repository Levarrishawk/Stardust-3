--[[
	Self Destruct  --  ep3_avatar_self_destruct

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_avatar_self_destruct.qst and string/en/quest/ground/ep3_avatar_self_destruct.stf.

	THE TASK TREE (nested)
		task 0  Wait for Signal            magneticShieldOff   -- terminal_safety_override
		task 3  Retrieve Item              object/tangible/quest/avatar_safety_01.iff
		task 4  Retrieve Item              object/tangible/quest/avatar_safety_02.iff
		task 5  Wait for Signal            coreOverloaded      -- terminal_core_overload
		task 7  Destroy Multiple and Loot  CreatureType ep3_avatar_blackscale_watch_cmd,
		                                   LootItemName "DESTRUCT CODE: 1 2 3 4 5",
		                                   NumberItemsRequired 1, LootDropPercent 100
		task 6  Wait for Signal            destructSequenceStarted  -- terminal_main_console
		                                   (console also raises avatarDestructSequence, a
		                                   zssik-arc signal, not consumed by this .qst)

	Grant site is theme_park terminal_technical_readout: only while
	ep3_trando_hssissk_zssik_10 task technicalReadout is active. grantQuest is
	exposed here so that terminal can call it. The zssik gate itself is OPEN
	(other arc).

	Both safety iff templates are in the repo. Spawn rows are dungeon object
	rows of ep3_avatar_platform.tab. Menu component is here so the dungeon
	can attach it. Not spawned here.

	OPEN: ep3_avatar_blackscale_watch_cmd has no repo template (no look-alikes).
	"DESTRUCT CODE: 1 2 3 4 5" has no object template; loot flag. The keypad
	passcode on the master console is spawn-table string:passcode=12345.

	NO JOURNAL: the journal engine is not in this tree. The client already
	ships quest/ep3_avatar_self_destruct.qst. Do not call the journal API.

	XP: quest_experience[85][TIER_4] = 157647. See avatar_quest_xp.lua.
]]

avatarSelfDestructScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "avatarSelfDestructScreenPlay",
	repeatable = true,
	lootDropPercent = 100,
	devices = {
		{ template = "object/tangible/quest/avatar_safety_01.iff", key = "s1", title = "@quest/ground/ep3_avatar_self_destruct:task01_journal_entry_title", stage = 2 },
		{ template = "object/tangible/quest/avatar_safety_02.iff", key = "s2", title = "@quest/ground/ep3_avatar_self_destruct:task02_journal_entry_title", stage = 3 },
	},
	killTemplates = {
		-- OPEN: ep3_avatar_blackscale_watch_cmd
	},
}

registerScreenPlay("avatarSelfDestructScreenPlay", true)

function avatarSelfDestructScreenPlay:start()
end

function avatarSelfDestructScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function avatarSelfDestructScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function avatarSelfDestructScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function avatarSelfDestructScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function avatarSelfDestructScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "s1")
	deleteScreenPlayData(pPlayer, self.screenplayName, "s2")
	deleteScreenPlayData(pPlayer, self.screenplayName, "code")
	self:setStage(pPlayer, 0)
end

function avatarSelfDestructScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task00_journal_entry_title")

	return true
end

-- Raised by terminal_safety_override under the SOE name magneticShieldOff.
function avatarSelfDestructScreenPlay:signalMagneticShieldOff(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task01_journal_entry_title")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task01_journal_entry_description")

	return true
end

function avatarSelfDestructScreenPlay:getRadialText(pPlayer, key)
	local stage = self:getStage(pPlayer)

	for i = 1, #self.devices do
		if (self.devices[i].key == key and stage == self.devices[i].stage and tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) ~= 1) then
			return self.devices[i].title
		end
	end

	return nil
end

function avatarSelfDestructScreenPlay:collectDevice(pPlayer, key)
	if (self:getRadialText(pPlayer, key) == nil) then
		return false
	end

	if (key == "s1") then
		writeScreenPlayData(pPlayer, self.screenplayName, "s1", "1")
		self:setStage(pPlayer, 3)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task02_journal_entry_title")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task02_journal_entry_description")
	elseif (key == "s2") then
		writeScreenPlayData(pPlayer, self.screenplayName, "s2", "1")
		self:setStage(pPlayer, 4)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task03_journal_entry_title")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task03_journal_entry_description")
	end

	return true
end

-- Raised by terminal_core_overload under the SOE name coreOverloaded.
function avatarSelfDestructScreenPlay:signalCoreOverloaded(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 4) then
		return false
	end

	self:setStage(pPlayer, 5)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task04_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task04_journal_entry_description")

	return true
end

function avatarSelfDestructScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function avatarSelfDestructScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "avatarSelfDestructScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function avatarSelfDestructScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "avatarSelfDestructScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function avatarSelfDestructScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 5) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil or not self:isKillTemplate(victimTemplate)) then
		return 0
	end

	if (getRandomNumber(100) > self.lootDropPercent) then
		return 0
	end

	self:signalLootedDestructCode(pPlayer)

	return 0
end

function avatarSelfDestructScreenPlay:signalLootedDestructCode(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 5) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "code", "1")
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 6)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task05_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_self_destruct:task05_journal_entry_description")

	return true
end

-- Raised by terminal_main_console under the SOE name destructSequenceStarted.
function avatarSelfDestructScreenPlay:signalDestructSequenceStarted(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 6) then
		return false
	end

	KashyyykAvatarQuestXp:award(pPlayer, "ep3_avatar_self_destruct")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_sucess.snd")
	self:clearQuest(pPlayer)

	return true
end

KashAvatarSelfDestructMenuComponent = {}

function KashAvatarSelfDestructMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashAvatarDestruct")
	local text = avatarSelfDestructScreenPlay:getRadialText(pPlayer, key)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function KashAvatarSelfDestructMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashAvatarDestruct")

	avatarSelfDestructScreenPlay:collectDevice(pPlayer, key)

	return 0
end
