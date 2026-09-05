--[[
	Arena Challenge  --  ep3_forest_arena_epic_1

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_arena_epic_1.qst and string/en/quest/ground/ep3_forest_arena_epic_1.stf.

	THE TASK TREE
		task 1  Nothing
		task 2  Wait for Signal  Signal startfight
		task 3  Timer  Min 0 Max 0
		task 8  Encounter  ep3_forest_wirartu x1
		task 9  Wait for Signal  Signal 
		task 10  Reward  credits 0 item 
		task 11  Immediately Complete Quest
		task 4  Timer  Min 0 Max 0
		task 7  Encounter  ep3_cr_walluga x2
		task 5  Timer  Min 0 Max 0
		task 6  Encounter  ep3_forest_webweaver_gravespinner x3

	OPEN
		Encounter Creature Type ep3_forest_wirartu has no repo template
		Encounter Creature Type ep3_cr_walluga has no repo template

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_arena_epic_1.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[65][TIER_6] = 108427. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestArenaEpic1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestArenaEpic1ScreenPlay",
	repeatable = false,
	rewardCredits = 0,
	encounters = {
		{ soe = "ep3_forest_wirartu", template = "", count = 1, minDist = 5, maxDist = 10 },
		{ soe = "ep3_cr_walluga", template = "", count = 2, minDist = 5, maxDist = 10 },
		{ soe = "ep3_forest_webweaver_gravespinner", template = "webweaver", count = 3, minDist = 5, maxDist = 10 },
	},
	timers = {
		{ min = 0, max = 0 },
		{ min = 0, max = 0 },
		{ min = 0, max = 0 },
	},
}

registerScreenPlay("forestArenaEpic1ScreenPlay", true)

function forestArenaEpic1ScreenPlay:start()
end

function forestArenaEpic1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestArenaEpic1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestArenaEpic1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestArenaEpic1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestArenaEpic1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 0)
end

function forestArenaEpic1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_arena_epic_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_arena_epic_1:journal_entry_description")
	return true
end

function forestArenaEpic1ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_arena_epic_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestArenaEpic1ScreenPlay:signalStartfight(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:setStage(pPlayer, 3)
	self:startTimers(pPlayer)
	self:attachKillObserver(pPlayer)
	return true
end

function forestArenaEpic1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestArenaEpic1ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestArenaEpic1ScreenPlay:isKillTemplate(name)
	if (self.encounters ~= nil) then
		for i = 1, #self.encounters do
			if (self.encounters[i].template ~= nil and self.encounters[i].template == name) then
				return true
			end
		end
	end
	return false
end

function forestArenaEpic1ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestArenaEpic1ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestArenaEpic1ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestArenaEpic1ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestArenaEpic1ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	if (n >= 3) then
		self:onWorkComplete(pPlayer)
	end
	return 0
end

function forestArenaEpic1ScreenPlay:startTimers(pPlayer)
	if (pPlayer == nil) then
		return
	end
	for i = 1, #self.timers do
		local t = self.timers[i]
		local ms = t.min * 1000
		createEvent(ms, "forestArenaEpic1ScreenPlay", "onTimer", pPlayer, tostring(i))
	end
end

function forestArenaEpic1ScreenPlay:onTimer(pPlayer, arg)
	if (pPlayer == nil or self:getStage(pPlayer) < 1) then
		return
	end
	local idx = tonumber(arg) or 1
	if (self.encounters ~= nil and self.encounters[idx] ~= nil) then
		self:spawnEncounter(pPlayer, self.encounters[idx])
	end
	self:attachKillObserver(pPlayer)
end

function forestArenaEpic1ScreenPlay:spawnEncounter(pPlayer, enc)
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

