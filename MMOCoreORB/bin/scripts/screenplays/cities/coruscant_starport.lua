CoruscantStarportScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "CoruscantStarportScreenPlay",
	planet = "coruscant",
	starportID = 37000196,
	terminalTemplate = "object/tangible/terminal/terminal_space.iff",

	-- Coronet starport (1855671), from snapshot/corellia.ws: six terminals
	-- in cell 4 and four in cell 10. Coruscant uses the same building layout.
	terminalPositions = {
		{cell = 4, x = -0.173982367, z = 0.639420986, y = 57.355182648, ow = 3.20012709665e-08, ox = 0, oy = 1, oz = 0},
		{cell = 4, x = -0.306201220, z = 0.639421999, y = 62.241462708, ow = 1, ox = 0, oy = 0, oz = 0},
		{cell = 4, x = -10.389243126, z = 0.639423013, y = 57.414516449, ow = -3.20012709665e-08, ox = 0, oy = 1, oz = 0},
		{cell = 4, x = -10.596613884, z = 0.639424026, y = 62.366893768, ow = 1, ox = 0, oy = 0, oz = 0},
		{cell = 4, x = 10.057667732, z = 0.639421940, y = 57.248973846, ow = -0.00689757429063, ox = 0, oy = 0.999976038933, oz = 0},
		{cell = 4, x = 9.918564796, z = 0.639421940, y = 62.203796387, ow = 0.999976217747, ox = 0, oy = 0.00689846463501, oz = 0},
		{cell = 10, x = -40.431083679, z = 1.639423847, y = 46.481815338, ow = 0.997529327869, ox = 0, oy = -0.0702515244484, oz = 0},
		{cell = 10, x = -37.943672180, z = 1.639421940, y = 49.299140930, ow = 0.753582954407, ox = 0, oy = -0.657352805138, oz = 0},
		{cell = 10, x = -44.163364410, z = 1.639421940, y = 50.172061920, ow = 0.648033559322, ox = 0, oy = 0.761611461639, oz = 0},
		{cell = 10, x = -41.607471466, z = 1.639423847, y = 52.927013397, ow = 0.0579759627581, ox = 0, oy = 0.998318016529, oz = 0},
	},
}

registerScreenPlay("CoruscantStarportScreenPlay", true)

function CoruscantStarportScreenPlay:terminalPresent(pCell, entry)
	for i = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
		local pObject = SceneObject(pCell):getContainerObject(i)
		if (pObject ~= nil and SceneObject(pObject):getTemplateObjectPath() == self.terminalTemplate) then
			local dx = SceneObject(pObject):getPositionX() - entry.x
			local dz = SceneObject(pObject):getPositionZ() - entry.z
			local dy = SceneObject(pObject):getPositionY() - entry.y
			if (dx * dx + dz * dz + dy * dy < 0.01) then
				return true
			end
		end
	end
	return false
end

function CoruscantStarportScreenPlay:start()
	if (not isZoneEnabled(self.planet)) then
		return
	end

	local pBuilding = getSceneObject(self.starportID)
	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject() or SceneObject(pBuilding):getZoneName() ~= self.planet
		or SceneObject(pBuilding):getTemplateObjectPath() ~= "object/building/corellia/starport_corellia.iff") then
		print("[coruscant] Starship terminals: starport " .. self.starportID .. " is unavailable")
		return
	end

	for _, cellNumber in ipairs({4, 10}) do
		local pCell = BuildingObject(pBuilding):getCell(cellNumber)
		if (pCell == nil) then
			print("[coruscant] Starship terminals: missing starport cell " .. cellNumber)
		else
			local parentID = SceneObject(pCell):getObjectID()
			for _, entry in ipairs(self.terminalPositions) do
				if (entry.cell == cellNumber and not self:terminalPresent(pCell, entry)) then
					local pTerminal = spawnSceneObject(self.planet, self.terminalTemplate, entry.x, entry.z, entry.y, parentID, entry.ow, entry.ox, entry.oy, entry.oz)
					if (pTerminal == nil) then
						print("[coruscant] Starship terminal spawn failed in cell " .. cellNumber .. " at " .. entry.x .. ", " .. entry.z .. ", " .. entry.y)
					end
				end
			end
		end
	end
end
