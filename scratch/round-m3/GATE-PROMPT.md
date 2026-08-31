# Gate — Stardust Round M3 (Mustafar runtime defects)

You are the verification seat. Repo root is your cwd: `C:\stardust-3-space-port\server`,
branch `mustafar-content`. Review four Lua changes, uncommitted, in the working tree.

## How to work

Use your shell to read — read-only commands only (`cat`, `sed -n`, `grep`, `ls`, `git diff`,
`git log`, `git show`). Do not run builds, tests, or servers; there is no build here and the game
server is not yours to start. Reading any file in this repo is expected and encouraged.

The staged diff of exactly the four files under review is at `scratch/round-m3/M3.diff`.
The coder brief that produced them is at `scratch/round-m3/BRIEF.md`.

## SCOPE — read this before you run `git status`

`git status` will show ~33 dirty files. **Only four are under review in this round:**

1. `MMOCoreORB/bin/scripts/managers/object/object_manager.lua`
2. `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/cursed_shard.lua`
3. `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/samaritan.lua`
4. `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/mining_field_markers.lua`

**Everything else dirty in this tree is prior work from Rounds M1 and M2. It was gated in its own
round and it is OUT OF SCOPE here. Do not review it, do not count it as an unexplained change, and
do not reject on its presence.** The full out-of-scope list, verbatim:

```
 M MMOCoreORB/bin/conf/config.lua
 M MMOCoreORB/bin/scripts/mobile/conversations.lua
 M MMOCoreORB/bin/scripts/mobile/custom_content/som/doc_lu.lua
 M MMOCoreORB/bin/scripts/mobile/custom_content/som/naboo_historian.lua
 M MMOCoreORB/bin/scripts/mobile/custom_content/som/npc_ithes_olok.lua
 M MMOCoreORB/bin/scripts/mobile/custom_content/som/reporter_jural.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/blackguard_problem.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/collectors_business.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/glyph_hunt.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/hidden_treasure.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/jedi_dog.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/jenha_tar_cube.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/lava_beetle_nests.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/maneater.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/reunite_shard.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/som_poison_miners.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/som_striking_miners.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/storm_lord.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/story_arc_prelude.lua
 M MMOCoreORB/bin/scripts/screenplays/mustafar/quest/symbiosis.lua
 M MMOCoreORB/bin/scripts/screenplays/screenplays.lua
?? MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_cube_ithes_olok.lua
?? MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_doctor_lu.lua
?? MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_glyph_hunt.lua
?? MMOCoreORB/bin/scripts/mobile/conversations/mustafar/som_storm_lord_jural.lua
?? MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/cube_ithes_olok_conv_handler.lua
?? MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/doctor_lu_conv_handler.lua
?? MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/glyph_hunt_conv_handler.lua
?? MMOCoreORB/bin/scripts/screenplays/mustafar/quest/conversation/storm_lord_jural_conv_handler.lua
?? scratch/
```

A dirty tree is the expected state of this round. The orchestrator commits, not you.

⚠ **CRLF noise.** Windows git here has `core.autocrlf=true` and the worktree files are LF, so git
emits "LF will be replaced by CRLF" warnings on nearly every file. That is an end-of-line artifact,
not a content change. If you think you see a file modified, confirm with
`git diff --ignore-space-at-eol -- <path>` before calling it.

## Project rules the fixes had to obey

- **Live-faithful. Invent nothing.** No new coordinate, NPC name, display string, or dialogue.
  A fix that would need one must be reported, not written.
- Lua only. Never C++, `.tre`, `snapshot/*.ws`, `conf/`, `quests.iff`, `quest_manager.lua`.
- Additive where possible. No deletions of files.

## The four fixes and the evidence behind each

### F1 — `managers/object/object_manager.lua`

