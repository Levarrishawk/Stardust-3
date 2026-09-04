# ROUND H(g) SPEC — the Ancient Jundak has a retail row after all

Do not commit. Do not run git. Do not touch any file not named here.

## Why this exists

`trophy_hunts.lua:475-476` currently says:

```lua
			-- som_ancient_jundak does not ship anywhere.  SUBSTITUTE -- see header.
			huntTemplate = "jundak_devourer",
```

That comment is false, and it was false because nobody had read the retail master
creature table. It is at:

```
C:\swg-extract\_dsrc-full\sku.0\sys.server\compiled\game\datatables\mob\creatures.tab
```

6713 rows, 292 of them `som_*`. Its header declares
`creatureName / BaseLevel / ... / difficultyClass e(NORMAL=0,ELITE=1,BOSS=2) / ... / template`.
Every jundak row in it:

```
  som_ancient_jundak                  lvl  84  ELITE    som/jundak.iff            scale 1.5/1.5
  som_jundak                          lvl   1  NORMAL   som/jundak.iff            scale 0.8/1.4
  som_jundak_devourer                 lvl  88  NORMAL   som/jundak_devourer.iff   scale 1.7/1.7
  som_nesting_grounds_jundak          lvl  78  NORMAL   som/jundak.iff            scale 0.8/1.2
  som_nesting_grounds_jundak_bloated  lvl  84  NORMAL   som/jundak.iff            scale 1.1/1.5
  som_nesting_grounds_jundak_shrieker lvl  80  NORMAL   som/jundak.iff            scale 0.9/1.3
  som_nesting_grounds_jundak_stalker  lvl  82  NORMAL   som/jundak.iff            scale 1/1.4
```

So the substitution was wrong twice over. `som_ancient_jundak` **does** ship — CL 84, ELITE.
And `som_jundak_devourer` is a *different creature* on a *different appearance*
(`som/jundak_devourer.iff`, not `som/jundak.iff`), so the trophy target has also been
wearing the wrong model.

The rest of the `som_ancient_jundak` row, for the record:

```
  socialGroup jundak      where mustafar      niche carnivore
  aggressive 9   assist 9   death_blow instant   attackSpeed 2
  meat 40 meat_insect      hide 48 hide_scaley
  lootTable mustafar/mustafar_jundak
  wildAbilityList highAbilitySpeedStrong
  primary_weapon_specials mantis_5   secondary_weapon_specials generic_creature_special_6
```

Cross-checks: `_som\quest\som_jundak_skull.qst:52` carries
`<data value="som_ancient_jundak" name="CreatureType" />`, and the retail buildout
`datatables\buildout\mustafar\mustafar_main_ne.tab:969` spawns `mustafar/ancient_jundak`,
which resolves through `spawning\ground_spawning\types\mustafar\ancient_jundak.tab:3` to
`som_ancient_jundak`.

## What to do

### 1. NEW FILE `bin/scripts/mobile/custom_content/som/som_ancient_jundak.lua`

Model it on `jundak_devourer.lua`, which is the ELITE rung of this tree's tier ladder and
is the closest sibling. Copy that file's shape exactly and change only what is listed.

```lua
som_ancient_jundak = Creature:new {
	customName = "Ancient Jundak",
	socialGroup = "jundak",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 84,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {5,5,5,30,-1,30,-1,-1,-1},
	meatType = "meat_carnivore",
	meatAmount = 400,
	hideType = "hide_leathery",
	hideAmount = 300,
	boneType = "bone_mammal",
	boneAmount = 250,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/jundak.iff"},
	lootGroups = {
		{
			groups = {
				{group = "resource_creature", chance = 6000000},
				{group = "junk", chance = 2000000},
				{group = "armor_attachments", chance = 2000000}
			},
			lootChance = 4000000
		}
	},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"knockdownattack",""}, {"dizzyattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_ancient_jundak, "som_ancient_jundak")
```

Put a header comment above it recording, in this order and in plain sentences:

