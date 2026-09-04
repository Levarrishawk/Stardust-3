# ROUND H(h1) — the seventeen dungeon-population creatures

Do exactly what this file says. Do not commit. Do not run git. Do not touch any file
not named here.

## Why

`MMOCoreORB/bin/scripts/screenplays/mustafar/mustafar_dungeon_population.lua` maps
seventeen live creature names onto fifteen substitute templates, and states two things
that are both FALSE. Both were checked against the retail SERVER datatable
`C:\swg-extract\_dsrc-full\sku.0\sys.server\compiled\game\datatables\mob\creatures.tab`,
which no earlier round consulted.

Claim 1, at :41-46 — *"Not one of the seventeen creature names in those tables exists as
a template. This is a CHECKED absence... no som_orf_* and no som_decrepit_* creature
definition appears anywhere in this repo or anywhere in the extracted source tree."*
**All seventeen have full retail rows** at BaseLevel 80-87 with real appearances, social
groups and loot tables. The absence was checked against the client TREs and this repo,
never against the server datatable.

Claim 2, at :54-55 and again at :251-252 — *"all fifteen substitute templates are level
70"* / *"every one is level 70."* **Five of fifteen are level 70.** Seven are 85 and
three are 50 — a 35-level spread, verified by reading each file:

    union_sentry_droid 85   asn_121 85   som_ancient_guardian_droideka 85
    som_ancient_guardian_ig 85   lava_flea 50   lava_flea_smoldering 85
    kubaza_beetle 50   kubaza_worker_beetle 50   kubaza_soldier_beetle 70
    orf_tulrus 70   orf_xandank 70   cww8_battle_droid 70
    cww8a_eradicator 85   cww8a_battle_droid 70   ig106 85

So the "consistent difficulty band" the header claims the substitution bought does not
exist. Authoring the seventeen for real fixes both claims at once and puts 88 spawn rows
onto their own creatures.

## PART 1 — create seventeen new template files

All seventeen go in `MMOCoreORB/bin/scripts/mobile/custom_content/som/`, one file per
creature, named `<creature name>.lua`.

### The three stat rungs (copy these numbers exactly)

These are the tree's existing rungs, not new numbers. Do not invent values.

    STD 70    level = 70,  chanceHit = 0.65, damageMin = 430, damageMax = 570,
              baseXp = 6747,  baseHAM = 12000, baseHAMmax = 15000
    ELITE 85  level = 85,  chanceHit = 0.75, damageMin = 555, damageMax = 820,
              baseXp = 8130,  baseHAM = 12000, baseHAMmax = 15000
    BOSS 120  level = 120, chanceHit = 4.0,  damageMin = 745, damageMax = 1200,
              baseXp = 11390, baseHAM = 44000, baseHAMmax = 54000, armor = 2

The rung is chosen by retail's `difficultyClass`, using the mapping this tree already
uses everywhere else (NORMAL -> STD 70, ELITE -> ELITE 85, BOSS -> BOSS 120). Retail's
own BaseLevel is NOT copied into `level` — it is recorded in the header comment only.
That is deliberate and is the same rule every other som template follows.

### The nine droids

Copy `custom_content/som/cww8_battle_droid.lua` as the base for all nine and change only
what the table below names. Keep its `resists = {0,0,0,0,0,0,0,-1,-1}`, its
`meatType/hideType/boneType` empty strings and zero amounts, `milk = 0`,
`tamingChance = 0`, `ferocity = 0`, `optionsBitmask = AIENABLED`,
`creatureBitmask = PACK + STALKER`, `conversationTemplate = ""`, `faction = ""`.

