local gallery = object_building_player_shared_generic_medium_window_s02:new {
    clientTemplateFileName = "object/building/coruscant/shared_luthen_rael_gallery.iff"
}
ObjectTemplates:addClientTemplate(gallery, "object/building/coruscant/shared_luthen_rael_gallery.iff")

local publicGallery = object_building_player_generic_medium_window_s02:new {
    clientTemplateFileName = "object/building/coruscant/shared_luthen_rael_gallery.iff",
    publicStructure = 1,
    childObjects = {}
}
ObjectTemplates:addTemplate(publicGallery, "object/building/coruscant/luthen_rael_gallery.iff")
