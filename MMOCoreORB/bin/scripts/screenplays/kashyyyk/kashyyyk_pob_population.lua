-- Avatar Platform uses its existing snapshot copy. Myyydril has a separate native buildout and population.

KashyyykPobPopulation = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "KashyyykPobPopulation",

	respawn = 600,
	copies = {avatar_platform = {14400801}},
	pools = {
		{
			key = "avatar_platform",
			label = "Avatar Platform",
			table = "ep3_avatar_platform.tab",
			rows = {
				{ "ep3_wke_civilian_03", "room", -135.5, 0, -154.2, 27 },
				{ "ep3_wke_civilian_03", "room", -125.1, 0, -149.4, -69 },
				{ "ep3_wke_civilian_03", "room", -133.5, 0, -149.4, 22 },
				{ "ep3_blackscale_guard_m_01", "mainhangar", 36.3, 0, 18.4, -90 },
				{ "ep3_blackscale_guard_m_02", "mainhangar", 36.3, 0, 24.7, -90 },
				{ "ep3_wke_civilian_01", "jails", -160.4, -0.5, -133.5, -90 },
				{ "ep3_wke_civilian_02", "jails", -183.7, -0.5, -133.8, 90 },
				{ "ep3_wke_civilian_03", "jails", -181.6, -0.5, -154.8, 90 },
				{ "ep3_avatar_jawa", "securityoffice", -160.8, 0, -124.7, 0 },
				{ "ep3_blackscale_guard_m_03", "barracksanteroom", -44.2, 0, -98, 66 },
				{ "ep3_blackscale_assault_m_01", "barracksanteroom", -48.2, 0, -104.8, 103 },
				{ "ep3_wke_commando_01", "cavehall03", -57.3, 0, 71.1, -90 },
				{ "ep3_wke_freedom_fighter_01", "cavehall03", -52.9, 0, 75.2, -113 },
				{ "ep3_blackscale_guard_m_04", "anteroom", 60.9, 0, -69.4, -99 },
				{ "ep3_blackscale_guard_m_01", "checkpoint01", 13.5, 0, 56, 53 },
				{ "ep3_blackscale_guard_m_02", "systemscontrol", -88.1, 0, 32.8, 0 },
				{ "ep3_blackscale_guard_m_03", "systemscontrol", -93.5, 0, 33.7, 0 },
				{ "ep3_blackscale_guard_m_04", "cavehall03", -68.8, 0, 76.7, 100 },
				{ "ep3_blackscale_assault_m_02", "anteroom", 49.3, 0, -61.6, 142 },
				{ "ep3_blackscale_assault_m_03", "mainhangar", 29.3, 0, 21.8, 90 },
				{ "ep3_blackscale_assault_m_01", "generalstorage", -14.7, 0, 19.6, 0 },
				{ "ep3_blackscale_assault_m_02", "barracksanteroom", -95.3, 0, 19.2, 90 },
				{ "ep3_blackscale_assault_m_03", "cavehall03", -64.6, 0, 72.4, 90 },
				{ "ep3_blackscale_guard_m_01", "cavehall09", -127.5, 0, -121.3, -90 },
				{ "ep3_blackscale_trooper_m_01", "navigationroom", -170, 0, 35, 90 },
				{ "ep3_wke_civilian_04", "jails", -160.4, -0.5, -145, -90 },
				{ "ep3_wke_civilian_05", "jails", -182.5, -0.5, -144.5, 90 },
				{ "ep3_blackscale_guard_m_01", "mainhangar", 62.6, 0, 26.3, -12 },
				{ "ep3_blackscale_guard_m_02", "mainhangar", 61.6, 0, 15.6, 89 },
				{ "ep3_blackscale_guard_m_03", "mainhangar", 54.2, 0, 10, 59 },
				{ "ep3_blackscale_guard_m_04", "mainhangar", 53.8, 0, 33.4, 87 },
				{ "ep3_blackscale_guard_m_01", "commandhall01", 45.3, 0, 58.8, 52 },
				{ "ep3_blackscale_assault_m_01", "commandhall01", 47.2, 0, 62, -141 },
				{ "ep3_blackscale_guard_m_02", "checkpoint01", 16, 0, 62.2, -175 },
				{ "ep3_blackscale_guard_m_03", "checkpoint01", 15.8, 0, 58.6, 0 },
				{ "ep3_blackscale_assault_m_02", "checkpoint01", 13.2, 0, 53, 176 },
				{ "ep3_blackscale_guard_m_04", "generalstorage", -11.6, 0, 23.8, -17 },
				{ "ep3_blackscale_guard_m_01", "generalstorage", -20.3, 0, 20, -51 },
				{ "ep3_blackscale_guard_m_02", "generalstorage", -18.4, 0, 17.4, -49 },
				{ "ep3_blackscale_guard_m_03", "generalstorage", -4.5, 0, 21.4, -36 },
				{ "ep3_wke_freedom_fighter_02", "generalstorage", -10.9, 0, 33.5, 160 },
				{ "ep3_wke_freedom_fighter_03", "generalstorage", -17.7, 0, 32.5, 145 },
				{ "ep3_wke_freedom_fighter_04", "generalstorage", -28.7, 0, 27.2, 136 },
				{ "ep3_blackscale_guard_m_04", "secondarystorage", -45.9, 0, 35.4, 122 },
				{ "ep3_blackscale_guard_m_01", "secondarystorage", -49.2, 0, 44.6, 130 },
				{ "ep3_blackscale_guard_m_02", "secondarystorage", -56.5, 0, 27.6, 78 },
				{ "ep3_wke_civilian_06", "rockchasm", -75.1, 0, 97.8, 135 },
				{ "ep3_wke_civilian_01", "rockchasm", -57.2, 0, 99, -125 },
				{ "ep3_wke_civilian_02", "rockchasm", -67, 0.7, 93.4, 99 },
				-- OPEN ep3_avatar_wke_battleleader  "cavehall03"  -53, 0, 74, -74
				{ "ep3_wke_freedom_fighter_05", "cavehall03", -58.7, 0, 70.5, -65 },
				{ "ep3_blackscale_guard_m_03", "cavehall03", -71.1, 0, 80.4, 112 },
				{ "ep3_blackscale_guard_m_04", "cavehall03", -77.5, 0, 74, 88 },
				{ "ep3_blackscale_guard_m_01", "cavehall03", -69.5, 0, 70.7, 72 },
				{ "ep3_blackscale_guard_m_02", "cavehall03", -88.6, 0, 61.1, -1 },
				{ "ep3_blackscale_guard_m_03", "cavehall04", -93.2, 0, 51.8, 13 },
				{ "ep3_blackscale_guard_m_04", "cavehall03", -87.3, 0, 54, -7 },
				{ "ep3_blackscale_guard_m_01", "controlroom", -85.8, -0.3, 17.7, -86 },
				{ "ep3_blackscale_assault_m_03", "controlroom", -90.5, -0.3, 13.7, 6 },
				{ "ep3_blackscale_guard_m_02", "controlroom", -94.3, -0.3, 17.1, -86 },
				{ "ep3_blackscale_enforcer_m_01", "systemscontrol", -72.8, 0, 30.2, -43 },
				{ "ep3_blackscale_guard_m_03", "systemscontrol", -82.1, 9, 1, 69 },
				{ "ep3_blackscale_assault_m_01", "systemscontrol", -99.8, 9, 1, -52 },
				{ "ep3_blackscale_enforcer_m_02", "powercore", -85.3, 10.1, -16.3, -70 },
				{ "ep3_blackscale_guard_m_04", "powercore", -96.1, 10.1, -20.5, 36 },
				{ "ep3_blackscale_guard_m_01", "cavehall01", -26.6, 0, -9.2, 177 },
				{ "ep3_blackscale_guard_m_02", "cavehall01", -30.7, 0, -15.4, 161 },
				{ "ep3_wke_civilian_03", "cavemaintenance", 3.4, -0.6, -57.8, -94 },
				{ "ep3_wke_civilian_04", "cavemaintenance", -14.2, 0.1, -54.3, 66 },
				{ "ep3_wke_civilian_05", "cavemaintenance", -5.1, 0, -43.6, 3 },
				{ "ep3_wke_civilian_06", "cavemaintenance", -3.2, 0.4, -26.2, -111 },
				{ "ep3_wke_civilian_01", "cavemaintenance", -12.3, 0.2, -29.1, -89 },
				{ "ep3_blackscale_guard_m_03", "cavehall02", -31.7, 0, -48.3, 14 },
				{ "ep3_blackscale_guard_m_04", "cavehall02", -44.1, 0, -50.3, 71 },
				{ "ep3_wke_freedom_fighter_01", "cavehall01", -27.6, -0.1, -28.9, -169 },
				{ "ep3_wke_commando_02", "cavehall01", -23.1, 0, -25.5, -20 },
				{ "ep3_blackscale_guard_m_01", "powercore", -80.2, 0.1, -50.2, 85 },
				{ "ep3_blackscale_guard_m_02", "powercore", -90.2, 0.1, -60.4, 176 },
				{ "ep3_blackscale_guard_m_03", "powercore", -100.2, 0.1, -50, -90 },
				{ "ep3_blackscale_assault_m_02", "powercore", -90.2, -9.9, -25.3, -98 },
				{ "ep3_blackscale_guard_m_04", "powercore", -85.3, -13.9, -43.7, -69 },
				{ "ep3_blackscale_enforcer_m_03", "powercore", -94.5, -13.9, -44.1, 44 },
				{ "ep3_blackscale_guard_m_01", "powercore", -87.9, -13.9, -68.4, 77 },
				{ "ep3_blackscale_guard_m_02", "powercore", -82, -13.9, -80.6, 90 },
				{ "ep3_blackscale_guard_m_03", "powercore", -65.9, -13.9, -63.3, -45 },
				{ "ep3_blackscale_guard_m_04", "powercore", -115.9, 0.1, -74, 60 },
				{ "ep3_blackscale_assault_m_03", "powercore", -103.9, 0.1, -89.3, 20 },
				{ "ep3_blackscale_guard_m_01", "powercore", -95.9, 0.1, -90.3, -22 },
				{ "ep3_blackscale_guard_m_02", "barracksanteroom", -52.2, 0, -111.1, 49 },
				{ "ep3_blackscale_guard_m_03", "barracksanteroom", -49.4, 0, -102.4, 76 },
				{ "ep3_blackscale_guard_m_04", "cavehall05", 10.3, 0.2, -92.8, 56 },
				{ "ep3_blackscale_guard_m_01", "cavehall05", 15.1, 0.3, -96.8, -14 },
				{ "ep3_blackscale_guard_m_02", "cavehall05", 15, 0, -89.9, -168 },
				{ "ep3_blackscale_guard_m_03", "anteroom", 45.6, 0, -61.1, 112 },
				{ "ep3_wke_civilian_02", "cavekitchen", 23.2, 0, -47.6, 46 },
				{ "ep3_wke_civilian_03", "cavekitchen", 21.3, -0.1, -29.1, -5 },
				{ "ep3_wke_civilian_04", "cavekitchen", 4.8, 0.1, -14.2, 103 },
				{ "ep3_wke_civilian_05", "cavekitchen", 9.4, -0.1, -9.8, 166 },
				{ "ep3_wke_civilian_06", "cavekitchen", 49.4, 0.2, -27.6, -169 },
				{ "ep3_blackscale_guard_m_04", "techhall03", 59.4, 0, -29.1, 0 },
				{ "ep3_blackscale_assault_m_01", "techhall03", 60, 0, -25.8, 179 },
				{ "ep3_wke_freedom_fighter_02", "techhall07", -39.8, 0, -158, 5 },
				{ "ep3_wke_freedom_fighter_03", "techhall07", -38.1, 0, -154.1, -155 },
				{ "ep3_wke_freedom_fighter_04", "techhall07", -43, 0, -156.8, 76 },
				{ "ep3_wke_freedom_fighter_05", "barracks01", -48.6, 0, -169, 102 },
				{ "ep3_wke_freedom_fighter_01", "barracks01", -56, 0, -181.6, 141 },
				{ "ep3_wke_freedom_fighter_02", "barracks01", -65.1, 0, -173, -55 },
				{ "ep3_wke_commando_03", "barracks01", -68.4, 0, -183, 85 },
				{ "ep3_wke_freedom_fighter_03", "barracks02", -55.2, 0, -141.5, 103 },
				{ "ep3_wke_freedom_fighter_04", "barracks02", -52.7, 0, -141.9, -76 },
				{ "ep3_wke_freedom_fighter_05", "cavehall07", -99.5, 0, -154, -14 },
				{ "ep3_wke_freedom_fighter_01", "cavehall07", -96.6, 0.4, -147.9, -17 },
				{ "ep3_wke_commando_01", "cavehall07", -95.3, 0.1, -153.2, -23 },
				{ "ep3_wke_freedom_fighter_02", "cavehall08", -120.6, 0.1, -131.4, 95 },
				{ "ep3_wke_freedom_fighter_03", "cavehall08", -118.6, 0.1, -134.8, 81 },
				{ "ep3_blackscale_guard_m_01", "cavehall08", -98.9, 0, -136.5, 173 },
				{ "ep3_blackscale_guard_m_02", "techhall03", -102.1, 0, -133.7, -90 },
				{ "ep3_blackscale_guard_m_03", "cavehall09", -132.4, 0.1, -93.7, 133 },
				{ "ep3_blackscale_assault_m_02", "cavehall09", -129.5, 0.1, -94.5, -90 },
				{ "ep3_blackscale_guard_m_02", "securityoffice", -164, 0.1, -104, 154 },
				{ "ep3_blackscale_guard_m_03", "securityoffice", -159.7, 0, -109.1, -89 },
				{ "ep3_blackscale_guard_m_04", "securityoffice", -155.9, 0, -100.6, 161 },
				{ "ep3_blackscale_guard_m_01", "securityoffice", -162.5, 0.1, -100.8, -95 },
				{ "ep3_blackscale_guard_m_04", "commandhall04", -143.9, 0.1, -52, -144 },
				{ "ep3_blackscale_assault_m_03", "commandhall04", -137.7, 0.1, -50.4, -81 },
				{ "ep3_blackscale_guard_m_01", "commandhall04", -145, 0, -47, -22 },
				{ "ep3_wke_freedom_fighter_04", "commandhall04", -144.3, 0.1, -64.7, 7 },
				{ "ep3_wke_commando_02", "commandhall04", -148.7, 0, -62.6, 13 },
				{ "ep3_wke_freedom_fighter_05", "commandhall04", -148.3, 0.1, -36.3, 162 },
				{ "ep3_wke_freedom_fighter_01", "commandhall04", -144.6, 0, -37.2, -175 },
				{ "ep3_wke_freedom_fighter_02", "commandcorridor", -163.6, 0.1, -26.5, 96 },
				-- OPEN ep3_avatar_wke_battleleader  "commandcorridor"  -174.8, 0.1, -28.6, 63
				{ "ep3_wke_freedom_fighter_03", "commandcorridor", -171.5, 0, -22.8, 88 },
				{ "ep3_wke_freedom_fighter_04", "commandcorridor", -161.6, 0.1, -16.8, 145 },
				{ "ep3_wke_commando_03", "commandhall06", -171.7, 0, 1.3, -23 },
				{ "ep3_wke_commando_01", "commandhall06", -170.3, 0, 6.1, -13 },
				{ "ep3_blackscale_guard_m_02", "commandhall06", -174.5, 0.1, 17.9, 165 },
				{ "ep3_blackscale_guard_m_03", "commandhall06", -171.4, 0, 15.8, -176 },
				{ "ep3_blackscale_guard_m_04", "navigationroom", -178.8, -0.3, 31.6, 122 },
				{ "ep3_blackscale_assault_m_01", "navigationroom", -186.2, 0, 44.8, -25 },
				{ "ep3_blackscale_enforcer_m_04", "navigationroom", -163.9, 0, 49.7, 48 },
				{ "ep3_blackscale_guard_m_01", "navigationroom", -170.5, -0.3, 44.3, -154 },
				{ "ep3_wke_commando_02", "commandhall07", -173, 0.1, -66.4, -138 },
				-- OPEN ep3_avatar_wke_battleleader  "commandhall07"  -176, 0, -71.3, 11
				{ "ep3_wke_freedom_fighter_05", "commandhall07", -182.3, 0.1, -71.2, 83 },
				-- OPEN ep3_avatar_wke_battleleader  "sensorsystems"  -185.1, -0.1, -84.4, -162
				{ "ep3_wke_commando_03", "sensorsystems", -190.8, -0.4, -89.7, -176 },
				{ "ep3_wke_freedom_fighter_01", "sensorsystems", -197.3, -0.1, -86.4, 167 },
				{ "ep3_blackscale_guard_m_02", "sensorsystems", -195.4, -0.1, -104.3, 1 },
				{ "ep3_blackscale_assault_m_02", "sensorsystems", -189.9, 0, -108.3, 0 },
				{ "ep3_blackscale_guard_m_03", "sensorsystems", -182.1, -0.1, -103.2, -21 },
				{ "ep3_wke_freedom_fighter_02", "cavehall03", -57.7, 0, 68.5, -65 },
				{ "ep3_wke_freedom_fighter_03", "cavehall03", -55.7, 0, 72.5, -65 },
				{ "ep3_wke_freedom_fighter_04", "generalstorage", -28.7, 0, 30.1, 136 },
				{ "ep3_wke_commando_01", "generalstorage", -25.7, 0, 27.2, 136 },
				{ "clone_droid", "entrance", 111, 0, 24.4, -128 },
			},
		},
	},

	spawnedCount = 0,
}

