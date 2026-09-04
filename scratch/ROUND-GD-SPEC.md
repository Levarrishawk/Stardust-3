# ROUND G(d) — the south-east wall, and the Chapter Three 01 scout post

Two defects, one root cause. Both are fixed by moving geometry, not by adding logic.

## The root cause

`MMOCoreORB/bin/scripts/screenplays/mustafar/boundaries/mustafar_boundaries.lua` builds an
invisible wall out of 126 ActiveAreas, each with an ENTEREDAREA observer that teleports the
player back inside. Its own header says what it is:

```
Boundaries for mustafar_mustafar_main terrain Layer by Levarris
```

Hand-drawn against a custom terrain layer. It is not live data and it was vendored in
unexamined by commit 3133fa6829, whose message never mentions it.

In the south-east corner it is drawn straight through live content.

## Defect 1 — Chapter Three 01's scout is unreachable

Live places the scout at (550.59, -154.69):
`sys.server/.../datatables/buildout/mustafar/mustafar_main_se.tab:30`,
`object/tangible/npc/mustafar_spawn/story_arc_chapter_three_scout.iff`.
The quest task agrees: `som_story_arc_chapter_three_01.tab:3`,
`LOCATION_X 550, LOCATION_Y 157, LOCATION_Z -154`, CREATE_WAYPOINT true. Of the 55
live Mustafar-located quest tasks this is the only one with x > 300.
The port transcribes it at `screenplays/mustafar/quest/story_arc_chapters.lua:651`.

Se1 sits at (587, -196) r256 — 56 m from the scout. Its 256 m radius projects inward as
well as out, so the scout is 200.03 m inside the wall. Any player walking to the waypoint
crosses Se1's edge 200 m short of the scout and is teleported to (197, -214).

## Defect 2 — the F1(c) pocket is a hole in the map

Commit 130a4a8113 tried to fix defect 1 with a 60 m exemption inside the handler
(`mustafar_boundaries.lua:1589-1596`): if the player is within 60 m of (550, -154),
return 0 instead of teleporting.

That cannot work, and it is worse than nothing:

- ENTEREDAREA fires ONLY on the transition into the area.
  `MMOCoreORB/src/server/zone/GroundZoneImplementation.cpp:253` guards the enter event with
  `if (!tano->hasActiveArea(activeArea) && activeArea->containsPoint(...))`. A player already
  inside gets `notifyPositionUpdate` (`:245`), which notifies no observers. There is no
  EXITEDAREA observer and no periodic task anywhere in the file.
- The pocket is entirely interior to Se1 (max 55.97 + 60 = 115.97 < 256), so a walker can
  never enter through it. It only ever applies to a player teleported straight in — which is
  the Valley Battlefield exit at (541, -160) (`valley_battlefield.lua:124-125`, `switchZone`
  at `:727`).
- That player becomes a registered member of Se1 and Se2 and is never re-checked. Walking
  due east from (541, -160) they leave the ring at x = 840.5 — 299.5 m, one straight line,
  no re-trigger. Bearings 65.2 deg to 198.1 deg all escape.

So the exemption does not make the scout walkable and does open the map. It comes out.

It is also the only handler-side exemption in the file: the other 46 handlers are
unconditional and byte-identical in shape. Removing it restores house style.

## The fix — move the wall out around the scout

Se1 moves out, Se2 moves out, and one new area Se0 bridges the widened corner so the chain
stays continuous. The pocket exemption is deleted.

| area | centre now | centre after | radius |
|---|---|---|---|
| Se0 | (new) | (860, -57) | 256 |
| Se1 | (587, -196) | (825, -300) | 256 (unchanged) |
| Se2 | (448, -404) | (477, -500) | 275 (unchanged) |

The height argument is decorative: `ActiveAreaImplementation::containsPoint(float px, float py)`
at `MMOCoreORB/src/server/zone/objects/area/ActiveAreaImplementation.cpp:24-34` tests x and y
only. Keep Se1's 170 and Se2's 226 as they are; give Se0 170.

### Chain continuity — consecutive centres vs sum of radii

| pair | distance | radii sum | overlap |
|---|---|---|---|
| Ea23 (712,690) - Ea24 (679,186) | 505.08 | 512 | 6.9 (PRE-EXISTING, not touched) |
| Ea24 (679,186) - Se0 (860,-57) | 303.00 | 512 | 209.0 |
| Se0 - Se1 (825,-300) | 245.51 | 512 | 266.5 |
| Se1 - Se2 (477,-500) | 401.38 | 531 | 129.6 |
| Se2 - Se3 (139,-504) | 338.02 | 550 | 212.0 |
| Se3 - So1 (-121,-604) | 278.57 | 535 | 256.4 |

