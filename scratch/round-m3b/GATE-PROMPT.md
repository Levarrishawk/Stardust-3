# Gate — Stardust Round M3b (delta round)

You are the verification seat. cwd is the repo root: `C:\stardust-3-space-port\server`,
branch `mustafar-content`. This is a **small delta round**: three edits, two of which close
findings you raised in the previous round.

## How to work

Use your shell to read — read-only commands only. Prefer plain `cat`, `sed -n`, `grep -n`, `ls`,
`git diff`, `git show`. **Avoid `powershell.exe -Command ...` wrappers**; the previous round had a
dozen of those rejected by policy and it cost you reads. Do not run builds, tests, or servers.
Reading any file in this repo is expected.

## What changed for M3b

**1. `cursed_shard.lua` — closes your HIGH finding "F2 residual strand".**
You wrote: *"A player who returns to Mustafar but never re-enters either 300 m ambush area remains
at STAGE_SHARD with both flags forever. `getStage` is already a suitable reconciliation hook in
this file."* That is exactly what was done:
- `getStage` (now `:339-359`) gains a `STAGE_SHARD` branch that calls `checkBroodGate` and then
  returns `rawStage`, in the same shape as the existing `STAGE_BROOD` branch above it.
- The now-redundant explicit catch-up block M3 had added at the top of `notifyEnteredEventArea`
  was **removed** — `:450` in that same function already calls `getStage` on the next statement.
- The block comment at `:333-338` gained one sentence.

Deliberately **not** gated on `isPresent`, because `startBrood` (`:524`) touches no client API —
it only writes screenplay data and calls `createEvent` — and `endBrood` handles the offline case
itself at `:554-556`. Gating it would have excluded the offline players the fix exists to rescue.
Confirm that reasoning holds.

**2. `samaritan.lua` — closes your MEDIUM finding "permanently aggressive".**
You wrote: *"there is no reschedule after combat ends; 'a later arm' is not guaranteed."*
`calmQuestGiver:581-584` now re-arms itself on the same `self.calmSeconds` interval instead of
returning bare, and the comment was corrected.

**3. `object_manager.lua` — comment only, closes your LOW finding.**
You wrote that `hutta_bilbousa_city.lua:669` is inside a `--[[ ]]` block and cannot throw. Verified
first-hand: the block opens at `:649` and closes at `:683`. The shim's comment at `:320-323` was
corrected from "48 call sites" to distinguish the 47 live sites from the 1 commented one. **No
code changed in this file.**

## SCOPE

Review **only** these three files, and within them only the regions described above:

1. `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/cursed_shard.lua`
2. `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/samaritan.lua`
3. `MMOCoreORB/bin/scripts/managers/object/object_manager.lua`

`git status` shows ~33 dirty files. **All the others are prior work from Rounds M1, M2 and M3.
They are out of scope. Do not review them, do not count them as unexplained changes, and do not
reject on their presence.** A dirty tree is the expected state; the orchestrator commits, not you.

⚠ Windows git here has `core.autocrlf=true` against an LF worktree, so it emits "LF will be
replaced by CRLF" warnings almost everywhere. That is an end-of-line artifact, not a content
change. Confirm with `git diff --ignore-space-at-eol -- <path>` before calling anything modified.

## Already settled — do not re-litigate

- All 33 dirty `.lua` files parse clean under `luac5.3 -p`, re-verified after these three edits.
  Syntax is not your job here.
- Your other M3 findings were accepted as-written and are **not** addressed in this round, by
  choice: **E2** (`giveItem` can fail after the `isContainerFullRecursive` check and its return is
  discarded) is latent — `completionItem` is `nil` at `mining_field_markers.lua:99`, so the branch
  is dead — and is being carried to the human as a flagged item rather than fixed blind.
  **C5** (the `"brood"` flag is never cleared, so a GM stage reset would wedge it) is likewise
  carried, not fixed. Note them if you like, but they are known and deliberate.
- `mining_field_markers.lua:411` (`surveyor_jo`'s coordinate) remains deliberately untouched —
  unsourceable, and under "invent nothing" it is flagged for the human, not guessed.

## What I want

For each of the three edits:

1. **Does it actually close the finding you raised?** Name what a build with the M3b change
   reverted would now fail on. If the answer is "nothing observable", say so.
2. **What does it break?** Specifically for edit 1, I want these four checked:
   - **Recursion.** `getStage` now calls `checkBroodGate` → `startBrood`. Confirm nothing in that
     path calls `getStage` again. `checkBroodGate` should read `rawStage`, and `startBrood` should
     write via `setStage`.
   - **Re-entrancy / cost.** `getStage` is called from six sites in this file plus
     `menth_paul_conv_handler.lua:59` and `cursed_shard_sucker_conv_handler.lua:58`. It is now a
     *mutating* read for any player at `STAGE_SHARD`. Is there any caller for which a stage read
     having a side effect is wrong — a status query, a UI refresh, a loop, anything called at high
     frequency?
   - **The removal.** Confirm deleting the explicit catch-up from `notifyEnteredEventArea` loses
     nothing: does `:450` reach `getStage` on every path the removed block would have run on?
   - **Offline safety.** Confirm `startBrood` really is client-API-free, so running it for an
     absent player is harmless and `endBrood` picks up the flavour later.
3. For edit 2: does the retry chain terminate in every case — NPC killed, NPC despawned, NPC
   destroyed, server restart, combat never ending? Is one event per 300 s on one NPC an acceptable
   cost? And can the chain now double up — one arm from `giveCrystal` plus one from a retry —
   and does that matter?

## Report

**Print your findings directly in your final message. Do not try to write a file — this session is
read-only and the previous round wasted its last turn discovering that.**

Keep it under 80 lines. One short section per edit, then a final line:

`VERDICT: ACCEPT` or `VERDICT: ACCEPT WITH FINDINGS` or `VERDICT: REJECT`

Tag findings `HIGH` / `MEDIUM` / `LOW`. If you cannot verify something, say "unverified" and why —
do not reject for lack of verification alone.
