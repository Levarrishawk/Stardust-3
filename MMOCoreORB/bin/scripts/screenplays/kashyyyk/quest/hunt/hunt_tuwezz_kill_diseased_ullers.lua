--[[
	journal_entry_title  --  ep3_hunt_tuwezz_kill_diseased_ullers

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_tuwezz_kill_diseased_ullers.qst and string/en/quest/ground/ep3_hunt_tuwezz_kill_diseased_ullers.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 1  d1  Wait for Signal  tuwezz_talkToTuwezz  signal tuwezz_talkToTuwezz
		task 3  d2  Destroy Multiple  tuwezz_huntingDiseasedUllers  Target ep3_etyyy_uller_diseased  Count 17
		task 5  d3  Wait for Signal  tuwezz_diseasedUllersDone  signal tuwezz_diseasedUllersDone

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[43][TIER_3] = 23403. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntTuwezzKillDiseasedUllersScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntTuwezzKillDiseasedUllersScreenPlay",
	questKey = "ep3_hunt_tuwezz_kill_diseased_ullers",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 17,
	lootDropPercent = 0,
	killStage = 2,
	maxStage = 3,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = { "uller_stoneclaw" },
	taskStages = { tuwezz_talkToTuwezz = 1,
		tuwezz_huntingDiseasedUllers = 2,
		tuwezz_diseasedUllersDone = 3 },
}

registerScreenPlay("huntTuwezzKillDiseasedUllersScreenPlay", true)

function huntTuwezzKillDiseasedUllersScreenPlay:start()
end

function huntTuwezzKillDiseasedUllersScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntTuwezzKillDiseasedUllersScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntTuwezzKillDiseasedUllersScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntTuwezzKillDiseasedUllersScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntTuwezzKillDiseasedUllersScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntTuwezzKillDiseasedUllersScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntTuwezzKillDiseasedUllersScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntTuwezzKillDiseasedUllersScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntTuwezzKillDiseasedUllersScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntTuwezzKillDiseasedUllersScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function huntTuwezzKillDiseasedUllersScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function huntTuwezzKillDiseasedUllersScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "huntTuwezzKillDiseasedUllersScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function huntTuwezzKillDiseasedUllersScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "huntTuwezzKillDiseasedUllersScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function huntTuwezzKillDiseasedUllersScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function huntTuwezzKillDiseasedUllersScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	if (self.maxStage == 1 and self.autoAward) then
		self:awardQuest(pPlayer)
		return true
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_tuwezz_kill_diseased_ullers:journal_entry_title")
	return true
end

function huntTuwezzKillDiseasedUllersScreenPlay:raiseSignal(pPlayer, signalName)
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

function huntTuwezzKillDiseasedUllersScreenPlay:awardQuest(pPlayer)
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

function huntTuwezzKillDiseasedUllersScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
