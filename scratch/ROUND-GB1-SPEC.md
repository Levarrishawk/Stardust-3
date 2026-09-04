# ROUND G(b1) — the Kenobi finale setpiece

You are editing `C:\stardust-3-space-port\server`, branch `mustafar-content`.

**Do not commit. Do not run git. Do not push.**

Touch ONLY the files named in the "FILES" section. These files are FENCED — never open
them: `obi_wan_ghost.lua`, `surveyor_jo.lua`, the retune-fenced `serverobjects.lua`,
`jo_kelsev_conv_handler.lua`, `MMOCoreORB/bin/conf/config.lua`.

Round G(a) wired quest XP through `MustafarQuestXp:award`. **Do not re-touch any XP award
call or `mustafar_quest_xp.lua`.** They are done and verified.

Every file you touch must pass `luac5.3 -p`.

House rule for comments in this tree: **amend findings forward, never delete one to make
room.** If a note is now wrong, keep it and write underneath it what overturned it and
where the new fact came from. Comments cite file:line of the source they came from.

---

## 1. WHAT THIS ROUND IS

`kenobi_spine.lua` currently ends the arc like this: the player enters the crystal lair,
kills `som_dark_jedi_boss`, and gets a system message saying "Sinistro is dead and the Soul
Crystal is destroyed." There is no crystal in the room. There is no pedestal. There is no
way out except the instance sweep. Obi-Wan is not there.

The file itself says so, at `kenobi_spine.lua:211-260`, in a block headed "WHAT IS NOT
MODELLED, AND WHY". That block says the two registered tangibles
`som_kenobi_final_crystal_pedestal` and `som_kenobi_final_force_crystal` are referenced by
no `.qst` and no dungeon spawn table, guesses that they belong at the centre of the .ilf's
second statue gallery, `(79.83, 5.29)`, and closes:

> The x/z are as good as sourced; the h is not. That is the whole decision, and it
> is Aaron's.

**That block is wrong, and this round overturns it.** The room's contents are not in a
`.qst` and not in a dungeon spawn table. They are in the building's own server template,
which names four scripts, one of which reads a datatable that is the complete shipped
setpiece. The pedestal is at `(57, 0, 6)`, not `(79.83, ?, 5.29)`, and the height is `0`,
not unknowable. Nothing here was ever a decision for Aaron; it was a lookup nobody had done.

---

## 2. THE SOURCE CHAIN — quote these file paths in the comments you write

**Step 1.** The building's shared template names the interior:

`_dsrc-full/sku.0/sys.shared/.../shared_lair_of_the_crystal.tpf`

```
interiorLayoutFileName = "interiorlayout/som_obiwan_crystal_lair.ilf"
objectName             = "som/mustafar_items"  "lair_of_the_crystal"
portalLayoutFilename   = "appearance/poi_all_bunker_cave_s01.pob"
```

**Step 2.** The building's SERVER template names the scripts. This is the link the earlier
search missed:

`_dsrc-full/sku.0/sys.server/.../lair_of_the_crystal.tpf`

```
objvars = +[ "instance_name"="obiwan_crystal_cave" ]
scripts = +[ "systems.instance.instance_manager",
             "theme_park.dungeon.generic_spawner",
             "theme_park.dungeon.mustafar_trials.obiwan_finale.lair_clean_up",
             "theme_park.dungeon.mustafar_trials.obiwan_finale.obiwan_event_manager" ]
```

**Step 3.** `obiwan_event_manager` reads
`_dsrc-full/sku.0/sys.server/compiled/game/datatables/dungeon/mustafar_trials/obiwan_finale/obiwan_event_data.tab`.
Columns are `dataType | object | locx | locy | locz | yaw | script | animation |
clientEffect | minDamage | maxDamage`. The rows, verbatim:

