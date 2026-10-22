# Single-instance native Rryatt migration

October 22, 2026. Authorized scope: one public copy, all four original section
tables and only the first four native area rows. The other twenty area rows
remain excluded. Other worlds and missing dungeon snapshots are unchanged.

## Implemented behavior

`PlanetManagerImplementation.cpp` enables native buildouts only for
`kashyyyk_rryatt_trail` and never opens that world's legacy `.ws`. It requires
scene row 5, area indices 500..503, the four native section names/bounds and
506/469/385/349 placement rows. Missing sections, stale instance counts, wrong
scene order/bounds and unresolved template CRCs reject the complete load before
runtime object publication. Buildout identities and transforms follow the NGE
client's existing rules; no new allocation of placement IDs is introduced.
All 1,709 placements have world-space parents/cell index0.

The existing buildout object path creates transient client objects. Legacy
snapshot IDs are no longer requested, and the client uses a valid empty snapshot
override. No persistent object/database records are deleted. A full restart is
required to leave the previous scene contents behind; this is not a hot reload.

`kashyyyk_rryatt_npcs.lua` restores the 15 native NPC positions/headings and original
travel offsets. Existing owned NPCs are repositioned without duplication; the
old layoutShift corrections are removed. `kashyyyk_zone_transitions.lua` restores
the entrance/arrival coordinates and binds the native door ID
`-141018963347066332` (signed Lua 64 representation). It removes a matching
screenplay-owned legacy door from the live world, with no duplicate fallback.
Missing native geometry defers gate/NPC setup. Progression, mastery/guide rules,
quest state, spawn counts/groups and other-zone gates are preserved.
`kashyyyk_rryatt_trail_regions.lua` restores native DSRC spawn centers;
`kashyyyk_patrol_paths.lua` restores the two Rryatt routes' ten points.

## Matching client/server assets

The following nine loose assets are staged under `C:/SWG-DEV/stardust_3_04` for
the operator's TRE rebuild, and installed loose in `C:/Stardust-Experimental`:

- `datatables/buildout/buildout_scenes.iff` (existing scoped scene order, Rryatt5)
- `datatables/buildout/areas_kashyyyk_rryatt_trail.iff` (four leading native rows)
- `datatables/buildout/kashyyyk_rryatt_trail/kashyyyk_rryatt_trail_lvl_1_and_2.iff`
- `datatables/buildout/kashyyyk_rryatt_trail/kashyyyk_rryatt_trail_lvl_3.iff`
- `datatables/buildout/kashyyyk_rryatt_trail/kashyyyk_rryatt_trail_lvl_4.iff`
- `datatables/buildout/kashyyyk_rryatt_trail/kashyyyk_rryatt_trail_lvl_5.iff`
- `misc/object_template_crc_string_table.iff` (four required names merged)
- `terrain/kashyyyk_rryatt_trail.trn` (original NGE terrain)
- `snapshot/kashyyyk_rryatt_trail.ws` (valid 48-byte empty override)

The four added CRC names are shared_rryatt_world_root_a1/a2 and the
shared_poi_kash_rryatt_rope_lift_rope_half/quarter templates under
`object/building/kashyyyk/`. All 294 required shared object files match the
original NGE bytes and have corresponding server Lua definitions. No new object
template scripts are needed. Use the same effective assets on both sides.

The existing NGE client already supports these buildouts; no additional client
binary is required. Experimental retains EXE 4ED43101 and source-built stock
gl05 9E0C43A7. Its configuration, archive mounts and saved options are unchanged.
No TRE is created or rebuilt by this work. **config.lua is unchanged and belongs
to the operator.** The operator must arrange the matching server asset overlay
and its precedence there. Nothing here edits that configuration.

Private manifest, exact hashes, source backups, delivery receipt and logs are
under `C:/SWG-DEV/SRC-Client-Dev/diagnostics/rryatt-single-instance-20261022`.
No proprietary assets or compiled fixtures are added to either Git repository.

## Validation completed locally

- Compiled production BuildoutData methods and extracted real PlanetManager
  append/loader methods with small Core3 container/IO adapters. All 1,709 IDs,
  parents, CRCs, positions, quaternions, radii and portal CRCs match independent
  expected records. Duplicate/cycle cases reject. Six stale/missing/malformed
  asset cases publish no nodes. Rryatt never opens the legacy snapshot;
  Naboo/Mustafar/Kashyyyk Main retain the existing snapshot path.
- Real Lua 5.3 runs of `kashyyyk_progression_test.lua`, new
  `rryatt_single_instance_test.lua`, and `kashyyyk_population_test.lua` pass.
  These include 15 NPCs, eight guide routes/returns, four mastery warps, owned
  NPC migration, exact 64-bit gate identity, legacy-door retirement, retries,
  region/patrol anchors, persistence and unchanged other-zone gate creation.
- Real client datatable/area/CRC/snapshot libraries plus the verbatim production
  buildout loop pass 58,130 checks: four areas, 1,709 placements, zero legacy nodes.
- The existing map inverse passes72,988 checks. Four deployed snapshot-radius
  configurations pass 175,588 checks. The operator confirms Mustafar's current
  4,826 roots reflect33 removed custom ribbons superseded by native terrain
  affectorRibbons; this migration changes no Mustafar assets.

These offline tests use no network/database/renderer and do not compile the full
Core3 server or exercise actual scene-object factories. The complete authoritative
Debian build and live verification have not been run here.

## Operator build and live verification

Reconfigure the existing CMake build if necessary so its source glob includes
`BuildoutData.cpp`, then build on Debian using the normal `make -j$(nproc)` flow.
With COMPILE_TESTS enabled, run from MMOCoreORB/bin:

```sh
./core3 runUnitTests --gtest_filter='BuildoutDataTest.*:NgeTerrainTest.*:BasicTerrainTest.*'
```

Rebuild/distribute the matching TRE and set its server precedence yourself.
Restart the updated server with the same native assets; regenerate the Rryatt
navigation cache using the normal deployment procedure. Confirm startup reports
`Loaded 1709 buildout nodes for kashyyyk_rryatt_trail` with no per-object template,
creation or transfer errors. The count reports parsed nodes; check actual object
creation/collision as well. Do not accept missing-gate/NPC deferral as success.

Enter from Kachirho at native world(-3817.315,171.735,3361.33). Verify terrain and
geometry alignment, entrance gate, NPC footing and facing, all five levels,
eight guide trips/returns, four mastery warps, map-click waypoints/coordinates,
collision/pathing, relog and repeat travel. Confirm no legacy overlap or extra
instance copies and that other planets retain their current behavior.
Existing saved player positions are not moved automatically; use a normal
operator travel action if a character was saved in the old displaced frame.
Database cleanup is outside this migration.
