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
-- WHICH SHIPPED FILES GOVERN (ruling 2026-09-04, K-1, TRE order option (a))
--   The DEPLOY's bin/conf/config.lua TreFiles (conf/ is never synced from this
--   repo; the Mustafar precedent) lists mtg_patch_022.tre ABOVE mtg_patch_023.tre
--   and mtg_planets.tre below both, and "kashyyyk" is in its ZonesEnabled. First
--   listed wins (src/tre3/TreeDirectory.h:16 setNoDuplicateInsertPlan), so:
--     terrain/kashyyyk.trn                 mtg_patch_022.tre  mapWidth 16384
--     snapshot/kashyyyk.ws                 mtg_patch_022.tre  448 templates,
--                                          4679 objects loaded at boot
--     datatables/clientregion/kashyyyk.iff mtg_patch_022.tre  1 row
--     string/en/kashyyyk_region_names.stf  mtg_patch_013_configurable_02.tre
--                                          1 key: kachirho => Kachirho
--   mtg_patch_023.tre still supplies the four snapshots that ship nowhere else
--   (kashyyyk_north_dungeons, kashyyyk_south_dungeons, kashyyyk_rryatt_trail,
--   kashyyyk_pob_dungeons); with 023 on top the server would load its 4096-wide
--   Kachirho-only cut (1298 nodes) and every hunting/dead-forest row below would
--   land off the map. Moving 023 below 022 changes the winner for exactly 20
--   paths, all Kashyyyk (measured 2026-09-03).
--   Boot proof 2026-09-04: "Ground Zone: Kashyyyk deployed", "Loaded 27 total
--   regions", "Loaded 4679 client objects from world snapshot", 0 errors.
--
-- BUILDOUT -> WORLD CONVERSION {#kash-offset} (proved 2026-09-03 to 0.00 m,
-- zero rotation, zero scale; SOE buildout px/pz -> merged snapshot/kashyyyk.ws)
--   kashyyyk_main          world_x = buildout_x - 4096   world_z = buildout_z - 4096
--     proof: bunker_imperial_kashyyyk_01 (3417.56, 3986.49) -> (-678.44, -109.51)
--   kashyyyk_hunting       world_x = buildout_x - 2048   world_z = buildout_z - 5048
--     proof: mun_kash_shuttlepost_s01 (2446.22, 2648.59) -> (398.22, -2399.41)
--   kashyyyk_dead_forest   world_x = buildout_x - 3548   world_z = buildout_z - 548
--     proof: mun_kash_elder_hut x2 (1750.86, 1853.46) -> (-1797.14, 1305.46)
--   kashyyyk_north_dungeons world_x = buildout_x - 3840  world_z = buildout_z + 2816
--     proof: poi_kash_slave_camp_tower x4, all exact
--   kashyyyk_south_dungeons world_x = buildout_x - 3968  world_z = buildout_z + 2944
--     (snapshot copy #0 only) proof: thm_kash_zonegate_gate_simple
--   kashyyyk_pob_dungeons   no linear map (1 buildout row each vs 10/20 copies
--                           on a 1000 m grid at z=0) -- OPEN
--   kashyyyk_rryatt_trail   not yet measured (levels stacked by height) -- OPEN
--   Buildout tab layouts differ: surface + rryatt lvl 1/2, 4, 5 have 13 columns
--   (objid container server_template_crc cell_index px py pz qw qx qy qz scripts
--   objvars); arena, slaver, avatar_platform, myyydril_caverns, bocctyyy, hracca
--   and rryatt lvl 3 have 11 (no objid/container). px is column 5 only on the 13.
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
-- WHAT NOW EXISTS (K-3 + K-3.1 + K-4 + K-5, ruling 2026-09-04)
--   * SPAWNAREA rows from SOE datatables/buildout/kashyyyk_main/kashyyyk_main.tab
--     area_spawner.iff (240 sourced). Name is kach_sp_<buildout_row> so each row
--     traces to a sourced buildout line. wx/wz are already merged-snapshot world
--     coords (buildout - 4096 on both axes, proved). Spawn limit is SOE
--     intSpawnCount (floored to 1). Radius is max(SOE fltRadius, 32): a Core3 spawn
--     area needs room for a lair, and the NGE area-spawner radii are typically 1-20 m.
--     Live rows are area_spawners whose type table has at least one mapped creature
--     (C6 iff-match under ep3/ OR K-3.1 mapping: custom_content/mobile stubs and
--     numbered set members). The C6 scout was too narrow (ruling 2026-09-04).
--     Fully-OPEN type tables stay as comments so the server does not dangle a
--     spawn-group name; coords stay sourced.
--   * 27 kashyyyk_main patrol_spawner.iff rows are NOT in this file. They need
--     patrol paths from the 126 patrol_waypoint rows -- OPEN for K-3b.
--   * SPAWNAREA rows from SOE datatables/buildout/kashyyyk_hunting/kashyyyk_hunting.tab
--     area_spawner.iff (258 sourced). Name is hunt_sp_<buildout_row>. wx/wz are
--     already merged-snapshot world coords (buildout - 2048 on x, - 5048 on z,
--     proved). Spawn limit is SOE intSpawnCount (floored to 1). Radius is
--     max(SOE fltRadius, 32): a Core3 spawn area needs room for a lair.
--     Region names stay hunting_grounds_* (Etyyy is in no shipped Kashyyyk string
--     table); spawn-group names keep SOE's etyyy_* stems. A type table K-3 already
--     built is reused by name; no second file.
--   * 14 kashyyyk_hunting patrol_spawner.iff rows are NOT in this file. They need
--     patrol paths from the 84 patrol_waypoint rows -- OPEN for K-3b.
--   * SPAWNAREA rows from SOE datatables/buildout/kashyyyk_dead_forest/kashyyyk_dead_forest.tab
--     area_spawner.iff (87 sourced; 84 with a type table). Name is dead_sp_<buildout_row>.
--     wx/wz are already merged-snapshot world coords (buildout - 3548 on x, - 548 on z,
--     proved). Spawn limit is SOE intSpawnCount (floored to 1). Radius is
--     max(SOE fltRadius, 32): a Core3 spawn area needs room for a lair.
--     Region names stay dead_forest_* (Kkowir is in no shipped Kashyyyk string table);
--     spawn-group names keep SOE's forest_* / kash_kkowir_* / rryatt_* / ep3_* stems.
--     Three area_spawners (buildout 5-7) name rebel_trooper / rebel_medic /
--     rebel_first_lieutenant, which have no type table anywhere in SOE's data --
--     listed OPEN, no SPAWNAREA row.
--   * 4 kashyyyk_dead_forest patrol_spawner.iff rows are NOT in this file. They need
--     patrol paths -- OPEN for K-3b.
--   * No world_spawner row. Kashyyyk used placed area-spawners, not a planet-wide
--     spawn list (no spawn_lists/kashyyyk in the leak).
--
-- WHAT IS DELIBERATELY ABSENT
--   * No rows for kashyyyk_rryatt_trail, kashyyyk_north_dungeons,
--     kashyyyk_south_dungeons or kashyyyk_pob_dungeons*. Their snapshots ship
--     only in mtg_patch_023.tre, which the deploy now loads (below 022); their
--     rows belong to the dungeon components (K-8+), each with its own zone.
--   * Only ONE localized region name exists for this planet. kashyyyk_region_names.stf
--     ships exactly one key (kachirho). Any other @kashyyyk_region_names:* string
--     would dangle, so every other row below uses a plain unlocalized name, the
--     same way endor_regions.lua names korga_cave, hot_springs and stone_village.

require("scripts.managers.planet.regions")

--[[

Kashyyyk Creature Spawn Groups
- kashyyyk_clone_droid
- kashyyyk_ep3_clone_relics_sawtooth
- kashyyyk_ep3_clone_relics_trandoshan_researchers
- kashyyyk_ep3_qst_anguished_wookiee
- kashyyyk_ep3_qst_forlorn_wookiee
- kashyyyk_ep3_qst_mad_wookiee
- kashyyyk_ep3_qst_wke_wrhisch
- kashyyyk_etyyy_arcona_addict
- kashyyyk_etyyy_blackscale_guard
- kashyyyk_etyyy_chiss_poacher
- kashyyyk_etyyy_chiss_poacher_defender
- kashyyyk_etyyy_chiss_poacher_hunter
- kashyyyk_etyyy_chiss_poacher_smuggler
- kashyyyk_etyyy_clan_ehartt
- kashyyyk_etyyy_clan_lesser
- kashyyyk_etyyy_clan_sordaan
- kashyyyk_etyyy_clan_tripp
- kashyyyk_etyyy_clan_ziven
- kashyyyk_etyyy_kash_bantha
- kashyyyk_etyyy_kash_bantha_herdleader
- kashyyyk_etyyy_kash_bantha_matriarch
- kashyyyk_etyyy_kash_bantha_quest_greyclimber
- kashyyyk_etyyy_laen_pieweto
- kashyyyk_etyyy_slavermaster_klesk
- kashyyyk_etyyy_uller
- kashyyyk_etyyy_uller_diseased
- kashyyyk_etyyy_uller_elder
- kashyyyk_etyyy_uller_quest_spiketop
- kashyyyk_etyyy_uller_warhoof
- kashyyyk_etyyy_walluga
- kashyyyk_etyyy_walluga_elder
- kashyyyk_etyyy_walluga_frenzied
- kashyyyk_etyyy_walluga_quest_stoneleg
- kashyyyk_etyyy_webweaver
- kashyyyk_etyyy_webweaver_crazed
- kashyyyk_etyyy_webweaver_quest_silkthrower
- kashyyyk_etyyy_webweaver_spiker
- kashyyyk_etyyy_webweaver_warrior
- kashyyyk_forest_blackscale_guard
- kashyyyk_forest_exemplar
- kashyyyk_forest_kerritamba_warrior
- kashyyyk_forest_myssith
- kashyyyk_forest_sayormi
- kashyyyk_forest_sayormi_cyrans
- kashyyyk_forest_sayormi_monk
- kashyyyk_forest_sayormi_queen
- kashyyyk_forest_sayormi_warrior
- kashyyyk_forest_sayormi_witch
- kashyyyk_forest_warchief
- kashyyyk_forest_webweaver_bloodseeker
- kashyyyk_forest_webweaver_gravespinner
- kashyyyk_forest_webweaver_tombsinger
- kashyyyk_kash_blackscale_guard
- kashyyyk_kash_kachirho_bantha
- kashyyyk_kash_kachirho_bantha_bull
- kashyyyk_kash_kachirho_bolotaur
- kashyyyk_kash_kachirho_bolotaur_hard
- kashyyyk_kash_kachirho_canopy_bandits
- kashyyyk_kash_kachirho_canopy_boss
- kashyyyk_kash_kachirho_civilian_chiss
- kashyyyk_kash_kachirho_civilian_wookiee
- kashyyyk_kash_kachirho_guard_trando
- kashyyyk_kash_kachirho_guard_wookiee
- kashyyyk_kash_kachirho_jaggedfang
- kashyyyk_kash_kachirho_uller
- kashyyyk_kash_kachirho_uller_hard
- kashyyyk_kash_kachirho_varactyl
- kashyyyk_kash_kachirho_varactyl_hard
- kashyyyk_kash_kachirho_wke_bloodsample
- kashyyyk_kash_kachirho_wke_ceremonial_guard
- kashyyyk_kash_kachirho_wke_commando
- kashyyyk_kash_kachirho_wke_dead_guard
- kashyyyk_kash_kachirho_wke_fighters
- kashyyyk_kash_kachirho_wke_healthy
- kashyyyk_kash_kachirho_wke_stalkers
- kashyyyk_kash_kachiro_sieged_trandos
- kashyyyk_kash_kkowir_tagged_wookiee
- kashyyyk_kashyyyk_fern_bicker
- kashyyyk_kashyyyk_jyykle_vulture
- kashyyyk_kashyyyk_kklyyytt
- kashyyyk_kashyyyk_pug_jumper
- kashyyyk_kashyyyk_roroo
- kashyyyk_kashyyyk_sathog
- kashyyyk_rryatt_scout_troopers

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
	{"dead_forest_webweaver_den", -1277, 1814, {CIRCLE, 20}, NOSPAWNAREA + NOBUILDZONEAREA},

	-- SPAWNAREA -- Kachirho surface (kashyyyk_main), K-3 + K-3.1
	-- Sourced area_spawner.iff in kashyyyk_main.tab: 240.
	-- Live rows: 239. Still-fully-OPEN type tables: 1 row(s) commented.
	-- Radius floor 32 m: a Core3 spawn area needs room for a lair.
	-- 27 patrol_spawner.iff rows are OPEN for K-3b.
	{"kach_sp_12", -498.75, -113.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_clone_droid"}, 1},
	{"kach_sp_16", 218.16, -124.27, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_wookiee"}, 1},
	{"kach_sp_17", 204.55, -137.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_wookiee"}, 1},
	{"kach_sp_18", 213.48, -151.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_wookiee"}, 1},
	{"kach_sp_19", 245.63, -142.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_wookiee"}, 1},
	{"kach_sp_20", 218.05, -162.81, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_wookiee"}, 1},
	{"kach_sp_21", 284.17, -151.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_wookiee"}, 1},
	{"kach_sp_22", 316.35, -194.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_wookiee"}, 1},
	{"kach_sp_23", 337.53, -223.55, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_wookiee"}, 1},
	{"kach_sp_24", 304.40, -207.81, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_wookiee"}, 1},
	{"kach_sp_25", 274.54, -193.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_wookiee"}, 1},
	{"kach_sp_26", 248.75, -180.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_wookiee"}, 1},
	{"kach_sp_27", 206.65, 95.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_28", 211.21, 106.14, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_29", 104.62, 148.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_30", 134.25, 188.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_31", 478.12, 238.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_32", 476.46, 252.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_33", 524.36, 242.42, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_34", 522.59, 256.17, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_35", 489.06, 276.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_36", 524.32, 359.29, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_37", 530.72, 360.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_38", 431.63, 826.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_39", 412.06, 827.42, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_40", 427.09, 968.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_41", 403.17, 969.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_42", 429.53, 905.68, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_43", 415.42, 892.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_44", 403.52, 955.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_45", 424.75, 955.39, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_46", 427.89, 768.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_47", 406.93, 775.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_blackscale_guard"}, 1},
	{"kach_sp_48", 196.59, 98.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_49", 660.40, -304.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl"}, 2},
	{"kach_sp_50", -402.15, 668.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 3},
	{"kach_sp_51", -405.33, 667.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_boss"}, 1},
	{"kach_sp_52", -74.38, 778.31, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_ceremonial_guard"}, 1},
	{"kach_sp_53", -84.37, 784.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_ceremonial_guard"}, 1},
	{"kach_sp_54", -69.82, 835.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_ceremonial_guard"}, 1},
	{"kach_sp_55", -54.97, 830.39, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_ceremonial_guard"}, 1},
	{"kach_sp_57", -738.44, 247.20, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_dead_guard"}, 1},
	{"kach_sp_58", -755.01, 263.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_dead_guard"}, 1},
	{"kach_sp_59", -757.50, 232.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_dead_guard"}, 1},
	{"kach_sp_60", -773.36, 249.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_dead_guard"}, 1},
	{"kach_sp_61", -799.31, 182.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_dead_guard"}, 1},
	{"kach_sp_62", -815.65, 188.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_dead_guard"}, 1},
	{"kach_sp_63", -562.06, 142.11, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_commando"}, 3},
	{"kach_sp_64", -558.85, 162.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_fighters"}, 3},
	{"kach_sp_65", -540.91, 146.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_fighters"}, 3},
	{"kach_sp_66", -551.06, 178.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_fighters"}, 1},
	{"kach_sp_67", -523.90, 149.87, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_fighters"}, 1},
	{"kach_sp_68", -479.46, 151.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_fighters"}, 3},
	{"kach_sp_69", -493.91, 230.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_fighters"}, 3},
	{"kach_sp_70", -466.20, 281.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_commando"}, 4},
	{"kach_sp_71", -516.85, 276.83, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_commando"}, 4},
	{"kach_sp_72", -438.29, 386.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_fighters"}, 4},
	{"kach_sp_73", 29.13, -1.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_commando"}, 3},
	{"kach_sp_74", -89.52, 268.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_commando"}, 3},
	{"kach_sp_75", 518.82, 657.34, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher"}, 1},
	{"kach_sp_76", 792.92, 434.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_stalkers"}, 1},
	{"kach_sp_77", 806.46, 452.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_stalkers"}, 1},
	{"kach_sp_78", 808.69, 391.51, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_stalkers"}, 3},
	{"kach_sp_79", 797.90, 309.46, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_stalkers"}, 3},
	{"kach_sp_80", 772.92, 289.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_stalkers"}, 4},
	{"kach_sp_81", 738.59, 313.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_uller_hard"}, 2},
	{"kach_sp_82", 701.61, -192.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 3},
	{"kach_sp_83", 699.40, 83.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 3},
	{"kach_sp_84", 525.08, -54.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 3},
	{"kach_sp_85", 443.52, -81.13, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_stalkers"}, 4},
	{"kach_sp_86", 513.96, 36.31, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 3},
	{"kach_sp_87", 611.61, 76.49, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 4},
	{"kach_sp_88", 656.68, 161.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_uller_hard"}, 3},
	{"kach_sp_89", 757.69, 128.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_uller_hard"}, 3},
	{"kach_sp_90", 819.11, 170.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 1},
	{"kach_sp_91", 811.96, 109.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 1},
	{"kach_sp_92", 927.17, 222.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 1},
	{"kach_sp_93", 893.95, 232.78, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 1},
	{"kach_sp_94", 900.41, 135.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 1},
	{"kach_sp_95", 882.45, 173.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl_hard"}, 1},
	{"kach_sp_96", -172.08, 483.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 4},
	{"kach_sp_97", 186.48, 578.04, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_wke_wrhisch"}, 1},
	{"kach_sp_98", 197.37, 631.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_forlorn_wookiee"}, 3},
	{"kach_sp_99", 97.74, 533.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_forlorn_wookiee"}, 3},
	{"kach_sp_100", 233.06, 502.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_forlorn_wookiee"}, 3},
	{"kach_sp_101", 191.40, 597.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_mad_wookiee"}, 2},
	{"kach_sp_102", 140.10, 585.77, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_mad_wookiee"}, 2},
	{"kach_sp_103", 202.46, 549.36, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_mad_wookiee"}, 2},
	{"kach_sp_104", 162.44, 494.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_anguished_wookiee"}, 2},
	{"kach_sp_105", 148.86, 539.13, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_qst_anguished_wookiee"}, 2},
	{"kach_sp_106", 916.13, 240.78, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_jaggedfang"}, 1},
	{"kach_sp_107", 112.04, 162.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_108", 137.93, 214.26, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_109", 149.86, 118.22, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_110", 542.00, 398.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_111", 516.57, 438.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_112", 324.58, -166.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_healthy"}, 1},
	{"kach_sp_113", 167.33, 147.56, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 3},
	{"kach_sp_114", 147.09, 118.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_115", 144.52, 120.46, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_116", 141.88, 123.28, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_117", 139.78, 126.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 1},
	{"kach_sp_118", 157.14, 120.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_119", 138.48, 134.03, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_120", 112.58, 159.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 1},
	{"kach_sp_121", 337.64, 118.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_bloodsample"}, 4},
	{"kach_sp_122", 560.59, 267.42, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_clone_relics_trandoshan_researchers"}, 3},
	{"kach_sp_123", 544.10, 311.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_trando"}, 3},
	{"kach_sp_124", 494.62, 286.93, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_clone_relics_trandoshan_researchers"}, 2},
	{"kach_sp_125", 565.95, 467.42, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_clone_relics_trandoshan_researchers"}, 4},
	{"kach_sp_126", 586.70, 720.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_chiss"}, 3},
	{"kach_sp_127", 578.08, 744.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_chiss"}, 3},
	{"kach_sp_128", 610.35, 754.86, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_civilian_chiss"}, 2},
	{"kach_sp_129", 695.69, 834.93, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_uller"}, 3},
	{"kach_sp_130", 791.60, 821.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_uller"}, 2},
	{"kach_sp_131", 824.64, 780.31, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_uller"}, 3},
	{"kach_sp_132", 764.56, 554.96, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_uller"}, 3},
	{"kach_sp_133", 762.37, -337.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl"}, 3},
	{"kach_sp_134", 786.65, -451.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl"}, 4},
	{"kach_sp_135", 759.09, -510.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha"}, 3},
	{"kach_sp_136", 735.44, -609.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha"}, 3},
	{"kach_sp_137", 663.80, -620.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl"}, 3},
	{"kach_sp_138", 531.35, -522.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl"}, 3},
	{"kach_sp_139", 591.71, -440.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_varactyl"}, 3},
	{"kach_sp_140", 275.92, -286.04, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha"}, 2},
	{"kach_sp_141", -160.05, -82.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha"}, 3},
	{"kach_sp_142", -322.89, -175.93, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha"}, 2},
	{"kach_sp_143", -252.19, 21.80, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 4},
	{"kach_sp_144", -385.43, 464.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bolotaur"}, 3},
	{"kach_sp_145", -275.32, 713.88, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bolotaur_hard"}, 3},
	{"kach_sp_146", -411.43, 537.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 3},
	{"kach_sp_147", -395.70, 578.68, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 3},
	{"kach_sp_148", -390.36, 640.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 3},
	{"kach_sp_149", -379.11, 700.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 3},
	{"kach_sp_150", -384.74, 762.22, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 3},
	{"kach_sp_151", -168.12, 55.35, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_commando"}, 3},
	{"kach_sp_152", -119.81, 108.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachiro_sieged_trandos"}, 2},
	{"kach_sp_153", -110.40, 89.27, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachiro_sieged_trandos"}, 1},
	{"kach_sp_154", -88.65, 115.55, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachiro_sieged_trandos"}, 1},
	{"kach_sp_155", -70.99, 84.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachiro_sieged_trandos"}, 1},
	{"kach_sp_157", -479.91, -88.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_158", -557.08, -170.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_159", -312.73, -162.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_160", -148.38, -94.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 4},
	{"kach_sp_161", -202.95, -104.11, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 4},
	{"kach_sp_162", -92.45, -173.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"kach_sp_163", -45.18, -200.49, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_164", -3.28, -147.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 4},
	{"kach_sp_165", 88.79, -151.39, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_166", 101.97, -134.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"kach_sp_180", 211.91, -86.51, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_220", 284.81, 92.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 4},
	{"kach_sp_221", 254.83, 33.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_222", 336.24, 323.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_229", 404.61, 499.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_230", 417.39, 603.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_236", 673.65, 808.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_237", 763.91, 786.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 2},
	{"kach_sp_238", 830.37, 716.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_239", 825.88, 643.87, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"kach_sp_251", 890.24, 491.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_252", 864.11, 444.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 4},
	{"kach_sp_253", 782.43, 344.42, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_254", 704.31, 263.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_255", 631.17, 119.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_260", 633.99, -255.03, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_wookiee"}, 1},
	{"kach_sp_261", 633.67, -250.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_guard_wookiee"}, 1},
	{"kach_sp_279", 787.42, -401.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 4},
	{"kach_sp_280", 712.26, -459.81, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_286", 565.32, -650.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 5},
	{"kach_sp_287", 589.58, -589.41, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"kach_sp_288", 444.76, -537.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha"}, 4},
	{"kach_sp_289", 503.96, -590.96, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha"}, 4},
	{"kach_sp_290", 549.15, -556.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"kach_sp_291", 573.32, -480.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"kach_sp_292", 425.70, -477.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_300", 205.48, -373.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_301", 259.55, -428.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_302", 263.47, -296.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_303", 198.74, -316.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_304", 221.74, -274.83, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 2},
	{"kach_sp_305", 19.89, -275.67, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"kach_sp_306", 94.69, -305.66, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_313", 293.66, -25.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_314", 334.01, -49.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_315", 376.87, -71.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_316", 402.61, -9.14, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_canopy_bandits"}, 3},
	{"kach_sp_317", 437.76, -51.23, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_318", 146.24, -45.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_319", 36.61, -46.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_320", -24.39, -5.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 5},
	{"kach_sp_321", -81.20, -8.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_322", -158.05, 25.99, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_323", -68.27, 404.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_324", -52.74, 440.06, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_325", 40.78, 493.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 2},
	{"kach_sp_326", 166.67, 535.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_327", 164.89, 590.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_328", 157.85, 773.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_329", 119.18, 811.52, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 4},
	{"kach_sp_330", 92.56, 769.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_331", 236.10, 743.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 4},
	{"kach_sp_338", 315.15, 710.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_339", -34.75, 742.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_340", -87.56, 757.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 4},
	{"kach_sp_341", -28.68, 693.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 2},
	{"kach_sp_342", -98.51, 542.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 5},
	{"kach_sp_343", -82.99, 602.36, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"kach_sp_348", -275.11, 453.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_358", -265.27, 675.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_359", -321.71, 607.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_360", -308.07, 645.30, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bolotaur"}, 3},
	{"kach_sp_361", -186.65, 884.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_362", -223.10, 897.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_369", -365.59, 419.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_370", -348.05, 500.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"kach_sp_375", -472.03, 316.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_380", -346.63, 130.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_381", -281.99, 65.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 4},
	{"kach_sp_382", -581.53, 101.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_383", -681.04, 91.74, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_384", -646.95, 49.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_385", -701.11, -4.99, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_386", -859.89, -224.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_387", -944.06, -121.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 5},
	{"kach_sp_388", -807.18, -52.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"kach_sp_389", -810.53, 2.17, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"kach_sp_390", 135.94, 171.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_clone_relics_trandoshan_researchers"}, 8},
	{"kach_sp_1607", 651.15, 668.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha_bull"}, 3},
	{"kach_sp_1608", 676.90, 771.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha_bull"}, 3},
	{"kach_sp_1609", 750.09, 749.81, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha_bull"}, 3},
	{"kach_sp_1610", 800.88, 702.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha_bull"}, 3},
	{"kach_sp_1611", 790.74, 621.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha_bull"}, 3},
	{"kach_sp_1612", 766.90, 490.42, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha_bull"}, 3},
	{"kach_sp_1613", 704.52, -399.78, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_bantha_bull"}, 3},
	{"kach_sp_1614", 328.16, 451.73, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_uller"}, 3},
	{"kach_sp_1662", 582.18, -637.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_lesser"}, 1},
	{"kach_sp_1663", 567.31, -643.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_lesser"}, 1},
	{"kach_sp_1664", 587.35, -637.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_lesser"}, 1},
	-- OPEN area_spawner.iff rows (not live; would dangle). Count = 1.
	-- Full sourced row is in the comment so a later round can uncomment when a repo template exists.
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for ep3_npc_ceremonial_captain): {"kach_sp_56", -54.40, 839.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kachirho_wke_ceremonial_captain"}, 1}, -- strSpawns type table fully unmatched


	-- SPAWNAREA -- Hunting grounds (kashyyyk_hunting), K-4
	-- Sourced area_spawner.iff in kashyyyk_hunting.tab: 258.
	-- Live rows: 225. Still-fully-OPEN type tables: 33 row(s) commented.
	-- Radius floor 32 m: a Core3 spawn area needs room for a lair.
	-- 14 patrol_spawner.iff rows are OPEN for K-3b.
	{"hunt_sp_3", -1212.96, -3127.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_laen_pieweto"}, 1},
	{"hunt_sp_4", -1204.15, -3133.07, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_5", -1216.12, -3113.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_6", -1196.88, -3124.22, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_7", -1177.44, -3136.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_8", -1181.95, -3096.96, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_9", -1206.72, -3085.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_10", -1178.78, -3072.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_smuggler"}, 3},
	{"hunt_sp_11", -1159.12, -3070.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_smuggler"}, 3},
	{"hunt_sp_12", -1145.51, -3066.46, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_smuggler"}, 3},
	{"hunt_sp_13", -1182.77, -3041.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_smuggler"}, 3},
	{"hunt_sp_14", -1211.72, -3021.87, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_15", -1202.46, -3007.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_16", -1220.08, -2997.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_17", -1199.53, -2955.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_18", -1195.10, -2930.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_19", -1201.57, -2915.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_hunter"}, 3},
	{"hunt_sp_20", -1162.62, -2936.36, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_smuggler"}, 3},
	{"hunt_sp_21", -1140.12, -2937.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_smuggler"}, 3},
	{"hunt_sp_22", -1095.84, -2907.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 4},
	{"hunt_sp_23", -1109.87, -2928.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 4},
	{"hunt_sp_24", -1109.28, -2956.39, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 4},
	{"hunt_sp_25", -1139.12, -2980.04, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_smuggler"}, 2},
	{"hunt_sp_26", -1107.99, -3003.13, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 4},
	{"hunt_sp_27", -1107.88, -3060.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 4},
	{"hunt_sp_28", -1085.07, -3101.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 4},
	{"hunt_sp_29", -1148.28, -3169.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 4},
	{"hunt_sp_30", -1137.47, -3141.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_smuggler"}, 3},
	{"hunt_sp_31", -1171.65, -3213.26, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 3},
	{"hunt_sp_32", -1068.30, -2878.12, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher_defender"}, 3},
	{"hunt_sp_33", -277.06, -2517.13, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha_quest_greyclimber"}, 1},
	{"hunt_sp_34", -274.86, -2514.17, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha_herdleader"}, 1},
	{"hunt_sp_35", -221.55, -2537.78, {CIRCLE, 50}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha_matriarch"}, 5},
	{"hunt_sp_36", -143.80, -2574.78, {CIRCLE, 50}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 6},
	{"hunt_sp_37", -375.69, -2494.96, {CIRCLE, 50}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 5},
	{"hunt_sp_38", -383.23, -2506.92, {CIRCLE, 50}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha_matriarch"}, 3},
	{"hunt_sp_55", 832.00, -2876.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 4},
	{"hunt_sp_56", 827.39, -2875.51, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_elder"}, 2},
	{"hunt_sp_57", 896.37, -2893.36, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_elder"}, 2},
	{"hunt_sp_58", 894.84, -2901.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 4},
	{"hunt_sp_59", 1029.69, -2812.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_warhoof"}, 3},
	{"hunt_sp_60", 1057.24, -2847.52, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_warhoof"}, 3},
	{"hunt_sp_61", 1095.75, -2838.17, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_quest_spiketop"}, 1},
	{"hunt_sp_62", 759.09, -2864.78, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_elder"}, 2},
	{"hunt_sp_63", 756.66, -2890.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 4},
	{"hunt_sp_64", 704.94, -2999.13, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller"}, 3},
	{"hunt_sp_65", 824.38, -2772.17, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_elder"}, 3},
	{"hunt_sp_66", 886.40, -2759.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 3},
	{"hunt_sp_67", 685.91, -3056.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_elder"}, 3},
	{"hunt_sp_68", 621.77, -3062.04, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 4},
	{"hunt_sp_69", 603.23, -3163.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller"}, 4},
	{"hunt_sp_70", -682.14, -3519.07, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_quest_stoneleg"}, 1},
	{"hunt_sp_71", -688.14, -3517.56, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_frenzied"}, 1},
	{"hunt_sp_72", -771.57, -3573.11, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_frenzied"}, 2},
	{"hunt_sp_73", -718.18, -3695.88, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_frenzied"}, 2},
	{"hunt_sp_74", -626.81, -3602.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_frenzied"}, 2},
	{"hunt_sp_75", -702.71, -3596.36, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_frenzied"}, 3},
	{"hunt_sp_76", -572.33, -3524.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_elder"}, 3},
	{"hunt_sp_77", -527.96, -3510.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 3},
	{"hunt_sp_78", -781.74, -3503.39, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_elder"}, 3},
	{"hunt_sp_79", -848.12, -3627.42, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_elder"}, 2},
	{"hunt_sp_80", -846.79, -3629.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 3},
	{"hunt_sp_81", 1110.71, -3422.78, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_quest_silkthrower"}, 1},
	{"hunt_sp_82", 1112.25, -3428.14, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_spiker"}, 3},
	{"hunt_sp_83", 994.46, -3543.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_spiker"}, 3},
	{"hunt_sp_84", 1042.14, -3496.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_spiker"}, 2},
	{"hunt_sp_85", 1015.30, -3510.23, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_warrior"}, 4},
	{"hunt_sp_86", 1054.01, -3550.27, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_warrior"}, 3},
	{"hunt_sp_87", 1128.90, -3541.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_warrior"}, 3},
	{"hunt_sp_88", 1181.34, -3493.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_spiker"}, 3},
	{"hunt_sp_89", 1190.48, -3530.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_warrior"}, 3},
	{"hunt_sp_90", 1249.27, -3549.58, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 3},
	{"hunt_sp_91", 1216.26, -3583.30, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 3},
	{"hunt_sp_92", 1160.49, -3604.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 4},
	{"hunt_sp_93", 1074.60, -3629.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 4},
	{"hunt_sp_94", 1006.00, -3615.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 2},
	{"hunt_sp_95", 881.37, -3488.13, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_warrior"}, 3},
	{"hunt_sp_96", 889.26, -3451.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 3},
	{"hunt_sp_97", 820.71, -3472.52, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 4},
	{"hunt_sp_98", 764.58, -3490.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 3},
	{"hunt_sp_99", 671.86, -3474.73, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 2},
	{"hunt_sp_100", -135.13, -3776.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_blackscale_guard"}, 2},
	{"hunt_sp_101", -146.96, -3747.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_blackscale_guard"}, 2},
	{"hunt_sp_102", -122.40, -3782.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_blackscale_guard"}, 1},
	{"hunt_sp_103", -126.77, -3788.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_blackscale_guard"}, 1},
	{"hunt_sp_104", -129.80, -3782.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_slavermaster_klesk"}, 1},
	{"hunt_sp_105", 596.62, -2446.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_106", 590.53, -2450.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_107", 564.70, -2471.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_122", 592.73, -2408.19, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"hunt_sp_123", 607.03, -2414.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 2},
	{"hunt_sp_124", 429.08, -2500.68, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"hunt_sp_125", 410.65, -2505.96, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"hunt_sp_130", 409.79, -2471.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"hunt_sp_139", 275.74, -2515.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_140", 281.89, -2488.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_145", 239.63, -2522.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_146", 312.44, -2462.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_147", 314.58, -2462.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_156", 191.06, -2534.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ehartt"}, 1},
	{"hunt_sp_157", 194.26, -2532.32, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ehartt"}, 1},
	{"hunt_sp_158", 176.15, -2540.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ehartt"}, 1},
	{"hunt_sp_166", 108.00, -2550.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_167", 108.21, -2534.41, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_175", 164.26, -2390.07, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_tripp"}, 1},
	{"hunt_sp_176", 190.17, -2393.93, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_tripp"}, 1},
	{"hunt_sp_177", 175.72, -2391.55, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_tripp"}, 1},
	{"hunt_sp_178", 186.74, -2393.86, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_tripp"}, 1},
	{"hunt_sp_179", 151.63, -2590.95, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_188", 64.78, -2632.83, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"hunt_sp_189", 31.99, -2603.58, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"hunt_sp_190", 0.24, -2650.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 1},
	{"hunt_sp_191", -15.39, -2688.29, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 1},
	{"hunt_sp_192", -48.27, -2657.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"hunt_sp_193", -104.48, -2646.55, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 3},
	{"hunt_sp_194", -50.00, -2740.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 4},
	{"hunt_sp_195", -71.22, -2745.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"hunt_sp_196", -117.88, -2786.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha_herdleader"}, 3},
	{"hunt_sp_197", -188.04, -2776.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"hunt_sp_198", -260.45, -2872.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_199", -198.47, -2915.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_200", -169.02, -2859.87, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 2},
	{"hunt_sp_201", -59.80, -2856.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha_matriarch"}, 1},
	{"hunt_sp_202", -64.69, -2857.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 2},
	{"hunt_sp_203", 33.23, -2802.29, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_204", -221.54, -2517.27, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"hunt_sp_205", -166.63, -2454.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 2},
	{"hunt_sp_206", -224.48, -2413.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"hunt_sp_207", -156.18, -2392.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"hunt_sp_208", -129.47, -2407.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 2},
	{"hunt_sp_209", -119.59, -2352.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha_matriarch"}, 1},
	{"hunt_sp_210", -125.28, -2352.26, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 1},
	{"hunt_sp_211", -473.86, -2345.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"hunt_sp_212", -500.19, -2391.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 2},
	{"hunt_sp_213", -354.57, -2564.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"hunt_sp_214", -283.93, -2654.80, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha"}, 2},
	{"hunt_sp_215", -263.42, -2642.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_kash_bantha_herdleader"}, 1},
	{"hunt_sp_216", -269.76, -2742.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"hunt_sp_217", -347.42, -2755.87, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 4},
	{"hunt_sp_218", -397.21, -2802.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_219", -409.44, -2726.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_chiss_poacher"}, 2},
	{"hunt_sp_221", -528.55, -2295.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"hunt_sp_222", -639.66, -2306.64, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 2},
	{"hunt_sp_223", -637.46, -2388.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_225", -632.46, -2234.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"hunt_sp_226", -408.61, -2279.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 2},
	{"hunt_sp_227", -378.80, -2215.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_arcona_addict"}, 1},
	{"hunt_sp_231", -480.85, -2191.18, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_arcona_addict"}, 1},
	{"hunt_sp_232", -609.37, -2120.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_arcona_addict"}, 1},
	{"hunt_sp_233", -606.12, -2115.80, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_arcona_addict"}, 1},
	{"hunt_sp_234", -612.22, -2115.96, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_arcona_addict"}, 1},
	{"hunt_sp_235", -575.81, -2089.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_arcona_addict"}, 1},
	{"hunt_sp_245", -730.59, -2281.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_246", -869.49, -2276.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 2},
	{"hunt_sp_247", -842.28, -2368.09, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_250", -915.95, -2334.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 2},
	{"hunt_sp_251", -1016.58, -2329.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_258", -1023.44, -2377.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_263", -1157.05, -3255.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"hunt_sp_264", -1116.10, -3430.47, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 1},
	{"hunt_sp_265", -1132.36, -3370.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 1},
	{"hunt_sp_266", -1071.96, -3499.63, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 2},
	{"hunt_sp_267", -967.70, -3544.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 1},
	{"hunt_sp_268", -967.08, -3528.49, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 1},
	{"hunt_sp_269", -921.30, -3566.51, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"hunt_sp_270", -898.71, -3499.14, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 2},
	{"hunt_sp_271", -666.23, -3449.95, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 2},
	{"hunt_sp_272", -741.13, -3450.99, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_elder"}, 2},
	{"hunt_sp_273", -720.70, -3769.64, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 1},
	{"hunt_sp_274", -636.19, -3680.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 1},
	{"hunt_sp_275", -551.21, -3590.32, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_elder"}, 2},
	{"hunt_sp_276", -494.95, -3641.93, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 3},
	{"hunt_sp_277", -507.98, -3703.06, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_elder"}, 2},
	{"hunt_sp_278", -544.98, -3825.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga_frenzied"}, 2},
	{"hunt_sp_279", -572.83, -3724.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 2},
	{"hunt_sp_280", -478.67, -3791.44, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 1},
	{"hunt_sp_281", -384.54, -3516.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 2},
	{"hunt_sp_282", -391.49, -3637.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"hunt_sp_283", -401.22, -3772.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 3},
	{"hunt_sp_284", -396.42, -3819.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"hunt_sp_285", -316.19, -3817.74, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"hunt_sp_286", -292.94, -3644.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_walluga"}, 2},
	{"hunt_sp_287", -239.27, -3692.74, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_288", -230.29, -3615.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_289", -128.16, -3664.77, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_290", -52.43, -3730.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver"}, 2},
	{"hunt_sp_291", 228.01, -3402.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 2},
	{"hunt_sp_292", 440.20, -3494.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver"}, 2},
	{"hunt_sp_293", 461.89, -3408.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_warrior"}, 4},
	{"hunt_sp_294", 435.31, -3446.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver_crazed"}, 3},
	{"hunt_sp_295", 584.94, -3424.64, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_webweaver"}, 2},
	{"hunt_sp_296", 541.09, -3586.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_kklyyytt"}, 3},
	{"hunt_sp_297", 292.44, -3242.74, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"hunt_sp_298", 282.40, -3183.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 3},
	{"hunt_sp_299", 273.60, -3109.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_jyykle_vulture"}, 3},
	{"hunt_sp_300", 438.55, -3170.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller"}, 3},
	{"hunt_sp_301", 451.93, -3090.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_302", 537.29, -3100.49, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller"}, 2},
	{"hunt_sp_303", 679.39, -3127.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 3},
	{"hunt_sp_304", 732.80, -3064.50, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 2},
	{"hunt_sp_305", 682.81, -2949.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 2},
	{"hunt_sp_306", 775.22, -2963.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_diseased"}, 2},
	{"hunt_sp_307", 824.61, -2936.21, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_elder"}, 2},
	{"hunt_sp_308", 944.25, -2862.03, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_elder"}, 2},
	{"hunt_sp_309", 966.38, -2825.30, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_uller_elder"}, 2},
	{"hunt_sp_310", 394.20, -2976.53, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"hunt_sp_311", 306.79, -2992.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_312", 310.10, -2912.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_pug_jumper"}, 3},
	{"hunt_sp_313", 235.85, -2898.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"hunt_sp_314", 192.21, -2743.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_sathog"}, 4},
	{"hunt_sp_315", 172.93, -3021.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_fern_bicker"}, 3},
	{"hunt_sp_316", 111.56, -2989.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kashyyyk_roroo"}, 3},
	{"hunt_sp_326", 52.76, -3054.87, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_333", -6.59, -3194.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"hunt_sp_334", -84.18, -3220.96, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"hunt_sp_335", -36.40, -3208.82, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_ziven"}, 1},
	{"hunt_sp_336", 51.27, -3055.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_337", 125.33, -3056.30, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_338", 102.53, -3078.68, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_339", 34.45, -3228.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_340", 31.89, -3228.97, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_341", 91.29, -3199.73, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_342", 74.59, -3183.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_343", 69.39, -3186.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_clan_sordaan"}, 1},
	{"hunt_sp_377", 221.45, -2432.26, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_clone_droid"}, 1},
	-- OPEN area_spawner.iff rows (not live; would dangle). Count = 33.
	-- Full sourced row is in the comment so a later round can uncomment when a repo template exists.
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_39", -1169.58, -2260.92, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_quest_brightclaw"}, 1}, -- strSpawns=kashyyyk/etyyy_mouf_quest_brightclaw soe_radius=3.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_40", -1156.81, -2444.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=6.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_41", -1216.02, -2405.11, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=8.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_42", -1171.76, -2274.26, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_roarlord"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf_roarlord soe_radius=10.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_43", -1150.00, -2340.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_roarlord"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf_roarlord soe_radius=10.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_44", -1073.43, -2164.58, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=10.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_45", -1096.47, -2287.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf soe_radius=10.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_46", -1074.51, -2376.52, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf soe_radius=10.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_47", -976.27, -2239.91, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=10.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_48", -833.77, -2188.70, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 4}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=10.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_49", -892.37, -2129.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 4}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=10.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_50", -913.02, -2182.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=5.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_51", -953.23, -2111.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=5.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_52", -922.57, -2078.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_quest_paleclaw"}, 1}, -- strSpawns=kashyyyk/etyyy_mouf_quest_paleclaw soe_radius=3.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_53", -824.76, -2125.48, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 1}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=3.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_54", -823.94, -2128.51, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=5.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_220", -528.50, -2352.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=6.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_224", -603.32, -2434.58, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 1}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=3.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_248", -746.74, -2465.99, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=5.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_249", -740.46, -2400.22, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 1}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=0.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_252", -1128.64, -2290.11, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=4.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_253", -1094.66, -2214.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=4.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_254", -1225.53, -2339.73, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=4.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_255", -1239.37, -2431.15, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=4.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_256", -1197.32, -2364.08, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=4.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_257", -1124.25, -2461.07, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vicious"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vicious soe_radius=4.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_259", -994.21, -2404.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=4.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_260", -898.54, -2485.14, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=5.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_261", -913.55, -2521.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=4.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_262", -852.20, -2708.98, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 3}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=5.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_374", -289.23, -2351.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=3.0 soe_count=2
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_375", -242.46, -2323.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 1}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=0.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"hunt_sp_376", -265.95, -2311.13, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_etyyy_mouf_vibrant"}, 2}, -- strSpawns=kashyyyk/etyyy_mouf_vibrant soe_radius=3.0 soe_count=2


	-- SPAWNAREA -- Dead forest (kashyyyk_dead_forest), K-5
	-- Sourced area_spawner.iff in kashyyyk_dead_forest.tab: 87.
	-- With a type table: 84. Three rebel_* strSpawns have no type table
	-- anywhere in SOE's data (buildout 5-7): listed OPEN, no SPAWNAREA row.
	-- Live rows: 58. Still-fully-OPEN type tables: 26 row(s) commented.
	-- Radius floor 32 m: a Core3 spawn area needs room for a lair.
	-- 4 patrol_spawner.iff rows are OPEN for K-3b.
	{"dead_sp_8", -1288.92, 1778.03, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_webweaver_gravespinner"}, 4},
	{"dead_sp_9", -1307.45, 1747.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_webweaver_tombsinger"}, 4},
	{"dead_sp_10", -1339.12, 1735.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_webweaver_bloodseeker"}, 4},
	{"dead_sp_11", -1346.81, 1663.36, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_webweaver_gravespinner"}, 2},
	{"dead_sp_15", -1371.34, 1395.99, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_witch"}, 1},
	{"dead_sp_16", -1370.67, 1389.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_17", -1366.26, 1387.00, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_monk"}, 1},
	{"dead_sp_18", -1351.53, 1388.64, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_19", -1360.22, 1407.09, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_20", -1120.96, 1391.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_queen"}, 1},
	{"dead_sp_21", -1118.75, 1351.71, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_22", -1101.22, 1369.75, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_23", -1112.99, 1388.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_witch"}, 1},
	{"dead_sp_24", -1127.39, 1386.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_witch"}, 1},
	{"dead_sp_25", -1106.91, 1383.05, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_witch"}, 1},
	{"dead_sp_26", -1131.56, 1379.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_witch"}, 1},
	{"dead_sp_27", -1055.19, 1243.34, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 4},
	{"dead_sp_28", -1055.86, 1146.88, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 4},
	{"dead_sp_29", -1244.85, 1113.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 4},
	{"dead_sp_30", -1368.10, 1278.33, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_monk"}, 1},
	{"dead_sp_31", -1369.44, 1252.10, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_32", -1364.21, 1254.32, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_monk"}, 1},
	{"dead_sp_33", -1363.08, 1258.57, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_34", -1177.99, 1161.04, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 4},
	{"dead_sp_36", -1652.36, 1245.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 5},
	{"dead_sp_37", -1642.31, 1267.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_38", -1629.21, 1256.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_39", -1575.51, 1303.27, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_40", -1591.68, 1304.78, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_41", -1686.28, 1330.88, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_42", -1690.18, 1345.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_43", -1692.15, 1354.40, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_44", -1767.83, 1318.89, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_45", -1770.22, 1326.96, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_46", -1794.73, 1315.23, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_47", -1789.36, 1310.85, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_48", -1799.33, 1295.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_49", -1804.92, 1300.29, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 1},
	{"dead_sp_62", -1739.72, 1395.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_kerritamba_warrior"}, 4},
	{"dead_sp_66", -1792.87, 1116.60, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_myssith"}, 1},
	{"dead_sp_67", -1793.65, 1106.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_blackscale_guard"}, 3},
	{"dead_sp_68", -1132.29, 1712.72, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kkowir_tagged_wookiee"}, 3},
	{"dead_sp_69", -1158.60, 1739.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kkowir_tagged_wookiee"}, 2},
	{"dead_sp_70", -1184.15, 1718.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kkowir_tagged_wookiee"}, 2},
	{"dead_sp_71", -1133.48, 1668.61, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kkowir_tagged_wookiee"}, 2},
	{"dead_sp_72", -1167.03, 1658.43, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_kash_kkowir_tagged_wookiee"}, 2},
	{"dead_sp_73", -1098.71, 1047.86, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_ep3_clone_relics_sawtooth"}, 1},
	{"dead_sp_92", -1494.74, 1716.22, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_exemplar"}, 1},
	{"dead_sp_136", -1225.71, 1473.80, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_rryatt_scout_troopers"}, 2},
	{"dead_sp_137", -1260.20, 1519.38, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 6},
	{"dead_sp_138", -1344.16, 1344.74, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 5},
	{"dead_sp_139", -1316.79, 1222.06, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 4},
	{"dead_sp_142", -1168.69, 1081.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 4},
	{"dead_sp_143", -1052.14, 1319.41, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_witch"}, 5},
	{"dead_sp_144", -1069.38, 1374.59, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 4},
	{"dead_sp_145", -1154.28, 1371.02, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_146", -1163.91, 1351.24, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi_warrior"}, 1},
	{"dead_sp_147", -1148.94, 1302.69, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_sayormi"}, 3},
	-- OPEN area_spawner.iff rows (not live; would dangle). Count = 26.
	-- Full sourced row is in the comment so a later round can uncomment when a repo template exists.
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_12", -1361.41, 1491.62, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_great_mouf"}, 4}, -- strSpawns=kashyyyk/forest_great_mouf soe_radius=10.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_13", -1307.40, 1440.41, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_great_mouf"}, 4}, -- strSpawns=kashyyyk/forest_great_mouf soe_radius=15.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_14", -1301.84, 1364.14, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 4}, -- strSpawns=kashyyyk/forest_mouf soe_radius=15.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_35", -1154.42, 1221.16, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_great_mouf"}, 4}, -- strSpawns=kashyyyk/forest_great_mouf soe_radius=15.0 soe_count=4
	{"dead_sp_50", -1655.34, 1900.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 6},
	{"dead_sp_51", -1616.48, 1707.03, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 3},
	{"dead_sp_52", -1715.91, 1624.26, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 3},
	{"dead_sp_53", -1813.82, 1542.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 3},
	{"dead_sp_54", -1679.67, 1500.83, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 4},
	{"dead_sp_55", -1549.26, 1513.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 4},
	{"dead_sp_56", -1465.35, 1555.90, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 3},
	{"dead_sp_57", -1409.03, 1577.01, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 2},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_58", -1484.33, 1686.25, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 3}, -- strSpawns=kashyyyk/forest_mouf soe_radius=5.0 soe_count=3
	{"dead_sp_59", -1476.39, 1737.79, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 3},
	{"dead_sp_60", -1294.14, 1623.76, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 6},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_61", -1726.88, 1560.34, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 2}, -- strSpawns=kashyyyk/forest_mouf soe_radius=5.0 soe_count=2
	{"dead_sp_63", -1875.58, 1425.84, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 4},
	{"dead_sp_64", -1925.58, 1327.94, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 4},
	{"dead_sp_65", -1917.76, 1193.66, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_shadevale"}, 3},
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_91", -1405.79, 1483.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_steelclaw"}, 1}, -- strSpawns=kashyyyk/forest_steelclaw soe_radius=5.0 soe_count=1
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_134", -1464.97, 1629.54, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 4}, -- strSpawns=kashyyyk/forest_mouf soe_radius=5.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_135", -1393.52, 1619.55, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 3}, -- strSpawns=kashyyyk/forest_mouf soe_radius=5.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_140", -1305.76, 1208.37, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 3}, -- strSpawns=kashyyyk/forest_mouf soe_radius=5.0 soe_count=3
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_141", -1227.06, 1033.45, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 4}, -- strSpawns=kashyyyk/forest_mouf soe_radius=5.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_148", -1187.05, 1394.65, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 4}, -- strSpawns=kashyyyk/forest_mouf soe_radius=5.0 soe_count=4
	-- OPEN (type table fully unmatched, ruling 2026-09-04: no repo file for type): {"dead_sp_149", -1345.04, 1554.06, {CIRCLE, 32}, SPAWNAREA, {"kashyyyk_forest_mouf"}, 6}, -- strSpawns=kashyyyk/forest_mouf soe_radius=5.0 soe_count=6

}
