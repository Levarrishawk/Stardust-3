--[[
	journal_entry_title  --  ep3_hunt_kerssoc_bantha_pelts

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_kerssoc_bantha_pelts.qst and string/en/quest/ground/ep3_hunt_kerssoc_bantha_pelts.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 2  d1  Destroy Multiple and Loot  kerssoc_huntingBantha  CreatureType ep3_etyyy_bantha_kashyyyk  Social bantha_kashyyyk  Loot "Kashyyyk bantha pelt" x17 50%
		task 3  d2  Wait for Signal  kerssoc_kashyyykBanthaPelts  signal kerssoc_kashyyykBanthaPelts

	Uses an attackable hunting variant; decorative banthas remain unchanged.
	OPEN: LootItemName "Kashyyyk bantha pelt" has no object template; tracked as a per-player loot flag (chunk shape).

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[40][TIER_3] = 20257. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntKerssocBanthaPeltsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntKerssocBanthaPeltsScreenPlay",
	questKey = "ep3_hunt_kerssoc_bantha_pelts",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 17,
	lootDropPercent = 50,
	killStage = 1,
	maxStage = 2,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = { "kashyyyk_hunt_bantha", "kashyyyk_hunt_greyclimber" },
	taskStages = { kerssoc_huntingBantha = 1,
		kerssoc_kashyyykBanthaPelts = 2 },
}

registerScreenPlay("huntKerssocBanthaPeltsScreenPlay", true)

function huntKerssocBanthaPeltsScreenPlay:start()
end

function huntKerssocBanthaPeltsScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntKerssocBanthaPeltsScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntKerssocBanthaPeltsScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntKerssocBanthaPeltsScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntKerssocBanthaPeltsScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntKerssocBanthaPeltsScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntKerssocBanthaPeltsScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntKerssocBanthaPeltsScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntKerssocBanthaPeltsScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntKerssocBanthaPeltsScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function huntKerssocBanthaPeltsScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function huntKerssocBanthaPeltsScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "huntKerssocBanthaPeltsScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function huntKerssocBanthaPeltsScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "huntKerssocBanthaPeltsScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function huntKerssocBanthaPeltsScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function huntKerssocBanthaPeltsScreenPlay:grantQuest(pPlayer)
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
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_kerssoc_bantha_pelts:journal_entry_title")
	return true
end

function huntKerssocBanthaPeltsScreenPlay:raiseSignal(pPlayer, signalName)
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

function huntKerssocBanthaPeltsScreenPlay:awardQuest(pPlayer)
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

function huntKerssocBanthaPeltsScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	if (self.lootDropPercent > 0 and getRandomNumber(100) > self.lootDropPercent) then
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
