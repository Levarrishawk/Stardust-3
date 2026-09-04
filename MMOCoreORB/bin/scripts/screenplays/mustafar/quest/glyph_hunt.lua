--[[
Unlocking the Secrets  --  som_glyph_hunt

SOURCE OF RECORD

quest/som_glyph_hunt.qst in the client TREs, cross-checked against
string/en/quest/ground/som_glyph_hunt.stf. Every title, description, task name,
signal name, coordinate, count, radial text, item name, creature type, drop
percentage and credit figure below is quoted from one of those two files.

The .stf agrees with the .qst word for word on all twenty-eight of its rows. It
also carries five strings the .qst keeps only inside its two Wait for Tasks
blocks, which is where the sub-objective labels come from:

	task01_task_display_string_1  "Glyph of Mustafar that Was"
	task01_task_display_string_2  "Glyph of Mustafar that Is"
	task01_task_display_string_3  "Glyph of Mustafar that Changed"
	task03_task_display_string_1  "First Chunk of Missing Glyph"
	task03_task_display_string_2  "Second Chunk of Missing Glyph"

Note that those three glyph labels are NOT the same strings as the three Retrieve
tasks' own journalEntryTitles, which read "Glyph of the Mustafar that Was",
"Glyph of the Mustafar that Is" and "Glyph of the Mustafar in Change". Both sets
shipped; both are reproduced below, each against the field it came from.

THE TASK TREE, transcribed

	task 0  Nothing              musicOnActivate mus_mustafar_quest_exception.snd
	                             showSystemMessages 0, no journal text
	 task 1 Wait for Tasks       taskName glyph_hunt_four
	                             "Find the Three Glyphs"
	                             Task1 glyph_hunt_one, Task2 glyph_hunt_two,
	                             Task3 glyph_hunt_three
	  task 4 Retrieve Item       taskName glyph_hunt_one
	                             "Glyph of the Mustafar that Was"
	                             object/tangible/quest/som_jedi_two_glyph_01.iff
	                             Count 1, LootDropPercent 100,
	                             retrieveMenuText "Copy Glyph"
	  task 3 Retrieve Item       taskName glyph_hunt_two
	                             "Glyph of the Mustafar that Is"
	                             .../som_jedi_two_glyph_02.iff, same shape
	  task 2 Retrieve Item       taskName glyph_hunt_three
	                             "Glyph of the Mustafar in Change"
	                             .../som_jedi_two_glyph_03.iff, same shape
	  task 5 Wait for Signal     taskName glyph_hunt_five
	                             "Return to the Historian"
	                             Signal Name glyph_hunt_found
	                             createWaypoint TRUE, Planet mustafar,
	                             LocationX -5791, LocationY 106, LocationZ 5808
	                             waypointName "Return to the Historian"
	   task 7 Wait for Tasks     taskName glyph_hunt_eight
	                             "Defeat the Coyn's Commanders"
	                             Task1 glyph_hunt_six, Task2 glyph_hunt_seven
	    task 8 Destroy Mult+Loot taskName glyph_hunt_six
	                             "Defeat Captain Starkill"
	                             CreatureType som_coyn_captain
	                             LootItemName "Missing Chunk of Glyph"
	                             NumberItemsRequired 1, LootDropPercent 100,
	                             RewardCredits 0
	    task 9 Destroy Mult+Loot taskName glyph_hunt_seven
	                             "Defeat Commander Razor"
	                             CreatureType som_coyn_commander, same shape
	    task 10 Wait for Signal  taskName glyph_hunt_nine
	                             "Return to Historian"
	                             Signal Name glyph_hunt_finish
	                             createWaypoint TRUE, same -5791 / 106 / 5808
	                             waypointName "Return to Historian"
	     task 11 Reward          Bank Credits 10000, lootCount 1,
	                             lootName weapon_tow_rifle_03_01,
	                             Experience Amount 0,
	                             musicOnComplete mus_mustafar_quest_success.snd

The quest <list> says journalEntryTitle "Unlocking the Secrets", category
Mustafar, Level 75, Tier 4, allowRepeats true, Experience Type quest_combat,
Experience Amount 0, completeWhenTasksComplete true. The stored Experience
Amount 0 is real; live still paid, because the server recomputed from
quest_experience (see mustafar_quest_xp.lua).

One shipped inconsistency, quoted and left alone: task 5's description says
"Bring the two glyphs back to the historian" when task 1 above it required three.
The .stf says the same thing. The task list is what runs; the sentence is only
printed.

CHAINED OR INDEPENDENT

Independent. grantQuestOnComplete, grantQuestOnFail, prerequisiteQuests,
exclusionQuests, prerequisiteTasks, exclusionTasks,
conditionalQuestGrantQuestsThatMustBeCompleted and
conditionalQuestGrantQuestToGive are present on every task in the file and every
one is empty. Nothing grants this quest and this quest grants nothing.

WHERE THE GLYPHS COME FROM

Nothing is spawned. snapshot/mustafar.ws inside stardust_03.tre already places
all three glyphs, and PlanetManagerImplementation::loadSnapshotObject()
instantiates each snapshot node with objectID == the node ID, so
getSceneObject(<nodeID>) returns the object the client is already drawing.

	node 12111392  object/tangible/quest/shared_som_jedi_two_glyph_01.iff
	               x = -5295.25  z = 138.40  y = 6084.57   -- "that Was"
	node 12111391  object/tangible/quest/shared_som_jedi_two_glyph_02.iff
	               x = -5384.87  z = 128.32  y = 6027.99   -- "that Is"
	node 12111390  object/tangible/quest/shared_som_jedi_two_glyph_03.iff
	               x = -5294.42  z = 265.74  y = 5986.21   -- "in Change"

All three carry parent 0 and cell 0. They sit inside the nw_jedi_ruins region --
managers/planet/mustafar_regions.lua:151 puts that region at (-5424, 6028) with
radius 200 -- which is the "ruins of the Jedi enclave to the northeast" task 1
names.

(.ws stores x / height / z, and Core3's spawn and waypoint calls take x, z, y
with z as the height, so a .ws triple maps across unchanged. The .qst stores the
same thing as LocationX / LocationY / LocationZ with LocationY the height, which
is why the historian waypoint below reads x -5791, z 106, y 5808.)

The ordering that makes the attach safe: ZoneServerImplementation::start() runs
startGroundZones(), which blocks until every zone reports hasManagersStarted()
and PlanetManager::initialize() has called loadSnapshotObjects(), strictly before
startManagers() reaches startGlobalScreenPlays().

THE RADIAL

The three Retrieve tasks carry retrieveMenuText "Copy Glyph", which in live only
appears while its task is running. There is no quest journal here (see NO
JOURNAL), so each glyph gets a Lua ObjectMenuComponent that offers "Copy Glyph"
only to a player whose stored stage says the glyphs are the live step and who has
not already copied that glyph. Everyone else sees the object's ordinary radial.

THE TWO COMMANDERS  --  already placed, so they are observed, not spawned

The two Destroy Multiple and Loot tasks name creature types with the .qst's
"som_" authoring prefix. Both resolve to registered, already-spawned creatures
and both are matched by template name on the kill:

	som_coyn_captain    -> coyn_captain    customName "Captain Relgon Starkill"
	                       mobile/custom_content/som/coyn_captain.lua,
	                       included at that directory's serverobjects.lua:38
	                       spawned screenplays/mustafar/regions/
	                       north_west_region.lua:53 at (-5432.8, 130.6, 6016.4)
	som_coyn_commander  -> coyn_commander  customName "Commander Hal Razor"
	                       .../coyn_commander.lua, serverobjects.lua:39
	                       spawned north_west_region.lua:96
	                       at (-5301.4, 266.9, 5992.1)

The shipped conversation table string/en/conversation/som_glyph_hunt.stf has the
historian, Pletus Croix of the Nabooian Historical Archives, name them "Captain
Starkill" and "Hal Razor", which is what the two task titles say. Nothing is
respawned and north_west_region.lua is not touched -- one persistent
KILLEDCREATURE observer per player does the counting, the same mechanism
bounty_hunts.lua:459 and map_exploration.lua:346 use.

LootDropPercent is 100 on both, so a kill always yields its chunk; the roll is
still written out rather than assumed. NumberItemsRequired is 1 each, and
"Missing Chunk of Glyph" is a live server-side static item name with no object
template anywhere in this tree, so as in bounty_hunts.lua the roll is honoured
and no inventory item is minted for it. The two chunks are tracked as flags and
reported to the player using the .stf's own display strings, "First Chunk of
Missing Glyph" and "Second Chunk of Missing Glyph".

THE REWARD

Bank Credits 10000, awarded. Experience Amount is 0 on the Reward task, and the
<list>'s Experience Type quest_combat is journal-level data that only the quest
system awards -- there is no quest system row here, so nothing is invented to
stand in for it. The stored Experience Amount 0 is real; live still paid,
because the server recomputed from quest_experience (see mustafar_quest_xp.lua).

lootCount 1 / lootName weapon_tow_rifle_03_01 is NOT granted. lootName is a live
server-side static-item name, not an object template. The name resolves to
"DP-23 Rifle" in string/en/static_item_n.stf, but an exhaustive sweep of every
shipped shared_*.iff finds no object template carrying that objectName, so
granting the live item would mean authoring an object. Nothing in this tree is
called weapon_tow_rifle_03_01 and no rifle in the tree is identifiably the same
weapon, so it is left unresolved rather than replaced with a guess. This is the
same class of unresolvable reward already recorded in hidden_treasure.lua and
bounty_hunts.lua.

THE GIVER

The historian is named in every description and in both waypoint names, and
string/en/conversation/som_glyph_hunt.stf carries his entire dialogue tree
(Pletus Croix of the Nabooian Historical Archives). The tree and handler are
wired; this file places him:

  * naboo_historian is a registered creature (mobile/custom_content/som/
    naboo_historian.lua, included at that directory's serverobjects.lua:88,
    customName "Historian"). conversationTemplate is "som_glyph_hunt"; the tree
    ships at mobile/conversations/mustafar/som_glyph_hunt.lua.
  * There is no quest_start object for this quest in snapshot/mustafar.ws.

grantQuest, signalGlyphsFound and signalGlyphFinish are the seams the giver's
conversation handler calls. The two signal functions ARE glyph_hunt_found and
glyph_hunt_finish -- the .qst raises both from the hand-in, and there is
nothing else in the shipped data that can raise them.

The waypoint the .qst plants for both hand-ins, mustafar (-5791, 106, 5808),
is where the historian was standing in live. It is used as a waypoint exactly as
shipped. It is now also used as the placement: the Mustafar offset work
established that this is where he stood in live, and the .qst waypoint is the
only 3D position the shipped data carries for him. That reverses the earlier
ruling that a waypoint target is not a placement.

NO JOURNAL

som_glyph_hunt has no row in datatables/player/quests.iff. The table the server
loads is stardust_03.tre's, which wins the TreFiles order in conf/config.lua; its
307 rows contain no Mustafar entries but the 45 exploration markers. Adding a row
would mean authoring a TRE. So progress lives in persistent screenplay data on
the player and the journal text goes out as system messages, the same as
bounty_hunts.lua and map_exploration.lua. No id is added to
managers/quest/quest_manager.lua, because an id with no table row does nothing.

showSystemMessages is true on every task that has journal text, and 0 only on
task 0, which has none, so the flag is honoured as written.
--]]

