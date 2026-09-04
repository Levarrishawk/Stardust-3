# ROUND H(f) SPEC

You are editing ONE file. Do not commit. Do not run git. Do not touch any other file.

File: `MMOCoreORB/bin/scripts/object/custom_content/serverobjects.lua`

## Background you need

Two loot items registered by round H(e) name object templates that are not in
the object load closure, so those two items can never be created and the loot
roll silently drops them:

```
loot/items/mustafar/weapon_tow_blasterfist_04_01.lua -> object/weapon/melee/special/blasterfist_generic.iff
loot/items/mustafar/weapon_tow_sword_rsf_04_01.lua   -> object/weapon/melee/sword/sword_rsf_generic.iff
```

The two server templates that declare those paths DO exist:

```
object/custom_content/weapon/melee/blasterfist_generic.lua  -> object/weapon/melee/special/blasterfist_generic.iff
object/custom_content/weapon/melee/sword_rsf_generic.lua    -> object/weapon/melee/sword/sword_rsf_generic.iff
```

They are just never included. The file you are editing already includes eleven
melee files one by one, at lines 79-89. The comment above them (lines 52-77)
explains why melee is included file-by-file and never wholesale. These two
belong in that list; they were missed when H(e) added the loot items.

Each of the two files declares exactly ONE template path and neither collides
with anything already in the closure. This was measured, not assumed.

## The change

### 1. Add the two includeFile lines

Insert them into the existing melee block at lines 79-89 in alphabetical order,
matching how that block is already sorted. `blasterfist_generic.lua` goes FIRST
in the block (before `blacksun_razor_generic.lua`? no -- "blacksun" sorts before
"blasterfist", so it goes second, after blacksun_razor_generic.lua and before
lance_kashyyk_generic.lua). `sword_rsf_generic.lua` goes LAST, after
`sword_mace_junti_generic.lua`.

Verify the alphabetical placement yourself against the actual lines in the file
rather than trusting the sentence above; if the block turns out not to be
strictly sorted, put each new line where it best matches the existing order and
say so in your output.

Result should be thirteen `includeFile` lines in that block instead of eleven.

### 2. Update the comment block above it

The comment at lines 52-77 currently says "The eleven named files below carry
none of the colliding paths." That number becomes thirteen.

Also add a short paragraph to that same comment block, in the same voice as the
rest of the file (plain sentences, no bullet lists, wrapped at about 88
columns), recording:

- These last two were added a round later than the other eleven, because H(e)
  registered `weapon_tow_blasterfist_04_01` and `weapon_tow_sword_rsf_04_01` as
  loot items without adding their server templates here. The loot item existed,
  the object template did not load, so the roll produced nothing.
- How it was caught: by checking each registered loot item's
  `directObjectTemplate` against the object include closure, rather than against
  what is present on disk. Both files were sitting in
  `custom_content/weapon/melee/` the whole time. Presence is not registration.
- The collision check was re-run for these two specifically. Each declares one
  path, `object/weapon/melee/special/blasterfist_generic.iff` and
  `object/weapon/melee/sword/sword_rsf_generic.iff`, and neither is registered
  anywhere else in the tree.

Do not restate things the existing comment already says. Do not delete or
reword the existing text except for the eleven -> thirteen count.

## Constraints

- ASCII only. No smart quotes, no em dashes, no non-breaking spaces. Use `--`
  for a dash.
- Tabs vs spaces: match whatever the file already uses.
- Do not touch `custom_content/weapon/melee/serverobjects.lua` or add it as an
  include. The comment explains why that would overwrite a stock crafted saber
  and a quest 2h sword.
- Do not modify the two weapon .lua files themselves.
- Do not modify any loot file.

## When you are done

Print the final contents of lines 52 to the end of the file so the change can be
read back.
