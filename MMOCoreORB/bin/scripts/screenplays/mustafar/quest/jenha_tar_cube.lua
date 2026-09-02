--[[
Symbols of Chu-Gon Dar  --  som_jenha_tar_cube

SOURCE OF RECORD

quest/som_jenha_tar_cube.qst in the client TREs, cross-checked against
string/en/quest/ground/som_jenha_tar_cube.stf. Every title, description, task
name, signal name, coordinate, radius, count, radial text, item name and reward
template below is quoted from one of those two files. The .stf carries eleven
rows -- category, journal_entry_title/description, task00/01/02 title and
description, task01_item_name, task01_retrieve_menu_text, task02_waypoint_name --
and every one of them is byte-identical to the .qst attribute it mirrors, so
nothing here had to be reconciled.

THE TASK TREE, transcribed

	task 0  Go to Location      taskName find_ruins
	                            "Find the Ruins"
	                            Planet mustafar, LocationX -2578, LocationY 147,
	                            LocationZ -30, Radius(m) 50
	                            createWaypoint FALSE
	                            musicOnActivate mus_mustafar_quest_exception.snd
	 task 1 Retrieve Item       taskName take_notes
	                            "Locate the Tablets"
	                            Server Object Template
	                              object/tangible/quest/som_cube_rune_tablet.iff
	                            Count 3, ItemName "Tablet notes",
	                            LootDropPercent 100,
	                            retrieveMenuText "Copy tablet"
	  task 2 Wait for Signal    taskName return_notes
	                            "Return the Notes"
	                            Signal Name somCubeSuccess
	                            createWaypoint TRUE, Planet mustafar,
	                            LocationX -2444, LocationY 218, LocationZ 1760
	                            waypointName "Ithes Olok"
	                            buildingCellName small_room_04
	                            interiorWaypointAppearance mustafar
	   task 3 Reward            Item object/tangible/container/loot/som_cube.iff
	                            CountItem 1, Bank Credits 0,
	                            musicOnComplete mus_mustafar_quest_success.snd
	    task 4 Reward           Item .../cube_loot/cube_loot_0a.iff, CountItem 1
	     task 5 Reward          Item .../cube_loot/cube_loot_0b.iff, CountItem 1
	      task 6 Reward         Item .../cube_loot/cube_loot_0c.iff, CountItem 1

The four Reward tasks are nested one inside the next with Bank Credits 0 and
Experience Amount 0 on every one, which is the .qst editor's way of handing over
four items in a row; they are one payout here.

The quest <list> says journalEntryTitle "Symbols of Chu-Gon Dar", category
Mustafar, Level 1, Tier 1, Experience Type quest_general, Experience Amount 0,
completeWhenTasksComplete true and -- alone among these four Mustafar ports --
allowRepeats FALSE. So this one runs once per character and canGrantQuest below
refuses a second run.

CHAINED OR INDEPENDENT

Independent. grantQuestOnComplete, grantQuestOnFail, prerequisiteQuests,
exclusionQuests, prerequisiteTasks, exclusionTasks,
conditionalQuestGrantQuestsThatMustBeCompleted and
conditionalQuestGrantQuestToGive are present on every task in the file and every
one of them is empty. Nothing grants this quest and this quest grants nothing.

WHERE THE TABLETS COME FROM

Nothing is spawned. snapshot/mustafar.ws inside stardust_03.tre already places
three som_cube_rune_tablet nodes, and PlanetManagerImplementation::
loadSnapshotObject() instantiates each snapshot node with objectID == the node
ID, so getSceneObject(<nodeID>) returns the object the client is already drawing.
Spawning copies would double them.

	node 12112287  object/tangible/quest/shared_som_cube_rune_tablet.iff
	               x = -2550.05  z = 147.88  y = -48.09
	node 12112288  object/tangible/quest/shared_som_cube_rune_tablet.iff
	               x = -2543.34  z = 147.88  y = -4.39
	node 12112289  object/tangible/quest/shared_som_cube_rune_tablet.iff
	               x = -2618.79  z = 152.77  y = -45.46

All three carry parent 0 and cell 0, so they stand in the open world, and all
three fall inside the .qst's 50 m circle about (-2578, -30): 33.3 m, 43.1 m and
43.6 m out. Three placed tablets against a Count of 3 is the whole of task 1, so
each one is copied once and the third copy finishes the task.

(.ws stores x / height / z. Core3's spawn and waypoint calls take x, z, y with z
as the height, so a .ws triple maps across unchanged in that order. The .qst
stores the same thing under LocationX / LocationY / LocationZ with LocationY as
the height, which is why the ruins circle below reads x -2578, z 147, y -30.)

The ordering that makes the attach safe: ZoneServerImplementation::start() runs
startGroundZones(), which blocks until every zone reports hasManagersStarted()
and PlanetManager::initialize() has called loadSnapshotObjects(), strictly before
startManagers() reaches startGlobalScreenPlays(). Snapshot objects exist before
any screenplay start() runs.

THE RADIAL

Task 1's retrieveMenuText "Copy tablet" only appears in live while that task is
running. There is no quest journal here (see NO JOURNAL), so each tablet gets a
Lua ObjectMenuComponent that offers "Copy tablet" only to a player whose stored
stage says the tablets are the live step and who has not already copied that
tablet. Everyone else sees the object's ordinary radial.

THE RETURN WAYPOINT  --  what is and is not modelled

Task 2 is the only task in the file with createWaypoint true. Its coordinates
(-2444, 218, 1760) and its waypointName "Ithes Olok" are honoured exactly. Its
buildingCellName small_room_04 and interiorWaypointAppearance mustafar are NOT:
LuaPlayerObject::addWaypoint takes a planet name and a world position and has no
cell argument, so the waypoint is planted at the world coordinates the .qst
gives. Both fields are recorded on returnTask below so the day an interior
waypoint is possible the data is already here.

THE REWARD  --  one shipped path does not resolve, and it is not silently swapped

	object/tangible/container/loot/som_cube.iff
	  registered, object/custom_content/tangible/container/loot/som_cube.lua:5.
	  Used exactly as the .qst writes it.

	object/tangible/loot/mustafar/cube_loot/cube_loot_0a.iff  (and _0b, _0c)
	  NOT registered at that path. The server template files exist --
	  object/custom_content/tangible/loot/mustafar/cube_loot/cube_loot_0a.lua and
	  its two siblings, all three included from that directory's
	  serverobjects.lua -- but line 5 of each registers the object under

	      object/tangible/loot/mustafar/cube/loot/cube_loot_0a.iff

	  with "cube_loot" split into "cube/loot". The client template is registered
	  correctly at object/tangible/loot/mustafar/cube_loot/shared_cube_loot_0a.iff
	  (that directory's objects.lua:5), and the server template inherits
	  clientTemplateFileName from it, so the object built from the odd path still
	  draws the right thing -- TemplateManager::addTemplate reads
	  clientTemplateFileName off the Lua table (TemplateManager.cpp:456) and only
	  uses the registration string as the lookup key.

	  So the objects granted below are the same three objects the .qst asks for;
	  only the string used to find them differs. They are addressed by their
	  registered path, and this is flagged rather than swapped: the one-line fix
	  is in cube_loot_0a/0b/0c.lua, which is not this port's file to change.

All four reward items have a shipped display name. They are not tow items, so
they are not in static_item_n.stf; each one's shared client template names the
table string/en/som/som_cube.stf, which ships in mtg_patch_019.tre and
mtg_planets.tre:

    som_cube      -> cube_n          "Chu-Gon Dar Cube"
    cube_loot_0a  -> cube_loot_0a_n  "a barely glowing old cup"
    cube_loot_0b  -> cube_loot_0b_n  "a barely glowing datapad"
    cube_loot_0c  -> cube_loot_0c_n  "a barely glowing worklight"

Nothing here needs to name them itself -- the client resolves each object's own
objectName. The hand-over messages name the quest, not the items.

THE GIVER

The .qst names Doctor Olok in three of its descriptions and its waypoint, and
string/en/conversation/som_cube_ithes_olok.stf carries his whole dialogue tree.
The tree and handler are wired; this file places him:

  * npc_ithes_olok is a registered creature (mobile/custom_content/som/
    npc_ithes_olok.lua, included at that directory's serverobjects.lua:89,
    customName "Ithes Olok"). conversationTemplate is "som_cube_ithes_olok";
    the tree ships at mobile/conversations/mustafar/som_cube_ithes_olok.lua.
  * There is no quest_start object for this quest in snapshot/mustafar.ws. The
    moon carries exactly three quest_start nodes, the same three in stardust_03
    and in mtg_patch_023, and all three belong to Kenobi quests:
      12110146  shared_som_kenobi_hidden_treasure_plaque       (36.53, 4387.13)
      12111454  shared_som_kenobi_reunite_shard             (-4385.03, 3165.60)
      12112643  shared_som_kenobi_symbiosis_fluid_container  (-1551.38,  467.68)
    mtg_planets and mtg_patch_022 carry none.
  * His cell and position are the live server's. The facility's dungeon spawn
    table posts him in small_room_04 at (-23.7, 19.1, -6.1) facing 79, and that
    is what questGiver now carries. The room name is resolved by name rather
    than by cellID arithmetic, because +N node arithmetic is wrong for this
    building -- the cell node run has gaps at 12112233 and 12112239 -- but for
    the record small_room_04 is 12112238.
  * An earlier revision derived the position instead: it subtracted the .qst
    return waypoint (-2444, 218, 1760) from snapshot building 12112217's origin
    (-2420.500, 199.403, 1767.080), which is valid arithmetic because that
    building has an identity quaternion, and took floor height 19.07 off
    must_mining_facility.ilf. It landed within a tenth on x, a metre out on y,
    and guessed heading 0. The derivation is kept here because it is the method
    to fall back on for any NPC the live table does not cover; it is not the
    source for this one.

grantQuest and signalReturnNotes are the seams the giver's conversation handler
calls. signalReturnNotes IS the somCubeSuccess signal -- the .qst raises it from
the hand-in conversation, and there is no other way for it to be raised.

NO JOURNAL

som_jenha_tar_cube has no row in datatables/player/quests.iff. The table the
server loads is stardust_03.tre's, which wins the TreFiles order in
conf/config.lua; its 307 rows contain no Mustafar entries but the 45 exploration
markers. Adding a row would mean authoring a TRE. So progress lives in persistent
screenplay data on the player, and the journal text goes out as system messages,
the same as bounty_hunts.lua and map_exploration.lua. No id is added to
managers/quest/quest_manager.lua, because an id with no table row does nothing.

Every task in the file carries showSystemMessages true except the four Reward
tasks, which say 0; the Reward tasks have no journal text of their own, so that
flag costs nothing here and is honoured by having no reward chatter beyond the
hand-over lines.
--]]

somJenhaTarCubeScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "somJenhaTarCubeScreenPlay",

	-- [list] journalEntryTitle / journalEntryDescription / Level / Tier /
	-- allowRepeats / category.
	questTitle = "Symbols of Chu-Gon Dar",
	questDescription = "Doctor Ithes Olok has asked you to help gather data for his research. In exchange for your assistance, he has offered to share some of his findings with you.",
	questLevel = 1,
	questTier = 1,
	repeatable = false,

	-- task 0 musicOnActivate, task 3 musicOnComplete.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst. The tablet counter has no shipped sound; this is the one
	-- map_exploration.lua:412 uses for its own counters.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	-- task 0, Go to Location. createWaypoint is false in the .qst, so no waypoint
	-- is handed out for this leg; the player is told to travel south and finds it.
	ruins = {
		taskName = "find_ruins",
		title = "Find the Ruins",
		description = "Doctor Olok has given you a general idea about where the Old Republic ruins are located. Travel south of the mining facility and see if you can find the exact location of the ruins.",
		x = -2578,
		z = 147,
		y = -30,
		radius = 50,
	},

	-- task 1, Retrieve Item.
	tabletTask = {
		taskName = "take_notes",
		title = "Locate the Tablets",
		description = "You need to locate and copy down the three ancient tablets that are found somewhere around the Old Republic ruins.",
		template = "object/tangible/quest/som_cube_rune_tablet.iff",
		count = 3,
		itemName = "Tablet notes",
		lootDropPercent = 100,
		radialText = "Copy tablet",
	},

	-- The three snapshot nodes; see WHERE THE TABLETS COME FROM.
	tabletNodes = { 12112287, 12112288, 12112289 },

	-- task 2, Wait for Signal.
	returnTask = {
		taskName = "return_notes",
		title = "Return the Notes",
		description = "Return to Doctor Olok and give him the notes that you copied from the Old Republic ruins.",
		signal = "somCubeSuccess",
		x = -2444,
		z = 218,
		y = 1760,
		waypointName = "Ithes Olok",
		-- Recorded, not modelled; addWaypoint has no cell argument.
		buildingCellName = "small_room_04",
		interiorWaypointAppearance = "mustafar",
	},

	-- tasks 3 to 6, in the order the .qst nests them. som_cube is addressed by the
	-- path the .qst writes; the three cube_loot items are addressed by the path
	-- they are actually registered under. See THE REWARD.
	rewardItems = {
		"object/tangible/container/loot/som_cube.iff",
		"object/tangible/loot/mustafar/cube/loot/cube_loot_0a.iff",
		"object/tangible/loot/mustafar/cube/loot/cube_loot_0b.iff",
		"object/tangible/loot/mustafar/cube/loot/cube_loot_0c.iff",
	},

	-- THE GIVER. Cell and position are the live server's, not derived: the facility
	-- dungeon spawn table posts him in small_room_04 facing 79. An earlier revision
	-- subtracted the .qst waypoint from the building origin and guessed heading 0;
	-- it was close on x but a metre out on y and had him facing the wrong way.
	-- small_room_04 is cell 12112238. See THE GIVER in the header.
	questGiver = {
		template = "npc_ithes_olok",
		buildingID = 12112217,
		cellName = "small_room_04",
		x = -23.7,
		z = 19.1,
		y = -6.1,
		heading = 79,
	},

	-- Built by attachTablets on every boot. In-memory only, which is correct: it
	-- is derived from placements and the placements are re-attached each start.
	tabletIndex = {},

	ruinsAreaID = 0,
	questGiverID = 0,
}

