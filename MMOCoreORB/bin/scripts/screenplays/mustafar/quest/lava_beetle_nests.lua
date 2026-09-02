--[[
	Clear Out Beetle Nest  --  som_lava_beetle_nest_destroy + som_lava_beetle_nest_destroy_2

	SOURCE OF RECORD
	----------------
	Every title, description, count, distance, coordinate, radius, signal name,
	sound, credit figure and reward id below is quoted verbatim from the two
	shipped quest definitions:

		quest/som_lava_beetle_nest_destroy.qst      (545 lines)
		quest/som_lava_beetle_nest_destroy_2.qst    (776 lines)

	read as plain XML out of the client TREs.  Provenance comments name the .qst
	task each string came from.  Where a string had to be authored because the
	.qst has no line for it, the comment says so in as many words.

	THEY ARE NOT A CHAIN -- and here is the evidence, because the brief asked
	-------------------------------------------------------------------------
	The obvious reading of a "_2" suffix is that _2 follows _1.  The shipped data
	says otherwise, on four independent counts:

	  1. grantQuestOnComplete is EMPTY on every task in both files.
	     som_lava_beetle_nest_destroy.qst has 14 grantQuestOnComplete fields and
	     som_lava_beetle_nest_destroy_2.qst has 16; a `sort -u` over the values
	     of all 30 returns exactly one distinct value, "".  Neither file names
	     the other, or any other quest, anywhere.
	  2. Both [list] blocks have prerequisiteQuests EMPTY and exclusionQuests
	     EMPTY.  Neither one gates on the other; neither one locks the other out.
	  3. The four "Wait for Tasks" rows in each file point at THEMSELVES.  _1's
	     Task1-4 all carry Quest Filename "quest/som_lava_beetle_nest_destroy";
	     _2's all carry "quest/som_lava_beetle_nest_destroy_2".  There is no
	     cross-file task reference in either direction.
	  4. Contrast with the pair in this same folder that IS a chain.
	     hidden_treasure.lua:12-14 records that som_kenobi_hidden_treasure_1's
	     last task carries grantQuestOnComplete = som_kenobi_hidden_treasure_2
	     and that _2 sets allowRepeats = false.  That is the exact field our pair
	     leaves blank, and our pair sets allowRepeats = true on BOTH halves.

	What _2 actually is: a later revision of _1.  Same camp, same four nests,
	same task ids, same taskNames, same signal names, same coordinate, same
	Radius 50, same Counts of 5 and 8, same Min/Max Distances, same Level 75,
	same Tier 4, same Bank Credits 10000, same lootName item_tow_trophey_02_01.
	Only three things differ:

	  * _2 adds a fail branch.  signalsOnFail = "failed_beetle_destroy" is set on
	    the five Encounter tasks (6, 15, 16, 17, 18; .qst lines 209, 303, 394,
	    485, 576), feeding task 20 "Waiting for Fail signal" -> task 21
	    "You failed" (Immediately Clear Quest).  _1 has no fail path at all.
	  * _2 was saved by a newer quest editor: it carries EntranceLocationX/Y/Z,
	    chanceToActivate, createEntranceWaypoint, entranceWaypointName,
	    penaltyFactionAmount, penaltyFactionName and
	    questControlOnTaskCompletion/Failure fields that do not exist in _1 --
	    ten field names in total, confirmed by diffing the two files' field-name
	    sets.  Every one of them is inert: 0, "" or "none", except
	    penaltyFactionName, which is the editor's default "Rebel" and does
	    nothing because its penaltyFactionAmount is 0.
	  * One word of the [list] description: _1 says the mineral pocket is "near a
	    kubaza beetle nest", _2 says "near kubaza beetle nests".

	So they are filed in ONE screenplay, as the brief asked -- but as two
	VARIANTS of one job, not as act one and act two.  They drive the same four
	world nests, so only one of them can be live on a character at a time; see
	THE VARIANTS below.

	THE NESTS ARE ALREADY IN THE WORLD
	----------------------------------
	Nothing here spawns a nest.  snapshot/mustafar.ws in stardust_03.tre already
	places all four, and PlanetManagerImplementation::loadSnapshotObject()
	instantiates each snapshot node with objectID == the node id, so
	getSceneObject(<nodeID>) returns the exact object the client is already
	drawing.  Spawning our own copies would double them up.

		node 12111378  object/tangible/item/som/shared_lava_beetle_nest.iff
		                                              (-3423.42, 17.86, 5362.56)
		node 12111377  object/tangible/item/som/shared_lava_beetle_nest_two.iff
		                                              (-3397.46, 16.76, 5375.79)
		node 12111376  object/tangible/item/som/shared_lava_beetle_nest_three.iff
		                                              (-3377.90, 20.15, 5373.63)
		node 12111375  object/tangible/item/som/shared_lava_beetle_nest_four.iff
		                                              (-3347.16, 21.57, 5359.08)

	All four sit inside task 5's own Radius 50 of the camp coordinate
	(-3386, 33, 5331): 48.95 m, 46.23 m, 43.39 m and 47.93 m out.  Four shipped nest
	props against four "lava_beetle_nest_<n>_destroyed" signals is a 1:1 match,
	so nest_one..nest_four below are mapped onto the props in the order the
	templates are numbered.  All four server templates are registered:
	object/custom_content/tangible/item/som/serverobjects.lua lines 19-22.
	No other screenplay in this tree references any of these four node ids.

	(.ws stores x / height / z; Core3's spawn and waypoint calls take x, z, y
	with z as the height, so a .ws triple maps across unchanged in that order.
	Same rule for the .qst: LocationY is the height, so LocationX/LocationY/
	LocationZ becomes x/z/y.  map_exploration.lua:43-81 documents this.)

	THE CREATURES DO NOT SHIP -- BOTH SUBSTITUTED, BOTH FLAGGED
	-----------------------------------------------------------
	The .qst names two creature templates on its Encounter tasks:

		som_burning_plains_lava_beetle_soldier    tasks 15, 16, 17, 18 (Count 5)
		som_link_lava_beetle_soldier              task 6              (Count 8)

	Neither exists.  A scoped grep over every .lua in this repo returns zero
	hits for either name, and a binary-safe grep over all of C:\swg-extract\_som
	returns hits only inside the two .qst files themselves.  There is no
	mobile/custom_content/som template for either, so they cannot be spawned.

	Both are substituted with mobile/custom_content/som/kubaza_soldier_beetle
	("a Kubaza Soldier Beetle", level 70, registered at som/serverobjects.lua:56).
	That is the only shipped soldier-caste kubaza beetle in the tree, and the
	.qst's own prose calls the targets "kubaza soldier beetles" in task 15-18's
	journalEntryDescription and "kubaza beetles" in task 6's.  The substitution
	is my pick, not a finding -- see OPEN DECISIONS in the report.  Nothing here
	distinguishes the two .qst names from each other, because nothing shipped
	says how they differed.

	THE GIVER -- Donko Jen, found and placed
	----------------------------------------
	An earlier pass of this file said he "DOES NOT EXIST ANYWHERE", drove the
	grant off nothing, and made the return leg fire its own reward signal so the
	player would not be stranded.  That was wrong on every count, and it was
	wrong because the search was done by his display name.  SOE named this
	quest's data after the QUEST, not the NPC: his conversation script is
	lava_beetle_nest_destroy_donko, and the live spawn row that places him
	carries that script name.  Searching for "donko jen" found nothing; searching
	the conversation scripts found him at once.

	He is now built and placed:

		mobile/custom_content/som/foreman_donko.lua                the creature
		mobile/conversations/mustafar/lava_beetle_nest_destroy_donko.lua
		.../quest/conversation/lava_beetle_nest_destroy_donko_conv_handler.lua
		screenplays/mustafar/mensix/mensix_mining_facility_main.lua the spawn

	The spawn is in entrance_room_01 of the Mensix Mining Facility, cell
	12112222, at the position and heading the live data gives.  His appearance is
	the one repo choice -- the live spawn data carries no appearance column and
	no donko model ships -- and that is documented in foreman_donko.lua itself.

	The four entry points

		lavaBeetleNestsScreenPlay:grantNestQuest(pPlayer, "one")
		lavaBeetleNestsScreenPlay:grantNestQuest(pPlayer, "two")
		lavaBeetleNestsScreenPlay:signalReward(pPlayer)
		lavaBeetleNestsScreenPlay:failQuest(pPlayer)

	are now called from his handler, from exactly the screens SOE hung the side
	effects on.  Note that BOTH of SOE's grant sites pass variant "two"; variant
	"one" has no giver in SOE's own script and is left exposed but uncalled,
	which is SOE's shape, not a gap in this port.

	The DEVIATION is gone with him.  finishCleanup no longer fires
	mustafar_lava_beetle_nest_reward itself; it sets STAGE_RETURN, sends task 9's
	shipped text, and stops.  The player walks back to Donko Jen and his hand-in
	screen fires the signal, which is what the Wait for Signal task always meant.

	NO JOURNAL / PROGRESS TRACKING
	------------------------------
	Neither quest has a row in datatables/player/quests.iff.  The table the
	server loads is the one in stardust_03.tre, which wins the TreFiles order in
	conf/config.lua; it holds 307 rows whose only Mustafar entries are the 45
	exploration markers.  Adding a row would mean authoring a TRE, so nothing is
	added to managers/quest/quest_manager.lua and progress lives in persistent
	screenplay data instead: the .qst's journalEntryTitle goes out as a system
	message and a waypoint name, its journalEntryDescription as a system message
	and a waypoint description.

	THE REWARD -- RESOLVED
	----------------------
	Both [list] blocks pay Bank Credits 10000, Experience Amount 0, Faction
	Amount 0, and lootCount 1 of lootName "item_tow_trophey_02_01".

	The 10000 credits are granted literally.  The loot name is resolved:
	item_tow_trophey_02_01 is "Mounted Kubaza Beetle Head" in
	string/en/static_item_n.stf, and the shipped client template
	object/tangible/loot/mustafar/shared_trophey_lava_beetle.iff carries exactly
	that as its objectName (static_item_n : item_tow_trophey_02_01).  The server
	template is registered -- trophey_lava_beetle.lua:3 addTemplate,
	serverobjects.lua:15 -- and giveItem grants trophey_lava_beetle.iff.

	It is a member of the same family trophy_hunts.lua:102-118 already resolved
	by name.  With this file the four that resolve are:

		item_tow_trophey_02_06 -> trophey_blistmok_skin.iff
		item_tow_trophey_02_04 -> bones_must_monster_jaw_small.iff
		item_tow_trophey_02_03 -> trophey_xandank.iff
		item_tow_trophey_02_01 -> trophey_lava_beetle.iff

	(maneater.lua still grants trophey_tulrus_spine.iff for item_tow_trophey_02_02,
	but that stays a SUBSTITUTE: the wanted name resolves to "Mounted Tulrus Spine"
	in static_item_n.stf with no shipped object carrying that objectName, and
	shared_trophey_tulrus_spine.iff has an empty string table and the key
	trophey_tulrus_spine_n, which appears in no shipped STF.  The two grants do
	not collide.)

	REPEATS
	-------
	Both [list] blocks carry allowRepeats = true, so STAGE_DONE is a record and
	not a lock: grantNestQuest resets from it and bumps a per-variant run counter.

	THE FAIL BRANCH -- WIRED AS A SEAM, NEVER FIRED
	-----------------------------------------------
	Variant two's five Encounter tasks carry signalsOnFail = failed_beetle_destroy,
	which clears the quest.  Nothing shipped says what FAILS an Encounter -- the
	.qst has no timer field, no death condition, no leash distance, nothing.  So
	failQuest() exists, honours the Immediately Clear Quest task, refuses to run
	for variant one which has no fail path, and is called by nothing.  OPEN.

	WHAT IS NOT MODELLED
	--------------------
	  * The timed charge.  The [list] says "They have supplied you with a timed
	    charge that you will need to drop into the nests" and task 11-14's text
	    says "Once the charge is set, move away from the nest, or you might be
	    caught in the blast".  No charge item template ships (no som charge/
	    explosive/detonator in object/custom_content/tangible/item/som), the .qst
	    gives the charge no template, no fuse length and no blast radius, and it
	    is never granted by any task.  The radial arms the nest instantly and
	    there is no blast.  Inventing a fuse and a damage number would be content
	    authoring, not wiring.  OPEN.
	  * The nest props are not visually destroyed or despawned.  They are
	    snapshot objects the client draws; removing one would remove it for
	    everybody on the shard, and both quests are repeatable.
	  * Faction Amount 0 / Faction Name Rebel and Experience Amount 0 /
	    quest_combat are honoured literally: no faction, no XP, because that is
	    what the .qst says. The stored Experience Amount 0 is real; live still
	    paid, because the server recomputed from quest_experience (see
	    mustafar_quest_xp.lua).
	  * "Level 75" and "Tier 4" are recorded on the table for a giver to gate on;
	    nothing here enforces them, because nothing here grants the quest.
	  * The typo in task 6's shipped description ("The nests are destoyed") is
	    reproduced as shipped.
--]]

lavaBeetleNestsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "lavaBeetleNestsScreenPlay",

	-- task 0, Nothing: musicOnActivate.  Identical in both files.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	-- Neither file has a Reward task, so neither carries musicOnComplete.  This
	-- is the shipped SOM success sting the rest of this folder uses; MINE.
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst.  Counter ticks have no shipped sound; this is the one
	-- map_exploration.lua:412 uses for its own hunt ticks.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	STAGE_TRAVEL = 1,
	STAGE_NESTS = 2,
	STAGE_CLEANUP = 3,
	STAGE_RETURN = 4,
	STAGE_DONE = 5,

	-- task 5, Go to Location (mustafar_lava_beetle_nest_one).
	-- Planet mustafar, LocationX -3386, LocationY 33 (height), LocationZ 5331,
	-- Radius(m) 50, createWaypoint true.
	campX = -3386,
	campZ = 33,
	campY = 5331,
	campRadius = 50,
	campWaypointName = "Kubaza Beetle Infested Mining Camp",
	travelTitle = "Travel to the Mining Camp",
	travelDescription = "Travel to the mining camp. There are several nests surrounding the camp that need to be destroyed. You can expect that the kubaza beetles will fiercely defend their nests.",

	-- task 10, Wait for Tasks (lava_beetle_nest_tasks) -- the umbrella over the
	-- four nest legs.  Its four Display Strings are all the same string.
	nestsTitle = "Destroy the Four Kubaza Beetle Nests",
	nestsDescription = "Donko Jen needs you to place the charges on each of the kubaza beetle nests that surround his mining camp. He warned you that the beetles will send out their soldiers to defend the nests and that they need all be killed or they will rebuild the nests.",
	nestDestroyedText = "Kubaza Beetle Nest Destroyed",

	-- tasks 11/12/13/14, Wait for Signal.  All four share this title and text;
	-- the title doubles as the radial label on the nest props.
	chargeTitle = "Destroy Kubaza Beetle Nest",
	chargeDescription = "Find one of the nests that surround the miner's camp and place a charge on it. Once the charge is set, move away from the nest, or you might be caught in the blast. Be very careful, because this will really rile up the kubaza beetle soldiers, and you should expect to be attacked.",

	-- tasks 15/16/17/18, Encounter.  Creature Type
	-- som_burning_plains_lava_beetle_soldier, Count 5, Min Distance 15,
	-- Max Distance 25.  Template SUBSTITUTED -- see the header.
	soldierTitle = "Defeat Kubaza Soldier Beetles",
	soldierDescription = "You must kill any of the kubaza soldier beetles that manage to escape the blast. If you do not, they will rebuild the nest.",
	soldiersPerNest = 5,
	soldierMinDistance = 15,
	soldierMaxDistance = 25,
	soldierTemplate = "kubaza_soldier_beetle",

	-- task 6, Encounter (mustafar_lava_beetle_nest_two).  Creature Type
	-- som_link_lava_beetle_soldier, Count 8, Min Distance 15, Max Distance 35.
	-- Template SUBSTITUTED -- see the header.  "destoyed" is the shipped spelling.
	cleanupTitle = "Clean up Any Remaining Kubaza Beetles",
	cleanupDescription = "The nests are destoyed but there is a chance that some of the beetles managed to get out. You must kill any remaining beetles in the area to avoid them being able to rebuild their nests.",
	cleanupCount = 8,
	cleanupMinDistance = 15,
	cleanupMaxDistance = 35,
	cleanupTemplate = "kubaza_soldier_beetle",

	-- task 9, Wait for Signal (mustafar_lava_beetle_nest_four).  Signal Name
	-- mustafar_lava_beetle_nest_reward, fired by Donko Jen's hand-in screen.
	-- Wait for Signal carries no location, so no waypoint is handed out for the
	-- walk back; the description below is the only direction live gave.
	returnTitle = "Return to Donko Jen",
	returnDescription = "Return to Donko Jen and report that the nest has been destroyed.",

	-- [list], identical in both files: Bank Credits 10000, lootCount 1,
	-- lootName item_tow_trophey_02_01 (RESOLVED -- header), Level 75, Tier 4,
	-- Experience Amount 0, Faction Amount 0.
	rewardCredits = 10000,
	rewardItem = "object/tangible/loot/mustafar/trophey_lava_beetle.iff",
	rewardName = "Kubaza Beetle Trophy",
	questLevel = 75,
	questTier = 4,

	-- The four shipped snapshot nest props, in template-number order, paired
	-- with the .qst signal and taskName each one stands for.
	nests = {
		{
			n = 1,
			nodeID = 12111378,
			taskName = "destroy_lava_beetle_nest_one",		-- task 11
			signal = "lava_beetle_nest_one_destroyed",
			waitTask = "destroyed_beetle_soldiers_one",		-- task 10, Task1
			x = -3423.42, z = 17.86, y = 5362.56,
		},
		{
			n = 2,
			nodeID = 12111377,
			taskName = "destroy_lava_beetle_nest_two",		-- task 12
			signal = "lava_beetle_nest_two_destroyed",
			waitTask = "destroyed_beetle_soldiers_two",		-- task 10, Task2
			x = -3397.46, z = 16.76, y = 5375.79,
		},
		{
			n = 3,
			nodeID = 12111376,
			taskName = "destroy_lava_beetle_nest_three",	-- task 13
			signal = "lava_beetle_nest_three_destroyed",
			waitTask = "destroyed_beetle_soldier_three",	-- task 10, Task3
			x = -3377.90, z = 20.15, y = 5373.63,
		},
		{
			n = 4,
			nodeID = 12111375,
			taskName = "destroy_lava_beetle_nest_four",		-- task 14
			signal = "lava_beetle_nest_four_destroyed",
			waitTask = "destroyed_beetle_soldier_four",		-- task 10, Task4
			x = -3347.16, z = 21.57, y = 5359.08,
		},
	},

	-- The only two things that differ between the files, plus the file each one
	-- came from so a reader can go check.  See THEY ARE NOT A CHAIN.
	variants = {
		one = {
			key = "one",
			questFile = "quest/som_lava_beetle_nest_destroy",
			title = "Clear Out Beetle Nest",
			description = "A new pocket of high grade minerals has been located on the Burning Plains. The Mustafar Mining Company wants to get their crews into that area and extract those resources. The problem is that the pocket is near a kubaza beetle nest, and kubaza beetles are extremely aggressive when defending their nests. The company needs that nest of beetles eliminated before they can send their miners in. They have supplied you with a timed charge that you will need to drop into the nests.",
			failSignal = nil,
		},
		two = {
			key = "two",
			questFile = "quest/som_lava_beetle_nest_destroy_2",
			title = "Clear Out Beetle Nest",
			description = "A new pocket of high grade minerals has been located on the Burning Plains. The Mustafar Mining Company wants to get their crews into that area and extract those resources. The problem is that the pocket is near kubaza beetle nests, and kubaza beetles are extremely aggressive when defending their nests. The company needs that nest of beetles eliminated before they can send their miners in. They have supplied you with a timed charge that you will need to drop into the nests.",
			-- task 20 "Waiting for Fail signal" -> task 21 "You failed".
			failSignal = "failed_beetle_destroy",
		},
	},

	campAreaID = 0,
}

