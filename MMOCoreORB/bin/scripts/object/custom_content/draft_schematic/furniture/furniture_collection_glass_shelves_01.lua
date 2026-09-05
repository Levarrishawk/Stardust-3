object_draft_schematic_furniture_furniture_collection_glass_shelves_01 = object_draft_schematic_furniture_shared_furniture_collection_glass_shelves_01:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Glass Shelving 01",

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
   ingredientTitleNames = {"glass_shelves", "shelf_fasteners", "shelf_support", "wall_mount"},
   ingredientSlotType = {0, 0, 0, 0},
   resourceTypes = {"gemstone", "metal", "metal", "aluminum"},
   resourceQuantities = {220, 25, 80, 15},
   contribution = {100, 100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/glass_shelving_01.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_collection_glass_shelves_01, "object/draft_schematic/furniture/furniture_collection_glass_shelves_01.iff")
