local clientPath = "object/building/coruscant/shared_entertainment_district_south_cantina.iff"

local sharedCantina = object_building_player_city_shared_cantina_corellia:new {
    clientTemplateFileName = clientPath
}
ObjectTemplates:addClientTemplate(sharedCantina, clientPath)

local southCantina = object_building_player_city_cantina_corellia:new {
    clientTemplateFileName = clientPath
}
ObjectTemplates:addTemplate(southCantina, "object/building/coruscant/entertainment_district_south_cantina.iff")
