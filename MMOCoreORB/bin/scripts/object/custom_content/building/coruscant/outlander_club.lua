local outlanderShared = SharedBuildingObjectTemplate:new {
    clientTemplateFileName = "object/building/coruscant/shared_outlander_club.iff"
}
ObjectTemplates:addClientTemplate(outlanderShared, "object/building/coruscant/shared_outlander_club.iff")

local outlander = object_building_player_city_cantina_corellia:new {
    clientTemplateFileName = "object/building/coruscant/shared_outlander_club.iff",
    totalCellNumber = 2,
    childObjects = {
        object_building_player_city_cantina_corellia.childObjects[1],
        {templateFile = "object/tangible/terminal/terminal_player_structure.iff", x = -2.2, z = 0.25, y = 1.98, ox = 0, oy = 1, oz = 0, ow = 0, cellid = 2, containmentType = -1}
    }
}
ObjectTemplates:addTemplate(outlander, "object/building/coruscant/outlander_club.iff")
