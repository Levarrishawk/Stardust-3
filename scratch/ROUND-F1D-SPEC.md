# ROUND F1(d) — the demolition-pack player tool

You are writing Lua for the Core3 SWG emulator (Stardust-3 fork). Follow this spec
exactly. Do not commit. Do not run git.

Round F1(c) shipped the Valley Battlefield and deliberately left one thing out, and
said so in its own header:

> Demo-pack radial (pick up / plant charge / detonator) is round F1(d), not built
> here. The two packs still place as props at stage 1; they have no radial yet.

This round builds it.

Everything below marked LIVE is transcribed from SOE source I have already read in
full. Everything marked SUBSTITUTION is a place where Core3 has no equivalent and I
have already decided the answer and proved it. **Do not re-decide a SUBSTITUTION and
do not invent a rule that is not written here.** If something is genuinely missing,
leave a comment saying so — do not fill the gap with a guess.

---

## 1. Files

### 1.1 NEW — `MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/demolition_pack.lua`

Holds all three live scripts (`demolition_generator`, `demolition_detonator`,
`demolition_pack`) as one Lua screenplay plus two menu components. Live split them
across three files because each was attached to a different object; in Core3 they are
one screenplay with two `ObjectMenuComponent` tables, which is how this repo already
does multi-object radials (see `corvetteMenuComponents.lua`).

### 1.2 EDIT — `MMOCoreORB/bin/scripts/screenplays/screenplays.lua`

Add, immediately after the existing `battlefields/valley_battlefield.lua` line:

```lua
includeFile("mustafar/battlefields/demolition_pack.lua")
```

Order matters: `valley_battlefield.lua` first, this second.

### 1.3 EDIT — `MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/valley_battlefield.lua`

Four small changes, listed in §6. Nothing else in that file may change.

**No object templates are needed.** All five already exist and are already registered:
`demo_pack.iff`, `demo_charge_light.iff`, `demo_charge_medium.iff`,
`demo_charge_heavy.iff`, `demo_detonator.iff` — all under
`bin/scripts/object/custom_content/tangible/dungeon/mustafar/valley_battlefield/`,
reached from `allobjects.lua:969`. Do not add, edit or regenerate any file under
`bin/scripts/object/`.

---

## 2. The live behaviour, branch for branch

### 2.1 The pack — `demolition_generator.java` (166 lines, read in full)

The pack has two lives. It starts as a world prop, then becomes an inventory tool.
The discriminator is `hasBeenPickedUp`, live lines 66-73:

```java
public boolean hasBeenPickedUp(obj_id self) {
    if (utils.hasScriptVar(self, "inWorld")) { return false; }
    return true;
}
```

So: the `inWorld` flag present means NOT picked up. The flag is set by the spawn row,
not by the script — `valley_event_data.tab` rows 11-12 carry
`scriptVar "boolean:inWorld=true,int:currentMineCount=6"`.

**Radial** (`OnObjectMenuRequest`, :19-32):
- `verifyLocationBasedDestructionAnchor(self, 500)` fails → `SCRIPT_OVERRIDE`, i.e.
  no menu at all.
- not picked up → one root item, `ITEM_USE`, text `PICK_UP`.
- picked up → one root item, `ITEM_USE`, text `PLACE_CHARGE`.

**Select** (`OnObjectMenuSelect`, :33-45):
- not picked up → `regenerateInPlayerInventory(player, self)`. Note live does NOT
  check the item id on this branch.
- picked up and item == `ITEM_USE` → `placeDetonationCharge(player)`.

**regenerateInPlayerInventory** (:54-65): create a `demo_pack.iff` in the player's
inventory; on failure log and return; anchor it at the player's location with 500;
copy `currentMineCount` off the world pack; destroy the world pack.
The new inventory pack has NO `inWorld` var, which is what flips it to mode two.

**placeDetonationCharge** (:74-85): `createCharge` at `getLocation(player)`; if the
charge id is invalid, log and return; else `generateDetonationDevice`.

**createCharge** (:86-102): row key is `"demolitionCharge_" + getCommandoModifyLevel(player)`;
read `mineTemplate` from that row; `createObject` at the spawn point; strip objvars and
scripts; set `mineType` = the row key; mark it a temp object; attach the pack script.

