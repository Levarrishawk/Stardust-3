# ROUND F1(c) — build the Valley Battlefield

You are Grok. Do exactly what this file says. **Do not commit and do not run git.**
Everything you need is quoted here; where it says "read", read that file yourself.

Repo root: `C:\stardust-3-space-port\server`
Branch: `mustafar-content`

---

## 0. FENCES — do not touch these files, for any reason

    MMOCoreORB/bin/scripts/mobile/custom_content/som/serverobjects.lua   <-- EXCEPT the one
                                                                            append in §7
    MMOCoreORB/bin/conf/config.lua
    screenplays/mustafar/quest/conversation/jo_kelsev_conv_handler.lua
    any obi_wan_ghost.lua / surveyor_jo.lua

Do not reformat, re-indent or re-wrap any line you are not asked to change.
Tabs, not spaces — this tree indents with tabs.

---

## 1. WHAT THIS IS

The Valley Battlefield is SOE's `mustafar_droid_army` instance: a group defence
where an HK-47 droid army marches on a Mustafarian mining camp over eleven waves
and the players hold the line until the Forward Commander dies.

This port has never had it. Twenty-two tangibles for it are already registered
(`object/custom_content/tangible/dungeon/mustafar/valley_battlefield/`) and ten
creature templates were added in commit `852e2074b4`. Nothing spawns any of it.

Round F1(c) builds the encounter.

**The complete live source is already digested for you** in
`scratch/LIVE-VALLEY.md` (998 lines). Read §1 (generator), §2 (demo packs),
§4 (commander), §5 (win/lose), §6 (allies), §7 (waypoints/paths). This spec
quotes the numbers that must be exact; LIVE-VALLEY carries the reasoning.

The wave table below is transcribed **verbatim** from
`C:\swg-extract\_dsrc-full\sku.0\sys.server\compiled\game\datatables\dungeon\mustafar_trials\valley_battlefield\valley_event_data.tab`.
Do not re-derive it; do not "improve" a number.

---

## 2. THE DECISIONS ALREADY MADE — do not re-open these

### 2.1 Where it goes

    ANCHOR = (x = 600, y = -1600) on zone "mustafar"

Off-map, in the empty southern band, entered and left by teleport — the same
model `screenplays/mustafar/mustafar_instances.lua` already uses for the six SOE
dungeon pools. Decided from measured data; the evidence is in
`scratch/PLACEMENT.md`. **Do not move it and do not second-guess it.**

### 2.2 The coordinate transform

Live's datatable rows are already offsets from the controller at
`374.501, 6.52941, 282.793`, in SOE axis order `locx, locy(HEIGHT), locz`.
This repo's Lua order is `x, z(HEIGHT), y`. So:

    repo x = 600  + locx
    repo y = -1600 + locz
    repo z = getWorldFloor(x, y, "mustafar")        <-- resolved, never hardcoded

**The live height offset (`locy`) is DROPPED on every row.** The chosen band is
dead flat at −5.00 m — 162 coarse samples plus two 81-sample fine grids, spread
0.000 (`scratch/PLACEMENT.md`). Live's `locy` values (12, 13, 12.7647 …) encode
terrain relief this plane does not have; applying them would leave the upper camp
and its 22 fences floating twelve metres in the air. Everything is ground-placed.
Say so in the file header — this is a deviation and it gets recorded, not hidden.

Waypoint coordinates in LIVE-VALLEY §7.2: use the **Offset from controller**
column the same way (`repo x = 600 + off_x`, `repo y = -1600 + off_z`), and
resolve height with `getWorldFloor`.

### 2.3 Yaw

The `yaw` column is DEGREES.

- `spawnMobile(zone, template, respawn, x, z, y, heading, parentID)` takes heading
  in **degrees** — pass the column straight through.
- `spawnSceneObject(zone, template, x, z, y, parentID, ow, ox, oy, oz)` takes a
  **quaternion**. Convert: `local r = math.rad(yaw) / 2` then
  `ow = math.cos(r)`, `ox = 0`, `oy = math.sin(r)`, `oz = 0`.

This is documented in `screenplays/mustafar/mustafar_dungeon_population.lua:25-37`.
Follow it.

**One deliberate divergence, and it goes in the header:** live ignores the yaw
column on creature rows entirely (LIVE-VALLEY §3.3 — the creature branch never
calls `setYaw`), and the miner scripts re-apply −70 themselves at deploy time. We
pass the authored yaw on every row. For the miners that lands where live lands.
For Foreman Koseyet it means he faces −133 here and 0 in live. Cosmetic; state it.

---

## 3. FILES YOU CREATE OR CHANGE

| # | File | Action |
|---|---|---|
| 1 | `MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/valley_battlefield.lua` | **create** |
| 2 | `MMOCoreORB/bin/scripts/screenplays/screenplays.lua` | one `includeFile` line |
| 3 | `MMOCoreORB/bin/scripts/screenplays/mustafar/boundaries/mustafar_boundaries.lua` | pocket exemption, §6 |
| 4 | `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/story_arc_chapters.lua` | quest wiring, §5 |
| 5 | `MMOCoreORB/bin/scripts/mobile/custom_content/som/som_battlefield_foreman_koseyet.lua` | **create**, §7 |
| 6 | `MMOCoreORB/bin/scripts/mobile/custom_content/som/serverobjects.lua` | one `includeFile` line, §7 |

