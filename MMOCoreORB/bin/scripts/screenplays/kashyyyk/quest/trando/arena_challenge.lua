--[[
	The Arena Challenge  --  ep3_arena_challenge

	ruling 2026-09-04

	THE TASK TREE
		task 0  Wait for Signal    signalArenaChallengeAccepted

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	OPEN:
		Grant site is conversation/ep3_forest_kerritamba (forest epic). Not transcribed here.
		Dungeon send on the outer guard is OPEN.
]]

arenaChallengeScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "arenaChallengeScreenPlay",
	repeatable = true,
	turnInStage = 1,
}


registerScreenPlay("arenaChallengeScreenPlay", true)

function arenaChallengeScreenPlay:start()
end

function arenaChallengeScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function arenaChallengeScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function arenaChallengeScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function arenaChallengeScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function arenaChallengeScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function arenaChallengeScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function arenaChallengeScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_arena_challenge:journal_entry_title")
	return true
end

function arenaChallengeScreenPlay:signalArenaChallengeAccepted(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_arena_challenge")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)
	return true
end
