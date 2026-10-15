local KashyyykQuestJournal = require("screenplays.kashyyyk.quest.kashyyyk_quest_journal")

--[[
	Trandoshan Hunting Rifle  --  ep3_kachirho_trando_rifle_crafting

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	SOURCE: quest/ep3_kachirho_trando_rifle_crafting.qst and
	string/en/quest/ground/ep3_kachirho_trando_rifle_crafting.stf.

	THE TASK TREE
		task 0  Nothing
		task 4  Wait for Signal    questionLolo  -- Lolo conversation
		task 6  Craft Item         object/weapon/ranged/rifle/rifle_faux_bowcaster.iff  Count 1
		task 5  Wait for Signal    completeKressik  -- Kressik turn-in / schematic

	Givers ep3_trando_kressik and ep3_wke_lolo have no buildout row (SOE script spawn).
	Quest text: "Lolo has a little shop in Kachirho" -- no coordinates. Placement OPEN;
	not spawned here. Kressik carries ep3_trando_kressik_convo. Lolo carries
	ep3_wke_lolo_convotemplate (space inspect).
	The attached space conversation also includes the ground screens and handler.

	OPEN: the quest cannot progress past questionLolo until Lolo is placed. Do not
	bypass him. Kressik's bowcaster turn-in requires the Lolo stage to have been
	reached and the craft stage to be active. A bowcaster presented earlier is
	refused with the conversation's own refusal screen (s_16 / s_24).

	Craft Item: accept rifle_faux_bowcaster.iff on Kressik turn-in at the craft
	stage (getContainerObjectByTemplate). grantRifleSchematic hands
	object/tangible/loot/loot/schematic/trandoshan_hunter_rifle_schematic.iff
	(repo template). Barrel schematic grant is OPEN (no distinct barrel loot schematic).

	Space inspect ep3_wke_bowcaster_crafting is granted by the attached Lolo
	handler. grantSpaceMission here records the ground quest's dialogue progress.

	Journal stages mirror the existing screenplay state through KashyyykQuestJournal.

	XP: quest_experience[30][TIER_3] = 11842. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
]]

kachirhoTrandoRifleCraftingScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "kachirhoTrandoRifleCraftingScreenPlay",
	repeatable = true,
	bowcasterTemplate = "object/weapon/ranged/rifle/rifle_faux_bowcaster.iff",
	rifleSchematic = "object/tangible/loot/loot/schematic/trandoshan_hunter_rifle_schematic.iff",
}

registerScreenPlay("kachirhoTrandoRifleCraftingScreenPlay", true)

function kachirhoTrandoRifleCraftingScreenPlay:start()
end

function kachirhoTrandoRifleCraftingScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kachirhoTrandoRifleCraftingScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	KashyyykQuestJournal.sync(self, pPlayer, stage)
end

function kachirhoTrandoRifleCraftingScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function kachirhoTrandoRifleCraftingScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function kachirhoTrandoRifleCraftingScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	KashyyykQuestJournal.clear(self, pPlayer)

	dropObserver(PROTOTYPECREATED, self.screenplayName, "notifyBowcasterCrafted", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "lolo")
	deleteScreenPlayData(pPlayer, self.screenplayName, "space")
	deleteScreenPlayData(pPlayer, self.screenplayName, "pieces")
	self:setStage(pPlayer, 0)
end

function kachirhoTrandoRifleCraftingScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	KashyyykQuestJournal.begin(self, pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_trando_rifle_crafting:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_trando_rifle_crafting:task01_journal_entry_title")

	return true
end

function kachirhoTrandoRifleCraftingScreenPlay:signalQuestionLolo(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "lolo", "1")
	self:setStage(pPlayer, 2)
	self:attachCraftObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_trando_rifle_crafting:task02_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_trando_rifle_crafting:task02_journal_entry_description")

	return true
end

function kachirhoTrandoRifleCraftingScreenPlay:grantSpaceMission(pPlayer)
	if (pPlayer == nil) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "space", "1")

	-- Space inspect is already granted by Ep3WkeLoloConvoHandler when that tree is live.
	-- The ground Lolo tree records the dialogue; the attached handler starts the space mission.
	if (self:getStage(pPlayer) == 1) then
		self:signalQuestionLolo(pPlayer)
	end
end

function kachirhoTrandoRifleCraftingScreenPlay:grantBarrelSchematic(pPlayer)
	-- OPEN: no distinct barrel loot schematic in the repo.
	if (pPlayer ~= nil) then
		writeScreenPlayData(pPlayer, self.screenplayName, "pieces", "1")
	end
end

function kachirhoTrandoRifleCraftingScreenPlay:hasCompletedLolo(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function kachirhoTrandoRifleCraftingScreenPlay:hasBowcasterPieces(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "pieces")) == 1
end

function kachirhoTrandoRifleCraftingScreenPlay:hasFailedSpace(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "space")) == 1 and self:getStage(pPlayer) == 2 and not self:hasBowcaster(pPlayer)
end

function kachirhoTrandoRifleCraftingScreenPlay:hasBowcaster(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return false
	end

	local pItem = getContainerObjectByTemplate(pInventory, self.bowcasterTemplate, true)

	return pItem ~= nil
end

function kachirhoTrandoRifleCraftingScreenPlay:canTurnInBowcaster(pPlayer)
	local ready = self:getStage(pPlayer) == 2 and self:hasBowcaster(pPlayer)
	if (ready) then KashyyykQuestJournal.sync(self, pPlayer, 2) end
	return ready
end

function kachirhoTrandoRifleCraftingScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or not self:canTurnInBowcaster(pPlayer)) then
		return false
	end

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
	local pItem = getContainerObjectByTemplate(pInventory, self.bowcasterTemplate, true)

	if (pItem ~= nil) then
		SceneObject(pItem):destroyObjectFromWorld()
		SceneObject(pItem):destroyObjectFromDatabase()
	end

	if (pInventory ~= nil) then
		giveItem(pInventory, self.rifleSchematic, -1, true)
	end

	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_sucess.snd")
	KashyyykQuestJournal.complete(self, pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_kachirho_trando_rifle_crafting")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

	return true
end

function kachirhoTrandoRifleCraftingScreenPlay:attachCraftObserver(pPlayer)
	dropObserver(PROTOTYPECREATED, self.screenplayName, "notifyBowcasterCrafted", pPlayer)
	createObserver(PROTOTYPECREATED, self.screenplayName, "notifyBowcasterCrafted", pPlayer, 1)
end

function kachirhoTrandoRifleCraftingScreenPlay:notifyBowcasterCrafted(pPlayer, pItem, practice)
	if (pPlayer == nil or pItem == nil or practice == 1) then return 0 end
	if (self:getStage(pPlayer) ~= 2) then return 1 end
	if (SceneObject(pItem):getTemplateObjectPath() ~= self.bowcasterTemplate) then return 0 end
	KashyyykQuestJournal.crafted(self, pPlayer)
	return 1
end