Nothing else. The demolition-pack player tool (LIVE-VALLEY §2) is **out of scope
for this round** — it is a separate item-script subsystem and it is round F1(d).
The two demo packs still get placed as props at stage 1; they simply have no
radial yet. Put that in the header as a stated, scoped omission — do not silently
skip it and do not stub a fake radial.

---

## 4. THE SCREENPLAY — `valley_battlefield.lua`

Global name and `screenplayName` must both be **`ValleyBattlefield`** (they must
match, because `createEvent` and `createObserver` take the global's name as a
string). Copy the file shape, comment voice and nil-guard discipline of
`screenplays/mustafar/mustafar_instances.lua` — that is the house pattern for
teleport-in/teleport-out Mustafar content and it is the sibling to read first.

### 4.1 Header comment

Write a real one, in the voice of `mustafar_instances.lua` and
`mustafar_dungeon_population.lua`. It must state:

- what the encounter is and that live ran it as an 8-player instance
  (`instance_datatable.tab:12`, max 8, 3600 s, daily lockout, key
  `mustafar_droid_army`);
- that Core3 has no instance system for outdoor areas, so this is one off-map
  arena at (600, −1600), one session at a time, entered by teleport;
- the coordinate transform of §2.2 and that live's height offsets are dropped,
  with the reason;
- the yaw divergence of §2.3;
- that the demo-pack radial is round F1(d), not built here;
- every substitution you end up making, each with its reason.

### 4.2 Constants

```lua
ValleyBattlefield = ScreenPlay:new {
    numberOfActs = 1,
    screenplayName = "ValleyBattlefield",

    anchorX = 600,
    anchorY = -1600,

    -- live instance_datatable.tab:12 enter -79,12,-152 -> offsets, so anchor-relative
    entryX = 521,          -- 600 + (-79)
    entryY = -1752,        -- -1600 + (-152)

    -- live exit_one 541,155,-160,mustafar -> a REAL Mustafar world coordinate,
    -- 10.8 m from Chapter Three 01's scout post. Reachable only because of the
    -- boundary pocket this round also opens (see mustafar_boundaries.lua).
    exitX = 541,
    exitY = -160,

    maxPlayers = 8,        -- live max_players
    entryRange = 60,       -- group members within this of the caller come along
    timeLimit = 3600,      -- live time_limit, seconds
    waveDelay = 150,       -- trial.java:147 BATTLEFIELD_WAVE_DELAY
    rezDelay = 18,         -- trial.java:148 BATTLEFIELD_COMM_REZ_DELAY
    winPoll = 60,          -- validateDungeon re-arm, LIVE-VALLEY §5.1
    cleanOut = 300,        -- post-victory loot window, LIVE-VALLEY §5.1
    generatorHp = 65000,   -- trial.java:212 HP_BATTLEFIELD_GENERATOR
    generatorRange = 40,   -- power_generator.java:16 VOLUME_RANGE
    leakRange = 18,        -- end_point_monitor.java VOLUME_RANGE
    leakRescan = 10,       -- end_point_monitor.java RESCAN
    leakLimit = 4,         -- escalation 4 == loseTrial
    rezRange = 22,         -- forward_commander.java:702
    rezMax = 3,            -- forward_commander.java:704
    victoryBadge = "bdg_must_victory_army",
    victoryMusic = "sound/mus_mustafar_quest_success.snd",
    introMusic = "sound/mus_mustafar_droid_invasion_intro.snd",
}
```

### 4.3 Session state

