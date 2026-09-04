# MUSTAFAR TRIALS — VOLCANO BATTLEFIELD: IMPLEMENTATION SPEC

---

## §1 LIFECYCLE

### 1.1 The controller object

`object/tangible/dungeon/mustafar/volcano_battlefield/volcano_battlefield_controller.tpf`:
```
L18  sharedTemplate = "object/tangible/spawning/shared_spawn_egg.iff"
L25  invulnerable = true
L27  persistByDefault = true
L29  objvars = +[ "instance_name"="mustafar_volcano" ]
L31  scripts = +[ "systems.instance.instance_manager",
                  "theme_park.dungeon.mustafar_trials.volcano_battlefield.volcano_event_manager" ]
L33  visibleFlags = [ VF_gm ]
```
One object carries BOTH the instance manager and the dungeon controller. It is invulnerable, persistent, and GM-visible only. It is placed by buildout at `datatables/buildout/mustafar/mustafar_volcano.tab:3` → `647.941 74.7399 448.941`.

### 1.2 Instance registration (boot)

`systems/instance/instance_manager.java:14-23` — `OnAttach` / `OnInitialize` both call `instance.registerInstance(self)`. Nothing spawns at boot. The battlefield is EMPTY until a group starts a session.

`datatables/instance/instance_datatable.tab:13` (field-by-field):
```
dungeon        = mustafar_volcano
enter_one      = "-256,-1,233,none"
enter_two      = (empty)
exit_one       = "-2397,210,1850,mustafar"
exit_two       = (empty)
min_players    = (empty → type default i[0])
max_players    = (empty → type default i[8])
key_required   = mustafar_volcano
failure_string = (empty → s[no_key])
player_script  = theme_park.dungeon.mustafar_trials.volcano_battlefield.volcano_player
time_limit     = (empty → type default i[3600])
lockoutTimer   = daily
vehicle_allowed= (empty → i[0])
```

**Derived, from the type-row defaults:** max 8 players, min 0, 3600s (1 hour) instance duration, daily lockout, no vehicles, key `mustafar_volcano` required.

### 1.3 Session start → the only spawn wave

`systems/instance/instance_manager.java:106-130` `startNewInstance`:
- sets scriptvar `INSTANCE_OWNER`
- sets scriptvar `INSTANCE_START_TIME = getGameTime()`
- `instance.startInstanceTimer(self)`
- adds player to the player list
- `messageTo(player, "movePlayerToInstance", ...)`
- `messageTo(self, "beginSpawn", params, 0.0f, false)`  ← **this is the dungeon boot**

`volcano_event_manager.java:24-29`:
```java
public int beginSpawn(obj_id self, dictionary params) throws InterruptedException
{
    clearEventArea(self);
    spawnActors(self, 1);
    return SCRIPT_CONTINUE;
}
```

`spawnActors(dungeon, 1)` (L71-155) is the ONLY spawn pass. It reads `datatables/dungeon/mustafar_trials/volcano_battlefield/volcano_event_data.iff` (declared `volcano_event_manager.java:13`) and for every row with `stage == 1` (all six rows):

```java
obj_id wp = getWaypointId(dungeon, dict.getString("wp_name"));
location here = getLocation(wp);
float locX = here.x + dict.getInt("locx");
float locY = here.y + dict.getInt("locy");
float locZ = here.z + dict.getInt("locz");
float yaw  = dict.getFloat("yaw");
```
`yaw` — **no `yaw` column exists in the datatable.** Not in source; the read returns the float default.

`getWaypointId` (L156-173) scans `getObjectsInRange(dungeon, 500)` for an object whose objvar `battlePoint` equals the row's `wp_name`.

Because every row's `object` is `simple_spawn_item.iff`, all six go down the `"object/"` branch → `createObject(...)`, then:
```java
trial.markAsTempObject(item, true);
setObjVar(item, "parent", dungeon);
attachScript(item, dict.getString("script"));
event_manager[k++] = item;
```
and the array is stored:
```java
utils.setScriptVar(dungeon, "event_manager", event_manager);
```

**What exists at t=0:** six invisible `simple_spawn_item.iff` controller objects, in table order:
| idx | script attached | position |
|---|---|---|
| 0 | `event_one` | firstPoint + (10,0,5) |
| 1 | `event_two` | secondPoint + (-2,0,6) |
| 2 | `event_three` | thirdPoint + (0,0,23) |
| 3 | `event_four` | fourthPoint + (1,0,1) |
| 4 | `event_five` | finalPoint + (-2,1.2,-18) |
| 5 | `hk_final` | finalEncounter + (-15,0,-39) |

Each controller's `OnAttach` immediately spawns its boss (and event_one its guards). **All bosses and static guards exist from t=0**, invulnerable and inert. Only trigger volumes are staged.

### 1.4 The activation chain

`event_one.java:21-27` is the ONLY event that arms itself at attach:
```java
public int OnAttach(obj_id self) throws InterruptedException
{
    spawnBoss(self);
    messageTo(self, "spawnGuards", null, 2, false);
    setTriggerVolume(self);
    return SCRIPT_CONTINUE;
}
```
Events two–five and hk_final expose `activateEvent` which calls `setTriggerVolume`. That message comes from:

