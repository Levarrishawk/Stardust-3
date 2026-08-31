You are the verification gate. Read-only. Do not edit any file.

Produce a SHORT report (under 150 lines). End with exactly one line:
VERDICT: ACCEPT   or   VERDICT: REJECT
followed by a line `EXIT:0` (accept) or `EXIT:1` (reject).

## What this is

Four SWGEmu Core3 Lua quest screenplays were edited to place their quest-giver NPCs in the
world. Until this change none of the four quests could be started, because the giver was
registered, conversationally wired, and spawned nowhere. Judge the change.

The four files under review (working tree, already edited):
  MMOCoreORB/bin/scripts/screenplays/mustafar/quest/jenha_tar_cube.lua
  MMOCoreORB/bin/scripts/screenplays/mustafar/quest/glyph_hunt.lua
  MMOCoreORB/bin/scripts/screenplays/mustafar/quest/blackguard_problem.lua
  MMOCoreORB/bin/scripts/screenplays/mustafar/quest/storm_lord.lua

`git diff` against HEAD shows the change. ⚠ Two caveats about that diff:
  - Other files in the diff (mobile/conversations.lua, screenplays.lua, the four
    mobile/custom_content/som/*.lua, and the untracked conversation trees and handlers) are
    PRIOR uncommitted work, not this round. Do not judge them.
  - Inside jenha_tar_cube.lua the diff ALSO contains `hasCube` and `replaceCube`, which are
    prior uncommitted work implementing a separate ruling. Not this round. Do not judge them.

## The governing project rule

**Live-faithful. Invent nothing.** A coordinate that cannot be sourced is an open question, not
an answer. The change is only acceptable if every number in it traces to shipped data or to a
stated, checkable derivation.

## The evidence the change rests on

**The Mustafar coordinate offset.** This server's Mustafar is a pure translation of the live
one: `shipped_x = way_x - 2880`, `shipped_z = way_z + 2976`. No scale, no rotation. It was
fixed by two shipped `.qst` waypoints and then confirmed by converting ten independent
landmarks from a 2006 live-era community walkthrough, each of which landed on the snapshot
object it names. Two of the four placements are community waypoints converted through it.

**The indoor placement.** Ithes Olok goes inside the on-map Mensix mining facility. From
`snapshot/mustafar.ws` (`stardust_03.tre`), read directly by the orchestrator:

```
building node 12112217  object/building/mustafar/structures/shared_must_new_mining_facility.iff
  world x=-2420.500  h=199.403  y=1767.080
  quaternion w=1.000000 x=0 y=0 z=0        (identity -> yaw 0 -> cell-local = world - origin)
  30 child cell nodes, contiguous EXCEPT for gaps at 12112233 and 12112239
  cell node 12112238 = cellIndex 20 = small_room_04
```

His `.qst` world position is `(-2444, 218, 1760)`. Subtracting the origin gives cell-local
`x=-23.50, y=-7.08`, height 18.597. The height used is **19.07** instead, taken from
`must_mining_facility.ilf`, where every floor-standing item in `small_room_04` sits at exactly
19.070; the subtraction undershoots the floor.

## What I already verified mechanically — RE-CHECK, do not assume

I ran these myself and got a clean result. Contradict me if I am wrong; a false pass from me is
worse than a slow gate.
  - All four files pass `luac5.3 -p`.
  - Only the four named files were edited; nothing else in the tree changed this round.
  - The four `conversationTemplate` values are already correct and were NOT touched:
    doc_lu.lua:40 `som_doctor_lu`, naboo_historian.lua:37 `som_glyph_hunt`,
    npc_ithes_olok.lua:37 `som_cube_ithes_olok`, reporter_jural.lua:37 `som_storm_lord_jural`.
    reporter_talper.lua:37 is `""` and must stay `""` — no tree ships for him.
  - The three tow reward items are still not granted; the `lootName` paragraphs were not
    touched this round.

Spend your effort on the JUDGEMENT calls below.

## Checks, in priority order

**G1 — ARGUMENT ORDER (fatal if wrong).** Core3's signature is
`spawnMobile(zone, template, respawnSeconds, x, z, y, heading, cellID)` where **`z` is the
HEIGHT and `y` is the second planar axis.** Read all five `spawnMobile` calls in the four
files and confirm each passes height in the third positional slot after the template's
respawn. This is the single easiest thing to get backwards and it would put NPCs underground
or kilometres away. Compare against the in-repo precedents:
  screenplays/mustafar/quest/historian.lua:309-318  (giver, outdoor+cell)
  screenplays/mustafar/quest/historian.lua:420-431  (getWorldFloor on a start() path)
  screenplays/mustafar/mensix/mensix_mining_facility_main.lua:58-68  (indoor, same building)

**G2 — THE INDOOR PLACEMENT.** Verify the cell is resolved by NAME
(`BuildingObject(pBuilding):getNamedCell("small_room_04")`) and not by node-id arithmetic.
The `buildingNodeID + N` rule is WRONG for this building because of the two gaps listed above,
and an earlier pass got it wrong that way. Confirm the code has no hardcoded cell node id.
Check the nil-handling: a missing building or a missing cell must fail loudly and must NOT
fall through to spawning the NPC at world origin or in cell 0.

**G3 — DERIVED VS SHIPPED, and whether the file says which is which.** Three different
provenance classes are in play and the header comments must not blur them:
  - `naboo_historian` at (-5791, 106, 5808) — fully shipped, straight out of the `.qst`.
  - `npc_ithes_olok` — shipped `.qst` position, but transformed, and with the height replaced
    from the ILF.
  - `doc_lu` (-4635, 3296) and `reporter_jural` (440, 5115) — community waypoints converted
    through the offset. Not shipped.
  - `reporter_talper` at (443, 5115) — **3 m east of Jural, and that 3 m is not sourced from
    anything.** It is the one invented number in the change.
Read the header blocks and the table comments. Does each placement state its own provenance
honestly, and is the unsourced 3 m called out as unsourced? An overclaim here is a FATAL, not
a style note — the headers are this project's record of what shipped.

**G4 — STALE CLAIMS.** Each of the four headers previously asserted things that are now false
("spawned NOWHERE in this tree", `conversationTemplate is ""`, "this file spawns nobody and
invents no position"). Confirm none of those survive anywhere in the four files. Separately,
`glyph_hunt.lua` previously carried an explicit ruling that the `.qst` waypoint "is NOT used to
spawn anything, because a waypoint target is not a placement". That ruling is now reversed.
Confirm the reversal is **recorded as a reversal** and not silently deleted.

**G5 — LOST FACTS.** Compare each header against its HEAD version. Flag anything true that was
dropped rather than corrected. Specifically check that the `quest_start` findings survived, and
that storm_lord's note about `storm_lord_region.lua` owning the valley's target placements
survived.

**G6 — BOOT SAFETY.** All five spawns run from `start()`. `getWorldFloor` is used for two of
them. Is that safe at screenplay-start time? `historian.lua:423` already does it on this planet
from a `start()`-driven path — confirm that precedent is real and that the new code matches it.
Also confirm every `start()` still guards on `isZoneEnabled("mustafar")`.

**G7 — SCOPE.** Confirm the round added no reward grant, no `quests.iff` row, no
`quest_manager.lua` id, no `spatialChat`, no mood string, no creature-template edit, and no
change to `miner_hens` or the trophy hunts. ⚠ `spatialChat` does not work in cells on this
build; a `spatialChat` added to the indoor giver would be a FATAL.

## Reporting rules

- Cite file:line for every finding.
- Distinguish FATAL (wrong argument order, hardcoded/wrong cell, silent fallback on a nil cell,
  a placement whose comment overclaims its provenance, a surviving false claim, a dropped true
  fact, out-of-scope edit) from ADVISORY (wording, formatting).
- If you could not check something, say "UNCHECKED" and why. Do not assert a check passed
  unless you actually performed it.
- REJECT if any FATAL is present. Otherwise ACCEPT, listing advisories.
