# LIVE-VALLEY — Mustafar Trials: `valley_battleground` (Droid Army Battlefield)

Source of truth: original SOE `_dsrc-full` extract. Every claim below carries the pasted source line.
Path roots (abbreviated in citations):
- `SCRIPT` = `C:\swg-extract\_dsrc-full\sku.0\sys.server\compiled\game\script`
- `VB`     = `SCRIPT\theme_park\dungeon\mustafar_trials\valley_battleground`
- `DT`     = `C:\swg-extract\_dsrc-full\sku.0\sys.server\compiled\game\datatables`

Given (not re-derived here): controller origin = `(374.501, 6.52941, 282.793)`; datatable `locx/locy/locz`
are offsets from it; `BATTLEFIELD_WAVE_DELAY = 150`; stages 1..11 fire at t = 0,150,...,1500;
win = commander killed AND zero living `isArmy` within 400m. Turrets are unreachable dead code — omitted.

---

## §0 Ownership map (who is attached to what)

| Object | Template | Script(s) | Attached by |
|---|---|---|---|
| Battlefield controller | `valley_battlefield_controller.iff` | `systems.instance.instance_manager`, `theme_park...valley_battleground.valley_event_manager` | `valley_battlefield_controller.tpf` |
| Instance name | — | `mustafar_droid_army` | `valley_battlefield_controller.tpf:29` |

```
valley_battlefield_controller.tpf:29  objvars = +[ "instance_name"="mustafar_droid_army"]
```

The whole event is kicked off by the instance manager:

```
SCRIPT\systems\instance\instance_manager.java:128   messageTo(self, "beginSpawn", params, 0.0f, false);
```

```
VB\valley_event_manager.java:15   public int beginSpawn(obj_id self, dictionary params) throws InterruptedException
VB\valley_event_manager.java:17       clearEventArea(self);
VB\valley_event_manager.java:19       trial.bumpSession(self, "da_control");
VB\valley_event_manager.java:20       utils.setScriptVar(self, STAGE, 1);
VB\valley_event_manager.java:21       messageTo(self, "spawnNextStage", null, 0, false);
```

```
VB\valley_event_manager.java:13   public static final String STAGE = "currentStage";
```

Dead / orphaned code in this package — flagged so nobody ports it:

| Item | Why dead | Evidence |
|---|---|---|
| `valley_event_manager.redirectArmy()` | No callers anywhere in the extract; only its own definition | `VB\valley_event_manager.java:270` is the sole hit for `redirectArmy` |
| `VB\valley_player.java` | `player_script` column for `mustafar_droid_army` is empty → default `s[none]` → never attached; body is an empty `OnAttach` | `DT\instance\instance_datatable.tab:12`; `VB\valley_player.java:10-13` |
| `VB\koseyet_spawner.java` | `koseyet_spawner.tpf` attaches `npc.celebrity.celebrity_spawner`, not this script. Koseyet actually spawns from the stage‑1 datatable row | `koseyet_spawner.tpf` `scripts = [ "npc.celebrity.celebrity_spawner"]` |
| `VB\battlefield_destructable.java` | No row in `valley_event_data.tab` names this script | grep of `valley_event_data.tab` `script` column |
| `trial.setIsGeneratorDestroyed(self, true)` | Never called. Only the `false` reset in `clearEventArea` exists | `VB\valley_event_manager.java:36` |

---

## §1 POWER GENERATOR

The generator is the gate object: destroying it triggers the stage `-1` spawn (miner reinforcements +
the end‑point monitor) and the miner debuff.

### 1.1 Spawn row (stage 1, t = 0)

`DT\dungeon\mustafar_trials\valley_battlefield\valley_event_data.tab` — data row for the generator:

```
object/tangible/dungeon/mustafar/power_generator.iff   1   26   0   -22   25   theme_park.dungeon.mustafar_trials.valley_battleground.power_generator
```

| Field | Value |
|---|---|
| Template | `object/tangible/dungeon/mustafar/power_generator.iff` |
| Stage | 1 (t = 0) |
| Offset (locx, locy, locz) | `26, 0, -22` |
| **World location** | **`400.501, 6.52941, 260.793`** |
| Yaw | `25` |
| Script | `theme_park.dungeon.mustafar_trials.valley_battleground.power_generator` |
| scriptVar | none |

Because the template string starts with `object/`, the manager takes the tangible branch — it is
created with `createObject`, yawed, marked as a temp object, parented, then scripts, then scriptvars:

```
VB\valley_event_manager.java   if (object.startsWith("object/"))
VB\valley_event_manager.java       obj_id item = createObject(object, loc);
VB\valley_event_manager.java       setYaw(item, yaw);
VB\valley_event_manager.java       trial.markAsTempObject(item, true);
VB\valley_event_manager.java       utils.setScriptVar(item, trial.PARENT, self);
```

### 1.2 Template properties

```
power_generator.tpf   @base object/tangible/lair/base/shared_lair_base.iff
power_generator.tpf   invulnerable = false
power_generator.tpf   persistByDefault = false
```

Base is `lair_base` — that is why the kill trigger is `OnObjectDisabled` (lair semantics), not
`OnIncapacitated`.

### 1.3 Runtime behaviour — `VB\power_generator.java`

```
power_generator.java:15   public static final String VOLUME_NAME = "addGeneratorHate";
power_generator.java:16   public static final float VOLUME_RANGE = 40.0f;
power_generator.java:17   public static final boolean LOGGING = false;
```

Attach:

```
power_generator.java:20       trial.setInterest(self);
power_generator.java:21       setTriggerVolume(self);
power_generator.java:22       trial.setHp(self, trial.HP_BATTLEFIELD_GENERATOR);
power_generator.java:23       factions.setIgnorePlayer(self);
```

Hit points:

```
SCRIPT\library\trial.java:212   public static final int HP_BATTLEFIELD_GENERATOR = 65000;
```

`trial.setHp` branches on creature vs object; the generator is a tangible, so it takes the
`setMaxHitpoints`/`setHitpoints` branch:

```
SCRIPT\library\trial.java:1636   public static void setHp(obj_id target, int hp)
```

**Generator HP = 65,000.**

Trigger volume (droid‑army aggro magnet):

```
power_generator.java:65       createTriggerVolume(VOLUME_NAME, VOLUME_RANGE, true);
power_generator.java:54       if (volumeName.equals(VOLUME_NAME))
power_generator.java:56           if (utils.hasScriptVar(breacher, trial.BATTLEFIELD_DROID_ARMY))
power_generator.java:58               addHate(breacher, self, 1);
```

```
SCRIPT\library\trial.java:132   public static final String BATTLEFIELD_DROID_ARMY = "isArmy";
```

So: **any droid marked `isArmy` that enters a 40 m sphere around the generator gains 1 hate on it.**
Hate value is 1 — a nudge, not a lock; players out‑threat it trivially.

Destruction:

```
power_generator.java:26   public int OnObjectDisabled(obj_id self, obj_id killer)
power_generator.java:28       location death = getLocation(self);
power_generator.java:29       playClientEffectObj(killer, trial.PRT_WORKING_HK_BOOM_1, self, "");
power_generator.java:30       playClientEffectLoc(killer, "clienteffect/combat_explosion_lair_large.cef", death, 0);
power_generator.java:31       obj_id top = trial.getParent(self);
power_generator.java:37       messageTo(top, "generatorDestroyed", null, 0, false);
power_generator.java:38       setInvulnerable(self, true);
power_generator.java:39       messageTo(self, "destroyDisabledLair", null, 0.5f, false);
power_generator.java:40       obj_id[] enemies = getWhoIsTargetingMe(self);
power_generator.java:41       if (enemies != null && enemies.length > 1)
power_generator.java:44           if (isPlayer(enemy)) {
power_generator.java:45               setTarget(enemy, null);
power_generator.java:46               setCombatTarget(enemy, null);
```

```
SCRIPT\library\trial.java:187   public static final String PRT_WORKING_HK_BOOM_1 = "clienteffect/avatar_explosion_01.cef";
```

**BUG (faithful port note):** `enemies.length > 1` — with exactly one player targeting the generator,
targets are never cleared. Off‑by‑one in the original. Reproduce or fix deliberately, but know it.

Corpse removal 0.5 s later:

```
power_generator.java:69       destroyObject(self);
```

Damage‑state visuals — two bands, with a 15 s cooldown objvar:

```
power_generator.java:76       int smolder = (maxHP - (maxHP / 3));
power_generator.java:77       int fire = (maxHP / 3);
power_generator.java:78       if (!hasObjVar(self, "playingEffect"))
power_generator.java:80           if (curHP < smolder)
power_generator.java:82               if (curHP < fire)
power_generator.java:85                   setObjVar(self, "playingEffect", 1);
power_generator.java:86                   messageTo(self, "effectManager", null, 15, true);
power_generator.java:91                   playClientEffectObj(attacker, "clienteffect/lair_med_damage_smoke.cef", self, "");
power_generator.java:92                   playClientEffectLoc(attacker, "clienteffect/combat_explosion_lair_large.cef", death, 0);
power_generator.java:102      removeObjVar(self, "playingEffect");
```

With maxHP 65000: `smolder` threshold = 65000 − 21666 = **43,334**; `fire` threshold = **21,666**.

