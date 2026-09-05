--[[
	Search for the Cure: Part II  --  ep3_forest_kerritamba_epic_2

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_kerritamba_epic_2.qst and string/en/quest/ground/ep3_forest_kerritamba_epic_2.stf.

	THE TASK TREE
		task 0  Nothing
		task 2  Destroy Multiple and Loot  LootItemName Osera Seed x1 70%  [Find an Osera Seed]
		task 3  Destroy Multiple and Loot  LootItemName Ranrt Crystal x1 70%  [Find a Ranrt Crystal]
		task 4  Retrieve Item  object/tangible/quest/mysess_blossom.iff x1 has_iff=True  [Gather a Mysess Blossom]
		task 8  Destroy Multiple and Loot  LootItemName Webweaver Silk x1 50%  [Find Webweaver Silk]
		task 9  Wait for Tasks  siblings
		task 5  Wait for Signal  Signal curestuff
		task 6  Reward  credits 0 item   [Reward Issued]

	OPEN
		Destroy-and-Loot Social Group forest_mouf has no lair mapping (not substituted)

	Kill/encounter templates that ship pvpBitmask NONE (observer still matches):
		dressed_sayormi_witch, dressed_sayormi_witch_01, dressed_sayormi_witch_02, dressed_sayormi_witch_03, dressed_sayormi_witch_04, dressed_sayormi_witch_05, dressed_sayormi_witch_06, dressed_sayormi_witch_07, webweaver
		repo template ships pvpBitmask NONE; observer still matches (Kachirho lobarorr shape)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_kerritamba_epic_2.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[35][TIER_4] = 20037. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestKerritambaEpic2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestKerritambaEpic2ScreenPlay",
	repeatable = false,
	rewardCredits = 0,
	killGroups = {
		{ key = "loot0", count = 1, pct = 70, templates = {} },
		{ key = "loot1", count = 1, pct = 70, templates = {
			"dressed_sayormi_witch",
			"dressed_sayormi_witch_01",
			"dressed_sayormi_witch_02",
			"dressed_sayormi_witch_03",
			"dressed_sayormi_witch_04",
			"dressed_sayormi_witch_05",
			"dressed_sayormi_witch_06",
			"dressed_sayormi_witch_07",
		} },
		{ key = "loot2", count = 1, pct = 50, templates = {
			"webweaver",
		} },
	},
	retrieves = {
		{ key = "r0", template = "object/tangible/quest/mysess_blossom.iff", count = 1, title = "@quest/ground/ep3_forest_kerritamba_epic_2:task04_journal_entry_title" },
	},
	propX = -1641.5200,
	propZ = 33.0841,
	propY = 1401.1500,
}

registerScreenPlay("forestKerritambaEpic2ScreenPlay", true)

function forestKerritambaEpic2ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnProps()
	end
end

function forestKerritambaEpic2ScreenPlay:spawnProps()
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
					SceneObject(pObj):setObjectMenuComponent("forestKerritambaEpic2ScreenPlayMenuComponent")
				end
			end
		end
	end
end

function forestKerritambaEpic2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestKerritambaEpic2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestKerritambaEpic2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestKerritambaEpic2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestKerritambaEpic2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot0")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot1")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot2")
	deleteScreenPlayData(pPlayer, self.screenplayName, "r0")
	self:setStage(pPlayer, 0)
end

function forestKerritambaEpic2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_2:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_2:task02_journal_entry_title")
	return true
end

function forestKerritambaEpic2ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_kerritamba_epic_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestKerritambaEpic2ScreenPlay:signalCurestuff(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestKerritambaEpic2ScreenPlay:signalTurnIn(pPlayer)
	return self:signalCurestuff(pPlayer)
end

function forestKerritambaEpic2ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestKerritambaEpic2ScreenPlay:allWorkDone(pPlayer)
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

function forestKerritambaEpic2ScreenPlay:isKillTemplate(name)
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

function forestKerritambaEpic2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestKerritambaEpic2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestKerritambaEpic2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestKerritambaEpic2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestKerritambaEpic2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

function forestKerritambaEpic2ScreenPlay:getRadialText(pPlayer, key)
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
			return "@quest/ground/ep3_forest_kerritamba_epic_2:journal_entry_title"
		end
	end
	return nil
end

function forestKerritambaEpic2ScreenPlay:collectProp(pPlayer, key)
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

forestKerritambaEpic2ScreenPlayMenuComponent = {}

function forestKerritambaEpic2ScreenPlayMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	local text = forestKerritambaEpic2ScreenPlay:getRadialText(pPlayer, key)
	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function forestKerritambaEpic2ScreenPlayMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end
	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	forestKerritambaEpic2ScreenPlay:collectProp(pPlayer, key)
	return 0
end

