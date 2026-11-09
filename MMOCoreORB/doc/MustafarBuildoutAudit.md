# Mustafar buildout and DSRC parity audit

DSRC reference is local commit `e3aac29b55b46fec2ce2b1518db80a8f70d798a5`.
The server previously read `snapshot/mustafar.ws` from `stardust_3_01.tre`.
The server now selects native buildouts for Mustafar and skips that snapshot.
The loader requires Mustafar at scene row 18, all 88 area rows and all 5,917
placements before it creates objects. The source expands to 1,044 cells.

The native shared tables provide scenery, buildings, cells and props. DSRC's
separate server buildout tables contain NPC spawn controllers and Java script
attachments. Those tables provide the reference for the population audit.

## Placement changes

- Matched 85 non-instance references by template, position and containment.
  Cell references also match by portal cell index. The northwestern Jedi conduit
  is 6.7 m from its snapshot position and now matches the existing quest waypoint.
- Switched all six instance pools to their native building IDs. The uplink cave
  and decrepit factory each have eight distinct copies. The other four pools
  have twelve each. The legacy snapshot duplicated one position in each of the
  two smaller pools. The native lists contain 64 distinct buildings.
- Kept the saved progress keys for copied tablets, robbed tulrus nests, prelude
  filters and power rods. Finale timer arguments accept signed Lua 5.3 buildout
  IDs. Existing quest prerequisites continue to control access.
- Moved both travelers to the DSRC landing deck coordinates and corrected four
  miner placements in Mensix.
- Restored the Mensix junk dealer's DSRC dialogue and animations using the
  existing junk dealer handler. Sale eligibility and the sale window follow
  Stardust's generic dealer rules.
- Removed eight combat-level checks. The affected entry points are the damaged
  map, Miner Madness, The Strike, Q4P3, Menth Paul, the mining executive, Pwwoz
  Pwwa and Pei Yi's lesson. Pei Yi still checks entertainer skill. Questlist
  difficulty values remain available for display and XP.

## Overworld population

The four DSRC mainland server tables provide 178 area controllers with 477
slots, 13 patrol controllers with 23 slots, seven named actors and 19 corpses.
The runtime uses the source positions, headings, spawn types, counts, respawn
bounds and ordered routes. The routes reference 85 of the 86 marker rows. Quest
scripts now use the shared native actors or resolve their source-backed creature
IDs for kill credit. The two generic building spawners feed Mensix and the
crashed cruiser. They remain part of the building audit below.

The regional wildlife data uses all 34 source spawn regions, 585 weighted
entries and 156 pack recipes. Capped packs use player group size and the source
cap for each creature type. Existing Stardust no-build footprints and five
no-spawn buffers remain in force. Core3 still controls regional spawn cadence,
terrain checks, culling and respawns. The six area controllers that ask DSRC to
find clear ground use Core3's spawn-point search. Creature profiles retain
Stardust combat and loot. The configured asset set uses Stardust's ruins leader
appearance in place of the DSRC ruins patron.

Run this from the repository root to check the four generated files against the
reference. Omit `--check` to regenerate them.

```powershell
python MMOCoreORB/utils/mustafar/build_population.py C:/Users/ancie/Documents/dsrc --check
```

## Conversations, quests and instances

- Valley Battlefield squad leaders use the DSRC conversation with follow, halt,
  deploy and withdraw orders. Engagement closes further orders. The deployed
  troops participate in the existing demolition and cleanup logic.
- Mensix uses nine DSRC ambient sequences, including both corridor patrols.
  The hall 08 miners now perform the jokes that ran on duplicate outdoor
  miners. Three extra indoor stand-ins were removed. Core3 drives the movement
  and plays the hub miner's electrical effect on the actor.
- The seven exploration chains use the 31 native buildout markers, DSRC radial
  labels and message boxes, and DSRC journal task indices. Legacy quest flags
  still track progression. Each completed area pays its 5,000 credits to the bank.
- The six indoor pools use DSRC entry cells and transfer coordinates. Groupmates
  can join an occupied party copy up to eight players. The five party pools run
  for up to one hour. The crystal cave admits solo players for 30 minutes.
  The Old Republic Facility grants persistent access from the applicable story,
  Historian or shard quest phase.
- The 88 static creature rows in the Old Republic Facility and two droid factories
  match the DSRC creature name, cell, position and yaw. The four factory patrols
  use 15 ordered source waypoints. The current 600-second respawn covers reused
  copies pending a full per-run reset.

| Scope | Remaining parity work |
| --- | --- |
| Overworld | Verify DSRC spawn placement, respawn and patrol behavior in the client. Compare creature combat, loot and Java behavior attached to individual source templates. Regional spawn scheduling and clearance still follow Core3. |
| Mensix and crashed cruiser | Verify all 37 Mensix creature rows and in-cell pathing in play. Compare the crashed cruiser computer and its scripted interactions. |
| Conversations and quest lines | Verify branch conditions and side effects across all conversations and the 76 `som_*.tab` questlist/task pairs. Stardust uses profession skills and quest state where applicable. Diskret Stahn's performance grant and the Tanray Heart badge depend on compatible data. |
| Indoor instances | Match daily lockout triggers, encounter resets, the factory keypad sequence, phased Uplink and Obi-Wan encounters, and Sher Kar's syringe chain. Sher Kar remains accessible while Stardust lacks the full assembly and acquisition path for its key. |
| Outdoor instances | Valley and Volcano use their existing single-arena scripts. Compare instance allocation, encounters and completion handling with DSRC. |

## Deployment and verification

The local loose payload is under `client-assets/mustafar_native_buildout/loose`.
It contains the full scene table, Mustafar area table, 12 object tables and an
empty Mustafar client snapshot. The full scene table preserves the existing
native Kashyyyk indices. The earlier shortened Myyydril fallback scene table
places Mustafar at row 7 and is incompatible with Mustafar's native IDs.

1. Copy the payload's `datatables/buildout/` tree into `MMOCoreORB/bin` on
   the test server, preserving relative paths. The regular asset loader reads
   those loose files from its working directory. Stage the same tables and the
   empty `snapshot/mustafar.ws` for the native-buildout client as loose files.
   The production client reads both sources, so the empty file suppresses the
   packed snapshot. Use the client's existing loose-file path.
2. Build on Debian with `make -j$(nproc)` and start under GDB. Check for
   `Loaded 5917 buildout nodes for mustafar` and review template, container and
   transfer diagnostics. That count is the decoded placement count.
3. Refresh Mustafar navigation data and test overworld patrols, regional packs,
   Mensix interiors, NPC chat, quest props, instance transfers, group joins and
   relog. Before cutover, move characters parked in legacy instance cells to the
   surface. Their saved parent IDs refer to the old snapshot.

Local checks covered native table decoding, mapped references, the staged empty
snapshot, population regeneration and Lua syntax. Lua stubs exercised all 500
controller slots, actor uniqueness, patrol movement and replacement, the eight
level-one entry points, the junk dealer sale option, Valley orders, marker
completion, party admission and timed exits. The Debian build and live server
and client verification are pending. The nine Mensix sequences were also
checked against the DSRC action tables and run in the Lua harness.
