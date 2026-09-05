--[[
	ep3_trando_ysith_reward  --  ep3_trando_ysith_reward

	ruling 2026-09-04

	THE TASK TREE
		task 0  Reward  Bank Credits 10000

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	OPEN: no conversation in this arc grants this quest.
]]

trandoYsithRewardScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoYsithRewardScreenPlay",
	repeatable = true,
	rewardCredits = 10000,
}


registerScreenPlay("trandoYsithRewardScreenPlay", true)

function trandoYsithRewardScreenPlay:start()
end

function trandoYsithRewardScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoYsithRewardScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoYsithRewardScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoYsithRewardScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoYsithRewardScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoYsithRewardScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function trandoYsithRewardScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_trando_ysith_reward")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:setStage(pPlayer, 0)
	return true
end
