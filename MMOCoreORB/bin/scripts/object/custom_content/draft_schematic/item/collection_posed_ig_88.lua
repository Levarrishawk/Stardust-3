object_draft_schematic_item_collection_posed_ig_88 = object_draft_schematic_item_shared_collection_posed_ig_88:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Posed Ig 88 Reward",

   craftingToolTab = 524288, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_electronics.iff",
   
   xpType = "crafting_general", 
   xp = 140, 

   assemblySkill = "general_assembly", 
   experimentingSkill = "general_experimentation", 
   customizationSkill = "clothing_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n"},
   ingredientTitleNames = {"ig_88_frame", "ig_88_fasteners", "ig_88_casing", "ig_88_paint", "ig_88_dowel", "ig_88_stand", "ig_88_trim"},
   ingredientSlotType = {0, 0, 0, 0, 1, 0, 0},
   resourceTypes = {"wood_deciduous", "steel_rhodium", "aluminum_titanium", "chemical", "object/tangible/loot/creature_loot/collections/shared_ig_88_wooden_dowel.iff", "wood", "copper"},
   resourceQuantities = {125, 50, 200, 150, 1, 150, 20},
   contribution = {100, 100, 100, 100, 100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/posed_ig_88_reward.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_item_collection_posed_ig_88, "object/draft_schematic/item/collection_posed_ig_88.iff")
