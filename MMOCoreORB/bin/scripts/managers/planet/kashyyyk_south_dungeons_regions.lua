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
-- KASHYYYK_SOUTH_DUNGEONS -- PROVENANCE
-- ===========================================================================
-- Zone "kashyyyk_south_dungeons" is its own zone, not a row on the merged
-- surface (trap 1: Kashyyyk is seven zones). PlanetManagerImplementation.cpp:633
-- opens "snapshot/" + zone->getZoneName() + ".ws"; PlanetManagerImplementation.cpp:923
-- opens "scripts/managers/planet/" + planetName + "_regions.lua". This file
-- exists so boot does not log the missing-regions error.
--
-- WHICH SHIPPED FILES GOVERN (ruling 2026-09-04, TRE order option (a):
-- mtg_patch_022.tre above mtg_patch_023.tre; 023 must stay loaded)
--   snapshot/kashyyyk_south_dungeons.ws  mtg_patch_023.tre ONLY
--                                        379,574 B, 60 templates / 4476 nodes
--   terrain/kashyyyk_south_dungeons.trn  mtg_planets.tre (also
--                                        mtg_patch_013_configurable_02.tre)
--                                        mapWidth 16384  (research E9)
--   023 is the only TRE that ships this snapshot. First listed wins
--   (src/tre3/TreeDirectory.h:16 setNoDuplicateInsertPlan); with 022 above 023
--   the 023-only path is still found because 022 does not carry it.
--
-- BUILDOUT -> WORLD CONVERSION {#kash-offset} (proved 2026-09-03 to 0.00 m,
-- zero rotation, zero scale; snapshot copy #0 only)
--   world_x = buildout_x - 3968    world_z = buildout_z + 2944
--   proof: thm_kash_zonegate_gate_simple
--     buildout (888.186, 15.4514, 448.36) -> ws (-3079.81, 15.45, 3392.36)
--   The island then repeats at x +1152 m per copy (-1927.81, -775.81, ...).
--   Trap 5: hracca.tab (280 rows) and bocctyyy.tab (237 rows) are 11-column
--   (no objid/container). px is column 3, not column 5.
--   Contents: Hracca Glade + Bocctyyy monster islands.
--
-- WHAT NOW EXISTS (, ruling 2026-09-04)
--   * SPAWNAREA rows from SOE datatables/buildout/kashyyyk_south_dungeons/
--     hracca.tab (29) and bocctyyy.tab (26) area_spawner.iff (55 sourced).
--     Name is south_sp_<tab>_<buildout_row> because both tabs start at row 3.
--     wx/wz are already dungeon-snapshot world coords for island copy #0
--     (buildout - 3968 on x, + 2944 on z, proved). This pass places copy #0
--     ONLY; the island repeats at +1152 m in x per copy -- copies are a later
--     decision.
--     Spawn limit is SOE intSpawnCount (floored to 1). Radius is
--     max(SOE fltRadius, 32): a Core3 spawn area needs room for a lair.
--     A type table a surface pass already built is reused by name; no second
--     file. Fully-OPEN type tables (etyyy_mouf: no repo mouf template) stay as
--     comments so the server does not dangle a spawn-group name; coords stay
--     sourced.
--   * 89 object/tangible/spawning/ rows (88 kashyyyk/* monster-island spawners
--     driven by SOE's theme_park.dungeon.space_dungeon_controller java + 2
--     control objects, and 1 ep3 quest NPC) are NOT in this file -- OPEN for
--     the behaviours pass.
--
-- ZONE SHAPE
--   terrain/kashyyyk_south_dungeons.trn reports mapWidth 16384, i.e. the zone
--   spans +/-8192 -- the same map size as the Kashyyyk surface, whose no-build
--   edges sit at +/-8000. These four rows copy that convention.

require("scripts.managers.planet.regions")

--[[

Kashyyyk Creature Spawn Groups
- kashyyyk_clone_droid
- kashyyyk_etyyy_uller
- kashyyyk_etyyy_walluga
- kashyyyk_etyyy_webweaver
- kashyyyk_hracca_noxious_creature
- kashyyyk_kashyyyk_fern_bicker
- kashyyyk_kashyyyk_kklyyytt
- kashyyyk_kashyyyk_pug_jumper
- kashyyyk_kashyyyk_roroo

--]]

kashyyyk_south_dungeons_regions = {
	-- No Build Zones
	-- INFERRED (convention, not shipped rows). Dimensionally justified: the
	-- governing terrain/kashyyyk_south_dungeons.trn is mapWidth 16384 (+/-8192),
	-- identical to the Kashyyyk surface, which uses these exact bounds.
	{"northedge_kashyyyk_south_dungeons_nobuild", -8000, 7640, {RECTANGLE, 8000, 8000}, NOBUILDZONEAREA},
	{"westedge_kashyyyk_south_dungeons_nobuild", -8000, -7640, {RECTANGLE, -7640, 7640}, NOBUILDZONEAREA},
	{"southedge_kashyyyk_south_dungeons_nobuild", -8000, -8000, {RECTANGLE, 8000, -7640}, NOBUILDZONEAREA},
	{"eastedge_kashyyyk_south_dungeons_nobuild", 7640, -7640, {RECTANGLE, 8000, 7640}, NOBUILDZONEAREA},

	-- SPAWNAREA -- Hracca Glade + Bocctyyy (kashyyyk_south_dungeons), 
	-- Sourced area_spawner.iff: 55 (hracca.tab 29, bocctyyy.tab 26). Island copy #0 only.
	-- Live rows: 52. Still-fully-OPEN type tables: 3 row(s) commented (etyyy_mouf).
	-- Radius floor 32 m: a Core3 spawn area needs room for a lair.
	{"south_sp_hracca_254", -3212.19, 3332.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 2},
	{"south_sp_hracca_255", -3277.34, 3333.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_256", -3307.72, 3318.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_257", -3325.00, 3301.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_258", -3301.19, 3279.06, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_259", -3265.03, 3258.07, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_260", -3235.22, 3285.83, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_261", -3375.00, 3281.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_262", -3463.45, 3310.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_263", -3534.13, 3316.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_264", -3561.96, 3344.77, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_265", -3599.91, 3407.14, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 2},
	{"south_sp_hracca_266", -3653.25, 3366.32, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 2},
	{"south_sp_hracca_267", -3805.94, 3399.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 4},
	{"south_sp_hracca_268", -3824.24, 3435.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 2},
	{"south_sp_hracca_269", -3810.05, 3500.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_270", -3800.92, 3636.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_271", -3756.20, 3617.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_272", -3718.47, 3642.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 4},
	{"south_sp_hracca_273", -3683.04, 3602.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_274", -3670.03, 3567.52, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 4},
	{"south_sp_hracca_275", -3549.69, 3487.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_276", -3608.39, 3471.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_277", -3664.04, 3524.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_278", -3726.94, 3491.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_279", -3719.22, 3534.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_280", -3738.63, 3460.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 4},
	{"south_sp_hracca_281", -3735.69, 3422.32, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_hracca_noxious_creature"}, 3},
	{"south_sp_hracca_282", -3140.16, 3327.41, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_clone_droid"}, 1},
	{"south_sp_bocctyyy_214", -3822.11, 3035.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"south_sp_bocctyyy_215", -3784.94, 3024.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"south_sp_bocctyyy_216", -3765.06, 3055.51, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller"}, 3},
	{"south_sp_bocctyyy_217", -3764.53, 3008.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller"}, 3},
	{"south_sp_bocctyyy_218", -3706.88, 3025.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"south_sp_bocctyyy_219", -3669.13, 3022.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"south_sp_bocctyyy_220", -3627.27, 2999.78, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller"}, 3},
	{"south_sp_bocctyyy_221", -3595.56, 3027.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"south_sp_bocctyyy_222", -3566.22, 3050.06, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 2},
	{"south_sp_bocctyyy_223", -3555.12, 3110.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 2},
	{"south_sp_bocctyyy_224", -3622.11, 3106.88, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"south_sp_bocctyyy_225", -3676.90, 3140.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf soe_radius=8.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"south_sp_bocctyyy_226", -3787.45, 3201.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf soe_radius=8.0 soe_count=2
	{"south_sp_bocctyyy_227", -3739.29, 3260.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"south_sp_bocctyyy_228", -3844.15, 3332.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller"}, 3},
	{"south_sp_bocctyyy_229", -3898.27, 3354.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"south_sp_bocctyyy_230", -3826.75, 3379.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver"}, 3},
	{"south_sp_bocctyyy_231", -3749.54, 3383.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver"}, 3},
	{"south_sp_bocctyyy_232", -3713.03, 3356.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo mouf template): {"south_sp_bocctyyy_233", -3655.19, 3270.20, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf soe_radius=8.0 soe_count=3
	{"south_sp_bocctyyy_234", -3612.53, 3267.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"south_sp_bocctyyy_235", -3547.36, 3343.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"south_sp_bocctyyy_236", -3612.60, 3377.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver"}, 3},
	{"south_sp_bocctyyy_237", -3523.41, 3393.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"south_sp_bocctyyy_238", -3504.91, 3419.51, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver"}, 3},
	{"south_sp_bocctyyy_239", -3894.79, 2990.52, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_clone_droid"}, 1},
}
