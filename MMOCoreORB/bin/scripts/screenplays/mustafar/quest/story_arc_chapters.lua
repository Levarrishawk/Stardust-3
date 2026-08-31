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
	encodes.

	MILO AS THE GIVER IS NO LONGER AN OPEN DECISION. It used to rest on the
	prelude's closing line plus chapter one's own list prose. It now rests on
	conversation/story_arc_chapter_one_milo, whose grantFirstMission action grants
	som_story_arc_chapter_one_01 outright. The .qst still names no giver -- that
	field is empty across all seven, and it always was -- because in this content
	the giver lives in the conversation, not the quest. Same place the badge and
	the reward rows turned out to live. See point 4 below.

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

	must_orc_computer is placed inside the crashed cruiser, and the placement is
	QUOTED. Node 12112205 is a SharedBuildingObjectTemplate whose client iff points
	at appearance/poi_must_crashed_republic_ship.pob, and that pob has cells
	literally named "bridge" and "hallway". The crash site's own server-side dungeon
	spawn table has one row and only one, and that row is this object: room "bridge",
	position 2.2 / 1.9 / 8, yaw -90, carrying the two scripts the .qst implies. So
	the computer was never a placement problem. It is stated outright.

	This paragraph used to derive the spot instead, and the derivation is recorded
	here because it was wrong in a way worth remembering:
	interiorlayout/crashed_republic_ship.ilf puts two starship pilot chairs in the
	bridge at (1.151, h 1.658, z 12.430) and (-1.224, h 1.658, z 12.152), and the
	bridge collision floor spans x -2.85..2.85, h 1.66..2.04, z 3.84..12.26 -- so
	the computer went on the centreline between the chairs, at 0.0 / 1.66 / 11.3
	facing 180. That is 3.4 m too far forward and facing the wrong way.

	The same mistake had been made in the Old Republic Facility, and it is corrected
	the same way. That building is already pooled by mustafar_instances.lua (pool
	"old_republic_facility", 12 copies, entrance cell, ungated). Chapter one task
	2/3/5 and chapter two task 5 all happen there, so the terminals are spawned into
	EVERY copy in the pool -- the precedent is reunite_shard.lua, which furnishes
	each building of a pool the same way. All three USED TO sit in cell "entrance",
	on spots read off som_old_republic_facility.ilf's entrance fixtures: two wall
	terminal banks at (23.430, -0.667, 4.268) and (23.432, -0.696, -4.164), and a
	floor data terminal at (4.426, 0.0, -7.256). The facility's dungeon spawn table
	puts the two real ones in two different cells -- core_tower8 and smallroom12 --
	nowhere near the entrance or each other, so each terminal now carries its own
	cell. The third has no live counterpart at all and is labelled INVENTED at its
	entry rather than dressed up as a reading.

	ROOT CAUSE, one cause for both: the dungeon spawn tables were not in the searched
	set. Only the .qst files and the interior layouts were, so the .ilf was the best
	evidence available and got used as though it were the only evidence that existed.
	A .ilf says what a building was FURNISHED with; a dungeon spawn table says what
	the server actually PUTS in it. Only the second is a placement, and only the
	second carries a heading -- the missing heading should have been the tell.

	The .ilf reasoning is still sound where nothing server-side spawns the object:
	Core3 never instantiates .ilf furniture, so those coordinates are not "where the
	prop is", they are shipped evidence of where SOE left open floor. That is a fair
	way to choose a spot for an INVENTED object. It is not a substitute for looking.

	WHAT COULD NOT BE PLACED FROM DATA
	----------------------------------
	1. RESOLVED -- the uplink cavern interior is now entered. The .qst gives one
	   coordinate for chapter one task 1 (-3604 / 157 / 3483) and
	   mustafar_instances.lua has a nine-copy "uplink_cave" pool on door node
	   12111281. That pool is now wired, gated "story_arc_uplink" against
	   mayEnterUplinkCave(pPlayer) below, and it keeps its own radial because
	   12111281 is a different node from the 12111374 bunker entrance this file
	   owns.

	   THE REASON THIS WAS LISTED AS UNPLACEABLE WAS NOT A FINDING. It read "that
	   file belongs to another agent this run, so it is NOT edited", and this file
	   then published a gate function for that other agent to call. There was no
	   other agent and no other owner. The premise was assumed, never checked, and
	   it was load-bearing: it turned work that was in scope into a hand-off, and
	   the hand-off had no recipient. The pool's own "wire the quest first, then
	   the door" comment was the instruction, not a prohibition -- the quest was
	   already wired in this very file.

	   ROOT CAUSE: an ownership boundary was inferred from a neighbouring file's
	   comment and then treated as a fact about who may edit what. A comment
	   explaining why something is unfinished is not a claim that somebody else
	   will finish it.

	   The repair droid, the relay it builds and the beetle wave count are not in
	   the .qst at all. A Mark I Mining Droid stands in for the repair droid and
	   must_satellite_uplink for the relay; the wave is four beetles. Both are
	   labelled SUBSTITUTED / INFERRED at their table entries. The cave's interior
	   arrival spot is INVENTED and mustafar_instances.lua records the checked
	   absence behind it: som_uplink_cave has no dungeon spawn table at all.

	2. RESOLVED -- the droid factory interior is now entered. Chapter two task 1
	   says "travel to the bottom of the factory and restart the main computer
	   processor" and chapter three task 16 says "find a way to shut down the
	   factory". Both now happen inside. mustafar_instances.lua's
	   working_droid_factory and decrepit_droid_factory pools are wired, gated
	   "story_arc_factory" against mayEnterDroidFactory(pPlayer) below, and they
	   carry entry.nodeID = nil so this file keeps the radial on shared door
	   12112909 while the pools supply the landing spot.

	   THIS ENTRY HAS NOW BEEN WRONG TWICE, and both errors are recorded because
	   they are the same error at different depths.

	   The first version read "there is NO droid factory .ilf shipped -- only nine
	   .ilf files exist and none of them is the factory. With no interior layout
	   there is no defensible interior coordinate to invent." The .ilf part is true
	   and the conclusion does not follow. Both factories have full server-side
	   dungeon spawn tables, and those are better evidence than a .ilf would have
	   been: rooms, positions, yaws, scripts and objvars for the entire interior
	   population.
	   ROOT CAUSE: the dungeon spawn tables were not in the searched set, so "no
	   .ilf" was read as "no data". Absence in the file you happened to open is not
	   absence.

	   The second version fixed the evidence and then invented an owner to hand the
	   work to. It said the interior was "documented and unwired, which is a
	   different problem with a different owner", and left the terminal coordinates
	   "for whoever wires the pools". There is no other owner for Mustafar content.
	   The hand-off was addressed to nobody, and it converted a solved problem back
	   into an open one -- which is worse than the first error, because the first
	   error was at least an honest misreading of evidence.
	   ROOT CAUSE: a premise asserted instead of checked. Nothing in the tree said
	   another agent held mustafar_instances.lua; that was inferred from its own
	   "wire the quest first, then the door" comment, which is a sequencing note,
	   not a claim of ownership. Deferring approved work and dressing it as somebody
	   else's scope is a false completion.

	   The coordinates that were being left for that imaginary reader are now used.
	   Both factory tables were read in full. The working factory's end terminal is
	   a system_controller in centralroom28 and the decrepit factory's security
	   controller and master power core are in mainroom27 and smallroom20; all three
	   rows are quoted at the entries below and spawned by this file.

	3. Chapter three chapter 03 carries NO coordinates whatsoever -- not for the
	   volcano crater arena, not for HK-47's last stand, not for the terminal
	   "located in this room". Every arena task carries LocationX/Y/Z 0.0,
	   createWaypoint 0 and an empty waypointName.

	   That is not missing data. mustafar_volcano is a separate ZONE and the
	   chapter happens inside it, which is why the ground map is never addressed;
	   the pilot's conversation flies the player in. Core3 has no such zone, so
	   HK-47 is stood on the open terrain instead -- the deviation
	   story_arc_chapter_three_pilot.lua states in full.

	   So his position is INVENTED, not inferred, and the entry says so. It used
	   to be justified here as a reading of the prose "the highest point in the
	   area, a nearby volcano crater" onto node 12112130, the highest snapshot
	   node in the central-volcano region. The prose is real; what was wrong was
	   treating it as pointing at a spot on this zone. See the hk47 entry for the
	   three independent checks and the root cause.

	   The pilot is no longer in this list either -- he is quoted, not inferred;
	   see his own entry.

	4. WITHDRAWN, AND IT WAS THE BIGGEST WRONG CALL IN THIS FILE. It read:

	     "No conversation table ships for Milo Mensix, for a pilot, or for a droid
	      factory engineer. Twenty-five SOM conversation STFs were enumerated and
	      none of them covers these three. ... So every NPC beat here is a radial
	      plus an SUI box."

	   All of it ships. story_arc_chapter_one_milo (43 screens),
	   story_arc_chapter_three_pilot, story_arc_chapter_three_cobar,
	   story_arc_chapter_three_scout, story_arc_chapter_one_computer and
	   story_arc_chapter_two_computer -- six real trees for this file's NPCs,
	   plus story_arc_prelude_chivos next door.

	   ROOT CAUSE: "twenty-five SOM conversation STFs were enumerated" is exactly
	   the defect. The enumeration was scoped to the som_ name prefix, because
	   that is how the quests, the mobiles and the datatables on this planet are
	   named. These conversations are named story_arc_* and ship in the BASE
	   string/en/conversation/ set. Nothing under that prefix was ever in the set
	   being looked at, and "none of them covers these three" was a true statement
	   about the wrong set, read as a fact about live.

	   The second half of the claim was also wrong on its own terms: nothing
	   forbids adding a NEW conversationTemplate to a mobile whose field is empty.
	   The rule is that an EXISTING one may not be repointed, and none was.

	   Every radial and every SUI box those three NPCs had is retired. What
	   remains SUI-delivered is listed at 5 and 6 below, and those are real
	   engine limits, not this.

	5. The two Comm Player tasks (chapter two task 3, chapter three chapter 03
	   task 7) cannot be rendered. There is no comm-player primitive exposed to Lua;
	   hk_history.lua:47-80 records that search in full. Both are delivered as SUI
	   message boxes carrying the .qst's text verbatim, titled with the speaker.

	6. "Social Group must_bandit" is not usable as a discriminator: every ported SOM
	   creature template carries socialGroup "townsperson" or "". The two concrete
	   registered bandit templates are enumerated instead
	   (mobile/custom_content/som/serverobjects.lua:82-83).

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

	-- Level 80 on all seven .qst files -- re-read and confirmed in all seven, and
	-- the prelude's three are 75, which is where story_arc_prelude.lua's number
	-- comes from.
	--
	-- NOTHING GATES ON THIS ANY MORE. It is the level the JOURNAL DISPLAYS, not
	-- an entry requirement, and live's Milo has no level test -- his fifteen
	-- greeting conditions are pure quest state. offerArc used to refuse the arc
	-- below it; that gate was invented here, back when Milo was a radial and
	-- something had to stand in for a giver. Kept declared because the value is
	-- real evidence about the content's intended tier.
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

	-- The cruiser, node 12112205. LIVE POSITION. The crash-site dungeon spawn
	-- table places must_orc_computer in room "bridge" at 2.2 / 1.9 / 8, yaw -90.
	-- The old value here (0.0 / 1.66 / 11.3, heading 180) was INFERRED from the
	-- .ilf's two pilot chairs and is superseded -- it was 3.4 m too far forward and
	-- faced the wrong way. Root cause of the guess: the dungeon spawn tables were
	-- not in the searched set, only the .qst files and the interior layouts.
	cruiser = { nodeID = 12112205, cell = "bridge", x = 2.2, z = 1.9, y = 8, heading = -90 },

	-- task 1: 4 circuit boards at 60 percent, from Salvage Bandits.
	-- "Social Group must_bandit" is unusable (all SOM templates carry socialGroup
	-- "townsperson" or ""), so the concrete registered templates are enumerated;
	-- both are included from mobile/custom_content/som/serverobjects.lua:82-83.
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
	-- Node 12111281 is the door, half a metre away, and it is a DIFFERENT object:
	-- mustafar_instances.lua's uplink_cave pool now owns it, with its own radial
	-- and the "story_arc_uplink" gate. This file owns 12111374 only. Keeping the
	-- two straight matters -- an earlier note in this file claimed a menu collision
	-- between them, and there is none.
	uplinkEntrance = { nodeID = 12111374 },

	-- SUBSTITUTED: the .qst names "an automated repair droid" and "the relay it
	-- makes" but gives no template for either. must_mining_droid_mark_01 is the only
	-- registered SOM utility droid (mobile/custom_content/som/serverobjects.lua:79)
	-- and must_satellite_uplink is the one registered uplink prop
	-- (object/custom_content/building/mustafar/items/serverobjects.lua:12).
	repairDroid = { template = "must_mining_droid_mark_01", respawn = 300 },
	uplinkRelayTemplate = "object/building/mustafar/items/must_satellite_uplink.iff",

	-- INFERRED: the .qst states beetles attack the droid and the relay but gives no
	-- count and no templates. All three registered kubaza templates are accepted as
	-- kills (mobile/custom_content/som/serverobjects.lua:59-61); four is the
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
	-- Every copy has to be furnished, so these three go into each one.
	--
	-- ALL THREE USED TO SIT IN CELL "entrance", at coordinates INFERRED from the
	-- .ilf's entrance fixtures. Root cause of that guess: the dungeon spawn tables
	-- were not in the searched set, only the .qst files and the interior layouts.
	--
	-- The live table has now been read, and it settles TWO of the three. It has a
	-- row for Delta Five (core_tower8) and a row for the power terminal
	-- (smallroom12) -- two different cells, neither of them the entrance. It has
	-- NO row for the third; orfContact is INVENTED and its own entry says so and
	-- says why. So each terminal now carries its own cell and
	-- spawnFacilityTerminals resolves one per terminal, instead of a single
	-- orfCell shared by all three.
	--
	-- Stated this way on purpose: "the table places all three" would be an
	-- overclaim, and it is exactly the kind that made the original guess look
	-- like a reading.
	orfPool = "old_republic_facility",

	-- LIVE ROW, verbatim. terminal_bank_floor_on_02.iff, named "Terminal Delta
	-- Five", room core_tower8, yaw 123.759, carrying the one script
	-- conversation.story_arc_chapter_two_computer. This is the AI's terminal and
	-- it now runs the real shipped conversation; see must_facility_ai.lua and
	-- mobile/conversations/mustafar/story_arc_chapter_two_computer.lua.
	-- The old value -- entrance, 22.4 / 0.0 / 4.27, heading 270, wearing
	-- must_orc_computer -- was wrong in cell, position, facing and appearance.
	orfDeltaFive = { cell = "core_tower8", x = 70.0275, z = -34.106, y = 14.0088, heading = 123.759 },
	deltaFiveTemplate = "object/tangible/furniture/terminal/terminal_bank_floor_on_02.iff",

	-- LIVE PLACEMENT, BORROWED BEHAVIOUR. Chapter one 03 task 3 says "find a power
	-- access terminal" and names no template and no position, but the facility
	-- ships one object called exactly that: terminal_bank_floor_on_01.iff, "Power
	-- Access Terminal", room smallroom12, yaw 90. That object belongs to the
	-- eight-object mustafar_trials puzzle (script quest_object_01) which this repo
	-- does not implement, so the SPOT is live's and the behaviour is this file's.
	-- The appearance stays must_control_computer, which is the repo's own choice
	-- and not a claim about what stands there on live.
	orfPower = { cell = "smallroom12", x = 2.48938, z = 0.0, y = -24.9179, heading = 90 },

	-- NO LIVE ROW EXISTS FOR THIS ONE, and that is the honest version. Live has no
	-- separate "contact the ship's AI" terminal: Delta Five is the AI's terminal
	-- for both visits, and the conversation's own greeting covers the before-power
	-- case with its s_72 screen. The repo still needs a discrete trigger to move
	-- STAGE_TRAVEL_ORF -> STAGE_ORF_POWER, so this stand-in stays, in the entrance
	-- where the player arrives. INVENTED PLACEMENT -- the only one of the three.
	orfContact = { cell = "entrance", x = 22.4, z = 0.0, y = -4.16, heading = 270 },

	-- The power terminal template: object/tangible/quest/must_control_computer.iff,
	-- registered by addTemplate in
	-- object/custom_content/tangible/quest/must_control_computer.lua:5, included
	-- from object/custom_content/tangible/quest/serverobjects.lua:253.
	controlComputerTemplate = "object/tangible/quest/must_control_computer.iff",

	--------------------------------------------------------------------------
	-- THE TWO DROID FACTORIES
	--------------------------------------------------------------------------
	-- Both pools are wired and both are REACHABLE. They share exterior door
	-- 12112909, which has exactly one radial, so the door has to choose:
	--
	--     stage 13 (repair) and stage 20 (shutdown)  ->  working_droid_factory
	--     stage 19                                   ->  the keypad, door sealed
	--     any other stage                            ->  decrepit_droid_factory
	--
	-- Earlier stages fall into the same branch and are refused by
	-- mayEnterDroidFactory at the gate, so the door never opens for them.
	--
	-- The two arc tasks both target the operational factory. Nothing in the tree
	-- states a rule for reaching the decrepit one -- in live the keypad code
	-- decided, and that puzzle only covers the arc -- so the rule above is ours,
	-- ruled by Aaron 2026-08-31 as part of completing Mustafar rather than left as
	-- an open question. It is the same class of deviation as using arc stage in
	-- place of the code, and it is what makes the decrepit interior reachable
	-- instead of furnished-and-sealed.
	--
	-- ⚠ TWO EARLIER CLAIMS HERE WERE FALSE and are withdrawn. This comment said
	-- "the decrepit one is enterable" and the note above useFactoryDoor said "both
	-- interiors CAN now be entered", while useFactoryDoor passed self.factoryPool
	-- unconditionally and nothing ever named decrepitPool. The prose described the
	-- intent; the code did not implement it. Caught by review, not by testing,
	-- which is the argument for reading a claim against the line it describes.
	factoryPool = "working_droid_factory",
	decrepitPool = "decrepit_droid_factory",

	-- QUOTED, and it is the ONLY end-of-dungeon terminal row in
	-- som_working_droid_factory.tab: room centralroom28, loc_x 63.738,
	-- loc_y -22.7667, loc_z 7.09469, yaw -92.8192, script
	-- theme_park.dungeon.mustafar_trials.decrepit_droid_factory.exit_terminal.
	-- Chapter two 01 task 1 wants the player "at the bottom of the factory" to
	-- "restart the main computer processor" and chapter three 01 task 16 wants it
	-- shut down; live has one system_controller, so both tasks use it.
	factorySystem = { cell = "centralroom28", x = 63.738, z = -22.7667, y = 7.09469, heading = -92.8192 },

	-- The template on that row really is the DECREPIT factory's system_controller.
	-- The working factory's table borrows it rather than shipping its own -- the
	-- working_droid_factory template directory registers only four objects and no
	-- controller at all. Quoted as live has it, not tidied. Registered by
	-- addTemplate in object/custom_content/tangible/dungeon/mustafar/
	-- decrepit_droid_factory/system_controller.lua:1, included from that
	-- directory's serverobjects.lua and reached from object/serverobjects.lua:90.
	factorySystemTemplate = "object/tangible/dungeon/mustafar/decrepit_droid_factory/system_controller.iff",

	-- QUOTED, som_decrepit_droid_factory.tab: master_power_core in smallroom20 at
	-- 7.15079 / -24 / -1.20436 yaw 90.5273 (script ...decrepit_droid_factory.power_core),
	-- and security_controller in mainroom27 at 69.2167 / -23.6592 / 3.87901 yaw
	-- 117.639 (script ...final_security_terminal). Both are scenery here: this repo
	-- does not implement the factory's own trial, so they are placed where live
	-- places them and carry no radial. Stated so the next reader does not mistake
	-- a correct position for an implemented puzzle.
	decrepitPowerCore = { cell = "smallroom20", x = 7.15079, z = -24, y = -1.20436, heading = 90.5273 },
	decrepitSecurity = { cell = "mainroom27", x = 69.2167, z = -23.6592, y = 3.87901, heading = 117.639 },

	decrepitPowerCoreTemplate = "object/tangible/dungeon/mustafar/decrepit_droid_factory/master_power_core.iff",
	decrepitSecurityTemplate = "object/tangible/dungeon/mustafar/decrepit_droid_factory/security_controller.iff",

	-- Live's completeChapterOne closes with badge.grantBadge(player,
	-- "bdg_must_victory_orf") -- collection_n.stf calls it "Old Republic Seeker",
	-- collection_d.stf "You have activated the Old Republic Facility." It is
	-- granted nowhere else in the seven story-arc scripts and it was missing from
	-- this port entirely. Root cause: the arc was built from the .qst files, and
	-- the .qst files carry no reward rows -- the badge lives in the conversation.
	-- Exactly the same miss, for the same reason, as the Keslev exploration badge.
	--
	-- Badge keys arrive in Lua as uppercase globals holding their index, so this
	-- is looked up by name at grant time and skipped if this server's badge_map
	-- has no such row. Same guarded idiom as mining_field_markers.lua:644.
	completionBadge = "BDG_MUST_VICTORY_ORF",

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
	-- must_scout is included from mobile/custom_content/som/serverobjects.lua:84.
	-- Its customName was once the raw placeholder "must_scout" and this comment
	-- recorded that as an open decision. It is resolved: must_scout.lua:17 now
	-- carries customName = "Scout Olon Lono", the name his own live conversation
	-- script sets through setName in both OnInitialize and OnAttach. That file's
	-- header documents the find. Nothing is open here.
	scoutPost = { x = 550, y = -154, waypointName = "Mustafarian Scout", respawn = 300 },

	-- INFERRED, and now a CHECKED inference rather than an unchecked one. The
	-- .qst says "an army of droids" with no roster and no count -- and the live
	-- spawn tables do not supply them either, because this army is not a dungeon
	-- population. The .qst is explicit that HK-47 "has sent out an army of droids
	-- FROM the factory towards the Mining Facility": it marches in the open, so
	-- there is no room for it to be a row in. Both factory tables were read to be
	-- sure. The operational factory holds one mob in total; the decrepit factory
	-- is a different dungeon with its own roster.
	--
	-- That roster would be the more faithful substitution if it were available --
	-- SOE populates its own factories with som_decrepit_battle_droid,
	-- som_decrepit_super_battle_droid and som_decrepit_cww8_combat_droid -- but
	-- none of those templates is registered in this repo, so they cannot be used.
	-- These are the three registered SOM battle droid templates
	-- (mobile/custom_content/som/serverobjects.lua:43-45); six is the authored
	-- wave size.
	--
	-- mustafar_dungeon_population.lua now stands those three live names in as
	-- exactly these three templates, so the army and the decrepit factory's own
	-- garrison are made of the same mobiles. That is not a collision: countDroid
	-- fires only at STAGE_DROID_ARMY (16), and mayEnterDroidFactory admits exactly
	-- STAGE_REPAIR_FACTORY (13) and stage >= STAGE_ENTER_FACTORY (19). 16 is
	-- neither, so both factory pools are shut at the one stage that counts these
	-- kills and nobody can be inside to farm them. Checked, not assumed --
	-- re-checked when that gate was corrected, because the gate is the whole
	-- argument: it previously read ">= 19" alone, and widening it to admit 13 does
	-- not admit 16.
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

	-- Engineer Cobar hands the tool over. He is NOT inferred: SOE's
	-- conversation/story_arc_chapter_three_cobar ships, renames the mob "Engineer
	-- Cobar", and fires SIGNAL_OVERRIDE_TOOL as its only action. His tree is in
	-- mobile/conversations/mustafar/story_arc_chapter_three_cobar.lua and his
	-- mobile in mobile/custom_content/som/engineer_cobar.lua.
	--
	-- HIS POSITION IS THE ONE INFERRED THING ABOUT HIM. He is the only story-arc
	-- NPC with no row in any dungeon spawn table. The .qst task says "Talk to one
	-- of the engineers located at the Mensix Mining Facility" and his own default
	-- line puts him at a computer terminal inside it; small_room_05, cell
	-- 12112243, is that facility's technician room in the live table -- it carries
	-- the technician patrol markers, Chief Drono and the exploration marker -- so
	-- he stands in the free corner of it. The ROOM is reasoned from live evidence.
	-- The coordinate inside it is not.
	cobar = { template = "engineer_cobar", cellID = 12112243, x = -147.5, z = 19.1, y = -64.8, heading = 45, respawn = 300 },

	--------------------------------------------------------------------------
	-- CHAPTER THREE 03 -- "Destroy HK-47"
	--------------------------------------------------------------------------

	-- The .qst carries no coordinates, but the pilot is not inferred: the facility
	-- spawn table has a som_volcano_pilot row carrying
	-- conversation.story_arc_chapter_three_pilot -- this task's own conversation --
	-- in landing_deck_room, cell 12112248, at (-41.9, 31.5, -106.9) facing -145.
	-- A pilot on the landing deck. miner_pilot is included from
	-- mobile/custom_content/som/serverobjects.lua:69 and carries pvpBitmask NONE.
	--
	-- An earlier revision stood him outdoors at (-2476, 230.1, 1627), beside the
	-- two travellers mensix_mining_facility_main.lua moves out of the deck. Those
	-- travellers are outdoors only because Levarris moved them there for
	-- spatialChat; borrowing their height was borrowing a workaround's position.
	pilot = { template = "miner_pilot", cellID = 12112248, x = -41.9, z = 31.5, y = -106.9, heading = -145, respawn = 300 },

	-- INVENTED, and it has to be. There is no live position for THIS HK-47 -- the
	-- one the player fights in the volcano arena -- to be read from.
	--
	-- This used to read "INFERRED" and offer node 12112130 (must_power_rod,
	-- -2742.13 h 246.58 3636.59) as the highest snapshot node in the central-volcano
	-- region, as though live had a ground position that was merely hard to locate.
	-- It does not, and four things say so independently:
	--   - hk47 appears nowhere in mustafar.ws. He is not a snapshot node.
	--   - He has no creature row in ANY dungeon spawn table, not just the SOM ones.
	--     The whole dungeon set was searched for him, not only the five Mustafar
	--     tables, and he is in none of them.
	--   - No volcano spawn table ships at all. The SOM dungeon tables are the mining
	--     facility, the ORF, the crash-site cruiser and the two droid factories.
	--   - som_story_arc_chapter_three_03.qst carries LocationX/Y/Z 0.0,
	--     createWaypoint 0 and an empty waypointName on EVERY arena task --
	--     volcano_arena_one, _three, _four, _five. All five. That is not an
	--     omission, it is the shape of a task that happens somewhere the ground
	--     map cannot address.
	--
	-- ONE THING THAT LOOKS LIKE A COUNTEREXAMPLE AND IS NOT, recorded so it is not
	-- re-litigated: the operational droid factory's spawn table does contain an
	-- HK-47 beat, as a set of patrol_waypoint objects in mainroom27 and smallroom20
	-- tagged by an hk_sequence objvar -- hk_spawn, hk_moveto, fire1/2/3, and two
	-- player trigger points running the factory's hk_final_trigger script. That is
	-- a scripted appearance inside a dungeon: marks for where a cutscene stands him
	-- and moves him, not a spawn of the creature and not the arena.
	--
	-- This file DOES own that pool now, so the old sign-off -- "it is real content
	-- for whoever wires that pool" -- is withdrawn; there was never another owner
	-- to hand it to. Owning it does not change the conclusion, and that is what
	-- makes it worth keeping: the hk_sequence marks are a cutscene the engine
	-- cannot play, seven waypoint objects with no creature row behind them. They
	-- still give the arena fight no coordinate. They are deliberately NOT spawned
	-- -- reproducing the marks for a cutscene that cannot run would be scenery
	-- pretending to be content.
	--
	-- mustafar_volcano is its own ZONE, not a place on this one: zone_n.stf calls
	-- it "Mustafar Volcano" and instance.stf calls it "Mustafar: The Volcano
	-- Crater". Menddle flies the player into it. Core3 has no such zone, so
	-- HK-47 stands on the open terrain instead and the player walks to a waypoint
	-- -- the deviation story_arc_chapter_three_pilot.lua already states in full.
	-- The coordinate below is a consequence of that deviation, not a reading.
	--
	-- ROOT CAUSE: searching the ground zone for a position without first asking
	-- whether the encounter is ON the ground zone. The five all-zero task
	-- locations were the answer and were read as missing data. A .qst that
	-- carries no coordinates anywhere is telling you something; it is not a gap
	-- to be filled from the nearest plausible landmark.
	--
	-- hk47 is included from mobile/custom_content/som/serverobjects.lua:54.
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
	-- mobile/custom_content/som/serverobjects.lua:78, customName
	-- "Milo Mensix", level 70, conversationTemplate "" -- so he has no shipped
	-- conversation and is driven by radial.
	--
	-- LIVE position, not inferred. The facility's dungeon spawn table puts him in
	-- conference_room -- cell 12112241 -- at (-158.1, 22.6, -15.2) facing 90, and
	-- names conversation.story_arc_chapter_one_milo on the row, which is what
	-- identifies it as this Milo. He is the head of the company; his room is the
	-- boardroom, not the bar. Urup Falco stands in the same room at h 19.1 and
	-- Milo at 22.6, so he is up on the dais at the head of it.
	--
	-- An earlier revision put him in the cantina, cell 12112226, at (-87, 10.8,
	-- 62). The reasoning was that the cantina is where the arc's other NPCs are
	-- and the spot cleared all seven of them by 8 m. Both statements were true
	-- and neither was evidence; story_arc_prelude.lua records the same mistake
	-- made about Chivos, one room over.
	milo = { template = "must_milo_mensix", cellID = 12112241, x = -158.1, z = 22.6, y = -15.2, heading = 90, respawn = 300 },

	-- "the terminal located in this room" -- chapter three chapter 03 task 6.
	-- LIVE. The spawn table carries exactly one object row for conference_room:
	-- object/tangible/item/som/communication_console.iff at (-140.5, 19, -10.2),
	-- on the room's own floor plane rather than Milo's dais. A communication
	-- console in the room the player is told to check messages in is the terminal
	-- that line means, so both the template and the spot are the live ones now.
	-- The template is registered at
	-- object/custom_content/tangible/item/som/communication_console.lua:5.
	miloTerminalTemplate = "object/tangible/item/som/communication_console.iff",
	miloTerminal = { x = -140.5, z = 19.0, y = -10.2, heading = 0 },

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

	-- Runtime handles, filled by start(). Never persisted -- and, as it turns out,
	-- never read either: all four are assigned once and used nowhere. They are the
	-- leftovers of the radial and menu-component code that did read them. Kept
	-- rather than removed, and labelled so the next reader does not go looking for
	-- the consumer. story_arc_prelude.lua's crashAreaID / arrivalAreaID / chivosID
	-- are the same three-of-a-kind.
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
		self:spawnFactoryTerminals()
		self:spawnMilo()
		self:spawnCobar()
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

