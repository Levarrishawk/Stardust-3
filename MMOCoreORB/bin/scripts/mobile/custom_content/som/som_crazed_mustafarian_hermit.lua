-- som_kenobi_main_quest_1's hermit, the one carrying the Soul Crystal shard.
-- He is talked to twice and can end either way: task 15 fires 'talkedHermit2'
-- when he hands the shard over, task 21 is Destroy Multiple and Loot when he
-- does not. So he is CONVERSABLE and stays ATTACKABLE -- both endings are
-- shipped and neither is privileged here.
--
-- The weapons/attacks fields below are the pre-rewrite shape and are inert in
-- this build; they are left alone because they are a repo-wide pattern, not an
-- arc defect.
som_crazed_mustafarian_hermit = Creature:new {
	customName = "Crazed Mustafarian Hermit",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 70,
	chanceHit = 0.27,
	damageMin = 550,
	damageMax = 800,
	baseXp = 235,
	baseHAM = 16000,
	baseHAMmax = 19000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_crazed_mustafarian_hermit.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "som_kenobi_crazed_hermit",
	primaryAttacks = merge(marksmannovice,brawlernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_crazed_mustafarian_hermit, "som_crazed_mustafarian_hermit")
