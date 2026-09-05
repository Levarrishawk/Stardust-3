--[[
	Athanlu's Cure  --  ep3_forest_athnalu_quest_2

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_athnalu_quest_2.qst and string/en/quest/ground/ep3_forest_athnalu_quest_2.stf.

	THE TASK TREE
		task 0  Nothing
		task 1  Destroy Multiple and Loot  LootItemName Mouf Hair x2 90%  [Athanlu's Cure]
		task 2  Destroy Multiple and Loot  LootItemName Snake Eye x2 80%  [Athanlu's Cure]
		task 3  Retrieve Item  object/tangible/quest/mysess_blossom.iff x1 has_iff=True  [Athanlu's Cure]
		task 8  Wait for Tasks  siblings
		task 4  Wait for Signal  Signal snakes
		task 6  Reward  credits 5000 item   [Reward Issued]

	OPEN
		Destroy-and-Loot Social Group forest_mouf has no lair mapping (not substituted)
		Destroy-and-Loot Social Group forest_snake has no lair mapping (not substituted)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_athnalu_quest_2.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[36][TIER_3] = 16533. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestAthnaluQuest2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestAthnaluQuest2ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
	killGroups = {
		{ key = "loot0", count = 2, pct = 90, templates = {} },
		{ key = "loot1", count = 2, pct = 80, templates = {} },
	},
	retrieves = {
		{ key = "r0", template = "object/tangible/quest/mysess_blossom.iff", count = 1, title = "@quest/ground/ep3_forest_athnalu_quest_2:task03_journal_entry_title" },
	},
	propX = -1679.6500,
	propZ = 31.6392,
	propY = 1325.8300,
}

registerScreenPlay("forestAthnaluQuest2ScreenPlay", true)

function forestAthnaluQuest2ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnProps()
	end
end

function forestAthnaluQuest2ScreenPlay:spawnProps()
	local z = getWorldFloor(self.propX, self.propY, "kashyyyk")
	if (z == nil or z == 0) then
		z = self.propZ
	end
	local n = 0
	for i = 1, #self.retrieves do
		local r = self.retrieves[i]
		if (r.template ~= nil and r.template ~= "") then
			for c = 1, r.count do
				n = n + 1
				local pObj = spawnSceneObject("kashyyyk", r.template, self.propX + (n * 1.5), z, self.propY + (n * 0.8), 0, 0)
				if (pObj ~= nil) then
					writeStringData(SceneObject(pObj):getObjectID() .. ":kashForestRet", r.key)
					SceneObject(pObj):setObjectMenuComponent("forestAthnaluQuest2ScreenPlayMenuComponent")
				end
			end
		end
	end
end

function forestAthnaluQuest2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestAthnaluQuest2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestAthnaluQuest2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestAthnaluQuest2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestAthnaluQuest2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot0")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot1")
	deleteScreenPlayData(pPlayer, self.screenplayName, "r0")
	self:setStage(pPlayer, 0)
end

function forestAthnaluQuest2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_athnalu_quest_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_athnalu_quest_2:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_athnalu_quest_2:task01_journal_entry_title")
	return true
end

function forestAthnaluQuest2ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_athnalu_quest_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestAthnaluQuest2ScreenPlay:signalSnakes(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestAthnaluQuest2ScreenPlay:signalTurnIn(pPlayer)
	return self:signalSnakes(pPlayer)
end

function forestAthnaluQuest2ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestAthnaluQuest2ScreenPlay:allWorkDone(pPlayer)
	for i = 1, #self.killGroups do
		local g = self.killGroups[i]
		local n = tonumber(readScreenPlayData(pPlayer, self.screenplayName, g.key)) or 0
		if (n < g.count) then
			return false
		end
	end
	for i = 1, #self.retrieves do
		local r = self.retrieves[i]
		local n = tonumber(readScreenPlayData(pPlayer, self.screenplayName, r.key)) or 0
		if (n < r.count) then
			return false
		end
	end
	return true
end

function forestAthnaluQuest2ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killGroups do
		local g = self.killGroups[i]
		for j = 1, #g.templates do
			if (g.templates[j] == name) then
				return true
			end
		end
	end
	return false
end

function forestAthnaluQuest2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestAthnaluQuest2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestAthnaluQuest2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestAthnaluQuest2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestAthnaluQuest2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	for i = 1, #self.killGroups do
		local g = self.killGroups[i]
		local hit = false
		for j = 1, #g.templates do
			if (g.templates[j] == victimTemplate) then
				hit = true
			end
		end
		if (hit) then
			if (getRandomNumber(100) > g.pct) then
				return 0
			end
			local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, g.key)) or 0) + 1
			writeScreenPlayData(pPlayer, self.screenplayName, g.key, tostring(n))
		end
	end
	if (self:allWorkDone(pPlayer)) then
		self:onWorkComplete(pPlayer)
	end
	return 0
end

function forestAthnaluQuest2ScreenPlay:getRadialText(pPlayer, key)
	if (self:getStage(pPlayer) ~= 1 or key == nil or key == "") then
		return nil
	end
	for i = 1, #self.retrieves do
		local r = self.retrieves[i]
		local n = tonumber(readScreenPlayData(pPlayer, self.screenplayName, r.key)) or 0
		if (r.key == key and n < r.count) then
			if (r.title ~= nil and r.title ~= "") then
				return r.title
			end
			return "@quest/ground/ep3_forest_athnalu_quest_2:journal_entry_title"
		end
	end
	return nil
end

function forestAthnaluQuest2ScreenPlay:collectProp(pPlayer, key)
	if (self:getRadialText(pPlayer, key) == nil) then
		return false
	end
	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, key, tostring(n))
	if (self:allWorkDone(pPlayer)) then
		self:onWorkComplete(pPlayer)
	end
	return true
end

forestAthnaluQuest2ScreenPlayMenuComponent = {}

function forestAthnaluQuest2ScreenPlayMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	local text = forestAthnaluQuest2ScreenPlay:getRadialText(pPlayer, key)
	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function forestAthnaluQuest2ScreenPlayMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end
	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	forestAthnaluQuest2ScreenPlay:collectProp(pPlayer, key)
	return 0
end

