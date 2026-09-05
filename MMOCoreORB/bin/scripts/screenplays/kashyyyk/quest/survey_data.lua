--[[
	Collecting Survery Data  --  ep3_kachirho_survey_data

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	SOURCE: quest/ep3_kachirho_survey_data.qst and string/en/quest/ground/ep3_kachirho_survey_data.stf.
	Title spelling "Survery" is shipped.

	THE TASK TREE
		task 0-4  Retrieve Item   survey_data.iff .. survey_data_05.iff  Count 1, LootDropPercent 100
		task 5    Wait for Signal dataReward  -- conversation turn-in
		task 6    Reward          Bank Credits 10000

	Devices are spawned at the five kashyyyk_main buildout rows (ox/oz 4096):
		survey_data     wx=-794.36  z=18.8235  wz=240.92
		survey_data_02  wx=203.66   z=18.9309  wz=-410.51
		survey_data_03  wx=317.66   z=20.5981  wz=53.65
		survey_data_04  wx=-78.7    z=21.0     wz=813.81
		survey_data_05  wx=-312.61  z=5.65853  wz=602.07

	Giver ep3_dr_farnsworth already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: do not call Journal.*. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: quest_experience[27][TIER_2] = 7123. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
]]

kachirhoSurveyDataScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "kachirhoSurveyDataScreenPlay",
	repeatable = true,
	rewardCredits = 10000,
	devices = {
		{ template = "object/tangible/quest/survey_data.iff",    x = -794.36, z = 18.8235, y = 240.92,  key = "d0", title = "@quest/ground/ep3_kachirho_survey_data:task00_journal_entry_title" },
		{ template = "object/tangible/quest/survey_data_02.iff", x = 203.66,  z = 18.9309, y = -410.51, key = "d1", title = "@quest/ground/ep3_kachirho_survey_data:task01_journal_entry_title" },
		{ template = "object/tangible/quest/survey_data_03.iff", x = 317.66,  z = 20.5981, y = 53.65,   key = "d2", title = "@quest/ground/ep3_kachirho_survey_data:task02_journal_entry_title" },
		{ template = "object/tangible/quest/survey_data_04.iff", x = -78.7,   z = 21.0,    y = 813.81,  key = "d3", title = "@quest/ground/ep3_kachirho_survey_data:task03_journal_entry_title" },
		{ template = "object/tangible/quest/survey_data_05.iff", x = -312.61, z = 5.65853, y = 602.07,  key = "d4", title = "@quest/ground/ep3_kachirho_survey_data:task04_journal_entry_title" },
	},
}

registerScreenPlay("kachirhoSurveyDataScreenPlay", true)

function kachirhoSurveyDataScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnDevices()
	end
end

function kachirhoSurveyDataScreenPlay:spawnDevices()
	for i = 1, #self.devices do
		local d = self.devices[i]
		local z = getWorldFloor(d.x, d.y, "kashyyyk")

		if (z == nil or z == 0) then
			z = d.z
		end

		local pObj = spawnSceneObject("kashyyyk", d.template, d.x, z, d.y, 0, 0)

		if (pObj ~= nil) then
			writeStringData(SceneObject(pObj):getObjectID() .. ":kashSurvey", d.key)
			SceneObject(pObj):setObjectMenuComponent("KashSurveyDataMenuComponent")
		end
	end
end

function kachirhoSurveyDataScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kachirhoSurveyDataScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function kachirhoSurveyDataScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function kachirhoSurveyDataScreenPlay:hasDevice(pPlayer, key)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) == 1
end

function kachirhoSurveyDataScreenPlay:deviceCount(pPlayer)
	local n = 0

	for i = 1, #self.devices do
		if (self:hasDevice(pPlayer, self.devices[i].key)) then
			n = n + 1
		end
	end

	return n
end

function kachirhoSurveyDataScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function kachirhoSurveyDataScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	for i = 1, #self.devices do
		deleteScreenPlayData(pPlayer, self.screenplayName, self.devices[i].key)
	end

	self:setStage(pPlayer, 0)
end

function kachirhoSurveyDataScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_survey_data:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_survey_data:task00_journal_entry_title")

	return true
end

function kachirhoSurveyDataScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_kachirho_survey_data")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

	return true
end

function kachirhoSurveyDataScreenPlay:getRadialText(pPlayer, key)
	if (self:getStage(pPlayer) ~= 1 or key == nil or key == "") then
		return nil
	end

	for i = 1, #self.devices do
		if (self.devices[i].key == key and not self:hasDevice(pPlayer, key)) then
			return self.devices[i].title
		end
	end

	return nil
end

function kachirhoSurveyDataScreenPlay:collectDevice(pPlayer, key)
	if (self:getRadialText(pPlayer, key) == nil) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_survey_data:task00_item_name")

	if (self:deviceCount(pPlayer) >= #self.devices) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_survey_data:task05_journal_entry_title")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_survey_data:task05_journal_entry_description")
	end

	return true
end

KashSurveyDataMenuComponent = {}

function KashSurveyDataMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashSurvey")
	local text = kachirhoSurveyDataScreenPlay:getRadialText(pPlayer, key)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function KashSurveyDataMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local key = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashSurvey")

	kachirhoSurveyDataScreenPlay:collectDevice(pPlayer, key)

	return 0
end
