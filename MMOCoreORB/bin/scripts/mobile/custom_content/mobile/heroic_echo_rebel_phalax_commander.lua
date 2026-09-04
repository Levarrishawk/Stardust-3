-- heroic_echo_rebel_phalax_commander -- Echo Base heroic Rebel Phalanx Commander.
--
-- SOURCED (SOE, creatures.tab:6159): creatureName heroic_echo_rebel_phalax_commander,
-- BaseLevel 92, difficultyClass BOSS, socialGroup rebel, faction Rebel,
-- template rebel_mandalorian.iff, minScale 1.15, maxScale 1.15,
-- primary_weapon rebel_hoth_rifle, niche npc, death_blow instant, canNotPunish 1,
-- objvars int:ai.noChatMood=1,int:noPursue=1,float:regen_mod.health=0,int:hp_value=285000.
--
-- SOE hp_value 285000 is recorded here and is NOT used; the BOSS-120 rung governs.
--
-- Stardust rung BOSS 120, OURS, NOT SOURCED (Stardust rung BOSS 120, Mustafar ladder).
-- Anchored on corsec_security_specialist.lua (level 120, chanceHit 4.0,
-- damageMin 745, damageMax 1200, baseXp 11390, baseHAM 44000, baseHAMmax 54000, armor 2,
-- resists {90,90,90,90,90,90,90,90,-1}).
--
-- Appearance: object/mobile/rebel_mandalorian.iff (registered in
-- object/custom_content/mobile/rebel_mandalorian.lua:5).
--
-- Weapon: rebel_rifle (mobile/weapon/groups/rebel_rifle.lua, nearest group for
-- rebel_hoth_rifle / rifle_a280.iff).
-- primaryAttacks = merge(riflemanmaster, marksmanmaster) (creatureskills.lua:45,15).
--
-- SOE AI-profile specials (heroic_echo_rebel_phalax_commander) not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_rebel_phalax_commander = Creature:new {
	customName = "a Phalanx Commander",
	socialGroup = "rebel",
	faction = "rebel",
	mobType = MOB_NPC,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
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

	templates = {"object/mobile/rebel_mandalorian.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "rebel_rifle",
	secondaryWeapon = "none",
	primaryAttacks = merge(riflemanmaster, marksmanmaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_rebel_phalax_commander, "heroic_echo_rebel_phalax_commander")
