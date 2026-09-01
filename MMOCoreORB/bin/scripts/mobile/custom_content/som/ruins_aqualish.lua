-- One of the scavengers that skulk around the Mustafar ruins; historian.lua spawns
-- these for som_kenobi_historian_2's "killScavengers" task.
ruins_aqualish = Creature:new {
	customName = "an Aqualish scavenger",
	socialGroup = "thug",
	faction = "",
	mobType = MOB_NPC,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
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

	templates = {"object/mobile/som/ruins_aqualish.iff"},
	lootGroups = {
		{
			groups = {
				{group = "thug_tier_1", chance = 10000000}
			}
		}
	},
	-- weapons/attacks are dead fields. CreatureTemplate.cpp reads defaultWeapon (:138),
	-- primaryWeapon/secondaryWeapon (:191/192) and primaryAttacks (:195); nothing reads
	-- weapons or attacks, so this mobile used to spawn unarmed. Pairing follows
	-- corellia/corellia_times_investigator.lua, which uses the same weapon group.
	primaryWeapon = "melee_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = merge(brawlermaster,swordsmanmaster),
	secondaryAttacks = brawlermaster
}

CreatureTemplates:addCreatureTemplate(ruins_aqualish, "ruins_aqualish")
