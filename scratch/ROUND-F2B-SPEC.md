# ROUND F2(b) — the Volcano Battlefield screenplay

Instruction file for the coding agent. Everything below is settled; nothing here is
an open question. Where a live mechanic cannot be ported, the omission is named and
the reason is given — **write the reason into the file header, do not invent a
stand-in.**

Source of truth for live behaviour: `scratch/LIVE-VOLCANO.md`. Read §1–§4 and §6.
Architectural template to mirror: `MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/valley_battlefield.lua`.
**Read that file in full before writing a line.** This screenplay is its sibling and
must look like it: same section banners, same session bookkeeping, same entry/exit,
same `createEvent` re-arm discipline, same comment voice (say what live does, then
say what this file does and why).

This is PART ONE of two. Part one builds the file through event three. Part two
(`ROUND-F2B-SPEC-2.md`) adds events four and five, the HK finale and the wiring.
Do not start part two.

---

## THE FILE

New: `MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/volcano_battlefield.lua`

Global name `VolcanoBattlefield`, `registerScreenPlay("VolcanoBattlefield", true)`.
Do NOT touch `screenplays.lua` yet — that is part two.

---

## 1. GEOMETRY — all coordinates are settled, use these exact numbers

The arena anchors at **(-292, -1680)** on the Mustafar ground zone, off-map in the
southern band, entered and left by teleport. That is the same model the valley uses
and the same model `mustafar_instances.lua` uses for the six SOE dungeon pools.

Live's controller sits at `647.941 74.7399 448.941`. The transform onto this zone is:

    repoX = liveX - 939.941
    repoY = liveZ - 2128.941

Live's `loc_y` (height) is dropped on every row. The whole live buildout has 0.62 m
of relief (LIVE-VOLCANO §6.1) and the repo band is dead flat at -5.00 m, so every
spawn ground-places with `getWorldFloor(x, y, "mustafar")`. Live `setYaw(deg)` maps
straight onto `spawnMobile`'s heading argument, which is already degrees.

Live offsets are `"X:Z"` strings added to the spawner's own location. Because the
transform is a pure translation on both axes, an offset `(dx, dz)` becomes `(dx, dz)`
added to `(x, y)` here. **No sign flips. No axis swap in the offsets.**

### Fixed points (put these in the screenplay table)

| what | live (x, z) | **repo (x, y)** | volume radius |
|---|---|---|---|
| controller / anchor | 647.941, 448.941 | **-292.000, -1680.000** | — |
| `zoneIn` (entry) | 389.646, 648.353 | **-550.295, -1480.588** | — |
| event one | 395.032, 517.445 | **-544.909, -1611.496** | 45 |
| event two | 452.530, 405.987 | **-487.411, -1722.954** | 45 |
| event three | 536.664, 556.382 | **-403.277, -1572.559** | 45 |
| event four | 529.992, 693.472 | **-409.949, -1435.469** | 45 |
| event five | 633.054, 662.052 | **-306.887, -1466.889** | 45 |
| hk_final | 635.000, 414.000 | **-304.941, -1714.941** | 95 |
| YT landing site | 679.541, 451.141 | **-260.400, -1677.800** | — |

Exit is **(-2397, 1850)**. That is SOE's own `exit_one` from
`instance_datatable.tab:13` (`-2397,210,1850,mustafar`) — a real Mustafar world
coordinate, kept verbatim, exactly as the valley kept its own `exit_one`.

### Two facts about the placement that belong in the header

1. **The anchor is NOT the box centre, and `scratch/PLACEMENT.md` line 12 assumed it
   was.** PLACEMENT.md decided `VOLCANO ARENA anchor (x = -400, y = -1600) box
   380 x 420 m`. The box size is right — the arena's true span is 379.97 m by
   419.47 m — but live's arena is not centred on its controller, so anchoring at
   (-400, -1600) would have thrown the footprint to x -698..-318, y -1730..-1310,
   which is 108 m west and 80 m north of the box PLACEMENT.md actually measured with
   its 81-sample fine grid. The anchor moved to **(-292, -1680)** so the footprint
   lands inside the measured box instead:

       measured box   x -590.000 .. -210.000   y -1810.000 .. -1390.000
       true footprint x -589.909 .. -209.941   y -1809.941 .. -1390.469

   Say plainly in the header that PLACEMENT.md's anchor number is superseded and why.
   The box itself is not amended; only the anchor moves.

