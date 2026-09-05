object_draft_schematic_furniture_furniture_stage_smoke = object_draft_schematic_furniture_shared_furniture_stage_smoke:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Stage Smoke Machine",

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
   ingredientTitleNames = {"stage_smoke_explosives", "stage_smoke_ignition", "stage_smoke_wiring", "stage_smoke_casing"},
   ingredientSlotType = {1, 1, 0, 0},
   resourceTypes = {"object/tangible/component/item/shared_electronic_control_unit.iff", "object/tangible/component/item/shared_electronic_power_conditioner.iff", "copper", "petrochem_inert_polymer"},
   resourceQuantities = {1, 1, 50, 50},
   contribution = {100, 100, 100, 100},


   targetTemplate = "object/tangible/item/entertainer_console/stage_smoke_machine.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_stage_smoke, "object/draft_schematic/furniture/furniture_stage_smoke.iff")
