-- Planet Region Definitions
--
-- {"regionName", x, y, shape and size, tier, {"spawnGroup1", ...}, maxSpawnLimit}
-- For circle and ring, x and y are the center point
-- For rectangles, x and y are the bottom left corner. x2 and y2 (see below) are the upper right corner
-- Shape and size is a table with the following format depending on the shape of the area:
--   - Circle: {CIRCLE, radius}
--   - Rectangle: {RECTANGLE, x2, y2}
--   - Ring: {RING, inner radius, outer radius}
-- Tier is a bit mask with the following possible values where each hexadecimal position is one possible configuration.
-- That means that it is not possible to have both a spawn area and a no spawn area in the same region, but
-- a spawn area that is also a no build zone is possible.
--
-- ===========================================================================
-- KASHYYYK_RRYATT_TRAIL -- PROVENANCE
-- ===========================================================================
-- Zone "kashyyyk_rryatt_trail" is its own zone, not a row on the merged
-- surface (trap 1: Kashyyyk is seven zones). PlanetManagerImplementation.cpp:633
-- opens "snapshot/" + zone->getZoneName() + ".ws"; PlanetManagerImplementation.cpp:923
-- opens "scripts/managers/planet/" + planetName + "_regions.lua". This file
-- exists so boot does not log the missing-regions error.
--
-- WHICH SHIPPED FILES GOVERN (ruling 2026-09-04, TRE order option (a):
-- mtg_patch_022.tre above mtg_patch_023.tre; 023 must stay loaded)
--   snapshot/kashyyyk_rryatt_trail.ws  mtg_patch_023.tre ONLY
--                                      629,473 B, 261 templates / 7302 nodes
--   terrain/kashyyyk_rryatt_trail.trn  mtg_planets.tre (also
--                                      mtg_patch_013_configurable_02.tre)
--                                      mapWidth 16384  (research E9)
--   023 is the only TRE that ships this snapshot. First listed wins
--   (src/tre3/TreeDirectory.h:16 setNoDuplicateInsertPlan); with 022 above 023
--   the 023-only path is still found because 022 does not carry it.
--
-- BUILDOUT -> WORLD CONVERSION {#kash-offset} (measured against
-- snapshot/kashyyyk_rryatt_trail.ws from mtg_patch_023.tre)
--   Trap 4: five levels are stacked by height in one zone, not separated in
--   x/z. Each tab has its own offset. The 023 snapshot carries SIX copies of
--   every level layout (two x-columns at approx -3908 and approx +444, three
--   z-bands). Levels 4 and 5 (K-11b) sit in the column x approx -3908 at
--   dz +2115. This round (K-11a) places levels 1-2 in that SAME instance copy
--   (dz +3365). Which of the six copies should be live is the maintainer's
--   decision (same question as the POB copies).
--   Level 1-2 (kashyyyk_rryatt_trail_lvl_1_and_2.tab, 13-column):
--     world_x = buildout_x - 3908    world_z = buildout_z + 3365
--     evidence: 30 building rows voted (-3908, 3365, dy 0) against the
--     snapshot. The other five copies vote (-3892, 69), (-3924, -3371),
--     (444, 3381), (460, 85), (428, -3355).
--   Level 3 (kashyyyk_rryatt_trail_lvl_3.tab, 11-column) is OPEN: the tab
--     does not match the snapshot under any constant offset. Its building
--     rows (poi_kash_rryatt_lvl2_* at heights ~87-102) find no node at a
--     consistent (dx, dz, dy); the level-3 layout in 023 must differ from
--     the leaked tab's frame. Nothing built this round.
--   Level 4 (kashyyyk_rryatt_trail_lvl_4.tab, 13-column):
--     world_x = buildout_x - 3908    world_z = buildout_z + 2115
--     evidence (three building rows matched to snapshot nodes):
--       Row 3 rootbush_s02 (344.241, 961.329) -> (-3563.759, 3076.329)
--       Row 65 endor_giant_catwalk (0.0, 0.0) -> (-3908.0, 2115.0)
--       Row 66 far_treewall_a1 (523.900, 1235.520) -> (-3384.100, 3350.520)
--   Level 5 (kashyyyk_rryatt_trail_lvl_5.tab, 13-column):
--     world_x = buildout_x - 2208    world_z = buildout_z + 2115
--     evidence (three building rows matched to snapshot nodes):
--       Row 44 tree_trunk_a2 (841.150, 574.515) -> (-1366.850, 2689.515)
--       Row 45 near_roots_a1 (1450.290, 15.040) -> (-757.710, 2130.040)
--       Row 46 tree_trunk_a2 (1275.630, 281.730) -> (-932.370, 2396.730)
--   Trap 5: lvl_1_and_2 (575 rows), lvl_4 (446), lvl_5 (390) are 13-column
--   (objid container server_template_crc cell_index px py pz ...); lvl_3
--   (557 rows) is 11-column (no objid/container). px is column 5 only on the 13.
--   Sources: 4 buildout tabs, 1968 rows; 28 rryatt_* type tables.
--
-- WHAT NOW EXISTS (K-11b + K-11a, ruling 2026-09-04)
--   * SPAWNAREA rows from SOE datatables/buildout/kashyyyk_rryatt_trail/
--     kashyyyk_rryatt_trail_lvl_4.tab (58) and kashyyyk_rryatt_trail_lvl_5.tab
--     (40) area_spawner.iff (98 sourced). Name is rryatt_sp_<lvl>_<buildout_row>
--     so each row traces to a sourced buildout line. wx/wz are already
--     dungeon-snapshot world coords using the per-level offsets above.
--     Spawn limit is SOE intSpawnCount (floored to 1). Radius is
--     max(SOE fltRadius, 32): a Core3 spawn area needs room for a lair.
--     A type table a surface round already built is reused by name; no second
--     file. New rryatt_* type tables get a lair + group this round.
--     kash_blackscale_enforcer was built by the north-dungeons round (K-8b);
--     its four level-4 rows are live. Coords stay sourced.
--   * 3 trail-guide quest NPCs + 1 rryatt_trail_rroot_spawner control object
--     are NOT in this file -- OPEN for the behaviours round.
--   * Levels 1-2 area_spawners (K-11a, ruling 2026-09-04): sourced from
--     kashyyyk_rryatt_trail_lvl_1_and_2.tab area_spawner.iff. Name is
--     rryatt_sp_12_<buildout_row>. World coords use (x - 3908, z + 3365)
--     so they sit in the same instance copy as levels 4-5. A type table
--     already on disk is reused by name; new rryatt_* tables get a lair
--     + group. Mouf type tables stay commented (no repo mouf template;
--     surface rounds established this).
--   * Level 3 is OPEN (tab does not match the 023 snapshot under any
--     constant offset; build nothing).
--   * patrol_spawner.iff rows and patrol_point_setup waypoints are OPEN
--     (not Core3 SPAWNAREA rows). Quest NPCs / control objects stay OPEN
--     for the behaviours round.
--
-- ZONE SHAPE
--   terrain/kashyyyk_rryatt_trail.trn reports mapWidth 16384, i.e. the zone
--   spans +/-8192 -- the same map size as the Kashyyyk surface, whose no-build
--   edges sit at +/-8000. These four rows copy that convention.

