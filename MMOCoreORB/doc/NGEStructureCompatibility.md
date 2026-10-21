# NGE structure reader audit

## Scope and result

The supplied example is
`C:/SWG-DEV/Legends-Extracted/legens_06/object/building/player/shared_player_guildhall_imperial_style_01.iff`.
It is 1,670 bytes, SHA-256
`6059c49c994d2d17cf31fe3576718a863dfc0d53339e03fff04ffe72b9ce3806`.

Its object-template formats are readable through Core3's existing building,
tangible, and shared-object readers. They use named `PCNT`/`XXXX` parameters;
each class layer has its own version. No new object class or blanket version
replacement is needed. Unset parameters inherit their base values; an explicitly
empty string clears an inherited filename. Repeated `DERV` references to the same
base are already suppressed by `loadedDerivedFiles`.

**The complete geometry chain cannot yet be validated.** The template references
`appearance/ply_impl_assoc_hall_s01.pob`, which was not found in the supplied
extracted files, the installed stock SKU TOCs, or the readable TRE-v5 archives
searched under `C:/SWG-DEV`. This prevents inspection of this building's cell
appearances, floor meshes, portal graph, doors, and collision geometry. No other
guildhall appearance has been substituted, and the asset name has not been changed.

No object Lua, registration, spawning, placement, buildout activation, or client
asset changes accompany this audit. Reading an IFF does not supply Core3's
server-specific building gameplay configuration or register a spawnable object.
The buildout framework remains dormant.

## Resolved inheritance

| Template | Class layers | Located in |
| --- | --- | --- |
| `object/building/player/shared_player_guildhall_imperial_style_01.iff` | SBOT/0001, STOT/0010, SHOT/0010 | Supplied loose file |
| `object/building/base/shared_base_player_building.iff` | SBOT/0001, STOT/0009, SHOT/0010 | `patch_26_shared_00.tre` |
| `object/building/base/shared_base_building.iff` | SBOT/0001, STOT/0009, SHOT/0010 | `patch_24_shared_00.tre` |
| `object/tangible/base/shared_tangible_base.iff` | STOT/0010, SHOT/0010 | `patch_26_shared_00.tre` |
| `object/object/base/shared_base_object.iff` | SHOT/0010 | `patch_18_shared_00.tre` |

These origins record the stock SKU resolver's selection for the audit. The custom
Legends TOC's override ordering was not inferred. The standalone validation uses
these exact resolved bytes and omits server Lua overrides.

## Associated files and effective values

| Reference or field | Finding |
| --- | --- |
| `footprint/building/player/shared_player_guildhall_corellia_style_01.sfp` | Present in `patch_00.tre`; supported FOOT/0000. Seven columns, eight rows, center (3, 3), eight-metre chunks. The sample inherits a false outline-use flag; Core3's existing dimension reader is sufficient for that case. |
| `abstract/slot/arrangement/arrangement_structure.iff` | Inherited from the player-building base; present in `patch_26_shared_00.tre`. Supported ARGD/0000, one `structure_control_device` slot. |
| `appearanceFilename` | Inherits an empty string. Geometry must come through the POB, including the exterior cell. |
| `portalLayoutFilename` | Explicitly `appearance/ply_impl_assoc_hall_s01.pob`; missing from the sources checked. |
| `clientdata/building/shared_association_hall_imperial.cdf` | Present in the supplied extracted tree; CLDF/0000 containing only CNCF: center (0, 0, 0), flora-clear radius 35. No further asset references. |
| `clearFloraRadius` | Explicitly 38, already consumed by Core3's terrain flora-clearing integration for ground-level objects. It covers the CDF's concentric 35-metre circle; this example requires no additional CDF interpreter. |
| `snapToTerrain`, `targetable` | Both resolve to false through inheritance. |
| `gameObjectType` | Resolves to client type 0x202. This does not replace Core3's server Lua classification. |
| Terrain modification and interior layout | Both resolve to empty filenames; this example has no referenced terrain modifier or interior-layout file. |
| `clientVisabilityFlag` | New STOT parameter, unset in the sample and zero in the base. Client visibility metadata does not shift subsequent named chunks. No server visibility policy has been added. |
| `forceNoCollision` | Unset in the sample and false in the root base. Core3 currently skips this NGE parameter. That has no suppress-collision effect for this chain; true-valued examples require a separate semantic audit before claiming support. |

