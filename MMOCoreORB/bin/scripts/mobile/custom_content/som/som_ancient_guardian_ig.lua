-- The vault guardian for som_kenobi_hidden_treasure_2, spawned when the player
-- pulls som_vault_lever_2 (.qst task 16, Encounter, Count 1). The .qst journal
-- entry for the fight is titled "The ancient guardian"; there is no row for this
-- creature in any creature_names.stf shipped with the client, so the customName
-- below is taken from that journal title rather than invented.
--
-- Weapon schema: this is a droid, so it follows the shipped droid templates
-- (mobile/lok/ig_assassin_droid.lua, mobile/lok/droideka.lua) -- defaultWeapon
-- plus defaultAttack -- rather than the weapon-group form the humanoid mobs in
-- this pack use. The previous "weapons" and "attacks" fields were dead:
-- CreatureTemplate::readObject() only reads primaryWeapon / secondaryWeapon /
-- primaryAttacks / secondaryAttacks / defaultWeapon / defaultAttack, so this mob
-- was spawning with no weapon at all.
--
-- pvpBitmask gains AGGRESSIVE + ENEMY: the .qst spawns it as a hostile Encounter
-- that the player must then kill (task 25, Destroy Multiple). Plain ATTACKABLE
-- would have left it standing there passively.
--
-- Stats are Levarris's port values, unchanged. The .qst rates the encounter Level
-- 75 Tier 4 while these are the pack's stock level 70 block; retuning is a balance
-- call, not a wiring fix, so it is left alone. The lootGroups block is likewise
-- carried over as-is -- an empty "groups" list drops nothing, but the .qst awards
-- this quest's reward through the Reward task, not through loot.
som_ancient_guardian_ig = Creature:new {
	customName = "an Ancient Guardian",
	socialGroup = "",
	faction = "",
	mobType = MOB_ANDROID,
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

	templates = {"object/mobile/som/som_ancient_guardian_ig.iff"},
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

CreatureTemplates:addCreatureTemplate(som_ancient_guardian_ig, "som_ancient_guardian_ig")
