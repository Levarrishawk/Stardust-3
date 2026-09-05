object_draft_schematic_droid_component_droid_dance_module = object_draft_schematic_droid_component_shared_droid_dance_module:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Droid Dance Module",

   craftingToolTab = 32, -- (See DraftSchematicObjectTemplate.h)
   complexity = 15, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_electronics.iff",
   
   xpType = "crafting_droid_general", 
   xp = 30, 

   assemblySkill = "droid_assembly", 
   experimentingSkill = "droid_experimentation", 
   customizationSkill = "droid_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_droid_ingredients_n", "craft_droid_ingredients_n", "craft_droid_ingredients_n", "craft_droid_ingredients_n"},
   ingredientTitleNames = {"module_frame", "thermal_shielding", "internal_music_memory", "dance_movement_algarithm_controller"},
   ingredientSlotType = {0, 0, 0, 0},
   resourceTypes = {"steel", "ore", "copper", "metal"},
   resourceQuantities = {150, 200, 300, 500},
   contribution = {100, 100, 100, 100},


   targetTemplate = "object/tangible/component/droid/droid_dance_module.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_droid_component_droid_dance_module, "object/draft_schematic/droid/component/droid_dance_module.iff")