| HP band | Effect |
|---|---|
| 65000 → 43334 | none |
| < 43334 and ≥ 21666 | `lair_med_damage_smoke.cef` on generator + `combat_explosion_lair_large.cef` at loc |
| < 21666 | **no effect played** — the inner branch only sets the objvar and re‑arms the cooldown |

**BUG (faithful port note):** the `< fire` branch plays nothing. `location death` is computed and
discarded. The "heavily damaged" state is visually silent in the original.

### 1.4 What generator death does upstream

```
VB\valley_event_manager.java:254   public int generatorDestroyed(obj_id self, dictionary params)
VB\valley_event_manager.java        instance.sendInstanceSystemMessage(self, trial.BATTLEFIELD_GENERATOR_DEAD);
VB\valley_event_manager.java        messageTo(self, "handleDebufMiners", null, 10, false);
VB\valley_event_manager.java        spawnActors(self, -1);
```

```
SCRIPT\library\trial.java:139   public static final String BATTLEFIELD_GENERATOR_DEAD = "generator_destroyed";
SCRIPT\library\trial.java:138   public static final String BATTLEFIELD_STF = "mustafar/valley_battlefield";
```

Localized text for `mustafar/valley_battlefield` — **not in source** (no `.stf` for this file exists
anywhere under `C:\swg-extract`).

Sequence on generator death:
1. Instance‑wide message `generator_destroyed`.
2. `spawnActors(self, -1)` — immediately spawns the 9 mining squad leaders + the end‑point monitor (§6, §5).
3. 10 s later, `handleDebufMiners` → `debufMiners` (§6.4).

---

## §2 DEMOLITION PACKS

Two packs are placed at stage 1. Each is a 6‑charge dispenser; a player picks it up, plants charges,
gets a detonator per charge, and blows them remotely. Charge power scales with Commando skill.

### 2.1 Spawn rows (stage 1, t = 0)

```
object/tangible/dungeon/mustafar/demo_pack.iff   1   -3   0   2   0   none   boolean:inWorld=true,int:currentMineCount=6
object/tangible/dungeon/mustafar/demo_pack.iff   1   -4   0    0   0   none   boolean:inWorld=true,int:currentMineCount=6
```

| # | Offset | **World location** | Yaw | Script column | scriptVar |
|---|---|---|---|---|---|
| 1 | `-3, 0, 2` | `371.501, 6.52941, 284.793` | 0 | `none` | `boolean:inWorld=true,int:currentMineCount=6` |
| 2 | `-4, 0, 0` | `370.501, 6.52941, 282.793` | 0 | `none` | `boolean:inWorld=true,int:currentMineCount=6` |

The script column is `none` because the script lives in the template:

```
demo_pack.tpf:22   scripts = [ "theme_park.dungeon.mustafar_trials.valley_battleground.demolition_generator"]
```

**Each pack starts with 6 charges.** `inWorld=true` marks it as world‑placed, not inventory‑held.

### 2.2 The pack — `VB\demolition_generator.java`

```
demolition_generator.java:12   public static final string_id PICK_UP = new string_id("mustafar/valley_battlefield", "pick_up_demo_pack");
demolition_generator.java:13   public static final string_id PLACE_CHARGE = new string_id("npc_landmines", "place_charge");
```

Both `.stf` files — **not in source**; only the string ids exist in the extract.

Radial menu:

```
demolition_generator.java:19   public int OnObjectMenuRequest(obj_id self, obj_id player, menu_info mi)
demolition_generator.java      utils.verifyLocationBasedDestructionAnchor(self, 500);
demolition_generator.java      if (!hasBeenPickedUp(self))  ...  mi.addRootMenu(menu_info_types.ITEM_USE, PICK_UP);
demolition_generator.java      else                              mi.addRootMenu(menu_info_types.ITEM_USE, PLACE_CHARGE);
```

```
demolition_generator.java:66   public boolean hasBeenPickedUp(obj_id self)
demolition_generator.java:67       return !utils.hasScriptVar(self, "inWorld");
```

So while the pack still has `inWorld`, the menu reads **"pick up demo pack"**; once in inventory it
reads **"place charge"**.

Self‑destruct anchor: `utils.verifyLocationBasedDestructionAnchor(self, 500)` — the pack destroys
itself if it travels more than 500 m from its anchor point.

Pick‑up path:

```
demolition_generator.java:54   public int regenerateInPlayerInventory(obj_id self, dictionary params)
```

Charge creation:

```
demolition_generator.java:86    public obj_id createCharge(obj_id self, obj_id player)
demolition_generator.java       String mineType = "demolitionCharge_" + getCommandoModifyLevel(player);
demolition_generator.java       removeAllObjVars(charge);
demolition_generator.java       detachAllScripts(charge);
demolition_generator.java       setObjVar(charge, "mineType", mineType);
demolition_generator.java       setObjVar(charge, trial.TEMP_OBJECT, true);
demolition_generator.java       attachScript(charge, "theme_park.dungeon.mustafar_trials.valley_battleground.demolition_pack");
```

```
SCRIPT\library\trial.java:21   public static final String TEMP_OBJECT = "tempObject";
```

Commando scaling — the pack literally counts skills:

```
demolition_generator.java:103   public int getCommandoModifyLevel(obj_id player)
demolition_generator.java       if (hasSkill(player, "class_commando_phase1_novice"))  level++;
demolition_generator.java       if (hasSkill(player, "class_commando_phase2_novice"))  level++;
demolition_generator.java       if (hasSkill(player, "class_commando_phase3_novice"))  level++;
demolition_generator.java       if (hasSkill(player, "class_commando_phase4_novice"))  level++;
demolition_generator.java       if (hasSkill(player, "class_commando_phase4_master"))  level++;
```

**Level range 0..5.** A non‑Commando gets `demolitionCharge_0`; a master Commando gets `demolitionCharge_5`.

Detonator handout + count decrement:

```
demolition_generator.java:121   public obj_id generateDetonationDevice(obj_id self, obj_id player, obj_id charge)
demolition_generator.java       attachScript(det, "theme_park.dungeon.mustafar_trials.valley_battleground.demolition_detonator");
demolition_generator.java       setObjVar(det, "chargeId", charge);
demolition_generator.java       utils.verifyLocationBasedDestructionAnchor(det, 500);
demolition_generator.java:146   public int decrimentMineCount(obj_id self, dictionary params)
demolition_generator.java       if (count <= 0)  destroyObject(self);
```

**One detonator is created per charge, bound by `chargeId`.** When the count hits 0 the pack is destroyed.

```
demo_detonator.tpf   (no scripts line — the detonator script is attached at runtime only)
```

### 2.3 The detonator — `VB\demolition_detonator.java`

```
demolition_detonator.java:16   public static final string_id DETONATE = new string_id("mustafar/valley_battlefield", "detonate_charge");
demolition_detonator.java:17   public static final string_id PAGE     = new string_id("mustafar/valley_battlefield", "page_charge");
demolition_detonator.java:19   public int OnObjectMenuRequest(...)
demolition_detonator.java       int root = mi.addRootMenu(menu_info_types.ITEM_USE, DETONATE);
demolition_detonator.java       mi.addSubMenu(root, menu_info_types.ITEM_USE_OTHER, PAGE);
```

| Menu | Message sent | Detonator survives? |
|---|---|---|
| Detonate (root, `ITEM_USE`) | `messageTo(charge, "detonateCharge", ...)` then `destroyObject(detonator)` | **No** — consumed |
| Page (sub, `ITEM_USE_OTHER`) | `messageTo(charge, "pageCharge", ...)` | **Yes** |

```
demolition_detonator.java:49   public int OnObjectMenuSelect(...)   // detonate branch
demolition_detonator.java:68   ...                                  // page branch
```

Page makes the planted charge announce itself:

```
demolition_pack.java:20   public static final string_id SHOW_PAGE_TEXT = new string_id("mustafar/valley_battlefield", "charge_page_text");
demolition_pack.java:40       showFlyText(getSelf(), SHOW_PAGE_TEXT, 1.0f, colors.GREEN);
```

### 2.4 The planted charge — `VB\demolition_pack.java`

```
demolition_pack.java:43    public boolean verifyMine(obj_id self)
demolition_pack.java:60    // blast-radius target gather: players AND mobs, skipping dead/incapacitated
demolition_pack.java:97    damage(target, damageType, HIT_LOCATION_BODY, rand(minDamage, maxDamage));
demolition_pack.java       destroyObject(self);
```

**The charge damages players too** — it gathers every valid target in the radius, not just droids.

Damage‑type string → constant map:

```
demolition_pack.java:127   // "blast"      -> DAMAGE_ELEMENTAL_HEAT
demolition_pack.java       // "heat"       -> DAMAGE_ELEMENTAL_HEAT
demolition_pack.java       // "energy"     -> DAMAGE_ENERGY
demolition_pack.java       // "stun"       -> DAMAGE_STUN
demolition_pack.java       // "cold"       -> DAMAGE_ELEMENTAL_COLD
demolition_pack.java       // "acid"       -> DAMAGE_ELEMENTAL_ACID
demolition_pack.java       // "electrical" -> DAMAGE_ELEMENTAL_ELECTRICAL
demolition_pack.java       // "kinetic"    -> DAMAGE_KINETIC
demolition_pack.java:162   // default      -> -1
```

### 2.5 Charge stats — `DT\npc_landmines.tab` rows 10‑15

