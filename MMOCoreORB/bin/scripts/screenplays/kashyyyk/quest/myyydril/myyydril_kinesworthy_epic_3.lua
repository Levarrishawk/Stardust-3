--[[
	Treun Lorn  --  ep3_myyydril_kinesworthy_epic_3

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_kinesworthy_epic_3.qst and string/en/quest/ground/ep3_myyydril_kinesworthy_epic_3.stf.

	THE TASK TREE
		task 0  Destroy Multiple and Loot  CreatureType ep3_myyydril_nk3; LootItemName Cybernetic Node; LootDropPercent 100; NumberItemsRequired 1; RewardCredits 3000
		        title Treun Lorn
			task 1  Wait for Signal  Signal Name phatLewts
				task 2  Reward  Bank Credits 10000; Item object/tangible/wearables/cybernetic/s03/cybernetic_s03_arm_r.iff

	ep3_myyydril_nk3 maps onto itself. OPEN: no POB spawn row for NK-3. pvpBitmask NONE.
	LootItemName Cybernetic Node has no iff; chunk flag.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[57][TIER_4] = 55077. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilKinesworthyEpic3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilKinesworthyEpic3ScreenPlay",
	repeatable = false,
	lootCount = 1,
	lootDropPercent = 100,
	rewardCredits = 10000,
	killCredits = 3000,
	rewardItem = "object/tangible/wearables/cybernetic/s03/cybernetic_s03_arm_r.iff",
	killTemplates = {
		"ep3_myyydril_nk3",
	},
}

registerScreenPlay("myyydrilKinesworthyEpic3ScreenPlay", true)

function myyydrilKinesworthyEpic3ScreenPlay:start()
end

function myyydrilKinesworthyEpic3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilKinesworthyEpic3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilKinesworthyEpic3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilKinesworthyEpic3ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilKinesworthyEpic3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilKinesworthyEpic3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilKinesworthyEpic3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_3:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_3:task00_journal_entry_title")

	return true
end

function myyydrilKinesworthyEpic3ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_kinesworthy_epic_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, self.rewardItem, -1, true)
	end
	self:clearQuest(pPlayer)

end

function myyydrilKinesworthyEpic3ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilKinesworthyEpic3ScreenPlay:isKillTemplate(name)
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

function myyydrilKinesworthyEpic3ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "myyydrilKinesworthyEpic3ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function myyydrilKinesworthyEpic3ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "myyydrilKinesworthyEpic3ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function myyydrilKinesworthyEpic3ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_3:task00_journal_entry_title")

	if (n >= self.lootCount) then
		self:detachKillObserver(pPlayer)
		if (self.killCredits ~= nil) then
			CreatureObject(pPlayer):addBankCredits(self.killCredits, true)
		end
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_3:task01_journal_entry_title")
	end

	return 0
end
