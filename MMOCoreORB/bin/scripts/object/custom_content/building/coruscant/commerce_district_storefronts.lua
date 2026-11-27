do
    local shared = SharedBuildingObjectTemplate:new {
        clientTemplateFileName = "object/building/coruscant/shared_collective_commerce_kettle_cafe.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_collective_commerce_kettle_cafe.iff")
    ObjectTemplates:addTemplate(shared:new {}, "object/building/coruscant/collective_commerce_kettle_cafe.iff")
end

do
    local shared = SharedBuildingObjectTemplate:new {
        clientTemplateFileName = "object/building/coruscant/shared_collective_commerce_exchange_offices.iff"
    }
    ObjectTemplates:addClientTemplate(shared, "object/building/coruscant/shared_collective_commerce_exchange_offices.iff")
    ObjectTemplates:addTemplate(shared:new {}, "object/building/coruscant/collective_commerce_exchange_offices.iff")
end
