# ROUND G(d) part 2 — close the three real holes in the Mustafar boundary ring

ONE FILE ONLY:
`MMOCoreORB/bin/scripts/screenplays/mustafar/boundaries/mustafar_boundaries.lua`

Do not touch any other file. Do not commit. Do not run git.

---

## Why

The wall is 127 ActiveArea discs named in five chains (`Se`, `So`, `We`, `No`, `Ea`).
Two consecutive segments make wall only where their discs **overlap**. Any consecutive
pair that does not overlap is a hole in the map.

Levarris left 7 copy-paste stacks — areas spawned on a coordinate already occupied by
their neighbour, walling nothing new. Three of those stacks sit immediately before a
long unwalled run, so the segments that were meant to fill the run were never moved
off their template coordinate. Result: three holes.

    So5  - So6    centres 1022.2 m apart, radii sum 512  ->  GAP 510.2 m
    Ea17 - Ea18   centres  742.0 m apart, radii sum 512  ->  GAP 230.0 m
    No16 - No17   centres  719.8 m apart, radii sum 512  ->  GAP 207.8 m

A 2 m flood fill from the push-back point (197,-214) reaches the edge of the world box.
The map is open, and has been the whole time.

The fix is to un-stack the duplicates into the run they were plainly meant to fill,
keeping name order so the chain stays readable. The `So` and `Ea` runs have spare
stacked segments to spend. The `No` run does not, so it gets one new segment `No16b`,
following the `Se0` precedent set earlier this round.

Heights are **decorative** — `ActiveAreaImplementation::containsPoint(float px, float py)`
is 2D only, so the 2nd number in `spawnSceneObject` plays no part in containment. The
values below are interpolated between the two fixed neighbours purely so the spawn sits
near plausible terrain.

The moved areas keep their existing observer handler. Every one of those handlers still
throws the player inward and no destination lands inside a disc:

| area | handler | destination | distance from new centre |
|---|---|---|---|
| So3 | notifySpawnAreaSo2 | (-658, -268) | 332 m, north — outside r256 |
| So4 | notifySpawnAreaSo2 | (-658, -268) | 397 m, north-east — outside r256 |
| So5 | notifySpawnAreaSo3 | (-1117, -199) | 390 m, north — outside r256 |
| Ea16 | notifySpawnAreaEa7 | (484, 2211) | 327 m, west — outside r256 |
| Ea17 | notifySpawnAreaEa7 | (484, 2211) | 424 m, north-west — outside r256 |
| No16b | notifySpawnAreaNo7 | (-1744, 5951) | 460 m, south-east — outside r256 |

---

## EDIT 1 — So3, So4, So5 spread along the So2 -> So6 run

`So2` is at (-374, -604) r260 and `So6` is at (-1396, -583) r256; both stay put.
So3/So4/So5 are all sitting on So2's exact coordinate. Space them evenly along the run.

### 1a. Line 250, inside `spawnActiveAreaSo3`

FIND:
```lua
  local pAreaSo3 = spawnSceneObject("mustafar", "object/active_area.iff", -374, 251, -604, 0, 0, 0, 0, 0)
```
REPLACE WITH:
```lua
  -- G(d): was stacked on So2's exact coordinate (-374, 251, -604) and walled nothing.
  -- Spread along the So2 -> So6 run; overlaps So2 by 260 m and So4 by 257 m.
  local pAreaSo3 = spawnSceneObject("mustafar", "object/active_area.iff", -630, 281, -599, 0, 0, 0, 0, 0)
```

### 1b. Line 261, inside `spawnActiveAreaSo4`

FIND:
```lua
  local pAreaSo4 = spawnSceneObject("mustafar", "object/active_area.iff", -374, 251, -604, 0, 0, 0, 0, 0)
```
REPLACE WITH:
```lua
  -- G(d): was stacked on So2's exact coordinate. Overlaps So3 by 257 m and So5 by 256 m.
  local pAreaSo4 = spawnSceneObject("mustafar", "object/active_area.iff", -885, 312, -594, 0, 0, 0, 0, 0)
```

### 1c. Line 272, inside `spawnActiveAreaSo5`

FIND:
```lua
  local pAreaSo5 = spawnSceneObject("mustafar", "object/active_area.iff", -374, 251, -604, 0, 0, 0, 0, 0)
```
REPLACE WITH:
```lua
  -- G(d): was stacked on So2's exact coordinate, which left a 510 m hole between here
  -- and So6 (-1396, -583). Overlaps So4 by 256 m and So6 by 257 m; the hole is closed.
  local pAreaSo5 = spawnSceneObject("mustafar", "object/active_area.iff", -1141, 342, -588, 0, 0, 0, 0, 0)
```

