-- main_quest_3 boss. No proper name exists in any som STF -- Obi-Wan's dialogue
-- says only "A great evil has arrived". The designer-internal task name in
-- som_kenobi_main_quest_3.qst is killSinistro, which was never surfaced in-game.
-- Stats are RETUNED. The note that stood here said the level-70 block was a port
-- value and the arc's final boss was not mine to retune. Its own parenthesis gave
-- the game away -- "same as the trash mobs". That block was the placeholder every
-- one of the 158 som templates carried, not a tuned boss: level 70, chanceHit 0.27,
-- 550-800 damage, 16000/19000 HAM, baseXp 235, and a lootGroups entry whose groups
-- list was empty behind lootChance 2100000, so the kill dropped nothing at all
-- (LootGroupCollectionEntry.h).
--
-- He is now the BOSS tier: level 120 on the stock anchor
-- object/mobile/dungeon/corellian_corvette/.../corsec_security_specialist.lua,
-- which puts him above the level-80 storyArcChapters gate the arc's own
-- conversation handler enforces, and gives him dark_jedi_tier_5 loot.
-- Tier table and stat anchors: scratch/MUSTAFAR-GAPS.md.
som_dark_jedi_boss = Creature:new {
	customName = "a Dark Jedi Master",
	socialGroup = "dark_jedi",
	faction = "",
	mobType = MOB_NPC,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
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

	templates = {"object/mobile/som/som_dark_jedi_boss.iff"},
	lootGroups = {
		{
			groups = {
				{group = "dark_jedi_tier_5", chance = 4000000},
				{group = "holocron_dark", chance = 1500000},
				{group = "color_crystals", chance = 2000000},
				{group = "power_crystals", chance = 1500000},
				{group = "armor_attachments", chance = 1000000}
			},
			lootChance = 7000000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "dark_jedi_weapons_gen4",
	secondaryWeapon = "dark_jedi_weapons_ranged",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(som_dark_jedi_boss, "som_dark_jedi_boss")
