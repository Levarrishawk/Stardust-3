--[[
	Task Force Bravo  --  ep3_kachirho_kill_wke

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	SOURCE: quest/ep3_kachirho_kill_wke.qst and string/en/quest/ground/ep3_kachirho_kill_wke.stf.

	THE TASK TREE
		task 0  Destroy Multiple   Count 15, Social Group kashyyyk_resistance
		task 1  Wait for Signal    gurnstReward  -- conversation turn-in
		task 2  Reward             Bank Credits 15000

	Kill templates are the repo names the the lair headers map onto
	ep3_npc_wookiee_freedom_fighters (no look-alikes):
		ep3_wke_freedom_fighter_01..05
		ep3_wke_forest_stalker_01..03  (same kash_kachirho_wke_fighters lair)

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships quest/ep3_kachirho_kill_wke.qst; the journal row comes from the
	integration branch later. Do not call Journal.*.

	Giver ep3_col_gurnst already stands via kashyyyk_static_npcs.lua. Not spawned here.

	XP: KashyyykQuestXp / mustafar_quest_xp.lua shape, quest_experience[30][TIER_1] = 171.
]]

kachirhoKillWkeScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "kachirhoKillWkeScreenPlay",
	repeatable = true,
	killCount = 15,
	rewardCredits = 15000,
	killTemplates = {
		"ep3_wke_freedom_fighter_01",
		"ep3_wke_freedom_fighter_02",
		"ep3_wke_freedom_fighter_03",
		"ep3_wke_freedom_fighter_04",
		"ep3_wke_freedom_fighter_05",
		"ep3_wke_forest_stalker_01",
		"ep3_wke_forest_stalker_02",
		"ep3_wke_forest_stalker_03",
	},
}

registerScreenPlay("kachirhoKillWkeScreenPlay", true)

function kachirhoKillWkeScreenPlay:start()
end

function kachirhoKillWkeScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kachirhoKillWkeScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function kachirhoKillWkeScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function kachirhoKillWkeScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function kachirhoKillWkeScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function kachirhoKillWkeScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function kachirhoKillWkeScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_kill_wke:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_kill_wke:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_kill_wke:task00_journal_entry_title")

	return true
end

function kachirhoKillWkeScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function kachirhoKillWkeScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_kachirho_kill_wke")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function kachirhoKillWkeScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function kachirhoKillWkeScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "kachirhoKillWkeScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function kachirhoKillWkeScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "kachirhoKillWkeScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function kachirhoKillWkeScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_kill_wke:task00_journal_entry_title")

	if (kills >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_kill_wke:task01_journal_entry_title")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_kill_wke:task01_journal_entry_description")
	end

	return 0
end
