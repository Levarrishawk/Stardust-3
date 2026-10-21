# NGE asset reader compatibility

This change extends Core3's existing IFF readers. Numeric versions belong to each
form, not to the entire asset collection: the supplied Mustafar terrain is
`PTAT/0015`, with nested `BPOL/0007`, `AROA/0006`, and other independently versioned
forms. Existing `PTAT/0013` and `PTAT/0014` paths remain supported.

## Source references

Layouts were checked against the local `client-tools` repository at
`C:/Users/ancie/Documents/client-tools`, under:

- `src/engine/shared/library/sharedTerrain/src/shared/appearance/ProceduralTerrainAppearanceTemplate.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/appearance/ProceduralTerrainAppearance.cpp` (native `createFlora`, clearing)
- `src/engine/shared/library/sharedTerrain/src/shared/generator/CoordinateHash.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/generator/Boundary.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/generator/Filter.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/generator/RadialGroup.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/generator/FloraGroup.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/generator/TerrainGenerator.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/generator/AffectorRoad.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/generator/AffectorRiver.cpp`
- `src/engine/shared/library/sharedTerrain/src/shared/generator/AffectorRibbon.cpp`
- `src/engine/shared/library/sharedUtility/src/shared/PackedIntegerMap.cpp`
- `src/engine/shared/library/sharedUtility/src/shared/PackedFixedPointMap.cpp`
- `src/engine/shared/library/sharedRandom/src/shared/RandomGenerator.cpp` and `.h`
- `src/engine/client/library/clientGame/src/shared/object/ClientClearCollidableFloraNotification.cpp`

DSRC's `sku.0/sys.shared/compiled/game/object/object_template.tdf` and
`tangible_object_template.tdf` both define versions through 10. Core3's shared
object readers already use named `PCNT`/`XXXX` parameter chunks and accept the
version form dynamically. No blanket replacement of object versions is needed.
This does not establish that every new NGE parameter or object class has server
semantics; those require representative object assets and a separate field audit.
The supplied Imperial guildhall's template and resolved inheritance chain are
covered in [NGE structure reader audit](NGEStructureCompatibility.md), including
the missing portal dependency that prevents complete geometry validation.

## Reader changes

| Form | Added or corrected behavior | Older behavior |
| --- | --- | --- |
| PTAT/0015 | Reads the legacy-map flag and trailing PIMP/PFPM static-flora maps | 0013/0014 retain their layouts and default to a legacy map |
| BPOL/0007 | Reads water type **before** the shader string; preserves the type | 0005 has no extra integer; 0006 consumes its reserved integer |
| BREC/0004 | Retains its trailing water type | 0002/0003 parsing stays intact |
| BPLN/0003 | Uses the same payload layout as 0001 | 0001 remains supported |
| FBIT/0001 | Reads gain and adds it to bitmap intensity before clamping and feathering | 0000 keeps its existing evaluation path |
| RGRP/0004 | Reads maximum width/height and aspect-ratio flag between the existing fields | 0003 remains supported |
| FGRP/0006–0008 | Handles each family's version-specific alignment and scale fields | Existing 0008 remains supported |
| LAYR/0004 | Consumes its unused integer before the expanded flag and notes | 0003 remains supported |
| AROA/0006 | Reads height lists and the fixed-height flag; evaluates fixed ramps with width/feathering | 0005 keeps the existing sampled-height path and width adjustment |
| ARIV/0006 | Consumes its trailing water type | 0005 remains supported; existing river simulation behavior stays unchanged |
| ARIB/0005 | Builds sloping water triangles, endpoint extensions, and the source's eight-sided starting cap | New reader; ribbons do not modify terrain height in the reference source |

Production changes are in `src/terrain/`, `src/pathfinding/`,
`server/zone/GroundZoneImplementation.cpp`, and
`server/zone/managers/collision/CollisionManager.cpp`. The subsequent buildout
stage also extends `src/templates/snapshot/` and
`server/zone/managers/planet/PlanetManagerImplementation.cpp`. Terrain fixtures are in
`src/tests/NgeTerrainTest.cpp`. No Engine3, IDL, database, packet, archive, or
client runtime files were changed.

## Native water and static-flora integration

For PTAT/0015, enabled ribbons and enabled water boundaries participate in a
highest-surface query. `TerrainManager::getWaterSurface` also returns the stored
water type (0 water, 1 lava in the supplied terrain; -1 for no surface). Existing
height-only water callers now see ribbon heights on NGE maps. Older terrain
queries retain their original first-boundary/global-table priority. Disabled
NGE parent layers and boundaries cannot contribute water.

