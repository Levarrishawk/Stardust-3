object_draft_schematic_furniture_furniture_collection_dejarik_table = object_draft_schematic_furniture_shared_furniture_collection_dejarik_table:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Dejarik Table Reward",

   craftingToolTab = 524288, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_electronics.iff",
   
   xpType = "crafting_general", 
   xp = 140, 

   assemblySkill = "general_assembly", 
   experimentingSkill = "general_experimentation", 
   customizationSkill = "clothing_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"dejarik_play_surface", "dejarik_player_1_pieces", "dejarik_player_2_pieces", "dejarik_table_legs", "dejarik_accents", "dejarik_power"},
   ingredientSlotType = {0, 0, 0, 0, 0, 0},
   resourceTypes = {"metal_ferrous", "bone", "wood", "metal_ferrous", "copper", "energy_renewable"},
   resourceQuantities = {50, 30, 30, 150, 35, 100},
   contribution = {100, 100, 100, 100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/dejarik_table_reward.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_collection_dejarik_table, "object/draft_schematic/furniture/furniture_collection_dejarik_table.iff")
