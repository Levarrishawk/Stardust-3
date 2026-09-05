--[[
	journal_entry_title  --  ep3_hunt_manfred_kill_chiss_leader

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_manfred_kill_chiss_leader.qst and string/en/quest/ground/ep3_hunt_manfred_kill_chiss_leader.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 1  d1  Destroy Multiple  manfred_killingChissLeader  Target ep3_etyyy_chiss_poacher_laen_pieweto  Count 1
		task 2  d2  Wait for Signal  manfred_killedChissLeader  signal manfred_killedChissLeader

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[47][TIER_4] = 35976. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntManfredKillChissLeaderScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntManfredKillChissLeaderScreenPlay",
	questKey = "ep3_hunt_manfred_kill_chiss_leader",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 1,
	lootDropPercent = 0,
	killStage = 1,
	maxStage = 2,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = { "ep3_etyyy_laen_pieweto" },
	taskStages = { manfred_killingChissLeader = 1,
		manfred_killedChissLeader = 2 },
}

registerScreenPlay("huntManfredKillChissLeaderScreenPlay", true)

function huntManfredKillChissLeaderScreenPlay:start()
end

function huntManfredKillChissLeaderScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntManfredKillChissLeaderScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntManfredKillChissLeaderScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntManfredKillChissLeaderScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntManfredKillChissLeaderScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntManfredKillChissLeaderScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntManfredKillChissLeaderScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntManfredKillChissLeaderScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntManfredKillChissLeaderScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntManfredKillChissLeaderScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function huntManfredKillChissLeaderScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function huntManfredKillChissLeaderScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "huntManfredKillChissLeaderScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function huntManfredKillChissLeaderScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "huntManfredKillChissLeaderScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function huntManfredKillChissLeaderScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function huntManfredKillChissLeaderScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	if (self.maxStage == 1 and self.autoAward) then
		self:awardQuest(pPlayer)
		return true
	end

	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_manfred_kill_chiss_leader:journal_entry_title")
	return true
end

function huntManfredKillChissLeaderScreenPlay:raiseSignal(pPlayer, signalName)
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

	if (nxt == self.killStage or (self.killStage > 0 and nxt == 1)) then
		self:attachKillObserver(pPlayer)
	end
	return true
end

function huntManfredKillChissLeaderScreenPlay:awardQuest(pPlayer)
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

function huntManfredKillChissLeaderScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	local kills = self:getKills(pPlayer) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(kills))
	if (kills >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:markTask(pPlayer, "")
		local nxt = 1 + 1
		if (nxt > 2) then
			if (self.clearOnFinish) then
				self:clearQuest(pPlayer)
			else
				self:awardQuest(pPlayer)
			end
		else
			self:setStage(pPlayer, nxt)
		end
	end
	return 0
end
