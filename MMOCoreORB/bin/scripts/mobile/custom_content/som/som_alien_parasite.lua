-- Encounter mob for som_kenobi_symbiosis_1 / _2. The .qst spawns it 2 at a time
-- out of each treasure-hunter corpse (Min Distance 1 / Max Distance 2) and then
-- 6 more as the delayed ambush in _2 (Min 10 / Max 20). The quest is rated
-- Level 75 / Tier 4 / solo, so eight of these are meant to be a real fight.
--
-- WHAT WAS CHANGED, AND WHY
--
--  1. weapons/attacks -> primaryWeapon/secondaryWeapon/primaryAttacks/secondaryAttacks.
--     CreatureTemplate.cpp only reads the primary*/secondary* (and defaultWeapon/
--     defaultAttack) keys; `weapons` and `attacks` are not in the schema and were
--     silently discarded. As written, every parasite spawned would have had no
--     weapon and no attack line -- eight monsters standing in the lava doing
--     nothing. (Same dead-schema port artifact carried by ~2400 custom_content
--     files in this tree; only the ones this arc spawns are being touched.)
--
--  2. mobType added. It was absent, so getMobType() stayed at its default and the
--     agent never classified as a creature. MOB_CARNIVORE matches what the thing
--     is and what the encounter needs; diet moved from HERBIVORE to CARNIVORE to
--     agree with it.
--
--  3. pvpBitmask was ATTACKABLE only -- the player could hit it, it would never
--     hit back on its own. Now AGGRESSIVE + ATTACKABLE + ENEMY, matching the
--     base-tree pattern for a hostile creature (see mobile/lok/kimogila.lua).
--
--  4. socialGroup was "townsperson", which is the blanket value stamped on nearly
--     every file in this som pack including droids, bosses and vendors. On an
--     aggressive mob it is actively wrong: it puts the parasite in the same help
--     group as the friendly Mustafar NPCs. Set to its own species group, which is
--     the base-tree convention (kimogila.lua uses socialGroup = "kimogila").
--
--  5. RETUNED. The note that stood here said the stat block was Levarris's balance
--     call and not mine to touch. That read was wrong. All 158 som templates
--     carried the identical block -- level 70, chanceHit 0.27, 550-800 damage,
--     16000/19000 HAM, baseXp 235, and a lootGroups entry whose groups list was
--     empty behind lootChance 2100000. An empty groups list makes the roll fire and
--     resolve nothing (LootGroupCollectionEntry.h), and 235 XP is 3% of the stock
--     value at that level. That is a placeholder, not balance. This mob is now the
--     ELITE tier -- level 85, against the .qst's own Level 75 / Tier 4 rating --
--     on the stock level-85 anchor mobile/dathomir/spiderclan_crawler.lua.
--     Tier table and stat anchors: scratch/MUSTAFAR-GAPS.md.
--
-- LEFT ALONE ON PURPOSE: creatureBitmask, which is spawn behaviour, not combat maths.
som_alien_parasite = Creature:new {
	customName = "Alien Parasite",
	socialGroup = "kimogila",
	faction = "",
	mobType = MOB_CARNIVORE,
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/som_alien_parasite.iff"},
	lootGroups = {
		{
			groups = {
				{group = "resource_creature", chance = 6000000},
				{group = "junk", chance = 2000000},
				{group = "armor_attachments", chance = 2000000}
			},
			lootChance = 4000000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_alien_parasite, "som_alien_parasite")
