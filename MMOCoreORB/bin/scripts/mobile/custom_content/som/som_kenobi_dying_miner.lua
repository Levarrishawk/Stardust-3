-- som_obi_wan_signal_1 target -- the dying miner at the new mining facility.
--
-- SUBSTITUTED, and the gap is recorded rather than papered over. The quest is
-- one Wait-for-Signal task on 'dyingMiner' and nothing else; there is no
-- creature template, no conversation table and no string for him anywhere in
-- the shipped data. Obi-Wan's s_26 ("Go seek out a dying miner who is at the
-- new mining facility") and s_27 ("The miner had been attacked with a
-- lightsaber") are the only two lines about him that ship. So he is built the
-- same way the symbiosis corpses were: scenery with a screenplay-supplied
-- radial, because SOE left nothing for him to say.
--
-- The appearance is object/mobile/som/mustafarian_m_01.iff, which ships and is
-- registered from object/custom_content/mobile/som/serverobjects.lua. Mensix's
-- workforce is already Mustafarian in this arc -- som_kenobi_moral_strike_leader
-- uses mustafarian_m_02.iff -- so the other one of the pair is used here to keep
-- the two from being the same face.
--
-- Scenery only: never fights, never dies. The 'Examine the dying miner' radial
-- is supplied at spawn time by the screenplay via SceneObject:setObjectMenuComponent().
som_kenobi_dying_miner = Creature:new {
	customName = "a Dying Miner",
	socialGroup = "",
	faction = "",
	mobType = MOB_NPC,
	level = 70,
	chanceHit = 0.27,
	damageMin = 550,
	damageMax = 800,
	baseXp = 235,
	baseHAM = 16000,
	baseHAMmax = 19000,
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
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = AIENABLED + INVULNERABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/som/mustafarian_m_01.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_kenobi_dying_miner, "som_kenobi_dying_miner")