- that this is `creatures.tab`'s `som_ancient_jundak`, CL 84 ELITE, `som/jundak.iff` at
  scale 1.5;
- that **`level = 84` is retail's own number, not the ladder's.** The ladder's ELITE rung is
  85. Everything else in this template *is* the ELITE rung, unchanged. This is the second
  deliberate exception to "level is copied from the anchor exactly" and it is taken because
  retail states a per-creature number for this named unique and a displayed CL is worth
  getting exactly right. Say so plainly so the next reader does not "fix" the 84 back to 85;
- that retail lists `meat_insect` / `hide_scaley` for every jundak, but this tree's whole
  jundak family (`jundak.lua`, `jundak_devourer.lua`) uses `meat_carnivore` /
  `hide_leathery` / `bone_mammal`, so the family convention wins here and retail's values
  are recorded in this comment instead of applied. One divergent template would read as a
  mistake;
- that the retail row's `lootTable mustafar/mustafar_jundak` is not transcribed here; the
  `lootGroups` block is the ELITE sibling's, carried over unchanged.

Do NOT add a `controlDeviceTemplate`. This is a named quest elite, not a pet.

### 2. `bin/scripts/mobile/custom_content/som/serverobjects.lua`

Add one line, in the alphabetical position the surrounding lines already use:

```lua
includeFile("custom_content/som/som_ancient_jundak.lua")
```

Match the exact quoting and path shape of the neighbouring lines -- they are relative to
`custom_content/`, e.g. line 57 is `includeFile("custom_content/som/jundak.lua")`.
Add nothing else to this file and change no existing line in it.

### 3. `bin/scripts/screenplays/mustafar/quest/trophy_hunts.lua` around line 475

Replace:

```lua
			-- som_ancient_jundak does not ship anywhere.  SUBSTITUTE -- see header.
			huntTemplate = "jundak_devourer",
```

with `huntTemplate = "som_ancient_jundak",` plus a short comment saying the substitution is
retired: `som_ancient_jundak` is in `creatures.tab` at CL 84 ELITE on `som/jundak.iff`, and
`jundak_devourer` was both the wrong creature and the wrong model. Keep the surrounding
lines (`huntName`, `huntWaypointName`) exactly as they are -- `huntName = "Ancient Jundak"`
is still correct and `spawnNamed` at line 742 still wants it.

### 4. Same file, the header block around lines 84-90 and 136-141

Two places in the header describe the substitution as standing:

- line ~86: `som_ancient_jundak      -> jundak_devourer,      setCustomObjectName("Ancient Jundak")`
- lines ~138-141: the paragraph beginning `som_ancient_jundak is the one that stays an OPEN
  QUESTION: it appears nowhere in the extract list, so jundak_devourer (ELITE 85, against
  jundak and orf_jundak at 70) remains my pick of the closest shipped variant.`

Correct both. The first should record that the substitution is retired and the creature is
now its own template. The second should be replaced with the measured result: it is not an
open question, it appears in `creatures.tab` at CL 84 ELITE, and the reason it looked absent
is that the extract list consulted at the time did not include that table. Keep the entry
for any OTHER creature in that list that is still a substitute -- only the jundak line
changes.

If the line numbers above do not match what you find, the string match wins and this spec's
line numbers are wrong.

## Constraints

- ASCII only. No smart quotes, no em dashes. Use `--` for a dash.
- Tabs for indentation inside the Lua table, matching `jundak_devourer.lua` exactly.
- Do not touch `jundak.lua`, `jundak_devourer.lua` or `orf_jundak.lua`. Their levels are
  deliberately left alone this round.
- Do not touch `bounty_hunts.lua`. Its `killTemplates` list stays as it is --
  `som_ancient_jundak` must NOT be added to it, because the ancient jundak is a
  single quest spawn and not one of the fifteen bounty targets.
- Do not delete anything.

## When you are done

Print the new file in full, and print each changed line with its file and line number.