`writeData` keys. Ints only — that is all `writeData` stores.

    valleyBattlefield:active         1 while a session is running
    valleyBattlefield:session        monotonic session id (live's trial.bumpSession)
    valleyBattlefield:owner          objectID of the player who opened it
    valleyBattlefield:stage          current stage number
    valleyBattlefield:startedAt      os.time()
    valleyBattlefield:generatorID    objectID of the power generator
    valleyBattlefield:leaks          end-point escalation counter
    valleyBattlefield:commanderDead  1 once the commander dies
    valleyBattlefield:won            1 once victory fires
    <playerID>:valleyBattlefield     1 while that player is inside
    <playerID>:valleyBattlefieldOut  1 for 2 s during an eject (re-entrancy guard)

Object lists (spawned army, allies, props) live in an in-memory table on the
screenplay, keyed by session id, e.g. `self.tracked[session] = { army = {}, ... }`.
A restart destroys the world objects anyway, so in-memory is the honest store.

**`ValleyBattlefield:start()` MUST clear every `valleyBattlefield:*` key.**
Without that, a crash or restart mid-session leaves `active = 1` forever and the
battlefield is permanently locked. Guard `start()` on
`isZoneEnabled("mustafar")` the way the sibling screenplays do.

### 4.4 Entry — `ValleyBattlefield:enter(pPlayer)`

In order:

1. nil-guard.
2. Quest gate. Fail **closed**, exactly the way
   `MustafarInstances:isEntryAllowed` does it:
   ```lua
   if (storyArcChaptersScreenPlay == nil) then
       printLuaError("ValleyBattlefield: story_arc_chapters.lua is not loaded; refusing entry")
       return
   end
   if (not storyArcChaptersScreenPlay:mayEnterValleyBattlefield(pPlayer)) then
       CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:not_ready")
       return
   end
   ```
3. If `valleyBattlefield:active == 1`: allow only if the caller is in the owner's
   group and the arena holds fewer than `maxPlayers`; otherwise
   `"@dungeon/space_dungeon:unable_to_find_dungeon"` and return. **Say why —
   a silent return is indistinguishable from a broken radial.**
4. If not active: bump the session id, set `active`, `owner`, `startedAt`,
   `stage = 0`, clear `leaks` / `commanderDead` / `won`, then run stage 1
   (`§4.6`), arm the wave scheduler and arm the 3600 s timeout.
5. Build the travelling party: the caller, plus each group member within
   `entryRange` of him, capped at `maxPlayers`.
6. For each: dismount if riding, `writeData(id .. ":valleyBattlefield", 1)`, then
   ```lua
   local height = getWorldFloor(self.entryX, self.entryY, "mustafar")
   SceneObject(pMember):switchZone("mustafar", self.entryX, height, self.entryY, 0)
   ```
   (cell 0 = world; this is the `mustafar_instances.lua:736` exit pattern).

### 4.5 Exit — `ValleyBattlefield:sendToExit(pPlayer)`

Copy `MustafarInstances:sendToExit` (lines 708-746) including the
`:valleyBattlefieldOut` re-entrancy flag and its 2 s `clearEjecting` event.
Exit at `(exitX, exitY)`, height from `getWorldFloor`, cell 0.

When the last player leaves, run the reset (`§4.12`).

### 4.6 STAGE 1 — the setup wave, t = 0

Verbatim from `valley_event_data.tab` lines 3-23, 64-86. Columns are
`object, stage, locx, locy, locz, yaw, script, scriptVar`. `locy` is dropped
per §2.2. Encode as a Lua table and iterate; do not write 32 copy-pasted calls.

**Creatures** (`spawnMobile`, respawn 0, heading = yaw, parent 0):

| template | locx | locz | yaw | role |
|---|---|---|---|---|
| `som_battlefield_mining_droid` | 11 | 2 | −70 | ally, §4.10 |
| `som_battlefield_mining_droid` | 10 | 4 | −70 | ally |
| `som_battlefield_mining_droid` | 8 | −2 | −70 | ally |
| `som_battlefield_mining_droid` | 6 | −5 | −70 | ally |
| `som_battlefield_mining_droid` | 3 | −8 | −70 | ally |
| `som_battlefield_mining_leader` | 2 | −3 | −70 | ally leader, NO autoDeploy |
| `som_battlefield_mining_leader` | 4 | 3 | −70 | ally leader, NO autoDeploy |
| `som_battlefield_foreman_koseyet` | −81 | −131 | −133 | flavour NPC |

**Tangibles** (`spawnSceneObject`, quaternion from yaw, parent 0). All paths are
the repo's own — note they are `.../valley_battlefield/<name>.iff`, which is what
both the live datatable and this tree use:

| template | locx | locz | yaw |
|---|---|---|---|
| `object/tangible/dungeon/mustafar/valley_battlefield/demo_pack.iff` | −3 | 2 | 0 |
| `object/tangible/dungeon/mustafar/valley_battlefield/demo_pack.iff` | −4 | 0 | 0 |
| `object/tangible/dungeon/mustafar/valley_battlefield/power_generator.iff` | 26 | −22 | 25 |
| `object/tangible/collection/rare_heavy_oppressor_flame_thrower.iff` | 10 | −35 | 0 |

Lower camp, 10 props (file lines 14-23):

| template | locx | locz | yaw |
|---|---|---|---|
| `must_bandit_fence_16m.iff` | 17.7881 | −2.17578 | 129.671 |
| `must_bandit_fence_8m.iff` | 26.9551 | 4.29785 | 0 |
| `must_bandit_fence_16m.iff` | 37.3062 | −0.771973 | −140.948 |
| `must_bandit_fence_16m.iff` | 40.063 | −13.8052 | −64.7442 |
| `must_bandit_fence_16m.iff` | 33.2681 | −28.4541 | −64.7442 |
| `must_bandit_fence_16m.iff` | 21.042 | −34.5688 | 8.02144 |
| `must_bandit_fence_8m.iff` | 3.76514 | −30.873 | 22.9183 |
| `must_bandit_fence_16m.iff` | 4.62305 | −21.707 | 119.931 |
| `must_bandit_bunker.iff` | 28.457 | −5.55811 | −122.613 |
| `must_bandit_cooling_unit.iff` | 17.7529 | −24.376 | −153.162 |

Upper camp, 22 props (file lines 64-85):

| template | locx | locz | yaw |
|---|---|---|---|
| `must_bandit_fence_16m.iff` | −107.007 | −186.509 | −9.16729 |
| `must_bandit_fence_16m.iff` | −122.785 | −186.548 | 8.02144 |
| `must_bandit_fence_8m.iff` | −139.671 | −183.098 | 21.7724 |
| `must_bandit_fence_8m.iff` | −145.455 | −180.295 | 32.0857 |
| `must_bandit_fence_16m.iff` | −156.384 | −176.184 | 14.324 |
| `must_bandit_fence_8m.iff` | −167.22 | −171.933 | 38.9611 |
| `must_bandit_fence_8m.iff` | −177.687 | −165.591 | 28.6479 |
| `must_bandit_fence_8m.iff` | −188.113 | −159.809 | 28.6479 |
| `must_bandit_fence_16m.iff` | −193.501 | −147.556 | −61.8795 |
| `must_bandit_fence_16m.iff` | −187.007 | −132.461 | −71.0468 |
| `must_bandit_fence_16m.iff` | −176.378 | −126.193 | 14.324 |
| `must_bandit_fence_16m.iff` | −164.898 | −135.306 | 63.0253 |
| `must_bandit_fence_8m.iff` | −157.255 | −142.249 | 0 |
| `must_bandit_fence_8m.iff` | −141.812 | −142.903 | 0 |
| `must_bandit_fence_16m.iff` | −129.958 | −140.175 | −18.9076 |
| `must_bandit_fence_16m.iff` | −115.585 | −142.313 | 36.6693 |
| `must_bandit_fence_8m.iff` | −108.162 | −151.486 | −102.559 |
| `must_bandit_fence_8m.iff` | −105.096 | −163.364 | −102.559 |
| `must_bandit_fence_8m.iff` | −102.128 | −175.045 | −102.559 |
| `must_bandit_bunker.iff` | −116.314 | −178.987 | 13.1781 |
| `must_bandit_bunker.iff` | −138.045 | −154.052 | −122.613 |
| `must_bandit_bunker.iff` | −152.869 | −169.947 | 38.3881 |

### 4.7 The wave scheduler — stages 2-11

`createEvent(self.waveDelay * 1000, "ValleyBattlefield", "spawnNextStage", nil, "")`,
re-armed each time, stopping after stage 11 or when the session ends. Every wave
row: yaw 0, `isArmy = true`, spawn anchor from the table, path index as given.

Six spawn anchors, offsets from the anchor (LIVE-VALLEY §3.5):

    A = (-253, 201)   B = (-294, 160)   C = (-148, 181)
    D = (  41, 104)   E = (   1, 125)   F = (-268,  53)

| Stage | t | 1 | 2 | 3 |
|---|---|---|---|---|
| 2 | 150 | `squad_leader` @A p1 | `squad_leader` @B p8 | `squad_leader` @C p7 |
| 3 | 300 | `ak_1a` @A p2 | `squad_leader` @C p7 | `ak_3` @B p7 |
| 4 | 450 | `squad_leader` @B p5 | `squad_leader` @C p6 | `ak_1a` @A p8 |
| 5 | 600 | `ak_1a` @C p7 | `gk_5` @A p4 | `squad_leader` @B p2 |
| 6 | 750 | `squad_leader` @A p0 | `gk_5` @B p8 | `squad_leader` @C p7 |
| 7 | 900 | `squad_leader` @C p5 | `squad_leader` @B p6 | `ak_1a` @A p8 |
| 8 | 1050 | `ak_3` @C p7 | `squad_leader` @A p1 | `squad_leader` @B p8 |
| 9 | 1200 | `gk_5` @C p7 | `ak_1a` @A p4 | `squad_leader` @B p2 |
| 10 | 1350 | **`som_battlefield_commander`** @D p12 | `squad_leader` @D p12 | `ak_1a` @E p11 |
| 11 | 1500 | `squad_leader` @E p12 | `squad_leader` @F p10 | `squad_leader` @F p13 |

`squad_leader` = `som_battlefield_droid_squad_leader`, `ak_1a` =
`som_battlefield_ak_1a`, `ak_3` = `som_battlefield_ak_3`, `gk_5` =
`som_battlefield_gk_5`.

Stage side-effects (LIVE-VALLEY §3.4):
- **stage 2** — play `self.introMusic` to everyone inside.
- **stage 10** — play music, send an instance-wide "the commander has arrived"
  message, and **arm `validateDungeon`** (`§4.11`). Nothing polls for victory
  before stage 10. That is live's rule; keep it.

### 4.8 Squad leaders and the commander

**Every `som_battlefield_droid_squad_leader`** spawns 4 `som_battlefield_droid_soldier`
at its own position, staggered at 2 / 3 / 4 / 5 seconds
(`droid_squad_leader.java:762`, `j + 2`, j = 0..3), each copying the leader's
path. **No agro link** — live does not link squad members.

**The commander** (`som_battlefield_commander`, stage 10 @D p12):
- 2 s after spawn, spawns **6** `som_battlefield_elite_guard` at his own location,
  all on his path;
- live calls `ai_lib.establishAgroLink` on the six. Core3 has no equivalent
  binding. Reproduce the *effect*: when the commander enters combat, put each
  guard on the same defender, and vice versa. Use a `DEFENDERADDED` or
  `STARTCOMBAT` observer (both are registered globals —
  `DirectorManager.cpp:597-598`). If you cannot make it work, say so in the
  header and leave the guards unlinked — **do not fake it**;
- arms `performRez` every `rezDelay` (18 s): find up to `rezMax` (3) dead tracked
  army corpses within `rezRange` (22 m) and revive each. What it comes back as,
  by the dead mob's template (`forward_commander.java:139`):

  | dead template contains | comes back as |
  |---|---|
  | `cww` (`ak_1a`, `ak_3`) | `som_battlefield_ak_3` |
  | `union` (`gk_5`) | `som_battlefield_gk_5` |
  | anything else | `som_battlefield_droid_soldier` |

  Elite guards are **never** rezzable — live never marks them as corpses.
  The rez timer always re-arms while the commander lives, whether or not it
  revived anything.
- **commander death is the only thing that stops the rez loop.** On his death:
  set `valleyBattlefield:commanderDead = 1`, send the instance message, and stop
  re-arming `performRez`.

### 4.9 The power generator

`TangibleObject(pGen):setMaxCondition(self.generatorHp)` (65000) and a
`createObserver(OBJECTDESTRUCTION, "ValleyBattlefield", "generatorDestroyed", pGen)`.
Store its objectID in `valleyBattlefield:generatorID`.

**This is the one mechanic that does not port literally, and the substitution is
ruled here — implement it as written, do not invent an alternative.**

Live makes the droids attack the generator through a 40 m trigger volume that
adds 1 hate to any `isArmy` droid inside it (`power_generator.java:56-58`). Core3
AI cannot hold hate on a tangible object. So the *effect* is reproduced directly:
every 5 seconds, count the living tracked army mobs within `generatorRange`
(40 m) of the generator and apply

    100 damage per droid per 5-second tick

via `setConditionDamage`. The arithmetic, stated so it can be argued with: one
droid alone needs 3250 s to kill it — longer than the 3600 s instance, so a
single leaker cannot lose the fight on its own; five droids need 650 s (about 11
minutes), which is roughly four wave intervals. This is a **port constant, not a
live number** — live's droid DPS against a 65000 HP object is not recoverable
from the source. Write that sentence into the header.

On destruction (`generatorDestroyed`):
1. instance-wide message that the generator is destroyed;
2. **immediately** run stage −1 (`§4.13`);
3. 10 s later, debuff the miners (`§4.10`).

Live's two-band damage visuals (`power_generator.java:76-102`) are **not ported**
— there is no Lua hook for damage taken by a tangible in this tree. Note it. Note
also that live's lower band plays nothing at all (the `< fire` branch computes a
location and discards it), so half of what is being skipped never worked anyway.

