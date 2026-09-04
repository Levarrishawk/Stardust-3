# ROUND H(h3) — port the deferred AI specials profiles

Scope: 6 files, all in `MMOCoreORB/bin/scripts/mobile/custom_content/som/`.
This round changes `primaryAttacks` on 4 files and header comment text on 6.
It changes NO other field. Do not touch level, chanceHit, damageMin, damageMax,
baseXp, baseHAM, baseHAMmax, armor, resists, socialGroup, customName, templates,
hues, scale, lootGroups, pvpBitmask, creatureBitmask, optionsBitmask, mobType,
diet, meat*, hide*, bone*, milk, tamingChance, ferocity, primaryWeapon,
secondaryWeapon, secondaryAttacks, or conversationTemplate.

FENCED — do not open or edit these at all:
`obi_wan_ghost.lua`, `surveyor_jo.lua`, `serverobjects.lua`,
`jo_kelsev_conv_handler.lua`.

---

## WHY THIS ROUND EXISTS

Six som templates carry a header line saying a live AI specials profile was
"not ported this round". Those profiles have now been read. The table is
`C:\swg-extract\_dsrc-full\sku.0\sys.server\compiled\game\datatables\ai\ai_combat_profiles.tab`
(59 columns: `profile_id`, then `action1..action14` each with `_use_time`,
`_use_chance`, `_use_count`, then `knockdown_recovery_time`; 364 rows).
`creatures.tab` columns `primary_weapon_specials` / `secondary_weapon_specials`
name the row.

What the rows actually contain:

| profile | tab line | actions |
|---|---|---|
| `roach_5` | 258 | bm_bolster_armor_5 (once, t=2), bm_bite_5 (t=6), bm_enfeeble_5 (once, t=6), bm_enfeeble_5 (t=30) |
| `spider_5` | 308 | bm_defensive_5 (once, t=2), bm_damage_poison_5 (once, t=6), bm_damage_poison_5 (t=18), bm_puncture_3 (t=9) |
| `droid_5` | 181 | **none — the row is empty** |
| `droid_special_6` | 188 | **none — the row is empty** |
| `som_working_devistator` | 126 | devastating_strike (t=6, chance 100) |

## THE MAPPING METHOD — already established and committed in this tree

`som_link_lava_beetle_foreman.lua` records it verbatim. Do not invent a new one:

1. The profile's dominant action maps to the nearest Core3 creature command.
2. An action with no direct Core3 analogue is replaced by the shipped family's
   own verb, cited to the sibling file it is taken from.
3. Self-buffs are dropped, and the header says they were dropped.
4. The header labels the pairing a judgement, and states that what is *sourced*
   is only "a tier-N profile exists", not the specific Core3 verbs.

---

## PART 1 — `som_link_lava_beetle_soldier.lua`

This is the clearest item in the round: the soldier carries the **same
`roach_5` profile** as `som_link_lava_beetle_defender.lua` and
`som_link_lava_beetle_foreman.lua`, both of which already ship
`{ intimidationattack, creatureareaattack }` with that mapping written into
their headers. The soldier was left empty. Same profile, same family, two
different treatments — that is the defect.

**1a.** Find this line (it is `primaryAttacks = { },` inside the table, NOT in
the header comment):

```
	primaryAttacks = { },
```

Replace with:

```
	primaryAttacks = { {"intimidationattack",""}, {"creatureareaattack",""} },
```

**1b.** Find these two header lines:

```
     No specials authored. Live's roach_5 profile is not ported this round;
     say so here rather than invent actions. ]]
```

Replace with:

```
       primaryAttacks { intimidationattack, creatureareaattack }. Live specials
         come from AI profile roach_5 (ai_combat_profiles.tab:258) =
         bm_bolster_armor_5 (once), bm_bite_5, bm_enfeeble_5 x2 -- the same
         profile the foreman and the defender carry. This is their mapping,
         applied here for consistency rather than minting a second answer:
         bm_enfeeble_5 is the dominant action and maps to Core3's
         intimidationattack; bm_bite_5 has no direct Core3 creature-command
         analogue, so the shipped kubaza family's own creatureareaattack is used
         (kubaza_beetle.lua:35); bm_bolster_armor_5 is a self-buff with no Core3
         creature-command analogue and is dropped. The pairing is a judgement;
         what is sourced is "a tier-5 roach profile exists".
         CORRECTED IN H(h3): this file previously said the roach_5 profile was
         "not ported this round". That was wrong twice over -- the profile row
         was readable all along at ai_combat_profiles.tab:258, and the two
         siblings sharing it already shipped the mapping. ]]
```

---

## PART 2 — the three Sher Kar guards

Applies **identically** to all three files:
`som_sherkar_praetorian.lua`, `som_sherkar_karling.lua`, `som_sherkar_symbiot.lua`.

