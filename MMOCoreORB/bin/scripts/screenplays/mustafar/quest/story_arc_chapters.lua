--[[
	Secrets of Mustafar -- the HK-47 story arc, chapters one through three.

	SOURCE OF RECORD
	----------------
	Seven shipped .qst files, read verbatim from C:\swg-extract\_som\quest\ :

		som_story_arc_chapter_one_01.qst      "The Downed Ship"
		som_story_arc_chapter_one_02.qst      "Activating the Terminal"
		som_story_arc_chapter_one_03.qst      "The Transfer of the AI"
		som_story_arc_chapter_two_01.qst      "Wrong Place, Wrong Time"
		som_story_arc_chapter_three_01.qst    "The Trouble with HK-47"
		som_story_arc_chapter_three_02.qst    "Terminal Hack"
		som_story_arc_chapter_three_03.qst    "Destroy HK-47"

	Their journal prose lives in C:\swg-extract\_som\string\en\quest\ground\<name>.stf
	and matches the .qst inline strings, with one shipped disagreement noted below.

	EVERY string, coordinate, radius, count, item template and signal name in this
	file is quoted from those seven .qst files. Where a value is quoted, the comment
	says which task it came from. Where a value is NOT in the shipped data it is
	labelled INFERRED or SUBSTITUTED and it is also listed as an open decision in the
	hand-back report -- it is not dressed up as shipped data.

	Coordinate mapping: the .qst writes LocationX / LocationY / LocationZ where
	LocationY is the HEIGHT. Core3 takes (x, z, y). So x = LocationX,
	z = LocationY, y = LocationZ. Every coordinate comment below prints the .qst
	triple in .qst order so it can be diffed against the file by eye.

	THERE IS NO JOURNAL
	-------------------
	None of these seven quests has a row in datatables/player/quests.iff -- the
	loaded copy in stardust_03.tre carries 307 rows and its only Mustafar entries
	are the 45 exploration markers at 188-232. A quest id with no table row does
	nothing, so nothing is added to managers/quest/quest_manager.lua. Progress is
	held in persistent screenplay data, and the shipped journalEntryTitle /
	journalEntryDescription prose is delivered as system messages and waypoint
	descriptions instead. This is exactly what map_exploration.lua and
	story_arc_prelude.lua already do on this planet.

	WHERE THIS PICKS UP
	-------------------
	story_arc_prelude.lua ends at its STAGE_DONE (8) with Foreman Chivos saying
	Milo Mensix wants to talk to you. That is the hand-off. This file gates its
	first stage on the prelude being finished, read through _G so the two files
	stay independently loadable -- if the prelude is not registered, the gate
	simply reports the prelude is unavailable rather than erroring.

	The .qst files themselves name NO quest giver. There is no grantQuestOnComplete
	chain between any of the seven either: every grantQuestOnComplete,
	grantQuestOnFail, prerequisiteQuest and exclusionQuest field in all seven files
	is empty. The ordering used here is the one the journal prose states
	("Return to Milo", "Return to the Ship's Computer", ...), not one the data
	encodes. Milo Mensix as the giver of chapter one comes from the prelude's
	closing line plus chapter one's own list prose ("Milo Mensix wants a permanent
	solution ..."), not from a giver field. OPEN DECISION.

	THE TASK LISTS, TRANSCRIBED
	---------------------------
	Task ids below are the .qst's own ids, which are not sequential -- they are
	reproduced in the .qst's authored order, not sorted.

	som_story_arc_chapter_one_01  -- level 80, tier -1, type group
		0  Nothing            (music sound/mus_mustafar_quest_exception.snd)
		1  Go to Location     "Travel to the Wreckage"
		                      mustafar -2672 / 130 / 3154, radius 300,
		                      createWaypoint 0, taskName mustafar_orc_one
		2  Wait for Signal    "Locate a Working Terminal"
		                      signal mustafar_orc_complete
		                      (music sound/mus_mustafar_quest_success.snd)

	som_story_arc_chapter_one_02  -- level 80
		0  Retrieve Item      "Salvage Circuit Boards"
		                      object/tangible/quest/must_crash_site_destroyed_terminal.iff
		                      count 1, drop 100, menu text "Remove Circuit Board"
		1  Destroy Multiple and Loot  "Search Salvage Bandits"
		                      social group must_bandit, loot "Circuit Board",
		                      4 required, drop 60
		2  Retrieve Item      "Fix Terminal"
		                      object/tangible/quest/must_orc_computer.iff
		                      count 1, drop 100, menu text "Install Circuit Boards"
		6  Wait for Signal    "Activate Computer"  signal access_computer_fixed

	som_story_arc_chapter_one_03  -- level 80, tier 6, type group
		0  Nothing
		1  Wait for Signal    "Create an Uplink"   signal mustafar_uplink_established
		                      createWaypoint TRUE, waypoint name "Kubaza Beetle Cavern",
		                      mustafar -3604 / 157 / 3483
		6  Wait for Signal    "Return to the Ship's Computer"
		                      signal mustafar_uplink_make_transfer
		2  Wait for Signal    "Travel to the Old Republic Facility"
		                      signal mustafar_uplink_comm
		3  Wait for Signal    "Turn Facility Power On"  signal mustafar_uplink_power
		7  Show Message Box   title "Message From Ship's AI"
		5  Wait for Signal    "Find Terminal Delta-Five"  signal mustafar_uplink_finish

	som_story_arc_chapter_two_01  -- level 80, tier 6, type group
		0  Wait for Signal    "Investigate the Droid Factory"  signal mustafar_factory_found
		1  Wait for Signal    "Repair the Factory"             signal mustafar_factory_fixed
		5  Go to Location     "Return to the Ship's Computer"
		                      mustafar -758 / 87 / 6067, radius 50
		3  Comm Player        NPC appearance object/mobile/som/hk47.iff
		4  Wait for Signal    "Return to Milo"   signal mustafar_factory_finish

	som_story_arc_chapter_three_01  -- level 80, tier 6, type group
		6  Wait for Signal    "Defeat the Droid Army"  signal mustafar_droidarmy_victory
		                      createWaypoint TRUE, waypoint name "Mustafarian Scout",
		                      mustafar 550 / 157 / -154
		17 Go to Location     "Scout the Droid Factory"
		                      createWaypoint TRUE, waypoint name "Operational Droid Factory",
		                      mustafar 516 / 64 / 1990, radius 50
		9  Wait for Signal    "Search for Answers"   signal mustafar_droidfactory_open
		10 Reward             object/tangible/item/som/droid_factory_history_datapad.iff x1
		11 Wait for Signal    "Enter Droid Factory"  signal mustafar_droidfactory_final
		16 Wait for Signal    "Shut Down Factory"    signal mustafar_droidfactory_shutdown
		14 Wait for Signal    "Return to Milo"       signal mustafar_droidfactory_victory

	som_story_arc_chapter_three_02  -- level 80, tier 1, type SOLO (the only solo one)
		0  Show Message Box   title "Terminal Report"
		1  Wait for Signal    "Get a Terminal Override"
		                      signal mustafar_droid_factory_tool_recieved
		                      (the misspelling is shipped -- it is reproduced, not fixed)

	som_story_arc_chapter_three_03  -- level 80, tier 6, type group
		0  Wait for Signal    "Talk to a Pilot"      signal volcano_arena_pilot
		3  Wait for Signal    "Defeat HK-47"         signal volcano_arena_victory
		5  Wait for Signal    "Return to Milo"       signal hk_story_arc_completed
		6  Wait for Signal    "Check Your Messages"  signal hk47_final_goodbye
		7  Comm Player        NPC appearance object/mobile/som/hk47.iff
		4  Reward             object/tangible/hologram/hologram_hk47.iff x1
		                      (music sound/mus_mustafar_story_arc_complete.snd)

	Verified across all seven: every "Time To Complete", "CountdownTimer",
	"Bank Credits" and "Experience Amount" field is 0, so this arc pays no credits,
	no XP and runs no timers. The only radii in the whole arc are 300, 50 and 50.
	Every quest is level 80.

	THE SIGNALS ARE THE STATE MACHINE
	---------------------------------
	Sixteen of the twenty-nine tasks are "Wait for Signal". A signal in the shipped
	client is fired by some other piece of content -- a conversation, a script, a
	trigger volume -- and none of those senders ship as data we can read. So each
	signal name below is carried as a stage constant and the thing that advances it
	is a radial, an active area, or a kill, chosen to match the task's own prose.
	The signal names are kept verbatim in the table so a future sender can be
	matched to them by name.

	WHAT IS PLACED, AND WHERE IT COMES FROM
	---------------------------------------
	Snapshot first, spawn only where the snapshot has nothing. Every node id below
	was read out of _som/snapshot/stardust_03.tre/snapshot/mustafar.ws and its
	position is printed in that file's own order (x, height, z):

		12111401  must_crash_site_destroyed_terminal   -2668.84  145.20  3263.38
		12112127  must_crash_site_destroyed_terminal   -2670.69  149.81  3278.40
		12112205  must_crashed_republic_ship           -2619.67   99.35  3008.83
		12111374  must_uplink_bunker_entrance          -3591.93  159.29  3489.73
		12112268  droid_factory_history_terminal         529.13   66.15  1968.60
		12112269  droid_factory_entrance_keypad          532.26   65.76  1981.75
		12112909  droid_factory_exterior_door            532.71   68.28  1977.03
		12112250  must_droid_factory_exterior            538.25   62.77  1972.65

	The two crash-site terminals are the ones chapter one task 0 and task 2 need,
	and they are already observed by map_exploration.lua (its crashSiteUsed, on
	both node ids). setObjectMenuComponent REPLACES an object's menu wholesale, so
	setting one here would silently break that file. OBJECTRADIALUSED observers
	stack, so this file attaches a stacking observer to those two nodes and never
	sets a menu component on them. The cost is that the .qst's authored menu labels
	"Remove Circuit Board" and "Install Circuit Boards" cannot be rendered as radial
	text on those two objects -- they are sent as system messages instead. Stated,
	not hidden.

	must_orc_computer is placed inside the crashed cruiser. Node 12112205 is a
	SharedBuildingObjectTemplate whose client iff points at
	appearance/poi_must_crashed_republic_ship.pob, and that pob has cells literally
	named "bridge" and "hallway". interiorlayout/crashed_republic_ship.ilf puts two
	starship pilot chairs in the bridge at (1.151, h 1.658, z 12.430) and
	(-1.224, h 1.658, z 12.152), and the bridge collision floor spans
	x -2.85..2.85, h 1.66..2.04, z 3.84..12.26. The computer goes on the centreline
	between the chairs. That satisfies the .qst's "return to the ship's bridge".

	The Old Republic Facility is already pooled by mustafar_instances.lua
	(pool "old_republic_facility", 12 copies, entrance cell, ungated). Chapter one
	task 2/3/5 and chapter two task 5 all happen there, so the three terminals are
	spawned into EVERY copy in the pool -- the precedent is reunite_shard.lua,
	which furnishes each building of a pool the same way. Their cell-local spots
	come from som_old_republic_facility.ilf's own entrance fixtures: two wall
	terminal banks at (23.430, -0.667, 4.268) and (23.432, -0.696, -4.164), and a
	floor data terminal at (4.426, 0.0, -7.256).

	Core3 never instantiates .ilf furniture, so those coordinates are not "where the
	prop is" -- they are the shipped evidence of where SOE left open floor. That is
	why they are used and why they are cited.

	WHAT COULD NOT BE PLACED FROM DATA
	----------------------------------
	1. The uplink cavern interior. The .qst gives one coordinate for chapter one
	   task 1 (-3604 / 157 / 3483) and mustafar_instances.lua has a nine-copy
	   "uplink_cave" pool whose door node is 12111281 -- and its own comment says
	   the pool is deliberately not wired ("Wire the quest first, then the door.").
	   That file belongs to another agent this run, so it is NOT edited. This file
	   exposes mayEnterUplinkCave(pPlayer) for it to call, and the report states the
	   exact table it needs.
	   The repair droid, the relay it builds and the beetle wave count are not in
	   the .qst at all. A Mark I Mining Droid stands in for the repair droid and
	   must_satellite_uplink for the relay; the wave is four beetles. Both are
	   labelled SUBSTITUTED / INFERRED at their table entries.

	2. The droid factory interior. Chapter two task 1 says "travel to the bottom of
	   the factory and restart the main computer processor" and chapter three task 16
	   says "find a way to shut down the factory". mustafar_instances.lua carries
	   working_droid_factory and decrepit_droid_factory pools behind door 12112909,
	   also deliberately unwired, and there is NO droid factory .ilf shipped -- only
	   nine .ilf files exist and none of them is the factory. With no interior
	   layout there is no defensible interior coordinate to invent, so both steps
	   are driven from the exterior door node the snapshot does place. The report
	   lists this as the largest single reduction in this port.

	3. Chapter three chapter 03 carries NO coordinates whatsoever -- not for the
	   volcano crater arena, not for HK-47's last stand, not for the pilot, not for
	   the terminal "located in this room". Every position used for that chapter is
	   INFERRED and labelled as such. HK-47 stands near node 12112130, the highest
	   snapshot node in the whole central-volcano region (246.58, out of 45 nodes
	   scanned across x -3400..-2300, z 2900..4800), because the list prose says
	   "the highest point in the area, a nearby volcano crater". That is a reading
	   of the prose, not a datum.

	4. No conversation table ships for Milo Mensix, for a pilot, or for a droid
	   factory engineer. Twenty-five SOM conversation STFs were enumerated and none
	   of them covers these three. Building a real conversation needs
	   mobile/conversations.lua plus a creature template edit -- shared files owned
	   by other agents this run, and repointing an existing conversationTemplate is
	   forbidden outright. So every NPC beat here is a radial plus an SUI box, the
	   same call story_arc_prelude.lua made for Foreman Chivos and for the same
	   reason.

	5. The two Comm Player tasks (chapter two task 3, chapter three chapter 03
	   task 7) cannot be rendered. There is no comm-player primitive exposed to Lua;
	   hk_history.lua:47-80 records that search in full. Both are delivered as SUI
	   message boxes carrying the .qst's text verbatim, titled with the speaker.

	6. "Social Group must_bandit" is not usable as a discriminator: every ported SOM
	   creature template carries socialGroup "townsperson" or "". The two concrete
	   registered bandit templates are enumerated instead
	   (mobile/custom_content/som/serverobjects.lua:72-73).

	PROGRESS TRACKING
	-----------------
	One integer, "stage", in persistent screenplay data, 0 through 26, plus a small
	number of named flags for the within-stage counters (circuit boards, beetle
	kills, droid army kills, the chapter 03/02 override tool). readScreenPlayData
	returns "" for a key that was never written and tonumber("") is nil, hence the
	"or 0" idiom throughout -- the same idiom story_arc_prelude.lua uses.

	NO TIMERS
	---------
	Nothing here is on a clock. Every one of the seven .qst files has
	"Time To Complete" 0 and "CountdownTimer" 0, so there is nothing to settle
	lazily and no createEvent survives-a-restart problem to solve. The one durable
	subscription is a single KILLEDCREATURE observer created with persistence 1 when
	the arc starts and dropped at the final stage; it serves all four kill legs.

	SPAWNS ARE NOT PERSISTENT
	-------------------------
	DirectorManager.cpp:2707 passes persistent = false for every spawnMobile, so all
	of these mobs die with the process; each carries a respawn timer so
	AiAgentImplementation.cpp:2283 rebuilds it, and start() re-places them on every
	boot. No stage waits on a mob that only exists once.

	WHAT IS NOT MODELLED
	--------------------
	- No journal. There is no table row to write to. See above.
	- No credits, no XP, no timers. The .qst asks for none of them.
	- The two Retrieve Item menu labels on the crash-site terminals, for the
	  menu-component collision described above.
	- The droid factory and uplink cavern interiors, for the missing-geometry reason
	  described above.
	- The two Comm Player renders, delivered as SUI instead.
	- Nothing in this file touches screenplays.lua, mustafar_instances.lua,
	  conversations.lua, any creature template, or any other agent's screenplay.
--]]

storyArcChaptersScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "storyArcChaptersScreenPlay",

	-- Level 80 on all seven .qst files.
	requiredLevel = 80,

	-- The prelude's terminal stage. story_arc_prelude.lua declares STAGE_DONE = 8
	-- and ends with Chivos pointing the player at Milo Mensix.
	preludeScreenPlayName = "storyArcPreludeScreenPlay",
	preludeDoneStage = 8,

	--------------------------------------------------------------------------
	-- CHAPTER ONE 01 -- "The Downed Ship"
	--------------------------------------------------------------------------

	-- task 1 Go to Location, mustafar LocationX -2672 LocationY 130 LocationZ 3154,
	-- Radius(m) 300, createWaypoint 0, taskName mustafar_orc_one.
	-- createWaypoint is 0, so the shipped quest gave NO waypoint for this leg; the
	-- ring is still authored, so the ring is what is built.
	wreckArea = { x = -2672, z = 130, y = 3154, radius = 300 },

	-- task 2 signal.
	SIGNAL_ORC_COMPLETE = "mustafar_orc_complete",

	--------------------------------------------------------------------------
	-- CHAPTER ONE 02 -- "Activating the Terminal"
	--------------------------------------------------------------------------

	-- task 0 / task 2 target templates, quoted.
	-- Both crash-site terminal nodes are already observed by map_exploration.lua,
	-- so this file stacks an OBJECTRADIALUSED observer and sets NO menu component.
	crashTerminals = { 12111401, 12112127 },

	-- task 2's target: object/tangible/quest/must_orc_computer.iff, registered by
	-- addTemplate in object/custom_content/tangible/quest/must_orc_computer.lua:5,
	-- included from object/custom_content/tangible/quest/serverobjects.lua:259.
	orcComputerTemplate = "object/tangible/quest/must_orc_computer.iff",

	-- The cruiser, node 12112205. Cell "bridge" comes from the pob; the local spot
	-- is the centreline between the two shipped pilot chairs, on the bridge floor
	-- (h 1.66) at forward 11.3, just short of the chairs at forward 12.15/12.43.
	cruiser = { nodeID = 12112205, cell = "bridge", x = 0.0, z = 1.66, y = 11.3, heading = 180 },

	-- task 1: 4 circuit boards at 60 percent, from Salvage Bandits.
	-- "Social Group must_bandit" is unusable (all SOM templates carry socialGroup
	-- "townsperson" or ""), so the concrete registered templates are enumerated;
	-- both are included from mobile/custom_content/som/serverobjects.lua:72-73.
	banditTemplates = { "must_salvage_bandit_01", "must_salvage_bandit_leader_01" },
	boardsRequired = 4,
	boardDropPercent = 60,

	-- task 6 signal.
	SIGNAL_ACCESS_COMPUTER = "access_computer_fixed",

	--------------------------------------------------------------------------
	-- CHAPTER ONE 03 -- "The Transfer of the AI"
	--------------------------------------------------------------------------

	-- task 1 carries createWaypoint TRUE and its own waypoint name.
	-- mustafar LocationX -3604 LocationY 157 LocationZ 3483.
	kubazaCavern = { x = -3604, z = 157, y = 3483, waypointName = "Kubaza Beetle Cavern" },

	-- The uplink bunker entrance the snapshot places beside that coordinate.
	-- 12111374 shared_must_uplink_bunker_entrance.iff  -3591.93 h 159.29 3489.73.
	-- Node 12111281 is the door, and mustafar_instances.lua records it as the
	-- uplink_cave pool door, deliberately unwired. Not touched here.
	uplinkEntrance = { nodeID = 12111374 },

	-- SUBSTITUTED: the .qst names "an automated repair droid" and "the relay it
	-- makes" but gives no template for either. must_mining_droid_mark_01 is the only
	-- registered SOM utility droid (mobile/custom_content/som/serverobjects.lua:69)
	-- and must_satellite_uplink is the one registered uplink prop
	-- (object/custom_content/building/mustafar/items/serverobjects.lua:12).
	repairDroid = { template = "must_mining_droid_mark_01", respawn = 300 },
	uplinkRelayTemplate = "object/building/mustafar/items/must_satellite_uplink.iff",

	-- INFERRED: the .qst states beetles attack the droid and the relay but gives no
	-- count and no templates. All three registered kubaza templates are accepted as
	-- kills (mobile/custom_content/som/serverobjects.lua:55-57); four is the
	-- authored wave size.
	kubazaTemplates = { "kubaza_beetle", "kubaza_soldier_beetle", "kubaza_worker_beetle" },
	kubazaRequired = 4,

	-- task 1 / 6 / 2 / 3 / 5 signals, verbatim.
	SIGNAL_UPLINK_ESTABLISHED = "mustafar_uplink_established",
	SIGNAL_UPLINK_TRANSFER = "mustafar_uplink_make_transfer",
	SIGNAL_UPLINK_COMM = "mustafar_uplink_comm",
	SIGNAL_UPLINK_POWER = "mustafar_uplink_power",
	SIGNAL_UPLINK_FINISH = "mustafar_uplink_finish",

	-- The Old Republic Facility pool, already declared by mustafar_instances.lua.
	-- Three terminals go into the entrance cell of every copy. The local spots are
	-- the .ilf's own entrance fixtures, cited in the header.
	orfPool = "old_republic_facility",
	orfCell = "entrance",
	orfContact = { x = 22.4, z = 0.0, y = -4.16, heading = 270 },
	orfPower = { x = 4.43, z = 0.0, y = -7.26, heading = 0 },
	orfDeltaFive = { x = 22.4, z = 0.0, y = 4.27, heading = 270 },

	-- The power terminal template: object/tangible/quest/must_control_computer.iff,
	-- registered by addTemplate in
	-- object/custom_content/tangible/quest/must_control_computer.lua:5, included
	-- from object/custom_content/tangible/quest/serverobjects.lua:253.
	controlComputerTemplate = "object/tangible/quest/must_control_computer.iff",

	--------------------------------------------------------------------------
	-- CHAPTER TWO 01 -- "Wrong Place, Wrong Time"
	--------------------------------------------------------------------------

	-- task 5 Go to Location, mustafar LocationX -758 LocationY 87 LocationZ 6067,
	-- Radius(m) 50. This is the Old Republic Facility's outdoor doorstep;
	-- mustafar_instances.lua records the ORF exit at x -771.6 y 6082.8, 21 m away.
	orfReturnArea = { x = -758, z = 87, y = 6067, radius = 50 },

	-- task 0 / 1 / 4 signals, verbatim.
	SIGNAL_FACTORY_FOUND = "mustafar_factory_found",
	SIGNAL_FACTORY_FIXED = "mustafar_factory_fixed",
	SIGNAL_FACTORY_FINISH = "mustafar_factory_finish",

	--------------------------------------------------------------------------
	-- CHAPTER THREE 01 -- "The Trouble with HK-47"
	--------------------------------------------------------------------------

	-- task 6 createWaypoint TRUE, waypoint name "Mustafarian Scout",
	-- mustafar LocationX 550 LocationY 157 LocationZ -154. No radius on this task.
	-- must_scout is included from mobile/custom_content/som/serverobjects.lua:74,
	-- but its own template carries customName = "must_scout"
	-- (must_scout.lua:2) -- an unresolved placeholder, so he will display as
	-- "must_scout" in game. That is a template defect, not a screenplay one, and
	-- the template is not this file's to edit. OPEN DECISION.
	scoutPost = { x = 550, y = -154, waypointName = "Mustafarian Scout", respawn = 300 },

	-- INFERRED: the .qst says "an army of droids" with no roster and no count.
	-- These are the three registered SOM battle droid templates
	-- (mobile/custom_content/som/serverobjects.lua:41-43); six is the authored
	-- wave size.
	droidArmy = {
		{ template = "cww8_battle_droid", count = 3 },
		{ template = "cww8a_battle_droid", count = 2 },
		{ template = "cww8a_eradicator", count = 1 },
	},
	droidArmyRequired = 6,

	-- task 17 Go to Location, createWaypoint TRUE,
	-- waypoint name "Operational Droid Factory",
	-- mustafar LocationX 516 LocationY 64 LocationZ 1990, Radius(m) 50.
	-- One ring serves task 0 of chapter two as well; that task carries no
	-- coordinates of its own and names the same building.
	factoryArea = { x = 516, z = 64, y = 1990, radius = 50, waypointName = "Operational Droid Factory" },

	-- Snapshot furniture on the factory's doorstep.
	factoryTerminal = { nodeID = 12112268 },
	factoryKeypad = { nodeID = 12112269 },
	factoryDoor = { nodeID = 12112909 },

	-- task 10 Reward: object/tangible/item/som/droid_factory_history_datapad.iff,
	-- CountItem 1. Registered by addTemplate in
	-- object/custom_content/tangible/item/som/droid_factory_history_datapad.lua:5,
	-- included from object/custom_content/tangible/item/som/serverobjects.lua:10.
	datapadTemplate = "object/tangible/item/som/droid_factory_history_datapad.iff",

	-- task 11: "The information downloaded onto the datapad might have clues about
	-- what the code of the door is." The code is not in the .qst. It is in the
	-- shipped droid factory history log, entry 7, which hk_history.lua already
	-- carries verbatim: "... Alter door passcode...37323."
	factoryPasscode = "37323",
	factoryHistoryEntry = 7,

	-- task 9 / 11 / 16 / 14 signals, verbatim.
	SIGNAL_FACTORY_OPEN = "mustafar_droidfactory_open",
	SIGNAL_FACTORY_FINAL = "mustafar_droidfactory_final",
	SIGNAL_FACTORY_SHUTDOWN = "mustafar_droidfactory_shutdown",
	SIGNAL_FACTORY_VICTORY = "mustafar_droidfactory_victory",

	--------------------------------------------------------------------------
	-- CHAPTER THREE 02 -- "Terminal Hack" (solo side branch)
	--------------------------------------------------------------------------

	-- task 1 signal. The misspelling "recieved" is shipped and is reproduced as-is.
	SIGNAL_OVERRIDE_TOOL = "mustafar_droid_factory_tool_recieved",

	--------------------------------------------------------------------------
	-- CHAPTER THREE 03 -- "Destroy HK-47"
	--------------------------------------------------------------------------

	-- INFERRED, every position in this block. This .qst carries no coordinates.
	-- miner_pilot is included from mobile/custom_content/som/serverobjects.lua:65
	-- and carries pvpBitmask NONE, so he is safe to stand in the open.
	-- The spot is beside the two travellers mensix_mining_facility_main.lua already
	-- places outdoors at (-2481, 230.1, 1633.7) and (-2483.1, 230.1, 1635.7);
	-- 230.1 is their proven standing height there.
	pilot = { template = "miner_pilot", x = -2476, z = 230.1, y = 1627, heading = 45, respawn = 300 },

	-- INFERRED. "the highest point in the area, a nearby volcano crater" -- node
	-- 12112130 (must_power_rod, -2742.13 h 246.58 3636.59) is the highest snapshot
	-- node in the whole central-volcano region. hk47 is included from
	-- mobile/custom_content/som/serverobjects.lua:50.
	hk47 = { template = "hk47", x = -2748, y = 3642, heading = 0, respawn = 300 },

	-- task 4 Reward: object/tangible/hologram/hologram_hk47.iff, CountItem 1,
	-- lootCount 1. Registered by addTemplate in
	-- object/custom_content/tangible/hologram/hologram_hk47.lua:1, included from
	-- object/custom_content/tangible/hologram/serverobjects.lua:4.
	hologramTemplate = "object/tangible/hologram/hologram_hk47.iff",

	-- task 0 / 3 / 5 / 6 signals, verbatim.
	SIGNAL_PILOT = "volcano_arena_pilot",
	SIGNAL_ARENA_VICTORY = "volcano_arena_victory",
	SIGNAL_ARC_COMPLETE = "hk_story_arc_completed",
	SIGNAL_FINAL_GOODBYE = "hk47_final_goodbye",

	--------------------------------------------------------------------------
	-- MILO MENSIX -- the arc's anchor NPC
	--------------------------------------------------------------------------

	-- must_milo_mensix is included from
	-- mobile/custom_content/som/serverobjects.lua:68, customName
	-- "Milo Mensix", level 70, conversationTemplate "" -- so he has no shipped
	-- conversation and is driven by radial. Cell 12112226 is medium_room_01 of the
	-- Mensix mining facility (confirmed against must_mining_facility.ilf's own
	-- bounding box, x -100.12..-67.41 / h 10.39..142.84 / z 35.41..72.12), the same
	-- cell story_arc_prelude.lua and mensix_mining_facility_main.lua already use.
	-- The spot clears all seven existing occupants of that room by 8 m or more and
	-- the nearest .ilf clutter by 5.66 m.
	milo = { template = "must_milo_mensix", cellID = 12112226, x = -87, z = 10.8, y = 62, heading = 180, respawn = 300 },

	-- "the terminal located in this room" -- chapter three chapter 03 task 6.
	-- INFERRED position, same cell, beside Milo.
	miloTerminal = { x = -89.5, z = 10.8, y = 62.5, heading = 90 },

	--------------------------------------------------------------------------
	-- STAGES
	--------------------------------------------------------------------------

	STAGE_NONE = 0,

	-- chapter one 01
	STAGE_TRAVEL_WRECK = 1,
	STAGE_FIND_TERMINAL = 2,

	-- chapter one 02
	STAGE_SALVAGE_BOARDS = 3,
	STAGE_SEARCH_BANDITS = 4,
	STAGE_FIX_TERMINAL = 5,
	STAGE_ACTIVATE_COMPUTER = 6,

	-- chapter one 03
	STAGE_UPLINK = 7,
	STAGE_UPLINK_REPORT = 8,
	STAGE_TRAVEL_ORF = 9,
	STAGE_ORF_POWER = 10,
	STAGE_DELTA_FIVE = 11,

	-- chapter two 01
	STAGE_FIND_FACTORY = 12,
	STAGE_REPAIR_FACTORY = 13,
	STAGE_RETURN_ORF = 14,
	STAGE_WARN_MILO = 15,

	-- chapter three 01
	STAGE_DROID_ARMY = 16,
	STAGE_SCOUT_FACTORY = 17,
	STAGE_FACTORY_TERMINAL = 18,
	STAGE_ENTER_FACTORY = 19,
	STAGE_SHUTDOWN_FACTORY = 20,
	STAGE_REPORT_MILO = 21,

	-- chapter three 03
	STAGE_FIND_PILOT = 22,
	STAGE_KILL_HK47 = 23,
	STAGE_REPORT_SUCCESS = 24,
	STAGE_CHECK_MESSAGE = 25,
	STAGE_DONE = 26,

	-- Runtime handles, filled by start(). Never persisted.
	wreckAreaID = 0,
	factoryAreaID = 0,
	orfReturnAreaID = 0,
	miloID = 0,
}

