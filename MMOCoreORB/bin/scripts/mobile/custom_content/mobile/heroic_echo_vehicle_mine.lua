-- heroic_echo_vehicle_mine -- Echo Base heroic vehicle mine (non-combat prop mob).
--
-- SOURCED (SOE, creatures.tab:6175): creatureName heroic_echo_vehicle_mine,
-- BaseLevel 91, difficultyClass NORMAL, socialGroup rebel, faction Rebel,
-- template vehicle_mine.iff, minScale 5.0, maxScale 5.0, niche npc,
-- rootImmune 1, snareImmune 1, stunImmune 1, mezImmune 1, tauntImmune 1,
-- canNotPunish 1, death_blow instant, objvars int:ai.noChatMood=1,float:regen_mod.health=0,
-- scripts theme_park.heroic.echo_base.vehicle_mine.
--
-- Stardust rung STD 70, OURS, NOT SOURCED (Stardust rung STD 70, Mustafar ladder).
-- Anchored on mobile/corellia/gronda_juggernaut.lua (level 70, chanceHit 0.65,
-- damageMin 430, damageMax 570, baseXp 6747, baseHAM 12000, baseHAMmax 15000, armor 0,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Non-combat prop mob; SOE theme_park.heroic.echo_base.vehicle_mine script not ported.
--
-- Appearance: object/mobile/vehicle_mine.iff (registered in
-- object/custom_content/mobile/vehicle_mine.lua:5).
--
-- Weapon & attacks: primaryWeapon "unarmed", primaryAttacks {}, secondaryAttacks = {}.
-- Bitmasks: creatureBitmask NONE, optionsBitmask AIENABLED, pvpBitmask ATTACKABLE.
--
-- SOE AI-profile specials not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_vehicle_mine = Creature:new {
	customName = "an anti-vehicle mine",
	socialGroup = "rebel",
	faction = "rebel",
	mobType = MOB_NPC,
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
	pvpBitmask = ATTACKABLE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED,
	diet = NONE,
	scale = 5.0,

	templates = {"object/mobile/vehicle_mine.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = {},
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_vehicle_mine, "heroic_echo_vehicle_mine")
