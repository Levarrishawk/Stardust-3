--[[
OURS copy of dressed_arena_champion for the post-combat conversation.

ruling 2026-09-04: "ensure kashyyyk is fully done"

dressed_arena_champion keeps the pre-combat tree (ep3_forest_wirartu_arena_convo).
This named copy carries ep3_forest_wirartu_attack_convo. The two trees cannot
share one template.

Contract for the arena screenplay (the branches meet later): the post-fight
spawn is spawnMobile(zone, "dressed_arena_champion_attack", ...).
]]

dressed_arena_champion_attack = Creature:new {
	customName = "human_base_male",
	randomNameType = NAME_GENERIC,
	randomNameTag = true,
	socialGroup = "townsperson",
	faction = "townsperson",
	level = 4,
	chanceHit = 0.24,
	damageMin = 40,
	damageMax = 45,
	baseXp = 62,
	baseHAM = 113,
	baseHAMmax = 118,
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
	optionsBitmask = AIENABLED + CONVERSABLE,
	diet = HERBIVORE,

	templates = {"object/mobile/dressed_arena_champion.iff"},
	lootGroups = {},
	weapons = {},
	conversationTemplate = "ep3_forest_wirartu_attack_convo",
	attacks = {
	}
}

CreatureTemplates:addCreatureTemplate(dressed_arena_champion_attack, "dressed_arena_champion_attack")
