--[[
	The Sayormi  --  ep3_forest_kerritamba_epic_4

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_kerritamba_epic_4.qst and string/en/quest/ground/ep3_forest_kerritamba_epic_4.stf.

	THE TASK TREE
		task 0  Destroy Multiple  Count 20 Social Group forest_sayormi  [Defeat the Sayormi]
		task 1  Wait for Signal  Signal sayormi
		task 2  Reward  credits 5000 item   [Reward Issued]

	Kill/encounter templates that ship pvpBitmask NONE (observer still matches):
		dressed_sayormi_witch, dressed_sayormi_witch_01, dressed_sayormi_witch_02, dressed_sayormi_witch_03, dressed_sayormi_witch_04, dressed_sayormi_witch_05, dressed_sayormi_witch_06, dressed_sayormi_witch_07, dressed_sayormi_warrior_01, dressed_sayormi_warrior_02, dressed_sayormi_warrior_03, dressed_sayormi_warrior_04
		repo template ships pvpBitmask NONE; observer still matches (Kachirho lobarorr shape)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_kerritamba_epic_4.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[35][TIER_3] = 15681. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestKerritambaEpic4ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestKerritambaEpic4ScreenPlay",
	repeatable = false,
	rewardCredits = 10000,
	killCount = 20,
	lootDropPercent = 100,
	killTemplates = {
		"dressed_sayormi_witch",
		"dressed_sayormi_witch_01",
		"dressed_sayormi_witch_02",
		"dressed_sayormi_witch_03",
		"dressed_sayormi_witch_04",
		"dressed_sayormi_witch_05",
		"dressed_sayormi_witch_06",
		"dressed_sayormi_witch_07",
		"dressed_sayormi_warrior_01",
		"dressed_sayormi_warrior_02",
		"dressed_sayormi_warrior_03",
		"dressed_sayormi_warrior_04",
		"dressed_sayormi_warrior_05",
		"dressed_sayormi_warrior_06",
		"dressed_sayromi_monk_01",
		"dressed_sayromi_monk_02",
		"dressed_sayromi_monk_03",
		"dressed_sayromi_monk_04",
		"dressed_sayromi_monk_05",
		"dressed_sayromi_monk_06",
	},
}

registerScreenPlay("forestKerritambaEpic4ScreenPlay", true)

function forestKerritambaEpic4ScreenPlay:start()
end

function forestKerritambaEpic4ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestKerritambaEpic4ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestKerritambaEpic4ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestKerritambaEpic4ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestKerritambaEpic4ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function forestKerritambaEpic4ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_4:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_4:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_4:task00_journal_entry_title")
	return true
end

function forestKerritambaEpic4ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_kerritamba_epic_4")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestKerritambaEpic4ScreenPlay:signalSayormi(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestKerritambaEpic4ScreenPlay:signalTurnIn(pPlayer)
	return self:signalSayormi(pPlayer)
end

function forestKerritambaEpic4ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestKerritambaEpic4ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function forestKerritambaEpic4ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestKerritambaEpic4ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestKerritambaEpic4ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestKerritambaEpic4ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestKerritambaEpic4ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

