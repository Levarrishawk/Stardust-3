--[[ som_sherkar_praetorian -- Sher Kar Praetorian, one of four guards
     monster_manager.java places in the Monster Lair. Live record:
     creatures.tab BaseLevel 85 / difficultyClass ELITE / HP 120000 (runtime from
     trial.java, header only -- Core3 has no matching HAM column; the tier
     ladder's baseHAM governs) / where mustafar / socialGroup sherkar /
     template som/sher_kar.iff / minScale 0.3 / maxScale 0.3 / hue 1 /
     intLootRolls 1 / intRollPercent 80 / lootTable BLANK / niche carnivore /
     meat 16 meat_insect / hide 24 hide_scaley / primary_weapon blank /
     primary_weapon_specials spider_5 / aggressive 6 / assist 6 /
     death_blow instant / script sher_kar.praetorian.

     TIER: ELITE 85. Live level 85 / difficultyClass ELITE maps to the ELITE 85
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same reading every
     prior Mustafar round took. Stat row taken whole from that ladder. Resists
     are R_BASE {0,0,0,0,0,0,0,-1,-1}.

     SOURCED:
       customName "Sher Kar Praetorian" -- live English name.
       socialGroup "sherkar" -- live.
       templates {"object/mobile/som/sher_kar.iff"}, hues { 1 }, scale 0.3 --
         live. Same sher_kar.iff body as the boss (scale 1.2); at 0.3 it reads
         as his brood, not a separate species. That is live's own data, not a
         choice.
       meat 16 meat_insect / hide 24 hide_scaley -- live; amounts match
         som_link_lava_beetle_defender.lua.
       primaryWeapon "unarmed" -- live primary_weapon blank.
       lootGroups {} -- live intLootRolls 1 / intRollPercent 80 with a blank
         lootTable; there is no group to name. Empty here is live's data, not
         an omission.
       creatureBitmask PACK + KILLER -- KILLER from live death_blow = instant;
         PACK because live calls ai_lib.establishAgroLink(guards[0], guards)
         and Core3 has no binding -- same substitution
         som_link_lava_beetle_defender.lua records.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 6.

     No specials authored. Live's spider_5 profile is not ported this round;
     say so here rather than invent actions. ]]
som_sherkar_praetorian = Creature:new {
	customName = "Sher Kar Praetorian",
	socialGroup = "sherkar",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "meat_insect",
	meatAmount = 16,
	hideType = "hide_scaley",
	hideAmount = 24,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/sher_kar.iff"},
	hues = { 1 },
	scale = 0.3,
	lootGroups = {},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_sherkar_praetorian, "som_sherkar_praetorian")
