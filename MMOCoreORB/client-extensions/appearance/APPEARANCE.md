# Appearance client prototype, release version 10

The client caches several cosmetic sources and their covered real equipment IDs.
Sources retain the accepted yellow inventory highlight; real equipment retains
its standard equipped highlight. Ordinary equipment uses the supplied UI color.
Control markers are consumed without applying engine containment. Normal
containment arguments and all four Direct3D exports continue to the existing
post-processing extension unchanged.

Install only in **C:/Stardust-DEV**, with clients closed. The installer protects
C:/Stardust, validates the exact executable and known proxy hashes, preserves
`d3d9-appearance-base.dll` and external developer backups, and verifies the
post-processing INI after installation. `install.ps1 -Mode Restore` restores the
original DLL from the verified backup under client-tools/deployment-backups/Stardust-DEV. Source in this folder is authoritative;
older copies under ignored client-tools/ and MMOCoreORB/tools/ are historical.

## Server requirement

Build the accompanying CreatureObject IDL/C++ changes on Debian. On the isolated
server, retain this in the active `conf/config-local.lua`:

```lua
Core3.AppearanceEquipment = Core3.AppearanceEquipment or {}
Core3.AppearanceEquipment.ClientStateMarkers = true
```

Both test clients must use release version 10 before testing several selections. The
option defaults false and is not negotiated with each client. Version 6/7 replaces
its single cached pair on each source marker; unpatched clients treat control
records as real containment. Public distribution is handled by the user, including the updated wearer DLL.

The server sends an owner reset (0x7fff0100), then a source (0x7fff0101) followed
by its targets (0x7fff0102; destination is the owner). Reset/replay handles removal,
equipment changes and reloads. Cache limits are 64 sources and 256 targets, matched
by server validation. A duplicate target cannot be claimed by a different source.
Only IDs are retained; the inventory parent classifier resolves the owner live.

## Build and tests

Use an x86 Windows compiler, with warnings treated as errors:

```text
i686-w64-mingw32-clang -shared -O2 -Wall -Wextra -Werror -Wno-unused-parameter appearance_probe.c appearance_probe.def -lbcrypt -o d3d9.dll
i686-w64-mingw32-clang -O2 -Wall -Wextra -Werror -Wno-unused-parameter abi_test.c -lbcrypt -o abi-test.exe
```

Run `abi-test.exe` in a writable diagnostics directory. Assertions cover normal
color, multiple cosmetic sources and targets, independent reset/replay, duplicate
markers, bounded caches, invalid-pointer fallback and unchanged containment ABI.

Run `tests/test-projection.ps1 -Compiler <path-to-clang++.exe>` for the real
WearablesDeltaVector header against isolated engine stand-ins. This exercises
wire projection and protection-map preservation; it does not compile the server
against Engine3. The full Debian build and in-game tests remain required.

The built release DLL SHA256 is
`CF843206F23B2BE3DFE235BA0B5B18E4F0C6B1110432C51A634E38FFA9908BF4`.
A rebuild can change the binary hash; update the installer pin only after validating
that build. See ../../doc/appearance-equipment-prototype.md for runtime checks.

## Release cleanup

The default build sets APPEARANCE_DIAGNOSTICS=0. Only the color, containment,
and inventory parent hooks are installed; four wearable diagnostic hooks are
omitted. Inventory template inspection, per-item/per-frame logs and diagnostic
counters are compiled out. appearance-client.log records one startup installed
or rejected status per process. Build with -DAPPEARANCE_DIAGNOSTICS=1 only for
local investigation; diagnostics are not a runtime dependency.

The DEV installation preserves the tested original post-processing DLL and INI
byte-for-byte. Old snapshots and captured logs have been archived outside the
client under client-tools/deployment-backups/Stardust-DEV/archive-before-release-v9.
The installer now keeps its rollback copies outside the deployment as well.
See DISTRIBUTION.md for the exact runtime files and package.

## Inventory volume correction (version 10)

Version 9's visual containment counted hidden armor as inventory contents and
removed the cosmetic's volume from its real bag. Five covered pieces therefore
changed 3/80 into 7/80. Version 10 neutralizes native volume charges for those
visual transfers. The cosmetic continues to count in its original server container,
and covered real gear continues to consume no inventory volume.