### 4.10 The allies

Three types, all of them **damage-immune to players by design** — not via
`setInvulnerable` but by hate inversion plus heal-for-damage
(`mining_squad_leader.java:41-66`).

Reproduce with a `DAMAGERECEIVED` observer on each `som_battlefield_mining_leader`,
`som_battlefield_miner` and `som_battlefield_foreman_koseyet`: if the damager is
a player or a player's pet, heal the exact damage back and set that player's
threat to the floor. **A player who shoots a miner heals it.** That is the
anti-grief design and it is load-bearing.

`som_battlefield_mining_droid` (5 at stage 1) is different: it starts
`setInvulnerable(true)` and sentinel, begins pathing 8 s after spawn and becomes
vulnerable the moment it starts. It walks its waypoints in **random** order,
unlike the army's fixed order. Live's radial reactivation is gated on
`class_engineering_phase2_novice` + a `deactivated` scriptvar that nothing ever
sets — the droids always auto-start. Port the auto-start; skip the dead radial
and say why.

**Miner squad leaders** (`mining_squad_leader.java:75-97`), `deployForces`:
4 × `som_battlefield_miner` per leader, in a box formation around the leader,
each following him, all yawed −70, and deploying makes the leader vulnerable.
Leaders spawned at stage −1 carry `autoDeploy` and deploy themselves 5 s after
spawn. The two stage-1 leaders do **not** auto-deploy — in live a player commands
them by conversation. There is no conversation file for them in this tree and no
`.stf` in the extract, so: **the stage-1 pair also auto-deploy here**, and that
divergence is written into the header. Do not author dialogue.

