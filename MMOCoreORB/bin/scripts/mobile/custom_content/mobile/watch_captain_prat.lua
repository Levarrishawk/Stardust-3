--[[ watch_captain_prat -- Watch Captain Prat, first boss of the Star Destroyer
     heroic, the corridor watch in hallway01. Live record: creatures.tab:5816
     heroic_sd_watch_captain_prat BaseLevel 93 / difficultyClass BOSS / socialGroup
     heroic_sd / template watch_captain_prat.iff / primary_weapon imperial_carbine x2
     / specials sd_prat x2. Tab:228 OnEnterCombat:triggerId:lock_prat,
     OnDeath:triggerId:prat_dead.

     TIER: BOSS 120. The first boss of the run, a step under the two APEX gates.
     Ladder row taken whole from scratch/MUSTAFAR-GAPS.md BOSS
     (corsec_security_specialist).

     SOURCED:
       socialGroup "heroic_sd" -- creatures.tab:5816.
       templates {"object/mobile/watch_captain_prat.iff"} -- existing SD3 template.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- the SD-2 import had NONE.

     OURS, NOT SOURCED:
       Rung BOSS 120 / chanceHit 4.0 / dmg 745-1200 / xp 11390 / HAM 44000-54000 /
         armor 2 / resists {90,90,90,90,90,90,90,90,-1} -- Mustafar BOSS row
         with BOSS/APEX resist override (dark_jedi_master.lua:16).
         SOE stat_balance.tab keyed on 93+BOSS gives 600,450 HP -- not transcribed.
       primaryWeapon "imperial_weapons_heavy" -- nearest Core3 group to SOE
         imperial_carbine (verified mobile/weapon/groups/imperial_weapons_heavy.lua).
       secondaryWeapon "unarmed".
       primaryAttacks merge(marksmanmaster, carbineermaster, commandomaster) --
         Lev's Exar shape. AI profile sd_prat has no Core3 analogue; dropped.
       secondaryAttacks {}.
       -- mobType: SD3 schema field, OURS
       lootGroups sd_sub_2 at lootChance 10000000 -- SOE intLootRolls 1 @ 100%. ]]
watch_captain_prat = Creature:new {
	customName = "watch_captain_prat",
	socialGroup = "heroic_sd",
	faction = "",
	mobType = MOB_NPC,
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
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/watch_captain_prat.iff"},
	lootGroups = {
		{
			groups = {
				{group = "sd_sub_2", chance = 10000000}
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

CreatureTemplates:addCreatureTemplate(watch_captain_prat, "watch_captain_prat")
