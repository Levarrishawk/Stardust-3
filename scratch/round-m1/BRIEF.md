# ROUND M1 — place the four Mustafar quest givers

You are the coder seat. Repo root is `C:\stardust-3-space-port\server`, branch
`mustafar-content`. Everything below was verified firsthand by the orchestrator against the
shipped bytes. Do not re-derive it and do not "improve" it.

---

## HARD FENCES — read these first

- **Lua only, additive only.** Never edit C++, `.tre`, or `snapshot/*.ws`. You may READ them.
- **Never delete a file.** Never `git commit`, never `git push`, never add a remote.
- **Never repoint an existing `conversationTemplate`.** All four are already correct.
- **Never touch** the elysium / World Beyond Worlds content, `obi_wan_elysium`, `obi_wan_ghost`.
- **Invent nothing.** Every number below is sourced. Do not add mood strings, patrol paths,
  faction, level overrides, loot, or dialogue. If something seems missing, leave it missing and
  say so in your report.
- Touch **only** these four files:
  - `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/jenha_tar_cube.lua`
  - `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/glyph_hunt.lua`
  - `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/blackguard_problem.lua`
  - `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/storm_lord.lua`

---

## Background — what changed and why this round exists

These four quests are fully ported and fully wired. Each has a reconstructed conversation tree
(`mobile/conversations/mustafar/som_*.lua`), a handler
(`screenplays/mustafar/quest/conversation/*_conv_handler.lua`), both registered, and a giver
creature whose `conversationTemplate` points at the tree. Verified:

```
mobile/custom_content/som/doc_lu.lua:40           conversationTemplate = "som_doctor_lu"
mobile/custom_content/som/naboo_historian.lua:37  conversationTemplate = "som_glyph_hunt"
mobile/custom_content/som/npc_ithes_olok.lua:37   conversationTemplate = "som_cube_ithes_olok"
mobile/custom_content/som/reporter_jural.lua:37   conversationTemplate = "som_storm_lord_jural"
mobile/custom_content/som/reporter_talper.lua:37  conversationTemplate = ""      (no tree ships; correct as-is)
```

**The one missing piece is `spawnMobile`.** None of the four is placed in the world, so none of
the four quests can be started. That is what this round fixes.

The positions were unknown until the **Mustafar coordinate offset** was proven. Our Mustafar is a
pure translation of the live one:

```
shipped_x = way_x - 2880
shipped_z = way_z + 2976
```

No scale, no rotation (scale ratio 1.0000 over a 5 km baseline). It was fixed by two shipped
`.qst` waypoints and then confirmed by converting ten independent community landmarks from a
2 April 2006 live-era walkthrough — each landed on the snapshot object it names, misses from 1.3 m
to 65 m. That is why the two derived positions below are usable evidence and not guesses.

---

## The in-repo precedent you are copying

`screenplays/mustafar/quest/historian.lua` already does exactly this job on this planet. Match it.

- `historian.lua:282-290` — `start()` guards on `isZoneEnabled("mustafar")` and calls named
  spawn helpers.
- `historian.lua:309-318` — `spawnQuestGiver()`: one `spawnMobile`, **respawn arg `0`**, nil-checked
  with a `print` that names the consequence, object id stashed on self.
- `historian.lua:420-431` — `getWorldFloor(x, y, "mustafar")` called on a `start()`-driven spawn
  path. **This settles boot timing: `getWorldFloor` is safe from `start()` on Mustafar.**
- `historian.lua:352-360` — cells resolved by **name** via
  `BuildingObject(pBuilding):getNamedCell(name)` → `SceneObject(pCell):getObjectID()`.

Argument order is `spawnMobile(zone, template, respawnSeconds, x, z, y, heading, cellID)` where
`z` is the HEIGHT. Respawn `0` = never respawns, which is what a quest giver wants and what
`historian.lua:311` uses.

---

## THE FOUR PLACEMENTS

### 1. `jenha_tar_cube.lua` — Ithes Olok, INDOORS

Template `npc_ithes_olok`. He is inside the on-map Mensix mining facility.