**getCommandoModifyLevel** (:103-120): count how many of five skills the player has,
0 through 5. See SUBSTITUTION C.

**generateDetonationDevice** (:121-134): create a `demo_detonator.iff` in the player's
inventory; on failure log and return **without touching the mine count**; attach the
detonator script; set its `chargeId` to the charge; anchor it at the player's location
with 500; then `decrimentMineCount` on the pack.

**decrimentMineCount** (:146-158): current − 1; if `<= 0`, destroy the pack and return
−1; else store and return the new count.

Two live orderings you must keep exactly:
- the charge is created BEFORE the detonator, and live does **not** roll the charge back
  if the detonator fails. A failed detonator leaves a live charge in the world that
  nobody can trigger. That is live's behaviour. Keep it and comment it.
- the mine count is decremented LAST, from inside `generateDetonationDevice`, so a
  failed detonator also does not consume a mine.

### 2.2 The detonator — `demolition_detonator.java` (92 lines, read in full)

**Radial** (:19-28): anchor check first, `SCRIPT_OVERRIDE` on failure. Then one root
item `ITEM_USE` / `DETONATE`, and one submenu under it, `ITEM_USE_OTHER` / `PAGE`.

**Select** (:29-40): `ITEM_USE` → `detonateCharge`; `ITEM_USE_OTHER` → `pageDetonationCharge`.

**detonateCharge** (:49-67): no `chargeId` → log, destroy the detonator, return. Invalid
charge → log, destroy the detonator, return. Otherwise message the charge to detonate
**and destroy the detonator**.

**pageDetonationCharge** (:68-84): identical guards (both destroy the detonator), but on
success it messages the charge to page and **does NOT destroy the detonator**. That
asymmetry is deliberate — page is free, detonate is one-shot.

### 2.3 The charge — `demolition_pack.java` (170 lines, read in full)

The charge carries no radial. It only receives two messages.

**verifyMine** (:43-59), run on attach: no `mineType` var → destroy self. `mineType` not
present in the datatable → destroy self.

**getTargetsInBlastRadius** (:60-96): `getObjectsInRange(loc, blastRadius)`, keep those
that are a player or a mob AND not incapacitated AND not dead. Empty → null.

**applyChargeEffects** (:97-126):
1. read `minDamage`, `maxDamage`, `damageType`, `effectOnExplode` off the row.
2. bad damage type → log, destroy the charge, return.
3. targets empty → **still play the effect**, destroy the charge, return.
4. otherwise play the effect, then for EACH target roll `rand(minDamage, maxDamage)`
   fresh and apply it, then destroy the charge.

Point 3 and the fresh per-target roll in point 4 are both load-bearing. Do not hoist the
roll out of the loop.

**pageCharge** (:38-42): `showFlyText(getSelf(), SHOW_PAGE_TEXT, 1.0f, colors.GREEN)`.

---

## 3. The datatable — `datatables/combat/npc_landmines.tab`, rows 10-15

Transcribed verbatim. Columns: `mineType mineTemplate detonateRange blastRadius
minDamage maxDamage damageType effectOnExplode`. Template paths are all prefixed
`object/tangible/dungeon/mustafar/valley_battlefield/`.

| tier | template | blastRadius | minDamage | maxDamage | effectOnExplode |
|---|---|---|---|---|---|
| 0 | demo_charge_light.iff  | 8  | 1445 | 1605 | clienteffect/exp_ap_landmine.cef |
| 1 | demo_charge_light.iff  | 9  | 1825 | 2055 | clienteffect/exp_ap_landmine.cef |
| 2 | demo_charge_medium.iff | 10 | 2344 | 2505 | clienteffect/combat_grenade_proton.cef |
| 3 | demo_charge_medium.iff | 12 | 2948 | 3200 | clienteffect/combat_grenade_proton.cef |
| 4 | demo_charge_medium.iff | 14 | 3350 | 3605 | clienteffect/combat_grenade_proton.cef |
| 5 | demo_charge_heavy.iff  | 18 | 4200 | 5000 | clienteffect/combat_grenade_thermal_detonator.cef |

