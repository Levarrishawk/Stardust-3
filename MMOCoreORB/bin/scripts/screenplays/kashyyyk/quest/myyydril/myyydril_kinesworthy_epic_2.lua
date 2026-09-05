--[[
	"The Lost"  --  ep3_myyydril_kinesworthy_epic_2

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_kinesworthy_epic_2.qst and string/en/quest/ground/ep3_myyydril_kinesworthy_epic_2.stf.

	THE TASK TREE
		task 5  Destroy Multiple and Loot  CreatureType ep3_myyydril_erriya; LootItemName Odd Gadget; LootDropPercent 100; NumberItemsRequired 1
		        title "The Lost"
			task 6  Wait for Signal  Signal Name phatLewts
			        title Unknown Object Found
				task 7  Reward  Bank Credits 6000; Item object/tangible/wearables/cybernetic/s02/cybernetic_s02_arm_l.iff
				        title Reward Issued

	ep3_myyydril_erriya -> dressed_myyydril_lost_erriya (iff). LootItemName Odd Gadget has no iff; chunk flag.
	Placeholder pvpBitmask NONE. He stands in morag53 via the POB populator.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[65][TIER_3] = 59142. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilKinesworthyEpic2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilKinesworthyEpic2ScreenPlay",
	repeatable = false,
	lootCount = 1,
	lootDropPercent = 100,
	rewardCredits = 6000,
	rewardItem = "object/tangible/wearables/cybernetic/s02/cybernetic_s02_arm_l.iff",
	killTemplates = {
		"dressed_myyydril_lost_erriya",
	},
}

registerScreenPlay("myyydrilKinesworthyEpic2ScreenPlay", true)

function myyydrilKinesworthyEpic2ScreenPlay:start()
end

function myyydrilKinesworthyEpic2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilKinesworthyEpic2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilKinesworthyEpic2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilKinesworthyEpic2ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilKinesworthyEpic2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilKinesworthyEpic2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilKinesworthyEpic2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_2:task00_journal_entry_title")

	return true
end

function myyydrilKinesworthyEpic2ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_kinesworthy_epic_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, self.rewardItem, -1, true)
	end
	self:clearQuest(pPlayer)

end

function myyydrilKinesworthyEpic2ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilKinesworthyEpic2ScreenPlay:isKillTemplate(name)
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

function myyydrilKinesworthyEpic2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "myyydrilKinesworthyEpic2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function myyydrilKinesworthyEpic2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "myyydrilKinesworthyEpic2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function myyydrilKinesworthyEpic2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_2:task00_journal_entry_title")

	if (n >= self.lootCount) then
		self:detachKillObserver(pPlayer)
		if (self.killCredits ~= nil) then
			CreatureObject(pPlayer):addBankCredits(self.killCredits, true)
		end
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_2:task01_journal_entry_title")
	end

	return 0
end