2. **The east rim of HK's 95 m trigger volume lands at x = -209.941, six centimetres
   outside the nominal box.** Do not fudge the anchor to hide it. State it: the box
   was sampled on a 50 m grid, and the whole southern band measures -5.00 m flat
   across x -1400..1400, so six centimetres is inside the measurement's own
   granularity.

Both arenas and the exit were re-checked against every one of the 126 boundary
active areas in `mustafar_boundaries.lua`. All clear; nearest margins: arena anchor
736 m, exit 218 m. **The volcano needs no boundary pocket** — unlike the valley,
whose exit sat inside Se1.

---

## 2. THE SCREENPLAY TABLE

Mirror `valley_battlefield.lua:110-148`. Constants, every one sourced:

```
anchorX = -292, anchorY = -1680
entryX  = -550.295, entryY = -1480.588      -- live buildout waypoint zoneIn
exitX   = -2397,    exitY  = 1850           -- live instance_datatable.tab:13 exit_one
maxPlayers = 8                              -- live max_players
entryRange = 60                             -- same as the valley
timeLimit  = 3600                           -- live time_limit
cleanOut   = 300                            -- trial.java:1524-1537 setDungeonCleanOutTimer
winPoll    = 30                             -- this file's own re-arm; see below
victoryBadge = "bdg_must_victory_volcano"   -- volcano_event_manager.java:308-316
victoryMusic = "sound/mus_mustafar_quest_success.snd"
hkIntroMusic = "sound/mus_mustafar_hk47_intro.snd"   -- trial.java:199 MUS_VOLCANO_HK_INTRO
tracked = {},
```

`winPoll = 30` is this file's number, not live's — live drives progression off
message passing, which this port replaces with polled `createEvent` re-arms. Label it.

Session bookkeeping is a straight copy of the valley's shape
(`valley_battlefield.lua:348-397`) with the key prefix `volcanoBattlefield:` and
these keys: `active`, `session`, `owner`, `stage`, `startedAt`, `eventIdx`, `won`.
`getTrack(session)` returns a table with:

```
army = {}, guards = {}, corpses = {}, props = {}, players = {},
areas = {}, bossID = 0, deadBoss = 0, deadGuards = 0, corpseIdx = 0,
```

`start()` is the valley's: bail unless `isZoneEnabled("mustafar")`, then
`clearSessionKeys()` and `self.tracked = {}`. A crash mid-session otherwise leaves
`active = 1` forever.

---

## 3. ENTRY, EXIT, RESET — copy the valley's, do not redesign

- `enter(pPlayer)` — mirror `valley_battlefield.lua:590-648`. Gate on
  `storyArcChaptersScreenPlay:mayEnterVolcanoBattlefield(pPlayer)` (part two adds
  that function; call it now and guard with `storyArcChaptersScreenPlay == nil`
  exactly as the valley does at :595-598). Same "already active, are you grouped with
  the owner, is it full" logic and the same two `@dungeon/space_dungeon:` system
  message ids.
- `buildParty` / `teleportIn` / `sendToExit` / `clearEjecting` / `ejectEveryone` —
  copy `valley_battlefield.lua:650-749` verbatim in shape, swapping the writeData key
  names to `volcanoBattlefield` / `volcanoBattlefieldOut`.
- `forEachPlayerInside` / `broadcastMessage` / `broadcastMusic` / `countPlayersInside`
  / `trackPlayer` — copy `:533-584`.
- `worldXY(locx, locz)` returns `self.anchorX + locx, self.anchorY + locz`.
- `resetArena(reason)` / `destroyIDList(list)` — mirror `:1607-1656`, minus the demo
  gear (there is none here). Clear `active` FIRST so `sendToExit`'s "last player left"
  path cannot re-enter, eject, destroy `army` / `guards` / `corpses` / `props`,
  destroy every active area in `track.areas`, drop the track, then
  `clearSessionKeys()` and bump `session` so in-flight `createEvent` callbacks find a
  stale id and bail.
- `onTimeout` at 3600 s and `cleanOutTimer` at 300 s post-win: mirror `:1581-1605`.

**Omitted from live, state each one in the header:**
- The daily lockout (`instance.java:659-674`, reset 06:00). The valley did not port
  its lockout either; there is no instance system to hang it on.
