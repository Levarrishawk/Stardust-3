--[[
	Exemplar Zheus  --  ep3_forest_ardon_quest_2

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_ardon_quest_2.qst and string/en/quest/ground/ep3_forest_ardon_quest_2.stf.

	THE TASK TREE
		task 5  Destroy Multiple and Loot  LootItemName Exemplar's Ring x1 100%  [Exemplar Zheus]
		task 6  Wait for Signal  Signal exemplar
		task 7  Reward  credits 5000 item   [Reward Issued]

	Kill/encounter templates that ship pvpBitmask NONE (observer still matches):
		dressed_ep3_forest_outcast_assassin_01, dressed_ep3_forest_outcast_assassin_02
		repo template ships pvpBitmask NONE; observer still matches (Kachirho lobarorr shape)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_ardon_quest_2.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[39][TIER_5] = 29997. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestArdonQuest2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestArdonQuest2ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
	killCount = 1,
	lootDropPercent = 100,
	killTemplates = {
		"dressed_ep3_forest_outcast_assassin_01",
		"dressed_ep3_forest_outcast_assassin_02",
	},
}

registerScreenPlay("forestArdonQuest2ScreenPlay", true)

function forestArdonQuest2ScreenPlay:start()
end

function forestArdonQuest2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestArdonQuest2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestArdonQuest2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestArdonQuest2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestArdonQuest2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function forestArdonQuest2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_ardon_quest_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_ardon_quest_2:journal_entry_description")
	return true
end

function forestArdonQuest2ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_ardon_quest_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestArdonQuest2ScreenPlay:signalExemplar(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestArdonQuest2ScreenPlay:signalTurnIn(pPlayer)
	return self:signalExemplar(pPlayer)
end

function forestArdonQuest2ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestArdonQuest2ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function forestArdonQuest2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestArdonQuest2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestArdonQuest2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestArdonQuest2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestArdonQuest2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