| mineType | size | ? | radius | minDamage | maxDamage | damageType | effect |
|---|---|---|---|---|---|---|---|
| `demolitionCharge_0` | light | 1 | 8 | 1445 | 1605 | heat | `exp_ap_landmine` |
| `demolitionCharge_1` | light | 1 | 9 | 1825 | 2055 | heat | `exp_ap_landmine` |
| `demolitionCharge_2` | medium | 1 | 10 | 2344 | 2505 | heat | `combat_grenade_proton` |
| `demolitionCharge_3` | medium | 1 | 12 | 2948 | 3200 | heat | `combat_grenade_proton` |
| `demolitionCharge_4` | medium | 1 | 14 | 3350 | 3605 | heat | `combat_grenade_proton` |
| `demolitionCharge_5` | heavy | 1 | 18 | 4200 | 5000 | heat | `combat_grenade_thermal_detonator` |

All heat‑typed → `DAMAGE_ELEMENTAL_HEAT`. A master Commando's charge is **~3× the damage and 2.25× the
radius** of a non‑Commando's.

---

## §3 WAVE-BY-WAVE SPAWN TABLE — **the build list**

`DT\dungeon\mustafar_trials\valley_battlefield\valley_event_data.tab` (86 lines).
Loaded as the `.iff` sibling:

```
SCRIPT\library\trial.java:130   public static final String VALLEY_DATA = "datatables/dungeon/mustafar_trials/valley_battlefield/valley_event_data.iff";
```

### 3.1 Columns and file layout

```
row 1 (names)   object   stage   locx   locy   locz   yaw   script   scriptVar   path
row 2 (types)   s        i[1]    f[0]   f[0]   f[0]   f[0]  s[none]  s[none]     s
```

- **Row 1** = column names. **Row 2** = type + default in brackets. **Data starts at file line 3.**
- An empty cell falls through to the type‑row default: `stage`→1, coords/yaw→0.0, `script`/`scriptVar`→`"none"`.
- **File line 3 = data row index 0.** This matters for §7: the `path` column is read by *row index*.

### 3.2 Parser semantics — colon and comma

`script` column — **colon‑separated list of fully‑qualified script names**:

```
VB\valley_event_manager.java:169   public void attachSpawnScripts(obj_id actor, String spawnScripts)
VB\valley_event_manager.java:171       String[] scripts = split(spawnScripts, ':');
```

Example: `mining_squad_leader:conversation.som_battlefield_miner_leader` → two scripts attached.

`scriptVar` column — **comma‑separated entries, each `type:name=value`**:

```
VB\valley_event_manager.java:176   public void setSpawnScriptVar(obj_id actor, String scriptVars)
VB\valley_event_manager.java:178       String[] varList = split(scriptVars, ',');
VB\valley_event_manager.java           String[] pair = split(varList[i], '=');
VB\valley_event_manager.java           String[] name = split(pair[0], ':');
VB\valley_event_manager.java           // switch on name[0]: "string" | "int" | "float" | "boolean" | "bool"
```

Supported types: `string`, `int`, `float`, `boolean`, `bool`. Example
`int:path=7,boolean:isArmy=true` sets two scriptvars.

Coordinates are offsets applied to the controller's own location:

```
VB\valley_event_manager.java   locX = here.x + locx;
VB\valley_event_manager.java   locY = here.y + locy;
VB\valley_event_manager.java   locZ = here.z + locz;
```

### 3.3 The two creation branches (they are NOT symmetric)

```
VB\valley_event_manager.java   if (object.startsWith("object/"))     // TANGIBLE
VB\valley_event_manager.java       createObject(...) ; setYaw ; trial.markAsTempObject(item, true) ; setParent
VB\valley_event_manager.java       // scripts THEN scriptvars
VB\valley_event_manager.java   else                                   // CREATURE
VB\valley_event_manager.java       create.object(object, loc) ; setParent
VB\valley_event_manager.java       // scriptvars THEN scripts
```

| | Tangible (`object/...`) | Creature (`som_...`) |
|---|---|---|
| Creator | `createObject` | `create.object` |
| `setYaw` applied | yes | **no** (yaw column ignored for creatures) |
| `markAsTempObject` | **yes** | **no** — creatures persist until killed/cleaned |
| Order | scripts → scriptvars | **scriptvars → scripts** |

The creature ordering is load‑bearing: `OnAttach` in the creature scripts reads scriptvars that the
manager has *already* set (e.g. `path`, `autoDeploy`).

### 3.4 Stage scheduler

```
VB\valley_event_manager.java:59   public int spawnNextStage(obj_id self, dictionary params)
VB\valley_event_manager.java          if (!trial.verifySession(self, params, "da_control")) return SCRIPT_CONTINUE;
VB\valley_event_manager.java          spawnActors(self, stage);
VB\valley_event_manager.java          int[] stages = dataTableGetIntColumn(trial.VALLEY_DATA, "stage");
VB\valley_event_manager.java          messageTo(self, "spawnNextStage", null, trial.BATTLEFIELD_WAVE_DELAY, false);
```

```
SCRIPT\library\trial.java:147   public static final int BATTLEFIELD_WAVE_DELAY = 150;
SCRIPT\library\trial.java:148   public static final int BATTLEFIELD_COMM_REZ_DELAY = 18;
```

Stage 2 and stage 10 have special side effects:

```
VB\valley_event_manager.java:93   public void spawnActors(obj_id self, int stage)
VB\valley_event_manager.java        // stage == 2  -> playMusic(... trial.MUS_BATTLEFIELD_DROID_ARMY_INTRO ...)
VB\valley_event_manager.java        // stage == 10 -> messageTo(dungeon, "validateDungeon", null, 60, false)
VB\valley_event_manager.java        //                + music + instance message trial.BATTLEFIELD_CMNDR_INTRO
```

```
SCRIPT\library\trial.java:198   public static final String MUS_BATTLEFIELD_DROID_ARMY_INTRO = "sound/mus_mustafar_droid_invasion_intro.snd";
SCRIPT\library\trial.java:141   public static final String BATTLEFIELD_CMNDR_INTRO = "commander_intro";
```

**Stage 10 is the moment the win-check loop starts.** Nothing polls for victory before it.

### 3.5 Spawn anchors used by stages 2‑11

Only six offsets are reused across the whole assault:

| Anchor | Offset (x,y,z) | **World location** |
|---|---|---|
| A | `-253, 12, 201` | `121.501, 18.52941, 483.793` |
| B | `-294, 12, 160` | `80.501, 18.52941, 442.793` |
| C | `-148, 12, 181` | `226.501, 18.52941, 463.793` |
| D | `41, 8, 104` | `415.501, 14.52941, 386.793` |
| E | `1, 0, 125` | `375.501, 6.52941, 407.793` |
| F | `-268, 0, 53` | `106.501, 6.52941, 335.793` |

### 3.6 STAGE 1 — t = 0 (setup wave: allies, props, generator, demo packs)

| Count | Object | Offset | **World location** | Yaw | Script | scriptVar |
|---|---|---|---|---|---|---|
| 1 | `som_battlefield_mining_droid` | `11,0,2` | `385.501, 6.52941, 284.793` | -70 | `...valley_battleground.mining_droid` | none |
| 1 | `som_battlefield_mining_droid` | `10,0,4` | `384.501, 6.52941, 286.793` | -70 | `...mining_droid` | none |
| 1 | `som_battlefield_mining_droid` | `8,0,-2` | `382.501, 6.52941, 280.793` | -70 | `...mining_droid` | none |
| 1 | `som_battlefield_mining_droid` | `6,0,-5` | `380.501, 6.52941, 277.793` | -70 | `...mining_droid` | none |
| 1 | `som_battlefield_mining_droid` | `3,0,-8` | `377.501, 6.52941, 274.793` | -70 | `...mining_droid` | none |
| 1 | `som_battlefield_mining_leader` | `2,0,-3` | `376.501, 6.52941, 279.793` | -70 | `...mining_squad_leader:conversation.som_battlefield_miner_leader` | none |
| 1 | `som_battlefield_mining_leader` | `4,0,3` | `378.501, 6.52941, 285.793` | -70 | `...mining_squad_leader:conversation.som_battlefield_miner_leader` | none |
| 1 | `som_battlefield_foreman_koseyet` | `-81,13,-131` | `293.501, 19.52941, 151.793` | -133 | `conversation.trial_foreman_koseyet` | none |
| 1 | `object/tangible/dungeon/mustafar/demo_pack.iff` | `-3,0,2` | `371.501, 6.52941, 284.793` | 0 | none (in tpf) | `boolean:inWorld=true,int:currentMineCount=6` |
| 1 | `object/tangible/dungeon/mustafar/demo_pack.iff` | `-4,0,0` | `370.501, 6.52941, 282.793` | 0 | none (in tpf) | `boolean:inWorld=true,int:currentMineCount=6` |
| 1 | `object/tangible/dungeon/mustafar/power_generator.iff` | `26,0,-22` | `400.501, 6.52941, 260.793` | 25 | `...power_generator` | none |
| 1 | `object/tangible/collection/rare_heavy_oppressor_flame_thrower.iff` | `10,0,-35` | `384.501, 6.52941, 247.793` | 0 | none | none |
| 10 | lower‑camp props (fence / bunker / cooling) | see file lines 14‑23 | — | — | none | none |
| 22 | upper‑camp props (fence / bunker) | see file lines 64‑85 | — | — | none | none |

