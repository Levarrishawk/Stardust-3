-- heroic_tusken_kav_golder -- escort NPC / phase-1 greeter. Pre-existing placeholder
-- replaced in place (D2, "fix pre-existing, carefully"). Same registered name.
--
-- SOURCED (SOE, creatures.tab:2181): creatureName heroic_tusken_kav_goldor (SOE creature
-- key is goldor; conversation file, object template and this SD3 mobile are all golder --
-- PART 5.3 spelling trap), BaseLevel 90, difficultyClass BOSS, socialGroup espa,
-- template heroic_tusken_kav_golder.iff, lootTable npc/tusken:tusken_normal.
-- All eight armor columns = 0. 5 spawn instances across cantina.tab.
--
-- Stardust rung APEX 140, invulnerable in play, OURS, NOT SOURCED. Must not die
-- (OnDeath:triggerId:instance_fail); phases 3-4 set isInvulnerable=1 in the tab anyway.
-- pvpBitmask ATTACKABLE so Tuskens can still kill him if the players fail to protect
-- him (cantina.tab:25 OnDeath:instance_fail). Script sets INVULNERABLE on the greeter
-- and on the phase-3 rally.
--
-- LOST: kav_tusken_killer (8 s, 100%). SOURCED (SOE, ai_combat_profiles.tab:137).
-- 0 hits on SD3. Not faked. rebel_pistol is the nearest shipped group (militia/medic).
--
-- customName "Kav Golder" -- OURS, NOT SOURCED (PART 5.3: no shipped name key; the name
-- exists only inside dialogue body text).
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_tusken_kav_golder = Creature:new {
	customName = "Kav Golder",
	socialGroup = "townsperson",
	faction = "townsperson",
	mobType = MOB_NPC,
	level = 140,
	chanceHit = 4.5,
	damageMin = 900,
	damageMax = 1460,
	baseXp = 11015,
	baseHAM = 52000,
	baseHAMmax = 64000,
	armor = 0,
	resists = {0,0,0,0,0,0,0,0,-1},
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/heroic_tusken_kav_golder.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "rebel_pistol",
	secondaryWeapon = "unarmed",
	primaryAttacks = merge(marksmanmaster, pistoleermaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_tusken_kav_golder, "heroic_tusken_kav_golder")
