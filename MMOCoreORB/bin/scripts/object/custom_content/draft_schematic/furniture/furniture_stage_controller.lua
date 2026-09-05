object_draft_schematic_furniture_furniture_stage_controller = object_draft_schematic_furniture_shared_furniture_stage_controller:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Stage Controller",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 15, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_furniture.iff",
   
   xpType = "crafting_structure_general", 
   xp = 250, 

   assemblySkill = "structure_assembly", 
   experimentingSkill = "structure_experimentation", 
   customizationSkill = "structure_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"stage_controller_control", "stage_controller_remote", "stage_controller_frame", "stage_controller_wiring", "stage_controller_display"},
   ingredientSlotType = {1, 1, 0, 0, 0},
   resourceTypes = {"object/tangible/component/item/shared_electronic_control_unit_advanced.iff", "object/tangible/component/item/shared_micro_sensor_suite.iff", "steel", "copper", "gemstone"},
   resourceQuantities = {1, 1, 100, 50, 50},
   contribution = {100, 100, 100, 100, 100},


   targetTemplate = "object/tangible/item/entertainer_console/stage_controller.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_stage_controller, "object/draft_schematic/furniture/furniture_stage_controller.iff")
