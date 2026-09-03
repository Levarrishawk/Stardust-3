-- Valley Battlefield (mustafar_droid_army) forward commander. Live row
-- som_battlefield_commander, level 84 BOSS; level here is BOSS tier 120 from
-- som_dark_jedi_boss.lua, not live's 84. resists, socialGroup, and aggression
-- are live; weapon/attacks come from hk77.lua because live's droid_hk77_boss
-- is unregistered. customName is authored -- no .stf ships in the extract.
-- Loot: live table mustafar_npc_loot_b:forward_commander (loot group
-- forward_commander). creatures.tab intLootRolls = 1; master_loot.tab chance
-- 10000/10000 so lootChance = 10000000. Previous technician_tier_1 /
-- armor_attachments / clothing_attachments were filler, not a tuned choice.
som_battlefield_commander = Creature:new {
	customName = "a Droid Army Forward Commander",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_ANDROID,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {75,75,100,60,100,25,40,85,-1},
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/hk77.iff"},
	lootGroups = {
		{
			groups = {
				{group = "forward_commander", chance = 10000000}
			},
			lootChance = 10000000
		}
	},
	primaryWeapon = "ranged_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,bountyhuntermaster),
	secondaryAttacks = bountyhuntermaster
}

CreatureTemplates:addCreatureTemplate(som_battlefield_commander, "som_battlefield_commander")
