object_draft_schematic_dance_prop_prop_combat_fan_l = object_draft_schematic_dance_prop_shared_prop_combat_fan_l:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Prop Cb Fan L",

   craftingToolTab = 524288, -- (See DraftSchematicObjectTemplate.h)
   complexity = 7, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_generic_items.iff",
   
   xpType = "dancing", 
   xp = 20, 

   assemblySkill = "general_assembly", 
   experimentingSkill = "general_experimentation", 
   customizationSkill = "clothing_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_furniture_ingredients_n", "craft_furniture_ingredients_n", "craft_furniture_ingredients_n"},
   ingredientTitleNames = {"blade", "hilt", "grip"},
   ingredientSlotType = {0, 0, 0},
   resourceTypes = {"metal", "metal", "hide"},
   resourceQuantities = {20, 10, 5},
   contribution = {100, 100, 100},


   targetTemplate = "object/tangible/dance_prop/prop_combat_fan_l.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_dance_prop_prop_combat_fan_l, "object/draft_schematic/dance_prop/prop_combat_fan_l.iff")
