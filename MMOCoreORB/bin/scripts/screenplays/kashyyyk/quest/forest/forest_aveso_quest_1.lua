--[[
	Grunt Work: Part I  --  ep3_forest_aveso_quest_1

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_aveso_quest_1.qst and string/en/quest/ground/ep3_forest_aveso_quest_1.stf.

	THE TASK TREE
		task 0  Nothing
		task 7  Destroy Multiple and Loot  LootItemName Spider Meat x20 70%  [Grunt Work: Part I]
		task 8  Destroy Multiple and Loot  LootItemName Mouf Meat x20 80%  [Grunt Work: Part I]
		task 9  Wait for Tasks  siblings
		task 3  Wait for Signal  Signal meat
		task 5  Reward  credits 3000 item   [Reward Issued]

	OPEN
		Destroy-and-Loot Social Group forest_mouf has no lair mapping (not substituted)

	Kill/encounter templates that ship pvpBitmask NONE (observer still matches):
		webweaver
		repo template ships pvpBitmask NONE; observer still matches (Kachirho lobarorr shape)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_aveso_quest_1.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[34][TIER_3] = 14850. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestAvesoQuest1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestAvesoQuest1ScreenPlay",
	repeatable = false,
	rewardCredits = 3000,
	killGroups = {
		{ key = "loot0", count = 20, pct = 70, templates = {
			"webweaver",
		} },
		{ key = "loot1", count = 20, pct = 80, templates = {} },
	},
}

registerScreenPlay("forestAvesoQuest1ScreenPlay", true)

function forestAvesoQuest1ScreenPlay:start()
end

function forestAvesoQuest1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestAvesoQuest1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestAvesoQuest1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestAvesoQuest1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestAvesoQuest1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot0")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot1")
	self:setStage(pPlayer, 0)
end

function forestAvesoQuest1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_aveso_quest_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_aveso_quest_1:journal_entry_description")
	return true
end

function forestAvesoQuest1ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_aveso_quest_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestAvesoQuest1ScreenPlay:signalMeat(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestAvesoQuest1ScreenPlay:signalTurnIn(pPlayer)
	return self:signalMeat(pPlayer)
end

function forestAvesoQuest1ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestAvesoQuest1ScreenPlay:allWorkDone(pPlayer)
	for i = 1, #self.killGroups do
		local g = self.killGroups[i]
		local n = tonumber(readScreenPlayData(pPlayer, self.screenplayName, g.key)) or 0
		if (n < g.count) then
			return false
		end
	end
	return true
end

function forestAvesoQuest1ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killGroups do
		local g = self.killGroups[i]
		for j = 1, #g.templates do
			if (g.templates[j] == name) then
				return true
			end
		end
	end
	return false
end

function forestAvesoQuest1ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestAvesoQuest1ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestAvesoQuest1ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestAvesoQuest1ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestAvesoQuest1ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	for i = 1, #self.killGroups do
		local g = self.killGroups[i]
		local hit = false
		for j = 1, #g.templates do
			if (g.templates[j] == victimTemplate) then
				hit = true
			end
		end
		if (hit) then
			if (getRandomNumber(100) > g.pct) then
				return 0
			end
			local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, g.key)) or 0) + 1
			writeScreenPlayData(pPlayer, self.screenplayName, g.key, tostring(n))
		end
	end
	if (self:allWorkDone(pPlayer)) then
		self:onWorkComplete(pPlayer)
	end
	return 0
end

