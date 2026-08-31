You are the verification gate. Read-only. Do not edit any file.

Produce a SHORT report (under 120 lines). End with exactly one line:
VERDICT: ACCEPT   or   VERDICT: REJECT
followed by a line `EXIT:0` (accept) or `EXIT:1` (reject).

## What this is

Fifteen SWGEmu Core3 Lua quest screenplays under
`MMOCoreORB/bin/scripts/screenplays/mustafar/quest/` had their REWARD header prose
corrected. The round is **prose-only except for one label change**; no reward grant
was added, removed or swapped.

The governing project rule is **Live-faithful. Invent nothing.** These header blocks
are this project's record of what shipped, so a false or overclaiming statement in
one is a FATAL, not a style note.

`git diff` shows the change. ⚠ Two caveats:
  - `blackguard_problem.lua`, `glyph_hunt.lua`, `storm_lord.lua` and
    `jenha_tar_cube.lua` also contain PRIOR uncommitted work (Round M1: quest-giver
    placement, `spawnGiver`, `hasCube`/`replaceCube`). That was already gated. **Judge
    only the REWARD / display-name prose in those four.**
  - `mobile/*`, `screenplays/screenplays.lua` and the untracked conversation trees and
    handlers are also prior work. Do not judge them.

## The defect that was fixed

The files justified their conclusions with a claim that is false:
*"There is no string/en/static_item_n.stf in _som to look it up in"* / *"no string/en
STF row"* / *"None of the four reward items has a display name anywhere."*

`static_item_n.stf` ships (1,052,886 bytes, `stardust_03.tre`, 9,754 keys) and all 20
reward tokens under `screenplays/mustafar/` resolve in it. The files described one
local extract and stated it as a fact about what shipped.

## The evidence, gathered firsthand by the orchestrator

`scratch/round-m2/EVIDENCE.md` has the full detail. The load-bearing facts:

  - An exhaustive sweep of **all 31,074 shipped `object/**/shared_*.iff` templates in
    every TRE** found an object carrying the wanted `objectName` for only **6** of the
    20 keys. For the other 14 there is no object.
  - `item_tow_trophey_02_01` = "Mounted Kubaza Beetle Head", and
    `shared_trophey_lava_beetle.iff` carries exactly that objectName.
  - `shared_trophey_tulrus_spine.iff` does **NOT** carry `item_tow_trophey_02_02`. Its
    objectName record has an EMPTY string table and the key `trophey_tulrus_spine_n`,
    which is in no shipped STF.
  - The two `object/tangible/collection/` hits are `SharedTangibleObjectTemplate`,
    `gameObjectType = 8211`, with no damage / attackSpeed / xpType / cert.

## What I already verified mechanically — RE-CHECK, do not assume

A false pass from me is worse than a slow gate. Contradict me if I am wrong.
  - All 15 edited files, plus `trophy_hunts.lua` and `historian.lua`, pass
    `/usr/bin/luac5.3 -p` (Lua 5.3.3). Re-run it if you can; if your policy blocks
    executing it, say UNCHECKED rather than asserting either way.
  - `git status --porcelain` shows only the 15 files plus prior-work files.

## Checks, in priority order

**G1 — CONCLUSIONS MUST NOT HAVE MOVED (fatal if wrong).** Exactly ONE conclusion may
change in this round: `lava_beetle_nests.lua` goes SUBSTITUTED → RESOLVED. Every other
file's "NOT granted" / "substituted" conclusion must be **identical** to its HEAD
version. Confirm no other file quietly upgraded, downgraded, or reversed a conclusion,
and that no `rewardItem` / `rewardWeapon` / `giveItem` / `rewardCredits` value changed
anywhere. Diff the actual code lines, not just the prose.

**G2 — THE ONE CONTENT CHANGE.** In `lava_beetle_nests.lua`, verify the RESOLVED claim
is actually supported: `item_tow_trophey_02_01` → "Mounted Kubaza Beetle Head" →
`shared_trophey_lava_beetle.iff` objectName → registered server template
(`trophey_lava_beetle.lua:3`, `serverobjects.lua:15`) → and that the file already
granted `object/tangible/loot/mustafar/trophey_lava_beetle.iff` before this round.
If the grant itself changed, that is out of scope and FATAL.

**G3 — NO NEW OVERCLAIM.** The whole point of the round was that a claim about "the
extract" was passed off as a claim about what shipped. Confirm the *replacement* prose
does not commit a fresh version of the same sin. In particular:
  - Does any file now assert an item is unobtainable more strongly than the sweep
    supports?
  - `maneater.lua` must still read as SUBSTITUTED/OPEN, and its new reasoning (wanted
    item has a name but no object; substitute has an object but no resolvable name)
    must match the evidence above.
  - `som_poison_miners.lua` and `symbiosis.lua` must state that an exact-named object
    DOES ship, that it is a non-functional display tangible, and that the swap is an
    **open decision for Aaron that was not taken**. Neither may imply the swap was
    made or was rejected on the merits.

**G4 — THE `jenha_tar_cube.lua` DISPLAY NAMES.** Its four reward items are not tow
items. The header now claims they resolve via `string/en/som/som_cube.stf` to
"Chu-Gon Dar Cube", "a barely glowing old cup", "a barely glowing datapad", "a barely
glowing worklight". Two edits here were made by the orchestrator, not the coder — check
them the hardest. Confirm the claim is coherent with each object's shared template
naming table `som/som_cube`, and that the matching comment above `giveReward` agrees
with the header.

**G5 — LOST FACTS.** Compare each edited header against its HEAD version. Flag anything
TRUE that was dropped rather than corrected — especially the `pistol_dl44` blue-frog
reasoning in `som_poison_miners.lua` (the 99999999998 damage placeholder refusal), the
`addRewardedSchematic` fails-closed note in both weapon files, and the `cube_loot`
`cube/loot` mis-registration finding in `jenha_tar_cube.lua`. A dropped true fact is a
FATAL.

**G6 — SCOPE.** Confirm the round added no reward grant, no `quests.iff` row, no
`quest_manager.lua` id, no `spatialChat`, no creature-template edit, no C++ / `.tre` /
`snapshot` edit, and did NOT touch `trophy_hunts.lua` (it was already correct).

## Reporting rules

- Cite file:line for every finding.
- Distinguish FATAL (a moved conclusion, a changed grant, a fresh overclaim, a dropped
  true fact, an out-of-scope edit) from ADVISORY (wording, formatting).
- If you could not check something, say "UNCHECKED" and why. Do not assert a check
  passed unless you actually performed it.
- REJECT if any FATAL is present. Otherwise ACCEPT, listing advisories.
