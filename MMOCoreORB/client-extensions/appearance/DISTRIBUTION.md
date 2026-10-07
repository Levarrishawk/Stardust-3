# Appearance release deployment

C:/Stardust-DEV now contains the quiet release module. The public client folder
C:/Stardust was not changed. Version 10 also requires the matching server visual transaction begin/end
messages. Server gameplay, real inventory limits and serialization are unchanged.

## Runtime files

Place these together beside the tested Stardust.exe:

| File | Purpose |
| --- | --- |
| d3d9.dll | Appearance inventory state/color hooks and graphics forwarding |
| d3d9-appearance-base.dll | Unmodified existing post-processing extension; required |
| d3d9-postfx.ini | Tested post-processing configuration |

The active post-processing DLL and configuration retain their original hashes.
The included INI supplies tested defaults; an existing player's post-processing
configuration can be retained. No executable, TRE, UI resource or other game
asset was modified by this cleanup.

The user manages public distribution. A local package is prepared at:
client-tools/appearance-release-v10/stardust-appearance-update.zip
Its entries are exactly the three runtime files above, with no logs, test
binaries, backups or developer installer. SHA256.json beside the ZIP lists
per-file hashes. The client-tools directory remains ignored by Git.

## Developer maintenance

The native source, tests and installer remain in this repository folder.
Installation/restore requires clients closed. Rollback files are now outside
Stardust-DEV at client-tools/deployment-backups/Stardust-DEV/; use install.ps1
-Mode Restore to restore the verified original proxy. The previously tested v8
appearance DLL is also retained there as d3d9-tested-v8.dll.

Both release and diagnostic ABI tests passed, including several sources and
covered targets, independent reset/replay, ordinary-color fallback, cache bounds
and unchanged containment forwarding. Four-export graphics forwarding and
executable-mismatch rejection passed. Version 10 needs real-client capacity verification at 3/80 and nearly/full 80/80
before distribution, after building/restarting the matching server update.

The appearance module writes one startup status to appearance-client.log.
Existing post-processing logging remains unchanged. Runtime-generated logs and
character/profile files do not belong in the appearance update package.
