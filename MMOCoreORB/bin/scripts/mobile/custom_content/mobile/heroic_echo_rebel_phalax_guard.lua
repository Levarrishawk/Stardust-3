-- heroic_echo_rebel_phalax_guard -- Echo Base heroic Rebel Phalanx Guard.
--
-- SOURCED (SOE, creatures.tab:6160): creatureName heroic_echo_rebel_phalax_guard,
-- BaseLevel 90, difficultyClass BOSS, socialGroup rebel, faction Rebel,
-- template rebel_mandalorian_grey.iff, minScale 1.05, maxScale 1.05,
-- primary_weapon rebel_hoth_rifle, niche npc, death_blow instant, canNotPunish 1,
-- skillmods expertise_co_killing_spree_target=2,expertise_co_cluster_bomblet=4,
-- objvars int:ai.noChatMood=1,int:noPursue=1,float:regen_mod.health=0.
--
-- Stardust rung NAMED 100, OURS, NOT SOURCED (Stardust rung NAMED 100, Mustafar ladder).
-- Anchored on mobile/corellia/acun_solari.lua (level 100, chanceHit 1,
-- damageMin 645, damageMax 1000, baseXp 9429, baseHAM 24000, baseHAMmax 30000, armor 1,
-- resists {0,0,0,0,0,0,0,-1,-1}).
--
-- Appearance: object/mobile/rebel_mandalorian_grey.iff (registered in
-- object/custom_content/mobile/rebel_mandalorian_grey.lua:5).
--
-- Weapon: rebel_rifle (mobile/weapon/groups/rebel_rifle.lua, nearest group for
-- rebel_hoth_rifle / rifle_a280.iff).
-- primaryAttacks = merge(riflemanmaster, marksmanmaster) (creatureskills.lua:45,15).
--
-- SOE AI-profile specials and skillmods not ported, no Core3 command.
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_echo_rebel_phalax_guard = Creature:new {
	customName = "a Phalanx Guard",
	socialGroup = "rebel",
	faction = "rebel",
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
	scale = 1.05,

	templates = {"object/mobile/rebel_mandalorian_grey.iff"},
	-- SOURCED (creatures.tab:6160 lootTable); EB-f
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

CreatureTemplates:addCreatureTemplate(heroic_echo_rebel_phalax_guard, "heroic_echo_rebel_phalax_guard")
