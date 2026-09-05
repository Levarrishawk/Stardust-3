--[[
	ep3_trando_mosolium_zssik_07  --  ep3_trando_mosolium_zssik_07

	ruling 2026-09-04

	THE TASK TREE
		task 6  Wait for Signal  Breach Bunker Defenses / trandoBunkerEntryBreach
		task 7  Destroy Multiple and Loot  Kill Captain Beshk / ep3_qst_blackscale_captain_beshk
		task 8  Wait for Signal  Turn off the Power / trandoPowerFlipped
		task 9  Retrieve Item  Retrieve the Avatar Access Codes / 
		task 10  Wait for Signal  Return to Mosolium / rewardMosolium02

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	OPEN:
		no grantQuest for ep3_trando_mosolium_zssik_07 in this arc's conversation java
		trandoBunkerEntryBreach / trandoPowerFlipped raise sites are dungeon scripts, not this fence
		ep3_qst_blackscale_captain_beshk has no lair map
		computer_console.iff exists but the bunker command-center origin is not a surface buildout row; not spawned
		ep3_trando_mosolium_zssik_07: ep3_qst_blackscale_captain_beshk -- no lair map
	XP: quest_experience[84][TIER_5] = 185229.
]]

trandoMosoliumZssik07ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoMosoliumZssik07ScreenPlay",
	repeatable = true,
	turnInStage = 3,
}
registerScreenPlay("trandoMosoliumZssik07ScreenPlay", true)

function trandoMosoliumZssik07ScreenPlay:start()
end

function trandoMosoliumZssik07ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoMosoliumZssik07ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoMosoliumZssik07ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoMosoliumZssik07ScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoMosoliumZssik07ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoMosoliumZssik07ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function trandoMosoliumZssik07ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_mosolium_zssik_07:journal_entry_title")
	return true
end

function trandoMosoliumZssik07ScreenPlay:attachKillObserver(pPlayer)
end

function trandoMosoliumZssik07ScreenPlay:detachKillObserver(pPlayer)
end

function trandoMosoliumZssik07ScreenPlay:signalTrandoBunkerEntryBreach(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	if (1 == 3) then
		KashyyykQuestXp:award(pPlayer, "ep3_trando_mosolium_zssik_07")
		writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
		self:clearQuest(pPlayer)
	else
		self:setStage(pPlayer, 2)
	end

	return true
end

function trandoMosoliumZssik07ScreenPlay:signalTrandoPowerFlipped(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	if (2 == 3) then
		KashyyykQuestXp:award(pPlayer, "ep3_trando_mosolium_zssik_07")
		writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
		self:clearQuest(pPlayer)
	else
		self:setStage(pPlayer, 3)
	end

	return true
end

function trandoMosoliumZssik07ScreenPlay:signalRewardMosolium02(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	if (3 == 3) then
		KashyyykQuestXp:award(pPlayer, "ep3_trando_mosolium_zssik_07")
		writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
		self:clearQuest(pPlayer)
	else
		self:setStage(pPlayer, 4)
	end

	return true
end
