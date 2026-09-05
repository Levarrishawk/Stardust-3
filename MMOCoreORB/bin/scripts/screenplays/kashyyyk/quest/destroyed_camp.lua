--[[
	The Missing Researchers  --  ep3_kachirho_destroyed_camp

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	SOURCE: quest/ep3_kachirho_destroyed_camp.qst and string/en/quest/ground/ep3_kachirho_destroyed_camp.stf.

	THE TASK TREE (nested)
		task 0  Retrieve Item      kachirho_destroyed_camp.iff  (drum / "Canopy")
		task 1  Wait for Signal    huntResearchers  (radio)
		task 5  Retrieve Item      kachirho_qst_bag.iff
		task 6  Wait for Signal    huntCanopy  (radio)
		task 2  Destroy Multiple   Count 15, Social Group canopy_bandit
		task 4  Wait for Signal    codeReceived  (radio s_413 / doSignal03)
		task 7  Wait for Signal    codeEntered
			OPEN: no sealed-container object/radial in the repo. The radio
			java never raises codeEntered (doSignal03 is codeReceived only).
			Closest honest raise: the radio's final screen s_413, which is
			the only shipped line that states the code 25854. codeReceived
			advances the stage; s_413 then fires codeEntered for the award.

	Radio is kashyyyk_main row 1792 at wx=116.17, wz=813.43. static NPCs did not
	place this mobile (it is not a celebrity row); spawned here. Conversation table is
	conversation/destroyed_camp_radio (java c_stringFile), not in the 370-row dump.

	Kill templates (repo, no look-alikes): ep3_canopy_bandit_01..04 and
	ep3_canopy_reaper_01 (the lair headers). ep3_kachirho_canopy_cutthroat is OPEN
	(no repo template). The live lair currently only stands the reaper.

	Bag world origin was not in the transcription; spawned at the radio camp. OPEN placement.

	Giver conversation is attached to ep3_kachirho_qst_radio.

	NO JOURNAL: do not call Journal.*. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: quest_experience[27][TIER_3] = 9862. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

kachirhoDestroyedCampScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "kachirhoDestroyedCampScreenPlay",
	repeatable = false,
	killCount = 15,
	radioX = 116.17,
	radioZ = 11.4634,
	radioY = 813.43,
	drumTemplate = "object/tangible/quest/kachirho_destroyed_camp.iff",
	bagTemplate = "object/tangible/quest/kachirho_qst_bag.iff",
	killTemplates = {
		"ep3_canopy_bandit_01",
		"ep3_canopy_bandit_02",
		"ep3_canopy_bandit_03",
		"ep3_canopy_bandit_04",
		"ep3_canopy_reaper_01",
	},
}

registerScreenPlay("kachirhoDestroyedCampScreenPlay", true)

function kachirhoDestroyedCampScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnRadio()
		self:spawnProps()
	end
end

function kachirhoDestroyedCampScreenPlay:spawnRadio()
	local z = getWorldFloor(self.radioX, self.radioY, "kashyyyk")

	if (z == nil or z == 0) then
		z = self.radioZ
	end

	spawnMobile("kashyyyk", "ep3_kachirho_qst_radio", 0, self.radioX, z, self.radioY, 0, 0)
end

function kachirhoDestroyedCampScreenPlay:spawnProps()
	local z = getWorldFloor(self.radioX, self.radioY, "kashyyyk")

	if (z == nil or z == 0) then
		z = self.radioZ
	end

	local pDrum = spawnSceneObject("kashyyyk", self.drumTemplate, self.radioX + 2, z, self.radioY, 0, 0)

	if (pDrum ~= nil) then
		writeStringData(SceneObject(pDrum):getObjectID() .. ":kashCamp", "drum")
		SceneObject(pDrum):setObjectMenuComponent("KashDestroyedCampMenuComponent")
	end

	-- Bag: iff exists. Canopy-camp origin was not in the transcription. OPEN placement, radio camp.
	local pBag = spawnSceneObject("kashyyyk", self.bagTemplate, self.radioX - 2, z, self.radioY, 0, 0)

	if (pBag ~= nil) then
		writeStringData(SceneObject(pBag):getObjectID() .. ":kashCamp", "bag")
		SceneObject(pBag):setObjectMenuComponent("KashDestroyedCampMenuComponent")
	end
end

function kachirhoDestroyedCampScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kachirhoDestroyedCampScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function kachirhoDestroyedCampScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function kachirhoDestroyedCampScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function kachirhoDestroyedCampScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function kachirhoDestroyedCampScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "drum")
	deleteScreenPlayData(pPlayer, self.screenplayName, "bag")
	self:setStage(pPlayer, 0)
end

function kachirhoDestroyedCampScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task00_journal_entry_title")

	return true
end

function kachirhoDestroyedCampScreenPlay:signalHuntResearchers(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:setStage(pPlayer, 3)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task02_journal_entry_title")

	return true
end

function kachirhoDestroyedCampScreenPlay:signalHuntCanopy(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 4) then
		return false
	end

	self:setStage(pPlayer, 5)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task04_journal_entry_title")

	return true
end

function kachirhoDestroyedCampScreenPlay:signalCodeReceived(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 6) then
		return false
	end

	self:setStage(pPlayer, 7)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task06_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task06_journal_entry_description")

	return true
end

function kachirhoDestroyedCampScreenPlay:signalCodeEntered(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 7) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_kachirho_destroyed_camp")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

	return true
end

function kachirhoDestroyedCampScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function kachirhoDestroyedCampScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "kachirhoDestroyedCampScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function kachirhoDestroyedCampScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "kachirhoDestroyedCampScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function kachirhoDestroyedCampScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 5) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil or not self:isKillTemplate(victimTemplate)) then
		return 0
	end

	local kills = self:getKills(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(kills))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task04_journal_entry_title")

	if (kills >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 6)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task05_journal_entry_title")
	end

	return 0
end

function kachirhoDestroyedCampScreenPlay:getRadialText(pPlayer, role)
	local stage = self:getStage(pPlayer)

	if (role == "drum" and stage == 1 and tonumber(readScreenPlayData(pPlayer, self.screenplayName, "drum")) ~= 1) then
		return "@quest/ground/ep3_kachirho_destroyed_camp:task00_journal_entry_title"
	end

	if (role == "bag" and stage == 3 and tonumber(readScreenPlayData(pPlayer, self.screenplayName, "bag")) ~= 1) then
		return "@quest/ground/ep3_kachirho_destroyed_camp:task02_journal_entry_title"
	end

	return nil
end

function kachirhoDestroyedCampScreenPlay:collectProp(pPlayer, role)
	if (self:getRadialText(pPlayer, role) == nil) then
		return false
	end

	if (role == "drum") then
		writeScreenPlayData(pPlayer, self.screenplayName, "drum", "1")
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task00_item_name")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task01_journal_entry_title")
	elseif (role == "bag") then
		writeScreenPlayData(pPlayer, self.screenplayName, "bag", "1")
		self:setStage(pPlayer, 4)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task02_item_name")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_destroyed_camp:task03_journal_entry_title")
	end

	return true
end

KashDestroyedCampMenuComponent = {}

function KashDestroyedCampMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashCamp")
	local text = kachirhoDestroyedCampScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function KashDestroyedCampMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kashCamp")

	kachirhoDestroyedCampScreenPlay:collectProp(pPlayer, role)

	return 0
end