registerScreenPlay("storyArcChaptersScreenPlay", true)

function storyArcChaptersScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachSnapshotObjects()
		self:spawnCruiserComputer()
		self:spawnFacilityTerminals()
		self:spawnMilo()
		self:spawnScout()
		self:spawnPilot()
		self:spawnHk47()
		self:spawnAreas()
	end
end

--------------------------------------------------------------------------------
-- PLACEMENT
--------------------------------------------------------------------------------

-- The two crash-site terminals belong to map_exploration.lua's radial menu.
-- setObjectMenuComponent would replace their menu entirely and break that file,
-- so this attaches a STACKING OBJECTRADIALUSED observer instead and sets no menu
-- component. The .qst's authored menu labels cannot be rendered as a result.
-- Everything else in this list is unclaimed and takes a real menu component.
function storyArcChaptersScreenPlay:attachSnapshotObjects()
	for i = 1, #self.crashTerminals do
		self:observeOnly(self.crashTerminals[i], "crashTerminal")
	end

	self:attachOne(self.uplinkEntrance.nodeID, "uplinkEntrance")
	self:attachOne(self.factoryTerminal.nodeID, "factoryTerminal")
	self:attachOne(self.factoryKeypad.nodeID, "factoryKeypad")
	self:attachOne(self.factoryDoor.nodeID, "factoryDoor")
