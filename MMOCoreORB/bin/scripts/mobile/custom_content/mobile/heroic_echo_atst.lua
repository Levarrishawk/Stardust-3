-- heroic_echo_atst -- Echo Base heroic AT-ST walker.
--
-- SOURCED (SOE, creatures.tab:6152): creatureName heroic_echo_atst,
-- BaseLevel 90, difficultyClass BOSS, socialGroup imperial, faction Imperial,
-- template atst.iff, niche vehicle, rootImmune 100, snareImmune 100,
-- stunImmune 100, mezImmune 100, canNotPunish 1, death_blow instant,
-- objvars int:hp_value=105000,float:regen_mod.health=0.
--
-- SOE hp_value 105000 is recorded here and is NOT used; the NAMED-100 rung governs.
--
-- Stardust rung NAMED 100, OURS, NOT SOURCED (Stardust rung NAMED 100, Mustafar ladder).
-- Anchored on mobile/corellia/acun_solari.lua (level 100, chanceHit 1,
-- damageMin 645, damageMax 1000, baseXp 9429, baseHAM 24000, baseHAMmax 30000, armor 1,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Appearance: object/mobile/atst.iff (registered in object/mobile/atst.lua:48).
--
-- primaryWeapon is "unarmed" (vehicles use unarmed / built-in weapons; nearest heavy
-- group in mobile/weapon/groups/ is imperial_weapons_heavy.lua).
--
-- SOE AI-profile specials not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_atst = Creature:new {
	customName = "an AT-ST",
	socialGroup = "imperial",
	faction = "imperial",
	mobType = MOB_VEHICLE,
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
	diet = NONE,

	templates = {"object/mobile/atst.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_atst, "heroic_echo_atst")
