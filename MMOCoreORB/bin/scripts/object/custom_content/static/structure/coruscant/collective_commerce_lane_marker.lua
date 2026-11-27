local shared = SharedStaticObjectTemplate:new {
    clientTemplateFileName = "object/static/structure/coruscant/shared_collective_commerce_lane_marker.iff"
}
ObjectTemplates:addClientTemplate(shared, "object/static/structure/coruscant/shared_collective_commerce_lane_marker.iff")
ObjectTemplates:addTemplate(shared:new {}, "object/static/structure/coruscant/collective_commerce_lane_marker.iff")