registerScreenPlay("lavaBeetleNestsScreenPlay", true)

-- ====================================================================
-- World setup
--
-- DirectorManager::startScreenPlay calls this by name on every screenplay
-- registered with true, so everything here runs once per server start.
-- ====================================================================

function lavaBeetleNestsScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachNests()
		self:spawnCampArea()
	end
end

-- The four shipped lava_beetle_nest snapshot nodes get the radial that tasks
-- 11-14 ask for.  Nothing is spawned; these already exist.
function lavaBeetleNestsScreenPlay:attachNests()
	for i = 1, #self.nests do
		local nest = self.nests[i]
		local pNest = getSceneObject(nest.nodeID)

		if (pNest == nil) then
			print("lavaBeetleNestsScreenPlay: nest snapshot object " .. nest.nodeID .. " was not found; nest " .. nest.n .. " cannot be destroyed and the quest cannot be finished")
		else
			writeStringData(nest.nodeID .. ":lavaBeetleNest", tostring(nest.n))
			SceneObject(pNest):setObjectMenuComponent("LavaBeetleNestsMenuComponent")
		end
	end
end

-- task 5's Radius 50 around the camp coordinate.  Clears the travel leg, and
-- re-arms the cleanup wave if a restart ate its spawns.
function lavaBeetleNestsScreenPlay:spawnCampArea()
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.campX, self.campZ, self.campY, self.campRadius, 0)

	if (pArea == nil) then
		print("lavaBeetleNestsScreenPlay: the mining camp active area failed to spawn; the travel leg cannot clear itself")
		return
	end

	self.campAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "lavaBeetleNestsScreenPlay", "notifyEnteredCamp", pArea)
