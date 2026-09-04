--[[ krix_swiftshadow -- Krix Swiftshadow, hangar boss of the Star Destroyer
     heroic. Live record: creatures.tab:5834 heroic_sd_krix_swiftshadow BaseLevel 92 /
     difficultyClass BOSS / socialGroup heroic_sd / template krix_swiftshadow.iff /
     primary_weapon imperial_carbine x2 / specials sd_krix_swiftshadow x2.
     Tab:63 trigger spawn_krix, OnDeath:triggerId:krix_died (hangar fences).

     TIER: APEX 140. Same rung as Kenkirk. Ladder row taken whole from
     scratch/MUSTAFAR-GAPS.md APEX.

     Krix's 1,243,250 HP (krix.java:40 trial.setHp) is recorded and deliberately
     not transcribed. SOE's table value is 405,070, overridden by the script.
     Those are NGE-scale numbers for NGE combat. The APEX row gives 68,000 / 83,000.

     krix_burn / krix_megaburn / krix_megapatch do not port. krix.java:114/199/200
     queue them by CRC against command_table.tab:1608/1621/1622. Core3 has no such
     commands and no queueCommand-by-CRC binding. The phase machine in starDestroyer.lua
     stands in.

     SOURCED:
       socialGroup "heroic_sd" -- creatures.tab:5834.
       templates {"object/mobile/krix_swiftshadow.iff"} -- existing SD3 template.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- already correct on the SD-2 import.

     OURS, NOT SOURCED:
       Rung APEX 140 / chanceHit 7 / dmg 845-1400 / xp 13273 / HAM 68000-83000 /
         armor 2 / resists {90,90,90,90,90,90,90,90,-1} -- Mustafar APEX row
         with BOSS/APEX resist override (dark_jedi_master.lua:16). The SD-2 import
         had {40,40,40,100,40,40,40,40,40} -- 9 entries, replaced whole.
       primaryWeapon "imperial_weapons_heavy" -- nearest Core3 group to SOE
         imperial_carbine. The SD-2 import used mixed_force_weapons, which is a
         Sith kit and does not match SOE's carbine.
       secondaryWeapon "unarmed".
       primaryAttacks merge(marksmanmaster, carbineermaster, commandomaster) --
         Lev's Exar shape. Replaces pikemanmaster+brawlermaster on mixed_force_weapons.
         AI profile sd_krix_swiftshadow dropped (no Core3 analogue).
       secondaryAttacks {}.
       -- mobType: SD3 schema field, OURS
       lootGroups sd_sub_1 at lootChance 10000000 -- SOE intLootRolls 1 @ 100%. ]]
krix_swiftshadow = Creature:new {
	customName = "krix_swiftshadow",
	socialGroup = "heroic_sd",
	faction = "",
	mobType = MOB_NPC,
	level = 140,
	chanceHit = 7,
	damageMin = 845,
	damageMax = 1400,
	baseXp = 13273,
	baseHAM = 68000,
	baseHAMmax = 83000,
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
	creatureBitmask = PACK + HERD + KILLER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/krix_swiftshadow.iff"},
	lootGroups = {
		{
			groups = {
				{group = "sd_sub_1", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	primaryWeapon = "imperial_weapons_heavy",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	primaryAttacks = merge(marksmanmaster, carbineermaster, commandomaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(krix_swiftshadow, "krix_swiftshadow")
