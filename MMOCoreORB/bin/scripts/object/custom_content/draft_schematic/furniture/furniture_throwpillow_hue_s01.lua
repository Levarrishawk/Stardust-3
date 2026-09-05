object_draft_schematic_furniture_furniture_throwpillow_hue_s01 = object_draft_schematic_furniture_shared_furniture_throwpillow_hue_s01:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Frn All Feather Pillow Hue S01",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 15, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_furniture.iff",
   
   xpType = "crafting_structure_general", 
   xp = 0, 

   assemblySkill = "structure_assembly", 
   experimentingSkill = "structure_experimentation", 
   customizationSkill = "structure_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"upholstery", "filling"},
   ingredientSlotType = {0, 0},
   resourceTypes = {"hide_wooly", "hide"},
   resourceQuantities = {40, 40},
   contribution = {100, 100},


   targetTemplate = "object/tangible/furniture/all/frn_all_feather_pillow_hue_s01.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_throwpillow_hue_s01, "object/draft_schematic/furniture/furniture_throwpillow_hue_s01.iff")
