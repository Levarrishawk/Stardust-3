object_draft_schematic_clothing_clothing_collection_jeweled_necklace = object_draft_schematic_clothing_shared_clothing_collection_jeweled_necklace:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Smc Jeweled Necklace Reward",

   craftingToolTab = 8, -- (See DraftSchematicObjectTemplate.h)
   complexity = 30, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_clothing.iff",
   
   xpType = "crafting_clothing_general", 
   xp = 330, 

   assemblySkill = "clothing_assembly", 
   experimentingSkill = "clothing_experimentation", 
   customizationSkill = "clothing_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_clothing_ingredients_n", "craft_clothing_ingredients_n", "craft_clothing_ingredients_n", "craft_clothing_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n", "craft_item_ingredients_n"},
   ingredientTitleNames = {"setting", "trim", "jewel", "jewelry_metal_band", "nightsister_gem_bead", "nightsister_gold_gem", "nightsister_gold_wire", "nightsister_green_bead", "nightsister_clasp"},
   ingredientSlotType = {0, 0, 0, 0, 1, 1, 1, 1, 1},
   resourceTypes = {"copper", "copper", "gemstone_crystalline", "copper", "object/tangible/loot/creature_loot/collections/shared_trader_dom_gem_bead.iff", "object/tangible/loot/creature_loot/collections/shared_trader_dom_gold_bead.iff", "object/tangible/loot/creature_loot/collections/shared_trader_dom_gold_wire.iff", "object/tangible/loot/creature_loot/collections/shared_trader_dom_green_bead.iff", "object/tangible/loot/creature_loot/collections/shared_trader_dom_jewelry_clasp.iff"},
   resourceQuantities = {10, 10, 25, 10, 1, 1, 1, 1, 1},
   contribution = {100, 100, 100, 100, 100, 100, 100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/smc_jeweled_necklace_reward.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_clothing_clothing_collection_jeweled_necklace, "object/draft_schematic/clothing/clothing_collection_jeweled_necklace.iff")
