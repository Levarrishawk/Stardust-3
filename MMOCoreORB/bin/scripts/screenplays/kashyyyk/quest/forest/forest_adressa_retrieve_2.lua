--[[
	Adressa's Antidote  --  ep3_forest_adressa_retrieve_2

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_adressa_retrieve_2.qst and string/en/quest/ground/ep3_forest_adressa_retrieve_2.stf.

	THE TASK TREE
		task 3  Nothing
		task 4  Destroy Multiple and Loot  LootItemName Spider Venom x1 100%  [Adressa's Antidote]
		task 5  Retrieve Item  Mysess Blossom x1 has_iff=False  [Adressa's Antidote]

	OPEN
		Retrieve Item Mysess Blossom has no Server Object Template (name-only; chunk flag not used — no kill source)

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_adressa_retrieve_2.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[0][TIER_0] = 0. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

forestAdressaRetrieve2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestAdressaRetrieve2ScreenPlay",
	repeatable = true,
	rewardCredits = 0,
	killCount = 1,
	lootDropPercent = 100,
	killTemplates = {},
	retrieves = {
		{ key = "r0", template = "", count = 1, title = "" },
	},
}

registerScreenPlay("forestAdressaRetrieve2ScreenPlay", true)

function forestAdressaRetrieve2ScreenPlay:start()
end

function forestAdressaRetrieve2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestAdressaRetrieve2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestAdressaRetrieve2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestAdressaRetrieve2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestAdressaRetrieve2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "r0")
	self:setStage(pPlayer, 0)
end

function forestAdressaRetrieve2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_adressa_retrieve_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_adressa_retrieve_2:journal_entry_description")
	return true
end

function forestAdressaRetrieve2ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_adressa_retrieve_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestAdressaRetrieve2ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestAdressaRetrieve2ScreenPlay:onWorkComplete(pPlayer)
	self:awardQuest(pPlayer)
end

function forestAdressaRetrieve2ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function forestAdressaRetrieve2ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "forestAdressaRetrieve2ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function forestAdressaRetrieve2ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "forestAdressaRetrieve2ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function forestAdressaRetrieve2ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

function forestAdressaRetrieve2ScreenPlay:getRadialText(pPlayer, key)
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
			return "@quest/ground/ep3_forest_adressa_retrieve_2:journal_entry_title"
		end
	end
	return nil
end

function forestAdressaRetrieve2ScreenPlay:collectProp(pPlayer, key)
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

forestAdressaRetrieve2ScreenPlayMenuComponent = {}

function forestAdressaRetrieve2ScreenPlayMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	local text = forestAdressaRetrieve2ScreenPlay:getRadialText(pPlayer, key)
	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function forestAdressaRetrieve2ScreenPlayMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end
	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end
	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashForestRet")
	forestAdressaRetrieve2ScreenPlay:collectProp(pPlayer, key)
	return 0
end