Miner debuff on generator loss: live calls `debufMiners` 10 s after the generator
dies. Reduce the surviving miners' effective combat contribution — the source
body is not quoted in LIVE-VALLEY, so pick the smallest honest thing (a health
reduction on each living miner), implement it, and label it INFERRED in a comment
at the call site.

### 4.11 Win

Armed at stage 10, re-arming every `winPoll` (60 s) — `validateDungeon`.

Victory when the commander is dead **and** no tracked army mob is still alive.
Then:

1. `valleyBattlefield:won = 1`;
2. instance-wide victory message;
3. `playMusicMessage(self.victoryMusic)` to everyone inside;
4. award `self.victoryBadge`, **guarded on the global existing** — exactly the
   pattern at `mustafar/quest/mining_field_markers.lua:666`:
   ```lua
   if (_G[self.victoryBadge] ~= nil) then
       PlayerObject(pGhost):awardBadge(_G[self.victoryBadge])
   end
   ```
5. call `storyArcChaptersScreenPlay:onBattlefieldVictory(pPlayer)` for each player
   inside (nil-guard the screenplay);
6. arm the `cleanOut` timer (300 s) — players get five minutes to loot and leave,
   then everyone is ejected and the arena resets (`§4.12`).

Live also grants a `high_morale` buff for 3600 s. **That cannot be done here.**
`CreatureObject::addBuff` takes a Buff object, Buff has no DirectorManager
registration, and there is no way to construct one from Lua — this is already
written down at `mustafar/quest/reunite_shard.lua:192-196`. Do not fake it. State
the omission in the header and move on.

