--[[
	journal_entry_title  --  ep3_hunt_sordaan_webweaver_bet_lost

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_sordaan_webweaver_bet_lost.qst and string/en/quest/ground/ep3_hunt_sordaan_webweaver_bet_lost.stf.

	THE TASK TREE
		task 0  d0  Wait for Signal  sordaan_webweaverBetLost  signal sordaan_webweaverBetLost
		task 1  d1  Immediately Clear Quest

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[0][TIER_-1] = 0. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntSordaanWebweaverBetLostScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntSordaanWebweaverBetLostScreenPlay",
	questKey = "ep3_hunt_sordaan_webweaver_bet_lost",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 0,
	lootDropPercent = 0,
	killStage = 0,
	maxStage = 1,
	clearOnFinish = true,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = {  },
	taskStages = { sordaan_webweaverBetLost = 1 },
}

registerScreenPlay("huntSordaanWebweaverBetLostScreenPlay", true)

function huntSordaanWebweaverBetLostScreenPlay:start()
end

function huntSordaanWebweaverBetLostScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntSordaanWebweaverBetLostScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntSordaanWebweaverBetLostScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntSordaanWebweaverBetLostScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntSordaanWebweaverBetLostScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntSordaanWebweaverBetLostScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntSordaanWebweaverBetLostScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntSordaanWebweaverBetLostScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntSordaanWebweaverBetLostScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntSordaanWebweaverBetLostScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function huntSordaanWebweaverBetLostScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	if (self.maxStage == 1 and self.autoAward) then
		self:awardQuest(pPlayer)
		return true
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_sordaan_webweaver_bet_lost:journal_entry_title")
	return true
end

function huntSordaanWebweaverBetLostScreenPlay:raiseSignal(pPlayer, signalName)
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
	if (nxt > 1) then
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

function huntSordaanWebweaverBetLostScreenPlay:awardQuest(pPlayer)
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