| file / creature name | customName | rung | mobType | socialGroup | armor | templates iff | scale |
|---|---|---|---|---|---|---|---|
| som_orf_ancient_security_drone | an Old Republic security drone | STD 70 | MOB_ANDROID | orf_security | 0 | object/mobile/som/cww8_battle_droid.iff | 0.8 |
| som_orf_ancient_patrol_drone | an Old Republic patrol drone | STD 70 | MOB_ANDROID | orf_security | 0 | object/mobile/som/cww8_battle_droid.iff | 0.8 |
| som_orf_ancient_sentinel_droid | an Old Republic sentinel droid | STD 70 | MOB_ANDROID | orf_security | 0 | object/mobile/som/cww8a_battle_droid.iff | 0.8 |
| som_orf_ancient_guard_droid | an Old Republic guard droid | ELITE 85 | MOB_ANDROID | orf_security | 1 | object/mobile/som/cww8a_battle_droid.iff | 0.8 |
| som_decrepit_battle_droid | a decrepit battle droid | ELITE 85 | MOB_ANDROID | droid_army | 1 | object/mobile/death_watch_battle_droid.iff | — |
| som_decrepit_super_battle_droid | a decrepit super battle droid | BOSS 120 | MOB_ANDROID | droid_army | 2 | object/mobile/death_watch_s_battle_droid.iff | — |
| som_decrepit_cww8_combat_droid | a decrepit CWW8 combat droid | BOSS 120 | MOB_ANDROID | droid_army | 2 | object/mobile/som/cww8a_battle_droid.iff | — |
| som_decrepit_blastromech | a decrepit blastromech | ELITE 85 | MOB_DROID | droid_army | 1 | object/mobile/blastromech.iff | — |
| som_decrepit_patrol_bot | a decrepit patrol bot | ELITE 85 | MOB_DROID | droid_army | 1 | object/mobile/som/asn_121.iff | — |

`scale` column "—" means do not add a `scale` line at all. Where a value is given, add
`scale = 0.8,` immediately after the `armor` line. Retail carries minScale=maxScale=0.8
for the four ORF drones.

**`diet = NONE` on all nine.** Not `HERBIVORE`. `union_sentry_droid.lua` is the one som
droid that has this right; a droid does not eat plants, and `diet` feeds
`CreatureImplementation.cpp:199` (harvest gating) and `DnaManager.cpp:217,386` (BE DNA
dependability).

**Weapons.** All nine keep the `cww8_battle_droid` weapon block:

    primaryWeapon = "ranged_weapons",
    secondaryWeapon = "none",
    primaryAttacks = merge(marksmanmaster,pistoleermaster),
    secondaryAttacks = pistoleermaster

EXCEPT `som_decrepit_super_battle_droid`, which is the heavy and uses
`cww8a_eradicator.lua`'s block instead:

    primaryWeapon = "imperial_weapons_heavy",
    secondaryWeapon = "none",
    primaryAttacks = merge(marksmanmaster,commandomaster),
    secondaryAttacks = commandomaster

Do NOT use bare `weapons = {...}` or `attacks = ...`. `CreatureTemplate.cpp:191-233`
reads only primaryWeapon / secondaryWeapon / thrownWeapon / primaryAttacks /
secondaryAttacks / defaultWeapon / defaultAttack. Bare `weapons` and `attacks` are dead
fields and a mob carrying only those spawns unarmed.