### 4.12 Lose, timeout, and reset

**Leakage.** Live spawns an invisible monitor at offset `(-195, -194)` — here
**(405, −1794)** — only at stage −1, i.e. after the generator falls
(`end_point_monitor.java`). Every `leakRescan` (10 s) it counts army mobs within
`leakRange` (18 m) that are alive **and not in combat**. If it finds any, the
counter goes up; if it finds none, the counter goes down (floor 0). Counter
1 / 2 / 3 send escalating warnings; **4 loses the fight.**

The "not in combat" test is what makes *hold the line* a real tactic — a droid
being fought inside the volume does not count. Keep it.

**Timeout.** 3600 s from session start ends the session regardless.

**Reset** — on win clean-out, on loss, on timeout, or when the last player leaves:
eject everyone still inside, destroy every tracked spawned object (army, allies,
props, generator, monitor), clear every `valleyBattlefield:*` key, and bump the
session id so any in-flight `createEvent` callback finds a stale session and
returns without doing anything. **Every repeating callback must check the session
id first and bail if it is stale.** That is live's `trial.verifySession` and it is
the only thing that stops orphaned timers.

### 4.13 STAGE −1 — fires only on generator destruction

Not on a timer. Nine `som_battlefield_mining_leader`, all yaw 0, all with
`autoDeploy` (so 36 more miners), plus the end-point monitor:

| template | locx | locz |
|---|---|---|
| `som_battlefield_mining_leader` | −98 | −150 |
| `som_battlefield_mining_leader` | −100 | −138 |
| `som_battlefield_mining_leader` | −115 | −125 |
| `som_battlefield_mining_leader` | −139 | −125 |
| `som_battlefield_mining_leader` | −162 | −118 |
| `som_battlefield_mining_leader` | −198 | −125 |
| `som_battlefield_mining_leader` | −175 | −116 |
| `som_battlefield_mining_leader` | −173 | −155 |
| `som_battlefield_mining_leader` | −134 | −171 |
| `object/tangible/ground_spawning/patrol_waypoint.iff` (the monitor) | −195 | −194 |

Check `patrol_waypoint.iff` is registered in this tree before using it. If it is
not, use any registered invisible/marker tangible and **say which and why** — or
drop the object entirely and run the leak scan from a pure coordinate, which is
cleaner. Your call; document it.

### 4.14 Pathing — the 26 waypoints and 14 paths

This is live's `pathToNextPoint` chain and it is what makes the encounter a
*march* rather than a spawn-camp. Reproduce it with `AiAgent:setNextPosition`.

Waypoints, as offsets from the anchor (`x = 600 + off_x`, `y = −1600 + off_z`;
height from `getWorldFloor`). Copied from LIVE-VALLEY §7.2:

| name | off_x | off_z |
|---|---|---|
| `mining_camp` | 21.200 | −18.034 |
| `camp_east` | 6.091 | 118.885 |
| `camp_west` | −41.719 | −24.499 |
| `player_exit` | −105.151 | −27.966 |
| `droid_1` | −35.776 | −22.225 |
| `droid_2` | −13.826 | −29.189 |
| `droid_3` | 32.171 | 46.578 |
| `droid_4` | 22.700 | 75.273 |
| `east_wall` | −91.431 | 150.808 |
| `hk_droid_exit` | −150.912 | 105.985 |
| `hk_droid_exit_top` | −196.380 | 170.784 |
| `hk_droid_exit_start` | −253.152 | 187.599 |
| `west_approach` | −155.840 | −20.701 |
| `western_flats` | −264.568 | 27.328 |
| `center_line` | −93.324 | 54.671 |
| `top_camp_2` | −76.082 | −156.699 |
| `top_camp_0` | −124.504 | −124.095 |
| `top_camp_1` | −144.762 | −119.817 |
| `end_point` | −196.749 | −189.703 |
| `droid_exit_bridge` | −222.709 | 175.079 |
| `droid_exit_ramp` | −186.290 | 143.862 |
| `droid_east_bridge` | −123.790 | 130.058 |
| `east_camp_bridge` | −36.665 | 135.346 |
| `east_approach_bridge` | 14.304 | 30.725 |
| `exit_west_bridge` | −230.610 | 87.441 |
| `player_exit_ramp` | −103.648 | −60.514 |