end

-- ====================================================================
-- Player state
--
-- readScreenPlayData returns "" for a key that was never written and
-- tonumber("") is nil, hence "or 0" everywhere.
-- ====================================================================

function lavaBeetleNestsScreenPlay:getNumber(pPlayer, name)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, name)) or 0
end

function lavaBeetleNestsScreenPlay:setNumber(pPlayer, name, value)
	writeScreenPlayData(pPlayer, self.screenplayName, name, tostring(value))
end

function lavaBeetleNestsScreenPlay:getStage(pPlayer)
	return self:getNumber(pPlayer, "stage")
end

function lavaBeetleNestsScreenPlay:setStage(pPlayer, stage)
	self:setNumber(pPlayer, "stage", stage)
end

-- Which of the two variants is live.  Both drive the same four world nests, so
-- only one can be live at a time; grantNestQuest refuses the second.
function lavaBeetleNestsScreenPlay:getVariant(pPlayer)
	local key = readScreenPlayData(pPlayer, self.screenplayName, "variant")

	if (key == nil or key == "") then
		return nil
	end

	return self.variants[key]
end

function lavaBeetleNestsScreenPlay:isActive(pPlayer)
	local stage = self:getStage(pPlayer)

	return stage > 0 and stage ~= self.STAGE_DONE
