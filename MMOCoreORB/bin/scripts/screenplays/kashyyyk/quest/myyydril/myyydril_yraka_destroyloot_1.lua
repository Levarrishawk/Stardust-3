--[[
	Webweaver Blankets  --  ep3_myyydril_yraka_destroyloot_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_yraka_destroyloot_1.qst and string/en/quest/ground/ep3_myyydril_yraka_destroyloot_1.stf.

	THE TASK TREE
		task 4  Destroy Multiple and Loot  Social Group forest_webweaver; LootItemName Webweaver Strand; LootDropPercent 80; NumberItemsRequired 20; RewardCredits 2000
		        title Webweaver Blankets
			task 5  Wait for Signal  Signal Name giveReward
				task 6  Reward  Bank Credits 5000
				        title Reward Issued

	Social Group forest_webweaver -> webweaver (lair headers). LootItemName Webweaver Strand has no iff; chunk flag.
	NPC givers that share the social group are not kill targets.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[38][TIER_3] = 18337. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilYrakaDestroyloot1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilYrakaDestroyloot1ScreenPlay",
	repeatable = false,
	lootCount = 20,
	lootDropPercent = 80,
	rewardCredits = 5000,
	killCredits = 2000,
	killTemplates = {
		"webweaver",
	},
}

registerScreenPlay("myyydrilYrakaDestroyloot1ScreenPlay", true)

function myyydrilYrakaDestroyloot1ScreenPlay:start()
end

function myyydrilYrakaDestroyloot1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilYrakaDestroyloot1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilYrakaDestroyloot1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilYrakaDestroyloot1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilYrakaDestroyloot1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilYrakaDestroyloot1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilYrakaDestroyloot1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_destroyloot_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_destroyloot_1:task00_journal_entry_title")

	return true
end

function myyydrilYrakaDestroyloot1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_yraka_destroyloot_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilYrakaDestroyloot1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilYrakaDestroyloot1ScreenPlay:isKillTemplate(name)
	if (self.killTemplate ~= nil) then
		return name == self.killTemplate
	end

	if (self.killTemplates == nil) then
		return false
	end

	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function myyydrilYrakaDestroyloot1ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "myyydrilYrakaDestroyloot1ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function myyydrilYrakaDestroyloot1ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "myyydrilYrakaDestroyloot1ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function myyydrilYrakaDestroyloot1ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "loot")) or 0) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "loot", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_destroyloot_1:task00_journal_entry_title")

	if (n >= self.lootCount) then
		self:detachKillObserver(pPlayer)
		if (self.killCredits ~= nil) then
			CreatureObject(pPlayer):addBankCredits(self.killCredits, true)
		end
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_destroyloot_1:task01_journal_entry_title")
	end

	return 0
end
