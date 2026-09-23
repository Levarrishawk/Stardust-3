-- heroic_ig88_super_battle_droid -- phase-5 gate. Two of them; they attack the
-- patrol mouse droids, not the players (ig88_super_battle_droid.java:85-110).
--
-- SOURCED (SOE, creatures.tab:2167): creatureName heroic_ig88_super_battle_droid,
-- BaseLevel 90, difficultyClass BOSS, socialGroup ig88, template battle_droid.iff,
-- lootTable npc/boss_npc:boss_npc_81_90, primary_weapon droid_flamethrower_nomuzzle.iff,
-- attackSpeed 2, minScale/maxScale 2, tauntImmune 1. niche android -> MOB_ANDROID.
-- Resists share the five-combat-droid row: K85 E95 Blast100 Heat60 Cold100
-- Electric25 Acid40 Stun85.
--
-- Stardust rung APEX 140, OURS, NOT SOURCED. SOE's 90/BOSS maps to APEX because
-- this is the phase-5 gate (two of them, and they double their own health at
-- engage -- ig88_super_battle_droid.java:77-84). Anchor is Lev's
-- mobile/custom_content/mobile/exar_kun_caretaker.lua (level 140, baseHAM 225000,
-- armor 3). The SOE runtime x2 HEALTH is folded into that authored HAM rather
-- than applied at engage. OURS, NOT SOURCED.
--
-- WEAPON FALLBACK, OURS, NOT SOURCED: droid_flamethrower_nomuzzle.iff is one of
-- the 16 corrupt Kashyyyk-sword copies (PART 3.7). Substitute commando_ranged
-- (shipped rifle_flame_thrower.iff). primaryAttacks = commandomid
-- (creatureskills.lua:31), one rung below the boss, matching APEX vs RAID.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_ig88_super_battle_droid = Creature:new {
	customName = "a super battle droid",
	socialGroup = "ig88",
	faction = "",
	mobType = MOB_ANDROID,
	level = 140,
	chanceHit = 0.24,
	damageMin = 1540,
	damageMax = 1845,
	baseXp = 6200,
	baseHAM = 225000,
	baseHAMmax = 225000,
	armor = 3,
	resists = {85,95,100,60,100,25,40,85,-1},
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
	scale = 2,

	templates = {"object/mobile/battle_droid.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "commando_ranged",
	secondaryWeapon = "none",
	primaryAttacks = commandomid,
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_ig88_super_battle_droid, "heroic_ig88_super_battle_droid")
