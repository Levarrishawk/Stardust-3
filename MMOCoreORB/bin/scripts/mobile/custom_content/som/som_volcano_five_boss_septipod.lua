-- Volcano Battlefield event_five boss, the Oppressor Septipod.
-- Live row som_volcano_five_boss_septipod, level 82 BOSS; level here is APEX tier 140, not live's 82 -- see
-- the note below.
-- Live weapon droid_union_sentry_02.iff is unregistered, so this falls back to the defaultWeapon /
-- defaultAttack shape from union_sentry_droid.lua. Live setHp of 220000 is
-- dropped for the APEX tier's baseHAM/baseHAMmax. Live scale 1.3 is dropped because Core3 Creature
-- templates have no scale field.
-- Loot: live table mustafar/mustafar_trial_oppressor (loot group gk_oppressor_loot).
-- creatures.tab intLootRolls = 1; master_loot.tab chance 10000/10000 so lootChance =
-- 10000000. Previous technician_tier_1 / junk were filler, not a tuned choice. The
-- chronicle relic remains absent.
-- The volcano sits one rung above the valley battlefield on the same tier ladder
-- (scratch/MUSTAFAR-GAPS.md): live BOSS -> APEX 140, live ELITE -> BOSS 120. The valley
-- is Chapter Three task 6 and the volcano is the campaign's last content, gated behind
-- it, so the two cannot sit on the same rung. Live encodes that gap in raw HP -- the
-- volcano bosses run 545k-950k against the valley's numbers -- and the ladder replaces
-- raw HP, so the gap has to move onto the ladder or it disappears. That one-rung shift
-- is the only authored number here; every other field is copied from a tier anchor or
-- from live.
som_volcano_five_boss_septipod = Creature:new {
	customName = "the Oppressor Septipod",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_DROID,
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

	templates = {"object/mobile/som/union_sentry_droid.iff"},
	lootGroups = {
		{
			groups = {
				{group = "gk_oppressor_loot", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(som_volcano_five_boss_septipod, "som_volcano_five_boss_septipod")