- The min-player check that closes the instance after three failed passes
  (`instance_manager.java:180-245`).
- `volcano_player.java`'s 20-second-delayed `volcano_arena_pilot` signal on entry.
  In this port the pilot conversation is what advances the quest, before entry — see
  part two.

---

## 4. THE ACTIVATION CHAIN — six trigger volumes, armed strictly in order

Live: `event_one.java:21-27` is the only event that arms itself at attach. Every
other event exposes `activateEvent`, and `volcano_event_manager.java:174-198`
`eventDefeated` walks an index so the order is **one → two → three → four → five →
hk_final**. The trigger volume, not the kill, is what starts a fight.

Port that literally:

- All six bosses and all their static guards spawn **at session start**, invulnerable,
  the way live spawns everything at controller attach.
- `spawnEventArea(session, idx)` does
  `spawnActiveArea("mustafar", "object/active_area.iff", x, z, y, radius, 0)` then
  `writeStringData(areaID .. ":volcanoEvent", tostring(idx))` and
  `createObserver(ENTEREDAREA, "VolcanoBattlefield", "notifyEnteredEventArea", pArea)`.
  This is the idiom `story_arc_chapters.lua:1250-1262` and `mustafar_boundaries.lua`
  already use in this tree; follow it.
- Only event one's area is spawned at session start. `eventDefeated(session, idx)`
  destroys the finished area, increments `volcanoBattlefield:eventIdx`, and spawns the
  next one. After `hk_final` it calls `winTrial`.
- `notifyEnteredEventArea` must ignore non-players and must re-check
  `isSessionCurrent` before doing anything.

Get the height for `spawnActiveArea` from `getWorldFloor` like every other spawn here.

---

## 5. WHAT CANNOT BE PORTED — verified absent, name every one in the header

Each of these was checked against the Lua binding tables in `MMOCoreORB/src`, not
guessed. Cite the file:line in the header so the next reader does not re-derive it.

**A. Buffs — there is no Lua buff API at all.** `addBuff` does not appear anywhere in
the `LuaCreatureObject` registration array (`LuaCreatureObject.cpp:40-160`). Every
buff mechanic is therefore omitted, with no stand-in. This is the same ruling
`valley_battlefield.lua` made for its three morale buffs, and its wording is the
precedent: *there is no honest stand-in to write; do not invent one.* The full list
of what goes:
  - event one's `volc_boss_one_1 … volc_boss_one_8` escalation, one per dead guard
    (`event_one_boss.java:15-25`, `:101-124`)
  - event five's three debuff pools — ham `bio_etheric_shock/torpor/vacuity`,
    debuff `lethargy/wavering/toxic_dissolution`, skill
    `obfuscation/confusion/corrosion` (`event_five_boss.java:312-342`)
  - HK's two smaller pools (`hk_final_boss.java:336-346`)
  - `distraction` and `enfeeble` on both event five and HK
  - `low_morale` on a squad member whose leader died (`hk_squad_member.java`)
  The damage AEs those bursts are bundled with **do** port — see §6. Only the buff
  half is lost.

**B. Buff strip.** `event_five_guard` and `hk_gk_septipod` strip player buffs via
`queueCommand(self, (1679682244), ...)`. There is no `queueCommand` binding and no
buff API to strip with. Omitted.

**C. Hate lists.** No `setHate`, `clearHateList` or `removeHateTarget` binding exists;
`LuaAiAgent.cpp:30-136` has `setDefender`, `addDefender`, `setOblivious`,
`clearCombatState` and nothing else in that family. So:
  - live `switchTarget` → pick a random player in range other than the current
    defender and `AiAgent(pMob):setDefender(pOther)`. The observable effect (the boss
    changes victim on a timer) survives; the hate arithmetic does not.
  - live `clearHateList` + `stopCombat` → `AiAgent(pMob):clearCombatState()` then
    `AiAgent(pMob):setOblivious()`.
  Label both as substitutions where they appear.

**D. Corpses.** There is no `POSTURE_DEAD`. `DirectorManager.cpp:642-647` registers
exactly `UPRIGHT, PRONE, POSTURESITTING, KNOCKEDDOWN, CROUCHED, LYINGDOWN`. A corpse
here is: `spawnMobile` the template with respawn 0, then
`CreatureObject(pCorpse):setPosture(KNOCKEDDOWN)`,
`TangibleObject(pCorpse):setOptionBit(INVULNERABLE)`, and
`AiAgent(pCorpse):setAITemplate("idle")` so it never acquires. Precedent for the
knocked-down-prop idiom: `village_jedi_manager_township.lua:463`.

