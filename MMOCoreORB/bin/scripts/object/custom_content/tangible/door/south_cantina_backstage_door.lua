local sharedPath = "object/tangible/door/shared_south_cantina_backstage_door.iff"
local sharedDoor = SharedTangibleObjectTemplate:new { clientTemplateFileName = sharedPath }
ObjectTemplates:addClientTemplate(sharedDoor, sharedPath)

local backstageDoor = sharedDoor:new { clientTemplateFileName = sharedPath }
ObjectTemplates:addTemplate(backstageDoor, "object/tangible/door/south_cantina_backstage_door.iff")