local JournalMirror = require("managers.quest.journal_mirror")

somGlyphHuntScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "somGlyphHuntScreenPlay",

	-- [list] journalEntryTitle / journalEntryDescription / Level / Tier /
	-- allowRepeats / category.
	questTitle = "Unlocking the Secrets",
	questDescription = "A historian has asked you to try to locate a series of glyphs located in the temple ruins. The problem is that a group of Coyn mercenaries, called the Razor Runners, have secured the area and the Emperor has refused to supply any troops to clear them out. The historian has asked you to infiltrate the area and locate the glyphs.",
	questLevel = 75,
	questTier = 4,
	repeatable = true,

	-- task 0 musicOnActivate, task 11 musicOnComplete.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst. Neither counter has a shipped sound; this is the one
	-- map_exploration.lua:412 uses for its own counters.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	-- task 1, Wait for Tasks.
	glyphStage = {
		taskName = "glyph_hunt_four",
		title = "Find the Three Glyphs",
		description = "The historian needs you to find three different glyphs located around the ruins of the Jedi enclave to the northeast.",
	},

	-- tasks 4, 3 and 2, in the order task 1 lists them. `label` is task 1's
	-- Task<n> Display String, `title` and `description` the Retrieve task's own
	-- journal text, `itemName` its ItemName, `nodeID` its snapshot node.
	glyphs = {
		{
			taskName = "glyph_hunt_one",
			label = "Glyph of Mustafar that Was",
			title = "Glyph of the Mustafar that Was",
			description = "The historian needs you to locate the glyph showing Mustafar as it used to be.",
			template = "object/tangible/quest/som_jedi_two_glyph_01.iff",
			itemName = "The Glyph of Mustafar shows the moon having forests and water. It also shows the planet having great cities",
			nodeID = 12111392,
		},
		{
			taskName = "glyph_hunt_two",
			label = "Glyph of Mustafar that Is",
			title = "Glyph of the Mustafar that Is",
			description = "The historian needs you to locate the glyph showing Mustafar as it is today.",
			template = "object/tangible/quest/som_jedi_two_glyph_02.iff",
			itemName = "This Glyph of Mustafar shows the moon in its current volcanic state",
			nodeID = 12111391,
		},
		{
			taskName = "glyph_hunt_three",
			label = "Glyph of Mustafar that Changed",
			title = "Glyph of the Mustafar in Change",
			description = "The historian needs you to locate the glyph showing Mustafar as it went through its change.",
			template = "object/tangible/quest/som_jedi_two_glyph_03.iff",
			itemName = "This glyph appears to have been defaced. It appears that two huge portions of the glyph are missing so you cannot decipher what occured",
			nodeID = 12111390,
		},
	},

	-- Count 1 and LootDropPercent 100 are identical on all three Retrieve tasks,
	-- and retrieveMenuText is "Copy Glyph" on all three.
	glyphRadialText = "Copy Glyph",
	glyphDropPercent = 100,

	-- task 5, Wait for Signal.
	returnOne = {
		taskName = "glyph_hunt_five",
		title = "Return to the Historian",
		description = "Bring the two glyphs back to the historian and explain the damage done to the glyph of Mustafar that Changed.",
		signal = "glyph_hunt_found",
		x = -5791,
		z = 106,
		y = 5808,
		waypointName = "Return to the Historian",
	},

	-- task 7, Wait for Tasks.
	commanderStage = {
		taskName = "glyph_hunt_eight",
		title = "Defeat the Coyn's Commanders",
		description = "Locate the two commanding officers of the Coyn mercenaries. They will probably have the missing pieces of the glyph on them.",
	},

	-- tasks 8 and 9, in the order task 7 lists them. `label` is task 7's Task<n>
	-- Display String. `killTemplate` is the registered name the .qst's
	-- CreatureType resolves to; see THE TWO COMMANDERS.
	commanders = {
		{
			taskName = "glyph_hunt_six",
			label = "First Chunk of Missing Glyph",
			title = "Defeat Captain Starkill",
			description = "The two missing chunks of the last glyph must be with the commanding officers of the mercenary group. Defeat Captain Starkill and see if he has one of the pieces of the glyph.",
			creatureType = "som_coyn_captain",
			killTemplate = "coyn_captain",
			lootItemName = "Missing Chunk of Glyph",
			numberItemsRequired = 1,
			lootDropPercent = 100,
		},
		{
			taskName = "glyph_hunt_seven",
			label = "Second Chunk of Missing Glyph",
			title = "Defeat Commander Razor",
			description = "The two missing chunks of the last glyph must be with the commanding officers of the mercenary group. Defeat Commander Razor and see if he has one of the pieces of the glyph.",
			creatureType = "som_coyn_commander",
			killTemplate = "coyn_commander",
			lootItemName = "Missing Chunk of Glyph",
			numberItemsRequired = 1,
			lootDropPercent = 100,
		},
	},

	-- task 10, Wait for Signal. Same coordinates as task 5, different name.
	returnTwo = {
		taskName = "glyph_hunt_nine",
		title = "Return to Historian",
		description = "Return to the historian with the missing pieces of the glyph and see if he can put them back together.",
		signal = "glyph_hunt_finish",
		x = -5791,
		z = 106,
		y = 5808,
		waypointName = "Return to Historian",
	},

	-- task 11, Reward. lootName is recorded and not granted; see THE REWARD.
	rewardCredits = 10000,
	rewardLootName = "weapon_tow_rifle_03_01",
	rewardLootCount = 1,

	-- THE GIVER. The .qst's own hand-in waypoint, mustafar (-5791, 106, 5808) --
	-- full 3D, so nothing is derived. See THE GIVER in the header.
	questGiver = {
		template = "naboo_historian",
		x = -5791,
		z = 106,
		y = 5808,
		heading = 0,
	},

	-- Built by attachGlyphs on every boot. In-memory only, which is correct: it is
	-- derived from placements and the placements are re-attached each start.
	glyphIndex = {},
	questGiverID = 0,
}

