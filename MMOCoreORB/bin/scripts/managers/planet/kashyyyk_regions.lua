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
-- KASHYYYK SURFACE -- PROVENANCE
-- ===========================================================================
-- This file was NOT produced by the SWGEmu World Spawner Tool. Every row below
-- is derived from shipped client data; the derivation for each one is recorded
-- next to it. Rows whose NAME or RADIUS is not itself shipped are marked
-- INFERRED so nothing here reads as quoted data when it is not.
--
-- WHICH SHIPPED FILES GOVERN
--   bin/conf/config.lua TreFiles puts mtg_patch_022.tre above mtg_planets.tre
--   and does NOT list mtg_patch_023.tre at all, so the governing bytes are:
--     terrain/kashyyyk.trn                 mtg_patch_022.tre  mapWidth 16384
--     snapshot/kashyyyk.ws                 mtg_patch_022.tre  448 templates,
--                                          4642 top-level nodes
--     datatables/clientregion/kashyyyk.iff mtg_patch_022.tre  1 row
--     string/en/kashyyyk_region_names.stf  mtg_patch_013_configurable_02.tre
--                                          1 key: kachirho => Kachirho
--
-- ZONE SHAPE
--   terrain/kashyyyk.trn (mtg_patch_022) reports mapWidth 16384, i.e. the zone
--   spans +/-8192 -- the same map size as endor.trn, dathomir.trn, corellia.trn
--   and naboo.trn, all of which use the -8000/7640 edge no-build convention.
--   The three surface sub-zone terrains (kashyyyk_main.trn, kashyyyk_hunting.trn,
--   kashyyyk_dead_forest.trn) are each mapWidth 4096. So zone "kashyyyk" is the
--   whole surface, not just Kachirho, and this one file covers all three.
--
-- SUB-ZONE MERGE OFFSETS (proved, not assumed)
--   snapshot/kashyyyk.ws is a merged whole-surface map. For every template that
--   appears in both the merged file and a sub-zone file with an identical node
--   count, the centroid delta was computed. Each sub-zone produced exactly ONE
--   offset with zero disagreement:
--     kashyyyk_main.ws        dx    +0.0  dz    +0.0   144 templates / 409 nodes
--     kashyyyk_hunting.ws     dx    +0.0  dz -3000.0    86 templates / 533 nodes
--     kashyyyk_dead_forest.ws dx -1500.0  dz +1500.0    74 templates / 473 nodes
--   All coordinates below are in MERGED (whole-surface) space, which is what a
--   zone loading snapshot/kashyyyk.ws actually uses.
--
-- AXIS MAPPING
--   The .ws DATA chunk stores (x, y, z) where y is HEIGHT. A Core3 region row
--   takes the ground plane as (x, y). Every row below therefore uses
--     lua-x = ws-x   and   lua-y = ws-z   (ws-y, the height, is discarded).
--   Cross-checked against shipped data that already went through this repo:
--   datatables/clientregion/endor.iff ships (X=-905.0, Z=1584.0) and
--   (X=3221.0, Z=-3471.0); endor_regions.lua carries those same two outposts at
--   (-898, 1587) and (3222, -3467) -- Z landing in the lua y slot, unmirrored.
--
-- HOW THE POI CENTRES AND RADII WERE OBTAINED
--   Foliage, rock, particle and loose-furniture templates were filtered out of
--   snapshot/kashyyyk.ws by template name, leaving 1934 structure-like top-level
--   nodes of 4642. Those were clustered, then each region below was measured as
--   a bounding box over the shipped node positions: the centre printed here is
--   the bbox centre and the radius is the enclosing radius rounded UP to a round
--   number. Node count, measured radius and the dominant templates are recorded
--   on every row so the naming can be checked against what is actually there.
--
-- WHAT IS DELIBERATELY ABSENT
--   * No SPAWNAREA rows and no world_spawner row. This is blocked, not undecided:
--     mobile/spawn/ contains no Kashyyyk spawn group of any kind, so every name
--     this file could write would dangle and fail at load. Spawn rows become
--     possible the day a Kashyyyk spawn group exists, and belong in the pass that
--     writes it.
--   * No rows for kashyyyk_rryatt_trail, kashyyyk_north_dungeons,
--     kashyyyk_south_dungeons or kashyyyk_pob_dungeons*. Also blocked, not
--     undecided: those snapshots ship only in mtg_patch_023.tre, and config.lua
--     does not load it, so the server cannot see the geometry those rows would
--     describe. Loading that TRE is a separate change with its own consequences.
--   * Only ONE localized region name exists for this planet. kashyyyk_region_names.stf
--     ships exactly one key (kachirho). Any other @kashyyyk_region_names:* string
--     would dangle, so every other row below uses a plain unlocalized name, the
--     same way endor_regions.lua names korga_cave, hot_springs and stone_village.