end

-- ====================================================================
-- Waypoints and messaging
--
-- No journal row exists for either quest, so journalEntryTitle goes out as a
-- system message and a waypoint name, journalEntryDescription as a system
-- message and a waypoint description.
-- ====================================================================

function lavaBeetleNestsScreenPlay:clearWaypoint(pPlayer)
	local waypointID = self:getNumber(pPlayer, "wp")

	if (waypointID == 0) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

function lavaBeetleNestsScreenPlay:setWaypoint(pPlayer, name, description, x, y)
	self:clearWaypoint(pPlayer)

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)

	self:setNumber(pPlayer, "wp", waypointID)
end

function lavaBeetleNestsScreenPlay:announce(pPlayer, title, description)
	if (title ~= nil and title ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(title)
	end

	if (description ~= nil and description ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(description)
	end
end

-- ====================================================================
-- Grant  --  task 0 (Nothing) into task 5 (Go to Location)
--
-- The giver is Donko Jen, and he is live-sourced on all three counts:
--
--   * NAME -- som_lava_beetle_nest_destroy.stf names "Donko Jen" in task02
--     and task04.
--   * TREE -- SOE's own conversation/lava_beetle_nest_destroy_donko.java,
--     rebuilt node for node at
--     mobile/conversations/mustafar/lava_beetle_nest_destroy_donko.lua.
--   * PLACE -- the live spawn table puts som_foreman_donko in entrance_room_01
--     of the Mensix Mining Facility at -13.5, 10.8, 35, facing 180.  He is
--     spawned there by mensix_mining_facility_main.lua.
--
-- Only his APPEARANCE is a repo choice; see the header of
-- mobile/custom_content/som/foreman_donko.lua.
--
-- variantKey is "one" for som_lava_beetle_nest_destroy and "two" for
-- som_lava_beetle_nest_destroy_2.  BOTH of SOE's grant sites in Donko's tree
-- pass "two" -- s_44 -> s_46 on the first meeting and s_38 -> s_40 on the
-- restart.  Variant one is never granted by him; it has no giver in any
-- shipped script, which is consistent with _2 being the later revision of the
-- same job.  "one" stays wired so a character who already carries it from a
-- pre-existing save still runs and still turns in.
-- ====================================================================

function lavaBeetleNestsScreenPlay:grantNestQuest(pPlayer, variantKey)
	if (pPlayer == nil) then
		return false
	end

	local variant = self.variants[variantKey]

	if (variant == nil) then
		print("lavaBeetleNestsScreenPlay: grantNestQuest called with unknown variant " .. tostring(variantKey))
		return false
	end

	-- Both variants drive the same four snapshot nests, so a second one running
	-- alongside the first would arm and credit the same props twice.
	if (self:isActive(pPlayer)) then
		return false
	end

	self:resetProgress(pPlayer)

	writeScreenPlayData(pPlayer, self.screenplayName, "variant", variant.key)
	self:setStage(pPlayer, self.STAGE_TRAVEL)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)
	self:announce(pPlayer, variant.title, variant.description)
	self:announce(pPlayer, self.travelTitle, self.travelDescription)
	-- task 5, createWaypoint true, waypointName "Kubaza Beetle Infested Mining Camp"
	self:setWaypoint(pPlayer, self.campWaypointName, self.travelDescription, self.campX, self.campY)

	return true
end

--[[ Donko's clear, s_37 -> s_39 and the first half of s_38 -> s_40

SOE runs groundquests.clearQuest on BOTH quest names and then drops the
beetle_nest scriptvar tree if the player still carries one.  Our port keeps the
whole run under one variant key, so clearing both names is clearing the variant,
and the scriptvar tree is the per-nest progress data.  This is that, and it is
NOT failQuest: no fail signal is involved and the player is told nothing.
--]]
function lavaBeetleNestsScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	self:clearWaypoint(pPlayer)
	self:resetProgress(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "variant")
	self:setNumber(pPlayer, "stage", 0)

	return true
end

function lavaBeetleNestsScreenPlay:resetProgress(pPlayer)
	for i = 1, #self.nests do
		local n = self.nests[i].n

		deleteScreenPlayData(pPlayer, self.screenplayName, "nest_" .. n)
		deleteScreenPlayData(pPlayer, self.screenplayName, "nestkills_" .. n)
		deleteScreenPlayData(pPlayer, self.screenplayName, "nestmobs_" .. n)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "cleanupkills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "cleanupmobs")
end

-- ====================================================================
-- task 5 clearing  --  the camp active area
-- ====================================================================

function lavaBeetleNestsScreenPlay:notifyEnteredCamp(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_TRAVEL) then
		self:arriveAtCamp(pPlayer)
	elseif (stage == self.STAGE_CLEANUP) then
		-- A restart takes spawned mobs with it.  Walking back into the camp is
		-- what puts the remaining wave back; nothing in the .qst covers this,
		-- it exists so a restart cannot strand the leg.
		self:refreshCleanupWave(pPlayer)
	end

	return 0
end

function lavaBeetleNestsScreenPlay:arriveAtCamp(pPlayer)
	self:clearWaypoint(pPlayer)
	self:setStage(pPlayer, self.STAGE_NESTS)

	-- task 10, Wait for Tasks, then the leg text tasks 11-14 share.
	self:announce(pPlayer, self.nestsTitle, self.nestsDescription)
	self:announce(pPlayer, self.chargeTitle, self.chargeDescription)
end

-- ====================================================================
-- tasks 11-14 (Wait for Signal) and 15-18 (Encounter)
--
-- The radial on a nest prop is this file's stand-in for the .qst's
-- lava_beetle_nest_<n>_destroyed signal: placing the charge fires the signal
-- and opens that nest's Encounter.  The nest is not counted destroyed until
-- all five soldiers are dead, which is what task 10's Wait for Tasks over
-- destroyed_beetle_soldiers_* actually waits on.
-- ====================================================================

function lavaBeetleNestsScreenPlay:getNest(n)
	for i = 1, #self.nests do
		if (self.nests[i].n == n) then
			return self.nests[i]
		end
	end

	return nil
end

-- Spawned mobs do not survive a restart, so the tracked ids are re-checked
-- before the radial is offered again.  Ids are stored persistently because the
-- player's progress is persistent; the OBJECTS are not.
function lavaBeetleNestsScreenPlay:readMobList(pPlayer, key)
	local packed = readScreenPlayData(pPlayer, self.screenplayName, key)
	local ids = {}

	if (packed == nil or packed == "") then
		return ids
	end

	for id in string.gmatch(packed, "[^,]+") do
		local number = tonumber(id)

		if (number ~= nil) then
			table.insert(ids, number)
		end
	end

	return ids
end

function lavaBeetleNestsScreenPlay:writeMobList(pPlayer, key, ids)
	writeScreenPlayData(pPlayer, self.screenplayName, key, table.concat(ids, ","))
end

function lavaBeetleNestsScreenPlay:anyMobAlive(pPlayer, key)
	local ids = self:readMobList(pPlayer, key)

	for i = 1, #ids do
		if (getSceneObject(ids[i]) ~= nil) then
			return true
		end
	end

	return false
end

-- Encounter Min/Max Distance is a ring around the PLAYER, which is what
-- getSpawnPoint's last two arguments are.  hidden_treasure.lua:356-385 is the
-- same idiom.  respawnTimer 0 is deliberate: AiAgentImplementation.cpp:2283
-- only schedules a RespawnCreatureTask when the timer is above zero, so these
-- are one-shot quest mobs that do not litter the camp forever.
function lavaBeetleNestsScreenPlay:spawnWave(pPlayer, template, count, minDistance, maxDistance, nestNumber)
	local playerID = SceneObject(pPlayer):getObjectID()
	local ids = {}

	for i = 1, count do
		local spawnPoint = getSpawnPoint("mustafar", SceneObject(pPlayer):getWorldPositionX(), SceneObject(pPlayer):getWorldPositionY(), minDistance, maxDistance, true)

		if (spawnPoint ~= nil) then
			local pMobile = spawnMobile("mustafar", template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], 0, 0)

			if (pMobile ~= nil) then
				local mobileID = SceneObject(pMobile):getObjectID()

				writeData(mobileID .. ":lavaBeetlePlayer", playerID)
				writeData(mobileID .. ":lavaBeetleNest", nestNumber)
				table.insert(ids, mobileID)

				createObserver(OBJECTDESTRUCTION, "lavaBeetleNestsScreenPlay", "notifyBeetleKilled", pMobile)
				AiAgent(pMobile):setDefender(pPlayer)
			end
		end
	end

	if (#ids < count) then
		print("lavaBeetleNestsScreenPlay: only " .. #ids .. " of " .. count .. " " .. template .. " spawned near the mining camp")
	end

	return ids
end

-- Called from the nest radial.  nestNumber 1-4.
function lavaBeetleNestsScreenPlay:placeCharge(pPlayer, nestNumber)
	if (self:getStage(pPlayer) ~= self.STAGE_NESTS) then
		return
	end

	local nest = self:getNest(nestNumber)

	if (nest == nil) then
		return
	end

	local state = self:getNumber(pPlayer, "nest_" .. nestNumber)

	-- 2 = this nest is already done for this run.
	if (state == 2) then
		return
	end

	-- 1 = armed, soldiers already out.  Re-arming is only allowed when the
	-- tracked soldiers are all gone, which after a restart they are.
	if (state == 1 and self:anyMobAlive(pPlayer, "nestmobs_" .. nestNumber)) then
		return
	end

	local killed = self:getNumber(pPlayer, "nestkills_" .. nestNumber)
	local remaining = self.soldiersPerNest - killed

	if (remaining < 1) then
		self:completeNest(pPlayer, nestNumber)
		return
	end

	self:setNumber(pPlayer, "nest_" .. nestNumber, 1)

	-- task 11-14's own text, then the Encounter's.
	self:announce(pPlayer, self.chargeTitle, self.chargeDescription)
	self:announce(pPlayer, self.soldierTitle, self.soldierDescription)

	local ids = self:spawnWave(pPlayer, self.soldierTemplate, remaining, self.soldierMinDistance, self.soldierMaxDistance, nestNumber)

	self:writeMobList(pPlayer, "nestmobs_" .. nestNumber, ids)

	-- Nothing to kill would strand this nest at armed forever.
	if (#ids == 0) then
		self:setNumber(pPlayer, "nest_" .. nestNumber, 0)
	end
end

-- The OBJECTDESTRUCTION observer on every soldier this file spawned.  Ownership
-- is read back off the mob, so a mob belonging to another player's run cannot
-- credit this one.  Returns 1 on every path so the observer is dropped with the
-- object; hidden_treasure.lua:389-417 is the same shape.
function lavaBeetleNestsScreenPlay:notifyBeetleKilled(pMobile, pKiller)
	if (pMobile == nil) then
		return 1
	end

	local mobileID = SceneObject(pMobile):getObjectID()
	local ownerID = readData(mobileID .. ":lavaBeetlePlayer")
	local nestNumber = readData(mobileID .. ":lavaBeetleNest")
	local pPlayer = getSceneObject(ownerID)

	deleteData(mobileID .. ":lavaBeetlePlayer")
	deleteData(mobileID .. ":lavaBeetleNest")

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	if (nestNumber == 0) then
		self:creditCleanupKill(pPlayer)
	else
		self:creditNestKill(pPlayer, nestNumber)
	end

	return 1
end

function lavaBeetleNestsScreenPlay:creditNestKill(pPlayer, nestNumber)
	if (self:getStage(pPlayer) ~= self.STAGE_NESTS) then
		return
	end

	if (self:getNumber(pPlayer, "nest_" .. nestNumber) ~= 1) then
		return
	end

	local killed = self:getNumber(pPlayer, "nestkills_" .. nestNumber)

	if (killed >= self.soldiersPerNest) then
		return
	end

	killed = killed + 1
	self:setNumber(pPlayer, "nestkills_" .. nestNumber, killed)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
	CreatureObject(pPlayer):sendSystemMessage(self.soldierTitle .. " " .. killed .. "/" .. self.soldiersPerNest)

	if (killed >= self.soldiersPerNest) then
		self:completeNest(pPlayer, nestNumber)
	end
end

-- task 10's Task<n> Display String, all four of which are this same string.
function lavaBeetleNestsScreenPlay:completeNest(pPlayer, nestNumber)
	self:setNumber(pPlayer, "nest_" .. nestNumber, 2)
	deleteScreenPlayData(pPlayer, self.screenplayName, "nestmobs_" .. nestNumber)

	CreatureObject(pPlayer):sendSystemMessage(self.nestDestroyedText)

	self:checkNests(pPlayer)
end

-- task 10, Wait for Tasks: all four legs before task 6 opens.
function lavaBeetleNestsScreenPlay:checkNests(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_NESTS) then
		return
	end

	local done = 0

	for i = 1, #self.nests do
		if (self:getNumber(pPlayer, "nest_" .. self.nests[i].n) == 2) then
			done = done + 1
		end
	end

	CreatureObject(pPlayer):sendSystemMessage(self.nestsTitle .. " " .. done .. "/" .. #self.nests)

	if (done < #self.nests) then
		return
	end

	self:startCleanup(pPlayer)
end

-- ====================================================================
-- task 6 (Encounter)  --  the eight that got out
-- ====================================================================

function lavaBeetleNestsScreenPlay:startCleanup(pPlayer)
	self:setStage(pPlayer, self.STAGE_CLEANUP)
	self:setNumber(pPlayer, "cleanupkills", 0)

	self:announce(pPlayer, self.cleanupTitle, self.cleanupDescription)

	local ids = self:spawnWave(pPlayer, self.cleanupTemplate, self.cleanupCount, self.cleanupMinDistance, self.cleanupMaxDistance, 0)

	self:writeMobList(pPlayer, "cleanupmobs", ids)
end

-- Not from the .qst.  Re-arms the remainder of the wave when the tracked mobs
-- are all gone but the count is not met -- the restart case.
function lavaBeetleNestsScreenPlay:refreshCleanupWave(pPlayer)
	if (self:anyMobAlive(pPlayer, "cleanupmobs")) then
		return
	end

	local killed = self:getNumber(pPlayer, "cleanupkills")
	local remaining = self.cleanupCount - killed

	if (remaining < 1) then
		self:finishCleanup(pPlayer)
		return
	end

	self:announce(pPlayer, self.cleanupTitle, self.cleanupDescription)

	local ids = self:spawnWave(pPlayer, self.cleanupTemplate, remaining, self.cleanupMinDistance, self.cleanupMaxDistance, 0)

	self:writeMobList(pPlayer, "cleanupmobs", ids)
end

function lavaBeetleNestsScreenPlay:creditCleanupKill(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_CLEANUP) then
		return
	end

	local killed = self:getNumber(pPlayer, "cleanupkills")

	if (killed >= self.cleanupCount) then
		return
	end

	killed = killed + 1
	self:setNumber(pPlayer, "cleanupkills", killed)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
	CreatureObject(pPlayer):sendSystemMessage(self.cleanupTitle .. " " .. killed .. "/" .. self.cleanupCount)

	if (killed >= self.cleanupCount) then
		self:finishCleanup(pPlayer)
	end
end

-- task 9, Wait for Signal, mustafar_lava_beetle_nest_reward.
--
-- This used to fire signalReward itself, because no giver had been found and the
-- player would otherwise have been parked at a stage nothing could clear.  Donko
-- Jen has been found and placed, so that deviation is gone: this sets the stage,
-- sends task 9's shipped text and stops.  His hand-in screen fires the signal.
function lavaBeetleNestsScreenPlay:finishCleanup(pPlayer)
	self:setStage(pPlayer, self.STAGE_RETURN)
	deleteScreenPlayData(pPlayer, self.screenplayName, "cleanupmobs")

	self:announce(pPlayer, self.returnTitle, self.returnDescription)
end

-- ====================================================================
-- task 19, Immediately Complete Quest, and the [list] payout
--
-- Bank Credits 10000 granted literally.  Experience Amount 0 and Faction
-- Amount 0 are honoured literally too: nothing is granted for either.
-- allowRepeats is true, so STAGE_DONE is a record, not a lock.
-- ====================================================================

function lavaBeetleNestsScreenPlay:signalReward(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_RETURN) then
		return false
	end

	local variant = self:getVariant(pPlayer)

	self:clearWaypoint(pPlayer)
	self:setStage(pPlayer, self.STAGE_DONE)
	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	-- Two quests, one function -- discriminator is getVariant.
	if (variant ~= nil and variant.key == "one") then
		MustafarQuestXp:award(pPlayer, "som_lava_beetle_nest_destroy")
	elseif (variant ~= nil and variant.key == "two") then
		MustafarQuestXp:award(pPlayer, "som_lava_beetle_nest_destroy_2")
	end

	if (variant ~= nil) then
		self:setNumber(pPlayer, "runs_" .. variant.key, self:getNumber(pPlayer, "runs_" .. variant.key) + 1)
	end

	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	-- Written here; the .qst has no line for handing the payout over.
	CreatureObject(pPlayer):sendSystemMessage("You have been paid " .. self.rewardCredits .. " credits for clearing out the kubaza beetle nests.")

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	-- The full-inventory notice is the shipped row @error_message:inv_full, "Your
	-- inventory is full." -- the same one the base server's own reward handlers
	-- use.  There is no shipped row for the success case: in live the item simply
	-- appeared, and base_player.stf's only item-arrival rows are loot rows, which
	-- this is not.  So the item is handed over silently, exactly as it was.
	if (pInventory == nil) then
		print("lavaBeetleNestsScreenPlay: player has no inventory; " .. self.rewardName .. " could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		CreatureObject(pPlayer):sendSystemMessage("@error_message:inv_full")
	end

	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	return true
end

-- ====================================================================
-- The fail branch  --  variant two only, tasks 20 and 21
--
-- Nothing shipped says what fails an Encounter, so nothing calls this.  It is
-- here so that whoever rules the failure condition has the clear-quest half
-- already written.  See THE FAIL BRANCH in the header.
-- ====================================================================

function lavaBeetleNestsScreenPlay:failQuest(pPlayer)
	if (pPlayer == nil or not self:isActive(pPlayer)) then
		return false
	end

	local variant = self:getVariant(pPlayer)

	-- som_lava_beetle_nest_destroy has no signalsOnFail on any task.
	if (variant == nil or variant.failSignal == nil) then
		return false
	end

	self:clearWaypoint(pPlayer)
	self:resetProgress(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "variant")
	self:setNumber(pPlayer, "stage", 0)

	-- task 21's journalEntryTitle.  Its journalEntryDescription is empty.
	CreatureObject(pPlayer):sendSystemMessage("You failed")

	return true
end

--[[ Radial dispatch

One component table serves all four nest props.  SceneObjectImplementation::
setObjectMenuComponent() falls through to LuaObjectMenuComponent when no C++
component of that name is registered, and LuaObjectMenuComponent replaces the
object's menu entirely -- so fillObjectMenuResponse has to add every item we
want to see, and adds nothing at all when this player has no business touching
the nest.

The radial label is the .qst's own wording: "Destroy Kubaza Beetle Nest" is
tasks 11-14's journalEntryTitle.
--]]

LavaBeetleNestsMenuComponent = {}

function lavaBeetleNestsScreenPlay:getRadialText(pPlayer, nestNumber)
	if (nestNumber == nil or nestNumber < 1) then
		return nil
	end

	if (self:getStage(pPlayer) ~= self.STAGE_NESTS) then
		return nil
	end

	local state = self:getNumber(pPlayer, "nest_" .. nestNumber)

	if (state == 2) then
		return nil
	end

	if (state == 1 and self:anyMobAlive(pPlayer, "nestmobs_" .. nestNumber)) then
		return nil
	end

	return self.chargeTitle
end

function LavaBeetleNestsMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local nestNumber = tonumber(readStringData(SceneObject(pSceneObject):getObjectID() .. ":lavaBeetleNest"))
	local text = lavaBeetleNestsScreenPlay:getRadialText(pPlayer, nestNumber)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function LavaBeetleNestsMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local nestNumber = tonumber(readStringData(SceneObject(pSceneObject):getObjectID() .. ":lavaBeetleNest"))

	if (nestNumber ~= nil) then
		lavaBeetleNestsScreenPlay:placeCharge(pPlayer, nestNumber)
	end

	return 0
end
