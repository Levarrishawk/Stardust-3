blue = Creature:new {
	objectName = "",
	customName = "Blue",
	socialGroup = "",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 350,
	chanceHit = 6.25,
	damageMin = 2940,
	damageMax = 5840,
	baseXp = 14030,
	baseHAM = 869786,
	baseHAMmax = 939540,
	armor = 1,
	resists = {160,160,55,55,200,160,200,160,60},
	meatType = "meat_carnivore",
	meatAmount = 100000,
	hideType = "hide_leathery",
	hideAmount = 100000,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/som_kenobi_blistmok.iff"},
	hues = { 24, 25, 26, 27, 28, 29, 30, 31 },
	scale = 4,
	lootGroups = {
		{
			groups = {
				{group = "imperial_corvette_loot", chance = 2000000},
				{group = "lok_track", chance = 500000},
				{group = "krayt_tissue_rare", chance = 1000000},
				{group = "veteran_rewards_720_days", chance = 1000000},
				{group = "veteran_rewards_900_days", chance = 500000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "nge_houses_all", chance = 1000000}
			},
				lootChance = 10000000,
		},
		
		{
			groups = {
				{group = "imperial_corvette_loot", chance = 2000000},
				{group = "lok_track", chance = 500000},
				{group = "krayt_tissue_rare", chance = 1000000},
				{group = "veteran_rewards_720_days", chance = 1000000},
				{group = "veteran_rewards_900_days", chance = 500000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "nge_houses_all", chance = 1000000}
			},
				lootChance = 8500000,
		},
		
		{
			groups = {
				{group = "imperial_corvette_loot", chance = 2000000},
				{group = "lok_track", chance = 500000},
				{group = "krayt_tissue_rare", chance = 1000000},
				{group = "veteran_rewards_720_days", chance = 1000000},
				{group = "veteran_rewards_900_days", chance = 500000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "nge_houses_all", chance = 1000000}
			},
				lootChance = 7000000,
		},
		
		{
			groups = {
				{group = "imperial_corvette_loot", chance = 2000000},
				{group = "lok_track", chance = 500000},
				{group = "krayt_tissue_rare", chance = 1000000},
				{group = "veteran_rewards_720_days", chance = 1000000},
				{group = "veteran_rewards_900_days", chance = 500000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "nge_houses_all", chance = 1000000}
			},
				lootChance = 6000000,
		},
		
		{
			groups = {
				{group = "imperial_corvette_loot", chance = 2000000},
				{group = "lok_track", chance = 500000},
				{group = "krayt_tissue_rare", chance = 1000000},
				{group = "veteran_rewards_720_days", chance = 1000000},
				{group = "veteran_rewards_900_days", chance = 500000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "nge_houses_all", chance = 1000000}
			},
				lootChance = 5000000,
		},
		
		{
			groups = {
				{group = "imperial_corvette_loot", chance = 2000000},
				{group = "lok_track", chance = 500000},
				{group = "krayt_tissue_rare", chance = 1000000},
				{group = "veteran_rewards_720_days", chance = 1000000},
				{group = "veteran_rewards_900_days", chance = 500000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "nge_houses_all", chance = 1000000}
			},
				lootChance = 4000000,
		},
		
		{
			groups = {
				{group = "imperial_corvette_loot", chance = 2000000},
				{group = "lok_track", chance = 500000},
				{group = "krayt_tissue_rare", chance = 1000000},
				{group = "veteran_rewards_720_days", chance = 1000000},
				{group = "veteran_rewards_900_days", chance = 500000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "nge_houses_all", chance = 1000000}
			},
				lootChance = 3000000,
		},
		
		{
			groups = {
				{group = "imperial_corvette_loot", chance = 2000000},
				{group = "lok_track", chance = 500000},
				{group = "krayt_tissue_rare", chance = 1000000},
				{group = "veteran_rewards_720_days", chance = 1000000},
				{group = "veteran_rewards_900_days", chance = 500000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000},
				{group = "nge_houses_all", chance = 1000000}
			},
				lootChance = 2500000,
		},
		
		{
			groups = {
				{group = "token_stardust", chance = 10000000}
			},
				lootChance = 10000000,
		},
		
		{
			groups = {
				{group = "krayt_tissue_enhanced", chance = 10000000}
			},
				lootChance = 1000000,
		},
	},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	
	primaryAttacks = { {"creatureareaattack","stateAccuracyBonus=50"}, {"blindattack","stateAccuracyBonus=100"}, {"posturedownattack","stateAccuracyBonus=50"}, {"creatureareacombo","stateAccuracyBonus=75"} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(blue, "blue")
