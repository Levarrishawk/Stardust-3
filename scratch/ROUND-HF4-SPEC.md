# ROUND H(f) PART 4 SPEC — make the badge comments tell the measured truth

Do not commit. Do not run git. Comments only -- do not change a single line of
executable Lua in any of these files.

## The measured fact

Badges are rows in `datatables/badge/badge_map.iff`, which the server reads out
of the TRE set (`BadgeList.cpp:46`), and `DirectorManager.cpp:863-869` then
registers each row as an uppercase Lua global holding its index.

That file has now been extracted from this server's own TRE set and read. Result:

```
badge_map.iff  <- stardust_03.tre (searchTree_01, the highest-priority TRE
                  that carries the file)   10517 bytes
58 bdg_* rows. Zero of them contain "must", "ep3" or "tow".
The families present are: bdg_accolade_*, bdg_axkva_min_dungeon,
bdg_corvette_*, bdg_exar_kun_dungeon, bdg_exp_*, bdg_library_trivia,
bdg_racing_*, bdg_thm_park_*.
```

So all six Mustafar badge globals are nil at runtime:

```
BDG_MUST_VICTORY_ARMY          valley_battlefield.lua:172
BDG_MUST_VICTORY_VOLCANO       volcano_battlefield.lua:262
BDG_MUST_OBIWAN_STORY_GOOD     kenobi_spine.lua:733
BDG_MUST_OBIWAN_STORY_BAD      kenobi_spine.lua:734
BDG_MUST_MUSTAFAR_EXPLORATION  mining_field_markers.lua:137
BDG_MUST_VICTORY_ORF           story_arc_chapters.lua:637
```

Every one is read through a `_G[...] ~= nil` guard, so nothing errors and nothing
crashes. The badge is simply never awarded. The Lua is correct and stays exactly
as it is; adding the rows means rebuilding a TRE, which is not something this
repo can do -- there is no TRE packing tool in the project, only readers.

## What to change

Two comments currently assert something that is now measurably false. Fix those,
and add the measured result to the other three sites so no future reader has to
re-derive it.

### 1. `screenplays/mustafar/quest/mining_field_markers.lua` around line 135

It currently reads:

```lua
	-- The shipped badge key. DirectorManager exports every badge key as an uppercase Lua
	-- global holding its index, so this is looked up by name at grant time.
```

"The shipped badge key" is wrong -- it is not shipped. Rewrite the comment to say
the key is the live name, that `badge_map.iff` in this server's TRE set has no
row for it, that the `_G[...]` guard therefore skips the award silently, and that
the fix is a TRE row and not a script change.

### 2. `screenplays/mustafar/quest/kenobi_spine.lua` around line 727-732

The block currently ends with words to the effect of "whether these two exist is
a property of the TRE set, not of the scripts, and it cannot be settled by
grepping the repo."

The first half is right and stays. The last clause is now stale: it cannot be
settled by grepping the repo, but it CAN be settled by reading `badge_map.iff`
out of the TRE, and that has now been done. Replace that clause with the result:
neither row is present in this server's TRE set, so both awards are currently
no-ops, and the nil-guard is doing exactly the job it was written for.

### 3. The other three sites

- `screenplays/mustafar/battlefields/valley_battlefield.lua` around line 168-171
- `screenplays/mustafar/battlefields/volcano_battlefield.lua` around line 256-261
- `screenplays/mustafar/quest/story_arc_chapters.lua` around line 634-636

These already explain the UPPERCASE rule and the guard, and that part is correct
-- keep it. Add one short sentence to each recording that `badge_map.iff` in this
server's TRE set carries no `bdg_must_*` row, so the guard is currently a no-op
by data rather than by defect.

Do not repeat the whole 58-row analysis in five places. One sentence each, in the
voice already used in that file.

## Constraints

- ASCII only. No smart quotes, no em dashes. Use `--` for a dash.
- Tabs to match the surrounding file.
- Comments only. If you find yourself changing a `victoryBadge =` or
  `completionBadge =` or `goodBadge =` / `badBadge =` line, stop -- that is not
  this task. The key names are correct as written.
- Do not touch any other file. Do not delete anything.

## When you are done

Print each changed comment block with its file and line range.
