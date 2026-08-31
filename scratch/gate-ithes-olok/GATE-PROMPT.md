You are the verification gate. Read-only. Do not edit any file.

Produce a SHORT report (under 150 lines). End with exactly one line:
VERDICT: ACCEPT   or   VERDICT: REJECT
followed by a line `EXIT:0` (accept) or `EXIT:1` (reject).

## What this is

A SWGEmu Core3 Lua conversation tree AND its handler were drafted by an outside
model. They are NOT in the source tree. Decide whether they are faithful and
correct enough to install.

CANDIDATES (the things under review):
  scratch/gate-ithes-olok/som_cube_ithes_olok.CANDIDATE.lua
  scratch/gate-ithes-olok/cube_ithes_olok_conv_handler.CANDIDATE.lua

Intended install paths (currently DO NOT EXIST — do not create them):
  MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_cube_ithes_olok.lua
  MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/cube_ithes_olok_conv_handler.lua

## Ground truth — all inside this repo

1. THE SHIPPED STRING TABLE (the ONLY legal source of dialogue text)
   scratch/gate-ithes-olok/som_cube_ithes_olok.stf.dump.txt
   A dump of string/en/conversation/som_cube_ithes_olok.stf, `key => value`.
   105 keys. NOTE: s_2 has an empty value and was never offered to the drafting
   model. `do_not_edit` is the SOE generator banner, not dialogue.

2. THE SCREENPLAY (already in the tree, already loads, DO NOT judge it)
   MMOCoreORB/bin/scripts/screenplays/mustafar/quest/jenha_tar_cube.lua
   Read `getStage`, `canGrantQuest`, `grantQuest`, `signalReturnNotes`,
   `reportProgress`, `awardQuest`, `isComplete`, and the `repeatable` field.

3. HOUSE STYLE — the siblings these must resemble
   MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_glyph_hunt.lua
   MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_storm_lord_jural.lua
   MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/glyph_hunt_conv_handler.lua
   and the thirteen handlers in screenplays/mustafar/quest/conversation/

## The governing project rule

**Live-faithful. Invent nothing.** Every line of dialogue must reference a row that
actually exists in the shipped table. Inventing dialogue, or importing text from
another emulator project's reconstruction, is a REJECT.

## What I already verified mechanically — RE-CHECK, do not assume

I ran these myself and got a clean result. Contradict me if I am wrong; a false
pass from me is worse than a slow gate.
  - 101 distinct s_NN referenced, every one present in the dump, none invented.
  - Every trailing `--` English comment matches the dump value for its key
    (108 comment lines checked, 0 mismatches).
  - 51 screens defined, no dangling targets, no orphans, no duplicate ids.
  - No row is used as BOTH a leftDialog and an option (51 NPC / 50 player, disjoint).
  - All 5 screenplay methods called (getStage, canGrantQuest, grantQuest,
    reportProgress, signalReturnNotes) exist on somJenhaTarCubeScreenPlay.
  - addConversationTemplate is the tree file's last statement.
  - Both files pass `luac5.3 -p`.
  - Unplaced rows: s_2 (empty, never offered), s_130 and s_192 (both declared in
    ROWS NOT PLACED with reasoning).

So spend your effort on the JUDGEMENT calls below, which no script can check.

## Checks, in priority order

**G1 — SPEAKER DIRECTION (fatal if wrong).** A `leftDialog` is spoken by ITHES
OLOK, an elderly scholar ("I'm no spry hatchling anymore", s_110) researching the
Chu-Gon Dar cube. An entry in `options` is spoken by THE PLAYER. Read every screen
and flag any row on the wrong side. Pay special attention to:
  - s_188 and s_208 are both the single word "Good." Decide whose mouth that is on
    each screen it appears, and whether the candidate agrees.
  - s_166 is the single word "No." — decide whether that is the player answering
    "have you heard of Chu-Gon Dar?" or Ithes saying it.
  - The five identical "Sorry, I've got to go." rows (s_135, s_149, s_154, s_158,
    s_162, s_170, s_174, s_182) and the five identical "Does this not interest you?"
    rows (s_139, s_152, s_156, s_160, s_164, s_172). These pair up; a mis-pairing
    here is the likeliest defect in the file.

