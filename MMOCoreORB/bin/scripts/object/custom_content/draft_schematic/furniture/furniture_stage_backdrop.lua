object_draft_schematic_furniture_furniture_stage_backdrop = object_draft_schematic_furniture_shared_furniture_stage_backdrop:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Stage Backdrop Generator",

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

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"stage_backdrop_projector", "stage_backdrop_image_module", "stage_backdrop_wiring", "stage_backdrop_casing"},
   ingredientSlotType = {1, 1, 0, 0},
   resourceTypes = {"object/tangible/component/item/shared_electronic_control_unit.iff", "object/tangible/component/item/shared_electronics_memory_module.iff", "copper", "petrochem_inert_polymer"},
   resourceQuantities = {1, 1, 50, 50},
   contribution = {100, 100, 100, 100},


   targetTemplate = "object/tangible/item/entertainer_console/stage_backdrop_generator.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_stage_backdrop, "object/draft_schematic/furniture/furniture_stage_backdrop.iff")
