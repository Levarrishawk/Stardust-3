--[[ The Mustafar Kenobi spine -- six .qst files on one conversation

Obi-Wan Kenobi meets the player on the northeastern shoreline, sends them after a
dying miner, then after a crazed hermit carrying a Soul Crystal shard, then to
charge three Jedi conduits with it, and finally into the hidden chamber under the
Burning Plains to destroy the crystal and the Sith who came for it.

THE .qst FILES, AS THEY SHIPPED

  som_obi_wan_signal_1        "Obi-Wan's Redemption"
    task 0  Wait for Signal  dyingMiner   taskName "The Dying Miner"
    task 1  Reward  Bank Credits 2500

  som_obi_wan_signal_2        "Return To Obi-Wan"
    task 0  Wait for Signal  returnToObiWan
    task 1  Reward  Bank Credits 2500

  som_kenobi_main_quest_1     "Fate of the Galaxy"   Level 75, Tier 4, solo
    task 0  Wait for Signal  talkedToTechnician      taskName accessMainframe
            musicOnActivate sound/mus_mustafar_quest_exception.snd
      task 1  Retrieve Item  "Input search command"  som_kenobi_mining_computer.iff
        task 2  Timer 10-15
          task 3  Retrieve Item  "Check results"     the same object
            task 4  Go to Location  mustafar (-4050, 75, 2400) r 25
                    createWaypoint "Last known location of hermit"
              task 6   Encounter  som_kenobi_crazed_hermit  Count 1, 10-20
              task 9   Message Box  "No one around"
              task 7   Timer 20-35
                task 23  Message Box  "Attacked!"
                  task 8   Encounter  som_kenobi_blistmok  Count 2, 30-40
                    task 10  Wait for Signal  talkedHermit1   taskName talkHermit1
                      task 14  Encounter  som_kenobi_blistmok  Count 4, 5-50  ('attacked')
                        task 15  Wait for Signal  talkedHermit2  taskName talkHermit2
                          task 17  Immediately Complete Quest
                                   grantQuestOnComplete som_kenobi_main_quest_spared
                      task 21  Destroy Multiple and Loot  som_kenobi_crazed_hermit
                               "You remove the Soul Crystal from the corpse of the Crazed Hermit."
                        task 22  grantQuestOnComplete som_kenobi_main_quest_killed

  som_kenobi_main_quest_spared / _killed   "Fate of the Galaxy, II"  Level 80, Tier 5
    task 0  Wait for Signal  talkedKenobi1   taskName talkKenobi1
      three SIBLING branches, all required:
        task 16  Retrieve "Wedge crystal"  _w.iff   "West enclave"
          task 21  Timer 70-100    task 24  Retrieve "Take crystal"  taskName conduit3
          task 31  Timer 35-65     task 32  Encounter minion_mix Count 1, 25-50
        task 17  Retrieve "Wedge crystal"  _e.iff   "East enclave"
          task 20  Timer 80-120    task 23  Retrieve "Take crystal"  taskName conduit2
          task 29  Timer 25-40     task 30  Encounter minion_mix Count 2, 25-50
        task 18  Retrieve "Wedge crystal"  _nw.iff  "North West enclave"
          task 19  Timer 180-240   task 22  Retrieve "Take crystal"  taskName conduit1
          task 27  Timer 25-40     task 28  Encounter minion_mix Count 3, 25-50
    _killed differs in exactly two columns: task 32's Creature Type is
    som_kenobi_dark_jedi_minion_5, and task 28's Min Distance is 30.

  som_kenobi_main_quest_3 / _3_b           journalVisible FALSE, Level 1
    task 14  Wait for Tasks  conduit1/2/3 in quest/som_kenobi_main_quest_spared
             grantQuestOnComplete som_kenobi_main_quest_3_visible
      task 0  Wait for Signal  talkedKenobi2   taskName talkKenobi2
        task 4  Timer 340-460   task 8, task 10  minion_4 Count 1 each
        task 3  Timer 200-320   task 7 minion_2, task 9 minion_3, Count 1 each
        task 2  Timer 120-180   task 5  minion_1 Count 1
        task 1  Go to Location  mustafar (-2694, 42, 6077) r 10
          task 6   Wait for Signal  talkedKenobi3   taskName talkKenobi3
            task 15  Destroy Multiple  som_kenobi_dark_jedi_boss  Count 1  killSinistro
              task 13  Immediately Complete Quest
    All six minion encounters are Min Distance 20, Max Distance 30.
    _3_b watches _killed instead, grants _3_b_visible, and adds taskNames
    timer1/2/3 plus a "Destroying the crystal" journal line on task 15.

  som_kenobi_main_quest_3_visible / _3_b_visible   "Fate of the Galaxy, III"
    The player-facing shadow of the above: talkedKenobi2, the Go to Location,
    talkedKenobi3, then Destroy Multiple with musicOnComplete
    sound/mus_mustafar_quest_success.snd. _3_b_visible differs only in a
    "north east"/"northeast" typo and in showSystemMessages.

  The _3 / _3_visible pair is one sequence to the player: an invisible driver and
  a visible journal shadow of the same four steps. There is no journal in this
  build (see PROGRESS TRACKING), so the pair collapses to one run of stages here
  and the _visible file's strings are the ones sent as system messages, because
  they are the ones SOE wrote for the player to read.

THE CONVERSATION

All six quests hang off one NPC. His tree is
mobile/conversations/mustafar/som_kenobi_obi_wan.lua and the routing is in
screenplays/mustafar/quest/conversation/obi_wan_conv_handler.lua; both carry
their own notes. The technician and the hermit have their own trees and handlers
in the same two directories.

WHERE EVERYTHING IS, MEASURED

  Obi-Wan, the shoreline.  s_266 and s_302 say "the northeastern shoreline
  between the old and new mining facilities". Three mining facilities stand in
  the snapshot: the new one (node 12112217, floor 199.40), the destroyed one
  (12112376, inland and south), and the fork (12112377, floor 3.66 -- the only
  one at lava level, so the shore one). Walking the segment between the new
  facility (-2420.50, 1767.08) and the fork (-2292.74, 2671.33) and asking the
  snapshot what is near each step, the midpoint is the emptiest ground on it:

    t=0.5  (-2356.62, 2219.20)   nearest node 94.84 m  shared_must_lava_falls_01
    t=0.6  (-2343.84, 2309.63)   nearest node 45.27 m  shared_must_lava_falls_01
    t=0.7  (-2331.07, 2400.05)   nearest node 108.55 m shared_must_lava_falls_01

  He stands at t=0.5. Height is resolved with getWorldFloor at spawn, never
  hardcoded.

  Obi-Wan, the entrance stone.  s_269 promises "I can't come with you, but will
  meet you there", so a second copy stands beside snapshot node 12112106,
  obiwan_finale_entrance_stone, at (-2693.52, h 42.57, 6075.59). His spot
  (-2690.0, 6073.5) is 4.09 m from the stone and 5.91 m from the temple dome and
  platform behind it. One creature template, two spawns, tagged apart -- see
  KENOBI ROLES.

  The mining computer.  som_kenobi_mining_computer has zero snapshot nodes, so
  it is spawned, and the facility's dungeon spawn table says where. Both it and
  the technician who stands by it are in small_room_03 -- cell 12112234, on the
  lower floor:

    the technician   (-117.4, 10.8, 39.6)  heading 91
    the computer     (-132.2, 10.8, 44.6)  heading 90

  An earlier revision put both in small_room_04 and called that cell 12112237.
  Both halves were wrong, and the second is the one to learn from. It read the
  cell run as 12112218..12112249 contiguous and did POB index 20 -> 12112218 + 19
  = 12112237. The run is NOT contiguous: it has gaps at 12112233 and 12112239,
  so index 20 is 12112238, and 12112237 is hall_05. mensix_mining_facility_main.lua
  carries the resolved map and is the only thing to read cell ids off. +N
  arithmetic on this building is wrong every time.

  The room was wrong too. The reasoning picked small_room_04 because
  must_mining_facility.ilf puts six shared_must_mining_console_02 slots there,
  all on floor h 19.070, and took the first of them:

    (-33.220, -18.510)  (-33.214, -22.234)  (-25.420, -5.952)
    (-25.403, -24.902)  (-22.071, -5.942)   (-22.054, -24.892)

  Core3 never instantiates .ilf furniture, so those really are empty floor at
  runtime -- the observation is true. It is just not evidence: a console slot in
  the layout is where a console COULD stand, and SOE put this one two floors of
  the map away. small_room_04 is not "otherwise unused" either; it is the room
  Epo Qetora, the Q4P3 droid and Ithes Olok stand in.

  moral_choice's network computer does not collide with this one, but the old
  note gave the wrong reason: that computer is in hub_room (12112236), not
  small_room_05.

  The three conduits.  All three ship in the snapshot, and their positions match
  s_156's three directions exactly:

    _nw  node 12112107  (-5302.96, h 265.20, 6010.56)  "northwest corner"       conduit1
    _w   node 12112110  (-4467.51, h 114.88, 3206.98)  "west of the volcano"    conduit3
    _e   node 12110936  (  206.66, h 263.91, 4126.13)  "east edge, straight
                                                        east of the volcano"    conduit2

  The radials are attached to those world objects; nothing is spawned.

  The lair.  lair_of_the_crystal is a 12-copy instance pool already listed in
  mustafar_instances.lua, entered from the same node 12112106 the .qst's own Go
  to Location points at. This file is what unlocks that door; the pool entry is
  gated on the spine reaching STAGE_LAIR, which is why it was left NOT WIRED
  until now. The boss stands in every copy, placed through
  MustafarInstances:getPoolBuildings so the pool list is never duplicated.
  som_obiwan_crystal_lair.ilf is 141 nodes of decor in one room, mainroom, with
  a statue gallery in two rows at z 2.5 and z 7.68 spanning x 21..40 on a floor
  at y 0; the player arrives at (24.0, 5.1) and the boss waits at (37.0, 5.1),
  down the aisle between the statues.

THE CREATURES  --  four substituted, one exact

  som_kenobi_crazed_hermit           -> som_crazed_mustafarian_hermit
  som_kenobi_computer_technician     -> som_mustafarian_computer_technician
  som_kenobi_dark_jedi_minion_1..5   -> som_dark_jedi_minion_1..5
  som_kenobi_dark_jedi_boss          -> som_dark_jedi_boss
  som_kenobi_blistmok                   exists under that exact name

  som_kenobi_dark_jedi_minion_mix does not exist under any name. It is the
  Creature Type on all three conduit ambushes, and "mix" is what it says it is,
  so it is resolved to a random draw from som_dark_jedi_minion_1..8 -- the full
  set that ships. That is a substitution, not shipped data.

  The dying miner has no template, no conversation table and no string anywhere;
  see som_kenobi_dying_miner.lua. Obi-Wan is a new additive template,
  som_kenobi_obi_wan, so that obi_wan_ghost's obi_wan_elysium conversation is
  left untouched; see som_kenobi_obi_wan.lua.

PROGRESS TRACKING

None of these quests has a row in datatables/player/quests.iff, so there is no
journal in spite of journalVisible. All progress lives in persistent screenplay
data on the player's ghost; the journalEntryDescription lines go out as system
messages and as waypoint descriptions instead. The .qst carries createWaypoint on
exactly two tasks -- main_quest_1 task 4 and main_quest_3 task 1 -- and the three
conduits and the two return legs get substitute waypoints, because "go to the
northwest corner of the continent" with no journal and no marker is unfinishable
by anyone who did not read the coordinates out of the file.

WHAT IS NOT MODELLED, AND WHY

  The two Message Box tasks (main_quest_1 task 23 "Attacked!" and task 9 "No one
  around") are sent as system messages rather than as SUI boxes, matching the
  rest of this wave.

  main_quest_1 task 8's two blistmoks are a timed ambush on arrival rather than a
  gate on the first conversation. The .qst chains task 10 under task 8, but task
  6 spawns the hermit as a sibling of that timer, so he is standing there before
  the blistmoks arrive; gating his first line behind a kill count the player has
  no way to learn about would strand anyone who walks up and talks to him. The
  spawn and the signal are both honoured; only the ordering between them is
  relaxed, and this is the one place in this file where that is done.

  som_kenobi_final_crystal_pedestal and som_kenobi_final_force_crystal are
  registered tangibles that no .qst in this tree references. They are left
  unplaced rather than guessed at -- an open question about what SOE meant the
  finale room to contain, not a gap this file should fill.

  The absence is CHECKED, and the check is not the one this note used to cite.
  It used to rest on "the lair's own .ilf does not place them", which proves
  nothing: a .ilf lists what a building was furnished with, and the server
  spawns quest objects from dungeon spawn tables instead. Those tables are the
  place to look, and they have now been searched -- every dungeon table, not
  just Mustafar's five. Neither template appears in any of them, and there is no
  dungeon table for this building at all: spawning/dungeon/ holds 23 tables,
  five of them som_*, and none is a crystal lair. So there is genuinely nothing
  to quote, which is what this note claimed on weaker grounds than it had.

  The same search DID overturn the sibling claim in reunite_shard.lua, where
  som_kenobi_fusion_machine turned out to have a live row all along. That is why
  this one was re-checked rather than left standing.

  WHERE THEY WOULD GO, IF THEY GO ANYWHERE. This is geometry, not a source, and
  it is written down so the decision is one line of work rather than another
  survey. The 141-node .ilf has TWO statue galleries, not one:

    gallery 1   x 21..40    h -0.2..0.8  16 relic statues standing on the floor,
                                         mostly in two rows -- 7 at z 2.50 and
                                         6 at z ~7.65. The aisle between them is
                                         where the player arrives (24.0, 5.1)
                                         and where the boss waits (37.0, 5.1).

    gallery 2   x 74..86    h ~ 4.13      8 relic statues in a ring, each one
                                         raised on its own pillar_pristine_tall
                                         at h -4.10 -- 8 statues, 8 pillars,
                                         paired within a metre of each other.

  Gallery 2's ring centre is (79.83, 5.29), mean statue h 4.13. The
  jeditemple_dome sits at (79.81, 5.30) and the jeditemple_platform_lrg at
  (79.96, 5.19). Three separate objects agree on that centre to within 0.15 m,
  and there is nothing standing in it. A domed rotunda ringed by eight raised
  relic statues, empty at the middle, is the only spot in the building shaped
  like a place for a pedestal, and the two homeless tangibles are named
  "final_crystal_pedestal" and "final_force_crystal".

  WHAT IS STILL UNKNOWN, and why that is enough to keep it unplaced: the
  walkable height. The .ilf gives platform_lrg's ORIGIN at h -0.79, not its mesh
  top, and som_obiwan_crystal_lair exists in the extract ONLY as that .ilf --
  no .pob, no .msh -- so the surface a pedestal would stand on cannot be
  derived, only guessed. Placing it means inventing a height, and a pedestal
  sunk into or floating over its own dais is worse than an empty shrine. The
  x/z are as good as sourced; the h is not. That is the whole decision, and it
  is Aaron's.

  allowRepeats: stage stops at done, as everywhere else in this wave.

  The Retrieve tasks' ItemNames are progress markers, not minted inventory
  items; nothing downstream reads them. The Reward tasks' CountItem, Faction
  Name and quality columns are that task type's unused fields. Only the two
  signal quests carry a Reward task, at 2500 bank credits each, and only those
  two pay out here -- no credits are invented for the four that pay nothing.
--]]

kenobiSpineScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "kenobiSpineScreenPlay",

	-- som_kenobi_main_quest_1's Level 75 is NOT a gate and is not kept here. There
	-- is no level test anywhere in this arc; the gate is the nine finished side
	-- quests in hasCompletedPrerequisites below. See THE GATE in
	-- obi_wan_conv_handler for what was wrong and why.

	--[[ Obi-Wan's two stands. See WHERE EVERYTHING IS. ]]

	shore = {
		template = "som_kenobi_obi_wan",
		x = -2356.62,
		y = 2219.20,
		heading = 180,  -- back down the line toward the new facility, the way in
	},

	stone = {
		template = "som_kenobi_obi_wan",
		x = -2690.0,
		y = 6073.5,
		heading = -59,  -- atan2(-3.52, 2.09): facing the entrance stone
	},

	--[[ The new mining facility: the technician and the search computer. ]]

	facility = {
		buildingID = 12112217,
		x = -2420.5,
		y = 1767.08,
	},

	-- Both are the live facility spawn table's, cell-local. small_room_03 is
	-- cell 12112234, on the lower floor at h 10.8 -- NOT small_room_04, and not
	-- 12112237, which is hall_05. See THE MINING COMPUTER for what went wrong.
	technician = {
		template = "som_mustafarian_computer_technician",
		cellName = "small_room_03",
		cellID = 12112234,
		x = -117.4,
		z = 10.8,
		y = 39.6,
		heading = 91,
	},

	computer = {
		template = "object/tangible/quest/som_kenobi_mining_computer.iff",
		cellName = "small_room_03",
		cellID = 12112234,
		x = -132.2,
		z = 10.8,
		y = 44.6,
		heading = 90,
	},

	--[[ The dying miner. som_obi_wan_signal_1 says only "at the new mining
	     facility", so he lies on the landing deck, cell index 29 of the same POB
	     -- node 12112248 -- which is the one room in the building a body could be
	     carried into off the field.

	     This used to read x -47.0, z 19.07, y 6.0, and the comment here used to
	     claim no shipped line pinned the spot down. That was wrong on both counts.
	     mensix/mensix_mining_facility_main.lua:87-89 records the original NGE
	     positions of the two travelers, in this exact cell 12112248, and the live
	     facility spawn table carries the same two rows:

	         traveler_m   -55.1, 31.5, -120.3
	         traveler_f   -56.5, 31.5, -119.1

	     Two independent sources agree the floor plane of landing_deck_room is
	     z = 31.5. The old z of 19.07 was the upper-floor height this file was
	     using everywhere else at the time -- a copy-paste off the technician
	     block, which has since turned out to be wrong itself and now reads 10.8.
	     It put the miner about twelve metres beneath the deck and outside every
	     room in the POB. Since STAGE_REPORT is set at exactly one site (inside
	     examineMiner) and the report gates on isInRangeWithObject(..., 8), no
	     player could reach him and som_obi_wan_signal_1 was uncompletable.

	     The coordinates below are traveler_m's recorded position, reused because
	     it is a proven in-cell point on that floor. traveler_m itself does not
	     stand there on this server: mensix_mining_facility_main.lua:87 moves both
	     travelers outdoors, Levarris's own change, because spatialChat does not
	     carry inside a cell. So the spot is unoccupied here even though live had
	     someone in it. ]]

	miner = {
		template = "som_kenobi_dying_miner",
		cellName = "landing_deck_room",
		cellID = 12112248,
		x = -55.1,
		z = 31.5,
		y = -120.3,
		heading = 0,
	},

	--[[ main_quest_1 task 4: Go to Location (-4050, 75, 2400) r 25, with
	     createWaypoint and waypointName both quoted. ]]

	hermitSite = {
		x = -4050,
		y = 2400,
		radius = 25,
		waypointName = "Last known location of hermit",
	},

	hermit = {
		template = "som_crazed_mustafarian_hermit",
		minDistance = 10,
		maxDistance = 20,
	},

	-- Task 2's Timer, between the two computer radials.
	searchDelayMin = 10,
	searchDelayMax = 15,

	-- Task 7's Timer and task 8's Encounter, then task 14's.
	firstWave = {
		template = "som_kenobi_blistmok",
		count = 2,
		minDistance = 30,
		maxDistance = 40,
		delayMin = 20,
		delayMax = 35,
	},

	secondWave = {
		template = "som_kenobi_blistmok",
		count = 4,
		minDistance = 5,
		maxDistance = 50,
	},

	--[[ The three conduits. Each is a snapshot node with two radials in
	     sequence, its own charge Timer, and its own ambush. taskName, enclave
	     name and every number are the .qst's. ]]

	conduits = {
		{
			key = "conduit1",
			label = "North West enclave",
			nodeID = 12112107,
			x = -5302.96,
			y = 6010.56,
			chargeMin = 180,
			chargeMax = 240,
			ambushDelayMin = 25,
			ambushDelayMax = 40,
			ambushCount = 3,
			-- _killed's task 28 raises this to 30; _spared's is 25.
			ambushMinDistance = 25,
			ambushMinDistanceKilled = 30,
			ambushMaxDistance = 50,
		},
		{
			key = "conduit2",
			label = "East enclave",
			nodeID = 12110936,
			x = 206.66,
			y = 4126.13,
			chargeMin = 80,
			chargeMax = 120,
			ambushDelayMin = 25,
			ambushDelayMax = 40,
			ambushCount = 2,
			ambushMinDistance = 25,
			ambushMinDistanceKilled = 25,
			ambushMaxDistance = 50,
		},
		{
			key = "conduit3",
			label = "West enclave",
			nodeID = 12112110,
			x = -4467.51,
			y = 3206.98,
			chargeMin = 70,
			chargeMax = 100,
			ambushDelayMin = 35,
			ambushDelayMax = 65,
			ambushCount = 1,
			ambushMinDistance = 25,
			ambushMinDistanceKilled = 25,
			ambushMaxDistance = 50,
		},
	},

	-- som_kenobi_dark_jedi_minion_mix. See THE CREATURES.
	minionMix = { "som_dark_jedi_minion_1", "som_dark_jedi_minion_2", "som_dark_jedi_minion_3",
		"som_dark_jedi_minion_4", "som_dark_jedi_minion_5", "som_dark_jedi_minion_6",
		"som_dark_jedi_minion_7", "som_dark_jedi_minion_8" },

	-- _spared's task 32 is minion_mix; _killed's is minion_5, which is the only
	-- other difference between the two files.
	conduit3AmbushKilled = "som_dark_jedi_minion_5",

	--[[ main_quest_3's three timed hunts, after talkedKenobi2. Every one is Min
	     Distance 20, Max Distance 30. The .qst files them as three timers with
	     one or two Encounters each; they are kept in that shape. ]]

	hunts = {
		{ delayMin = 120, delayMax = 180, templates = { "som_dark_jedi_minion_1" } },
		{ delayMin = 200, delayMax = 320, templates = { "som_dark_jedi_minion_2", "som_dark_jedi_minion_3" } },
		{ delayMin = 340, delayMax = 460, templates = { "som_dark_jedi_minion_4", "som_dark_jedi_minion_4" } },
	},

	huntMinDistance = 20,
	huntMaxDistance = 30,

	-- main_quest_3 task 1: Go to Location (-2694, 42, 6077) r 10.
	chamberSite = {
		x = -2694,
		y = 6077,
		radius = 10,
		waypointName = "Entrance to the hidden chamber",
	},

	--[[ The lair. Cell-local, from som_obiwan_crystal_lair.ilf; the pool and the
	     entry point are mustafar_instances.lua's. ]]

	lair = {
		poolKey = "lair_of_the_crystal",
		cellName = "mainroom",
		boss = "som_dark_jedi_boss",
		x = 37.0,
		z = 0.0,
		y = 5.1,
		heading = 90,  -- facing back up the aisle, at the arriving player
		-- One boss is placed per copy at start() and start() runs once per server
		-- lifetime, so without a timer the first kill empties that copy for good and
		-- findFreeCopy hands the cleared copy straight to the next player -- who then
		-- has nothing to kill and no other way to reach STAGE_DONE. Matches the arc's
		-- own dark jedi timer, historian.lua:220.
		respawn = 600,
	},

	-- som_obi_wan_signal_1 task 1 and som_obi_wan_signal_2 task 1.
	prologueReward = 2500,

	--[[ Stages. One integer per player; see STATE. ]]

	STAGE_START = 0,
	STAGE_MINER = 1,
	STAGE_REPORT = 2,
	STAGE_WEST = 3,
	STAGE_HUNT = 4,
	STAGE_SHARD_SPARED = 5,
	STAGE_SHARD_KILLED = 6,
	STAGE_CONDUITS = 7,
	STAGE_CHAMBER = 8,
	STAGE_ENTRANCE = 9,
	STAGE_LAIR = 10,
	STAGE_DONE = 11,

	-- Where the hermit is up to, inside STAGE_HUNT.
	HERMIT_NONE = 0,
	HERMIT_MET = 1,
	HERMIT_WAVE_DONE = 2,
	HERMIT_GAVE = 3,

	-- How many times an off-planet player's pending ambush is re-armed before it
	-- is dropped. Not from the .qst; see armEvent.
	maxTries = 12,

	--[[ What start() actually placed. Only the conduits and the buildings are
	     snapshot data, so recording the rest is the only way a boot check can
	     tell a silent failure from a success. ]]

	shoreID = 0,
	stoneID = 0,
	technicianID = 0,
	technicianCellID = 0,
	technicianCellBy = "none",
	computerID = 0,
	computerCellID = 0,
	computerCellBy = "none",
	minerID = 0,
	minerCellID = 0,
	minerCellBy = "none",
	hermitAreaID = 0,
	chamberAreaID = 0,
	conduitsAttached = 0,
	bossCopies = 0,
}

registerScreenPlay("kenobiSpineScreenPlay", true)

--[[ Placement

One creature template, som_kenobi_obi_wan, is spawned twice: once on the lava
shore where the prologue and the whole middle of the arc are handed out, once at
the finale entrance stone where the last two conversations happen. Both copies
answer to the same conversation tree and the same handler, so the handler is told
which one it is talking through by a role string keyed on the object id --
exactly the way moral_choice tells its generator from its terminal.

The two Obi-Wans are separate spawns and not one walking NPC because nothing in
Core3 walks an NPC 3900m across a planet, and because the .qst treats the two
places as two independent Wait-for-Signal targets.
--]]

function kenobiSpineScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnKenobi("shore", self.shore)
		self:spawnKenobi("chamber", self.stone)
		self:spawnFacilityObjects()
		self:spawnAreas()
		self:attachConduits()
		self:spawnBosses()
	end
end

-- role is "shore" or "chamber"; see getKenobiRole. The heading is degrees here
-- because spawnMobile takes degrees, unlike spawnSceneObject.
function kenobiSpineScreenPlay:spawnKenobi(role, where)
	local z = getWorldFloor(where.x, where.y, "mustafar")
	local pNpc = spawnMobile("mustafar", where.template, 0, where.x, z, where.y, where.heading, 0)

	if (pNpc == nil) then
		printLuaError("kenobiSpineScreenPlay: failed to spawn " .. where.template .. " at the " .. role .. "; that half of the arc has no giver")
		return
	end

	local objectID = SceneObject(pNpc):getObjectID()

	writeStringData(objectID .. ":kenobiSpineRole", role)

	if (role == "chamber") then
		self.stoneID = objectID
	else
		self.shoreID = objectID
	end
end

-- Cell name first, recorded snapshot node id second. Returns the cell id and how
-- it was found, so the boot probe can say which answered. Same shape as
-- moral_choice:resolveCell -- both quests furnish the same building.
function kenobiSpineScreenPlay:resolveCell(pBuilding, cellName, cellID)
	if (pBuilding ~= nil) then
		local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

		if (pCell ~= nil) then
			return SceneObject(pCell):getObjectID(), "name"
		end
	end

	if (cellID ~= 0 and getSceneObject(cellID) ~= nil) then
		return cellID, "snapshot"
	end

	return 0, "none"
end

function kenobiSpineScreenPlay:spawnFacilityObjects()
	local pBuilding = getSceneObject(self.facility.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		printLuaError("kenobiSpineScreenPlay: the new mining facility (" .. self.facility.buildingID .. ") is missing; the prologue and the search terminal are both unreachable")
		pBuilding = nil
	end

	self:spawnTechnician(pBuilding)
	self:spawnComputer(pBuilding)
	self:spawnMiner(pBuilding)
end

function kenobiSpineScreenPlay:spawnTechnician(pBuilding)
	local tech = self.technician

	self.technicianCellID, self.technicianCellBy = self:resolveCell(pBuilding, tech.cellName, tech.cellID)

	if (self.technicianCellID == 0) then
		printLuaError("kenobiSpineScreenPlay: no cell " .. tech.cellName .. " in the new mining facility; main_quest_1 cannot be started")
		return
	end

	local pNpc = spawnMobile("mustafar", tech.template, 0, tech.x, tech.z, tech.y, tech.heading, self.technicianCellID)

	if (pNpc == nil) then
		printLuaError("kenobiSpineScreenPlay: failed to spawn " .. tech.template .. "; main_quest_1 cannot be started")
	else
		self.technicianID = SceneObject(pNpc):getObjectID()
	end
end

-- The search terminal itself. som_kenobi_mining_computer is already a registered
-- tangible (object/custom_content/tangible/quest/serverobjects.lua); nothing new
-- is added for it.
function kenobiSpineScreenPlay:spawnComputer(pBuilding)
	local computer = self.computer

	self.computerCellID, self.computerCellBy = self:resolveCell(pBuilding, computer.cellName, computer.cellID)

	if (self.computerCellID == 0) then
		printLuaError("kenobiSpineScreenPlay: no cell " .. computer.cellName .. " in the new mining facility; the hermit search cannot be run")
		return
	end

	local pComputer = spawnSceneObject("mustafar", computer.template, computer.x, computer.z, computer.y, self.computerCellID, math.rad(computer.heading))

	if (pComputer == nil) then
		printLuaError("kenobiSpineScreenPlay: failed to spawn the mining computer; the hermit search cannot be run")
		return
	end

	self.computerID = SceneObject(pComputer):getObjectID()

	writeStringData(self.computerID .. ":kenobiSpineRole", "computer")
	SceneObject(pComputer):setObjectMenuComponent("KenobiSpineMenuComponent")
end

-- som_obi_wan_signal_1's only task. He is scenery with a radial, because SOE
-- shipped him no conversation and no template; see som_kenobi_dying_miner.lua.
function kenobiSpineScreenPlay:spawnMiner(pBuilding)
	local miner = self.miner

	self.minerCellID, self.minerCellBy = self:resolveCell(pBuilding, miner.cellName, miner.cellID)

	if (self.minerCellID == 0) then
		printLuaError("kenobiSpineScreenPlay: no cell " .. miner.cellName .. " in the new mining facility; the prologue cannot be finished")
		return
	end

	local pNpc = spawnMobile("mustafar", miner.template, 0, miner.x, miner.z, miner.y, miner.heading, self.minerCellID)

	if (pNpc == nil) then
		printLuaError("kenobiSpineScreenPlay: failed to spawn " .. miner.template .. "; the prologue cannot be finished")
		return
	end

	self.minerID = SceneObject(pNpc):getObjectID()

	writeStringData(self.minerID .. ":kenobiSpineRole", "miner")
	SceneObject(pNpc):setObjectMenuComponent("KenobiSpineMenuComponent")
end

-- The two Go to Location tasks that are not a conversation: main_quest_1's hermit
-- site and main_quest_3_b's chamber. Both areas are global and stage-guarded, the
-- way reunite_shard's leg areas are.
function kenobiSpineScreenPlay:spawnAreas()
	local hermit = self.hermitSite
	local pHermitArea = spawnActiveArea("mustafar", "object/active_area.iff", hermit.x, getWorldFloor(hermit.x, hermit.y, "mustafar"), hermit.y, hermit.radius, 0)

	if (pHermitArea == nil) then
		printLuaError("kenobiSpineScreenPlay: failed to spawn the hermit site area; the hermit will never appear")
	else
		self.hermitAreaID = SceneObject(pHermitArea):getObjectID()
		createObserver(ENTEREDAREA, "kenobiSpineScreenPlay", "notifyEnteredHermitSite", pHermitArea)
	end

	local chamber = self.chamberSite
	local pChamberArea = spawnActiveArea("mustafar", "object/active_area.iff", chamber.x, getWorldFloor(chamber.x, chamber.y, "mustafar"), chamber.y, chamber.radius, 0)

	if (pChamberArea == nil) then
		printLuaError("kenobiSpineScreenPlay: failed to spawn the chamber area; the finale cannot be reached")
	else
		self.chamberAreaID = SceneObject(pChamberArea):getObjectID()
		createObserver(ENTEREDAREA, "kenobiSpineScreenPlay", "notifyEnteredChamberSite", pChamberArea)
	end
end

-- The three conduits are snapshot objects that the client already draws, so
-- nothing is spawned for them -- only a radial is attached, the same way
-- moral_choice attaches to the power generator.
function kenobiSpineScreenPlay:attachConduits()
	for i = 1, #self.conduits do
		local conduit = self.conduits[i]
		local pConduit = getSceneObject(conduit.nodeID)

		if (pConduit == nil) then
			printLuaError("kenobiSpineScreenPlay: snapshot object " .. conduit.nodeID .. " (" .. conduit.label .. ") was not found; that conduit cannot be charged")
		else
			writeStringData(conduit.nodeID .. ":kenobiSpineRole", conduit.key)
			SceneObject(pConduit):setObjectMenuComponent("KenobiSpineMenuComponent")
			self.conduitsAttached = self.conduitsAttached + 1
		end
	end
end

-- Every copy of the instance gets its own boss, because the pool hands a free
-- copy to whoever asks; reunite_shard furnishes its fusion machine the same way.
function kenobiSpineScreenPlay:spawnBosses()
	local buildings = MustafarInstances:getPoolBuildings(self.lair.poolKey)

	if (#buildings == 0) then
		printLuaError("kenobiSpineScreenPlay: no " .. self.lair.poolKey .. " pool; the finale has no boss")
		return
	end

	for i = 1, #buildings do
		local pBuilding = getSceneObject(buildings[i])

		if (pBuilding == nil) then
			printLuaError("kenobiSpineScreenPlay: " .. self.lair.poolKey .. " copy " .. buildings[i] .. " is missing")
		else
			local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

			if (cellID == 0) then
				printLuaError("kenobiSpineScreenPlay: copy " .. buildings[i] .. " has no cell named " .. self.lair.cellName .. "; it has no boss")
			elseif (spawnMobile("mustafar", self.lair.boss, self.lair.respawn, self.lair.x, self.lair.z, self.lair.y, self.lair.heading, cellID) == nil) then
				printLuaError("kenobiSpineScreenPlay: failed to spawn " .. self.lair.boss .. " in copy " .. buildings[i])
			else
				self.bossCopies = self.bossCopies + 1
			end
		end
	end
end

--[[ State

Persistent screenplay data on the player's ghost, so the arc survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0" on every read.

	stage    the STAGE_* ladder above, 0 = nothing started
	hermit   the HERMIT_* sub-state, only meaningful inside STAGE_HUNT
	spared   1 if the hermit handed the shard over, absent if he was killed for it
	<key>    per-conduit: 0 not begun, 1 charging, 2 charged
	tries    how many times an off-planet ambush has been re-armed
	wp       waypoint id currently handed out, absent if none
--]]

function kenobiSpineScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kenobiSpineScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function kenobiSpineScreenPlay:getHermitStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "hermit")) or 0
end

function kenobiSpineScreenPlay:setHermitStage(pPlayer, value)
	writeScreenPlayData(pPlayer, self.screenplayName, "hermit", tostring(value))
end

-- Which of the two endings the player took. Set once, read for the rest of the
-- arc: it picks the A or B twin of every screen from the chamber on.
function kenobiSpineScreenPlay:sparedTheHermit(pPlayer)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "spared")) or 0) == 1
end

-- Which of the two Obi-Wan copies this is. Written at spawn by spawnKenobi; the
-- conversation handler cannot see the screenplay's spawn ids any other way,
-- because the two Lua states are separate.
function kenobiSpineScreenPlay:getKenobiRole(pNpc)
	if (pNpc == nil) then
		return "shore"
	end

	local role = readStringData(SceneObject(pNpc):getObjectID() .. ":kenobiSpineRole")

	if (role == "chamber") then
		return "chamber"
	end

	return "shore"
end

function kenobiSpineScreenPlay:isPresent(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	return pGhost ~= nil and PlayerObject(pGhost):isOnline() and SceneObject(pPlayer):getZoneName() == "mustafar"
end

-- One waypoint at a time. The arc never has two fixed-location objectives open at
-- once -- the three conduits are the only place it could, and main_quest_3 makes
-- them sequential; see PROGRESS TRACKING.
function kenobiSpineScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function kenobiSpineScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

function kenobiSpineScreenPlay:payCredits(pPlayer, amount)
	CreatureObject(pPlayer):addBankCredits(amount, true)
	CreatureObject(pPlayer):sendSystemMessage("You have received " .. amount .. " credits.")
end

-- Spawns one encounter's worth of hostiles around the player, the shape every
-- Encounter task in the six quests has. Callers pass the .qst's own counts and
-- distances; setDefender is only used where the creature is not already
-- AGGRESSIVE in its own template.
function kenobiSpineScreenPlay:spawnEncounter(pPlayer, template, count, minDistance, maxDistance, engage)
	if (not self:isPresent(pPlayer)) then
		return
	end

	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()

	for i = 1, count do
		local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, minDistance, maxDistance, true)

		if (spawnPoint == nil) then
			print("kenobiSpineScreenPlay: no spawn point near the player for " .. template)
		else
			local pMob = spawnMobile("mustafar", template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

			if (pMob == nil) then
				print("kenobiSpineScreenPlay: failed to spawn " .. template)
			elseif (engage) then
				AiAgent(pMob):setDefender(pPlayer)
			end
		end
	end
end

--[[ The prologue -- som_obi_wan_signal_1 and som_obi_wan_signal_2

Two one-task quests with a 2500 credit reward each. The first waits on the signal
'dyingMiner', the second on 'returnToObiWan'. Neither is gated on anything. The
prologue's own conversation gates only on those two quests' own state, and the
nine-quest gate belongs to main_quest_1 -- see THE GATE below.
--]]

-- Screen pro_task, s_26: "Go seek out a dying miner who is at the new mining
-- facility". This opens som_obi_wan_signal_1.
function kenobiSpineScreenPlay:giveMinerTask(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_START) then
		return
	end

	self:setStage(pPlayer, self.STAGE_MINER)

	CreatureObject(pPlayer):sendSystemMessage("Go seek out a dying miner who is at the new mining facility.")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- No createWaypoint on the task; see PROGRESS TRACKING for why one is given.
	self:giveWaypoint(pPlayer, "New mining facility", "Obi-Wan's Redemption", self.facility.x, self.facility.y)
end

-- The miner's radial. He is the whole of som_obi_wan_signal_1 task 0 and SOE gave
-- him nothing to say, so examining him is what fires 'dyingMiner'.
function kenobiSpineScreenPlay:examineMiner(pPlayer, pMiner)
	if (self:getStage(pPlayer) ~= self.STAGE_MINER) then
		return
	end

	self:setStage(pPlayer, self.STAGE_REPORT)

	-- task 1's Reward: Bank Credits 2500.
	self:payCredits(pPlayer, self.prologueReward)

	-- s_27, the only other line about him that ships.
	CreatureObject(pPlayer):sendSystemMessage("The miner had been attacked with a lightsaber.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	-- som_obi_wan_signal_2 opens here: go back and tell him.
	CreatureObject(pPlayer):sendSystemMessage("Return to Obi-Wan on the northeastern shoreline and tell him what you found.")

	self:giveWaypoint(pPlayer, "Obi-Wan Kenobi", "Return To Obi-Wan", self.shore.x, self.shore.y)
end

-- Screen pro_west, s_28. 'returnToObiWan' closes som_obi_wan_signal_2 and the
-- spine proper starts at the next conversation.
function kenobiSpineScreenPlay:finishPrologue(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_REPORT) then
		return
	end

	self:setStage(pPlayer, self.STAGE_WEST)
	self:removeWaypoint(pPlayer)

	-- task 1's Reward: Bank Credits 2500, the second of the two.
	self:payCredits(pPlayer, self.prologueReward)

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
end

--[[ som_kenobi_main_quest_1 -- "Fate of the Galaxy"

Talk the technician into the Mensix mainframe, run a search on the mining
computer, wait for it, read the result, go where it points, and meet the hermit.
The gate is the handler's; by the time anything here runs it has passed.

The sub-state is two counters on top of STAGE_HUNT:
  mainframe  1 once the technician has given way ('talkedToTechnician')
  search     0 not begun, 1 running (task 2's timer), 2 results waiting,
             3 read, the site is marked and the hermit leg is live
--]]

--[[ THE GATE -- live's condition_startFirstQuest

Nine side quests, all completed, ANDed together. This is the only thing standing
between a player and the main quest; there is no level test anywhere in the
conversation. Live's list, verbatim:

  som_kenobi_collectors_business_1   som_kenobi_reunite_shard_3
  som_kenobi_cursed_shard_2          som_kenobi_samaritan_1
  som_kenobi_hidden_treasure_2       som_kenobi_serpent_shard_1
  som_kenobi_historian_2             som_kenobi_symbiosis_1
  som_kenobi_moral_choice_1

Live also lets isGod(player) through ahead of the nine. There is no equivalent
here, and a staff bypass is not something to invent, so it is left out.

None of the nine is a groundquest in this tree -- each is a screenplay carrying
its own stage -- so the equivalent test is each one's terminal stage. The terminal
stage of seven of the nine is that screenplay's highest, so >= is safe there; the
other two end two ways, and taking the lower ending keeps >= correct for both
endings because the higher one also satisfies it. That was checked against every
setStage call in all nine files, not assumed. The two that end two ways take the
lower ending, which covers both:
moral_choice DONE_CORP 6 / DONE_MINERS 7, samaritan DONE_KEPT 5 / DONE_KILLED 6.

Three of the nine number their stages with bare integers and have no constant to
name, so the number is written out with the file it came from.

The globals are read inside the function rather than in the table above, because
screenplays.lua loads this file before some of the nine and a table built at load
time would capture nils. A missing global fails the gate closed. ]]
function kenobiSpineScreenPlay:hasCompletedPrerequisites(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local required = {
		{ collectorsBusinessScreenPlay, collectorsBusinessScreenPlay.STAGE_DONE },  -- collectors_business_1
		{ cursedShardScreenPlay,        cursedShardScreenPlay.STAGE_DONE },         -- cursed_shard_2
		{ hiddenTreasureScreenPlay,     6 },                                        -- hidden_treasure_2, awardQuest
		{ historianScreenPlay,          historianScreenPlay.STAGE_DONE },           -- historian_2
		{ moralChoiceScreenPlay,        moralChoiceScreenPlay.STAGE_DONE_CORP },    -- moral_choice_1
		{ reuniteShardScreenPlay,       7 },                                        -- reunite_shard_3, retrieveCrystal
		{ samaritanScreenPlay,          samaritanScreenPlay.STAGE_DONE_KEPT },      -- samaritan_1
		{ serpentShardScreenPlay,       serpentShardScreenPlay.STAGE_DONE },        -- serpent_shard_1
		{ symbiosisScreenPlay,          6 },                                        -- symbiosis_1, clearAmbush
	}

	for i = 1, #required do
		local screenPlay, doneStage = required[i][1], required[i][2]

		if (screenPlay == nil or doneStage == nil) then
			return false
		end

		if (screenPlay:getStage(pPlayer) < doneStage) then
			return false
		end
	end

	return true
end

-- Screens give_quest_a / give_quest_b. The hunt opens at the technician, which is
-- back inside the new mining facility.
function kenobiSpineScreenPlay:giveHermitHunt(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_WEST) then
		return
	end

	self:setStage(pPlayer, self.STAGE_HUNT)
	self:restartHermitSearch(pPlayer)

	-- Root task 0's musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")
end

-- Screen research, s_352: "you will have to perform another search for him". Also
-- how the hunt is opened the first time, since it is the same three steps.
function kenobiSpineScreenPlay:restartHermitSearch(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "search", "0")

	-- task 0's taskName, accessMainframe.
	CreatureObject(pPlayer):sendSystemMessage("Talk your way onto the Mensix mining network at the new mining facility, then search it for the hermit.")

	self:giveWaypoint(pPlayer, "New mining facility", "Fate of the Galaxy", self.facility.x, self.facility.y)
end

-- The technician's whole contract with this file: he only has business with a
-- player who is on this leg and has not already been let through.
function kenobiSpineScreenPlay:needsMainframe(pPlayer)
	return self:getStage(pPlayer) == self.STAGE_HUNT
		and (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "mainframe")) or 0) == 0
end

-- Signal 'talkedToTechnician', task 0. Every route through his tree that ends
-- with him giving way lands here.
function kenobiSpineScreenPlay:grantMainframe(pPlayer)
	if (not self:needsMainframe(pPlayer)) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "mainframe", "1")

	-- task 1's ItemName, "Input search command".
	CreatureObject(pPlayer):sendSystemMessage("You have access to the mining network. Use the computer in this room to run a search for the hermit.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
end

-- Task 1's radial, then task 2's Timer, Min 10 / Max 15.
function kenobiSpineScreenPlay:startSearch(pPlayer, pComputer)
	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "search")) or 0) ~= 0) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "search", "1")

	CreatureObject(pPlayer):sendSystemMessage("The search is running. It will take a few moments.")

	createEvent(getRandomNumber(self.searchDelayMin, self.searchDelayMax) * 1000, "kenobiSpineScreenPlay", "searchFinished", pPlayer, "")