Every consecutive pair still overlaps, so the union stays connected and there is no gap to
walk through.

### The scout is now outside every area

| point | Se0 | Se1 | Se2 |
|---|---|---|---|
| scout (550, -154) | 324.82 (68.8 clear) | 311.35 (55.4 clear) | 353.62 (78.6 clear) |
| battlefield exit (541, -160) | 335.22 (79.2 clear) | 316.63 (60.6 clear) | 345.97 (71.0 clear) |

At the scout's latitude y = -154 the free ground now runs east to x = 614.7 (Se1's inner
face there), a 65 m apron past the scout. The live rock cluster from x 618 outward stays
walled; that is scenery, not gameplay, and opening further would mean redrawing the whole
east wall against a terrain layer this port did not author.

### The push-back target stays valid

(197, -214) must remain outside every area or the handler bounces forever.
New Se2: 400.24 vs 275, outside. New Se1: 633.86. Se0: 681.34. Se3 is unchanged at 295.7
vs 275 — a 20.7 m margin, as before.

### The wall still does its job

The header's purpose is to keep players out of the surrounding instance buildouts. The
nearest one east is `mustafar_volcano`, which starts at x 1552 (`areas_mustafar.tab`).
Se0's outer edge is 860 + 256 = 1116 and Se1's is 825 + 256 = 1081. Both stay well clear.

---

# CHANGES — make exactly these, and nothing else

## 1. `MMOCoreORB/bin/scripts/screenplays/mustafar/boundaries/mustafar_boundaries.lua`

### 1a. Register Se0 in `start()`

In `mustafar_boundaries:start()`, find:

```lua
      --southeast
      self:spawnActiveAreaSe1()
```

Replace with:

```lua
      --southeast
      self:spawnActiveAreaSe0()
      self:spawnActiveAreaSe1()
```

### 1b. Add the Se0 spawn function

Find the line `--southeast` that sits immediately above
`function mustafar_boundaries:spawnActiveAreaSe1()` (this is the second `--southeast` in the
file, at file scope, not the one inside `start()`). Insert the new function between that
comment and `spawnActiveAreaSe1`, so the file reads:

```lua
--southeast

--[[ Se0 is OURS, not Levarris's. It bridges the corner that opens when Se1 moves out to
     clear Chapter Three 01's scout post. Without it, Ea24 (679,186) r256 and the new Se1
     (825,-300) r256 sit 490.7 m apart against a 512 m radii sum, and the wall pinches to a
     21 m overlap. Se0 at (860,-57) puts 209.0 m of overlap on the Ea24 side and 266.5 m on
     the Se1 side.

     It is placed outboard of the scout on purpose: at the scout's latitude Se0's inner face
     is x 623.1 and Se1's is x 614.7, so the scout at x 550 keeps a 65 m eastern apron.

     Height 170 copies Se1. containsPoint(float, float) at
     src/server/zone/objects/area/ActiveAreaImplementation.cpp:24-34 tests x and y only, so
     the height argument does not affect containment. ]]
function mustafar_boundaries:spawnActiveAreaSe0()
  local pAreaSe0 = spawnSceneObject("mustafar", "object/active_area.iff", 860, 170, -57, 0, 0, 0, 0, 0)

  if (pAreaSe0 ~= nil) then
    local activeArea = LuaActiveArea(pAreaSe0)
          activeArea:setCellObjectID(0)
          activeArea:setRadius(256)
          createObserver(ENTEREDAREA, "mustafar_boundaries", "notifySpawnAreaSe", pAreaSe0)
      end
end

function mustafar_boundaries:spawnActiveAreaSe1()
```

Match the file's existing indentation style exactly (two spaces, then the odd ten-space
indent on the `activeArea:` lines, then the `      end` / `end` pair) — copy it from
`spawnActiveAreaSe1` directly below.

### 1c. Move Se1

In `spawnActiveAreaSe1`, find:

```lua
  local pAreaSe1 = spawnSceneObject("mustafar", "object/active_area.iff", 587, 170, -196, 0, 0, 0, 0, 0)
```

Replace with:

