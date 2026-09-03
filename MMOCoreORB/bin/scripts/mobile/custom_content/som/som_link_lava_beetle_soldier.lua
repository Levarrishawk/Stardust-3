--[[ som_link_lava_beetle_soldier -- Lava Beetle Soldier, the third beetle
     grade in the Establish the Link cave (above the drone and the worker).
     Live record: creatures.tab BaseLevel 80 / difficultyClass NORMAL /
     where mustafar / socialGroup link_beetle / template som/kubaza_beetle.iff /
     minScale 1.3 / maxScale 1.3 / hue 1 / meat 16 meat_insect /
     hide 24 hide_scaley / intLootRolls 1 / intRollPercent 80 / lootTable BLANK /
     niche carnivore / primary_weapon blank / primary_weapon_specials roach_5 /
     aggressive 6 / assist 6.

     TIER: STD 70. Live level 80 / difficultyClass NORMAL maps to the STD 70
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same reading
     som_link_lava_beetle_drone already took. Stat row taken whole from that
     ladder. Resists are R_BASE {0,0,0,0,0,0,0,-1,-1}.

     SOURCED:
       customName "Lava Beetle Soldier" -- live English name.
       socialGroup "link_beetle" -- live.
       templates {"object/mobile/som/kubaza_beetle.iff"}, hues { 1 },
         scale 1.3 -- live. Sits at scale 1.3 against the defender's 1.5;
         that is live's data, not a choice.
       meat 16 meat_insect / hide 24 hide_scaley -- live.
       primaryWeapon "unarmed" -- live primary_weapon blank.
       lootGroups {} -- live lootTable blank. Empty here is live's data, not
         an omission.
       creatureBitmask PACK -- live blanks death_blow; PACK is the port's
         stand-in already used on the defender for agro-link absence.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 6.

     No specials authored. Live's roach_5 profile is not ported this round;
     say so here rather than invent actions. ]]
som_link_lava_beetle_soldier = Creature:new {
	customName = "Lava Beetle Soldier",
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/kubaza_beetle.iff"},
	hues = { 1 },
	scale = 1.3,
	lootGroups = {},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_link_lava_beetle_soldier, "som_link_lava_beetle_soldier")
