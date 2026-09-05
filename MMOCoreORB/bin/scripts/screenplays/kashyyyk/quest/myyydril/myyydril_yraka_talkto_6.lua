--[[
	Doctor Kinesworthy  --  ep3_myyydril_yraka_talkto_6

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_yraka_talkto_6.qst and string/en/quest/ground/ep3_myyydril_yraka_talkto_6.stf.

	THE TASK TREE
		task 1  Wait for Signal  Signal Name talktokines
		        title Doctor Kinesworthy

	Wait for Signal talktokines, raised by Kinesworthy.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[38][TIER_1] = 209. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilYrakaTalkto6ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilYrakaTalkto6ScreenPlay",
	repeatable = false,

}

registerScreenPlay("myyydrilYrakaTalkto6ScreenPlay", true)

function myyydrilYrakaTalkto6ScreenPlay:start()
end

function myyydrilYrakaTalkto6ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilYrakaTalkto6ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilYrakaTalkto6ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilYrakaTalkto6ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilYrakaTalkto6ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilYrakaTalkto6ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilYrakaTalkto6ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_talkto_6:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_talkto_6:task00_journal_entry_title")

	return true
end

function myyydrilYrakaTalkto6ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_yraka_talkto_6")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

end

function myyydrilYrakaTalkto6ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilYrakaTalkto6ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilYrakaTalkto6ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end
