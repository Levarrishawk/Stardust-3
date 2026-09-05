--[[
	The Creation  --  ep3_myyydril_lorn_talkto

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_lorn_talkto.qst and string/en/quest/ground/ep3_myyydril_lorn_talkto.stf.

	THE TASK TREE
		task 0  Wait for Signal  Signal Name lorn
		        title The Creation

	Wait for Signal lorn, raised by Treun Lorn's conversation.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[80][TIER_1] = 435. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 1.
]]
myyydrilLornTalktoScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilLornTalktoScreenPlay",
	repeatable = true,

}

registerScreenPlay("myyydrilLornTalktoScreenPlay", true)

function myyydrilLornTalktoScreenPlay:start()
end

function myyydrilLornTalktoScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilLornTalktoScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilLornTalktoScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilLornTalktoScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilLornTalktoScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilLornTalktoScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilLornTalktoScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_lorn_talkto:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_lorn_talkto:task00_journal_entry_title")

	return true
end

function myyydrilLornTalktoScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_lorn_talkto")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

end

function myyydrilLornTalktoScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilLornTalktoScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilLornTalktoScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end