-- JOURNAL MIRROR (J-3, 2026-09-04): stage -> client journal task bits, from the SOE task tree in
-- this header and scratch/mustafar-stage-task-map.md §glyph_hunt. Screenplay data stays truth.
somGlyphHuntScreenPlay.journalMap = {
	[1] = { quest = "som_glyph_hunt", complete = {0}, activate = {1} }, -- 1→t1 Wait for Tasks (t4/t3/t2 sub-flags)
	[2] = { quest = "som_glyph_hunt", complete = {1}, activate = {5} }, -- 2→t5 Wait for Signal glyph_hunt_found
	[3] = { quest = "som_glyph_hunt", complete = {5}, activate = {7} }, -- 3→t7 Wait for Tasks (t8/t9 sub-flags)
	[4] = { quest = "som_glyph_hunt", complete = {7}, activate = {10} }, -- 4→t10 Wait for Signal glyph_hunt_finish
	[5] = { quest = "som_glyph_hunt", complete = {10}, activate = {11}, finish = true }, -- 5→t11 Reward (then reset 0)
}

registerScreenPlay("somGlyphHuntScreenPlay", true)

function somGlyphHuntScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachGlyphs()
		self:spawnGiver()
	end
end

function somGlyphHuntScreenPlay:spawnGiver()
	local giver = self.questGiver
	-- z off the .qst is a WAYPOINT altitude -- where the map marker floats -- not
	-- ground level, and this is an outdoor spawn. Take the terrain height and keep
	-- the quoted value only as a fallback.
	local groundZ = getWorldFloor(giver.x, giver.y, "mustafar")

	-- Not `or` -- 0 is truthy in Lua, so an `or` fallback would keep a zero floor
	-- and bury him. Zero is treated as failure here: no point on Mustafar's terrain
	-- in this tree is at height 0.
	if (groundZ == nil or groundZ == 0) then
		groundZ = giver.z
	end
	local pNpc = spawnMobile("mustafar", giver.template, 0, giver.x, groundZ, giver.y, giver.heading, 0)

	if (pNpc == nil) then
		print("somGlyphHuntScreenPlay: failed to spawn " .. giver.template .. "; the quest cannot be started")
	else
		self.questGiverID = SceneObject(pNpc):getObjectID()
	end