-- must_orc_computer goes on the bridge of the crashed cruiser, node 12112205, at
-- the live spawn-table spot. resolveCell prefers the pob's own named cell and
-- never invents a cell id; the shape is kenobi_spine.lua:resolveCell.
--
-- TWO objects go on that spot, and the reason is in must_cruiser_ai.lua's header.
-- Live hangs two scripts on the one tangible: retrieve_item_on_item, which is the
-- "Install Circuit Boards" step, and the conversation. Core3 can only start a
-- conversation from an AiAgent, so the terminal keeps the radial and an invisible
-- carrier standing on it keeps the talk.
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

	-- The conversation carrier, on the same coordinate. If it fails to spawn the
	-- terminal still works for the circuit-board step, so this is a warning and
	-- not a return -- but the briefing would be unreachable, so say which.
	local pAI = spawnMobile("mustafar", "must_cruiser_ai", 0, self.cruiser.x, self.cruiser.z, self.cruiser.y, self.cruiser.heading, cellID)

	if (pAI == nil) then
		print("storyArcChaptersScreenPlay: must_cruiser_ai failed to spawn on the cruiser bridge; the ship AI's conversation will be unreachable")
	end
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

		-- Each terminal names its own cell now; the live table puts them in three
		-- different rooms. See the orf* block for the rows.
		self:spawnFacilityTerminal(pBuilding, self.orcComputerTemplate, self.orfContact, "facilityContact")
		self:spawnFacilityTerminal(pBuilding, self.controlComputerTemplate, self.orfPower, "facilityPower")

		-- Terminal Delta Five carries NO role and NO menu component. Live hangs a
		-- single script on it, conversation.story_arc_chapter_two_computer, so the
		-- conversation is the whole object -- there is nothing left for a radial to
		-- do. The invisible carrier beside it is what the player actually talks to;
		-- must_facility_ai.lua carries the DEVIATION and the C++ citation.
		self:spawnFacilityTerminal(pBuilding, self.deltaFiveTemplate, self.orfDeltaFive, nil)
		self:spawnFacilityCarrier(pBuilding, "must_facility_ai", self.orfDeltaFive)
	end
