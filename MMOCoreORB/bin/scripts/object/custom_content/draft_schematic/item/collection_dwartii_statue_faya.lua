object_draft_schematic_item_collection_dwartii_statue_faya = object_draft_schematic_item_shared_collection_dwartii_statue_faya:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Dwartii Statue Faya",

   craftingToolTab = 512, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_furniture.iff",
   
   xpType = "crafting_structure_general", 
   xp = 140, 

   assemblySkill = "structure_assembly", 
   experimentingSkill = "structure_experimentation", 
   customizationSkill = "structure_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n"},
   ingredientTitleNames = {"cast_metal", "statue_base", "finish"},
   ingredientSlotType = {0, 0, 0},
   resourceTypes = {"iron_bronzium", "steel_carbonite", "aluminum_titanium"},
   resourceQuantities = {600, 200, 20},
   contribution = {100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/dwartii_statue_faya.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_item_collection_dwartii_statue_faya, "object/draft_schematic/item/collection_dwartii_statue_faya.iff")
