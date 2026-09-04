# ROUND H(h2) -- mechanics conformance for custom_content/som

Two mechanical defects, both confirmed by direct read of the engine source and
both already diagnosed once in this very folder. Nothing here is a judgement
call; every change is a field-name or field-value correction.

Do NOT touch these files under any circumstance:
obi_wan_ghost.lua, surveyor_jo.lua, serverobjects.lua, jo_kelsev_conv_handler.lua,
som_working_super_repair_droid.lua.

Do not commit. Do not run git.

If a line number below does not match what you find, THE STRING MATCH WINS and
this spec's line number is wrong. Report it in your summary.

---

## PART 1 -- 59 diet/mobType mismatches

`diet` is not decoration. It drives two systems:
  * CreatureImplementation.cpp:199 -- corpse harvest gating; `diet == NONE` blocks
    harvesting entirely.
  * DnaManager.cpp:217,386 -- bio-engineer DNA dependability, via
    Genetics::dietToValue.

The correct pairing, from this tree's own correct examples
(union_sentry_droid.lua is the one som droid that already has it right):

    MOB_DROID     -> diet = NONE
    MOB_ANDROID   -> diet = NONE
    MOB_CARNIVORE -> diet = CARNIVORE
    MOB_HERBIVORE -> diet = HERBIVORE

Stock content gets this right with zero mismatches (dathomir 136/137 set diet,
endor 280/281, lok 138/139). som has 59 wrong.

I checked before ordering this: of the 36 droids moving to `diet = NONE`,
ZERO carry a non-zero meatAmount, hideAmount, boneAmount or milk. So setting
NONE removes no live harvest from any of them. That check is why this is safe.

### The edit

In each file below, find the field line inside the `Creature:new {` table. It is
tab-indented and comma-terminated, exactly:

    	diet = HERBIVORE,

Replace ONLY that line with the tab-indented, comma-terminated correct value:

    	diet = NONE,          (for MOB_DROID and MOB_ANDROID)
    	diet = CARNIVORE,     (for MOB_CARNIVORE)

CRITICAL: several of these files also mention `diet` inside the `--[[ ... ]]`
header comment. Do NOT edit the header comment text. Change ONLY the tab-indented
field line inside the table. If a header comment now states the old diet and that
makes it wrong, fix that sentence too -- but as a comment edit, separately, and
only where the comment actually asserts the wrong value.

Change nothing else in these files. No reformatting, no reordering, no stat edits.

All paths are relative to:
  MMOCoreORB/bin/scripts/mobile/custom_content/som/

| file (add .lua)                        | mobType       | has       | set to    |
|----------------------------------------|---------------|-----------|-----------|
| asn_121                                | MOB_DROID     | HERBIVORE | NONE      |
| blistmok                               | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| blistmok_shrieker                      | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| blistmok_trampler                      | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| cinderclaw                             | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| cww8_battle_droid                      | MOB_ANDROID   | HERBIVORE | NONE      |
| cww8a_battle_droid                     | MOB_ANDROID   | HERBIVORE | NONE      |
| cww8a_eradicator                       | MOB_DROID     | HERBIVORE | NONE      |
| deathsting                             | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| droid_8t88                             | MOB_ANDROID   | HERBIVORE | NONE      |
| hk47                                   | MOB_ANDROID   | HERBIVORE | NONE      |
| hk77                                   | MOB_ANDROID   | HERBIVORE | NONE      |
| ig106                                  | MOB_ANDROID   | HERBIVORE | NONE      |
| jundak                                 | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| jundak_devourer                        | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| kubaza_beetle                          | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| kubaza_soldier_beetle                  | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| kubaza_worker_beetle                   | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| must_mining_droid_mark_01              | MOB_DROID     | HERBIVORE | NONE      |
| must_mining_droid_mark_02              | MOB_DROID     | HERBIVORE | NONE      |
| must_mining_droid_mark_03              | MOB_DROID     | HERBIVORE | NONE      |
| orf_angler                             | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| orf_jundak                             | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| orf_reptilian_flier                    | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| orf_vesp                               | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| orf_xandank                            | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| scorching_terror                       | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| sher_kar                               | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| som_ancient_jundak                     | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| som_battlefield_ak_1a                  | MOB_ANDROID   | HERBIVORE | NONE      |
| som_battlefield_ak_3                   | MOB_ANDROID   | HERBIVORE | NONE      |
| som_battlefield_commander              | MOB_ANDROID   | HERBIVORE | NONE      |
| som_battlefield_droid_soldier          | MOB_ANDROID   | HERBIVORE | NONE      |
| som_battlefield_droid_squad_leader     | MOB_ANDROID   | HERBIVORE | NONE      |
| som_battlefield_elite_guard            | MOB_ANDROID   | HERBIVORE | NONE      |
| som_battlefield_gk_5                   | MOB_DROID     | HERBIVORE | NONE      |
| som_battlefield_mining_droid           | MOB_DROID     | HERBIVORE | NONE      |
| som_kenobi_blistmok                    | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| som_pann_protocol_droid                | MOB_DROID     | HERBIVORE | NONE      |
| som_volcano_final_hk47                 | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_final_risen_sustainer      | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_final_septipod             | MOB_DROID     | HERBIVORE | NONE      |
| som_volcano_final_squadleader          | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_final_squadmember          | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_final_walker               | MOB_DROID     | HERBIVORE | NONE      |
| som_volcano_five_boss_septipod         | MOB_DROID     | HERBIVORE | NONE      |
| som_volcano_five_midguard              | MOB_DROID     | HERBIVORE | NONE      |
| som_volcano_five_septipod              | MOB_DROID     | HERBIVORE | NONE      |
| som_volcano_one_sustainer              | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_one_taskmaster             | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_three_forward_commander    | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_three_hk77                 | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_three_risen_commander      | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_two_ak_prime               | MOB_ANDROID   | HERBIVORE | NONE      |
| som_volcano_two_hk77                   | MOB_ANDROID   | HERBIVORE | NONE      |
| trained_blistmok                       | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| xandank                                | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| xandank_onyx_plated                    | MOB_CARNIVORE | HERBIVORE | CARNIVORE |
| xandank_patriarch                      | MOB_CARNIVORE | HERBIVORE | CARNIVORE |

