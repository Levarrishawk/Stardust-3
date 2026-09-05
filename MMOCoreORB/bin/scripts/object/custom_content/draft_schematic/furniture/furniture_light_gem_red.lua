object_draft_schematic_furniture_furniture_light_gem_red = object_draft_schematic_furniture_shared_furniture_light_gem_red:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Gem Collection Reward 03",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 18, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_furniture.iff",
   
   xpType = "crafting_structure_general", 
   xp = 340, 

   assemblySkill = "structure_assembly", 
   experimentingSkill = "structure_experimentation", 
   customizationSkill = "structure_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"light_gem_base", "light_gem_gem", "light_gem_light"},
   ingredientSlotType = {0, 0, 0},
   resourceTypes = {"wood", "crystalline_sormahil_firegem", "fuel_petrochem_liquid"},
   resourceQuantities = {30, 50, 25},
   contribution = {100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/gem_collection_reward_03.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_light_gem_red, "object/draft_schematic/furniture/furniture_light_gem_red.iff")