The 14 paths, verbatim (`;`-separated, walked **in order**, once):

    0  hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;droid_exit_ramp;hk_droid_exit;droid_east_bridge;east_wall;east_camp_bridge;camp_east;east_approach_bridge;mining_camp;player_exit;player_exit_ramp;top_camp_0;end_point
    1  hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;droid_exit_ramp;hk_droid_exit;droid_east_bridge;east_wall;center_line;player_exit;camp_west;mining_camp;player_exit;top_camp_1;end_point
    2  hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;droid_exit_bridge;hk_droid_exit;exit_west_bridge;west_approach;player_exit;camp_west;mining_camp;player_exit;top_camp_1;end_point
    3  hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;droid_exit_bridge;hk_droid_exit;exit_west_bridge;west_approach;center_line;east_wall;camp_east;east_approach_bridge;mining_camp;player_exit;top_camp_1;end_point
    4  hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;exit_west_bridge;western_flats;west_approach;player_exit;camp_west;mining_camp;player_exit;top_camp_2;end_point
    5  hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;exit_west_bridge;western_flats;center_line;camp_east;east_approach_bridge;mining_camp;player_exit;top_camp_0;end_point
    6  western_flats;center_line;camp_west;mining_camp;player_exit;top_camp_0;end_point
    7  east_wall;camp_east;east_approach_bridge;mining_camp;player_exit;top_camp_1;end_point
    8  western_flats;player_exit;mining_camp;player_exit;top_camp_0;end_point
    9  east_wall;center_line;west_approach;player_exit;mining_camp;player_exit;top_camp_0;end_point
    10 west_approach;mining_camp;player_exit;top_camp_1;end_point
    11 mining_camp;player_exit;top_camp_0;end_point
    12 mining_camp;player_exit;top_camp_2;end_point
    13 west_approach;mining_camp;top_camp_0;end_point

**Repeated entries are deliberate.** Paths 1, 2, 4, 8, 9 list `player_exit`
twice; paths 2 and 3 list `droid_exit_bridge` twice. Live walks the list in
order, so those droids double back. Transcribe them as they are — do not
de-duplicate.

The walker: one repeating event (every 4 s is fine) per session that, for each
living tracked army mob, calls
`AiAgent(pMob):setNextPosition(x, z, y, 0)` toward its current point and advances
its index when the mob is within about 12 m. Drop a mob from the walker when it
dies or its list runs out. Mobs the commander revives inherit the dead mob's
remaining list, the way live copies `patrolPoints`.

The five mining droids use the same machinery with **`droid`-prefixed waypoints in
random order** — live's match is `wp_name.startsWith("droid")`, which catches
seven waypoints, not four: `droid_1`..`droid_4` **plus** `droid_exit_bridge`,
`droid_exit_ramp` and `droid_east_bridge`. That is why they wander onto the army's
approach bridges. Faithful; keep all seven.

---

## 5. QUEST WIRING — `story_arc_chapters.lua`

The file's own comment at :2174-2178 already says `sendToBattlefield` /
`spawnDroidArmy` are "the repo's stand-in for SOE's `sendGroupToBattlefield`,
whose entire body is `instance.requestInstanceMovement(player, "mustafar_droid_army")`".
Replace the stand-in with the real thing.

1. **`sendToBattlefield(pPlayer)`** — keep the `STAGE_DROID_ARMY` guard, then hand
   off to `ValleyBattlefield:enter(pPlayer)` (nil-guard `ValleyBattlefield`,
   fail closed with a printLuaError). Delete the `armyReleased` flag branch.
2. **Delete** `spawnDroidArmy`, the `droidArmy` roster table (:679), the
   `droidArmyRequired` constant (:684), `countDroid` (:2374-2401) and the
   `elseif (stage == self.STAGE_DROID_ARMY) then self:countDroid(...)` dispatch
   at :2315-2316. They exist only to serve the stand-in.
   **Leave a short comment where the roster was** saying it went and why — the
   six-kill counter was invented ("INFERRED count", its own comment says so) and
   is superseded by the real encounter.
3. **Add** `mayEnterValleyBattlefield(pPlayer)`:
   ```lua
   function storyArcChaptersScreenPlay:mayEnterValleyBattlefield(pPlayer)
       return self:getStage(pPlayer) == self.STAGE_DROID_ARMY
   end
   ```
   Model it on the existing `mayEnterUplinkCave` / `mayEnterDroidFactory`.
4. **Add** `onBattlefieldVictory(pPlayer)`: if the player is at
   `STAGE_DROID_ARMY`, advance to `STAGE_SCOUT_FACTORY` — the same transition
   `countDroid` used to make (chapter three 01 task 6 → task 17). Anyone at
   another stage is ignored, not errored.
5. Leave `scoutPost` and its waypoint alone. That coordinate is SOE's and three
   records agree on it.

---

## 6. THE BOUNDARY POCKET — `mustafar_boundaries.lua`

**This is a defect fix and it is not optional; without it the battlefield's exit
point is a bounce pad and Chapter Three 01 is unreachable.**

