# Round F1(a) — the ten Droid Army creature templates

Repo root: `C:\stardust-3-space-port\server`   Branch: `mustafar-content`
**Do not commit. Do not run git. Leave the working tree dirty.**
**Create exactly the 10 new files listed. Edit exactly one existing file (`serverobjects.lua`).
Touch nothing else.** Files under `mobile/` are TAB-indented — match the siblings exactly.

---

## What this is

The Valley Battlefield (`mustafar_droid_army`) is live group content this port has never had.
Every tangible for it is already registered in
`object/custom_content/tangible/dungeon/mustafar/valley_battlefield/` — the bunkers, the fences,
the power generator, the demo packs. **Not one creature is.** This round adds the roster only.
The screenplay that spawns them is a separate round.

The live roster is read out of the original SOE server source at
`C:\swg-extract\_dsrc-full\...\datatables\mob\creatures.tab` lines 4605-4615, digested in
`scratch/LIVE-VALLEY.md` §3.9. Ten templates are needed.

---

## The two rules that make every value below checkable

**RULE 1 — TIER, NOT LEVEL.** Do not copy live's `level`. This tree runs the retune ladder from
commit `189d4f1622` (CIV 45 · FAUNA_L 50 · STD 70 · ELITE 85 · NAMED 100 · BOSS 120 · APEX 140 ·
RAID 200), where `level` is a *band selector* and every creature in a band shares one stat block.
Live's levels are 80-84 — four points of spread across three difficulty classes — which does not
survive transcription. Live's *ordering* does, and that is what is reproduced:

| live class | live level | this tree | anchor file to copy the stat block FROM |
|---|---|---|---|
| ELITE | 80-82 | **85** | `mobile/custom_content/som/asn_121.lua` |
| BOSS (wave mobs) | 82-83 | **100** | `mobile/custom_content/som/volcano_cyborg_lt.lua` |
| BOSS (the commander) | 84 | **120** | `mobile/custom_content/som/som_dark_jedi_boss.lua` |
| NORMAL (allies) | 80 | **70** | `mobile/custom_content/som/cww8_battle_droid.lua` |

The six numbers to lift from each anchor: `level`, `chanceHit`, `damageMin`, `damageMax`, `baseXp`,
`baseHAM`, `baseHAMmax`, `armor`. **Read them out of the anchor file — do not type them from this
spec.** If what you read disagrees with the table below, the anchor wins and say so in your reply.

For reference only, what those anchors currently hold:

```
85  ELITE   chanceHit 0.75   dmg 555/820    xp 8130    HAM 12000/15000   armor 1
100 NAMED   chanceHit 1      dmg 645/1000   xp 9429    HAM 24000/30000   armor 1
120 BOSS    chanceHit 4.0    dmg 745/1200   xp 11390   HAM 44000/54000   armor 2
70  STD     chanceHit 0.65   dmg 430/570    xp 6747    HAM 12000/15000   armor 0
```

**RULE 2 — COPY FROM THE SIBLING THAT ALREADY WEARS THE SAME MODEL.** For `mobType`,
`primaryWeapon`, `secondaryWeapon`, `primaryAttacks` and `secondaryAttacks`, copy the block verbatim
from whichever existing file in `mobile/custom_content/som/` already uses that same `templates`
entry. Live's weapon names (`droid_hk77_boss`, `droid_cww8_01`, …) are **not registered anywhere in
this tree** — checked, 0 hits — so they cannot be used and the sibling's weapon is the substitute.

| appearance | copy weapon/attacks/mobType from |
|---|---|
| `object/mobile/som/hk77.iff` | `hk77.lua` |
| `object/mobile/som/cww8_battle_droid.iff` | `cww8_battle_droid.lua` |
| `object/mobile/som/cww8a_battle_droid.iff` | `cww8a_battle_droid.lua` |
| `object/mobile/som/union_sentry_droid.iff` | `union_sentry_droid.lua` |
| `object/mobile/som/mustafarian_m_01.iff` | `mustafarian_miner_01.lua` |
| `object/mobile/probot.iff` | `must_mining_droid_mark_01.lua` |

All six appearance templates are registered — verified by direct grep. `probot.iff` registers at
`object/mobile/probot.lua:48`.

---

## LIVE DATA that IS transcribed exactly