**E. Invulnerability.** Live `setInvulnerable(true/false)` →
`TangibleObject(pMob):setOptionBit(INVULNERABLE)` /
`clearOptionBit(INVULNERABLE)`. `INVULNERABLE` is registered at
`DirectorManager.cpp:737`; `setOptionBit`/`clearOptionBit` at
`LuaTangibleObject.cpp:49-50`.

**F. Particle and client effects.** Live names a dozen `.prt` / `.cef` assets
(`trial.java:174-199`). `SceneObject:playEffect(file, aux)` exists
(`LuaSceneObject.cpp:97`), but none of those asset paths can be verified against this
tree's client build, and the sibling `valley_battlefield.lua` uses no `playEffect` at
all. Omit the particle calls; **record live's exact effect strings in the header as
data** so nothing is lost. Music files DO play — the valley plays them — so keep
`broadcastMusic`.

**G. String ids.** Every live message is a `string_id` in
`mustafar/volcano_battlefield.stf`. That stf is not in this tree
(`bin/string/en/mustafar/` does not exist). Use plain English `sendSystemMessage`
strings the way the valley does ("The droid army has been defeated."), and quote the
live stf key in a comment beside each one.

**H. HP.** **Do not call `setMaxHAM` or `setHAM` anywhere in this file.** Live sets
per-mob HP through `trial.setHp` (545000 for the event-one boss, 950485 for the
cyborg prototype, and so on). Round F2(a), commit `34dccdf96c`, deliberately placed
all twenty volcano rows on the retune ladder from commit `189d4f1622` instead — the
ladder replaced raw HP, which is why live's `setHp` values have nowhere to land, and
the volcano's rows were put one rung above the valley's precisely to keep live's
difficulty gap. Writing live's raw HP back in here would undo that commit. The tier
ladder IS the tuning. Say so in the header and list live's HP table as reference data
only.

---

## 6. WHAT *CAN* BE PORTED — the damage primitives, verified present

- **Spatial query:** `SceneObject:getPlayersInRange(range)` —
  `LuaSceneObject.cpp:104` / `:1012-1038`. Returns a **1-indexed Lua table of
  lightuserdata SceneObjects**, or `nil` when the object has no zone. Always nil-check
  the return. Existing callers: `city_control_landing.lua:101`,
  `village_raids.lua:340`, `fs_cs_base_control.lua:278`.
- **Direct damage:** `CreatureObject:inflictDamage(pAttacker, damageType, damage, destroy)`
  — `LuaCreatureObject.cpp:612-632`. `damageType` is the HAM pool index: **0 = HEALTH,
  3 = ACTION, 6 = MIND**. Every one of the eight existing call sites in the tree passes
  0 (e.g. `corellianCorvette.lua:529`, `deathWatchBunker.lua:916`, `geoLab.lua:547`).
  Pass `false` for destroy.
- **DOTs:** `CreatureObject:addDotState(pAttacker, dotType, strength, attribute, duration, potency, objectID, defense)`
  — `LuaCreatureObject.cpp:258-274`. The tree's only call site is `geoLab.lua:556`:
  `CreatureObject(pTarget):addDotState(pTarget, POISONED, 150, HEALTH, 300, 100, areaID, 0)`.
  Follow that argument shape exactly. `POISONED / DISEASED / ONFIRE / BLEEDING` at
  `DirectorManager.cpp:710-713`; `HEALTH / ACTION / MIND` at `:700 / :703 / :706`.
- **Healing:** `CreatureObject:healDamage(amount, pool)` — `LuaCreatureObject.cpp:1063`,
  argument order is amount-then-pool. The valley calls it as `healDamage(amount, 0)`
  at `:905`. Pool 0 is HEALTH.
- **Force:** `PlayerObject:getForcePower()` / `setForcePower(n)` —
  `LuaPlayerObject.cpp:47-49`. Only needed in part two.

---

## 7. EVENT ONE — the Taskmaster (LIVE-VOLCANO §2.1)

Centre **(-544.909, -1611.496)**, volume radius 45, armed at session start.

