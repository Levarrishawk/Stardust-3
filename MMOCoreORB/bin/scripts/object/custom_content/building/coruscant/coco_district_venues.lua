do
    local shared = SharedBuildingObjectTemplate:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_depot.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_coco_depot.iff")
    local building = shared:new {}
    ObjectTemplates:addTemplate(building, "object/building/coruscant/coco_depot.iff")
end

do
    local shared = object_building_player_shared_generic_medium_window_s02:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_theatre.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_coco_theatre.iff")
    local building = object_building_player_generic_medium_window_s02:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_theatre.iff",
        publicStructure = 1,
        childObjects = {}
    }
    ObjectTemplates:addTemplate(building, "object/building/coruscant/coco_theatre.iff")
end

do
    local shared = object_building_player_shared_generic_medium_window_s02:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_repair.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_coco_repair.iff")
    local building = object_building_player_generic_medium_window_s02:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_repair.iff",
        publicStructure = 1,
        childObjects = {}
    }
    ObjectTemplates:addTemplate(building, "object/building/coruscant/coco_repair.iff")
end

do
    local shared = SharedBuildingObjectTemplate:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_instruments.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_coco_instruments.iff")
    local building = shared:new {}
    ObjectTemplates:addTemplate(building, "object/building/coruscant/coco_instruments.iff")
end

do
    local shared = SharedBuildingObjectTemplate:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_tower.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_coco_tower.iff")
    local building = shared:new {}
    ObjectTemplates:addTemplate(building, "object/building/coruscant/coco_tower.iff")
end

do
    local shared = object_building_player_shared_generic_medium_window_s02:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_inn.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_coco_inn.iff")
    local building = object_building_player_generic_medium_window_s02:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_inn.iff",
        publicStructure = 1,
        childObjects = {}
    }
    ObjectTemplates:addTemplate(building, "object/building/coruscant/coco_inn.iff")
end

do
    local shared = SharedBuildingObjectTemplate:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_exchange.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_coco_exchange.iff")
    local building = shared:new {}
    ObjectTemplates:addTemplate(building, "object/building/coruscant/coco_exchange.iff")
end

do
    local shared = object_building_player_shared_generic_medium_window_s02:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_museum.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_coco_museum.iff")
    local building = object_building_player_generic_medium_window_s02:new {
        clientTemplateFileName = "object/building/coruscant/shared_coco_museum.iff",
        publicStructure = 1,
        childObjects = {}
    }
    ObjectTemplates:addTemplate(building, "object/building/coruscant/coco_museum.iff")
end