Measured, not inferred: the scout post at (550, −154) sits **55.97 m inside** Se1
(centre 587,−196 r256) and **270.01 m inside** Se2 (centre 448,−404 r275).
`notifySpawnAreaSe` (:1568-1585) teleports any non-AI creature that enters those
spheres to (197,121,−214). It returns early only for `isAiAgent()`, so Scout Olon
Lono stands there quite happily and the *player* is thrown out before reaching
him. The valley's exit at (541, −160) is 58.4 m from Se1's centre — same problem.

These active areas are spheres, so each projects its radius **inward** as well as
outward; the wall carries a 256 m apron over legitimate ground everywhere it
runs. The scout post is the one piece of authored content that fell in it.

Open a 60 m pocket, and **only inside `notifySpawnAreaSe`** — do not touch
`spawnActiveAreaSe1/2/3`, do not change a radius, do not move a centre, do not
touch any other notify handler:

```lua
    -- Chapter Three 01's scout post is SOE's own coordinate (550, -154): the .qst
    -- task, story_arc_chapters.lua:650 and the live instance exit all agree on it.
    -- It sits 55.97 m inside Se1 and 270.01 m inside Se2, so the wall's inward
    -- apron made the step unreachable, and it made the Valley Battlefield's exit
    -- at (541, -160) a bounce pad. A 60 m pocket is opened around it.
    --
    -- This cannot open the map. Every point in the pocket is at most
    -- 55.97 + 60 = 115.97 m from Se1's centre, and Se1's radius is 256, so the
    -- whole pocket lies deep inside the wall. Walk 60 m in any direction and Se1
    -- takes over again.
    local px = SceneObject(pMovingObject):getPositionX()
    local py = SceneObject(pMovingObject):getPositionY()
    local dx = px - 550
    local dy = py + 154

    if ((dx * dx + dy * dy) <= 3600) then
        return 0
    end
```

Place it after the `isAiAgent()` early-out and before the
`sendSystemMessage`/`teleport` pair.

---

## 7. THE ELEVENTH CREATURE — Foreman Koseyet

Live `creatures.tab` row 4605-4615 has eleven Droid Army rows. Commit
`852e2074b4` added ten; `som_battlefield_foreman_koseyet` was missed. Stage 1
places him, so he is needed now.

Create `MMOCoreORB/bin/scripts/mobile/custom_content/som/som_battlefield_foreman_koseyet.lua`
modelled **exactly** on the sibling `som_battlefield_mining_leader.lua` (read it
first — it carries the tier reasoning and the `pvpBitmask = ATTACKABLE` decision
in its header, and yours must carry the same reasoning in the same voice).

Live's row: level 80 NORMAL, appearance `som/battlefield_foreman.iff`,
socialGroup `mustafar_miner`, loot group `mustafar_miner`.

- appearance: `object/mobile/som/battlefield_foreman.iff` — **verified registered**
  at `object/custom_content/mobile/som/battlefield_foreman.lua:5`. Use it.
- level: 70, the same STD tier the other two miner rows landed on. Do not mint a
  new number.
- `lootGroups`: check whether a `mustafar_miner` loot group exists in this tree
  before referencing it. If it does not, ship `lootGroups = {}` and say so — do
  not invent a group.
- `customName`: authored, as with all ten — no `.stf` ships in the extract.

Then append **one** `includeFile` line to
`MMOCoreORB/bin/scripts/mobile/custom_content/som/serverobjects.lua`, in the same
style and the correct alphabetical position as its neighbours. **That one line is
the only change permitted to that file.**

---

## 8. SCREENPLAYS.LUA

Add exactly one line to `MMOCoreORB/bin/scripts/screenplays/screenplays.lua`,
immediately after line 758 (`mustafar/mustafar_dungeon_population.lua`):

```lua
includeFile("mustafar/battlefields/valley_battlefield.lua")
```

It goes before `story_arc_chapters.lua` (:829) and before
`boundaries/mustafar_boundaries.lua` (:830). Change nothing else in that file.

---

## 9. HOUSE RULES FOR THE CODE

- Tabs for indentation. `if (cond) then` with the parens, the way every file here
  writes it.
- **Nil-guard every `getSceneObject` / `getContainerObject` / cross-screenplay
  reference.** Cross-screenplay guards fail **closed** and `printLuaError` when
  the other screenplay is missing — copy `MustafarInstances:isEntryAllowed`.
- Never silently return where a player is waiting on feedback. `mustafar_instances.lua:602-606`
  explains why in the file itself: "a silent return is indistinguishable from a
  broken radial, and that is how a wrong gate threshold sat unnoticed".
- Every repeating `createEvent` chain checks its session id first and bails if
  stale.
- No `os.date`, no coroutines, no `require`. `os.time()` is fine and already used.
- Comments explain **why**, and every substitution names what live did, what this
  does instead, and the reason. Look at
  `mustafar_dungeon_population.lua` and `mustafar_instances.lua` for the register.
- Do not write a claim you have not checked. If you could not verify a template,
  a loot group or a binding, write that you could not.

---

## 10. WHEN YOU ARE DONE

Do **not** run git. Do **not** commit.

Print a short report:
1. every file you created or modified, with a one-line summary each;
2. every substitution or omission you made and its reason;
3. anything in this spec you could not implement, stated plainly.

The luac gate, the WSL sync and the boot proof are run by the orchestrator, not
by you.