Note the yaw on the miners/droids (`-70`, `-133`) is **written but ignored** — they take the creature
branch, which never calls `setYaw` (§3.3). The scripts re‑apply yaw themselves at deploy time
(`mining_squad_leader.java:82  setYaw(self, -70);`).

### 3.7 STAGES 2‑11 — the assault waves

Every assault row: `yaw = 0`, `scriptVar = "int:path=N,boolean:isArmy=true"`.
`dsl` = `som_battlefield_droid_squad_leader`, script `...droid_squad_leader`.
`ak_1a` / `ak_3` / `gk_5` = `som_battlefield_ak_1a` / `_ak_3` / `_gk_5`, script `...assault_killer_bot`.

| Stage | t (s) | Spawn 1 | Spawn 2 | Spawn 3 |
|---|---|---|---|---|
| 2 | 150 | `dsl` @A path 1 | `dsl` @B path 8 | `dsl` @C path 7 |
| 3 | 300 | `ak_1a` @A path 2 | `dsl` @C path 7 | `ak_3` @B path 7 |
| 4 | 450 | `dsl` @B path 5 | `dsl` @C path 6 | `ak_1a` @A path 8 |
| 5 | 600 | `ak_1a` @C path 7 | `gk_5` @A path 4 | `dsl` @B path 2 |
| 6 | 750 | `dsl` @A path 0 | `gk_5` @B path 8 | `dsl` @C path 7 |
| 7 | 900 | `dsl` @C path 5 | `dsl` @B path 6 | `ak_1a` @A path 8 |
| 8 | 1050 | `ak_3` @C path 7 | `dsl` @A path 1 | `dsl` @B path 8 |
| 9 | 1200 | `gk_5` @C path 7 | `ak_1a` @A path 4 | `dsl` @B path 2 |
| 10 | 1350 | **`som_battlefield_commander`** @D path 12, script `...forward_commander` | `dsl` @D path 12 | `ak_1a` @E path 11 |
| 11 | 1500 | `dsl` @E path 12 | `dsl` @F path 10 | `dsl` @F path 13 |

**Direct spawns total: 30 assault mobs across stages 2‑11 (3 per stage).** Every `dsl` then spawns 4
squad members (§4.4) and the commander spawns 6 elite guards (§4.2), so the true head‑count is far
higher — plus the rez loop (§4.3).

Head‑count from direct spawns + squads (before rezzes):

| Type | Direct | Auto‑spawned children | Total |
|---|---|---|---|
| `som_battlefield_droid_squad_leader` | 19 | — | 19 |
| `som_battlefield_droid_soldier` (squad members) | 0 | 19 × 4 = 76 | 76 |
| `som_battlefield_ak_1a` | 5 | — | 5 |
| `som_battlefield_ak_3` | 2 | — | 2 |
| `som_battlefield_gk_5` | 3 | — | 3 |
| `som_battlefield_commander` | 1 | — | 1 |
| `som_battlefield_elite_guard` | 0 | 6 | 6 |
| **Total** | **30** | **82** | **112** |

### 3.8 STAGE -1 — fires only on generator destruction

Not on a timer. Triggered by `spawnActors(self, -1)` in `generatorDestroyed` (§1.4). Yaw 0 on all rows.

| Count | Object | Offset | **World location** | Script | scriptVar |
|---|---|---|---|---|---|
| 1 | `som_battlefield_mining_leader` | `-98,12,-150` | `276.501, 18.52941, 132.793` | `...mining_squad_leader:conversation.som_battlefield_miner_leader` | `int:autoDeploy=1` |
| 1 | `som_battlefield_mining_leader` | `-100,12,-138` | `274.501, 18.52941, 144.793` | same | `int:autoDeploy=1` |
| 1 | `som_battlefield_mining_leader` | `-115,12,-125` | `259.501, 18.52941, 157.793` | same | `int:autoDeploy=1` |
| 1 | `som_battlefield_mining_leader` | `-139,9,-125` | `235.501, 15.52941, 157.793` | same | `int:autoDeploy=1` |
| 1 | `som_battlefield_mining_leader` | `-162,9,-118` | `212.501, 15.52941, 164.793` | same | `int:autoDeploy=1` |
| 1 | `som_battlefield_mining_leader` | `-198,12,-125` | `176.501, 18.52941, 157.793` | same | `int:autoDeploy=1` |
| 1 | `som_battlefield_mining_leader` | `-175,10,-116` | `199.501, 16.52941, 166.793` | same | `int:autoDeploy=1` |
| 1 | `som_battlefield_mining_leader` | `-173,12,-155` | `201.501, 18.52941, 127.793` | same | `int:autoDeploy=1` |
| 1 | `som_battlefield_mining_leader` | `-134,12,-171` | `240.501, 18.52941, 111.793` | same | `int:autoDeploy=1` |
| 1 | `object/tangible/ground_spawning/patrol_waypoint.iff` | `-195,10,-194` | `179.501, 16.52941, 88.793` | `...end_point_monitor` | none |

**9 mining leaders, each with `autoDeploy=1` → each deploys 4 `som_battlefield_miner` = 36 more allies
(§6.3), for 45 defenders.** Plus the invisible end‑point monitor that runs the lose condition (§5.2).

### 3.9 Creature stats — `DT\mob\creatures.tab` lines 4605‑4615

| name | lvl | class | appearance | scale | weapon | aggr/assist | loot |
|---|---|---|---|---|---|---|---|
| `som_battlefield_commander` | 84 | BOSS | `som/hk77.iff` | 1.6 | `droid_hk77_boss.iff` | 24 / 9 | 1 roll @100%, `mustafar/mustafar_trial_forward_cmdr`, collection `col_shattered_shard_02` |
| `som_battlefield_elite_guard` | 82 | ELITE | `som/hk77.iff` | 1.2 | `droid_hk77_elite.iff` | 24 / 24 | 1 roll @80%, collection `col_shattered_shard_02` |
| `som_battlefield_droid_squad_leader` | 80 | ELITE | `som/hk77.iff` | 1.1 | `droid_hk77_elite.iff` | — | 1 roll @80% |
| `som_battlefield_droid_soldier` | 80 | ELITE | `som/hk77.iff` | 1.0 | `droid_hk77_assault_droid.iff` | — | 1 roll @80% |
| `som_battlefield_ak_1a` | 82 | BOSS | `som/cww8_battle_droid.iff` | — | `droid_cww8_01.iff` | — | 1 roll @80% |
| `som_battlefield_ak_3` | 82 | BOSS | `som/cww8a_battle_droid.iff` | — | `droid_cww8_02.iff` | — | 1 roll @80% |
| `som_battlefield_gk_5` | 83 | BOSS | `som/union_sentry_droid.iff` | 1.0 | `droid_union_sentry.iff` | — | 1 roll @80%, collection `col_shattered_shard_02` |

All droid‑army rows share: `socialGroup = droid_army`, `pvpFaction = droid_army`, `where = mustafar`,
`attackSpeed = 2`, armor `K75 E75 B100 H60 C100 El25 A40 S85`.

Commander‑only flags: `stealingFlags = CREDITS`; `root/snare/stun/mezImmune = 100`; `canNotPunish = 1`;
`death_blow` instant. Elite guard: `root/snare/mezImmune = 100`, no `death_blow`.

Squad leader specials: `droid_special_6`, `spider_5`.

Ally rows (same table):

| name | lvl | class | appearance | socialGroup | pvpFaction | loot |
|---|---|---|---|---|---|---|
| `som_battlefield_foreman_koseyet` | 80 | NORMAL | `som/battlefield_foreman.iff` | `mustafar_miner` | — | `mustafar_miner` |
| `som_battlefield_miner` | 80 | NORMAL | `som/mustafarian_m_01.iff` | `mustafar_miner` | `mustafar_miners` | — |
| `som_battlefield_mining_droid` | 80 | NORMAL | `probot.iff` | — | — | weapon `droid_probot_ranged.iff` |
| `som_battlefield_mining_leader` | 80 | NORMAL | `som/mustafarian_m_01.iff` | — | — | — |

Commander loot chain:

```
DT\loot\master_loot.tab:613   mustafar_trial_forward_cmdr   datatables/loot/creature_loot/mustafar/mustafar_npc_loot_b.iff:forward_commander   10000
DT\loot\master_loot.tab:678   mustafar_trial_forward_cmdr   datatables/loot/creature_loot/mustafar/mustafar_npc_loot_b.iff:forward_commander   10000
```

Weight 10000 = 100% of that table. The leaf table `mustafar_npc_loot_b` — **not in source** (the `.tab`
is not present in this extract). Actual drop items cannot be stated.

---

## §4 THE COMMANDER AND HIS GUARDS

### 4.1 Spawn

Stage 10, anchor D, path 12:

```
som_battlefield_commander   10   41   8   104   0   theme_park.dungeon.mustafar_trials.valley_battleground.forward_commander   int:path=12,boolean:isArmy=true
```

**World location `415.501, 14.52941, 386.793`.** Level 84 BOSS (§3.9).

### 4.2 OnAttach — `VB\forward_commander.java`