end

function storyArcChaptersScreenPlay:attachOne(nodeID, role)
	local pObject = getSceneObject(nodeID)

	if (pObject == nil) then
		print("storyArcChaptersScreenPlay: snapshot object " .. nodeID .. " (" .. role .. ") was not found; that step of the arc will be unreachable")
		return
	end

	writeStringData(nodeID .. ":storyArcChaptersRole", role)
	SceneObject(pObject):setObjectMenuComponent("StoryArcChaptersMenuComponent")
end

-- Stack an observer without claiming the menu. The player still gets here by
-- using whatever radial the owning screenplay already draws.
function storyArcChaptersScreenPlay:observeOnly(nodeID, role)
	local pObject = getSceneObject(nodeID)

	if (pObject == nil) then
		print("storyArcChaptersScreenPlay: snapshot object " .. nodeID .. " (" .. role .. ") was not found; that step of the arc will be unreachable")
		return
	end

	writeStringData(nodeID .. ":storyArcChaptersRole", role)
	createObserver(OBJECTRADIALUSED, "storyArcChaptersScreenPlay", "snapshotObjectUsed", pObject)
end

function storyArcChaptersScreenPlay:snapshotObjectUsed(pObject, pPlayer)
	if (pObject == nil or pPlayer == nil) then
		return 0
	end

	local objectID = SceneObject(pObject):getObjectID()
	self:handleUse(pPlayer, readStringData(objectID .. ":storyArcChaptersRole"), objectID)
	return 0
end

-- must_orc_computer goes on the bridge of the crashed cruiser, node 12112205.
-- resolveCell prefers the pob's own named cell and never invents a cell id; the
-- shape is kenobi_spine.lua:resolveCell.
function storyArcChaptersScreenPlay:spawnCruiserComputer()
	local pShip = getSceneObject(self.cruiser.nodeID)

	if (pShip == nil) then
		print("storyArcChaptersScreenPlay: crashed cruiser " .. self.cruiser.nodeID .. " was not found; the ship's computer will not be placed")
		return
	end

	local cellID = self:resolveCell(pShip, self.cruiser.cell)

	if (cellID == 0) then
		print("storyArcChaptersScreenPlay: the crashed cruiser has no cell named '" .. self.cruiser.cell .. "'; the ship's computer will not be placed")
		return
	end

	local pComputer = spawnSceneObject("mustafar", self.orcComputerTemplate, self.cruiser.x, self.cruiser.z, self.cruiser.y, cellID, math.rad(self.cruiser.heading))

	if (pComputer == nil) then
		print("storyArcChaptersScreenPlay: " .. self.orcComputerTemplate .. " failed to spawn on the cruiser bridge")
		return
	end

	writeStringData(SceneObject(pComputer):getObjectID() .. ":storyArcChaptersRole", "shipComputer")
	SceneObject(pComputer):setObjectMenuComponent("StoryArcChaptersMenuComponent")
end

function storyArcChaptersScreenPlay:resolveCell(pBuilding, cellName)
	if (pBuilding == nil) then
		return 0
	end

	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

	if (pCell == nil) then
		return 0
	end

	return SceneObject(pCell):getObjectID()
end

-- The Old Republic Facility is an instance POOL, so every copy has to be
-- furnished or a player who lands in copy 7 finds an empty room. reunite_shard.lua
-- furnishes its fusion machine the same way.
function storyArcChaptersScreenPlay:spawnFacilityTerminals()
	if (MustafarInstances == nil) then
		print("storyArcChaptersScreenPlay: mustafar_instances.lua is not loaded; the Old Republic Facility terminals will not be placed")
		return
	end

	local buildings = MustafarInstances:getPoolBuildings(self.orfPool)

	if (buildings == nil or #buildings == 0) then
		print("storyArcChaptersScreenPlay: instance pool '" .. self.orfPool .. "' is empty; the Old Republic Facility terminals will not be placed")
		return
	end

	for i = 1, #buildings do
		local pBuilding = getSceneObject(buildings[i])
		local cellID = self:resolveCell(pBuilding, self.orfCell)

		if (cellID == 0) then
			print("storyArcChaptersScreenPlay: facility " .. buildings[i] .. " has no cell named '" .. self.orfCell .. "'")
		else
			self:spawnFacilityTerminal(cellID, self.orcComputerTemplate, self.orfContact, "facilityContact")
			self:spawnFacilityTerminal(cellID, self.controlComputerTemplate, self.orfPower, "facilityPower")
			self:spawnFacilityTerminal(cellID, self.orcComputerTemplate, self.orfDeltaFive, "facilityDelta")
		end
	end
end

function storyArcChaptersScreenPlay:spawnFacilityTerminal(cellID, template, spot, role)
	local pTerminal = spawnSceneObject("mustafar", template, spot.x, spot.z, spot.y, cellID, math.rad(spot.heading))

	if (pTerminal == nil) then
		print("storyArcChaptersScreenPlay: " .. template .. " (" .. role .. ") failed to spawn in cell " .. cellID)
		return
	end

	writeStringData(SceneObject(pTerminal):getObjectID() .. ":storyArcChaptersRole", role)
	SceneObject(pTerminal):setObjectMenuComponent("StoryArcChaptersMenuComponent")
end

-- Milo Mensix. He has conversationTemplate "" in his own template, so he is
-- radial-driven; see the header for why no conversation table is authored here.
function storyArcChaptersScreenPlay:spawnMilo()
	local pMilo = spawnMobile("mustafar", self.milo.template, self.milo.respawn, self.milo.x, self.milo.z, self.milo.y, self.milo.heading, self.milo.cellID)

	if (pMilo == nil) then
		print("storyArcChaptersScreenPlay: " .. self.milo.template .. " failed to spawn; the whole arc will be ungiveable")
		return
	end

	-- He has no snapshot node, so keep the id the spawn just handed back --
	-- story_arc_prelude.lua:379 keeps Foreman Chivos's the same way.
	self.miloID = SceneObject(pMilo):getObjectID()
	writeStringData(self.miloID .. ":storyArcChaptersRole", "milo")
	SceneObject(pMilo):setObjectMenuComponent("StoryArcChaptersMenuComponent")

	local pTerminal = spawnSceneObject("mustafar", self.controlComputerTemplate, self.miloTerminal.x, self.miloTerminal.z, self.miloTerminal.y, self.milo.cellID, math.rad(self.miloTerminal.heading))

	if (pTerminal == nil) then
		print("storyArcChaptersScreenPlay: the message terminal in Milo's room failed to spawn")
		return
	end

	writeStringData(SceneObject(pTerminal):getObjectID() .. ":storyArcChaptersRole", "miloTerminal")
	SceneObject(pTerminal):setObjectMenuComponent("StoryArcChaptersMenuComponent")
end

-- The Mustafarian Scout stands at the exact coordinate chapter three 01 task 6
-- names for its waypoint. That task gives a height (157) but the surrounding
-- terrain is authored, so the world floor is used and the .qst height is kept in
-- the comment as the evidence it is.
function storyArcChaptersScreenPlay:spawnScout()
	-- The .qst gave LocationY 157 for this waypoint, but a waypoint height and a
	-- standing height are not the same number, so the live floor is resolved the
	-- way every other file on this planet does it (cursed_shard.lua:257).
	local z = getWorldFloor(self.scoutPost.x, self.scoutPost.y, "mustafar")
	local pScout = spawnMobile("mustafar", "must_scout", self.scoutPost.respawn, self.scoutPost.x, z, self.scoutPost.y, 0, 0)

	if (pScout == nil) then
		print("storyArcChaptersScreenPlay: must_scout failed to spawn at the droid army waypoint")
		return
	end

	writeStringData(SceneObject(pScout):getObjectID() .. ":storyArcChaptersRole", "scout")
	SceneObject(pScout):setObjectMenuComponent("StoryArcChaptersMenuComponent")
end

-- INFERRED position -- chapter three 03 gives no coordinates at all.
function storyArcChaptersScreenPlay:spawnPilot()
	local pPilot = spawnMobile("mustafar", self.pilot.template, self.pilot.respawn, self.pilot.x, self.pilot.z, self.pilot.y, self.pilot.heading, 0)

	if (pPilot == nil) then
		print("storyArcChaptersScreenPlay: " .. self.pilot.template .. " failed to spawn; the 'Talk to a Pilot' step will be unreachable")
		return
	end

	writeStringData(SceneObject(pPilot):getObjectID() .. ":storyArcChaptersRole", "pilot")
	SceneObject(pPilot):setObjectMenuComponent("StoryArcChaptersMenuComponent")
end

-- INFERRED position -- see the header. HK-47 is hostile and is left standing;
-- his kill is caught by the shared KILLEDCREATURE observer, not by a radial.
function storyArcChaptersScreenPlay:spawnHk47()
	local z = getWorldFloor(self.hk47.x, self.hk47.y, "mustafar")
	local pHk = spawnMobile("mustafar", self.hk47.template, self.hk47.respawn, self.hk47.x, z, self.hk47.y, self.hk47.heading, 0)

	if (pHk == nil) then
		print("storyArcChaptersScreenPlay: " .. self.hk47.template .. " failed to spawn at the crater; 'Defeat HK-47' will be uncompletable")
	end
end

function storyArcChaptersScreenPlay:spawnAreas()
	self.wreckAreaID = self:spawnRing(self.wreckArea, "wreck")
	self.factoryAreaID = self:spawnRing(self.factoryArea, "factory")
	self.orfReturnAreaID = self:spawnRing(self.orfReturnArea, "orfReturn")
end

function storyArcChaptersScreenPlay:spawnRing(area, role)
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", area.x, area.z, area.y, area.radius, 0)

	if (pArea == nil) then
		print("storyArcChaptersScreenPlay: the '" .. role .. "' active area failed to spawn")
		return 0
	end

	local areaID = SceneObject(pArea):getObjectID()
	writeStringData(areaID .. ":storyArcChaptersRole", role)
	createObserver(ENTEREDAREA, "storyArcChaptersScreenPlay", "notifyEnteredArea", pArea)
	return areaID
end

--------------------------------------------------------------------------------
-- STATE
--------------------------------------------------------------------------------

-- readScreenPlayData hands back "" for a key that was never written, and
-- tonumber("") is nil, hence "or 0" on every read.
function storyArcChaptersScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function storyArcChaptersScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function storyArcChaptersScreenPlay:getCount(pPlayer, key)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0
end

function storyArcChaptersScreenPlay:addCount(pPlayer, key)
	local count = self:getCount(pPlayer, key) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, key, tostring(count))
	return count