end

function kenobiSpineScreenPlay:searchFinished(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "search")) or 0) ~= 1) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "search", "2")

	-- task 3's ItemName, "Check results". The message is sent whether or not the
	-- player is standing at the computer; the radial is what actually gates it.
	CreatureObject(pPlayer):sendSystemMessage("The search has finished. Check the results on the mining computer.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
end

-- Task 3's radial, then task 4: Go to Location (-4050, 75, 2400) r 25, with
-- createWaypoint and waypointName both from the .qst.
function kenobiSpineScreenPlay:readResults(pPlayer, pComputer)
	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "search")) or 0) ~= 2) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "search", "3")

	CreatureObject(pPlayer):sendSystemMessage("The network has a last known location for the hermit. Travel there and find him.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:giveWaypoint(pPlayer, self.hermitSite.waypointName, "Fate of the Galaxy", self.hermitSite.x, self.hermitSite.y)
end

--[[ Task 4 completing. Three things hang off it as siblings: task 6 spawns the
     hermit, task 9 says there is no one around, and task 7's timer leads to task
     23 and the first pair of blistmoks. See WHAT IS NOT MODELLED for the one
     ordering relaxation in this file, which is here. ]]

function kenobiSpineScreenPlay:notifyEnteredHermitSite(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return 0
	end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "search")) or 0) ~= 3) then
		return 0
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "search", "4")
	self:removeWaypoint(pPlayer)

	-- task 9's Message Box, "No one around".
	CreatureObject(pPlayer):sendSystemMessage("There is no one around here. The network's information must have been out of date, or he has moved on.")

	-- task 6: Encounter som_kenobi_crazed_hermit, Count 1, 10-20. He is
	-- CONVERSABLE and ATTACKABLE both, so nothing engages for him.
	-- The observer goes up WITH the spawn, not at the first conversation. He is
	-- conversable and attackable both, so a player may simply kill him on sight;
	-- when this was created in hermitFirstMeetingDone instead, that kill landed with
	-- nothing listening, notifyKilledCreature never ran, and STAGE_HUNT had no other
	-- exit. Persistence 1 so the credit survives a logout, same as the wave observer.
	-- Once only. restartHermitSearch resets search to 0, so a player who is sent
	-- back around the loop re-enters this site and reaches this line again; with
	-- persistence 1 that would leave two live observers and count every wave kill
	-- twice. The flag is cleared in closeHermitLeg, next to the dropObserver.
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "killObserver")) or 0) == 0) then
		writeScreenPlayData(pPlayer, self.screenplayName, "killObserver", "1")
		createObserver(KILLEDCREATURE, "kenobiSpineScreenPlay", "notifyKilledCreature", pPlayer, 1)
	end
	self:spawnEncounter(pPlayer, self.hermit.template, 1, self.hermit.minDistance, self.hermit.maxDistance, false)

	-- task 7's Timer, Min 20 / Max 35.
	createEvent(getRandomNumber(self.firstWave.delayMin, self.firstWave.delayMax) * 1000, "kenobiSpineScreenPlay", "firstBlistmokWave", pPlayer, "")

	return 0
