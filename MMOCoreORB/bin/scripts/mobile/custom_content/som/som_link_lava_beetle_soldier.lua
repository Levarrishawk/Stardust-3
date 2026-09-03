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

       primaryAttacks { intimidationattack, creatureareaattack }. Live specials
         come from AI profile roach_5 (ai_combat_profiles.tab:258) =
         bm_bolster_armor_5 (once), bm_bite_5, bm_enfeeble_5 x2 -- the same
         profile the foreman and the defender carry. This is their mapping,
         applied here for consistency rather than minting a second answer:
         bm_enfeeble_5 is the dominant action and maps to Core3's
         intimidationattack; bm_bite_5 has no direct Core3 creature-command
         analogue, so the shipped kubaza family's own creatureareaattack is used
         (kubaza_beetle.lua:35); bm_bolster_armor_5 is a self-buff with no Core3
         creature-command analogue and is dropped. The pairing is a judgement;
         what is sourced is "a tier-5 roach profile exists".
         CORRECTED IN H(h3): this file previously said the roach_5 profile was
         "not ported this round". That was wrong twice over -- the profile row
         was readable all along at ai_combat_profiles.tab:258, and the two
         siblings sharing it already shipped the mapping. ]]
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

	primaryAttacks = { {"intimidationattack",""}, {"creatureareaattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_link_lava_beetle_soldier, "som_link_lava_beetle_soldier")
