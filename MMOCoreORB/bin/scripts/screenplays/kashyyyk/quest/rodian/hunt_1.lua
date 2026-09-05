--[[
	ep3_rodian_hunt_1

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_hunt_1.qst. Questlist title "Rodian Hunters Camp".

	THE TASK TREE
		task 0  Destroy Multiple   Target Server Template rill, Count 6,
		                           RewardCredits 500

	Kill template is the exact repo name `rill` (tatooine/rill.lua). OPEN: no
	Kashyyyk lair header spawns rill. Observer still matches that template.
	No look-alikes.

	COMPLETE_WHEN_TASKS_COMPLETE 1. No Wait for Signal. ALLOW_REPEATS 0.
	Questlist has no LEVEL/TIER: XP passthrough 0.

	OPEN: no conversation java in this arc grants hunt_1/2/3 (journal names a
	"Rodian Master Hunter"; ep3_rodian_master_m has no convo script). Task
	machine is live for a later grant site.

	OPEN: no shipped quest stf for ep3_rodian_hunt_1 (strings dump has fop
	quest files only). No system-message keys sent.

	NO JOURNAL: do not call the journal engine. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: no LEVEL/TIER. See rodian_quest_xp.lua.
]]

rodianHunt1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianHunt1ScreenPlay",
	repeatable = false,
	killCount = 6,
	rewardCredits = 500,
	killTemplates = {
		"rill",
	},
}

registerScreenPlay("rodianHunt1ScreenPlay", true)

function rodianHunt1ScreenPlay:start()
end

function rodianHunt1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianHunt1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianHunt1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianHunt1ScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function rodianHunt1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianHunt1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rodianHunt1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")

	return true
end

function rodianHunt1ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_rodian_hunt_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rodianHunt1ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rodianHunt1ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rodianHunt1ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rodianHunt1ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rodianHunt1ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rodianHunt1ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