end

-- Task 23's Message Box "Attacked!", then task 8: Encounter som_kenobi_blistmok,
-- Count 2, Min Distance 30 / Max Distance 40.
function kenobiSpineScreenPlay:firstBlistmokWave(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	if (not self:isPresent(pPlayer)) then
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("You are under attack!")

	self:spawnEncounter(pPlayer, self.firstWave.template, self.firstWave.count, self.firstWave.minDistance, self.firstWave.maxDistance, true)
end

-- Task 10's signal 'talkedHermit1' -- the first meeting ends -- then task 14:
-- Encounter som_kenobi_blistmok, Count 4, Min Distance 5 / Max Distance 50, whose
-- taskName is 'attacked'. He goes quiet, s_67, once they are dead.
function kenobiSpineScreenPlay:hermitFirstMeetingDone(pPlayer, pNpc)
	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	if (self:getHermitStage(pPlayer) ~= self.HERMIT_NONE) then
		return
	end

	self:setHermitStage(pPlayer, self.HERMIT_MET)
	writeScreenPlayData(pPlayer, self.screenplayName, "waveKills", "0")

	-- The KILLEDCREATURE observer is already up: it goes on at hermit spawn, because
	-- he can be killed before this conversation ever happens. Creating a second one
	-- here would double-count every wave kill.

	self:spawnEncounter(pPlayer, self.secondWave.template, self.secondWave.count, self.secondWave.minDistance, self.secondWave.maxDistance, true)

	CreatureObject(pPlayer):sendSystemMessage("More of them are coming for him.")
end

-- Counts the second wave down, and nothing else. The hermit himself is task 21's
-- Destroy Multiple and Loot, and that is handled here too because it is the
-- killed branch's whole trigger.
function kenobiSpineScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil) then
		return 0
	end

	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_HUNT) then
		if (victimTemplate == self.hermit.template) then
			self:hermitKilled(pPlayer)
			return 0
		end

		if (victimTemplate == self.secondWave.template and self:getHermitStage(pPlayer) == self.HERMIT_MET) then
			local killed = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "waveKills")) or 0) + 1

			writeScreenPlayData(pPlayer, self.screenplayName, "waveKills", tostring(killed))

			if (killed >= self.secondWave.count) then
				self:setHermitStage(pPlayer, self.HERMIT_WAVE_DONE)
				CreatureObject(pPlayer):sendSystemMessage("The blistmoks are dead. The hermit has gone quiet.")
			end
		end

		return 0
	end

	if (stage == self.STAGE_LAIR and victimTemplate == self.lair.boss) then
		self:bossKilled(pPlayer)
		return 0
	end

	-- Nothing left to watch for on this player.
	if (stage >= self.STAGE_DONE) then
		return 1
	end

	return 0
