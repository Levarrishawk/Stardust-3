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

  OVERTURNED -- ROUND G(b1). The boss fighting stand is (31, 0, 6), not
  (37.0, 5.1); see lair.x/y and the OVERTURNED block under WHAT IS NOT
  MODELLED. furnishLair now places the full setpiece per copy -- boss, Obi-Wan
  at hangBackLocation (33, 0, 4.7), pedestal and buff crystal at (57, *, 6),
  exit stone at (4.38, 0, 2.34). Per-player keys crystal (0/1/2) and usedCrystal
  gate the finale radials; see STATE.

  ROUND G(b2a). The lair is a scripted six-beat encounter (beats 0-4 in this
  round; beat 5 remains bossKilled for G(b2b)), not a static boss. The ladder,
  waves, and movers live in the event block after furnishLair, sourced from
  obiwan_event_manager.java (lightsCameraAction and its handlers) and
  obiwan_lair_boss.java (OnAttach / startFighting). The boss is spawned into
  the event on entry, not by furnishLair -- see the OVERTURNED block under
  lair.respawn.

  ROUND G(b2b). The two fights, the force-power attack cycle, the interrupt,
  fight-one's health-floor ending, banter, and beat 5's crystal nag live after
  the G(b2a) ladder, sourced from obiwan_lair_boss.java (startFighting,
  stopFighting, the windup/execute/taunt/praise handlers) and
  obiwan_event_manager.java (obiSaysDestroyCrystal / obiRepeatsDestroyCrystal).

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

  som_kenobi_final_crystal_pedestal and som_kenobi_final_force_crystal ARE
  placed, from datatables/dungeon/mustafar_trials/obiwan_finale/obiwan_event_data.tab,
  which lair_of_the_crystal.tpf reaches through
  theme_park.dungeon.mustafar_trials.obiwan_finale.obiwan_event_manager. The
  pedestal row is object/tangible/quest/som_kenobi_final_crystal_pedestal.iff at
  live (locx, locy, locz) = (57, 0, 6), yaw -90, which is repo (x, z, y) =
  (57, 0, 6). It lands in the finale section of this file (self.lair.pedestal).
  Shared template shared_lair_of_the_crystal.tpf names the interior as
  interiorlayout/som_obiwan_crystal_lair.ilf. Cell name "mainroom" is confirmed
  by obiwan_event_manager.java:539 getCellId(self, "mainroom").

  Why an earlier note was wrong: it searched .qst files and
  datatables/spawning/dungeon/ and concluded from two empty directories that
  nothing shipped. The table was in the building's own server template all
  along. That is a research gap, not a design question, and the sentence
  calling the placement Aaron's decision is withdrawn.

  The 141-node .ilf has TWO statue galleries, and they still describe the room:

    gallery 1   x 21..40    h -0.2..0.8  16 relic statues standing on the floor,
                                         mostly in two rows -- 7 at z 2.50 and
                                         6 at z ~7.65. The aisle between them is
                                         where the player arrives (24.0, 5.1)
                                         and where the boss waits (37.0, 5.1).

    gallery 2   x 74..86    h ~ 4.13      8 relic statues in a ring, each one
                                         raised on its own pillar_pristine_tall
                                         at h -4.10 -- 8 statues, 8 pillars,
                                         paired within a metre of each other.
                                         Gallery 2's ring centre is (79.83, 5.29);
                                         the jeditemple_dome and
                                         jeditemple_platform_lrg agree on that
                                         centre to within 0.15 m. Gallery 2 is no
                                         longer a guess about where the pedestal
                                         goes; the guess was wrong by about 23 m.

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

	--[[ The lair. Cell-local; the pool and the entry point are
	     mustafar_instances.lua's. Positions below are from
	     obiwan_event_data.tab via obiwan_event_manager (see OVERTURNED -- ROUND
	     G(b1) above). SOE columns are locx/locy/locz with locy = height; this
	     repo's spawn order is x, z, y with z = height. ]]

	lair = {
		poolKey = "lair_of_the_crystal",
		cellName = "mainroom",
		boss = "som_dark_jedi_boss",
		-- Old guessed position was x = 37.0, y = 5.1 (gallery-1 aisle centre from
		-- the .ilf). Replaced by moveBossToHomeLoc's fighting stand at (31, 0, 6)
		-- -- obiwan_event_manager.java:179, :199, :254 message that mover before
		-- every minionWaveLaunch; the posture stand at (53, 0, 5) is the monologue
		-- spot and is not used here (no intermission ladder in G(b1)).
		x = 31,
		z = 0.0,
		y = 6,
		heading = 90,  -- facing back up the aisle, at the arriving player
		-- One boss is placed per copy at start() and start() runs once per server
		-- lifetime, so without a timer the first kill empties that copy for good and
		-- findFreeCopy hands the cleared copy straight to the next player -- who then
		-- has nothing to kill and no other way to reach STAGE_DONE. Matches the arc's
		-- own dark jedi timer, historian.lua:220.
		respawn = 600,

		--[[ OVERTURNED -- ROUND G(b2). furnishLair no longer spawns the boss, and
		     the ladder spawns it on entry with respawn 0 (see startLair). Two
		     reasons: (1) the boss must be INVULNERABLE for most of the encounter,
		     and a 600 s respawn would drop a fresh attackable mobile with a clean
		     options bitmask -- killable with no ladder running; (2) live does not
		     place the boss statically either -- spawnBossDelay at
		     obiwan_event_manager.java:239-246 calls mustafar.spawnContents(self,
		     "boss", 1) into the event. clearLair despawns any leftover before the
		     next run, so the empty-copy problem the timer papered over is gone. ]]

		-- obiwan_event_data.tab setpiece row; yaw transcribed, positions cross-checked.
		pedestal = {
			template = "object/tangible/quest/som_kenobi_final_crystal_pedestal.iff",
			x = 57,
			z = 0,
			y = 6,
			heading = -90,
		},

		-- Same table's buff-crystal setpiece. Height 1.5 is not a typo -- it floats
		-- one and a half metres above the pedestal at height 0, same x and y.
		-- Yaw -92 transcribed from the table; yaw convention was not cross-checked.
		crystal = {
			template = "object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_buff_crystal.iff",
			x = 57,
			z = 1.5,
			y = 6,
			heading = -92,
		},

		-- Same table's exit-stone setpiece; script obiwan_exit_object.
		exitStone = {
			template = "object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_exit_stone.iff",
			x = 4.38,
			z = 0,
			y = 2.34,
			heading = 0,
		},

		-- hangBackLocation from the same table -- the only Obi-Wan mover without a
		-- hardcoded new location (moveObiwanHomeAfterCommenting,
		-- obiwan_event_manager.java:589). Yaw 88 transcribed; not cross-checked.
		obiwan = {
			template = "som_kenobi_obi_wan",
			x = 33,
			z = 0,
			y = 4.7,
			heading = 88,
		},

		--[[ The scripted event. Beats and timings are obiwan_event_manager.java's
		     lightsCameraAction ladder (:141-238) and the handlers it messages.
		     Positions are cell-local, same axis mapping as the setpiece above. ]]

		-- moveBossToHomeLoc, obiwan_event_manager.java:486. The fighting stand.
		bossHome = { x = 31, z = 0, y = 6 },
		-- moveBossToPostureLoc, :473. Where the boss retreats to monologue between waves.
		bossPosture = { x = 53, z = 0, y = 5 },
		-- moveObiwanToPostureLocation :554 and moveObiwanForCrystalComment :582.
		obiwanPosture = { x = 53.8, z = -0.4, y = 5.9 },
		-- moveObiwanOuttaTheWay, :568. Where he stands while minions are up.
		obiwanClear = { x = 48, z = 0, y = 9 },
		-- moveMinionIntoRoom, :540 -- every minion paths here, then
		-- utils.getRandomAwayLocation(home, 1.0f, 4.0f) scatters it 1-4 m off.
		minionMuster = { x = 55, z = 0, y = 6 },
		minionScatterMin = 1,
		minionScatterMax = 4,

		--[[ Wave sizes are minionWaveLaunch's switch, obiwan_event_manager.java:352-382:
		     wave 1 = spawnContents("minionA", 1); wave 2 = ("minionA", 2) + ("minionB", 1);
		     wave 3 = ("minionB", 2) + ("minionB", 3). So 1, 3, 5.

		     Live splits them by template -- minionA is som_kenobi_finale_minion_mix and
		     minionB is som_kenobi_finale_minion_melee (obiwan_event_data.tab). This tree
		     has neither. It has som_dark_jedi_minion_1..8, and all eight are the SAME
		     stat block -- level 85, baseHAM 12000/15000, PACK + STALKER, primary
		     dark_jedi_weapons_gen3 and secondary dark_jedi_weapons_ranged (verified
		     across all eight files). They differ only in appearance .iff. So live's
		     mix/melee split has no analogue here and carries no mechanical meaning;
		     only the wave SIZES survive the port. The eight variants are cycled purely
		     so the player does not fight the same face nine times. ]]
		waves = { 1, 3, 5 },
		minionTemplates = {
			"som_dark_jedi_minion_1", "som_dark_jedi_minion_2",
			"som_dark_jedi_minion_3", "som_dark_jedi_minion_4",
			"som_dark_jedi_minion_5", "som_dark_jedi_minion_6",
			"som_dark_jedi_minion_7", "som_dark_jedi_minion_8",
		},

		--[[ Live delivers these through mustafar/obiwan_finale.stf (mustafar.java:12).
		     This repo ships no .stf files -- strings are TRE-side -- so whether that
		     file is present cannot be determined here, and a missing key would print
		     raw in the chat window. Authored instead, with the live key each line
		     stands in for. Swap them for "@mustafar/obiwan_finale:<key>" if the stf is
		     ever confirmed. ]]
		lines = {
			-- som_dark_jedi_crystal_speech1
			bossOpening = "So. Another one comes crawling to the crystal. It is mine, and you are nothing.",
			-- som_dark_jedi_attack_minions_1 / _2 / _3
			bossWave = {
				"Kill this one. I have waited long enough.",
				"More of you! Tear the fool apart!",
				"All of you! I will not be denied!",
			},
			-- som_dark_jedi_cannot_defeat_me
			bossCannotDefeat = "You cannot defeat me. Better than you have tried and been broken.",
			-- som_dark_jedi_destroy_you_myself
			bossDestroyYou = "Enough. If it must be done, I will destroy you myself.",
			-- som_dark_jedi_snap_you_half
			bossSnapYouHalf = "I am going to snap you in half.",
			-- som_dark_jedi_nooo
			bossNooo = "No! The crystal is MINE!",
			-- som_obi_be_careful
			obiBeCareful = "Careful. He is stronger than he looks, and he is not fighting alone.",
			-- som_obi_be_careful2
			obiBeCareful2 = "The crystal behind him -- draw on it if you must. It will not last.",
			--[[ som_dark_jedi_you_die_1 .. _15, rolled by randomTaunter
			     (obiwan_lair_boss.java:263). Eight authored rather than fifteen --
			     the point of the list is that he does not repeat himself inside one
			     fight, and at rand(10,30) seconds a fight will not draw eight. ]]
			bossTaunts = {
				"You fight well. It will not be enough.",
				"Is that all the Force gave you?",
				"You are already tired. I can hear it.",
				"Every one of you dies the same way.",
				"The crystal is watching you fail.",
				"Kneel, and I may make it quick.",
				"You should have stayed on the shore.",
				"I have killed better and forgotten them.",
			},
			--[[ som_obiwan_sayings_1 .. _10, rolled by randomPraiser (:302). Six
			     authored, same reasoning. Obi-Wan is a ghost giving encouragement,
			     not a combatant -- he never intervenes. ]]
			obiSayings = {
				"Steady. Do not let his anger become yours.",
				"Good. You see the opening before he does.",
				"He is stronger than you. That is not the same as better.",
				"Breathe. The Force is not in a hurry.",
				"He fights to be feared. You fight to be finished.",
				"You are doing well. Do not stop.",
			},
			-- som_obi_lookout_special, obiwan_event_manager.java:295.
			obiLookoutSpecial = "Look out -- he is gathering something. Break his focus!",
			-- som_obi_block_special, :311.
			obiBlockSpecial = "Yes! You broke it. He cannot hold that and take a hit.",
			-- som_obi_won_congrats, :224.
			obiWonCongrats = "It is over. You did what I could not ask anyone else to do.",
			-- som_obi_destroy_crystal, :496.
			obiDestroyCrystal = "The crystal is what he came for. Destroy it, and none of this happens again.",
			-- som_obi_destroy_crystal_short, :525.
			obiDestroyCrystalShort = "The crystal. Deal with it.",
		},

		--[[ The special force-power attack. Four rows, obiwan_event_data.tab's
		     forcePowerAttack entries -- name, the animation the boss plays on
		     execute, the client effect played on the PLAYER, and the damage band.
		     The band is the whole difficulty curve of the attack: a multiStoneThrow
		     that lands is 3000-4000, which is why blocking it matters. ]]
		forceAttacks = {
			{ name = "singleStoneThrow", animation = "force_push",     effect = "clienteffect/mustafar/dark_jedi_rock_attack_1.cef",  minDamage = 500,  maxDamage = 1000 },
			{ name = "doubleStoneThrow", animation = "force_strength", effect = "clienteffect/mustafar/dark_jedi_rock_attack_2.cef",  minDamage = 1000, maxDamage = 2000 },
			{ name = "tripleStoneThrow", animation = "force_strength", effect = "clienteffect/mustafar/dark_jedi_rock_attack_3.cef",  minDamage = 2000, maxDamage = 3000 },
			{ name = "multiStoneThrow",  animation = "force_choke",    effect = "clienteffect/mustafar/dark_jedi_rock_attack_10.cef", minDamage = 3000, maxDamage = 4000 },
		},

		--[[ The WINDUP is deliberately not the same effect as the execute. On windup
		     the boss plays one of three animations and one of four client effects on
		     HIMSELF, all picked at random and none of them tied to the row that will
		     actually fire (obiwan_lair_boss.java:348-352 rolls the row, the anim and
		     the cef independently). That is the tell the player has to read: something
		     is coming, but not what. Lists are FORCE_ATTACK_ANIMS :15-20 and
		     FORCE_ATTACK_CEFS :21-27. ]]
		forceWindupAnims = { "force_push", "force_strength", "force_choke" },
		forceWindupEffects = {
			"clienteffect/pl_force_tangle.cef",
			"clienteffect/pl_force_lightning_begin.cef",
			"clienteffect/pl_force_weaken.cef",
			"clienteffect/pl_force_blast.cef",
		},

		-- FORCE_ATTACK_ABORT_DAMAGE_REQUIRED, obiwan_lair_boss.java:35. One hit over
		-- this while he is winding up cancels the attack.
		forceInterruptDamage = 2000,
		-- messageTo "specialForcePowerAttackWindup", rand(10, 20) -- :233, :365, :433.
		forceWindupMin = 10,
		forceWindupMax = 20,
		-- messageTo "specialForcePowerAttackExecute", 15 -- :351. Fixed, not a roll.
		forceExecuteDelay = 15,
		-- randomTaunter rand(10, 30) :231 / :267; randomPraiser rand(15, 30) :232 / :306.
		tauntMin = 10,
		tauntMax = 30,
		praiseMin = 15,
		praiseMax = 30,
		--[[ Fight one ends here instead of at zero. See notifyLairBossDamaged for why
		     a health floor replaces live's OnAboutToBeIncapacitated + SCRIPT_OVERRIDE. ]]
		fightOneFloor = 0.25,
		-- obiRepeatsDestroyCrystal, obiwan_event_manager.java:501, :529.
		nagMin = 20,
		nagMax = 40,
	},

	--[[ Live badge.grantBadge keys, from obiCongratulatesPlayer
	     (obiwan_event_manager.java:445) and playerGetsCrystal (:428).

	     UPPERCASE because that is the only form that can resolve. The badge list
	     is not in this repo at all -- BadgeList.cpp:46 reads
	     datatables/badge/badge_map.iff out of the TREs, and
	     DirectorManager.cpp:863-869 then registers each row as a Lua global under
	     badge->getKey().toUpperCase(). So whether these two exist is a property of
	     the TRE set, not of the scripts. Reading badge_map.iff from this server's
	     TRE set shows neither row is present, so both awards are currently no-ops
	     and the nil-guard at grantFinaleBadge is doing exactly the job it was
	     written for: on a TRE set that carries them the player gets the badge,
	     and on one that does not, nothing happens and nothing errors. ]]
	goodBadge = "BDG_MUST_OBIWAN_STORY_GOOD",
	badBadge = "BDG_MUST_OBIWAN_STORY_BAD",

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
	-- Written by startLair (the ladder), not by furnishLair.
	bossCopies = 0,
	pedestalCopies = 0,
	crystalCopies = 0,
	exitStoneCopies = 0,
	obiwanLairCopies = 0,
	lairObserverCopies = 0,
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
		self:furnishLair()
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

--[[ Every copy of the instance gets the full setpiece -- boss, Obi-Wan, pedestal,
     buff crystal, exit stone -- because the pool hands a free copy to whoever
     asks; reunite_shard furnishes its fusion machine the same way. Was
     spawnBosses(); renamed when the room contents from obiwan_event_data.tab
     were wired in. Crystal and exit stone carry KenobiSpineMenuComponent; the
     pedestal and Obi-Wan do not. ]]
function kenobiSpineScreenPlay:furnishLair()
	local buildings = MustafarInstances:getPoolBuildings(self.lair.poolKey)

	if (#buildings == 0) then
		printLuaError("kenobiSpineScreenPlay: no " .. self.lair.poolKey .. " pool; the finale has no room")
		return
	end

	local pedestal = self.lair.pedestal
	local crystal = self.lair.crystal
	local exitStone = self.lair.exitStone
	local obiwan = self.lair.obiwan

	for i = 1, #buildings do
		local pBuilding = getSceneObject(buildings[i])

		if (pBuilding == nil) then
			printLuaError("kenobiSpineScreenPlay: " .. self.lair.poolKey .. " copy " .. buildings[i] .. " is missing")
		else
			local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

			if (cellID == 0) then
				printLuaError("kenobiSpineScreenPlay: copy " .. buildings[i] .. " has no cell named " .. self.lair.cellName .. "; it has no setpiece")
			else
				local pObiwan = spawnMobile("mustafar", obiwan.template, 0, obiwan.x, obiwan.z, obiwan.y, obiwan.heading, cellID)

				if (pObiwan == nil) then
					printLuaError("kenobiSpineScreenPlay: failed to spawn " .. obiwan.template .. " in the lair copy " .. buildings[i])
				else
					writeData(self:lairKey(buildings[i], "obiwan"), SceneObject(pObiwan):getObjectID())
					self.obiwanLairCopies = self.obiwanLairCopies + 1
				end

				local pPedestal = spawnSceneObject("mustafar", pedestal.template, pedestal.x, pedestal.z, pedestal.y, cellID, math.rad(pedestal.heading))

				if (pPedestal == nil) then
					printLuaError("kenobiSpineScreenPlay: failed to spawn the crystal pedestal in copy " .. buildings[i])
				else
					self.pedestalCopies = self.pedestalCopies + 1
				end

				local pCrystal = spawnSceneObject("mustafar", crystal.template, crystal.x, crystal.z, crystal.y, cellID, math.rad(crystal.heading))

				if (pCrystal == nil) then
					printLuaError("kenobiSpineScreenPlay: failed to spawn the finale crystal in copy " .. buildings[i])
				else
					writeStringData(SceneObject(pCrystal):getObjectID() .. ":kenobiSpineRole", "finaleCrystal")
					SceneObject(pCrystal):setObjectMenuComponent("KenobiSpineMenuComponent")
					self.crystalCopies = self.crystalCopies + 1
				end

				local pStone = spawnSceneObject("mustafar", exitStone.template, exitStone.x, exitStone.z, exitStone.y, cellID, math.rad(exitStone.heading))

				if (pStone == nil) then
					printLuaError("kenobiSpineScreenPlay: failed to spawn the exit stone in copy " .. buildings[i])
				else
					writeStringData(SceneObject(pStone):getObjectID() .. ":kenobiSpineRole", "exitStone")
					SceneObject(pStone):setObjectMenuComponent("KenobiSpineMenuComponent")
					self.exitStoneCopies = self.exitStoneCopies + 1
				end

				if (createObserver(ENTEREDBUILDING, "kenobiSpineScreenPlay", "notifyEnteredLair", pBuilding) ~= nil) then
					self.lairObserverCopies = self.lairObserverCopies + 1
				end
			end
		end
	end
end

function kenobiSpineScreenPlay:lairKey(buildingID, field)
	return "kenobiLair:" .. buildingID .. ":" .. field
end

-- Splits a "buildingID:session" event args string and verifies the session is still
-- the live one for that copy. Returns the buildingID, or 0 if the chain is stale.
-- Pattern tolerates a trailing ":waveIndex" so lairWave can carry its index.
function kenobiSpineScreenPlay:liveLair(args)
	local buildingID, session = string.match(tostring(args), "^(%d+):(%d+)")

	if (buildingID == nil) then
		return 0
	end

	buildingID = tonumber(buildingID)

	if (readData(self:lairKey(buildingID, "session")) ~= tonumber(session)) then
		return 0
	end

	return buildingID
end

--[[ Live moves everyone with ai_lib.aiPathTo + setHomeLocation
     (obiwan_event_manager.java:474-475 and friends). This tree binds
     AiAgent:setNextPosition(x, z, y, cellID) -- LuaAiAgent.cpp:45, and the cellID is a
     NUMERIC id, which is what an in-cell move needs. The sequence around it is
     fs_cs_commander.lua:321-327's.

     setHomeLocation is deliberately NOT called. Its binding takes the cell as
     lightuserdata, not as an id, and every screenplay in the tree passes a literal 0 --
     which for an in-cell mob would pin its home to an outdoor position and make it try
     to leash out of the building. setNextPosition alone is the correct in-cell move. ]]
function kenobiSpineScreenPlay:moveLairActor(pActor, where, cellID)
	if (pActor == nil or where == nil or cellID == 0) then
		return
	end

	AiAgent(pActor):stopWaiting()
	AiAgent(pActor):setWait(0)
	AiAgent(pActor):setNextPosition(where.x, where.z, where.y, cellID)
	AiAgent(pActor):executeBehavior()
end

--[[ The ladder starts when a STAGE_LAIR player walks into a lair copy.

     Live starts it from the boss's own OnAttach (obiwan_lair_boss.java:37-52), which
     fires when the event manager spawns the boss into the freshly-created instance --
     i.e. on arrival. Arrival is therefore the faithful trigger, and it is also the only
     workable one: the boss is INVULNERABLE for most of the encounter, and an
     INVULNERABLE agent is not attackable at all (AiAgentImplementation.cpp:4358 --
     isAttackableBy returns false on the bit), so "the player swung at the boss" could
     never fire.

     Observer contract: return 0 to stay attached, 1 to drop
     (ScreenPlayObserverImplementation.cpp:40). This one stays -- the copy is reused. ]]
function kenobiSpineScreenPlay:notifyEnteredLair(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil) then
		return 0
	end

	if (not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_LAIR) then
		return 0
	end

	local buildingID = SceneObject(pBuilding):getObjectID()

	-- Same player re-entering an in-progress ladder must not restart it.
	if (readData(self:lairKey(buildingID, "player")) == SceneObject(pPlayer):getObjectID()) then
		if (readData(self:lairKey(buildingID, "phase")) >= 0) then
			return 0
		end
	end

	self:startLair(buildingID, pPlayer)
	return 0
end

function kenobiSpineScreenPlay:startLair(buildingID, pPlayer)
	self:clearLair(buildingID)

	local session = readData(self:lairKey(buildingID, "session")) + 1
	writeData(self:lairKey(buildingID, "session"), session)
	writeData(self:lairKey(buildingID, "player"), SceneObject(pPlayer):getObjectID())
	writeData(self:lairKey(buildingID, "phase"), 0)
	writeData(self:lairKey(buildingID, "minions"), 0)
	writeData(self:lairKey(buildingID, "fight"), 0)

	local pBuilding = getSceneObject(buildingID)
	local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

	if (cellID == 0) then
		printLuaError("kenobiSpineScreenPlay: lair copy " .. buildingID .. " has no cell named " .. self.lair.cellName .. "; the ladder cannot start")
		return
	end

	local pBoss = spawnMobile("mustafar", self.lair.boss, 0, self.lair.x, self.lair.z, self.lair.y, self.lair.heading, cellID)

	if (pBoss == nil) then
		printLuaError("kenobiSpineScreenPlay: failed to spawn " .. self.lair.boss .. " in lair copy " .. buildingID)
		return
	end

	-- Live holds the boss with setInvulnerable(true) (obiwan_lair_boss.java:40). There is
	-- no setInvulnerable binding in this tree; the substitution is the INVULNERABLE
	-- option bit (DirectorManager.cpp:737 registers the global,
	-- LuaTangibleObject.cpp:49-51 binds the setters), which zeroes all damage
	-- (CreatureObjectImplementation.cpp:1199) and makes the agent untargetable
	-- (AiAgentImplementation.cpp:4358). Same substitution the volcano arena already
	-- ruled and uses -- volcano_battlefield.lua:448 and :2214.
	TangibleObject(pBoss):setOptionBit(INVULNERABLE)
	writeData(self:lairKey(buildingID, "boss"), SceneObject(pBoss):getObjectID())
	self.bossCopies = self.bossCopies + 1

	-- bossKilled arrives through notifyKilledCreature, which has no building. Record
	-- the copy on the player so the ending can find the ladder it has to shut down.
	writeScreenPlayData(pPlayer, self.screenplayName, "lairCopy", tostring(buildingID))

	-- Live delays the first lightsCameraAction by 16 s from the boss's OnAttach
	-- (obiwan_lair_boss.java:51).
	createEvent(16 * 1000, "kenobiSpineScreenPlay", "lairBeat", pPlayer, buildingID .. ":" .. session)
end

--[[ A copy is reused. Whatever the previous occupant left standing -- a boss they never
     killed, a half-cleared wave -- has to go before a new ladder starts, or the next
     player walks into someone else's fight. Bumping the session in startLair kills the
     old timer chain; this kills the old bodies.

     Minions are not individually recorded. They are left to their own
     OBJECTDESTRUCTION / despawn handling. The session bump stops them counting toward
     the new ladder: the minions counter is reset to 0, and a stale minion killed later
     hits notifyLairMinionKilled, which floors at 0 and finds no live session (each
     minion carries the session it was spawned under), so it cannot advance the new
     ladder. ]]
function kenobiSpineScreenPlay:clearLair(buildingID)
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))

	if (pBoss ~= nil) then
		SceneObject(pBoss):destroyObjectFromWorld()
	end

	writeData(self:lairKey(buildingID, "boss"), 0)
	writeData(self:lairKey(buildingID, "minions"), 0)
	writeData(self:lairKey(buildingID, "phase"), 0)
	writeData(self:lairKey(buildingID, "player"), 0)
	writeData(self:lairKey(buildingID, "fight"), 0)
	writeData(self:lairKey(buildingID, "fightNum"), 0)
	writeData(self:lairKey(buildingID, "forceAtk"), 0)
	writeData(self:lairKey(buildingID, "noForce"), 0)
	-- dmgObs is the "have I already attached the damage observer" flag, and it is
	-- attached to the boss object, which clearLair destroys. Leaving it set would
	-- mean the next run's boss never gets one and fight one would never end.
	writeData(self:lairKey(buildingID, "dmgObs"), 0)
end

-- lightsCameraAction, obiwan_event_manager.java:141-238.
function kenobiSpineScreenPlay:lairBeat(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local phase = readData(self:lairKey(buildingID, "phase"))

	-- obiwan_event_manager.java:147-150 clears readyToUseCrystal on entry to every beat.
	-- Only beat 2 re-sets it below, so the buff crystal is a fight-one lifeline only --
	-- beat 3 fires from lairEndFightOne, which is what takes it away again.
	writeScreenPlayData(pPlayer, self.screenplayName, "crystalReady", "0")

	if (phase == 0) then
		-- obiwan_event_manager.java:159-169, then darkJediThrowsDownPartOne :247-257
		CreatureObject(pPlayer):playEffect("clienteffect/mustafar/som_dark_jedi_laugh.cef", "")
		CreatureObject(pBoss):doAnimation("threaten")
		spatialChat(pBoss, self.lair.lines.bossOpening)
		-- :168 messages darkJediThrowsDownPartOne at +10 s, which then schedules the
		-- wave at +10 s (:255) and the boss's walk home at +14 s (:254).
		createEvent(20 * 1000, "kenobiSpineScreenPlay", "lairWave", pPlayer, buildingID .. ":" .. session .. ":1")
		createEvent(24 * 1000, "kenobiSpineScreenPlay", "lairBossHome", pPlayer, args)
	elseif (phase == 1) then
		-- :170-183
		CreatureObject(pBoss):doAnimation("point_forward")
		spatialChat(pBoss, self.lair.lines.bossCannotDefeat)
		createEvent(3 * 1000, "kenobiSpineScreenPlay", "lairObiWarns", pPlayer, args)
		createEvent(6 * 1000, "kenobiSpineScreenPlay", "lairWave", pPlayer, buildingID .. ":" .. session .. ":2")
		createEvent(10 * 1000, "kenobiSpineScreenPlay", "lairBossHome", pPlayer, args)
	elseif (phase == 2) then
		-- :184-195. :191 sets readyToUseCrystal on the player.
		spatialChat(pBoss, self.lair.lines.bossDestroyYou)
		writeScreenPlayData(pPlayer, self.screenplayName, "crystalReady", "1")
		createEvent(1 * 1000, "kenobiSpineScreenPlay", "lairObiToCrystal", pPlayer, args)
		createEvent(17 * 1000, "kenobiSpineScreenPlay", "lairBossThrowsDown", pPlayer, args)
		createEvent(23 * 1000, "kenobiSpineScreenPlay", "lairStartFight", pPlayer, args)
	elseif (phase == 3) then
		-- :196-203
		createEvent(1 * 1000, "kenobiSpineScreenPlay", "lairBossHome", pPlayer, args)
		createEvent(10 * 1000, "kenobiSpineScreenPlay", "lairWave", pPlayer, buildingID .. ":" .. session .. ":3")
	elseif (phase == 4) then
		-- :204-213
		spatialChat(pBoss, self.lair.lines.bossNooo)
		createEvent(10 * 1000, "kenobiSpineScreenPlay", "lairStartFight", pPlayer, args)
	else
		-- phase 5+: beat 5 is bossKilled, which round G(b2b) owns; the ladder does not drive it.
		return
	end

	writeData(self:lairKey(buildingID, "phase"), phase + 1)
end

function kenobiSpineScreenPlay:lairWave(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local waveIndex = tonumber(string.match(tostring(args), "^%d+:%d+:(%d+)$")) or 0
	local size = self.lair.waves[waveIndex] or 0
	local pBuilding = getSceneObject(buildingID)
	local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

	if (cellID == 0 or size == 0) then
		return
	end

	-- minionWaveLaunch :344-347
	spatialChat(pBoss, self.lair.lines.bossWave[waveIndex])
	writeData(self:lairKey(buildingID, "minions"), size)

	--[[ Live spawns minions at the tab's (9, 0, -3.5) doorway and then paths each one to
	     (55, 0, 6) with utils.getRandomAwayLocation(home, 1.0f, 4.0f)
	     (obiwan_event_manager.java:532-544, moveMinionIntoRoom). Collapsed here into a
	     direct spawn at the destination with the same 1-4 m scatter: this tree has no
	     in-cell aiPathTo, and setNextPosition gives no arrival guarantee inside a
	     building, so pathing them from the doorway risks a wave that never reaches the
	     player and a ladder that never advances. The end state -- a scattered wave at
	     (55, 0, 6) attacking the player -- is identical.

	     OBJECTDESTRUCTION per minion rather than counting through the player's
	     KILLEDCREATURE observer: this fires whoever lands the kill, so a minion that
	     dies to anything else still advances the ladder. Same pattern as
	     lava_beetle_nests.lua:692-720, in this same directory. ]]
	for i = 1, size do
		local muster = self.lair.minionMuster
		local dx = getRandomNumber(self.lair.minionScatterMin, self.lair.minionScatterMax)
		local dy = getRandomNumber(self.lair.minionScatterMin, self.lair.minionScatterMax)
		local template = self.lair.minionTemplates[((waveIndex * 3 + i) % #self.lair.minionTemplates) + 1]
		local pMinion = spawnMobile("mustafar", template, 0, muster.x + dx, muster.z, muster.y + dy, getRandomNumber(0, 359), cellID)

		if (pMinion == nil) then
			printLuaError("kenobiSpineScreenPlay: failed to spawn " .. template .. " in lair copy " .. buildingID)
		else
			writeData(SceneObject(pMinion):getObjectID() .. ":kenobiLairSession", session)
			createObserver(OBJECTDESTRUCTION, "kenobiSpineScreenPlay", "notifyLairMinionKilled", pMinion)
			AiAgent(pMinion):setDefender(pPlayer)
		end
	end

	-- minionWaveLaunch :383
	createEvent(5 * 1000, "kenobiSpineScreenPlay", "lairObiClear", pPlayer, args)
end

function kenobiSpineScreenPlay:notifyLairMinionKilled(pMinion, pKiller)
	if (pMinion == nil) then
		return 1
	end

	local pBuilding = SceneObject(pMinion):getRootParent()

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		return 1
	end

	local buildingID = SceneObject(pBuilding):getObjectID()
	local minionID = SceneObject(pMinion):getObjectID()
	local session = readData(minionID .. ":kenobiLairSession")

	deleteData(minionID .. ":kenobiLairSession")

	-- Stale minion from a previous run: session bump in startLair makes this safe.
	if (readData(self:lairKey(buildingID, "session")) ~= session) then
		return 1
	end

	local before = readData(self:lairKey(buildingID, "minions"))
	local remaining = before - 1

	if (remaining < 0) then
		remaining = 0
	end

	writeData(self:lairKey(buildingID, "minions"), remaining)

	-- minionDied, obiwan_event_manager.java:386-396
	if (before > 0 and remaining == 0) then
		local pPlayer = getSceneObject(readData(self:lairKey(buildingID, "player")))
		local args = buildingID .. ":" .. session

		if (pPlayer ~= nil) then
			createEvent(1 * 1000, "kenobiSpineScreenPlay", "lairBossPosture", pPlayer, args)
			createEvent(8 * 1000, "kenobiSpineScreenPlay", "lairBeat", pPlayer, args)
		end
	end

	return 1
end

-- obiSaysBeCareful, obiwan_event_manager.java:258-268
function kenobiSpineScreenPlay:lairObiWarns(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	if (pObiwan == nil) then
		return
	end

	spatialChat(pObiwan, self.lair.lines.obiBeCareful)
end

-- moveObiwanForCrystalComment, obiwan_event_manager.java:574-588
function kenobiSpineScreenPlay:lairObiToCrystal(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local pBuilding = getSceneObject(buildingID)
	local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

	self:moveLairActor(pObiwan, self.lair.obiwanPosture, cellID)
	-- :585 messages obiSaysBeCareful2 at +4 s
	createEvent(4 * 1000, "kenobiSpineScreenPlay", "lairObiWarns2", pPlayer, args)
end

-- obiSaysBeCareful2, obiwan_event_manager.java:269-280
function kenobiSpineScreenPlay:lairObiWarns2(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	if (pObiwan == nil) then
		return
	end

	spatialChat(pObiwan, self.lair.lines.obiBeCareful2)
	-- :278 moveObiwanHomeAfterCommenting at +5 s
	createEvent(5 * 1000, "kenobiSpineScreenPlay", "lairObiHome", pPlayer, args)
end

function kenobiSpineScreenPlay:lairObiHome(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local pBuilding = getSceneObject(buildingID)
	local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

	self:moveLairActor(pObiwan, self.lair.obiwan, cellID)
end

-- moveObiwanOuttaTheWay, obiwan_event_manager.java:560-573
function kenobiSpineScreenPlay:lairObiClear(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local pBuilding = getSceneObject(buildingID)
	local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

	self:moveLairActor(pObiwan, self.lair.obiwanClear, cellID)
end

-- darkJediThrowsDownPartTwo, obiwan_event_manager.java:317-328
function kenobiSpineScreenPlay:lairBossThrowsDown(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	spatialChat(pBoss, self.lair.lines.bossSnapYouHalf)
end

-- moveBossToHomeLoc, obiwan_event_manager.java:478-490
function kenobiSpineScreenPlay:lairBossHome(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local pBuilding = getSceneObject(buildingID)
	local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

	self:moveLairActor(pBoss, self.lair.bossHome, cellID)
end

-- moveBossToPostureLoc, obiwan_event_manager.java:465-477
function kenobiSpineScreenPlay:lairBossPosture(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local pBuilding = getSceneObject(buildingID)
	local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)

	self:moveLairActor(pBoss, self.lair.bossPosture, cellID)
end

--[[ The session token says "this ladder run is still the live one". The fight token
     says "this is still the same FIGHT". Both are needed: fight one and fight two are
     the same ladder run, so a taunt timer left over from fight one would otherwise
     re-arm itself inside fight two and the player would face two overlapping chains of
     force attacks. Bumped in lairStartFight, checked here. ]]
function kenobiSpineScreenPlay:liveFight(buildingID, args)
	local fightNum = tonumber(string.match(tostring(args), "^%d+:%d+:(%d+)$"))

	if (fightNum == nil) then
		return false
	end

	if (readData(self:lairKey(buildingID, "fight")) ~= 1) then
		return false
	end

	return readData(self:lairKey(buildingID, "fightNum")) == fightNum
end

--[[ obiwan_lair_boss.java:208-235, startFighting. Round G(b2b) adds the force-power
     attack cycle and the fight-end detection; this is the part both fights share. ]]
function kenobiSpineScreenPlay:lairStartFight(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)
	writeData(self:lairKey(buildingID, "fight"), 1)
	AiAgent(pBoss):setDefender(pPlayer)

	local fightNum = readData(self:lairKey(buildingID, "fightNum")) + 1
	writeData(self:lairKey(buildingID, "fightNum"), fightNum)
	writeData(self:lairKey(buildingID, "noForce"), 0)
	writeData(self:lairKey(buildingID, "forceAtk"), 0)
	-- Live calls startCombat(self, target) (:229); engageCombat is the binding
	-- (LuaCreatureObject.cpp:87).
	CreatureObject(pBoss):engageCombat(pPlayer)

	-- Attach the damage observer once per ladder run, not once per fight.
	if (readData(self:lairKey(buildingID, "dmgObs")) ~= 1) then
		createObserver(DAMAGERECEIVED, "kenobiSpineScreenPlay", "notifyLairBossDamaged", pBoss)
		writeData(self:lairKey(buildingID, "dmgObs"), 1)
	end

	local fightArgs = buildingID .. ":" .. session .. ":" .. fightNum

	createEvent(getRandomNumber(self.lair.forceWindupMin, self.lair.forceWindupMax) * 1000, "kenobiSpineScreenPlay", "lairForceWindup", pPlayer, fightArgs)
	createEvent(getRandomNumber(self.lair.tauntMin, self.lair.tauntMax) * 1000, "kenobiSpineScreenPlay", "lairTaunt", pPlayer, fightArgs)
	createEvent(getRandomNumber(self.lair.praiseMin, self.lair.praiseMax) * 1000, "kenobiSpineScreenPlay", "lairPraise", pPlayer, fightArgs)
end

--[[ Fight-one ending: a health floor instead of live's OnAboutToBeIncapacitated.

     Live. The boss has 155000 HP (obiwan_lair_boss.java:41) and fight one runs the
     whole bar down to zero. At the moment of death OnAboutToBeIncapacitated (:54-87)
     returns SCRIPT_OVERRIDE, which cancels the incapacitation, and stopFighting
     (:192-207) re-locks him, plays a heal effect, and puts 150000 health back
     (addToHealth(self, 150000)). So live's encounter is two full bars of boss.

     Here. There is no pre-death hook. OBJECTDESTRUCTION fires after posture DEAD is
     already set, so returning from its handler cannot un-kill anything. Nothing in
     this tree corresponds to SCRIPT_OVERRIDE.

     Ruling: end fight one at a health floor instead of at zero. A DAMAGERECEIVED
     observer on the boss watches health after every hit; when it crosses 25 % of
     max, fight one ends -- full heal, re-lock, ladder advances. Chosen over the
     volcano arena's polling timer (volcano_battlefield.lua) because a poll can be
     outrun: a 3000 ms tick against a boss losing health every swing can find him
     already dead. DAMAGERECEIVED fires on the swing itself, so the only way to skip
     the floor is one hit for 25 % of the bar.

     Why 25 % and not lower. This tree's boss is som_dark_jedi_boss, baseHAM = 44000,
     baseHAMmax = 54000 (mobile/custom_content/som/som_dark_jedi_boss.lua:27-28). A
     25 % floor leaves 11000-13500 health in the pool -- far above any single player
     hit at this level, so the floor cannot be jumped. Use the fraction, not a
     literal: read getMaxHAM(0) so the check is correct whatever the roll gave him.

     What it costs. Live asks for 155000 + 150000 ≈ two full bars. This asks for
     0.75 of a bar, then a full one -- 1.75 bars. The encounter is slightly shorter
     than live's and the shape is identical: fight, interrupted, wave, fight again
     to the death.

     And if he dies anyway. He degrades into the normal ending. bossKilled is the
     existing beat-5 handler and it does not care which fight killed him, so a freak
     one-shot gives the player a correct, completed quest instead of a hung
     instance. That is deliberate.

     Signature fixed by the engine: (pObservable, pArg1, arg2) -- for DAMAGERECEIVED
     that is the boss, the attacker, and the damage (ObserverEventType.h:43,
     CombatManager.cpp:2002). Same shape as deathWatchBunker.lua's haldoDamage. ]]
function kenobiSpineScreenPlay:notifyLairBossDamaged(pBoss, pAttacker, damage)
	if (pBoss == nil) then
		return 1
	end

	local pBuilding = SceneObject(pBoss):getRootParent()

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		return 1
	end

	local buildingID = SceneObject(pBuilding):getObjectID()

	-- Locked between fights; keep the observer, do nothing.
	if (readData(self:lairKey(buildingID, "fight")) ~= 1) then
		return 0
	end

	local pPlayer = getSceneObject(readData(self:lairKey(buildingID, "player")))

	if (pPlayer == nil) then
		return 0
	end

	-- The interrupt first -- live checks it first (obiwan_lair_boss.java:124-138).
	if (damage ~= nil and damage > self.lair.forceInterruptDamage and readData(self:lairKey(buildingID, "forceAtk")) ~= 0) then
		--[[ obiwan_lair_boss.java:124-138. One hit over 2000 while he is winding up
		     cancels the attack outright -- the queued row is dropped, he takes the
		     heavy-hit stagger, and the execute timer finds noForce set and re-winds
		     instead of firing. This is the encounter's only real mechanic: the player
		     is meant to save a hard hit for the windup tell. ]]
		writeData(self:lairKey(buildingID, "forceAtk"), 0)
		writeData(self:lairKey(buildingID, "noForce"), 1)
		CreatureObject(pBoss):doAnimation("anims.HUMAN_REA_STAND_COMBAT_GET_HIT_HEAVY")

		local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

		if (pObiwan ~= nil) then
			SceneObject(pObiwan):faceObject(pPlayer, true)
			spatialChat(pObiwan, self.lair.lines.obiBlockSpecial)
		end
	end

	--[[ The floor. Only during fight one. G(b2a)'s ladder makes phase a clean
	     discriminator: lairStartFight is scheduled from the phase-2 block, and
	     lairBeat increments after the block, so phase is 3 for the whole of fight
	     one and 5 for the whole of fight two. ]]
	if (readData(self:lairKey(buildingID, "phase")) == 3) then
		local maxHealth = CreatureObject(pBoss):getMaxHAM(0)

		if (maxHealth > 0 and CreatureObject(pBoss):getHAM(0) <= (maxHealth * self.lair.fightOneFloor)) then
			self:lairEndFightOne(buildingID, pPlayer, pBoss)
		end
	end

	-- Observer must survive fight one to police fight two.
	return 0
end

-- stopFighting, obiwan_lair_boss.java:192-207, plus the lightsCameraAction message
-- OnAboutToBeIncapacitated sends at :84.
function kenobiSpineScreenPlay:lairEndFightOne(buildingID, pPlayer, pBoss)
	-- That alone kills the taunt, praise and force chains at their next tick.
	writeData(self:lairKey(buildingID, "fight"), 0)
	writeData(self:lairKey(buildingID, "forceAtk"), 0)
	writeData(self:lairKey(buildingID, "noForce"), 1)
	-- clearCombatState takes a clearDefenders boolean (LuaAiAgent.cpp:103); live
	-- calls stopCombat(self) at :201.
	AiAgent(pBoss):clearCombatState(true)
	-- So he does not immediately re-acquire the player and swing at someone he
	-- cannot hurt.
	AiAgent(pBoss):setOblivious()
	SceneObject(pBoss):playEffect("clienteffect/pl_force_healing.cef", "")

	--[[ Live adds a flat 150000 (addToHealth(self, 150000)). Here that is a full
	     restore -- the pool is 44000-54000 and a flat number tuned to a 155000 boss
	     is meaningless against it. Same loop useCrystal already uses; stands in for
	     live's flat 150000. ]]
	local pools = { 0, 3, 6 }

	for i = 1, #pools do
		local pool = pools[i]
		local missing = CreatureObject(pBoss):getMaxHAM(pool) - CreatureObject(pBoss):getHAM(pool)

		if (missing > 0) then
			CreatureObject(pBoss):healDamage(missing, pool)
		end
	end

	TangibleObject(pBoss):setOptionBit(INVULNERABLE)
	spatialChat(pBoss, self.lair.lines.bossCannotDefeat)
	-- Advance the ladder at +2 s, live's delay (:84).
	createEvent(2 * 1000, "kenobiSpineScreenPlay", "lairBeat", pPlayer, buildingID .. ":" .. readData(self:lairKey(buildingID, "session")))
end

-- specialForcePowerAttackWindup, obiwan_lair_boss.java:311-355.
function kenobiSpineScreenPlay:lairForceWindup(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	if (not self:liveFight(buildingID, args)) then
		return
	end

	-- Live :314-318 -- the flag is consumed by whichever of windup/execute reaches
	-- it first. Clear and return without re-arming.
	if (readData(self:lairKey(buildingID, "noForce")) == 1) then
		writeData(self:lairKey(buildingID, "noForce"), 0)
		return
	end

	-- One queued attack at a time (:325-329).
	if (readData(self:lairKey(buildingID, "forceAtk")) ~= 0) then
		return
	end

	local row = getRandomNumber(1, #self.lair.forceAttacks)
	writeData(self:lairKey(buildingID, "forceAtk"), row)

	-- The tell -- anim and effect rolled independently of the row.
	CreatureObject(pBoss):doAnimation(self.lair.forceWindupAnims[getRandomNumber(1, #self.lair.forceWindupAnims)])
	SceneObject(pBoss):playEffect(self.lair.forceWindupEffects[getRandomNumber(1, #self.lair.forceWindupEffects)], "")

	-- obiwanWarnsOfSpecialAttack, obiwan_event_manager.java:281-300, messaged at
	-- delay 0 (obiwan_lair_boss.java:353).
	if (pObiwan ~= nil) then
		SceneObject(pObiwan):faceObject(pPlayer, true)
		spatialChat(pObiwan, self.lair.lines.obiLookoutSpecial)
	end

	createEvent(self.lair.forceExecuteDelay * 1000, "kenobiSpineScreenPlay", "lairForceExecute", pPlayer, args)
end

-- specialForcePowerAttackExecute, obiwan_lair_boss.java:356-438.
function kenobiSpineScreenPlay:lairForceExecute(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	if (not self:liveFight(buildingID, args)) then
		return
	end

	-- Player interrupted him. Clear and re-arm the windup. Live at :359-368.
	-- This is what the player earns by breaking the windup: the attack is lost.
	if (readData(self:lairKey(buildingID, "noForce")) == 1) then
		writeData(self:lairKey(buildingID, "noForce"), 0)
		createEvent(getRandomNumber(self.lair.forceWindupMin, self.lair.forceWindupMax) * 1000, "kenobiSpineScreenPlay", "lairForceWindup", pPlayer, args)
		return
	end

	local row = readData(self:lairKey(buildingID, "forceAtk"))

	if (row == 0) then
		return
	end

	writeData(self:lairKey(buildingID, "forceAtk"), 0)

	local attack = self.lair.forceAttacks[row]
	local damage = getRandomNumber(attack.minDamage, attack.maxDamage)

	--[[ Live builds a hit_result by hand and calls doDamage
	     (obiwan_lair_boss.java:421-430) so the attack bypasses the combat roll --
	     it is scripted, it always lands. inflictDamage is the equivalent here:
	     inflictDamage(pAttacker, damageType, damage, destroy), attacker read as
	     lightuserdata (LuaCreatureObject.cpp:46). damageType 0 is HEALTH
	     (DirectorManager.cpp:700); destroy 0, because the death path is the
	     player's normal one, not this call's. Same shape as
	     deathWatchBunker.lua:1427. ]]
	CreatureObject(pPlayer):inflictDamage(pBoss, 0, damage, 0)
	CreatureObject(pPlayer):playEffect(attack.effect, "")
	CreatureObject(pBoss):doAnimation(attack.animation)

	-- Re-arm the windup (:433).
	createEvent(getRandomNumber(self.lair.forceWindupMin, self.lair.forceWindupMax) * 1000, "kenobiSpineScreenPlay", "lairForceWindup", pPlayer, args)
end

-- randomTaunter, obiwan_lair_boss.java:236-276.
function kenobiSpineScreenPlay:lairTaunt(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	if (not self:liveFight(buildingID, args)) then
		return
	end

	-- Live rolls rand(1,10) and plays the laugh on > 5 (:258-262).
	if (getRandomNumber(1, 10) > 5) then
		CreatureObject(pPlayer):playEffect("clienteffect/mustafar/som_dark_jedi_laugh.cef", "")
	end

	spatialChat(pBoss, self.lair.lines.bossTaunts[getRandomNumber(1, #self.lair.lines.bossTaunts)])
	createEvent(getRandomNumber(self.lair.tauntMin, self.lair.tauntMax) * 1000, "kenobiSpineScreenPlay", "lairTaunt", pPlayer, args)
end

-- randomPraiser, obiwan_lair_boss.java:277-310. Live gates the praiser on the boss's
-- ignoreTaunt flag (:281) -- i.e. Obi-Wan goes quiet whenever the boss does. The
-- liveFight check covers the same ground here, because both chains die the moment
-- fight goes to 0.
function kenobiSpineScreenPlay:lairPraise(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	if (not self:liveFight(buildingID, args)) then
		return
	end

	if (pObiwan == nil) then
		return
	end

	spatialChat(pObiwan, self.lair.lines.obiSayings[getRandomNumber(1, #self.lair.lines.obiSayings)])
	createEvent(getRandomNumber(self.lair.praiseMin, self.lair.praiseMax) * 1000, "kenobiSpineScreenPlay", "lairPraise", pPlayer, args)
end

--[[ State

Persistent screenplay data on the player's ghost, so the arc survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0" on every read.

	stage         the STAGE_* ladder above, 0 = nothing started
	hermit        the HERMIT_* sub-state, only meaningful inside STAGE_HUNT
	spared        1 if the hermit handed the shard over, absent if he was killed for it
	<key>         per-conduit: 0 not begun, 1 charging, 2 charged
	tries         how many times an off-planet ambush has been re-armed
	wp            waypoint id currently handed out, absent if none
	crystal       finale choice: 0 unset, 1 destroyed, 2 taken (once)
	usedCrystal   1 if the player drew on the crystal during the fight
	crystalReady  1 once beat 2 unlocks the buff crystal (live readyToUseCrystal)
	lairCopy      building id of the lair copy the ladder is running in
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
	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_main_quest_1")
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
	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_main_quest_1")
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
	-- Quest XP: quest_experience[80][TIER_5]. See mustafar_quest_xp.lua.
	if (self:sparedTheHermit(pPlayer)) then
		MustafarQuestXp:award(pPlayer, "som_kenobi_main_quest_spared")
	else
		MustafarQuestXp:award(pPlayer, "som_kenobi_main_quest_killed")
	end

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
-- musicOnComplete is the success sting. The crystal choice is an epilogue after
-- this -- SOE unlocked dealWithCrystal at intermission 5, after the boss was
-- finished (obiwan_event_manager.java:221), and the .qst completes on the kill.
function kenobiSpineScreenPlay:bossKilled(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_LAIR) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE)
	-- Quest XP: quest_experience[80][TIER_5]. See mustafar_quest_xp.lua.
	if (self:sparedTheHermit(pPlayer)) then
		MustafarQuestXp:award(pPlayer, "som_kenobi_main_quest_3_b_visible")
	else
		MustafarQuestXp:award(pPlayer, "som_kenobi_main_quest_3_visible")
	end

	dropObserver(KILLEDCREATURE, "kenobiSpineScreenPlay", "notifyKilledCreature", pPlayer)

	CreatureObject(pPlayer):sendSystemMessage("Sinistro is dead. The Soul Crystal stands unguarded.")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")

	--[[ Event teardown. obiwan_event_manager.java:214-229 and obiSaysDestroyCrystal
	     :491-503. Live's buff.removeAllBuffs(player) at :222 is a no-op here, for the
	     reason the finale header block already records -- this tree has no Lua buff
	     API. ]]
	local buildingID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "lairCopy")) or 0

	if (buildingID ~= 0) then
		-- Bump session -- that one write kills every pending timer in the run,
		-- including any left over from the fight the player just won.
		writeData(self:lairKey(buildingID, "session"), readData(self:lairKey(buildingID, "session")) + 1)
		writeData(self:lairKey(buildingID, "fight"), 0)
		writeData(self:lairKey(buildingID, "forceAtk"), 0)
		writeData(self:lairKey(buildingID, "phase"), 6)
		-- Live strips readyToUseCrystal at beat 5 (:217-220) -- the crystal was a
		-- lifeline for the fight and the fight is over.
		writeScreenPlayData(pPlayer, self.screenplayName, "crystalReady", "0")
		-- Obi-Wan congratulates at +10 s. Live's delay is the one OnIncapacitated
		-- sends (obiwan_lair_boss.java:97), deliberately long so the death animation
		-- plays out first.
		createEvent(10 * 1000, "kenobiSpineScreenPlay", "lairObiCongratulates", pPlayer, buildingID .. ":" .. readData(self:lairKey(buildingID, "session")))
	end
end

-- Do not use the shared preamble's pBoss == nil or isDead bail: the boss is dead;
-- that is the point. liveLair, then the Obi-Wan pointer, nothing about the boss.
function kenobiSpineScreenPlay:lairObiCongratulates(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pObiwan == nil) then
		return
	end

	SceneObject(pObiwan):faceObject(pPlayer, true)
	spatialChat(pObiwan, self.lair.lines.obiWonCongrats)
	-- :228
	createEvent(3 * 1000, "kenobiSpineScreenPlay", "lairObiDestroyCrystal", pPlayer, args)
end

-- obiSaysDestroyCrystal, obiwan_event_manager.java:491-503.
function kenobiSpineScreenPlay:lairObiDestroyCrystal(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pObiwan == nil) then
		return
	end

	SceneObject(pObiwan):faceObject(pPlayer, true)
	spatialChat(pObiwan, self.lair.lines.obiDestroyCrystal)
	-- Live's playMusic at :500; playMusicMessage is the binding
	-- (LuaCreatureObject.cpp:36), and bossKilled already uses it.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_obi_wan_quest.snd")
	createEvent(getRandomNumber(self.lair.nagMin, self.lair.nagMax) * 1000, "kenobiSpineScreenPlay", "lairObiNag", pPlayer, args)
end

-- obiRepeatsDestroyCrystal, obiwan_event_manager.java:504-531. Live repeats until
-- the player deals with the crystal.
function kenobiSpineScreenPlay:lairObiNag(pPlayer, args)
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pObiwan == nil) then
		return
	end

	-- Stop if the player has already dealt with it. Key is 1 for destroyed and 2
	-- for taken (destroyCrystal, takeCrystal_finale). Live's equivalent is the
	-- dealWithCrystal scriptvar check at :516-519.
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crystal")) or 0) ~= 0) then
		return
	end

	-- Stop if the player has left the building -- live checks
	-- mustafar.stillWithinDungeonCheck (:520). Compare root parent against the copy.
	local pBuilding = SceneObject(pPlayer):getRootParent()

	if (pBuilding == nil or SceneObject(pBuilding):getObjectID() ~= buildingID) then
		return
	end

	spatialChat(pObiwan, self.lair.lines.obiDestroyCrystalShort)
	createEvent(getRandomNumber(self.lair.nagMin, self.lair.nagMax) * 1000, "kenobiSpineScreenPlay", "lairObiNag", pPlayer, args)
end

--[[ Finale crystal and exit stone

Sourced from obiwan_crystal_object.java / obiwan_exit_object.java /
obiwan_event_manager.java via obiwan_event_data.tab. The crystal is a three-state
object in live (readyToUseCrystal / dealWithCrystal / drainedCrystal). Here the
fight-time use is a full HAM restore and the post-boss choice is destroy-or-take,
each once. See R1-R6 in ROUND-GB1-SPEC.

Live crystal_buff (datatables/buff/buff.tab:378) cannot be ported: this tree has
no Lua buff API (valley_battlefield.lua:63-80; grep of LuaCreatureObject.cpp /
LuaPlayerObject.cpp finds no addBuff / applyBuff / hasBuff / removeBuff). Four of
its five effects (expertise_healing_all, expertise_damage_all,
combat_divide_damage_taken, expertise_glancing_blow_all) have no Core3 analogue
and are omitted. The fifth, health 90000, is approximated by a full heal rather
than by raising max HAM -- setMaxHAM exists (LuaCreatureObject.cpp:49, :436) but
a raise needs a guaranteed revert, and a logout, a death or a server restart
inside the 500 s window would leave the player permanently 90000 health over
cap. A missed revert is worse than a missing buff. Live's
buff.removeAllBuffs(player) at obiwan_event_manager.java:222 is a no-op here for
the same reason.
--]]

-- Live: theBigCrystalBuff / som_force_crystal_buff.cef
-- (obiwan_crystal_object.java:87). Once per player during the fight.
function kenobiSpineScreenPlay:useCrystal(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (self:getStage(pPlayer) ~= self.STAGE_LAIR) then
		return
	end

	--[[ Live sets readyToUseCrystal on the player at beat 2 only
	     (obiwan_event_manager.java:191) and strips it at the top of every other beat
	     (:147-150), so the crystal is a lifeline for the two fights and nothing else.
	     Without this gate the player could drain it before the first minion lands. ]]
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crystalReady")) or 0) ~= 1) then
		CreatureObject(pPlayer):sendSystemMessage("The crystal is dark. Whatever power it holds, it is not yours to take yet.")
		return
	end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "usedCrystal")) or 0) ~= 0) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "usedCrystal", "1")

	local pools = { 0, 3, 6 }

	for i = 1, #pools do
		local pool = pools[i]
		local missing = CreatureObject(pPlayer):getMaxHAM(pool) - CreatureObject(pPlayer):getHAM(pool)

		if (missing > 0) then
			CreatureObject(pPlayer):healDamage(missing, pool)
		end
	end

	CreatureObject(pPlayer):playEffect("clienteffect/mustafar/som_force_crystal_buff.cef", "")
	CreatureObject(pPlayer):sendSystemMessage("You draw on the crystal's power and feel your strength restored.")
end

-- Live destroyTheCrystal -> blowUpCrystal / obiCongratulatesPlayer
-- (obiwan_crystal_object.java, obiwan_event_manager.java:433-447). Grants
-- item_tow_crystal_uber_05_02 in live -- a static-item name with no object
-- template here, same situation collectors_business.lua:82-92 already ruled for
-- item_tow_holocron_ab_immune_02_01. Badge and scene only; item recorded for a
-- later static-item pass.
function kenobiSpineScreenPlay:destroyCrystal(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (self:getStage(pPlayer) ~= self.STAGE_DONE) then
		return
	end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crystal")) or 0) ~= 0) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "crystal", "1")

	self:grantFinaleBadge(pPlayer, self.goodBadge)

	CreatureObject(pPlayer):playEffect("clienteffect/mustafar/som_force_crystal_destruction.cef", "")
	CreatureObject(pPlayer):sendSystemMessage("Obi-Wan congratulates you. The Soul Crystal is destroyed.")
end

-- Named takeCrystal_finale so it does not shadow takeCrystal at the conduits.
-- Live takeTheCrystal -> playerGetsCrystal (obiwan_event_manager.java:414-431).
-- Grants item_tow_cystal_buff_drained_05_01 in live -- SOE's own typo, preserved.
-- Same static-item ruling as destroyCrystal / collectors_business.lua:82-92;
-- badge and scene only.
function kenobiSpineScreenPlay:takeCrystal_finale(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (self:getStage(pPlayer) ~= self.STAGE_DONE) then
		return
	end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crystal")) or 0) ~= 0) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "crystal", "2")

	self:grantFinaleBadge(pPlayer, self.badBadge)

	CreatureObject(pPlayer):playEffect("clienteffect/pl_force_healing.cef", "")
	CreatureObject(pPlayer):sendSystemMessage("Obi-Wan is disappointed. You take the drained crystal for yourself.")
end

-- Live obiwan_exit_object.java:26-42 calls
-- instance.requestExitPlayer("obiwan_crystal_cave", player). Equivalent here is
-- MustafarInstances:sendToExit (mustafar_instances.lua:708); the building is the
-- stone's root parent (LuaSceneObject.cpp:25, :451).
function kenobiSpineScreenPlay:leaveLair(pPlayer, pStone)
	if (pPlayer == nil or pStone == nil) then
		return
	end

	local pBuilding = SceneObject(pStone):getRootParent()

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		printLuaError("kenobiSpineScreenPlay: exit stone has no building parent; the player cannot leave the lair")
		return
	end

	MustafarInstances:sendToExit(pPlayer, pBuilding)
end

-- Badge keys arrive in Lua as uppercase globals holding their index
-- (DirectorManager.cpp:863-869), so the guard is "does this server's TRE set have
-- that badge_map row". Same shape as volcano_battlefield.lua:2984 and
-- story_arc_chapters.lua:1941. See goodBadge / badBadge above for why this cannot
-- be settled by grepping the repo.
function kenobiSpineScreenPlay:grantFinaleBadge(pPlayer, badgeKey)
	if (badgeKey == nil or _G[badgeKey] == nil) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	PlayerObject(pGhost):awardBadge(_G[badgeKey])
end

--[[ Radial dispatch

One component table serves six kinds of object: the dying miner, the spawned
mining computer, the three snapshot conduits, the finale crystal and the exit
stone. LuaObjectMenuComponent replaces the object's menu entirely, so
fillObjectMenuResponse has to add every item that should be there and add
nothing at all when this player has no business with the object. Each object's
role was written at start(); see getKenobiRole and the writeStringData calls in
the spawn functions.

Every string below is the .qst's own retrieveMenuText, except the miner's, which
is authored -- SOE gave him no menu text because they gave him nothing at all --
and the finale crystal / exit stone strings, which are authored from the live
menu keys (obiwan_finale_use_crystal / destroy / take / eject).
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

	if (role == "exitStone") then
		if (self:getStage(pPlayer) >= self.STAGE_LAIR) then
			return "Leave the chamber of the crystal"
		end

		return nil
	end

	if (role == "finaleCrystal") then
		local stage = self:getStage(pPlayer)

		if (stage ~= self.STAGE_LAIR and stage ~= self.STAGE_DONE) then
			return nil
		end

		if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crystal")) or 0) ~= 0) then
			return nil
		end

		-- STAGE_DONE is the two-item case; see getRadialItems.
		if (stage == self.STAGE_DONE) then
			return nil
		end

		if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "usedCrystal")) or 0) ~= 0) then
			return nil
		end

		return "Draw on the crystal's power"
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

--[[ Sibling of getRadialText for roles that need more than one menu item.
     getRadialText still serves every single-item role.

     THE IDS ARE 68 AND 69, NOT 21 AND 22. RadialOptions.h:15-92 is an enum, and
     20 is ITEM_USE -- which is why every single-item radial in this tree uses 20
     and why the exit stone keeps it (live used ITEM_USE for the stone too,
     obiwan_exit_object.java:29). But 21 and 22 are ITEM_USE_SELF and
     ITEM_USE_OTHER, real client menu types with their own meaning, not free
     slots. The free slots are SERVER_MENU1..10 at 68..77
     (RadialOptions.h:83-92). Live put the two crystal choices on SERVER_MENU1
     and SERVER_MENU2 (obiwan_crystal_object.java:34-35), so 68 and 69 are both
     correct here and the same pair SOE used. ]]
function kenobiSpineScreenPlay:getRadialItems(pPlayer, role)
	if (role ~= "finaleCrystal") then
		return nil
	end

	if (self:getStage(pPlayer) ~= self.STAGE_DONE) then
		return nil
	end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crystal")) or 0) ~= 0) then
		return nil
	end

	return {
		{ id = 68, text = "Destroy the Soul Crystal" },  -- SERVER_MENU1
		{ id = 69, text = "Take the Soul Crystal" },     -- SERVER_MENU2
	}
end

KenobiSpineMenuComponent = {}

function KenobiSpineMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":kenobiSpineRole")
	local items = kenobiSpineScreenPlay:getRadialItems(pPlayer, role)

	if (items ~= nil) then
		for i = 1, #items do
			LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(items[i].id, 3, items[i].text)
		end

		return
	end

	local text = kenobiSpineScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function KenobiSpineMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	-- 20 = ITEM_USE, 68/69 = SERVER_MENU1/2. See getRadialItems for why the two
	-- crystal choices are not 21 and 22.
	if (selectedID ~= 20 and selectedID ~= 68 and selectedID ~= 69) then
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

	elseif (role == "exitStone") then
		if (selectedID == 20) then
			kenobiSpineScreenPlay:leaveLair(pPlayer, pSceneObject)
		end

	elseif (role == "finaleCrystal") then
		if (selectedID == 20) then
			kenobiSpineScreenPlay:useCrystal(pPlayer)
		elseif (selectedID == 68) then
			kenobiSpineScreenPlay:destroyCrystal(pPlayer)
		elseif (selectedID == 69) then
			kenobiSpineScreenPlay:takeCrystal_finale(pPlayer)
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
