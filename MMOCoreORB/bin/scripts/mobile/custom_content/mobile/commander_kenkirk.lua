--[[ commander_kenkirk -- Commander Kenkirk, the officers'-quarters gate whose
     death unlocks the bridge (tab:268 OnDeath:triggerId:access_bridge). Live
     record: creatures.tab:5814 heroic_sd_commander_kenkirk BaseLevel 94 /
     difficultyClass BOSS / socialGroup heroic_sd / template commander_kenkirk.iff
     / primary_weapon imperial_carbine x2 / specials sd_kenkirk x2.

     TIER: APEX 140. Lev's mid-boss rung. Kenkirk's death is the last gate before
     the final. Ladder row taken whole from scratch/MUSTAFAR-GAPS.md APEX
     (corsec_special_ops_master_sergeant).

     SOURCED:
       socialGroup "heroic_sd" -- creatures.tab:5814.
       templates {"object/mobile/commander_kenkirk.iff"} -- existing SD3 template.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- the SD-2 import had NONE.

     OURS, NOT SOURCED:
       Rung APEX 140 / chanceHit 7 / dmg 845-1400 / xp 13273 / HAM 68000-83000 /
         armor 2 / resists {90,90,90,90,90,90,90,90,-1} -- Mustafar APEX row
         with BOSS/APEX resist override (dark_jedi_master.lua:16).
         SOE stat_balance.tab keyed on 94+BOSS gives 882,752 HP -- not transcribed.
       primaryWeapon "imperial_weapons_heavy" -- nearest Core3 group to SOE
         imperial_carbine (verified mobile/weapon/groups/imperial_weapons_heavy.lua).
       secondaryWeapon "unarmed".
       primaryAttacks merge(marksmanmaster, carbineermaster, commandomaster) --
         Lev's Exar shape. AI profile sd_kenkirk has no Core3 analogue; dropped.
       secondaryAttacks {}.
       -- mobType: SD3 schema field, OURS
       lootGroups sd_sub_3 at lootChance 10000000 -- SOE intLootRolls 1 @ 100%. ]]
commander_kenkirk = Creature:new {
	customName = "commander_kenkirk",
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
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/commander_kenkirk.iff"},
	lootGroups = {
		{
			groups = {
				{group = "sd_sub_3", chance = 10000000}
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

CreatureTemplates:addCreatureTemplate(commander_kenkirk, "commander_kenkirk")