```
forward_commander.java:18   public static final String SQUAD_MEMBER = "som_battlefield_elite_guard";
forward_commander.java:27   public int OnAttach(obj_id self)
forward_commander.java          trial.bumpSession(self);
forward_commander.java          findWayPoints(self);
forward_commander.java          trial.setInterest(self);
forward_commander.java          trial.markAsDroidArmy(self);
forward_commander.java          messageTo(self, "pathToNextPoint", null, 2, false);
forward_commander.java          messageTo(self, "spawnEliteGuard", null, 2, false);
forward_commander.java          messageTo(self, "performRez", null, trial.BATTLEFIELD_COMM_REZ_DELAY, false);
forward_commander.java          setHibernationDelay(self, 7200);
```

Elite guard spawn — **6 guards, all at the commander's own location, all on the commander's path,
all agro‑linked to him**:

```
forward_commander.java:39   public int spawnEliteGuard(obj_id self, dictionary params)
forward_commander.java          obj_id[] squad = new obj_id[6];
forward_commander.java          setYaw(self, -250);
forward_commander.java          squad[i] = create.object(SQUAD_MEMBER, spawnLoc);
forward_commander.java          attachScript(squad[i], "theme_park.dungeon.mustafar_trials.valley_battleground.elite_guard");
forward_commander.java          utils.setScriptVar(squad[i], trial.PARENT, self);
forward_commander.java          ai_lib.setPatrolOncePath(squad[i], patrolPoints);
forward_commander.java          trial.markAsDroidArmy(squad[i]);
forward_commander.java          ai_lib.establishAgroLink(self, squad);
```

`establishAgroLink` means **pulling the commander pulls all 6 guards, and vice versa.** This is the
single hardest pull in the encounter: one level‑84 boss + six level‑82 elites, linked.

Guard behaviour:

```
VB\elite_guard.java   OnAttach:  trial.setInterest(self); trial.markAsDroidArmy(self); setHibernationDelay(self, 7200);
VB\elite_guard.java   OnIncapacitated:  messageTo(self, "handleDeath", null, 5, false);
VB\elite_guard.java   handleDeath:      destroyObject(self);
```

**Elite guards are never marked `droidCorpse` → they can never be rezzed.** Only assault killer bots
and droid squad members/leaders can (§4.3).

### 4.3 The rez loop — the commander's real mechanic

```
forward_commander.java:119   public int performRez(obj_id self, dictionary params)
forward_commander.java           if (!trial.verifySession(self, params)) return SCRIPT_CONTINUE;
forward_commander.java           obj_id[] corpses = trial.getObjectsInRangeWithScriptVar(self, trial.BATTLEFIELD_DROID_CORPSE, 22.0f);
forward_commander.java           playClientEffectObj(..., trial.PRT_DROID_REVIVE, ..., 4.0f ...);
forward_commander.java           for (int i = 0; i < corpses.length && i < 3; i++)
forward_commander.java           messageTo(self, "performRez", null, trial.BATTLEFIELD_COMM_REZ_DELAY, false);
```

```
SCRIPT\library\trial.java:137   public static final String BATTLEFIELD_DROID_CORPSE = "droidCorpse";
SCRIPT\library\trial.java:177   public static final String PRT_DROID_REVIVE = "clienteffect/mus_droid_revive.cef";
SCRIPT\library\trial.java:148   public static final int BATTLEFIELD_COMM_REZ_DELAY = 18;
```

**Every 18 seconds the commander revives up to 3 droid corpses within 22 metres.** The timer always
re‑arms, regardless of whether anything was rezzed.

What each corpse comes back as — template substring decides:

```
forward_commander.java:139   public void rezCorpse(obj_id self, obj_id corpse)
forward_commander.java           // template contains "cww"   -> "som_battlefield_ak_3"          + script assault_killer_bot
forward_commander.java           // template contains "union" -> "som_battlefield_gk_5"          + script assault_killer_bot
forward_commander.java           // else                      -> "som_battlefield_droid_soldier" + script droid_squad_member
forward_commander.java           // each: revive effect, messageTo(new,"pathToNextPoint",null,3,false), copied patrolPoints, destroyObject(corpse)
```

| Corpse appearance | Rezzes as | Level change |
|---|---|---|
| `som/cww8*_battle_droid.iff` (ak_1a, ak_3) | `som_battlefield_ak_3` | 82 → 82 |
| `som/union_sentry_droid.iff` (gk_5) | `som_battlefield_gk_5` | 83 → 83 |
| anything else (hk77 squad leaders and soldiers) | `som_battlefield_droid_soldier` | 80 → 80 |

**A squad leader that dies near the commander comes back as a plain soldier — a downgrade.** An `ak_1a`
comes back as an `ak_3`.

Corpses are created by the droid death handlers:

```
VB\assault_killer_bot.java    OnIncapacitated -> trial.prepareCorpse(self); utils.setScriptVar(self, trial.BATTLEFIELD_DROID_CORPSE, ...)
VB\droid_squad_leader.java    OnIncapacitated -> trial.prepareCorpse(self); ... droidCorpse
VB\droid_squad_member.java    OnIncapacitated -> trial.prepareCorpse(self); ... droidCorpse
```

```
SCRIPT\library\trial.java:1828   public static void prepareCorpse(obj_id corpse)    // detachScript(corpse, "ai.ai")
```

**Design consequence:** the fight is unwinnable by attrition while the commander lives inside the
corpse field. Players must either drag droids >22 m from him or kill him first.

### 4.4 Squad leaders — `VB\droid_squad_leader.java`

```
droid_squad_leader.java:18   public static final String SQUAD_MEMBER = "som_battlefield_droid_soldier";
droid_squad_leader.java:36   public int spawnSquad(obj_id self, dictionary params)
droid_squad_leader.java          obj_id[] squad = new obj_id[4];
droid_squad_leader.java          setYaw(self, -250);
droid_squad_leader.java          attachScript(squad[j], "theme_park.dungeon.mustafar_trials.valley_battleground.droid_squad_member");
droid_squad_leader.java          utils.setScriptVar(squad[j], trial.PARENT, self);
droid_squad_leader.java          // copies the leader's patrolPoints to each member
droid_squad_leader.java          trial.markAsDroidArmy(squad[j]);
droid_squad_leader.java          messageTo(squad[j], "pathToNextPoint", null, j + 2, false);
```

**4 members per leader, staggered start at 2 / 3 / 4 / 5 seconds** (`j + 2`, j = 0..3), producing a
strung‑out column rather than a clump. **No `establishAgroLink`** — unlike the commander's guards,
squad members are pulled individually.

### 4.5 Commander death

```
forward_commander.java:20   public int OnIncapacitated(obj_id self, obj_id killer)
forward_commander.java          trial.bumpSession(self);
forward_commander.java          messageTo(top, "commanderDied", null, 5, false);
```

`trial.bumpSession(self)` here is **the only thing that stops the rez loop** — the next `performRez`
fails `verifySession` and returns without re‑arming. `top` is the `trial.PARENT` scriptvar (the
controller).

```
VB\valley_event_manager.java:301   public int commanderDied(obj_id self, dictionary params)
VB\valley_event_manager.java           debuffDroidArmy(self);
VB\valley_event_manager.java           trial.setIsCommanderKilled(self, true);
VB\valley_event_manager.java           instance.sendInstanceSystemMessage(self, trial.BATTLEFIELD_COMMANDER_DIED);
```

```
SCRIPT\library\trial.java:140   public static final String BATTLEFIELD_COMMANDER_DIED = "commander_killed";
SCRIPT\library\trial.java:134   public static final String BATTLEFIELD_COMMANDER_KILLED = "isCommanderKilled";
```

`debuffDroidArmy`:

```
VB\valley_event_manager.java:206   public void debuffDroidArmy(obj_id self)
```

---

## §5 WIN AND LOSE

### 5.1 Win

```
VB\valley_event_manager.java:332   public int validateDungeon(obj_id self, dictionary params)
VB\valley_event_manager.java           messageTo(self, "validateDungeon", null, 60, false);   // re-arm every 60s
VB\valley_event_manager.java           obj_id[] army = trial.getObjectsInRangeWithScriptVar(self, trial.BATTLEFIELD_DROID_ARMY, 400.0f);
VB\valley_event_manager.java           // dead army members are destroyObject'ed during the sweep
```

The loop is armed once, at stage 10:

```
VB\valley_event_manager.java   // stage == 10 -> messageTo(dungeon, "validateDungeon", null, 60, false);
```

**Poll interval = 60 s.** Worst case the win is recognised up to a minute after the last droid falls.

Win payload:

```
VB\valley_event_manager.java:309   public int winTrial(obj_id self, dictionary params)
VB\valley_event_manager.java           trial.setIsDroidArmyDefeated(self, true);
VB\valley_event_manager.java           trial.setDungeonCleanOutTimer(self);
VB\valley_event_manager.java           trial.sendCompletionSignal(self, trial.ARMY_WIN_SIGNAL);
VB\valley_event_manager.java           instance.sendInstanceSystemMessage(self, trial.BATTLEFIELD_WIN_MESSAGE);
VB\valley_event_manager.java           playMusic(... trial.MUS_MUST_QUEST_WIN ...);
VB\valley_event_manager.java           badge.grantBadge(players, "bdg_must_victory_army");
VB\valley_event_manager.java           buff.applyBuff(player, "high_morale", 3600);
```

```
SCRIPT\library\trial.java:27    public static final String ARMY_WIN_SIGNAL = "mustafar_droidarmy_victory";
SCRIPT\library\trial.java:131   public static final String BATTLEFIELD_DROID_ARMY_DEFEATED = "armyDefeated";
SCRIPT\library\trial.java:142   public static final String BATTLEFIELD_WIN_MESSAGE = "battlefield_win_message";
SCRIPT\library\trial.java:200   public static final String MUS_MUST_QUEST_WIN = "sound/mus_mustafar_quest_success.snd";
```