Claimed defect: the file defined the global wrapper constructors (`Object`, `SceneObject`,
`CreatureObject`, `AiAgent`, …) and ended at line 317 with a function `end` and **no `return`**.
It defined no `ObjectManager` table. 264 files do
`local ObjectManager = require("managers.object.object_manager")`, so all 264 bound the boolean
`true`. 262 never call a method. Two do, and threw "attempt to index a boolean value" at runtime:
`screenplays/mustafar/boundaries/mustafar_boundaries.lua` (47 sites) and
`screenplays/cities/hutta_bilbousa_city.lua` (1 site).

Claimed impact: every Mustafar world-boundary teleport handler threw, so nothing pushed a player
back inside the playable area.

Claim to check: `ObjectManager.withCreatureObject` is the **only** `ObjectManager.*` API used
anywhere in `MMOCoreORB/bin/scripts` — asserted as exactly 48 hits, all the same name.

Fix: appended an `ObjectManager` table with `withCreatureObject` and a `return ObjectManager`.
`ObjectManager` is deliberately a **global**, matching how `Object` and the constructors are
declared in the same file, so the 262 requirers that read it as a global still work.

### F2 — `screenplays/mustafar/quest/cursed_shard.lua`

Claimed defect — an unrecoverable player strand. `notifyEnteredEventArea` set the area's
persistent flag, then scheduled `springAmbush` on a 5–20 s `createEvent`. `springAmbush` bails at
the top when `isPresent` is false, and `isPresent` (`:403-411`) is false when the player is offline
**or** off Mustafar. The brood gate was the **last thing in that same function**. `startBrood` had
exactly one call site and the file has no `LOGGEDIN` observer and no resume hook. So a player who
logged out or zoned off Mustafar during the delay on the **second** area kept both flags, never
reached `startBrood`, and no other path could advance him out of `STAGE_SHARD`.

Fix: the gate is extracted to `checkBroodGate`, given a `not hasFlag("brood")` term; `startBrood`
sets that persistent flag first and returns early if already set; and `notifyEnteredEventArea`
calls `checkBroodGate` at the top, guarded by `isPresent`.

### F3 — `screenplays/mustafar/quest/samaritan.lua`

Claimed defect — a timer stack that disarms the fight it belongs to. `giveCrystal` is deliberately
re-callable (its own comment says the second call only re-aggros), but the aggro block runs
unconditionally on every call, arming one `calmQuestGiver` event per hail on the same shared world
NPC. The earliest arm fires mid-fight and clears `AGGRESSIVE`, broadcasts, and
`clearCombatState(true)` on an NPC the player is still fighting.

Fix: `calmQuestGiver` returns early when `AiAgent(pNpc):isInCombat()`.
`AiAgent(p):isInCombat()` is an existing binding used by shipped stock screenplays —
`screenplays/cities/city.lua:265`, `screenplays/crackdown/cantina.lua:304` and `:566`.

There is no cancel primitive for a queued `createEvent` in this engine, so the queued arms cannot
be revoked; the fix makes each arm a no-op instead.

### F4 — `screenplays/mustafar/quest/mining_field_markers.lua`

Claimed defect — a once-per-player guard that did not survive a restart. `grantCompletionReward`
guarded itself with `readData`/`writeData`. `screenplays/screenplay.lua:5` and `:21` route
`writeData`/`readData` to `writeSharedMemory`/`readSharedMemory` — `DirectorSharedMemory`, in-memory
and lost on restart. The comment claimed "once and only once per player", which was false across a
restart. Siblings use the persistent store for exactly this: `samaritan.lua:617`,
`moral_choice.lua:577`.

Fix: the guard moved to `readScreenPlayData`/`writeScreenPlayData`, the rollback on a full pack
moved to `deleteScreenPlayData` on the same key, and the false comment was corrected.
`readScreenPlayData` returns `""` for an unwritten key, so the `tonumber(...)` wrapper is
load-bearing — `tonumber("")` is `nil`, which compares false against `1`.

## Already decided — do not re-litigate these

