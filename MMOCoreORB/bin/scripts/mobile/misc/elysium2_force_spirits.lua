local function createElysiumTwoSpirit(customName, conversationTemplate)
	return Creature:new {
		customName = customName,
		socialGroup = "",
		faction = "",
		level = 1,
		chanceHit = 0,
		damageMin = 0,
		damageMax = 0,
		baseXp = 0,
		baseHAM = 1000,
		baseHAMmax = 1000,
		armor = 0,
		resists = {0, 0, 0, 0, 0, 0, 0, -1, -1},
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
		optionsBitmask = AIENABLED + CONVERSABLE + INVULNERABLE,
		diet = HERBIVORE,
		templates = {"object/mobile/exar_kun.iff"},
		lootGroups = {},
		weapons = {},
		conversationTemplate = conversationTemplate,
		attacks = {},
	}
end

elysium2_force_spirit = createElysiumTwoSpirit("a Force Spirit", "elysiumTwoForceSpiritConvoTemplate")
CreatureTemplates:addCreatureTemplate(elysium2_force_spirit, "elysium2_force_spirit")

elysium2_combat_spirit = createElysiumTwoSpirit("a Spirit of Prowess", "elysiumCombatSpiritConvoTemplate")
CreatureTemplates:addCreatureTemplate(elysium2_combat_spirit, "elysium2_combat_spirit")

elysium2_reflexes_spirit = createElysiumTwoSpirit("a Spirit of Reflex", "elysiumReflexesSpiritConvoTemplate")
CreatureTemplates:addCreatureTemplate(elysium2_reflexes_spirit, "elysium2_reflexes_spirit")

elysium2_crafting_spirit = createElysiumTwoSpirit("a Spirit of Creation", "elysiumCraftingSpiritConvoTemplate")
CreatureTemplates:addCreatureTemplate(elysium2_crafting_spirit, "elysium2_crafting_spirit")

elysium2_senses_spirit = createElysiumTwoSpirit("a Spirit of Insight", "elysiumSensesSpiritConvoTemplate")
CreatureTemplates:addCreatureTemplate(elysium2_senses_spirit, "elysium2_senses_spirit")

elysium2_initiate_spirit = createElysiumTwoSpirit("a Force Spirit", "elysiumInitiateSpiritConvoTemplate")
CreatureTemplates:addCreatureTemplate(elysium2_initiate_spirit, "elysium2_initiate_spirit")
