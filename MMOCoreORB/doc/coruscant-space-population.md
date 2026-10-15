# Coruscant orbital population

`space_coruscant` now loads Coruscant Orbital Control at the origin, ten stationary capital ships, and 216 ambient ships at full population. The existing SpaceManager and SpaceSpawnerScreenPlay manage the station, startup staggering, patrols, destruction observers, and replacements. Other systems' populations and ship statistics are unchanged.

## Station and fleet

Coordinates below use the scripts' order: **x, z (height), y**, in metres. Distances refer to object origins. The station reuses the existing Imperial station appearance. It is invulnerable and offers a comm conversation for landing at the existing Coruscant Spaceport (-96, 40, 3149) and paid full repairs using the standard station helpers and component decay.

| Object | x | z (height) | y |
| --- | ---: | ---: | ---: |
| Coruscant Orbital Control | 0 | 0 | 0 |
| Inner port Venator | -1400 | 0 | 0 |
| Inner starboard Venator | 1400 | 0 | 0 |
| Outer port Venator | -4200 | 350 | 0 |
| Outer starboard Venator | 4200 | 350 | 0 |
| Aft port ISD | -2000 | 400 | -3600 |
| Aft starboard ISD | 2000 | 400 | -3600 |
| Forward port ISD | -2000 | 400 | 3600 |
| Forward starboard ISD | 2000 | 400 | 3600 |
| Forward outer port ISD | -5400 | 400 | 3600 |
| Forward outer starboard ISD | 5400 | 400 | 3600 |

The two inner Venators are each 1,400 m from the station. The formation accounts for the current 2,000 m Venator hull and approximately 2,587 m stock ISD hull; their appearance bounds do not intersect one another or the station. Capital ships use the existing stationary AI and identity spawn rotation. The imported Venator's bow points opposite the stock ISD's bow at that rotation. Capitals respawn 30–60 minutes after destruction.

## Traffic

| Population | Ships |
| --- | ---: |
| Individual tier 4/5 TIE patrols | 96 |
| Eight existing six-ship Imperial response wings | 48 |
| Military logistics Lambda shuttles | 12 |
| Civilian freighters and science transports | 60 |
| **Ambient total** | **216** |
| **Total including capitals and station** | **227** |

Patrols include TIE fighters, interceptors, bombers, Advanced, Oppressor and Aggressor variants. Response wings also include Imperial gunboats and Lambda shuttles. Guard patrol pockets cover inner approaches, outer quadrants, and upper/lower space. Ships retain their existing faction and combat behavior.

Civilian traffic follows twelve seven-point routes: six east/west lanes at height -1600 m and six north/south lanes at -2800 m, with alternate lanes reversing direction. The two traffic decks pass below the capital fleet and separate crossing routes by height. All route points, spawn offsets and nominal guard patrol ranges fit inside the existing +/-8000 m space limits. Combat pursuit can take ships outside their nominal patrol areas.

Ambient replacements use the existing spawner's timers: 45–120 seconds for fighters, 120–240 seconds for response wings, 60–120 seconds for civilians and 90–180 seconds for logistics. Startup is staggered using the standard 2–5 minute spawner delay and subsequent per-ship delays; allow up to approximately 17 minutes for the full population.

## Files and deployment

- `bin/scripts/screenplays/space/spawning/space_coruscant_spawner.lua`: capital formation and ambient populations.
- `bin/scripts/ship_mobile/patrol_points/space_coruscant.lua`: civilian routes.
- `bin/scripts/object/custom_content/ship/spacestation_coruscant.lua` and `bin/scripts/ship_mobile/ships/spacestation_coruscant.lua`: station object and agent, inheriting existing Imperial assets.
- `bin/scripts/mobile/conversations/space/spacestation_coruscant.lua` and `bin/scripts/screenplays/space/spacestations/spacestation_coruscant_conv_handler.lua`: station services.
- Existing registration files load these definitions; `managers/space/space_manager.lua` places the station, `managers/space/ship_chassis.lua` registers its collision lookup, and `screenplays/space/spacestations/spacestation.lua` adds the landing destination.

Deploy the Lua files and restart the Debian server. No C++ compilation, generated interfaces, database changes or Engine3 changes are required. Ensure `space_coruscant` is listed in the deployed configuration's `SpaceZonesEnabled`; enable the ground `coruscant` zone for landing. The ignored local development configuration currently disables space zones and is not changed by this feature.

The previously created 2 km Venator loose assets must be installed on the server and clients through the established mod workflow (`client-assets/imperial_venator/` at the repository root). The station and ambient ships reuse existing client resources. No TREs or client configuration files were changed.

## Verification

From `MMOCoreORB`, run:

```sh
luajit bin/scripts/screenplays/tests/coruscant_space_test.lua
```

The standalone test loads the real Lua definitions and spawner with mocked engine calls. It checks zone gating, startup and capital replacement scheduling, actual spawned population counts, agent registration, station/capital bounds, patrol references and route bounds, plus station service handling after range/zone changes or insufficient funds. All changed Lua files also passed syntax compilation with LuaJIT. These checks do not simulate ship physics, combat or client rendering.

Debian/client verification remains: confirm the station loads once at the origin; comm it and land/repair; fly the formation to inspect hulls and attachments; wait for full traffic, check server logs for missing templates or patrol points, and measure server/client performance with the 227-object population. Confirm destroyed ships are replaced once and traffic remains present after leaving/re-entering the system.