| Reward | Value |
|---|---|
| Quest signal | `mustafar_droidarmy_victory` (to all players in the instance area) |
| Badge | `bdg_must_victory_army` |
| Buff | `high_morale`, **3600 s** |
| Music | `sound/mus_mustafar_quest_success.snd` |
| Instance state | `armyDefeated` = true |

```
SCRIPT\library\trial.java:1547   public static void sendCompletionSignal(obj_id dungeon, String signalName)
                                     // groundquests.sendSignal(instance.getPlayersInInstanceArea(dungeon), signalName)
```

Clean‑out timer after the win — **300 seconds**:

```
SCRIPT\library\trial.java:1524   public static void setDungeonCleanOutTimer(obj_id dc)     // -> setDungeonCleanOutTimer(dc, 300)
SCRIPT\library\trial.java:1536   // setObjVar(dc, space_dungeon.VAR_DUNGEON_END_TIME, getGameTime() + 300);
                                 // messageTo(dc, "handleSessionTimerUpdate", ...); instance.setClock(dc, 300);
```

**Players get 5 minutes to loot and leave after victory.**

### 5.2 Lose — the end‑point monitor

The lose condition is *leakage*: droids reaching the end point. The monitor object spawns only at
stage −1 (i.e. only after the generator is destroyed — §3.8).

```
VB\end_point_monitor.java:15   public static final String VOLUME_NAME = "finish_monitor";
VB\end_point_monitor.java:16   public static final float VOLUME_RANGE = 18.0f;
VB\end_point_monitor.java:17   public static final int RESCAN = 10;
VB\end_point_monitor.java:20   public int OnAttach(obj_id self)
VB\end_point_monitor.java:23       messageTo(self, "scan", null, 1.0f, false);
VB\end_point_monitor.java:56   public int checkForDroidArmy(obj_id self, dictionary params)
VB\end_point_monitor.java          messageTo(self, "checkForDroidArmy", null, RESCAN, false);
VB\end_point_monitor.java          obj_id[] army = trial.getObjectsInRangeWithScriptVar(self, trial.BATTLEFIELD_DROID_ARMY, VOLUME_RANGE);
VB\end_point_monitor.java          // "living" = !isDead(x) && !ai_lib.isInCombat(x)   -> counter++
VB\end_point_monitor.java          // stage 1 -> instance.sendInstanceSystemMessage(trial.getParent(self), trial.BATTLEFIELD_LOSE_1)
VB\end_point_monitor.java          // stage 2 -> ... BATTLEFIELD_LOSE_2
VB\end_point_monitor.java          // stage 3 -> ... BATTLEFIELD_LOSE_3
VB\end_point_monitor.java          // stage 4 -> messageTo(trial.getParent(self), "loseTrial", null, 0, false)
```

```
SCRIPT\library\trial.java:144   public static final String BATTLEFIELD_LOSE_1 = "about_to_lose_1";
SCRIPT\library\trial.java:145   public static final String BATTLEFIELD_LOSE_2 = "about_to_lose_2";
SCRIPT\library\trial.java:146   public static final String BATTLEFIELD_LOSE_3 = "about_to_lose_3";
SCRIPT\library\trial.java:143   public static final String BATTLEFIELD_LOSE_MESSAGE = "battlefield_lose_message";
```

| Escalation stage | Result |
|---|---|
| 1 | instance warning `about_to_lose_1` |
| 2 | instance warning `about_to_lose_2` |
| 3 | instance warning `about_to_lose_3` |
| 4 | `loseTrial` on the controller |

**Scan radius 18 m around the end‑point marker at `179.501, 16.52941, 88.793`, re‑checked every 10 s.**
The counter increments per scan that finds a living, non‑combat droid and decrements otherwise — so
**three strikes of warning, then loss on the fourth.** A droid that is *in combat* inside the volume
does not count, which is what makes "hold the line at the end point" a workable tactic.

```
VB\valley_event_manager.java:327   public int loseTrial(obj_id self, dictionary params)
VB\valley_event_manager.java           instance.closeInstance(self);
```

### 5.3 Lose — instance timeout

```
DT\instance\instance_datatable.tab:12   mustafar_droid_army  ... enter_one "-79,12,-152,none"  exit_one "541,155,-160,mustafar"  key_required mustafar_droid_army  lockoutTimer daily
```

`min_players`, `max_players`, `player_script` and `time_limit` are **all empty cells** → they take the
type‑row defaults:

```
DT\instance\instance_datatable.tab  (type row)   ... min_players i[0]   max_players i[8]   player_script s[none]   time_limit i[3600]
```

| Field | Effective value | Source |
|---|---|---|
| Entry point | `-79, 12, -152` (no area) | cell |
| Exit point | `541, 155, -160`, `mustafar` | cell |
| Key required | `mustafar_droid_army` | cell |
| Lockout | `daily` | cell |
| Min players | **0** | default `i[0]` |
| Max players | **8** | default `i[8]` |
| Player script | **none** | default `s[none]` → `valley_player.java` never attaches |
| **Time limit** | **3600 s (1 hour)** | default `i[3600]` |

```
SCRIPT\systems\instance\instance_manager.java:156   public int startClock(...)        // fires handleClockTic 300s before expiry
SCRIPT\systems\instance\instance_manager.java:180   public int handleClockTic(...)
SCRIPT\systems\instance\instance_manager.java       if (time < 1) { ... instance.INSTANCE_TIMEOUT ... instance.closeInstance(self); }
```

```
SCRIPT\library\instance.java:642   public static void setClock(obj_id instance_id, int seconds)
```

**The full wave schedule ends at t = 1500 s; the instance closes at t = 3600 s. Players have 2100 s
(35 min) after the last wave to finish the commander.** The manager also closes the instance after 3
consecutive `failed_min_player_check` results, but `min_players = 0` makes that check unreachable.

### 5.4 Area reset

```
VB\valley_event_manager.java:33   public void clearEventArea(obj_id self)
VB\valley_event_manager.java:36       // resets isGeneratorDestoryed / isCommanderKilled / armyDefeated to false
VB\valley_event_manager.java          utils.setScriptVar(self, STAGE, 0);
VB\valley_event_manager.java          trial.bumpSession(self, "da_control");
VB\valley_event_manager.java          // 400m sweep -> trial.cleanupNpc on everything found
```

```
VB\valley_event_manager.java:23   public int cleanupSpawn(obj_id self, dictionary params)   // -> trial.dungeonCleanup
```

Note the misspelled constant, preserved from the original:

```
SCRIPT\library\trial.java:135   public static final String BATTLEFIELD_GENERATOR_DESTROYED = "isGeneratorDestoryed";
```

---

## §6 THE ALLIES

Three ally types. All of them are **damage‑immune to players by design** — not via `setInvulnerable`,
but by a hate‑inversion plus a heal‑for‑damage‑taken handler. Griefing is mechanically neutralised.

### 6.1 The friendly-fire pattern (shared by miner leader and miner)

```
mining_squad_leader.java:41   public int OnCreatureDamaged(obj_id self, obj_id attacker, obj_id weapon, int[] damage)
mining_squad_leader.java:43       if (isPlayer(attacker) || pet_lib.isPet(attacker))
mining_squad_leader.java:45           setHate(self, attacker, -5000.0f);
mining_squad_leader.java:50           addToHealth(self, total);
mining_squad_leader.java:54   public int OnAttackerCombatAction(obj_id self, obj_id weapon, obj_id defender)
mining_squad_leader.java:58           setHate(self, defender, -5000.0f);
mining_squad_leader.java:62   public int OnHateTargetAdded(obj_id self, obj_id target)
mining_squad_leader.java:66           setHate(self, target, -5000.0f);
```

Identical trio in `VB\mining_squad_member.java:36-64`. **A player who shoots a miner heals it for the
exact damage dealt and drives its hate to −5000.**

### 6.2 Mining droids — `VB\mining_droid.java` (5 spawned at stage 1)

```
mining_droid.java   public static final string_id ACTIVATE_DROID = new string_id("mustafar/valley_battlefield", "activate_droid");
mining_droid.java   OnObjectMenuRequest: only if hasSkill(player, "class_engineering_phase2_novice") AND utils.hasScriptVar(self, "deactivated")
mining_droid.java   OnAttach:  setInvulnerable(self, true); ai_lib.setDefaultCalmBehavior(self, ai_lib.BEHAVIOR_SENTINEL);
mining_droid.java              messageTo(self, "startPathing", null, 8, false); setHibernationDelay(self, 7200);
mining_droid.java   activateDroid: playClientEffectObj(..., "clienteffect/space_command/emergency_power_on.cef", ..., 0.4f);
mining_droid.java                  messageTo(self, "startPathing", null, 3, false);
mining_droid.java   pathToNextPoint: ai_lib.setPatrolRandomPath(self, patrolPoints); setInvulnerable(self, false);
```

| Property | Value |
|---|---|
| Radial gate | `class_engineering_phase2_novice` **and** scriptvar `deactivated` |
| Start state | invulnerable, sentinel behaviour |
| Auto‑start | 8 s after attach |
| Reactivation delay | 3 s after the `emergency_power_on.cef` effect (0.4 s in) |
| Movement | `setPatrolRandomPath` — random order, unlike the army's `setPatrolOncePath` |
| Vulnerability | becomes vulnerable the moment it starts pathing |

