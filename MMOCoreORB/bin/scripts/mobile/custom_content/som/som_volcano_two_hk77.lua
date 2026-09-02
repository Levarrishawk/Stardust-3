-- Volcano Battlefield event_two guard, an HK-77 Assault Droid under AK Prime.
-- Live row som_volcano_two_hk77, level 83 ELITE; level here is BOSS tier 120, not live's 83 -- see
-- the note below.
-- Live weapon droid_hk77_assault_droid.iff is unregistered, so this falls back to ranged_weapons from
-- hk77.lua; live's boss/elite/assault HK-77 distinction collapses to the same group. Live scale 1.3
-- is dropped because Core3 Creature templates have no scale field.
-- The volcano sits one rung above the valley battlefield on the same tier ladder
-- (scratch/MUSTAFAR-GAPS.md): live BOSS -> APEX 140, live ELITE -> BOSS 120. The valley
-- is Chapter Three task 6 and the volcano is the campaign's last content, gated behind
-- it, so the two cannot sit on the same rung. Live encodes that gap in raw HP -- the
-- volcano bosses run 545k-950k against the valley's numbers -- and the ladder replaces
-- raw HP, so the gap has to move onto the ladder or it disappears. That one-rung shift
-- is the only authored number here; every other field is copied from a tier anchor or
-- from live.
som_volcano_two_hk77 = Creature:new {
	customName = "an HK-77 Assault Droid",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_ANDROID,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
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
	diet = HERBIVORE,

	templates = {"object/mobile/som/hk77.iff"},
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
	primaryAttacks = merge(marksmanmaster,bountyhuntermaster),
	secondaryAttacks = bountyhuntermaster
}

CreatureTemplates:addCreatureTemplate(som_volcano_two_hk77, "som_volcano_two_hk77")