end

--[[ The two endings. Task 15's signal 'talkedHermit2' grants
     som_kenobi_main_quest_spared; task 21's Destroy Multiple and Loot grants
     som_kenobi_main_quest_killed. Neither is privileged here -- the player picks
     one by which screen they walk into. ]]

-- Screens handover_free (s_82) and handover_trade (s_97).
function kenobiSpineScreenPlay:hermitHandsOverShard(pPlayer, pNpc)
	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	self:setHermitStage(pPlayer, self.HERMIT_GAVE)
	self:setStage(pPlayer, self.STAGE_SHARD_SPARED)
	writeScreenPlayData(pPlayer, self.screenplayName, "spared", "1")

	self:closeHermitLeg(pPlayer)

	CreatureObject(pPlayer):sendSystemMessage("The hermit hands you the Soul Crystal. Take it back to Obi-Wan.")
end

-- Any of the six second-meeting screens live answers with removeInvuln + attack.
-- Not the three first-meeting screens that end with the same "kill him" line --
-- those fire talkedHermit1 instead; see the handler. He is ATTACKABLE from the
-- start, so this only aims him.
function kenobiSpineScreenPlay:hermitTurnsHostile(pPlayer, pNpc)
	if (pNpc == nil or self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	AiAgent(pNpc):setDefender(pPlayer)

	CreatureObject(pPlayer):sendSystemMessage("The hermit attacks you.")
end

-- Task 21's Destroy Multiple and Loot, whose own line is quoted below.
function kenobiSpineScreenPlay:hermitKilled(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return
	end

	self:setHermitStage(pPlayer, self.HERMIT_GAVE)
	self:setStage(pPlayer, self.STAGE_SHARD_KILLED)
	deleteScreenPlayData(pPlayer, self.screenplayName, "spared")

	self:closeHermitLeg(pPlayer)

	CreatureObject(pPlayer):sendSystemMessage("You remove the Soul Crystal from the corpse of the Crazed Hermit.")
end

function kenobiSpineScreenPlay:closeHermitLeg(pPlayer)
	dropObserver(KILLEDCREATURE, "kenobiSpineScreenPlay", "notifyKilledCreature", pPlayer)
	writeScreenPlayData(pPlayer, self.screenplayName, "killObserver", "0")

	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:giveWaypoint(pPlayer, "Obi-Wan Kenobi", "Fate of the Galaxy", self.shore.x, self.shore.y)
end

--[[ som_kenobi_main_quest_spared / _killed -- "Fate of the Galaxy, II"

Three sibling branches under one signal, all three required. Each is the same
five tasks: wedge the shard into a conduit, wait out that conduit's charge timer,
take it back, and separately wait out an ambush timer that drops minions on the
player while they stand there. The two files differ in exactly two columns and
both are carried, on the "spared" flag: conduit3's ambush creature and conduit1's
ambush minimum distance.

Per-conduit state, one key each:
  0  not begun     1  charging     2  charged, ready to take     3  done
--]]

function kenobiSpineScreenPlay:getConduit(key)
	for i = 1, #self.conduits do
		if (self.conduits[i].key == key) then
			return self.conduits[i]
		end
	end

	return nil
end

function kenobiSpineScreenPlay:rawConduitState(pPlayer, key)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0
end

--[[ The charge is driven by createEvent, which does not survive a server restart, while
     the conduit state does. Reading the state settles an overdue charge as well, so a
     restart inside those 70-240 s cannot leave a player parked at state 1, where
     getRadialText offers nothing on the conduit and takeCrystal refuses -- the only exit
     is conduitCharged. Both paths funnel into conduitCharged, which is guarded on the raw
     state, so whichever arrives first wins and the other does nothing.

     The persistent 6-arg createEvent is not usable here: DirectorManager.cpp builds the
     event name from key + screenplay + object id, which is identical for all three
     conduits of one player, and the second one logs "Duplicate persistent event". ]]
function kenobiSpineScreenPlay:getConduitState(pPlayer, key)
	local state = self:rawConduitState(pPlayer, key)

	if (state == 1) then
		local due = tonumber(readScreenPlayData(pPlayer, self.screenplayName, key .. "Until")) or 0

		if (due ~= 0 and getTimestamp() >= due) then
			self:conduitCharged(pPlayer, key)

			return self:rawConduitState(pPlayer, key)
		end
	end

	return state
end

function kenobiSpineScreenPlay:setConduitState(pPlayer, key, value)
	writeScreenPlayData(pPlayer, self.screenplayName, key, tostring(value))
end

-- Screens send_a..send_d, signal 'talkedKenobi1'. Both quests open the same way,
-- and which of the two the player is on is the "spared" flag, already set.
function kenobiSpineScreenPlay:talkedKenobi1(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage ~= self.STAGE_SHARD_SPARED and stage ~= self.STAGE_SHARD_KILLED) then
		return
	end

	self:setStage(pPlayer, self.STAGE_CONDUITS)

	for i = 1, #self.conduits do
		self:setConduitState(pPlayer, self.conduits[i].key, 0)
	end

	CreatureObject(pPlayer):sendSystemMessage("Three Jedi conduits stand at the enclaves. Wedge the Soul Crystal into each one in turn to charge it.")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	self:markNextConduit(pPlayer)
end

-- The three enclaves are a set, not a sequence, but only one waypoint is handed
-- out at a time; see PROGRESS TRACKING. The first unfinished one in .qst order is
-- the one marked.
function kenobiSpineScreenPlay:markNextConduit(pPlayer)
	for i = 1, #self.conduits do
		local conduit = self.conduits[i]

		if (self:getConduitState(pPlayer, conduit.key) < 3) then
			self:giveWaypoint(pPlayer, conduit.label, "Fate of the Galaxy, II", conduit.x, conduit.y)
			return
		end
	end

	self:removeWaypoint(pPlayer)
end

-- Tasks 16, 17 and 18: Retrieve "Wedge crystal". Starts that conduit's charge
-- timer and, as a sibling, its ambush timer.
function kenobiSpineScreenPlay:wedgeCrystal(pPlayer, key)
	local conduit = self:getConduit(key)

	if (conduit == nil or self:getStage(pPlayer) ~= self.STAGE_CONDUITS) then
		return
	end

	if (self:getConduitState(pPlayer, key) ~= 0) then
		return
	end

	self:setConduitState(pPlayer, key, 1)

	CreatureObject(pPlayer):sendSystemMessage("The crystal sits in the conduit at the " .. conduit.label .. " and begins to draw a charge. Stay with it.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	-- tasks 19, 20 and 21, the charge Timers. The deadline is stamped alongside the event so
	-- getConduitState can settle the charge if the event is lost with the process.
	local chargeDelay = getRandomNumber(conduit.chargeMin, conduit.chargeMax)

	writeScreenPlayData(pPlayer, self.screenplayName, key .. "Until", tostring(getTimestamp() + chargeDelay))
	createEvent(chargeDelay * 1000, "kenobiSpineScreenPlay", "conduitCharged", pPlayer, key)

	-- tasks 27, 29 and 31, the ambush Timers.
	createEvent(getRandomNumber(conduit.ambushDelayMin, conduit.ambushDelayMax) * 1000, "kenobiSpineScreenPlay", "conduitAmbush", pPlayer, key)
end

function kenobiSpineScreenPlay:conduitCharged(pPlayer, key)
	local conduit = self:getConduit(key)

	if (pPlayer == nil or conduit == nil or self:getStage(pPlayer) ~= self.STAGE_CONDUITS) then
		return
	end

	-- Raw, not getConduitState: the catch-up path in getConduitState calls this function.
	if (self:rawConduitState(pPlayer, key) ~= 1) then
		return
	end

	self:setConduitState(pPlayer, key, 2)
	deleteScreenPlayData(pPlayer, self.screenplayName, key .. "Until")

	-- tasks 22, 23 and 24: Retrieve "Take crystal", whose taskNames are the
	-- conduit1/2/3 that main_quest_3 waits on.
	CreatureObject(pPlayer):sendSystemMessage("The conduit at the " .. conduit.label .. " is charged. Take the crystal back.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
end

-- Tasks 28, 30 and 32: Encounter som_kenobi_dark_jedi_minion_mix. The two
-- differences between the spared and killed files are both here.
function kenobiSpineScreenPlay:conduitAmbush(pPlayer, key)
	local conduit = self:getConduit(key)

	if (pPlayer == nil or conduit == nil or self:getStage(pPlayer) ~= self.STAGE_CONDUITS) then
		return
	end

	if (not self:isPresent(pPlayer)) then
		return
	end

	local spared = self:sparedTheHermit(pPlayer)
	local minDistance = spared and conduit.ambushMinDistance or conduit.ambushMinDistanceKilled

	for i = 1, conduit.ambushCount do
		local template

		if (key == "conduit3" and not spared) then
			template = self.conduit3AmbushKilled
		else
			template = self.minionMix[getRandomNumber(1, #self.minionMix)]
		end

		self:spawnEncounter(pPlayer, template, 1, minDistance, conduit.ambushMaxDistance, true)
	end
end

-- The "Take crystal" radial. When the third one is taken the quest is over and
-- main_quest_3's Wait for Tasks on conduit1/2/3 is satisfied.
function kenobiSpineScreenPlay:takeCrystal(pPlayer, key)
	local conduit = self:getConduit(key)

	if (conduit == nil or self:getStage(pPlayer) ~= self.STAGE_CONDUITS) then
		return
	end

	if (self:getConduitState(pPlayer, key) ~= 2) then
		return
	end

	self:setConduitState(pPlayer, key, 3)

	local done = 0

	for i = 1, #self.conduits do
		if (self:getConduitState(pPlayer, self.conduits[i].key) == 3) then
			done = done + 1
		end
	end

	if (done < #self.conduits) then
		CreatureObject(pPlayer):sendSystemMessage("Conduits charged: " .. done .. " of " .. #self.conduits .. ".")
		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
		self:markNextConduit(pPlayer)
		return
	end

	self:setStage(pPlayer, self.STAGE_CHAMBER)

	CreatureObject(pPlayer):sendSystemMessage("All three conduits are charged. Return to Obi-Wan.")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")

	self:giveWaypoint(pPlayer, "Obi-Wan Kenobi", "Fate of the Galaxy, II", self.shore.x, self.shore.y)
end

--[[ som_kenobi_main_quest_3 / _3_b -- "Fate of the Galaxy, III"

The invisible driver and its visible shadow are one run of stages here; see the
header. Three timed hunts are armed by talkedKenobi2 and run while the player
crosses the continent, and the Go to Location at the entrance stone is what
brings them to the second Obi-Wan.
--]]

-- Screens goluck_a..goluck_d, signal 'talkedKenobi2'.
function kenobiSpineScreenPlay:talkedKenobi2(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_CHAMBER) then
		return
	end

	self:setStage(pPlayer, self.STAGE_ENTRANCE)

	-- task 1's createWaypoint, and the _visible file's line for it.
	CreatureObject(pPlayer):sendSystemMessage("Make your way to the hidden chamber beneath the Burning Plains. Obi-Wan will meet you at the entrance.")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	self:giveWaypoint(pPlayer, self.chamberSite.waypointName, "Fate of the Galaxy, III", self.chamberSite.x, self.chamberSite.y)

	-- tasks 2, 3 and 4. They fire whether or not the player is anywhere near the
	-- chamber, which is what the .qst has: they are siblings of the journey, not
	-- children of arriving.
	for i = 1, #self.hunts do
		local hunt = self.hunts[i]
		createEvent(getRandomNumber(hunt.delayMin, hunt.delayMax) * 1000, "kenobiSpineScreenPlay", "sendHunt", pPlayer, tostring(i))
	end
end

--[[ Screen resume_yes, s_341: "Make your way to the lair immediately."

WHY THIS EXISTS, AND WHY IT IS NOT talkedKenobi2 AGAIN. Live fires two actions on
s_341 -- regiveQuest3, which re-grants som_kenobi_main_quest_3_visible, and
talkNumber2, which re-sends 'talkedKenobi2'. Its gate, condition_abandonedQuest3,
is exact: the hidden quest 3 is still running but the VISIBLE one is not. That is
a player who dropped the journal entry, and the pair of actions puts it back.

This tree has no visible/hidden split -- one stage machine, and a stage cannot be
dropped -- so that state has no equivalent here and nothing is invented for it.
What survives the translation is the recoverable half: give the player back the
line and the waypoint they lost. So this re-issues, and does not re-run. It does
not touch the stage and it does not re-arm the three hunts, which talkedKenobi2
schedules once; re-running those would stack a second set of ambushes on a player
whose only mistake was walking back to ask the way.

s_341 was previously unwired, so this screen did nothing at all.
--]]
function kenobiSpineScreenPlay:resumeJourney(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage ~= self.STAGE_ENTRANCE and stage ~= self.STAGE_LAIR) then
		return
	end

	if (stage == self.STAGE_LAIR) then
		-- talkedKenobi3 already opened the way and dropped the waypoint. The
		-- entrance stone is still where he is sending them.
		CreatureObject(pPlayer):sendSystemMessage("The way into the chamber is open. Destroy the crystal, and whatever came for it.")
	else
		CreatureObject(pPlayer):sendSystemMessage("Make your way to the hidden chamber beneath the Burning Plains. Obi-Wan will meet you at the entrance.")
	end

	self:giveWaypoint(pPlayer, self.chamberSite.waypointName, "Fate of the Galaxy, III", self.chamberSite.x, self.chamberSite.y)
end

-- tasks 5, 7, 8, 9 and 10. Every one is Count 1, Min Distance 20, Max Distance
-- 30; the third timer carries two of them, which is why templates is a list.
function kenobiSpineScreenPlay:sendHunt(pPlayer, args)
	local hunt = self.hunts[tonumber(args) or 0]

	if (pPlayer == nil or hunt == nil) then
		return
	end

	local stage = self:getStage(pPlayer)

	if (stage ~= self.STAGE_ENTRANCE and stage ~= self.STAGE_LAIR) then
		return
	end

	if (not self:isPresent(pPlayer)) then
		return
	end

	for i = 1, #hunt.templates do
		self:spawnEncounter(pPlayer, hunt.templates[i], 1, self.huntMinDistance, self.huntMaxDistance, true)
	end
end

-- task 1: Go to Location (-2694, 42, 6077) r 10. The second Obi-Wan stands 4 m
-- from the entrance stone inside this circle, so arriving and meeting him are the
-- same act; this is the arrival half, and his chamber_meet screen is the other.
function kenobiSpineScreenPlay:notifyEnteredChamberSite(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_ENTRANCE) then
		return 0
	end

	self:removeWaypoint(pPlayer)

	CreatureObject(pPlayer):sendSystemMessage("Obi-Wan is waiting for you at the entrance stone.")

	return 0
end

-- Screens hurry_a / hurry_b, signal 'talkedKenobi3'. This is what opens the way
-- into the lair; see mustafar_instances.lua, where the entry consults mayEnterLair.
function kenobiSpineScreenPlay:talkedKenobi3(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_ENTRANCE) then
		return
	end

	self:setStage(pPlayer, self.STAGE_LAIR)
	self:removeWaypoint(pPlayer)

	-- _3_b's task 15 journal line, "Destroying the crystal".
	CreatureObject(pPlayer):sendSystemMessage("The way into the chamber is open. Destroy the crystal, and whatever came for it.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	-- Re-armed for the boss; it was dropped when the hermit leg closed.
	createObserver(KILLEDCREATURE, "kenobiSpineScreenPlay", "notifyKilledCreature", pPlayer, 1)
end

-- The gate mustafar_instances.lua asks before it will show or honour the entry
-- radial on node 12112106.
function kenobiSpineScreenPlay:mayEnterLair(pPlayer)
	return self:getStage(pPlayer) >= self.STAGE_LAIR
end

-- task 15: Destroy Multiple som_kenobi_dark_jedi_boss, Count 1, taskName
-- killSinistro, then task 13's Immediately Complete Quest. The _visible file's
-- musicOnComplete is the success sting.
function kenobiSpineScreenPlay:bossKilled(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_LAIR) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE)

	dropObserver(KILLEDCREATURE, "kenobiSpineScreenPlay", "notifyKilledCreature", pPlayer)

	CreatureObject(pPlayer):sendSystemMessage("Sinistro is dead and the Soul Crystal is destroyed.")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
end

--[[ Radial dispatch

One component table serves four kinds of object: the dying miner, the spawned
mining computer, and the three snapshot conduits. LuaObjectMenuComponent replaces
the object's menu entirely, so fillObjectMenuResponse has to add every item that
should be there and add nothing at all when this player has no business with the
object. Each object's role was written at start(); see getKenobiRole and the
writeStringData calls in the spawn functions.

Every string below is the .qst's own retrieveMenuText, except the miner's, which
is authored -- SOE gave him no menu text because they gave him nothing at all.
--]]

function kenobiSpineScreenPlay:getRadialText(pPlayer, role)
	if (role == "miner") then
		if (self:getStage(pPlayer) == self.STAGE_MINER) then
			return "Examine the dying miner"
		end

		return nil
	end

	if (role == "computer") then
		if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
			return nil
		end

		if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "mainframe")) or 0) == 0) then
			return nil
		end

		local search = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "search")) or 0

		if (search == 0) then
			return "Input search command"
		elseif (search == 2) then
			return "Check results"
		end

		return nil
	end

	if (self:getConduit(role) ~= nil) then
		if (self:getStage(pPlayer) ~= self.STAGE_CONDUITS) then
			return nil
		end

		local state = self:getConduitState(pPlayer, role)

		if (state == 0) then
			return "Wedge crystal"
		elseif (state == 2) then
			return "Take crystal"
		end

		return nil
	end

	return nil
end

KenobiSpineMenuComponent = {}

function KenobiSpineMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kenobiSpineRole")
	local text = kenobiSpineScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function KenobiSpineMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kenobiSpineRole")

	if (role == "miner") then
		kenobiSpineScreenPlay:examineMiner(pPlayer, pSceneObject)

	elseif (role == "computer") then
		local search = tonumber(readScreenPlayData(pPlayer, kenobiSpineScreenPlay.screenplayName, "search")) or 0

		if (search == 0) then
			kenobiSpineScreenPlay:startSearch(pPlayer, pSceneObject)
		elseif (search == 2) then
			kenobiSpineScreenPlay:readResults(pPlayer, pSceneObject)
		end

	elseif (kenobiSpineScreenPlay:getConduit(role) ~= nil) then
		local state = kenobiSpineScreenPlay:getConduitState(pPlayer, role)

		if (state == 0) then
			kenobiSpineScreenPlay:wedgeCrystal(pPlayer, role)
		elseif (state == 2) then
			kenobiSpineScreenPlay:takeCrystal(pPlayer, role)
		end
	end

	return 0
end
