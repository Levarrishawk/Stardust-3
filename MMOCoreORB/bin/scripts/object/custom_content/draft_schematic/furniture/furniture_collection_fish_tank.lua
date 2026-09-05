object_draft_schematic_furniture_furniture_collection_fish_tank = object_draft_schematic_furniture_shared_furniture_collection_fish_tank:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Fish Tank Reward",

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

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"fish_tank_front_panel", "fish_tank_rear_panel", "fish_tank_left_panel", "fish_tank_right_panel", "fish_tank_bubble_stone", "fish_tank_tubing", "fish_tank_water"},
   ingredientSlotType = {1, 1, 1, 1, 1, 1, 0},
   resourceTypes = {"object/tangible/fishing/fish/shared_fish_tank_front_panel.iff", "object/tangible/fishing/fish/shared_fish_tank_rear_panel.iff", "object/tangible/fishing/fish/shared_fish_tank_left_panel.iff", "object/tangible/fishing/fish/shared_fish_tank_right_panel.iff", "object/tangible/fishing/fish/shared_fish_tank_bubble_stone.iff", "object/tangible/fishing/fish/shared_fish_tank_tubing.iff", "water"},
   resourceQuantities = {1, 1, 1, 1, 1, 1, 500},
   contribution = {100, 100, 100, 100, 100, 100, 100},


   targetTemplate = "object/tangible/collection/reward/fish_tank_reward.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_furniture_furniture_collection_fish_tank, "object/draft_schematic/furniture/furniture_collection_fish_tank.iff")