registerScreenPlay("somJenhaTarCubeScreenPlay", true)

function somJenhaTarCubeScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachTablets()
		self:spawnRuinsArea()
		self:spawnGiver()
	end
end

function somJenhaTarCubeScreenPlay:spawnGiver()
	local giver = self.questGiver
	local pBuilding = getSceneObject(giver.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("somJenhaTarCubeScreenPlay: building " .. giver.buildingID .. " is missing; Doctor Olok cannot be placed and the quest cannot be started")
		return
	end

	local pCell = BuildingObject(pBuilding):getNamedCell(giver.cellName)

	if (pCell == nil) then
		print("somJenhaTarCubeScreenPlay: building " .. giver.buildingID .. " has no cell named " .. giver.cellName .. "; Doctor Olok cannot be placed")
		return
	end

	local pNpc = spawnMobile("mustafar", giver.template, 0, giver.x, giver.z, giver.y, giver.heading, SceneObject(pCell):getObjectID())

	if (pNpc == nil) then
		print("somJenhaTarCubeScreenPlay: failed to spawn " .. giver.template .. "; the quest cannot be started")
	else
		self.questGiverID = SceneObject(pNpc):getObjectID()
	end
end

function somJenhaTarCubeScreenPlay:attachTablets()
	self.tabletIndex = {}

	for i = 1, #self.tabletNodes do
		local nodeID = self.tabletNodes[i]
		local pTablet = getSceneObject(nodeID)

		if (pTablet == nil) then
			print("somJenhaTarCubeScreenPlay: snapshot tablet " .. nodeID .. " was not found; that copy will be unreachable")
		else
			self.tabletIndex[nodeID] = i
			SceneObject(pTablet):setObjectMenuComponent("SomJenhaTarCubeMenuComponent")
		end
	end
end

-- task 0, Go to Location: Radius(m) 50 about mustafar (-2578, 147, -30).
function somJenhaTarCubeScreenPlay:spawnRuinsArea()
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.ruins.x, self.ruins.z, self.ruins.y, self.ruins.radius, 0)

	if (pArea == nil) then
		print("somJenhaTarCubeScreenPlay: failed to spawn the ruins arrival area")
		return
	end

	self.ruinsAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "somJenhaTarCubeScreenPlay", "notifyEnteredRuins", pArea)
