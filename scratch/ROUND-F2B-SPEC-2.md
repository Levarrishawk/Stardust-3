# ROUND F2(b) PART TWO — events four and five, the HK finale, and the wiring

Instruction file for the coding agent. This is **PART TWO**. Part one
(`ROUND-F2B-SPEC.md`) already created
`MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/volcano_battlefield.lua`
with the geometry, the screenplay table, entry/exit/reset, the six-volume
activation chain, and events one through three.

**Read `ROUND-F2B-SPEC.md` first.** Everything it settles — the anchor, the
transform, the omission list §5A–H, the verified damage primitives §6, and the
house rules §10 — applies here unchanged and is not repeated. In particular:

- **§5H still holds: do not call `setMaxHAM` or `setHAM` anywhere.** Live HP
  numbers below are reference data for the header only.
- **§5A still holds: no buff API exists.** Every buff below is omitted, named,
  and given no stand-in.
- Every `createEvent` callback re-checks `isSessionCurrent(session)` first.

Source of truth for live behaviour: `scratch/LIVE-VOLCANO.md` §2.4, §2.5, §3.2,
§4 and §6. Architectural template: `valley_battlefield.lua`.

---

## 1. EVENT FOUR — the Cyborg Prototype (LIVE-VOLCANO §2.4)

Centre **(-409.949, -1435.469)**, volume radius 45. Boss yaw **195**.

**Spawn at session start:** 1 × `som_volcano_four_cym_prototype` at the centre,
invulnerable. Track as the event's boss. **No guards spawn here.**

Live plants 4 `patrol_waypoint.iff` marker objects and later spawns beetles "at
every marker". Do not spawn marker objects — they exist in live only because its
spawn code reads objvars off world objects. Keep the four offsets as a plain Lua
table on the screenplay and spawn straight onto them:

```
16:-24   -29:-16   -1:11   29:-6
```

Say that in a comment: *live uses `event_5_spawn_point` marker objects
(`event_four.java:51-86`); this port keeps the same four offsets as data because
there is nothing else the markers were for.*

**On trigger:** clear INVULNERABLE on the boss, `setDefender` on the nearest
player within radius 90, then arm three repeating events.

- **`beetleWave`, every 31 s** (`BEETLE_RESPAWN`, `event_four_boss.java:100-137`).
  One `som_volcano_four_lava_beetle` at **each** of the four offsets, random yaw
  (`getRandomNumber(0, 359)`), each `setDefender`ed onto the nearest player
  within 90. Track them in `track.guards`. `broadcastMessage` the summon —
  live's `four_summon_add` string id (`trial.java:152`), quoted in a comment per
  part one §5G.
- **`poisonAE`, every 35 s** (`POISON_RECAST`), radius **200**. For every player
  in range: `addDotState(pAttacker, POISONED, 125, HEALTH, 455, 30, areaOid, 0)`
  — live's own numbers (`strength 125, duration 455, potency 30`), in the
  argument shape part one §6 pinned from `geoLab.lua:556`.
- **`forceDrainAE`, every 22 s** (`FORCE_DRAIN_RECAST`), radius **200**. Live is
  `drainAttributes(target, 1000, 0)`. Port as `inflictDamage(pBoss, 3, 1000,
  false)` **and** `inflictDamage(pBoss, 6, 1000, false)` — pools 3 = ACTION and
  6 = MIND, part one §6. Comment it: live drains two secondary pools by 1000;
  this is the closest honest primitive, and it is damage rather than a drain.

**Live's opening cadence** (`OnEnteredCombat` → `doAEBurst` @4 s, `spawnAdd`
@6 s; `doAEBurst` → poison @1 s, force drain @8 s) sets the *first* fire times.
Use them: first beetle wave at 6 s, first poison at 5 s, first drain at 12 s,
then the recasts above.

**`doDiseaseAE` is defined in live and never scheduled** (`event_four.java`
comment in LIVE-VOLCANO §2.4). **Do not port it.** Say so in the header — a
reader who diffs against the live source must not think it was missed.

**Beetle self-destruct** (`event_four_guard.java`): on a beetle's death, after
5 s, every player within radius **7** takes **2000** damage
(live: `DAMAGE_ELEMENTAL_HEAT`; `inflictDamage` has no element channel, so it
lands as pool 0 — say so). Live plays a warning effect first; the effect is
omitted (§5F), so `broadcastMessage` the warning instead, otherwise the blast is
invisible and unfair. Beetles are `setMovementRun` in live — no Lua binding for
that was found; omit and state it.

**Win:** boss dies → `eventDefeated(session, 4)`.

