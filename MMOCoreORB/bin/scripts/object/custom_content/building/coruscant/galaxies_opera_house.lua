local operaHouse = SharedBuildingObjectTemplate:new {
    clientTemplateFileName = "object/building/coruscant/shared_galaxies_opera_house.iff"
}
ObjectTemplates:addClientTemplate(operaHouse, "object/building/coruscant/shared_galaxies_opera_house.iff")

ObjectTemplates:addTemplate(operaHouse:new { totalCellNumber = 2 }, "object/building/coruscant/galaxies_opera_house.iff")
