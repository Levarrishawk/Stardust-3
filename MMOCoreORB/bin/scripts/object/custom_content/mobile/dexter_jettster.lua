local sharedPath = "object/mobile/shared_dexter_jettster.iff"
local sharedDexter = SharedCreatureObjectTemplate:new {
    clientTemplateFileName = sharedPath
}
ObjectTemplates:addClientTemplate(sharedDexter, sharedPath)

local dexter = sharedDexter:new {}
ObjectTemplates:addTemplate(dexter, "object/mobile/dexter_jettster.iff")
