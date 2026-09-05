--[[
	Tala'oree's Beetles  --  ep3_myyydril_talaoree_destroy_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_talaoree_destroy_1.qst and string/en/quest/ground/ep3_myyydril_talaoree_destroy_1.stf.

	THE TASK TREE
		task 0  Destroy Multiple  Count 6; Target Server Template ep3_myyydril_uwari_aggro; RewardCredits 1000
		        title Myyydril Trust - Tala'oree's Beetles
			task 1  Wait for Signal  Signal Name giveReward
				task 2  Reward  Bank Credits 3000
				        title Reward Issued

	ep3_myyydril_uwari_aggro -> uwari_beetle_aggro (iff) plus numbered aggro_1/2. Placeholder pvpBitmask NONE.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[34][TIER_3] = 14850. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilTalaoreeDestroy1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilTalaoreeDestroy1ScreenPlay",
	repeatable = false,
	killCount = 6,
	rewardCredits = 3000,
	killCredits = 1000,
	killTemplates = {
		"uwari_beetle_aggro",
		"uwari_beetle_aggro_1",
		"uwari_beetle_aggro_2",
	},
}

registerScreenPlay("myyydrilTalaoreeDestroy1ScreenPlay", true)

function myyydrilTalaoreeDestroy1ScreenPlay:start()
end

function myyydrilTalaoreeDestroy1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilTalaoreeDestroy1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilTalaoreeDestroy1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilTalaoreeDestroy1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilTalaoreeDestroy1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilTalaoreeDestroy1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilTalaoreeDestroy1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_talaoree_destroy_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_talaoree_destroy_1:task00_journal_entry_title")

	return true
end

function myyydrilTalaoreeDestroy1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_talaoree_destroy_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilTalaoreeDestroy1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilTalaoreeDestroy1ScreenPlay:isKillTemplate(name)
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

function myyydrilTalaoreeDestroy1ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "myyydrilTalaoreeDestroy1ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function myyydrilTalaoreeDestroy1ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "myyydrilTalaoreeDestroy1ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function myyydrilTalaoreeDestroy1ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

	local n = self:getCount(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_talaoree_destroy_1:task00_journal_entry_title")

	if (n >= self.killCount) then
		self:detachKillObserver(pPlayer)
		if (self.killCredits ~= nil) then
			CreatureObject(pPlayer):addBankCredits(self.killCredits, true)
		end
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_talaoree_destroy_1:task01_journal_entry_title")
	end

	return 0
end