end

function storyArcChaptersScreenPlay:hasFlag(pPlayer, key)
	return self:getCount(pPlayer, key) == 1
end

function storyArcChaptersScreenPlay:setFlag(pPlayer, key)
	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
end

-- The prelude is read through _G so this file loads and runs whether or not
-- story_arc_prelude.lua is registered. If it is absent the arc simply refuses to
-- start rather than erroring -- Core3 would otherwise index a nil global.
function storyArcChaptersScreenPlay:isPreludeComplete(pPlayer)
	local prelude = _G[self.preludeScreenPlayName]

	if (prelude == nil or prelude.getStage == nil) then
		return false
	end

	return prelude:getStage(pPlayer) >= self.preludeDoneStage
end

--------------------------------------------------------------------------------
-- PLAYER FEEDBACK
--------------------------------------------------------------------------------

-- There is no journal row for any of these seven quests, so the .qst's own
-- journalEntryTitle and journalEntryDescription are delivered here: the title as
-- a system message, the description as a message box the player can read at
-- leisure. Nothing is paraphrased on the way through.
function storyArcChaptersScreenPlay:announceTask(pPlayer, title, description)
	CreatureObject(pPlayer):sendSystemMessage(title)
	self:showMessageBox(pPlayer, title, description)
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
end

function storyArcChaptersScreenPlay:showMessageBox(pPlayer, title, prompt)
	local sui = SuiMessageBox.new("storyArcChaptersScreenPlay", "messageBoxCallback")

	sui.setTitle(title)
	sui.setPrompt(prompt)
	sui.sendTo(pPlayer)
end

-- Nothing to do -- the box is read-only. It still needs a callback to exist or
-- the SUI framework has nothing to bind to.
function storyArcChaptersScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

function storyArcChaptersScreenPlay:giveWaypoint(pPlayer, key, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer, key)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key, tostring(waypointID))
end

function storyArcChaptersScreenPlay:removeWaypoint(pPlayer, key)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)
end

-- Named grantItem, not giveItem, so it can never be confused with the global
-- giveItem() it calls.
function storyArcChaptersScreenPlay:grantItem(pPlayer, template, message)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("storyArcChaptersScreenPlay: player has no inventory; " .. template .. " was not granted")
		return
	end

	if (giveItem(pInventory, template, -1, true) == nil) then
		print("storyArcChaptersScreenPlay: failed to create " .. template .. "; check it is registered with addTemplate")
		return
	end

	CreatureObject(pPlayer):sendSystemMessage(message)
end

--------------------------------------------------------------------------------
-- THE TASK TEXT, VERBATIM
--------------------------------------------------------------------------------

-- Keyed by the stage the player is ENTERING. Every title and body below is the
-- .qst's own journalEntryTitle / journalEntryDescription, copied character for
-- character including the trailing space chapter two 01 task 5 ships with.
storyArcChaptersScreenPlay.taskText = {
	-- som_story_arc_chapter_one_01 task 1
	[1] = { "Travel to the Wreckage", "Make your way to the central volcano and revisit the crashed Old Republic cruiser." },
	-- som_story_arc_chapter_one_01 task 2
	[2] = { "Locate a Working Terminal", "Amazingly the ship appears to be in better condition then expected. There is a chance that its memory is still intact. If you can locate a working terminal you might be able to access it." },
	-- som_story_arc_chapter_one_02 task 0
	[3] = { "Salvage Circuit Boards", "Sift through the ship's debris and see if you can locate another terminal with good circuit boards to replace the damaged ones." },
	-- som_story_arc_chapter_one_02 task 1
	[4] = { "Search Salvage Bandits", "The Salvage Bandits in the area probably removed the circuit boards from the terminal. Search them until you find the four you need." },
	-- som_story_arc_chapter_one_02 task 2
	[5] = { "Fix Terminal", "Now that you have the four circuit boards, return to the ship's bridge and attach them to the terminal." },
	-- som_story_arc_chapter_one_02 task 6
	[6] = { "Activate Computer", "Access the now operational computer and try to find any information you can about increasing the power output of the mining facility." },
	-- som_story_arc_chapter_one_03 task 1
	[7] = { "Create an Uplink", "It appears that there is a satellite relay station on the other side of the volcano. The computer informed you that there are underground cables running from the ship to the satellite. The problem is that the cavern that was used to house the main interface has become infested with kubaza beetles and they destroyed the old uplink. There is an automated repair droid that will recreate the uplink relay. But the kubaza beetles will attempt to destroy both the droid and the relay it makes unless you protect them." },
	-- som_story_arc_chapter_one_03 task 6
	[8] = { "Return to the Ship's Computer", "Now that the uplink has been established, return to the ship's computer and let it know that the transfer can take place." },
	-- som_story_arc_chapter_one_03 task 2
	[9] = { "Travel to the Old Republic Facility", "The ship's AI has successfully transferred itself to the facility to the northeast. You would guess that it is located in the northeast corner of Berken's Flow. Travel to that facility and reestablish contact with the AI to see if it can find any information on how to repair the miner's facility." },
	-- som_story_arc_chapter_one_03 task 3
	[10] = { "Turn Facility Power On", "The power in the facility is offline. Find a power access terminal and see if you can get the main power back online." },
	-- som_story_arc_chapter_one_03 task 5
	[11] = { "Find Terminal Delta-Five", "You need to find terminal Delta-Five and find out what the AI intends to do next." },
	-- som_story_arc_chapter_two_01 task 0
	[12] = { "Investigate the Droid Factory", "It seems that the Neimodians had built a droid factory on Mustafar before the end of the Clone Wars. The ship's AI seems to believe that they took all the information from the Old Republic Facility and transferred it down to their droid factory. Travel to the southern tip of Berken's Flow and make sure that this factory is in good working order." },
	-- som_story_arc_chapter_two_01 task 1
	[13] = { "Repair the Factory", "The new factory is in need of repair. Before the AI can transfer itself down to this location, you are going to have to make sure it is in good working order. From the look of things you will have to travel to the bottom of the factory and restart the main computer processor." },
	-- som_story_arc_chapter_two_01 task 5 -- the trailing space is shipped.
	[14] = { "Return to the Ship's Computer", "Now that this facility has been reactivated, you need to return to the Old Republic Facility and let the ship's AI know that it can begin its transfer. " },
	-- som_story_arc_chapter_two_01 task 4
	[15] = { "Return to Milo", "You seem to have accidentally reactivated some sort of psychotic droid and given it the means to make a new droid army. You need to warn Milo Mensix of this new threat immediately." },
	-- som_story_arc_chapter_three_01 task 6
	[16] = { "Defeat the Droid Army", "HK-47 has sent out an army of droids from the factory towards the Mining Facility. This droid army must be stopped before it can wreak havoc on all of Mustafar." },
	-- som_story_arc_chapter_three_01 task 17
	[17] = { "Scout the Droid Factory", "With the droid army defeated, HK-47's plans have been temporarily thwarted. You must find a way inside the droid factory to find out exactly what HK-47 is planning and perhaps find a way to defeat him for good." },
	-- som_story_arc_chapter_three_01 task 9
	[18] = { "Search for Answers", "There is an exterior terminal on the droid factory that appears to be functional. You may be able to use the terminal to break into the factory's system, find out what HK-47's plan is, and get the door open." },
	-- som_story_arc_chapter_three_01 task 11
	[19] = { "Enter Droid Factory", "The information downloaded onto the datapad might have clues about what the code of the door is." },
	-- som_story_arc_chapter_three_01 task 16
	[20] = { "Shut Down Factory", "That crazy droid is using the factory to create a massive army of killer droid. You were the one who turned it back on and you must be the one to turn it back off. Find a way to shut down the factory." },
	-- som_story_arc_chapter_three_01 task 14
	[21] = { "Return to Milo", "Report back to Milo that, although you never saw HK-47, you did manage to shutdown the droid factory." },
	-- som_story_arc_chapter_three_03 task 0
	[22] = { "Talk to a Pilot", "You need to find a pilot who is crazy enough to fly into the crater of an active volcano. There are not to many of those around but there has to be at least one on the planet." },
	-- som_story_arc_chapter_three_03 task 3
	[23] = { "Defeat HK-47", "You must destroy HK-47 before he has a chance to get away. He still has access to the droid factory and can start it up again any time he wants." },
	-- som_story_arc_chapter_three_03 task 5
	[24] = { "Return to Milo", "You shouldn't have any more problem with HK-47. You should report your success to Milo." },
	-- som_story_arc_chapter_three_03 task 6
	[25] = { "Check Your Messages", "Milo has told you that you have a message waiting for you. He said that you could use the terminal located in this room to check the message." },
}

-- som_story_arc_chapter_three_02 task 1, its own journal row -- the solo branch.
storyArcChaptersScreenPlay.overrideToolText = {
	"Get a Terminal Override",
	"Talk to one of the engineers located at the Mensix Mining Facility. One of them should have an override tool that will allow you to break into the terminal.",
}

-- The five Show Message Box / Comm Player payloads, verbatim.
storyArcChaptersScreenPlay.boxText = {
	-- som_story_arc_chapter_one_03 task 7
	shipAiDelta = {
		"Message From Ship's AI",
		"How disappointing. It doesn't appear that what I am...we are looking for is here either. Terminal Delta-Five is still online though. Access me there, while I figure out what to do next.",
	},
	-- som_story_arc_chapter_two_01 task 3, Comm Player, NPC appearance
	-- object/mobile/som/hk47.iff. There is no comm-player primitive exposed to
	-- Lua (hk_history.lua:47-80 records that search), so it is an SUI box.
	hk47Betrayal = {
		"HK-47",
		"I appreciate you helping me get back into my own body. Now to get this factory running and get some payback from those dirty meatbags who took it from me. Of course, I am not really sure who took it to begin with...better kill everyone just to make sure. I hope this doesn't put a damper on our friendship, but to be safe I am going to have to kill you too. Do not worry though, you seem tough so you will not splatter much.",
	},
	-- som_story_arc_chapter_three_02 task 0
	terminalReport = {
		"Terminal Report",
		"Unauthorized access detected. Closing terminal port...",
	},
	-- som_story_arc_chapter_three_03 task 7, Comm Player, same appearance, same
	-- reason it is an SUI box.
	hk47Farewell = {
		"HK-47",
		"I must admit that you almost make me wish I still needed a good master...almost. Your little grey brain must be getting confused at this point...I understand that happens a lot with your kind. I didn't survive for four thousand years in the husk of a ship just to be destroyed by a few lucky shots. I must be going now. I have made a list, first I need to visit those Neimodians, then I think I will go after architects...don't worry you are far down the list. You amuse me. One last thing, I know that you meatbags like keepsakes...I have sent you one. You should start enjoying yourself, it won't take me long to get through my list.",
	},
}

