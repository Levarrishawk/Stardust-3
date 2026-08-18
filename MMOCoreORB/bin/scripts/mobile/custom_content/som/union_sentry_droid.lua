-- The Old Republic facility's security droids. historian.lua spawns four of these
-- into every copy of the ORF instance for som_kenobi_historian_1's task 3, which
-- names its target by Social Group "orf_security" -- so that is the social group
-- set here. No creature in this tree carried it before.
--
-- customName was the raw template name, "union_sentry_droid", which is what the
-- player would have read over its head.
--
-- Weapon schema follows the shipped droid templates (mobile/lok/droideka.lua) and
-- som_ancient_guardian_droideka.lua in this same folder: defaultWeapon plus
-- defaultAttack. The previous "weapons" and "attacks" fields were dead --
-- CreatureTemplate::readObject() never reads them -- so this mob was spawning
-- unarmed. mobType is MOB_DROID for the same reason.
--
-- pvpBitmask gains AGGRESSIVE + ENEMY: the player has to fight these to get the
-- decryption key, and a facility's security does not wait to be hit first.
--
-- Stats, and the empty lootGroups block, are Levarris's port values, unchanged.
union_sentry_droid = Creature:new {
	customName = "an Old Republic security droid",
	socialGroup = "orf_security",
	faction = "",
	mobType = MOB_DROID,
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
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/union_sentry_droid.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(union_sentry_droid, "union_sentry_droid")