registerScreenPlay("KashyyykPobPopulation", true)

function KashyyykPobPopulation:start()
	if (not isZoneEnabled("kashyyyk_pob_dungeons")) then
		return
	end

	for i = 1, #self.pools do
		self:populatePool(self.pools[i])
	end

	print("KashyyykPobPopulation: " .. self.spawnedCount .. " creatures placed across the Kashyyyk POB dungeon copies")
end

function KashyyykPobPopulation:populatePool(pool)
	local buildings = self.copies[pool.key]

	if (buildings == nil or #buildings == 0) then
		print("KashyyykPobPopulation: copy list '" .. pool.key .. "' is empty; " .. pool.label .. " will not be populated")
		return
	end

	for i = 1, #buildings do
		self:populateCopy(pool, buildings[i])
	end
end

function KashyyykPobPopulation:populateCopy(pool, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("KashyyykPobPopulation: " .. pool.key .. " copy " .. buildingID .. " is missing; it gets no creatures")
		return
	end

	-- Resolved once per cell name rather than once per row. A cell the
	-- building does not have is reported once, by name, instead of once per row.
	local cells = {}

	for i = 1, #pool.rows do
		local row = pool.rows[i]
		local cellName = row[2]

		if (cells[cellName] == nil) then
			cells[cellName] = self:resolveCell(pBuilding, cellName)

			if (cells[cellName] == 0) then
				print("KashyyykPobPopulation: " .. pool.key .. " copy " .. buildingID .. " has no cell named '" .. cellName .. "'; its rows from " .. pool.table .. " are skipped")
			end
		end

		if (cells[cellName] ~= 0) then
			self:spawnRow(pool, row, cells[cellName], buildingID)
		end
	end
end

function KashyyykPobPopulation:resolveCell(pBuilding, cellName)
	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

	if (pCell == nil) then
		return 0
	end

	return SceneObject(pCell):getObjectID()
end

function KashyyykPobPopulation:spawnRow(pool, row, cellID, buildingID)
	local template = row[1]

	if (template == nil) then
		print("KashyyykPobPopulation: no template on a row of " .. pool.table .. "; that row is skipped")
		return
	end

	-- row is { repo template, cell, x, z, y, heading } and spawnMobile wants
	-- x, z, y, heading, so the row reads straight across. Heading is in DEGREES
	-- here -- see THE AXIS MAPPING. Respawn is self.respawn (600), the same
	-- argument MustafarDungeonPopulation:spawnRow passes at line 1230.
	local pMobile = spawnMobile("kashyyyk_pob_dungeons", template, self.respawn, row[3], row[4], row[5], row[6], cellID)

	if (pMobile == nil) then
		print("KashyyykPobPopulation: failed to spawn " .. template .. " in " .. row[2] .. " of " .. pool.key .. " copy " .. buildingID)
		return
	end

	self.spawnedCount = self.spawnedCount + 1
end