-- Advance to a stage and hand the player that stage's shipped prose plus any
-- waypoint the .qst authored for it. Waypoints are only created where the .qst
-- actually set createWaypoint TRUE, or where a Go to Location task named a spot;
-- chapter one 01 task 1 explicitly shipped createWaypoint 0 and so gets none.
function storyArcChaptersScreenPlay:advance(pPlayer, stage)
	self:setStage(pPlayer, stage)

	local text = self.taskText[stage]

	if (text ~= nil) then
		self:announceTask(pPlayer, text[1], text[2])
	end

	self:refreshWaypoints(pPlayer, stage)
end

function storyArcChaptersScreenPlay:refreshWaypoints(pPlayer, stage)
	self:removeWaypoint(pPlayer, "task")

	local text = self.taskText[stage]
	local description = ""

	if (text ~= nil) then
		description = text[2]
	end

	if (stage == self.STAGE_UPLINK) then
		-- .qst chapter one 03 task 1: createWaypoint TRUE, its own authored name.
		self:giveWaypoint(pPlayer, "task", self.kubazaCavern.waypointName, description, self.kubazaCavern.x, self.kubazaCavern.y)
	elseif (stage == self.STAGE_DROID_ARMY) then
		-- .qst chapter three 01 task 6: createWaypoint TRUE, its own authored name.
		self:giveWaypoint(pPlayer, "task", self.scoutPost.waypointName, description, self.scoutPost.x, self.scoutPost.y)
	elseif (stage == self.STAGE_FIND_FACTORY or stage == self.STAGE_SCOUT_FACTORY) then
		-- .qst chapter three 01 task 17: createWaypoint TRUE, its own authored
		-- name. Chapter two 01 task 0 names the same building and ships no
		-- coordinates of its own, so it reuses this one.
		self:giveWaypoint(pPlayer, "task", self.factoryArea.waypointName, description, self.factoryArea.x, self.factoryArea.y)
	elseif (stage == self.STAGE_RETURN_ORF) then
		-- Go to Location with no authored waypoint name; the task title is used.
		self:giveWaypoint(pPlayer, "task", text[1], description, self.orfReturnArea.x, self.orfReturnArea.y)
	elseif (stage == self.STAGE_TRAVEL_WRECK) then
		-- createWaypoint was 0 on this task. Deliberately no waypoint.
		return
	end
end

--------------------------------------------------------------------------------
-- GO TO LOCATION -- the three authored rings
--------------------------------------------------------------------------------

function storyArcChaptersScreenPlay:notifyEnteredArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local role = readStringData(SceneObject(pArea):getObjectID() .. ":storyArcChaptersRole")
	local stage = self:getStage(pPlayer)

	if (role == "wreck" and stage == self.STAGE_TRAVEL_WRECK) then
		-- chapter one 01 task 1 satisfied, task 2 goes live.
		self:advance(pPlayer, self.STAGE_FIND_TERMINAL)
	elseif (role == "orfReturn" and stage == self.STAGE_RETURN_ORF) then
		-- chapter two 01 task 5 satisfied. Task 3 is the Comm Player beat.
		self:showMessageBox(pPlayer, self.boxText.hk47Betrayal[1], self.boxText.hk47Betrayal[2])
		self:advance(pPlayer, self.STAGE_WARN_MILO)
	elseif (role == "factory") then
		if (stage == self.STAGE_FIND_FACTORY) then
			-- chapter two 01 task 0 satisfied.
			self:advance(pPlayer, self.STAGE_REPAIR_FACTORY)
		elseif (stage == self.STAGE_SCOUT_FACTORY) then
			-- chapter three 01 task 17 satisfied.
			self:advance(pPlayer, self.STAGE_FACTORY_TERMINAL)
		end
	end

	return 0
end

--------------------------------------------------------------------------------
-- RADIAL USE -- one entry point for every object this file owns or observes
--------------------------------------------------------------------------------

function storyArcChaptersScreenPlay:handleUse(pPlayer, role, objectID)
	if (pPlayer == nil or role == nil or role == "") then
		return
	end

	if (role == "milo") then
		self:useMilo(pPlayer)
	elseif (role == "crashTerminal") then
		self:useCrashTerminal(pPlayer)
	elseif (role == "shipComputer") then
		self:useShipComputer(pPlayer)
	elseif (role == "uplinkEntrance") then
		self:useUplinkEntrance(pPlayer)
	elseif (role == "facilityContact") then
		self:useFacilityContact(pPlayer)
	elseif (role == "facilityPower") then
		self:useFacilityPower(pPlayer)
	elseif (role == "facilityDelta") then
		self:useFacilityDelta(pPlayer)
	elseif (role == "factoryDoor") then
		self:useFactoryDoor(pPlayer)
	elseif (role == "factoryTerminal") then
		self:useFactoryTerminal(pPlayer, objectID)
	elseif (role == "factoryKeypad") then
		self:useFactoryKeypad(pPlayer)
	elseif (role == "scout") then
		self:useScout(pPlayer)
	elseif (role == "pilot") then
		self:usePilot(pPlayer)
	elseif (role == "miloTerminal") then
		self:useMiloTerminal(pPlayer)
	end
end

--------------------------------------------------------------------------------
-- MILO MENSIX -- giver, and the turn-in for three of the seven quests
--------------------------------------------------------------------------------

function storyArcChaptersScreenPlay:useMilo(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_NONE) then
		self:offerArc(pPlayer)
	elseif (stage == self.STAGE_WARN_MILO) then
		-- chapter two 01 task 4 turn-in; chapter three 01 opens.
		self:advance(pPlayer, self.STAGE_DROID_ARMY)
		self:startKillWatch(pPlayer)
	elseif (stage == self.STAGE_REPORT_MILO) then
		-- chapter three 01 task 14 turn-in; chapter three 03 opens.
		self:advance(pPlayer, self.STAGE_FIND_PILOT)
	elseif (stage == self.STAGE_REPORT_SUCCESS) then
		-- chapter three 03 task 5 turn-in; task 6 goes live.
		self:advance(pPlayer, self.STAGE_CHECK_MESSAGE)
	elseif (stage == self.STAGE_FACTORY_TERMINAL and not self:hasFlag(pPlayer, "overrideTool")) then
		-- som_story_arc_chapter_three_02 task 1: "Talk to one of the engineers
		-- located at the Mensix Mining Facility." No engineer template ships and
		-- no engineer is named, so Milo hands the tool over. SUBSTITUTED.
		self:setFlag(pPlayer, "overrideTool")
		CreatureObject(pPlayer):sendSystemMessage("You have received a terminal override tool.")
		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
		-- signal mustafar_droid_factory_tool_recieved (misspelling shipped).
	else
		CreatureObject(pPlayer):sendSystemMessage("Milo Mensix has nothing further for you at the moment.")
	end
end