end

--[[ State

Persistent screenplay data on the player, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0" throughout.

	stage        0  not started
	             1  task 0 live -- find the ruins
	             2  task 1 live -- copy the three tablets
	             3  task 2 live -- carry the notes back to Doctor Olok
	             4  finished
	tablets      how many of the three have been copied
	copied_<n>   1 once snapshot node n has been copied by this character
	wp_return    waypoint id handed out for the hand-in
	runs         completed runs; allowRepeats is false, so 1 closes the quest
--]]

function somJenhaTarCubeScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function somJenhaTarCubeScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function somJenhaTarCubeScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function somJenhaTarCubeScreenPlay:getTabletCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "tablets")) or 0
end

function somJenhaTarCubeScreenPlay:hasCopiedTablet(pPlayer, nodeID)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "copied_" .. nodeID)) == 1
end

--[[ Entry points

grantQuest and signalReturnNotes are what Doctor Olok's conversation handler --
conversation/cube_ithes_olok_conv_handler.lua -- calls. Neither sends a refusal
of its own: the refusal wording lives in the tree, where the shipped .stf lines
are, so these two just report whether they did anything and let the screen the
handler picks say it in Olok's voice.

	canGrantQuest(pPlayer)      may this character start it
	grantQuest(pPlayer)         task 0 goes live
	signalReturnNotes(pPlayer)  raise somCubeSuccess -- completes task 2 and pays
	reportProgress(pPlayer)     read-only progress line, the missing journal page
	isComplete(pPlayer)         has this character finished it
--]]

function somJenhaTarCubeScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	-- [list] allowRepeats false: once only.
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function somJenhaTarCubeScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, 1)

	CreatureObject(pPlayer):sendSystemMessage(self.questTitle)
	CreatureObject(pPlayer):sendSystemMessage(self.questDescription)
	CreatureObject(pPlayer):sendSystemMessage(self.ruins.description)

	-- task 0 musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)

	return true
end

function somJenhaTarCubeScreenPlay:isComplete(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function somJenhaTarCubeScreenPlay:reportProgress(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local stage = self:getStage(pPlayer)

	if (stage == 1) then
		CreatureObject(pPlayer):sendSystemMessage(self.ruins.description)
	elseif (stage == 2) then
		CreatureObject(pPlayer):sendSystemMessage(self.tabletTask.itemName .. ": " .. self:getTabletCount(pPlayer) .. " of " .. self.tabletTask.count .. ".")
	elseif (stage == 3) then
		CreatureObject(pPlayer):sendSystemMessage(self.returnTask.description)
	end
end

--[[ task 0  --  Go to Location ]]

function somJenhaTarCubeScreenPlay:notifyEnteredRuins(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (SceneObject(pArea):getObjectID() ~= self.ruinsAreaID or self:getStage(pPlayer) ~= 1) then
		return 0
	end

	self:setStage(pPlayer, 2)

	CreatureObject(pPlayer):sendSystemMessage(self.ruins.title)
	CreatureObject(pPlayer):sendSystemMessage(self.tabletTask.title)
	CreatureObject(pPlayer):sendSystemMessage(self.tabletTask.description)

	return 0
end

--[[ task 1  --  Retrieve Item ]]

-- The label the menu component hangs on a tablet, or nil for no label at all.
function somJenhaTarCubeScreenPlay:getRadialText(pPlayer, nodeID)
	if (self.tabletIndex[nodeID] == nil) then
		return nil
	end

	if (self:getStage(pPlayer) ~= 2 or self:hasCopiedTablet(pPlayer, nodeID)) then
		return nil
	end

	return self.tabletTask.radialText
end

function somJenhaTarCubeScreenPlay:copyTablet(pPlayer, nodeID)
	if (self:getRadialText(pPlayer, nodeID) == nil) then
		return false
	end

	-- LootDropPercent 100 on task 1: the copy never fails. The roll is written out
	-- rather than assumed so a different percentage is a one-value change.
	if (getRandomNumber(100) > self.tabletTask.lootDropPercent) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "copied_" .. nodeID, "1")

	local copied = self:getTabletCount(pPlayer) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "tablets", tostring(copied))

	if (copied >= self.tabletTask.count) then
		self:startReturnLeg(pPlayer)

		return true
	end

	CreatureObject(pPlayer):sendSystemMessage(self.tabletTask.itemName .. ": " .. copied .. " of " .. self.tabletTask.count .. ".")
	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)

	return true
