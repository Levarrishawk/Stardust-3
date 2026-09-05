--[[
	ep3_rodian_fop_2

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_fop_2.qst and the matching quest stf.

	THE TASK TREE
		task 1  Destroy Multiple and Loot   CreatureType trandoshan_slaver,
		                                    LootItemName "Rodian Paystub",
		                                    NumberItemsRequired 6, LootDropPercent 92,
		                                    RewardCredits 128000

	Kill templates from the Kashyyyk lair headers (no look-alikes):
		ep3_npc_trandoshan_slavers / ep3_trandoshan_slavers -> ep3_trando_slaver

	"Rodian Paystub" has no object template; tracked as a per-player loot flag
	(varactyl_hunt.lua chunk shape).

	COMPLETE_WHEN_TASKS_COMPLETE 1. No Wait for Signal. ALLOW_REPEATS 0.

	Giver ep3_rodian_fop has no buildout row. OPEN: not placed.

	NO JOURNAL: do not call the journal engine. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: quest_experience[28][TIER_3] = 10494. See rodian_quest_xp.lua.
]]

rodianFop2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianFop2ScreenPlay",
	repeatable = false,
	lootCount = 6,
	lootDropPercent = 92,
	rewardCredits = 128000,
	killTemplates = {
		"ep3_trando_slaver",
	},
}

registerScreenPlay("rodianFop2ScreenPlay", true)

function rodianFop2ScreenPlay:start()
end

function rodianFop2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianFop2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianFop2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianFop2ScreenPlay:getLoot(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "paystubs")) or 0
end

function rodianFop2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianFop2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "paystubs")
	self:setStage(pPlayer, 0)
end

function rodianFop2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "paystubs")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_2:task00_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_2:task00_journal_entry_description")

	return true
end

function rodianFop2ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_rodian_fop_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "paystubs")
	self:setStage(pPlayer, 0)
end

function rodianFop2ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rodianFop2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rodianFop2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rodianFop2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rodianFop2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rodianFop2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

	writeScreenPlayData(pPlayer, self.screenplayName, "paystubs", tostring(loot))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_2:task00_journal_entry_title")

	if (loot >= self.lootCount) then
		self:awardQuest(pPlayer)
	end

	return 0
end