require("scripts.managers.planet.regions")

--[[

Kashyyyk Creature Spawn Groups
- kashyyyk_clone_droid
- kashyyyk_etyyy_clan_ziven
- kashyyyk_kash_blackscale_enforcer
- kashyyyk_rryatt_abandoned_battle_droid
- kashyyyk_rryatt_abandoned_droideka
- kashyyyk_rryatt_abandoned_super_battle_droid
- kashyyyk_rryatt_bolotaur
- kashyyyk_rryatt_bolotaur_special
- kashyyyk_rryatt_crazed_jedi
- kashyyyk_rryatt_escaped_wookiees
- kashyyyk_rryatt_feral_wookiee
- kashyyyk_rryatt_gotal_hunter
- kashyyyk_rryatt_gotal_hunter_leader
- kashyyyk_rryatt_katarn
- kashyyyk_rryatt_lobarorr
- kashyyyk_rryatt_minstyngar_elite_bloodspiller
- kashyyyk_rryatt_minstyngar_elite_bonecrusher
- kashyyyk_rryatt_minstyngar_elite_deathcaller
- kashyyyk_rryatt_minstyngar_scratch
- kashyyyk_rryatt_nestling
- kashyyyk_rryatt_rebels
- kashyyyk_rryatt_scout_troopers
- kashyyyk_rryatt_walluga_smasher
- kashyyyk_rryatt_walluga_smasher_boss
- kashyyyk_rryatt_walluga_smasher_elite
- kashyyyk_rryatt_webweaver_darkstalker
- kashyyyk_rryatt_webweaver_shadowravager
- kashyyyk_rryatt_webweaver_trailphantom

--]]

