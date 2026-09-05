--[[
	The Sayormi People  --  ep3_forest_meust_quest_3

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_meust_quest_3.qst and string/en/quest/ground/ep3_forest_meust_quest_3.stf.

	THE TASK TREE
		task 0  Destroy Multiple and Loot  LootItemName Sayormi Necklace x7 70%  [The Sayormi People]
		task 1  Wait for Signal  Signal sayormi
		task 2  Reward  credits 5000 item   [Reward Issued]

	Kill/encounter templates that ship pvpBitmask NONE (observer still matches):
		dressed_sayormi_witch, dressed_sayormi_witch_01, dressed_sayormi_witch_02, dressed_sayormi_witch_03, dressed_sayormi_witch_04, dressed_sayormi_witch_05, dressed_sayormi_witch_06, dressed_sayormi_witch_07, dressed_sayormi_warrior_01, dressed_sayormi_warrior_02, dressed_sayormi_warrior_03, dressed_sayormi_warrior_04
		repo template ships pvpBitmask NONE; observer still matches (Kachirho lobarorr shape)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_meust_quest_3.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[36][TIER_3] = 16533. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestMeustQuest3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestMeustQuest3ScreenPlay",
	repeatable = false,
	rewardCredits = 7000,
	killCount = 7,
	lootDropPercent = 70,
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

registerScreenPlay("forestMeustQuest3ScreenPlay", true)

function forestMeustQuest3ScreenPlay:start()
end

function forestMeustQuest3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestMeustQuest3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestMeustQuest3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestMeustQuest3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestMeustQuest3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function forestMeustQuest3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_meust_quest_3:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_meust_quest_3:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_meust_quest_3:task00_journal_entry_title")
	return true
end

function forestMeustQuest3ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_meust_quest_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestMeustQuest3ScreenPlay:signalSayormi(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestMeustQuest3ScreenPlay:signalTurnIn(pPlayer)
	return self:signalSayormi(pPlayer)
end

function forestMeustQuest3ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestMeustQuest3ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function forestMeustQuest3ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestMeustQuest3ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestMeustQuest3ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestMeustQuest3ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestMeustQuest3ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(n))
	if (n >= self.killCount) then
		self:onWorkComplete(pPlayer)
	end
	return 0
end

