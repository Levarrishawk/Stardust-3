--[[
	Steelclaw  --  ep3_forest_meust_quest_2

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_meust_quest_2.qst and string/en/quest/ground/ep3_forest_meust_quest_2.stf.

	THE TASK TREE
		task 0  Destroy Multiple and Loot  LootItemName Steelclaw's Ear x1 100%  [Steelclaw]
		task 1  Wait for Signal  Signal steelhoof
		task 2  Reward  credits 5000 item   [Reward Issued]

	OPEN
		Destroy-and-Loot CreatureType ep3_forest_steelclaw has no repo template

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_meust_quest_2.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[36][TIER_4] = 21126. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestMeustQuest2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestMeustQuest2ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
	killCount = 1,
	lootDropPercent = 100,
	killTemplates = {},
}

registerScreenPlay("forestMeustQuest2ScreenPlay", true)

function forestMeustQuest2ScreenPlay:start()
end

function forestMeustQuest2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestMeustQuest2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestMeustQuest2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestMeustQuest2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestMeustQuest2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function forestMeustQuest2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_meust_quest_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_meust_quest_2:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_meust_quest_2:task00_journal_entry_title")
	return true
end

function forestMeustQuest2ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_meust_quest_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestMeustQuest2ScreenPlay:signalSteelhoof(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestMeustQuest2ScreenPlay:signalTurnIn(pPlayer)
	return self:signalSteelhoof(pPlayer)
end

function forestMeustQuest2ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestMeustQuest2ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function forestMeustQuest2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestMeustQuest2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestMeustQuest2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestMeustQuest2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestMeustQuest2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

