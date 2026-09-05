--[[
	ep3_rodian_hunter_3

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_hunter_3.qst.

	THE TASK TREE
		task 0  Destroy Multiple and Loot   CreatureType trandoshan_slaver,
		                                    LootItemName "Kidnap Order Fragment",
		                                    NumberItemsRequired 5, LootDropPercent 88,
		                                    RewardCredits 2500

	Kill templates from the Kashyyyk lair headers (no look-alikes):
		ep3_npc_trandoshan_slavers / ep3_trandoshan_slavers -> ep3_trando_slaver

	"Kidnap Order Fragment" has no object template; tracked as a loot flag
	(varactyl_hunt.lua chunk shape).

	COMPLETE_WHEN_TASKS_COMPLETE 1. No Wait for Signal. ALLOW_REPEATS 0.
	Questlist has no LEVEL/TIER: XP passthrough 0.

	Giver ep3_rodian_hunter has no buildout row. OPEN: not placed.

	OPEN: java also grants quest/ep3_rodian_hunter_4 and _5. No .qst in the
	transcribe set. Those grant screens are no-ops (see the hunter handler).

	OPEN: no shipped quest stf. No system-message keys sent.

	NO JOURNAL: do not call the journal engine. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: no LEVEL/TIER. See rodian_quest_xp.lua.
]]

rodianHunter3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianHunter3ScreenPlay",
	repeatable = false,
	lootCount = 5,
	lootDropPercent = 88,
	rewardCredits = 2500,
	killTemplates = {
		"ep3_trando_slaver",
	},
}

registerScreenPlay("rodianHunter3ScreenPlay", true)

function rodianHunter3ScreenPlay:start()
end

function rodianHunter3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianHunter3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianHunter3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianHunter3ScreenPlay:getLoot(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "orders")) or 0
end

function rodianHunter3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianHunter3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "orders")
	self:setStage(pPlayer, 0)
end

function rodianHunter3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "orders")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")

	return true
end

function rodianHunter3ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_rodian_hunter_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "orders")
	self:setStage(pPlayer, 0)
end

function rodianHunter3ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rodianHunter3ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rodianHunter3ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rodianHunter3ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rodianHunter3ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rodianHunter3ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

	writeScreenPlayData(pPlayer, self.screenplayName, "orders", tostring(loot))

	if (loot >= self.lootCount) then
		self:awardQuest(pPlayer)
	end

	return 0
end
