--[[ som_link_lava_beetle_foreman -- Kubaza Beetle Foreman, the Establish the Link
     trial boss. Live record: creatures.tab BaseLevel 80 / difficultyClass BOSS /
     stealingFlags CREDITS / where mustafar / socialGroup link_beetle / template
     som/kubaza_beetle.iff / minScale 3.2 / maxScale 3.2 / hue 1 / armorStun -1
     (all other armour 0) / attackSpeed 2 / hasResources 1 / meat 16 meat_insect /
     hide 24 hide_scaley / intLootRolls 1 / intRollPercent 100 / lootTable
     mustafar/mustafar_trial_foreman / niche carnivore / rootImmune snareImmune
     stunImmune mezImmune 100 / canNotPunish 1 / primary_weapon_specials roach_5 /
     aggressive 9 / assist 8 / death_blow yes.

     TIER: BOSS 120. Live level 80 / difficultyClass BOSS maps to the BOSS 120 row
     of the ladder in scratch/MUSTAFAR-GAPS.md:1763 -- the same row
     som_sherkar_consort already uses. Stat row taken whole from that ladder /
     dark_jedi_master.lua:16. DISCLOSED DIVERGENCE: live gives armorStun -1
     (stun-vulnerable); the ladder's BOSS row gives stun 90. The ladder is applied
     whole, same as every other retuned row.

     SOURCED:
       customName "a Kubaza Beetle Foreman" -- authored English; live's shared
         template would read "Kubaza Beetle".
       tamingChance = 0 -- live gives no taming data for a BOSS row, and the
         shipped kubaza_beetle.lua taming (0.25) is the ordinary family, not this.
       creatureBitmask KILLER -- live death_blow = yes. No PACK, no STALKER: live
         leaves both blank on this row.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 9 / assist 8.
       scale 3.2 and hues { 1 } -- live minScale/maxScale/hue.
       primaryWeapon "unarmed" -- live primary_weapon is blank.
       meat 16 meat_insect / hide 24 hide_scaley -- live.
       loot group kubaza_foreman, lootChance 10000000 -- live intLootRolls 1,
         master_loot.tab chance 10000/10000.

     OURS, NOT SOURCED:
       primaryAttacks { intimidationattack, creatureareaattack }. Live specials
         come from AI profile roach_5 (ai_combat_profiles.tab:257) =
         bm_bolster_armor_5 (once), bm_bite_5, bm_enfeeble_5 x2. bm_enfeeble_5 is
         the dominant action and maps to Core3's intimidationattack; bm_bite_5
         has no direct Core3 creature-command analogue, so the shipped kubaza
         family's own creatureareaattack is used (kubaza_beetle.lua:35).
         bm_bolster_armor_5 is a self-buff with no Core3 creature-command analogue
         and is dropped. The pairing is a judgement; what is sourced is "a tier-5
         debuffer with a bite". ]]
som_link_lava_beetle_foreman = Creature:new {
	customName = "a Kubaza Beetle Foreman",
	socialGroup = "link_beetle",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
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
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/kubaza_beetle.iff"},
	hues = { 1 },
	scale = 3.2,
	lootGroups = {
		{
			groups = {
				{group = "kubaza_foreman", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = { {"intimidationattack",""}, {"creatureareaattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_link_lava_beetle_foreman, "som_link_lava_beetle_foreman")