end

--[[ task 2  --  Wait for Signal somCubeSuccess ]]

function somJenhaTarCubeScreenPlay:startReturnLeg(pPlayer)
	self:setStage(pPlayer, 3)

	CreatureObject(pPlayer):sendSystemMessage(self.returnTask.title)
	CreatureObject(pPlayer):sendSystemMessage(self.returnTask.description)

	-- task 2 createWaypoint true. The cell name is recorded on returnTask and not
	-- used; addWaypoint plants at the world position.
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", self.returnTask.waypointName, self.returnTask.title, self.returnTask.x, 0, self.returnTask.y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
		writeScreenPlayData(pPlayer, self.screenplayName, "wp_return", tostring(waypointID))
	end
end

function somJenhaTarCubeScreenPlay:removeReturnWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp_return")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp_return")
end

-- This IS the somCubeSuccess signal. The .qst raises it from the hand-in, and
-- there is nothing else in the shipped data that can raise it.
function somJenhaTarCubeScreenPlay:signalReturnNotes(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	self:removeReturnWaypoint(pPlayer)
	self:awardQuest(pPlayer)

	return true
end

--[[ tasks 3 to 6  --  the Reward chain ]]

function somJenhaTarCubeScreenPlay:awardQuest(pPlayer)
	self:setStage(pPlayer, 4)
	-- Quest XP: quest_experience[1][TIER_1]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_jenha_tar_cube")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))

	-- Every one of the four Reward tasks says Bank Credits 0 and Experience
	-- Amount 0, so the four items are the whole payout. Nothing is invented to
	-- stand in for the [list] Experience Type quest_general, because there is no
	-- quest system row here to award it.
	for i = 1, #self.rewardItems do
		self:giveReward(pPlayer, self.rewardItems[i])
	end

	CreatureObject(pPlayer):sendSystemMessage("You have completed " .. self.questTitle .. ".")

	-- task 3 musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)
