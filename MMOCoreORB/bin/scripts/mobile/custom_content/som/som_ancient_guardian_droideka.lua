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
-- Stats and loot are RETUNED; an earlier note here called them unchanged port
-- values. They were the placeholder every som template shared -- level 70,
-- chanceHit 0.27, 550-800 damage, 16000/19000 HAM, baseXp 235, and a lootGroups
-- entry whose groups list was empty behind lootChance 2100000, which fires a roll
-- that resolves nothing (LootGroupCollectionEntry.h). Now the ELITE tier on the
-- stock level-85 anchor. Tier table: scratch/MUSTAFAR-GAPS.md.
--
-- defaultWeapon and defaultAttack are deliberately kept in preference to the
-- weapon-group form: droid_droideka_ranged.iff is the right weapon for this chassis
-- and a generic group would be a downgrade.
som_ancient_guardian_droideka = Creature:new {
	customName = "an Ancient Guardian",
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
	creatureBitmask = STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/som_ancient_guardian_droideka.iff"},
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

CreatureTemplates:addCreatureTemplate(som_ancient_guardian_droideka, "som_ancient_guardian_droideka")
