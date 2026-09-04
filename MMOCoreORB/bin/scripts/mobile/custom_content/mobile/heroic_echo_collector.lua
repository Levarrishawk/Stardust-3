-- heroic_echo_collector -- Echo Base heroic Hoth Collector NPC.
--
-- SOURCED (SOE, creatures.tab:6209): creatureName heroic_echo_collector,
-- BaseLevel 90, difficultyClass NORMAL, socialGroup hoth, faction (empty),
-- template hoth_collector.iff, minScale 0.75, maxScale 0.9, invulnerable 1,
-- niche npc, scripts conversation.heroic_echo_collector.
--
-- Stardust rung CIV 45, OURS, NOT SOURCED (Stardust rung CIV 45, Mustafar ladder).
-- Anchored on mobile/corellia/gronda_patriarch.lua (level 45, chanceHit 0.44,
-- damageMin 345, damageMax 400, baseXp 4461, baseHAM 9300, baseHAMmax 11300, armor 0,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Non-combat dressing / invulnerable collector NPC: optionsBitmask = AIENABLED + INVULNERABLE,
-- pvpBitmask = NONE.
-- SOE conversation script (conversation.heroic_echo_collector) not ported.
--
-- Appearance: object/mobile/hoth_collector.iff (registered in
-- object/custom_content/mobile/hoth_collector.lua:5).
--
-- Weapon & attacks: primaryWeapon "unarmed", secondaryWeapon "none", primaryAttacks {}, secondaryAttacks = {}.
--
-- SOE AI-profile specials not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_collector = Creature:new {
	customName = "Hoth Collector",
	socialGroup = "hoth",
	faction = "",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4461,
	baseHAM = 9300,
	baseHAMmax = 11300,
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
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,
	diet = HERBIVORE,
	scale = 0.82,

	templates = {"object/mobile/hoth_collector.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_collector, "heroic_echo_collector")
