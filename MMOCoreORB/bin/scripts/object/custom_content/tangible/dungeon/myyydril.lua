local root = "object/tangible/theme_park/myyydril/"
local objects = {
	{ "myyydril_machine", 1000 },
	{ "myyydril_power_cell", 500 },
	{ "myyydril_grievous_encounter_manager" },
	{ "myyydril_magic_stone" },
}

for _, row in ipairs(objects) do
	local name, hitPoints = row[1], row[2]
	local clientPath = root .. "shared_" .. name .. ".iff"
	local sharedTemplate = SharedTangibleObjectTemplate:new { clientTemplateFileName = clientPath }
	ObjectTemplates:addClientTemplate(sharedTemplate, clientPath)
	local serverTemplate = sharedTemplate:new { maxCondition = hitPoints }
	if (name == "myyydril_magic_stone") then
		serverTemplate.objectMenuComponent = "MyyydrilMagicStoneMenuComponent"
	end
	ObjectTemplates:addTemplate(serverTemplate, root .. name .. ".iff")
end