**Spawn at session start, all yaw 0, all invulnerable:**
- 1 × `som_volcano_one_taskmaster` at the centre. Track as `track.bossID`.
- 8 × `som_volcano_one_sustainer` at offsets
  `3:2  6:4  9:7  12:10  -3:2  -6:4  -9:7  -12:10` (`event_one.java:75-111`).
  Track in `track.guards`.

**On trigger** (`activateEncounter`, `event_one.java:46-52`): clear INVULNERABLE on
the boss only. The guards **stay invulnerable** — that is the whole mechanic. Start
two repeating events:
- `guardHeal` every **5 s** (`event_one_guard.java`): for each living guard, heal the
  boss `healDamage(1000, 0)`. Live's `performGuardHeal` is `addToHealth(self, 1000)`
  at `event_one_boss.java:125-137` — 1000 per guard per 5 s, all eight at once.
- `rotateAttacker` every **10 s** (`event_one.java:112-128`): pick a random living
  guard that is not the current attacker (`chooseNewAttacker`, `:137-206`). The
  outgoing attacker gets INVULNERABLE set, `clearCombatState()`, `setOblivious()`.
  The incoming one gets INVULNERABLE cleared and `setDefender` on the nearest player
  within radius **80** (`event_one_guard.java` `beginAttack`).

**Win:** boss dies → `eventDefeated(session, 1)`. Only the boss counts; the guards
never have to die.

**Reset:** live's `OnExitedCombat` resets the whole encounter (full heal, respawn
guards, re-invulnerable). Port it as a poll: if the boss is alive, out of combat, and
`countPlayersInside()` inside the volume is 0, restore the starting state.

Omitted here and stated: the eight escalation buffs (§5A) and `PRT_DROID_HEAL` /
`PRT_INVULN_SHIELD` (§5F). Live guard HP 65000 and boss HP 545000 are reference only
(§5H).

---

## 8. EVENT TWO — AK Prime (LIVE-VOLCANO §2.2)

Centre **(-487.411, -1722.954)**, volume radius 45.

**Spawn:** 1 × `som_volcano_two_ak_prime` at the centre plus 4 ×
`som_volcano_two_hk77` at `-6:-6  6:6  -6:6  6:-6` (`event_two.java:70-102`), all
invulnerable. Live calls `ai_lib.establishAgroLink(boss, guards)` — pulling the boss
pulls all four — so on trigger, when a player engages the boss, `setDefender` every
guard onto the same player.

**The three-AE cycle** (`event_two_boss.java`), re-armed every **18 s**, type chosen
at random from wave / airfall / cone. Each is telegraphed: announce at t+0, burst at
**t+4 s**. Announce with `broadcastMessage`, since the telegraph particles are
omitted (§5F) and without a warning the burst is invisible and unfair.

All three use `getPlayersInRange` off the boss.

- **Wave**, radius **96** (`:143-183`). The current defender takes a flat **2000**
  HEALTH damage plus a fire DOT — live: `dot.DOT_FIRE`, HEALTH, duration **200**,
  potency **60**. Everyone else takes `math.floor(30000 / distance)` plus a DOT of
  `damage / 10` for **300**. Clamp distance to a minimum of 1 before dividing.
- **Airfall**, radius **96** (`:193-224`). `modDistance = math.max(0.1, distance / 20)`,
  `damage = modDistance * 3000`, damage type **ELECTRICAL — more damage the farther
  you are.** `inflictDamage` has no element channel, so this lands as pool-0 damage;
  say so in the comment rather than pretending the element survived.
- **Cone**, range **96**, arc **30°** (`:234-270`). Live uses
  `trial.getValidTargetsInCone(self, target, 96, 30)`. There is no cone helper here,
  so filter `getPlayersInRange(96)` by the angle between (boss → defender) and
  (boss → candidate) being ≤ 15° either side. Write the arithmetic out in a comment.
  Primary target takes **2500** COLD; everyone else in the cone takes **8500**.
  That is live's number and it is not a typo — the cone punishes the group, not the
  tank.

**Win:** boss dies → `eventDefeated(session, 2)`.

---

## 9. EVENT THREE — the Forward Commander and the corpse revive (§2.3, §3.1)

Centre **(-403.277, -1572.559)**, volume radius 45. This is the most intricate of the
three in part one; get the counters exactly right.

