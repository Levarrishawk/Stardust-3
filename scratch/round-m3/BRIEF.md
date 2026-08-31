# Round M3 — Mustafar runtime defects

Repo root: `C:\stardust-3-space-port\server`. Branch `mustafar-content`.

You are the coder seat. Four fixes, all proven by the orchestrator firsthand. Make exactly
these four changes and nothing else.

## Governing rules — these override any instinct to improve things

- **Live-faithful. Invent nothing.** Do not add, move, or guess a coordinate, an NPC name, a
  display string, or a piece of dialogue. If a fix seems to need one, STOP and report it
  instead of writing it.
- **Lua only. Additive where possible.** Never touch C++, `.tre`, `snapshot/*.ws`, `conf/`,
  `quests.iff`, or `quest_manager.lua`.
- **Do not commit. Do not `git push`. Do not add a remote.** Leave the tree dirty.
- **Do not delete any file.**
- The tree already contains prior uncommitted work (Rounds M1 and M2) across
  `screenplays/mustafar/**`, `mobile/**` and `conf/config.lua`. Leave all of it alone.
- If you disagree with a fix, implement it as written and say so in your report. Do not
  substitute your own design.

---

## F1 — `MMOCoreORB/bin/scripts/managers/object/object_manager.lua`

**The defect.** The file defines the global wrapper constructors (`Object`, `SceneObject`,
`CreatureObject`, `AiAgent`, …) and then **ends without a `return`**. It is 317 lines and its
last statement is a function `end`. It defines **no `ObjectManager` table anywhere**, and no
file in `bin/scripts` defines `withCreatureObject`.

264 files do `local ObjectManager = require("managers.object.object_manager")`. Because the
module returns nothing, every one of them binds `ObjectManager` to the boolean `true`.

262 of those files never call a method on it, so they are unaffected. **Two do**, and both are
broken at runtime with "attempt to index a boolean value":

- `screenplays/mustafar/boundaries/mustafar_boundaries.lua` — **47** call sites
- `screenplays/cities/hutta_bilbousa_city.lua` — **1** call site

Impact: every Mustafar world-boundary teleport handler throws, so nothing pushes a player back
inside the playable area.

`ObjectManager.withCreatureObject` is the **only** `ObjectManager.*` API used anywhere in the
repo — verified by `grep -rhon "ObjectManager\.[A-Za-z_]*"`, which returns exactly 48 hits and
all 48 are `withCreatureObject`.

**The fix.** Append to the end of `object_manager.lua`, additively — do not modify any existing
line:

```lua
-- Restored: the wrapper constructors above are consumed as globals by every file that
-- requires this module, but the module returned nothing, so `local ObjectManager =
-- require(...)` bound the boolean `true` and every ObjectManager.* call threw. Only
-- withCreatureObject is used in this repo (48 call sites).
ObjectManager = {}

function ObjectManager.withCreatureObject(pCreatureObject, performImplementation)
	if (pCreatureObject == nil) then
		return nil
	end

	return performImplementation(CreatureObject(pCreatureObject))
end

return ObjectManager
```

Notes you must respect:
- `ObjectManager` is a **global** here, matching how `Object` and the constructors are declared
  in this same file. Do not make it `local`.
- Use the pooled `CreatureObject(...)` constructor already defined at line 170. Do not use
  `LuaCreatureObject(...)` directly.
- Adding the `return` is safe for the other 262 requirers: they currently bind `true` and never
  read it, and they will now bind a table and still never read it.
- Do NOT edit `mustafar_boundaries.lua` or `hutta_bilbousa_city.lua`. This one change repairs
  both.

---

## F2 — `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/cursed_shard.lua`

**The defect — an unrecoverable player strand.**

`notifyEnteredArea` sets the area's persistent flag at `:447`, *then* schedules the ambush on a
5–20 s delay at `:452`:

```lua
	self:setFlag(pPlayer, event.key)
	self:showMessageBox(pPlayer, event.title, event.text)
	createEvent(getRandomNumber(event.delayMin, event.delayMax) * 1000, "cursedShardScreenPlay", "springAmbush", pPlayer, event.key)
```

`springAmbush` bails out at the top if the player is gone (`:460-462`), and the brood gate is
the **last thing in that same function** (`:486-488`):

```lua
	if (self:hasFlag(pPlayer, "event1") and self:hasFlag(pPlayer, "event2") and self:rawStage(pPlayer) == self.STAGE_SHARD) then
		self:startBrood(pPlayer)
	end
```

`isPresent` (`:403-411`) is false when the player is offline **or** off Mustafar.

Verified: `startBrood` has exactly **one** call site in the file — line `:487` — and the file
contains **no** `LOGGEDIN` observer and no resume hook. So a player who logs out or zones off
Mustafar during the delay on the **second** area keeps both flags set, never reaches
`startBrood`, and no other code path can advance him out of `STAGE_SHARD`. Hard strand,
unrecoverable without a GM.

**The fix — a catch-up, matching this repo's own established idiom.** Sibling files already do
exactly this: `hidden_treasure.lua:205-220` rolls an orphaned stage back inside `getStage`, and
`reunite_shard.lua` gives `getStage` a catch-up side effect.