- **`mining_field_markers.lua:411`, the `surveyor_jo` spawn, is deliberately NOT touched.** Its
  coordinate is a known open question with two mutually incompatible readings and no source that
  settles it. Under "invent nothing" it is flagged for the human, not fixed. Out of scope.
- **The prose edit in `cursed_shard.lua:117-124` (the REWARD header) is out of the coder's brief
  but is KEPT, and the orchestrator verified both of its factual claims first-hand:**
  - The key `item_tow_gloves_microsensory_02_01` **does** exist in `string/en/static_item_n.stf`,
    resolving to "Microsensory Mesh Gloves". Confirmed in six shipped archives
    (`mtg_patch_013_configurable_02`, `mtg_patch_019`, `mtg_patch_022`, `mtg_planets`,
    `stardust_02`, `stardust_03`). The prose it replaced said "no string/en STF row", which was
    **false**.
  - No object template exists for it. A sweep of every path in every shipped `.tre` for
    `tow_gloves` or `microsensory` returned **zero** hits, and the repo's `scripts/object/` and
    `scripts/custom_content/` trees have zero mentions.
  - The substitute it names, `object/tangible/tcg/series8/shared_wearable_exogorth_gloves.iff`,
    **does** ship, in `mtg_patch_022.tre`.
  You cannot re-run those sweeps — the `.tre` archives are outside this repo. Take them as given.
- All 33 dirty `.lua` files, including these four, **parse clean** under `luac5.3 -p`. Verified
  after the last edit. You do not need to re-check syntax.

## What I want from you

For each of F1–F4, in order:

1. **Is the stated defect real?** Read the pre-change code (`git show HEAD:<path>`) and say so from
   the source, not from my description. If my description of a defect is wrong, say that plainly —
   a wrong premise is the most valuable thing you can find here.
2. **Does the fix actually fix it?** Name what a **reverted** build would fail on. If the answer is
   "nothing observable", the fix is not done.
3. **What does the fix break?** Every new call path, every changed data lifetime, every caller that
   now sees different behaviour. Be specific: file and line.

Then these five, which are the ones I am least sure of:

- **F1 globals.** Does introducing a global named `ObjectManager` collide with anything else in
  `MMOCoreORB/bin/scripts`? And does adding a `return` value change behaviour for any of the other
  262 requirers — including the Lua module cache, and including any file that tests the require
  result for truthiness or type?
- **F1 coverage.** Verify the "only `withCreatureObject` is ever called" claim yourself. If any
  other `ObjectManager.*` member is referenced anywhere, name it — the shim would still throw.
- **F2 residual strand.** The catch-up only fires when the player re-enters an event area. Is there
  a path where a stranded player never re-enters one and stays stuck? If so, is there a better hook
  already available in this codebase (an observer, a `getStage` side effect like the one in
  `hidden_treasure.lua:205-220`, or a resume mechanism) that would close it without inventing
  content?
- **F2 flag namespace.** The new persistent flag is named `"brood"`. Confirm it does not collide
  with an existing key written by this screenplay or by anything else keyed on the same
  screenplay name.
- **F4 data lifetime.** `writeScreenPlayData` is persistent and `deleteScreenPlayData` is the
  rollback. Walk the full-inventory path: is there any ordering where the player both receives the
  item and clears the flag, or receives nothing and keeps it? And confirm `self.screenplayName` is
  the right key for this file.

## Report

Write your findings to `scratch/round-m3/terra-gate.md`. **Keep it short — under 150 lines.**
Do not append a session log.

Format: one section per fix, then one section for the five questions above, then a final line:

`VERDICT: ACCEPT` or `VERDICT: ACCEPT WITH FINDINGS` or `VERDICT: REJECT`

Severity-tag every finding `HIGH` / `MEDIUM` / `LOW`. If you cannot verify something, say
"unverified" and why — do not reject for lack of verification alone, and do not treat anything in
the out-of-scope list above as a finding.
