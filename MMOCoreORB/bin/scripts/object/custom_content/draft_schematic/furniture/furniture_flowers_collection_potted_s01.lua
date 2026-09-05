object_draft_schematic_furniture_furniture_flowers_collection_potted_s01 = object_draft_schematic_furniture_shared_furniture_flowers_collection_potted_s01:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Potted Flower Reward 01",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_furniture.iff",
   
   xpType = "crafting_structure_general", 
   xp = 200, 

   assemblySkill = "structure_assembly", 
   experimentingSkill = "structure_experimentation", 
   customizationSkill = "structure_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"pot", "tree", "greenery"},
   ingredientSlotType = {0, 0, 0},
   resourceTypes = {"mineral", "wood_deciduous_yavin4", "chemical"},
   resourceQuantities = {40, 40, 40},
   contribution = {100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/potted_flower_reward_01.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_flowers_collection_potted_s01, "object/draft_schematic/furniture/furniture_flowers_collection_potted_s01.iff")
