object_draft_schematic_furniture_furniture_collection_hanging_light_02 = object_draft_schematic_furniture_shared_furniture_collection_hanging_light_02:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Hanging Light Reward 02",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_furniture.iff",
   
   xpType = "crafting_structure_general", 
   xp = 110, 

   assemblySkill = "structure_assembly", 
   experimentingSkill = "structure_experimentation", 
   customizationSkill = "structure_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"lamp_body", "lamp_assembly", "shade", "rod"},
   ingredientSlotType = {0, 0, 0, 0},
   resourceTypes = {"metal", "metal", "mineral", "aluminum"},
   resourceQuantities = {40, 25, 20, 15},
   contribution = {100, 100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/hanging_light_reward_02.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_collection_hanging_light_02, "object/draft_schematic/furniture/furniture_collection_hanging_light_02.iff")
