-- heroic_echo_wampa_boss -- Uncle Joe, optional Echo Base wampa cave boss.
--
-- SOURCED (SOE, creatures.tab:6207): creatureName heroic_echo_wampa_boss,
-- BaseLevel 95, difficultyClass BOSS, socialGroup hoth_wampa_boss, template
-- beast_master/bm_wampa.iff, minScale/maxScale 1.5, hue 16, niche carnivore,
-- aggressive 18, assist 9, death_blow instant, intLootRolls 1, intRollPercent 100,
-- lootTable heroic/echo_base_wampa_boss, collectionRoll 10,
-- collectionLoot echo_base_wampa_boss, primary_weapon blank,
-- primary_weapon_specials echo_base_wampa_boss, scripts
-- theme_park.heroic.echo_base.wampa_boss. armorKinetic/Energy/Blast/Heat/
-- Electric/Acid 0, armorCold 90, armorStun -1. HP_UNCLE_JOE = 818,125
-- (trial.java:248, identical to HP_AXKVA_KIMARU); wampa_boss.java:24.
--
-- APPEARANCE: bm_wampa.iff is registered only as
-- object/intangible/beast/bm_wampa.iff (beast-master PCD), not as a creature
-- mobile. No object/mobile/beast_master/bm_wampa.lua. Fallback
-- object/mobile/wampa.iff (custom_content/mobile/wampa.lua addTemplate).
-- hue 16 not applied (Core3 palettes are 0-7).
--
-- Stardust rung RAID 200, OURS, NOT SOURCED. D-EBe1: SOE 818,125 HP maps to
-- the top rung the way Lev put IG-88 / SD finals at RAID 200. Ladder row
-- taken whole from ROUND-HSD-SPEC.md RAID / rebel_rear_admiral.lua /
-- captain_andal_sait.lua (chanceHit 16, 1145-2000, xp 19008, HAM 160000/195000,
-- armor 3, resists {165,145,35,35,35,35,35,35,-1} from gorax.lua:14).
-- SOE's 818,125 is NGE-scale and is not copied into baseHAM.
--
-- ABILITIES, OURS, NOT SOURCED (D-EBe2): ai_combat_profiles.tab:356
-- echo_base_wampa_boss ("uncle joe encounter on Hoth") =
-- wampa_boss_ice_throw_prep (39s,100%), wampa_boss_tauntaun_throw_prep (21s,100%),
-- bm_dampen_pain_5 (2s once), bm_stomp_5 (9s), bm_shaken_3 (6s once + 18s).
-- grep -n wampa_boss over commands/ and src/ = 0 hits. Nearest Core3 creature
-- attacks: creatureareaknockdown (stomp), stunattack (shaken),
-- posturedownattack (throws), intimidationattack (dampen_pain).
--
-- DNA drop item_cs_dna_wampa 5% (wampa_boss.java:19-20,216-224) NOT PORTED:
-- no template on SD3 (0 files named *dna*wampa*).
-- collectionRoll 10 NOT PORTED (no collection system).
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.

heroic_echo_wampa_boss = Creature:new {
	customName = "Uncle Joe",	-- OURS, NOT SOURCED (no client string ships; SOE java identifiers uncleJoeAdds / UNCLE_JOE_MAX_DISTANCE / "Uncle Joe Hate List")
	socialGroup = "hoth_wampa_boss",
	faction = "",
	mobType = MOB_CARNIVORE,
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
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,
	scale = 1.5,

	templates = {"object/mobile/wampa.iff"},
	lootGroups = {
		{
			groups = {
				{group = "echo_base_wampa_boss", chance = 10000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "echo_base_wampa_generic", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	primaryAttacks = { {"creatureareaknockdown",""}, {"stunattack",""}, {"posturedownattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_echo_wampa_boss, "heroic_echo_wampa_boss")
