local clientPath = "object/building/coruscant/shared_monument_square_cantina.iff"

local sharedCantina = object_building_corellia_shared_cantina_corellia:new {
    clientTemplateFileName = clientPath
}
ObjectTemplates:addClientTemplate(sharedCantina, clientPath)

local cantina = object_building_corellia_cantina_corellia:new {
    clientTemplateFileName = clientPath
}
ObjectTemplates:addTemplate(cantina, "object/building/coruscant/monument_square_cantina.iff")
