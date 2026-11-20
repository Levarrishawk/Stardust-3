--[[ heroic_sd_darktrooper -- Star Destroyer dark trooper. Live record:
     creatures.tab heroic_sd_darktrooper BaseLevel 90 / difficultyClass BOSS /
     socialGroup heroic_sd / template dark_trooper.iff / minScale 1.25 / maxScale 1.25
     / primary_weapon imperial_carbine / secondary imperial_sword / specials
     heroic_sd_darktrooper / heroic_sd_darktrooper_unarmed.

     TIER: ELITE, level 88. Lev's trash rung exactly (exar_kun_open_hand 88).
     SOE calls it BOSS but spawns 31 of them -- elite trash, not a boss.
     Combat row taken whole from the ELITE 85 ladder; level is 88 as the
     PART 4.2 table states. Resists are R_BASE {0,0,0,0,0,0,0,-1,-1}.

     New name (heroic_sd_*) rather than retuning mobile/faction/imperial/dark_trooper.lua
     (level 35, stock Core3 imperial content, spawned by other content).

     SOURCED:
       socialGroup "heroic_sd" -- creatures.tab.
       templates {"object/mobile/dark_trooper.iff"} -- present on SD3 and in TREs.
       scale 1.25 -- live minScale/maxScale.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive garrison.

     OURS, NOT SOURCED:
       Rung ELITE / level 88 / chanceHit 0.75 / dmg 555-820 / xp 8130 /
         HAM 12000-15000 / armor 1 / resists R_BASE.
       primaryWeapon "imperial_weapons_heavy" -- nearest Core3 group to SOE
         imperial_carbine (verified mobile/weapon/groups/imperial_weapons_heavy.lua).
       secondaryWeapon "unarmed".
       primaryAttacks merge(marksmanmaster, carbineermaster, commandomaster) --
         Lev's Exar shape. AI profile heroic_sd_darktrooper dropped (no Core3 analogue).
       secondaryAttacks {}.
       customName "a Dark Trooper".
       lootGroups {} -- H(sd-a) does not give trash a corpse table. ]]
heroic_sd_darktrooper = Creature:new {
	customName = "a Dark Trooper",
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

	templates = {"object/mobile/dark_trooper.iff"},
	scale = 1.25,
	lootGroups = {},

	primaryWeapon = "imperial_weapons_heavy",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	primaryAttacks = merge(marksmanmaster, carbineermaster, commandomaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_sd_darktrooper, "heroic_sd_darktrooper")