Waypoint discovery is deliberately loose:

```
mining_droid.java   findWayPoints:  // 500m search; matches wp_name.startsWith("droid")
```

**This matches 7 waypoints, not 4** — `droid_1`, `droid_2`, `droid_3`, `droid_4` plus
`droid_exit_bridge`, `droid_exit_ramp`, `droid_east_bridge`. The mining droids therefore wander far
out onto the droid‑army approach bridges. Whether that was intended is unknowable from source; it is
what the code does.

### 6.3 Miner squad leaders — `VB\mining_squad_leader.java`

2 spawn at stage 1 (conversable, player‑commanded); 9 spawn at stage −1 with `autoDeploy=1`.

```
mining_squad_leader.java:13   public static final String MINE_SOLDIER = "som_battlefield_miner";
mining_squad_leader.java:15   public int OnAttach(obj_id self)
mining_squad_leader.java:17       ai_lib.setDefaultCalmBehavior(self, ai_lib.BEHAVIOR_SENTINEL);
mining_squad_leader.java:19       messageTo(self, "autoDeploy", null, 5, false);
mining_squad_leader.java:20       setHibernationDelay(self, 7200);
mining_squad_leader.java:23   public int autoDeploy(obj_id self, dictionary params)
mining_squad_leader.java:25       if (utils.hasScriptVar(self, "autoDeploy"))
mining_squad_leader.java:27           messageTo(self, "deployForces", null, 0, false);
```

**Auto‑deploy check runs 5 s after attach and only fires if the `autoDeploy` scriptvar is set** —
which is exactly the stage −1 rows (§3.8). The stage‑1 pair must be told to deploy by a player.

```
mining_squad_leader.java:75    public int deployForces(obj_id self, dictionary params)
mining_squad_leader.java:77        setInvulnerable(self, false);
mining_squad_leader.java:79        factions.setIgnorePlayer(self);
mining_squad_leader.java:80        obj_id[] miners = new obj_id[4];
mining_squad_leader.java:82        setYaw(self, -70);
mining_squad_leader.java:86        miners[i] = create.object(MINE_SOLDIER, spawnLoc);
mining_squad_leader.java:89        attachScript(miners[i], "...valley_battleground.mining_squad_member");
mining_squad_leader.java:90        setYaw(miners[i], -70);
mining_squad_leader.java:92        ai_lib.followInFormation(miners[i], self, ai_lib.FORMATION_BOX, i + 1);
mining_squad_leader.java:93        factions.setIgnorePlayer(miners[i]);
mining_squad_leader.java:96        utils.setScriptVar(self, "forces", miners);
mining_squad_leader.java:97        utils.setScriptVar(self, "deployed", true);
```

**4 miners per leader, `FORMATION_BOX` slots 1‑4, all yawed −70.** Deploying makes the leader
vulnerable (`setInvulnerable(self, false)`).

Undeploy is refused once blooded, and it **kills** the squad rather than despawning it:

```
mining_squad_leader.java:100   public int unDeployForces(obj_id self, dictionary params)
mining_squad_leader.java:102       if (utils.hasScriptVar(self, "engaged"))   // "I have already been engaged, ignoring command"
mining_squad_leader.java:122       setInvulnerable(self, true);
mining_squad_leader.java:125           kill(force);
mining_squad_leader.java:126           destroyObject(force);
```

The `engaged` flag is set two ways — the leader entering combat, or any member reporting in:

```
mining_squad_leader.java:31   public int OnEnteredCombat(obj_id self)
mining_squad_leader.java:33       utils.setScriptVar(self, "engaged", true);
mining_squad_leader.java:34       if (hasScript(self, "conversation.som_battlefield_miner_leader"))
mining_squad_leader.java:36           clearCondition(self, CONDITION_CONVERSABLE);
mining_squad_leader.java:37           detachScript(self, "conversation.som_battlefield_miner_leader");
mining_squad_leader.java:70   public int troopEngaged(obj_id self, dictionary params)
mining_squad_leader.java:72       utils.setScriptVar(self, "engaged", true);
```

```
mining_squad_member.java:22   public int OnEnteredCombat(obj_id self)
mining_squad_member.java:33       messageTo(parent, "troopEngaged", null, 0, false);
```

**A leader in combat permanently loses its conversation menu** — the script is detached, not just
hidden. Commands cannot be reissued after the fighting starts.

### 6.4 Miner debuff on generator loss

```
VB\valley_event_manager.java:229   public void debufMiners(obj_id self)
```

Called 10 s after the generator dies (§1.4).

### 6.5 Miner leader conversation — `SCRIPT\conversation\som_battlefield_miner_leader.java`

Four commands, mutually gated by follow/deploy state:

```
som_battlefield_miner_leader.java:34   // deployForces:     ai_lib.aiStopFollowing(npc); aiSetHomeLocation(npc, here);
som_battlefield_miner_leader.java:40   //                   utils.setScriptVar(npc, "player", player); messageTo(npc, "deployForces", ...)
som_battlefield_miner_leader.java:42   // startFollowing:   ai_lib.aiFollow(...); setMovementRun(npc);
som_battlefield_miner_leader.java:47   // stopFollowing:    ai_lib.aiStopFollowing(npc); aiSetHomeLocation(...); BEHAVIOR_SENTINEL
som_battlefield_miner_leader.java:54   // undeployAndFollow: messageTo(npc, "unDeployForces", ...); ai_lib.aiFollow(...)
```

| Response slot | String id | Action | Gate condition |
|---|---|---|---|
| `:191` | `s_6` | `startFollowing` → reply `s_8` | `isNotFollowing` |
| `:195` | `s_10` | `stopFollowing` → reply `s_12` | `isMinerFollowing` |
| `:199` | `s_14` | `deployForces` | `isNotDeployed` |
| `:203` | `s_18` | `undeployAndFollow` | `isDeployed` |

Localized text for these string ids — **not in source** (no `.stf` present).

### 6.6 Foreman Koseyet — `SCRIPT\conversation\trial_foreman_koseyet.java`

Spawned at stage 1 at `293.501, 19.52941, 151.793` (§3.6). The quest‑giver / exit NPC.

```
trial_foreman_koseyet.java   public static final String c_stringFile = "conversation/trial_foreman_koseyet";
trial_foreman_koseyet.java   // conditions: isArmyActive / isArmyDefeated  -> trial.isDroidArmyDefeated(trial.getParent(npc))
trial_foreman_koseyet.java   // action ejectFromInstance -> instance.requestExitPlayer("mustafar_droid_army", player)
trial_foreman_koseyet.java   // action faceLowerCamp     -> faceTo(npc, trial.getParent(npc))
trial_foreman_koseyet.java   OnAttach: setCondition(CONVERSABLE | INTERESTING); setInvulnerable(npc, true);
trial_foreman_koseyet.java             ai_lib.setDefaultCalmBehavior(npc, ai_lib.BEHAVIOR_SENTINEL);
trial_foreman_koseyet.java   OnStartNpcConversation: blocked while in combat
```

Branch map:

| State | Greeting | Player options | Outcome |
|---|---|---|---|
| Army NOT defeated | `s_4` (branch 1) | `s_6`, `s_14` | — |
| `s_6` | → `s_8` + `s_17` (branch 2) | `s_17` | `faceLowerCamp` + `doAnimationAction(npc,"point_forward")` + `s_18` + `s_19` (branch 3) |
| `s_19` (branch 3) | — | — | end at `s_20` |
| `s_14` | → `s_16` + `s_22` (branch 5) | `s_22` | **eject from instance**, end at `s_24` |
| Army defeated | `s_26` (branch 7) | `s_28` | **eject from instance**, end at `s_30` |

Localized text — **not in source**.

---

## §7 THE 26 WAYPOINTS AND 14 PATHS

### 7.1 How pathing is wired

Waypoints are buildout objects, not datatable rows. They carry their name in a packed objvar:

```
DT\buildout\mustafar\mustafar_droid_army.tab   objvars:  ignoreInBuildoutArray|0|1|registerWithController|0|1|wp_name|4|<name>|$|
```

```
SCRIPT\library\trial.java:22   public static final String WAYPOINT_NAME = "wp_name";
```

The controller itself is a buildout row:

```
DT\buildout\mustafar\mustafar_droid_army.tab:18   valley_battlefield_controller.iff   374.501   6.52941   282.793
```

Path resolution in `forward_commander.java` (the same routine is used by the squad leaders and
killer bots):

```
forward_commander.java:59   public void findWayPoints(obj_id self)
forward_commander.java          // 400m search for objects carrying wp_name
forward_commander.java          // pathNum = scriptvar "path" if present, else rand(0, paths.length - 1)
forward_commander.java          String path = dataTableGetString(trial.VALLEY_DATA, pathNum, "path");
forward_commander.java          String[] points = split(path, ';');
forward_commander.java          // for each point name, match against the objvar wp_name of the found waypoints
```

**Three parser facts that matter:**
1. `dataTableGetString(table, pathNum, "path")` takes a **row index**, not a stage. Path index N =
   data row N = **file line N + 3**.
2. Path strings are **semicolon‑separated**, unlike the colon‑separated `script` column and the
   comma‑separated `scriptVar` column. All three delimiters are different.
