--[[
The Mustafar dungeon populator

WHAT THIS IS

Three of the Mustafar instance pools ship a server-side dungeon spawn table, and
until now nothing in this repo read them, so a player who entered any of those
buildings walked through empty rooms. This file spawns those tables' creature
rows into every copy of the matching pool.

SOURCE OF RECORD

_dsrc/sku.0/sys.server/compiled/game/datatables/spawning/dungeon/

    som_old_republic_facility.tab    42 creature rows  ->  old_republic_facility
    som_decrepit_droid_factory.tab   45 creature rows  ->  decrepit_droid_factory
    som_working_droid_factory.tab     1 creature row   ->  working_droid_factory

Every room name, position and heading below is QUOTED from those rows. Nothing
here is read off a .ilf and nothing here is placed by eye. Two of the five
Mustafar dungeon tables are not used here: som_mining_facility is the Mensix
facility, which is a snapshot building and not an instance pool, and
som_crash_site_cruiser carries no creature rows at all.

THE AXIS MAPPING  --  the one thing to get right

The tables' columns are loc_x, loc_y, loc_z, yaw, and loc_y is HEIGHT. This
repo's Lua argument order is x, z, y, heading, and z is height. So:

    repo x        <-  loc_x
    repo z        <-  loc_y     (height)
    repo y        <-  loc_z
    repo heading  <-  yaw

spawnMobile takes heading in DEGREES, so yaw goes across unconverted. This is
the opposite of spawnSceneObject, which takes radians and is why the terminals
in story_arc_chapters.lua are wrapped in math.rad and these creatures are not.

THE TEMPLATES ARE THIS TREE'S OWN

Every one of the seventeen names is defined in retail's
sys.server/compiled/game/datatables/mob/creatures.tab at BaseLevel 80-87:

    som_orf_ancient_security_drone   BaseLevel 85  NORMAL
    som_orf_ancient_patrol_drone     BaseLevel 84  NORMAL
    som_orf_ancient_sentinel_droid   BaseLevel 86  NORMAL
    som_orf_ancient_guard_droid      BaseLevel 87  ELITE
    som_orf_flea_hatchling           BaseLevel 83  NORMAL
    som_orf_flea_juvenile            BaseLevel 84  NORMAL
    som_orf_flea_starving            BaseLevel 85  NORMAL
    som_orf_beetle_hatchling         BaseLevel 84  NORMAL
    som_orf_beetle_worker            BaseLevel 85  NORMAL
    som_orf_beetle_soldier           BaseLevel 86  NORMAL
    som_orf_ancient_tulrus           BaseLevel 85  BOSS
    som_orf_ancient_xandank          BaseLevel 87  BOSS
    som_decrepit_battle_droid        BaseLevel 83  ELITE
    som_decrepit_super_battle_droid  BaseLevel 85  BOSS
    som_decrepit_cww8_combat_droid   BaseLevel 83  BOSS
    som_decrepit_blastromech         BaseLevel 81  ELITE
    som_decrepit_patrol_bot          BaseLevel 80  ELITE

The earlier "CHECKED absence" was checked against the client TRE set and this
repo and never against the retail server datatable, which is where creature
definitions actually live. An absence is only evidence once you know you have
read the whole list.

The seventeen are now authored as their own templates in
mobile/custom_content/som/, on this tree's STD 70 / ELITE 85 / BOSS 120 rungs,
mapped from retail's difficultyClass (NORMAL -> STD 70, ELITE -> ELITE 85,
BOSS -> BOSS 120). Retail's BaseLevel is recorded in each file's header and is
not copied into level.

The old claim that "all fifteen substitute templates are level 70" was also
wrong -- of those fifteen, five were level 70, seven were 85 and three were 50.
So the "consistent difficulty band" that sentence claimed the substitution
bought never existed. The band is consistent now, for the first time.

RESPAWN  --  one number, and it is a substitution of application, not of value

Live gives the 40 ordinary ORF rows respawn_time 600 and leaves the column blank
on everything else: the two ORF bosses (both carry the
mustafar_trials.old_republic_facility.boss_timer script) and all 46 factory rows
(static_guard, patrol_guard and observation_droid). Blank means the live instance
reset those rooms when the instance was released, and this pool has no reset --
a copy is claimed, cleared and handed to the next player as it stands.

So every row here gets 600. The number is not invented; it is the one these same
tables use. What is substituted is applying it to the rows live left blank, and
the alternative was worse: respawn 0 would mean the second player to be handed a
recycled copy finds a building that has already been cleared out.

THE PATROL PATHS ARE NOT HONOURED

Four rows carry a patrol_path objvar -- the two som_decrepit_cww8_combat_droid,
the som_decrepit_blastromech and the som_decrepit_patrol_bot. The paths name
waypoint sets (bridgeOne;bridgeTwo, roomOne..roomFour, controlOne..controlFive,
obsBotOne..obsBotFour) and the decrepit table spawns fifteen
object/tangible/ground_spawning/patrol_waypoint.iff rows to mark them, on lines
55-65 and 68-71.

Nothing in this tree reads that objvar, and the waypoint props are markers with
no behaviour attached. The four droids are therefore spawned STATIC, on the
position their own row gives. They stand where live started them and they do not
walk the route. The waypoints are not spawned, because a marker prop with no
patrol behind it is furniture that means nothing.

THE obsBot WAYPOINTS SIT IN THE OTHER TABLE

som_decrepit_patrol_bot is a working_droid_factory row, but its four waypoints
(lines 68-71, mainroom27, height -12) are in the DECREPIT table. That is not a
mistake in either file: the two tables describe the same building geometry in two
states, which is also why the working factory's own system_controller row names
the decrepit factory's template. See story_arc_chapters.lua for that one.

THE LIVE CELL TYPO IS PRESERVED

Rows 21 and 22 of the decrepit table give the cell as "smallrooom8" -- three o's.
It is spelled that way in the shipped table and it is spelled that way here,
because the cell name in the .pob is whatever the live server matched against.
Do not tidy it. If it turns out to be wrong the boot check below will say so by
name, and that is the moment to change it, not before.

THE BOOT COST  --  921 creatures, said out loud

The pools are 12, 9 and 12 copies deep, and every copy is furnished:

    old_republic_facility    42 rows x 12 copies  =  504
    decrepit_droid_factory   45 rows x  9 copies  =  405
    working_droid_factory     1 row  x 12 copies  =   12
                                                    ----
                                                     921

That is a real number and it is stated here rather than left to be discovered in
a profile. If it has to come down, the honest lever is the pool depth in
mustafar_instances.lua, not a quiet cull of rows in this file.

THE PROPS COST ANOTHER 366, added 2026-08-31

The same tables carry non-creature rows, and until now this file read only the
creature ones. The props tables below place the rest:

    old_republic_facility    21 rows x 12 copies  =  252
    decrepit_droid_factory   10 rows x  9 copies  =   90
    working_droid_factory     2 rows x 12 copies  =   24
                                                    ----
                                                     366

Same lever if it has to come down, and the same rule: pool depth, not a quiet cull.

WHAT IS DELIBERATELY NOT PLACED, so the difference between the tables and this
file is a decision and not a gap. Every one of these was read before it was
skipped:

  - The 59 patrol_waypoint rows across the three tables. They are invisible
    pathing markers for live's sequencer, which Core3 does not have -- the same
    case as the npe_node rows in som_mining_facility.tab, and the same call.
    THE PATROL PATHS ARE NOT HONOURED, above, is the reason; spawning the markers
    would not make them honoured, it would just put 59 invisible objects per copy
    in the world.

  - ORF table line 23, object/tangible/dungeon/avatar_platform/avatar_lockbox.iff.
    NOT PLACEABLE: no server template exists for it anywhere in this tree. A
    find for avatar_lockbox.lua under bin/scripts/object returns nothing and no
    addTemplate names it, so spawnSceneObject would return nil. This is the one
    row of the 34 that is a genuine missing asset rather than a decision.

  - ORF table line 17, terminal_bank_floor_on_01.iff in smallroom12. The SPOT is
    already occupied: story_arc_chapters.lua:533 puts its power terminal on
    exactly these coordinates, deliberately, and that entry says so -- it borrows
    live's position and wears must_control_computer instead. Placing the live
    template too would stack two objects on one point.

  - Five decrepit rows and three working rows already placed elsewhere; the props
    tables name them individually, with the file and line that owns each.

WHAT IT DOES TO THE KILL COUNTERS  --  checked, one by one, before writing

Substituting means these creatures answer to template names that other Mustafar
screenplays already count kills against.

HOW THIS LIST WAS BUILT, because the first attempt at it was wrong. Grepping the
tree for each substituted template STRING misses any screenplay that resolves the
name at runtime instead of writing it out -- and historian.lua is exactly that
case, because it now asks getSubstitute rather than carrying "union_sentry_droid"
as a literal. The sound basis is the call site, not the string: the 15 Mustafar
screenplays that call AiAgent:getCreatureTemplateName, each read against the
substitutes table. Those are blackguard_problem, bounty_hunts, glyph_hunt,
historian, kenobi_spine, maneater, map_exploration, reunite_shard, samaritan,
serpent_shard, som_poison_miners, storm_lord, story_arc_chapters,
story_arc_prelude and trophy_hunts. Nine of them reference no substituted name at
all; the six that do are below.

An earlier revision of this section called itself "the whole list" and was not. It
omitted historian.lua and maneater.lua. Both are named now.

  GONE. This slot used to describe story_arc_chapters countDroid, which credited
  cww8_battle_droid, cww8a_battle_droid and cww8a_eradicator -- the same three
  templates the decrepit factory uses -- and argued the overlap was unreachable
  because both factory pools are shut at STAGE_DROID_ARMY (16). Round F1(c)
  deleted countDroid outright: stage 16 is now the Valley Battlefield, an off-map
  arena with its own eleven-wave roster, and nothing in this tree counts kills at
  that stage any more. There is no overlap left to argue about.

  REACHABLE and left alone, because live worked this way. The Old Republic
  Facility is ungated, and it now holds fleas and kubaza beetles. So its kills feed
  samaritan's flea hunt, story_arc_chapters countKubaza, and the flea, beetle,
  tulrus and xandank rows of map_exploration and bounty_hunts.

  maneater.lua belongs in that same group and was missed the first time. Its
  tulrusTemplates set names orf_tulrus outright (maneater.lua:249) and
  creditStomachContents fires on any of them at STAGE_STOMACHS
  (maneater.lua:503-515). The ORF's two som_orf_ancient_tulrus rows now stand up as
  orf_tulrus, so they credit the stomach hunt from inside the facility. Same
  reasoning as the rest of this group -- live matched a social group, so an indoor
  tulrus counting is faithful -- but it is an added kill source and saying so is
  the point of this section.

  INTENDED, and the reason this file exists. historian.lua counts kills against
  the ORF security droid (historian.lua:1000), and the template it compares to is
  the one it asks this file for. That is not an accidental overlap -- it is the
  seam, and it is why getSubstitute is public. Its guard fails closed: an
  unresolved substitution leaves the template "", which matches no creature name,
  so an unpopulated facility credits nothing rather than crediting everything.

  That is not a loophole this file opened by accident. Every one of those tasks
  matches a live Social Group, not a template -- samaritan.lua:43 and
  map_exploration.lua:147 both say so outright -- and a social group match credits
  the species wherever it stands, indoors included. The template sets in those
  files are this tree's way of spelling a social group it has no field for. So
  crediting an ORF flea for a flea hunt is the faithful behaviour, not a bug.

  What is genuinely unknown, and is stated rather than papered over: live's own ORF
  creatures were som_orf_flea_* and som_orf_beetle_*, and since no definition for
  them ships anywhere, there is no way to check whether they carried the same
  social group as the surface ones. If they did not, these kills should not count
  and the substitution is what makes them. Nobody can settle that from what ships.

  ALREADY GUARDED. jedi_dog's Cobak is an orf_xandank matched by objectID rather
  than by template, precisely so an ordinary orf_xandank cannot be mistaken for him
  (jedi_dog.lua:459). The ORF's own xandank is one more ordinary one and the guard
  already covers it.

  SPAWN-ONLY, so no counter to disturb. Three more screenplays name a substituted
  template but never call getCreatureTemplateName, so they cannot mis-credit
  anything: cursed_shard spawns lava_flea_smoldering as scripted ambushers,
  lava_beetle_nests spawns kubaza_soldier_beetle at its nests and tracks them by
  objectID, and hidden_treasure spawns the two som_ancient_guardian droids from
  levers. Checked rather than assumed, and listed so the absence is on the record.

WHAT THIS FIXES ELSEWHERE

historian.lua used to spawn four union_sentry_droid on an invented aisle in
smallroom6, because its quest one needs killable ORF security and nothing
populated the building. Live puts no droid in that room at all. That picket line
is retired: the ORF's six real security drone rows now stand in the halls and
stairwells live puts them in, and historian.lua asks this file for the template
rather than carrying its own.
--]]