`detonateRange` is 1 on every row and is a proximity-trigger field for NPC landmines.
These charges are command-detonated, so live never reads it. Do not port it; say so in
one comment.

`damageType` is `heat` on every row. See SUBSTITUTION A.

Encode this as a Lua array indexed 0..5, or a table keyed by tier — your choice, but
every number above must appear verbatim.

---

## 4. Substitutions — DECIDED, do not re-decide

### SUBSTITUTION A — damage type is dropped

Live: `damage(target, DAMAGE_ELEMENTAL_HEAT, HIT_LOCATION_BODY, damageToApply)`.

Core3 Lua has `CreatureObject:inflictDamage(attacker, damageType, damage, destroy)`,
and its `damageType` is **a HAM pool index, not an elemental type**. Proof, read
directly:

- `CreatureObjectImplementation.cpp:1194` — `if (damageType < 0 || damageType >= hamList.size())`
  then `error("incorrect damage type in CreatureObjectImplementation::inflictDamage")`
- `CreatureObjectImplementation.cpp:1231` — `int maxHam = maxHamList.get(damageType);`
- every existing call site in this repo passes `0`.

So heat typing and hit location cannot be reproduced. Pass `0` (health pool).
Write this out in a comment as a named substitution — it is not a silent drop.

The attacker argument: pass the player who detonated it, so the damage attributes and
threat lands correctly. Live's `damage()` has no attacker argument at all, so this is
the closest available shape.

### SUBSTITUTION B — target search is the tracked set, not a world query

Live: `getObjectsInRange(loc, blastRadius)`.

Core3 Lua has **no world range query**. I enumerated every global function
`DirectorManager.cpp` registers (117 of them) and there is nothing of the kind.

Substitute: iterate `ValleyBattlefield`'s own tracked object ids — `track.army`,
`track.allies` and `track.players` — and range-check each with
`SceneObject(pCharge):isInRangeWithObject(pTarget, blastRadius)`, keeping those that are
alive and not incapacitated. Inside the arena this is the same set live would find,
because the arena spawns and tracks everything in it.