end

-- The four reward items carry their own display names from som_cube.stf (see the
-- header), so the client names them on receipt. A failure names the template,
-- and a success says nothing beyond the completion line above.
function somJenhaTarCubeScreenPlay:giveReward(pPlayer, template)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("somJenhaTarCubeScreenPlay: player has no inventory; " .. template .. " could not be handed over")
	elseif (giveItem(pInventory, template, -1, true) == nil) then
		print("somJenhaTarCubeScreenPlay: failed to create " .. template)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for the rest of Doctor Olok's findings.")
	end
end

-- Ithes Olok's s_194 -- "I suppose I can let you have another" -- is a shipped line,
-- so the server has to be able to honour it. Live's own gate has now been read; it is
-- the condition on the s_193 option, not on the handover:
--
--   condition_lostCube -> !utils.playerHasItemByTemplateInBankOrInventory(player,
--                             "object/tangible/container/loot/som_cube.iff")
--
-- This comment used to say live did "a BASE inventory check ... did not recurse into
-- containers, which is why players learned to drop the cube in a backpack and ask
-- again", and to keep that as a deliberate quirk. The name of live's helper says bank
-- OR inventory, so the first half was wrong; and utils.java is not in the extract, so
-- whether it recursed cannot be read at all. The backpack story was not sourced from
-- anything and is withdrawn.
--
-- ROOT CAUSE: describing a mechanism from how the bug was remembered rather than from
-- the code, and then defending the memory as fidelity.
--
-- What this does: scans the inventory and the bank, top level only, because that is
-- what Core3's Lua container API reaches without a recursive walk. If the helper turns
-- out to recurse, this is narrower than live and a player with a cube in a backpack
-- gets a second one.
function somJenhaTarCubeScreenPlay:hasCube(pPlayer)
	local slots = { "inventory", "bank" }

	for s = 1, #slots do
		local pContainer = SceneObject(pPlayer):getSlottedObject(slots[s])

		if (pContainer ~= nil) then
			for i = 1, SceneObject(pContainer):getContainerObjectsSize() do
				local pItem = SceneObject(pContainer):getContainerObject(i - 1)

				if (pItem ~= nil and SceneObject(pItem):getTemplateObjectPath() == self.rewardItems[1]) then
					return true
				end
			end
		end
	end

	return false
end

-- Only ever reachable from the finished state, and only hands over the cube itself --
-- rewardItems[1]. The three loot objects are the hand-in payout and are not reissued.
function somJenhaTarCubeScreenPlay:replaceCube(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 4 or self:hasCube(pPlayer)) then
		return false
	end

	self:giveReward(pPlayer, self.rewardItems[1])

	return true
end

--[[ Radial dispatch

One component table serves all three tablets. SceneObjectImplementation::
setObjectMenuComponent() falls through to LuaObjectMenuComponent when no C++
component of that name is registered, and LuaObjectMenuComponent REPLACES the
object's menu entirely -- so fillObjectMenuResponse has to add every item we want
to see, and adds nothing at all when this player has no business touching the
tablet.

Snapshot objects carry objectID == node ID, so the object id is the key straight
into tabletIndex; nothing has to be stashed on the object itself.
--]]

SomJenhaTarCubeMenuComponent = {}

function SomJenhaTarCubeMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local text = somJenhaTarCubeScreenPlay:getRadialText(pPlayer, SceneObject(pSceneObject):getObjectID())

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function SomJenhaTarCubeMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	somJenhaTarCubeScreenPlay:copyTablet(pPlayer, SceneObject(pSceneObject):getObjectID())

	return 0
end