Verified from `snapshot/mustafar.ws` (`stardust_03.tre`, first archive wins):

```
building node 12112217  object/building/mustafar/structures/shared_must_new_mining_facility.iff
  world  x=-2420.500  h=199.403  y=1767.080
  quat   w=1.000000 x=0 y=0 z=0        <-- IDENTITY. yaw 0, so cell-local = world - origin.
  cell node 12112238 = cellIndex 20 = small_room_04
```

⚠ **Do NOT compute the cell node id as `buildingNodeID + N`.** That rule is wrong for this
building — the cell node run has gaps at 12112233 and 12112239, so the arithmetic is off by two by
the time it reaches this room. This was caught and corrected once already. **Resolve the cell by
NAME**, the way `historian.lua:352-360` does.

Position, derived from the shipped `.qst` waypoint:

```
.qst world      (-2444, 218, 1760)
minus origin    (-2420.500, 199.403, 1767.080)
cell-local      x = -23.50   y = -7.08
floor height    z = 19.07    <-- from must_mining_facility.ilf, NOT from the .qst
```

The height comes from the ILF, not the subtraction. Every floor-standing item in `small_room_04`
in the shipped interior layout sits at exactly `19.070` (power cells, mining chair). The `.qst`
subtraction gives 18.597, which is under the floor. Use **19.07**.

Heading **0** — no heading ships for him anywhere; 0 is the unmarked default, not a choice.

Implement as a new `spawnGiver()` helper called from `start()` after `spawnRuinsArea()`:

```lua
function somJenhaTarCubeScreenPlay:spawnGiver()
	local giver = self.questGiver
	local pBuilding = getSceneObject(giver.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("somJenhaTarCubeScreenPlay: building " .. giver.buildingID .. " is missing; Doctor Olok cannot be placed and the quest cannot be started")
		return
	end

	local pCell = BuildingObject(pBuilding):getNamedCell(giver.cellName)

	if (pCell == nil) then
		print("somJenhaTarCubeScreenPlay: building " .. giver.buildingID .. " has no cell named " .. giver.cellName .. "; Doctor Olok cannot be placed")
		return
	end

	local pNpc = spawnMobile("mustafar", giver.template, 0, giver.x, giver.z, giver.y, giver.heading, SceneObject(pCell):getObjectID())

	if (pNpc == nil) then
		print("somJenhaTarCubeScreenPlay: failed to spawn " .. giver.template .. "; the quest cannot be started")
	else
		self.questGiverID = SceneObject(pNpc):getObjectID()
	end
end
```

with the data on the screenplay table, next to the other task tables:

```lua
	-- THE GIVER. Position derived from the .qst waypoint against snapshot building
	-- 12112217 (identity quaternion, so cell-local = world - origin); floor height
	-- 19.07 read off must_mining_facility.ilf. See THE GIVER in the header.
	questGiver = {
		template = "npc_ithes_olok",
		buildingID = 12112217,
		cellName = "small_room_04",
		x = -23.5,
		z = 19.07,
		y = -7.08,
		heading = 0,
	},
```

⚠ **`spatialChat` does not work in cells on this build** (`mensix_mining_facility_main.lua:38`
records a mobile being moved outdoors for exactly that reason). **Conversations DO work in cells**
— `must_junk` at `mensix_mining_facility_main.lua:58` proves it. So do not add any `spatialChat`
to this giver. You were not asked to; this is here so you do not add one "for polish".

### 2. `glyph_hunt.lua` — the Historian, OUTDOORS, height is shipped

Template `naboo_historian`. The `.qst` plants a waypoint for both hand-ins at
`mustafar (-5791, 106, 5808)` — full 3D, height included. That is where he stood in live.
Snapshot crates near that point sit at h≈106.8, so the shipped height is right.

Pass the shipped height straight through. Do **not** call `getWorldFloor` here — the reasoning is
already written down in `som_poison_miners.lua:105-106`: shipped heights are passed through
because on the ground they cannot break anything.

