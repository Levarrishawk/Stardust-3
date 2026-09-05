--[[
	Grunt Work: Part III  --  ep3_forest_aveso_quest_3

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_aveso_quest_3.qst and string/en/quest/ground/ep3_forest_aveso_quest_3.stf.

	THE TASK TREE
		task 0  Escort  [Grunt Work: Part III]
		task 5  Timer  Min 60 Max 60
		task 6  Encounter  ep3_forest_kerritamba_assassin x1
		task 1  Go to Location
		task 2  Wait for Signal  Signal escort
		task 3  Reward  credits 0 item 
		task 4  Immediately Complete Quest

	OPEN
		Escort — Core3 has no SOE escort destination (Planet tatooine 0,0,0); not faked
		Encounter Creature Type ep3_forest_kerritamba_assassin has no repo template
		Go to Location is tatooine 0,0,0 (editor default) — OPEN, no area spawned

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_aveso_quest_3.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[37][TIER_3] = 17424. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestAvesoQuest3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestAvesoQuest3ScreenPlay",
	repeatable = false,
	rewardCredits = 0,
	encounters = {
		{ soe = "ep3_forest_kerritamba_assassin", template = "", count = 1, minDist = 5, maxDist = 50 },
	},
	timers = {
		{ min = 60, max = 60 },
	},
}

registerScreenPlay("forestAvesoQuest3ScreenPlay", true)

function forestAvesoQuest3ScreenPlay:start()
end

function forestAvesoQuest3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestAvesoQuest3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestAvesoQuest3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestAvesoQuest3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestAvesoQuest3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 0)
end

function forestAvesoQuest3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_aveso_quest_3:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_aveso_quest_3:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_aveso_quest_3:task00_journal_entry_title")
	return true
end

function forestAvesoQuest3ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_aveso_quest_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestAvesoQuest3ScreenPlay:signalEscort(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestAvesoQuest3ScreenPlay:signalTurnIn(pPlayer)
	return self:signalEscort(pPlayer)
end

function forestAvesoQuest3ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestAvesoQuest3ScreenPlay:isKillTemplate(name)
	if (self.encounters ~= nil) then
		for i = 1, #self.encounters do
			if (self.encounters[i].template ~= nil and self.encounters[i].template == name) then
				return true
			end
		end
	end
	return false
end

function forestAvesoQuest3ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestAvesoQuest3ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestAvesoQuest3ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestAvesoQuest3ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestAvesoQuest3ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	return 0
end

function forestAvesoQuest3ScreenPlay:startTimers(pPlayer)
	if (pPlayer == nil) then
		return
	end
	for i = 1, #self.timers do
		local t = self.timers[i]
		local ms = t.min * 1000
		createEvent(ms, "forestAvesoQuest3ScreenPlay", "onTimer", pPlayer, tostring(i))
	end
end

function forestAvesoQuest3ScreenPlay:onTimer(pPlayer, arg)
	if (pPlayer == nil or self:getStage(pPlayer) < 1) then
		return
	end
	local idx = tonumber(arg) or 1
	if (self.encounters ~= nil and self.encounters[idx] ~= nil) then
		self:spawnEncounter(pPlayer, self.encounters[idx])
	end
	self:attachKillObserver(pPlayer)
end

function forestAvesoQuest3ScreenPlay:spawnEncounter(pPlayer, enc)
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

