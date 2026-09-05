--[[
	Deadwood Moss  --  ep3_forest_perusta_quest_1

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_perusta_quest_1.qst and string/en/quest/ground/ep3_forest_perusta_quest_1.stf.

	THE TASK TREE
		task 0  Retrieve Item  object/tangible/quest/dead_forest_stump.iff x5 has_iff=True  [Deadwood Moss]
		task 1  Wait for Signal  Signal moss
		task 2  Reward  credits 5000 item   [Reward Issued]

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_perusta_quest_1.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[35][TIER_3] = 15681. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestPerustaQuest1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestPerustaQuest1ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
	retrieves = {
		{ key = "r0", template = "object/tangible/quest/dead_forest_stump.iff", count = 5, title = "@quest/ground/ep3_forest_perusta_quest_1:task00_journal_entry_title" },
	},
	propX = -1686.7100,
	propZ = 31.6392,
	propY = 1382.3900,
}

registerScreenPlay("forestPerustaQuest1ScreenPlay", true)

function forestPerustaQuest1ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnGiver()
		self:spawnProps()
	end
end

function forestPerustaQuest1ScreenPlay:spawnGiver()
	local z = getWorldFloor(-1686.7100, 1382.3900, "kashyyyk")
	if (z == nil or z == 0) then
		z = 31.6392
	end
	spawnMobile("kashyyyk", "dressed_shoartu_mystic_03", 0, -1686.7100, z, 1382.3900, 135, 0)
end

function forestPerustaQuest1ScreenPlay:spawnProps()
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
					SceneObject(pObj):setObjectMenuComponent("forestPerustaQuest1ScreenPlayMenuComponent")
				end
			end
		end
	end
end

function forestPerustaQuest1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestPerustaQuest1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestPerustaQuest1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestPerustaQuest1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestPerustaQuest1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	deleteScreenPlayData(pPlayer, self.screenplayName, "r0")
	self:setStage(pPlayer, 0)
end

function forestPerustaQuest1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_perusta_quest_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_perusta_quest_1:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_perusta_quest_1:task00_journal_entry_title")
	return true
end

function forestPerustaQuest1ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_perusta_quest_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestPerustaQuest1ScreenPlay:signalMoss(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestPerustaQuest1ScreenPlay:signalTurnIn(pPlayer)
	return self:signalMoss(pPlayer)
end

function forestPerustaQuest1ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
end

function forestPerustaQuest1ScreenPlay:getRadialText(pPlayer, key)
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
			return "@quest/ground/ep3_forest_perusta_quest_1:journal_entry_title"
		end
	end
	return nil
end

function forestPerustaQuest1ScreenPlay:collectProp(pPlayer, key)
	if (self:getRadialText(pPlayer, key) == nil) then
		return false
	end
	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, key, tostring(n))
	local r
	for i = 1, #self.retrieves do
		if (self.retrieves[i].key == key) then
			r = self.retrieves[i]
		end
	end
	if (r ~= nil and n >= r.count) then
		self:onWorkComplete(pPlayer)
	end
	return true
end

forestPerustaQuest1ScreenPlayMenuComponent = {}

function forestPerustaQuest1ScreenPlayMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	local text = forestPerustaQuest1ScreenPlay:getRadialText(pPlayer, key)
	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function forestPerustaQuest1ScreenPlayMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end
	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	forestPerustaQuest1ScreenPlay:collectProp(pPlayer, key)
	return 0
end

