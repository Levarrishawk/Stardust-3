--[[ som_link_lava_beetle_drone -- Kubaza Beetle Drone, the trash beetle the
     Establish the Link trial's foreman_drone_spawner and bug_spawner place.
     Live record: creatures.tab BaseLevel 80 / Damagelevelmodifier 0 /
     difficultyClass NORMAL / where mustafar / socialGroup link_beetle / template
     som/kubaza_beetle.iff / minScale 0.9 / maxScale 0.9 / hue 1 / armorStun -1
     (all other armour 0) / attackSpeed 2 / hasResources 1 / meat 16 meat_insect /
     hide 24 hide_scaley / geneProfile defaultProfile / niche carnivore /
     primary_weapon_specials roach_5 / aggressive 0 / assist 2 /
     death_blow instant.

     TIER: STD 70. Live level 80 / difficultyClass NORMAL maps to the STD 70
     row of the ladder in scratch/MUSTAFAR-GAPS.md:1761 -- the same reading the
     valley battlefield already took for its live-NORMAL rows
     (som_battlefield_miner, som_battlefield_foreman_koseyet). Stat row taken
     whole from that ladder. Resists are R_BASE {0,0,0,0,0,0,0,-1,-1}
     (mobile/thug/thug.lua:16); there is no tier override for STD, and R_BASE
     also matches live exactly (all seven armour columns 0, armorStun -1).

     SOURCED:
       customName "a Kubaza Beetle Drone" -- authored English; matching the
         foreman's "a Kubaza Beetle Foreman" voice.
       tamingChance = 0 -- live gives no taming data on these rows, and the
         shipped kubaza_beetle.lua taming (0.25) is the ordinary family, not this.
       pvpBitmask ATTACKABLE -- live aggressive 0.
       creatureBitmask KILLER -- live death_blow = instant.
       scale 0.9 and hues { 1 } -- live minScale/maxScale/hue.
       primaryWeapon "unarmed" -- live primary_weapon is blank.
       meat 16 meat_insect / hide 24 hide_scaley -- live.
       lootGroups {} -- live lootTable blank; master_loot.tab has no som_link
         beetle row (only the foreman has one).

     OURS, NOT SOURCED:
       primaryAttacks { creatureareaattack }. Live gives this row the same
         roach_5 AI profile as the foreman and defender (bm_bolster_armor_5,
         bm_bite_5, bm_enfeeble_5 x2). This is the trash tier (live
         Damagelevelmodifier 0, aggressive 0); giving it the debuff is not
         warranted, and creatureareaattack alone is what the shipped
         kubaza_beetle.lua uses. Disclosed as OURS -- live gives all three the
         same roach_5 profile. ]]
som_link_lava_beetle_drone = Creature:new {
	customName = "a Kubaza Beetle Drone",
	socialGroup = "link_beetle",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 0,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/kubaza_beetle.iff"},
	hues = { 1 },
	scale = 0.9,
	lootGroups = {},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = { {"creatureareaattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_link_lava_beetle_drone, "som_link_lava_beetle_drone")
