object_draft_schematic_item_collection_posed_stormtrooper = object_draft_schematic_item_shared_collection_posed_stormtrooper:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Posed Stormtrooper Reward",

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
   ingredientTitleNames = {"stormtrooper_frame", "stormtrooper_fasteners", "stormtrooper_casing", "stormtrooper_paint", "stormtrooper_dowel", "stormtrooper_stand", "stormtrooper_trim"},
   ingredientSlotType = {0, 0, 0, 0, 1, 0, 0},
   resourceTypes = {"wood_deciduous", "steel_rhodium", "aluminum", "chemical", "object/tangible/loot/creature_loot/collections/shared_stormtrooper_wooden_dowel.iff", "wood", "copper"},
   resourceQuantities = {125, 50, 200, 150, 1, 150, 20},
   contribution = {100, 100, 100, 100, 100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/posed_stormtrooper_reward.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_item_collection_posed_stormtrooper, "object/draft_schematic/item/collection_posed_stormtrooper.iff")
