--[[
	Search for the Cure: Part I  --  ep3_forest_kerritamba_epic_1

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_kerritamba_epic_1.qst and string/en/quest/ground/ep3_forest_kerritamba_epic_1.stf.

	THE TASK TREE
		task 0  Nothing
		task 1  Retrieve Item  object/tangible/quest/pod_egg_sacs.iff x1 has_iff=True  [Gather an Urnsori's Egg Sample]
		task 2  Retrieve Item  object/tangible/quest/naktra_crystals.iff x1 has_iff=True  [Gather a Nak'tra Crystal Sample]
		task 3  Retrieve Item  object/tangible/quest/luilris_mushrooms.iff x1 has_iff=True  [Gather a Luilris Mushroom Sample]
		task 9  Wait for Tasks  siblings
		task 4  Wait for Signal  Signal steps
		task 7  Reward  credits 4000 item   [Reward Issued]

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_kerritamba_epic_1.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[35][TIER_3] = 15681. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestKerritambaEpic1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestKerritambaEpic1ScreenPlay",
	repeatable = false,
	rewardCredits = 4000,
	retrieves = {
		{ key = "r0", template = "object/tangible/quest/pod_egg_sacs.iff", count = 1, title = "@quest/ground/ep3_forest_kerritamba_epic_1:task01_journal_entry_title" },
		{ key = "r1", template = "object/tangible/quest/naktra_crystals.iff", count = 1, title = "@quest/ground/ep3_forest_kerritamba_epic_1:task02_journal_entry_title" },
		{ key = "r2", template = "object/tangible/quest/luilris_mushrooms.iff", count = 1, title = "@quest/ground/ep3_forest_kerritamba_epic_1:task03_journal_entry_title" },
	},
	propX = -1641.5200,
	propZ = 33.0841,
	propY = 1401.1500,
}

registerScreenPlay("forestKerritambaEpic1ScreenPlay", true)

function forestKerritambaEpic1ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnGiver()
		self:spawnProps()
	end
end

function forestKerritambaEpic1ScreenPlay:spawnGiver()
	local z = getWorldFloor(-1641.5200, 1401.1500, "kashyyyk")
	if (z == nil or z == 0) then
		z = 33.0841
	end
	spawnMobile("kashyyyk", "dressed_chief_kerritamba", 0, -1641.5200, z, 1401.1500, 218, 0)
end

function forestKerritambaEpic1ScreenPlay:spawnProps()
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
					SceneObject(pObj):setObjectMenuComponent("forestKerritambaEpic1ScreenPlayMenuComponent")
				end
			end
		end
	end
end

function forestKerritambaEpic1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestKerritambaEpic1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestKerritambaEpic1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestKerritambaEpic1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestKerritambaEpic1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	deleteScreenPlayData(pPlayer, self.screenplayName, "r0")
	deleteScreenPlayData(pPlayer, self.screenplayName, "r1")
	deleteScreenPlayData(pPlayer, self.screenplayName, "r2")
	self:setStage(pPlayer, 0)
end

function forestKerritambaEpic1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_1:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_1:task01_journal_entry_title")
	return true
end

function forestKerritambaEpic1ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_kerritamba_epic_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestKerritambaEpic1ScreenPlay:signalSteps(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestKerritambaEpic1ScreenPlay:signalTurnIn(pPlayer)
	return self:signalSteps(pPlayer)
end

function forestKerritambaEpic1ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
end

function forestKerritambaEpic1ScreenPlay:allWorkDone(pPlayer)
	for i = 1, #self.retrieves do
		local r = self.retrieves[i]
		local n = tonumber(readScreenPlayData(pPlayer, self.screenplayName, r.key)) or 0
		if (n < r.count) then
			return false
		end
	end
	return true
end

function forestKerritambaEpic1ScreenPlay:getRadialText(pPlayer, key)
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
			return "@quest/ground/ep3_forest_kerritamba_epic_1:journal_entry_title"
		end
	end
	return nil
end

function forestKerritambaEpic1ScreenPlay:collectProp(pPlayer, key)
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

forestKerritambaEpic1ScreenPlayMenuComponent = {}

function forestKerritambaEpic1ScreenPlayMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	local text = forestKerritambaEpic1ScreenPlay:getRadialText(pPlayer, key)
	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function forestKerritambaEpic1ScreenPlayMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end
	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	forestKerritambaEpic1ScreenPlay:collectProp(pPlayer, key)
	return 0
end

