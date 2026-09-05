--[[
	Arena Challenge: Face Wirartu  --  ep3_forest_wirartu_epic_1

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_wirartu_epic_1.qst and string/en/quest/ground/ep3_forest_wirartu_epic_1.stf.

	THE TASK TREE
		task 0  Nothing  [Arena Challenge: Face Wirartu]
		task 11  Wait for Signal  Signal startfight
		task 4  Timer  Min 10 Max 10
		task 6  Encounter  ep3_arena_webweaver_bonerender x4
		task 3  Timer  Min 70 Max 70
		task 7  Encounter  ep3_arena_uller_hellstalker x3
		task 2  Timer  Min 150 Max 150
		task 8  Encounter  ep3_arena_varactyl_venomblade x1
		task 1  Timer  Min 310 Max 310
		task 5  Encounter  ep3_forest_wirartu x1
		task 9  Wait for Signal  Signal wirartu

	OPEN
		Encounter Creature Type ep3_arena_webweaver_bonerender has no repo template
		Encounter Creature Type ep3_arena_uller_hellstalker has no repo template
		Encounter Creature Type ep3_arena_varactyl_venomblade has no repo template
		Encounter Creature Type ep3_forest_wirartu has no repo template

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_wirartu_epic_1.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[65][TIER_5] = 91999. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

forestWirartuEpic1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestWirartuEpic1ScreenPlay",
	repeatable = true,
	rewardCredits = 0,
	encounters = {
		{ soe = "ep3_arena_webweaver_bonerender", template = "", count = 4, minDist = 5, maxDist = 10 },
		{ soe = "ep3_arena_uller_hellstalker", template = "", count = 3, minDist = 5, maxDist = 10 },
		{ soe = "ep3_arena_varactyl_venomblade", template = "", count = 1, minDist = 5, maxDist = 10 },
		{ soe = "ep3_forest_wirartu", template = "", count = 1, minDist = 5, maxDist = 10 },
	},
	timers = {
		{ min = 10, max = 10 },
		{ min = 70, max = 70 },
		{ min = 150, max = 150 },
		{ min = 310, max = 310 },
	},
}

registerScreenPlay("forestWirartuEpic1ScreenPlay", true)

function forestWirartuEpic1ScreenPlay:start()
end

function forestWirartuEpic1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestWirartuEpic1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestWirartuEpic1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestWirartuEpic1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestWirartuEpic1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 0)
end

function forestWirartuEpic1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_wirartu_epic_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_wirartu_epic_1:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_wirartu_epic_1:task00_journal_entry_title")
	return true
end

function forestWirartuEpic1ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_wirartu_epic_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestWirartuEpic1ScreenPlay:signalStartfight(pPlayer)
	-- grantQuest writes stage 1. The .qst Wait-for-Signal startfight is the
	-- next task, then the 10/70/150/310-second encounter chain. Accept the
	-- granted state and advance into the timer state.
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:setStage(pPlayer, 3)
	self:startTimers(pPlayer)
	self:attachKillObserver(pPlayer)
	return true
end

function forestWirartuEpic1ScreenPlay:signalWirartu(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestWirartuEpic1ScreenPlay:signalTurnIn(pPlayer)
	return self:signalWirartu(pPlayer)
end

function forestWirartuEpic1ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestWirartuEpic1ScreenPlay:isKillTemplate(name)
	if (self.encounters ~= nil) then
		for i = 1, #self.encounters do
			if (self.encounters[i].template ~= nil and self.encounters[i].template == name) then
				return true
			end
		end
	end
	return false
end

function forestWirartuEpic1ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestWirartuEpic1ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestWirartuEpic1ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestWirartuEpic1ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestWirartuEpic1ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end
	if (self:getStage(pPlayer) ~= 3) then
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

function forestWirartuEpic1ScreenPlay:startTimers(pPlayer)
	if (pPlayer == nil) then
		return
	end
	for i = 1, #self.timers do
		local t = self.timers[i]
		local ms = t.min * 1000
		createEvent(ms, "forestWirartuEpic1ScreenPlay", "onTimer", pPlayer, tostring(i))
	end
end

function forestWirartuEpic1ScreenPlay:onTimer(pPlayer, arg)
	if (pPlayer == nil or self:getStage(pPlayer) < 1) then
		return
	end
	local idx = tonumber(arg) or 1
	if (self.encounters ~= nil and self.encounters[idx] ~= nil) then
		self:spawnEncounter(pPlayer, self.encounters[idx])
	end
	self:attachKillObserver(pPlayer)
end

function forestWirartuEpic1ScreenPlay:spawnEncounter(pPlayer, enc)
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

