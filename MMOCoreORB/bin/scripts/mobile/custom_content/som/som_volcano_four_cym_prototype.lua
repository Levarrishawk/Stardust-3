-- Volcano Battlefield event_four boss, the Cyborg Prototype.
-- Live row som_volcano_four_cym_prototype, level 85 BOSS; level here is APEX tier 140, not live's 85 -- see
-- the note below.
-- Live weapons jedi_dark and jedi_dark_ranged are unregistered, so this falls back to
-- dark_jedi_weapons_gen4 / dark_jedi_weapons_ranged from som_dark_jedi_boss.lua. Live loot
-- mustafar/mustafar_trial_cym and its chronicle relic are absent, so volcano_cyborg_lt.lua's
-- imperial_tier_4 loot block stands in. Live setHp of 950485 is dropped for the APEX tier's
-- baseHAM/baseHAMmax. Live scale 1.2 is dropped because Core3 Creature templates have no scale
-- field. creatureBitmask is STALKER alone, matching the lone-boss shape of som_dark_jedi_boss.lua.
-- The volcano sits one rung above the valley battlefield on the same tier ladder
-- (scratch/MUSTAFAR-GAPS.md): live BOSS -> APEX 140, live ELITE -> BOSS 120. The valley
-- is Chapter Three task 6 and the volcano is the campaign's last content, gated behind
-- it, so the two cannot sit on the same rung. Live encodes that gap in raw HP -- the
-- volcano bosses run 545k-950k against the valley's numbers -- and the ladder replaces
-- raw HP, so the gap has to move onto the ladder or it disappears. That one-rung shift
-- is the only authored number here; every other field is copied from a tier anchor or
-- from live.
som_volcano_four_cym_prototype = Creature:new {
	customName = "the Cyborg Prototype",
	socialGroup = "imperial",
	faction = "",
	mobType = MOB_NPC,
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
	diet = HERBIVORE,

	templates = {"object/mobile/som/volcano_cyborg_lt.iff"},
	lootGroups = {
		{
			groups = {
				{group = "imperial_tier_4", chance = 6000000},
				{group = "armor_attachments", chance = 2000000},
				{group = "clothing_attachments", chance = 2000000}
			},
			lootChance = 7000000
		}
	},

	primaryWeapon = "dark_jedi_weapons_gen4",
	secondaryWeapon = "dark_jedi_weapons_ranged",
	conversationTemplate = "",
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(som_volcano_four_cym_prototype, "som_volcano_four_cym_prototype")
