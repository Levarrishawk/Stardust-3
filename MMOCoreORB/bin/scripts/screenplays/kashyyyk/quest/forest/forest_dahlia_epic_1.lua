--[[
	The Road to Exemplar: Kerritamba Warriors  --  ep3_forest_dahlia_epic_1

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_dahlia_epic_1.qst and string/en/quest/ground/ep3_forest_dahlia_epic_1.stf.

	THE TASK TREE
		task 0  Destroy Multiple  Count 10 ep3_forest_kerritamba_warrior  [The Road to Exemplar: Kerritamba Warriors]
		task 1  Wait for Signal  Signal warriors
		task 2  Reward  credits 5000 item   [Reward Issued]

	Kill/encounter templates that ship pvpBitmask NONE (observer still matches):
		dressed_ep3_forest_kerritamba_warrior, dressed_ep3_forest_kerritamba_warrior_01, dressed_ep3_forest_kerritamba_warrior_02, dressed_ep3_forest_kerritamba_warrior_03, dressed_ep3_forest_kerritamba_warrior_04, dressed_ep3_forest_kerritamba_warrior_05, dressed_ep3_forest_kerritamba_warrior_06, dressed_ep3_forest_kerritamba_warrior_07, dressed_ep3_forest_kerritamba_warrior_08
		repo template ships pvpBitmask NONE; observer still matches (Kachirho lobarorr shape)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_dahlia_epic_1.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[36][TIER_3] = 16533. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestDahliaEpic1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestDahliaEpic1ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
	killCount = 10,
	lootDropPercent = 100,
	killTemplates = {
		"dressed_ep3_forest_kerritamba_warrior",
		"dressed_ep3_forest_kerritamba_warrior_01",
		"dressed_ep3_forest_kerritamba_warrior_02",
		"dressed_ep3_forest_kerritamba_warrior_03",
		"dressed_ep3_forest_kerritamba_warrior_04",
		"dressed_ep3_forest_kerritamba_warrior_05",
		"dressed_ep3_forest_kerritamba_warrior_06",
		"dressed_ep3_forest_kerritamba_warrior_07",
		"dressed_ep3_forest_kerritamba_warrior_08",
	},
}

registerScreenPlay("forestDahliaEpic1ScreenPlay", true)

function forestDahliaEpic1ScreenPlay:start()
end

function forestDahliaEpic1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestDahliaEpic1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestDahliaEpic1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestDahliaEpic1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestDahliaEpic1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function forestDahliaEpic1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_dahlia_epic_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_dahlia_epic_1:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_dahlia_epic_1:task00_journal_entry_title")
	return true
end

function forestDahliaEpic1ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_dahlia_epic_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestDahliaEpic1ScreenPlay:signalWarriors(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestDahliaEpic1ScreenPlay:signalTurnIn(pPlayer)
	return self:signalWarriors(pPlayer)
end

function forestDahliaEpic1ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestDahliaEpic1ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function forestDahliaEpic1ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestDahliaEpic1ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestDahliaEpic1ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestDahliaEpic1ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestDahliaEpic1ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(n))
	if (n >= self.killCount) then
		self:onWorkComplete(pPlayer)
	end
	return 0
end