```lua
	-- THE GIVER. The .qst's own hand-in waypoint, mustafar (-5791, 106, 5808) --
	-- full 3D, so nothing is derived. See THE GIVER in the header.
	questGiver = {
		template = "naboo_historian",
		x = -5791,
		z = 106,
		y = 5808,
		heading = 0,
	},
```

`spawnGiver()` for this one is the simple outdoor shape — copy `historian.lua:309-318` verbatim
apart from names, `cellID` **0**, respawn **0**. Call it from `start()` after `attachGlyphs()`.

### 3. `blackguard_problem.lua` — Dr. Lu, OUTDOORS, height from terrain

Template `doc_lu`. Position converted from a community `/way` through the proven offset:
**(-4635, 3296)**. The nearest snapshot node is a `must_smuggler_watchtower` 18.5 m away at
h=69.49, which is the corroboration, not the height source.

**No height ships for him**, so resolve it at spawn time with `getWorldFloor`, inline in the
`spawnMobile` call exactly as `coa3Screenplay.lua:519` does and as `historian.lua:423` does on
this planet:

```lua
	-- THE GIVER. Converted from a live-era community waypoint through the proven
	-- Mustafar offset (shipped = way_x - 2880, way_z + 2976). No height ships, so
	-- the floor is resolved at spawn. See THE GIVER in the header.
	questGiver = {
		template = "doc_lu",
		x = -4635,
		y = 3296,
		heading = 0,
	},
```

```lua
	local pNpc = spawnMobile("mustafar", giver.template, 0, giver.x, getWorldFloor(giver.x, giver.y, "mustafar"), giver.y, giver.heading, 0)
```

`start()` is currently an empty body at `blackguard_problem.lua:333-334`. Replace it with the
guarded form and delete the three-line comment above it at `:329-332` that says nothing is placed
at boot — it is now false. Keep the `DirectorManager` note about why `start()` exists; fold it
into the new comment.

### 4. `storm_lord.lua` — Reporter Jural AND her brother Talper, OUTDOORS

Templates `reporter_jural` and `reporter_talper`. Position converted through the proven offset:
**(440, 5115)**, open terrain. No height ships — use `getWorldFloor`.

⚠ **An empty snapshot result near this point is expected, not a refutation.** Nothing sits within
600 m of it. The live sources put Jural on open road ~880 m out from the Berken's Flow ruins, with
her dying brother. Bare terrain is the correct finding here.

Talper is the sick brother the entire quest is about and her shipped dialogue names him. He gets
the same waypoint, offset **3 m east**, because two bodies cannot occupy one point. **Say so in
the comment** — the 3 m is nominal and is the only number in this round that is not sourced:

```lua
	-- THE GIVER. Converted from a live-era community waypoint through the proven
	-- Mustafar offset (shipped = way_x - 2880, way_z + 2976). No height ships, so
	-- the floor is resolved at spawn. Talper is placed beside her because her
	-- shipped dialogue is about him standing there; the 3 m gap is nominal, not
	-- shipped -- one waypoint cannot hold two bodies. See THE GIVER in the header.
	questGiver = {
		template = "reporter_jural",
		x = 440,
		y = 5115,
		heading = 0,
	},

	brother = {
		template = "reporter_talper",
		x = 443,
		y = 5115,
		heading = 0,
	},
```

`spawnGiver()` places both, each nil-checked separately with its own `print`. `start()` is
currently empty at `storm_lord.lua:382-383` with a comment above it at `:378-381`; same treatment
as blackguard.

---

## HEADER CORRECTIONS — required, and as important as the code

Each of these four files opens with a long `--[[ ... --]]` provenance header. Those headers are
the project's record of what shipped and what did not. **Three of the four now contain statements
that are false**, and a stale header is worse than no header. Correct them — in the same plain,
evidence-first voice the rest of the header uses. Do not add hype, do not add a changelog line,
do not sign anything.

### `jenha_tar_cube.lua` — the `NO GIVER` block at lines 144-167

False now:
- `:153-154` "Its conversationTemplate is "" and there is no ithes_olok file in
  mobile/conversations/mustafar/." — both halves are false; it is `"som_cube_ithes_olok"` and the
  tree ships at `mobile/conversations/mustafar/som_cube_ithes_olok.lua`.
