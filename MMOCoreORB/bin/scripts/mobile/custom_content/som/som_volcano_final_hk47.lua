-- Volcano Battlefield HK-47 finale boss.
-- Live row som_volcano_final_hk47, level 83 BOSS; level here is APEX tier 140, not live's 83 -- see
-- the note below.
-- Live has no separate registered weapon path for this row in the nine-weapon gap list; attacks follow
-- the hk47.lua / HK weapon-group shape with ranged_weapons.
-- Loot: live table mustafar/mustafar_trial_hk47 (loot group hk47_loot). creatures.tab
-- intLootRolls = 1; master_loot.tab chance 10000/10000 so lootChance = 10000000.
-- Previous technician_tier_1 / armor_attachments / clothing_attachments were filler, not a
-- tuned choice. col_shattered_shard_02 and the chronicle relic remain absent.
-- Live setHp of 545852 is dropped for the APEX tier's baseHAM/baseHAMmax. Live scale 1.3 is dropped
-- because Core3 Creature templates have no scale field. creatureBitmask is STALKER alone -- the
-- campaign's final boss stands alone.
-- The volcano sits one rung above the valley battlefield on the same tier ladder
-- (scratch/MUSTAFAR-GAPS.md): live BOSS -> APEX 140, live ELITE -> BOSS 120. The valley
-- is Chapter Three task 6 and the volcano is the campaign's last content, gated behind
-- it, so the two cannot sit on the same rung. Live encodes that gap in raw HP -- the
-- volcano bosses run 545k-950k against the valley's numbers -- and the ladder replaces
-- raw HP, so the gap has to move onto the ladder or it disappears. That one-rung shift
-- is the only authored number here; every other field is copied from a tier anchor or
-- from live.
som_volcano_final_hk47 = Creature:new {
	customName = "HK-47",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_ANDROID,
	level = 140,
	chanceHit = 7,
	damageMin = 845,
	damageMax = 1400,
	baseXp = 13273,
	baseHAM = 68000,
	baseHAMmax = 83000,
	armor = 2,
	resists = {75,75,100,60,100,25,40,85,-1},
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

	templates = {"object/mobile/som/hk47.iff"},
	lootGroups = {
		{
			groups = {
				{group = "hk47_loot", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	primaryWeapon = "ranged_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,bountyhuntermaster),
	secondaryAttacks = bountyhuntermaster
}

CreatureTemplates:addCreatureTemplate(som_volcano_final_hk47, "som_volcano_final_hk47")