kashyyyk_rryatt_trail_regions = {
	-- No Build Zones
	-- INFERRED (convention, not shipped rows). Dimensionally justified: the
	-- governing terrain/kashyyyk_rryatt_trail.trn is mapWidth 16384 (+/-8192),
	-- identical to the Kashyyyk surface, which uses these exact bounds.
	{"northedge_kashyyyk_rryatt_trail_nobuild", -8000, 7640, {RECTANGLE, 8000, 8000}, NOBUILDZONEAREA},
	{"westedge_kashyyyk_rryatt_trail_nobuild", -8000, -7640, {RECTANGLE, -7640, 7640}, NOBUILDZONEAREA},
	{"southedge_kashyyyk_rryatt_trail_nobuild", -8000, -8000, {RECTANGLE, 8000, -7640}, NOBUILDZONEAREA},
	{"eastedge_kashyyyk_rryatt_trail_nobuild", 7640, -7640, {RECTANGLE, 8000, 7640}, NOBUILDZONEAREA},

	-- SPAWNAREA -- Rryatt Trail levels 4 and 5 (kashyyyk_rryatt_trail), K-11b
	-- Sourced area_spawner.iff: 98 (lvl_4.tab 58, lvl_5.tab 40).
	-- Live rows: 98 (the four kash_blackscale_enforcer rows went live with the north round's lair).
	-- Radius floor 32 m: a Core3 spawn area needs room for a lair.
	{"rryatt_sp_4_4", -3503.62, 3076.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_darkstalker"}, 2},
	{"rryatt_sp_4_5", -3415.62, 3089.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_darkstalker"}, 2},
	{"rryatt_sp_4_6", -3347.66, 3026.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_7", -3347.66, 3026.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_darkstalker"}, 2},
	{"rryatt_sp_4_8", -3256.69, 3018.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_9", -3256.69, 3018.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 1},
	{"rryatt_sp_4_10", -3195.50, 2981.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_11", -3195.50, 2981.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 2},
	{"rryatt_sp_4_12", -3184.68, 2895.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_13", -3184.68, 2895.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 2},
	{"rryatt_sp_4_14", -3162.43, 2976.09, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_15", -3162.43, 2976.09, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_darkstalker"}, 2},
	{"rryatt_sp_4_16", -3272.53, 2764.73, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_17", -3272.53, 2764.73, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_darkstalker"}, 2},
	{"rryatt_sp_4_18", -3238.58, 2758.34, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_darkstalker"}, 2},
	{"rryatt_sp_4_19", -3503.70, 2667.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_20", -3338.34, 2652.80, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_21", -3321.00, 2671.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_22", -3333.86, 2664.99, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_23", -3362.20, 2663.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_24", -3509.73, 2668.34, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_25", -3350.63, 2669.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 4},
	{"rryatt_sp_4_26", -3356.90, 2681.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 3},
	{"rryatt_sp_4_27", -3516.71, 2488.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 3},
	{"rryatt_sp_4_28", -3565.03, 2449.80, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 3},
	{"rryatt_sp_4_29", -3611.54, 2427.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 6},
	{"rryatt_sp_4_30", -3591.98, 2414.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 3},
	{"rryatt_sp_4_31", -3380.13, 2676.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 3},
	{"rryatt_sp_4_32", -3320.53, 2644.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_33", -3256.59, 2548.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_34", -3256.59, 2548.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 2},
	{"rryatt_sp_4_35", -3185.04, 2620.20, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_36", -3185.04, 2620.20, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 2},
	{"rryatt_sp_4_37", -3081.65, 2570.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_38", -3081.65, 2570.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 2},
	{"rryatt_sp_4_39", -3123.76, 2507.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 2},
	{"rryatt_sp_4_40", -3054.61, 2486.30, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_41", -3054.61, 2486.30, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 2},
	{"rryatt_sp_4_42", -2968.53, 2436.86, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_43", -2968.53, 2436.86, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 2},
	{"rryatt_sp_4_44", -2806.23, 2405.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_45", -2806.23, 2405.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 1},
	{"rryatt_sp_4_46", -2817.77, 2481.28, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 3},
	{"rryatt_sp_4_47", -2672.55, 2486.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 3},
	{"rryatt_sp_4_48", -2664.84, 2507.26, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 3},
	{"rryatt_sp_4_49", -2678.55, 2633.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 3},
	{"rryatt_sp_4_50", -2714.30, 2720.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 2},
	{"rryatt_sp_4_51", -2864.93, 2868.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 3},
	{"rryatt_sp_4_52", -2779.18, 2857.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_darkstalker"}, 1},
	{"rryatt_sp_4_53", -2843.19, 2940.41, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 1},
	{"rryatt_sp_4_54", -2785.18, 2968.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 2},
	{"rryatt_sp_4_55", -2813.26, 3006.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_darkstalker"}, 2},
	{"rryatt_sp_4_56", -2733.36, 2902.78, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 2},
	{"rryatt_sp_4_57", -2670.65, 2960.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 1},
	{"rryatt_sp_4_58", -2670.65, 2960.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 2},
	{"rryatt_sp_4_59", -2748.24, 2921.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_trailphantom"}, 2},
	{"rryatt_sp_4_60", -2675.06, 2965.66, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_feral_wookiee"}, 2},
	{"rryatt_sp_4_61", -2675.06, 2965.66, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_webweaver_shadowravager"}, 1},
	{"rryatt_sp_5_3", -1813.05, 2599.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_lobarorr"}, 1},
	{"rryatt_sp_5_5", -1291.38, 2515.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_katarn"}, 1},
	{"rryatt_sp_5_6", -1327.48, 2531.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_nestling"}, 1},
	{"rryatt_sp_5_7", -1337.63, 2506.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_nestling"}, 1},
	{"rryatt_sp_5_8", -1213.18, 2558.07, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_nestling"}, 1},
	{"rryatt_sp_5_9", -1237.05, 2509.39, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_nestling"}, 1},
	{"rryatt_sp_5_10", -1276.79, 2553.41, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_nestling"}, 1},
	{"rryatt_sp_5_11", -1293.37, 2461.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_nestling"}, 1},
	{"rryatt_sp_5_12", -1474.95, 2691.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 3},
	{"rryatt_sp_5_13", -1485.87, 2679.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter_leader"}, 1},
	{"rryatt_sp_5_14", -1735.06, 2536.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 1},
	{"rryatt_sp_5_15", -1505.85, 2676.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_16", -1662.59, 2604.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_17", -1454.29, 2684.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_18", -1792.03, 2651.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_19", -1528.84, 2670.58, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_20", -1852.02, 2373.49, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_abandoned_battle_droid"}, 3},
	{"rryatt_sp_5_21", -1707.72, 2350.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_abandoned_droideka"}, 3},
	{"rryatt_sp_5_22", -1812.85, 2379.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_abandoned_battle_droid"}, 3},
	{"rryatt_sp_5_23", -1806.79, 2336.88, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_abandoned_droideka"}, 3},
	{"rryatt_sp_5_24", -1841.08, 2337.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_abandoned_super_battle_droid"}, 2},
	{"rryatt_sp_5_25", -1822.25, 2315.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_abandoned_battle_droid"}, 2},
	{"rryatt_sp_5_26", -1701.11, 2372.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_abandoned_battle_droid"}, 2},
	{"rryatt_sp_5_27", -1716.82, 2592.95, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_abandoned_droideka"}, 2},
	{"rryatt_sp_5_28", -1445.02, 2471.88, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_minstyngar_elite_bloodspiller"}, 2},
	{"rryatt_sp_5_29", -1564.48, 2444.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_minstyngar_elite_bloodspiller"}, 2},
	{"rryatt_sp_5_30", -1606.81, 2360.64, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_minstyngar_elite_bloodspiller"}, 2},
	{"rryatt_sp_5_31", -1498.54, 2367.03, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_minstyngar_elite_bonecrusher"}, 4},
	{"rryatt_sp_5_32", -1482.56, 2383.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_minstyngar_elite_deathcaller"}, 4},
	{"rryatt_sp_5_33", -1656.62, 2337.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_minstyngar_elite_deathcaller"}, 2},
	{"rryatt_sp_5_34", -1461.78, 2365.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_minstyngar_scratch"}, 1},
	{"rryatt_sp_5_35", -1475.21, 2349.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_minstyngar_elite_bonecrusher"}, 2},
	{"rryatt_sp_5_36", -1595.20, 2571.51, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_37", -1545.03, 2623.35, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_38", -1738.90, 2417.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_39", -1537.35, 2590.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_40", -1763.07, 2628.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_41", -1363.82, 2582.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_42", -1421.50, 2564.32, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	{"rryatt_sp_5_43", -1509.78, 2580.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_gotal_hunter"}, 2},
	-- SPAWNAREA -- Rryatt Trail levels 1 and 2 (kashyyyk_rryatt_trail), K-11a
	-- Sourced area_spawner.iff from kashyyyk_rryatt_trail_lvl_1_and_2.tab.
	-- Live rows: 34. Commented OPEN: 12 (mouf type tables; no repo mouf template).
	-- Radius floor 32 m: a Core3 spawn area needs room for a lair.
	{"rryatt_sp_12_4", -3453.43, 3736.96, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 3},
	{"rryatt_sp_12_5", -3484.54, 3795.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 1},
	{"rryatt_sp_12_6", -3450.85, 3840.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 3},
	{"rryatt_sp_12_7", -3409.23, 3550.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_rebels"}, 2},
	{"rryatt_sp_12_8", -3377.95, 3617.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_rebels"}, 2},
	{"rryatt_sp_12_9", -3336.24, 3542.66, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_rebels"}, 5},
	{"rryatt_sp_12_10", -3339.77, 3564.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_rebels"}, 3},
	{"rryatt_sp_12_11", -3364.17, 4038.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_bolotaur"}, 1},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_12", -3162.50, 4362.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 4}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=8.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_13", -3277.40, 4413.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 1}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=5.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_14", -3406.41, 4475.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 4}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=8.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_15", -3386.38, 4506.88, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 4}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=8.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_16", -3450.99, 4594.34, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 4}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=8.0 soe_count=4
	{"rryatt_sp_12_17", -3548.65, 4713.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_escaped_wookiees"}, 3},
	{"rryatt_sp_12_18", -3544.97, 4735.73, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_escaped_wookiees"}, 4},
	{"rryatt_sp_12_19", -3532.49, 4672.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_escaped_wookiees"}, 2},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_20", -3361.24, 4567.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw_elite"}, 2}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw_elite soe_radius=8.0 soe_count=2
	{"rryatt_sp_12_21", -3386.04, 3934.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_scout_troopers"}, 4},
	{"rryatt_sp_12_22", -3467.99, 3764.81, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 3},
	{"rryatt_sp_12_23", -3445.49, 3802.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 1},
	{"rryatt_sp_12_24", -3479.82, 3877.73, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 3},
	{"rryatt_sp_12_25", -3409.23, 3550.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_rebels"}, 2},
	{"rryatt_sp_12_26", -3377.95, 3617.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_rebels"}, 2},
	{"rryatt_sp_12_27", -3336.24, 3542.66, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_rebels"}, 5},
	{"rryatt_sp_12_28", -3339.78, 3564.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_rebels"}, 3},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_29", -3162.50, 4362.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 4}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=8.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_30", -3277.40, 4413.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 1}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=5.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_31", -3383.06, 4456.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 4}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=8.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_32", -3370.19, 4532.93, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 4}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=8.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_33", -3448.34, 4560.20, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw"}, 4}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw soe_radius=8.0 soe_count=4
	{"rryatt_sp_12_34", -3529.47, 4705.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_escaped_wookiees"}, 3},
	{"rryatt_sp_12_35", -3557.00, 4725.49, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_escaped_wookiees"}, 4},
	{"rryatt_sp_12_36", -3533.01, 4685.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_escaped_wookiees"}, 2},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"rryatt_sp_12_37", -3344.45, 4574.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_mouf_bloodclaw_boss"}, 1}, -- strSpawns=kashyyyk/rryatt_mouf_bloodclaw_boss soe_radius=8.0 soe_count=1
	{"rryatt_sp_12_38", -2854.26, 4527.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_bolotaur_special"}, 1},
	{"rryatt_sp_12_39", -2822.07, 4699.29, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_crazed_jedi"}, 1},
	{"rryatt_sp_12_40", -3487.16, 3847.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 2},
	{"rryatt_sp_12_41", -3416.62, 4004.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 2},
	{"rryatt_sp_12_42", -3341.93, 4174.17, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 4},
	{"rryatt_sp_12_43", -3317.30, 4198.86, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher_elite"}, 2},
	{"rryatt_sp_12_44", -3337.05, 4235.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher"}, 3},
	{"rryatt_sp_12_45", -3332.24, 4201.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_walluga_smasher_boss"}, 1},
	{"rryatt_sp_12_57", -3051.16, 4537.55, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"rryatt_sp_12_58", -3023.55, 4559.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"rryatt_sp_12_64", -3057.89, 4568.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"rryatt_sp_12_72", -3771.80, 3641.95, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_clone_droid"}, 1},
}
