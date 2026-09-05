object_draft_schematic_furniture_furniture_framed_beetle_specimen_collection_reward = object_draft_schematic_furniture_shared_furniture_framed_beetle_specimen_collection_reward:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Framed Beetle Specimen",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
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

   ingredientTemplateNames = {"craft_furniture_ingredients_n"},
   ingredientTitleNames = {"frame"},
   ingredientSlotType = {0},
   resourceTypes = {"wood"},
   resourceQuantities = {125},
   contribution = {100},


   targetTemplate = "object/tangible/collection/reward/framed_beetle_specimen.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_framed_beetle_specimen_collection_reward, "object/draft_schematic/furniture/furniture_framed_beetle_specimen_collection_reward.iff")
