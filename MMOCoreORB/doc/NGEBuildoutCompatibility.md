# NGE buildout datatables

The shared-client buildout compatibility framework is implemented but **dormant**.
`PlanetManagerImplementation::loadSnapshotObjects` keeps `useBuildouts` false for
all terrains. No buildout datatables are opened at startup, no buildout objects
are spawned, and normal path checks do not consult buildout area rules. Existing
snapshot loading remains active. Activation is deferred until explicitly requested.

## Inputs and source rules

The prepared loader can obtain these inputs through the existing asset loader
when explicitly activated:

- `datatables/buildout/buildout_scenes.iff`: scene **row order** determines the
  namespace. The area index is `sceneRow * 100 + areaRow`; never sort these rows.
- `datatables/buildout/areas_<scene>.iff`: area rectangles, names and metadata.
  Repeated names describe different placements of the same object table.
- `datatables/buildout/<scene>/<area>.iff`: shared object templates, transforms,
  cell indices, portal-layout CRCs and radii.
- `misc/object_template_crc_string_table.iff`: shared template CRC resolution,
  with Core3's registered template names as a fallback.

The supplied `client-tools` source defines two shared object table layouts in
`clientGame/src/shared/core/WorldSnapshot.cpp`:

| Layout | Identity and containment |
| --- | --- |
| Implicit IDs, no `objid`/`container` columns | Base ID `-(areaIndex + 1) * 30000`; portal buildings and cells consume the first 2,000 slots, other objects start at base + 2,000. Cell rows belong to the preceding building; interior objects belong to the preceding cell. |
| Explicit `objid` and `container` columns | Sign-extend each signed 32-bit value to 64 bits; for negative values XOR `(areaIndex + 1) << 48`. Positive IDs and container zero keep their meanings. |

Both layouts resolve columns by name. World rows (`cell_index == 0`) add the area
rectangle's minimum X/Z to their positions. Interior rows retain cell-local
positions. Quaternions retain the source component order. The existing snapshot
adapter performs Core3's horizontal/height axis conversion.

`useOrigin`, `originX` and `originZ` are retained as metadata. The inspected
client's `WorldSnapshot::load` uses the area rectangle minimum for object
placement even when `useOrigin` is set; this implementation follows that code.
It does not substitute the origin or composite center for the placement offset.

The other reference is
`sharedGame/src/shared/core/SharedBuildoutAreaManager.cpp` and `.h`. DSRC includes
the corresponding source tables under
`sku.0/sys.shared/compiled/game/datatables/buildout/`, and separate server tables
under `sku.0/sys.server/compiled/game/datatables/buildout/`.

## Runtime integration and compatibility

`templates/snapshot/BuildoutData` parses area metadata and object rows using
Core3's existing `DataTableIff`. It orders internal container dependencies and
rejects duplicate IDs, cycles, missing schema columns, invalid geometry values,
unparented interiors and invalid portal-building containment. The scene loader
resolves an area's template names and checks its IDs and container references
before appending any of its nodes. Invalid or missing area files produce a
diagnostic naming the file and area index; unrelated areas continue loading.

The dormant `PlanetManagerImplementation::loadSnapshotObjects` buildout branch
can append these nodes to the existing snapshot adapter. Buildings, cells and
other objects would use Core3's normal
scene-object factory and transfers. Buildout loads run in dependency order even
when `PARALLEL_SNAPSHOT_LOADING` is enabled. A missing runtime parent causes the
child to be skipped rather than inserted at cell-local coordinates in the world.
Failed native transfers are logged and use the existing object cleanup path.

When activated, new buildout objects would be **transient client objects**,
regenerated from the tables on startup. Their upper ID bits identify buildout areas and must not be
registered as Core3 database table IDs. Ordinary snapshot objects retain their
existing persistence behavior. Existing objects are checked by ID before creation.
Buildout cell IDs and contained object IDs are preserved; they are not replaced
with newly allocated server IDs.

`WorldSnapshotNode` now holds 64-bit IDs in memory. Its `.ws` reader still consumes
the same unsigned 32-bit fields, preserving the old interpretation of high-bit
snapshot IDs. No database schema, packet layout, IDL signature, Engine3 code or
client archive was changed.