The server now brackets each owner visual transaction with markers 0x7fff0103
(begin) and 0x7fff0104 (end), around the existing reset/source/target messages.
Accounting records survive reset during restoration and are pruned at end.
Recalculation excludes covered targets and includes the source in its original
container, including bag/ancestor volumes. Original bags are recalculated after
cleanup so moving/removing a source does not leave an extra charged slot.
Actual object volume attributes, native inventory limits and server inventory
accounting remain unchanged. The patch changes five verified call/instruction
sites within client VolumeContainer accounting, alongside the existing three
appearance hooks. Diagnostic builds additionally install four tracing hooks.

Build the matching CreatureObjectImplementation.cpp update on Debian before
in-game verification. No IDL regeneration or database migration is needed for
this fix. Wearers must use version 10 with the updated server markers; observers
receive no control markers. A version-10 client against the previous server
keeps its previous behavior rather than applying partial volume accounting.

`volume_test.c` exercises the real helpers/adapters with synthetic native objects:
3/80 and 80/80, five covered items, nested bag and parent totals, simultaneous
appearances and independent removal, recalculation, repeated cycles, moved-source
cleanup, and old-server fallback. Ordinary items still cost their original volume.
Compile/run like abi_test.c; no game client is launched by the tests.

The version-10 package remains a rollback candidate. Its capacity correction
is retained in version 11 and still requires real-client verification.

## Hide Backpack (version 11)

Equipped wearable containers offer Hide Backpack (222) and Show Backpack (223).
The selection is stored as container IDs on the player, restored before CREO6,
and cleared when that bag is unequipped or fails ownership/equipment validation.
Other players' bags and unequipped bags cannot be toggled. Existing characters
default to visible. No database schema or Engine3 change is involved.

Observers omit hidden containers from the projected wearables and slotted-object
creation. An already known observer object receives a visual inventory link to
detach it; Show restores its genuine equipment link and projected list entry.
The owner's backpack never receives a fake containment link. Opening, contents,
skill mods, inventory volume and equipped highlighting use its genuine state.

Owner-only marker 0x7fff0107 resets the hidden-container snapshot; 0x7fff0105
adds a hidden container ID with its wearer ID. These are separate from cosmetic
volume transactions. The client invalidates the wearer's skeletal mesh and skips
the matching worn child's mesh collection at the verified recursive call
0x7cae5e -> 0x7cadc0. The saved parent appearance is EBP-4, the child object is
EAX, and the two native arguments are a mesh accumulator and LOD index. Skipping
this call leaves the real object, container hierarchy and inventory icon intact.
The native dirty method is 0x7cb440. Exact executable identity and hook bytes are
checked before installation. No raw game-object pointers are cached.

The related [SkeletalAppearance2 source](https://github.com/SWG-Source/client-tools/blob/master/src/engine/client/library/clientSkeletalAnimation/src/shared/appearance/SkeletalAppearance2.cpp)
helped distinguish hardpoint attachments from worn skeletal meshes; the Stardust
addresses and calling convention were checked against its own executable.

Release builds now use nine hooks; diagnostic builds use thirteen. The matching
version-11 client is required for wearers because earlier DLLs do not consume
the backpack markers. Existing unpatched observer clients use server projection.
Compile the changed CreatureObject.idl and C++ on Debian with generated interfaces
refreshed by the normal build, then restart. Keep ClientStateMarkers enabled.

backpack_test.c verifies the native stack adapter, hide/show mesh filtering,
owner isolation, duplicate/reset markers and cache bounds. It also verifies that
markers do not call native containment or populate volume accounting. Existing
appearance ABI, volume and projection tests remain required. These tests use
stand-ins; they do not establish actual client rendering or server compilation.

Before distribution, test a loaded backpack from wearer and observer, including
hide/show, normal highlighting, opening and moving contents, full inventory,
clothing appearances sourced inside the hidden bag, zoning, relog and server
restart. Unequip/re-equip should restore the default visible state. Version 11 is
a test candidate until that sequence passes.
