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
-- KASHYYYK_POB_DUNGEONS -- PROVENANCE
-- ===========================================================================
-- Zone "kashyyyk_pob_dungeons" is its own zone, not a row on the merged
-- surface (trap 1: Kashyyyk is seven zones). PlanetManagerImplementation.cpp:633
-- opens "snapshot/" + zone->getZoneName() + ".ws"; PlanetManagerImplementation.cpp:923
-- opens "scripts/managers/planet/" + planetName + "_regions.lua". This file
-- exists so boot does not log the missing-regions error.
--
-- WHICH SHIPPED FILES GOVERN (ruling 2026-09-04, TRE order option (a):
-- mtg_patch_022.tre above mtg_patch_023.tre; 023 must stay loaded)
--   snapshot/kashyyyk_pob_dungeons.ws ships in BOTH TREs:
--     mtg_patch_022.tre  71,849 B   (older cut; template/node count unmeasured)
--     mtg_patch_023.tre  156,655 B  4 templates / 1862 nodes
--   First listed wins (src/tre3/TreeDirectory.h:16 setNoDuplicateInsertPlan).
--   With 022 above 023, PlanetManagerImplementation.cpp:633 opens the 022 cut.
--   023 must stay loaded regardless: object/building/kashyyyk/
--   shared_thm_kash_myyydril_caverns.iff and
--   interiorlayout/thm_kash_cave_myyydril_interior.ilf ship only in 023.
--   terrain/kashyyyk_pob_dungeons.trn  mtg_planets.tre (also
--                                      mtg_patch_013_configurable_02.tre)
--                                      mapWidth 16384  (research E9)
--
-- BUILDOUT -> WORLD CONVERSION {#kash-offset}
--   UNMEASURED — measured in the spawn pass.
--   Trap 6: no linear map. The buildout has one thm_kash_myyydril_caverns at
--   (400.2584, 4.32584, 400.512) and one dungeon_avatar_platform at
--   (450.2555, 41.521, 500.4547). The 023 snapshot has 10 myyydril copies and
--   20 avatar copies on a 1000 m grid at z=0. That is a copy-farm, not a Core3
--   instance -- instance_datatable.tab has no Kashyyyk row. Do not reach for
--   the Mustafar instance pattern.
--   Trap 5: myyydril_caverns.tab (80 rows) and avatar_platform.tab (54 rows)
--   are 11-column (no objid/container). px is column 3, not column 5.
--
-- NO SPAWN ROWS YET. A later pass adds them from the transcribed buildouts.
--
-- ZONE SHAPE
--   terrain/kashyyyk_pob_dungeons.trn reports mapWidth 16384, i.e. the zone
--   spans +/-8192 -- the same map size as the Kashyyyk surface, whose no-build
--   edges sit at +/-8000. These four rows copy that convention.

require("scripts.managers.planet.regions")

-- WHICH SNAPSHOT ACTUALLY LOADS (measured 2026-09-04): 022 sits above 023 in the deploy TRE list, and 022 also
-- carries snapshot/kashyyyk_pob_dungeons.ws (71,849 B, 853 nodes: 10 myyydril copies at x = 0 along z, 2 avatar
-- platforms). That older cut is the one the server loads; the 023 cut (156,655 B, 1862 nodes, 10 + 20 copies on a
-- 1000 m grid) is shadowed. The populator addresses the 022 building ids.

kashyyyk_pob_dungeons_regions = {
	-- No Build Zones
	-- INFERRED (convention, not shipped rows). Dimensionally justified: the
	-- governing terrain/kashyyyk_pob_dungeons.trn is mapWidth 16384 (+/-8192),
	-- identical to the Kashyyyk surface, which uses these exact bounds.
	{"northedge_kashyyyk_pob_dungeons_nobuild", -8000, 7640, {RECTANGLE, 8000, 8000}, NOBUILDZONEAREA},
	{"westedge_kashyyyk_pob_dungeons_nobuild", -8000, -7640, {RECTANGLE, -7640, 7640}, NOBUILDZONEAREA},
	{"southedge_kashyyyk_pob_dungeons_nobuild", -8000, -8000, {RECTANGLE, 8000, -7640}, NOBUILDZONEAREA},
	{"eastedge_kashyyyk_pob_dungeons_nobuild", 7640, -7640, {RECTANGLE, 8000, 7640}, NOBUILDZONEAREA},
}
