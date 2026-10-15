object_ship_spacestation_coruscant = object_ship_spacestation_imperial:new {
	-- The native template loader does not enumerate inherited Lua fields.
	gameObjectType = 536870920,
	objectName = "@space/ship_names:spacestation_coruscant",
}

ObjectTemplates:addTemplate(object_ship_spacestation_coruscant, "object/ship/spacestation_coruscant.iff")
