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
-- KASHYYYK_NORTH_DUNGEONS -- PROVENANCE
-- ===========================================================================
-- Zone "kashyyyk_north_dungeons" is its own zone, not a row on the merged
-- surface (trap 1: Kashyyyk is seven zones). PlanetManagerImplementation.cpp:633
-- opens "snapshot/" + zone->getZoneName() + ".ws"; PlanetManagerImplementation.cpp:923
-- opens "scripts/managers/planet/" + planetName + "_regions.lua". This file
-- exists so boot does not log the missing-regions error.
--
-- WHICH SHIPPED FILES GOVERN (ruling 2026-09-04, TRE order option (a):
-- mtg_patch_022.tre above mtg_patch_023.tre; 023 must stay loaded)
--   snapshot/kashyyyk_north_dungeons.ws  mtg_patch_023.tre ONLY
--                                        376,492 B, 35 templates / 4456 nodes
--   terrain/kashyyyk_north_dungeons.trn  mtg_planets.tre (also
--                                        mtg_patch_013_configurable_02.tre)
--                                        mapWidth 16384  (research E9)
--   023 is the only TRE that ships this snapshot. First listed wins
--   (src/tre3/TreeDirectory.h:16 setNoDuplicateInsertPlan); with 022 above 023
--   the 023-only path is still found because 022 does not carry it.
--
-- BUILDOUT -> WORLD CONVERSION {#kash-offset} (proved 2026-09-03 to 0.00 m,
-- zero rotation, zero scale)
--   world_x = buildout_x - 3840    world_z = buildout_z + 2816
--   proof: poi_kash_slave_camp_tower x4, all exact
--     (420.371, 758.215) -> (-3419.63, 3574.22)
--   Trap 5: slaver.tab (542 rows) and arena.tab (198 rows) are 11-column
--   (no objid/container). px is column 3, not column 5.
--   Contents: Trandoshan slave camp + the Arena.
--
-- WHAT NOW EXISTS (K-8b, ruling 2026-09-04)
--   * SPAWNAREA rows from SOE datatables/buildout/kashyyyk_north_dungeons/
--     slaver.tab and arena.tab. transcribe_spawners.py processed both
--     tabs; all 108 spawners are slaver.tab (91 area_spawner.iff, 17
--     patrol_spawner.iff). arena.tab contributed none of those templates.
--     Name is north_sp_<tab>_<buildout_row> because both tabs start at
--     row 3. wx/wz are already dungeon-snapshot world coords (buildout
--     - 3840 on x, + 2816 on z, proved).
--     Spawn limit is SOE intSpawnCount (floored to 1). Radius is
--     max(SOE fltRadius, 32): a Core3 spawn area needs room for a lair.
--     A type table a surface round already built is reused by name; no
--     second file. kash_blackscale_kamurith is built (K-8b.1): SOE's
--     voritor_lizard_hue.iff is the appearance the base-game kamurith
--     templates declare, an iff match. The named boss table
--     kash_blackscale_kamurith_ysskir (1 row) stays a comment so the server
--     does not dangle a spawn-group name; coords stay sourced.
--     Empty-strSpawns area spawners stay as comments.
--     patrol_spawner.iff rows stay as comments (the north patrol round
--     comes after the surface patrol shape is proven).
--   * 130 object/tangible/spawning/ and ground_spawning/ rows (128
--     patrol_point_setup waypoints, 1 space_dungeon_controller control
--     object, 1 unscripted arena_guard_inner) are NOT in this file --
--     waypoints belong to the patrols (OPEN); control object and
--     unscripted row listed, spawn nothing.
--
-- ZONE SHAPE
--   terrain/kashyyyk_north_dungeons.trn reports mapWidth 16384, i.e. the zone
--   spans +/-8192 -- the same map size as the Kashyyyk surface, whose no-build
--   edges sit at +/-8000. These four rows copy that convention.

require("scripts.managers.planet.regions")

--[[

Kashyyyk Creature Spawn Groups
- kashyyyk_clone_droid
- kashyyyk_kash_blackscale_assault
- kashyyyk_kash_blackscale_enforcer
- kashyyyk_kash_blackscale_guard
- kashyyyk_kash_blackscale_kamurith
- kashyyyk_kash_blackscale_keeper_grigova
- kashyyyk_kash_blackscale_selindrolich
- kashyyyk_kash_blackscale_trooper

--]]