```lua
  -- MOVED. Levarris drew Se1 at (587, -196), which put its 256 m radius 200.03 m inboard
  -- of Chapter Three 01's live scout post at (550, -154) and made the quest step
  -- unreachable. Moved out to (825, -300), which leaves the scout 55.4 m clear.
  local pAreaSe1 = spawnSceneObject("mustafar", "object/active_area.iff", 825, 170, -300, 0, 0, 0, 0, 0)
```

### 1d. Move Se2

In `spawnActiveAreaSe2`, find:

```lua
  local pAreaSe2 = spawnSceneObject("mustafar", "object/active_area.iff", 448, 226, -404, 0, 0, 0, 0, 0)
```

Replace with:

```lua
  -- MOVED, same reason as Se1. At (448, -404) the scout post sat 4.99 m inside Se2's 275 m
  -- radius -- a near miss, but a miss is a bounce. (477, -500) leaves it 78.6 m clear and
  -- also clears the approach from the push-back point at (197, -214).
  local pAreaSe2 = spawnSceneObject("mustafar", "object/active_area.iff", 477, 226, -500, 0, 0, 0, 0, 0)
```

### 1e. Delete the pocket exemption

In `mustafar_boundaries:notifySpawnAreaSe`, find this whole block (comment and code):

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

Replace it with:

```lua
    -- NO EXEMPTION HERE, AND DO NOT ADD ONE. F1(c) put a 60 m pocket around the scout
    -- post in this handler. It was wrong twice over, and round G(d) took it out.
    --
    -- It could not work: ENTEREDAREA fires only on the transition into an area.
    -- GroundZoneImplementation.cpp:253 guards the enter event with
    -- !tano->hasActiveArea(activeArea), and a player already inside gets only
    -- notifyPositionUpdate (:245), which notifies nobody. The file has no EXITEDAREA
    -- observer and no periodic task. So an exemption is not a hole in a wall -- it is a
    -- one-way door. A player dropped into the pocket by the Valley Battlefield exit
    -- became a registered member of Se1 and Se2 and was never checked again; walking due
    -- east from (541, -160) they left the ring at x 840.5, 299.5 m, no re-trigger.
    --
    -- And it never fixed what it was for. The pocket lay entirely inside Se1, so a player
    -- walking to the scout crossed Se1's edge 140 m outside it and was bounced anyway.
    --
    -- The scout is reachable now because Se0/Se1/Se2 were moved. Geometry is the only
    -- thing this event model can express.
```

Leave the rest of the handler exactly as it is, including the `isCreatureObject` guard, the
`isAiAgent` guard, the system message, `player:teleport(197, 121, -214, 0)` and `return 0`.
After the edit the handler must be unconditional, like the other 46.

## 2. `MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/valley_battlefield.lua`

Find:

```lua
	-- live exit_one 541,155,-160,mustafar -> a REAL Mustafar world coordinate,
	-- 10.8 m from Chapter Three 01's scout post. Reachable only because of the
	-- boundary pocket this round also opens (see mustafar_boundaries.lua).
```

Replace with:

```lua
	-- live exit_one 541,155,-160,mustafar -> a REAL Mustafar world coordinate,
	-- 10.8 m from Chapter Three 01's scout post. This used to depend on a 60 m
	-- exemption inside mustafar_boundaries:notifySpawnAreaSe. That exemption was a
	-- one-way door out of the map and round G(d) deleted it; the exit point is free
	-- ground now because Se0/Se1/Se2 were moved instead. Nearest wall is Se1 at
	-- (825,-300) r256, 60.6 m away.
```

Keep the tab indentation this file uses.

## 3. `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/story_arc_chapters.lua`

Find the `scoutPost` line and the comment block above it (around lines 643-651). Leave the
existing comment alone, but insert these two lines immediately above the `scoutPost = {` line:

```lua
	-- Reachable since round G(d): Levarris's Se1 boundary sphere was drawn 56 m from this
	-- point and projected 256 m inward over it. Se0/Se1/Se2 moved out; see
	-- screenplays/mustafar/boundaries/mustafar_boundaries.lua.
```

Keep the tab indentation this file uses.

---

# RULES

- Plain ASCII only. No non-ASCII characters anywhere, including in comments. No arrows, no
  warning signs, no smart quotes. Use `->` and `--` if you need them.
- Do not reformat, re-indent or re-order anything you were not told to change. The
  boundaries file has irregular indentation; leave it irregular.
- Do not touch any other active area, any other handler, or any other file.
- Do not commit and do not run git.
