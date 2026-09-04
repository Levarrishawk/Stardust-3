--[[ som_link_lava_beetle_defender -- Kubaza Beetle Defender, one of the four
     guards the Establish the Link trial's foreman_spawner places around the
     foreman. Live record: creatures.tab BaseLevel 80 / Damagelevelmodifier 4 /
     difficultyClass ELITE / where mustafar / socialGroup link_beetle / template
     som/kubaza_beetle.iff / minScale 1.5 / maxScale 1.5 / hue 1 / armorStun -1
     (all other armour 0) / attackSpeed 2 / hasResources 1 / meat 16 meat_insect /
     hide 24 hide_scaley / geneProfile defaultProfile / intLootRolls 1 /
     intRollPercent 80 / lootTable BLANK / niche carnivore / rootImmune 75 /
     snareImmune 75 / primary_weapon_specials roach_5 / aggressive 9 / assist 8.

     TIER: ELITE 85. Live level 80 / difficultyClass ELITE maps to the ELITE 85
     row of the ladder in scratch/MUSTAFAR-GAPS.md:1761 -- the same reading the
     valley battlefield already took for its live-ELITE rows
     (som_battlefield_droid_soldier, som_battlefield_elite_guard). Stat row
     taken whole from that ladder. Resists are R_BASE {0,0,0,0,0,0,0,-1,-1}
     (mobile/thug/thug.lua:16); there is no tier override for ELITE, and R_BASE
     also matches live exactly (all seven armour columns 0, armorStun -1).

     SOURCED:
       customName "a Kubaza Beetle Defender" -- authored English; matching the
         foreman's "a Kubaza Beetle Foreman" voice.
       tamingChance = 0 -- live gives no taming data on these rows, and the
         shipped kubaza_beetle.lua taming (0.25) is the ordinary family, not this.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 9 / assist 8.
       scale 1.5 and hues { 1 } -- live minScale/maxScale/hue.
       primaryWeapon "unarmed" -- live primary_weapon is blank.
       meat 16 meat_insect / hide 24 hide_scaley -- live.
       lootGroups {} -- live lootTable blank; master_loot.tab has no som_link
         beetle row (only the foreman has one).

     OURS, NOT SOURCED:
       creatureBitmask PACK -- live blanks death_blow. PACK is the port's
         stand-in for ai_lib.establishAgroLink(foreman, eventMobs), which Core3
         does not have; the same reasoning is already written at
         valley_battlefield.lua:105-108 for the commander's guards.
       primaryAttacks { intimidationattack, creatureareaattack }. Live specials
         come from AI profile roach_5 (ai_combat_profiles.tab:257) =
         bm_bolster_armor_5 (once), bm_bite_5, bm_enfeeble_5 x2 -- the same
         profile the foreman has. Same mapping the foreman header already
         records: bm_enfeeble_5 -> intimidationattack, bm_bite_5 has no Core3
         analogue so creatureareaattack stands in, bm_bolster_armor_5 dropped. ]]
som_link_lava_beetle_defender = Creature:new {
	customName = "a Kubaza Beetle Defender",
	socialGroup = "link_beetle",
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/kubaza_beetle.iff"},
	hues = { 1 },
	scale = 1.5,
	lootGroups = {},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = { {"intimidationattack",""}, {"creatureareaattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_link_lava_beetle_defender, "som_link_lava_beetle_defender")
