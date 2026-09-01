-- moral_choice -- the leader of the striking miners.
--
-- SUBSTITUTED, and deliberately a NEW template rather than a conversation bolted
-- onto miner_foreman_on_strike. The .qst never names him either (like the
-- executive he is only a conversation), and som_kenobi_moral_strike_leader.stf
-- is the string table he speaks from.
--
-- miner_foreman_on_strike already ships with exactly the right stats and the
-- right appearance (object/mobile/som/mustafarian_m_02.iff), so this is that
-- template with a name, a conversation and CONVERSABLE. It is NOT that template
-- edited: screenplays/mustafar/regions/smoking_forest_region.lua:50 and :52 spawn
-- two foremen as ambient population at the very camp this quest uses, so wiring
-- the conversation onto the foreman would turn every foreman in the smoking
-- forest into the strike leader.
--
-- ATTACKABLE and unfactioned, like the miners around him. Nothing in the .qst
-- kills him; s_207 and s_208 are what he says on the player's second and third
-- visit, so he has to stay standing.
som_kenobi_moral_strike_leader = Creature:new {
	customName = "the Strike Leader",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 45,
	chanceHit = 0.44,
	damageMin = 345,
	damageMax = 400,
	baseXp = 4461,
	baseHAM = 9300,
	baseHAMmax = 11300,
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
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/mustafarian_m_02.iff"},
	lootGroups = {},

	-- Primary and secondary weapon should be different types (rifle/carbine, carbine/pistol, rifle/unarmed, etc)
	-- Unarmed should be put on secondary unless the mobile doesn't use weapons, in which case "unarmed" should be put primary and "none" as secondary
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "som_kenobi_moral_strike_leader",

	-- primaryAttacks and secondaryAttacks should be separate skill groups specific to the weapon type listed in primaryWeapon and secondaryWeapon
	-- Use merge() to merge groups in creatureskills.lua together. If a weapon is set to "none", set the attacks variable to empty brackets
	primaryAttacks = { },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_kenobi_moral_strike_leader, "som_kenobi_moral_strike_leader")
