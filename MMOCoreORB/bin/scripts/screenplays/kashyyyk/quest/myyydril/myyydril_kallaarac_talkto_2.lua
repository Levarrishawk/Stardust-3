--[[
	Myyydril Trust - Tala'oree  --  ep3_myyydril_kallaarac_talkto_2

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_kallaarac_talkto_2.qst and string/en/quest/ground/ep3_myyydril_kallaarac_talkto_2.stf.

	THE TASK TREE
		task 1  Wait for Signal  Signal Name talktotalaoree
		        title Myyydril Trust - Tala'oree

	Wait for Signal talktotalaoree, raised by Tala'oree's grant of destroy_1.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[34][TIER_1] = 193. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilKallaaracTalkto2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilKallaaracTalkto2ScreenPlay",
	repeatable = false,

}

registerScreenPlay("myyydrilKallaaracTalkto2ScreenPlay", true)

function myyydrilKallaaracTalkto2ScreenPlay:start()
end

function myyydrilKallaaracTalkto2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilKallaaracTalkto2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilKallaaracTalkto2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilKallaaracTalkto2ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilKallaaracTalkto2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilKallaaracTalkto2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilKallaaracTalkto2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kallaarac_talkto_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kallaarac_talkto_2:task00_journal_entry_title")

	return true
end

function myyydrilKallaaracTalkto2ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_kallaarac_talkto_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

end

function myyydrilKallaaracTalkto2ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilKallaaracTalkto2ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilKallaaracTalkto2ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end
