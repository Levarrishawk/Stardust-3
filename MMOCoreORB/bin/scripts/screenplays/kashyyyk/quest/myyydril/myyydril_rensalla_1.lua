--[[
	Return Ren'Salla's Stone  --  ep3_myyydril_rensalla_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_rensalla_1.qst and string/en/quest/ground/ep3_myyydril_rensalla_1.stf.

	THE TASK TREE
		task 0  Wait for Signal  Signal Name finddagger
		        title Return Ren'Salla's Stone
			task 1  Reward  Bank Credits 3000
			        title Reward Issued

	OPEN: no grantQuest call in this arc's java. Refugee only sendSignal finddagger.
	Shared body dressed_myyydril_refugee_f_02 is not given the convo (every refugee copy would speak).

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[78][TIER_2] = 69355. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilRensalla1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilRensalla1ScreenPlay",
	repeatable = false,
	rewardCredits = 3000,
}

registerScreenPlay("myyydrilRensalla1ScreenPlay", true)

function myyydrilRensalla1ScreenPlay:start()
end

function myyydrilRensalla1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilRensalla1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilRensalla1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilRensalla1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilRensalla1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilRensalla1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilRensalla1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_rensalla_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_rensalla_1:task00_journal_entry_title")

	return true
end

function myyydrilRensalla1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_rensalla_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilRensalla1ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilRensalla1ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilRensalla1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end
