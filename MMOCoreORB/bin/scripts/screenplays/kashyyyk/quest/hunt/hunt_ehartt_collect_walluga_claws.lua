--[[
	journal_entry_title  --  ep3_hunt_ehartt_collect_walluga_claws

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_ehartt_collect_walluga_claws.qst and string/en/quest/ground/ep3_hunt_ehartt_collect_walluga_claws.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 1  d1  Wait for Signal  ehartt_talkToEhartt  signal ehartt_speakWithEhartt
		task 4  d2  Destroy Multiple and Loot  ehartt_collectingWallugaClaws  Social walluga_etyyy  Loot "perfect walluga claws" x21 40%
		task 3  d3  Wait for Signal  ehartt_wallugaClaws  signal ehartt_wallugaClaws

	OPEN: pvpBitmask NONE on walluga; observer still matches
	OPEN: LootItemName "perfect walluga claws" has no object template; tracked as a per-player loot flag (chunk shape).

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[46][TIER_3] = 26906. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntEharttCollectWallugaClawsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntEharttCollectWallugaClawsScreenPlay",
	questKey = "ep3_hunt_ehartt_collect_walluga_claws",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 21,
	lootDropPercent = 40,
	killStage = 2,
	maxStage = 3,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = { "walluga" },
	taskStages = { ehartt_talkToEhartt = 1,
		ehartt_speakWithEhartt = 1,
		ehartt_collectingWallugaClaws = 2,
		ehartt_wallugaClaws = 3 },
}

registerScreenPlay("huntEharttCollectWallugaClawsScreenPlay", true)

function huntEharttCollectWallugaClawsScreenPlay:start()
end

function huntEharttCollectWallugaClawsScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntEharttCollectWallugaClawsScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntEharttCollectWallugaClawsScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntEharttCollectWallugaClawsScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntEharttCollectWallugaClawsScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntEharttCollectWallugaClawsScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntEharttCollectWallugaClawsScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntEharttCollectWallugaClawsScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntEharttCollectWallugaClawsScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntEharttCollectWallugaClawsScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function huntEharttCollectWallugaClawsScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function huntEharttCollectWallugaClawsScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "huntEharttCollectWallugaClawsScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function huntEharttCollectWallugaClawsScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "huntEharttCollectWallugaClawsScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function huntEharttCollectWallugaClawsScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function huntEharttCollectWallugaClawsScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	if (self.maxStage == 1 and self.autoAward) then
		self:awardQuest(pPlayer)
		return true
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_ehartt_collect_walluga_claws:journal_entry_title")
	return true
end

function huntEharttCollectWallugaClawsScreenPlay:raiseSignal(pPlayer, signalName)
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

	if (nxt == self.killStage or (self.killStage > 0 and nxt == 2)) then
		self:attachKillObserver(pPlayer)
	end
	return true
end

function huntEharttCollectWallugaClawsScreenPlay:awardQuest(pPlayer)
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

function huntEharttCollectWallugaClawsScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end
	if (self:getStage(pPlayer) ~= 2) then
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
		local nxt = 2 + 1
		if (nxt > 3) then
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