- `:163` "So this file spawns nobody and invents no position."

Still true and must be kept:
- `:150-152` the creature registration facts (minus the "spawned NOWHERE" clause).
- `:155-161` there is no `quest_start` object in the snapshot; the moon carries exactly three and
  all three are Kenobi's. That is genuinely true and worth keeping.
- `:163-167` `signalReturnNotes` IS the `somCubeSuccess` signal and there is no other way to raise
  it.

Retitle the block `THE GIVER` and state what is now known: the tree and handler are wired, the
`.qst` waypoint gives his world position, snapshot building 12112217 has an identity quaternion so
cell-local is a plain subtraction, and the floor height is the ILF's. Say explicitly that the cell
is resolved by name because the `+N` node arithmetic is wrong for this building.

### `glyph_hunt.lua` — the `NO GIVER` block at lines 174-197

False now:
- `:183` "it is spawned NOWHERE in this tree."
- `:184-185` "Its conversationTemplate is "" and there is no historian file in
  mobile/conversations/mustafar/ for it to point at." — false on both halves.
- `:188` "So this file spawns nobody and invents no position."
- `:194-197` — **this is the one that matters.** It rules that the waypoint
  `mustafar (-5791, 106, 5808)` "is NOT used to spawn anything, because a waypoint target is not a
  placement and the .qst never says it is one." That ruling is now reversed, and the reversal must
  be recorded as a reversal, not quietly dropped. Say plainly: the waypoint is now also used as the
  placement, because the offset work established that this is where he stood in live and the `.qst`
  waypoint is the only 3D position the shipped data carries for him.

Keep `:186` (no `quest_start` object) and `:188-192` (the two signal seams).

### `blackguard_problem.lua` — the `THE GIVER` block at lines 175-203

Only the tail is stale. `:181-188` is already correct and describes the wired tree.

False now:
- `:190-197` "What the shipped data still does NOT say is where he stands ... spawned NOWHERE ...
  So this file still spawns nobody and invents no position -- that one is Aaron's call, and it is
  the last thing between this quest and playable."

Replace that with the offset derivation: no shipped position exists for him, the position comes
from a live-era community waypoint converted through the proven offset, the offset itself was
fixed by two shipped `.qst` waypoints and confirmed against ten independent landmarks, and the
height is resolved from terrain at spawn because the waypoint carries only X and Z.

Keep `:194` (no `quest_start`) and `:198-203` (the four seams).

### `storm_lord.lua` — the `NO GIVER` block at lines 194-220

Same shape as glyph_hunt. False now: `:207-209` (spawned nowhere, and Talper likewise),
`:210-211` (`conversationTemplate` is "" — it is `"som_storm_lord_jural"`, and the tree ships),
`:214` "So this file spawns nobody, invents no position and writes no conversation."

Record the offset derivation, the terrain-resolved height, and — explicitly — that Talper's 3 m
offset is nominal and is the one unsourced number in the placement.

Keep `:212` (no `quest_start`) and `:215-220` (the four seams). **Leave `reporter_talper`'s
`conversationTemplate = ""` alone** — no tree ships for him and none may be authored.

---

## What you must NOT do in this round

- Do not touch the `lootName` / `item_tow_*` paragraphs in any of these headers. They are being
  corrected in a separate round with separate evidence. Leave them exactly as they are.
- Do not grant, spawn, or invent any reward item.
- Do not add a `quests.iff` row, a `quest_manager.lua` id, or a journal entry.
- Do not add `spatialChat` anywhere.
- Do not touch `miner_hens`, the trophy hunts, or any creature template.

---

## Deliverable

1. The four files edited, nothing else changed.
2. Report, in plain text:
   - the exact `spawnMobile` call you wrote for each of the five mobiles (four givers + Talper),
   - every header line number you rewrote,
   - anything in this brief that did not match what you found in the file — **say so and stop
     rather than adapting**, because a mismatch means the brief is stale and the orchestrator
     needs to know before you guess.
3. Do not commit. The orchestrator commits.