Add a catch-up so the brood can still start when the player comes back:

1. Add a single guard so the brood cannot start twice. Use the file's **persistent** screenplay
   data (the same `setFlag`/`hasFlag` mechanism the events already use) — e.g. a flag key
   `"brood"`. Set it inside `startBrood` before it spawns, and make `startBrood` return
   immediately if it is already set. Read `startBrood` at `:513` first and keep its existing
   behaviour otherwise.
2. Extract the existing `:486-488` gate into a small method, e.g.
   `cursedShardScreenPlay:checkBroodGate(pPlayer)`, containing the identical condition plus the
   new not-already-started check. Call it from where `:486-488` is now.
3. Call that same method on the player's way back in, so the missed gate is picked up. The
   natural place is the area handler `notifyEnteredArea` — call it once at the top, before the
   `:443` early-return, guarded so it only runs when the player is present.

Constraints:
- Do NOT change the ambush delay, the flags' names, the message text, or `spawnAmbusher`.
- The brood must still require **both** `event1` and `event2` and `STAGE_SHARD`, exactly as now.
- The brood must never start twice for one player.

---

## F3 — `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/samaritan.lua`

**The defect — a timer stack that disarms the fight it belongs to.**

`giveCrystal` (`:539`) is deliberately re-callable; its own comment at `:536-538` says re-hailing
Pwwoz while he is possessed lands here again and "the second call only re-aggros". But
`:563-568` run unconditionally on **every** call, including the `STAGE_POSSESSED` path:

```lua
	TangibleObject(pNpc):setPvpStatusBit(AGGRESSIVE)
	AiAgent(pNpc):setDefender(pPlayer)
	createEvent(self.calmSeconds * 1000, "samaritanScreenPlay", "calmQuestGiver", pNpc, "")
```

So N hails arm N `calmQuestGiver` events on the same shared world NPC. The earliest one fires
mid-fight and runs `:576-578` — clears `AGGRESSIVE`, broadcasts, and `clearCombatState(true)` —
on an NPC the player is still fighting.

**The fix.** Make `calmQuestGiver` refuse to disarm an NPC that is currently fighting:

```lua
function samaritanScreenPlay:calmQuestGiver(pNpc)
	if (pNpc == nil or CreatureObject(pNpc):isDead()) then
		return
	end

	-- Hailing Pwwoz again re-arms this timer, so an earlier arm can land in the middle
	-- of the fight it was meant to clean up after. Leave a live fight alone; a later
	-- arm, or his respawn, still clears the bit.
	if (AiAgent(pNpc):isInCombat()) then
		return
	end

	TangibleObject(pNpc):clearPvpStatusBit(AGGRESSIVE)
	...unchanged...
end
```

`AiAgent(p):isInCombat()` is an existing binding used by shipped stock screenplays —
`screenplays/cities/city.lua:265` and `screenplays/crackdown/cantina.lua:304,566`.

Constraints:
- Do NOT change `giveCrystal`, `calmSeconds`, the aggro lines, or the system message.
- Do NOT try to cancel the queued events; there is no cancel primitive here.

---

## F4 — `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/mining_field_markers.lua`

**The defect — a once-per-player guard that does not survive a restart.**

`grantCompletionReward` (`:558`) guards itself with `readData`/`writeData` at `:561` and `:565`:

```lua
	if (readData(playerID .. ":miningFieldMarkers:rewarded") == 1) then
		return
	end

	writeData(playerID .. ":miningFieldMarkers:rewarded", 1)
```

`screenplays/screenplay.lua:5` and `:21` route `writeData`/`readData` to
`writeSharedMemory`/`readSharedMemory` — `DirectorSharedMemory`, which is in-memory and lost on
restart. The comment at `:556-557` claims "once and only once per player", which is false across
a restart.

Its own siblings use the persistent store for exactly this: `samaritan.lua:617` and
`moral_choice.lua:577` use `writeScreenPlayData`.

**The fix.** Convert this one guard to the persistent store, matching the siblings:

```lua
	if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "rewarded")) == 1) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "rewarded", 1)
```

Constraints:
- `readScreenPlayData` returns `""` for an unwritten key, so the `tonumber(...)` wrapper is
  required — `tonumber("")` is `nil`, which correctly compares false against `1`.
- Change ONLY this guard. Leave every other `readData`/`writeData` in this file alone — the
  node-id→role tables are per-boot on purpose.
- Do NOT touch `:411` (the `surveyor_jo` spawn). Its coordinate is a known open question and is
  deliberately out of scope for this round.
- Update the `:556-557` comment so it stops claiming something that was not true.

---

## Done means

- Exactly four files changed: `managers/object/object_manager.lua`,
  `screenplays/mustafar/quest/cursed_shard.lua`,
  `screenplays/mustafar/quest/samaritan.lua`,
  `screenplays/mustafar/quest/mining_field_markers.lua`.
- No other file created, modified, deleted, or committed.
- All four parse under `luac5.3 -p`.

## Report

Write `scratch/round-m3/grok-report.txt` containing, for each fix: the file, the line range you
changed, and the final text of the changed region. Then list anything you were asked to do that
you could not do, and anything you noticed but were fenced off from. Be blunt about both.
