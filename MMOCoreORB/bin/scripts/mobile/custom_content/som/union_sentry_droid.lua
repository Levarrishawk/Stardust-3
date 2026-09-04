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
-- Stats and loot are RETUNED; an earlier note here called them unchanged port
-- values. They were the placeholder every som template shared -- level 70,
-- chanceHit 0.27, 550-800 damage, 16000/19000 HAM, baseXp 235, and a lootGroups
-- entry whose groups list was empty behind lootChance 2100000, which fires a roll
-- that resolves nothing (LootGroupCollectionEntry.h). Now the ELITE tier on the
-- stock level-85 anchor. Tier table: scratch/MUSTAFAR-GAPS.md.
--
-- defaultWeapon and defaultAttack are deliberately kept in preference to the
-- weapon-group form, for the same reason as the droideka above.
union_sentry_droid = Creature:new {
	customName = "an Old Republic security droid",
	socialGroup = "orf_security",
	faction = "",
	mobType = MOB_DROID,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
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
			groups = {
				{group = "technician_tier_1", chance = 7000000},
				{group = "junk", chance = 3000000}
			}
		}
	},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(union_sentry_droid, "union_sentry_droid")
