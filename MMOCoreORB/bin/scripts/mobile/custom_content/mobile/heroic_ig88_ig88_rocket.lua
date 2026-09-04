-- heroic_ig88_ig88_rocket -- IG-88, the factory arena's final boss.
--
-- SOURCED (SOE, creatures.tab:2166): creatureName heroic_ig88_ig88_rocket,
-- BaseLevel 90, difficultyClass BOSS, socialGroup ig88, template ig_88_rocket.iff,
-- lootTable heroic/heroic:ig88, primary_weapon droid_rocket_launcher.iff,
-- specials droid_1, attackSpeed 2, minScale/maxScale 2, stalker 1, aggressive 0,
-- minCash 80000 / maxCash 160000, rootImmune/snareImmune/stunImmune/mezImmune 100,
-- resists K85 E95 Blast100 Heat60 Cold100 Electric25 Acid40 Stun85,
-- chronicleLootCategory heroic_ig88. niche android -> MOB_ANDROID.
--
-- Stardust rung RAID 200, OURS, NOT SOURCED. SOE's 90/BOSS maps to RAID because
-- this is the heroic's final boss; the rung Lev's own exar_kun sits on
-- (mobile/custom_content/mobile/exar_kun.lua:6, level 200). Stat row taken from
-- that template (chanceHit 4.75, 1770-2600, baseXp 12424, baseHAM 610000, armor 2).
--
-- SOE ig88.java:220-243 quadruples HEALTH and doubles ACTION at the moment he
-- engages (setInvulnerable false, then setMaxAttrib). Lev has no invulnerability
-- idiom; the x4 is folded into the authored RAID 200 baseHAM here instead of
-- applying it at runtime. OURS, NOT SOURCED.
--
-- WEAPON FALLBACK, OURS, NOT SOURCED: SOE's droid_rocket_launcher.iff and
-- droid_flamethrower*.iff cannot be used. All 16 files under
-- object/custom_content/weapon/droid/ are byte-identical copies of
-- 2h_sword_kashyyk (PART 3.7); they are fenced and not repaired this round.
-- Substitute is the shipped group commando_ranged, whose first entry is
-- object/weapon/ranged/rifle/rifle_flame_thrower.iff -- the flamethrower half
-- of SOE's loop is exact; the rocket half has no Core3 equivalent.
-- SOURCED (SOE, datatables/ai/ai_combat_profiles.tab row droid_1): the profile creatures.tab:2166
-- names for this creature has ALL action columns EMPTY -- SOE gave IG-88 no profile-driven
-- specials; his rocket/flame/grenade abilities are script-driven (ig88.java) and have no SD3 command.
-- primaryAttacks = commandomaster (creatureskills.lua:42) -- OURS, NOT SOURCED, the nearest group.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_ig88_ig88_rocket = Creature:new {
	customName = "IG-88",
	socialGroup = "ig88",
	faction = "",
	mobType = MOB_ANDROID,
	level = 200,
	chanceHit = 4.75,
	damageMin = 1770,
	damageMax = 2600,
	baseXp = 12424,
	baseHAM = 610000,
	baseHAMmax = 610000,
	armor = 2,
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
	creatureBitmask = STALKER,
	optionsBitmask = AIENABLED,
	diet = NONE,
	scale = 2,

	templates = {"object/mobile/ig_88_rocket.iff"},
	lootGroups = {
		{
			groups = {
				{group = "ig88_heroic_drops", chance = 10000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "ig88_heroic_drops", chance = 10000000}
			},
			lootChance = 10000000
		},
		{
			groups = {
				{group = "ig88_heroic_drops", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	conversationTemplate = "",
	primaryWeapon = "commando_ranged",
	secondaryWeapon = "none",
	primaryAttacks = commandomaster,
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_ig88_ig88_rocket, "heroic_ig88_ig88_rocket")
