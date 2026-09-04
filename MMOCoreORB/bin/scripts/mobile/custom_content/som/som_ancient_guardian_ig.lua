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
-- Stats are RETUNED. The note that stood here said the level-70 block was a port
-- value and retuning it was a balance call, not a wiring fix. That was wrong: it
-- was not a tuned value at all, it was the one placeholder block all 158 som
-- templates shared (level 70, chanceHit 0.27, 550-800 damage, 16000/19000 HAM,
-- baseXp 235). The note's own next sentence made the point -- the .qst rates this
-- encounter Level 75 Tier 4 and the mob was not near it. It is now the ELITE tier,
-- level 85, on the stock level-85 anchor mobile/dathomir/spiderclan_crawler.lua.
--
-- lootGroups is retuned too. The old block was not "carried over as-is"; it was
-- actively broken -- an empty groups list behind lootChance 2100000 fires a roll
-- that resolves nothing (LootGroupCollectionEntry.h). The .qst still pays the quest
-- reward through its Reward task; this is the corpse drop, which is separate.
-- Tier table and stat anchors: scratch/MUSTAFAR-GAPS.md.
som_ancient_guardian_ig = Creature:new {
	customName = "an Ancient Guardian",
	socialGroup = "orf_security",
	faction = "",
	mobType = MOB_ANDROID,
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
	creatureBitmask = STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/som_ancient_guardian_ig.iff"},
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

CreatureTemplates:addCreatureTemplate(som_ancient_guardian_ig, "som_ancient_guardian_ig")
