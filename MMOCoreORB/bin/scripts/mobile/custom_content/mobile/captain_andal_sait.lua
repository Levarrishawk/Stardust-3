--[[ captain_andal_sait -- Captain Andal Sait, final boss of the Star Destroyer
     heroic (the Blackguard). Live record: creatures.tab:5813 heroic_sd_captain_sait
     BaseLevel 95 / difficultyClass BOSS / socialGroup heroic_sd / template
     captain_andal_sait.iff / primary_weapon imperial_carbine / secondary imperial_sword
     / specials heroic_sd_darktrooper / heroic_sd_darktrooper_unarmed / death_blow instant.
     Consumer of lootTable heroic/heroic:sd_boss. sd_controller.java:14-19 fires
     saitDied, awards tokenIndex 3.

     TIER: RAID 200. Sait is this heroic's exar_kun: the controller's only handler,
     the token grant, the CS victory log. Ladder row taken whole from
     scratch/MUSTAFAR-GAPS.md RAID (rebel_rear_admiral).

     SOURCED:
       socialGroup "heroic_sd" -- creatures.tab:5813.
       templates {"object/mobile/captain_andal_sait.iff"} -- existing SD3 template.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live is a boss; the SD-2 import
         had NONE, which made him unattackable.

     OURS, NOT SOURCED:
       Rung RAID 200 / chanceHit 16 / dmg 1145-2000 / xp 19008 / HAM 160000-195000 /
         armor 3 / resists {165,145,35,35,35,35,35,35,-1} -- Mustafar RAID row.
         SOE stat_balance.tab keyed on 95+BOSS gives 1,109,085 HP -- NGE-scale, not
         transcribed. Same recording as som_link_lava_beetle_foreman.lua:22-24.
       primaryWeapon "imperial_weapons_heavy" -- nearest Core3 group to SOE
         imperial_carbine (verified mobile/weapon/groups/imperial_weapons_heavy.lua).
       secondaryWeapon "unarmed" -- SOE secondary imperial_sword; Core3 convention
         puts unarmed on secondary for a ranged primary (fed_dub_captain.lua:45).
       primaryAttacks merge(marksmanmaster, carbineermaster, commandomaster) --
         Lev's Exar shape (exar_kun_open_hand.lua:38), preferred over mapping
         AI profile heroic_sd_darktrooper through ai_combat_profiles.tab.
         krix_burn / krix_megaburn / krix_megapatch do not apply here; Sait's
         specials have no Core3 command analogue and are dropped.
       secondaryAttacks {} -- unarmed secondary, same as fed_dub_captain.lua:52.
       -- mobType: SD3 schema field, OURS
       lootGroups sd_boss at lootChance 10000000 -- SOE intLootRolls 1 @ 100%. ]]
captain_andal_sait = Creature:new {
	customName = "captain_andal_sait",
	socialGroup = "heroic_sd",
	faction = "",
	mobType = MOB_NPC,
	level = 200,
	chanceHit = 16,
	damageMin = 1145,
	damageMax = 2000,
	baseXp = 19008,
	baseHAM = 160000,
	baseHAMmax = 195000,
	armor = 3,
	resists = {165,145,35,35,35,35,35,35,-1},
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

	templates = {"object/mobile/captain_andal_sait.iff"},
	lootGroups = {
		{
			groups = {
				{group = "sd_boss", chance = 10000000}
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

CreatureTemplates:addCreatureTemplate(captain_andal_sait, "captain_andal_sait")
