-- heroic_echo_launch_imperial -- Echo Base Imperial Hoth Transportation NPC.
--
-- SOURCED (SOE, creatures.tab:6206): creatureName heroic_echo_launch_imperial,
-- notes "Imperial Hoth Transportation NPC", BaseLevel 100, difficultyClass ELITE,
-- socialGroup hoth, faction Imperial, template snowtrooper_s01.iff, invulnerable 1,
-- niche npc, objvars string:item.vendor.vendor_table=echo_base_imperial_items,
-- scripts npc.vendor.vendor,conversation.echo_base_launch.
--
-- Stardust rung CIV 45, OURS, NOT SOURCED (Stardust rung CIV 45, Mustafar ladder).
-- Anchored on mobile/corellia/gronda_patriarch.lua (level 45, chanceHit 0.44,
-- damageMin 345, damageMax 400, baseXp 4461, baseHAM 9300, baseHAMmax 11300, armor 0,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Non-combat dressing / invulnerable vendor NPC: optionsBitmask = AIENABLED + INVULNERABLE,
-- pvpBitmask = NONE.
-- SOE vendor/conversation scripts (npc.vendor.vendor, conversation.echo_base_launch)
-- and vendor table objvars not ported.
--
-- Appearance: object/mobile/snowtrooper_s01.iff (registered in
-- object/custom_content/mobile/snowtrooper_s01.lua:5).
--
-- Weapon & attacks: primaryWeapon "unarmed", secondaryWeapon "none", primaryAttacks {}, secondaryAttacks = {}.
--
-- SOE AI-profile specials (bounty_hunter_4) not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_launch_imperial = Creature:new {
	customName = "Imperial Transportation Specialist",
	socialGroup = "hoth",
	faction = "imperial",
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

	templates = {"object/mobile/snowtrooper_s01.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_launch_imperial, "heroic_echo_launch_imperial")
