object_draft_schematic_item_collection_ice_cream_fryer = object_draft_schematic_item_shared_collection_ice_cream_fryer:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Fryer",

   craftingToolTab = 4, -- (See DraftSchematicObjectTemplate.h)
   complexity = 15, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_food.iff",
   
   xpType = "crafting_general", 
   xp = 500, 

   assemblySkill = "food_assembly", 
   experimentingSkill = "food_experimentation", 
   customizationSkill = "food_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_food_ingredients_n", "craft_food_ingredients_n", "craft_food_ingredients_n", "craft_food_ingredients_n"},
   ingredientTitleNames = {"fryer_body", "heat_control", "power_conditioner", "fryer_basket"},
   ingredientSlotType = {0, 1, 1, 0},
   resourceTypes = {"metal_nonferrous", "object/tangible/component/item/shared_electronic_control_unit.iff", "object/tangible/component/item/shared_electronic_power_conditioner.iff", "steel"},
   resourceQuantities = {300, 1, 1, 50},
   contribution = {100, 100, 100, 100},


   targetTemplate = "object/tangible/container/food/ice_cream_fryer.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_item_collection_ice_cream_fryer, "object/draft_schematic/item/collection_ice_cream_fryer.iff")
