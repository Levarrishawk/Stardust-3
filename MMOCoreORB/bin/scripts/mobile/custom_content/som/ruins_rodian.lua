-- One of the scavengers that skulk around the Mustafar ruins; historian.lua spawns
-- these for som_kenobi_historian_2's "killScavengers" task.
ruins_rodian = Creature:new {
	customName = "a Rodian scavenger",
	socialGroup = "thug",
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
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/ruins_rodian.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},
	-- weapons/attacks are dead fields. CreatureTemplate.cpp reads defaultWeapon (:138),
	-- primaryWeapon/secondaryWeapon (:191/192) and primaryAttacks (:195); nothing reads
	-- weapons or attacks, so this mobile used to spawn unarmed. Pairing follows
	-- corellia/corellia_times_investigator.lua, which uses the same weapon group.
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	primaryAttacks = merge(brawlernovice,marksmannovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(ruins_rodian, "ruins_rodian")
