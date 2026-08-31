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

THE TEMPLATES ARE SUBSTITUTED  --  every single one

Not one of the seventeen creature names in those tables exists as a template. This
is a CHECKED absence, not an assumption: no som_orf_* and no som_decrepit_*
creature definition appears anywhere in this repo or anywhere in the extracted
source tree. They exist only as the strings in these tables. So each live name is
mapped to the closest thing this tree actually ships, and the mapping is written
out in full below with its reason.

What that buys and what it does not: the ENCOUNTER is real -- the right kind of
creature, in the right room, on the right spot, facing the right way, in the
right numbers. The CREATURE is not. Combat stats, loot tables, special attacks
and faction are whatever the substitute already had. Nobody should read a kill
in here as a reproduction of the live fight.

The one thing that is uniform: all fifteen substitute templates are level 70, so the
difficulty band across the three buildings is at least consistent.

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

  UNREACHABLE, so no effect. story_arc_chapters countDroid credits
  cww8_battle_droid, cww8a_battle_droid and cww8a_eradicator -- the same three
  templates the decrepit factory uses -- but only at exactly STAGE_DROID_ARMY (16),
  and both factory pools are gated by mayEnterDroidFactory at STAGE_ENTER_FACTORY
  (19). A player who could kill these droids cannot be at the stage that counts
  them. The overlap exists on paper and cannot be walked into.

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

	--[[ The substitution table.

	     Keyed by the live creature name so it reads against the .tab rows, and so
	     historian.lua can ask for one by the live name instead of duplicating a
	     template string. Every value is a real registered mobile in
	     mobile/custom_content/som/ and every one is level 70.

	     The reasons are short on purpose: the long version is that none of these
	     seventeen names has a definition to copy, so each pick is the nearest
	     shipped creature of the same kind, and there is no better evidence than
	     the name itself. Seventeen live names map onto fifteen distinct templates
	     because lava_flea covers two flea stages and asn_121 covers both patrol
	     droids -- so the two counts are different on purpose and neither is a
	     typo. ]]
	substitutes = {
		-- The four ancient droid classes of the Old Republic Facility.
		som_orf_ancient_security_drone = "union_sentry_droid",       -- a facility's security, and quest one's "orf_security" target
		som_orf_ancient_patrol_drone = "asn_121",                    -- a mobile probe droid; a patrol rather than a post
		som_orf_ancient_sentinel_droid = "som_ancient_guardian_droideka",
		som_orf_ancient_guard_droid = "som_ancient_guardian_ig",

		-- The flea and beetle broods. Same species, different life stage, and this
		-- tree ships two fleas and three beetles, so the stages collapse where it
		-- has no separate mobile for them.
		som_orf_flea_hatchling = "lava_flea",
		som_orf_flea_juvenile = "lava_flea",                         -- no juvenile mobile ships; same creature as the hatchling
		som_orf_flea_starving = "lava_flea_smoldering",
		som_orf_beetle_hatchling = "kubaza_beetle",
		som_orf_beetle_worker = "kubaza_worker_beetle",
		som_orf_beetle_soldier = "kubaza_soldier_beetle",

		-- The two ORF bosses. Both already exist under the orf_ prefix in this
		-- tree, so these two are the closest to quoted the file gets.
		som_orf_ancient_tulrus = "orf_tulrus",
		som_orf_ancient_xandank = "orf_xandank",

		-- The droid factory. The CWW8 line is what this tree ships for clone-war
		-- battle droids, and the eradicator is its heavy.
		som_decrepit_battle_droid = "cww8_battle_droid",
		som_decrepit_super_battle_droid = "cww8a_eradicator",
		som_decrepit_cww8_combat_droid = "cww8a_battle_droid",       -- the live name says CWW8 outright
		som_decrepit_blastromech = "ig106",                          -- an assassin droid; the nearest thing to a hunting astromech
		som_decrepit_patrol_bot = "asn_121",                         -- the observation droid, same pick as the ORF patrol
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
		},
	},

	-- What actually got placed, so a boot check can tell a silent failure from a
	-- success. Nothing here is snapshot data, so there is no world id to look any
	-- of it up by afterwards.
	spawnedCount = 0,
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

	print("MustafarDungeonPopulation: " .. self.spawnedCount .. " creatures placed across the Mustafar dungeon pools")
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