kashyyyk_north_dungeons_regions = {
	-- No Build Zones
	-- INFERRED (convention, not shipped rows). Dimensionally justified: the
	-- governing terrain/kashyyyk_north_dungeons.trn is mapWidth 16384 (+/-8192),
	-- identical to the Kashyyyk surface, which uses these exact bounds.
	{"northedge_kashyyyk_north_dungeons_nobuild", -8000, 7640, {RECTANGLE, 8000, 8000}, NOBUILDZONEAREA},
	{"westedge_kashyyyk_north_dungeons_nobuild", -8000, -7640, {RECTANGLE, -7640, 7640}, NOBUILDZONEAREA},
	{"southedge_kashyyyk_north_dungeons_nobuild", -8000, -8000, {RECTANGLE, 8000, -7640}, NOBUILDZONEAREA},
	{"eastedge_kashyyyk_north_dungeons_nobuild", 7640, -7640, {RECTANGLE, 8000, 7640}, NOBUILDZONEAREA},

	-- SPAWNAREA -- Trandoshan slave camp + the Arena (kashyyyk_north_dungeons), K-8b
	-- Sourced spawners: 108 (slaver.tab 91 area_spawner.iff + 17 patrol_spawner.iff; arena.tab 0).
	-- Live rows: 69 (K-8b 58 + K-8b.1 the 11 kamurith rows). Commented: 21 empty
	-- strSpawns, 1 named-boss table (kamurith_ysskir), 17 patrol_spawner.iff.
	-- Radius floor 32 m: a Core3 spawn area needs room for a lair.
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_3", -3528.72, 3304.84, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_4", -3366.25, 3102.81, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_5", -3270.05, 3469.26, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_6", -3221.69, 3572.67, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_7", -3264.33, 3704.65, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_8", -3452.28, 3661.02, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_9", -3374.47, 3571.32, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_10", -3609.97, 3628.86, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_11", -3215.18, 2918.15, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_12", -3121.02, 2998.62, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_13", -3188.00, 3055.88, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_14", -3281.30, 3087.78, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_15", -3334.73, 3164.34, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_16", -3410.78, 3147.45, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_17", -3457.37, 3189.49, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_18", -3424.49, 3370.17, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_19", -3339.00, 3504.40, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_20", -3149.02, 3540.66, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_21", -3116.16, 3692.10, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_22", -3158.84, 3635.93, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	-- OPEN (empty strSpawns; no type table): {"north_sp_slaver_23", -3546.80, 3723.90, {CIRCLE, 32}, SPAWNAREA, {""}, 1}, -- strSpawns= soe_radius=0.0 soe_count=1
	{"north_sp_slaver_24", -3131.26, 2974.93, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 3},
	{"north_sp_slaver_25", -3132.39, 3087.04, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 3},
	{"north_sp_slaver_26", -3267.18, 3559.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 6},
	{"north_sp_slaver_27", -3283.95, 3593.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 6},
	{"north_sp_slaver_28", -3373.70, 3650.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 6},
	{"north_sp_slaver_29", -3139.46, 3601.03, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 5},
	{"north_sp_slaver_30", -3445.29, 3592.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 4},
	{"north_sp_slaver_31", -3442.90, 3668.35, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 5},
	{"north_sp_slaver_32", -3494.08, 3730.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 5},
	{"north_sp_slaver_33", -3592.77, 3713.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 5},
	{"north_sp_slaver_34", -3638.73, 3585.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 5},
	{"north_sp_slaver_35", -3585.36, 3609.26, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"north_sp_slaver_36", -3585.83, 3641.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"north_sp_slaver_37", -3522.17, 3654.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 6},
	{"north_sp_slaver_38", -3531.41, 3651.27, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 6},
	{"north_sp_slaver_39", -3360.11, 3134.07, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 5},
	{"north_sp_slaver_40", -3230.86, 3647.29, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 4},
	{"north_sp_slaver_41", -3245.63, 2930.80, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 1},
	{"north_sp_slaver_42", -3240.23, 2917.28, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 1},
	{"north_sp_slaver_43", -3177.39, 2929.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 1},
	{"north_sp_slaver_44", -3172.74, 2917.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 1},
	{"north_sp_slaver_45", -3145.60, 2940.35, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 3},
	{"north_sp_slaver_46", -3140.55, 3049.35, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 2},
	{"north_sp_slaver_47", -3150.25, 3038.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 2},
	{"north_sp_slaver_48", -3145.94, 3043.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"north_sp_slaver_49", -3216.23, 3096.03, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2},
	{"north_sp_slaver_50", -3222.37, 3084.99, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2},
	{"north_sp_slaver_51", -3293.82, 3098.67, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2},
	{"north_sp_slaver_52", -3293.85, 3085.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2},
	{"north_sp_slaver_53", -3381.12, 3068.34, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 7},
	{"north_sp_slaver_54", -3415.62, 3156.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2},
	{"north_sp_slaver_55", -3422.23, 3150.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no custom_content template for voritor_lizard_hue.iff): {"north_sp_slaver_56", -3483.35, 3192.49, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith_ysskir"}, 1}, -- strSpawns=kashyyyk/kash_blackscale_kamurith_ysskir soe_radius=1.0 soe_count=1
	{"north_sp_slaver_57", -3476.24, 3198.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 3},
	{"north_sp_slaver_58", -3479.25, 3184.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 3},
	{"north_sp_slaver_59", -3534.15, 3236.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 5},
	{"north_sp_slaver_60", -3542.87, 3294.86, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2},
	{"north_sp_slaver_61", -3527.88, 3291.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 2},
	{"north_sp_slaver_62", -3485.23, 3385.87, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2},
	{"north_sp_slaver_63", -3475.14, 3367.52, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2},
	{"north_sp_slaver_64", -3346.46, 3389.17, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2},
	{"north_sp_slaver_65", -3340.18, 3372.31, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 3},
	{"north_sp_slaver_66", -3327.24, 3453.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2},
	{"north_sp_slaver_67", -3340.97, 3449.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2},
	{"north_sp_slaver_68", -3335.90, 3457.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 2},
	{"north_sp_slaver_69", -3362.80, 3535.66, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 2},
	{"north_sp_slaver_70", -3345.44, 3546.39, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 2},
	{"north_sp_slaver_71", -3413.43, 3596.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"north_sp_slaver_72", -3414.36, 3587.27, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"north_sp_slaver_73", -3298.03, 3448.83, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2},
	{"north_sp_slaver_74", -3287.20, 3438.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2},
	{"north_sp_slaver_75", -3226.98, 3516.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_keeper_grigova"}, 1},
	{"north_sp_slaver_76", -3234.47, 3521.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_selindrolich"}, 1},
	{"north_sp_slaver_77", -3107.43, 3569.22, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 3},
	{"north_sp_slaver_78", -3089.46, 3614.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 1},
	{"north_sp_slaver_79", -3100.05, 3668.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 1},
	{"north_sp_slaver_80", -3087.58, 3671.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2},
	{"north_sp_slaver_81", -3139.52, 3583.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2},
	{"north_sp_slaver_82", -3202.32, 3681.34, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2},
	{"north_sp_slaver_83", -3204.37, 3668.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2},
	{"north_sp_slaver_84", -3209.02, 3675.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_kamurith"}, 2},
	{"north_sp_slaver_85", -3199.55, 3606.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 4},
	{"north_sp_slaver_86", -3261.01, 3618.27, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2},
	{"north_sp_slaver_87", -3252.01, 3626.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2},
	{"north_sp_slaver_88", -3326.44, 3710.17, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2},
	{"north_sp_slaver_89", -3322.47, 3693.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2},
	{"north_sp_slaver_90", -3404.71, 3669.55, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"north_sp_slaver_91", -3404.47, 3660.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"north_sp_slaver_92", -3506.64, 3718.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 4},
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_93", -3153.28, 2937.77, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1}, -- strSpawns=kashyyyk/kash_blackscale_guard soe_radius=1.0 soe_count=1
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_403", -3195.21, 3041.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_guard soe_radius=3.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_413", -3212.50, 3086.77, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_enforcer soe_radius=2.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_423", -3296.49, 3092.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 1}, -- strSpawns=kashyyyk/kash_blackscale_enforcer soe_radius=2.0 soe_count=1
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_425", -3322.39, 3082.14, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 3}, -- strSpawns=kashyyyk/kash_blackscale_enforcer soe_radius=3.0 soe_count=3
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_439", -3468.48, 3188.83, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_guard soe_radius=3.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_443", -3480.90, 3378.95, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_enforcer"}, 1}, -- strSpawns=kashyyyk/kash_blackscale_enforcer soe_radius=3.0 soe_count=1
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_455", -3354.87, 3367.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_assault soe_radius=1.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_461", -3334.10, 3468.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_assault soe_radius=2.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_476", -3292.91, 3447.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_guard soe_radius=2.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_480", -3093.11, 3570.29, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_assault soe_radius=2.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_485", -3173.80, 3683.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_assault soe_radius=2.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_491", -3200.28, 3632.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 3}, -- strSpawns=kashyyyk/kash_blackscale_assault soe_radius=2.0 soe_count=3
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_502", -3499.98, 3544.39, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_assault"}, 5}, -- strSpawns=kashyyyk/kash_blackscale_assault soe_radius=2.0 soe_count=5
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_507", -3477.28, 3676.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 4}, -- strSpawns=kashyyyk/kash_blackscale_trooper soe_radius=3.0 soe_count=4
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_514", -3585.92, 3629.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_trooper soe_radius=1.0 soe_count=2
	-- OPEN (patrol_spawner.iff; north patrol round comes after the surface patrol shape is proven): {"north_sp_slaver_529", -3585.61, 3651.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_trooper"}, 2}, -- strSpawns=kashyyyk/kash_blackscale_trooper soe_radius=1.0 soe_count=2
	{"north_sp_slaver_544", -3270.96, 2831.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_clone_droid"}, 1},
}
