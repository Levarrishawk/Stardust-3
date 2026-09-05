object_draft_schematic_weapon_appearance_weapon_appearance_carbine_ee3_bounty = object_draft_schematic_weapon_appearance_shared_weapon_appearance_carbine_ee3_bounty:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Carbine Bounty Ee3",

   craftingToolTab = 1, -- (See DraftSchematicObjectTemplate.h)
   complexity = 40, 
   size = 1, 
   factoryCrateType = "object/factory/factory_crate_weapon.iff",
   
   xpType = "crafting_weapons_general", 
   xp = 450, 

   assemblySkill = "weapon_assembly", 
   experimentingSkill = "weapon_experimentation", 
   customizationSkill = "weapon_customization",
   factoryCrateSize = 0, 

   customizationOptions = {},
   customizationStringNames = {},
   customizationDefaults = {},

   ingredientTemplateNames = {"craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n", "craft_weapon_ingredients_n"},
   ingredientTitleNames = {"frame_assembly", "receiver_assembly", "grip_assembly", "barrel_rifle_projectile", "weapon_core", "scope", "stock"},
   ingredientSlotType = {0, 0, 0, 1, 1, 3, 3},
   resourceTypes = {"steel_carbonite", "copper_polysteel", "petrochem_inert_polymer", "object/tangible/component/weapon/shared_projectile_rifle_barrel_base.iff", "object/tangible/component/weapon/core/shared_weapon_core_ranged_base.iff", "object/tangible/component/weapon/shared_scope_weapon_base.iff", "object/tangible/component/weapon/shared_stock_base.iff"},
   resourceQuantities = {100, 45, 28, 1, 1, 1, 1},
   contribution = {100, 100, 100, 100, 100, 100, 100},
   ingredientAppearance = {"", "", "", "muzzle", "", "scope", "stock"},


   targetTemplate = "object/weapon/ranged/carbine/carbine_bounty_ee3.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_weapon_appearance_weapon_appearance_carbine_ee3_bounty, "object/draft_schematic/weapon/appearance/weapon_appearance_carbine_ee3_bounty.iff")
