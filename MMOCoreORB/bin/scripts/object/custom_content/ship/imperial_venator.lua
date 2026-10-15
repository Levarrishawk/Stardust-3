-- Retain the existing capital ship's component statistics and AI chassis setup.
object_ship_imperial_venator = object_ship_star_destroyer:new {
	-- The native template loader does not enumerate inherited Lua fields.
	gameObjectType = 536870920,
	clientTemplateFileName = "object/ship/shared_imperial_venator.iff",
	objectName = "Imperial Venator Star Destroyer",
	name = "imperial_venator",
	type = "imperial_venator",
}

ObjectTemplates:addTemplate(object_ship_imperial_venator, "object/ship/imperial_venator.iff")
