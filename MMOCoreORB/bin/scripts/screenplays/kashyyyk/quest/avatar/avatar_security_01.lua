--[[
	Retrieve a Passcard  --  ep3_avatar_security_01

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_avatar_security_01.qst and string/en/quest/ground/ep3_avatar_security_01.stf.

	THE TASK TREE
		task 0  Destroy Multiple and Loot  CreatureType ep3_avatar_blackscale_guard,
		                                   LootItemName "Security Passcard - Section A",
		                                   NumberItemsRequired 1, LootDropPercent 100
		task 1  Wait for Signal            techhalls_unlocked  -- terminal_security01_unlock

	Grant site is theme_park terminal_security01_unlock: using the terminal
	without the passcard grants this quest. Swiping with the loot flag raises
	techhalls_unlocked (and opens techhall06/04/01 -- dungeon doors).

	OPEN: ep3_avatar_blackscale_guard has no repo template and no lair-header
	mapping (no look-alikes). "Security Passcard - Section A" has no object
	template; tracked as a loot flag (glyph_hunt / varactyl_hunt shape).
	signalLootedPasscard is the honest raise for the flag.

	NO JOURNAL: the journal engine is not in this tree. The client already
	ships quest/ep3_avatar_security_01.qst. Do not call the journal API.

	XP: quest_experience[85][TIER_3] = 123376. See avatar_quest_xp.lua.
]]

avatarSecurity01ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "avatarSecurity01ScreenPlay",
	repeatable = true,
	lootDropPercent = 100,
	killTemplates = {
		-- OPEN: ep3_avatar_blackscale_guard
	},
}

registerScreenPlay("avatarSecurity01ScreenPlay", true)

function avatarSecurity01ScreenPlay:start()
end

function avatarSecurity01ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function avatarSecurity01ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function avatarSecurity01ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function avatarSecurity01ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function avatarSecurity01ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "passcard")
	self:setStage(pPlayer, 0)
end

function avatarSecurity01ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_security_01:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_security_01:task00_journal_entry_title")

	return true
end

function avatarSecurity01ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function avatarSecurity01ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "avatarSecurity01ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function avatarSecurity01ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "avatarSecurity01ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function avatarSecurity01ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 1) then
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

	self:signalLootedPasscard(pPlayer)

	return 0
end

function avatarSecurity01ScreenPlay:signalLootedPasscard(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "passcard", "1")
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_security_01:task01_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_security_01:task01_journal_entry_description")

	return true
end

function avatarSecurity01ScreenPlay:hasPasscard(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "passcard")) == 1
end

-- Raised by terminal_security01_unlock under the SOE name techhalls_unlocked.
function avatarSecurity01ScreenPlay:signalTechhallsUnlocked(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	KashyyykAvatarQuestXp:award(pPlayer, "ep3_avatar_security_01")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

	return true
end
