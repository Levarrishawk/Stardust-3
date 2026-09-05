--[[
	Injured Wirartu  --  ep3_forest_kerritamba_epic_7

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_kerritamba_epic_7.qst and string/en/quest/ground/ep3_forest_kerritamba_epic_7.stf.

	THE TASK TREE
		task 0  Nothing
		task 1  Retrieve Item  object/tangible/quest/mysess_blossom.iff x1 has_iff=True  [Injured Wirartu]
		task 2  Destroy Multiple and Loot  LootItemName Bag of Dust x1 40%  [Injured Wirartu]
		task 6  Wait for Tasks  siblings
		task 3  Wait for Signal  Signal alldone
		task 4  Reward  credits 3000 item   [Reward Issued]

	Kill/encounter templates that ship pvpBitmask NONE (observer still matches):
		dressed_sayormi_witch, dressed_sayormi_witch_01, dressed_sayormi_witch_02, dressed_sayormi_witch_03, dressed_sayormi_witch_04, dressed_sayormi_witch_05, dressed_sayormi_witch_06, dressed_sayormi_witch_07
		repo template ships pvpBitmask NONE; observer still matches (Kachirho lobarorr shape)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_kerritamba_epic_7.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[35][TIER_3] = 15681. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestKerritambaEpic7ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestKerritambaEpic7ScreenPlay",
	repeatable = false,
	rewardCredits = 3000,
	killCount = 1,
	lootDropPercent = 40,
	killTemplates = {
		"dressed_sayormi_witch",
		"dressed_sayormi_witch_01",
		"dressed_sayormi_witch_02",
		"dressed_sayormi_witch_03",
		"dressed_sayormi_witch_04",
		"dressed_sayormi_witch_05",
		"dressed_sayormi_witch_06",
		"dressed_sayormi_witch_07",
	},
	retrieves = {
		{ key = "r0", template = "object/tangible/quest/mysess_blossom.iff", count = 1, title = "@quest/ground/ep3_forest_kerritamba_epic_7:task01_journal_entry_title" },
	},
	propX = -1616.6300,
	propZ = 31.9644,
	propY = 1332.1700,
}

registerScreenPlay("forestKerritambaEpic7ScreenPlay", true)

function forestKerritambaEpic7ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnProps()
	end
end

function forestKerritambaEpic7ScreenPlay:spawnProps()
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
					SceneObject(pObj):setObjectMenuComponent("forestKerritambaEpic7ScreenPlayMenuComponent")
				end
			end
		end
	end
end

function forestKerritambaEpic7ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestKerritambaEpic7ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestKerritambaEpic7ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestKerritambaEpic7ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestKerritambaEpic7ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "r0")
	self:setStage(pPlayer, 0)
end

function forestKerritambaEpic7ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_7:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_7:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_7:task01_journal_entry_title")
	return true
end

function forestKerritambaEpic7ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_kerritamba_epic_7")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestKerritambaEpic7ScreenPlay:signalAlldone(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestKerritambaEpic7ScreenPlay:signalTurnIn(pPlayer)
	return self:signalAlldone(pPlayer)
end

function forestKerritambaEpic7ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
	self:detachKillObserver(pPlayer)
end

function forestKerritambaEpic7ScreenPlay:allWorkDone(pPlayer)
	local n = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
	if (n < self.killCount) then
		return false
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

function forestKerritambaEpic7ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function forestKerritambaEpic7ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestKerritambaEpic7ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestKerritambaEpic7ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestKerritambaEpic7ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestKerritambaEpic7ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	if (getRandomNumber(100) > self.lootDropPercent) then
		return 0
	end
	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(n))
	if (self:allWorkDone(pPlayer)) then
		self:onWorkComplete(pPlayer)
	end
	return 0
end

function forestKerritambaEpic7ScreenPlay:getRadialText(pPlayer, key)
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
			return "@quest/ground/ep3_forest_kerritamba_epic_7:journal_entry_title"
		end
	end
	return nil
end

function forestKerritambaEpic7ScreenPlay:collectProp(pPlayer, key)
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

forestKerritambaEpic7ScreenPlayMenuComponent = {}

function forestKerritambaEpic7ScreenPlayMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	local text = forestKerritambaEpic7ScreenPlay:getRadialText(pPlayer, key)
	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function forestKerritambaEpic7ScreenPlayMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end
	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	forestKerritambaEpic7ScreenPlay:collectProp(pPlayer, key)
	return 0
end

