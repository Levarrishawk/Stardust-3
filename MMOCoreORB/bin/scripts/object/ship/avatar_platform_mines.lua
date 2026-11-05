-- Use the matching fighter tier's components with the two mine turret mounts.
local fighterTiers = {
	object_ship_tiefighter_tier1,
	object_ship_tiefighter_tier2,
	object_ship_tiefighter_tier3,
	object_ship_tiefighter_tier4,
	object_ship_tiefighter_tier5,
}

for tier, fighter in ipairs(fighterTiers) do
	local name = "kessel_mine_turret_tier" .. tier
	local mine = fighter:new {
		clientTemplateFileName = "object/ship/shared_" .. name .. ".iff",
		gameObjectType = 536870919,
		objectName = "@space/space_mobile_type:" .. name,
		name = name,
		type = name,
		faction = "slaver",
		weapon_1 = fighter.weapon_0,
	}
	ObjectTemplates:addTemplate(mine, "object/ship/" .. name .. ".iff")
end
