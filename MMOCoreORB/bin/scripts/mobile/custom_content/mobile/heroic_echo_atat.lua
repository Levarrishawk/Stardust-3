-- heroic_echo_atat -- Echo Base heroic AT-AT walker.
--
-- SOURCED (SOE, creatures.tab:6151): creatureName heroic_echo_atat,
-- BaseLevel 200, difficultyClass BOSS, socialGroup atat, faction Imperial,
-- template atat.iff, minScale 1.3, maxScale 1.3, niche vehicle,
-- rootImmune 100, snareImmune 100, stunImmune 100, mezImmune 100,
-- canNotPunish 1, death_blow instant.
--
-- Stardust rung RAID 200, OURS, NOT SOURCED (Stardust rung RAID 200, Mustafar ladder).
-- Anchored on the Mustafar / corellian corvette RAID 200 rung (level 200, chanceHit 16,
-- damageMin 1145, damageMax 2000, baseXp 19008, baseHAM 160000, baseHAMmax 195000, armor 3,
-- resists {165,145,35,35,35,35,35,35,-1}).
--
-- Appearance: object/mobile/atat.iff (registered in object/mobile/atat.lua:79).
--
-- primaryWeapon is "unarmed" because vehicle_atst_ranged.iff is not registered in any
-- mobile/weapon/groups/ file (vehicles use unarmed / built-in weapons).
--
-- SOE AI-profile specials not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_atat = Creature:new {
	customName = "an AT-AT",
	socialGroup = "atat",
	faction = "imperial",
	mobType = MOB_VEHICLE,
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
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,
	scale = 1.3,

	templates = {"object/mobile/atat.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_atat, "heroic_echo_atat")