The CDF is client-side data; importing visual effects, sounds, or client child
objects into server scene state is not part of this reader change. Other CDFs
may contain different data and require their own server-relevant dependency audit.

## Reader fixes

- `SharedObjectTemplate.cpp` accepts the source format's `tintPalette` spelling in
  both its IFF and Lua parameter readers, while retaining historical
  `tintPallete` compatibility and existing storage/accessor names.
- `CellProperty.cpp` checks a loaded CELL/0005 floor before assigning its cell ID.
  A missing or rejected floor now produces a diagnostic instead of dereferencing
  null. This does not create substitute geometry or make the cell navigable.
- `PortalLayout.cpp` skips cells without floor meshes during global floor-node
  lookup, matching the existing null-floor handling in graph connection code.

These are shared reader fixes, with no changes to terrain format dispatch,
Engine3, IDL, persistence, or packets. Existing valid floor and template paths
retain their behavior. No additional portal/floor version dispatch was invented
without the missing POB.

## Source comparison

Layouts and parameter meanings were checked in the local `client-tools` repository
at `C:/Users/ancie/Documents/client-tools`, including:

- `src/engine/shared/library/sharedGame/src/shared/objectTemplate/SharedObjectTemplate.cpp`
- `src/engine/shared/library/sharedTemplate/src/shared/template/SharedTangibleObjectTemplate.cpp`
- `src/engine/shared/library/sharedTemplate/src/shared/template/SharedBuildingObjectTemplate.cpp`
- `src/engine/shared/library/sharedObject/src/shared/lot/StructureFootprint.cpp`
- `src/engine/client/library/clientGame/src/shared/objectTemplate/ClientDataFile.cpp` (CNCF)

The local DSRC definitions are under
`sku.0/sys.shared/compiled/game/object/`, including `object_template.tdf`,
`tangible_object_template.tdf`, and the building templates. The custom Imperial
hall itself was audited from its binary, not inferred from another hall's source.

## Validation and remaining checks

`src/tests/StructureAssetTest.cpp` contains six regression cases covering nested
SBOT/STOT/SHOT parsing with older and newer versions, repeated DERV suppression,
inherited versus explicitly empty values, both palette spellings, skipping unknown
named fields, missing floors in CELL/0004 and CELL/0005, and floor-graph lookup
without floors.

A local native C++ harness compiled the production parameter classes and selected
production template/cell/portal reader methods with lightweight engine and asset
loader substitutes. It passed all six cases and decoded both the supplied Imperial
template and the older Corellian guildhall (STOT/0007, SHOT/0008), including their
four-base inheritance chains, footprint dimensions, and slot arrangement. The
Corellian template is a regression input only; it is not a geometry replacement.
Local reports, extracted validation inputs, and the harness are under ignored
`scratch/nge-reader-check/`.

This is isolated reader validation. It does not exercise Core3's full runtime,
Lua inheritance overrides, archive selection, server/client building behavior,
or the missing Imperial geometry. Debian compilation and the actual Google Test
suite remain to be run. Reconfigure the existing CMake build so it discovers the
new test file, enable `COMPILE_TESTS`, build normally, and run from `MMOCoreORB/bin`:

```sh
./core3 runUnitTests --gtest_filter='StructureAssetTest.*:BuildoutDataTest.*:NgeTerrainTest.*:BasicTerrainTest.*'
```

When the exact POB becomes available, follow its actual cell appearance and floor
references recursively, verify their version dispatch and payload layouts against
the source, then test collision, interior cell creation, door transforms, portal
connectivity, pathfinding, and matching geometry in the new client. The server
must receive those files through its existing asset loader before runtime use.
