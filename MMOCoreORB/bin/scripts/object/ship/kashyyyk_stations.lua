-- Kashyyyk identities use the existing neutral station hull and component setup.
object_ship_spacestation_kashyyyk = object_ship_spacestation_neutral:new {
	objectName = "@clientpoi_n:station_kashyyyk",
}
ObjectTemplates:addTemplate(object_ship_spacestation_kashyyyk, "object/ship/spacestation_kashyyyk.iff")

object_ship_spacestation_rodian_base = object_ship_spacestation_neutral:new {
	objectName = "@clientpoi_n:kashyyyk_sordaan_outpost",
}
ObjectTemplates:addTemplate(object_ship_spacestation_rodian_base, "object/ship/spacestation_rodian_base.iff")

object_ship_spacestation_rodian_tripp_base = object_ship_spacestation_neutral:new {
	objectName = "@clientpoi_n:kashyyyk_tripp_outpost",
}
ObjectTemplates:addTemplate(object_ship_spacestation_rodian_tripp_base, "object/ship/spacestation_rodian_tripp_base.iff")

object_ship_station_gotal_pirate_base = object_ship_spacestation_neutral:new {
	objectName = "@clientpoi_n:kashyyyk_gotal_pirate_base",
}
ObjectTemplates:addTemplate(object_ship_station_gotal_pirate_base, "object/ship/station_gotal_pirate_base.iff")

object_ship_station_chiss_poacher_base = object_ship_spacestation_neutral:new {
	objectName = "@clientpoi_n:kashyyyk_chiss_poacher_base",
}
ObjectTemplates:addTemplate(object_ship_station_chiss_poacher_base, "object/ship/station_chiss_poacher_base.iff")

object_ship_spacestation_indie_slaver = object_ship_spacestation_neutral:new {
	objectName = "@clientpoi_n:kashyyyk_independent_slavers",
}
ObjectTemplates:addTemplate(object_ship_spacestation_indie_slaver, "object/ship/spacestation_indie_slaver.iff")

object_ship_spacestation_avatar_platform = object_ship_spacestation_neutral:new {
	objectName = "@clientpoi_n:station_avatar_platform",
}
ObjectTemplates:addTemplate(object_ship_spacestation_avatar_platform, "object/ship/spacestation_avatar_platform.iff")