end

function somGlyphHuntScreenPlay:attachGlyphs()
	self.glyphIndex = {}

	for i = 1, #self.glyphs do
		local glyph = self.glyphs[i]
		local pGlyph = getSceneObject(glyph.nodeID)

		if (pGlyph == nil) then
			print("somGlyphHuntScreenPlay: snapshot glyph " .. glyph.nodeID .. " (" .. glyph.taskName .. ") was not found; that copy will be unreachable")
		else
			self.glyphIndex[glyph.nodeID] = i
			SceneObject(pGlyph):setObjectMenuComponent("SomGlyphHuntMenuComponent")
		end
	end
end

--[[ State

Persistent screenplay data on the player, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0" throughout.

	stage           0  not started, or finished and available again
	                1  task 1 live -- copy the three glyphs
	                2  task 5 live -- carry them back, waiting on glyph_hunt_found
	                3  task 7 live -- kill both Coyn officers
	                4  task 10 live -- go back, waiting on glyph_hunt_finish
	                5  paying out; awardQuest resets to 0 before it returns, because
	                   [list] allowRepeats is true, so 5 is never a resting state.
	                   `runs` is what says the character has finished it at least
	                   once.
	glyph_<name>    1 once the glyph for that taskName has been copied
	chunk_<name>    1 once the officer for that taskName has dropped his chunk
	wp_return       waypoint id currently handed out for a hand-in
	observer        1 while this player carries the KILLEDCREATURE observer
	runs            completed runs; allowRepeats is true, so this only counts
--]]

function somGlyphHuntScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function somGlyphHuntScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	JournalMirror.applyStage(pPlayer, self.journalMap, stage)   -- J-3 journal mirror
end

function somGlyphHuntScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function somGlyphHuntScreenPlay:hasGlyph(pPlayer, taskName)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "glyph_" .. taskName)) == 1
end

function somGlyphHuntScreenPlay:hasChunk(pPlayer, taskName)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "chunk_" .. taskName)) == 1
end

function somGlyphHuntScreenPlay:getGlyphCount(pPlayer)
	local found = 0

	for i = 1, #self.glyphs do
		if (self:hasGlyph(pPlayer, self.glyphs[i].taskName)) then
			found = found + 1
		end
	end

	return found
end

function somGlyphHuntScreenPlay:getChunkCount(pPlayer)
	local found = 0

	for i = 1, #self.commanders do
		if (self:hasChunk(pPlayer, self.commanders[i].taskName)) then
			found = found + 1
		end
	end

	return found
end

function somGlyphHuntScreenPlay:clearRunData(pPlayer)
	for i = 1, #self.glyphs do
		deleteScreenPlayData(pPlayer, self.screenplayName, "glyph_" .. self.glyphs[i].taskName)
	end

	for i = 1, #self.commanders do
		deleteScreenPlayData(pPlayer, self.screenplayName, "chunk_" .. self.commanders[i].taskName)
	end