Native PTAT/0015 maps with the legacy flag **false** use the packed family and
height maps for static flora. Placement uses the source's 16-metre grid, tile
border, per-tile random generator, coordinate hash, byte-quantized child choice,
yaw, and optional scale. The shared legacy terrain random implementation stays
unchanged. Particle appearances are excluded from solid collision, matching the
reference particle collision behavior.

`StaticFlora` keeps immutable placement data and borrows globally owned appearance
templates. It does not create scene objects or database records. Queries select
nearby placements by grid and appearance bounds. Existing appearance collision
methods then handle world-floor, sphere, movement, and line-of-sight checks, with
uniform scale and the model/world coordinate conversion applied. Missing selected
families, appearances, bounds, or collision geometry produce diagnostics during
loading instead of leaving invisible or unsafe colliders.

Ground-zone insertion, movement, removal, and scene registration maintain snapshots
of object clear-flora circles keyed by object ID. Queries copy those circles under
a separate lock and clear placements by horizontal distance. They retain no scene
object pointers across queries. Navigation generation receives the same cleared
flora meshes. Ribbon stamping samples each surface's slope; native non-water
polygon and ribbon areas are excluded from navigation. Older navigation behavior
is retained. Existing Mustafar navigation caches must be regenerated to include
this geometry and surface classification; normal structure-area rebuilds refresh
flora clearing in affected navigation areas.

## Supplied assets checked

Read-only checks used the two loose files in `C:/SWG-DEV/nge-stuff`:

- `terrain/mustafar.trn`: 3,618,281 bytes; SHA-256
  `3650e21ae00fa682c24051a783dcdcbf3cba14fd9f63f00acd533d4728f036fb`.
  All observed version forms have a reader dispatch after this change. Independent
  source-layout checks consumed 626 selected payloads exactly. These include the
  header, layers, polygon/polyline boundaries, bitmap gain parameters, flora
  families, road definitions, and ribbon definitions. There are 172 polygons,
  including 88 nonzero water types; 22 roads, including 17 fixed-height roads;
  10 polylines; 23 bitmap filters; and 33 ribbons. Its legacy-map flag is false.
- `datatables/buildout/areas_mustafar.iff`: 10,031 bytes; SHA-256
  `20b6b3d83de1d314764a41111c4e026a4b7ca4386fc30188bf1552e9dfec22d6`.
  Existing `DTII/0001` layout; 25 columns and 88 rows decoded completely. No
  datatable reader change was required. The subsequent dormant buildout framework
  can consume this catalog and the per-area object tables when explicitly activated; see
  [NGE buildout compatibility](NGEBuildoutCompatibility.md) for supported behavior
  and runtime checks.

The local diagnostic script `tools/audit_core3_assets.py` inventories loose IFF
versions, compares them with reader declarations, and checks selected reference
layouts. That script is local tooling excluded by this repository's existing
ignore rules. It does not execute Core3 or verify external asset dependencies.

Ten older loose terrains in `.tmp/arc170-client-inspect/terrain` also passed the
structural/reference-layout audit with no version coverage gaps:
Corellia, Dantooine, Dathomir, Endor, Lok, Naboo, Rori, Talus, Tatooine, and Yavin4.
All ten use `PTAT/0014`; 3,185 selected payloads were validated. This is
file-layout evidence, not a runtime guarantee.

Read-only dependency inspection also used
`C:/SWG-DEV/SWGDevWork/StarWarsGalaxies`. The stock SKU TOCs resolved all 15 flora
children selected by Mustafar's three populated families through 15 APT redirects,
15 detail appearances, and their 15 lowest-detail collision meshes. All 45 files
were structurally checked, including finite vertex positions and valid triangle
indices (3,851 triangles). These files came from `data_other_00.tre`,
`data_static_mesh_00.tre`, and `patch_24_client_00.tre`. The installed custom Legends
TOC uses a different encrypted format; its override selection was not verified.
No client configuration or archive priorities were changed.

A local numerical harness compiled the production ribbon construction, water
triangle query, packed-value decoder, and flora placement/choice methods to
WebAssembly, with minimal geometry/container shims. Independent reference
calculations passed for all 33 supplied ribbons (1,194 triangles and centroid
surface queries), all 2,097,152 packed family/height values, and all 3,876 selected
flora placements. The family counts are 526 debris, 384 spires, and 2,966 rocks;
all 15 children are selected. This tests numerical code, not Core3 integration or
Debian compilation. Local reports and harnesses are under
`scratch/nge-reader-check/`, excluded by the existing ignore rules.

## Remaining runtime work

This is not a declaration of complete NGE compatibility.

- Typed water queries and navigation classification are implemented. Lava damage,
  new swimming restrictions, fishing rules, and other gameplay consumers have
  not been added or changed. Existing height-only callers cannot distinguish lava
  from water without adopting the typed query.