MustafarDungeonPopulation = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "MustafarDungeonPopulation",

	-- See RESPAWN in the header for why this is one number and why it is 600.
	respawn = 600,

	--[[ Every one of the seventeen now has its own template in
	     mobile/custom_content/som/. The mapping is identity. The
	     seventeen-onto-fifteen collapse is retired, and with it the three flea
	     stages sharing one body and the two patrol droids sharing asn_121.
	     Keyed by the live creature name so historian.lua can still ask by live
	     name; leave the table in place so a future substitution can be
	     reintroduced without call-site changes. ]]
	substitutes = {
		som_orf_ancient_security_drone = "som_orf_ancient_security_drone",
		som_orf_ancient_patrol_drone = "som_orf_ancient_patrol_drone",
		som_orf_ancient_sentinel_droid = "som_orf_ancient_sentinel_droid",
		som_orf_ancient_guard_droid = "som_orf_ancient_guard_droid",
		som_orf_flea_hatchling = "som_orf_flea_hatchling",
		som_orf_flea_juvenile = "som_orf_flea_juvenile",
		som_orf_flea_starving = "som_orf_flea_starving",
		som_orf_beetle_hatchling = "som_orf_beetle_hatchling",
		som_orf_beetle_worker = "som_orf_beetle_worker",
		som_orf_beetle_soldier = "som_orf_beetle_soldier",
		som_orf_ancient_tulrus = "som_orf_ancient_tulrus",
		som_orf_ancient_xandank = "som_orf_ancient_xandank",
		som_decrepit_battle_droid = "som_decrepit_battle_droid",
		som_decrepit_super_battle_droid = "som_decrepit_super_battle_droid",
		som_decrepit_cww8_combat_droid = "som_decrepit_cww8_combat_droid",
		som_decrepit_blastromech = "som_decrepit_blastromech",
		som_decrepit_patrol_bot = "som_decrepit_patrol_bot",
	},

	--[[ The rows.

	     Positional, because 88 rows of named fields is a wall. The order is:

	         { live name, cell, x, z (height), y, heading }

	     which is the argument order spawnMobile wants, so the call below reads
	     straight down the row. See THE AXIS MAPPING for how that came off the
	     table's loc_x / loc_y / loc_z / yaw. ]]
	pools = {
		{
			key = "old_republic_facility",
			label = "Old Republic Facility",
			table = "som_old_republic_facility.tab",
			rows = {
				{ "som_orf_ancient_patrol_drone", "hall5", 72.5602, 1.36e-06, -12.4439, -95.2087 },
				{ "som_orf_ancient_patrol_drone", "stairwell9", 83.2446, 2.67e-06, -20.3049, -0.942447 },
				{ "som_orf_ancient_patrol_drone", "stairwell9", 79.5881, 2.67e-06, -20.3624, 0.342858 },
				{ "som_orf_ancient_patrol_drone", "stairwell9", 115.958, -15.4, -14.9049, -89.3611 },
				{ "som_orf_ancient_patrol_drone", "stairwell9", 116.005, -15.4, -20.0668, -93.3621 },
				{ "som_orf_ancient_security_drone", "stairwell9", 79.2124, -33.6, -12.822, 89.3377 },
				{ "som_orf_ancient_security_drone", "hall16", 65.8556, -33.6, -5.90335, 178.521 },
				{ "som_orf_ancient_security_drone", "hall16", 65.7673, -33.6, -19.5551, 0.0712092 },
				{ "som_orf_flea_hatchling", "mediumroom13", 71.3957, -33.6, -57.3126, -89.8737 },
				{ "som_orf_flea_hatchling", "mediumroom13", 65.8335, -33.6, -63.7536, -0.700104 },
				{ "som_orf_flea_hatchling", "mediumroom13", 59.9731, -33.6, -57.4082, 88.8224 },
				{ "som_orf_ancient_security_drone", "hall18", 43.3881, -33.6, 3.36468, 179.921 },
				{ "som_orf_flea_hatchling", "smallroom21", 35.3151, -33.6, 40.5773, 82.9017 },
				{ "som_orf_flea_hatchling", "smallroom21", 37.3895, -33.6, 37.9687, 90.4021 },
				{ "som_orf_flea_hatchling", "smallroom21", 48.696, -33.6, 38.2986, -79.2864 },
				{ "som_orf_flea_hatchling", "smallroom21", 49.996, -33.6, 40.9447, -93.8659 },
				{ "som_orf_flea_juvenile", "smallroom22", 43.3875, -33.6, 70.4481, -178.968 },
				{ "som_orf_flea_juvenile", "smallroom22", 43.2608, -33.6, 74.1411, -1.57892 },
				{ "som_orf_flea_juvenile", "smallroom22", 47.3292, -33.6, 74.1451, -91.8183 },
				{ "som_orf_ancient_security_drone", "hall23", 65.799, -33.6, 63.3494, -0.331458 },
				{ "som_orf_ancient_security_drone", "hall15", 71.684, -33.6, 46.2119, -89.9146 },
				{ "som_orf_flea_starving", "smallroom20", 80.1556, -33.6, 52.032, 178.863 },
				{ "som_orf_flea_starving", "smallroom20", 82.8371, -33.6, 54.3125, 178.217 },
				{ "som_orf_flea_starving", "smallroom20", 88.3484, -33.6, 40.665, -4.58632 },
				{ "som_orf_ancient_sentinel_droid", "stairwell9", 117.042, -49, -18.601, -90.1923 },
				{ "som_orf_ancient_sentinel_droid", "stairwell9", 79.7225, -67.2, -19.0654, 91.3719 },
				{ "som_orf_ancient_sentinel_droid", "stairwell9", 79.8142, -67.2, -12.9863, 86.1028 },
				{ "som_orf_ancient_sentinel_droid", "hall29", 65.8465, -67.2, -6.26405, 178.532 },
				{ "som_orf_beetle_hatchling", "mediumroom28", 42.7916, -67.2, -6.98892, 177.621 },
				{ "som_orf_beetle_hatchling", "mediumroom28", 39.4511, -67.2, -4.5539, -91.311 },
				{ "som_orf_beetle_hatchling", "mediumroom28", 35.1958, -67.2, -31.5741, -1.04592 },
				{ "som_orf_beetle_hatchling", "mediumroom28", 35.0055, -67.2, -40.1574, -0.39907 },
				{ "som_orf_ancient_sentinel_droid", "hall26", 42.3869, -67.2143, 17.0288, -93.8611 },
				{ "som_orf_ancient_guard_droid", "hall33", 75.5108, -67.2096, 46.3429, -91.1521 },
				{ "som_orf_ancient_guard_droid", "hall27", 56.989, -67.2, 46.3992, 88.5659 },
				{ "som_orf_beetle_worker", "smallroom34", 42.0545, -67.2, 61.4253, 92.3731 },
				{ "som_orf_beetle_worker", "smallroom34", 56.7947, -67.2, 61.2674, -92.6 },
				{ "som_orf_beetle_soldier", "smallroom34", 56.3847, -67.2, 76.3102, -95.6153 },
				{ "som_orf_beetle_soldier", "smallroom34", 41.5876, -67.2, 76.1579, 88.5404 },
				{ "som_orf_ancient_tulrus", "smallroom31", 90.5268, -67.2, 39.762, 49.0762 },
				{ "som_orf_ancient_guard_droid", "hall10", 96.637, 8.22e-07, 23.8312, 179.58 },
				-- The boss of smallroom6, and the reason historian.lua's picket line
				-- was wrong: the room's guard is this, on a boss timer, not a line of
				-- four sentries. The Log Access Terminal and the Main Computer
				-- Terminal share the room with him.
				{ "som_orf_ancient_xandank", "smallroom6", 90.9704, -4.77e-07, 31.9041, 91.3982 },
			},

			--[[ The non-creature rows of the same table. Added 2026-08-31.

			     Same row shape as the creature rows above -- template, cell, x, z,
			     y, heading in DEGREES -- but row[1] is a full template path rather
			     than a live creature name, so nothing is substituted and nothing is
			     looked up. These are transcribed straight across; see THE AXIS
			     MAPPING for why the columns read in that order.

			     Rows 3-16 are the facility's own terminals; 18-24 are stock
			     furniture. Table line numbers are given so each row can be read back
			     against som_old_republic_facility.tab. ]]
			props = {
				-- core_room_terminal, table lines 3-10.
				{ "object/tangible/dungeon/mustafar/old_republic_facility/core_room_terminal.iff", "hall2", 43.9517, 4.93316, 17.231, -180 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/core_room_terminal.iff", "hall16", 65.3722, -28.6669, -3.66235, 90 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/core_room_terminal.iff", "hall15", 66.2821, -28.6669, 37.2615, -90 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/core_room_terminal.iff", "hall29", 65.3563, -62.2668, -3.66889, 90 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/core_room_terminal.iff", "hall26", 43.9561, -62.2784, 17.2767, -180 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/core_room_terminal.iff", "hall25", 87.6775, -62.2668, 16.336, 0 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/core_room_terminal.iff", "hall30", 66.2638, -62.2668, 37.2672, -89.9999 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/core_room_terminal.iff", "hall10", 87.6878, 4.93316, 16.3464, 0 },
				-- door_terminal, table lines 11-16.
				{ "object/tangible/dungeon/mustafar/old_republic_facility/door_terminal.iff", "hall11", 43.9489, -0.0632455, -31.6957, -90 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/door_terminal.iff", "hall19", 45.7174, -33.6633, 32.9905, -180 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/door_terminal.iff", "hall15", 74.7514, -33.6632, 43.9072, -90 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/door_terminal.iff", "hall32", 48.4885, -67.2536, -10.3049, 90 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/door_terminal.iff", "hall33", 83.1517, -67.2632, 43.9046, -90 },
				{ "object/tangible/dungeon/mustafar/old_republic_facility/door_terminal.iff", "hall25", 98.9155, -67.2632, 32.7319, -180 },
				-- Stock furniture, table lines 18-22 and 24.
				{ "object/tangible/furniture/cheap/chest_s01.iff", "mediumroom13", 75.6987, -32.6513, -46.0712, -93.4377 },
				{ "object/tangible/furniture/decorative/diagnostic_screen.iff", "smallroom22", 33.9066, -32.8727, 77.0979, 147.823 },
				{ "object/tangible/furniture/decorative/professor_desk.iff", "smallroom20", 95.9049, -33.6, 54.5825, -132.353 },
				{ "object/tangible/furniture/terminal/terminal_bank_wall_on_02.iff", "mediumroom28", 31.8932, -68.0538, -30.9565, 90 },
				{ "object/tangible/furniture/terminal/terminal_bank_wall_on_01.iff", "smallroom34", 47.6444, -67.5795, 78.9949, -180 },
				{ "object/tangible/furniture/terminal/terminal_bank_wall_on_01.iff", "smallroom6", 95.2071, -0.411096, 49.6319, -180 },
				-- Table line 68. The entrance wall terminal. storyArcChapters' own
				-- orfContact stand-in also sits in this cell, at 22.4 / 0.0 / -4.16;
				-- it is a different object at a different spot and both stand.
				{ "object/tangible/dungeon/wall_terminal_s4.iff", "entrance", 2.0015, 0, 4.22289, 90 },
			},
		},
		{
			key = "decrepit_droid_factory",
			label = "Decrepit Droid Factory",
			table = "som_decrepit_droid_factory.tab",
			rows = {
				{ "som_decrepit_battle_droid", "mainroom27", 24.6, -12, 22.9452, 91.0701 },
				{ "som_decrepit_battle_droid", "mainroom27", 24.6, -12, 7.01178, 86.0635 },
				{ "som_decrepit_battle_droid", "mainroom27", 24.6, -12, -8.96084, 90.8119 },
				{ "som_decrepit_battle_droid", "mainroom27", 39.9472, -12, -24.4, 0.447668 },
				{ "som_decrepit_battle_droid", "mainroom27", 56.0569, -12, -24.4, 0.624761 },
				{ "som_decrepit_battle_droid", "mainroom27", 71.9548, -12, -24.4, 0.768058 },
				{ "som_decrepit_battle_droid", "mainroom27", 87.4, -12, -9.02146, -89.5659 },
				{ "som_decrepit_battle_droid", "mainroom27", 87.4, -12, 7.01661, -89.6275 },
				{ "som_decrepit_battle_droid", "mainroom27", 87.4, -12, 22.9982, -89.3054 },
				{ "som_decrepit_battle_droid", "mainroom27", 72.0142, -12, 38.4, -179.763 },
				{ "som_decrepit_battle_droid", "mainroom27", 56.0475, -12, 38.4, -179.528 },
				{ "som_decrepit_battle_droid", "mainroom27", 39.9806, -12, 38.4, -179.462 },
				{ "som_decrepit_battle_droid", "smallroom4", 109.223, -20, -5.48711, -89.9227 },
				{ "som_decrepit_battle_droid", "smallroom4", 109.4, -20, 3.10089, -89.8395 },
				{ "som_decrepit_battle_droid", "smallroom3", 127.4, -20, 6.89296, -90.0033 },
				{ "som_decrepit_battle_droid", "smallroom3", 112.6, -20, 7.00646, 89.8807 },
				{ "som_decrepit_battle_droid", "smallroom6", 127.4, -28, 58.9771, -89.9786 },
				{ "som_decrepit_battle_droid", "smallroom6", 112.6, -28, 59.1363, 91.0472 },
				-- "smallrooom8", three o's, exactly as the shipped table spells it.
				-- See THE LIVE CELL TYPO IS PRESERVED.
				{ "som_decrepit_super_battle_droid", "smallrooom8", 87.3301, -36, 58.3628, -134.503 },
				{ "som_decrepit_super_battle_droid", "smallrooom8", 72.6439, -36, 43.6632, 45.4309 },
				{ "som_decrepit_battle_droid", "mediumroom10", 87.4, -38, -53.0858, -89.4356 },
				{ "som_decrepit_battle_droid", "mediumroom10", 71.9137, -38, -68.4, 0.570817 },
				{ "som_decrepit_battle_droid", "mediumroom10", 56.0017, -38, -68.4, -0.410217 },
				{ "som_decrepit_battle_droid", "mediumroom10", 40.6, -38, -52.9009, 90.7956 },
				{ "som_decrepit_battle_droid", "mediumroom10", 55.996, -38, -37.6, -179.37 },
				{ "som_decrepit_battle_droid", "mediumroom10", 72.0738, -38, -37.6, -179.581 },
				{ "som_decrepit_super_battle_droid", "smallroom14", 8.70194, -36, -25.6052, 134.38 },
				{ "som_decrepit_super_battle_droid", "smallroom14", 23.3473, -36, -40.3456, -44.7019 },
				{ "som_decrepit_battle_droid", "smallroom16", 24.6, -36, 57.1493, 90.7848 },
				{ "som_decrepit_battle_droid", "smallroom16", 39.4, -36, 56.9754, -89.6718 },
				{ "som_decrepit_battle_droid", "mediumroom18", -4.6, -28, 41.06, -89.6717 },
				{ "som_decrepit_battle_droid", "mediumroom18", -19.9927, -28, 56.4, -179.108 },
				{ "som_decrepit_battle_droid", "mediumroom18", -35.4, -28, 40.9307, 90.7961 },
				{ "som_decrepit_battle_droid", "mediumroom18", -35.4, -28, 6.9872, 92.5073 },
				{ "som_decrepit_battle_droid", "mediumroom18", -19.9518, -28, -8.39999, 1.19081 },
				{ "som_decrepit_battle_droid", "mediumroom18", -4.6, -28, 7.08912, -89.4358 },
				{ "som_decrepit_super_battle_droid", "mainroom27", 70.2827, -24, 5.01711, 92.2352 },
				{ "som_decrepit_super_battle_droid", "mainroom27", 70.1307, -24, 9.08402, 91.463 },
				{ "som_decrepit_super_battle_droid", "smallroom20", 21.3102, -24, -8.38273, -46.8388 },
				{ "som_decrepit_super_battle_droid", "smallroom20", 21.2929, -24, 6.4, -139.885 },
				{ "som_decrepit_super_battle_droid", "smallroom20", 6.62137, -24, 6.31427, 135.381 },
				{ "som_decrepit_super_battle_droid", "smallroom20", 6.69044, -24, -8.38334, 44.5929 },
				-- The three patrol_guard rows. Spawned static; see THE PATROL PATHS
				-- ARE NOT HONOURED. Live walked them bridgeOne;bridgeTwo,
				-- roomOne..roomFour and controlOne..controlFive respectively.
				{ "som_decrepit_cww8_combat_droid", "mainroom27", 31.6079, -36, 25.8964, 178.408 },
				{ "som_decrepit_cww8_combat_droid", "mediumroom18", -11.0435, -28, 7.27548, -179.47 },
				{ "som_decrepit_blastromech", "mainroom27", 32.0532, -24, 15.171, 85.9483 },
			},

			--[[ Table lines 45-54. The five rows this table has that are NOT here --
			     66 master_power_core, 67 system_controller, 75 the exit_terminal
			     access_controller, 76 security_controller, 77 the interior door --
			     are all already placed elsewhere and must not be doubled:
			     story_arc_chapters.lua:1101/1116/1117 furnishes the first, second and
			     fourth in every copy, and mustafar_instances.lua:374-408 owns the
			     door and the exit terminal because they are the instance's own
			     entrance furniture. ]]
			props = {
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/access_controller.iff", "hall1", 20.1561, -11.6521, 32.9993, 179.909 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/data_terminal.iff", "smallroom26", 87.6575, -11.7154, -35.2566, -89.9544 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/data_terminal.iff", "smallroom21", 105.696, -12, 31.2636, -91.1002 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/access_controller.iff", "mainroom27", 88.0126, -11.7154, -14.1607, -89.9543 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/data_terminal.iff", "smallroom23", 31.9562, -12, 56.6959, -179.909 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/access_controller.iff", "smallroom4", 93.0999, -19.6205, -0.983778, 89.3814 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/security_scanner.iff", "smallroom4", 99, -19.6703, -9.11545, -90.5273 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/security_scanner.iff", "smallroom4", 99, -19.6205, 7.12086, 90.7094 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/access_controller.iff", "smallroom11", 79.8117, -38, -86.8533, 0 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/environmental_controller.iff", "smallroom12", 48.0129, -38, -86.9426, 0 },
			},
		},
		{
			key = "working_droid_factory",
			label = "Working Droid Factory",
			table = "som_working_droid_factory.tab",
			rows = {
				-- The whole creature population of the working factory: one
				-- observation droid. The building is not meant to be fought
				-- through -- the arc sends the player to a terminal in it, and the
				-- decrepit table is the same geometry with the fight in it.
				-- Spawned static; its obsBotOne..obsBotFour route is not walked.
				{ "som_decrepit_patrol_bot", "mainroom27", 26.3758, -12, 23.2726, 109.317 },
			},

			--[[ Table lines 3 and 43. Both name the DECREPIT factory's
			     access_controller at coordinates the decrepit table also carries --
			     the same duplication the header describes, and not a mistake in
			     either file. They are still placed from here, because a working
			     factory copy is a different building from a decrepit one and gets
			     its own furniture.

			     Line 4's system_controller is placed by
			     story_arc_chapters.lua:1101, line 9's exit_terminal and line 44's
			     interior door by mustafar_instances.lua. Those three are not here.

			     The five rows below are the fight furniture of the three boss
			     encounters -- the Devistator's repair module and inhibitor supply,
			     the MDE's two cloners, and the Doom Bringer's destruction pile.
			     Live creates them from working_controller.java at the same boss_wp
			     waypoints as their bosses, not from a separate table. The cloner1
			     waypoint is also where som_working_super_repair_droid already stands
			     (existing lairBosses entry); the station and the droid share the
			     point in live too, so that is not a collision to fix. ]]
			props = {
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/access_controller.iff", "mainroom27", 88.0126, -11.7154, -14.1607, -89.9543 },
				{ "object/tangible/dungeon/mustafar/decrepit_droid_factory/access_controller.iff", "hall1", 20.1561, -11.6521, 32.9993, 179.909 },
				{ "object/tangible/dungeon/mustafar/working_droid_factory/reactive_repair_module.iff", "smallroom6", 119.986, -28, 73.0647, 180 },
				{ "object/tangible/dungeon/mustafar/working_droid_factory/inhibitor_storage.iff", "smallroom4", 95.4285, -20, -0.959162, 0 },
				{ "object/tangible/dungeon/mustafar/working_droid_factory/rapid_assembly_station.iff", "smallroom11", 80.0664, -38, -84.7532, 0 },
				{ "object/tangible/dungeon/mustafar/working_droid_factory/rapid_assembly_station.iff", "smallroom12", 47.9865, -38, -84.7016, 0 },
				{ "object/tangible/dungeon/mustafar/working_droid_factory/radioactive_pile.iff", "mediumroom18", -20.0197, -28, 40.8667, 0 },
			},
		},
	},

	--[[ Lair bosses -- fixed-point, one-per-copy spawns whose position is a
	     single attested point rather than a table row set.

	     spawnLairBoss places one spawn per copy of a named pool, cell resolved
	     by name, spawnMobile with a direct template name and degrees. Most of
	     the entries below come straight from
	     datatables/spawning/dungeon/som_working_droid_factory.tab boss_wp rows
	     (read through working_droid_factory/working_controller.java) or from
	     hardcoded live java in the decrepit factory. Sher Kar and his four
	     guards are the exception: there is no monster_lair dungeon table.

	     SHER KAR HAS NEITHER A POOL TABLE NOR A SUBSTITUTE KEY. There is no
	     monster_lair dungeon table at all -- the only SoM ones are
	     som_crash_site_cruiser, som_decrepit_droid_factory, som_mining_facility,
	     som_old_republic_facility and som_working_droid_factory -- and the
	     single row anywhere in the live datatables that mentions him at all is
	     "som_sherkar_consort 5" in ground_spawning/types/mustafar/malfosa.tab,
	     which is his consort and not him. Putting him in `pools` would mean
	     writing a `table` field that names a file that does not exist, and
	     inventing a live name for `substitutes` to key on. Both would be lies
	     in the shape of evidence, so he and his guards stay in this list.

	     THE CREATURE IS FINISHED AND SHIPPED. sher_kar.lua is level 200 (RAID on
	     the ladder), baseHAM 160000/195000, damage 1145/2000, baseXp 19008,
	     PACK + STALKER + KILLER, loot dark_jedi_tier_5 / force_tier_4 / crystals at
	     lootChance 10000000. Nothing about it needed authoring; it was simply
	     unreachable, because mustafar_instances.lua had `entry = nil` and nothing
	     placed him. Both halves are fixed together or neither is worth doing.

	     THE POINT IS NOW SOURCED, and it used to be ours. It is corrected here.
	     The old note said "THE POINT IS OURS ... there is no monster_lair dungeon
	     spawn table", and put him at x -86.3 / h -3.22 / y -205.0, a point fitted
	     from the 44 ground-resting props of the nest in must_monster_lair.ilf.
	     That search was in the wrong tree. The SoM trials keep their spawn data in
	     datatables/dungeon/mustafar_trials/<system>/, NOT in
	     datatables/spawning/dungeon/, and
	     datatables/dungeon/mustafar_trials/sher_kar/sher_kar_data.tab does exist.
	     Its first row is
	         area_spawner.iff  r1  locx -103.559  locy -10.1731  locz -164.703
	         string:spawn_point=sher_kar
	     which monster_manager.java:54-67 reads to place som_sherkar, then
	     setYaw(sherKar, -10). That is the point and the heading used below.

	     THE OLD FIT WAS NOT WRONG, WHICH IS WHY IT IS WORTH SAYING SO. The plane
	     it produced, floor h = -3.74 + -0.1966*(y + 202.35), predicts live's own
	     attested heights outside the region it was fitted on: at guard0
	     (y -128.367) it gives -18.29 against live's -18.2924, and at guard4
	     (y -133.004) it gives -17.37 against live's -17.1073. It only diverges far
	     up the tunnel, where the floor flattens -- at guard1 (y -62.5382) it says
	     -31.23 and live says -17.7027. So the axis mapping and the units in this
	     file are independently confirmed, and live's own numbers are used wherever
	     they exist because they are measurements and the plane is an inference.

	     The player still arrives at x -86.3 / h -5.19 / y -195.5, the near edge of
	     the nest -- that point is still ours and is unchanged. Sher Kar now stands
	     about 43 m up the tunnel from it with his four guards spread between 38 m
	     and 120 m out, which is the shape live's own table gives. Cell "r1" is the
	     building's only cell, all 456 .ilf nodes are in it.

	     THE CONSORT IS NOT MISSING FROM HERE, and the note that used to stand in
	     this spot was wrong on its premise. It read malfosa.tab as evidence that
	     the live lair held a consort population. It is not: malfosa.tab sits under
	     datatables/spawning/ground_spawning/types/mustafar/, which is the
	     open-world spawn system, not a dungeon table. Live spawns the lair from
	     monster_manager.java -- som_sherkar, som_sherkar_praetorian,
	     som_sherkar_karling and som_sherkar_symbiot -- and never a consort. The
	     four guards are now placed alongside him, which is what
	     monster_manager.java:54-95 does.

	     som_sherkar_consort now ships, as the open-world boss it actually is:
	     mobile/custom_content/som/som_sherkar_consort.lua, placed by
	     screenplays/mustafar/regions/malfosa_region.lua at (-3080.66, 5353.76),
	     which is buildout row mustafar_main_nw.tab:13 resolved through the
	     areas_mustafar.tab offset. The derivation is written out in full there. ]]
	lairBosses = {
		{
			poolKey = "monster_lair",
			label = "Sherkar's Lair",
			template = "sher_kar",
			cell = "r1",
			x = -103.559, z = -10.1731, y = -164.703, heading = -10,
		},
		--[[ Sher Kar's four guards. Source:
		     datatables/dungeon/mustafar_trials/sher_kar/sher_kar_data.tab, the
		     four minefield_spawner.iff rows carrying
		     string:spawn_point=guard0/1/3/4, read through
		     sher_kar/monster_manager.java:54-95, which allocates
		     obj_id[] guards = new obj_id[4] and assigns by index: type 0 and 1
		     -> som_sherkar_praetorian, type 2 -> som_sherkar_karling, type 3 ->
		     som_sherkar_symbiot.

		     The table has guard0, guard1, guard3 and guard4 -- there is no
		     guard2. That gap is live's own and is not a transcription error
		     here. The table also carries seven karling0..karling6 markers.
		     Nothing in live reads them -- monster_manager.java only ever looks
		     for sher_kar and guard*. They are dead markers, and the four
		     spawnAdd / praetorianDied / lifeSapperDied messages that would have
		     used them are never sent. Not ported, on purpose.

		     Live calls ai_lib.establishAgroLink(guards[0], guards); Core3 has
		     no binding, so the four carry PACK instead -- the same substitution
		     recorded elsewhere in this tree.

		     THE HEADINGS ARE COMPUTED, NOT COPIED, and that is deliberate. Every
		     guard row in the table carries yaw 0, but live never uses it: each
		     branch of spawnGuards ends in
		     faceTo(guards[type], utils.getObjIdScriptVar(self, trial.MONSTER_SHER_KAR)),
		     so all four turn to look at Sher Kar the moment they exist. Taking
		     the table's 0 would face all four due north, away from him. The
		     values below are atan2(sherKarX - guardX, sherKarY - guardY) in
		     degrees against his own sourced point (-103.559, -164.703) -- the
		     same convention spawnMobile's heading argument already uses in this
		     file. Distances from him, for the record: guard0 39.7 m, guard1
		     102.2 m, guard3 119.7 m, guard4 38.0 m. ]]
		{
			poolKey = "monster_lair",
			label = "Sherkar's Lair",
			template = "som_sherkar_praetorian",
			cell = "r1",
			x = -87.4726, z = -18.2924, y = -128.367, heading = -156.120,
		},
		{
			poolKey = "monster_lair",
			label = "Sherkar's Lair",
			template = "som_sherkar_praetorian",
			cell = "r1",
			x = -103.436, z = -17.7027, y = -62.5382, heading = -179.931,
		},
		{
			poolKey = "monster_lair",
			label = "Sherkar's Lair",
			template = "som_sherkar_karling",
			cell = "r1",
			x = -155.967, z = -18.7049, y = -57.0598, heading = 154.040,
		},
		{
			poolKey = "monster_lair",
			label = "Sherkar's Lair",
			template = "som_sherkar_symbiot",
			cell = "r1",
			x = -124.443, z = -17.1073, y = -133.004, heading = 146.622,
		},
		--[[ Doom Bringer. datatables/spawning/dungeon/som_working_droid_factory.tab, the
		     row boss_wp=doom_bringer at mediumroom18 / -28.058 / -28 / 6.81914, yaw 0.
		     working_droid_factory/working_controller.java:197-226 reads the boss_wp
		     objvar, takes getLocation of the one named doom_bringer, and calls
		     create.object("som_working_doom_bringer", doomBringerLoc). The waypoint IS
		     the spawn point. ]]
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_doom_bringer",
			cell = "mediumroom18",
			x = -28.058, z = -28, y = 6.81914, heading = 0,
		},
		--[[ Super Repair Droid. Three hops, all in shipped code. rapid_assembly_unit.java
		     STAGE_REPAIR spawns an mde_repair_droid at a cloner waypoint;
		     mde_repair_droid.java:251-262 completeTranx then does
		     create.object(FIXER_ONE, getLocation(self)) -- at its own location. So the
		     nearest attested point is the cloner waypoint itself: the boss_wp=cloner1
		     row, smallroom11 / 80.0664 / -38 / -84.7532, yaw 0. This is the cloner's
		     point, not a separately-shipped boss point. ]]
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_super_repair_droid",
			cell = "smallroom11",
			x = 80.0664, z = -38, y = -84.7532, heading = 0,
		},
		--[[ Working Droid Factory bosses from
		     datatables/spawning/dungeon/som_working_droid_factory.tab boss_wp
		     rows, read through working_droid_factory/working_controller.java.
		     beginSpawn at :28-36 fires spawnGuardians, spawnDevistator,
		     spawnDroidEngineer and spawnDoomBringer unconditionally;
		     spawnDoomBringer at :225 then fires spawnDoomGuards. So every one
		     of these is placed on entry, not gated.

		     The six Hands of Doom ring the Doom Bringer's room --
		     boss_wp=doom_bringer is tab line 41, mediumroom18 / -28.058 / -28 /
		     6.81914, and that boss is already placed by the existing lairBosses
		     entry above. Do not double it. ]]
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_hk_58_aurek",
			cell = "smallroom21",
			x = 100.881, z = -12, y = 30.9766, heading = 270,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_hk_58_besh",
			cell = "smallroom24",
			x = 11.1364, z = -12, y = -17.0658, heading = 90,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_devistator",
			cell = "smallroom6",
			x = 119.999, z = -28, y = 67.5402, heading = 180,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_master_droid_engineer",
			cell = "mediumroom10",
			x = 44.0914, z = -38, y = -41.7914, heading = 121,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_hand_of_doom",
			cell = "mediumroom18",
			x = -19.9774, z = -28, y = 52.3294, heading = 0,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_hand_of_doom",
			cell = "mediumroom18",
			x = -31.498, z = -28, y = 52.415, heading = 0,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_hand_of_doom",
			cell = "mediumroom18",
			x = -31.3043, z = -28, y = 41.041, heading = 0,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_hand_of_doom",
			cell = "mediumroom18",
			x = -31.5005, z = -28, y = 29.5312, heading = 0,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_hand_of_doom",
			cell = "mediumroom18",
			x = -19.9949, z = -28, y = 29.6682, heading = 0,
		},
		{
			poolKey = "working_droid_factory",
			label = "Working Droid Factory",
			template = "som_working_hand_of_doom",
			cell = "mediumroom18",
			x = -8.74025, z = -28, y = 29.6619, heading = 0,
		},
		--[[ Decrepit Droid Factory bosses. Neither comes from a table; both
		     positions are hardcoded in live java.

		     Colonel OR-5: decrepit_droid_factory/decrepit_controller.java:106-113,
		     new location(63, -67, -50, ...), setYaw(colonel, 90).

		     Factory Guardian: DERIVED. power_core.java:59-82 finds the
		     patrol_wp object named controlFour, takes its location, then does
		     spawnLoc.x -= 3.4 and spawnLoc.z -= 1.4 before
		     create.object("som_decrepit_guardian", spawnLoc) and
		     setYaw(guardian, -90). In live's axes that .z is the horizontal,
		     which is repo y. controlFour is at mainroom27 / 69.1 / -24 / 0.1,
		     so 69.1 - 3.4 = 65.7 and 0.1 - 1.4 = -1.3; the guardian lands at
		     65.7 / -24 / -1.3.

		     Live gates the guardian behind the power-core objective
		     (power_core.java fires spawnGuardian after the core is worked) and
		     the colonel behind spawnOr5. This port has no objective machine, so
		     both stand from the start -- the same static conversion the uplink
		     comment already records for the beetle cap. ]]
		{
			poolKey = "decrepit_droid_factory",
			label = "Decrepit Droid Factory",
			template = "som_decrepit_colonel_or5",
			cell = "mediumroom10",
			x = 63, z = -67, y = -50, heading = 90,
		},
		{
			poolKey = "decrepit_droid_factory",
			label = "Decrepit Droid Factory",
			template = "som_decrepit_guardian",
			cell = "mainroom27",
			x = 65.7, z = -24, y = -1.3, heading = -90,
		},
	},

	--[[ Uplink Cave -- Establish the Link trial population.

	     THE TABLE EXISTS, and an earlier note in this repo said it did not.
	     mustafar_instances.lua:279-281 reads "som_uplink_cave has NO dungeon spawn
	     table", and that was true only of datatables/spawning/dungeon/. The cave's
	     placement table is in a different tree:
	     datatables/dungeon/mustafar_trials/link_establish/link_event_data.tab,
	     reached from the building's own server template through link_event_manager.
	     That note is corrected in the instances file; this block is what reads it.

	     THE AXIS MAPPING is the same one at lines 25-37: live locy is HEIGHT, so
	     repo x <- locx, repo z <- locy, repo y <- locz. spawnMobile takes heading
	     in DEGREES; spawnProp / spawnSceneObject take RADIANS.

	     THE FOREMAN AND ITS FOUR GUARDS ARE ONE LIVE SCRIPT. foreman_spawner.java
	     does create.object(FOREMAN, getLocation(self)) at the line-23 waypoint,
	     then loops offSet = { "-10:-10", "-10:10", "10:-10", "10:10" } adding each
	     pair to live spawnLoc.x and spawnLoc.z -- which are repo x and repo y --
	     while keeping the height. Then ai_lib.establishAgroLink(foreman, eventMobs),
	     which Core3 has no binding for; the four defenders carry PACK instead, the
	     same substitution valley_battlefield.lua records for its commander's
	     guards. They used to sit split across lairBosses (foreman alone) and a
	     missing guard spawn; they are together here so the one live script stays
	     one block.

	     THE .ILF CORROBORATION, carried over from the deleted lairBosses comment:
	     the foreman point sits inside the som_uplink_cave.ilf footprint
	     (x -200.8..8.6, z -108.5..178.2), the nearest fixture is a
	     must_jeditemple_wall_long 13.8 m away, and the local ground band runs
	     h -4.2 to -7.7, which brackets live's -5. That is a check on the axis
	     mapping, not the source of the coordinate.

	     THE 32 LAIR BEETLES, and exactly what is ported and what is not.
	     bug_spawner.java is attached to each beetle_lair.iff. It has BUG_MAX = 8,
	     spawns one every 20 s at getLocation(self) -- the lair's own point -- and
	     re-spawns on droneDied until the cap. Each roll is DRONE unless
	     rand(0, 9) > 7, so 8 in 10 drones and 2 in 10 workers. Ported: the cap of
	     8 per lair, at the lair point, split 6 drones / 2 workers, which is that
	     ratio applied to 8. Not ported: the 20 s stagger, the re-spawn on death,
	     the lair's 50000 hit points and self-repair, and the soldier_spawner
	     marker the lair drops when destroyed. So live's 8 is a ceiling a player
	     climbs toward and this is 8 standing there from the start. Stated, not
	     hidden. Count: 52 creatures and 5 props per copy, across the 9 copies in
	     the uplink_cave pool.

	     WHAT THE TABLE PLACES THAT THIS DOES NOT:
	       - the 15 patrol_waypoint.iff rows (11 named, 4 randomN) -- not a
	         registered server template in this tree, checked by grep across
	         object/; the same call valley_battlefield.lua:96-100 already makes.
	       - the eleven-waypoint patrol path the stage-2 relay droid would walk
	         -- still not walked; this port has no pathing sequencer. The droid
	         itself IS placed (see the relay-droid block below): link_event_manager
	         beginSpawn at :17-23 calls spawnActors(self, 1) and then
	         messageTo(self, "beginEvent", null, 20, false); beginEvent at
	         :108-112 is nothing but spawnActors(self, 2). Stage 2 is
	         unconditional, twenty seconds in. Meanwhile the foreman and its
	         three drone spawners are stage 3 rows (table lines 22-25), and
	         stage 3 only fires from validateRelays at :123-141 once eleven
	         relay objects are counted -- and this port places those already.
	         So an earlier note here that skipped the relay droid as "gated"
	         was wrong: it was placing the gated content and skipping the
	         ungated content.
	       - must_uplink_bunker_entrance.iff on line 27 -- a building, and the
	         copies are already instantiated by mustafar_instances.lua; spawning
	         it inside a cell would nest cells.

	     RESPAWN is self.respawn (600), for the reason already given at lines
	     57-69. ]]
	uplinkCave = {
		poolKey = "uplink_cave",
		label = "Uplink Cave",
		table = "dungeon/mustafar_trials/link_establish/link_event_data.tab",
		cell = "mainroom",

		-- { template, x, z, y, heading }   z is HEIGHT, heading is DEGREES
		creatures = {
			-- foreman_spawner (table line 23) and its four offSet defenders
			{ "som_link_lava_beetle_foreman", -58, -5, 11, 0 },
			{ "som_link_lava_beetle_defender", -68, -5, 1, 0 },
			{ "som_link_lava_beetle_defender", -68, -5, 21, 0 },
			{ "som_link_lava_beetle_defender", -48, -5, 1, 0 },
			{ "som_link_lava_beetle_defender", -48, -5, 21, 0 },
			-- foreman_drone_spawner (table lines 24-26)
			{ "som_link_lava_beetle_drone", -74, 0, 75, 0 },
			{ "som_link_lava_beetle_drone", -6, -1, 0, 0 },
			{ "som_link_lava_beetle_drone", -102, 0, -87, 0 },
			-- lair line 15: 6 drones + 2 workers at the beetle_lair point
			{ "som_link_lava_beetle_drone", -100, -6, 37, 0 },
			{ "som_link_lava_beetle_drone", -100, -6, 37, 0 },
			{ "som_link_lava_beetle_drone", -100, -6, 37, 0 },
			{ "som_link_lava_beetle_drone", -100, -6, 37, 0 },
			{ "som_link_lava_beetle_drone", -100, -6, 37, 0 },
			{ "som_link_lava_beetle_drone", -100, -6, 37, 0 },
			{ "som_link_lava_beetle_worker", -100, -6, 37, 0 },
			{ "som_link_lava_beetle_worker", -100, -6, 37, 0 },
			-- lair line 16: 6 drones + 2 workers at the beetle_lair point
			{ "som_link_lava_beetle_drone", -71, -1, -1, 0 },
			{ "som_link_lava_beetle_drone", -71, -1, -1, 0 },
			{ "som_link_lava_beetle_drone", -71, -1, -1, 0 },
			{ "som_link_lava_beetle_drone", -71, -1, -1, 0 },
			{ "som_link_lava_beetle_drone", -71, -1, -1, 0 },
			{ "som_link_lava_beetle_drone", -71, -1, -1, 0 },
			{ "som_link_lava_beetle_worker", -71, -1, -1, 0 },
			{ "som_link_lava_beetle_worker", -71, -1, -1, 0 },
			-- lair line 17: 6 drones + 2 workers at the beetle_lair point
			{ "som_link_lava_beetle_drone", -36, -3, -27, 0 },
			{ "som_link_lava_beetle_drone", -36, -3, -27, 0 },
			{ "som_link_lava_beetle_drone", -36, -3, -27, 0 },
			{ "som_link_lava_beetle_drone", -36, -3, -27, 0 },
			{ "som_link_lava_beetle_drone", -36, -3, -27, 0 },
			{ "som_link_lava_beetle_drone", -36, -3, -27, 0 },
			{ "som_link_lava_beetle_worker", -36, -3, -27, 0 },
			{ "som_link_lava_beetle_worker", -36, -3, -27, 0 },
			-- lair line 18: 6 drones + 2 workers at the beetle_lair point
			{ "som_link_lava_beetle_drone", -93, -3, -44, 0 },
			{ "som_link_lava_beetle_drone", -93, -3, -44, 0 },
			{ "som_link_lava_beetle_drone", -93, -3, -44, 0 },
			{ "som_link_lava_beetle_drone", -93, -3, -44, 0 },
			{ "som_link_lava_beetle_drone", -93, -3, -44, 0 },
			{ "som_link_lava_beetle_drone", -93, -3, -44, 0 },
			{ "som_link_lava_beetle_worker", -93, -3, -44, 0 },
			{ "som_link_lava_beetle_worker", -93, -3, -44, 0 },
			--[[ Relay droid. link_event_data.tab line 2 -- the
			     patrol_waypoint.iff row at locx -81, locy 0, locz 128 carrying
			     script establish_the_link.droid_spawner. droid_spawner.java:22-29
			     spawnRelayDroid does create.object(RELAY_DROID, getLocation(self))
			     -- at the waypoint itself. Stage 2 is unconditional (see the
			     uplinkCave header above); the eleven-waypoint path is still not
			     walked. ]]
			{ "som_link_relay_droid", -81, 0, 128, 0 },
			--[[ Eleven lava beetle soldiers -- one at each named waypoint
			     (link_event_data.tab lines 3-13, the eleven stage-1 rows
			     carrying a wp_name).

			     Live never places these from the table. bug_spawner.java:21-36
			     OnDestroy creates a marker in mainroom and attaches
			     soldier_spawner. soldier_spawner.java:24-60 then collects every
			     object in the room carrying a WP_NAME script var -- which is
			     exactly these eleven -- and spawnNewBug picks one at random,
			     jitters it by rand(-6,6) on both axes, and spawns a soldier
			     there, up to BUG_MAX = 3, re-spawning on death.

			     So live's guaranteed total is 3 per destroyed lair across 4
			     lairs = 12 soldiers, drawn from these eleven points. This port
			     places eleven, one per point, from the start.

			     Not ported: the trigger on lair destruction, the +-6 jitter,
			     the re-spawn, and link_event_manager.stopRandomSoldiers at
			     :164-176, which destroys the spawners once the relay objective
			     completes. So live's soldiers are a wave that arrives and later
			     stops; these stand throughout.

			     This is the same static conversion already applied to the
			     beetle lairs' 8-cap two blocks above. One decision, not two. ]]
			{ "som_link_lava_beetle_soldier", -105, -1, 124, 0 },   -- firstCorner
			{ "som_link_lava_beetle_soldier", -106, -2,  79, 0 },   -- secondCorner
			{ "som_link_lava_beetle_soldier",  -78, -2,  71, 0 },   -- oppositeSide
			{ "som_link_lava_beetle_soldier",  -56,  0,  40, 0 },   -- firstSpawn
			{ "som_link_lava_beetle_soldier",  -70, -1,   0, 0 },   -- tSection
			{ "som_link_lava_beetle_soldier",  -54, -1, -30, 0 },   -- firstLegBend
			{ "som_link_lava_beetle_soldier",   -8, -2,  -1, 0 },   -- firstRelay
			{ "som_link_lava_beetle_soldier",  -82,  0,  -5, 0 },   -- secondLegBend
			{ "som_link_lava_beetle_soldier",  -99, -3, -45, 0 },   -- secondSpawn
			{ "som_link_lava_beetle_soldier", -101, -2, -73, 0 },   -- finalEncounter
			{ "som_link_lava_beetle_soldier", -102, -3, -26, 0 },   -- finalRelay
		},

		-- { template, x, z, y, yaw }       z is HEIGHT, yaw is DEGREES (spawnProp converts)
		props = {
			{ "object/tangible/dungeon/mustafar/uplink_trial/beetle_lair.iff", -100, -6, 37, 0 },
			{ "object/tangible/dungeon/mustafar/uplink_trial/beetle_lair.iff", -71, -1, -1, 0 },
			{ "object/tangible/dungeon/mustafar/uplink_trial/beetle_lair.iff", -36, -3, -27, 0 },
			{ "object/tangible/dungeon/mustafar/uplink_trial/beetle_lair.iff", -93, -3, -44, 0 },
			{ "object/tangible/dungeon/mustafar/uplink_trial/exit_door.iff", -90, 0, 117, 4 },
		},
	},

	-- What actually got placed, so a boot check can tell a silent failure from a
	-- success. Nothing here is snapshot data, so there is no world id to look any
	-- of it up by afterwards.
	--
	-- Expected counts after ROUND H(e) (checked against mustafar_instances.lua
	-- pool depths: old_republic_facility 12, monster_lair 12, uplink_cave 9,
	-- lair_of_the_crystal 12, working_droid_factory 12, decrepit_droid_factory 9):
	--   lairBosses: 19 entries (was 3).
	--   Per-pool boss placements: monster_lair 12 x 5 (Sher Kar + 4 guards) = 60;
	--     working_droid_factory 12 x 12 (doom bringer, super repair droid, aurek,
	--     besh, devistator, MDE, 6 hands) = 144; decrepit_droid_factory 9 x 2 = 18.
	--     Total lair bosses 222 (was 36). Corrected from a draft that assumed 12
	--     decrepit copies; mustafar_instances.lua gives decrepit 9, and the pool
	--     table wins.
	--   Props: working_droid_factory props 2 -> 7 rows, so +5 x 12 = +60. Uplink
	--     props unchanged. Total props 471 (was 411).
	--   Uplink creatures per copy 40 -> 52, x 9 = 468 (was 360).
	--     Total pool creatures (pools + uplink) 1389 (was 1281).
	spawnedCount = 0,
	bossCount = 0,
	propCount = 0,
}

registerScreenPlay("MustafarDungeonPopulation", true)

function MustafarDungeonPopulation:start()
	if (not isZoneEnabled("mustafar")) then
		return
	end

	if (MustafarInstances == nil) then
		print("MustafarDungeonPopulation: mustafar_instances.lua is not loaded; no dungeon will be populated")
		return
	end

	for i = 1, #self.pools do
		self:populatePool(self.pools[i])
	end

	self:populateLairBosses()
	self:populateUplinkCave()

	print("MustafarDungeonPopulation: " .. self.spawnedCount .. " creatures placed across the Mustafar dungeon pools, plus " .. self.bossCount .. " lair bosses")
	print("MustafarDungeonPopulation: " .. self.propCount .. " non-creature objects placed from the same tables")
end

-- Separate from populatePool because these have no live table and no substitute
-- key; see the lairBosses comment for why that distinction is kept honest rather
-- than papered over. One boss per copy of the pool, the same per-copy shape
-- populatePool uses -- twelve Sher Kars against the 921 creatures the pools above
-- already place.
function MustafarDungeonPopulation:populateLairBosses()
	for i = 1, #self.lairBosses do
		local boss = self.lairBosses[i]
		local buildings = MustafarInstances:getPoolBuildings(boss.poolKey)

		if (buildings == nil or #buildings == 0) then
			print("MustafarDungeonPopulation: instance pool '" .. boss.poolKey .. "' is empty; " .. boss.label .. " gets no boss")
		else
			for j = 1, #buildings do
				self:spawnLairBoss(boss, buildings[j])
			end
		end
	end
end

function MustafarDungeonPopulation:spawnLairBoss(boss, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("MustafarDungeonPopulation: " .. boss.poolKey .. " copy " .. buildingID .. " is missing; it gets no boss")
		return
	end

	local cellID = self:resolveCell(pBuilding, boss.cell)

	if (cellID == 0) then
		print("MustafarDungeonPopulation: " .. boss.poolKey .. " copy " .. buildingID .. " has no cell named '" .. boss.cell .. "'; " .. boss.template .. " is skipped")
		return
	end

	-- Heading is DEGREES here, same as spawnRow -- see THE AXIS MAPPING.
	local pBoss = spawnMobile("mustafar", boss.template, self.respawn, boss.x, boss.z, boss.y, boss.heading, cellID)

	if (pBoss == nil) then
		print("MustafarDungeonPopulation: failed to spawn " .. boss.template .. " in " .. boss.cell .. " of " .. boss.poolKey .. " copy " .. buildingID)
		return
	end

	self.bossCount = self.bossCount + 1
end

function MustafarDungeonPopulation:populateUplinkCave()
	local cave = self.uplinkCave
	local buildings = MustafarInstances:getPoolBuildings(cave.poolKey)

	if (buildings == nil or #buildings == 0) then
		print("MustafarDungeonPopulation: instance pool '" .. cave.poolKey .. "' is empty; " .. cave.label .. " will not be populated")
		return
	end

	for i = 1, #buildings do
		self:populateUplinkCopy(cave, buildings[i])
	end
end

-- cave.creatures rows are { template, x, z, y, heading } (5 fields, no cell name,
-- because the cell is constant); pool.rows are { liveName, cell, x, z, y, heading }
-- (6 fields). That is why this does not reuse spawnRow/spawnProp.
function MustafarDungeonPopulation:populateUplinkCopy(cave, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("MustafarDungeonPopulation: " .. cave.poolKey .. " copy " .. buildingID .. " is missing; it gets no creatures")
		return
	end

	local cellID = self:resolveCell(pBuilding, cave.cell)

	if (cellID == 0) then
		print("MustafarDungeonPopulation: " .. cave.poolKey .. " copy " .. buildingID .. " has no cell named '" .. cave.cell .. "'; its rows from " .. cave.table .. " are skipped")
		return
	end

	for i = 1, #cave.creatures do
		local row = cave.creatures[i]

		-- Heading is DEGREES here -- see THE AXIS MAPPING.
		local pMobile = spawnMobile("mustafar", row[1], self.respawn, row[2], row[3], row[4], row[5], cellID)

		if (pMobile == nil) then
			print("MustafarDungeonPopulation: failed to spawn " .. row[1] .. " in " .. cave.cell .. " of " .. cave.poolKey .. " copy " .. buildingID)
		else
			self.spawnedCount = self.spawnedCount + 1
		end
	end

	for i = 1, #cave.props do
		local row = cave.props[i]

		-- spawnSceneObject takes RADIANS and takes the cell id before the heading.
		local pObject = spawnSceneObject("mustafar", row[1], row[2], row[3], row[4], cellID, math.rad(row[5]))

		if (pObject == nil) then
			print("MustafarDungeonPopulation: failed to place " .. row[1] .. " in " .. cave.cell .. " of " .. cave.poolKey .. " copy " .. buildingID)
		else
			self.propCount = self.propCount + 1
		end
	end
end

-- The template a live creature name is standing in as, or nil if the name is not
-- one of the seventeen. historian.lua calls this rather than carrying its own copy
-- of a template string; see WHAT THIS FIXES ELSEWHERE.
function MustafarDungeonPopulation:getSubstitute(liveName)
	return self.substitutes[liveName]
end

function MustafarDungeonPopulation:populatePool(pool)
	local buildings = MustafarInstances:getPoolBuildings(pool.key)

	if (buildings == nil or #buildings == 0) then
		print("MustafarDungeonPopulation: instance pool '" .. pool.key .. "' is empty; " .. pool.label .. " will not be populated")
		return
	end

	for i = 1, #buildings do
		self:populateCopy(pool, buildings[i])
	end
end

function MustafarDungeonPopulation:populateCopy(pool, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("MustafarDungeonPopulation: " .. pool.key .. " copy " .. buildingID .. " is missing; it gets no creatures")
		return
	end

	-- Resolved once per cell name rather than once per row: the ORF's 42 rows sit
	-- in 15 cells and the decrepit factory's 45 sit in 8, so this is the
	-- difference between 87 lookups per copy and 23. It also means a cell the
	-- building does not have is reported once, by name, instead of once per row.
	local cells = {}

	for i = 1, #pool.rows do
		local row = pool.rows[i]
		local cellName = row[2]

		if (cells[cellName] == nil) then
			cells[cellName] = self:resolveCell(pBuilding, cellName)

			if (cells[cellName] == 0) then
				print("MustafarDungeonPopulation: " .. pool.key .. " copy " .. buildingID .. " has no cell named '" .. cellName .. "'; its rows from " .. pool.table .. " are skipped")
			end
		end

		if (cells[cellName] ~= 0) then
			self:spawnRow(pool, row, cells[cellName], buildingID)
		end
	end

	-- The non-creature rows of the same table, through the same cell cache. Pools
	-- that declare no props skip this entirely.
	if (pool.props ~= nil) then
		for i = 1, #pool.props do
			local row = pool.props[i]
			local cellName = row[2]

			if (cells[cellName] == nil) then
				cells[cellName] = self:resolveCell(pBuilding, cellName)

				if (cells[cellName] == 0) then
					print("MustafarDungeonPopulation: " .. pool.key .. " copy " .. buildingID .. " has no cell named '" .. cellName .. "'; its rows from " .. pool.table .. " are skipped")
				end
			end

			if (cells[cellName] ~= 0) then
				self:spawnProp(pool, row, cells[cellName], buildingID)
			end
		end
	end
end

function MustafarDungeonPopulation:resolveCell(pBuilding, cellName)
	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

	if (pCell == nil) then
		return 0
	end

	return SceneObject(pCell):getObjectID()
end

function MustafarDungeonPopulation:spawnRow(pool, row, cellID, buildingID)
	local template = self.substitutes[row[1]]

	if (template == nil) then
		print("MustafarDungeonPopulation: no substitute is defined for " .. row[1] .. "; that row is skipped in every copy")
		return
	end

	-- row is { live name, cell, x, z, y, heading } and spawnMobile wants
	-- x, z, y, heading, so the row reads straight across. Heading is in DEGREES
	-- here -- see THE AXIS MAPPING.
	local pMobile = spawnMobile("mustafar", template, self.respawn, row[3], row[4], row[5], row[6], cellID)

	if (pMobile == nil) then
		print("MustafarDungeonPopulation: failed to spawn " .. template .. " (" .. row[1] .. ") in " .. row[2] .. " of " .. pool.key .. " copy " .. buildingID)
		return
	end

	self.spawnedCount = self.spawnedCount + 1
end

--[[ The prop half of spawnRow, and the one difference that matters is the last
     argument. spawnMobile takes its heading in DEGREES; spawnSceneObject takes it
     in RADIANS, and it takes the cell id BEFORE the heading rather than after it.
     Two conventions, one file -- so the conversion is done here, once, and the
     tables above stay in the table's own units.

     No substitutes lookup: row[1] is already a full template path, because these
     rows name objects rather than live creature names. ]]
function MustafarDungeonPopulation:spawnProp(pool, row, cellID, buildingID)
	local pObject = spawnSceneObject("mustafar", row[1], row[3], row[4], row[5], cellID, math.rad(row[6]))

	if (pObject == nil) then
		print("MustafarDungeonPopulation: failed to place " .. row[1] .. " in " .. row[2] .. " of " .. pool.key .. " copy " .. buildingID)
		return
	end

	self.propCount = self.propCount + 1
end