end

--[[ Entry points

grantQuest, signalGlyphsFound and signalGlyphFinish are what the historian's
conversation handler calls once there is one. None of them sends a refusal: with
no giver in the shipped data there is no voice to put a refusal in, so they only
report whether they did anything.

	canGrantQuest(pPlayer)       may this character start it
	grantQuest(pPlayer)          task 1 goes live
	signalGlyphsFound(pPlayer)   raise glyph_hunt_found  -- completes task 5
	signalGlyphFinish(pPlayer)   raise glyph_hunt_finish -- completes task 10, pays
	reportProgress(pPlayer)      read-only progress, the missing journal page
--]]

function somGlyphHuntScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	-- [list] allowRepeats true, read from the table rather than assumed.
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function somGlyphHuntScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearRunData(pPlayer)
	self:setStage(pPlayer, 1)

	CreatureObject(pPlayer):sendSystemMessage(self.questTitle)
	CreatureObject(pPlayer):sendSystemMessage(self.questDescription)
	CreatureObject(pPlayer):sendSystemMessage(self.glyphStage.description)

	-- task 0 musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)

	return true
end

function somGlyphHuntScreenPlay:reportProgress(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local stage = self:getStage(pPlayer)

	if (stage == 1) then
		CreatureObject(pPlayer):sendSystemMessage(self.glyphStage.title)

		for i = 1, #self.glyphs do
			local glyph = self.glyphs[i]

			if (not self:hasGlyph(pPlayer, glyph.taskName)) then
				CreatureObject(pPlayer):sendSystemMessage(glyph.label)
			end
		end
	elseif (stage == 2) then
		CreatureObject(pPlayer):sendSystemMessage(self.returnOne.description)
	elseif (stage == 3) then
		CreatureObject(pPlayer):sendSystemMessage(self.commanderStage.title)

		for i = 1, #self.commanders do
			local officer = self.commanders[i]

			if (not self:hasChunk(pPlayer, officer.taskName)) then
				CreatureObject(pPlayer):sendSystemMessage(officer.label)
			end
		end
	elseif (stage == 4) then
		CreatureObject(pPlayer):sendSystemMessage(self.returnTwo.description)
	end
end

--[[ tasks 4, 3, 2  --  Retrieve Item ]]

-- The label the menu component hangs on a glyph, or nil for no label at all.
function somGlyphHuntScreenPlay:getRadialText(pPlayer, nodeID)
	local index = self.glyphIndex[nodeID]

	if (index == nil or self:getStage(pPlayer) ~= 1) then
		return nil
	end

	if (self:hasGlyph(pPlayer, self.glyphs[index].taskName)) then
		return nil
	end

	return self.glyphRadialText
end

function somGlyphHuntScreenPlay:copyGlyph(pPlayer, nodeID)
	if (self:getRadialText(pPlayer, nodeID) == nil) then
		return false
	end

	-- LootDropPercent 100: the copy never fails. Written out rather than assumed
	-- so a different percentage is a one-value change.
	if (getRandomNumber(100) > self.glyphDropPercent) then
		return false
	end

	local glyph = self.glyphs[self.glyphIndex[nodeID]]

	writeScreenPlayData(pPlayer, self.screenplayName, "glyph_" .. glyph.taskName, "1")

	-- The Retrieve task's own ItemName is what the player read off the glyph.
	CreatureObject(pPlayer):sendSystemMessage(glyph.title)
	CreatureObject(pPlayer):sendSystemMessage(glyph.itemName)

	if (self:getGlyphCount(pPlayer) >= #self.glyphs) then
		self:startReturnOne(pPlayer)

		return true
	end

	CreatureObject(pPlayer):sendSystemMessage(self.glyphStage.title .. ": " .. self:getGlyphCount(pPlayer) .. " of " .. #self.glyphs .. ".")
	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)

	return true
end

--[[ task 5  --  Wait for Signal glyph_hunt_found ]]

function somGlyphHuntScreenPlay:startReturnOne(pPlayer)
	self:setStage(pPlayer, 2)

	CreatureObject(pPlayer):sendSystemMessage(self.returnOne.title)
	CreatureObject(pPlayer):sendSystemMessage(self.returnOne.description)

	self:placeReturnWaypoint(pPlayer, self.returnOne)
end

function somGlyphHuntScreenPlay:signalGlyphsFound(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:removeReturnWaypoint(pPlayer)
	self:startCommanderStage(pPlayer)

	return true
end

--[[ tasks 8 and 9  --  Destroy Multiple and Loot ]]

function somGlyphHuntScreenPlay:startCommanderStage(pPlayer)
	self:setStage(pPlayer, 3)

	CreatureObject(pPlayer):sendSystemMessage(self.commanderStage.title)
	CreatureObject(pPlayer):sendSystemMessage(self.commanderStage.description)

	for i = 1, #self.commanders do
		CreatureObject(pPlayer):sendSystemMessage(self.commanders[i].description)
	end

	self:attachKillObserver(pPlayer)
end

function somGlyphHuntScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	-- Persistence 1 is createObserver's optional 5th argument; without it the
	-- observer is not saved with the player and kills stop being credited after a
	-- relog. The flag keeps a second grant from attaching a duplicate.
	createObserver(KILLEDCREATURE, "somGlyphHuntScreenPlay", "notifyKilledCreature", pPlayer, 1)

	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function somGlyphHuntScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "somGlyphHuntScreenPlay", "notifyKilledCreature", pPlayer)

	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function somGlyphHuntScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 3) then
		-- A non-zero return is how ScreenPlayObserverImplementation removes an
		-- observer, so this also clears one left behind by a finished run.
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")

		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil) then
		return 0
	end

	for i = 1, #self.commanders do
		local officer = self.commanders[i]

		if (officer.killTemplate == victimTemplate and not self:hasChunk(pPlayer, officer.taskName)) then
			self:creditChunk(pPlayer, officer)

			return 0
		end
	end

	return 0
