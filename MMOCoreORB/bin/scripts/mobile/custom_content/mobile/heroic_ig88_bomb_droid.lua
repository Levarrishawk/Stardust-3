-- heroic_ig88_bomb_droid -- suicide adds in waves of four.
--
-- SOURCED (SOE, creatures.tab:2170): creatureName heroic_ig88_bomb_droid,
-- BaseLevel 90, difficultyClass NORMAL, socialGroup ig88, template battle_droid.iff,
-- lootTable npc/npc_21_30, primary_weapon imperial_sword, specials droid_special_6,
-- attackSpeed 2. niche android -> MOB_ANDROID. Resists differ from the other
-- combat droids: K75 E75 (rest of the shared row: Blast100 Heat60 Cold100
-- Electric25 Acid40 Stun85).
--
-- SOE ig88_bomb_droid.java:20-21 sets HEALTH to a flat 8000 at runtime. That
-- number is recorded here and is NOT used; the ELITE-85 rung governs, the way
-- the som files carry live HP in the header and then apply the ladder.
--
-- Stardust rung ELITE 85, OURS, NOT SOURCED. SOE's 90/NORMAL maps to ELITE
-- (suicide adds in waves of four; must not out-damage the boss). Anchor is
-- som_ancient_guardian_droideka.lua's ELITE-85 row.
--
-- NO CLIENT OR SERVER bomb_droid TEMPLATE EXISTS (Blocker 3 / PART 3.6). No
-- shared_bomb_droid.iff in any TRE; no *bomb_droid* under object/. SOE's own
-- row already says template = battle_droid.iff -- it was a recoloured battle
-- droid (ig88_bomb_droid.java:108-118 hue.setColor INDEX_1=9, INDEX_2=15,
-- hue.setTexture 1,7). Colour is lost: hue.setColor is not bound in SD3 Lua.
-- The explosion effect survives via clienteffect/ig88_bomb_droid_explode.cef
-- at the destroy site in ig88.lua.
--
-- droid_special_6 and melee_special_6 exist in SOE's ai_combat_profiles.tab
-- with ALL action columns empty. primaryWeapon = "imperial_sword",
-- primaryAttacks = brawlermid per PART 3.5. OURS, NOT SOURCED.
--
-- Never weapons/attacks -- CreatureTemplate::readObject() does not read them.
heroic_ig88_bomb_droid = Creature:new {
	customName = "a battle droid",
	socialGroup = "ig88",
	faction = "",
	mobType = MOB_ANDROID,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {75,75,100,60,100,25,40,85,-1},
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

	templates = {"object/mobile/battle_droid.iff"},
	lootGroups = {},

	conversationTemplate = "",
	primaryWeapon = "imperial_sword",
	secondaryWeapon = "none",
	primaryAttacks = brawlermid,
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(heroic_ig88_bomb_droid, "heroic_ig88_bomb_droid")