-- The .qst names no giver and no prerequisite quest; the prelude's closing line
-- and chapter one's own list prose are the only evidence, so both gates are
-- soft-failed with an explanation rather than silently doing nothing.
function storyArcChaptersScreenPlay:offerArc(pPlayer)
	if (CreatureObject(pPlayer):getLevel() < self.requiredLevel) then
		CreatureObject(pPlayer):sendSystemMessage("You are not yet experienced enough for this task.")
		return
	end

	if (not self:isPreludeComplete(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("Milo Mensix is busy. Perhaps Foreman Chivos has work for you first.")
		return
	end

	-- som_story_arc_chapter_one_01 list description, verbatim.
	self:showMessageBox(pPlayer, "The Downed Ship", "Milo Mensix wants a permanent solution to the problems the facility is facing. The recently uncovered Old Republic cruiser might have information that the miners could use to increase their station's productivity. Mensix has asked you to investigate the downed ship in more detail and see if you can find a terminal that can be used to access the ship's memory banks.")
	self:advance(pPlayer, self.STAGE_TRAVEL_WRECK)
	self:startKillWatch(pPlayer)
end

--------------------------------------------------------------------------------
-- CHAPTER ONE 01 / 02 -- the crash site
--------------------------------------------------------------------------------

-- Reached through a STACKING observer on nodes 12111401 and 12112127, which
-- map_exploration.lua already owns the radial for. That is why the .qst's
-- "Remove Circuit Board" menu label cannot appear -- see the header.
function storyArcChaptersScreenPlay:useCrashTerminal(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_FIND_TERMINAL) then
		-- chapter one 01 task 2 satisfied. Chapter one 02's list prose says the
		-- terminal's circuit boards are destroyed, so task 0 opens next.
		self:showMessageBox(pPlayer, "Activating the Terminal", "You have located a terminal on the bridge of the crashed Old Republic cruiser but its circuit boards are destroyed. You will have to salvage some more circuit boards from around the crash site to replace the damaged ones.")
		self:advance(pPlayer, self.STAGE_SALVAGE_BOARDS)
	elseif (stage == self.STAGE_SALVAGE_BOARDS) then
		-- chapter one 02 task 0, ItemName verbatim from the .qst.
		CreatureObject(pPlayer):sendSystemMessage("All the circuit boards have been removed already. Damaged terminal")
		self:advance(pPlayer, self.STAGE_SEARCH_BANDITS)
	end
end

-- must_orc_computer on the cruiser bridge: chapter one 02 task 2 and task 6, and
-- chapter one 03 task 6.
function storyArcChaptersScreenPlay:useShipComputer(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_FIX_TERMINAL) then
		-- chapter one 02 task 2, ItemName verbatim.
		CreatureObject(pPlayer):sendSystemMessage("The view screen flickers briefly and then comes to life.")
		self:advance(pPlayer, self.STAGE_ACTIVATE_COMPUTER)
	elseif (stage == self.STAGE_ACTIVATE_COMPUTER) then
		-- chapter one 02 task 6 satisfied; chapter one 03's list prose is the
		-- AI's answer, and its task 1 opens.
		self:showMessageBox(pPlayer, "The Transfer of the AI", "The capital ship's AI has informed you that the ship's systems are too damaged in order to find the information you require. It does have knowledge of an Old Republic facility not far from the crash site that is no longer in use but probably has the information. With your help the AI will be able to use the information stored within the facility to find out how to help the miners. Establish a remote link between the downed cruiser and the facility.")
		self:advance(pPlayer, self.STAGE_UPLINK)
	elseif (stage == self.STAGE_UPLINK_REPORT) then
		-- chapter one 03 task 6 satisfied.
		self:advance(pPlayer, self.STAGE_TRAVEL_ORF)
	elseif (stage == self.STAGE_SEARCH_BANDITS) then
		CreatureObject(pPlayer):sendSystemMessage("You still need " .. (self.boardsRequired - self:getCount(pPlayer, "boards")) .. " more circuit boards.")
	end
end

--------------------------------------------------------------------------------
-- CHAPTER ONE 03 -- the uplink and the Old Republic Facility
--------------------------------------------------------------------------------

-- Node 12111374, the uplink bunker entrance the snapshot places 8 m from the
-- .qst's own waypoint coordinate. The repair droid and the relay are SUBSTITUTED
-- and the beetle wave is INFERRED -- the .qst names neither template nor count.
function storyArcChaptersScreenPlay:useUplinkEntrance(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_UPLINK) then
		return
	end

	if (self:hasFlag(pPlayer, "uplinkStarted")) then
		local left = self.kubazaRequired - self:getCount(pPlayer, "kubaza")

		if (left > 0) then
			CreatureObject(pPlayer):sendSystemMessage("The repair droid is still working. " .. left .. " more kubaza beetles are closing in on it.")
		end

		return
	end

	self:setFlag(pPlayer, "uplinkStarted")
	self:spawnUplinkWorkSite(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("A repair droid begins rebuilding the uplink relay. Protect it from the kubaza beetles.")
end

function storyArcChaptersScreenPlay:spawnUplinkWorkSite(pPlayer)
	local site = self.kubazaCavern
	local z = getWorldFloor(site.x, site.y, "mustafar")

	local pDroid = spawnMobile("mustafar", self.repairDroid.template, self.repairDroid.respawn, site.x, z, site.y, 0, 0)

	if (pDroid == nil) then
		print("storyArcChaptersScreenPlay: " .. self.repairDroid.template .. " failed to spawn at the uplink site")
	end

	local pRelay = spawnSceneObject("mustafar", self.uplinkRelayTemplate, site.x + 3, z, site.y, 0, 0)

	if (pRelay == nil) then
		print("storyArcChaptersScreenPlay: " .. self.uplinkRelayTemplate .. " failed to spawn at the uplink site")
	end

	-- INFERRED wave. The .qst says beetles attack, not how many or which.
	for i = 1, self.kubazaRequired do
		local template = self.kubazaTemplates[((i - 1) % #self.kubazaTemplates) + 1]
		local pBeetle = spawnMobile("mustafar", template, 300, site.x - 6 + (i * 3), z, site.y - 8, 0, 0)

		if (pBeetle == nil) then
			print("storyArcChaptersScreenPlay: " .. template .. " failed to spawn at the uplink site")
		end
	end
end

-- Public gate, for mustafar_instances.lua to call once its uplink_cave pool is
-- wired. That file is another agent's this run and is NOT edited here; the report
-- states the exact branch it needs.
function storyArcChaptersScreenPlay:mayEnterUplinkCave(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return self:getStage(pPlayer) >= self.STAGE_UPLINK
end

-- Public gate, same reason, for working_droid_factory / decrepit_droid_factory.
function storyArcChaptersScreenPlay:mayEnterDroidFactory(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return self:getStage(pPlayer) >= self.STAGE_ENTER_FACTORY
end

-- must_orc_computer in the facility entrance: chapter one 03 task 2.
function storyArcChaptersScreenPlay:useFacilityContact(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_TRAVEL_ORF) then
		CreatureObject(pPlayer):sendSystemMessage("The terminal is dead. Nothing in this facility has power.")
		self:advance(pPlayer, self.STAGE_ORF_POWER)
	elseif (stage == self.STAGE_RETURN_ORF) then
		-- chapter two 01 task 5 also ends here, at the facility. The ring outside
		-- is the authored trigger; this is the same beat reachable from inside.
		self:showMessageBox(pPlayer, self.boxText.hk47Betrayal[1], self.boxText.hk47Betrayal[2])
		self:advance(pPlayer, self.STAGE_WARN_MILO)
	end
end

-- must_control_computer in the facility entrance: chapter one 03 task 3,
-- "Find a power access terminal and see if you can get the main power back
-- online."
function storyArcChaptersScreenPlay:useFacilityPower(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_ORF_POWER) then
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("The facility's main power comes back online.")

	-- chapter one 03 task 7, Show Message Box, verbatim.
	self:showMessageBox(pPlayer, self.boxText.shipAiDelta[1], self.boxText.shipAiDelta[2])
	self:advance(pPlayer, self.STAGE_DELTA_FIVE)
end

-- Terminal Delta-Five: chapter one 03 task 5. The .qst gives it a name and no
-- template and no position; the second wall terminal bank in the entrance is the
-- placement, cited in the header.
function storyArcChaptersScreenPlay:useFacilityDelta(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_DELTA_FIVE) then
		return
	end

	-- chapter two 01 list description, verbatim -- this is the AI's answer.
	self:showMessageBox(pPlayer, "Wrong Place, Wrong Time", "The ship's AI seems to be upset that something is missing from the abandoned facility. But after searching the database of the facility it has discovered another abandoned factory where all the information needed was moved too sometime after it crashed and lost track of its surroundings. The AI has asked you to travel to the newly found Neimodian droid factory and make sure it is in working order. Once this is done the AI will transfer itself down there and get all the necessary information.")
	self:advance(pPlayer, self.STAGE_FIND_FACTORY)
end

--------------------------------------------------------------------------------
-- THE DROID FACTORY -- chapter two 01 task 1, chapter three 01 tasks 9/11/16
--------------------------------------------------------------------------------

-- ⚠ LATENT COLLISION, for whoever wires the factory pools next.
-- mustafar_instances.lua:267 calls attachEntryProp only under
-- "if (pool.entry ~= nil)", and working_droid_factory / decrepit_droid_factory /
-- uplink_cave all carry entry = nil today, so nothing else claims this node's
-- menu and the radials below work. The moment an entry = { nodeID = 12112909 }
-- table is added to either factory pool, attachEntryProp will call
-- setObjectMenuComponent("MustafarInstanceMenuComponent") on this same node and
-- REPLACE this file's component -- silently killing "Restart the main computer
-- processor" and "Shut down the factory". Same hazard on 12111374 for
-- uplink_cave. If those pools are wired, give them a DIFFERENT entry node, or
-- fold these roles into MustafarInstanceMenuComponent. Verified 2026-08-18.
--
-- Node 12112909, the exterior door. Chapter two 01 task 1 wants the player at
-- "the bottom of the factory" to "restart the main computer processor", and
-- chapter three 01 task 16 wants the factory shut down from the inside. Neither
-- interior can be entered: mustafar_instances.lua keeps both factory pools
-- deliberately unwired behind this same door node, and NO droid factory .ilf
-- ships, so there is no defensible interior coordinate to invent. Both steps are
-- therefore resolved at the door. This is the largest reduction in the port and
-- it is stated, not hidden.
function storyArcChaptersScreenPlay:useFactoryDoor(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_REPAIR_FACTORY) then
		CreatureObject(pPlayer):sendSystemMessage("You restart the factory's main computer processor. The assembly lines shudder into life.")
		self:advance(pPlayer, self.STAGE_RETURN_ORF)
	elseif (stage == self.STAGE_SHUTDOWN_FACTORY) then
		CreatureObject(pPlayer):sendSystemMessage("The assembly lines grind to a halt. The droid factory is shut down.")
		self:advance(pPlayer, self.STAGE_REPORT_MILO)
	elseif (stage == self.STAGE_ENTER_FACTORY) then
		CreatureObject(pPlayer):sendSystemMessage("The door is sealed. The keypad beside it wants a code.")
	end
end

-- Node 12112268, the shipped droid factory history terminal. Chapter three 01
-- task 9 breaks into it and task 10 rewards the datapad for doing so. The
-- terminal's own log is already implemented by hk_history.lua, so this hands the
-- player the same entry that carries the door code rather than duplicating it.
-- That file is read through _G so this one does not hard-depend on it.
function storyArcChaptersScreenPlay:useFactoryTerminal(pPlayer, objectID)
	local stage = self:getStage(pPlayer)

	if (stage ~= self.STAGE_FACTORY_TERMINAL) then
		return
	end

	-- som_story_arc_chapter_three_02 task 0, Show Message Box, verbatim. The solo
	-- side quest exists precisely because the first attempt fails.
	if (not self:hasFlag(pPlayer, "overrideTool")) then
		self:showMessageBox(pPlayer, self.boxText.terminalReport[1], self.boxText.terminalReport[2])
		self:announceTask(pPlayer, self.overrideToolText[1], self.overrideToolText[2])
		return
	end

	-- task 10 Reward, verbatim template, CountItem 1.
	self:grantItem(pPlayer, self.datapadTemplate, "You have received a droid factory history datapad.")

	local history = _G["somHkHistoryScreenPlay"]

	if (history ~= nil and history.playEntry ~= nil) then
		history:playEntry(pPlayer, self.factoryHistoryEntry, getSceneObject(objectID))
	end

	self:advance(pPlayer, self.STAGE_ENTER_FACTORY)
end

-- Node 12112269, the shipped entrance keypad. Chapter three 01 task 11: "The
-- information downloaded onto the datapad might have clues about what the code of
-- the door is." The code is not in the .qst -- it is in the factory's own history
-- log, entry 7: "... Alter door passcode...37323."
function storyArcChaptersScreenPlay:useFactoryKeypad(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_ENTER_FACTORY) then
		return
	end

	local sui = SuiInputBox.new("storyArcChaptersScreenPlay", "keypadCallback")

	sui.setTitle("Droid Factory Entrance")
	sui.setPrompt("Enter the door passcode.")
	sui.sendTo(pPlayer)
end

function storyArcChaptersScreenPlay:keypadCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	if (self:getStage(pPlayer) ~= self.STAGE_ENTER_FACTORY) then
		return
	end

	if (args ~= self.factoryPasscode) then
		CreatureObject(pPlayer):sendSystemMessage("The keypad rejects the code.")
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("The passcode is accepted and the factory door grinds open.")
	self:advance(pPlayer, self.STAGE_SHUTDOWN_FACTORY)
end

--------------------------------------------------------------------------------
-- CHAPTER THREE 01 / 03 -- the scout, the pilot, the last message
--------------------------------------------------------------------------------

-- must_scout stands at the exact coordinate chapter three 01 task 6 puts its
-- waypoint on. Talking to him is what releases the droid army; the .qst gives no
-- roster and no count, so both are INFERRED.
function storyArcChaptersScreenPlay:useScout(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_DROID_ARMY) then
		return
	end

	if (self:hasFlag(pPlayer, "armyReleased")) then
		CreatureObject(pPlayer):sendSystemMessage("Droids are still marching on the facility. " .. (self.droidArmyRequired - self:getCount(pPlayer, "droids")) .. " remain.")
		return
	end

	self:setFlag(pPlayer, "armyReleased")
	self:spawnDroidArmy()
	CreatureObject(pPlayer):sendSystemMessage("The scout points down the trail. HK-47's droid army is on the march.")
end

function storyArcChaptersScreenPlay:spawnDroidArmy()
	local index = 0

	for i = 1, #self.droidArmy do
		local wave = self.droidArmy[i]

		for n = 1, wave.count do
			index = index + 1

			local x = self.scoutPost.x + 10 + (index * 3)
			local y = self.scoutPost.y + 10
			local z = getWorldFloor(x, y, "mustafar")
			local pDroid = spawnMobile("mustafar", wave.template, 300, x, z, y, 0, 0)

			if (pDroid == nil) then
				print("storyArcChaptersScreenPlay: " .. wave.template .. " failed to spawn in the droid army")
			end
		end
	end
end

-- chapter three 03 task 0, "Talk to a Pilot". The .qst gives no position for him
-- and no template; miner_pilot is the only registered SOM pilot.
function storyArcChaptersScreenPlay:usePilot(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_FIND_PILOT) then
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("The pilot agrees to fly you into the crater.")
	self:advance(pPlayer, self.STAGE_KILL_HK47)
	self:giveWaypoint(pPlayer, "task", "Defeat HK-47", self.taskText[self.STAGE_KILL_HK47][2], self.hk47.x, self.hk47.y)
end

-- chapter three 03 task 6, "the terminal located in this room", then task 7's
-- Comm Player and task 4's reward.
function storyArcChaptersScreenPlay:useMiloTerminal(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_CHECK_MESSAGE) then
		return
	end

	self:showMessageBox(pPlayer, self.boxText.hk47Farewell[1], self.boxText.hk47Farewell[2])

	-- task 4 Reward, verbatim template, CountItem 1, lootCount 1.
	self:grantItem(pPlayer, self.hologramTemplate, "You have received a hologram of HK-47.")

	-- task 4 musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_story_arc_complete.snd")

	self:setStage(pPlayer, self.STAGE_DONE)
	self:removeWaypoint(pPlayer, "task")
	self:stopKillWatch(pPlayer)
end

--------------------------------------------------------------------------------
-- KILLS -- one observer for all four kill legs
--------------------------------------------------------------------------------

-- Four separate tasks across the arc are kill legs (circuit boards off the
-- bandits, the kubaza beetles at the uplink, the droid army, HK-47 himself).
-- One observer serves all four so the player never carries more than one, and it
-- is created with persistence 1 so it survives a relog mid-arc. It is dropped at
-- the terminal stage -- an observer that is never dropped accumulates.
function storyArcChaptersScreenPlay:startKillWatch(pPlayer)
	if (self:hasFlag(pPlayer, "killWatch")) then
		return
	end

	self:setFlag(pPlayer, "killWatch")
	createObserver(KILLEDCREATURE, "storyArcChaptersScreenPlay", "notifyKilledCreature", pPlayer, 1)
end

function storyArcChaptersScreenPlay:stopKillWatch(pPlayer)
	dropObserver(KILLEDCREATURE, "storyArcChaptersScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "killWatch")
end

function storyArcChaptersScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	local stage = self:getStage(pPlayer)

	-- Returning 1 removes the observer. Only do that once the arc is over.
	if (stage >= self.STAGE_DONE) then
		return 1
	end

	local template = AiAgent(pVictim):getCreatureTemplateName()

	if (stage == self.STAGE_SEARCH_BANDITS) then
		self:countBandit(pPlayer, template)
	elseif (stage == self.STAGE_UPLINK) then
		self:countKubaza(pPlayer, template)
	elseif (stage == self.STAGE_DROID_ARMY) then
		self:countDroid(pPlayer, template)
	elseif (stage == self.STAGE_KILL_HK47 and template == self.hk47.template) then
		-- chapter three 03 task 3.
		self:advance(pPlayer, self.STAGE_REPORT_SUCCESS)
	end

	return 0
end

-- chapter one 02 task 1: 4 "Circuit Board" at LootDropPercent 60. The .qst's
-- "Social Group must_bandit" cannot discriminate here (every ported SOM template
-- carries socialGroup "townsperson" or ""), so the two registered bandit
-- templates are matched by name. getRandomNumber(100) is 1-100 inclusive, the
-- same roll bounty_hunts.lua:507-510 uses for a drop percentage.
function storyArcChaptersScreenPlay:countBandit(pPlayer, template)
	if (not self:isOneOf(template, self.banditTemplates)) then
		return
	end

	if (getRandomNumber(100) > self.boardDropPercent) then
		return
	end

	local count = self:addCount(pPlayer, "boards")
	CreatureObject(pPlayer):sendSystemMessage("You have recovered a Circuit Board. (" .. count .. "/" .. self.boardsRequired .. ")")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	if (count >= self.boardsRequired) then
		self:advance(pPlayer, self.STAGE_FIX_TERMINAL)
	end
end

-- INFERRED count -- the .qst names no beetle count and no beetle template.
function storyArcChaptersScreenPlay:countKubaza(pPlayer, template)
	if (not self:hasFlag(pPlayer, "uplinkStarted") or not self:isOneOf(template, self.kubazaTemplates)) then
		return
	end

	local count = self:addCount(pPlayer, "kubaza")

	if (count < self.kubazaRequired) then
		CreatureObject(pPlayer):sendSystemMessage("The repair droid works on. " .. (self.kubazaRequired - count) .. " kubaza beetles remain.")
		return
	end

	-- chapter one 03 task 1 satisfied, task 6 goes live.
	CreatureObject(pPlayer):sendSystemMessage("The repair droid finishes the relay. The uplink is established.")
	self:advance(pPlayer, self.STAGE_UPLINK_REPORT)
end

-- INFERRED count -- the .qst names no roster and no count for the droid army.
function storyArcChaptersScreenPlay:countDroid(pPlayer, template)
	if (not self:hasFlag(pPlayer, "armyReleased")) then
		return
	end

	local match = false

	for i = 1, #self.droidArmy do
		if (self.droidArmy[i].template == template) then
			match = true
		end
	end

	if (not match) then
		return
	end

	local count = self:addCount(pPlayer, "droids")

	if (count < self.droidArmyRequired) then
		CreatureObject(pPlayer):sendSystemMessage("Droid destroyed. (" .. count .. "/" .. self.droidArmyRequired .. ")")
		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
		return
	end

	-- chapter three 01 task 6 satisfied, task 17 goes live.
	self:advance(pPlayer, self.STAGE_SCOUT_FACTORY)
end

function storyArcChaptersScreenPlay:isOneOf(template, list)
	for i = 1, #list do
		if (list[i] == template) then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------
-- RADIAL
--------------------------------------------------------------------------------

-- setObjectMenuComponent falls through to LuaObjectMenuComponent and REPLACES the
-- object's menu, so this is only ever set on objects this file owns outright.
-- The two crash-site terminals are reached by a stacking observer instead.
StoryArcChaptersMenuComponent = {}

function StoryArcChaptersMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local objectID = SceneObject(pSceneObject):getObjectID()
	local role = readStringData(objectID .. ":storyArcChaptersRole")
	local text = storyArcChaptersScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function StoryArcChaptersMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local objectID = SceneObject(pSceneObject):getObjectID()
	storyArcChaptersScreenPlay:handleUse(pPlayer, readStringData(objectID .. ":storyArcChaptersRole"), objectID)
	return 0
end

-- Returns nil when the object has nothing to offer at the player's current
-- stage, so the radial entry simply does not appear rather than appearing dead.
function storyArcChaptersScreenPlay:getRadialText(pPlayer, role)
	if (role == nil or role == "") then
		return nil
	end

	local stage = self:getStage(pPlayer)

	if (role == "milo") then
		if (stage == self.STAGE_NONE) then
			return "Ask Milo Mensix about the facility"
		elseif (stage == self.STAGE_WARN_MILO or stage == self.STAGE_REPORT_MILO or stage == self.STAGE_REPORT_SUCCESS) then
			return "Report to Milo Mensix"
		elseif (stage == self.STAGE_FACTORY_TERMINAL and not self:hasFlag(pPlayer, "overrideTool")) then
			-- som_story_arc_chapter_three_02 task 1's own title.
			return "Get a Terminal Override"
		end

		return nil
	end

	if (role == "shipComputer") then
		if (stage == self.STAGE_FIX_TERMINAL) then
			-- chapter one 02 task 2 retrieveMenuText, verbatim.
			return "Install Circuit Boards"
		elseif (stage == self.STAGE_ACTIVATE_COMPUTER) then
			return "Activate Computer"
		elseif (stage == self.STAGE_UPLINK_REPORT) then
			return "Report the uplink to the ship's computer"
		end

		return nil
	end

	if (role == "uplinkEntrance" and stage == self.STAGE_UPLINK) then
		return "Signal the repair droid"
	end

	if (role == "facilityContact" and (stage == self.STAGE_TRAVEL_ORF or stage == self.STAGE_RETURN_ORF)) then
		return "Contact the ship's AI"
	end

	if (role == "facilityPower" and stage == self.STAGE_ORF_POWER) then
		return "Restore facility power"
	end

	if (role == "facilityDelta" and stage == self.STAGE_DELTA_FIVE) then
		return "Access Terminal Delta-Five"
	end

	if (role == "factoryDoor") then
		if (stage == self.STAGE_REPAIR_FACTORY) then
			return "Restart the main computer processor"
		elseif (stage == self.STAGE_SHUTDOWN_FACTORY) then
			return "Shut down the factory"
		end

		return nil
	end

	if (role == "factoryTerminal" and stage == self.STAGE_FACTORY_TERMINAL) then
		return "Break into the terminal"
	end

	if (role == "factoryKeypad" and stage == self.STAGE_ENTER_FACTORY) then
		return "Enter the door passcode"
	end

	if (role == "scout" and stage == self.STAGE_DROID_ARMY) then
		return "Ask the scout about the droid army"
	end

	if (role == "pilot" and stage == self.STAGE_FIND_PILOT) then
		return "Ask the pilot to fly into the crater"
	end

	if (role == "miloTerminal" and stage == self.STAGE_CHECK_MESSAGE) then
		return "Check your messages"
	end

	return nil
end