```
setpiece | .../obiwan_finale_buff_crystal.iff                            | 57   | 1.5 | 6    | -92 | obiwan_crystal_object
setpiece | object/tangible/quest/som_kenobi_final_crystal_pedestal.iff   | 57   | 0   | 6    | -90 |
setpiece | .../obiwan_finale_exit_stone.iff                              | 4.38 | 0   | 2.34 | 0   | obiwan_exit_object
boss     | som_kenobi_dark_jedi_boss                                     | 9    | 0   | -3.5 | 0   | obiwan_lair_boss
minionA  | som_kenobi_finale_minion_mix                                  | 9.4  | 0   | -3.5 | 0   | obiwan_minion_ops
minionB  | som_kenobi_finale_minion_melee                                | 9.4  | 0   | -3.5 | 0   | obiwan_minion_ops
location | hangBackLocation                                              | 33   | 0   | 4.7  | 88
location | postureLocation                                               | 43   | 0   | 5    | 86
forcePowerAttack | singleStoneThrow | force_push     | dark_jedi_rock_attack_1.cef  |  500 | 1000
forcePowerAttack | doubleStoneThrow | force_strength | dark_jedi_rock_attack_2.cef  | 1000 | 2000
forcePowerAttack | tripleStoneThrow | force_strength | dark_jedi_rock_attack_3.cef  | 2000 | 3000
forcePowerAttack | multiStoneThrow  | force_choke    | dark_jedi_rock_attack_10.cef | 3000 | 4000
```

The `minion*` and `forcePowerAttack` rows are round G(b2), not this round. Leave them.

**Step 4 — the trap, already sprung once, do not fall into it.** The two `location` rows
are NOT both live. `postureLocation` is dead data: the boss's two move targets are
hardcoded in Java and neither equals `(43, 0, 5)`.

`obiwan_event_manager.java:465-490`:

```java
public int moveBossToPostureLoc(...) { ... location home = new location(53.0f, 0.0f, 5.0f, ...); ai_lib.aiPathTo(darkJedi, home); setHomeLocation(darkJedi, home); }
public int moveBossToHomeLoc(...)    { ... location home = new location(31,   0.0f, 6.0f, ...); ... }
```

`hangBackLocation` IS live — `moveObiwanHomeAfterCommenting` (`obiwan_event_manager.java:589`)
is the only Obi-Wan mover with no hardcoded `new location`, so `(33, 0, 4.7)` yaw `88` is
where Obi-Wan stands.

**Step 5 — which boss position is the fighting one.** Read the callers, not the names:

- `moveBossToHomeLoc` is messaged immediately before every `minionWaveLaunch`
  (`obiwan_event_manager.java:179`, `:199`, `:254`). That is **`(31, 0, 6)`** — where he
  fights.
- `moveBossToPostureLoc` is messaged when the last minion dies, right before
  `lightsCameraAction` (`obiwan_event_manager.java:392`). That is **`(53, 0, 5)`** — where
  he stands and monologues, one step from the pedestal at `(57, 0, 6)`.

**Use `(31, 0, 6)`.** This tree has no intermission ladder in G(b1), so the boss lives at
his fighting position.

**Step 6 — the cell name is confirmed, not assumed.**
`obiwan_event_manager.java:539` does `getCellId(self, "mainroom")`, matching
`kenobiSpineScreenPlay.lair.cellName = "mainroom"` already in the repo.

---

## 3. AXIS MAPPING — get this right or everything is in the wrong place

SOE's columns are `locx, locy, locz` where **`locy` is HEIGHT**.
This repo's Lua argument order is `x, z, y` where **`z` is HEIGHT**.

So `SOE (locx, locy, locz)` becomes `repo (x = locx, z = locy, y = locz)`.

`spawnSceneObject(zone, template, x, z, y, cellID, radians)` — heading in RADIANS, so wrap
in `math.rad()`. See `kenobi_spine.lua:669` for the existing call.
`spawnMobile(zone, template, respawn, x, z, y, headingDegrees, cellID)` — heading in
DEGREES. See `kenobi_spine.lua:770`.

The resulting table, which you will transcribe into `kenobi_spine.lua`:

| what | template | x | z (height) | y | heading |
|---|---|---|---|---|---|
| pedestal | `object/tangible/quest/som_kenobi_final_crystal_pedestal.iff` | 57 | 0 | 6 | -90 |
| buff crystal | `object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_buff_crystal.iff` | 57 | 1.5 | 6 | -92 |
| exit stone | `object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_exit_stone.iff` | 4.38 | 0 | 2.34 | 0 |
| boss | `som_dark_jedi_boss` | 31 | 0 | 6 | 90 |
| Obi-Wan | `som_kenobi_obi_wan` | 33 | 0 | 4.7 | 88 |

Notes you must write into the code as comments:

- The buff crystal's height `1.5` is not a typo — it floats one and a half metres above the
  pedestal, which sits at height `0`. Same x and y.
- The boss heading `90` is kept from the existing repo line and its existing comment
  ("facing back up the aisle, at the arriving player"); the player arrives at `(24.0, 5.1)`
  and the boss is still east of that at `x = 31`, so the heading is still correct. Only x
  and y change: `37.0 -> 31`, `5.1 -> 6`.