**Resists.** `LIVE-VALLEY.md:612` — *"All droid-army rows share: … armor K75 E75 B100 H60 C100 El25
A40 S85."* In this tree's 9-slot order (kinetic, energy, blast, heat, cold, electricity, acid, stun,
lightsaber) that is, for **all seven droid-army templates**:

```
	resists = {75,75,100,60,100,25,40,85,-1},
```

This is deliberate and it is live's own design, not an accident: blast and cold read 100 (immune),
and **heat reads 60 — the lowest number on the row**. Every one of the six demolition charges the
battlefield hands the player is heat damage, and the valley ships a
`rare_heavy_oppressor_flame_thrower` as a ground pickup. Heat is the intended answer to this army.
Do not round the 100s down.

**socialGroup.** `LIVE-VALLEY.md:612` gives `socialGroup = droid_army` for every droid-army row and
`mustafar_miner` for the allies. Both transcribed as-is — that is what makes the army assist itself.

**Aggression.** `LIVE-VALLEY.md:604-610` lists an aggro/assist radius on **only two rows**: the
commander (24/9) and the elite guard (24/24). Every other droid-army row is blank. So:

- commander + elite guard → `pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY`
- squad leader, soldier, ak_1a, ak_3, gk_5 → `pvpBitmask = ATTACKABLE + ENEMY` (**not aggressive** —
  they are a marching column, not a roaming pack)
- the three allies → copy `pvpBitmask` and `creatureBitmask` verbatim from `mustafarian_miner_01.lua`

**creatureBitmask.** `PACK + STALKER` for the seven droid-army templates (the tree's own convention
at 82 of 161 som files, and correct here — this is literally a pack).

---

## AUTHORED, and flagged as authored

`customName`. Live's display names live in `mob/som.stf`, and **no `.stf` file ships in the
extract** — the subagent that read the source reported this explicitly, it is not an oversight. The
names below are derived from the live template name and the live script name attached to each row
(`forward_commander`, `assault_killer_bot`, `droid_squad_leader`, `droid_squad_member`,
`elite_guard`, `mining_squad_leader`, `mining_droid`). They are the one authored field in this
round and the file header must say so.

---

## THE TEN FILES

Directory: `MMOCoreORB/bin/scripts/mobile/custom_content/som/`

Every file follows the exact shape of `hk77.lua` — same field order, same tabs, closing with
`CreatureTemplates:addCreatureTemplate(<name>, "<name>")`. `faction = ""`, `meatType`/`hideType`/
`boneType` `= ""`, all the amounts `0`, `milk 0`, `tamingChance 0`, `ferocity 0`,
`optionsBitmask = AIENABLED`, `diet = HERBIVORE`, `conversationTemplate = ""`.

### The droid army — seven files, all `resists = {75,75,100,60,100,25,40,85,-1}`, `socialGroup = "droid_army"`

| # | file | customName | tier→level | appearance | pvpBitmask |
|---|---|---|---|---|---|
| 1 | `som_battlefield_commander.lua` | `a Droid Army Forward Commander` | BOSS **120** | `som/hk77.iff` | AGGRESSIVE + ATTACKABLE + ENEMY |
| 2 | `som_battlefield_elite_guard.lua` | `a Droid Army Elite Guard` | ELITE **85** | `som/hk77.iff` | AGGRESSIVE + ATTACKABLE + ENEMY |
| 3 | `som_battlefield_droid_squad_leader.lua` | `a Droid Army Squad Leader` | ELITE **85** | `som/hk77.iff` | ATTACKABLE + ENEMY |
| 4 | `som_battlefield_droid_soldier.lua` | `a Droid Army Soldier` | ELITE **85** | `som/hk77.iff` | ATTACKABLE + ENEMY |
| 5 | `som_battlefield_ak_1a.lua` | `an AK-1A Assault Killer Bot` | NAMED **100** | `som/cww8_battle_droid.iff` | ATTACKABLE + ENEMY |
| 6 | `som_battlefield_ak_3.lua` | `an AK-3 Assault Killer Bot` | NAMED **100** | `som/cww8a_battle_droid.iff` | ATTACKABLE + ENEMY |
| 7 | `som_battlefield_gk_5.lua` | `a GK-5 Assault Killer Bot` | NAMED **100** | `som/union_sentry_droid.iff` | ATTACKABLE + ENEMY |

