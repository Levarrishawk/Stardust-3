--[[
	ep3_rodian_hunter_2

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_hunter_2.qst.

	THE TASK TREE
		task 0  Destroy Multiple   Target Server Template rill, Count 4,
		                           RewardCredits 1750

	Kill template is the exact repo name `rill`. OPEN: no Kashyyyk lair header
	spawns rill. Observer still matches that template.

	COMPLETE_WHEN_TASKS_COMPLETE 1. No Wait for Signal. ALLOW_REPEATS 0.
	Questlist has no LEVEL/TIER: XP passthrough 0.

	Giver ep3_rodian_hunter has no buildout row. OPEN: not placed.
	Conversation gates this grant on ep3_wookiee_benefactor_2; defined by the
	arc that owns ep3_wookiee_benefactor_2.

	OPEN: no shipped quest stf. No system-message keys sent.

	NO JOURNAL: do not call the journal engine. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: no LEVEL/TIER. See rodian_quest_xp.lua.
]]

rodianHunter2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianHunter2ScreenPlay",
	repeatable = false,
	killCount = 4,
	rewardCredits = 1750,
	killTemplates = {
		"rill",
	},
}

registerScreenPlay("rodianHunter2ScreenPlay", true)

function rodianHunter2ScreenPlay:start()
end

function rodianHunter2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianHunter2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianHunter2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianHunter2ScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function rodianHunter2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianHunter2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rodianHunter2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")

	return true
end

function rodianHunter2ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_rodian_hunter_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rodianHunter2ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rodianHunter2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rodianHunter2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rodianHunter2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rodianHunter2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rodianHunter2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 1) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil or not self:isKillTemplate(victimTemplate)) then
		return 0
	end

	local kills = self:getKills(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(kills))

	if (kills >= self.killCount) then
		self:awardQuest(pPlayer)
	end

	return 0
end