`TerrainManager::getBuildoutData()` exposes area lookup, metadata, relative map
coordinates and the reference isolation/traversal query.
`TerrainManager::isPathPassable` retains its existing terrain-only checks; buildout
traversal rules are available as framework queries and are not wired into gameplay.

Clip rectangles fall back to the area rectangle when enabled with zero dimensions.
Environment exclusions are applied with `envFlags & ~envFlagsExclude`. Composite
rectangles, isolation, internal/map/radar flags and required event names are
retained. Renderer clipping, radar and map presentation remain client behavior;
loading these fields does not add renderer behavior to Core3.

Event-required areas stay inactive until a server event integration is provided.
All 88 supplied Mustafar area rows have an empty event requirement. These are
**shared client buildouts**: the separate server buildout tables' Java scripts,
object variables, NPCs and quests are not automatically imported. Existing Core3
Lua templates and gameplay systems remain responsible for server behavior.

## Assets validated locally

Read-only inspection used `C:/SWG-DEV/nge-stuff/` and stock SKU TOCs/TRE contents
from `C:/SWG-DEV/SWGDevWork/StarWarsGalaxies/`. The custom encrypted Legends TOC's
override selection was not inspected. No client files, archives or search
priorities were modified.

- Mustafar is scene row 18 in the inspected compiled scene table.
- Its 88 area rows reference 12 distinct object files. There are 56 explicit-ID
  area instances and 32 implicit-ID area instances.
- Expanding all instances produces 5,917 objects, including 1,044 cells. Their
  IDs are unique and every nonzero container has a preceding object.
- All 416 referenced shared template names resolve in the stock CRC table and
  have corresponding server Lua files in this repository. Runtime registration
  and matching deployed template/appearance/portal assets still need validation.

A standalone Windows C++ harness compiled the **production BuildoutData methods**
with small substitutes for Core3 containers and already-decoded datatable cells.
All 5,917 IDs, parents, template CRCs, cell indices, positions, quaternions, radii
and portal CRCs matched independently calculated reference records. Duplicate and
cyclic-container cases were also rejected. This harness does not compile Engine3
or exercise live scene-object creation. Its files and asset inspection reports
are local ignored tooling under `scratch/nge-reader-check/`.

Ten Core3 regression fixtures in `src/tests/BuildoutDataTest.cpp` cover scene
ordering, metadata and coordinate rules, isolation, inactive events, implicit and
explicit IDs, reused area instances, ordering, malformed data and older snapshots.
The complete Core3 build and these Google Tests have not been run here.

## Remaining verification and future activation

Rerun the project's existing CMake configuration so its recursive source glob
discovers `BuildoutData.cpp`. Build normally with `make -j$(nproc)`. With the
existing `COMPILE_TESTS` option enabled, run from `MMOCoreORB/bin`:

```sh
./core3 runUnitTests --gtest_filter='BuildoutDataTest.*:NgeTerrainTest.*:BasicTerrainTest.*'
```

The framework has not yet passed a complete Debian build or live server/client
verification. The following deployment checks apply only after future activation;
no table deployment or activation is part of the current change.

Use matching native terrain, scene/area/object tables, CRC string table, templates
and collision assets on the server and NGE client. A legacy custom `.ws` that
already flattened the same buildouts can duplicate scenery under different IDs;
verify the test asset set before combining it with native buildouts. The loader
checks ID collisions and does not guess whether overlapping scenery is intentional.
The stock client files inspected here contain no `snapshot/mustafar.ws`.

Start under GDB and inspect the buildout-load diagnostics. Verify Mensix and the
mainland quadrant offsets, repeated cave/factory placements, building/cell entry,
cell-local decorations, collisions, flora clearing, object lookup by native IDs,
relog and zone transfer. Regenerate affected navigation caches so the new
buildings and props participate in routing. Confirm an older planet's snapshot
IDs, positions and object counts are unchanged. Client tests use loose files;
distribution TREs remain the user's responsibility.
