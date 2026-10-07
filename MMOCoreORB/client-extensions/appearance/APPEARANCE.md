# Appearance client prototype, release version 9

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

Both test clients must use release version 9 before testing several selections. The
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
`CA94D80303688D9E1C7D5B24D6BE8E442FC1D27A1751EE3C41AD03FA796763B8`.
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
