object_draft_schematic_furniture_furniture_collection_pob_chair = object_draft_schematic_furniture_shared_furniture_collection_pob_chair:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Pob Chair",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_furniture.iff",
   
   xpType = "crafting_structure_general", 
   xp = 1250, 

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
   resourceQuantities = {150, 200, 10},
   contribution = {100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/pob_chair_furniture_hue_01.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_collection_pob_chair, "object/draft_schematic/furniture/furniture_collection_pob_chair.iff")
