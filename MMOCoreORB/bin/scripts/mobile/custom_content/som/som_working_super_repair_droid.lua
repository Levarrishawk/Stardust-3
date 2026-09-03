--[[ som_working_super_repair_droid -- Super Repair Droid (FIXER_ONE), Working
     Droid Factory trial boss. Live record: creatures.tab BaseLevel 85 /
     difficultyClass BOSS / stealingFlags CREDITS / where mustafar / socialGroup
     droid_army / pvpFaction droid_army / template pit_droid.iff / minScale 3 /
     maxScale 3 / hue 0 / attackSpeed 2 / intLootRolls 1 / intRollPercent 100 /
     lootTable mustafar/mustafar_trial_engineer / niche android / stunImmune 100 /
     mezImmune 100 / canNotPunish 1 / primary_weapon pirate_carbine /
     secondary_weapon pirate_carbine / primary_weapon_specials droid_special_6 /
     aggressive 6 / assist 9. No death_blow.

     TIER: BOSS 120. Live level 85 / difficultyClass BOSS maps to the BOSS 120 row
     of the ladder in scratch/MUSTAFAR-GAPS.md:1763 -- the same row
     som_sherkar_consort already uses. Stat row taken whole from that ladder /
     dark_jedi_master.lua:16. Live's own armour columns are NOT used -- the ladder
     is applied whole, same as every other retuned row.

     SOURCED:
       customName "a Super Repair Droid" -- authored English; the trial script
         calls it FIXER_ONE (working_droid_factory/mde_repair_droid.java:255).
       templates {"object/mobile/pit_droid.iff"} -- live's template column is the
         bare pit_droid.iff, not som/pit_droid.iff. object/custom_content/mobile/
         pit_droid.lua:3 registers object/mobile/pit_droid.iff, reached through
         custom_content/mobile/serverobjects.lua:749.
       creatureBitmask NONE -- live leaves death_blow, stalker and herd all blank,
         so no flag is correct. NONE is a valid constant in this tree
         (mobile/corellia/agrilat_rasp.lua:25 and siblings). Do not add KILLER.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 / assist 9.
       scale 3 -- live minScale/maxScale. No hues key: live hue is 0.
       socialGroup "droid_army" -- live. pvpFaction has no Core3 field here.
       loot group master_droid_loot, lootChance 10000000 -- live intLootRolls 1,
         master_loot.tab chance 10000/10000.

     WEAPON GROUP IS SOURCED, NOT GUESSED:
       Live primary_weapon = pirate_carbine resolves through
       datatables/ai/ai_weapons.tab to carbine_laser.iff, carbine_ee3.iff,
       carbine_elite.iff. Core3's general_carbine group
       (mobile/weapon/groups/general_carbine.lua) holds carbine_laser, carbine_ee3,
       carbine_dxr6, carbine_e11 -- two of live's three exactly. That is the closest
       registered group and the reason it was chosen. The defaultWeapon droid form
       is not used here because live names a carbine group, not a droid-mounted
       weapon.

     droid_special_6 is an empty profile row, so no attacks. Same note as the Doom
     Bringer. ]]
som_working_super_repair_droid = Creature:new {
	customName = "a Super Repair Droid",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_DROID,
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
	diet = NONE,

	templates = {"object/mobile/pit_droid.iff"},
	scale = 3,
	lootGroups = {
		{
			groups = {
				{group = "master_droid_loot", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	primaryWeapon = "general_carbine",
	secondaryWeapon = "general_carbine",
	conversationTemplate = "",

	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_working_super_repair_droid, "som_working_super_repair_droid")
