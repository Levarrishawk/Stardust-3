-- heroic_echo_launch_rebel -- Echo Base Rebel Hoth Transportation NPC.
--
-- SOURCED (SOE, creatures.tab:6205): creatureName heroic_echo_launch_rebel,
-- notes "Rebel Hoth Transportation NPC", BaseLevel 100, difficultyClass ELITE,
-- socialGroup rebel, faction Rebel, template rebel_snow_soldier, invulnerable 1,
-- niche npc, objvars string:item.vendor.vendor_table=echo_base_rebel_items,
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
-- Appearance substitution: SOE rebel_snow_soldier is NOT REGISTERED under object/mobile/.
-- Substituted object/mobile/dressed_rebel_snow_echo_base_m_01.iff (registered placeholder
-- from object/custom_content/mobile/dressed_rebel_snow_echo_base_m_01.lua:5).
--
-- Weapon & attacks: primaryWeapon "unarmed", secondaryWeapon "none", primaryAttacks {}, secondaryAttacks = {}.
--
-- SOE AI-profile specials (commando_2) not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_launch_rebel = Creature:new {
	customName = "Rebel Transportation Specialist",
	socialGroup = "rebel",
	faction = "rebel",
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

	templates = {"object/mobile/dressed_rebel_snow_echo_base_m_01.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_launch_rebel, "heroic_echo_launch_rebel")
