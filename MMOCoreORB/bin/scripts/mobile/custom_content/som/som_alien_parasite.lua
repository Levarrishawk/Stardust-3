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
-- LEFT ALONE ON PURPOSE: the stat block (level 70, 550-800 damage, 16000/19000
-- HAM, chanceHit, resists, baseXp), creatureBitmask, and the empty lootGroups
-- block are Levarris's port values. They are balance, not wiring, and are not
-- mine to retune.
som_alien_parasite = Creature:new {
	customName = "Alien Parasite",
	socialGroup = "som_alien_parasite",
	faction = "",
	mobType = MOB_CARNIVORE,
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/som_alien_parasite.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { {"blindattack",""}, {"dizzyattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_alien_parasite, "som_alien_parasite")