Two consequences to write into the comment:
- a charge detonated with no active session hits nobody (it still plays the effect and
  still destroys itself, matching live's empty-targets branch).
- world objects the arena did not spawn are not hit. Nothing else is in the arena.

Get the tracked set through a new accessor on ValleyBattlefield (§6.4) — do not reach
into `ValleyBattlefield.tracked` from the demolition file.

### SUBSTITUTION C — the commando ladder is re-keyed onto the pre-CU tree

Live counts five skills, in order:
`class_commando_phase1_novice`, `class_commando_phase2_novice`,
`class_commando_phase3_novice`, `class_commando_phase4_novice`,
`class_commando_phase4_master` → level 0..5.

**None of those five exist in this tree.** I grepped `src/` and `bin/scripts/` for
`combat_commando*` and `class_commando*`: the only commando boxes present are the
pre-CU ones —

```
combat_commando_novice
combat_commando_thrownweapon_01 .. _04
combat_commando_heavyweapon_accuracy_01 .. _04
combat_commando_heavyweapon_speed_01 .. _04
combat_commando_support_01 .. _04
combat_commando_master
```

Re-key onto the thrown-weapon line, which is the pre-CU commando tree's explosives
line, so the ladder still means "a better demolitionist plants a bigger charge":

```
combat_commando_novice           -> +1
combat_commando_thrownweapon_01  -> +1
combat_commando_thrownweapon_02  -> +1
combat_commando_thrownweapon_03  -> +1
combat_commando_thrownweapon_04  -> +1
```

counted the same way live counts, plus: `combat_commando_master` forces 5.

Same shape as live — five checks, 0 for a non-commando, 5 for a master. A non-commando
still gets tier 0 and can still use the pack; live is the same.

Write the substitution out in the comment including the fact that the live skill names
do not exist here, so nobody later "fixes" it back to the NGE names.

### SUBSTITUTION D — the 500 m anchor

Live: `utils.verifyLocationBasedDestructionAnchor(obj, loc, 500)` sets an anchor at
creation, and `verifyLocationBasedDestructionAnchor(self, 500)` re-checks it on every
radial request; a fail suppresses the whole menu.

No Core3 equivalent. Substitute at the same trigger point: on the radial request, if the
player is more than 500 m from the arena anchor, destroy the object and return an empty
menu. Anchor is `ValleyBattlefield.anchorX, ValleyBattlefield.anchorY` (600, −1600).
Use `ValleyBattlefield:isNearArena(pPlayer, 500)` (§6.4), not a hand-rolled distance.

### SUBSTITUTION E — the radial is runtime-set, not script-attached

Live `attachScript`s at runtime and it persists. Core3's equivalent is
`SceneObject(pObj):setObjectMenuComponent("Name")`, which resolves through
`SceneObjectImplementation.cpp:496-517` and falls through to `LuaObjectMenuComponent`
when no C++ component of that name is registered. That is what every screenplay in this
repo does — `glyph_hunt.lua`, `corellianCorvette.lua`, `deathWatchBunker.lua`,
`geoLab.lua`, `warren.lua`, 20+ call sites, zero template-level ones.

Consequence: the radial is runtime-only and does not survive a server restart. That is
acceptable here **only because** the arena destroys all demo gear on reset (§6.3), so a
pack or detonator can never be stranded without its radial. Write that reasoning into
the comment — it is the load-bearing half.

**A menu component set this way REPLACES the object's menu entirely.** Whatever you want
on the object, you must add. Do not assume anything is inherited.

### SUBSTITUTION F — playClientEffectLoc has no scale argument

Live passes `0.4f` as a fourth argument. Core3's signature is
`playClientEffectLoc(pObj, effect, zone, x, z, y, cell)` — seven arguments, no scale.
Dropped. One comment, no more.

---

## 5. The new file — what to write

Header comment first, covering: what this is, which three live files it ports, and every
substitution A–F in the same plain terms as the spec. Match the tone of the existing
`valley_battlefield.lua` header — plain sentences, evidence beside each claim, no
bullet-point sales pitch.

Then, in this order:

### 5.1 `DemolitionPack` screenplay table

```lua
DemolitionPack = ScreenPlay:new {
    numberOfActs = 1,
    screenplayName = "DemolitionPack",

    packTemplate    = "object/tangible/dungeon/mustafar/valley_battlefield/demo_pack.iff",
    detTemplate     = "object/tangible/dungeon/mustafar/valley_battlefield/demo_detonator.iff",

    anchorRange = 500,     -- SUBSTITUTION D
    useRange    = 8,       -- see 5.6
    startingMines = 6,     -- valley_event_data.tab rows 11-12, scriptVar currentMineCount=6
}

registerScreenPlay("DemolitionPack", true)
```

`start()` may be empty (or absent) — there is nothing to boot.

### 5.2 The tier table

From §3, verbatim, with a comment naming the source file and rows.

### 5.3 State

Core3 Lua has no scriptvars. The repo's idiom is `writeData(objectID .. ":key", value)`
(see `corvetteMenuComponents.lua:153`, `readData(computerID .. ":spawnedEnemies")`).
Use exactly these keys, and no others:

| key | on | meaning |
|---|---|---|
| `<oid>:demoInWorld` | pack | 1 while it is still a world prop; deleted when picked up |
| `<oid>:demoMines`   | pack | mines remaining |
| `<oid>:demoTier`    | charge | 0..5, the row key |
| `<oid>:demoCharge`  | detonator | the charge's object id |
| `<oid>:demoSession` | all three | the arena session that created it |

Every key must be deleted when its object is destroyed. Write one helper,
`DemolitionPack:clearKeys(oid)`, and call it from every destroy path. A leaked key is a
real bug here: object ids are reused.

### 5.4 `SomDemoPackMenuComponent`

```lua
SomDemoPackMenuComponent = {}

function SomDemoPackMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
```
- nil-guard all three.
- anchor check (SUBSTITUTION D); fail → destroy the pack, add nothing, return.
- `readData(oid .. ":demoInWorld") == 1` → add `(20, 3, "@mustafar/valley_battlefield:pick_up_demo_pack")`
- else → add `(20, 3, "@npc_landmines:place_charge")`

```lua
function SomDemoPackMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
```
- guards, `selectedID ~= 20` → return 0.
- in-world branch → `useRange` proximity check, then `DemolitionPack:pickUp(pSceneObject, pPlayer)`.
- inventory branch → `DemolitionPack:placeCharge(pSceneObject, pPlayer)`.
- always `return 0`.

The `20` is `RadialOptions.h` `ITEM_USE`, and the `3` is the callback value every
existing Lua menu component in this repo passes. Comment both once.

### 5.5 `SomDemoDetonatorMenuComponent`

`fillObjectMenuResponse`: anchor check, then

```lua
LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@npc_landmines:detonate_charge")
LuaObjectMenuResponse(pMenuResponse):addRadialMenuItemToRadialID(20, 22, 3, "@npc_landmines:page_charge")
```

`22` is `ITEM_USE_OTHER`, which is what live's submenu uses. Signature is
`addRadialMenuItemToRadialID(parentRadialID, newRadialID, callback, text)` —
`LuaObjectMenuResponse.cpp:43-52`.

`handleObjectMenuSelect`: `20` → `DemolitionPack:detonate(...)`, `22` →
`DemolitionPack:page(...)`, anything else → return 0.

### 5.6 The functions

**`DemolitionPack:pickUp(pPack, pPlayer)`** — live `regenerateInPlayerInventory`.
Read the mine count off the world pack. `giveItem(pInventory, self.packTemplate, -1, true)`
— four args, the fourth is overload, matching live's
`createObjectInInventoryAllowOverload`. On nil, `printLuaError` and return with the world
pack untouched. On success: set `demoMines` and `demoSession` on the new pack, set its
menu component, register it with the arena, then clear the world pack's keys and destroy
it. Do NOT set `demoInWorld` on the inventory copy — its absence is the mode flag.

`useRange = 8` is a port constant, not a live number — live has no proximity check on
the pick-up because SOE's radial system enforces use range itself and Core3's does not
for a Lua component. 8 m matches the `glyph_hunt.lua` house pattern. Say so in one
comment.

**`DemolitionPack:placeCharge(pPack, pPlayer)`** — live `placeDetonationCharge` +
`createCharge` + `generateDetonationDevice`, in live's order:
1. tier = `self:commandoLevel(pPlayer)`; row = the tier table entry.
2. spawn the charge at the player's world position via `spawnSceneObject("mustafar",
   row.template, x, z, y, 0, 1, 0, 0, 0)`. Player position is
   `getWorldPositionX/Z/Y`; note the repo's argument order is `x, z(height), y`, the
   same convention `valley_battlefield.lua` documents in its header. Identity quaternion
   — live does not orient the charge.
3. charge nil → `printLuaError`, return, mine count untouched.
4. set `demoTier` and `demoSession` on the charge; register it with the arena.
5. `giveItem` the detonator. nil → `printLuaError` and return **leaving the charge in
   the world and the mine count untouched** — live's own behaviour, comment it as such.
6. set `demoCharge` and `demoSession` on the detonator, set its menu component, register
   it with the arena.
7. `self:decrementMines(pPack)`.

**`DemolitionPack:decrementMines(pPack)`** — live `decrimentMineCount`: current − 1; at
`<= 0` clear keys and destroy the pack; else write the new count.

**`DemolitionPack:commandoLevel(pPlayer)`** — SUBSTITUTION C.

**`DemolitionPack:detonate(pDetonator, pPlayer)`** — live `detonateCharge`: no
`demoCharge` key, or `getSceneObject` on it returns nil → clear keys, destroy the
detonator, return. Otherwise blast, then clear keys and destroy the detonator.

**`DemolitionPack:page(pDetonator, pPlayer)`** — live `pageDetonationCharge`: same two
guards, same destroy-the-detonator on failure; on success
`SceneObject(pCharge):showFlyText("npc_landmines", "charge_page_text", 0, 255, 0)` and
leave the detonator alone.

`showFlyText(file, key, r, g, b)` — `LuaSceneObject.cpp`. The file is bare
`"npc_landmines"` with no `@`, matching `warren.lua:489`. Green is live's
`colors.GREEN`.

`charge_page_text` renders as `-- PING --` (confirmed in the extract's string table;
`string/en/npc_landmines.stf` ships in `mtg_patch_019.tre`, which `conf/config.lua:176`
loads). All five strings this file uses were confirmed present the same way — one
comment covering all five is enough.

**`DemolitionPack:blast(pCharge, pPlayer)`** — live `applyChargeEffects`:
1. tier off `demoTier`; unknown tier → clear keys, destroy the charge, return. That is
   live's `verifyMine` guard, moved to the point of use because Core3 has no OnAttach.
   Comment that relocation.
2. gather targets (SUBSTITUTION B).
3. `playClientEffectLoc(pCharge, row.effect, "mustafar", x, z, y, 0)` — plays whether or
   not there are targets.
4. per target, `getRandomNumber(row.minDamage, row.maxDamage)` rolled fresh, then
   `CreatureObject(pTarget):inflictDamage(pPlayer, 0, dmg, false)`. `destroy` is false —
   live's `damage()` does not force a kill, it lets the normal death path run.
5. clear keys and destroy the charge.

---

## 6. Edits to `valley_battlefield.lua`

Exactly four. Keep them minimal — this file is already committed and reviewed.

**6.1** In `stage1Props`, add `isDemoPack = true` to the two existing `demo_pack.iff`
rows (currently lines 280-281). Change nothing else about those rows.

**6.2** In the `stage1Props` spawn loop (currently around line 711-724), beside the
existing `if (row.isGenerator)` block, add an `elseif (row.isDemoPack)` branch that sets
`demoInWorld = 1`, `demoMines = DemolitionPack.startingMines`, `demoSession = session`,
and the menu component. Guard on `DemolitionPack ~= nil` and `printLuaError` if it is —
same shape as the `ValleyBattlefield == nil` guard already in
`story_arc_chapters.lua:sendToBattlefield`.

**6.3** In `getTrack`, add `demo = {}` to the table. In `resetArena`, add
`self:destroyIDList(track.demo)` beside the three existing calls. Demo objects created
mid-fight land in this list and die with the arena — this is what makes SUBSTITUTION E
safe.

`destroyIDList` currently only calls `destroyObjectFromWorld`. For demo objects that is
enough (they are session-scoped and the world tick reaps them), but their `writeData`
keys would leak. Add a `DemolitionPack:clearKeys(oid)` call inside the demo loop only —
do not change `destroyIDList` itself, since the other three lists must keep their exact
current behaviour.

**6.4** Add two small public accessors near the other helpers, so the demolition file
never reaches into `ValleyBattlefield.tracked` directly:

```lua
-- Returns army ids, ally ids and player ids for the live session, or nil if there
-- is no live session. DemolitionPack:blast uses this in place of a world range
-- query, which Core3 Lua does not have.
function ValleyBattlefield:getBlastCandidates()

-- True if pPlayer is within range metres of the arena anchor. Stands in for live's
-- verifyLocationBasedDestructionAnchor.
function ValleyBattlefield:isNearArena(pPlayer, range)

-- Adds oid to the live session's demo list so resetArena reaps it.
function ValleyBattlefield:trackDemoObject(oid)
```

Three, not two — write all three. `getBlastCandidates` should return one flat array of
object ids; `blast` does the range and liveness filtering.

---

## 7. House rules

- Tabs for indentation, matching every other file in this tree.
- `if (cond) then` with the parens — the repo's style.
- Every function nil-guards its pointer arguments before use.
- Comments explain WHY, and cite the live file and line when the why is "live does it".
  Do not narrate what the next line does.
- Lua 5.3. The gate runs `luac5.3 -p` over the whole tree, so it must parse.
- No `os.date`, no `require`, no globals beyond the ones already used in
  `valley_battlefield.lua`.
- Do not touch: `obi_wan_ghost.lua`, `surveyor_jo.lua`,
  `mobile/custom_content/som/serverobjects.lua`, `jo_kelsev_conv_handler.lua`,
  `conf/config.lua`, or anything under `bin/scripts/object/`.
- Do not commit. Do not run git.