- The yaw values `-90` / `-92` / `88` are transcribed from the shipped table. Only the
  POSITIONS were cross-checked against a second source; the yaw convention was not, so say
  so in the comment rather than claiming it was verified.

**All five objects are per-copy.** The pool `lair_of_the_crystal` has 12 copies and
`spawnBosses()` (`kenobi_spine.lua:752-777`) already walks all of them. Extend that loop
rather than writing a second one.

---

## 4. WHAT THE ROOM DOES — sourced behaviour

### 4.1 The crystal is a three-state object

`obiwan_crystal_object.java:26-73`:

- player has scriptvar `readyToUseCrystal` -> one menu item, `obiwan_finale_use_crystal`
  -> `theBigCrystalBuff`
- player has scriptvar `dealWithCrystal` -> two menu items,
  `obiwan_finale_destroy_crystal` and `obiwan_finale_take_crystal`
- crystal has objvar `drainedCrystal` -> one menu item -> `drainedCrystalBuff`

`readyToUseCrystal` is set at intermission 2 and `dealWithCrystal` at intermission 5
(`obiwan_event_manager.java:190`, `:221`) — that is, once the boss is finished.

### 4.2 The two endings

`destroyTheCrystal` (`obiwan_crystal_object.java`): `PLAYER_FORCE_BLAST` animation,
`clienteffect/mustafar/som_force_crystal_destruction.cef`, then messageTo the dungeon
`"blowUpCrystal"` at 3 s and `"obiCongratulatesPlayer"` at 5 s.

`obiCongratulatesPlayer` (`obiwan_event_manager.java:433-447`):
```java
static_item.createNewItemFunction("item_tow_crystal_uber_05_02", player);
badge.grantBadge(player, "bdg_must_obiwan_story_good");
```

`takeTheCrystal`: Obi-Wan plays `som_obi_disappointed`, messageTo
`"moveObiwanToCrystalSuckLocation"` at 2 s, then `playerGetsCrystal`
(`obiwan_event_manager.java:414-431`):
```java
static_item.createNewItemFunction("item_tow_cystal_buff_drained_05_01", player);  // SOE's own typo
badge.grantBadge(player, "bdg_must_obiwan_story_bad");
destroyObject(crystal);
```

### 4.3 The exit stone

`obiwan_exit_object.java:26-42`: adds an `ITEM_USE` root menu; if the player is within
`6.0f` it adds a second `ITEM_USE` labelled `obiwan_finale_eject`; selecting it calls
`instance.requestExitPlayer("obiwan_crystal_cave", player)`.

Our equivalent is `MustafarInstances:sendToExit(pPlayer, pBuilding)`
(`mustafar_instances.lua:708`). Get the building with
`SceneObject(pStone):getRootParent()` — that binding exists
(`LuaSceneObject.cpp:25`, `:451`).

---

## 5. RULINGS — these are decided. Implement them; do not re-open them.

### R1. There is no Lua buff API in this tree. Do not invent one.

Verified by direct grep of `MMOCoreORB/src/`:

```
grep "buff\|Buff" src/server/zone/objects/creature/LuaCreatureObject.cpp   -> nothing
grep "Buff"       src/server/zone/objects/player/LuaPlayerObject.cpp       -> nothing
grep -rn "\"addBuff\"\|\"applyBuff\"\|\"hasBuff\"\|\"removeBuff\"" src/    -> nothing
```

This matches the ruling already standing at `valley_battlefield.lua:63-80`.

So `buff.applyBuff(player, "crystal_buff")` cannot be ported as a buff. The shipped buff is
`datatables/buff/buff.tab:378`:

```
crystal_buff          GROUP1 som_crystal_buff    PRIORITY 6  ICON command.centerOfBeing  DURATION 500
                      expertise_healing_all 100 | health 90000 | expertise_damage_all 350
                      combat_divide_damage_taken 85 | expertise_glancing_blow_all 100
crystal_buff_drained  GROUP1 som_drained_crystal                                        DURATION 120
                      expertise_critical_niche_all 5 | expertise_damage_all 10
                      expertise_glancing_blow_all 5 | constitution_modified 75 | luck_modified 50
```

**What to implement:** using the crystal performs a full HAM restore —
`CreatureObject(pPlayer):healDamage(missing, pool)` across all three pools, the same call
`volcano_battlefield.lua:455` already uses. Nothing else.