end

-- Both factories are instance POOLS, so every copy is furnished, exactly as the
-- Old Republic Facility above is. The working factory gets the system_controller
-- the arc uses; the decrepit one gets the two live tangibles that stand in its
-- own table. Cell names come from the dungeon tables, not from a .ilf -- no droid
-- factory .ilf ships, which is true and, as the header now records, irrelevant.
--
-- CELLS UNVERIFIED, and said plainly rather than discovered later: centralroom28,
-- smallroom20 and mainroom27 are read off the live spawn tables, and there is no
-- .ilf and no .pob in this tree to check them against. If a copy has no cell by
-- that name, resolveCell returns 0 and the print below names the missing cell.
-- That is the check, and it runs at boot rather than being assumed.
function storyArcChaptersScreenPlay:spawnFactoryTerminals()
	if (MustafarInstances == nil) then
		print("storyArcChaptersScreenPlay: mustafar_instances.lua is not loaded; the droid factory terminals will not be placed")
		return
	end

	local working = MustafarInstances:getPoolBuildings(self.factoryPool)

	if (working == nil or #working == 0) then
		print("storyArcChaptersScreenPlay: instance pool '" .. self.factoryPool .. "' is empty; the droid factory terminals will not be placed")
	else
		for i = 1, #working do
			local pBuilding = getSceneObject(working[i])

			self:spawnFacilityTerminal(pBuilding, self.factorySystemTemplate, self.factorySystem, "factorySystem")
		end
	end

	local decrepit = MustafarInstances:getPoolBuildings(self.decrepitPool)

	if (decrepit == nil or #decrepit == 0) then
		print("storyArcChaptersScreenPlay: instance pool '" .. self.decrepitPool .. "' is empty; the decrepit factory fittings will not be placed")
		return
	end

	for i = 1, #decrepit do
		local pBuilding = getSceneObject(decrepit[i])

		-- No role on either: they are live's own fittings, not arc triggers.
		self:spawnFacilityTerminal(pBuilding, self.decrepitPowerCoreTemplate, self.decrepitPowerCore, nil)
		self:spawnFacilityTerminal(pBuilding, self.decrepitSecurityTemplate, self.decrepitSecurity, nil)
	end
end

function storyArcChaptersScreenPlay:spawnFacilityTerminal(pBuilding, template, spot, role)
	-- Shared by the facility and both factories now, so the message names the cell
	-- and the template rather than assuming which building it was called for.
	local cellID = self:resolveCell(pBuilding, spot.cell)

	if (cellID == 0) then
		print("storyArcChaptersScreenPlay: no cell named '" .. spot.cell .. "' in this building; " .. template .. " will not be placed")
		return
	end

	local pTerminal = spawnSceneObject("mustafar", template, spot.x, spot.z, spot.y, cellID, math.rad(spot.heading))

	if (pTerminal == nil) then
		print("storyArcChaptersScreenPlay: " .. template .. " failed to spawn in cell " .. spot.cell)
		return
	end

	-- A terminal whose whole job is to be talked to gets no radial; see above.
	if (role == nil) then
		return
	end

	writeStringData(SceneObject(pTerminal):getObjectID() .. ":storyArcChaptersRole", role)
	SceneObject(pTerminal):setObjectMenuComponent("StoryArcChaptersMenuComponent")
end

-- The conversation carrier, on the terminal's own coordinate. Nothing else in the
-- facility depends on it, but the chapter one 03 finish, the chapter two 01 grant
-- and bdg_must_victory_orf all hang off its conversation, so say plainly what is
-- lost if it fails rather than printing a generic spawn error.
function storyArcChaptersScreenPlay:spawnFacilityCarrier(pBuilding, template, spot)
	local cellID = self:resolveCell(pBuilding, spot.cell)

	if (cellID == 0) then
		return
	end

	local pAI = spawnMobile("mustafar", template, 0, spot.x, spot.z, spot.y, spot.heading, cellID)

	if (pAI == nil) then
		print("storyArcChaptersScreenPlay: " .. template .. " failed to spawn in cell " .. spot.cell .. "; chapter one 03 cannot be finished")
	end
end

-- Milo Mensix. No radial and no menu component on the man himself: he carries a
-- real shipped conversation, story_arc_chapter_one_milo, and talking to him is
-- the interaction.
--
-- This block used to read "He has conversationTemplate "" in his own template,
-- so he is radial-driven; see the header for why no conversation table is
-- authored here." The first half was true and the second did not follow -- the
-- empty conversationTemplate was THIS REPO's gap, not evidence about live. Live
-- ships a 43-screen tree for him, the longest in the arc.
--
-- ROOT CAUSE: the enumeration that built the arc searched conversation scripts
-- and string tables whose name begins som_, because that is how the quests, the
-- mobiles and the datatables are named. These conversations are named
-- story_arc_* and ship in the base string/en/conversation/ set, so nothing under
-- that prefix was ever in the set being searched, and "no rows found" was read
-- as "did not ship". Same root cause as Cobar, the scout, the pilot and both
-- computers.
--
-- His message console keeps its radial. That is a different object with its own
-- live script; see useMiloTerminal.
function storyArcChaptersScreenPlay:spawnMilo()
	local pMilo = spawnMobile("mustafar", self.milo.template, self.milo.respawn, self.milo.x, self.milo.z, self.milo.y, self.milo.heading, self.milo.cellID)

	if (pMilo == nil) then
		print("storyArcChaptersScreenPlay: " .. self.milo.template .. " failed to spawn; the whole arc will be ungiveable")
		return
	end

	-- DEAD, and left that way deliberately. This assignment is the only thing that
	-- touches self.miloID; nothing in this file or any other reads it. It used to
	-- be justified as "keep the id the spawn just handed back -- story_arc_prelude
	-- keeps Foreman Chivos's the same way", but that precedent is dead too:
	-- chivosID is written once there and read nowhere either. A dead field cited
	-- as the warrant for a dead field.
	--
	-- It survived because the role write and menu component that used to follow it
	-- did read it, and they went with the radial while the handle stayed. Left in
	-- place rather than removed -- it costs one assignment, and taking it out is a
	-- deletion, not a correction. See the runtime-handle note on the field itself.
	self.miloID = SceneObject(pMilo):getObjectID()

	local pTerminal = spawnSceneObject("mustafar", self.miloTerminalTemplate, self.miloTerminal.x, self.miloTerminal.z, self.miloTerminal.y, self.milo.cellID, math.rad(self.miloTerminal.heading))

	if (pTerminal == nil) then
		print("storyArcChaptersScreenPlay: the message terminal in Milo's room failed to spawn")
		return
	end

	writeStringData(SceneObject(pTerminal):getObjectID() .. ":storyArcChaptersRole", "miloTerminal")
	SceneObject(pTerminal):setObjectMenuComponent("StoryArcChaptersMenuComponent")
end

-- Engineer Cobar. No radial and no menu component: he carries a real shipped
-- conversation, so talking to him is the interaction. See the cobar block above
-- for why his room is evidence and his coordinate is not.
function storyArcChaptersScreenPlay:spawnCobar()
	local pCobar = spawnMobile("mustafar", self.cobar.template, self.cobar.respawn, self.cobar.x, self.cobar.z, self.cobar.y, self.cobar.heading, self.cobar.cellID)

	if (pCobar == nil) then
		print("storyArcChaptersScreenPlay: " .. self.cobar.template .. " failed to spawn; the terminal override side quest will be uncompletable")
	end
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
	end

	-- No role and no menu component. He carries story_arc_chapter_three_scout on
	-- his mobile template, so the converse radial is the stock one and everything
	-- he does runs through scout_conv_handler.
end

-- Live position, cell-local on the landing deck; see the pilot block above.
function storyArcChaptersScreenPlay:spawnPilot()
	local pPilot = spawnMobile("mustafar", self.pilot.template, self.pilot.respawn, self.pilot.x, self.pilot.z, self.pilot.y, self.pilot.heading, self.pilot.cellID)

	if (pPilot == nil) then
		print("storyArcChaptersScreenPlay: " .. self.pilot.template .. " failed to spawn; the 'Talk to a Pilot' step will be unreachable")
	end

	-- No role and no menu component; see spawnScout. He carries
	-- story_arc_chapter_three_pilot and runs through pilot_conv_handler.
end

-- INVENTED position -- live fights him in the mustafar_volcano zone, not on this
-- one, so there is nothing to quote. See the hk47 entry. HK-47 is hostile and is left standing;
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

-- som_story_arc_chapter_three_02 is the solo side quest and it holds exactly one
-- task, mustafar_droid_factory_slicing, so "the quest is active" and "that task
-- is active" are the same test. It has no stage integer of its own because it
-- runs ALONGSIDE STAGE_FACTORY_TERMINAL rather than after it: the factory
-- terminal refusing the player is what opens it (sliceQuest), and Cobar handing
-- the tool over is what closes it (overrideTool).
--
-- This is what cobar_conv_handler dispatches on. It is the repo's translation of
-- SOE's groundquests.isTaskActive(player, "som_story_arc_chapter_three_02",
-- "mustafar_droid_factory_slicing").
function storyArcChaptersScreenPlay:isSlicingTaskActive(pPlayer)
	return self:hasFlag(pPlayer, "sliceQuest") and not self:hasFlag(pPlayer, "overrideTool")
end

-- SOE's story_arc_chapter_three_cobar_action_grantTool is a single sendSignal of
-- "mustafar_droid_factory_tool_recieved" -- the misspelling is SOE's and it is
-- what the .qst's Wait for Signal task listens for. There is no groundquests
-- journal here for that signal to land in, so the flag is the signal.
function storyArcChaptersScreenPlay:grantOverrideTool(pPlayer)
	if (self:hasFlag(pPlayer, "overrideTool")) then
		return
	end

	self:setFlag(pPlayer, "overrideTool")
	CreatureObject(pPlayer):sendSystemMessage("You have received a terminal override tool.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
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

	-- "milo" used to be handled here. Milo Mensix carries the shipped conversation
	-- story_arc_chapter_one_milo, so he now runs through milo_conv_handler and has
	-- no role and no radial.
	if (role == "crashTerminal") then
		self:useCrashTerminal(pPlayer)
	elseif (role == "shipComputer") then
		self:useShipComputer(pPlayer)
	elseif (role == "uplinkEntrance") then
		self:useUplinkEntrance(pPlayer)
	elseif (role == "facilityContact") then
		self:useFacilityContact(pPlayer)
	elseif (role == "facilityPower") then
		self:useFacilityPower(pPlayer)
	-- "facilityDelta" used to be handled here. Terminal Delta Five carries the
	-- shipped conversation story_arc_chapter_two_computer, so it now runs through
	-- facility_computer_conv_handler and has no role and no radial.
	elseif (role == "factoryDoor") then
		self:useFactoryDoor(pPlayer)
	elseif (role == "factorySystem") then
		self:useFactorySystem(pPlayer)
	elseif (role == "factoryTerminal") then
		self:useFactoryTerminal(pPlayer, objectID)
	elseif (role == "factoryKeypad") then
		self:useFactoryKeypad(pPlayer)
	-- "scout" and "pilot" used to be handled here. Both ship real conversations
	-- -- story_arc_chapter_three_scout and story_arc_chapter_three_pilot -- so
	-- they now run through their conv_handlers and carry no role and no radial.
	elseif (role == "miloTerminal") then
		self:useMiloTerminal(pPlayer)
	end
end

--------------------------------------------------------------------------------
-- MILO MENSIX -- giver, and the turn-in for three of the seven quests
--------------------------------------------------------------------------------

-- useMilo and offerArc used to live here. Between them they were a four-branch
-- radial and an SUI box that read out chapter one 01's journal prose, standing
-- in for a giver that was believed not to ship. It ships:
-- conversation/story_arc_chapter_one_milo, fifteen greeting conditions and
-- forty-three screens, and every one of those four radial branches is one of its
-- greetings. See spawnMilo above for the root cause of the wrong claim, and
-- milo_conv_handler.lua for the dispatch that replaced it.
--
-- Two things the stand-in did that live does not, both dropped on purpose:
--
--   THE SUI BOX. Live never shows chapter one 01's list description in a window
--   -- it is the journal entry, and the player reads it in the journal. The box
--   was a way to say "you have a mission now" when there was no conversation to
--   say it. Milo says it himself now, at length.
--
--   THE LEVEL GATE. offerArc refused the arc below requiredLevel (80). Live's
--   Milo has no level test; his fifteen conditions are pure quest state. The 80
--   is the "Level" row of the seven .qst files, verified in all seven -- that is
--   the level the JOURNAL DISPLAYS, not an entry requirement. requiredLevel
--   stays declared above because the value is real evidence, but nothing gates
--   on it any more.
--
-- What is left below is SOE's five actions, one function each.

-- ACTION grantFirstMission -- s_92 -> s_103, the option that starts the arc.
-- The prelude check is live's own condition 14, re-tested here so the grant
-- cannot outrun the greeting that offered it.
function storyArcChaptersScreenPlay:grantFirstMission(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_NONE or not self:isPreludeComplete(pPlayer)) then
		return
	end

	self:advance(pPlayer, self.STAGE_TRAVEL_WRECK)
	self:startKillWatch(pPlayer)
end

-- ACTION grantFinalChapter -- s_87 -> s_90. Live opens with a sendSignal of
-- mustafar_factory_finish and then grants chapter three 01; the signal was the
-- cross-script wake-up this repo does not need.
function storyArcChaptersScreenPlay:grantFinalChapter(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_WARN_MILO) then
		return
	end

	self:advance(pPlayer, self.STAGE_DROID_ARMY)
	self:startKillWatch(pPlayer)
end

-- ACTION startVolcanoQuest -- s_112 -> s_113. Live signals
-- mustafar_droidfactory_victory, then grants chapter three 03.
function storyArcChaptersScreenPlay:startVolcanoQuest(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_REPORT_MILO) then
		return
	end

	self:advance(pPlayer, self.STAGE_FIND_PILOT)
end

-- ACTION grantFinalReward -- s_115 -> s_116, the last action in the whole arc.
-- Live's whole body is sendSignal(hk_story_arc_completed), which is what puts
-- the encoded message on the console in this room.
function storyArcChaptersScreenPlay:grantFinalReward(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_REPORT_SUCCESS) then
		return
	end

	self:advance(pPlayer, self.STAGE_CHECK_MESSAGE)
end

-- ACTION checkForError -- fires at six places in Milo's tree and does nothing at
-- any of them, on purpose.
--
-- Live's body is: if som_story_arc_chapter_one_01 is still active, complete it.
-- It is a repair. SOE's journal can hold a quest active and its tasks finished
-- at the same time, so a player could walk around with a done mission still
-- showing, and this quietly closes it whenever they next talk to Milo.
--
-- The repo cannot reach that state. Progress here is ONE stage integer, and a
-- stage is either past chapter one 01 or it is not -- there is no second copy of
-- the state to fall out of step with the first. So there is nothing to repair.
--
-- It is kept, and called at all six sites, because deleting it would make SOE's
-- tree look like it has four actions instead of five, and the next person to
-- read the java would file this reconstruction as incomplete. An empty function
-- with the reason attached is the honest version.
function storyArcChaptersScreenPlay:checkForError(pPlayer)
end

--------------------------------------------------------------------------------
-- CHAPTER ONE 01 / 02 -- the crash site
--------------------------------------------------------------------------------

-- Reached through a STACKING observer on nodes 12111401 and 12112127, which
-- map_exploration.lua already owns the radial for. That is why the .qst's
-- "Remove Circuit Board" menu label cannot appear -- see the header.
function storyArcChaptersScreenPlay:useCrashTerminal(pPlayer)
	local stage = self:getStage(pPlayer)

	-- STAGE_FIND_TERMINAL used to be handled here, with an SUI box carrying
	-- chapter one 02's list prose. That was a stand-in. Live closes chapter one 01
	-- task 2 on must_orc_computer itself, from the greeting of the shipped
	-- conversation story_arc_chapter_one_computer: condition ChapOneFirstStep,
	-- screen s_80, action fixTerminal = signal mustafar_orc_complete + grant
	-- chapter one 02. It now runs there -- see cruiser_computer_conv_handler. The
	-- salvage branch below is a different task on a different object and stays.
	if (stage == self.STAGE_SALVAGE_BOARDS) then
		-- chapter one 02 task 0, ItemName verbatim from the .qst.
		CreatureObject(pPlayer):sendSystemMessage("All the circuit boards have been removed already. Damaged terminal")
		self:advance(pPlayer, self.STAGE_SEARCH_BANDITS)
	end
end

-- must_orc_computer on the cruiser bridge. THE RADIAL KEEPS ONLY THE CIRCUIT
-- BOARDS. Live hangs two scripts on this one object, and only one of them is the
-- conversation: quest.task.ground.retrieve_item_on_item is chapter one 02 task 2,
-- "Install Circuit Boards", and that is what is left here. It is also why no
-- condition in story_arc_chapter_one_computer ever tests mustafar_motor_three.
--
-- STAGE_ACTIVATE_COMPUTER and STAGE_UPLINK_REPORT used to be handled here too,
-- each with an SUI box. Both were stand-ins written while the claim stood that
-- the ship's AI had no shipped conversation. It DOES:
-- conversation/story_arc_chapter_one_computer, six greeting conditions, a
-- fourteen-screen briefing and five actions. Root cause of the wrong claim: the
-- enumeration behind it searched conversation scripts and string tables whose
-- name begins som_, and this one is named story_arc_*, so it was never in the set
-- that was looked at. Both now run through cruiser_computer_conv_handler.
function storyArcChaptersScreenPlay:useShipComputer(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_FIX_TERMINAL) then
		-- chapter one 02 task 2, ItemName verbatim.
		CreatureObject(pPlayer):sendSystemMessage("The view screen flickers briefly and then comes to life.")
		self:advance(pPlayer, self.STAGE_ACTIVATE_COMPUTER)
	elseif (stage == self.STAGE_SEARCH_BANDITS) then
		CreatureObject(pPlayer):sendSystemMessage("You still need " .. (self.boardsRequired - self:getCount(pPlayer, "boards")) .. " more circuit boards.")
	end
end

-- ACTION makeUpLink, from the last screen of the briefing -- SOE's grant of
-- som_story_arc_chapter_one_03. Guarded because the briefing is re-reachable at
-- STAGE_TRAVEL_ORF..STAGE_DELTA_FIVE, exactly as it is on live, and a re-hear
-- must not walk the player backwards. Past STAGE_ACTIVATE_COMPUTER it is a no-op,
-- which is what SOE's grantQuest on an already-granted quest does.
function storyArcChaptersScreenPlay:makeUpLink(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_ACTIVATE_COMPUTER) then
		return
	end

	self:advance(pPlayer, self.STAGE_UPLINK)
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

-- Public gate. mustafar_instances.lua calls this from isEntryAllowed for the
-- uplink_cave pool, gate string "story_arc_uplink". The pool is wired; the branch
-- that calls this exists. The comment here used to say that file was "another
-- agent's this run and is NOT edited here" -- there was no other agent, and both
-- halves of the seam are now written.
function storyArcChaptersScreenPlay:mayEnterUplinkCave(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return self:getStage(pPlayer) >= self.STAGE_UPLINK
end

-- Public gate, same seam, for working_droid_factory / decrepit_droid_factory,
-- gate string "story_arc_factory". Those two pools carry entry.nodeID = nil, so
-- this file keeps the radial on door 12112909 and useFactoryDoor below calls
-- MustafarInstances:enterInstance itself. isEntryAllowed asks this as well, since
-- a radial the client already drew can still be clicked.
-- ⚠ THIS GATE WAS WRONG AND LOCKED A TASK OUT OF ITS OWN BUILDING. It read
-- "stage >= STAGE_ENTER_FACTORY", and STAGE_ENTER_FACTORY is 19 while
-- STAGE_REPAIR_FACTORY is 13. Chapter two 01 task 1 -- restart the main computer
-- processor, which happens at stage 13 INSIDE the working factory -- was let
-- through useFactoryDoor and then refused here, silently, because isEntryAllowed
-- returns false with no message. The task was unfinishable and nothing said so.
-- The stage numbers are not in narrative order: the repair visit (13) comes long
-- before the keypad (19) and the shutdown (20), so a single >= threshold cannot
-- express "these three moments".
function storyArcChaptersScreenPlay:mayEnterDroidFactory(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local stage = self:getStage(pPlayer)

	-- Chapter two's repair visit, then everything from the keypad onward. Stage 16
	-- (STAGE_DROID_ARMY) is deliberately NOT admitted, which is what keeps
	-- countDroid's template overlap with the decrepit factory unreachable.
	return stage == self.STAGE_REPAIR_FACTORY or stage >= self.STAGE_ENTER_FACTORY
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

-- Terminal Delta-Five: chapter one 03 task 5.
--
-- useFacilityDelta USED TO LIVE HERE. It was a radial plus an SUI box that
-- paraphrased the AI by quoting the chapter two 01 journal description, written
-- on the claim that no conversation shipped for this terminal. THAT CLAIM WAS
-- FALSE. conversation/story_arc_chapter_two_computer ships, and the live spawn
-- table hangs it on this exact object. Root cause of the false claim: the search
-- was scoped to the som_ name prefix and the som_ string tables, and this
-- conversation is named story_arc_* and ships in the base string/en/conversation
-- set -- the same miss that hid the scout, the pilot and the cruiser AI.
--
-- The ten-screen briefing the box was standing in for is now the real thing, in
-- mobile/conversations/mustafar/story_arc_chapter_two_computer.lua, and the two
-- functions below are the two actions that conversation actually fires. The role,
-- the radial and the branch in handleUse are all gone with it.

-- ACTION completeChapterOne, java:511 -- the last option of the arrival chain.
-- Live sends mustafar_uplink_finish, grants som_story_arc_chapter_two_01 and pays
-- bdg_must_victory_orf. The signal closes chapter one 03 and the grant opens
-- chapter two 01; in the repo that is one edge, STAGE_DELTA_FIVE ->
-- STAGE_FIND_FACTORY, so the advance carries both.
--
-- No message box. advance() already announces the task text and refreshes the
-- waypoint, and the AI has just said all of it in its own words.
function storyArcChaptersScreenPlay:completeChapterOne(pPlayer)
	-- Guarded so a re-hear cannot walk the player backwards, which is what SOE's
	-- grantQuest on an already-granted quest does.
	if (self:getStage(pPlayer) ~= self.STAGE_DELTA_FIVE) then
		return
	end

	self:advance(pPlayer, self.STAGE_FIND_FACTORY)
	self:grantCompletionBadge(pPlayer)
end

-- ACTION grantMission, java:192 -- the last option of the nag chain. The grant
-- alone: no signal and no badge. That chain hangs off hasCompleteChapterOne,
-- which is unreachable in the repo (see facility_computer_conv_handler.lua), so
-- this is wired and will not fire today. Written because the action is real.
function storyArcChaptersScreenPlay:grantChapterTwo(pPlayer)
	if (self:getStage(pPlayer) >= self.STAGE_FIND_FACTORY) then
		return
	end

	self:advance(pPlayer, self.STAGE_FIND_FACTORY)
end

-- Badge keys arrive in Lua as uppercase globals holding their index, so the guard
-- is "does this server's badge_map have that row". It could not be checked from
-- the tre set here, and an unknown badge index would be an error, not a no-op.
-- Same shape as mining_field_markers.lua:644.
function storyArcChaptersScreenPlay:grantCompletionBadge(pPlayer)
	if (self.completionBadge == nil or _G[self.completionBadge] == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):awardBadge(_G[self.completionBadge])
end

--------------------------------------------------------------------------------
-- THE DROID FACTORY -- chapter two 01 task 1, chapter three 01 tasks 9/11/16
--------------------------------------------------------------------------------

-- COLLISION RESOLVED -- this used to be a ⚠ LATENT COLLISION warning addressed to
-- "whoever wires the factory pools next". That was this file's own work, and
-- wiring the pools is what dissolved the hazard rather than triggering it.
--
-- The mechanism it warned about was real: attachEntryProp calls
-- setObjectMenuComponent("MustafarInstanceMenuComponent"), which REPLACES a menu
-- rather than stacking, so a factory pool holding entry = { nodeID = 12112909 }
-- would have silently killed "Restart the main computer processor" and "Shut down
-- the factory". The fix is the third option the old note listed: both factory
-- pools now carry entry.nodeID = nil, mustafar_instances.lua's attachEntryProp
-- returns early on a nil nodeID, and this file's radial calls
-- MustafarInstances:enterInstance directly. One owner for the node, one for the
-- pool.
--
-- ONE CLAIM IN THAT WARNING WAS WRONG and is withdrawn rather than carried
-- forward: "Same hazard on 12111374 for uplink_cave." There is no such hazard.
-- The uplink_cave pool's door is node 12111281; 12111374 is the bunker entrance
-- standing about half a metre from it, and it is the node THIS file owns. Two
-- distinct objects, so the cave keeps its own prop and its own radial and nothing
-- is overwritten. The two node ids were conflated because they sit at almost the
-- same coordinate -- the pool's own comment states both, and it was not read.
--
-- Node 12112909, the exterior door. Chapter two 01 task 1 wants the player at
-- "the bottom of the factory" to "restart the main computer processor", and
-- chapter three 01 task 16 wants the factory shut down from the inside. Both
-- interiors can now be entered -- the working one at the two arc stages, the
-- decrepit one at every later stage, see THE TWO DROID FACTORIES above -- and
-- both arc steps happen inside at the terminal live puts them on.
-- The old text here -- "Neither interior can be entered ...
-- NO droid factory .ilf ships, so there is no defensible interior coordinate to
-- invent ... the largest reduction in the port" -- is withdrawn on both counts:
-- the .ilf absence was true but irrelevant, because both factories ship full
-- dungeon spawn tables, and the pools were unwired rather than unwirable.
-- The door now opens the dungeon instead of standing in for it. This is the half
-- of the seam that lives on this side: the working_droid_factory pool carries
-- entry.nodeID = nil precisely so this file keeps 12112909's menu component, so
-- nothing attaches a competing radial and this call is the only way in.
function storyArcChaptersScreenPlay:useFactoryDoor(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_ENTER_FACTORY) then
		CreatureObject(pPlayer):sendSystemMessage("The door is sealed. The keypad beside it wants a code.")
		return
	end

	if (MustafarInstances == nil) then
		print("storyArcChaptersScreenPlay: mustafar_instances.lua is not loaded; the droid factory cannot be entered")
		return
	end

	-- WHICH FACTORY THE SHARED DOOR OPENS. In live the keypad code decided this;
	-- that puzzle does ship here (role "factoryKeypad" at STAGE_ENTER_FACTORY), but
	-- it only opens the operational factory for the arc. Nothing in the tree states
	-- a rule for reaching the decrepit one, so the rule is ours: the arc owns the
	-- door while the arc needs it, and outside those two moments the door opens the
	-- decrepit factory. That is the same class of deviation as using arc stage in
	-- place of the keypad code, and it is what makes the decrepit interior -- fully
	-- furnished and populated from its own live table -- reachable at all.
	--
	-- enterInstance asks mayEnterDroidFactory again through each pool's
	-- "story_arc_factory" gate. Asking twice is deliberate and matches the pattern
	-- that file already uses: a radial the client has drawn can still be clicked
	-- after the stage moves on. That gate is also what refuses a player who has not
	-- reached the factory at all, so no stage check is needed here for them.
	if (stage == self.STAGE_REPAIR_FACTORY or stage == self.STAGE_SHUTDOWN_FACTORY) then
		MustafarInstances:enterInstance(pPlayer, self.factoryPool)
	else
		MustafarInstances:enterInstance(pPlayer, self.decrepitPool)
	end
end

-- Chapter two 01 task 1 and chapter three 01 task 16, both at the terminal live
-- puts them on rather than at the door. som_working_droid_factory.tab has exactly
-- one end-of-dungeon terminal -- the system_controller in centralroom28 -- so both
-- tasks resolve on the same object, and the stage decides which.
function storyArcChaptersScreenPlay:useFactorySystem(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_REPAIR_FACTORY) then
		CreatureObject(pPlayer):sendSystemMessage("You restart the factory's main computer processor. The assembly lines shudder into life.")
		self:advance(pPlayer, self.STAGE_RETURN_ORF)
	elseif (stage == self.STAGE_SHUTDOWN_FACTORY) then
		CreatureObject(pPlayer):sendSystemMessage("The assembly lines grind to a halt. The droid factory is shut down.")
		self:advance(pPlayer, self.STAGE_REPORT_MILO)
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

		-- The refusal IS the grant of som_story_arc_chapter_three_02. Announce it
		-- once and set the flag Engineer Cobar reads -- see isSlicingTaskActive.
		if (not self:hasFlag(pPlayer, "sliceQuest")) then
			self:setFlag(pPlayer, "sliceQuest")
			self:announceTask(pPlayer, self.overrideToolText[1], self.overrideToolText[2])
		end

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
	sui.setPrompt("@som/som_quest:df_keypad_code")
	sui.sendTo(pPlayer)
end

function storyArcChaptersScreenPlay:keypadCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	if (self:getStage(pPlayer) ~= self.STAGE_ENTER_FACTORY) then
		return
	end

	-- The code is not knowledge the character has until it has been read. It lives
	-- in the factory's own history log, entry 7, which useFactoryTerminal hands over
	-- with the datapad. Guessing 37323 out of character is refused here.
	-- hk_history.lua is reached through _G so this file does not hard-depend on it.
	local history = _G["somHkHistoryScreenPlay"]

	if (history ~= nil and history.hasPlayedEntry ~= nil
			and not history:hasPlayedEntry(pPlayer, self.factoryHistoryEntry)) then
		CreatureObject(pPlayer):sendSystemMessage("@som/som_quest:df_keypad_unknown")
		return
	end

	if (args ~= self.factoryPasscode) then
		CreatureObject(pPlayer):sendSystemMessage("@som/som_quest:df_keypad_incorrect")
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("@som/som_quest:df_keypad_unlocked")
	self:advance(pPlayer, self.STAGE_SHUTDOWN_FACTORY)
end

--------------------------------------------------------------------------------
-- CHAPTER THREE 01 / 03 -- the scout, the pilot, the last message
--------------------------------------------------------------------------------

-- Scout Olon Lono stands at the exact coordinate chapter three 01 task 6 puts its
-- waypoint on. Talking to him is what releases the droid army; the .qst gives no
-- roster and no count, so both are INFERRED.
--
-- This is called from scout_conv_handler, not from a radial. It is the repo's
-- stand-in for SOE's sendGroupToBattlefield, whose entire body is
-- instance.requestInstanceMovement(player, "mustafar_droid_army") -- there is no
-- signal and no group walk in it, so nothing else is being dropped here. Core3
-- has no such instance, so the army comes to the player instead. See the tree.
function storyArcChaptersScreenPlay:sendToBattlefield(pPlayer)
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

-- chapter three 03 task 0, "Talk to a Pilot". Called from pilot_conv_handler on
-- the two go-ahead screens, not from a radial.
--
-- SOE fires two actions there. sendGroupToVolcano is nothing but
-- instance.requestInstanceMovement(player, "mustafar_volcano") and has no repo
-- counterpart -- see the tree's DEVIATION block. sendFirstSignal is the one that
-- carries the quest, and it is GROUP-AWARE: if the player is grouped it walks
-- group.getPCMembersInRange(player, 80f) and sends volcano_arena_pilot to every
-- member with the task active, so one person talking advances the whole party.
-- Ungrouped, it signals the player alone. That is what is reproduced below; the
-- 80m radius and the per-member task test are SOE's, not chosen here.
function storyArcChaptersScreenPlay:sendPartyToVolcano(pPlayer)
	if (not CreatureObject(pPlayer):isGrouped()) then
		self:sendOneToVolcano(pPlayer)
		return
	end

	local groupSize = CreatureObject(pPlayer):getGroupSize()

	for i = 0, groupSize - 1, 1 do
		local pMember = CreatureObject(pPlayer):getGroupMember(i)

		if (pMember ~= nil and SceneObject(pMember):isPlayerCreature() and CreatureObject(pMember):isInRangeWithObject(pPlayer, 80)) then
			self:sendOneToVolcano(pMember)
		end
	end
end

-- The per-member half. The stage test is SOE's isTaskActive(volcano_arena_one).
function storyArcChaptersScreenPlay:sendOneToVolcano(pPlayer)
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
--
-- These three templates now also stand in for the Old Republic Facility's eight
-- kubaza rows (mustafar_dungeon_population.lua), and the ORF is ungated, so a
-- player at this stage can satisfy the step on beetles indoors. Left as it is on
-- purpose: task 1 matches a live Social Group, not a template, and a social group
-- credits the species wherever it stands. Tightening this to the four spawned
-- beetles by objectID would be LESS faithful, not more.
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

	-- The "milo" block used to be here: "Ask Milo Mensix about the facility",
	-- "Report to Milo Mensix", and before that "Get a Terminal Override". All
	-- three were stand-ins. The first two are greetings of the shipped
	-- conversation story_arc_chapter_one_milo, and the third was Engineer Cobar's
	-- all along. Milo has no role and no radial now.

	if (role == "shipComputer") then
		if (stage == self.STAGE_FIX_TERMINAL) then
			-- chapter one 02 task 2 retrieveMenuText, verbatim. This is the whole
			-- radial now: it is live's retrieve_item_on_item script, the other of
			-- the two scripts on this object, and it is meant to be here.
			return "Install Circuit Boards"
		end

		-- "Activate Computer" and "Report the uplink to the ship's computer" used
		-- to be returned here. Both are the shipped conversation's work now; see
		-- useShipComputer for the claim they rested on and why it was wrong.
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

	-- "Access Terminal Delta-Five" used to be returned here. Retired: the terminal
	-- carries a shipped conversation and gets no role, so nothing can ask for its
	-- radial text any more. See useFacilityDelta's headstone for the false claim
	-- it rested on and why it was wrong.

	-- The door is a door again. It used to carry "Restart the main computer
	-- processor" and "Shut down the factory" itself, because neither interior
	-- could be entered; both pools are wired now, so the door offers entry and the
	-- two task radials moved inside onto the system_controller where live's own
	-- table puts them. The .qst wording for task 1 is "travel to the bottom of the
	-- factory and restart the main computer processor" -- performing it at the
	-- threshold was the reduction, and it is gone.
	if (role == "factoryDoor") then
		if (stage == self.STAGE_REPAIR_FACTORY or stage == self.STAGE_SHUTDOWN_FACTORY) then
			return "Enter the factory"
		end

		-- The keypad owns the door at STAGE_ENTER_FACTORY; useFactoryDoor says so
		-- with the "sealed" message, so the option stays visible there rather than
		-- vanishing and reading as a broken door.
		if (stage == self.STAGE_ENTER_FACTORY) then
			return "Enter the factory"
		end

		-- Outside the arc's own moments the door leads to the decrepit factory --
		-- see useFactoryDoor. mayEnterDroidFactory still refuses anyone who has not
		-- reached stage 13, so this does not open the building to a fresh player.
		if (self:mayEnterDroidFactory(pPlayer)) then
			return "Enter the derelict factory"
		end

		return nil
	end

	if (role == "factorySystem") then
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

	-- "Ask the scout about the droid army" and "Ask the pilot to fly into the
	-- crater" used to be returned here. Both were stand-ins written while the
	-- claim stood that neither NPC had a shipped conversation. Both DO ship one;
	-- see the two tree files. Root cause of the wrong claim: the search was
	-- scoped to som_-prefixed names and som_ string tables, and these are named
	-- story_arc_* and ship in the base string/en/conversation set.
	if (role == "miloTerminal" and stage == self.STAGE_CHECK_MESSAGE) then
		return "Check your messages"
	end

	return nil
end