3. A mob with no `path` scriptvar picks a random path index. Every assault row does set `path`, so
   the random branch is only reachable via rezzed mobs that lost their scriptvar — they instead
   inherit copied `patrolPoints` (§4.3), so in practice the random branch is unused.

Because the `path` column is row‑indexed, path strings 0‑13 live on the first 14 data rows — which are
stage‑1 miner and fence rows. **The `path` column has nothing to do with the row it sits on.**

Movement mode differs by faction:

| Who | Call |
|---|---|
| Droid army (commander, guards, squad leaders, killer bots) | `ai_lib.setPatrolOncePath(...)` — one pass, in order |
| Mining droids (allies) | `ai_lib.setPatrolRandomPath(...)` — random order |

### 7.2 The 26 waypoints

World coords from `DT\buildout\mustafar\mustafar_droid_army.tab`. Offsets are relative to the
controller at `374.501, 6.52941, 282.793`.

| # | `wp_name` | World (x, y, z) | Offset from controller | Referenced by paths |
|---|---|---|---|---|
| 1 | `mining_camp` | 395.701, 6.52941, 264.759 | 21.200, 0.000, −18.034 | **all 0‑13** |
| 2 | `camp_east` | 380.592, 6.52941, 401.678 | 6.091, 0.000, 118.885 | 0, 3, 5, 7 |
| 3 | `camp_west` | 332.782, 6.52941, 258.294 | −41.719, 0.000, −24.499 | 1, 2, 4, 6 |
| 4 | `player_exit` | 269.350, 6.52941, 254.827 | −105.151, 0.000, −27.966 | 0‑12 |
| 5 | `droid_1` | 338.725, 6.52941, 260.568 | −35.776, 0.000, −22.225 | **none** |
| 6 | `droid_2` | 360.675, 6.52941, 253.604 | −13.826, 0.000, −29.189 | **none** |
| 7 | `droid_3` | 406.672, 6.52941, 329.371 | 32.171, 0.000, 46.578 | **none** |
| 8 | `droid_4` | 397.201, 6.52941, 358.066 | 22.700, 0.000, 75.273 | **none** |
| 9 | `east_wall` | 283.070, 6.52941, 433.601 | −91.431, 0.000, 150.808 | 0, 1, 3, 7, 9 |
| 10 | `hk_droid_exit` | 223.589, 6.52941, 388.778 | −150.912, 0.000, 105.985 | 0, 1, 2, 3 |
| 11 | `hk_droid_exit_top` | 178.121, 18.05880, 453.577 | −196.380, 11.529, 170.784 | 0‑5 |
| 12 | `hk_droid_exit_start` | 121.349, 18.82900, 470.392 | −253.152, 12.300, 187.599 | 0‑5 |
| 13 | `west_approach` | 218.661, 10.93540, 262.092 | −155.840, 4.406, −20.701 | 2, 3, 4, 9, 10, 13 |
| 14 | `western_flats` | 109.933, 6.52941, 310.121 | −264.568, 0.000, 27.328 | 4, 5, 6, 8 |
| 15 | `center_line` | 281.177, 6.52941, 337.464 | −93.324, 0.000, 54.671 | 1, 3, 5, 6, 9 |
| 16 | `top_camp_2` | 298.419, 19.29450, 126.094 | −76.082, 12.765, −156.699 | 4, 12 |
| 17 | `top_camp_0` | 249.997, 17.51160, 158.698 | −124.504, 10.982, −124.095 | 0, 5, 6, 8, 9, 11, 13 |
| 18 | `top_camp_1` | 229.739, 13.09320, 162.976 | −144.762, 6.564, −119.817 | 1, 2, 3, 7, 10 |
| 19 | `end_point` | 177.752, 15.73460, 93.090 | −196.749, 9.205, −189.703 | **all 0‑13** |
| 20 | `droid_exit_bridge` | 151.792, 18.61310, 457.872 | −222.709, 12.084, 175.079 | 0‑5 |
| 21 | `droid_exit_ramp` | 188.211, 13.47110, 426.655 | −186.290, 6.942, 143.862 | 0, 1 |
| 22 | `droid_east_bridge` | 250.711, 6.52941, 412.851 | −123.790, 0.000, 130.058 | 0, 1 |
| 23 | `east_camp_bridge` | 337.836, 6.52942, 418.139 | −36.665, 0.000, 135.346 | 0 |
| 24 | `east_approach_bridge` | 388.805, 6.52942, 313.518 | 14.304, 0.000, 30.725 | 0, 3, 5, 7 |
| 25 | `exit_west_bridge` | 143.891, 6.83183, 370.234 | −230.610, 0.302, 87.441 | 2, 3, 4, 5 |
| 26 | `player_exit_ramp` | 270.853, 8.70778, 222.279 | −103.648, 2.178, −60.514 | 0 |

Reading the table:
- **`mining_camp` and `end_point` are on every single path.** Every droid that lives long enough walks
  the mining camp and then the end point. That is the funnel the players defend.
- **`droid_1`..`droid_4` are referenced by zero paths.** They exist only for the mining droids'
  `startsWith("droid")` match (§6.2) — and that match also swallows waypoints 20, 21 and 22.
- `end_point` at `177.752, 15.73460, 93.090` sits ~2.6 m from the stage −1 monitor at
  `179.501, 16.52941, 88.793`, comfortably inside the monitor's 18 m volume (§5.2).
- The dead `redirectArmy` routine looks up `end_point` and `player_exit` — the only trace of a
  planned re‑route mechanic that never shipped.

### 7.3 The 14 path strings (verbatim)

Index = data row index = file line − 3, from the `path` column of `valley_event_data.tab`.

| Idx | Path (`;`‑separated) |
|---|---|
| 0 | `hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;droid_exit_ramp;hk_droid_exit;droid_east_bridge;east_wall;east_camp_bridge;camp_east;east_approach_bridge;mining_camp;player_exit;player_exit_ramp;top_camp_0;end_point` |
| 1 | `hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;droid_exit_ramp;hk_droid_exit;droid_east_bridge;east_wall;center_line;player_exit;camp_west;mining_camp;player_exit;top_camp_1;end_point` |
| 2 | `hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;droid_exit_bridge;hk_droid_exit;exit_west_bridge;west_approach;player_exit;camp_west;mining_camp;player_exit;top_camp_1;end_point` |
| 3 | `hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;droid_exit_bridge;hk_droid_exit;exit_west_bridge;west_approach;center_line;east_wall;camp_east;east_approach_bridge;mining_camp;player_exit;top_camp_1;end_point` |
| 4 | `hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;exit_west_bridge;western_flats;west_approach;player_exit;camp_west;mining_camp;player_exit;top_camp_2;end_point` |
| 5 | `hk_droid_exit_start;droid_exit_bridge;hk_droid_exit_top;exit_west_bridge;western_flats;center_line;camp_east;east_approach_bridge;mining_camp;player_exit;top_camp_0;end_point` |
| 6 | `western_flats;center_line;camp_west;mining_camp;player_exit;top_camp_0;end_point` |
| 7 | `east_wall;camp_east;east_approach_bridge;mining_camp;player_exit;top_camp_1;end_point` |
| 8 | `western_flats;player_exit;mining_camp;player_exit;top_camp_0;end_point` |
| 9 | `east_wall;center_line;west_approach;player_exit;mining_camp;player_exit;top_camp_0;end_point` |
| 10 | `west_approach;mining_camp;player_exit;top_camp_1;end_point` |
| 11 | `mining_camp;player_exit;top_camp_0;end_point` |
| 12 | `mining_camp;player_exit;top_camp_2;end_point` |
| 13 | `west_approach;mining_camp;top_camp_0;end_point` |

Path‑length notes (they encode the difficulty curve):
- Paths 0‑5 are the **long routes** (12‑15 hops) starting at `hk_droid_exit_start` in the far
  north‑west, used by the early waves — droids take minutes to arrive.
- Paths 6‑10 are **medium** (5‑8 hops), starting mid‑field.
- Paths 11‑13 are **short** (4‑5 hops), starting at or near the mining camp. Stage 10 (the commander)
  uses path 12 and stage 11 uses 12/10/13 — **the final waves arrive almost immediately.**
- Paths 1, 2, 4, 8, 9 list `player_exit` **twice**. `setPatrolOncePath` walks the list in order, so
  those droids double back through the exit point. Faithful to source; not obviously intentional.
- Path 2 and 3 list `droid_exit_bridge` twice (positions 2 and 4) — same doubling pattern.

---

## Gaps — where the source is silent

| Item | Status |
|---|---|
| `mustafar/valley_battlefield.stf` text (all instance messages, radial labels, fly text) | **not in source** — no `.stf` for this file exists in the extract |
| `npc_landmines.stf` text (`place_charge`) | **not in source** |
| `conversation/trial_foreman_koseyet.stf` and `.../som_battlefield_miner_leader.stf` text | **not in source** |
| `DT\loot\creature_loot\mustafar\mustafar_npc_loot_b.tab` (commander drop contents) | **not in source** — the `.tab` is absent; only the `master_loot.tab` pointer exists |
| Body of `trial.debuffDroidArmy` / `trial.debufMiners` effect stacks | in `valley_event_manager.java:206` / `:229`; the specific buff names are inside those method bodies |
| `redirectArmy` intended trigger | **not in source** — no caller exists |
