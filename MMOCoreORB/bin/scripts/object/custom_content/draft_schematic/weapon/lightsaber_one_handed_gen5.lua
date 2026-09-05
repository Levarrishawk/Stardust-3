object_draft_schematic_weapon_lightsaber_one_handed_gen5 = object_draft_schematic_weapon_shared_lightsaber_one_handed_gen5:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Sword Lightsaber Gen5",

   craftingToolTab = 2048, -- (See DraftSchematicObjectTemplate.h)
   complexity = 8, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_weapon.iff",
   
   xpType = "crafting_weapons_general", 
   xp = 0, 

   assemblySkill = "jedi_saber_assembly", 
   experimentingSkill = "jedi_saber_experimentation", 
   customizationSkill = "jedi_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n"},
   ingredientTitleNames = {"emitter_shroud", "activator", "handgrip", "power_field_insulator", "energizers"},
   ingredientSlotType = {0, 0, 0, 0, 0},
   resourceTypes = {"steel_duralloy", "aluminum_titanium", "petrochem_inert_polymer", "gas_inert_culsion", "copper_polysteel"},
   resourceQuantities = {75, 45, 60, 60, 60},
   contribution = {100, 100, 100, 100, 100},


   targetTemplate = "object/weapon/melee/sword/crafted_saber/sword_lightsaber_one_handed_gen5.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_weapon_lightsaber_one_handed_gen5, "object/draft_schematic/weapon/lightsaber_one_handed_gen5.iff")
