local visitor = commoner:new {
	socialGroup = "", faction = "", pvpBitmask = NONE, creatureBitmask = NONE,
	customAiMap = "cityPatrol", optionsBitmask = INVULNERABLE + AIENABLED,
}
CreatureTemplates:addCreatureTemplate(visitor, "monument_visitor")

CreatureTemplates:addCreatureTemplate(visitor:new {outfit = "opera_house_hand_reader"}, "monument_holographer")

local function speaker(id, name, appearance, conversation)
	CreatureTemplates:addCreatureTemplate(commoner:new {
		customName = name, randomNameType = NAME_TAG, randomNameTag = false,
		socialGroup = "", faction = "", pvpBitmask = NONE, creatureBitmask = NONE,
		optionsBitmask = INVULNERABLE + INTERESTING + CONVERSABLE,
		templates = {"object/mobile/" .. appearance .. ".iff"}, conversationTemplate = conversation,
	}, id)
end

speaker("monument_welcome_ranger", "Ranger Tavi Neth (Park Information)", "dressed_eisley_officer_bothan_female_01", "monumentWelcome")
speaker("monument_summit_ranger", "Ranger Corin Vale (Summit Guide)", "dressed_eisley_officer_human_male_01", "monumentSummit")
speaker("monument_caf_seller", "Nemi Ral (Caf and Pastries)", "dressed_commoner_naboo_twilek_female_02", "monumentShop")
speaker("monument_food_seller", "Boro Venn (Street Food)", "dressed_commoner_naboo_moncal_male_01", "monumentShop")
speaker("monument_keepsake_seller", "Sela Renn (Plaza Keepsakes)", "dressed_commoner_naboo_zabrak_female_01", "monumentShop")

local function serviceDroid(base, id, name)
	CreatureTemplates:addCreatureTemplate(base:new {
		customName = name, randomNameType = NAME_TAG, randomNameTag = false,
		customAiMap = "cityPatrol", optionsBitmask = INVULNERABLE + AIENABLED,
		socialGroup = "", faction = "", creatureBitmask = NONE, pvpBitmask = NONE,
		primaryWeapon = "none", secondaryWeapon = "none", primaryAttacks = {}, secondaryAttacks = {},
	}, id)
end
serviceDroid(mouse_droid, "monument_cleaner", "MSE (Pavement Cleaner)")
serviceDroid(le_repair_droid, "monument_lamp_tech", "LE-17 (Path Lighting Maintenance)")