---

## EDIT 2 — Ea16, Ea17 spread along the Ea15 -> Ea18 run

`Ea15` is at (813, 2432) and `Ea18` is at (805, 1690); both stay put.
Ea16/Ea17 are sitting on Ea15's exact coordinate.

### 2a. Line 1366, inside `spawnActiveAreaEa16`

FIND:
```lua
  local pAreaEa16 = spawnSceneObject("mustafar", "object/active_area.iff", 813, 94, 2432, 0, 0, 0, 0, 0)
```
REPLACE WITH:
```lua
  -- G(d): was stacked on Ea15's exact coordinate (813, 94, 2432) and walled nothing.
  -- Spread along the Ea15 -> Ea18 run; overlaps Ea15 by 265 m and Ea17 by 264 m.
  local pAreaEa16 = spawnSceneObject("mustafar", "object/active_area.iff", 810, 212, 2185, 0, 0, 0, 0, 0)
```

### 2b. Line 1377, inside `spawnActiveAreaEa17`

FIND:
```lua
  local pAreaEa17 = spawnSceneObject("mustafar", "object/active_area.iff", 813, 94, 2432, 0, 0, 0, 0, 0)
```
REPLACE WITH:
```lua
  -- G(d): was stacked on Ea15's exact coordinate, which left a 230 m hole between here
  -- and Ea18 (805, 1690). Overlaps Ea16 by 264 m and Ea18 by 265 m; the hole is closed.
  local pAreaEa17 = spawnSceneObject("mustafar", "object/active_area.iff", 808, 330, 1937, 0, 0, 0, 0, 0)
```

---

## EDIT 3 — new segment `No16b` between No16 and No17

`No16` (-2199, 5865) and `No17` (-2040, 6567) are 719.8 m apart, leaving a 207.8 m hole.
The `No` chain's duplicate stacks (No4/No5, No9/No10, No12/No13) are nowhere near this
run, so reusing one would scramble the name order. Add one segment at the midpoint
instead. It overlaps No16 by 152 m and No17 by 152 m.

### 3a. `start()` — add the call

FIND (lines 105-106):
```lua
      self:spawnActiveAreaNo16()
      self:spawnActiveAreaNo17()
```
REPLACE WITH:
```lua
      self:spawnActiveAreaNo16()
      self:spawnActiveAreaNo16b()
      self:spawnActiveAreaNo17()
```

### 3b. New function, inserted between `spawnActiveAreaNo16` and `spawnActiveAreaNo17`

FIND (the blank line and the header that follow the end of `spawnActiveAreaNo16`,
currently lines 1053-1055):
```lua
end

function mustafar_boundaries:spawnActiveAreaNo17()
```
REPLACE WITH:
```lua
end

-- G(d): new segment. No16 (-2199, 5865) and No17 (-2040, 6567) are 719.8 m apart with
-- r256 each, which left a 207.8 m hole in the north wall. This sits at the midpoint and
-- overlaps both by 152 m. Unlike the So and Ea runs there was no stacked duplicate in
-- this chain to spend here, so the segment is new -- same as Se0 earlier this round.
function mustafar_boundaries:spawnActiveAreaNo16b()
  local pAreaNo16b = spawnSceneObject("mustafar", "object/active_area.iff", -2120, 698, 6216, 0, 0, 0, 0, 0)

  if (pAreaNo16b ~= nil) then
    local activeArea = LuaActiveArea(pAreaNo16b)
          activeArea:setCellObjectID(0)
          activeArea:setRadius(256)
          createObserver(ENTEREDAREA, "mustafar_boundaries", "notifySpawnAreaNo7", pAreaNo16b)
      end
end

function mustafar_boundaries:spawnActiveAreaNo17()
```

Do NOT add a new `notifySpawnAreaNo16b` handler — `No16b` reuses the existing
`notifySpawnAreaNo7`, whose destination (-1744, 5951) is 460 m south-east of the new
centre, well inside the map and outside every disc.

---

## Do NOT touch

- Any other `spawnActiveArea*` function. The other four duplicate stacks
  (No1/We32, No4/No5, No9/No10, No12/No13, Ea22/Ea23) are wasteful but the chain stays
  continuous through them — they are not holes and they are being documented, not fixed.
- Any `notifySpawnArea*` handler. No handler changes in this round.
- The `Se0` / `Se1` / `Se2` work already in the working tree from G(d) part 1.
- Plain ASCII only. No non-ASCII characters anywhere in this file.
