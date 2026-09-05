--[[
	Myyydril Trust - Chief Kallaarac  --  ep3_myyydril_kivvaaa_talkto_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_kivvaaa_talkto_1.qst and string/en/quest/ground/ep3_myyydril_kivvaaa_talkto_1.stf.

	THE TASK TREE
		task 2  Wait for Signal  Signal Name talktokallaarac
		        title Myyydril Trust - Chief Kallaarac

	Wait for Signal talktokallaarac, raised by Kallaarac's grant of talkto_2.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[37][TIER_1] = 204. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilKivvaaaTalkto1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilKivvaaaTalkto1ScreenPlay",
	repeatable = false,

}

registerScreenPlay("myyydrilKivvaaaTalkto1ScreenPlay", true)

function myyydrilKivvaaaTalkto1ScreenPlay:start()
end

function myyydrilKivvaaaTalkto1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilKivvaaaTalkto1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilKivvaaaTalkto1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilKivvaaaTalkto1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilKivvaaaTalkto1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilKivvaaaTalkto1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilKivvaaaTalkto1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kivvaaa_talkto_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kivvaaa_talkto_1:task00_journal_entry_title")

	return true
end

function myyydrilKivvaaaTalkto1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_kivvaaa_talkto_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

end

function myyydrilKivvaaaTalkto1ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilKivvaaaTalkto1ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilKivvaaaTalkto1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end
