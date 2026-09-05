--[[
	ep3_rodian_hunt_2

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_hunt_2.qst. Questlist title "Make a Dent in our competition!".

	THE TASK TREE
		task 0  Destroy Multiple   Target Server Template mission_trandoshan_slaver,
		                           Count 3, RewardCredits 0

	OPEN: no repo template named mission_trandoshan_slaver (grep of mobile/ on
	this tree and the dungeons tree). Not substituted with
	ep3_trando_slaver. killTemplates is empty; the observer never counts.

	COMPLETE_WHEN_TASKS_COMPLETE 1. No Wait for Signal. ALLOW_REPEATS 0.
	Questlist has no LEVEL/TIER: XP passthrough 0.

	OPEN: no conversation java in this arc grants hunt_1/2/3.
	OPEN: no shipped quest stf. No system-message keys sent.

	NO JOURNAL: do not call the journal engine. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: no LEVEL/TIER. See rodian_quest_xp.lua.
]]

rodianHunt2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianHunt2ScreenPlay",
	repeatable = false,
	killCount = 3,
	rewardCredits = 0,
	killTemplates = {
		-- OPEN: mission_trandoshan_slaver has no repo template.
	},
}

registerScreenPlay("rodianHunt2ScreenPlay", true)

function rodianHunt2ScreenPlay:start()
end

function rodianHunt2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianHunt2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianHunt2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianHunt2ScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function rodianHunt2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianHunt2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rodianHunt2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")

	return true
end

function rodianHunt2ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_rodian_hunt_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rodianHunt2ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rodianHunt2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rodianHunt2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rodianHunt2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rodianHunt2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rodianHunt2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
