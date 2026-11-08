-- Both layouts use the same POB-local positions and room names.
KashyyykWebweaverPopulation = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykWebweaverPopulation"
}

registerScreenPlay("KashyyykWebweaverPopulation", true)

function KashyyykWebweaverPopulation:start()
	local zone, _, _, buildingID = KashyyykDeadForestPopulation:getLayout()
	if (zone == nil) then
		return
	end
	local pBuilding = getSceneObject(buildingID)
	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()
		or SceneObject(pBuilding):getZoneName() ~= zone
		or SceneObject(pBuilding):getTemplateObjectPath() ~= "object/building/kashyyyk/ep3_forest_webweaver.iff") then
		print(self.screenplayName .. ": missing Webweaver building " .. buildingID .. " in " .. zone)
		return
	end

	local cells = self:buildCellMap(pBuilding)
	local reported = {}
	for _, row in ipairs(KashyyykDeadForestData.cave) do
		local cellID = cells[row.room]
		local key = self.screenplayName .. ":" .. buildingID .. ":" .. row.row
		if (cellID == nil) then
			if (not reported[row.room]) then
				print(self.screenplayName .. ": missing room " .. row.room)
				reported[row.room] = true
			end
		elseif (getSceneObject(readData(key)) == nil) then
			local pMobile = spawnMobile(zone, "dead_forest_" .. row.item, row.respawn,
				row.x, row.z, row.y, row.heading, cellID)
			if (pMobile ~= nil) then
				writeData(key, SceneObject(pMobile):getObjectID())
				if (row.respawn == 0 and SceneObject(pMobile):isAiAgent()) then
					AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
				end
			else
				print(self.screenplayName .. ": failed to spawn " .. row.item .. " in " .. row.room)
			end
		end
	end
end

function KashyyykWebweaverPopulation:buildCellMap(pBuilding)
	local cells = {}
	local total = BuildingObject(pBuilding):getTotalCellNumber()

	for i = 1, total do
		local pCell = BuildingObject(pBuilding):getCell(i)

		if (pCell ~= nil) then
			local cellId = SceneObject(pCell):getObjectID()
			local cellNum = LuaCellObject(pCell):getCellNumber()
			local cellName = BuildingObject(pBuilding):getCellName(cellNum)

			if (cellName == nil) then
				cellName = ""
			end

			if (cellName ~= "") then
				cells[cellName] = cellId
			end

			cells["r" .. i] = cellId
		end
	end

	return cells
end
