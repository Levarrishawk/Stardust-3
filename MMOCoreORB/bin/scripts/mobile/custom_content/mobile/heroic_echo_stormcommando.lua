-- heroic_echo_stormcommando -- Echo Base heroic Imperial storm commando.
--
-- SOURCED (SOE, creatures.tab:6156): creatureName heroic_echo_stormcommando,
-- BaseLevel 90, difficultyClass BOSS, socialGroup hoth, faction Imperial,
-- template shocktrooper_blue.iff, minScale 1.15, maxScale 1.15,
-- primary_weapon imperial_hoth_rifle, niche npc, death_blow instant, canNotPunish 1,
-- objvars int:ai.noChatMood=1,int:noPursue=1,float:regen_mod.health=0.
--
-- Stardust rung NAMED 100, OURS, NOT SOURCED (Stardust rung NAMED 100, Mustafar ladder).
-- Anchored on mobile/corellia/acun_solari.lua (level 100, chanceHit 1,
-- damageMin 645, damageMax 1000, baseXp 9429, baseHAM 24000, baseHAMmax 30000, armor 1,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Appearance: object/mobile/shocktrooper_blue.iff (registered in
-- object/custom_content/mobile/shocktrooper_blue.lua:5).
--
-- Weapon: stormtrooper_rifle (mobile/weapon/groups/stormtrooper_rifle.lua, containing
-- rifle_t21.iff and rifle_e11.iff resolving imperial_hoth_rifle).
-- primaryAttacks = merge(riflemanmaster, marksmanmaster) (creatureskills.lua:45,15).
--
-- SOE AI-profile specials (heroic_echo_stormcommando) not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_stormcommando = Creature:new {
	customName = "a storm commando",
	socialGroup = "hoth",
	faction = "imperial",
	mobType = MOB_NPC,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
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
	scale = 1.15,

	templates = {"object/mobile/shocktrooper_blue.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "stormtrooper_rifle",
	secondaryWeapon = "none",
	primaryAttacks = merge(riflemanmaster, marksmanmaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_stormcommando, "heroic_echo_stormcommando")