require("scripts.managers.planet.regions")

--[[

Kashyyyk Creature Spawn Groups
- none. mobile/spawn/ has no kashyyyk group; see "WHAT IS DELIBERATELY ABSENT".

--]]

kashyyyk_regions = {
	-- No Build Zones
	-- INFERRED (convention, not shipped rows). Dimensionally justified: the
	-- governing terrain/kashyyyk.trn is mapWidth 16384 (+/-8192), identical to
	-- endor/dathomir/corellia/naboo, which all use these exact bounds. All
	-- shipped Kashyyyk surface content sits inside x -4096.4..1408.5 and
	-- y -5052.4..2029.2, so nothing shipped falls in these margins.
	{"northedge_kashyyyk_nobuild", -8000, 7640, {RECTANGLE, 8000, 8000}, NOBUILDZONEAREA},
	{"westedge_kashyyyk_nobuild", -8000, -7640, {RECTANGLE, -7640, 7640}, NOBUILDZONEAREA},
	{"southedge_kashyyyk_nobuild", -8000, -8000, {RECTANGLE, 8000, -7640}, NOBUILDZONEAREA},
	{"eastedge_kashyyyk_nobuild", 7640, -7640, {RECTANGLE, 8000, 7640}, NOBUILDZONEAREA},

	-- Named Region
	-- The ONLY fully shipped row in this file. Name, x, y and radius are all
	-- quoted: datatables/clientregion/kashyyyk.iff (mtg_patch_022.tre) row 0 is
	-- Name="@kashyyyk_region_names:kachirho" X=-500.0 Z=-100.0 Radius=250.0, and
	-- the key resolves -- string/en/kashyyyk_region_names.stf
	-- (mtg_patch_013_configurable_02.tre) holds kachirho => "Kachirho".
	-- The tier bits are NOT shipped: the client region table has only
	-- Name/X/Z/Radius columns, so flags are an authoring choice on every planet.
	-- These match dathomir_regions.lua's shipped named region (nightsister_clan).
	-- The 250 m circle does contain the whole village core: the structure cluster
	-- there measures centre (-580.2, -92.9) enclosing radius 162.7 over 206 nodes
	-- (thm_kash_house_ground_lg_s01 x3, thm_kash_column_wood x10, endr_lake_rail4m x25),
	-- the Kachirho tree lift doors mun_kash_tree_door_level_ground/1/2/3 sit at
	-- x -467..-451 / y -95..-77, and bunker_imperial_kashyyyk_01 at (-678.4, -109.5)
	-- with military_outpost_guard_house_imperial at (-665.4, -108.2) are 178.7 m and
	-- 165.6 m from the shipped centre respectively -- all inside 250 m.
	{"@kashyyyk_region_names:kachirho", -500, -100, {CIRCLE, 250}, NOBUILDZONEAREA + NOSPAWNAREA + NAMEDREGION},

	-- POIs -- Kachirho surface (kashyyyk_main sub-zone, merge offset dx 0 / dy 0)
	-- All names below are INFERRED, composed from the dominant shipped template
	-- family inside each cluster. Centres and radii are measured, not invented.
	-- n=46 measured radius 34.2; thm_kash_column_wood x14, thm_kash_arch_wood_s01 x10
	{"kachirho_north_arches", -556, 158, {CIRCLE, 40}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=46 measured radius 86.3; poi_kash_slave_camp_fence_piece_s01 x4,
	-- poi_kash_slave_camp_quarters x2, poi_kash_slave_camp_pen x1
	{"kachirho_west_slave_camp", 154, 157, {CIRCLE, 90}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=13 measured radius 136.3; poi_kash_slave_camp_fence_piece_s01 x9 plus one
	-- each of poi_kash_slave_camp_tower, _gate, _pen and poi_transport_trandoshan_slaver
	{"kachirho_east_slave_camp", 520, 351, {CIRCLE, 140}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=52 measured radius 51.8; thm_kash_house_ground_lg_s01 x3 and _med_s01 x2 with
	-- kash_kachiro_tall_plant x16 / low_plant x14, dant_fence_4m x7, dant_fish_rack x3,
	-- dant_fire_pit, dant_cooking_stone, dant_hide_tanning_s01/s02
	{"kachirho_east_homestead", 302, -181, {CIRCLE, 60}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=21 measured radius 68.7; poi_kash_hut_generic_destroyed_s01 x4,
	-- thm_all_wookiee_corpse_s02 x3, thm_kash_house_sm_s01 x2
	{"kachirho_north_ruined_huts", 172, 565, {CIRCLE, 75}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=38 measured radius 26.5; thm_kash_arch_wood_s01 x10, thm_kash_guard_hut x2,
	-- wp_mle_2h_kashyyyk_sword x4, wp_mle_lance_kashyyyk_bladestick x4
	{"kachirho_east_weapon_camp", 782, 298, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=26 measured radius 117.8; eqp_camping_tent_s3 x4, _s4 x3, pavilion, grills
	{"kachirho_north_camp", -342, 649, {CIRCLE, 120}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=49 measured radius 22.2; tent_jawa_01_small x2, camp_cot_s01 x2, camp stools, rails
	{"kachirho_northeast_camp", 586, 734, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=28 measured radius 30.4; tent_house_tatooine_style_01, tent_jawa_01_med/_small,
	-- eqp_camping_cot_s2 x5, camping grill and crate
	{"kachirho_southeast_camp", 553, -645, {CIRCLE, 35}, NOSPAWNAREA + NOBUILDZONEAREA},

	-- POIs -- Hunting grounds (kashyyyk_hunting sub-zone, merge offset dx 0 / dy -3000)
	-- Names use the shipped file stem "hunting" (terrain/kashyyyk_hunting.trn,
	-- snapshot/kashyyyk_hunting.ws). The NGE name for this area, Etyyy, appears in
	-- no shipped Kashyyyk string table, so it is not used as a region name here.
	-- n=398 measured radius 273.7; dant_fence_8m x86, thm_kash_column_wood x34,
	-- thm_kash_arch_wood_s02 x14, thm_kash_guard_hut x6, thm_kash_rodian_bannerpole_s01 x5.
	-- The "hunting" name is carried by the shipped contents as well as the file stem:
	-- frn_all_trophy_walluga x6, frn_all_trophy_uller x5, frn_all_trophy_webweaver x5.
	-- mun_kash_shuttlepost_s01 stands at (398.2, -2399.4), inside this circle -- the only
	-- shuttle structure anywhere on the merged surface.
	{"hunting_grounds_outpost", 343, -2491, {CIRCLE, 280}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=96 measured radius 143.6; dant_fence_8m x40, tent_house_tatooine_style_01 x5,
	-- dant_hide_tanning_s02 x3, lair_wooden_tent x4
	{"hunting_grounds_west_camp", -554, -2184, {CIRCLE, 150}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=34 measured radius 58.1; poi_kash_all_treewall_lg_corner_s01 x4 and
	-- _med_corner_s01 x3 with dant_fence_8m x15
	{"hunting_grounds_treewall_camp", -392, -2173, {CIRCLE, 60}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=10 measured radius 75.4; endor_catwalk x5, poi_kash_hut_generic_s01 x3,
	-- endor_lake_walkway_straight
	{"hunting_grounds_catwalks", -872, -2369, {CIRCLE, 80}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=111 measured radius 180.7; thm_kash_guard_hut x7, dant_fence_8m x32,
	-- item_newbie_crate x10, eqp_camping_tent_s4 x6
	{"hunting_grounds_south_camp", 24, -3167, {CIRCLE, 185}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=98 measured radius 137.8; poi_kash_chiss_hut x11 with debris_tatt drums/crates,
	-- dant_hide_tanning_s01 x10, dant_fish_rack x8, dant_rack_spears x7
	{"hunting_grounds_chiss_camp", -1158, -3038, {CIRCLE, 140}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=68 measured radius 107.6; poi_kash_hut_generic_destroyed_s01 x11,
	-- thm_all_bones_wookiee_s01/s02/s03 x24, skeleton_ithorian_headandbody x4
	{"hunting_grounds_ruined_camp", 96, -3499, {CIRCLE, 110}, NOSPAWNAREA + NOBUILDZONEAREA},

	-- POIs -- Dead forest (kashyyyk_dead_forest sub-zone, merge offset dx -1500 / dy +1500)
	-- Names use the shipped file stem "dead_forest" (terrain/kashyyyk_dead_forest.trn,
	-- snapshot/kashyyyk_dead_forest.ws). The NGE name Kkowir is in no shipped Kashyyyk
	-- string table and is not used as a region name here.
	-- n=189 measured radius 96.8; mun_kash_elder_hut x2, poi_kash_shaman_ritual_fire x2,
	-- poi_kash_hut_generic_s01 x10, thm_kash_house_ground_sm_s01 x2, nasllas_pillar_small x8,
	-- frn_chair_wookiee_ceremonial x12, frn_table_wookiee_ceremonial x7,
	-- frn_centerpiece_wookiee_ceremonial x7, frn_kash_wookiee_loom x2, camp_cot_s1 x20
	{"dead_forest_elder_village", -1714, 1355, {CIRCLE, 100}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=38 measured radius 72.9; poi_kash_dead_forest_scarecrow_s01 x9 and _s02 x7,
	-- thm_all_bones_wookiee_s01/s02 x9
	{"dead_forest_scarecrow_field", -1110, 1098, {CIRCLE, 75}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=74 measured radius 155.0; sayormi_tent x12, wp_mle_lance_staff_wood_s01 x12,
	-- thm_all_humanoid_bone_skull x12, dant_rack_spears, dant_hide_tanning_s01/s02
	{"dead_forest_sayormi_camp", -1239, 1325, {CIRCLE, 160}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=22 measured radius 26.9; banner_imperial_style_01 x3, camp_tent_s5/s6 x5,
	-- camp_light_s2 x2
	{"dead_forest_imperial_camp", -1794, 1107, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=29 measured radius 97.3; wookiee_gravestone_s01 x8, _s02 x5, _s03 x6,
	-- nasllas_pillar_small x6, nasllas_pillar_central x3
	{"dead_forest_gravesite", -1502, 1643, {CIRCLE, 100}, NOSPAWNAREA + NOBUILDZONEAREA},
	-- n=21 measured radius 16.3; shared_web_01/_04/_07, ep3_forest_webweaver,
	-- thm_all_humanoid_bone_skull/_forearm/_thigh
	{"dead_forest_webweaver_den", -1277, 1814, {CIRCLE, 20}, NOSPAWNAREA + NOBUILDZONEAREA}
}
