--[[
	journal_entry_title  --  ep3_hunt_tripp_collect_mouf_pelts

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_tripp_collect_mouf_pelts.qst and string/en/quest/ground/ep3_hunt_tripp_collect_mouf_pelts.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 1  d1  Wait for Signal  tripp_talkToTripp  signal tripp_talkToTripp
		task 2  d2  Destroy Multiple and Loot  tripp_collectingMoufPelts  CreatureType ep3_etyyy_mouf_vibrant  Loot "pristine mouf pelts" x14 40%
		task 3  d3  Wait for Signal  tripp_moufPelts  signal tripp_moufPelts

	OPEN: no repo template for ep3_etyyy_mouf_vibrant
	OPEN: LootItemName "pristine mouf pelts" has no object template; tracked as a per-player loot flag (chunk shape).

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[45][TIER_3] = 25702. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntTrippCollectMoufPeltsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntTrippCollectMoufPeltsScreenPlay",
	questKey = "ep3_hunt_tripp_collect_mouf_pelts",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 14,
	lootDropPercent = 40,
	killStage = 2,
	maxStage = 3,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = {  },
	taskStages = { tripp_talkToTripp = 1,
		tripp_collectingMoufPelts = 2,
		tripp_moufPelts = 3 },
}

registerScreenPlay("huntTrippCollectMoufPeltsScreenPlay", true)

function huntTrippCollectMoufPeltsScreenPlay:start()
end

function huntTrippCollectMoufPeltsScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntTrippCollectMoufPeltsScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntTrippCollectMoufPeltsScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntTrippCollectMoufPeltsScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntTrippCollectMoufPeltsScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntTrippCollectMoufPeltsScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntTrippCollectMoufPeltsScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntTrippCollectMoufPeltsScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntTrippCollectMoufPeltsScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntTrippCollectMoufPeltsScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function huntTrippCollectMoufPeltsScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	if (self.maxStage == 1 and self.autoAward) then
		self:awardQuest(pPlayer)
		return true
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_tripp_collect_mouf_pelts:journal_entry_title")
	return true
end

function huntTrippCollectMoufPeltsScreenPlay:raiseSignal(pPlayer, signalName)
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
	if (nxt > 3) then
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

function huntTrippCollectMoufPeltsScreenPlay:awardQuest(pPlayer)
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
