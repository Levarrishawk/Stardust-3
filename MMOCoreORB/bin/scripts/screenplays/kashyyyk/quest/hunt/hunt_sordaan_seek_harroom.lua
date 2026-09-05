--[[
	journal_entry_title  --  ep3_hunt_sordaan_seek_harroom

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_sordaan_seek_harroom.qst and string/en/quest/ground/ep3_hunt_sordaan_seek_harroom.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 3  d1  Wait for Signal  sordaan_webweaverBetReward  signal sordaan_webweaverBetReward
		task 1  d2  Wait for Signal  sordaan_talkToHarroom_04  signal sordaan_talkToHarroom
		task 2  d3  Immediately Clear Quest
		task 4  d1  Wait for Signal  sordaan_moufBetReward  signal sordaan_moufBetReward
		task 7  d2  Wait for Signal  sordaan_talkToHarroom_03  signal sordaan_talkToHarroom
		task 8  d3  Immediately Clear Quest
		task 5  d1  Wait for Signal  sordaan_wallugaBetReward  signal sordaan_wallugaBetReward
		task 9  d2  Wait for Signal  sordaan_talkToHarroom_02  signal sordaan_talkToHarroom
		task 13  d3  Immediately Clear Quest
		task 6  d1  Wait for Signal  sordaan_ullerBetReward  signal sordaan_ullerBetReward
		task 11  d2  Wait for Signal  sordaan_talkToHarroom_01  signal sordaan_talkToHarroom
		task 14  d3  Immediately Clear Quest

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[0][TIER_-1] = 0. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntSordaanSeekHarroomScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntSordaanSeekHarroomScreenPlay",
	questKey = "ep3_hunt_sordaan_seek_harroom",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 0,
	lootDropPercent = 0,
	killStage = 0,
	maxStage = 2,
	clearOnFinish = true,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = {  },
	taskStages = { sordaan_webweaverBetReward = 1,
		sordaan_moufBetReward = 1,
		sordaan_wallugaBetReward = 1,
		sordaan_ullerBetReward = 1,
		sordaan_talkToHarroom_04 = 2,
		sordaan_talkToHarroom = 2,
		sordaan_talkToHarroom_03 = 2,
		sordaan_talkToHarroom_02 = 2,
		sordaan_talkToHarroom_01 = 2 },
}

registerScreenPlay("huntSordaanSeekHarroomScreenPlay", true)

function huntSordaanSeekHarroomScreenPlay:start()
end

function huntSordaanSeekHarroomScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntSordaanSeekHarroomScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntSordaanSeekHarroomScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntSordaanSeekHarroomScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntSordaanSeekHarroomScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntSordaanSeekHarroomScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntSordaanSeekHarroomScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntSordaanSeekHarroomScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntSordaanSeekHarroomScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntSordaanSeekHarroomScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function huntSordaanSeekHarroomScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	if (self.maxStage == 1 and self.autoAward) then
		self:awardQuest(pPlayer)
		return true
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_sordaan_seek_harroom:journal_entry_title")
	return true
end

function huntSordaanSeekHarroomScreenPlay:raiseSignal(pPlayer, signalName)
	if (pPlayer == nil or signalName == nil) then
		return false
	end
	local need = self.taskStages[signalName]
	if (need == nil) then
		-- some Wait-for-Signal tasks use a taskName distinct from the signal
		for name, st in pairs(self.taskStages) do
			if (name == signalName) then
				need = st
				break
			end
		end
	end
	if (need == nil or self:getStage(pPlayer) ~= need) then
		return false
	end
	self:markTask(pPlayer, signalName)
	local nxt = need + 1
	if (nxt > 2) then
		if (self.clearOnFinish) then
			self:clearQuest(pPlayer)
		else
			self:awardQuest(pPlayer)
		end
		return true
	end
	self:setStage(pPlayer, nxt)

	return true
end

function huntSordaanSeekHarroomScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, self.questKey)
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	if (self.rewardItem ~= nil and self.rewardItem ~= "") then
		local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")
		if (pInv ~= nil) then
			giveItem(pInv, self.rewardItem, -1)
		end
	end
	self:clearQuest(pPlayer)
end
