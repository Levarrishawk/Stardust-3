--[[
	Cyrans the Unfeeling and the Sayromi Queen  --  ep3_forest_kerritamba_epic_5

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_kerritamba_epic_5.qst and string/en/quest/ground/ep3_forest_kerritamba_epic_5.stf.

	THE TASK TREE
		task 1  Nothing
		task 4  Destroy Multiple  Count 1 ep3_forest_sayormi_queen  [The Sayromi Queen]
		task 8  Wait for Tasks  siblings
		task 5  Wait for Signal  Signal epic5
		task 6  Reward  credits 10000 item   [Reward Issued]
		task 9  Destroy Multiple  Count 1 ep3_forest_sayormi_cyrans  [Cyrans the Unfeeling]

	Kill/encounter templates that ship pvpBitmask NONE (observer still matches):
		dressed_sayormi_queen, dressed_cyrans_unfeeling
		repo template ships pvpBitmask NONE; observer still matches (Kachirho lobarorr shape)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_kerritamba_epic_5.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[35][TIER_5] = 24393. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestKerritambaEpic5ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestKerritambaEpic5ScreenPlay",
	repeatable = false,
	rewardCredits = 15000,
	killGroups = {
		{ key = "kills0", count = 1, pct = 100, templates = {
			"dressed_sayormi_queen",
		} },
		{ key = "kills1", count = 1, pct = 100, templates = {
			"dressed_cyrans_unfeeling",
		} },
	},
}

registerScreenPlay("forestKerritambaEpic5ScreenPlay", true)

function forestKerritambaEpic5ScreenPlay:start()
end

function forestKerritambaEpic5ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestKerritambaEpic5ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestKerritambaEpic5ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestKerritambaEpic5ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestKerritambaEpic5ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills0")
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills1")
	self:setStage(pPlayer, 0)
end

function forestKerritambaEpic5ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_5:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_5:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_5:task04_journal_entry_title")
	return true
end

function forestKerritambaEpic5ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_kerritamba_epic_5")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestKerritambaEpic5ScreenPlay:signalEpic5(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestKerritambaEpic5ScreenPlay:signalTurnIn(pPlayer)
	return self:signalEpic5(pPlayer)
end

function forestKerritambaEpic5ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_5:task05_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_5:task05_journal_entry_description")
end

function forestKerritambaEpic5ScreenPlay:allWorkDone(pPlayer)
	for i = 1, #self.killGroups do
		local g = self.killGroups[i]
		local n = tonumber(readScreenPlayData(pPlayer, self.screenplayName, g.key)) or 0
		if (n < g.count) then
			return false
		end
	end
	return true
end

function forestKerritambaEpic5ScreenPlay:isKillTemplate(name)
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

function forestKerritambaEpic5ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestKerritambaEpic5ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestKerritambaEpic5ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestKerritambaEpic5ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestKerritambaEpic5ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

