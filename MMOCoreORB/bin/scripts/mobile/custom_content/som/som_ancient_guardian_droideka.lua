-- The other vault guardian for som_kenobi_hidden_treasure_2, spawned when the
-- player pulls som_vault_lever instead of som_vault_lever_2 (.qst task 12,
-- Encounter, Count 1). The two levers are symmetric: same message boxes, same
-- reward, different droid. See som_ancient_guardian_ig.lua for the twin.
--
-- Named from the .qst journal entry title "The ancient guardian"; no row for this
-- creature exists in any shipped creature_names.stf.
--
-- Weapon schema follows the shipped droid templates (mobile/lok/droideka.lua):
-- defaultWeapon plus defaultAttack. The previous "weapons" and "attacks" fields
-- were dead -- CreatureTemplate::readObject() never reads them -- so this mob was
-- spawning unarmed. mobType is MOB_DROID to match mobile/lok/droideka.lua (the IG
-- twin is MOB_ANDROID, matching mobile/lok/ig_assassin_droid.lua).
--
-- pvpBitmask gains AGGRESSIVE + ENEMY so the Encounter is actually hostile; the
-- player has to kill it to clear .qst task 24 (Destroy Multiple).
--
-- Stats, and the empty lootGroups block, are Levarris's port values, unchanged.
som_ancient_guardian_droideka = Creature:new {
	customName = "an Ancient Guardian",
	socialGroup = "",
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
	creatureBitmask = STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/som_ancient_guardian_droideka.iff"},
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

CreatureTemplates:addCreatureTemplate(som_ancient_guardian_droideka, "som_ancient_guardian_droideka")
