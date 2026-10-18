--[[ heroic_sd_stormtrooper -- Star Destroyer hangar/corridor stormtrooper, the
     most common mob in the heroic (32 spawn-tab rows). Live record:
     creatures.tab heroic_sd_stormtrooper BaseLevel 90 / difficultyClass ELITE /
     socialGroup heroic_sd / template dressed_stormtrooper_m.iff / primary_weapon
     imperial_carbine / secondary imperial_unarmed / specials officer_3 / melee_3.

     TIER: ELITE, level 88. Lev's trash rung exactly (exar_kun_open_hand 88).
     Combat row taken whole from the ELITE 85 ladder (spiderclan_crawler);
     level is 88 as the PART 4.2 table states. Resists are R_BASE
     {0,0,0,0,0,0,0,-1,-1} (mobile/thug/thug.lua:16); no ELITE resist override.

     New name (heroic_sd_*) rather than creating a dressed_stormtrooper_m creature
     template that would shadow a dress-group name.

     SOURCED:
       socialGroup "heroic_sd" -- creatures.tab.
       templates {"object/mobile/dressed_stormtrooper_m.iff"} -- present on SD3 and in TREs.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive garrison.

     OURS, NOT SOURCED:
       Rung ELITE / level 88 / chanceHit 0.75 / dmg 555-820 / xp 8130 /
         HAM 12000-15000 / armor 1 / resists R_BASE.
       primaryWeapon "imperial_weapons_heavy" -- nearest Core3 group to SOE
         imperial_carbine (verified mobile/weapon/groups/imperial_weapons_heavy.lua).
       secondaryWeapon "unarmed".
       primaryAttacks merge(marksmanmaster, carbineermaster, commandomaster) --
         Lev's Exar shape. AI profiles officer_3 / melee_3 dropped (no Core3 analogue).
       secondaryAttacks {}.
       customName "a Stormtrooper".
       lootGroups {} -- H(sd-a) does not give trash a corpse table. ]]
heroic_sd_stormtrooper = Creature:new {
	customName = "a Stormtrooper",
	socialGroup = "heroic_sd",
	faction = "",
	mobType = MOB_NPC,
	level = 88,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,0,0,0,-1,-1},
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
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_stormtrooper_m.iff"},
	lootGroups = {},

	primaryWeapon = "imperial_weapons_heavy",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	primaryAttacks = merge(marksmanmaster, carbineermaster, commandomaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_sd_stormtrooper, "heroic_sd_stormtrooper")
