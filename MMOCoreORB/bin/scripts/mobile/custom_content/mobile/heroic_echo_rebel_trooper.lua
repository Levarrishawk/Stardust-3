-- heroic_echo_rebel_trooper -- Echo Base heroic Rebel trooper.
--
-- SOURCED (SOE, creatures.tab:6158): creatureName heroic_echo_rebel_trooper,
-- BaseLevel 90, difficultyClass ELITE, socialGroup rebel, faction Rebel,
-- template rebel_snow_soldier, primary_weapon rebel_hoth_rifle, niche npc,
-- death_blow instant, objvars int:ai.noChatMood=1,float:regen_mod.health=0.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED (Stardust rung ELITE 85, Mustafar ladder).
-- Anchored on mobile/dathomir/spiderclan_crawler.lua (level 85, chanceHit 0.75,
-- damageMin 555, damageMax 820, baseXp 8130, baseHAM 12000, baseHAMmax 15000, armor 1,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Appearance substitution: SOE rebel_snow_soldier is NOT REGISTERED under object/mobile/.
-- Substituted object/mobile/dressed_rebel_snow_echo_base_m_01.iff (registered placeholder
-- from object/custom_content/mobile/dressed_rebel_snow_echo_base_m_01.lua:5).
--
-- Weapon: rebel_rifle (mobile/weapon/groups/rebel_rifle.lua, nearest group for
-- rebel_hoth_rifle / rifle_a280.iff).
-- primaryAttacks = merge(riflemanmaster, marksmanmaster) (creatureskills.lua:45,15).
--
-- SOE AI-profile specials (heroic_echo_rebel_trooper) not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_rebel_trooper = Creature:new {
	customName = "a Rebel trooper",
	socialGroup = "rebel",
	faction = "rebel",
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

	templates = {"object/mobile/dressed_rebel_snow_echo_base_m_01.iff"},
	-- SOURCED (creatures.tab:6158 lootTable); EB-f
	lootGroups = {
		{
			groups = {
				{group = "echo_base_rebel_soldier", chance = 10000000}
			},
			lootChance = 2000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "rebel_rifle",
	secondaryWeapon = "none",
	primaryAttacks = merge(riflemanmaster, marksmanmaster),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_rebel_trooper, "heroic_echo_rebel_trooper")