`volcano_event_manager.java:174-198` `eventDefeated`:
```java
int idx = 1;
if (utils.hasScriptVar(self, "idx")) { idx = utils.getIntScriptVar(self, "idx"); }
...
messageTo(event_manager[idx], "activateEvent", null, 0, false);
idx += 1;
if (idx > event_manager.length - 1) { idx = 0; }
utils.setScriptVar(self, "idx", idx);
```
Default `idx = 1`, so the first `eventDefeated` (from event_one's boss) arms `event_manager[1]` = event_two. Sequence is strictly **one → two → three → four → five → hk_final**. Progress is linear and the trigger volume, not the kill, is what starts a fight.

### 1.5 Timers — complete list

**Instance clock**
- `library/instance.java:576-579` `startInstanceTimer` → `messageTo(instance_id, "startClock", ...)`.
- `instance_manager.java:156-171` `startClock`: `instance_time = instance.getInstanceDuration(self)` (= `time_limit` = 3600). If `<= 300`, `handleClockTic` fires immediately; else first tic scheduled at **300s** carrying `instance_time - 300`.
- `instance_manager.java:180-245` `handleClockTic`, session-verified:
  - `if (time < 1)` → `fail_reason = instance.INSTANCE_TIMEOUT`, players messaged, `instance.closeInstance(self)`.
  - else `validatePlayer` on each; if `numPlayers < minPlayers` and no god present → `FAIL_WARN_TOO_FEW`, increments `failed_min_player_check`; `if (lastCheck >= 3)` → `FAIL_INSTANCE_FEW_PLAYERS` + `closeInstance`.
  - `instance.getNextClockTic(time)` (`instance.java:618-631`, 300s granularity); `timeRemaining == 0` → `sendSoonToCloseWarining`; re-arms at `nextTic`.

**So: instance timeout = 3600s, checked every 300s. Three consecutive under-min-player checks also closes it.**

**Post-win cleanout clock** — `volcano_event_manager.java:308-316`:
```java
trial.setDungeonCleanOutTimer(self);
trial.sendCompletionSignal(self, trial.VOLCANO_WIN_SIGNAL);
messageTo(self, "replacePlaceholder", null, 0, false);
badge.grantBadge(players, "bdg_must_victory_volcano");
```
`trial.java:1524-1537` `setDungeonCleanOutTimer(dc)` → `(dc, 300)`: sets `VAR_DUNGEON_END_TIME = getGameTime() + 300`, `messageTo "handleSessionTimerUpdate"`, `instance.setClock(dc, 300)`. **After HK dies you have 300s before the instance closes.**

**Encounter timers (all `messageTo` re-arms):**

| owner | handler | period | file:line |
|---|---|---|---|
| event_one | `doGuardAttack` rotate attacker | **10s** | `event_one.java:112-128` |
| event_one_guard | `healBoss` → boss | **5s** | `event_one_guard.java` |
| event_two_boss | `cycleNextAE` | **18s** | `event_two_boss.java` |
| event_two_boss | PreBurst 0s → Burst **4s** | 4s | `event_two_boss.java` |
| event_three | `doGuardAttackCycle` (one guard) | **10s** | `event_three.java:119-154` |
| event_three | `doResEffect` → `performRez` | **35s** | `event_three.java:292-320` |
| event_three | `performSoloCorpseRez` | **18s** | `event_three.java:351-368` |
| event_four_boss | `spawnAdd` (beetles) | **31s** (`BEETLE_RESPAWN=31`) | `event_four_boss.java:100-137` |
| event_four_boss | `doPoisonAE` | **35s** (`POISON_RECAST=35`) | `event_four_boss.java` |
| event_four_boss | `doDiseaseAE` | 60s (`DISEASE_RECAST=60`) — **never scheduled** | `event_four_boss.java` |
| event_four_boss | `doForceDrainAE` | **22s** (`FORCE_DRAIN_RECAST=22`) | `event_four_boss.java` |
| event_five_boss | `switchTarget` | **18s** (`SWITCH_RECAST=18`) | `event_five_boss.java:384-406` |
| event_five_boss | `applyDistraction` | **24s** (`DISTRACTION_RECAST=24`) | `event_five_boss.java` |
| event_five_boss | `doAEBurst` debuffs | **30s** (`DEBUFF_RECAST=30`) | `event_five_boss.java:312-342` |
| event_five_guard | `doBuffStrip` | **16s** (`BUFF_STRIP_RECAST=16`) | `event_five_guard.java` |
| hk_final_boss | `raiseGuard`/`performRez` | **48s** (`RAISE_RECAST=48`) | `hk_final_boss.java:282-315` |
| hk_final_boss | `switchTarget` | **24s** (`SWITCH_RECAST=24`) | `hk_final_boss.java:608-631` |
| hk_final_boss | `applyDistraction` | **24s** (`DISTRACTION_RECAST=24`) | `hk_final_boss.java:632-642` |
| hk_final_boss | `performDebuffAe` | **45s** (`DEBUFF_RECAST=45`) | `hk_final_boss.java:336-346` |
| hk_final_boss | `performPoisonAe` | **40s** (`POISON_RECAST=40`) | `hk_final_boss.java:532-552` |
| hk_final_boss | `cycleNextAE`→`performDamageAe` | **50s** (`AE_NUKE_RECAST=50`) | `hk_final_boss.java:528-531` |
| hk_final_boss | `performDiseaseAe` | 120s — **never scheduled** | `hk_final_boss.java:553-573` |
| hk_final_boss | `performForceDrainAe` | 34s — **never scheduled** | `hk_final_boss.java:574-607` |
| hk_risen_guard | `healBoss` → HK | **10s** | `hk_risen_guard.java:31-43` |
| hk_gk_septipod | `doBuffStrip` | **16s** | `hk_gk_septipod.java` |

**Boss-fight opener delays:**
- `event_five_boss.java:65-70` `startEventActions`: `doAEBurst` @4s, `switchTarget` @24s, `applyDistraction` @3s.
- `hk_final_boss.java:71-77` `startEventActions`: `startAECycle` @1s, `raiseGuard` @14s, `switchTarget` @24s, `applyDistraction` @3s.
- `hk_final_boss.java:329-335` `startAECycle`: `performDebuffAe` @15s, `performPoisonAe` @27s, `performDamageAe` @35s.

**Universal corpse timer:** every mob's `OnIncapacitated` does `messageTo(self, "destroySelf", null, 5, false)` — **5 seconds from incap to object destroy.**

### 1.6 Player enter

`library/instance.java:771-797` `attachInstanceScriptsOnPlayer` attaches the datatable's `player_script` — `volcano_player` — on entry.
`player/player_instance.java:289-342` `movePlayerToInstance`: reads the instance row, `attachInstanceScriptsOnPlayer`, `setResetDataOnPlayer` if exclusive, `callable.storeCallables(self)`, `utils.dismountRiderJetpackCheck(self)`, then `instance.sendToEnterOne(self, ...)` for team 1 → **`-256,-1,233,none`**.

`volcano_player.java` in full (23 lines):
```java
public int OnAttach(obj_id self) { messageTo(self, "sendEnterSignal", null, 20, false); }
public int sendEnterSignal(obj_id self, dictionary params) {
    groundquests.sendSignal(self, trial.VOLCANO_ENTER_SIGNAL);
}
```
`trial.java:30 VOLCANO_ENTER_SIGNAL = "volcano_arena_pilot"` — fired **20s after entry**, not on arrival.

**Daily lockout** — `instance.java:649-658` `isExclusiveInstance` (true when `lockoutTimer != none`); `instance.java:659-674` `setResetDataOnPlayer` for `RESET_DAILY` → `getCalendarTime() + secondsUntilNextDailyTime(6, 0, 0)`. **Reset at 06:00.**

### 1.7 Player exit

**The only working exit is the autopilot conversation.** `exit_terminal.java` exists (stf `mustafar/decrepit_droid_factory`, ids `decrepit_exit` / `decrepit_exit_confirm`, SUI `YES_NO` → `msgDungeonEjectConfirmed` → `instance.requestExitPlayer("mustafar_volcano", player)`) but **is never attached to any object anywhere in the volcano source.**

Live path — `script/conversation/trial_volcano_autopilot.java`: stf `conversation/trial_volcano_autopilot`, greeting `s_4`, player response `s_6`, end message `s_8`, `ejectPlayer` → `instance.requestExitPlayer("mustafar_volcano", player)`. `OnInitialize`/`OnAttach` set `CONDITION_CONVERSABLE`.

`instance.java:520-538` `requestExitPlayer(instance_name, player, team)` → dismount, `buff.applyBuff(player, "instance_exiting")`, then exit_one/exit_two from the datatable → **`-2397,210,1850,mustafar`**.

### 1.8 Death and disconnect

- **Player death:** no volcano-specific handler. `volcano_player.java` has only `OnAttach` and `sendEnterSignal`. Not in source.
- **Disconnect:** no volcano handler. Generic instance validation only — `instance_manager.java:246-289` `validatePlayer` fails a player who is in a closed instance, not in the player list, or when population exceeds the cap, and calls `instance.requestExitPlayer(instanceName, player, 1)`. `instance.java:816-830` `validateInstanceScriptsOnPlayer` detaches instance player scripts when the player is not in an instance area.
- **Session end** — `instance_manager.java:131-150` `endInstanceSession`: exits both team lists, resets owner/start/lists/team, `trial.bumpSession(self, "clock")`, re-registers the instance, and `messageTo(self, "cleanupSpawn", null, 0.0f, false)`.

`volcano_event_manager.java:30-39` `dungeonCleanup` / `cleanupSpawn` both call `clearEventArea`. `clearEventArea` (L40-70): removes scriptvars `"idx"` and `"observer"`; `getObjectsInRange(self, 500)`; for each non-self, non-player object — if `isMob` → `kill()` then `destroyObject()`; else if `trial.isTempObject` → `destroyObject()`. **Cleanup radius is 500m from the controller.**

### 1.9 Session tokens

Every delayed message in the encounter scripts is guarded by the `trial` session pattern: `trial.bumpSession(obj)` invalidates in-flight messages; `trial.getSessionDict(obj)` stamps the send; `trial.verifySession(self, params)` drops a stale delivery. A boss reset bumps the session, which is how orphaned timers are killed.

---

## §2 THE FIVE EVENTS

Waypoint world positions from `datatables/buildout/mustafar/mustafar_volcano.tab` (columns px py pz); every waypoint carries objvars `battlePoint|4|<name>|ignoreInBuildoutArray|0|1|registerWithController|0|1`.

### 2.1 EVENT ONE — The Taskmaster

- **Anchor:** `firstPoint` = `385.032 74.766 512.445` (buildout L6); offset `(10, 0, 5)` (`volcano_event_data.tab:3`).
- **Controller/volume centre:** **(395.032, 74.766, 517.445)**
- **Volume:** `event_one.java:32` `createTriggerVolume("activateVolume", 45, true)` — **radius 45**
- **Templates:** `event_one.java:18` boss `som_volcano_one_taskmaster`; L19 guard `som_volcano_one_sustainer`

**Spawns (all at attach, t=0):**
- 1 × `som_volcano_one_taskmaster` at controller loc, **yaw 0**, script `event_one_boss`, `ai_lib.BEHAVIOR_SENTINEL`, `trial.setParent` to controller (`event_one.java:53-67`).
- 8 × `som_volcano_one_sustainer`, **yaw 0**, offsets (`event_one.java:75-111`):
```java
{"3:2","6:4","9:7","12:10","-3:2","-6:4","-9:7","-12:10"}
```
each gets objvars `boss` + `parent`, `setInvulnerable(true)`, script `event_one_guard`. Scriptvars `currentGuardList`, `currentAttacker = guards[0]`.

**Activation** — `event_one.java:46-52` `activateEncounter`: boss `setInvulnerable(false)`; every guard gets `activateShield`.

**Mechanic — the shield/heal rotation.** Guards sit invulnerable behind `SHIELD = "effect_shield"` (`event_one_guard.java`), each running `healBoss` **every 5s**. One guard at a time is the attacker: `event_one.java:112-128` `doGuardAttack` rotates via `chooseNewAttacker` (L137-206, random live non-current guard) and re-arms at **10s**. The attacking guard gets `beginAttack` (radius 80, `setInvulnerable(false)`, `startCombat`); `stopAttack` restores invulnerability + shield, clears hate, stops combat.

**Boss** — `event_one_boss.java`:
```java
L29  trial.setHp(self, trial.HP_VOLCANO_ONE_BOSS);   // 545000  (trial.java:214)
     setInvulnerable(true);
```
- `OnEnteredCombat` → parent `beginGuardCycle` (`event_one.java:68-74`: all guards `healBoss`, then `doGuardAttack` @1s).
- `OnExitedCombat` → **`resetEncounter`**: clears all adds by objvar `boss` within 400, `messageTo(parent, "spawnGuards", null, 2, false)`, full heal, `setInvulnerable(true)`, `ai_lib.clearCombatData()`, clears damage buff.
- L15-25 `BUFF_LIST = volc_boss_one_1 … volc_boss_one_8` — one escalation buff per dead guard.
- L101-124 `guardDied`: `utils.sendSystemMessage(getHateList(self), trial.VOLCANO_TASKMASTER_STRENGTHEN)` then applies the next buff in `BUFF_LIST`.
- L125-137 `performGuardHeal`: `PRT_DROID_HEAL` on both, `addToHealth(self, 1000)`.

**Win:** `event_one.java:207-225` `eventMobDied`, `type == "boss"` → `messageTo(getObjIdObjVar(self,"parent"), "eventDefeated", null, 0, false)`. **Unlocks event_two's trigger volume.**

**String ids:** `trial.java:151 VOLCANO_TASKMASTER_STRENGTHEN = new string_id("mustafar/volcano_battlefield", "taskmaster_strengthen")`.
**Effects:** `trial.java:176 PRT_DROID_HEAL = "clienteffect/mus_droid_heal.cef"`, `trial.java:182 PRT_INVULN_SHIELD = "appearance/pt_flash_shield.prt"`.
**HP:** boss 545000 (`trial.java:214`), guard 65000 (`trial.java:213 HP_VOLCANO_ONE_GUARD=65000`).

### 2.2 EVENT TWO — AK Prime

- **Anchor:** `secondPoint` = `454.53 74.7338 399.987` (buildout L8); offset `(-2, 0, 6)` (`volcano_event_data.tab:4`).
- **Centre:** **(452.53, 74.7338, 405.987)**
- **Volume:** `event_two.java:34` radius **45**, armed by `activateEvent`.
- **Templates:** `event_two.java:16` boss `som_volcano_two_ak_prime`; L17 guard `som_volcano_two_hk77`

**Spawns:** 1 boss (script `event_two_boss`) + **4** guards at (`event_two.java:70-102`):
```java
{"-6:-6","6:6","-6:6","6:-6"}
```
guards spawn invulnerable, script `event_two_guard`, and `ai_lib.establishAgroLink(eventBoss, guards)` — **pulling the boss pulls all four.**

**Activation:** `activateEncounter` → boss vulnerable, each guard `activate` (`event_two_guard.java`: `setInvulnerable(false)`).

**Mechanic — the three-AE cycle.** `event_two_boss.java`: `trial.setHp(self, trial.HP_VOLCANO_TWO_BOSS)` = **655280** (`trial.java:216`). On entering combat → `doAEBurst` @0. `cycleNextAE` re-arms every **18s**. `chooseAEType` picks at random from {wave, airfall, cone}. Each is telegraphed: PreBurst particle @0, Burst @**4s**.

**Wave** (L143-183), radius **96**:
- tank: flat **2000** `DAMAGE_ELEMENTAL_HEAT` + `dot.DOT_FIRE`, name `"blast_wave_dot"`, HEALTH, `-1`, **200**, **60**
- everyone else: `Math.round(30000.0f / distance)` + a DOT of `damage/10` for **300**
- spam `("cbt_spam","blast_wave_hit")`
- particles `trial.java:190 PRT_VOLCANO_WAVE_PRE = "appearance/pt_blast_wave_build_up.prt"`, `L191 PRT_VOLCANO_WAVE_EXE = "appearance/pt_blast_wave.prt"`

**Airfall** (L193-224), radius **96**:
- `modDistance = distance / 20` (floor 0.1); `damage = modDistance * 3000` — **ELECTRICAL, more damage the FARTHER you are**
- spam `("cbt_spam","airburst_hit")`
- particles `trial.java:192 PRT_VOLCANO_AIR_PRE = "appearance/pt_rocket_barrage_wind_up.prt"`, `L193 PRT_VOLCANO_AIR_EXE = "appearance/pt_rocket_barrage.prt"`

**Cone** (L234-270): `trial.getValidTargetsInCone(self, target, 96, 30)` — range 96, arc 30°
- primary target: spam digit 2500, damage **2500** COLD
- everyone else in cone: spam digit 3400, damage **8500** COLD
- spam `("cbt_spam","blast_cone_hit")`
- particles `trial.java:194 PRT_VOLCANO_CONE_PRE = "appearance/pt_large_beam_warm_up.prt"`, `L195 PRT_VOLCANO_CONE_EXE = "appearance/pt_large_beam.prt"`

**Guards:** `event_two_guard.java` `trial.setHp(self, trial.HP_VOLCANO_TWO_GUARD)` = **95250** (`trial.java:215`); `destroySelf` @5s; `OnDestroy` → parent `{type:"guard"}`.

**Win:** boss dies → `eventDefeated` → **unlocks event_three.**

### 2.3 EVENT THREE — The Forward Commander (see §3.1 for the revive)

- **Anchor:** `thirdPoint` = `536.664 74.7673 533.382` (buildout L10); offset `(0, 0, 23)` (`volcano_event_data.tab:5`).
- **Centre:** **(536.664, 74.7673, 556.382)**
- **Volume:** `event_three.java:39` radius **45**.
- **Templates:** boss `som_volcano_three_forward_commander`, GUARD `som_volcano_three_hk77`, risen `som_volcano_three_risen_commander`.

**Spawns:** 1 boss at controller loc **yaw 180**, script `event_three_boss`; **15** guards, **yaw 180**, objvar `boss`, script `event_three_guard` (`event_three.java:74-118`):
```java
{"-6:-10","-3:-10","0:-10","3:-10","6:-10",
 "-6:-8","-3:-8","0:-8","3:-8","6:-8",
 "-6:-6","-3:-6","0:-6","3:-6","6:-6"}
```
Scriptvars set: `guards`, `deadBoss = 0`, `deadGuards = 0`, `corpseIdx = 0`; `bumpSession`.

**Activation** (L53-58): sets scriptvar `guardIndex` = 0 and `doGuardAttackCycle` @1s.

**Mechanic — the trickle.** `doGuardAttackCycle` (L119-154) releases **one guard every 10s** (a dead index costs 0s and is skipped). Guards are `setInvulnerable(true)` until released; `beginAttack` acquires at radius 100 then `setInvulnerable(false)` (`event_three_guard.java`). HP 33500 (`trial.java:217`).

**Phase gate** — `event_three.java:155-191` `eventMobDied`:
```java
// guard branch
deadGuards += 1;
placeGuardCorpse(self);
if (deadGuards == 15) { activateBoss(self); return; }
```
```java
// boss branch
deadBoss += 1;
if (deadBoss == 16) { winEncounter(self); return; }
```
**All 15 guards must die before the boss becomes active. Then 16 commander kills win it.**

`activateBoss` (L242-252): boss `beginAttack` @3s and `doResEffect` @10s.

**Boss** — `event_three_boss.java`: `trial.setHp(self, trial.HP_VOLCANO_THREE_BOSS)` = **655250** (`trial.java:219`), `trial.markAsVolcanoCommander(self)` (scriptvar `isCommander`, `trial.java:157`), `setInvulnerable(true)`. `beginAttack` (L92-109): vulnerable, radius 100, `startCombat`.
Bonus loot, L23-40:
```java
int x = rand(1, 100);
if (x <= 12)
{
    // 12% chance at dropping bonus loot Lava Transport Skiff
    static_item.createNewItemFunction("item_tow_schematic_vehicle_02_02", corpseInventory);
}
```

**Win:** `deadBoss == 16` → `winEncounter` → `eventDefeated` → **unlocks event_four.**

### 2.4 EVENT FOUR — Cyborg Prototype

- **Anchor:** `fourthPoint` = `528.992 74.7761 692.472` (buildout L13); offset `(1, 0, 1)` (`volcano_event_data.tab:6`).
- **Centre:** **(529.992, 74.7761, 693.472)**
- **Volume:** `event_four.java:32` radius **45**.
- **Template:** `event_four.java:16` BOSS `som_volcano_four_cym_prototype`

**Spawns** — `event_four.java:51-86` `spawnEvent`: 1 boss **yaw 195**, script `event_four_boss`. **No guards spawn here.** Instead it plants 4 `trial.WP_OBJECT` markers (`trial.java:18 WP_OBJECT = "object/tangible/ground_spawning/patrol_waypoint.iff"`) at:
```java
{"16:-24","-29:-16","-1:11","29:-6"}
```
each `setObjVar(item, "event_5_spawn_point", true)`.

**Activation:** `activateEncounter` → boss `activate`.

**Boss** — `event_four_boss.java`: GUARD `som_volcano_four_lava_beetle`; constants `BEETLE_RESPAWN = 31`, `POISON_RECAST = 35`, `DISEASE_RECAST = 60`, `FORCE_DRAIN_RECAST = 22`. `trial.setHp(self, trial.HP_VOLCANO_FOUR_BOSS)` = **950485** (`trial.java:221`) — the highest HP in the instance. Starts invulnerable.

`OnEnteredCombat` → `doAEBurst` @4s, `spawnAdd` @6s.

**Beetle wave** (L100-137): one `som_volcano_four_lava_beetle` at **every** `event_5_spawn_point` marker (4 of them), random yaw, script `event_four_guard`, objvar `boss`; players notified with `trial.VOLCANO_CYM_BEETLE_NOTIFY` (`trial.java:152` = `("mustafar/volcano_battlefield","four_summon_add")`); **re-arms every 31s.**

**AE suite** (L166-175 `doAEBurst`): `doPoisonAE` @1s and `doForceDrainAE` @8s. `doDiseaseAE` is defined and never scheduled.
- `doPoisonAE` — radius **200**: `dot.applyDotEffect(target, self, dot.DOT_POISON, "volcano_boss_poison_cloud", HEALTH, 125, 455, 30, true, null)`; recast **35**. Effect `trial.java:175 PRT_CYM_POISON = "clienteffect/mus_cym_poison.cef"`.
- `doDiseaseAE` — radius 200, `DOT_DISEASE`, `"volcano_boss_disease_cloud"`, 125, 600, 54; recast 60. Effect `trial.java:174 PRT_CYM_DISEASE = "clienteffect/mus_cym_disease.cef"`. **Unreachable.**
- `doForceDrainAE` — radius **200**: `drainAttributes(target, 1000, 0)` + `"clienteffect/pl_force_channel_self.cef"`; recast **22**.

**Beetles** — `event_four_guard.java`: `beginAttack` on attach plus `setMovementRun`; `trial.setHp(self, trial.HP_VOLCANO_FOUR_GUARD)` = **3000** (`trial.java:220`). `OnIncapacitated` → `nukeSelf` @5s + `PRT_KUBAZA_WARNING`. The nuke: radius **7**, `PRT_KUBAZA_EXPLODE`, `damage(target, DAMAGE_ELEMENTAL_HEAT, HIT_LOCATION_BODY, 2000)`. Effects `trial.java:180 PRT_KUBAZA_EXPLODE = "clienteffect/exp_ap_landmine.cef"`, `L181 PRT_KUBAZA_WARNING = "clienteffect/mus_kubaza_warning.cef"`.

**Win:** boss dies → `eventDefeated` → **unlocks event_five.**

### 2.5 EVENT FIVE — The Oppressor Septipod (see §3.2 for the midguard phase)

- **Anchor:** `finalPoint` = `635.054 74.9744 680.052` (buildout L4); offset `(-2, 1.2, -18)` (`volcano_event_data.tab:7` — the `locy` column is typed `i[0]` yet holds `1.2`).
- **Centre:** **(633.054, 74.9744 + locy, 662.052)**
- **Volume:** `event_five.java:32` radius **45**.
- **Template:** `event_five.java:16` BOSS `som_volcano_five_boss_septipod`

**Spawns** — `event_five.java:51-101`: boss **yaw 195**, and `here.y = here.y - 1;` before the marker loop. **9** `WP_OBJECT` markers:
```java
{"-19:20","24:23","-4:-32","-6:-22","-12:-6","-12:6","13:15","17:0","18:9"}
```
`i < 3` → objvar `trioAddSpawn` (**3 markers**); `else` → objvar `midguardSpawn` (**6 markers**).

**Boss** — `event_five_boss.java` (414 lines): GUARD `som_volcano_five_septipod`, MIDGUARD `som_volcano_five_midguard`; `SWITCH_RECAST = 18`, `DISTRACTION_RECAST = 24`, `DEBUFF_RECAST = 30`. `trial.setHp(self, trial.HP_VOLCANO_FIVE_BOSS)` = **220000** (`trial.java:224`) — the *lowest* boss HP, because the fight is about the adds. `activate` → vulnerable.

**Health ladder** (L75-106 `OnCreatureDamaged`):
```java
<= 0.2  spawnTrioAdd(20)
<= 0.4  spawnTrioAdd(40)
<= 0.5  spawnMidGuard          // the invulnerable phase — see §3.2
<= 0.6  spawnTrioAdd(60)
<= 0.8  spawnTrioAdd(80)
```

**Trio adds** (L218-250): `som_volcano_five_septipod` at all **3** `trioAddSpawn` markers, script `event_five_guard`; notify `trial.VOLCANO_OPP_ADD_NOTIFY` (`trial.java:153` = `("mustafar/volcano_battlefield","five_summon_trio")`).

`event_five_guard.java`: HP **50000** (`trial.java:222`); acquires at radius 150 then `doBuffStrip` every **16s** via `queueCommand(self, (1679682244), target, "", COMMAND_PRIORITY_FRONT)`; `REMOVED_BUFF = new string_id("mustafar/volcano_battlefield", "buff_removed")`; `destroySelf` → parent `{type:"trio"}`.

**Debuff AE** (L312-342 `getDebuffEffects`) — three rotating pools, cycled by scriptvars `debuff.ham` / `debuff.debuff` / `debuff.skill`:
```
ham    : bio_etheric_shock, torpor, vacuity
debuff : lethargy, wavering, toxic_dissolution
skill  : obfuscation, confusion, corrosion
```
`doAEBurst` applies **all three** within radius **400**; recast **30s**.

**Other abilities:** `applyDistraction` — buff `distraction`, recast 24. `switchTarget` (L384-406) — if the hate list has more than one entry, apply buff `enfeeble` and `setHate(self, target, 1.0f)`; recast 18.

**Win** — `event_five.java:102-125` `eventMobDied`, `"boss"` → `winEncounter` → `eventDefeated`. **Unlocks hk_final.**

---

## §3 THE SPECIALS

### 3.1 Event Three — the corpse revive

**Corpse pool.** `event_three.java:202-241` `placeGuardCorpse` runs once per guard death, using scriptvar `corpseIdx` against a fixed 15-slot offset table:
```java
{"7:4","2:-6","0:-11","-5:1","14:-13","-18:-32","-18:-23","6:-2",
 "16:-8","18:-14","-18:4","5:-4","11:4","-3:-12","7:-29"}
```
Each corpse is a fresh `som_volcano_three_hk77` (GUARD template), `POSTURE_DEAD`, `trial.prepareCorpse` (`trial.java:1828-1831` — `detachScript(corpse, "ai.ai")`), `trial.markAsVolcanoCorpse` (scriptvar `isCorpse`, `trial.java:158`), `setInvulnerable(true)`, objvar `boss`. **The corpse is a new object placed at a scripted spot, not the body where the guard fell.**

**Arming.** `activateBoss` (L242-252) fires `doResEffect` @10s alongside the boss's `beginAttack` @3s.

**Scan.** `doResEffect` (L253-291) gathers, within **400**: live objects with scriptvar `isCommander` (set by `trial.markAsVolcanoCommander` on `event_three_boss` and `event_three_boss_revived`), and objects with scriptvar `isCorpse`.

**Pairing.** `performRez` (L292-320): index-pairs `boss[i]` with `corpse[i]` — **every living commander revives one corpse simultaneously.** Per pair: `PRT_DROID_REVIVE` played at both (`trial.java:177 = "clienteffect/mus_droid_revive.cef"`), destroy the corpse, create `som_volcano_three_risen_commander` at the corpse location, `setYaw(rand(0, 360))`, attach `event_three_boss_revived`, `trial.setParent`, objvar `boss`. Then re-arm `doResEffect` at **35s**.

**The escalation.** Each revived commander is itself marked `isCommander`, so it joins the next scan as a rezzer. One commander → two → four → eight. The pool is capped at the **15 corpses** ever placed; win is `deadBoss == 16` (original + 15 revives).

**Risen commander** — `event_three_boss_revived.java`: `beginAttack` @3s, `trial.setHp(self, trial.HP_VOLCANO_THREE_RISEN)` = **60250** (`trial.java:218`), `markAsVolcanoCommander`; `destroySelf` @5s; `OnDestroy` sends `{type:"boss"}` **unless objvar `"reset"` is set**.

**Fallback.** `checkForLastBoss` (L321-350) and `performSoloCorpseRez` (L351-368) handle the single-commander case; the solo path re-arms at **18s** — faster than the 35s group cycle.

### 3.2 Event Five — the midguard / invulnerable phase

**Trigger.** At **50% health** exactly once (`event_five_boss.java:75-106`), the boss calls `spawnMidGuard(self)` — L195-206:
```java
if (!hasObjVar(self, "spawnedMidguard"))
{
    setInvulnerable(self, true);
    clearHateList(self);
    stopCombat(self);
    setObjVar(self, "spawnedMidguard", true);
    messageTo(self, "spawnMidGuard", null, 5, false);
}
```
The boss drops combat and becomes untouchable; the midguards arrive **5 seconds later**.

**The wall.** `spawnMidGuard(self, params)` (L251-283): `som_volcano_five_midguard` at **all 6** `midguardSpawn` markers (the `i >= 3` markers planted by `event_five.java:51-101`), random yaw, script `event_five_midguard`, `trial.setParent` to the boss. Players notified with `trial.VOLCANO_OPP_MIDGUARD` (`trial.java:154` = `("mustafar/volcano_battlefield","five_summon_midguard")`).

`event_five_midguard.java`: `trial.setHp(self, trial.HP_VOLCANO_FIVE_MIDGUARD)` = **100000** each (`trial.java:223`) — **600000 total, nearly 3× the boss's own 220000.** Acquires at radius 150. `destroySelf` @5s → `trial.getParent(self)` receives `{type:"midguard"}` then `destroyObject`.

**The gate.** `event_five_boss.java:136-160` `eventMobDied`, `"midguard"` branch: counts into objvar `deadMidguard`;
```java
if (count == 6) { resumeAttack(self); return; }
```
`resumeAttack` (L161-172): `setInvulnerable(false)`, scan radius **200**, `startCombat` on the closest. **If it finds nobody, it falls through to `verifyHealthReset`.**

**Why the phase cannot be skipped** — `verifyHealthReset` (L107-135) opens with:
```java
if (isInvulnerable(self)) { return; }
```
So while the midguards are up, the boss will not reset. When a reset does run: full heal, `utils.removeObjVarList(self, {"spawned80","spawned60","spawnedMidguard","spawned40","spawned20","deadMidguard"})` (which re-arms every ladder step including the midguard phase), `clearAllAdds` (children within 200), `ai_lib.clearCombatData()`, `setInvulnerable(true)`.

**Note on the event's own counter.** `event_five.java:102-125` has a `"midPointGuard"` branch that increments scriptvar `midGuard` and at 6 calls `reactivateBoss` → `messageTo(eventBoss, "reactivate", null, 3, false)`. The midguards actually send `"midguard"` to their parent, which is the boss — so the boss's own counter is the live one.

---

## §4 THE HK-47 FINALE

### 4.1 Trigger

- **Anchor:** `finalEncounter` = `650 74.7164 453` (buildout L16); offset `(-15, 0, -39)` (`volcano_event_data.tab:8`).
- **Centre:** **(635, 74.7164, 414)**
- **Volume:** `hk_final.java:33` `createTriggerVolume("activateVolume", 95, true)` — **radius 95, the largest in the instance.**

`hk_final.java:47-55` `activateEncounter`:
```java
messageTo(self, "spawnSquadLeaders", null, 0, false);
messageTo(parent, "landYt", null, 0, false);
messageTo(parent, "doHkTaunt", dict, 0, false);   // dict holds hk
removeTriggerVolume(self, "activateVolume");
```
Three things at once: the squad wall spawns, the YT-2400 begins its landing 200m away, and HK taunts.

`volcano_event_manager.java:199-210` `doHkTaunt`:
```java
utils.messagePlayer(hk, players, trial.VOLCANO_HK_TAUNT, "object/mobile/som/hk47.iff");
instance.playMusicInInstance(self, trial.MUS_VOLCANO_HK_INTRO);
```
`trial.java:156 VOLCANO_HK_TAUNT = new string_id(VOLCANO_STF, "hk_prefight_taunt")`; `trial.java:199 MUS_VOLCANO_HK_INTRO = "sound/mus_mustafar_hk47_intro.snd"`.

### 4.2 Spawn layout

`hk_final.java:56-110` `spawnEvent` (at controller attach, t=0): HK at the controller location, **`setYaw(25)`**, script `hk_final_boss`. Templates: L16 BOSS `som_volcano_final_hk47`, L17 SQUAD_LEADER `som_volcano_final_squadleader`.

Then **10** `WP_OBJECT` markers:
```java
{"55:34","9:48","-18:18","23:-30","15:-1","-18:3","-2:46","27:33","39:4","-21:28"}
```
- `i < 4` → objvar **`hk_beetle`** (4 markers: `55:34`, `9:48`, `-18:18`, `23:-30`)
- `i < 6` → objvar **`hk_walker`** (2 markers: `15:-1`, `-18:3`)
- else → objvar **`hk_septipod`** (4 markers: `-2:46`, `27:33`, `39:4`, `-21:28`)

### 4.3 The 14-mob squad wall

`hk_final.java:111-137` `spawnSquadLeaders`: sets scriptvars `sl_guard = 0` and `corpseIdx = 0`, then **2** `som_volcano_final_squadleader` at:
```java
{"-1:32","32:25"}
```
script `hk_squad_leader`, **yaw 25**.

`hk_squad_leader.java:54-92` `generateSquad` (runs in `OnAttach`, L23-28, alongside `trial.setHp(self, trial.HP_VOLCANO_HK_SQUAD_LEADER)` = **20000**, `trial.java:226`): each leader creates **6** `som_volcano_final_squadmember` at offsets relative to itself:
```java
{"-3:0","-5:0","-7:0","-3:3","-5:3","-7:3"}
```
each parented to the **event controller** (`trial.setParent(eventController, item, false)`), script `hk_squad_member`, **yaw 25**, `ai_lib.setDefaultCalmBehavior(item, ai_lib.BEHAVIOR_SENTINEL)`. The array is stored as objvar `guardList`.

**2 leaders × (1 leader + 6 members) = 14.**

`hk_squad_leader.java:29-48` `OnDestroy`: sends `{type:"sl_guard"}` to the parent, then loops `guardList` sending each member `leaderDied`.
`hk_squad_member.java` (53 lines): HP `trial.HP_VOLCANO_HK_SOLDIER` = **14000** (`trial.java:225`); `OnIncapacitated` → `destroySelf` @5s; `OnDestroy` → `{type:"sl_guard"}`; `leaderDied` → `buff.applyBuff(self, "low_morale")`. **Killing a leader debuffs its six survivors rather than killing them.**

**The gate** — `hk_final.java:138-162` `eventMobDied`:
```java
guard += 1;
placeGuardCorpse(self);
if (guard == 14) { activateHK(self); return; }
```
`activateHK` → `messageTo(eventBoss, "activate", null, 3, false)`. **All 14 must die before HK is attackable.**

**Corpses** — `hk_final.java:163-200` `placeGuardCorpse`, 14 offsets:
```java
{"7:26","-10:34","0:18","-5:46","10:35","26:32","-18:23",
 "6:39","24:38","18:27","31:19","5:26","11:21","-3:31"}
```
template `som_volcano_final_squadmember`, `trial.prepareCorpse`, `POSTURE_DEAD`, `trial.markAsHkCorpse` (scriptvar `isCorpse`, `trial.java:160`), `setInvulnerable(true)`, parented to HK. **This is the ammunition for HK's revive.**

`winEncounter` → `messageTo(top, "hkDefeated", null, 0, false)`.

### 4.4 HK-47 himself

`hk_final_boss.java` (650 lines). Templates: GUARD `som_volcano_final_risen_sustainer`, KUBAZA `som_volcano_final_lava_beetle`, AKBOT `som_volcano_final_walker`, GKBOT `som_volcano_final_septipod`.

Recast constants:
```java
DISTRACTION_RECAST = 24   SWITCH_RECAST = 24    DEBUFF_RECAST = 45
POISON_RECAST = 40        RAISE_RECAST = 48     DISEASE_RECAST = 120
AE_NUKE_RECAST = 50       FORCE_DRAIN_RECAST = 34
```
`trial.setHp(self, trial.HP_VOLCANO_HK47)` = **545852** (`trial.java:231`). Level **83**, difficulty **BOSS** (`creatures.tab:4851`).

**Activate** (L82-89): `setInvulnerable(false)`, scan radius **90**, `startCombat` on closest.
**Opening** (L71-77 `startEventActions`): `startAECycle` @1s, `raiseGuard` @14s, `switchTarget` @24s, `applyDistraction` @3s.
**AE cycle** (L329-335 `startAECycle`): `performDebuffAe` @15s, `performPoisonAe` @27s, `performDamageAe` @35s.

**Add ladder** (L90-111 `OnCreatureDamaged`):
```java
<= 0.2  summonAdd(20)
<= 0.5  summonAdd(50)
<= 0.8  summonAdd(80)
```
`getAddType` (L144-166) maps threshold → template + marker objvar:
| threshold | template | markers | count | script | notify |
|---|---|---|---|---|---|
| 80% | `som_volcano_final_lava_beetle` | `hk_beetle` | 4 | `hk_beetle` | `VOLCANO_CYM_BEETLE_NOTIFY` |
| 50% | `som_volcano_final_septipod` | `hk_septipod` | 4 | `hk_gk_septipod` | `VOLCANO_OPP_ADD_NOTIFY` |
| 20% | `som_volcano_final_walker` | `hk_walker` | 2 | `hk_ak_guardian` | `VOLCANO_HK_SUMMON_AK` |

`summonAdd(params)` (L191-253) spawns at **every** matching marker, random yaw, parented to HK, then `messageTo(spawned, "beginAttack", null, 2, false)`. `trial.java:155 VOLCANO_HK_SUMMON_AK = new string_id(VOLCANO_STF, "hk_summon_walker")`.

**Reset** — `verifyHealthReset` (L112-133):
```java
// full heal
utils.removeObjVarList(self, {"spawned80","spawned50","spawned20",
                              "ytSummoned","ytStrafing","stopRezEffect"});
clearAllAdds(...);
messageTo(parent, "spawnSquadLeaders", null, 0, false);
setInvulnerable(self, true);
trial.bumpSession(self);
```
**A wipe rebuilds the entire 14-mob squad wall and re-arms every add threshold.** HK returns to invulnerable and the group must clear all 14 again. Unlike `event_five_boss.verifyHealthReset`, there is **no `isInvulnerable` guard here.**

**Revive** — `raiseGuard` / `performRez` (L282-315): scans within **200** for scriptvar `isCorpse`; picks **ONE at random** (not all — contrast event_three); plays `PRT_DROID_REVIVE` at both HK and the corpse; destroys the corpse; creates `som_volcano_final_risen_sustainer`; attaches `hk_risen_guard`; parents to HK; re-arms at **48s**.

`hk_risen_guard.java`: `beginAttack` @3s, `healBoss` @10s, HP `trial.HP_VOLCANO_HK_RISEN_GUARD` = **22525** (`trial.java:227`). `healBoss` messages the parent `performGuardHeal` and re-arms every **10s**; `beginAttack` scans radius 90.
`hk_final_boss.java:316-328` `performGuardHeal`: `addToHealth(self, 1000)` + `PRT_DROID_HEAL`. **Each living risen guard heals HK 1000 every 10s.**

**Damage AE** (L405-413): `chooseAEType` returns `{"wave","wave"}` — **only the wave is reachable.** `performDamageAe` → `doWavePreBurst` @3s, `doWaveBurst` @7s.
`doWaveBurst` (L447-486), radius **96**:
- tank: combat spam digit **400**, actual `damage(target, DAMAGE_ELEMENTAL_HEAT, HIT_LOCATION_BODY, 1500)`
- others: `Math.round(15000.0f / distance)` + `DOT_FIRE` of `damage/10` for **60**
`doAirfallBurst` (L496-527, `modDistance * 3000` ELECTRICAL) is unreachable. `cycleNextAE` (L528-531) re-arms `performDamageAe` at **50s**.

**Debuff AE** (L336-346 `performDebuffAe`), radius **200**, recast **45** — smaller pools than event five:
```
ham    : torpor, vacuity
debuff : lethargy, toxic_dissolution
skill  : obfuscation, confusion
```

**Poison AE** (L532-552 `performPoisonAe`): radius **200**, `DOT_POISON`, 125, **235**, 30; recast **40**.
**Disease AE** (L553-573): radius 300, `DOT_DISEASE`, `-1`, **1200**, 54; recast 120 — **never scheduled.**
**Force drain AE** (L574-607): radius 300, `isJedi` targets only, `forceDamage = 210` clamped to the target's pool, `alterForcePower(target, -forceDamage)`, spam `("cbt_spam","forcedrain_hit")`; recast 34 — **never scheduled.**

**Target control:** `switchTarget` (L608-631) applies buff `enfeeble` then `removeHateTarget`, recast **24**. `applyDistraction` (L632-642) applies buff `distraction`, recast **24**.

**YT strafe:** `callYT` (L134-143) is guarded by objvar `ytSummoned` and sends `"landYT"` — **it is never called from anywhere in the file.** (The manager's handler is `landYt`.)

### 4.5 Death sequence

`hk_final_boss.java:33-51` `OnIncapacitated`:
```java
endEventActions(self);
// dict {type:"boss"} to parent
int x = rand(1, 100);
if (x <= 15)
{
    // 15% chance at dropping bonus loot Mustafar Bunker
    createObject("object/building/player/player_mustafar_house_lg.iff", corpseInventory, "");
}
```
→ `hk_final.eventMobDied` `"boss"` → `winEncounter` → `messageTo(top, "hkDefeated", ...)`.

`volcano_event_manager.java:308-316` `hkDefeated`:
```java
trial.setDungeonCleanOutTimer(self);                       // 300s to close
trial.sendCompletionSignal(self, trial.VOLCANO_WIN_SIGNAL); // "volcano_arena_victory"
messageTo(self, "replacePlaceholder", null, 0, false);
badge.grantBadge(players, "bdg_must_victory_volcano");
```
`trial.java:1547-1551 sendCompletionSignal` → `groundquests.sendSignal(instance.getPlayersInInstanceArea(dungeon), signal)`; `trial.java:31 VOLCANO_WIN_SIGNAL = "volcano_arena_victory"`.

### 4.6 The YT-2400 exit

**Landing** (fired at HK trigger, not at his death) — `volcano_event_manager.java:211-247` `landYt`:
```java
spawnLoc.x += 31.6;
spawnLoc.z += 2.2;
obj_id yt = createObject("object/creature/npc/theme_park/must_yt2400.iff", spawnLoc, ...);
setPosture(yt, POSTURE_PRONE);
setYaw(yt, -163);
detachScript(yt, "ai.ai");
detachScript(yt, "ai.creature_combat");
detachScript(yt, "skeleton.humanoid");
detachScript(yt, "systems.combat.combat_actions");
detachScript(yt, "systems.combat.credit_for_kills");
detachScript(yt, "player.species_innate");
attachScript(yt, "...volcano_battlefield.yt_controller");
messageTo(yt, "performLanding", null, 2, false);
messageTo(self, "playSmoke", dict, 34, false);
```
Base is the controller location, so landing = `647.941 + 31.6, 74.7399 + 2, 448.941 + 2.2` → **(679.541, 76.9399, 451.141)**. Six scripts stripped; the ship is a posed creature, not an AI.

`yt_controller.java` in full (33 lines):
```java
OnInitialize    -> destroyObject(self);
performLanding  -> queueCommand(self, (-1465754503), self, "", COMMAND_PRIORITY_FRONT);
                   setPosture(self, POSTURE_UPRIGHT);
performTakeoff  -> queueCommand(self, (-1114832209), self, "", COMMAND_PRIORITY_FRONT);
                   setPosture(self, POSTURE_PRONE);
selfDestruct    -> destroyObject(self);
```
Note `OnInitialize` destroys the object — the ship does not survive a server restart.

`volcano_event_manager.java:248-257` `playSmoke` (34s after landing starts): `playClientEffectLoc(viewer[0], trial.PRT_VOLCANO_YT_LANDING, landLoc, 1.0f)` — `trial.java:196 = "appearance/must_smoke_plume01.prt"`.

**Swap to the boardable ship** (only on `hkDefeated`) — `volcano_event_manager.java:258-276` `replacePlaceholder`:
```java
createObject("object/building/mustafar/structures/must_grounded_yt2400.iff", ...);
// cell "bridge"
messageTo(self, "destroyOld", dict, 2, false);
location pilotLoc = new location(25, 5, 13, spawnLoc.area, bridge);
obj_id pilot = create.object("som_volcano_autopilot", pilotLoc);
attachScript(pilot, "conversation.trial_volcano_autopilot");
```
`volcano_event_manager.java:283-307` `destroyYt`: if it's the temp YT, `performTakeoff` @0 then `selfDestruct` @**20s**; otherwise destroy outright.

**The exit is the conversation.** `som_volcano_autopilot` stands at cell-local **(25, 5, 13)** in cell `"bridge"`. `script/conversation/trial_volcano_autopilot.java`: greeting `s_4`, response `s_6`, end `s_8`, `ejectPlayer` → `instance.requestExitPlayer("mustafar_volcano", player)` → `-2397,210,1850,mustafar`. The grounded ship exists only after HK dies, and the 300s cleanout clock is already running.

---

## §5 FULL CREATURE ROSTER

`datatables/mob/creatures.tab:4850-4871`. Header columns used: `creatureName, BaseLevel, …, difficultyClass e(NORMAL=0,ELITE=1,BOSS=2), …, socialGroup, pvpFaction, …, template, minScale, maxScale, …, armorKinetic/Energy/Blast/Heat/Cold/Electric/Acid/Stun, attackSpeed, …, lootTable/lootList, collectionLoot, niche, primary_weapon, specials, aggressive/assist/…`.

**Shared by every som_volcano combat mob:** armor block `75/75/100/60/100/25/40/85`, `attackSpeed 2`, `socialGroup`/`pvpFaction` = `droid_army`, `where = mustafar`, `death_blow instant` (except where noted).

| creatureName | Lvl | Class | Appearance template | Scale | Weapon | Loot / collection | Spawned by | HP (trial.java) | Count |
|---|---|---|---|---|---|---|---|---|---|
| `som_volcano_one_taskmaster` (4865) | 85 | BOSS | `som/hk77.iff` | 1.5 | `droid_hk77_boss.iff` | `mustafar/mustafar_trial_taskmaster` · chronicle `hk_taskmaster` · CREDITS | `event_one.java:53-67` | 545000 (L214) | 1 |
| `som_volcano_one_sustainer` (4864) | 83 | ELITE | `som/hk77.iff` | 1.3 | `droid_hk77_elite.iff` | — | `event_one.java:75-111` | 65000 (L213) | 8 |
| `som_volcano_two_ak_prime` (4870) | 85 | BOSS | `som/cww8a_battle_droid.iff` | — | `droid_cww8_01.iff` | `mustafar/mustafar_trial_akprime` · chronicle `hk_ak_prime` · CREDITS | `event_two.java` | 655280 (L216) | 1 |
| `som_volcano_two_hk77` (4871) | 83 | ELITE | `som/hk77.iff` | 1.3 | `droid_hk77_assault_droid.iff` | — · **aggressive 1, death_blow yes** | `event_two.java:70-102` | 95250 (L215) | 4 |
| `som_volcano_three_forward_commander` (4867) | 85 | BOSS | `som/hk77.iff` | 1.5 | `droid_hk77_boss.iff` | `mustafar/mustafar_trial_cmdr_mk2` · chronicle `hk_forward_commander` · CREDITS · +12% skiff schematic | `event_three.java` | 655250 (L219) | 1 |
| `som_volcano_three_hk77` (4868) | 80 | ELITE | `som/hk77.iff` | 1.3 | `droid_hk77_assault_droid.iff` | — | `event_three.java:74-118` + corpses L202-241 | 33500 (L217) | 15 live + 15 corpses |
| `som_volcano_three_risen_commander` (4869) | 82 | ELITE | `som/hk77.iff` | 1.4 | `droid_hk77_elite.iff` | — | `event_three.java:292-320` | 60250 (L218) | up to 15 |
| `som_volcano_four_cym_prototype` (4861) | 85 | BOSS | `som/volcano_cyborg_lt.iff` | 1.2 | `jedi_dark` / `jedi_dark_ranged` | `mustafar/mustafar_trial_cym` · chronicle `hk_cym_prototype` · CREDITS | `event_four.java:51-86` | 950485 (L221) | 1 |
| `som_volcano_four_lava_beetle` (4862) | 80 | ELITE | `som/kubaza_beetle.iff` | 1.2 | — · niche carnivore · `generic_creature_special_6` | — | `event_four_boss.java:100-137` | 3000 (L220) | 4 per 31s wave |
| `som_volcano_five_boss_septipod` (4858) | 82 | BOSS | `som/union_sentry_droid.iff` | 1.3 | `droid_union_sentry_02.iff` | `mustafar/mustafar_trial_oppressor` · chronicle `hk_gk_oppressor` · CREDITS | `event_five.java:51-101` | 220000 (L224) | 1 |
| `som_volcano_five_septipod` (4860) | 83 | ELITE | `som/union_sentry_droid.iff` | 1.0 | `droid_union_sentry.iff` | — | `event_five_boss.java:218-250` | 50000 (L222) | 3 per ladder step (×4) |
| `som_volcano_five_midguard` (4859) | 83 | ELITE | `som/union_sentry_droid.iff` | 0.9 | `droid_union_sentry_01.iff` | — | `event_five_boss.java:251-283` | 100000 (L223) | 6 |
| `som_volcano_final_hk47` (4851) | 83 | BOSS | `som/hk47.iff` | 1.3 | — · `android` · `droid_special_6` 24/24 · aggressive+assist · maxCash 100 | `mustafar/mustafar_trial_hk47` · chronicle `hk47` · `col_shattered_shard_02` · CREDITS · +15% Mustafar Bunker | `hk_final.java:56-110` | 545852 (L231) | 1 |
| `som_volcano_final_squadleader` (4855) | 83 | ELITE | `som/hk77.iff` | 1.3 | `droid_hk77_boss.iff` | — | `hk_final.java:111-137` | 20000 (L226) | 2 |
| `som_volcano_final_squadmember` (4856) | 80 | ELITE | `som/hk77.iff` | 1.3 | `droid_hk77_assault_droid.iff` | — | `hk_squad_leader.java:54-92` + corpses `hk_final.java:163-200` | 14000 (L225) | 12 live + 14 corpses |
| `som_volcano_final_risen_sustainer` (4853) | 80 | ELITE | `som/hk77.iff` | 1.3 | `droid_hk77_elite.iff` · `droid_special_6` | — | `hk_final_boss.java:282-315` | 22525 (L227) | 1 per 48s |
| `som_volcano_final_lava_beetle` (4852) | 80 | ELITE | `som/kubaza_beetle.iff` | 1.2 | — · carnivore · `generic_creature_special_6` 24/24 | — | `hk_final_boss.java:191-253` (80%) | 9000 (L228) | 4 |
| `som_volcano_final_septipod` (4854) | 82 | ELITE | `som/union_sentry_droid.iff` | 0.9 | `droid_union_sentry_01.iff` | — | `hk_final_boss.java:191-253` (50%) | 75250 (L229) | 4 |
| `som_volcano_final_walker` (4857) | 83 | ELITE | `som/cww8_battle_droid.iff` | — | `droid_cww8_01.iff` · droid | — | `hk_final_boss.java:191-253` (20%) | 55855 (L230, `HP_VOLCANO_HK_CWW`) | 2 |
| `som_volcano_autopilot` (4850) | 100 | NORMAL | `3po_protocol_droid_red.iff` · protocoldroid · **no combat stats** | — | — | — | `volcano_event_manager.java:258-276` | — | 1 |
| `som_volcano_observer` (4863) | 80 | BOSS | `death_watch_battle_droid` · android · `droid_special_6` | — | — | — | **never spawned** — `volcano_event_data.tab` has no row for it, though `volcano_event_manager.java:71-155` has a dead branch storing it as scriptvar `"observer"` | — | 0 |
| `som_volcano_pilot` (4866) | 1 | NORMAL | `som/miner_pilot.iff` · commoner | — | pirate weapons · `npc/npc_1_10` | — | **never spawned** in volcano source | — | 0 |

**Peak simultaneous population (HK phase):** 1 HK + 2 leaders + 12 members = 15 at the wall; after activation up to 4 beetles + 4 septipods + 2 walkers + N risen sustainers.

**Raw HP constants** — `script/library/trial.java:213-231`:
```
L213 HP_VOLCANO_ONE_GUARD        = 65000     L214 HP_VOLCANO_ONE_BOSS        = 545000
L215 HP_VOLCANO_TWO_GUARD        = 95250     L216 HP_VOLCANO_TWO_BOSS        = 655280
L217 HP_VOLCANO_THREE_GUARD      = 33500     L218 HP_VOLCANO_THREE_RISEN     = 60250
L219 HP_VOLCANO_THREE_BOSS       = 655250    L220 HP_VOLCANO_FOUR_GUARD      = 3000
L221 HP_VOLCANO_FOUR_BOSS        = 950485    L222 HP_VOLCANO_FIVE_GUARD      = 50000
L223 HP_VOLCANO_FIVE_MIDGUARD    = 100000    L224 HP_VOLCANO_FIVE_BOSS       = 220000
L225 HP_VOLCANO_HK_SOLDIER       = 14000     L226 HP_VOLCANO_HK_SQUAD_LEADER = 20000
L227 HP_VOLCANO_HK_RISEN_GUARD   = 22525     L228 HP_VOLCANO_HK_BEETLE       = 9000
L229 HP_VOLCANO_HK_SEPTIPOD      = 75250     L230 HP_VOLCANO_HK_CWW          = 55855
L231 HP_VOLCANO_HK47             = 545852
```
`trial.java:1636-1655 setHp` → `setMaxAttrib` / `setAttrib` on `HEALTH`.

---

## §6 COORDINATES

### 6.1 Buildout — absolute world positions (`datatables/buildout/mustafar/mustafar_volcano.tab`)

```
L3   volcano_battlefield_controller.iff   647.941  74.7399  448.941
L4   finalPoint                           635.054  74.9744  680.052
L5   zoneIn                               389.646  74.8142  648.353
L6   firstPoint                           385.032  74.766   512.445
L7   firstPathPoint                       434.928  74.7924  468.502
L8   secondPoint                          454.53   74.7338  399.987
L9   secondPathPoint                      516.608  74.6883  415.536
L10  thirdPoint                           536.664  74.7673  533.382
L11  thirdPathPoint                       538.943  74.7163  585.989
L12  fourthPathPoint                      506.712  74.6705  649.509
L13  fourthPoint                          528.992  74.7761  692.472
L14  fifthPathPoint                       630.182  74.5388  608.466
L15  sixthPathPoint                       702.584  74.3557  561.256
L16  finalEncounter                       650      74.7164  453
```
Every one carries objvars `battlePoint|4|<name>|ignoreInBuildoutArray|0|1|registerWithController|0|1`. `battlePoint` is the key `getWaypointId` matches (`volcano_event_manager.java:156-173`).

`mustafar_volcano.tab:17-44` are scenery: `object/building/mustafar/terrain/must_rock_spire_*`.

### 6.2 Event controller / trigger-volume centres (waypoint + `volcano_event_data.tab` offset)

| event | anchor | offset (locx, locy, locz) | **world centre** | radius |
|---|---|---|---|---|
| event_one | firstPoint | `10 0 5` | **395.032, 74.766, 517.445** | 45 |
| event_two | secondPoint | `-2 0 6` | **452.53, 74.7338, 405.987** | 45 |
| event_three | thirdPoint | `0 0 23` | **536.664, 74.7673, 556.382** | 45 |
| event_four | fourthPoint | `1 0 1` | **529.992, 74.7761, 693.472** | 45 |
| event_five | finalPoint | `-2 1.2 -18` | **633.054, 74.9744+locy, 662.052** | 45 |
| hk_final | finalEncounter | `-15 0 -39` | **635, 74.7164, 414** | 95 |

`volcano_event_data.tab` columns: `object stage locx locy locz script wp_name objvar path`, types `s i[1] i[0] i[0] i[0] s[none] s[none] s[none] s`. **The `locy` on the event_five row is `1.2` in a column typed `i[0]`** — the read is `dict.getInt("locy")`, so it truncates. Row 3 also carries a `path` string that no script ever reads:
```
firstBranch:zoneIn:firstPoint:firstPathPoint:secondPoint:secondPathPoint:thirdPoint:thirdPathPoint:fourthPathPoint:fourthPoint:finalPoint:fifthPathPoint:sixthPathPoint
```

### 6.3 Relative offsets — every hardcoded spawn table

All are `"X:Z"` strings parsed by `split(offSet[i], ':')` and added to the spawner's own location; Y is inherited.

**event_one guards, 8** (`event_one.java:75-111`) — a V behind the boss:
```
3:2  6:4  9:7  12:10  -3:2  -6:4  -9:7  -12:10
```
**event_two guards, 4** (`event_two.java:70-102`) — corners:
```
-6:-6  6:6  -6:6  6:-6
```
**event_three guards, 15** (`event_three.java:74-118`) — three ranks of five:
```
-6:-10  -3:-10  0:-10  3:-10  6:-10
-6:-8   -3:-8   0:-8   3:-8   6:-8
-6:-6   -3:-6   0:-6   3:-6   6:-6
```
**event_three corpses, 15** (`event_three.java:202-241`) — scattered, consumed in order by `corpseIdx`:
```
7:4  2:-6  0:-11  -5:1  14:-13  -18:-32  -18:-23  6:-2
16:-8  18:-14  -18:4  5:-4  11:4  -3:-12  7:-29
```
**event_four markers, 4** (`event_four.java:51-86`) — objvar `event_5_spawn_point`:
```
16:-24  -29:-16  -1:11  29:-6
```
**event_five markers, 9** (`event_five.java:51-101`) — `i<3` = `trioAddSpawn`, else `midguardSpawn`; note `here.y = here.y - 1` first:
```
trioAddSpawn : -19:20   24:23   -4:-32
midguardSpawn: -6:-22  -12:-6  -12:6  13:15  17:0  18:9
```
**hk_final markers, 10** (`hk_final.java:56-110`) — `i<4` beetle, `i<6` walker, else septipod:
```
hk_beetle   : 55:34   9:48   -18:18   23:-30
hk_walker   : 15:-1   -18:3
hk_septipod : -2:46   27:33   39:4   -21:28
```
**hk_final squad leaders, 2** (`hk_final.java:111-137`):
```
-1:32   32:25
```
**hk_squad_leader members, 6 each** (`hk_squad_leader.java:57-65`) — relative to the leader, so 12 total:
```
-3:0  -5:0  -7:0  -3:3  -5:3  -7:3
```
**hk_final corpses, 14** (`hk_final.java:163-200`):
```
7:26  -10:34  0:18  -5:46  10:35  26:32  -18:23
6:39  24:38  18:27  31:19  5:26  11:21  -3:31
```

### 6.4 The YT-2400

`volcano_event_manager.java:211-247` — base is the controller location `647.941 74.7399 448.941`:
```java
spawnLoc.x += 31.6;
spawnLoc.z += 2.2;
```
**Landing site: (679.541, 76.9399, 451.141)**, `POSTURE_PRONE`, `setYaw(-163)`.
Grounded replacement `object/building/mustafar/structures/must_grounded_yt2400.iff` at the same spot (`volcano_event_manager.java:258-276`).
**Autopilot NPC: cell-local (25, 5, 13) in cell `"bridge"`.**

### 6.5 Instance entry / exit (`datatables/instance/instance_datatable.tab:13`)

```
enter_one = "-256,-1,233,none"          → in-instance staging point, no scene named
exit_one  = "-2397,210,1850,mustafar"   → world Mustafar, where requestExitPlayer drops you
```

### 6.6 Radii and ranges — every scan distance in the source

| value | what | file:line |
|---|---|---|
| 45 | trigger volume, events one–five | `event_one.java:32`, `event_two.java:34`, `event_three.java:39`, `event_four.java:32`, `event_five.java:32` |
| 95 | trigger volume, HK | `hk_final.java:33` |
| 500 | `getWaypointId` scan; `clearEventArea` sweep | `volcano_event_manager.java:156-173`, L40-70 |
| 400 | event_one `clearAllAdds`; event_three rez scan; event_five debuff AE | `event_one_boss.java`, `event_three.java:253-291`, `event_five_boss.java:312-342` |
| 300 | HK disease AE; HK force drain AE (both unreachable) | `hk_final_boss.java:553-573`, L574-607 |
| 200 | event_four poison/disease/force-drain AE; event_five `resumeAttack` + `clearAllAdds`; HK rez scan; HK debuff + poison AE; HK `clearAllAdds` | `event_four_boss.java`, `event_five_boss.java:161-172`, `hk_final_boss.java:282-315`, L336-346, L532-552 |
| 150 | event_five guard + midguard acquire; hk_gk_septipod acquire | `event_five_guard.java`, `event_five_midguard.java`, `hk_gk_septipod.java` |
| 100 | event_three boss + guard acquire; hk_beetle acquire | `event_three_boss.java:92-109`, `event_three_guard.java`, `hk_beetle.java` |
| 96 | event_two wave/airfall/cone; HK wave | `event_two_boss.java:143-183`, L193-224, L234-270; `hk_final_boss.java:447-486` |
| 90 | HK `activate` acquire; hk_risen_guard acquire | `hk_final_boss.java:82-89`, `hk_risen_guard.java:44-60` |
| 80 | event_one guard acquire; hk_ak_guardian acquire | `event_one_guard.java`, `hk_ak_guardian.java` |
| 30 | cone arc, degrees | `event_two_boss.java:234-270` |
| 7 | beetle self-destruct blast | `event_four_guard.java`, `hk_beetle.java` |

**Cone helper** — `trial.java:1471-1501 getValidTargetsInCone(self, target, range, cone)`.
**Target helper** — `trial.java:1409-1439 getValidTargetsInRadius` = pets (`ai.pet` / `beast`) + players, excluding `isIncapacitated`, requiring `canSee`.
**Closest helper** — `trial.java:1844-1859 getClosest` skips the dead and requires `canSee && !stealth.hasInvisibleBuff`.
agentId: aec37b03744e26e26 (use SendMessage with to: 'aec37b03744e26e26' to continue this agent)
<usage>subagent_tokens: 80803
tool_uses: 64
duration_ms: 1253963</usage>
