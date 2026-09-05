object_draft_schematic_weapon_appearance_weapon_appearance_pistol_dd6 = object_draft_schematic_weapon_appearance_shared_weapon_appearance_pistol_dd6:new {
   templateType = DRAFTSCHEMATIC,

   customObjectName = "Pistol Dd6",

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
   ingredientTitleNames = {"frame_assembly", "receiver_assembly", "grip_assembly", "barrel_pistol_projectile", "weapon_core", "scope", "stock"},
   ingredientSlotType = {0, 0, 0, 1, 1, 3, 3},
   resourceTypes = {"steel_duralloy", "copper_polysteel", "petrochem_inert_polymer", "object/tangible/component/weapon/shared_projectile_pistol_barrel_base.iff", "object/tangible/component/weapon/core/shared_weapon_core_ranged_base.iff", "object/tangible/component/weapon/shared_scope_weapon_base.iff", "object/tangible/component/weapon/shared_stock_base.iff"},
   resourceQuantities = {85, 40, 28, 1, 1, 1, 1},
   contribution = {100, 100, 100, 100, 100, 100, 100},
   ingredientAppearance = {"", "", "", "muzzle", "", "scope", "stock"},


   targetTemplate = "object/weapon/ranged/pistol/pistol_dd6.iff",

   additionalTemplates = {
             }
}
ObjectTemplates:addTemplate(object_draft_schematic_weapon_appearance_weapon_appearance_pistol_dd6, "object/draft_schematic/weapon/appearance/weapon_appearance_pistol_dd6.iff")
