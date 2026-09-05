--[[
	Gain Security Passkey  --  ep3_avatar_techhall08

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_avatar_techhall08.qst and string/en/quest/ground/ep3_avatar_techhall08.stf.

	THE TASK TREE
		task 0  Destroy Multiple and Loot  CreatureType ep3_avatar_blackscale_jailer,
		                                   LootItemName "Jailer ID Passcard",
		                                   NumberItemsRequired 1, LootDropPercent 100
		task 1  Wait for Signal            techhall08_unlocked  -- terminal_techhall08_unlock

	Grant site is theme_park terminal_techhall08_unlock: using the terminal
	without the passcard grants this quest. Swiping with the loot flag raises
	techhall08_unlocked (and opens the "room" cell -- dungeon doors).

	OPEN: ep3_avatar_blackscale_jailer has no repo template and no lair-header
	mapping (no look-alikes). "Jailer ID Passcard" has no object template;
	tracked as a loot flag. signalLootedPasscard is the honest raise for the flag.

	NO JOURNAL: the journal engine is not in this tree. The client already
	ships quest/ep3_avatar_techhall08.qst. Do not call the journal API.

	XP: quest_experience[85][TIER_4] = 157647. See avatar_quest_xp.lua.
]]

avatarTechhall08ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "avatarTechhall08ScreenPlay",
	repeatable = true,
	lootDropPercent = 100,
	killTemplates = {
		-- OPEN: ep3_avatar_blackscale_jailer
	},
}

registerScreenPlay("avatarTechhall08ScreenPlay", true)

function avatarTechhall08ScreenPlay:start()
end

function avatarTechhall08ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function avatarTechhall08ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function avatarTechhall08ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function avatarTechhall08ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function avatarTechhall08ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "passcard")
	self:setStage(pPlayer, 0)
end

function avatarTechhall08ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_techhall08:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_techhall08:task00_journal_entry_title")

	return true
end

function avatarTechhall08ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function avatarTechhall08ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "avatarTechhall08ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function avatarTechhall08ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "avatarTechhall08ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function avatarTechhall08ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

function avatarTechhall08ScreenPlay:signalLootedPasscard(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "passcard", "1")
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_techhall08:task01_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_techhall08:task01_journal_entry_description")

	return true
end

function avatarTechhall08ScreenPlay:hasPasscard(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "passcard")) == 1
end

-- Raised by terminal_techhall08_unlock under the SOE name techhall08_unlocked.
function avatarTechhall08ScreenPlay:signalTechhall08Unlocked(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	KashyyykAvatarQuestXp:award(pPlayer, "ep3_avatar_techhall08")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

	return true
end
