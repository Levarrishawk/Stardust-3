-- heroic_echo_snowtrooper -- Echo Base heroic Imperial snowtrooper.
--
-- SOURCED (SOE, creatures.tab:6154): creatureName heroic_echo_snowtrooper,
-- BaseLevel 90, difficultyClass ELITE, socialGroup hoth, faction Imperial,
-- template snowtrooper_s01.iff, primary_weapon imperial_hoth_rifle, niche npc,
-- death_blow instant, objvars int:ai.noChatMood=1,float:regen_mod.health=0.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED (Stardust rung ELITE 85, Mustafar ladder).
-- Anchored on mobile/dathomir/spiderclan_crawler.lua (level 85, chanceHit 0.75,
-- damageMin 555, damageMax 820, baseXp 8130, baseHAM 12000, baseHAMmax 15000, armor 1,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Appearance: object/mobile/snowtrooper_s01.iff (registered in
-- object/custom_content/mobile/snowtrooper_s01.lua:5).
--
-- Weapon: stormtrooper_rifle (mobile/weapon/groups/stormtrooper_rifle.lua, containing
-- rifle_t21.iff and rifle_e11.iff resolving imperial_hoth_rifle).
-- primaryAttacks = merge(riflemanmaster, marksmanmaster) (creatureskills.lua:45,15).
--
-- SOE AI-profile specials (heroic_echo_snowtrooper) not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_snowtrooper = Creature:new {
	customName = "a snowtrooper",
	socialGroup = "hoth",
	faction = "imperial",
	mobType = MOB_NPC,
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
	diet = HERBIVORE,

	templates = {"object/mobile/snowtrooper_s01.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "stormtrooper_rifle",
	secondaryWeapon = "none",
	primaryAttacks = merge(riflemanmaster, marksmanmaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_snowtrooper, "heroic_echo_snowtrooper")