Live HP reference only: boss 950485 (the highest in the instance), beetle 3000.

---

## 2. EVENT FIVE — the Oppressor Septipod (LIVE-VOLCANO §2.5, §3.2)

Centre **(-306.887, -1466.889)**, volume radius 45. Boss yaw **195**.

**Spawn at session start:** 1 × `som_volcano_five_boss_septipod` at the centre,
invulnerable. Two offset tables on the screenplay, from live's nine markers
(`event_five.java:51-101`, first three → `trioAddSpawn`, rest → `midguardSpawn`):

```
trioSpawns     -19:20   24:23   -4:-32
midguardSpawns -6:-22   -12:-6   -12:6   13:15   17:0   18:9
```

Set `track.deadGuards = 0` for the midguard counter and clear the ladder flags.

**On trigger:** clear INVULNERABLE, `setDefender` nearest within 90, arm
`switchTarget` at **18 s** and `debuffAE` at **30 s**.

**The health ladder** — live reads it in `OnCreatureDamaged`
(`event_five_boss.java:75-106`) at 0.8 / 0.6 / 0.5 / 0.4 / 0.2, each firing
**once**. There is no damage observer in this port, so poll: a `healthLadder`
event every **3 s** computing
`CreatureObject(pBoss):getHAM(0) / CreatureObject(pBoss):getMaxHAM(0)` and
firing any rung not yet flagged. Flags live in the track table
(`spawned80, spawned60, spawned50, spawned40, spawned20`). **Poll fires every
rung that has been crossed, not just the newest** — a big hit can skip two at
once, and live's chained `if` does the same. Comment the substitution.

