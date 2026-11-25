-- Concession portions use existing food and drink appearances and the same
-- no-buff consumption behavior as bartender drinks. Crafted recipes stay separate.
local function serving(name, shared, filling)
	ObjectTemplates:addTemplate(shared:new {
		templateType = CONSUMABLE, effectType = 7, filling = filling,
	}, "object/tangible/food/monument_square/" .. name .. ".iff")
end

serving("caf", object_tangible_food_crafted_shared_drink_caf, 5)
serving("puffcake", object_tangible_food_crafted_shared_dessert_puffcake, 7)
serving("stew", object_tangible_food_crafted_shared_dish_fire_stew, 10)
serving("bofa", object_tangible_food_crafted_shared_dessert_bofa_treat, 5)
