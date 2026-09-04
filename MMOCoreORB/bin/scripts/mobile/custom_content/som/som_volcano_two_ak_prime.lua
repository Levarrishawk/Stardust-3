-- Volcano Battlefield event_two boss, AK Prime.
-- Live row som_volcano_two_ak_prime, level 85 BOSS; level here is APEX tier 140, not live's 85 -- see
-- the note below.
-- Live weapon droid_cww8_01.iff is unregistered, so this falls back to ranged_weapons from
-- cww8a_battle_droid.lua. Live loot mustafar/mustafar_trial_akprime and its chronicle relic are
-- absent, so the tree's technician_tier_1 loot block stands in. Live setHp of 655280 is dropped
-- for the APEX tier's baseHAM/baseHAMmax.
-- The volcano sits one rung above the valley battlefield on the same tier ladder
-- (scratch/MUSTAFAR-GAPS.md): live BOSS -> APEX 140, live ELITE -> BOSS 120. The valley
-- is Chapter Three task 6 and the volcano is the campaign's last content, gated behind
-- it, so the two cannot sit on the same rung. Live encodes that gap in raw HP -- the
-- volcano bosses run 545k-950k against the valley's numbers -- and the ladder replaces
-- raw HP, so the gap has to move onto the ladder or it disappears. That one-rung shift
-- is the only authored number here; every other field is copied from a tier anchor or
-- from live.
som_volcano_two_ak_prime = Creature:new {
	customName = "AK Prime",
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/cww8a_battle_droid.iff"},
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 6000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
			lootChance = 7000000
		}
	},

	primaryWeapon = "ranged_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = merge(marksmanmaster,pistoleermaster),
	secondaryAttacks = pistoleermaster
}

CreatureTemplates:addCreatureTemplate(som_volcano_two_ak_prime, "som_volcano_two_ak_prime")