**armor:** 2 on the commander (from the 120 anchor), 1 on the other six (from the 85/100 anchors).

**lootGroups.** Six of the seven take the droid loot block used by every other som droid in this
tree — copy it verbatim from `cww8_battle_droid.lua`:

```
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 7000000},
				{group = "junk", chance = 3000000}
			}
		}
	},
```

The **commander alone** gets the boss block — copy the shape from `hk77.lua`, which is the only
other hk77-model mob in the tree:

```
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 6000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
			lootChance = 7000000
		}
	},
```

Live points the commander at `mustafar_npc_loot_b.iff:forward_commander` at weight 10000 (100%).
**That leaf table is not in the extract** — the subagent checked and reported it absent — so its
contents cannot be known and the tree's own hk77 boss block stands in. Say this in the file header.
`technician_tier_1` is the only `technician_tier_*` group that exists in this repo (verified: 1 hit,
`loot/groups/npc/townsperson/technician_tier_1.lua:18`). Do not invent a tier 4 or 5.

### The allies — three files, `socialGroup = "mustafar_miner"`, STD **70**, `resists = {0,0,0,0,0,0,0,-1,-1}`, `armor = 0`

| # | file | customName | appearance | copy weapon+bitmask block from |
|---|---|---|---|---|
| 8 | `som_battlefield_miner.lua` | `a Mustafarian Miner` | `som/mustafarian_m_01.iff` | `mustafarian_miner_01.lua` |
| 9 | `som_battlefield_mining_leader.lua` | `a Mining Squad Leader` | `som/mustafarian_m_01.iff` | `mustafarian_miner_01.lua` |
| 10 | `som_battlefield_mining_droid.lua` | `a Mining Droid` | `object/mobile/probot.iff` | `must_mining_droid_mark_01.lua` |

lootGroups for all three: copy verbatim from the sibling named in the last column.

**Note on the allies' level.** Live has them at 80, one tier under the droid army's 80-84. This
tree's STD band is 70, one tier under its ELITE 85. The *relationship* is preserved, which is the
thing that matters — the miners are meant to lose. Put that sentence in each ally file's header.

### Foreman Koseyet — DO NOT CREATE

`mobile/custom_content/som/battlefield_foreman.lua` already exists and is already the Koseyet mob
(`customName = "Battlefield Foreman"`, `templates = {"object/mobile/som/battlefield_foreman.iff"}`).
**Do not add an eleventh file and do not edit that one.** Its empty `conversationTemplate` is a real
gap but it belongs to the screenplay round, not this one.

---

## The one existing file to edit

`MMOCoreORB/bin/scripts/mobile/custom_content/som/serverobjects.lua`

Add ten `includeFile(...)` lines, one per new file, in the **alphabetical block** where the other
`som_*` and `s*` entries sit — match the surrounding ordering exactly, do not append to the end and
do not touch the `--Root Folder` block at the bottom. Form:

```
includeFile("custom_content/som/som_battlefield_ak_1a.lua")
```

---

## File headers

Every one of the ten files opens with a short comment block, in the voice of the existing headers in
this directory (see `cww8_battle_droid.lua` and `som_dark_jedi_boss.lua` for the register). It must
state, in plain sentences:

1. what the creature is and where it appears (the Valley Battlefield, `mustafar_droid_army`);
2. its live row — name, level, difficulty class — and the fact that the level here is the tree's
   tier ladder rather than live's number, with the anchor file named;
3. which field is transcribed from live (`resists`, `socialGroup`, aggression) and which is
   substituted (weapon, attacks) and why;
4. for all ten: that `customName` is authored because no `.stf` ships in the extract;
5. for the commander only: that its live loot table `mustafar_npc_loot_b:forward_commander` is
   absent from the extract.

Do not pad. Three to eight lines each is right.

---

## Definition of done

10 new files, 10 new lines in one existing file, nothing else changed.
Reply with: the 10 filenames, the stat line (`level / chanceHit / damageMin / damageMax / baseHAM`)
you actually read out of each anchor, and the 10 serverobjects lines in the order you inserted them.
If any anchor file disagrees with this spec, say which and what it actually said.