**What to record in the header, honestly:** four of the five `crystal_buff` effects
(`expertise_healing_all`, `expertise_damage_all`, `combat_divide_damage_taken`,
`expertise_glancing_blow_all`) have no Core3 analogue and are omitted; the fifth,
`health 90000`, is approximated by the full heal rather than by editing max HAM. Say WHY
max HAM was rejected: `setMaxHAM` exists (`LuaCreatureObject.cpp:49`, `:436`) but a raise
needs a guaranteed revert, and a logout, a death or a server restart inside the 500 s
window would leave the player permanently 90000 health over cap. A missed revert is worse
than a missing buff.

Also record that `buff.removeAllBuffs(player)` at `obiwan_event_manager.java:222` has no
equivalent and is a no-op here for the same reason.

### R2. Neither static item is granted. Both are recorded by name.

`item_tow_crystal_uber_05_02` and `item_tow_cystal_buff_drained_05_01` are static-item
names, not object templates. Both keys exist in `static_item_n.stf`; neither has a shipped
object template. This is the same situation `collectors_business.lua:82-92` already ruled
for `item_tow_holocron_ab_immune_02_01` — cite that file:line in your comment.

So: **both endings grant the badge and the scene, neither grants an item.** Do not give the
good ending nothing and the bad ending a substitute — that would make the correct choice
pay less, which is a gameplay wrong invented by us, not by SOE. Symmetric and recorded is
the honest state. Write both item names into the comment so a later pass with a static-item
system can wire them.

### R3. Badges are nil-guarded.

`bdg_must_obiwan_story_good` and `bdg_must_obiwan_story_bad` are NOT in this repo — checked
with `grep -rn "bdg_must_obiwan" bin/scripts/` which returns nothing. Use the guard pattern
this tree already uses at `volcano_battlefield.lua:2984` and `story_arc_chapters.lua:1941`:

```lua
if (_G[self.goodBadge] ~= nil) then
    awardBadge(pPlayer, _G[self.goodBadge])
end
```

Read one of those two call sites first and copy its exact shape, including how it reports
the miss.

### R4. The quest XP award does not move.

`bossKilled` (`kenobi_spine.lua:1694-1711`) already awards `som_kenobi_main_quest_3_b_visible`
or `som_kenobi_main_quest_3_visible` on the `sparedTheHermit` branch. That is round G(a)
work and it is correct: the `.qst` completes on task 15, the boss kill, not on the crystal
choice. **Leave it exactly where it is.** The crystal choice is an epilogue after quest
completion, which is what SOE did too.

### R5. The crystal choice can be taken once.

Write a per-player screenplay data key (`crystal`: `0` unset, `1` destroyed, `2` taken) and
gate the radial on it, the same way `getConduitState` gates the three conduits. After the
choice the radial goes away.

### R6. `bossKilled`'s message is now wrong and must be amended.

It says "Sinistro is dead and the Soul Crystal is destroyed." The player has not touched the
crystal yet. Change it to say the boss is dead and the crystal is now unguarded, and put the
success sting where it is. Keep the `.qst` citation comment above it.

---

## 6. FILES — touch only these

### 6.1 `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/kenobi_spine.lua`

Everything in this round lives here. In order:

1. **Amend the `WHAT IS NOT MODELLED` block at `:211-260` forward.** Keep every existing
   sentence. Underneath, add a clearly-marked paragraph that says: the tangibles were found;
   the source is the building's own server template naming `obiwan_event_manager`, which
   reads `obiwan_event_data.tab`; the pedestal is at `(57, 0, 6)` yaw `-90`; the gallery-2
   centre guess of `(79.83, 5.29)` is retracted and was wrong by about 23 m; the height was
   never unknowable, it is `0`; and the closing claim that the placement "is Aaron's"
   decision was a research gap, not a design question. Move the surviving text about the two
   statue galleries into that paragraph as what it now is — a description of the room, not a
   guess about the pedestal.

2. **Extend the `lair` table** at `:491-505` into the full setpiece. Keep `poolKey`,
   `cellName`, `respawn` and the existing `respawn` comment about `findFreeCopy` verbatim.
   Change `x` and `y` per section 3, with a comment recording the old guessed values and
   what replaced them. Add sub-tables for the pedestal, the crystal, the exit stone and
   Obi-Wan, each carrying template, x, z, y, heading, and a one-line source citation.