**pvpBitmask.** The four `orf_security` droids get
`pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY` (matching `union_sentry_droid.lua` — a
facility's security does not wait to be hit first, and retail gives them aggressive=24).
The five `droid_army` droids get `pvpBitmask = ATTACKABLE`.

**lootGroups.** All nine keep cww8_battle_droid's block verbatim:

    lootGroups = {
        {
            groups = {
                {group = "technician_tier_1", chance = 7000000},
                {group = "junk", chance = 3000000}
            }
        }
    },

### The three fleas

Copy `custom_content/som/lava_flea.lua`. Keep its
`resists = {130,130,-1,160,160,160,-1,-1,-1}`, `armor = 1`,
`primaryAttacks = { {"creatureareaattack",""} }`, `secondaryAttacks = { }`,
`primaryWeapon = "unarmed"`, `secondaryWeapon = "none"`, `lootGroups = {}`,
`creatureBitmask = PACK + STALKER`, `pvpBitmask = ATTACKABLE`.

DELETE the `controlDeviceTemplate` line — these are dungeon spawns, not tameable pets —
and set `tamingChance = 0`.

| file / creature name | customName | rung | socialGroup | scale | meatAmount | hideAmount |
|---|---|---|---|---|---|---|
| som_orf_flea_hatchling | an ORF flea hatchling | STD 70 | orf_flea | 0.3 | 20 | 29 |
| som_orf_flea_juvenile | a juvenile ORF flea | STD 70 | orf_flea | 0.4 | 20 | 30 |
| som_orf_flea_starving | a starving ORF flea | STD 70 | orf_flea | 0.5 | 20 | 33 |

`mobType = MOB_CARNIVORE`, `diet = CARNIVORE` on all three (retail niche=carnivore;
these are the two fields that must agree). `meatType = "meat_insect"`,
`hideType = "hide_scaley"`, `boneType = ""`, `boneAmount = 0`. Add `scale = <value>,`
immediately after the `armor` line.

The three scales are the whole point of splitting the life stages — the substitution
collapsed hatchling, juvenile and starving onto one `lava_flea` and they all rendered
identical. Retail gives 0.3 / 0.4 / 0.5.

### The three beetles

Copy `custom_content/som/kubaza_beetle.lua`. Keep its
`resists = {5,5,5,30,-1,30,-1,-1,-1}`, `armor` as found, `lootGroups = {}`,
`primaryWeapon = "unarmed"`. DELETE `controlDeviceTemplate` and set `tamingChance = 0`.

| file / creature name | customName | rung | socialGroup | meatAmount | hideAmount | primaryAttacks |
|---|---|---|---|---|---|---|
| som_orf_beetle_hatchling | an ORF beetle hatchling | STD 70 | orf_beetle | 21 | 28 | `{ {"creatureareaattack",""} }` |
| som_orf_beetle_worker | an ORF worker beetle | STD 70 | orf_beetle | 21 | 29 | `{ {"creatureareaattack",""} }` |
| som_orf_beetle_soldier | an ORF soldier beetle | STD 70 | orf_beetle | 21 | 32 | `{ {"stunattack",""}, {"intimidationattack",""} }` |

`mobType = MOB_CARNIVORE`, `diet = CARNIVORE` on all three.
`meatType = "meat_insect"`, `hideType = "hide_scaley"`, `boneType = ""`, `boneAmount = 0`.
`templates = {"object/mobile/som/kubaza_beetle.iff"}` on all three (the tree ships no
separate worker/soldier art — kubaza_beetle, kubaza_worker_beetle and
kubaza_soldier_beetle all already share this one appearance). No `scale` line.

### The two ORF bosses

| file / creature name | copy from | customName | rung | socialGroup | mobType | diet |
|---|---|---|---|---|---|---|
| som_orf_ancient_tulrus | orf_tulrus.lua | an Ancient Tulrus | BOSS 120 | orf_tulrus | MOB_HERBIVORE | HERBIVORE |
| som_orf_ancient_xandank | orf_xandank.lua | an Ancient Xandank | BOSS 120 | orf_xandank | MOB_CARNIVORE | CARNIVORE |

Keep each anchor's `resists`, `meatType`/`hideType`/`boneType` and amounts,
`primaryAttacks`, `lootGroups = {}`, `primaryWeapon = "unarmed"`. Override `armor = 2`
(the BOSS rung). No `scale` line.

Note `som_orf_ancient_tulrus` keeps `MOB_HERBIVORE` + `diet = HERBIVORE` to match its
family anchor `orf_tulrus.lua`, even though retail's niche column says carnivore. The
family convention wins — one divergent template would read as a mistake. Say so in the
header.

### Header comment on every one of the seventeen

Three to six lines at the top of each file, before the `= Creature:new {`. State:

1. The retail row, verbatim values: `creatures.tab` BaseLevel, difficultyClass,
   socialGroup, template, and lootTable if the row has one.
2. Which rung it was placed on and why (`retail difficultyClass X maps to the <RUNG>
   row`), and explicitly that retail's BaseLevel is recorded and NOT copied into `level`.
3. Which file it was copied from.
4. Anything divergent from retail, with the reason — the tulrus niche note, the shared
   beetle art, the deleted controlDeviceTemplate.

Also record once, in `som_orf_ancient_security_drone.lua`, that retail carries
`attackSpeed = 2` for all seventeen and that it is deliberately NOT transcribed: no
template anywhere in this tree's 9224 mobiles sets `attackSpeed`, so the engine default
`3.5 - level/100` (`AiAgentImplementation.cpp`) applies, and setting it on Mustafar alone
would make it the only planet with an authored attack speed.

ASCII ONLY. No non-ASCII bytes in any new file. Use `--` for dashes, plain quotes.
Tabs for indentation inside the table, matching the anchors exactly.

## PART 2 — register all seventeen

Add seventeen `includeFile` lines to
`MMOCoreORB/bin/scripts/mobile/custom_content/som/serverobjects.lua`, each of the form

    includeFile("custom_content/som/<name>.lua")

dropped into their alphabetical position inside the `--Mustafar (som)` block (which runs
from about :23 to about :246). The prefix is always `custom_content/som/` — never a bare
`som/`; the header comment at :3-18 of that file is about four lines that were broken
exactly that way.

The file currently has 210 `includeFile` lines. After this it must have 227.

## PART 3 — rewire the substitutes table

In `MMOCoreORB/bin/scripts/screenplays/mustafar/mustafar_dungeon_population.lua`, replace
the `substitutes` table (about :247-290) so every one of the seventeen keys maps to
**itself**:

    substitutes = {
        som_orf_ancient_security_drone = "som_orf_ancient_security_drone",
        ...
    },

Keep the table rather than deleting it, and keep the lookup code that reads it unchanged
— `historian.lua` asks for creatures by live name through this table, and leaving the
table in place with identity mappings means no call site changes and the table stays as
the one documented place a future substitution could be reintroduced.

Replace the table's `--[[ ]]` preamble (about :247-260) with a short block saying: every
one of the seventeen now has its own template in `mobile/custom_content/som/`; the
mapping is identity; the seventeen-onto-fifteen collapse is retired, and with it the
three flea stages sharing one body and the two patrol droids sharing `asn_121`.

## PART 4 — correct the two false header claims

In the same file's header block (`--[[` at :1, `--]]` at :237):

**a.** Replace the "THE TEMPLATES ARE SUBSTITUTED -- every single one" section (about
:39-55) with a section titled `THE TEMPLATES ARE THIS TREE'S OWN` that says:

- Every one of the seventeen names is defined in retail's
  `sys.server/compiled/game/datatables/mob/creatures.tab` at BaseLevel 80-87. Give the
  seventeen names with their retail BaseLevel and difficultyClass.
- The earlier "CHECKED absence" was checked against the client TRE set and this repo and
  never against the retail server datatable, which is where creature definitions actually
  live.
- The seventeen are now authored as their own templates on the tree's STD 70 / ELITE 85 /
  BOSS 120 rungs, mapped from retail's difficultyClass.
- The "all fifteen substitute templates are level 70" line was also wrong — the fifteen
  ran 50, 70 and 85. Give the count (5 at 70, 7 at 85, 3 at 50). So the "consistent
  difficulty band" that sentence claimed the substitution bought never existed; the band
  is consistent now, for the first time.

Add this line, or something close to it, in your own words:

    An absence is only evidence once you know you have read the whole list.

**b.** Anywhere else in the header that says the templates are substituted, or names a
substitute template, correct it to match. Search the whole header for "substitut" and
fix every hit.

**c.** Do NOT touch the header's PROPS COST section, the AXIS MAPPING, RESPAWN, the
patrol-path section, the cell-typo section, or the kill-counter section. Only the
substitution claims.

## Self-correction

If any line number in this spec does not match what you find, **the string match wins and
this spec's line numbers are wrong.** Report every such case at the end of your run.

If any file named here does not exist, or an anchor field differs from what this spec
quotes, STOP that item, leave it undone, and report it. Do not guess a replacement value.

## When you are done, report

1. The seventeen files created, with each one's final `level`, `mobType`, `diet`,
   `socialGroup`, `armor` and `scale`.
2. The `includeFile` count in serverobjects.lua before and after.
3. Every line number in this spec that turned out to be wrong.
4. Anything you could not do, and why.