**Spawn:** 1 × `som_volcano_three_forward_commander` at the centre, **yaw 180**,
invulnerable, plus **15** × `som_volcano_three_hk77` at yaw 180, invulnerable, in
three ranks of five (`event_three.java:74-118`):

```
-6:-10  -3:-10  0:-10  3:-10  6:-10
-6:-8   -3:-8   0:-8   3:-8   6:-8
-6:-6   -3:-6   0:-6   3:-6   6:-6
```

Set `track.deadGuards = 0`, `track.deadBoss = 0`, `track.corpseIdx = 0`.

**The trickle.** On trigger, `releaseGuard` fires every **10 s**
(`event_three.java:119-154`), walking a `guardIndex`. Each release clears
INVULNERABLE on that guard and `setDefender`s it onto the nearest player within
radius **100**. A guard that is already dead costs no time — skip it and take the
next in the same tick, exactly as live does.

**Corpses.** Each guard death runs `placeGuardCorpse` (`:202-241`): consume the next
slot of a fixed 15-entry offset table and place a **fresh** `som_volcano_three_hk77`
corpse there (per §5D). The corpse is a new object at a scripted spot, **not** the
body where the guard fell — that is live's behaviour and it must be reproduced.

```
7:4  2:-6  0:-11  -5:1  14:-13  -18:-32  -18:-23  6:-2
16:-8  18:-14  -18:4  5:-4  11:4  -3:-12  7:-29
```

**The phase gate** (`:155-191`): `deadGuards == 15` → `activateBoss`. All fifteen must
die before the commander is touchable. `activateBoss` (`:242-252`) clears the boss's
INVULNERABLE, `setDefender`s within radius 100, and arms `doResEffect` at **10 s**.

**The revive** (`performRez`, `:292-320`), re-armed every **35 s**: collect every
living commander (the original plus every risen one) and every remaining corpse, then
**index-pair them — commander[i] revives corpse[i], all simultaneously.** Per pair:
destroy the corpse, spawn `som_volcano_three_risen_commander` at the corpse's
position with `heading = getRandomNumber(0, 359)`, and mark it as a commander so it
joins the next scan as a rezzer. One commander becomes two, then four, then eight.
The pool is capped at the fifteen corpses ever placed.

**Win:** `track.deadBoss == 16` — the original plus fifteen revives — →
`eventDefeated(session, 3)`. Do not use any other number.

**Fallback:** when exactly one commander is alive, live runs `performSoloCorpseRez`
(`:351-368`) on the faster **18 s** cycle instead of 35. Port it.

**Bonus loot** (`event_three_boss.java:23-40`): live rolls 12% for
`item_tow_schematic_vehicle_02_02`, commented "Lava Transport Skiff". That live
static-item name does not exist in this tree and is not an object template. **Substitute
`object/tangible/deed/vehicle_deed/landspeeder_lava_skiff_deed.iff`** — registered at
`object/custom_content/tangible/deed/vehicle_deed/landspeeder_lava_skiff_deed.lua:20`,
and it generates `object/mobile/vehicle/landspeeder_lava_skiff.iff`, which is the
actual Lava Transport Skiff. Keep live's 12% roll with `getRandomNumber(100) <= 12`.
The precedent for substituting an unresolvable live `lootName` with the nearest real
object of the same family is `hidden_treasure.lua`'s THE REWARD block — read it and
match its reasoning style in the comment.

Live commander HP 655250 / risen 60250 / guard 33500 are reference only (§5H).

---

## 10. HOUSE RULES

- Every `createEvent` callback takes `(pObj, args)` where `args` is
  `tostring(session)`, and every one of them re-checks `isSessionCurrent(session)`
  first and returns silently if stale. No exceptions.
- Nil-check every `spawnMobile` / `spawnActiveArea` / `getSceneObject` return.
  `getPlayersInRange` can return nil.
- Never index a tracked object without `getSceneObject(oid) ~= nil` and
  `not CreatureObject(p):isDead()`.
- Lua 5.3, tabs for indentation, no trailing whitespace. It must pass
  `luac5.3 -p`.
- Comment voice: state what live does with its file:line, then what this file does,
  then why they differ. Match `valley_battlefield.lua`. Do not write cheerful
  comments and do not claim anything you did not verify.
- **Do not run git. Do not commit.**
