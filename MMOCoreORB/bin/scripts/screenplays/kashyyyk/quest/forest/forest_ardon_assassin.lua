--[[
	ep3_forest_ardon_assassin  --  ep3_forest_ardon_assassin

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_ardon_assassin.qst and string/en/quest/ground/ep3_forest_ardon_assassin.stf.

	THE TASK TREE
		task 0  Timer  Min 60 Max 60
		task 1  Encounter  ep3_forest_kerritamba_assassin x3
		task 2  Immediately Complete Quest

	OPEN
		Encounter Creature Type ep3_forest_kerritamba_assassin has no repo template

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_ardon_assassin.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[1][TIER_-1] = 0. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

forestArdonAssassinScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestArdonAssassinScreenPlay",
	repeatable = true,
	rewardCredits = 0,
	encounters = {
		{ soe = "ep3_forest_kerritamba_assassin", template = "", count = 3, minDist = 5, maxDist = 10 },
	},
	timers = {
		{ min = 60, max = 60 },
	},
}

registerScreenPlay("forestArdonAssassinScreenPlay", true)

function forestArdonAssassinScreenPlay:start()
end

function forestArdonAssassinScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestArdonAssassinScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestArdonAssassinScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestArdonAssassinScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestArdonAssassinScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 0)
end

function forestArdonAssassinScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:startTimers(pPlayer)
	return true
end

function forestArdonAssassinScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_ardon_assassin")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestArdonAssassinScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestArdonAssassinScreenPlay:onWorkComplete(pPlayer)
	self:awardQuest(pPlayer)
end

function forestArdonAssassinScreenPlay:isKillTemplate(name)
	if (self.encounters ~= nil) then
		for i = 1, #self.encounters do
			if (self.encounters[i].template ~= nil and self.encounters[i].template == name) then
				return true
			end
		end
	end
	return false
end

function forestArdonAssassinScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestArdonAssassinScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestArdonAssassinScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestArdonAssassinScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestArdonAssassinScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

function forestArdonAssassinScreenPlay:startTimers(pPlayer)
	if (pPlayer == nil) then
		return
	end
	for i = 1, #self.timers do
		local t = self.timers[i]
		local ms = t.min * 1000
		createEvent(ms, "forestArdonAssassinScreenPlay", "onTimer", pPlayer, tostring(i))
	end
end

function forestArdonAssassinScreenPlay:onTimer(pPlayer, arg)
	if (pPlayer == nil or self:getStage(pPlayer) < 1) then
		return
	end
	local idx = tonumber(arg) or 1
	if (self.encounters ~= nil and self.encounters[idx] ~= nil) then
		self:spawnEncounter(pPlayer, self.encounters[idx])
	end
	self:attachKillObserver(pPlayer)
end

function forestArdonAssassinScreenPlay:spawnEncounter(pPlayer, enc)
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

