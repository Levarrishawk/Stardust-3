--[[
	ep3_rodian_hunt_3

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_hunt_3.qst.

	THE TASK TREE
		task 0  Destroy Multiple and Loot   CreatureType mission_trandoshan_slaver,
		                                    LootItemName "Kidnappers' Plans",
		                                    NumberItemsRequired 3, LootDropPercent 86,
		                                    RewardCredits 0

	OPEN: no repo template named mission_trandoshan_slaver. Not substituted.
	killTemplates is empty; the observer never counts.

	"Kidnappers' Plans" has no object template; tracked as a loot flag
	(varactyl_hunt.lua chunk shape) if a kill template ever lands.

	COMPLETE_WHEN_TASKS_COMPLETE 1. No Wait for Signal. ALLOW_REPEATS 0.
	Questlist has no LEVEL/TIER: XP passthrough 0.

	OPEN: no conversation java in this arc grants hunt_1/2/3.
	OPEN: no shipped quest stf. No system-message keys sent.

	NO JOURNAL: do not call the journal engine. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: no LEVEL/TIER. See rodian_quest_xp.lua.
]]

rodianHunt3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianHunt3ScreenPlay",
	repeatable = false,
	lootCount = 3,
	lootDropPercent = 86,
	rewardCredits = 0,
	killTemplates = {
		-- OPEN: mission_trandoshan_slaver has no repo template.
	},
}

registerScreenPlay("rodianHunt3ScreenPlay", true)

function rodianHunt3ScreenPlay:start()
end

function rodianHunt3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianHunt3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianHunt3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianHunt3ScreenPlay:getLoot(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "plans")) or 0
end

function rodianHunt3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianHunt3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "plans")
	self:setStage(pPlayer, 0)
end

function rodianHunt3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "plans")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")

	return true
end

function rodianHunt3ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_rodian_hunt_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "plans")
	self:setStage(pPlayer, 0)
end

function rodianHunt3ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rodianHunt3ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rodianHunt3ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rodianHunt3ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rodianHunt3ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rodianHunt3ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

	if (getRandomNumber(100) > self.lootDropPercent) then
		return 0
	end

	local loot = self:getLoot(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "plans", tostring(loot))

	if (loot >= self.lootCount) then
		self:awardQuest(pPlayer)
	end

	return 0
end
