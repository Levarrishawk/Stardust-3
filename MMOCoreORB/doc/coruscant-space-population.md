# Coruscant orbital population

`space_coruscant` now loads Coruscant Orbital Control at the origin, ten stationary capital ships, and 216 ambient ships at full population. The existing SpaceManager and SpaceSpawnerScreenPlay manage the station, startup staggering, patrols, destruction observers, and replacements. Other systems' populations and ship statistics are unchanged.

## Station and fleet

Coordinates below use the scripts' order: **x, z (height), y**, in metres. Distances refer to object origins. The station reuses the existing Imperial station appearance. It is invulnerable and offers a comm conversation for landing at the existing Coruscant Spaceport (-96, 40, 3149) and paid full repairs using the standard station helpers and component decay.

| Object | x | z (height) | y |
| --- | ---: | ---: | ---: |
| Coruscant Orbital Control | 0 | 0 | 0 |
| Inner port Venator | -1400 | 0 | 0 |
| Inner starboard Venator | 1400 | 125 | 0 |
| Outer port Venator | -4200 | 275 | 0 |
| Outer starboard Venator | 4200 | 400 | 0 |
| Aft port ISD | -2000 | 25 | -3600 |
| Aft starboard ISD | 2000 | 175 | -3600 |
| Forward port ISD | -2000 | 325 | 3600 |
| Forward starboard ISD | 2000 | 475 | 3600 |
| Forward outer port ISD | -5400 | 625 | 3600 |
| Forward outer starboard ISD | 5400 | 775 | 3600 |

The two inner Venators are about 1,400 m and 1,406 m from the station. The formation accounts for the current 2,000 m Venator hull and approximately 2,587 m stock ISD hull; their rotated appearance bounds do not intersect one another or the station. The four Venators face 180 degrees from their original orientation, aligning their bows with the ISDs. The station faces 90 degrees to the right of its original orientation. Capital ships retain their stationary AI and respawn 30–60 minutes after destruction with the same headings and heights. ISD heights span 750 m; Venator heights span 400 m.

Coruscant's launch/load-in position and `space_coruscant_0` hyperspace arrival are both **(-5369, 1521, 548)** in x, z (height), y order. In `hyperspace_locations.iff`, whose columns are X/Y/Z, this is X=-5369, Y=548, Z=1521. The other 40 hyperspace rows are preserved.

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

Deploy the Lua files and the `DirectorManager.cpp` update, build on Debian with `make -j$(nproc)`, and restart the server. The spawner's optional numeric sixth argument now supplies yaw in degrees; existing calls with five arguments or a sixth ship target retain their behavior. Initial position, home heading, quaternion and ship collision/movement transform are initialized together before insertion into the zone. No IDL, generated-interface, database or Engine3 changes are required. Ensure `space_coruscant` is listed in the deployed configuration's `SpaceZonesEnabled`; enable the ground `coruscant` zone for landing. The ignored local development configuration currently disables space zones and is not changed by this feature.

The 2 km Venator loose assets must be installed on the server and clients through the established mod workflow (`client-assets/imperial_venator/` at the repository root). The follow-up package `client-assets/coruscant_space_updates/` stages twelve changed/new runtime files: the arrival table, three merged English STFs, the corrected Venator client template, its LOD/three hull meshes with an engine-on hardpoint, and a fitted glow mesh, appearance and client-data file. The glow reuses the ISD's original engine mesh geometry, emissive shader and texture at all twelve source-model exhaust openings; the stock ISD assets are unchanged. Server names resolve to `@space/space_mobile_type:imperial_venator` and `@space/ship_names:spacestation_coruscant`. The English `space_ship.stf` also provides both chassis labels. Existing string IDs/text and other hyperspace rows are retained. No TREs or client configuration files were changed.

## Verification

From `MMOCoreORB`, run:

```sh
luajit bin/scripts/screenplays/tests/coruscant_space_test.lua
```

The standalone test loads the real Lua definitions and spawner with mocked engine calls. It checks zone gating, startup and capital replacement scheduling, actual spawned population counts, agent registration, station/capital bounds, patrol references and route bounds, plus station service handling after range/zone changes or insufficient funds. It also checks explicit native object types using direct table enumeration, matching the C++ template loader. All changed Lua files also passed syntax compilation with LuaJIT. These checks do not simulate ship physics, combat or client rendering.

Both custom server object templates must explicitly define `gameObjectType = 536870920`, matching their existing base templates. `SharedObjectTemplate::readObject` enumerates only the Lua table's own fields with `lua_next`, so inheriting that field through a metatable does not override the client object's type. Without the explicit field, `ShipManager::createAiShip` cannot convert the created object to `ShipAiAgent`, and `/createCreature` reports the generic "invalid ship agent template" error. Deploy the corrected two object Lua files and restart the server; no client asset or C++ rebuild is required for this fix.

Debian/client verification remains: confirm the station loads once at the origin; comm it and land/repair; fly the formation to inspect hulls and attachments; wait for full traffic, check server logs for missing templates or patrol points, and measure server/client performance with the 227-object population. Confirm destroyed ships are replaced once and traffic remains present after leaving/re-entering the system.

## Coruscant Starport terminals

`bin/scripts/screenplays/cities/coruscant_starport.lua` adds ten standard `object/tangible/terminal/terminal_space.iff` terminals to Coruscant's existing starport (snapshot building 37000196, at x=-119, z=40, y=3132). The building uses the same `starport_corellia.iff` interior as Coronet. The placements and quaternions are copied from Coronet's building 1855671 in the DEV client's loaded `snapshot/corellia.ws`: six terminals in cell 4 (main hall) and four in cell 10 (side room). Coruscant's cells are resolved from its own building, rather than reusing Corellia cell IDs.

The screenplay starts only when Coruscant is enabled, validates the building, and checks each cell for an existing matching terminal at the intended local position before spawning. Repeated startup does not duplicate terminals, and existing unrelated objects are retained. There is no persistent state or delayed task. Mocked Lua checks verified all ten placements/headings against the source snapshot, correct parent cells, missing-building/cell handling and duplicate prevention.

Deploy the new screenplay and its include in `bin/scripts/screenplays/screenplays.lua`, then restart the server. This terminal addition requires no C++ compilation, client files or TRE update. In-game verification remains: check the six main-hall and four side-room terminals, open their starship menus, and launch into the configured Coruscant space arrival area.
