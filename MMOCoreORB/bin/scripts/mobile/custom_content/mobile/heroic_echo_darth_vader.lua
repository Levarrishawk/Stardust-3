-- heroic_echo_darth_vader -- Echo Base heroic final boss (Darth Vader).
--
-- SOURCED (SOE, creatures.tab:6222): creatureName heroic_echo_darth_vader,
-- BaseLevel 300, difficultyClass BOSS, socialGroup hoth, faction Imperial,
-- template dressed_echo_base_darth_vader.iff, minScale 1.2, maxScale 1.2,
-- primary_weapon jedi_vader -> sword_lightsaber_vader.iff, niche npc,
-- rootImmune 100, snareImmune 100, stunImmune 100, mezImmune 100,
-- canNotPunish 1, tauntImmune 1, death_blow instant,
-- objvars int:ai.noChatMood=1,int:ai.noFollow=1, scripts player.yavin_e3,ai.random_player_target.
--
-- Stardust rung RAID 200, OURS, NOT SOURCED (Stardust rung RAID 200, Mustafar ladder).
-- Anchored on the Mustafar / corellian corvette RAID 200 rung (level 200, chanceHit 16,
-- damageMin 1145, damageMax 2000, baseXp 19008, baseHAM 160000, baseHAMmax 195000, armor 3,
-- resists {165,145,35,35,35,35,35,35,-1}).
--
-- Appearance: object/mobile/dressed_echo_base_darth_vader.iff (registered in
-- object/custom_content/mobile/dressed_echo_base_darth_vader.lua:5).
--
-- Weapon: darth_vader_weapons (mobile/weapon/groups/darth_vader_weapons.lua,
-- which contains object/weapon/melee/sword/sword_lightsaber_vader.iff).
-- primaryAttacks = merge(lightsabermaster, forcepowermaster) (both in creatureskills.lua:52,54).
--
-- SOE AI-profile specials and scripts not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_darth_vader = Creature:new {
	customName = "Darth Vader",
	socialGroup = "hoth",
	faction = "imperial",
	mobType = MOB_NPC,
	level = 200,
	chanceHit = 16,
	damageMin = 1145,
	damageMax = 2000,
	baseXp = 19008,
	baseHAM = 160000,
	baseHAMmax = 195000,
	armor = 3,
	resists = {165,145,35,35,35,35,35,35,-1},
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
	scale = 1.2,

	templates = {"object/mobile/dressed_echo_base_darth_vader.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "darth_vader_weapons",
	secondaryWeapon = "none",
	primaryAttacks = merge(lightsabermaster, forcepowermaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_darth_vader, "heroic_echo_darth_vader")
