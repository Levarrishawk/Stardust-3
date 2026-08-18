-- Kill-and-loot target for som_kenobi_reunite_shard_2, task 16 (taskName shard6):
-- CreatureType = som_mustafarian_phantom_bandit, LootItemName "Crystal splinters",
-- NumberItemsRequired 1, LootDropPercent 60. Five of these are already placed in
-- the world by screenplays/mustafar/regions/storm_lord_region.lua on the canyon
-- approach (457-483 / 5692-5796), which sits inside the .qst's own task area
-- (485, 5764, radius 100) -- so the quest leg is served by Levarris's existing
-- population and does not spawn any extra.
--
-- WHAT WAS CHANGED, AND WHY
--
--  1. weapons/attacks -> primaryWeapon/secondaryWeapon/primaryAttacks/secondaryAttacks.
--     CreatureTemplate.cpp only reads the primary*/secondary* (and defaultWeapon/
--     defaultAttack) keys; `weapons` and `attacks` are not in the schema and were
--     silently discarded. As written, all five bandits had no weapon and no attack
--     line -- level 70 mobs that cannot swing at anything. The values themselves
--     are Levarris's and are carried across unchanged: pirate_weapons_light is a
--     real group in mobile/weapon/groups/, and marksmannovice/brawlernovice are
--     real groups in creatureskills.lua. Only the key names moved. The split
--     follows the base-tree rule quoted in the template comments: the two weapons
--     should be different types, so the ranged group stays primary and unarmed
--     takes secondary, with the matching attack group on each.
--     (Same dead-schema port artifact carried by ~2400 custom_content files in
--     this tree; only the ones this arc needs are being touched.)
--
--  2. mobType added. It was absent, so getMobType() stayed at its default and the
--     agent never classified. MOB_NPC is correct -- this is a humanoid bandit, not
--     a creature; it is also what makes the KILLEDCREATURE credit in
--     screenplays/mustafar/quest/reunite_shard.lua read a sane template name.
--
--  3. socialGroup was "townsperson", the blanket value stamped on nearly every file
--     in this som pack. On a bandit it is actively wrong: it put the phantoms in
--     the same mutual-help group as the friendly Mustafar NPCs, so attacking one
--     would have called civilians in. "thug" is the base-tree group for exactly
--     this (see mobile/corellia/lerat_zom.lua, mobile/quest/yavin4/ruwan_thug.lua)
--     and is already used by the sibling som files som_pwwoz_thug_1/_2 and
--     som_kenobi_sucker.
--
-- LEFT ALONE ON PURPOSE:
--   * pvpBitmask stays ATTACKABLE. These five are placed as idlewander scenery on
--     the canyon approach by storm_lord_region.lua; flipping them to AGGRESSIVE
--     would change how that region plays for everyone, and the quest leg does not
--     need it -- the player is the one starting the fight. That is Levarris's
--     region design, not quest wiring, so it is not mine to change.
--   * the stat block (level 70, 550-800 damage, 16000/19000 HAM, chanceHit,
--     resists, baseXp), creatureBitmask and the empty lootGroups block are his
--     port values. They are balance, not wiring.
som_mustafarian_phantom_bandit = Creature:new {
	customName = "a Phantoms Bandit",
	socialGroup = "thug",
	faction = "",
	mobType = MOB_NPC,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/som_mustafarian_phantom_bandit.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = marksmannovice,
	secondaryAttacks = brawlernovice
}

CreatureTemplates:addCreatureTemplate(som_mustafarian_phantom_bandit, "som_mustafarian_phantom_bandit")
