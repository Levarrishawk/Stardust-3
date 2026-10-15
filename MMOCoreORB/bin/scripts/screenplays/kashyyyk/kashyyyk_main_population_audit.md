# Kachirho scripted population audit

Source: [SWG-Source/dsrc](https://github.com/SWG-Source/dsrc/tree/master/sku.0/sys.server/compiled/game).

240 main-map controllers, 579 authored creature slots, 38 type tables.

Counts, radii, headings and timers are preserved per controller. All source placements are outdoors and use intGoodLocationSpawner=0. The retail placement helper offsets each horizontal axis independently within the radius; it does not distribute encounters across the planet.

First spawn is delayed 20 seconds; subsequent population slots fill at the sourced respawn intervals. A dead slot remains reserved until its sourced delay plus the retail two-second refill delay. Core3 STATIC/STATIONARY AI supplies local loiter/sentinel behaviour. No creature statistics or rewards are edited.

Zero-radius controllers retain authored height, including upper tree landings, except the four ground-level ceremonial-guard controllers (rows 52-55), which explicitly resolve the current world floor to avoid floating at the DSRC spawner height. Their authored coordinates remain recorded in the data; only spawn height is resolved at runtime. Other controllers use the existing world-floor helper at their local offset. Placement and navigation require Debian/in-game validation; the retail clearance search is unused for these controllers.

Patrol and celebrity controllers remain owned by their existing screenplays. The old 239 main-map dynamic SPAWNAREA rows are removed; named, no-build and no-spawn regions remain.

240 controllers can populate all 579 slots with available templates. The ceremonial captain now resolves to its DSRC appearance through ep3_wke_cerimonial_captain; its creature definition inherits the existing Core3 ceremonial-guard combat, XP and empty-loot profile unchanged. DSRC's different captain level, specials and elite loot are not imported. Wookiee battle-leader selections now resolve to both DSRC appearances, ep3_wke_battleleader_01 and ep3_wke_battleleader_02. They inherit the existing Core3 Wookiee Commando combat, XP and loot profile; DSRC leader-specific stats, specials and loot are not imported. The source table retains two commando rows, three freedom-fighter rows and one battle-leader row, selected uniformly, with both leader appearances available within that row. Five prior wildlife compatibility substitutions are retained and disclosed below.

Deployment requires the two population Lua files, their screenplays.lua includes, the main-region update, and the captain and two battle-leader creature definitions with their mobile and object serverobjects.lua registrations together, followed by a server restart. No C++ rebuild or client TRE change is required. Allow 20 seconds for first spawns; packs fill gradually at authored intervals. On Debian, inspect packs in the south/east wildlife areas and the northern camps, kill a pack member and verify its replacement, then restart and confirm populations do not duplicate.

Local verification: Lua 5.1 simulation covers all supported slots, local bounds, zero-radius platform heights, AI flags, failed-spawn retries, stale events, repeated startup, reserved dead slots and disabled-zone recovery. Separate source checks compare all 240 controllers to the buildout and confirm all 93 selected mobiles are in the active mobile include chain. Runtime terrain, water and pathing still require in-game checks.

The regeneration utility at MMOCoreORB/utils/kashyyyk/build_main_population.py is local and excluded by the repository-wide *.py rule; deployment does not depend on it. Generated data and this audit are ordinary repository files.

## Creature mappings and remaining gaps

| Retail creature | Core3 mobiles | Notes |
|---|---|---|
| clone_droid | clone_droid |  |
| clone_relics_trandoshan_researcher | ep3_clone_relics_trandoshan_researcher_01, ep3_clone_relics_trandoshan_researcher_02, ep3_clone_relics_trandoshan_researcher_03, ep3_clone_relics_trandoshan_researcher_04, ep3_clone_relics_trandoshan_researcher_05, ep3_clone_relics_trandoshan_researcher_06, ep3_clone_relics_trandoshan_researcher_07, ep3_clone_relics_trandoshan_researcher_08 |  |
| ep3_etyyy_chiss_poacher | ep3_etyyy_chiss_poacher_01, ep3_etyyy_chiss_poacher_02, ep3_etyyy_chiss_poacher_03, ep3_etyyy_chiss_poacher_04, ep3_etyyy_chiss_poacher_05 |  |
| ep3_jyykle_vulture | ep3_jyykle_vulture |  |
| ep3_kachirho_bantha | kashyyyk_bantha |  |
| ep3_kachirho_bantha_bull | kashyyyk_bull_bantha |  |
| ep3_kachirho_bantha_matriarch | kashyyyk_matriarch_bantha |  |
| ep3_kachirho_bolotaur | bolotaur |  |
| ep3_kachirho_bolotaur_fleshripper | bolotaur | Missing dedicated fleshripper; existing substitution retained. |
| ep3_kachirho_canopy_bandit | ep3_canopy_bandit_01, ep3_canopy_bandit_02, ep3_canopy_bandit_03, ep3_canopy_bandit_04 |  |
| ep3_kachirho_canopy_boss | ep3_canopy_boss |  |
| ep3_kachirho_canopy_cutthroat | ep3_canopy_bandit_01, ep3_canopy_bandit_02, ep3_canopy_bandit_03, ep3_canopy_bandit_04 |  |
| ep3_kachirho_canopy_reaper | ep3_canopy_reaper_01 |  |
| ep3_kachirho_chiss_villager | ep3_etyyy_chiss_poacher_01, ep3_etyyy_chiss_poacher_02, ep3_etyyy_chiss_poacher_03, ep3_etyyy_chiss_poacher_04, ep3_etyyy_chiss_poacher_05 |  |
| ep3_kachirho_sunbaked | bolotaur | Retail type-table typo; creatures.tab uses ep3_kachirho_bolotaur_sunbaked. No dedicated Core3 variant. |
| ep3_kachirho_uller | uller_stoneclaw | Existing normal-uller substitution; identity/stat audit still needed. |
| ep3_kachirho_uller_packleader | uller_stoneclaw | Missing dedicated packleader; existing substitution retained. |
| ep3_kachirho_uller_stoneclaw | uller_stoneclaw |  |
| ep3_kachirho_varactyl | varactyl_deathspine | Existing normal-varactyl substitution; identity/stat audit still needed. |
| ep3_kachirho_varactyl_deathspine | varactyl_deathspine |  |
| ep3_kachirho_varactyl_jaggedfang | varactyl_jagged_fang |  |
| ep3_kachirho_varactyl_preystalker | varactyl_preystalker |  |
| ep3_kachirho_wke_bloodsample | ep3_wke_civilian_01 |  |
| ep3_kachirho_wke_healthy | ep3_wke_civilian_05 |  |
| ep3_kklyyytt | ep3_kklyyytt |  |
| ep3_npc_ceremonial_captain | ep3_wke_cerimonial_captain | DSRC creatures.tab appearance ep3/ep3_wke_cerimonial_captain.iff; inherits existing ceremonial-guard combat, XP and loot profile. |
| ep3_npc_ceremonial_guard | ep3_wke_cerimonial_guard_01, ep3_wke_cerimonial_guard_02, ep3_wke_cerimonial_guard_03, ep3_wke_cerimonial_guard_04 |  |
| ep3_npc_dead_guard | ep3_wke_dead_guard_01, ep3_wke_dead_guard_02, ep3_wke_dead_guard_03 |  |
| ep3_npc_rodian_lesser_hunter | ep3_etyyy_hunter_lesser_rodian_01, ep3_etyyy_hunter_lesser_rodian_02, ep3_etyyy_hunter_lesser_rodian_03, ep3_etyyy_hunter_lesser_rodian_04 |  |
| ep3_npc_trandoshan_slavers | ep3_trando_slaver_01, ep3_trando_slaver_02, ep3_trando_slaver_03, ep3_trando_slaver_04, ep3_trando_slaver_05 |  |
| ep3_npc_wookiee_battleleader | ep3_wke_battleleader_01, ep3_wke_battleleader_02 | DSRC ep3_wke_battleleader appearance group; both inherit the existing Wookiee Commando combat, XP and loot profile. |
| ep3_npc_wookiee_commando | ep3_wke_commando_01, ep3_wke_commando_02, ep3_wke_commando_03 |  |
| ep3_npc_wookiee_forest_stalker | ep3_wke_forest_stalker_01, ep3_wke_forest_stalker_02, ep3_wke_forest_stalker_03 |  |
| ep3_npc_wookiee_freedom_fighters | ep3_wke_freedom_fighter_01, ep3_wke_freedom_fighter_02, ep3_wke_freedom_fighter_03, ep3_wke_freedom_fighter_04, ep3_wke_freedom_fighter_05 |  |
| ep3_pug_jumper | ep3_pug_jumper |  |
| ep3_qst_anguished_wookiee | ep3_anguished_wookiee_01, ep3_anguished_wookiee_02, ep3_anguished_wookiee_03, ep3_anguished_wookiee_04 |  |
| ep3_qst_forlorn_wookiee | ep3_forlorn_wookiee_01, ep3_forlorn_wookiee_02, ep3_forlorn_wookiee_03, ep3_forlorn_wookiee_04 |  |
| ep3_qst_mad_wookiee | ep3_mad_wookiee_01, ep3_mad_wookiee_02, ep3_mad_wookiee_03, ep3_mad_wookiee_04 |  |
| ep3_qst_wookiee_civilians | ep3_wke_civilian_01, ep3_wke_civilian_02, ep3_wke_civilian_03, ep3_wke_civilian_04, ep3_wke_civilian_05, ep3_wke_civilian_06 |  |
| ep3_qst_wookiee_guard | ep3_village_guard_01, ep3_village_guard_02, ep3_village_guard_03, ep3_village_guard_04, ep3_village_guard_05 |  |
| ep3_qst_wrhisch | ep3_wrhisch |  |
| ep3_roroo | ep3_roroo |  |
| ep3_sathog | ep3_sathog |  |
| ep3_slaver_blackscale_guard | ep3_blackscale_guard_m_01, ep3_blackscale_guard_m_02, ep3_blackscale_guard_m_03, ep3_blackscale_guard_m_04 |  |
| ep3_trandoshan_slavermaster | ep3_trando_slavemaster_01, ep3_trando_slavemaster_02 |  |

## Controller inventory

| Buildout row | Object ID | Type | X / height / Y | Radius | Count | Respawn seconds | Behaviour |
|---|---|---|---|---|---|---|---|
| 12 | -495811179 | clone_droid | -498.75 / 179.512 / -113.11999999999989 | 0.0 | 1 | 1.0–2.0 | 1 |
| 16 | -7030000 | kashyyyk/kash_kachirho_guard_wookiee | 218.15999999999985 / 28.2279 / -124.26999999999998 | 1.0 | 1 | 120.0–240.0 | 1 |
| 17 | -7029999 | kashyyyk/kash_kachirho_guard_wookiee | 204.55000000000018 / 29.4018 / -137.7199999999998 | 1.0 | 1 | 120.0–240.0 | 1 |
| 18 | -7029998 | kashyyyk/kash_kachirho_guard_wookiee | 213.47999999999956 / 38.6555 / -151.19000000000005 | 1.0 | 1 | 120.0–240.0 | 1 |
| 19 | -7029997 | kashyyyk/kash_kachirho_guard_wookiee | 245.6300000000001 / 31.8215 / -142.8499999999999 | 1.0 | 1 | 120.0–240.0 | 1 |
| 20 | -7029996 | kashyyyk/kash_kachirho_guard_wookiee | 218.05000000000018 / 33.5537 / -162.80999999999995 | 1.0 | 1 | 120.0–240.0 | 1 |
| 21 | -7029995 | kashyyyk/kash_kachirho_civilian_wookiee | 284.1700000000001 / 32.5426 / -151.53999999999996 | 1.0 | 1 | 120.0–240.0 | 1 |
| 22 | -7029994 | kashyyyk/kash_kachirho_civilian_wookiee | 316.35000000000036 / 33.1985 / -194.82000000000016 | 1.0 | 1 | 120.0–240.0 | 1 |
| 23 | -7029993 | kashyyyk/kash_kachirho_civilian_wookiee | 337.52999999999975 / 32.4559 / -223.55000000000018 | 1.0 | 1 | 120.0–240.0 | 1 |
| 24 | -7029992 | kashyyyk/kash_kachirho_civilian_wookiee | 304.39999999999964 / 32.8897 / -207.80999999999995 | 1.0 | 1 | 120.0–240.0 | 1 |
| 25 | -7029991 | kashyyyk/kash_kachirho_civilian_wookiee | 274.53999999999996 / 32.9594 / -193.69999999999982 | 1.0 | 1 | 120.0–240.0 | 1 |
| 26 | -7029990 | kashyyyk/kash_kachirho_civilian_wookiee | 248.75 / 33.1894 / -180.59000000000015 | 1.0 | 1 | 120.0–240.0 | 1 |
| 27 | -7029989 | kashyyyk/kash_kachirho_guard_trando | 206.64999999999964 / 23.1169 / 95.59000000000015 | 1.0 | 1 | 120.0–240.0 | 1 |
| 28 | -7029988 | kashyyyk/kash_kachirho_guard_trando | 211.21000000000004 / 23.1307 / 106.14000000000033 | 1.0 | 1 | 120.0–240.0 | 1 |
| 29 | -7029987 | kashyyyk/kash_kachirho_guard_trando | 104.61999999999989 / 23.4609 / 148.14999999999964 | 1.0 | 1 | 120.0–240.0 | 1 |
| 30 | -7029986 | kashyyyk/kash_kachirho_guard_trando | 134.25 / 22.3333 / 188.02000000000044 | 1.0 | 1 | 120.0–240.0 | 1 |
| 31 | -7029985 | kashyyyk/kash_kachirho_guard_trando | 478.1199999999999 / 18.8811 / 238.07999999999993 | 1.0 | 1 | 120.0–240.0 | 1 |
| 32 | -7029984 | kashyyyk/kash_kachirho_guard_trando | 476.46000000000004 / 19.0897 / 252.97000000000025 | 1.0 | 1 | 120.0–240.0 | 1 |
| 33 | -7029983 | kashyyyk/kash_kachirho_guard_trando | 524.3599999999997 / 24.7059 / 242.42000000000007 | 1.0 | 1 | 120.0–240.0 | 1 |
| 34 | -7029982 | kashyyyk/kash_kachirho_guard_trando | 522.5900000000001 / 24.7059 / 256.1700000000001 | 1.0 | 1 | 120.0–240.0 | 1 |
| 35 | -7029981 | kashyyyk/kash_kachirho_guard_trando | 489.0600000000004 / 27.0588 / 276.8199999999997 | 1.0 | 1 | 120.0–240.0 | 1 |
| 36 | -7029980 | kashyyyk/kash_kachirho_guard_trando | 524.3199999999997 / 24.9658 / 359.28999999999996 | 1.0 | 1 | 120.0–240.0 | 1 |
| 37 | -7029979 | kashyyyk/kash_kachirho_guard_trando | 530.7200000000003 / 25.1872 / 360.5699999999997 | 1.0 | 1 | 120.0–240.0 | 1 |
| 38 | -7029978 | kashyyyk/kash_blackscale_guard | 431.6300000000001 / 18.8235 / 826.6899999999996 | 1.0 | 1 | 120.0–240.0 | 1 |
| 39 | -7029977 | kashyyyk/kash_blackscale_guard | 412.0600000000004 / 18.8235 / 827.4200000000001 | 1.0 | 1 | 120.0–240.0 | 1 |
| 40 | -7029976 | kashyyyk/kash_blackscale_guard | 427.09000000000015 / 18.8235 / 968.9099999999999 | 1.0 | 1 | 120.0–240.0 | 1 |
| 41 | -7029975 | kashyyyk/kash_blackscale_guard | 403.1700000000001 / 18.8235 / 969.71 | 1.0 | 1 | 120.0–240.0 | 1 |
| 42 | -7029974 | kashyyyk/kash_blackscale_guard | 429.52999999999975 / 19.0877 / 905.6800000000003 | 1.0 | 1 | 120.0–240.0 | 1 |
| 43 | -7029973 | kashyyyk/kash_blackscale_guard | 415.4200000000001 / 18.9838 / 892.3699999999999 | 1.0 | 1 | 120.0–240.0 | 1 |
| 44 | -7029972 | kashyyyk/kash_blackscale_guard | 403.52000000000044 / 18.8235 / 955.0799999999999 | 1.0 | 1 | 120.0–240.0 | 1 |
| 45 | -7029971 | kashyyyk/kash_blackscale_guard | 424.75 / 18.8235 / 955.3900000000003 | 1.0 | 1 | 120.0–240.0 | 1 |
| 46 | -7029970 | kashyyyk/kash_blackscale_guard | 427.8900000000003 / 19.8222 / 768.4499999999998 | 1.0 | 1 | 120.0–240.0 | 1 |
| 47 | -7029969 | kashyyyk/kash_blackscale_guard | 406.9300000000003 / 19.694 / 775.5900000000001 | 1.0 | 1 | 120.0–240.0 | 1 |
| 48 | -7029968 | kashyyyk/kash_kachirho_guard_trando | 196.59000000000015 / 22.8271 / 98.6899999999996 | 0.0 | 1 | 120.0–240.0 | 1 |
| 49 | -7029967 | kashyyyk/kash_kachirho_varactyl | 660.3999999999996 / 19.5793 / -304.6999999999998 | 25.0 | 2 | 120.0–240.0 | 2 |
| 50 | -7029966 | kashyyyk/kash_kachirho_canopy_bandits | -402.1500000000001 / 20.9262 / 668.0100000000002 | 9.0 | 3 | 120.0–240.0 | 2 |
| 51 | -7029965 | kashyyyk/kash_kachirho_canopy_boss | -405.3299999999999 / 21.5355 / 667.7600000000002 | 0.0 | 1 | 120.0–240.0 | 1 |
| 52 | -7029964 | kashyyyk/kash_kachirho_wke_ceremonial_guard | -74.38000000000011 / 19.8838 / 778.3100000000004 | 0.0 | 1 | 120.0–240.0 | 1 |
| 53 | -7029963 | kashyyyk/kash_kachirho_wke_ceremonial_guard | -84.36999999999989 / 20.0253 / 784.75 | 0.0 | 1 | 120.0–240.0 | 1 |
| 54 | -7029962 | kashyyyk/kash_kachirho_wke_ceremonial_guard | -69.82000000000016 / 19.6385 / 835.4300000000003 | 0.0 | 1 | 120.0–240.0 | 1 |
| 55 | -7029961 | kashyyyk/kash_kachirho_wke_ceremonial_guard | -54.9699999999998 / 19.7974 / 830.3900000000003 | 0.0 | 1 | 120.0–240.0 | 1 |
| 56 | -7029960 | kashyyyk/kash_kachirho_wke_ceremonial_captain | -54.40000000000009 / 22.4933 / 839.3299999999999 | 0.0 | 1 | 120.0–240.0 | 1 |
| 57 | -7029959 | kashyyyk/kash_kachirho_wke_dead_guard | -738.44 / 18.8235 / 247.19999999999982 | 0.0 | 1 | 120.0–240.0 | 1 |
| 58 | -7029958 | kashyyyk/kash_kachirho_wke_dead_guard | -755.0100000000002 / 19.2435 / 263.4499999999998 | 0.0 | 1 | 120.0–240.0 | 1 |
| 59 | -7029957 | kashyyyk/kash_kachirho_wke_dead_guard | -757.5 / 19.2156 / 232.23999999999978 | 0.0 | 1 | 120.0–240.0 | 1 |
| 60 | -7029956 | kashyyyk/kash_kachirho_wke_dead_guard | -773.3600000000001 / 19.4482 / 249.44999999999982 | 0.0 | 1 | 120.0–240.0 | 1 |
| 61 | -7029955 | kashyyyk/kash_kachirho_wke_dead_guard | -799.31 / 19.287 / 182.21000000000004 | 0.0 | 1 | 120.0–240.0 | 1 |
| 62 | -7029954 | kashyyyk/kash_kachirho_wke_dead_guard | -815.6500000000001 / 19.2656 / 188.84000000000015 | 0.0 | 1 | 120.0–240.0 | 1 |
| 63 | -7029953 | kashyyyk/kash_kachirho_wke_commando | -562.06 / 7.45098 / 142.10999999999967 | 8.0 | 3 | 120.0–240.0 | 2 |
| 64 | -7029952 | kashyyyk/kash_kachirho_wke_fighters | -558.8499999999999 / 7.45098 / 162.71000000000004 | 8.0 | 3 | 120.0–240.0 | 2 |
| 65 | -7029951 | kashyyyk/kash_kachirho_wke_fighters | -540.9099999999999 / 7.45098 / 146.9399999999996 | 8.0 | 3 | 120.0–240.0 | 2 |
| 66 | -7029950 | kashyyyk/kash_kachirho_wke_fighters | -551.06 / 7.43179 / 178.6199999999999 | 0.0 | 1 | 120.0–240.0 | 1 |
| 67 | -7029949 | kashyyyk/kash_kachirho_wke_fighters | -523.9000000000001 / 7.45098 / 149.8699999999999 | 0.0 | 1 | 120.0–240.0 | 1 |
| 68 | -7029948 | kashyyyk/kash_kachirho_wke_fighters | -479.46000000000004 / 7.45098 / 151.64999999999964 | 8.0 | 3 | 120.0–240.0 | 2 |
| 69 | -7029947 | kashyyyk/kash_kachirho_wke_fighters | -493.90999999999985 / 7.45098 / 230.71000000000004 | 5.0 | 3 | 120.0–240.0 | 2 |
| 70 | -7029946 | kashyyyk/kash_kachirho_wke_commando | -466.1999999999998 / 7.45098 / 281.1899999999996 | 10.0 | 4 | 120.0–240.0 | 2 |
| 71 | -7029945 | kashyyyk/kash_kachirho_wke_commando | -516.8499999999999 / 13.5426 / 276.8299999999999 | 10.0 | 4 | 120.0–240.0 | 2 |
| 72 | -7029944 | kashyyyk/kash_kachirho_wke_fighters | -438.28999999999996 / 8.83124 / 386.75 | 10.0 | 4 | 120.0–240.0 | 2 |
| 73 | -7029943 | kashyyyk/kash_kachirho_wke_commando | 29.13000000000011 / 5.46985 / -1.5300000000002 | 8.0 | 3 | 120.0–240.0 | 2 |
| 74 | -7029942 | kashyyyk/kash_kachirho_wke_commando | -89.51999999999998 / 18.8235 / 268.15999999999985 | 5.0 | 3 | 120.0–240.0 | 2 |
| 75 | -7029941 | kashyyyk/etyyy_chiss_poacher | 518.8199999999997 / 18.9448 / 657.3400000000001 | 0.0 | 1 | 120.0–240.0 | 1 |
| 76 | -7029940 | kashyyyk/kash_kachirho_wke_stalkers | 792.9200000000001 / 18.9722 / 434.3299999999999 | 0.0 | 1 | 120.0–240.0 | 1 |
| 77 | -7029939 | kashyyyk/kash_kachirho_wke_stalkers | 806.46 / 18.6057 / 452.6199999999999 | 0.0 | 1 | 120.0–240.0 | 1 |
| 78 | -7029938 | kashyyyk/kash_kachirho_wke_stalkers | 808.6899999999996 / 5.44411 / 391.5100000000002 | 10.0 | 3 | 120.0–240.0 | 2 |
| 79 | -7029937 | kashyyyk/kash_kachirho_wke_stalkers | 797.8999999999996 / 6.27424 / 309.46000000000004 | 10.0 | 3 | 120.0–240.0 | 2 |
| 80 | -7029936 | kashyyyk/kash_kachirho_wke_stalkers | 772.9200000000001 / 6.80103 / 289.90999999999985 | 5.0 | 4 | 120.0–240.0 | 2 |
| 81 | -7029935 | kashyyyk/kash_kachirho_uller_hard | 738.5900000000001 / 5.38682 / 313.1899999999996 | 15.0 | 2 | 120.0–240.0 | 2 |
| 82 | -7029934 | kashyyyk/kash_kachirho_varactyl_hard | 701.6099999999997 / 18.8235 / -192.71000000000004 | 20.0 | 3 | 120.0–240.0 | 2 |
| 83 | -7029933 | kashyyyk/kash_kachirho_varactyl_hard | 699.3999999999996 / 8.62745 / 83.11999999999989 | 20.0 | 3 | 120.0–240.0 | 2 |
| 84 | -7029932 | kashyyyk/kash_kachirho_varactyl_hard | 525.0799999999999 / 6.9296 / -54.07999999999993 | 20.0 | 3 | 120.0–240.0 | 2 |
| 85 | -7029931 | kashyyyk/kash_kachirho_wke_stalkers | 443.52000000000044 / 7.50801 / -81.13000000000011 | 10.0 | 4 | 120.0–240.0 | 2 |
| 86 | -7029930 | kashyyyk/kash_kachirho_varactyl_hard | 513.96 / 8.41017 / 36.3100000000004 | 20.0 | 3 | 120.0–240.0 | 2 |
| 87 | -7029929 | kashyyyk/kash_kachirho_varactyl_hard | 611.6099999999997 / 8.66567 / 76.48999999999978 | 20.0 | 4 | 120.0–240.0 | 2 |
| 88 | -7029928 | kashyyyk/kash_kachirho_uller_hard | 656.6800000000003 / 7.0188 / 161.52999999999975 | 20.0 | 3 | 120.0–240.0 | 2 |
| 89 | -7029927 | kashyyyk/kash_kachirho_uller_hard | 757.6899999999996 / 8.62745 / 128.4399999999996 | 20.0 | 3 | 120.0–240.0 | 2 |
| 90 | -7029926 | kashyyyk/kash_kachirho_varactyl_hard | 819.1099999999997 / 8.62745 / 170.97000000000025 | 0.0 | 1 | 120.0–240.0 | 1 |
| 91 | -7029925 | kashyyyk/kash_kachirho_varactyl_hard | 811.96 / 8.67698 / 109.52999999999975 | 0.0 | 1 | 120.0–240.0 | 1 |
| 92 | -7029924 | kashyyyk/kash_kachirho_varactyl_hard | 927.1700000000001 / 8.62745 / 222.59000000000015 | 0.0 | 1 | 120.0–240.0 | 1 |
| 93 | -7029923 | kashyyyk/kash_kachirho_varactyl_hard | 893.9499999999998 / 8.78512 / 232.77999999999975 | 0.0 | 1 | 120.0–240.0 | 1 |
| 94 | -7029922 | kashyyyk/kash_kachirho_varactyl_hard | 900.4099999999999 / 8.74214 / 135.39999999999964 | 0.0 | 1 | 120.0–240.0 | 1 |
| 95 | -7029921 | kashyyyk/kash_kachirho_varactyl_hard | 882.4499999999998 / 8.62745 / 173.89000000000033 | 0.0 | 1 | 120.0–240.0 | 1 |
| 96 | -7029920 | kashyyyk/kash_kachirho_canopy_bandits | -172.07999999999993 / 20.0579 / 483.3299999999999 | 15.0 | 4 | 120.0–240.0 | 2 |
| 97 | -7029919 | kashyyyk/ep3_qst_wke_wrhisch | 186.47999999999956 / 19.68 / 578.04 | 0.0 | 1 | 120.0–240.0 | 1 |
| 98 | -7029918 | kashyyyk/ep3_qst_forlorn_wookiee | 197.3699999999999 / 23.6485 / 631.1199999999999 | 10.0 | 3 | 120.0–240.0 | 2 |
| 99 | -7029917 | kashyyyk/ep3_qst_forlorn_wookiee | 97.73999999999978 / 21.0979 / 533.6099999999997 | 10.0 | 3 | 120.0–240.0 | 2 |
| 100 | -7029916 | kashyyyk/ep3_qst_forlorn_wookiee | 233.0600000000004 / 20.9213 / 502.75 | 10.0 | 3 | 120.0–240.0 | 2 |
| 101 | -7029915 | kashyyyk/ep3_qst_mad_wookiee | 191.39999999999964 / 21.5923 / 597.0 | 5.0 | 2 | 120.0–240.0 | 2 |
| 102 | -7029914 | kashyyyk/ep3_qst_mad_wookiee | 140.10000000000036 / 22.2042 / 585.7700000000004 | 5.0 | 2 | 120.0–240.0 | 2 |
| 103 | -7029913 | kashyyyk/ep3_qst_mad_wookiee | 202.46000000000004 / 19.6078 / 549.3599999999997 | 5.0 | 2 | 120.0–240.0 | 2 |
| 104 | -7029912 | kashyyyk/ep3_qst_anguished_wookiee | 162.4399999999996 / 19.6092 / 494.1899999999996 | 5.0 | 2 | 120.0–240.0 | 2 |
| 105 | -7029911 | kashyyyk/ep3_qst_anguished_wookiee | 148.85999999999967 / 19.6078 / 539.1300000000001 | 5.0 | 2 | 120.0–240.0 | 2 |
| 106 | -7029910 | kashyyyk/kash_kachirho_jaggedfang | 916.1300000000001 / 8.62745 / 240.77999999999975 | 0.0 | 1 | 3600.0–4000.0 | 1 |
| 107 | -7029909 | kashyyyk/kash_kachirho_wke_bloodsample | 112.03999999999996 / 21.7167 / 162.4399999999996 | 0.0 | 1 | 120.0–240.0 | 1 |
| 108 | -7029908 | kashyyyk/kash_kachirho_wke_bloodsample | 137.9300000000003 / 22.3529 / 214.26000000000022 | 0.0 | 1 | 120.0–240.0 | 1 |
| 109 | -7029907 | kashyyyk/kash_kachirho_wke_bloodsample | 149.85999999999967 / 19.2951 / 118.22000000000025 | 0.0 | 1 | 120.0–240.0 | 1 |
| 110 | -7029906 | kashyyyk/kash_kachirho_wke_bloodsample | 542.0 / 24.7059 / 398.5 | 0.0 | 1 | 120.0–240.0 | 1 |
| 111 | -7029905 | kashyyyk/kash_kachirho_wke_bloodsample | 516.5699999999997 / 24.7389 / 438.21000000000004 | 0.0 | 1 | 120.0–240.0 | 1 |
| 112 | -7029904 | kashyyyk/kash_kachirho_wke_healthy | 324.5799999999999 / 29.3246 / -166.94000000000005 | 0.0 | 1 | 120.0–240.0 | 1 |
| 113 | -7029903 | kashyyyk/kash_kachirho_guard_trando | 167.32999999999993 / 19.7907 / 147.5600000000004 | 8.0 | 3 | 120.0–240.0 | 2 |
| 114 | -7029902 | kashyyyk/kash_kachirho_wke_bloodsample | 147.09000000000015 / 19.5515 / 118.90999999999985 | 0.0 | 1 | 120.0–240.0 | 1 |
| 115 | -7029901 | kashyyyk/kash_kachirho_wke_bloodsample | 144.52000000000044 / 19.6138 / 120.46000000000004 | 0.0 | 1 | 120.0–240.0 | 1 |
| 116 | -7029900 | kashyyyk/kash_kachirho_wke_bloodsample | 141.8800000000001 / 19.2919 / 123.27999999999975 | 0.0 | 1 | 120.0–240.0 | 1 |
| 117 | -7029899 | kashyyyk/kash_kachirho_wke_bloodsample | 139.77999999999975 / 19.2424 / 126.25 | 0.0 | 1 | 120.0–240.0 | 1 |
| 118 | -7029898 | kashyyyk/kash_kachirho_guard_trando | 157.14000000000033 / 19.0426 / 120.60000000000036 | 0.0 | 1 | 120.0–240.0 | 1 |
| 119 | -7029897 | kashyyyk/kash_kachirho_guard_trando | 138.47999999999956 / 19.0177 / 134.02999999999975 | 0.0 | 1 | 120.0–240.0 | 1 |
| 120 | -7029896 | kashyyyk/kash_kachirho_guard_trando | 112.57999999999993 / 21.8848 / 159.3699999999999 | 0.0 | 1 | 120.0–240.0 | 1 |
| 121 | -7029895 | kashyyyk/kash_kachirho_wke_bloodsample | 337.6400000000003 / 19.6485 / 118.23999999999978 | 5.0 | 4 | 120.0–240.0 | 1 |
| 122 | -7029894 | kashyyyk/ep3_clone_relics_trandoshan_researchers | 560.5900000000001 / 24.7059 / 267.4200000000001 | 8.0 | 3 | 120.0–240.0 | 2 |
| 123 | -7029893 | kashyyyk/kash_kachirho_guard_trando | 544.1000000000004 / 24.7059 / 311.3800000000001 | 8.0 | 3 | 120.0–240.0 | 1 |
| 124 | -7029892 | kashyyyk/ep3_clone_relics_trandoshan_researchers | 494.6199999999999 / 27.0588 / 286.9300000000003 | 4.0 | 2 | 120.0–240.0 | 1 |
| 125 | -7029891 | kashyyyk/ep3_clone_relics_trandoshan_researchers | 565.9499999999998 / 30.5648 / 467.4200000000001 | 5.0 | 4 | 120.0–240.0 | 2 |
| 126 | -7029890 | kashyyyk/kash_kachirho_civilian_chiss | 586.6999999999998 / 24.7059 / 720.5299999999997 | 4.0 | 3 | 120.0–240.0 | 2 |
| 127 | -7029889 | kashyyyk/kash_kachirho_civilian_chiss | 578.0799999999999 / 24.7059 / 744.9200000000001 | 4.0 | 3 | 120.0–240.0 | 2 |
| 128 | -7029888 | kashyyyk/kash_kachirho_civilian_chiss | 610.3500000000004 / 24.7059 / 754.8599999999997 | 3.0 | 2 | 120.0–240.0 | 2 |
| 129 | -7029887 | kashyyyk/kash_kachirho_uller | 695.6899999999996 / 18.8235 / 834.9300000000003 | 15.0 | 3 | 120.0–240.0 | 2 |
| 130 | -7029886 | kashyyyk/kash_kachirho_uller | 791.6000000000004 / 18.8235 / 821.4700000000003 | 15.0 | 2 | 120.0–240.0 | 2 |
| 131 | -7029885 | kashyyyk/kash_kachirho_uller | 824.6400000000003 / 18.8235 / 780.3100000000004 | 15.0 | 3 | 120.0–240.0 | 2 |
| 132 | -7029884 | kashyyyk/kash_kachirho_uller | 764.5600000000004 / 18.8235 / 554.96 | 15.0 | 3 | 120.0–240.0 | 2 |
| 133 | -7029883 | kashyyyk/kash_kachirho_varactyl | 762.3699999999999 / 23.9216 / -337.7600000000002 | 15.0 | 3 | 120.0–240.0 | 2 |
| 134 | -7029882 | kashyyyk/kash_kachirho_varactyl | 786.6499999999996 / 23.9216 / -451.82000000000016 | 20.0 | 4 | 120.0–240.0 | 2 |
| 135 | -7029881 | kashyyyk/kash_kachirho_bantha | 759.0900000000001 / 23.9216 / -510.75 | 15.0 | 3 | 120.0–240.0 | 2 |
| 136 | -7029880 | kashyyyk/kash_kachirho_bantha | 735.4399999999996 / 23.9216 / -609.5700000000002 | 15.0 | 3 | 120.0–240.0 | 2 |
| 137 | -7029879 | kashyyyk/kash_kachirho_varactyl | 663.8000000000002 / 23.9216 / -620.9099999999999 | 20.0 | 3 | 120.0–240.0 | 2 |
| 138 | -7029878 | kashyyyk/kash_kachirho_varactyl | 531.3500000000004 / 21.5212 / -522.8899999999999 | 20.0 | 3 | 120.0–240.0 | 2 |
| 139 | -7029877 | kashyyyk/kash_kachirho_varactyl | 591.71 / 23.5623 / -440.4499999999998 | 20.0 | 3 | 120.0–240.0 | 2 |
| 140 | -7029876 | kashyyyk/kash_kachirho_bantha | 275.9200000000001 / 32.6014 / -286.03999999999996 | 15.0 | 2 | 120.0–240.0 | 2 |
| 141 | -7029875 | kashyyyk/kash_kachirho_bantha | -160.05000000000018 / 19.2157 / -82.88999999999987 | 15.0 | 3 | 120.0–240.0 | 2 |
| 142 | -7029874 | kashyyyk/kash_kachirho_bantha | -322.8899999999999 / 21.0247 / -175.92999999999984 | 15.0 | 2 | 120.0–240.0 | 2 |
| 143 | -7029873 | kashyyyk/kash_kachirho_canopy_bandits | -252.19000000000005 / 5.59239 / 21.800000000000182 | 8.0 | 4 | 120.0–240.0 | 2 |
| 144 | -7029872 | kashyyyk/kash_kachirho_bolotaur | -385.42999999999984 / 6.30622 / 464.6300000000001 | 20.0 | 3 | 120.0–240.0 | 2 |
| 145 | -7029871 | kashyyyk/kash_kachirho_bolotaur_hard | -275.32000000000016 / 6.27451 / 713.8800000000001 | 20.0 | 3 | 120.0–240.0 | 2 |
| 146 | -7029870 | kashyyyk/kash_kachirho_canopy_bandits | -411.42999999999984 / 18.8326 / 537.0200000000004 | 5.0 | 3 | 120.0–240.0 | 2 |
| 147 | -7029869 | kashyyyk/kash_kachirho_canopy_bandits | -395.6999999999998 / 19.294 / 578.6800000000003 | 5.0 | 3 | 120.0–240.0 | 2 |
| 148 | -7029868 | kashyyyk/kash_kachirho_canopy_bandits | -390.3600000000001 / 19.199 / 640.3299999999999 | 5.0 | 3 | 120.0–240.0 | 2 |
| 149 | -7029867 | kashyyyk/kash_kachirho_canopy_bandits | -379.1100000000001 / 18.8235 / 700.1599999999999 | 6.0 | 3 | 120.0–240.0 | 2 |
| 150 | -7029866 | kashyyyk/kash_kachirho_canopy_bandits | -384.7399999999998 / 19.5722 / 762.2200000000003 | 6.0 | 3 | 120.0–240.0 | 2 |
| 151 | -7029865 | kashyyyk/kash_kachirho_wke_commando | -168.1199999999999 / 5.9183 / 55.350000000000364 | 6.0 | 3 | 120.0–240.0 | 2 |
| 152 | -7029864 | kashyyyk/kash_kachiro_sieged_trandos | -119.80999999999995 / 18.8536 / 108.97999999999956 | 4.0 | 2 | 120.0–240.0 | 1 |
| 153 | -7029863 | kashyyyk/kash_kachiro_sieged_trandos | -110.40000000000009 / 18.8768 / 89.27000000000044 | 0.0 | 1 | 120.0–240.0 | 1 |
| 154 | -7029862 | kashyyyk/kash_kachiro_sieged_trandos | -88.65000000000009 / 18.8235 / 115.55000000000018 | 2.0 | 1 | 120.0–240.0 | 1 |
| 155 | -7029861 | kashyyyk/kash_kachiro_sieged_trandos | -70.98999999999978 / 19.2157 / 84.11999999999989 | 0.0 | 1 | 120.0–240.0 | 1 |
| 157 | -7029859 | kashyyyk/kashyyyk_roroo | -479.90999999999985 / 18.8233 / -88.0 | 5.0 | 3 | 240.0–400.0 | 2 |
| 158 | -7029858 | kashyyyk/kashyyyk_roroo | -557.0799999999999 / 19.0275 / -170.92000000000007 | 5.0 | 3 | 240.0–400.0 | 2 |
| 159 | -7029857 | kashyyyk/kashyyyk_roroo | -312.73 / 19.1466 / -162.57000000000016 | 5.0 | 3 | 240.0–400.0 | 2 |
| 160 | -7029856 | kashyyyk/kashyyyk_roroo | -148.3800000000001 / 19.2157 / -94.15000000000009 | 5.0 | 4 | 240.0–400.0 | 2 |
| 161 | -7029855 | kashyyyk/kashyyyk_kklyyytt | -202.94999999999982 / 19.2157 / -104.11000000000013 | 5.0 | 4 | 240.0–400.0 | 2 |
| 162 | -7029854 | kashyyyk/kashyyyk_kklyyytt | -92.44999999999982 / 19.3764 / -173.17999999999984 | 5.0 | 3 | 120.0–400.0 | 2 |
| 163 | -7029853 | kashyyyk/kashyyyk_jyykle_vulture | -45.179999999999836 / 19.7113 / -200.48999999999978 | 5.0 | 3 | 200.0–400.0 | 2 |
| 164 | -7029852 | kashyyyk/kashyyyk_roroo | -3.2800000000002 / 18.957 / -147.78999999999996 | 8.0 | 4 | 20.0–400.0 | 2 |
| 165 | -7029851 | kashyyyk/kashyyyk_jyykle_vulture | 88.78999999999996 / 18.9293 / -151.38999999999987 | 5.0 | 3 | 200.0–400.0 | 2 |
| 166 | -7029850 | kashyyyk/kashyyyk_kklyyytt | 101.97000000000025 / 18.8237 / -134.88999999999987 | 5.0 | 3 | 240.0–400.0 | 2 |
| 180 | -7029836 | kashyyyk/kashyyyk_roroo | 211.90999999999985 / 11.2257 / -86.51000000000022 | 5.0 | 3 | 240.0–400.0 | 2 |
| 220 | -7029796 | kashyyyk/kashyyyk_roroo | 284.8100000000004 / 19.5754 / 92.90999999999985 | 10.0 | 4 | 240.0–400.0 | 2 |
| 221 | -7029795 | kashyyyk/kashyyyk_roroo | 254.82999999999993 / 18.6001 / 33.470000000000255 | 10.0 | 3 | 240.0–400.0 | 2 |
| 222 | -7029794 | kashyyyk/kashyyyk_sathog | 336.2399999999998 / 19.2157 / 323.47999999999956 | 5.0 | 3 | 240.0–400.0 | 2 |
| 229 | -7029787 | kashyyyk/kashyyyk_roroo | 404.6099999999997 / 18.7969 / 499.6899999999996 | 6.0 | 3 | 240.0–400.0 | 2 |
| 230 | -7029786 | kashyyyk/kashyyyk_sathog | 417.3900000000003 / 20.0 / 603.25 | 3.0 | 3 | 240.0–400.0 | 2 |
| 236 | -7029780 | kashyyyk/kashyyyk_jyykle_vulture | 673.6499999999996 / 18.8235 / 808.25 | 6.0 | 3 | 240.0–400.0 | 2 |
| 237 | -7029779 | kashyyyk/kashyyyk_jyykle_vulture | 763.9099999999999 / 18.8235 / 786.5299999999997 | 6.0 | 2 | 240.0–400.0 | 2 |
| 238 | -7029778 | kashyyyk/kashyyyk_jyykle_vulture | 830.3699999999999 / 18.8235 / 716.8199999999997 | 6.0 | 3 | 240.0–400.0 | 2 |
| 239 | -7029777 | kashyyyk/kashyyyk_kklyyytt | 825.8800000000001 / 23.6535 / 643.8699999999999 | 7.0 | 3 | 240.0–400.0 | 2 |
| 251 | -7029765 | kashyyyk/kashyyyk_pug_jumper | 890.2399999999998 / 4.23496 / 491.3800000000001 | 5.0 | 3 | 240.0–400.0 | 2 |
| 252 | -7029764 | kashyyyk/kashyyyk_pug_jumper | 864.1099999999997 / 4.17069 / 444.85000000000036 | 3.0 | 4 | 240.0–400.0 | 2 |
| 253 | -7029763 | kashyyyk/kashyyyk_pug_jumper | 782.4300000000003 / 5.4902 / 344.4200000000001 | 5.0 | 3 | 240.0–400.0 | 2 |
| 254 | -7029762 | kashyyyk/kashyyyk_pug_jumper | 704.3100000000004 / 5.43481 / 263.0500000000002 | 5.0 | 3 | 240.0–400.0 | 2 |
| 255 | -7029761 | kashyyyk/kashyyyk_pug_jumper | 631.1700000000001 / 5.57981 / 119.89000000000033 | 5.0 | 3 | 230.0–400.0 | 2 |
| 260 | -7029756 | kashyyyk/kash_kachirho_guard_wookiee | 633.9899999999998 / 20.0109 / -255.0300000000002 | 0.0 | 1 | 240.0–400.0 | 1 |
| 261 | -7029755 | kashyyyk/kash_kachirho_guard_wookiee | 633.6700000000001 / 20.1038 / -250.19000000000005 | 0.0 | 1 | 240.0–400.0 | 1 |
| 279 | -7029737 | kashyyyk/kashyyyk_roroo | 787.4200000000001 / 23.9216 / -401.19000000000005 | 5.0 | 4 | 240.0–400.0 | 2 |
| 280 | -7029736 | kashyyyk/kashyyyk_roroo | 712.2600000000002 / 23.9216 / -459.80999999999995 | 5.0 | 3 | 240.0–400.0 | 2 |
| 286 | -7029730 | kashyyyk/kashyyyk_roroo | 565.3199999999997 / 23.985 / -650.5999999999999 | 10.0 | 5 | 240.0–400.0 | 2 |
| 287 | -7029729 | kashyyyk/kashyyyk_kklyyytt | 589.5799999999999 / 24.5381 / -589.4099999999999 | 6.0 | 3 | 240.0–400.0 | 2 |
| 288 | -7029728 | kashyyyk/kash_kachirho_bantha | 444.7600000000002 / 24.2267 / -537.1799999999998 | 10.0 | 4 | 240.0–400.0 | 2 |
| 289 | -7029727 | kashyyyk/kash_kachirho_bantha | 503.96000000000004 / 23.9216 / -590.96 | 20.0 | 4 | 240.0–400.0 | 2 |
| 290 | -7029726 | kashyyyk/kashyyyk_kklyyytt | 549.1499999999996 / 20.5839 / -556.44 | 6.0 | 3 | 240.0–400.0 | 2 |
| 291 | -7029725 | kashyyyk/kashyyyk_kklyyytt | 573.3199999999997 / 21.2763 / -480.0100000000002 | 5.0 | 3 | 240.0–400.0 | 2 |
| 292 | -7029724 | kashyyyk/kashyyyk_roroo | 425.6999999999998 / 27.5319 / -477.8899999999999 | 5.0 | 3 | 240.0–400.0 | 2 |
| 300 | -7029716 | kashyyyk/kashyyyk_jyykle_vulture | 205.47999999999956 / 28.1305 / -373.9000000000001 | 6.0 | 3 | 240.0–400.0 | 2 |
| 301 | -7029715 | kashyyyk/kashyyyk_jyykle_vulture | 259.5500000000002 / 30.0661 / -428.4499999999998 | 5.0 | 3 | 240.0–400.0 | 2 |
| 302 | -7029714 | kashyyyk/kashyyyk_jyykle_vulture | 263.47000000000025 / 36.6523 / -296.2399999999998 | 5.0 | 3 | 240.0–400.0 | 2 |
| 303 | -7029713 | kashyyyk/kashyyyk_roroo | 198.73999999999978 / 26.1308 / -316.5300000000002 | 5.0 | 3 | 240.0–400.0 | 2 |
| 304 | -7029712 | kashyyyk/kashyyyk_jyykle_vulture | 221.73999999999978 / 33.9888 / -274.8299999999999 | 5.0 | 2 | 240.0–400.0 | 2 |
| 305 | -7029711 | kashyyyk/kashyyyk_kklyyytt | 19.890000000000327 / 20.6905 / -275.6700000000001 | 5.0 | 3 | 240.0–400.0 | 2 |
| 306 | -7029710 | kashyyyk/kashyyyk_roroo | 94.6899999999996 / 20.711 / -305.65999999999985 | 5.0 | 3 | 240.0–400.0 | 2 |
| 313 | -7029703 | kashyyyk/kashyyyk_pug_jumper | 293.65999999999985 / 7.5164 / -25.90000000000009 | 5.0 | 3 | 240.0–400.0 | 2 |
| 314 | -7029702 | kashyyyk/kashyyyk_pug_jumper | 334.0100000000002 / 5.31399 / -49.84999999999991 | 5.0 | 3 | 240.0–400.0 | 2 |
| 315 | -7029701 | kashyyyk/kashyyyk_pug_jumper | 376.8699999999999 / 7.01353 / -71.84000000000015 | 5.0 | 3 | 240.0–400.0 | 2 |
| 316 | -7029700 | kashyyyk/kash_kachirho_canopy_bandits | 402.6099999999997 / 19.4926 / -9.139999999999873 | 5.0 | 3 | 240.0–400.0 | 2 |
| 317 | -7029699 | kashyyyk/kashyyyk_pug_jumper | 437.7600000000002 / 5.14594 / -51.23000000000002 | 5.0 | 3 | 240.0–400.0 | 2 |
| 318 | -7029698 | kashyyyk/kashyyyk_pug_jumper | 146.23999999999978 / 6.13708 / -45.190000000000055 | 5.0 | 3 | 240.0–400.0 | 2 |
| 319 | -7029697 | kashyyyk/kashyyyk_sathog | 36.60999999999967 / 7.0459 / -46.789999999999964 | 5.0 | 3 | 240.0–400.0 | 2 |
| 320 | -7029696 | kashyyyk/kashyyyk_pug_jumper | -24.389999999999873 / 5.18701 / -5.210000000000036 | 10.0 | 5 | 240.0–400.0 | 2 |
| 321 | -7029695 | kashyyyk/kashyyyk_sathog | -81.19999999999982 / 5.88235 / -8.179999999999836 | 5.0 | 3 | 240.0–400.0 | 2 |
| 322 | -7029694 | kashyyyk/kashyyyk_pug_jumper | -158.05000000000018 / 6.27451 / 25.98999999999978 | 5.0 | 3 | 240.0–400.0 | 2 |
| 323 | -7029693 | kashyyyk/kashyyyk_roroo | -68.26999999999998 / 21.1765 / 404.2399999999998 | 5.0 | 3 | 240.0–400.0 | 2 |
| 324 | -7029692 | kashyyyk/kashyyyk_roroo | -52.73999999999978 / 21.1765 / 440.0600000000004 | 5.0 | 3 | 249.0–400.0 | 2 |
| 325 | -7029691 | kashyyyk/kashyyyk_sathog | 40.779999999999745 / 21.1765 / 493.64999999999964 | 4.0 | 2 | 240.0–400.0 | 2 |
| 326 | -7029690 | kashyyyk/kashyyyk_jyykle_vulture | 166.67000000000007 / 19.6078 / 535.4799999999996 | 5.0 | 3 | 240.0–400.0 | 2 |
| 327 | -7029689 | kashyyyk/kashyyyk_jyykle_vulture | 164.89000000000033 / 20.7843 / 590.6300000000001 | 5.0 | 3 | 240.0–400.0 | 2 |
| 328 | -7029688 | kashyyyk/kashyyyk_sathog | 157.85000000000036 / 7.12623 / 773.54 | 5.0 | 3 | 240.0–400.0 | 2 |
| 329 | -7029687 | kashyyyk/kashyyyk_jyykle_vulture | 119.18000000000029 / 10.5216 / 811.5200000000004 | 5.0 | 4 | 240.0–400.0 | 2 |
| 330 | -7029686 | kashyyyk/kashyyyk_roroo | 92.5600000000004 / 9.88161 / 769.9200000000001 | 5.0 | 3 | 240.0–400.0 | 2 |
| 331 | -7029685 | kashyyyk/kashyyyk_sathog | 236.10000000000036 / 19.7784 / 743.9099999999999 | 5.0 | 4 | 240.0–400.0 | 2 |
| 338 | -7029678 | kashyyyk/kashyyyk_roroo | 315.14999999999964 / 20.7922 / 710.1800000000003 | 5.0 | 3 | 240.0–400.0 | 2 |
| 339 | -7029677 | kashyyyk/kashyyyk_sathog | -34.75 / 19.5583 / 742.4799999999996 | 5.0 | 3 | 240.0–400.0 | 2 |
| 340 | -7029676 | kashyyyk/kashyyyk_roroo | -87.55999999999995 / 19.8744 / 757.6000000000004 | 5.0 | 4 | 249.0–400.0 | 2 |
| 341 | -7029675 | kashyyyk/kashyyyk_sathog | -28.679999999999836 / 28.1461 / 693.5 | 4.0 | 2 | 240.0–400.0 | 2 |
| 342 | -7029674 | kashyyyk/kashyyyk_jyykle_vulture | -98.51000000000022 / 21.5403 / 542.6099999999997 | 4.0 | 5 | 240.0–400.0 | 2 |
| 343 | -7029673 | kashyyyk/kashyyyk_roroo | -82.98999999999978 / 20.5222 / 602.3599999999997 | 5.0 | 3 | 240.0–400.0 | 2 |
| 348 | -7029668 | kashyyyk/kashyyyk_jyykle_vulture | -275.1100000000001 / 20.0 / 453.21000000000004 | 5.0 | 3 | 240.0–400.0 | 2 |
| 358 | -7029658 | kashyyyk/kashyyyk_jyykle_vulture | -265.27 / 6.34642 / 675.8900000000003 | 5.0 | 3 | 240.0–400.0 | 2 |
| 359 | -7029657 | kashyyyk/kashyyyk_jyykle_vulture | -321.71000000000004 / 6.27451 / 607.0799999999999 | 7.0 | 3 | 240.0–400.0 | 2 |
| 360 | -7029656 | kashyyyk/kash_kachirho_bolotaur | -308.07000000000016 / 6.27451 / 645.3000000000002 | 20.0 | 3 | 240.0–400.0 | 2 |
| 361 | -7029655 | kashyyyk/kashyyyk_pug_jumper | -186.6500000000001 / 4.91924 / 884.0 | 5.0 | 3 | 240.0–400.0 | 2 |
| 362 | -7029654 | kashyyyk/kashyyyk_pug_jumper | -223.0999999999999 / 4.44918 / 897.75 | 5.0 | 3 | 240.0–400.0 | 2 |
| 369 | -7029647 | kashyyyk/kashyyyk_jyykle_vulture | -365.59000000000015 / 15.3548 / 419.0799999999999 | 5.0 | 3 | 240.0–400.0 | 2 |
| 370 | -7029646 | kashyyyk/kashyyyk_jyykle_vulture | -348.0500000000002 / 18.2954 / 500.25 | 5.0 | 3 | 240.0–400.0 | 2 |
| 375 | -7029641 | kashyyyk/kashyyyk_pug_jumper | -472.0300000000002 / 8.03468 / 316.10000000000036 | 5.0 | 3 | 240.0–400.0 | 2 |
| 380 | -7029636 | kashyyyk/kashyyyk_pug_jumper | -346.6300000000001 / 5.89634 / 130.9399999999996 | 5.0 | 3 | 240.0–400.0 | 2 |
| 381 | -7029635 | kashyyyk/kashyyyk_pug_jumper | -281.9899999999998 / 4.65777 / 65.38000000000011 | 7.0 | 4 | 240.0–400.0 | 2 |
| 382 | -7029634 | kashyyyk/kashyyyk_pug_jumper | -581.5300000000002 / 6.27451 / 101.72000000000025 | 5.0 | 3 | 240.0–400.0 | 2 |
| 383 | -7029633 | kashyyyk/kashyyyk_sathog | -681.04 / 5.4902 / 91.73999999999978 | 5.0 | 3 | 240.0–400.0 | 2 |
| 384 | -7029632 | kashyyyk/kashyyyk_sathog | -646.9499999999998 / 5.50695 / 49.720000000000255 | 5.0 | 3 | 240.0–400.0 | 2 |
| 385 | -7029631 | kashyyyk/kashyyyk_pug_jumper | -701.1100000000001 / 5.4902 / -4.989999999999782 | 5.0 | 3 | 240.0–400.0 | 2 |
| 386 | -7029630 | kashyyyk/kashyyyk_pug_jumper | -859.8899999999999 / 5.54555 / -224.5 | 5.0 | 3 | 240.0–400.0 | 2 |
| 387 | -7029629 | kashyyyk/kashyyyk_roroo | -944.06 / 18.3775 / -121.61000000000013 | 10.0 | 5 | 240.0–400.0 | 2 |
| 388 | -7029628 | kashyyyk/kashyyyk_pug_jumper | -807.1799999999998 / 5.42136 / -52.23999999999978 | 5.0 | 3 | 240.0–400.0 | 2 |
| 389 | -7029627 | kashyyyk/kashyyyk_sathog | -810.5300000000002 / 5.50534 / 2.1700000000000728 | 5.0 | 3 | 240.0–400.0 | 2 |
| 390 | -7029626 | kashyyyk/ep3_clone_relics_trandoshan_researchers | 135.9399999999996 / 19.2157 / 171.1199999999999 | 24.0 | 8 | 18.0–23.0 | 2 |
| 1607 | -7028409 | kashyyyk/kash_kachirho_bantha_bull | 651.1499999999996 / 18.8235 / 668.4399999999996 | 20.0 | 3 | 120.0–240.0 | 2 |
| 1608 | -7028408 | kashyyyk/kash_kachirho_bantha_bull | 676.8999999999996 / 18.8235 / 771.6899999999996 | 20.0 | 3 | 120.0–240.0 | 2 |
| 1609 | -7028407 | kashyyyk/kash_kachirho_bantha_bull | 750.0900000000001 / 18.8235 / 749.8100000000004 | 20.0 | 3 | 120.0–240.0 | 2 |
| 1610 | -7028406 | kashyyyk/kash_kachirho_bantha_bull | 800.8800000000001 / 18.8235 / 702.1899999999996 | 20.0 | 3 | 120.0–240.0 | 2 |
| 1611 | -7028405 | kashyyyk/kash_kachirho_bantha_bull | 790.7399999999998 / 19.9303 / 621.1000000000004 | 20.0 | 3 | 120.0–240.0 | 2 |
| 1612 | -7028404 | kashyyyk/kash_kachirho_bantha_bull | 766.8999999999996 / 18.7323 / 490.4200000000001 | 20.0 | 3 | 120.0–240.0 | 2 |
| 1613 | -7028403 | kashyyyk/kash_kachirho_bantha_bull | 704.5200000000004 / 23.9216 / -399.7800000000002 | 20.0 | 3 | 120.0–240.0 | 2 |
| 1614 | -7028402 | kashyyyk/kash_kachirho_uller | 328.15999999999985 / 18.7607 / 451.72999999999956 | 20.0 | 3 | 120.0–240.0 | 2 |
| 1662 | -7028351 | kashyyyk/etyyy_clan_lesser | 582.1800000000003 / 23.9216 / -637.98 | 0.0 | 1 | 23.0–32.0 | 1 |
| 1663 | -7028350 | kashyyyk/etyyy_clan_lesser | 567.3100000000004 / 23.9216 / -643.5999999999999 | 0.0 | 1 | 23.0–32.0 | 1 |
| 1664 | -7028349 | kashyyyk/etyyy_clan_lesser | 587.3500000000004 / 23.9216 / -637.75 | 0.0 | 1 | 23.0–32.0 | 1 |

## Source hashes

- `kashyyyk_main.tab`: `abd72d12c9fe629e45e77e19c019470b3cf8b2c7c28eadfe914fc6d1485d79c4`
- `creatures.tab`: `2f0e8d82dc6ef4cb618decadb3b78c997737be4414b4cf1bcf5801bec2d3a268`
- `dressed_species_e.tab`: `6c5049c49966dadc2acffd0dd412f11a995ba1ee2ae0613005a26e8f0d01785f`
- `dressed_species_t.tab`: `c8f17b9f9fddca9700c87303ee2444e2c8a26bd66acb95c4355625ba7417ab44`
- `clone_droid.tab`: `9108af9f6dc35cdfec0e9e490c9a43ee2f67c9785aca5b2301b5e942e949b208`
- `ep3_clone_relics_trandoshan_researchers.tab`: `3af0b30ec11fc8b588aeba3145aa25f14aab4bf37b91a3b48a66fcc4123e7c24`
- `ep3_qst_anguished_wookiee.tab`: `7199c01a958286218ba85742adfc66c01f9bb51a853ff1941b330024d2e9077d`
- `ep3_qst_forlorn_wookiee.tab`: `e14c2a52284e78d663bf40f5d51440536fdcc41a5ac6a670b6b5d8b13671cb88`
- `ep3_qst_mad_wookiee.tab`: `0de07043400e4b4a17690e2b2b6d80077547f7e5625c4f7d950146cc892a5d19`
- `ep3_qst_wke_wrhisch.tab`: `7b55e06fe752efd296d6e2a7ec32be272587d9a7a6555249182824659c2e8381`
- `etyyy_chiss_poacher.tab`: `ef05816e0aa086838da574c960a8e09e0488c3892b0639089b80b9a5e0c0932a`
- `etyyy_clan_lesser.tab`: `6e84236b4f6012b245b2da3154e9b401b8592f21f0d63fcea53090ee3139cef2`
- `kash_blackscale_guard.tab`: `924d2418281bf35dec3c6c00e1d6a3ca71724aa68002b4806caddfb2939327ef`
- `kash_kachirho_bantha.tab`: `16e15252cac30422eaadb75ced81ffbbc019253c8772337b3089a7b6434f8a16`
- `kash_kachirho_bantha_bull.tab`: `45f0ad2b9171d3232ec86be94cba8ccb3c4bf794e8408030290aebc4de8e22ef`
- `kash_kachirho_bolotaur.tab`: `4ff8eb6e8099888e3d52bb2d660412f839865dee0d6e4d317e46f246c8e06f9a`
- `kash_kachirho_bolotaur_hard.tab`: `9ffa21fe6600a5506c1d5dc07509dfcde4dccdb1361bd03fa82acc85102439a8`
- `kash_kachirho_canopy_bandits.tab`: `40143336efa84100abe466ce58b69a9ebe96aa251835a5388ffd0a399887bdda`
- `kash_kachirho_canopy_boss.tab`: `15dde46d0794b53100fa7c64d7ea363876ced632831cf14c1f0234e671c1fa18`
- `kash_kachirho_civilian_chiss.tab`: `200d5fd5b8fe8df23f5c3070cd70d9205cc8f65b228cedb80996b6536068bbce`
- `kash_kachirho_civilian_wookiee.tab`: `111020c5905819ffb78e3e26f9f07a5ba96596cd474bef554eabc2ba661f6d87`
- `kash_kachirho_guard_trando.tab`: `b7afa28b2d571e511a8c31106ecd0b8a8693db58ac08bcbd72fe3d27415a436d`
- `kash_kachirho_guard_wookiee.tab`: `4a77df71ff9ae72d356fd0b0660f5a6583b0104ce0ddd9a336c3a5267cff336e`
- `kash_kachirho_jaggedfang.tab`: `7d328d1deca5f8af4606f974486d323584f1bebbf9583961bc59f64786e74c1e`
- `kash_kachirho_uller.tab`: `8eeb549a79f42c32c4db07d3a53122b3afae920d332a039e32c8d681bc1ed98b`
- `kash_kachirho_uller_hard.tab`: `5f079e17956f91c5582988de6599a8fc4c27d7f3049a20b58d40a50acd4b0a50`
- `kash_kachirho_varactyl.tab`: `063cf313bf2ed5bf6b2a250c308353b12cd72227ac3faf0bd83f55a2f7f528ce`
- `kash_kachirho_varactyl_hard.tab`: `1aa00c8c2424d8da8e03d54c4bab5b09f5882228d4f5d04453e9df46f0da6794`
- `kash_kachirho_wke_bloodsample.tab`: `834c4501d9c817922772b5a01ed1ff5a1818154cb7d41518b4cc96680ff4dee2`
- `kash_kachirho_wke_ceremonial_captain.tab`: `40302093f469de8d02697d8a319c124c4ba55709d4723f3fccff6ddf6b9beadc`
- `kash_kachirho_wke_ceremonial_guard.tab`: `2730f56a296026ba84a6360b07e010ff275dcab65c0176321665738f07b11536`
- `kash_kachirho_wke_commando.tab`: `6101d9c5de48faac48feb2e449c1be6d75d4501353b140957f55d935048ba4ce`
- `kash_kachirho_wke_dead_guard.tab`: `c911d15e640cf10ead1f78d4e44bfb04b2c102b3d5deb0f29c1b00a1a45f6f11`
- `kash_kachirho_wke_fighters.tab`: `cee22ac50cf5ca8d07dcf10317530164c006ffbe3d8de00e1b71dcd7753e6d4a`
- `kash_kachirho_wke_healthy.tab`: `d1e4e2d4860607946cb2e9cf2b7c79743f60a03bcfc7c589194217eba8893739`
- `kash_kachirho_wke_stalkers.tab`: `329e864070a917eb2ded1dca008e836cd89c2a9dc46c54c455cf8e10b6ff6839`
- `kash_kachiro_sieged_trandos.tab`: `6da763e8715c0e1fda2b92d535ebef4191fc8ca721ff236e112cb00dc700add9`
- `kashyyyk_jyykle_vulture.tab`: `7fdd75f8027f72b78c12c5f83677a538e6cb995f2551f6ef710ca0054f7a95d6`
- `kashyyyk_kklyyytt.tab`: `fb73399175f5886e1d520373f34c101b53f18d2b85645c642756379e535c0ae8`
- `kashyyyk_pug_jumper.tab`: `dc1456d15184a1d3cd651bdfa02eae4dc714d99b15c315f3b2379d85bc02c4ae`
- `kashyyyk_roroo.tab`: `197a43d0906f6966a7a0a28ea176f2db78ee92887113a046bbbb7ca9e45280c7`
- `kashyyyk_sathog.tab`: `0c55e5f42bf97da91cf475be07f1fa686ed3a4e0eb9828eae00d2aeceae10947`