- The legacy-map flag is retained without changing Core3's terrain sampling grid.
  Native NGE maps, road transitions, bitmap sampling, and client/server height
  agreement need coordinate comparisons with the new client. Non-fixed roads
  still use Core3's existing height-data evaluation.
- Selected static-flora collision dependencies were checked in the stock client
  assets. The server must have those matching files available through its existing
  asset loader. Other bitmaps, shaders, buildout objects, NGE object parameters,
  floors, and terrain-generator exclusion behavior on other NGE maps need their
  own asset and semantic checks.

Rerun the existing CMake configuration on Debian so its source glob discovers
`StaticFlora.cpp` and `AffectorRibbon.cpp`, then build with the project's normal
`make -j$(nproc)`. To include the regression fixtures, enable the existing CMake
`COMPILE_TESTS` option. Then, from `MMOCoreORB/bin`:

```sh
./core3 runUnitTests --gtest_filter='NgeTerrainTest.*:BasicTerrainTest.*'
```

The new fixtures exercise old/new terrain height, water, and passability;
polygon field ordering; both polyline versions; old and fixed-height roads;
bitmap gain/clamping; ribbon slopes, caps, types and disabled parents; packed
maps and invalid input; particle exclusion; flora transforms and clearing;
reference placement values; reload state; older water priority; unsupported
terrain rejection; and named object parameters at SHOT versions 0005 and 0010.
There are 19 NgeTerrainTest fixtures. Existing BasicTerrainTest adds archive-backed
height checks. The full C++ unit-test suite and Debian build have not been run
on this Windows workstation.

## Pre-rebuild compile audit, 2026-10-21

Reviewed the complete NGE patch and subsequent compile fixes for protected
container APIs, enum/byte conditionals, macro leakage, direct includes, method
declarations, const access, and generated-interface call signatures. Navigation's
new flora mesh call now directly includes `AppearanceTemplate.h`, instead of
depending on a generated scene header to supply that definition indirectly.
No Engine3 or generated sources were changed. Buildout activation remains false.

Expanded local C++ validation used the actual Engine3 `ArrayList`, `Vector`,
`SortedVector`, and `VectorMap` definitions. Thirteen existing terrain implementation
files compiled together under warnings-as-errors with the project's relevant
warning exclusions. The 18 terrain fixtures and the named-object fixture passed;
the six structure fixtures also passed. A separate runner compiled Core3's actual
datatable, snapshot, and buildout readers with the real container definitions:
all ten buildout fixtures and the 5,917 reference Mustafar placements passed.
These are isolated runners reusing the fixture bodies, not a completed run of
Core3's Google Test executable.

The full production ribbon-stamping method also compiled and ran with actual
Recast compact heightfields and allocation support. Water, non-water exclusion,
already-blocked spans, floors above the surface, and empty ribbon input passed.
The empty-input path preserves older terrain navigation behavior. The earlier
packed-map check used actual container definitions and verified all 2,097,152
Mustafar packed values. Perlin's header check verified Lua buffer declarations
after the terrain header and 139,400 unchanged noise values.

The current loader successfully loaded the ten older planet files listed above;
their NGE/static-flora flags stayed off. The Mustafar decoder consumed the full
actual file, with appearance-asset initialization excluded in that decoder check.
Independent structural checks again passed 3,185 selected older-terrain payloads
and 626 Mustafar payloads without version coverage gaps.

For a direct backward-compatibility comparison, compiled the terrain readers from
`d94d37fa26^` and the current readers with identical containers and validation
adapters. At 81 locations per older planet (810 total), terrain height, water
height, water presence, and passability matched **bit-for-bit**. Both versions used
the same input files and compiler settings. The compared output's SHA-256 is
`a1920a202140c094be8538582a6336ac88c890913fbf6a38b7cb8b81d631a92c`.

The local runners substitute IFF transport, geometry support, asset retrieval,
logging, synchronization, and test assertions where needed. They do not establish
full Engine3 linkage, concurrency correctness, generated server compilation,
Debian/GCC warning compatibility, or live client/server agreement. Server-zone
integration and IDL call signatures were inspected against their declarations;
those translation units still need the authoritative Debian build. Reports and
validation files remain under ignored `scratch/nge-reader-check/`.

After compilation, start under GDB, load both an unchanged older planet and
Mustafar, and compare known client/server heights at road centers/edges, bitmap
boundaries, lava pools, and ribbons. Verify movement and line of sight against
rocks/spires, standing on rock tops, AI routes after navigation regeneration, and
flora clearing after object placement, movement, removal, relog, and zone transfer.
Also check an unchanged older planet's water and collision behavior. Use loose
client files for tests; do not rebuild distribution TREs.
