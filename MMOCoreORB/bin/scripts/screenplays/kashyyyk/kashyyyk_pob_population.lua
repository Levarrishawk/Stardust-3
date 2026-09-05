--[[
The Kashyyyk POB dungeon populator

WHAT THIS IS

Zone kashyyyk_pob_dungeons is its own zone (not a row on the merged surface).
The 023 snapshot places 10 copies of thm_kash_myyydril_caverns and 20 copies
of dungeon_avatar_platform. Until now nothing in this repo read the dungeon
spawn tables, so a player who entered either building walked through empty
rooms. This file spawns those tables' creature rows into the copies listed
below.

ruling 2026-09-04: "ensure kashyyyk is done in full"

SOURCE OF RECORD

_dsrc/sku.0/sys.server/compiled/game/datatables/spawning/dungeon/

    ep3_myyydril_caverns.tab    917 rows (352 creature, 565 object)
    ep3_avatar_platform.tab     189 rows (156 creature,  33 object)

Every room name, position and heading below is QUOTED from those rows. Nothing
here is read off a .ilf and nothing here is placed by eye. The object rows
(quest crystals, terminals, doors, lockboxes) are dungeon logic and furniture,
not this file -- the same cut MustafarDungeonPopulation originally made,
before its 2026-08-31 props pass.

THE AXIS MAPPING  --  the one thing to get right

Copied from mustafar_dungeon_population.lua:25-37. The tables' columns are
loc_x, loc_y, loc_z, yaw, and loc_y is HEIGHT. This repo's Lua argument order
is x, z, y, heading, and z is height. So:

    repo x        <-  loc_x
    repo z        <-  loc_y     (height)
    repo y        <-  loc_z
    repo heading  <-  yaw

spawnMobile takes heading in DEGREES, so yaw goes across unconverted. This is
the opposite of spawnSceneObject, which takes radians.

THE COPY-FARM IS A MAINTAINER DECISION, STILL OPEN

instance_datatable.tab has no Kashyyyk row. This is not a Core3 instance pool
and this file does not reach for mustafar_instances.lua. The 023 snapshot is a
copy-farm: 10 myyydril + 20 avatar = 30 buildings. Populating all 30 would be
about 13,000 mobiles (352+156 creature rows x 30). Whether to run the shipped
farm or one copy per dungeon is still open.

copies, below, is the single table that decides. Only copy #0 of each dungeon
is listed. Switch the rest on by adding their snapshot node IDs (commented
next to the table, from the transcribed spawn rows).

    myyydril copy #0   node 12900001   world (1000, 4.32584, 0)
    avatar   copy #0   node 12900721   world (1000, 41.521, 1000)

Buildings are found the same way Mustafar finds them: getSceneObject on the
snapshot node ID (mustafar_instances.lua:165-166 buildings lists, then
mustafar_dungeon_population.lua:1156-1157 populateCopy).

CELL NAMES

MustafarDungeonPopulation.lua:40-51: cell names come from the .ilf files, and
BuildingObject:getNamedCell against those names is how interiors are addressed.
The myyydril building's layout is interiorlayout/thm_kash_cave_myyydril_interior.ilf
(kashyyyk_pob_dungeons_regions.lua, ruling 2026-09-04 TRE note). No .ilf is in
this tree, so the room column is quoted as live spelled it. A cell the building
does not have is reported once per copy, by name, from populateCopy -- the same
boot check MustafarDungeonPopulation.lua:1177-1178 runs.

RESPAWN  --  whatever the Mustafar populator passes

mustafar_dungeon_population.lua:266 sets respawn = 600, and spawnRow at
mustafar_dungeon_population.lua:1230 passes self.respawn as spawnMobile's
third argument. This file does the same. Live's myyydril/avatar tables mix
blank, 300, 360, 480, 600, 800, 1200 and 1800; applying 600 to every row is
the Mustafar substitution of application, not of value (header lines 78-90).

THEME_PARK BEHAVIOUR IS SEPARATE

Rows whose script is theme_park.* (myyydril generic_death, avatar generic_death
and the platform terminal/prisoner/lockbox scripts) still spawn as creatures.
The behaviour itself is separate. conversation.* is the same cut.

THE TEMPLATES ARE THIS TREE'S OWN

Mapped from creature-table iff-matches (the creature table) and
from Creature:new registrations in mobile/custom_content/ep3/ and
mobile/custom_content/mobile/. the first pass scanned only ep3/; the mobile/ dir holds the
urnsoris, uwari and dressed_myyydril bodies. Numbered set members rotate in
table order. Creatures with no repo template are OPEN: listed in place as
comments under their SOE name, never substituted. battle_droid.iff on
ep3_myyydril_lorn_servant is a generic IFF that also clothes unrelated rryatt
and clone-relics droids -- that row is OPEN rather than a look-alike.

THE BOOT COST  --  copy #0 only, said out loud

    myyydril_caverns     336 rows x 1 copy  =  336
    avatar_platform      152 rows x 1 copy  =  152
                                                     ----
                                                      488

If the farm is switched on, multiply by 10 and 20.
--]]

