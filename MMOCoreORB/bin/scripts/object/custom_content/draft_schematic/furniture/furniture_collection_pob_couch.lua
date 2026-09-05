object_draft_schematic_furniture_furniture_collection_pob_couch = object_draft_schematic_furniture_shared_furniture_collection_pob_couch:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Pob Couch",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_furniture.iff",
   
   xpType = "crafting_structure_general", 
   xp = 3250, 

   assemblySkill = "structure_assembly", 
   experimentingSkill = "structure_experimentation", 
   customizationSkill = "structure_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"frame", "upholstery", "seat"},
   ingredientSlotType = {0, 0, 1},
   resourceTypes = {"metal_ferrous", "hide_leathery_endor", "object/tangible/component/clothing/shared_synthetic_cloth.iff"},
   resourceQuantities = {300, 400, 30},
   contribution = {100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/pob_couch_furniture_hue_01.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_collection_pob_couch, "object/draft_schematic/furniture/furniture_collection_pob_couch.iff")
