# ROUND H(f) PART 3 SPEC — replace the invented STF key `not_ready`

Do not commit. Do not run git. Only touch the three files listed below.

## What this fixes

Three Mustafar entry gates send `@dungeon/space_dungeon:not_ready`. That key was
invented on this branch. It is used nowhere upstream and nothing else in the tree
references it, so the client cannot resolve it and the player is shown the raw
token `@dungeon/space_dungeon:not_ready` instead of a refusal message.

Proven, do not re-derive:

```
git grep "space_dungeon:not_ready" origin/unstable   -> no hits, ever
grep -rn ":not_ready" MMOCoreORB/bin/scripts/        -> only the 3 sites below

keys upstream actually ships in that same stf:
  corellian_corvette_travel_fail, corvette_, dungeon_ticket, dungeon_ticket_d,
  illegal_ticket, no_room_remaining, no_ticket, not_authorized,
  unable_to_find_dungeon, validating_ticket
```

`not_authorized` is the correct replacement. Upstream uses it at
`scripts/screenplays/dungeon/corellian_corvette/corellianCorvette.lua:970` for
exactly this case -- refusing a player who does not qualify to be in the area --
and its shipped text is "You do not have the proper authorization to be in this
area."

It also has to stay DIFFERENT from `unable_to_find_dungeon`, which each of these
three functions already sends a few lines later for the "no free copy / area
busy" case. The two failure modes must read differently to the player. That is
the whole point of the comment already sitting above the first site.

## Files to change

Change `not_ready` to `not_authorized` at exactly these three lines, and nowhere
else:

| file | line |
| --- | --- |
| `MMOCoreORB/bin/scripts/screenplays/mustafar/mustafar_instances.lua` | 635 |
| `MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/valley_battlefield.lua` | 632 |
| `MMOCoreORB/bin/scripts/screenplays/mustafar/battlefields/volcano_battlefield.lua` | 625 |

`mustafar_instances.lua:635` carries a trailing comment that quotes the old
string's intended text:

```lua
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:not_ready") -- You are not ready to enter that area.
```

Update that trailing comment to quote the shipped text of the key you are now
using, so the comment matches reality:

```lua
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:not_authorized") -- You do not have the proper authorization to be in this area.
```

The other two sites have no trailing comment. Add one to each, in the same style
as the `unable_to_find_dungeon` lines already in those files, quoting the same
shipped text.

If the line numbers above do not match what you find, the string match wins and
this spec's line numbers are wrong -- change the three `not_ready` occurrences by
content, and say so in your report.

## Constraints

- ASCII only. No smart quotes, no em dashes. Use `--` for a dash.
- Tabs to match the surrounding file.
- Do not touch any other file. Do not delete anything.
- Do not change the `unable_to_find_dungeon` lines.

## When you are done

Print the three changed lines with their file and line number, and the output of
a fresh `grep -rn "not_ready" MMOCoreORB/bin/scripts/` (expected: no hits).
