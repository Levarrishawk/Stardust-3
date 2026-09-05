--[[
	journal_entry_title  --  ep3_hunt_johnson_retrieve_ryoos_stash

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_johnson_retrieve_ryoos_stash.qst and string/en/quest/ground/ep3_hunt_johnson_retrieve_ryoos_stash.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 1  d1  Wait for Signal  johnson_talkToRyoo  signal johnson_talkToRyoo
		task 2  d2  Retrieve Item  johnson_findRyoosStash  object/tangible/quest/etyyy_ryoos_salt.iff
		task 3  d3  Wait for Signal  johnson_ryoosSalt  signal johnson_ryoosSalt

	OPEN: Retrieve Item spawned; world origin was not in the transcription. OPEN placement near the giver.

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[45][TIER_2] = 18563. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntJohnsonRetrieveRyoosStashScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntJohnsonRetrieveRyoosStashScreenPlay",
	questKey = "ep3_hunt_johnson_retrieve_ryoos_stash",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 0,
	lootDropPercent = 0,
	killStage = 0,
	maxStage = 3,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 1,
	retrieveTemplate = "object/tangible/quest/etyyy_ryoos_salt.iff",
	killTemplates = {  },
	taskStages = { johnson_talkToRyoo = 1,
		johnson_findRyoosStash = 2,
		johnson_ryoosSalt = 3 },
}

registerScreenPlay("huntJohnsonRetrieveRyoosStashScreenPlay", true)

function huntJohnsonRetrieveRyoosStashScreenPlay:start()
end

function huntJohnsonRetrieveRyoosStashScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntJohnsonRetrieveRyoosStashScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntJohnsonRetrieveRyoosStashScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntJohnsonRetrieveRyoosStashScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntJohnsonRetrieveRyoosStashScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntJohnsonRetrieveRyoosStashScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntJohnsonRetrieveRyoosStashScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntJohnsonRetrieveRyoosStashScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntJohnsonRetrieveRyoosStashScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntJohnsonRetrieveRyoosStashScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "retrieved")
	self:setStage(pPlayer, 0)
end

function huntJohnsonRetrieveRyoosStashScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	if (self.maxStage == 1 and self.autoAward) then
		self:awardQuest(pPlayer)
		return true
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_johnson_retrieve_ryoos_stash:journal_entry_title")
	return true
end

function huntJohnsonRetrieveRyoosStashScreenPlay:raiseSignal(pPlayer, signalName)
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

function huntJohnsonRetrieveRyoosStashScreenPlay:awardQuest(pPlayer)
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

function huntJohnsonRetrieveRyoosStashScreenPlay:getRetrieveCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "retrieved")) or 0
end

function huntJohnsonRetrieveRyoosStashScreenPlay:collectRetrieve(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	local n = self:getRetrieveCount(pPlayer) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "retrieved", tostring(n))
	if (n >= self.retrieveCount) then
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
	return true
end

function huntJohnsonRetrieveRyoosStashScreenPlay:start()
	if (isZoneEnabled("kashyyyk") and self.retrieveTemplate ~= "") then
		self:spawnRetrieves()
	end
end

function huntJohnsonRetrieveRyoosStashScreenPlay:spawnRetrieves()
	-- OPEN placement: giver transcription has no world origin for this iff. Ring near Ryoo Finn.
	local cx, cz, cy = -614.96, 8.7683, -2148.77
	for i = 1, self.retrieveCount do
		local ang = (i / self.retrieveCount) * 6.28318
		local x = cx + 12 * math.cos(ang)
		local y = cy + 12 * math.sin(ang)
		local z = getWorldFloor(x, y, "kashyyyk")
		if (z == nil or z == 0) then
			z = cz
		end
		local pObj = spawnSceneObject("kashyyyk", self.retrieveTemplate, x, z, y, 0, 0)
		if (pObj ~= nil) then
			SceneObject(pObj):setObjectMenuComponent("EtyyyHuntRetrieveMenuComponent")
			writeStringData(SceneObject(pObj):getObjectID() .. ":etyyyHuntRetrieve", self.screenplayName)
		end
	end
end
