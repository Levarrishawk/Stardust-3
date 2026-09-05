--[[
	The Sect: Mother Ves'ad  --  ep3_forest_rhiek_quest_3

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_rhiek_quest_3.qst and string/en/quest/ground/ep3_forest_rhiek_quest_3.stf.

	THE TASK TREE
		task 0  Destroy Multiple and Loot  LootItemName Queen's Gland x1 100%  [The Sect: Mother Ves'ad]
		task 1  Wait for Signal  Signal queen
		task 3  Reward  credits 5000 item   [Reward Issued]

	OPEN
		Destroy-and-Loot CreatureType ep3_forest_mother_vesad has no repo template

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_rhiek_quest_3.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[40][TIER_4] = 25883. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestRhiekQuest3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestRhiekQuest3ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
	killCount = 1,
	lootDropPercent = 100,
	killTemplates = {},
}

registerScreenPlay("forestRhiekQuest3ScreenPlay", true)

function forestRhiekQuest3ScreenPlay:start()
end

function forestRhiekQuest3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestRhiekQuest3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestRhiekQuest3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestRhiekQuest3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestRhiekQuest3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function forestRhiekQuest3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_rhiek_quest_3:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_rhiek_quest_3:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_rhiek_quest_3:task00_journal_entry_title")
	return true
end

function forestRhiekQuest3ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_rhiek_quest_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestRhiekQuest3ScreenPlay:signalQueen(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestRhiekQuest3ScreenPlay:signalTurnIn(pPlayer)
	return self:signalQueen(pPlayer)
end

function forestRhiekQuest3ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestRhiekQuest3ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function forestRhiekQuest3ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestRhiekQuest3ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestRhiekQuest3ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestRhiekQuest3ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestRhiekQuest3ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