**2a.** In each file find (inside the table, not the header):

```
	primaryAttacks = { },
```

Replace with:

```
	primaryAttacks = { {"strongpoison",""}, {"creatureareaattack",""} },
```

**2b.** In each file find these two header lines:

```
     No specials authored. Live's spider_5 profile is not ported this round;
     say so here rather than invent actions. ]]
```

Replace with:

```
       primaryAttacks { strongpoison, creatureareaattack }. Live specials come
         from AI profile spider_5 (ai_combat_profiles.tab:308) =
         bm_defensive_5 (once), bm_damage_poison_5 x2, bm_puncture_3. Mapped by
         the method som_link_lava_beetle_foreman.lua already records.
         bm_damage_poison_5 is the dominant action -- two of the four slots --
         and maps to Core3 poison. The tier picks the strength: the shipped
         spider family runs mildpoison at level 8-27
         (dathomir/cavern_spider.lua, gaping_spider.lua), mediumpoison at 44-46
         (cavern_spider_hunter.lua, cavern_spider_queen.lua) and strongpoison
         from 31 up (dathomir/chasmal_spider.lua:level 31). These guards are
         level 85, and the live action is tier 5, so strongpoison.
         bm_puncture_3 has no direct Core3 creature-command analogue, so the
         family's own verb is used -- sher_kar.lua ships
         creatureareaattack + creatureareaknockdown, and these three carry the
         same sher_kar.iff body at scale 0.3. bm_defensive_5 is a self-buff
         with no Core3 creature-command analogue and is dropped.
         The pairing is a judgement; what is sourced is "a tier-5 spider
         profile exists".
         CORRECTED IN H(h3): this file previously said spider_5 was "not ported
         this round". The row was readable all along at
         ai_combat_profiles.tab:308. ]]
```

---

## PART 3 — `som_working_master_droid_engineer.lua` (header only, no stat change)

`droid_5` is an **empty row**. The old wording implied unfinished work; it was
actually already complete. Find:

```
     No specials authored beyond the weapon-group merge above. Live's droid_5
     profile is not ported as named specials this round. ]]
```

Replace with:

```
     No specials authored beyond the weapon-group merge above. Live's droid_5
     row (ai_combat_profiles.tab:181) carries no actions at all -- only the
     profile_id -- so there is nothing to port. Empty here is live's data, not
     an omission. This matches what som_working_hk_58_aurek.lua and
     som_working_doom_bringer.lua already record for droid_special_6
     (ai_combat_profiles.tab:188), which is empty in the same way.
     CORRECTED IN H(h3): the previous wording, "not ported as named specials
     this round", read as deferred work. It was not deferred; there was never
     anything in the row. ]]
```

---

## PART 4 — `som_working_devistator.lua` (header only, no stat change)

This one genuinely cannot be ported, and now says why instead of saying "not
this round". Find:

```
     No specials authored. Live's som_working_devistator specials profile is
     not ported this round; say so here rather than invent actions. ]]
```

Replace with:

```
     No specials authored, and this one is resolved rather than deferred. Live's
     profile is its own row, som_working_devistator
     (ai_combat_profiles.tab:126), and it carries exactly one action:
     devastating_strike, use_time 6, use_chance 100, use_count infinite. There
     is no Core3 command of that name -- MMOCoreORB/bin/scripts/commands/ has no
     devast* or *strike* entry -- and devastating_strike is not part of the bm_*
     creature-ability vocabulary the other Mustafar profiles draw on, so the
     tier-mapping method used for roach_5 and spider_5 has nothing to map onto.
     Inventing a Core3 verb here would be a guess with no sourced tier behind
     it, so none is authored. The Devistator is not left unable to fight: it
     carries defaultWeapon/defaultAttack under the droid schema
     (CreatureTemplate.cpp:138,143), which is what drives its combat.
     CORRECTED IN H(h3): the previous wording said "not ported this round",
     which read as deferred work. It is not deferrable -- there is no Core3
     command to port it to. ]]
```

---

## RULES

- The `]]` that closes each header comment must remain exactly one `]]`. Every
  replacement above already ends with it — do not add a second one.
- Keep the file ASCII-only. No smart quotes, no em-dashes, no ellipsis
  characters. Use `--` and `...` as literal ASCII.
- Header comment bodies are indented with SPACES (matching the surrounding
  header). Table fields are indented with a single TAB. Preserve exactly.
- Do not run git. Do not commit.
- If a string above does not match what you find in the file, STOP and report
  which file and which string. The string match wins; if the surrounding text
  differs from what this spec quotes, this spec is wrong, not the file.

## REPORT BACK

For each of the 6 files, one line: filename, whether the stat edit applied
(PART 1/2 only), whether the header edit applied. Then list any string that did
not match.