- **0.8, 0.6, 0.4, 0.2 → `spawnTrioAdd`** (`:218-250`): one
  `som_volcano_five_septipod` at each of the **3** `trioSpawns`, random yaw,
  `setDefender` nearest within 150 (live's acquire radius), tracked in
  `track.guards`. `broadcastMessage` the summon (live `five_summon_trio`).
  Live's guards also strip player buffs every 16 s — omitted, part one §5B.
- **0.5 → the invulnerable midguard phase** (§3.2). Exactly once:
  `setOptionBit(INVULNERABLE)` on the boss, `clearCombatState()`,
  `setOblivious()` (part one §5C), flag it, and schedule the wall **5 s later**.

**The wall:** 6 × `som_volcano_five_midguard` at the six `midguardSpawns`,
random yaw, `setDefender` nearest within 150, tracked separately from
`track.guards` so the gate can count them. `broadcastMessage` the summon (live
`five_summon_midguard`).

**The gate:** all **6** must die. Count them into `track.deadGuards`; at 6,
`resumeAttack` — clear INVULNERABLE, scan radius **200**, `setDefender` on the
closest player. Poll the count on the same 3 s tick rather than an observer.

**Why the phase cannot be skipped:** live's `verifyHealthReset` opens with
`if (isInvulnerable(self)) return;` — while the midguards are up the boss will
not reset. Reproduce that: the out-of-combat reset poll (same shape as event
one's, part one §7) must bail while the boss is invulnerable. A reset clears
**every** ladder flag including `spawned50`, so the midguard phase re-arms.

**Omitted here, name each:** the three rotating debuff pools (ham
`bio_etheric_shock/torpor/vacuity`, debuff `lethargy/wavering/toxic_dissolution`,
skill `obfuscation/confusion/corrosion`, radius 400, recast 30), `distraction`
(recast 24), and `enfeeble` on `switchTarget` — all buffs, part one §5A. Record
the pool names in the header as data.

**`switchTarget` DOES port in its observable half** (part one §5C): every 18 s,
if more than one player is in range, `setDefender` onto a random player that is
not the current defender. Live also applies `enfeeble` and re-weights hate;
neither survives.

**Win:** boss dies → `eventDefeated(session, 5)`.

Live HP reference only: boss 220000 (the *lowest* boss HP — the fight is about
the adds), trio septipod 50000, midguard 100000 each (600000 total, nearly 3×
the boss).

---

## 3. THE HK-47 FINALE (LIVE-VOLCANO §4)

Centre **(-304.941, -1714.941)**, volume radius **95** — the largest in the
instance. HK yaw **25**.

### 3.1 Spawn at session start

1 × `som_volcano_final_hk47` at the centre, invulnerable, tracked as
`track.bossID`.

Live plants 10 markers (`hk_final.java:56-110`) split three ways. Keep them as
three offset tables, same reasoning as event four:

```
hkBeetleSpawns    55:34   9:48   -18:18   23:-30      (4)
hkWalkerSpawns    15:-1   -18:3                       (2)
hkSeptipodSpawns  -2:46   27:33   39:4   -21:28       (4)
```

### 3.2 On trigger — three things at once

`hk_final.java:47-55` fires `spawnSquadLeaders`, `landYt` and `doHkTaunt`
together and then removes the trigger volume. Port:

1. `broadcastMessage` HK's taunt (live `hk_prefight_taunt`) and
   `broadcastMusic(self.hkIntroMusic)`.
2. Build the squad wall (below).
3. The YT landing is **omitted** — see §4.

HK himself stays invulnerable.

### 3.3 The 14-mob squad wall

2 × `som_volcano_final_squadleader` at offsets **`-1:32`** and **`32:25`**,
yaw 25. Each leader then spawns **6** × `som_volcano_final_squadmember` at
offsets *relative to that leader*:

```
-3:0   -5:0   -7:0   -3:3   -5:3   -7:3
```

yaw 25, sentinel behaviour (live `BEHAVIOR_SENTINEL` — they hold until engaged;
do not `setDefender` them at spawn). **2 × (1 + 6) = 14.** Track all fourteen
together and reset `track.deadGuards = 0` and `track.corpseIdx = 0`.

Live's leader death sends `leaderDied` to its six members, which applies
`low_morale`. Omitted (part one §5A) — killing a leader has no effect on its
squad in this port. State it.

**The gate:** every squad death places a corpse (below) and increments
`track.deadGuards`. At **14**, `activateHK`: clear HK's INVULNERABLE after 3 s,
scan radius **90**, `setDefender` on the closest. **All 14 must die before HK is
attackable.** Poll the count on HK's own tick; do not rely on an observer.

**Corpses** (`hk_final.java:163-200`), 14 fixed offsets, template
`som_volcano_final_squadmember`, built per part one §5D (KNOCKEDDOWN +
INVULNERABLE + `setAITemplate("idle")`), tracked in `track.corpses`:

```
7:26   -10:34   0:18   -5:46   10:35   26:32   -18:23
6:39   24:38    18:27  31:19   5:26    11:21   -3:31
```

These corpses are HK's ammunition. Same rule as event three: a corpse is a
**fresh object at a scripted spot**, not the body where the mob fell.

### 3.4 HK's fight

**Opening**, on activation (`hk_final_boss.java:71-77`): `raiseGuard` first at
14 s, `switchTarget` first at 24 s, `damageAE` first at 35 s.

**Recasts** (`:556-561`): `RAISE_RECAST 48`, `SWITCH_RECAST 24`,
`AE_NUKE_RECAST 50`, `POISON_RECAST 40`. Ported: raise, switch, damage AE,
poison AE. Omitted: `DEBUFF_RECAST 45`, `DISTRACTION_RECAST 24` (buffs, §5A),
`DISEASE_RECAST 120` and `FORCE_DRAIN_RECAST 34` (**both defined and never
scheduled in live** — do not port; say so).

**The add ladder** — same 3 s poll as event five, flags `spawned80 / spawned50 /
spawned20`, every crossed rung fires:

| rung | template | offsets | count |
|---|---|---|---|
| 0.8 | `som_volcano_final_lava_beetle` | `hkBeetleSpawns` | 4 |
| 0.5 | `som_volcano_final_septipod` | `hkSeptipodSpawns` | 4 |
| 0.2 | `som_volcano_final_walker` | `hkWalkerSpawns` | 2 |

Random yaw, `setDefender` nearest within 90 after 2 s, tracked in
`track.guards`, each announced with `broadcastMessage`. The 0.5 septipods strip
buffs in live — omitted (§5B).

**The revive** — `raiseGuard` / `performRez` (`:282-315`), every **48 s**. Scan
`track.corpses` within **200** and pick **ONE at random** — *not all*, and this
is the deliberate contrast with event three's index-pairing. Destroy that
corpse, spawn `som_volcano_final_risen_sustainer` at its position with random
yaw, `setDefender` nearest within 90 after 3 s, and track it as a risen guard.
**Each living risen guard heals HK `healDamage(1000, 0)` every 10 s** — arm a
per-guard heal event the same way event one's guards heal the Taskmaster.

**The damage AE** — live's `chooseAEType` returns `{"wave","wave"}`, so **only
the wave is reachable**; `doAirfallBurst` is dead code. Port the wave only and
say why. Re-armed every **50 s**, telegraphed at t+0 and burst at **t+4 s**
(live pre-burst @3 s, burst @7 s), radius **96**:

- current defender: flat **1500** HEALTH damage (live's combat spam shows 400;
  the real number is 1500 — use 1500 and note the discrepancy).
- everyone else: `math.floor(15000 / distance)` plus a fire DOT of `damage / 10`
  for **60**. Clamp distance to a minimum of 1.

**The poison AE** — every **40 s**, radius **200**:
`addDotState(pAttacker, POISONED, 125, HEALTH, 235, 30, areaOid, 0)`.

**`switchTarget`** — every 24 s, the §5C substitution: `setDefender` onto a
random other player in range. Live's `enfeeble` and `removeHateTarget` do not
survive.

**The wipe reset** (`verifyHealthReset`, `:112-133`) — poll the same way event
one does: HK alive, out of combat, no players inside the volume. On reset: full
heal, clear **all three** add flags, destroy every add and every risen guard,
**rebuild the entire 14-mob squad wall from scratch**, clear and re-place the
corpse pool, and set HK back to INVULNERABLE. The group must clear all 14 again.
Unlike event five there is **no `isInvulnerable` guard here** — that asymmetry is
live's and must be preserved.

**Death:** HK dies → `eventDefeated(session, 6)` → `winTrial(session)`.

Live's 15% bonus loot roll on HK's corpse is
`object/building/player/player_mustafar_house_lg.iff` — a **building**, and this
tree has no deed for it, so there is nothing a player could receive. **Omitted,
with no substitution.** State it plainly in the header and contrast it with
event three's loot, which *was* substituted because a real deed of the same
family exists there. Do not invent a house reward.

Live HP reference only: HK 545852, squad leader 20000, squad member 14000, risen
sustainer 22525.

---

## 4. VICTORY AND THE EXIT

`winTrial(session)` mirrors `valley_battlefield.lua:1555-1578` exactly:
guard on `volcanoBattlefield:won`, `broadcastMessage("HK-47 has been
destroyed.")`, `broadcastMusic(self.victoryMusic)`, then for every player inside
— award `self.victoryBadge` through the same guarded
`_G[self.victoryBadge] ~= nil` pattern, and call
`storyArcChaptersScreenPlay:onVolcanoVictory(pPlayer)`. Then arm
`cleanOutTimer` at `self.cleanOut * 1000`.

**The exit.** Live's exit is a conversation with `som_volcano_autopilot`, who
stands on the bridge of a grounded YT-2400 that only exists after HK dies
(`volcano_event_manager.java:258-276`). None of that can be built here:

- `object/creature/npc/theme_park/must_yt2400.iff` **does not exist in this
  tree** — the landing placeholder cannot be spawned.
- `object/building/mustafar/structures/must_grounded_yt2400.iff` would need
  `spawnBuilding`, and `DirectorManager.cpp:2973-3009` shows that routes to
  `StructureManager::placeStructure` — a **player-owned structure with a
  maintenance pool and structure permissions**. That is the wrong object
  lifecycle for a scripted prop that must vanish on arena reset.
- The autopilot's conversation is `mustafar/volcano_battlefield.stf`, which is
  not in this tree (part one §5G).

So: **on victory, spawn `som_volcano_autopilot` standing on the ground** at
**(-260.400, -1677.800)** — live's own landing site, transformed — track it in
`track.props`, and give it a runtime radial reading "Leave the Volcano" that
calls `VolcanoBattlefield:sendToExit(pPlayer)`.

Use the demolition pack's runtime-radial idiom verbatim in shape
(`demolition_pack.lua:200-240` and `:316`): a `VolcanoAutopilotMenuComponent`
table with `fillObjectMenuResponse` / `handleObjectMenuSelect`, radial id **20**
(`RadialOptions.h ITEM_USE`) with callback value **3**, attached at runtime with
`SceneObject(pPilot):setObjectMenuComponent("VolcanoAutopilotMenuComponent")`.
Guard `selectedID ~= 20`. Note in the comment, as `demolition_pack.lua`
SUBSTITUTION E already does, that a runtime menu **replaces** the object's menu
entirely and does not survive a server restart — which is fine, because the
arena is torn down at cleanout anyway.

The player still leaves via `sendToExit`, which teleports to
**(-2397, 1850)** — SOE's own `exit_one`. Nothing about the destination changes;
only the ship is gone.

Also omitted and stated: the smoke plume, the takeoff, and `yt_controller`'s
`OnInitialize` self-destruct — all consequences of the ship that is not there.

---

## 5. THE WIRING

Three edits, in this order.

### 5.1 `MMOCoreORB/bin/scripts/screenplays/screenplays.lua`

Insert one line **after line 760** (`mustafar/battlefields/demolition_pack.lua`),
keeping the battlefields block together:

```lua
includeFile("mustafar/battlefields/volcano_battlefield.lua")
```

### 5.2 `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/story_arc_chapters.lua`

**(a) `sendOneToVolcano` (`:2213-2221`) hands off to the arena.** Keep the stage
test, the system message and `advance(pPlayer, self.STAGE_KILL_HK47)`. Replace
the `giveWaypoint` call — which pointed at the invented HK-47's ground position —
with the same guarded hand-off `sendToBattlefield` uses at `:2149-2160`:

```lua
	if (VolcanoBattlefield == nil) then
		printLuaError("storyArcChaptersScreenPlay: VolcanoBattlefield is not loaded; refusing volcano entry")
		return
	end

	VolcanoBattlefield:enter(pPlayer)
```

Update the comment above it: the block at `:2187-2193` currently says
`sendGroupToVolcano` "has no repo counterpart". It does now — say so, and name
the file.

**(b) Add the two seam functions**, mirroring `mayEnterValleyBattlefield`
(`:2162-2170`) and `onBattlefieldVictory` (`:2172-2185`):

```lua
function storyArcChaptersScreenPlay:mayEnterVolcanoBattlefield(pPlayer)
	-- stage == STAGE_KILL_HK47
end

function storyArcChaptersScreenPlay:onVolcanoVictory(pPlayer)
	-- stage must be STAGE_KILL_HK47; advance to STAGE_REPORT_SUCCESS
end
```

`onVolcanoVictory` makes the same transition the killed-creature branch used to:
chapter three 03 task 3 → task 4, `STAGE_KILL_HK47` → `STAGE_REPORT_SUCCESS`.

**(c) Delete the invented HK-47.** Four sites:

1. `:779` — the `hk47 = { template = "hk47", x = -2748, y = 3642, ... }` table
   entry.
2. `:1233-1244` — the whole `spawnHk47()` function and its INVENTED-position
   comment block.
3. `:895` — the `self:spawnHk47()` call inside `start()`.
4. `:2284-2286` — the `elseif (stage == self.STAGE_KILL_HK47 and template ==
   self.hk47.template)` branch of `notifyKilledCreature`. The advance now comes
   from `onVolcanoVictory`.

**Replace them with a comment in the shape of the precedent already written at
`:652-656`**, which is how F1(c) recorded deleting the invented droidArmy
roster. Same voice, same structure:

```lua
	-- The invented HK-47 spawn lived here. There was no live position for him --
	-- chapter three 03 carries no coordinates at all, because live fights him in
	-- the mustafar_volcano ZONE, and Core3 has no such zone. Round F2(b)
	-- replaced the stand-in with the real encounter (screenplays/mustafar/
	-- battlefields/volcano_battlefield.lua); the entry, spawnHk47 and the
	-- kill-counter branch are gone.
```

**Then fix the file's own DEVIATION block at `:295-311`**, which still says
"HK-47 is stood on the open terrain instead". That is no longer true. Rewrite
those two paragraphs to say what is now true: the chapter carries no coordinates
because it happens in a separate zone; this port answers that with an off-map
arena at (-292, -1680) entered by teleport from the pilot's conversation, the
same model the valley uses. Do not delete the history of the wrong call — amend
it forward.

**(d) `hk47Betrayal` / `hk47Farewell` message boxes, `hologramTemplate`,
`SIGNAL_FINAL_GOODBYE`, and the `taskText` entries stay untouched.** They are
quest text, not the invented spawn. Only the four sites listed in (c) go.

---

## 6. FENCED — do not touch

- `MMOCoreORB/bin/conf/config.lua`
- `obi_wan_ghost.lua`, `surveyor_jo.lua`, `jo_kelsev_conv_handler.lua`
- `mobile/custom_content/som/serverobjects.lua`

---

## 7. HOUSE RULES

All of part one §10 applies unchanged. Restated because they matter most here:

- Every `createEvent` callback takes `(pObj, args)` with `args = tostring(session)`
  and returns silently if `isSessionCurrent(session)` fails.
- Nil-check every spawn return and every `getPlayersInRange` return.
- Never index a tracked object without `getSceneObject(oid) ~= nil` and
  `not CreatureObject(p):isDead()`.
- Lua 5.3, tabs, no trailing whitespace, must pass `luac5.3 -p`.
- Comment voice: what live does with its file:line, what this file does, why they
  differ. No cheerful comments. Claim nothing you did not verify.
- **Do not run git. Do not commit.**