end

function somGlyphHuntScreenPlay:creditChunk(pPlayer, officer)
	-- Destroy Multiple and Loot: the kill only counts if the drop lands.
	-- getRandomNumber(100) is 1-100 inclusive, the same roll bounty_hunts.lua:510
	-- and samaritan.lua:493 make. LootDropPercent is 100 on both officers, so this
	-- never actually refuses; it is written out because the value is data.
	if (getRandomNumber(100) > officer.lootDropPercent) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "chunk_" .. officer.taskName, "1")

	-- "Missing Chunk of Glyph" is a live server-side static item name with no
	-- template in this tree, so nothing is minted; the label is the .stf's own
	-- display string for this sub-objective.
	CreatureObject(pPlayer):sendSystemMessage(officer.label .. ": " .. officer.numberItemsRequired .. " of " .. officer.numberItemsRequired .. ".")

	if (self:getChunkCount(pPlayer) >= #self.commanders) then
		self:detachKillObserver(pPlayer)
		self:startReturnTwo(pPlayer)

		return
	end

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
end

--[[ task 10  --  Wait for Signal glyph_hunt_finish ]]

function somGlyphHuntScreenPlay:startReturnTwo(pPlayer)
	self:setStage(pPlayer, 4)

	CreatureObject(pPlayer):sendSystemMessage(self.returnTwo.title)
	CreatureObject(pPlayer):sendSystemMessage(self.returnTwo.description)

	self:placeReturnWaypoint(pPlayer, self.returnTwo)
end

function somGlyphHuntScreenPlay:signalGlyphFinish(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 4) then
		return false
	end

	self:removeReturnWaypoint(pPlayer)
	self:awardQuest(pPlayer)

	return true
end

--[[ task 11  --  Reward ]]

function somGlyphHuntScreenPlay:awardQuest(pPlayer)
	self:setStage(pPlayer, 5)
	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_glyph_hunt")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))

	-- Bank Credits 10000. Experience Amount is 0 and lootName cannot be resolved;
	-- see THE REWARD.
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	CreatureObject(pPlayer):sendSystemMessage("You have received " .. self.rewardCredits .. " credits.")
	CreatureObject(pPlayer):sendSystemMessage("You have completed " .. self.questTitle .. ".")

	-- task 11 musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	-- allowRepeats true: reset so the historian can hand it out again.
	self:clearRunData(pPlayer)
	self:setStage(pPlayer, 0)
end

--[[ Waypoints

Both Wait for Signal tasks carry createWaypoint true and the same coordinates,
mustafar (-5791, 106, 5808), under two different waypointNames. Only one is ever
live, so one key holds it.
--]]

function somGlyphHuntScreenPlay:placeReturnWaypoint(pPlayer, task)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", task.waypointName, task.title, task.x, 0, task.y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp_return", tostring(waypointID))
end

function somGlyphHuntScreenPlay:removeReturnWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp_return")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp_return")
end

--[[ Radial dispatch

One component table serves all three glyphs. SceneObjectImplementation::
setObjectMenuComponent() falls through to LuaObjectMenuComponent when no C++
component of that name is registered, and LuaObjectMenuComponent REPLACES the
object's menu entirely -- so fillObjectMenuResponse has to add every item we want
to see, and adds nothing at all when this player has no business touching it.

Snapshot objects carry objectID == node ID, so the object id is the key straight
into glyphIndex; nothing has to be stashed on the object itself.
--]]

SomGlyphHuntMenuComponent = {}

function SomGlyphHuntMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local text = somGlyphHuntScreenPlay:getRadialText(pPlayer, SceneObject(pSceneObject):getObjectID())

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function SomGlyphHuntMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	somGlyphHuntScreenPlay:copyGlyph(pPlayer, SceneObject(pSceneObject):getObjectID())

	return 0
end