That is 59 files. Count them when you are done and state the number.

---

## PART 2 -- two level-120 bosses that spawn unarmed

CreatureTemplate::readObject() (MMOCoreORB/src/server/zone/objects/creature/ai/
CreatureTemplate.cpp:191-233) reads ONLY these weapon fields:

    primaryWeapon, secondaryWeapon, thrownWeapon, primaryAttacks, secondaryAttacks

and, for the droid schema (:138,143):

    defaultWeapon, defaultAttack

A bare `weapons = {...}` and a bare `attacks = ...` are DEAD FIELDS. They are
never read. A mob carrying only those spawns with no weapon and no attacks.

This exact bug was already diagnosed in this folder. union_sentry_droid.lua:9-13
says so verbatim: "The previous `weapons` and `attacks` fields were dead --
CreatureTemplate::readObject() never reads them -- so this mob was spawning
unarmed." The fix was never applied to these two.

Both are MOB_DROID. `primaryWeapon` taking a registered weapon-group name is the
dominant schema for MOB_DROID in this tree (77 of 115 MOB_DROID templates use it),
so that is the form to use -- not defaultWeapon, which takes an .iff path.

Both weapon groups are confirmed registered via addWeapon():
  mobile/weapon/groups/battle_droid_weapons.lua:6
  mobile/weapon/groups/pirate_carbine.lua:7

### 2a. som_decrepit_colonel_or5.lua

Around :79-81 the body currently reads:

	weapons = {"battle_droid_weapons"},
	conversationTemplate = "",
	attacks = merge(pistoleermaster,carbineermaster,marksmanmaster)

Replace those three lines with:

	primaryWeapon = "battle_droid_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(pistoleermaster,carbineermaster,marksmanmaster),
	secondaryAttacks = marksmanmaster

(secondaryAttacks takes one term from the merge, matching the pattern in
som_decrepit_battle_droid.lua:48-49 and som_decrepit_cww8_combat_droid.lua:48-49.
marksmanmaster is the term that matches a battle-droid ranged group.)

### 2b. som_working_master_droid_engineer.lua

Around :67-69 the body currently reads:

	weapons = {"pirate_carbine"},
	conversationTemplate = "",
	attacks = merge(pistoleermaster,carbineermaster,marksmanmaster)

Replace those three lines with:

	primaryWeapon = "pirate_carbine",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(pistoleermaster,carbineermaster,marksmanmaster),
	secondaryAttacks = carbineermaster

(carbineermaster, because the weapon group is a carbine group.)

### 2c. the headers

Both files have a header comment that documents the weapon choice and cites
ep3_clone_relics_super_battle_droid_01.lua as the source of the form. That
citation is the reason the bug is here: the ep3 template uses the dead fields
too. Update each header so it:
  * still records the live primary_weapon value it came from, and
  * states that the field is primaryWeapon/primaryAttacks because
    CreatureTemplate.cpp:191-233 reads only those, and that the earlier
    `weapons`/`attacks` form was dead and left this boss spawning unarmed.
  * drops the ep3_clone_relics_super_battle_droid_01.lua citation as a model,
    since that template carries the same defect.

Keep the headers ASCII-only. No smart quotes, no em dashes, no ellipsis
characters. Use plain `--` and `...` if you need them.

---

## When you are done, report

1. The number of files you changed in PART 1 (expected 59).
2. Any file where the `	diet = HERBIVORE,` line was not found as specified.
3. Any header comment you also edited, and why.
4. Confirmation that PART 2 left zero `weapons =` or `attacks =` lines in
   custom_content/som/.
5. Anything you could not do.
