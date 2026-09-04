-- heroic_echo_probe_droid -- Echo Base heroic Imperial probe droid.
--
-- SOURCED (SOE, creatures.tab:6176): creatureName heroic_echo_probe_droid,
-- BaseLevel 90, difficultyClass NORMAL, socialGroup hoth, faction (empty),
-- template probot.iff, primary_weapon object/weapon/ranged/droid/droid_probot_ranged.iff,
-- niche droid, death_blow instant, objvars int:ai.noChatMood=1,float:regen_mod.health=0.
--
-- Stardust rung STD 70, OURS, NOT SOURCED (Stardust rung STD 70, Mustafar ladder).
-- Anchored on mobile/corellia/gronda_juggernaut.lua (level 70, chanceHit 0.65,
-- damageMin 430, damageMax 570, baseXp 6747, baseHAM 12000, baseHAMmax 15000, armor 0,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- mobType MOB_DROID using defaultWeapon and defaultAttack per the shipped droid schema
-- (mobile/misc/probot.lua, mobile/lok/droideka.lua).
--
-- Appearance: object/mobile/probot.iff (registered in object/mobile/probot.lua:48).
--
-- Weapon: defaultWeapon = "object/weapon/ranged/droid/droid_probot_ranged.iff",
-- defaultAttack = "attack".
--
-- SOE AI-profile specials (droid_8) not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_probe_droid = Creature:new {
	customName = "a probe droid",
	socialGroup = "hoth",
	faction = "",
	mobType = MOB_DROID,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
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
	diet = NONE,

	templates = {"object/mobile/probot.iff"},
	lootGroups = {},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_probot_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(heroic_echo_probe_droid, "heroic_echo_probe_droid")
