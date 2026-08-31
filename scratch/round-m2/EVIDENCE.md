# Round M2 — evidence, gathered firsthand by the orchestrator

Every number below was produced by a script in `C:\swg-extract\` and its output read
directly. Nothing here is a subagent summary.

## 1. `static_item_n.stf` SHIPS. It was never missing.

    /mnt/c/swg-extract/_som/stf/string/en/static_item_n.stf   1,052,886 bytes
    from stardust_03.tre        keys=9754  values=9754

Nine Mustafar quest files assert the opposite, three of them in so many words:
*"There is no string/en/static_item_n.stf in _som to look it up in."*

That is **"not in my extract" written as "not shipped"** — the same failure mode as
`tre-index-is-blind-to-patch-023`. `trophy_hunts.lua:106` already had it right:
*"the display name is the string/en/static_item_n.stf row."*

## 2. Every reward token under `screenplays/mustafar/` resolves

`_m2_resolve.py` walked the whole directory, pulled every `(item|weapon|armor)_tow_*`
token with its file:line, and joined against the STF key table. **20 distinct real
tokens; all 20 resolve.** (Three further "tokens" — `armor_tow_helmet_acc`,
`armor_tow_helmet_acc_`, `item_tow_buff_crystal` — are regex artifacts caught from
prose lines at `historian.lua:118,120`, `samaritan.lua:139`, `serpent_shard.lua:85`.
They are not real names and are not part of this round.)

    item_tow_buff_crystal_02_01         Wild Force Shard
    item_tow_buff_crystal_02_02         Wild Force Shard
    item_tow_buff_crystal_02_03         Shard of the Serpent
    item_tow_clothing_03_02             Mustafarian Mining Suit
    item_tow_clothing_03_03             Mustafarian Miner's Boots
    item_tow_gloves_microsensory_02_01  Microsensory Mesh Gloves
    item_tow_holocron_ab_immune_02_01   Sith Holocron
    item_tow_necklace_03_01             Miners Medallion
    item_tow_painting_02_01             Map of Mustafar
    item_tow_proc_generic_03_01         Mustafarian Injector
    item_tow_proc_ranged_03_01          Mustafarian Distance Globe
    item_tow_schematic_reactor_02_01    Modified Fusion Reactor Schematic
    item_tow_trophey_02_01              Mounted Kubaza Beetle Head
    item_tow_trophey_02_02              Mounted Tulrus Spine
    item_tow_trophey_02_03              Mounted Xandank Head
    item_tow_trophey_02_04              Jundak Skull
    item_tow_trophey_02_06              Blistmok Skin Rug
    weapon_tow_pistol_02_01             Mustafarian Modified Disruptor Pistol
    weapon_tow_rifle_03_01              DP-23 Rifle
    weapon_tow_sword_1h_03_02           Caller of Storms

## 3. A display name is NOT an object template — the exhaustive sweep

`_m2_sweep.py` extracted and searched **all 31,074 `object/**/shared_*.iff` templates
in every TRE** for each of the 20 keys as an `objectName`. This is exhaustive, not a
sample. **Six keys have a shipped object. Fourteen have none.**

    HIT  item_tow_trophey_02_01   object/tangible/loot/mustafar/shared_trophey_lava_beetle.iff        [mtg_patch_019]
    HIT  item_tow_trophey_02_03   object/tangible/loot/mustafar/shared_trophey_xandank.iff            [mtg_patch_019]
    HIT  item_tow_trophey_02_04   object/tangible/loot/mustafar/shared_bones_must_monster_jaw_small.iff [mtg_patch_019]
    HIT  item_tow_trophey_02_06   object/tangible/loot/mustafar/shared_trophey_blistmok_skin.iff      [mtg_patch_022]
    HIT  weapon_tow_pistol_02_01  object/tangible/collection/shared_rare_pistol_mustafarian_modified_disruptor.iff [mtg_patch_021]
    HIT  weapon_tow_sword_1h_03_02 object/tangible/collection/shared_rare_melee_caller_storms.iff     [mtg_patch_021]

`_02_03`, `_02_04` and `_02_06` are the three `trophy_hunts.lua:102-118` already
resolved. The other three are new.

So for the **fourteen** unhit keys the existing "NOT granted / substituted"
conclusion is **CORRECT**. Only the stated reason is wrong.

## 4. The objectName records, read out of the shipped templates

Confirms the sweep by a second route, and kills a hypothesis I had held:

    shared_trophey_lava_beetle.iff        objectName = static_item_n : item_tow_trophey_02_01   <- EXACT
    shared_trophey_xandank.iff            objectName = static_item_n : item_tow_trophey_02_03
    shared_trophey_blistmok_skin.iff      objectName = static_item_n : item_tow_trophey_02_06
    shared_bones_must_monster_jaw_small.iff objectName = static_item_n : item_tow_trophey_02_04
    shared_trophey_lava_flea.iff          objectName = static_item_n : trophey_lava_flea        <- key NOT in the stf
    shared_trophey_lava_lizard_heart.iff  objectName = som/som_item  : trophey_lava_lizard_heart_n <- key NOT in som_item.stf
    shared_trophey_tulrus_spine.iff       objectName = <EMPTY TABLE> : trophey_tulrus_spine_n   <- unresolvable

**`trophey_tulrus_spine` is NOT `item_tow_trophey_02_02`.** Its `objectName` record
carries an empty string table (chunk length 0x26 = 38 bytes: 11 for the field name,
1 null for the absent table, 23 for the key, vs. lava_lizard_heart's 0x37 = 55 which
does carry `som/som_item`). No shipped STF anywhere holds `trophey_tulrus_spine_n` —
`som_item.stf` ships (mtg_patch_019 and mtg_planets) and does not contain it. That
template has **no resolvable display name at all**.

I had hypothesised tulrus_spine would resolve. It does not. `maneater.lua` stays a
substitution and now has proof of why, instead of a wrong reason.

## 5. The two new hits are display tangibles, NOT functional weapons

    rare_pistol_mustafarian_modified_disruptor.lua:2-4   SharedTangibleObjectTemplate, gameObjectType = 8211
    rare_melee_caller_storms.lua:2-4                     SharedTangibleObjectTemplate, gameObjectType = 8211

No `minDamage`, no `maxDamage`, no `attackSpeed`, no `xpType`, no cert. Both are
registered (`addTemplate` + `serverobjects.lua:404` and `:336`).

`som_poison_miners.lua` currently grants a **functional** `pistol_dl44.iff`;
`symbiosis.lua` currently grants a **functional** `som_sword_obsidian.iff`. Swapping
either for the exact-named collection object trades a usable weapon for an
unequippable display piece. **That is a gameplay ruling, not a wiring fix — it is
Aaron's call and this round does not make it.**