KashyyykPobPopulation = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "KashyyykPobPopulation",

	-- See RESPAWN in the header. Same number, same call: Mustafar
	-- mustafar_dungeon_population.lua:266 and spawnRow :1230.
	respawn = 600,

	--[[ Snapshot node IDs of the copies to furnish. Only copy #0 of
	     each dungeon is listed. Add node IDs to switch the farm on.
	     getSceneObject on these ids is how populateCopy finds the
	     building -- the same shape MustafarInstances:getPoolBuildings
	     feeds MustafarDungeonPopulation:populateCopy. ]]
	copies = {
		-- WHICH SNAPSHOT GOVERNS (measured on the deploy 2026-09-04): with mtg_patch_022.tre listed above
		-- mtg_patch_023.tre (the TRE-order ruling), snapshot/kashyyyk_pob_dungeons.ws comes from 022
		-- (853 nodes: 10 myyydril copies along z at x = 0, node ids 14400001 + 80n; 2 avatar platforms,
		-- 14400801 at (-600, 50, 0) and its twin). The 023 cut (1862 nodes, ids 12900001..) is shadowed;
		-- its ids are kept in the comments below for the day 023 is put above 022. The first boot with
		-- the 023 ids found no building; these ids come from the 022 file the server actually loads.
		myyydril_caverns = { 14400001 }, -- copy #0 in the 022 snapshot (0, 0, 0); 023 id was 12900001 at (1000, 4.32584, 0)
		-- myyydril copy 1  12900081  (2000, 4.3258, 0)
		-- myyydril copy 2  12900161  (3000, 4.3258, 0)
		-- myyydril copy 3  12900241  (4000, 4.3258, 0)
		-- myyydril copy 4  12900321  (5000, 4.3258, 0)
		-- myyydril copy 5  12900401  (6000, 4.3258, 0)
		-- myyydril copy 6  12900481  (-1000, 4.3258, 0)
		-- myyydril copy 7  12900561  (-2000, 4.3258, 0)
		-- myyydril copy 8  12900641  (-3000, 4.3258, 0)
		-- myyydril copy 9  12901781  (1000, 4.3258, -1000)
		avatar_platform = { 14400801 }, -- copy #0 in the 022 snapshot (-600, 50, 0); 023 id was 12900721 at (1000, 41.521, 1000)
		-- avatar copy 1  12900774  (0, 41.521, 1000)
		-- avatar copy 2  12900827  (-1000, 41.521, 1000)
		-- avatar copy 3  12900880  (-2000, 41.521, 1000)
		-- avatar copy 4  12900933  (-3000, 41.521, 1000)
		-- avatar copy 5  12900986  (-4000, 41.521, 1000)
		-- avatar copy 6  12901039  (-5000, 41.521, 1000)
		-- avatar copy 7  12901092  (-6000, 41.521, 1000)
		-- avatar copy 8  12901145  (-7000, 41.521, 1000)
		-- avatar copy 9  12901198  (2000, 41.521, 1000)
		-- avatar copy 10  12901251  (3000, 41.521, 1000)
		-- avatar copy 11  12901304  (4000, 41.521, 1000)
		-- avatar copy 12  12901357  (5000, 41.521, 1000)
		-- avatar copy 13  12901410  (6000, 41.521, 1000)
		-- avatar copy 14  12901463  (7000, 41.521, 1000)
		-- avatar copy 15  12901516  (0, 41.521, 2000)
		-- avatar copy 16  12901569  (1000, 41.521, 2000)
		-- avatar copy 17  12901622  (2000, 41.521, 2000)
		-- avatar copy 18  12901675  (3000, 41.521, 2000)
		-- avatar copy 19  12901728  (4000, 41.521, 2000)
	},

	--[[ The rows.

	     Positional, because hundreds of named fields is a wall. The order is:

	         { repo template, cell, x, z (height), y, heading }

	     which is the argument order spawnMobile wants, so the call below reads
	     straight down the row. See THE AXIS MAPPING for how that came off the
	     table's loc_x / loc_y / loc_z / yaw. OPEN creature rows stay in place
	     as comments under the SOE spawn name. ]]
	pools = {
		{
			key = "myyydril_caverns",
			label = "Myyydril Caverns",
			table = "ep3_myyydril_caverns.tab",
			rows = {
				{ "dressed_myyydril_guard_f_01", "hall19", 133.38, -44.8591, -100.662, -7.23094 },
				{ "dressed_myyydril_guard_m_01", "hall19", 122.598, -45.0342, -101.058, 9.6458 },
				{ "dressed_myyydril_farmer_f_01", "dungeon22", 130.511, -46.6596, -146.823, -164.533 },
				{ "dressed_myyydril_farmer_f_02", "dungeon22", 108.135, -46.4668, -151.602, 175.584 },
				{ "dressed_myyydril_farmer_f_03", "dungeon22", 115.75, -46.4627, -123.021, -77.0845 },
				{ "dressed_myyydril_farmer_m_01", "dungeon22", 156.743, -46.8204, -116.01, 80.7454 },
				{ "dressed_myyydril_farmer_m_02", "dungeon22", 143.965, -46.7404, -133.959, -60.017 },
				{ "dressed_myyydril_guard_f_01", "hall23", 153.435, -55.3663, -77.2239, 156.933 },
				{ "dressed_myyydril_farmer_m_03", "dungeon24", 186.976, -63.8147, -84.7525, 166.082 },
				{ "dressed_myyydril_farmer_f_01", "dungeon24", 201.045, -63.6227, -75.103, 158.165 },
				{ "dressed_myyydril_farmer_f_02", "dungeon24", 210.649, -63.5615, -92.8005, -162.07 },
				{ "dressed_myyydril_farmer_f_03", "dungeon24", 209.059, -63.6617, -95.7795, 32.5343 },
				{ "dressed_myyydril_farmer_m_01", "dungeon24", 228.335, -63.3402, -91.9031, 171.537 },
				{ "dressed_myyydril_guard_m_01", "hall25", 258.457, -69.0329, -93.5637, -177.026 },
				{ "dressed_myyydril_guard_f_01", "hall25", 255.935, -80.3757, -132.061, 9.66016 },
				{ "dressed_myyydril_guard_m_01", "oil_pits", 229.922, -91.107, -132.751, 5.43727 },
				{ "dressed_myyydril_guard_f_01", "oil_pits", 229.494, -91.1845, -122.488, 168.798 },
				{ "uwari_beetle_domestic", "oil_pits", 211.894, -97.1481, -148.783, -169.108 },
				{ "uwari_beetle_domestic", "oil_pits", 209.908, -97.0143, -152.412, 154.263 },
				{ "uwari_beetle_domestic", "oil_pits", 208.037, -97.0118, -148.132, -45.941 },
				{ "uwari_beetle_domestic", "oil_pits", 206.314, -96.8221, -152.979, -149.577 },
				{ "uwari_beetle_domestic", "oil_pits", 207.679, -96.4376, -157.211, 170.305 },
				{ "dressed_myyydril_herder_m_01", "oil_pits", 200.737, -95.002, -156.945, 65.7892 },
				{ "uwari_beetle_domestic", "oil_pits", 178.133, -91.7585, -163.64, -108.756 },
				{ "uwari_beetle_domestic", "oil_pits", 176.172, -91.4556, -160.618, -32.9205 },
				{ "uwari_beetle_domestic", "oil_pits", 179.213, -91.8415, -157.137, 43.0913 },
				{ "uwari_beetle_domestic", "oil_pits", 183.002, -92.4174, -161.502, 129.484 },
				{ "uwari_beetle_domestic", "oil_pits", 187.948, -92.9268, -161.238, 86.3757 },
				{ "dressed_myyydril_herder_m_02", "oil_pits", 171.97, -91.666, -156.314, 124.382 },
				{ "uwari_beetle_domestic", "oil_pits", 118.13, -91.1044, -136.731, -80.4279 },
				{ "uwari_beetle_domestic", "oil_pits", 117.342, -91.2804, -143.355, 50.2369 },
				{ "uwari_beetle_domestic", "oil_pits", 125.301, -90.7835, -138.652, -130.817 },
				{ "uwari_beetle_domestic", "oil_pits", 123.697, -90.9375, -151.423, -65.6022 },
				{ "uwari_beetle_domestic", "oil_pits", 130.843, -90.7821, -145.593, 59.4547 },
				{ "dressed_myyydril_herder_m_03", "oil_pits", 125.801, -90.6663, -145.778, -42.2462 },
				{ "dressed_myyydril_guard_m_01", "oil_pits", 136.339, -90.405, -212.999, 0.686426 },
				{ "dressed_myyydril_guard_f_01", "oil_pits", 120.851, -90.4859, -212.548, 0.510454 },
				{ "uwari_beetle_domestic", "oil_pits", 138.271, -93.9722, -181.884, 42.5633 },
				{ "uwari_beetle_domestic", "oil_pits", 139.739, -93.5805, -171.531, 21.6248 },
				{ "uwari_beetle_domestic", "oil_pits", 132.133, -94.0566, -178.126, -128.991 },
				{ "dressed_myyydril_herder_m_01", "oil_pits", 132.315, -94.141, -189.193, 21.9768 },
				{ "uwari_beetle_domestic", "oil_pits", 145.529, -94.2098, -98.1417, -145.179 },
				{ "dressed_myyydril_herder_m_02", "oil_pits", 146.319, -93.9385, -78.3572, -113.331 },
				{ "dressed_myyydril_herder_m_03", "oil_pits", 158.212, -91.2208, -88.1021, -110.34 },
				{ "uwari_beetle_domestic", "oil_pits", 137.268, -96.1155, -98.2057, -103.126 },
				{ "uwari_beetle_domestic", "oil_pits", 122.367, -94.9597, -104.549, -29.482 },
				{ "uwari_beetle_domestic", "oil_pits", 113.671, -95.2492, -97.1501, -47.1727 },
				{ "uwari_beetle_domestic", "oil_pits", 119.869, -96.9768, -85.7943, 27.4314 },
				{ "uwari_beetle_domestic", "oil_pits", 124.154, -96.6454, -91.5439, 142.505 },
				{ "uwari_beetle_domestic", "oil_pits", 137.196, -96.5338, -87.5184, 71.5956 },
				{ "uwari_beetle_domestic", "oil_pits", 129.077, -96.7714, -96.9842, -125.296 },
				{ "uwari_beetle_domestic", "oil_pits", 109.836, -95.2659, -106.584, -1.95276 },
				{ "dressed_myyydril_herder_m_01", "hall30", 142.368, -90.7822, -22.0194, -163.654 },
				{ "dressed_myyydril_herder_m_02", "hall30", 131.662, -90.568, -30.3875, 46.7862 },
				{ "dressed_myyydril_guard_m_01", "hall33", 226.647, -123.409, -213.627, 178.399 },
				{ "dressed_myyydril_guard_f_01", "hall33", 229.949, -123.221, -253.165, -89.5774 },
				{ "dressed_myyydril_guard_m_01", "hall33", 218.915, -123.177, -254.112, 90.2467 },
				{ "dressed_myyydril_chief", "lightningroom34", 108, -123, -308, 160 },
				{ "dressed_yraka_nes", "lightningroom34", 185, -115, -317, 104 },
				{ "dressed_doctor_kinesworthy", "lightningroom34", 134, -155, -294, 31 },
				{ "dressed_myyydril_treesh", "lightningroom34", 105, -128, -358, 31 },
				{ "dressed_myyydril_guard_f_01", "hall35", 90.7353, -153.011, -246.253, 55.4087 },
				{ "dressed_myyydril_guard_m_01", "hall35", 115.836, -152.993, -246.965, -8.28622 },
				{ "dressed_myyydril_miner_f_01", "hall36", 129.176, -159.715, -210.516, -53.8581 },
				{ "dressed_myyydril_miner_f_02", "hall36", 137.584, -160.284, -183.772, -98.5501 },
				{ "dressed_myyydril_miner_m_01", "hall36", 108.445, -160.217, -196.787, 141.486 },
				{ "dressed_myyydril_miner_m_02", "hall38", 77.8634, -188.084, -135.119, -0.192075 },
				{ "dressed_myyydril_miner_m_03", "hall38", 73.9995, -196.095, -166.608, -112.978 },
				{ "dressed_myyydril_guard_f_01", "hall39", 42.3038, -198.182, -195.802, -8.81384 },
				{ "dressed_myyydril_guard_m_01", "hall39", 40.9426, -197.826, -171.114, 174.353 },
				{ "urnsoris", "hall71", -90.5615, -200.052, -177.59, 166.084 },
				{ "urnsoris_nurse", "hall70", -140.595, -199.865, -175.559, -51.3945 },
				{ "urnsoris", "hall70", -123.892, -199.937, -167.536, 64.3826 },
				{ "urnsoris", "hall70", -97.7126, -199.993, -144.229, 0.511662 },
				{ "urnsoris", "hall69", -115.841, -199.579, -129.859, -63.0075 },
				{ "urnsoris", "hall69", -137.862, -200.275, -121.499, -46.8199 },
				{ "urnsoris_nurse", "hall72", -71.658, -200.267, -212.096, -31.8641 },
				{ "urnsoris_nurse", "hall72", -62.0804, -199.834, -210.382, -174.738 },
				{ "urnsoris_nurse", "hall72", -74.2529, -200.016, -225.482, -99.606 },
				{ "urnsoris", "hall71", -90.766, -200.045, -224.311, -15.8523 },
				{ "urnsoris", "hall71", -101.152, -199.833, -181.722, 94.9981 },
				{ "urnsoris", "hall64", -130.29, -167.374, -124.412, 44.5565 },
				{ "urnsoris", "hall64", -112.523, -167.361, -140.462, 136.699 },
				{ "urnsoris_nurse", "hall65", -96.1435, -167.281, -162.019, 160.101 },
				{ "urnsoris_nurse", "hall65", -98.063, -167.756, -183.395, -96.9666 },
				{ "urnsoris_nurse", "hall65", -114.041, -167.493, -181.021, -76.0282 },
				{ "urnsoris", "hall67", -161.711, -166.06, -185.628, -123.36 },
				{ "urnsoris_nurse", "hall66", -111.494, -167.411, -225.508, -117.025 },
				{ "urnsoris_nurse", "hall66", -122.596, -168.476, -241.871, 134.764 },
				{ "urnsoris_nurse", "hall66", -138.301, -168.278, -250.928, -1.60013 },
				{ "urnsoris_nurse", "hall66", -125.074, -169.256, -231.314, 95.8778 },
				{ "urnsoris", "bigroom40", -228.032, -222.821, -273.303, -98.9023 },
				{ "urnsoris_guard", "hall41", -207.426, -187.975, -356.064, -98.5502 },
				{ "urnsoris_guard", "hall41", -225.826, -188.65, -355.831, 118.576 },
				{ "urnsoris_guard", "hall42", -213.468, -183.031, -371.014, -94.8552 },
				{ "urnsoris_assassin", "hall42", -210.342, -177.409, -382.155, -144.298 },
				{ "urnsoris_guard", "hall42", -204.869, -174.955, -391.839, -64.2391 },
				{ "urnsoris_guard", "hall43", -183.866, -168.613, -426.173, 75.9953 },
				{ "urnsoris_assassin", "hall42", -179.621, -169.212, -403.305, -27.8171 },
				{ "urnsoris_queen", "hall43", -149.489, -172.906, -421.358, -81.6587 },
				{ "urnsoris_handmaiden", "hall43", -160.104, -169.084, -413.562, 123.679 },
				{ "urnsoris_handmaiden", "hall43", -166.636, -168.889, -429.96, 13.004 },
				{ "urnsoris_nurse", "hall64", -156.794, -168.21, -157.36, -69.1657 },
				{ "urnsoris_nurse", "hall64", -151.103, -168.211, -130.718, -11.8051 },
				{ "urnsoris", "bigroom40", -125.534, -173.371, -86.994, 32.0078 },
				{ "urnsoris", "bigroom40", -123.959, -196.273, -38.1244, -113.154 },
				{ "urnsoris", "bigroom40", -142.349, -196.288, -37.5862, -138.734 },
				{ "urnsoris", "bigroom40", -142.115, -198.717, -63.4563, -160.661 },
				{ "urnsoris", "bigroom40", -152.459, -204.76, -92.6718, -178.256 },
				{ "urnsoris", "hall73", -80.5427, -200.077, -184.47, 31.3041 },
				{ "urnsoris", "bigroom40", -232.158, -251.901, -181.587, 13.1809 },
				{ "urnsoris", "bigroom40", -234.745, -253.108, -153.528, 24.4417 },
				{ "urnsoris", "bigroom40", -215.911, -252.974, -119.88, 59.8083 },
				{ "urnsoris_assassin", "bigroom40", -220.282, -252.899, -100.07, 14.7642 },
				{ "urnsoris_assassin", "bigroom40", -184.424, -254.152, -64.4766, 71.421 },
				{ "urnsoris_assassin", "bigroom40", -133.319, -261.871, -73.2864, 137.051 },
				{ "urnsoris_assassin", "hall75", -134.645, -263.905, -120.932, -72.1567 },
				{ "urnsoris_assassin", "hall78", -143.513, -263.931, -258.537, -27.2736 },
				{ "urnsoris_assassin", "hall78", -152.582, -264.206, -241.53, -65.9981 },
				{ "urnsoris_assassin", "hall79", -178.121, -263.586, -221.024, -104.708 },
				{ "urnsoris_assassin", "bigroom40", -227.026, -269.325, -228.67, -72.6843 },
				{ "urnsoris_assassin", "bigroom40", -224.363, -268.731, -218.952, 40.2776 },
				{ "urnsoris_worker", "hall47", -336.93, -272.54, -211.368, -147.816 },
				{ "urnsoris_worker", "hall47", -340.282, -271.306, -186.639, -10.3967 },
				{ "urnsoris_assassin", "hall47", -326.153, -273.106, -196.546, 173.298 },
				{ "urnsoris_assassin", "hall47", -325.43, -273.247, -208.26, -97.1415 },
				{ "urnsoris_worker", "hall47", -350.215, -272.294, -200.579, -164.883 },
				{ "urnsoris_worker", "hall47", -348.644, -267.069, -164.439, 13.3571 },
				{ "urnsoris_worker", "hall48", -363.35, -263.985, -161.197, -139.546 },
				{ "urnsoris_worker", "hall48", -372.264, -259.451, -148.895, -35.7338 },
				{ "urnsoris_worker", "hall48", -364.401, -254.24, -133.716, 40.4538 },
				{ "urnsoris_assassin", "borglestatue49", -379.283, -255.592, -122.147, 42.0375 },
				{ "urnsoris_assassin", "borglestatue49", -365.933, -255.644, -107.159, 53.8264 },
				{ "urnsoris_worker", "borglestatue49", -384.104, -254.041, -98.9196, -46.8188 },
				{ "urnsoris_worker", "borglestatue49", -380.54, -247.825, -84.2129, 34.8234 },
				{ "urnsoris_worker", "hall50", -380.546, -241.697, -66.2874, -27.4639 },
				{ "urnsoris_assassin", "hall50", -348.102, -228.234, -68.1254, -165.763 },
				{ "urnsoris_assassin", "hall50", -351.118, -219.052, -88.3319, -166.115 },
				{ "urnsoris_assassin", "hall50", -349.161, -217.333, -98.6776, -93.7983 },
				{ "urnsoris_assassin", "hall51", -378.803, -206.584, -99.3908, -43.6519 },
				{ "urnsoris_assassin", "hall51", -381.949, -202.735, -84.4611, -19.7223 },
				{ "urnsoris_assassin", "hall52", -369.066, -197.726, -63.8687, -155.03 },
				{ "urnsoris", "bigroom40", -197.541, -252.807, -95.7474, -162.95 },
				{ "urnsoris", "hall44", -221.596, -221.117, 18.1722, 84.0884 },
				{ "urnsoris", "hall44", -210.891, -221.049, 18.5336, -90.2811 },
				{ "dressed_myyydril_refugee_f_01", "hall46", -109.723, -222.243, 127.402, 116.64 },
				{ "dressed_myyydril_refugee_f_02", "hall46", -116.599, -222.665, 132.686, 161.338 },
				{ "dressed_myyydril_refugee_f_03", "hall46", -108.923, -197.932, 92.7883, -15.8527 },
				{ "dressed_myyydril_refugee_f_04", "hall46", -123.679, -197.04, 81.1694, 49.25 },
				{ "dressed_myyydril_refugee_m_01", "hall46", -108.148, -197.379, 73.6902, 48.24 },
				{ "dressed_myyydril_refugee_m_02", "hall46", -93.3514, -196.78, 75.2431, 89.3673 },
				{ "dressed_myyydril_refugee_m_03", "hall46", -82.4134, -222.145, 116.72, 110.13 },
				{ "dressed_myyydril_refugee_f_01", "hall46", -74.6354, -221.927, 132.074, 123.502 },
				{ "urnsoris", "hall46", -127.171, -221.342, 67.367, -64.0638 },
				{ "urnsoris", "hall45", -146.482, -220.098, 83.2689, -36.4392 },
				{ "urnsoris", "hall45", -166.189, -221.558, 82.3109, -164.357 },
				{ "urnsoris", "hall44", -178.716, -221.6, 66.9749, -121.776 },
				{ "urnsoris", "hall44", -194.707, -221.788, 44.6385, -129.166 },
				{ "urnsoris", "hall44", -213.214, -221.185, 43.3101, -179.313 },
				{ "urnsoris", "hall44", -194.231, -221.009, 60.5784, 104.323 },
				{ "dressed_myyydril_guard_f_01", "hall21", 153.711, -54.9012, 2.71724, 3.81246 },
				{ "dressed_myyydril_guard_m_01", "hall21", 160.065, -54.8491, 3.07508, 3.46052 },
				{ "dressed_myyydril_guard_f_01", "oil_pits", 160.607, -90.4312, -49.3582, -126.745 },
				{ "dressed_myyydril_refugee_f_02", "hall46", -93.834, -196.729, 75.8661, -89.5601 },
				{ "dressed_treun_lorn", "hall57", -217.655, -92.8194, 149.159, -86.8496 },
				{ "dressed_myyydril_guard_m_01", "hall18", 130.408, -44.3392, -11.4392, 110 },
				{ "dressed_myyydril_guard_f_01", "hall31", 128.859, -90.7804, -233.048, 93.3335 },
				{ "dressed_myyydril_patrol_leader", "hall33", 230.436, -123.529, -235.86, -41 },
				{ "dressed_patrol_member_01", "hall33", 230.962, -123.39, -239.278, -41 },
				{ "dressed_patrol_member_02", "hall33", 231.423, -123.363, -233.263, -41 },
				{ "dressed_cantina_girl", "lightningroom34", 228, 110, -339, -138 },
				{ "dressed_myyydril_isdan", "lightningroom34", 178, -117, -374, 0 },
				{ "dressed_cantina_patron", "lightningroom34", 224.398, -111.58, -353.986, -68.5096 },
				{ "dressed_myyydril_herder_m_03", "hall30", 146.032, -90.9052, -33.8932, -27.6245 },
				{ "dressed_myyydril_chasuli", "lightningroom34", 228.008, -123.109, -299.456, -57.1849 },
				{ "dressed_myyydril_mystic", "lightningroom34", 114.374, -123.528, -319.023, -84.6334 },
				{ "dressed_myyydril_greeter_guard", "lightningroom34", 187.976, -123.284, -356.324, -52.2582 },
				{ "dressed_myyydril_old_warris", "lightningroom34", 211.593, -122.919, -326.858, 20.4105 },
				{ "dressed_myyydril_ivesa", "lightningroom34", 215.747, -123.503, -309.579, 51.7302 },
				{ "dressed_myyydril_serileo", "lightningroom34", 205.77, -114.578, -280.313, 146.393 },
				{ "urnsoris", "hall73", -72.7851, -200.641, -172.819, 39.9843 },
				{ "urnsoris", "hall71", -97.6878, -200.184, -189.65, 33.6849 },
				{ "urnsoris", "hall71", -95.9804, -199.778, -214.871, 56.6784 },
				{ "urnsoris", "hall70", -95.8281, -200.01, -162.515, -175.993 },
				{ "urnsoris_nurse", "hall70", -105.728, -200.065, -164.843, -140.475 },
				{ "urnsoris", "hall70", -107.449, -200.197, -152.32, -112.303 },
				{ "urnsoris_nurse", "hall70", -130.776, -199.984, -150.521, -108.723 },
				{ "urnsoris_nurse", "hall70", -122.387, -199.874, -186.053, 16.2026 },
				{ "urnsoris_nurse", "hall70", -141.232, -200.13, -192.321, -19.728 },
				{ "urnsoris", "hall69", -96.1835, -200.326, -130.106, -79.0667 },
				{ "urnsoris", "hall69", -121.792, -199.511, -124.364, 24.8569 },
				{ "urnsoris", "hall64", -122.058, -167.827, -122.194, 10.1803 },
				{ "urnsoris", "hall65", -99.4722, -168.254, -137.614, 164.081 },
				{ "urnsoris_nurse", "hall65", -95.4395, -168.357, -148.951, -154.866 },
				{ "urnsoris", "hall67", -127.161, -167.486, -191.225, -119.131 },
				{ "urnsoris", "hall67", -143.379, -168.024, -193.258, -49.3304 },
				{ "urnsoris", "hall66", -135.71, -167.462, -212.942, 174.219 },
				{ "urnsoris", "hall66", -121.516, -167.229, -219.276, 117.997 },
				{ "urnsoris_nurse", "hall66", -96.7567, -168.634, -221.173, 125.999 },
				{ "urnsoris_young", "hall66", -116.178, -167.062, -254.353, -48.4987 },
				{ "urnsoris_young", "hall66", -132.778, -169.211, -229.632, -12.2667 },
				{ "urnsoris_young", "hall67", -128.992, -167.097, -200.207, 99.8573 },
				{ "urnsoris_nurse", "hall64", -140.598, -168.187, -157.224, -64.6406 },
				{ "urnsoris", "hall67", -177.962, -167.785, -191.879, 83.2814 },
				{ "urnsoris_assassin", "bigroom40", -243.565, -223.005, -275.678, 115.078 },
				{ "urnsoris_young", "hall43", -181.83, -169.08, -424.707, -123.764 },
				{ "urnsoris_handmaiden", "hall43", -162.182, -169.373, -425.266, -60.4983 },
				{ "urnsoris_assassin", "hall76", -158.261, -263.287, -127.462, 29.7816 },
				{ "urnsoris_assassin", "hall76", -162.665, -263.886, -142.235, 51.6794 },
				{ "urnsoris_assassin", "hall76", -147.039, -263.454, -150.734, 97.0733 },
				{ "urnsoris_assassin", "hall77", -114.844, -263.566, -152.889, -155.858 },
				{ "urnsoris_assassin", "hall77", -86.3763, -260.827, -176.253, -62.8441 },
				{ "urnsoris_assassin", "hall77", -82.4326, -263.14, -148.514, -1.79468 },
				{ "urnsoris_young", "hall77", -85.4961, -263.052, -137.062, -39.179 },
				{ "urnsoris_young", "hall77", -93.4207, -263.578, -139.965, -103.621 },
				{ "urnsoris_young", "hall77", -91.4506, -263.467, -147.723, 169.984 },
				{ "urnsoris_young", "hall77", -89.4495, -262.024, -162.771, -141.533 },
				{ "urnsoris_young", "hall77", -99.4975, -263.064, -170.897, -129.193 },
				{ "urnsoris_assassin", "hall77", -109.452, -265.576, -190.976, -153.591 },
				{ "urnsoris_assassin", "hall77", -97.0835, -262.577, -203.522, 151.153 },
				{ "urnsoris_assassin", "hall77", -109.16, -265.908, -232.217, -113.419 },
				{ "urnsoris_young", "hall77", -119.005, -263.922, -224.187, -45.9008 },
				{ "urnsoris_young", "hall77", -128.417, -263.751, -214.226, 26.7147 },
				{ "urnsoris_young", "hall77", -117.947, -262.411, -213.213, 95.5103 },
				{ "urnsoris_young", "hall77", -130.536, -263.775, -178.448, 20.8024 },
				{ "urnsoris_young", "hall77", -121.887, -262.913, -179.783, 102.385 },
				{ "urnsoris_young", "hall77", -123.149, -263.828, -158.205, 11.9089 },
				{ "urnsoris_young", "hall77", -107.621, -263.447, -145.902, 76.0419 },
				{ "urnsoris_young", "hall77", -77.2086, -262.479, -192.218, -123.735 },
				{ "urnsoris_young", "hall77", -79.6007, -263.027, -228.093, -26.9605 },
				{ "urnsoris_young", "hall77", -94.413, -261.799, -240.832, -68.151 },
				{ "urnsoris_young", "hall77", -122.708, -263.344, -243.734, -137.07 },
				{ "urnsoris_assassin", "hall79", -168.819, -262.934, -239.951, -14.0703 },
				{ "urnsoris_assassin", "bigroom40", -203.464, -263.327, -229.324, -78.7059 },
				{ "urnsoris_assassin", "bigroom40", -204.053, -264.465, -219.638, -94.9377 },
				{ "urnsoris_assassin", "hall52", -352.762, -188.962, -68.5721, 82.6145 },
				{ "urnsoris_assassin", "hall52", -339.183, -187.025, -55.2882, -149.882 },
				{ "urnsoris_assassin", "hall52", -333.341, -187.504, -55.7555, 25.6833 },
				{ "urnsoris", "morag53", -362.731, -174.723, 68.1374, 169.966 },
				{ "dressed_myyydril_sick_01", "morag53", -327.648, -193.512, 35.9007, 98.3814 },
				{ "urnsoris_assassin", "morag53", -338.327, -185.646, -29.9445, 163.308 },
				{ "dressed_myyydril_sick_02", "morag53", -358.279, -191.987, -24.3221, 16.7391 },
				{ "dressed_myyydril_sick_03", "morag53", -351.508, -183.641, 9.31434, -11.9412 },
				{ "dressed_myyydril_sick_04", "morag53", -351.349, -184.386, 20.1809, -4.5512 },
				{ "urnsoris_assassin", "morag53", -389.421, -186.188, 21.8683, -102.909 },
				{ "dressed_myyydril_sick_05", "morag53", -375.858, -192.969, 35.4495, 144.129 },
				{ "urnsoris_assassin", "morag53", -311.893, -178.82, 55.9735, -16.1641 },
				{ "dressed_myyydril_sick_06", "morag53", -327.158, -190.19, 81.2808, -20.211 },
				{ "dressed_myyydril_sick_01", "morag53", -319.444, -189.231, 95.585, -157.278 },
				{ "dressed_myyydril_sick_02", "morag53", -336.972, -193.424, 109.427, -71.7651 },
				{ "urnsoris_assassin", "morag53", -354.376, -190.02, 115.88, -48.1873 },
				{ "dressed_myyydril_sick_03", "morag53", -385.543, -186.819, 121.203, -42.0289 },
				{ "dressed_myyydril_sick_04", "morag53", -386.172, -190.264, 105.224, -145.665 },
				{ "urnsoris_assassin", "morag53", -388.036, -183.492, 133.571, 173.308 },
				{ "urnsoris_assassin", "morag53", -415.258, -192.434, 110.468, -120.182 },
				{ "dressed_myyydril_sick_05", "morag53", -398.806, -190.779, 58.5673, 151.49 },
				{ "dressed_myyydril_sick_06", "morag53", -399.372, -191.382, 101.748, -25.5188 },
				{ "dressed_myyydril_sick_01", "morag53", -402.934, -186.789, 141.902, 31.8419 },
				{ "dressed_myyydril_sick_02", "morag53", -392.371, -189.679, 158.708, 26.3873 },
				{ "dressed_myyydril_lost_erriya", "morag53", -388.898, -178.761, 175.349, -179.126 },
				{ "dressed_myyydril_sick_03", "morag53", -414.037, -191.639, 122.902, -124.932 },
				{ "urnsoris_assassin", "morag53", -418.987, -182.892, 67.0751, -165.225 },
				{ "dressed_myyydril_sick_04", "morag53", -317.388, -183.311, 65.9697, 137.59 },
				{ "urnsoris_assassin", "morag53", -321.613, -190.744, 27.722, -39.5946 },
				{ "dressed_myyydril_sick_05", "morag53", -384.542, -190.937, 156.198, 86.7394 },
				{ "dressed_myyydril_sick_06", "morag53", -361.438, -187.467, 191.655, 109.613 },
				{ "dressed_myyydril_sick_01", "morag53", -346.378, -188.162, 190.403, 91.8423 },
				{ "urnsoris_assassin", "morag53", -325.542, -188.371, 192.278, 133.895 },
				{ "dressed_myyydril_sick_02", "morag53", -306.971, -188.21, 188.575, -59.6536 },
				{ "dressed_myyydril_sick_03", "morag53", -299.424, -190.363, 167.224, 159.936 },
				{ "urnsoris_assassin", "morag53", -285.869, -188.864, 166.816, 93.6014 },
				{ "urnsoris_assassin", "hall54", -267.033, -184.564, 167.379, 57.7063 },
				{ "urnsoris_assassin", "hall54", -265.113, -178.616, 187.724, 150.258 },
				{ "urnsoris_assassin", "hall54", -274.199, -177.763, 206.615, -131.091 },
				{ "urnsoris_assassin", "hall54", -295.924, -177.963, 210.362, -96.9565 },
				{ "urnsoris_assassin", "hall54", -324.807, -177.663, 207.5, -66.8685 },
				{ "urnsoris_assassin", "hall54", -346.48, -163.812, 207.777, -94.3172 },
				-- OPEN ep3_forgotten_creation  "hall61"  -163.793, -66.0753, 56.3436, 138.299
				-- OPEN ep3_forgotten_creation  "hall61"  -143.439, -68.0613, 49.7888, 111.906
				-- OPEN ep3_forgotten_creation  "hall61"  -133.926, -66.2461, 56.2187, 27.2728
				-- OPEN ep3_forgotten_creation  "hall61"  -131.021, -66.5682, 36.5596, 159.765
				-- OPEN ep3_forgotten_creation  "hall61"  -119.907, -65.3093, 41.4883, 64.2229
				-- OPEN ep3_forgotten_creation  "hall61"  -112.023, -61.5444, 28.0883, 157.126
				-- OPEN ep3_forgotten_creation  "hall61"  -100.821, -57.9983, 26.6354, 101.349
				-- OPEN ep3_forgotten_creation  "hall61"  -94.8129, -57.339, 17.3569, 130.733
				-- OPEN ep3_forgotten_creation  "hall62"  -64.7754, -42.9853, 23.7196, 152.903
				-- OPEN ep3_forgotten_creation  "hall62"  -64.3535, -41.1795, 10.4504, 159.765
				-- OPEN ep3_forgotten_creation  "hall62"  -59.5068, -34.975, -4.11938, 117.889
				-- OPEN ep3_forgotten_creation  "hall62"  -57.5454, -42.959, 18.6899, 40.2933
				{ "dressed_myyydril_compactor", "lightningroom34", 208.863, -122.809, -323.031, 34.4489 },
				-- OPEN ep3_myyydril_lorn_servant  "hall55"  -361, -145, 169, 12
				{ "dressed_myyydril_pers", "lightningroom34", 165.486, -147.825, -286.364, -101.727 },
				{ "uwari_beetle_aggro", "hall3", 10.282, -17.2765, -41.346, -2.19559 },
				{ "uwari_beetle_aggro", "hall3", 1.09388, -16.4583, -38.4621, 81.1276 },
				{ "uwari_beetle_aggro", "hall4", 13.2659, -21.1207, -57.8446, -117.862 },
				{ "uwari_beetle_aggro", "hall4", 4.2932, -21.9665, -60.0962, 78.9006 },
				{ "uwari_beetle_aggro", "hall5", -5.45612, -23.3196, -69.7975, -171.924 },
				{ "uwari_beetle_aggro", "hall5", -6.20541, -23.4719, -85.2956, 92.4764 },
				{ "uwari_beetle_aggro", "hall5", 2.77548, -21.8867, -85.0015, -77.7648 },
				{ "uwari_beetle_aggro", "hall5", 24.4632, -15.6197, -80.0502, 121.461 },
				{ "uwari_beetle_aggro", "hall8", 36.1459, -13.1518, -88.5054, 10.6147 },
				{ "uwari_beetle_aggro", "hall8", 46.7311, -13.0149, -93.3726, 82.031 },
				{ "uwari_beetle_aggro", "hall12", 61.12, -14.6268, -80.9186, 79.7441 },
				{ "uwari_beetle_aggro", "hall12", 72.1958, -16.3647, -72.5835, -118.146 },
				{ "uwari_beetle_aggro", "hall12", 69.2942, -14.6515, -83.6647, -47.6996 },
				{ "uwari_beetle_aggro", "hall15", 80.9088, -21.5786, -59.8052, 39.5459 },
				{ "uwari_beetle_aggro", "hall15", 85.7393, -22.0325, -52.1538, -148.237 },
				{ "uwari_beetle_aggro", "hall9", 68.9688, -18.5871, -44.2902, -96.8756 },
				{ "uwari_beetle_aggro", "hall16", 99.1537, -27.4516, -58.9261, 63.013 },
				{ "uwari_beetle_aggro", "hall16", 113.472, -33.5387, -53.1615, -115.981 },
				{ "uwari_beetle_aggro", "hall19", 124.172, -36.3608, -43.1886, 108.523 },
				{ "uwari_beetle_aggro", "hall19", 131.384, -36.6657, -54.4793, -15.8947 },
				{ "uwari_beetle_aggro", "hall19", 133.044, -41.5636, -70.2756, -130.673 },
				{ "uwari_beetle_aggro", "hall19", 122.4, -40.1499, -82.6049, -176.253 },
				{ "uwari_beetle_aggro", "hall14", 109.229, -36.9041, -95.0925, -33.7448 },
				{ "uwari_beetle_aggro", "hall14", 96.9874, -32.7555, -83.196, 140.364 },
				{ "uwari_beetle_aggro", "hall14", 92.3512, -32.2533, -93.9745, -107.46 },
				{ "uwari_beetle_aggro", "hall14", 82.9956, -30.3763, -95.5, 159.225 },
				{ "uwari_beetle_aggro", "hall13", 76.7341, -29.6746, -108.228, -45.203 },
				{ "uwari_beetle_aggro", "hall13", 65.7218, -29.1426, -101.079, -74.3695 },
				{ "uwari_beetle_aggro", "hall8", 43.0243, -29.9735, -102.618, -38.3462 },
				{ "uwari_beetle_aggro", "hall8", 44.7351, -29.8074, -86.6357, 32.3373 },
				{ "uwari_beetle_aggro", "hall6", 33.6506, -22.8741, -63.9208, 43.0353 },
				{ "uwari_beetle_aggro", "hall3", 34.8386, -21.2498, -46.2606, -36.2087 },
				{ "uwari_beetle_aggro", "hall3", 33.7738, -21.1431, -34.7444, -5.14588 },
				{ "uwari_beetle_aggro", "hall7", 27.7918, -21.096, -16.6394, 51.6105 },
				{ "uwari_beetle_aggro", "hall10", 49.2284, -26.8235, -18.6088, 107.469 },
				{ "uwari_beetle_aggro", "hall10", 53.2921, -26.9289, -3.76058, 13.702 },
				{ "uwari_beetle_aggro", "hall10", 62.2331, -26.6181, -15.0585, -71.679 },
				{ "uwari_beetle_aggro", "hall10", 71.3232, -29.0831, 5.46864, 112.448 },
				{ "uwari_beetle_aggro", "hall10", 83.8386, -34.332, -1.06825, 121.887 },
				{ "uwari_beetle_aggro", "hall17", 104.069, -41.7739, 1.90033, 169.889 },
				{ "uwari_beetle_aggro", "hall17", 96.4989, -39.7595, -13.1013, -135.452 },
				{ "uwari_beetle_aggro", "hall17", 91.5685, -37.1475, -27.276, -115.579 },
				{ "uwari_beetle_aggro", "hall11", 78.8226, -29.2769, -35.7567, -100.895 },
				{ "uwari_beetle_aggro", "hall9", 61.4853, -26.7455, -35.7015, -84.9094 },
				{ "uwari_beetle_aggro", "hall9", 57.8007, -26.8113, -50.5588, -103.526 },
				{ "uwari_beetle_aggro", "hall18", 115.308, -44.313, -33.4093, 35.5923 },
				{ "uwari_beetle_aggro", "hall18", 129.205, -44.4045, -21.4959, 81.202 },
				{ "uwari_beetle_aggro", "hall18", 146.792, -41.6294, -15.6817, 77.6646 },
				-- OPEN ep3_forgotten_creation  "hall63"  -43.3808, -34.5157, -12.2606, -169.104
				-- OPEN ep3_forgotten_creation  "hall63"  -51.9838, -25.1847, -41.5529, -164.311
				-- OPEN ep3_forgotten_creation  "hall63"  -22.8156, -19.2073, -40.2493, 93.611
				{ "dressed_myyydril_refugee_f_01", "hall46", -63.545, -222.07, 96.3889, -7.17393 },
				{ "dressed_myyydril_refugee_f_02", "hall46", -63.6293, -221.649, 116.499, -69.4608 },
				{ "dressed_myyydril_refugee_f_03", "hall46", -85.3694, -221.658, 121.309, -11.3567 },
				{ "dressed_myyydril_refugee_f_04", "hall46", -97.8823, -221.644, 114.605, 108.579 },
				{ "dressed_myyydril_refugee_m_01", "hall46", -102.747, -221.722, 123.599, -22.3489 },
				{ "dressed_myyydril_refugee_m_02", "hall46", -119.649, -197.633, 81.9757, 129.497 },
				{ "dressed_myyydril_refugee_m_03", "hall46", -109.946, -197.818, 86.6549, 95.0595 },
				{ "dressed_myyydril_refugee_f_01", "hall46", -93.3029, -221.826, 85.1953, 1.89417 },
				{ "clone_droid", "hall1", 0.3, -1.9, -7.5, -90 },
			},
		},
		{
			key = "avatar_platform",
			label = "Avatar Platform",
			table = "ep3_avatar_platform.tab",
			rows = {
				{ "ep3_wke_civilian_03", "room", -135.5, 0, -154.2, 27 },
				{ "ep3_wke_civilian_03", "room", -125.1, 0, -149.4, -69 },
				{ "ep3_wke_civilian_03", "room", -133.5, 0, -149.4, 22 },
				{ "ep3_blackscale_guard_m_01", "mainhangar", 36.3, 0, 18.4, -90 },
				{ "ep3_blackscale_guard_m_02", "mainhangar", 36.3, 0, 24.7, -90 },
				{ "ep3_wke_civilian_01", "jails", -160.4, -0.5, -133.5, -90 },
				{ "ep3_wke_civilian_02", "jails", -183.7, -0.5, -133.8, 90 },
				{ "ep3_wke_civilian_03", "jails", -181.6, -0.5, -154.8, 90 },
				{ "ep3_avatar_jawa", "securityoffice", -160.8, 0, -124.7, 0 },
				{ "ep3_blackscale_guard_m_03", "barracksanteroom", -44.2, 0, -98, 66 },
				{ "ep3_blackscale_assault_m_01", "barracksanteroom", -48.2, 0, -104.8, 103 },
				{ "ep3_wke_commando_01", "cavehall03", -57.3, 0, 71.1, -90 },
				{ "ep3_wke_freedom_fighter_01", "cavehall03", -52.9, 0, 75.2, -113 },
				{ "ep3_blackscale_guard_m_04", "anteroom", 60.9, 0, -69.4, -99 },
				{ "ep3_blackscale_guard_m_01", "checkpoint01", 13.5, 0, 56, 53 },
				{ "ep3_blackscale_guard_m_02", "systemscontrol", -88.1, 0, 32.8, 0 },
				{ "ep3_blackscale_guard_m_03", "systemscontrol", -93.5, 0, 33.7, 0 },
				{ "ep3_blackscale_guard_m_04", "cavehall03", -68.8, 0, 76.7, 100 },
				{ "ep3_blackscale_assault_m_02", "anteroom", 49.3, 0, -61.6, 142 },
				{ "ep3_blackscale_assault_m_03", "mainhangar", 29.3, 0, 21.8, 90 },
				{ "ep3_blackscale_assault_m_01", "generalstorage", -14.7, 0, 19.6, 0 },
				{ "ep3_blackscale_assault_m_02", "barracksanteroom", -95.3, 0, 19.2, 90 },
				{ "ep3_blackscale_assault_m_03", "cavehall03", -64.6, 0, 72.4, 90 },
				{ "ep3_blackscale_guard_m_01", "cavehall09", -127.5, 0, -121.3, -90 },
				{ "ep3_blackscale_trooper_m_01", "navigationroom", -170, 0, 35, 90 },
				{ "ep3_wke_civilian_04", "jails", -160.4, -0.5, -145, -90 },
				{ "ep3_wke_civilian_05", "jails", -182.5, -0.5, -144.5, 90 },
				{ "ep3_blackscale_guard_m_01", "mainhangar", 62.6, 0, 26.3, -12 },
				{ "ep3_blackscale_guard_m_02", "mainhangar", 61.6, 0, 15.6, 89 },
				{ "ep3_blackscale_guard_m_03", "mainhangar", 54.2, 0, 10, 59 },
				{ "ep3_blackscale_guard_m_04", "mainhangar", 53.8, 0, 33.4, 87 },
				{ "ep3_blackscale_guard_m_01", "commandhall01", 45.3, 0, 58.8, 52 },
				{ "ep3_blackscale_assault_m_01", "commandhall01", 47.2, 0, 62, -141 },
				{ "ep3_blackscale_guard_m_02", "checkpoint01", 16, 0, 62.2, -175 },
				{ "ep3_blackscale_guard_m_03", "checkpoint01", 15.8, 0, 58.6, 0 },
				{ "ep3_blackscale_assault_m_02", "checkpoint01", 13.2, 0, 53, 176 },
				{ "ep3_blackscale_guard_m_04", "generalstorage", -11.6, 0, 23.8, -17 },
				{ "ep3_blackscale_guard_m_01", "generalstorage", -20.3, 0, 20, -51 },
				{ "ep3_blackscale_guard_m_02", "generalstorage", -18.4, 0, 17.4, -49 },
				{ "ep3_blackscale_guard_m_03", "generalstorage", -4.5, 0, 21.4, -36 },
				{ "ep3_wke_freedom_fighter_02", "generalstorage", -10.9, 0, 33.5, 160 },
				{ "ep3_wke_freedom_fighter_03", "generalstorage", -17.7, 0, 32.5, 145 },
				{ "ep3_wke_freedom_fighter_04", "generalstorage", -28.7, 0, 27.2, 136 },
				{ "ep3_blackscale_guard_m_04", "secondarystorage", -45.9, 0, 35.4, 122 },
				{ "ep3_blackscale_guard_m_01", "secondarystorage", -49.2, 0, 44.6, 130 },
				{ "ep3_blackscale_guard_m_02", "secondarystorage", -56.5, 0, 27.6, 78 },
				{ "ep3_wke_civilian_06", "rockchasm", -75.1, 0, 97.8, 135 },
				{ "ep3_wke_civilian_01", "rockchasm", -57.2, 0, 99, -125 },
				{ "ep3_wke_civilian_02", "rockchasm", -67, 0.7, 93.4, 99 },
				-- OPEN ep3_avatar_wke_battleleader  "cavehall03"  -53, 0, 74, -74
				{ "ep3_wke_freedom_fighter_05", "cavehall03", -58.7, 0, 70.5, -65 },
				{ "ep3_blackscale_guard_m_03", "cavehall03", -71.1, 0, 80.4, 112 },
				{ "ep3_blackscale_guard_m_04", "cavehall03", -77.5, 0, 74, 88 },
				{ "ep3_blackscale_guard_m_01", "cavehall03", -69.5, 0, 70.7, 72 },
				{ "ep3_blackscale_guard_m_02", "cavehall03", -88.6, 0, 61.1, -1 },
				{ "ep3_blackscale_guard_m_03", "cavehall04", -93.2, 0, 51.8, 13 },
				{ "ep3_blackscale_guard_m_04", "cavehall03", -87.3, 0, 54, -7 },
				{ "ep3_blackscale_guard_m_01", "controlroom", -85.8, -0.3, 17.7, -86 },
				{ "ep3_blackscale_assault_m_03", "controlroom", -90.5, -0.3, 13.7, 6 },
				{ "ep3_blackscale_guard_m_02", "controlroom", -94.3, -0.3, 17.1, -86 },
				{ "ep3_blackscale_enforcer_m_01", "systemscontrol", -72.8, 0, 30.2, -43 },
				{ "ep3_blackscale_guard_m_03", "systemscontrol", -82.1, 9, 1, 69 },
				{ "ep3_blackscale_assault_m_01", "systemscontrol", -99.8, 9, 1, -52 },
				{ "ep3_blackscale_enforcer_m_02", "powercore", -85.3, 10.1, -16.3, -70 },
				{ "ep3_blackscale_guard_m_04", "powercore", -96.1, 10.1, -20.5, 36 },
				{ "ep3_blackscale_guard_m_01", "cavehall01", -26.6, 0, -9.2, 177 },
				{ "ep3_blackscale_guard_m_02", "cavehall01", -30.7, 0, -15.4, 161 },
				{ "ep3_wke_civilian_03", "cavemaintenance", 3.4, -0.6, -57.8, -94 },
				{ "ep3_wke_civilian_04", "cavemaintenance", -14.2, 0.1, -54.3, 66 },
				{ "ep3_wke_civilian_05", "cavemaintenance", -5.1, 0, -43.6, 3 },
				{ "ep3_wke_civilian_06", "cavemaintenance", -3.2, 0.4, -26.2, -111 },
				{ "ep3_wke_civilian_01", "cavemaintenance", -12.3, 0.2, -29.1, -89 },
				{ "ep3_blackscale_guard_m_03", "cavehall02", -31.7, 0, -48.3, 14 },
				{ "ep3_blackscale_guard_m_04", "cavehall02", -44.1, 0, -50.3, 71 },
				{ "ep3_wke_freedom_fighter_01", "cavehall01", -27.6, -0.1, -28.9, -169 },
				{ "ep3_wke_commando_02", "cavehall01", -23.1, 0, -25.5, -20 },
				{ "ep3_blackscale_guard_m_01", "powercore", -80.2, 0.1, -50.2, 85 },
				{ "ep3_blackscale_guard_m_02", "powercore", -90.2, 0.1, -60.4, 176 },
				{ "ep3_blackscale_guard_m_03", "powercore", -100.2, 0.1, -50, -90 },
				{ "ep3_blackscale_assault_m_02", "powercore", -90.2, -9.9, -25.3, -98 },
				{ "ep3_blackscale_guard_m_04", "powercore", -85.3, -13.9, -43.7, -69 },
				{ "ep3_blackscale_enforcer_m_03", "powercore", -94.5, -13.9, -44.1, 44 },
				{ "ep3_blackscale_guard_m_01", "powercore", -87.9, -13.9, -68.4, 77 },
				{ "ep3_blackscale_guard_m_02", "powercore", -82, -13.9, -80.6, 90 },
				{ "ep3_blackscale_guard_m_03", "powercore", -65.9, -13.9, -63.3, -45 },
				{ "ep3_blackscale_guard_m_04", "powercore", -115.9, 0.1, -74, 60 },
				{ "ep3_blackscale_assault_m_03", "powercore", -103.9, 0.1, -89.3, 20 },
				{ "ep3_blackscale_guard_m_01", "powercore", -95.9, 0.1, -90.3, -22 },
				{ "ep3_blackscale_guard_m_02", "barracksanteroom", -52.2, 0, -111.1, 49 },
				{ "ep3_blackscale_guard_m_03", "barracksanteroom", -49.4, 0, -102.4, 76 },
				{ "ep3_blackscale_guard_m_04", "cavehall05", 10.3, 0.2, -92.8, 56 },
				{ "ep3_blackscale_guard_m_01", "cavehall05", 15.1, 0.3, -96.8, -14 },
				{ "ep3_blackscale_guard_m_02", "cavehall05", 15, 0, -89.9, -168 },
				{ "ep3_blackscale_guard_m_03", "anteroom", 45.6, 0, -61.1, 112 },
				{ "ep3_wke_civilian_02", "cavekitchen", 23.2, 0, -47.6, 46 },
				{ "ep3_wke_civilian_03", "cavekitchen", 21.3, -0.1, -29.1, -5 },
				{ "ep3_wke_civilian_04", "cavekitchen", 4.8, 0.1, -14.2, 103 },
				{ "ep3_wke_civilian_05", "cavekitchen", 9.4, -0.1, -9.8, 166 },
				{ "ep3_wke_civilian_06", "cavekitchen", 49.4, 0.2, -27.6, -169 },
				{ "ep3_blackscale_guard_m_04", "techhall03", 59.4, 0, -29.1, 0 },
				{ "ep3_blackscale_assault_m_01", "techhall03", 60, 0, -25.8, 179 },
				{ "ep3_wke_freedom_fighter_02", "techhall07", -39.8, 0, -158, 5 },
				{ "ep3_wke_freedom_fighter_03", "techhall07", -38.1, 0, -154.1, -155 },
				{ "ep3_wke_freedom_fighter_04", "techhall07", -43, 0, -156.8, 76 },
				{ "ep3_wke_freedom_fighter_05", "barracks01", -48.6, 0, -169, 102 },
				{ "ep3_wke_freedom_fighter_01", "barracks01", -56, 0, -181.6, 141 },
				{ "ep3_wke_freedom_fighter_02", "barracks01", -65.1, 0, -173, -55 },
				{ "ep3_wke_commando_03", "barracks01", -68.4, 0, -183, 85 },
				{ "ep3_wke_freedom_fighter_03", "barracks02", -55.2, 0, -141.5, 103 },
				{ "ep3_wke_freedom_fighter_04", "barracks02", -52.7, 0, -141.9, -76 },
				{ "ep3_wke_freedom_fighter_05", "cavehall07", -99.5, 0, -154, -14 },
				{ "ep3_wke_freedom_fighter_01", "cavehall07", -96.6, 0.4, -147.9, -17 },
				{ "ep3_wke_commando_01", "cavehall07", -95.3, 0.1, -153.2, -23 },
				{ "ep3_wke_freedom_fighter_02", "cavehall08", -120.6, 0.1, -131.4, 95 },
				{ "ep3_wke_freedom_fighter_03", "cavehall08", -118.6, 0.1, -134.8, 81 },
				{ "ep3_blackscale_guard_m_01", "cavehall08", -98.9, 0, -136.5, 173 },
				{ "ep3_blackscale_guard_m_02", "techhall03", -102.1, 0, -133.7, -90 },
				{ "ep3_blackscale_guard_m_03", "cavehall09", -132.4, 0.1, -93.7, 133 },
				{ "ep3_blackscale_assault_m_02", "cavehall09", -129.5, 0.1, -94.5, -90 },
				{ "ep3_blackscale_guard_m_02", "securityoffice", -164, 0.1, -104, 154 },
				{ "ep3_blackscale_guard_m_03", "securityoffice", -159.7, 0, -109.1, -89 },
				{ "ep3_blackscale_guard_m_04", "securityoffice", -155.9, 0, -100.6, 161 },
				{ "ep3_blackscale_guard_m_01", "securityoffice", -162.5, 0.1, -100.8, -95 },
				{ "ep3_blackscale_guard_m_04", "commandhall04", -143.9, 0.1, -52, -144 },
				{ "ep3_blackscale_assault_m_03", "commandhall04", -137.7, 0.1, -50.4, -81 },
				{ "ep3_blackscale_guard_m_01", "commandhall04", -145, 0, -47, -22 },
				{ "ep3_wke_freedom_fighter_04", "commandhall04", -144.3, 0.1, -64.7, 7 },
				{ "ep3_wke_commando_02", "commandhall04", -148.7, 0, -62.6, 13 },
				{ "ep3_wke_freedom_fighter_05", "commandhall04", -148.3, 0.1, -36.3, 162 },
				{ "ep3_wke_freedom_fighter_01", "commandhall04", -144.6, 0, -37.2, -175 },
				{ "ep3_wke_freedom_fighter_02", "commandcorridor", -163.6, 0.1, -26.5, 96 },
				-- OPEN ep3_avatar_wke_battleleader  "commandcorridor"  -174.8, 0.1, -28.6, 63
				{ "ep3_wke_freedom_fighter_03", "commandcorridor", -171.5, 0, -22.8, 88 },
				{ "ep3_wke_freedom_fighter_04", "commandcorridor", -161.6, 0.1, -16.8, 145 },
				{ "ep3_wke_commando_03", "commandhall06", -171.7, 0, 1.3, -23 },
				{ "ep3_wke_commando_01", "commandhall06", -170.3, 0, 6.1, -13 },
				{ "ep3_blackscale_guard_m_02", "commandhall06", -174.5, 0.1, 17.9, 165 },
				{ "ep3_blackscale_guard_m_03", "commandhall06", -171.4, 0, 15.8, -176 },
				{ "ep3_blackscale_guard_m_04", "navigationroom", -178.8, -0.3, 31.6, 122 },
				{ "ep3_blackscale_assault_m_01", "navigationroom", -186.2, 0, 44.8, -25 },
				{ "ep3_blackscale_enforcer_m_04", "navigationroom", -163.9, 0, 49.7, 48 },
				{ "ep3_blackscale_guard_m_01", "navigationroom", -170.5, -0.3, 44.3, -154 },
				{ "ep3_wke_commando_02", "commandhall07", -173, 0.1, -66.4, -138 },
				-- OPEN ep3_avatar_wke_battleleader  "commandhall07"  -176, 0, -71.3, 11
				{ "ep3_wke_freedom_fighter_05", "commandhall07", -182.3, 0.1, -71.2, 83 },
				-- OPEN ep3_avatar_wke_battleleader  "sensorsystems"  -185.1, -0.1, -84.4, -162
				{ "ep3_wke_commando_03", "sensorsystems", -190.8, -0.4, -89.7, -176 },
				{ "ep3_wke_freedom_fighter_01", "sensorsystems", -197.3, -0.1, -86.4, 167 },
				{ "ep3_blackscale_guard_m_02", "sensorsystems", -195.4, -0.1, -104.3, 1 },
				{ "ep3_blackscale_assault_m_02", "sensorsystems", -189.9, 0, -108.3, 0 },
				{ "ep3_blackscale_guard_m_03", "sensorsystems", -182.1, -0.1, -103.2, -21 },
				{ "ep3_wke_freedom_fighter_02", "cavehall03", -57.7, 0, 68.5, -65 },
				{ "ep3_wke_freedom_fighter_03", "cavehall03", -55.7, 0, 72.5, -65 },
				{ "ep3_wke_freedom_fighter_04", "generalstorage", -28.7, 0, 30.1, 136 },
				{ "ep3_wke_commando_01", "generalstorage", -25.7, 0, 27.2, 136 },
				{ "clone_droid", "entrance", 111, 0, 24.4, -128 },
			},
		},
	},

	spawnedCount = 0,
}