3. **Rename and extend `spawnBosses()`** at `:752-777` to furnish the whole room per copy —
   boss, Obi-Wan, pedestal, crystal, exit stone. Keep every existing `printLuaError` and add
   one per new object in the same voice, so a silent failure is still visible in the boot
   log. Keep the `bossCopies` counter and add counters for the setpiece the same way, since
   the boot check is the only thing that can tell a silent failure from a success. Update
   the call site of the old name.

   Attach `KenobiSpineMenuComponent` to the crystal and to the exit stone, and register
   their roles with `writeStringData(objectID .. ":kenobiSpineRole", ...)` — the exact
   pattern already used for the conduits at `:743-744`. Roles: `"finaleCrystal"` and
   `"exitStone"`. The pedestal and Obi-Wan get no menu.

4. **Extend `getRadialText`** at `:1726-1772` with the two new roles.
   - `exitStone`: always "Leave the chamber of the crystal" for a player whose stage is
     `>= STAGE_LAIR`; `nil` otherwise.
   - `finaleCrystal`: `nil` unless the stage is `STAGE_LAIR` or `STAGE_DONE`.
     At `STAGE_LAIR` (fight in progress, choice not yet unlocked) -> "Draw on the crystal's
     power", once per player, gated on a `usedCrystal` data key.
     At `STAGE_DONE` with `crystal == 0` -> this is the two-item case. `getRadialText`
     returns one string, so add a sibling `getRadialItems(pPlayer, role)` returning a list,
     have `fillObjectMenuResponse` use it, and give the destroy and take items distinct
     menu IDs. Keep `getRadialText` working for every existing role — do not rewrite the
     four roles that already work.
   - After a choice is made (`crystal ~= 0`) -> `nil`.

5. **Extend `handleObjectMenuSelect`** at `:1789-1823` for the new roles and the new menu
   IDs, keeping the existing 8 m range check.

6. **Add the handlers:**
   - `useCrystal(pPlayer)` — full HAM heal per R1, sets `usedCrystal`, plays
     `clienteffect/mustafar/som_force_crystal_buff.cef` on the player
     (`obiwan_crystal_object.java:87`), sends a system message, records the omitted effects
     in a comment above the function.
   - `destroyCrystal(pPlayer)` — sets `crystal = 1`, good badge under R3, plays
     `clienteffect/mustafar/som_force_crystal_destruction.cef`
     (`obiwan_crystal_object.java`), Obi-Wan's congratulation as a system message, records
     the ungranted `item_tow_crystal_uber_05_02` per R2.
   - `takeCrystal_finale(pPlayer)` — **use a name that is not `takeCrystal`**; a
     `takeCrystal` already exists on this screenplay for the conduits at `:1544` and
     shadowing it would silently break the conduit leg. Sets `crystal = 2`, bad badge, plays
     `clienteffect/pl_force_healing.cef` (`obiwan_event_manager.java:422`), Obi-Wan's
     disappointment as a system message, records the ungranted
     `item_tow_cystal_buff_drained_05_01` (SOE's typo, preserved) per R2.
   - `leaveLair(pPlayer, pStone)` — `getRootParent()` then
     `MustafarInstances:sendToExit`.

7. **Amend `bossKilled`** per R6. Do not touch the XP lines.

8. **Extend the `WHERE EVERYTHING IS` / state documentation** so the new data keys
   (`crystal`, `usedCrystal`) are listed alongside `stage`, `hermit`, `spared` and `tries`
   at `:785-789`.

### 6.2 Nothing else.

`serverobjects.lua` already registers every template you need — checked:

- `object/custom_content/tangible/quest/serverobjects.lua:360-361` registers
  `som_kenobi_final_crystal_pedestal` and `som_kenobi_final_force_crystal`.
- `object/custom_content/tangible/dungeon/mustafar/obiwan_finale/serverobjects.lua`
  registers `obiwan_finale_buff_crystal` and `obiwan_finale_exit_stone`.

Do not add, edit or reorder any `serverobjects.lua`.

---

## 7. HOW TO WRITE IT

Match the surrounding file exactly: tabs, `local pX = ...` naming, `printLuaError` for every
failure that would otherwise be silent, a `--[[ ]]` block above each new section explaining
what it is and citing the source line. Prose in this file is plain English written for a
reader, not a changelog. Say what a thing is, then the evidence for it.

Do not add a summary comment at the top of the file about this round. Findings go where the
finding belongs.

When you are done, print the list of functions you added or changed and nothing else.
