--[[
	The Road to Exemplar: The Final Battle  --  ep3_forest_dahlia_epic_4

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_dahlia_epic_4.qst and string/en/quest/ground/ep3_forest_dahlia_epic_4.stf.

	THE TASK TREE
		task 0  Nothing
		task 1  Timer  Min 120 Max 120
		task 4  Encounter  ep3_forest_kerritamba_leader x1
		task 5  Wait for Signal  Signal win
		task 6  Reward  credits 5000 item   [Reward Issued]
		task 2  Timer  Min 10 Max 10
		task 3  Encounter  ep3_forest_kerritamba_warrior x5

	OPEN
		Encounter Creature Type ep3_forest_kerritamba_leader has no repo template

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_dahlia_epic_4.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[39][TIER_4] = 24640. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestDahliaEpic4ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestDahliaEpic4ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
	encounters = {
		{ soe = "ep3_forest_kerritamba_leader", template = "", count = 1, minDist = 5, maxDist = 10 },
		{ soe = "ep3_forest_kerritamba_warrior", template = "dressed_ep3_forest_kerritamba_warrior", count = 5, minDist = 5, maxDist = 10 },
	},
	timers = {
		{ min = 120, max = 120 },
		{ min = 10, max = 10 },
	},
}

registerScreenPlay("forestDahliaEpic4ScreenPlay", true)

function forestDahliaEpic4ScreenPlay:start()
end

function forestDahliaEpic4ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestDahliaEpic4ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestDahliaEpic4ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestDahliaEpic4ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestDahliaEpic4ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 0)
end

function forestDahliaEpic4ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_dahlia_epic_4:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_dahlia_epic_4:journal_entry_description")
	return true
end

function forestDahliaEpic4ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_dahlia_epic_4")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestDahliaEpic4ScreenPlay:signalWin(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestDahliaEpic4ScreenPlay:signalTurnIn(pPlayer)
	return self:signalWin(pPlayer)
end

function forestDahliaEpic4ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestDahliaEpic4ScreenPlay:isKillTemplate(name)
	if (self.encounters ~= nil) then
		for i = 1, #self.encounters do
			if (self.encounters[i].template ~= nil and self.encounters[i].template == name) then
				return true
			end
		end
	end
	return false
end

function forestDahliaEpic4ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestDahliaEpic4ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestDahliaEpic4ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestDahliaEpic4ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestDahliaEpic4ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(n))
	if (n >= 5) then
		self:onWorkComplete(pPlayer)
	end
	return 0
end

function forestDahliaEpic4ScreenPlay:startTimers(pPlayer)
	if (pPlayer == nil) then
		return
	end
	for i = 1, #self.timers do
		local t = self.timers[i]
		local ms = t.min * 1000
		createEvent(ms, "forestDahliaEpic4ScreenPlay", "onTimer", pPlayer, tostring(i))
	end
end

function forestDahliaEpic4ScreenPlay:onTimer(pPlayer, arg)
	if (pPlayer == nil or self:getStage(pPlayer) < 1) then
		return
	end
	local idx = tonumber(arg) or 1
	if (self.encounters ~= nil and self.encounters[idx] ~= nil) then
		self:spawnEncounter(pPlayer, self.encounters[idx])
	end
	self:attachKillObserver(pPlayer)
end

function forestDahliaEpic4ScreenPlay:spawnEncounter(pPlayer, enc)
	if (enc.template == nil or enc.template == "") then
		return
	end
	local zone = SceneObject(pPlayer):getZoneName()
	local x = SceneObject(pPlayer):getWorldPositionX()
	local y = SceneObject(pPlayer):getWorldPositionY()
	local z = SceneObject(pPlayer):getWorldPositionZ()
	for i = 1, enc.count do
		local dx = getRandomNumber(enc.minDist, enc.maxDist)
		local dy = getRandomNumber(enc.minDist, enc.maxDist)
		if (getRandomNumber(1, 2) == 1) then
			dx = 0 - dx
		end
		if (getRandomNumber(1, 2) == 1) then
			dy = 0 - dy
		end
		spawnMobile(zone, enc.template, 0, x + dx, z, y + dy, 0, 0)
	end
end