registerScreenPlay("KashyyykPobPopulation", true)

function KashyyykPobPopulation:start()
	if (not isZoneEnabled("kashyyyk_pob_dungeons")) then
		return
	end

	for i = 1, #self.pools do
		self:populatePool(self.pools[i])
	end

	print("KashyyykPobPopulation: " .. self.spawnedCount .. " creatures placed across the Kashyyyk POB dungeon copies")
end

function KashyyykPobPopulation:populatePool(pool)
	local buildings = self.copies[pool.key]

	if (buildings == nil or #buildings == 0) then
		print("KashyyykPobPopulation: copy list '" .. pool.key .. "' is empty; " .. pool.label .. " will not be populated")
		return
	end

	for i = 1, #buildings do
		self:populateCopy(pool, buildings[i])
	end
end

function KashyyykPobPopulation:populateCopy(pool, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("KashyyykPobPopulation: " .. pool.key .. " copy " .. buildingID .. " is missing; it gets no creatures")
		return
	end

	-- Resolved once per cell name rather than once per row. A cell the
	-- building does not have is reported once, by name, instead of once per row.
	local cells = {}

	for i = 1, #pool.rows do
		local row = pool.rows[i]
		local cellName = row[2]

		if (cells[cellName] == nil) then
			cells[cellName] = self:resolveCell(pBuilding, cellName)

			if (cells[cellName] == 0) then
				print("KashyyykPobPopulation: " .. pool.key .. " copy " .. buildingID .. " has no cell named '" .. cellName .. "'; its rows from " .. pool.table .. " are skipped")
			end
		end

		if (cells[cellName] ~= 0) then
			self:spawnRow(pool, row, cells[cellName], buildingID)
		end
	end
end

function KashyyykPobPopulation:resolveCell(pBuilding, cellName)
	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

	if (pCell == nil) then
		return 0
	end

	return SceneObject(pCell):getObjectID()
end

function KashyyykPobPopulation:spawnRow(pool, row, cellID, buildingID)
	local template = row[1]

	if (template == nil) then
		print("KashyyykPobPopulation: no template on a row of " .. pool.table .. "; that row is skipped")
		return
	end

	-- row is { repo template, cell, x, z, y, heading } and spawnMobile wants
	-- x, z, y, heading, so the row reads straight across. Heading is in DEGREES
	-- here -- see THE AXIS MAPPING. Respawn is self.respawn (600), the same
	-- argument MustafarDungeonPopulation:spawnRow passes at line 1230.
	local pMobile = spawnMobile("kashyyyk_pob_dungeons", template, self.respawn, row[3], row[4], row[5], row[6], cellID)

	if (pMobile == nil) then
		print("KashyyykPobPopulation: failed to spawn " .. template .. " in " .. row[2] .. " of " .. pool.key .. " copy " .. buildingID)
		return
	end

	self.spawnedCount = self.spawnedCount + 1
end
