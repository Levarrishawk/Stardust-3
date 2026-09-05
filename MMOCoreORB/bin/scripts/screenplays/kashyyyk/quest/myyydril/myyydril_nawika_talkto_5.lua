--[[
	Return to Chief Kallaarac  --  ep3_myyydril_nawika_talkto_5

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_nawika_talkto_5.qst and string/en/quest/ground/ep3_myyydril_nawika_talkto_5.stf.

	THE TASK TREE
		task 1  Wait for Signal  Signal Name talktochief
		        title Myyydril Trust - Return to Chief Kallaarac

	Wait for Signal talktochief, raised by Kallaarac.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[78][TIER_1] = 424. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilNawikaTalkto5ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilNawikaTalkto5ScreenPlay",
	repeatable = false,

}

registerScreenPlay("myyydrilNawikaTalkto5ScreenPlay", true)

function myyydrilNawikaTalkto5ScreenPlay:start()
end

function myyydrilNawikaTalkto5ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilNawikaTalkto5ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilNawikaTalkto5ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilNawikaTalkto5ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilNawikaTalkto5ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilNawikaTalkto5ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilNawikaTalkto5ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_nawika_talkto_5:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_nawika_talkto_5:task00_journal_entry_title")

	return true
end

function myyydrilNawikaTalkto5ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_nawika_talkto_5")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

end

function myyydrilNawikaTalkto5ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilNawikaTalkto5ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilNawikaTalkto5ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end