**G2 — STAGE GATING.** Stages are 0 (not started), 1 (find ruins), 2 (copy three
tablets), 3 (return to Olok), 4 (finished). Verify in jenha_tar_cube.lua yourself:
`repeatable` is false and `awardQuest` sets stage 4 and increments `runs`, so
stage 4 is a PERMANENT resting state and canGrantQuest can never be true again.
  - getInitialScreen must send the player somewhere sensible for each of stages 0-4.
  - The hand-in (signalReturnNotes) must be offered ONLY at stage 3, where the
    signal will succeed. Flag any path that offers it at stages 1, 2 or 4.
  - grantQuest must only be reachable from stage 0.
  - **SECOND PASS — this is the one that matters.** A prior run of this gate
    correctly rejected the candidate: the stage-4 lost-cube branch had Olok say
    "I suppose I can let you have another" (s_194) while no code gave a cube.
    That has now been fixed, and the fix is IN SCOPE for you to judge:
      * `jenha_tar_cube.lua` gained `hasCube` and `replaceCube`. I wrote these,
        not the drafting model. Judge them as harshly as the rest.
      * The handler gained a `lost_cube` case calling `replaceCube`.
    Verify: `replaceCube` cannot fire outside stage 4; it hands over ONLY
    `rewardItems[1]` (the cube) and never the three loot payout items; `hasCube`
    reads the player's inventory correctly and cannot throw on a nil item or an
    empty inventory; the container index base is right (`getContainerObject` is
    0-based, the loop is 1-based — check the off-by-one myself is wrong or right).
  - `hasCube` deliberately scans ONLY the base inventory and does NOT recurse into
    backpacks or other containers. That is intentional and is NOT a finding: the
    live server did a base inventory check, which is why players could stash the
    cube in a backpack and get a second one. This project restores what shipped.
    Do not report the non-recursion, and do not report the resulting duplicate-cube
    path, as defects. DO report it if the code fails to match that description.

**G3 — PAIRING LOGIC.** The header comment claims a spine and justifies the
non-obvious pairings. The table contains several NEAR-DUPLICATE pairs that differ by
one comma or one word — s_46/s_203, s_44/s_199, s_101/s_103, s_104/s_105,
s_54/s_180, s_58/s_168, s_144/s_200, s_141/s_198, s_142/s_202, s_143/s_204.
The header claims each pair sits on a different branch. Are those claims actually
supported by the text of the rows, or is any of it asserted without evidence?
Quote any claim you think is unsupported.

**G4 — PROVENANCE.** Does either file cite another emulator project, wiki, or a
recorded playthrough as authority? That is a defect on its own. (I grepped and found
none, but check the reasoning too — an uncited claim that could only come from
outside the table is the same problem.)

**G5 — HOUSE STYLE.** Tabs not spaces; `templateType = "Lua"`; luaClassHandler name
matches the handler global actually defined (`cube_ithes_olok_conv_handler`);
`stopConversation` is the string "true"/"false"; the handler returns `pClonedScreen`
like its siblings do; screens whose options are stage-dependent declare
`options = {}` and let the handler fill them.

## Known and already accepted — do NOT report these as findings

- `clonedConversation` is assigned and used only on one branch in the handler. The
  sibling handlers do the same. Advisory at most.
- The handler wraps `grantQuest` in an `if canGrantQuest` even though `grantQuest`
  self-guards. Redundant, not wrong.
- ROWS NOT PLACED containing s_130 and s_192 is expected, not a finding, unless you
  believe the stated reasoning is factually wrong.

## Reporting rules

- Cite file:line for every finding.
- Distinguish FATAL (invented text, wrong speaker, hand-in at an impossible stage,
  wrong screenplay call, quest grantable twice) from ADVISORY (style, comment wording).
- If you could not check something, say "UNCHECKED" and why. Do not assert a check
  passed unless you actually performed it.
- REJECT if any FATAL is present. Otherwise ACCEPT, listing advisories.
