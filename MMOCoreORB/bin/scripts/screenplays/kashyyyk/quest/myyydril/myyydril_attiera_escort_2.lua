--[[
	Save Froera  --  ep3_myyydril_attiera_escort_2

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_attiera_escort_2.qst and string/en/quest/ground/ep3_myyydril_attiera_escort_2.stf.

	THE TASK TREE
		task 1  Escort  Escort Creature Type bomarr_monk
		        title Save Froera
			task 3  Wait for Signal  Signal Name giveLoot
				task 4  Reward  
					task 5  Immediately Complete Quest  

	OPEN: Escort Creature Type is bomarr_monk. dressed_myyydril_froera exists but is not substituted.
	Attiera has no dungeon spawn row. No Core3 escort runner: completeEscort is never
	called, so stage 2 (s_524 giveLoot turn-in) is unreachable. Do not shortcut it.
	Reward task stores no Bank Credits.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[80][TIER_4] = 131890. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilAttieraEscort2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilAttieraEscort2ScreenPlay",
	repeatable = false,

}

registerScreenPlay("myyydrilAttieraEscort2ScreenPlay", true)

function myyydrilAttieraEscort2ScreenPlay:start()
end

function myyydrilAttieraEscort2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilAttieraEscort2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilAttieraEscort2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilAttieraEscort2ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilAttieraEscort2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilAttieraEscort2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilAttieraEscort2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_attiera_escort_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_attiera_escort_2:task00_journal_entry_title")

	return true
end

function myyydrilAttieraEscort2ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_attiera_escort_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

end

function myyydrilAttieraEscort2ScreenPlay:completeEscort(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_attiera_escort_2:task01_journal_entry_title")

	return true
end

function myyydrilAttieraEscort2ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilAttieraEscort2ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilAttieraEscort2ScreenPlay:detachKillObserver(pPlayer)
end
