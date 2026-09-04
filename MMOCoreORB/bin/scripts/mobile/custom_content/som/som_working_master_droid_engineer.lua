--[[ som_working_master_droid_engineer -- Master Droid Engineer, Working Droid
     Factory trial boss. Live record: creatures.tab BaseLevel 84 /
     difficultyClass BOSS / HP 385225 (runtime from trial.java, header only --
     Core3 has no matching HAM column; the tier ladder's baseHAM governs) /
     where mustafar / socialGroup droid_army / pvpFaction droid_army /
     template ev_9d9.iff / intLootRolls 1 / intRollPercent 80 / lootTable BLANK /
     niche android / primary_weapon pirate_carbine / primary_weapon_specials
     droid_5 / aggressive 6 / assist 9 / death_blow instant.

     TIER: BOSS 120. Live level 84 / difficultyClass BOSS maps to the BOSS 120
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same row
     som_working_doom_bringer already uses. Stat row taken whole from that
     ladder. Live's own armour columns are NOT used -- the ladder is applied
     whole.

     SOURCED:
       customName "Master Droid Engineer" -- live English name.
       socialGroup "droid_army" -- live.
       templates {"object/mobile/ev_9d9.iff"} -- live. No scale, no hues.
       creatureBitmask KILLER -- live death_blow = instant.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 9.
       lootGroups {} -- live intLootRolls 1 / intRollPercent 80 with a blank
         lootTable. Empty here is live's data, not an omission.
         master_droid_loot belongs to som_working_super_repair_droid
         (creatures.tab lootTable mustafar/mustafar_trial_engineer), which
         already ships; it is NOT re-pointed at the MDE.
       primaryWeapon = "pirate_carbine" -- live primary_weapon pirate_carbine
         resolves to the registered pirate_carbine group
         (mobile/weapon/serverobjects.lua). Field is primaryWeapon /
         primaryAttacks because CreatureTemplate.cpp:191-233 reads only
         those; the earlier weapons / attacks form was dead and left this
         boss spawning unarmed.

     No specials authored beyond the weapon-group merge above. Live's droid_5
     row (ai_combat_profiles.tab:181) carries no actions at all -- only the
     profile_id -- so there is nothing to port. Empty here is live's data, not
     an omission. This matches what som_working_hk_58_aurek.lua and
     som_working_doom_bringer.lua already record for droid_special_6
     (ai_combat_profiles.tab:188), which is empty in the same way.
     CORRECTED IN H(h3): the previous wording, "not ported as named specials
     this round", read as deferred work. It was not deferred; there was never
     anything in the row. ]]
som_working_master_droid_engineer = Creature:new {
	customName = "Master Droid Engineer",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_DROID,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/ev_9d9.iff"},
	lootGroups = {},
	primaryWeapon = "pirate_carbine",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(pistoleermaster,carbineermaster,marksmanmaster),
	secondaryAttacks = carbineermaster
}

CreatureTemplates:addCreatureTemplate(som_working_master_droid_engineer, "som_working_master_droid_engineer")
