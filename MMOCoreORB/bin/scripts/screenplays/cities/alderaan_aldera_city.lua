local alderaSidewalkRoutes = {
	{population = 4, points = {{1181, -1543, 0}, {1181, -1228, 180}}},
	{population = 4, points = {{1182, -1535, 0}, {1182, -1242, 180}}},
	{population = 4, points = {{1183, -1522, 0}, {1183, -1260, 180}}},
	{population = 5, points = {{1184, -1540, 0}, {1184, -1236, 180}}},
	{population = 4, points = {{1185, -1512, 0}, {1185, -1280, 180}}},
	{population = 5, points = {{1186, -1543, 0}, {1186, -1305, 180}}},
	{population = 4, points = {{1187, -1500, 0}, {1187, -1340, 180}}},
	{population = 4, points = {{1187.75, -1538, 0}, {1187.75, -1380, 180}}},
	{population = 4, points = {{1188, -1422, 0}, {1188, -1228, 180}}},
	{population = 4, points = {{1189, -1414, 0}, {1189, -1242, 180}}},
	{population = 4, points = {{1190.5, -1420, 0}, {1190.5, -1260, 180}}},
	{population = 4, points = {{1192, -1408, 0}, {1192, -1236, 180}}},
	{population = 4, points = {{1193.5, -1418, 0}, {1193.5, -1280, 180}}},
	{population = 3, points = {{1195, -1405, 0}, {1195, -1305, 180}}},

	-- Opposite sidewalk, north of the cross street.
	{population = 4, points = {{1126, -1410, 0}, {1126, -1230, 180}}},
	{population = 5, points = {{1116, -1410, 0}, {1116, -1230, 180}}},
	{population = 5, points = {{1113, -1410, 0}, {1113, -1230, 180}}},
	{population = 5, points = {{1110, -1410, 0}, {1110, -1230, 180}}},
	{population = 5, points = {{1107, -1410, 0}, {1107, -1230, 180}}},
	{population = 4, points = {{1100, -1410, 0}, {1100, -1230, 180}}},

	-- Opposite sidewalk, south of the cross street.
	{population = 4, points = {{1126, -1415, 0}, {1126, -1544, 180}}},
	{population = 3, points = {{1114, -1547, 0}, {1114, -1481, 180}}},
	{population = 3, points = {{1112, -1547, 0}, {1112, -1481, 180}}},
	{population = 3, points = {{1109, -1547, 0}, {1109, -1481, 180}}},
	{population = 3, points = {{1106, -1547, 0}, {1106, -1481, 180}}},

	-- East-west pedestrian traffic through the central cross streets.
	{population = 6, points = {{939, -1406, 90}, {1350, -1406, 270}}},
	{population = 4, points = {{1351, -1409, 270}, {1263, -1409, 90}}},
	{population = 4, points = {{1351, -1411, 270}, {1263, -1411, 90}}},
	{population = 4, points = {{1351, -1414, 270}, {1263, -1414, 90}}},
	{population = 4, points = {{1351, -1416, 270}, {1263, -1416, 90}}},
	{population = 4, points = {{1230, -1356, 90}, {1394, -1356, 270}}},
	{population = 4, points = {{1230, -1353, 90}, {1394, -1353, 270}}},
	{population = 4, points = {{1230, -1350, 90}, {1394, -1350, 270}}},
	{population = 4, points = {{1230, -1348, 90}, {1394, -1348, 270}}},
	{population = 4, points = {{1114, -1359, 270}, {884, -1359, 90}}},
	{population = 3, points = {{893, -1356, 90}, {948, -1356, 270}}},
	{population = 3, points = {{958, -1356, 90}, {1046, -1356, 270}}}
}

local alderaSidewalkPatrolMobiles = {}
local alderaSidewalkPatrolPoints = {}

for routeIndex = 1, #alderaSidewalkRoutes, 1 do
	local route = alderaSidewalkRoutes[routeIndex]
	local firstPoint = route.points[1]
	local secondPoint = route.points[2]

	for i = 1, route.population, 1 do
		local routeName = "alderaSidewalk" .. routeIndex .. "Npc" .. i
		local startPoint = firstPoint
		local endPoint = secondPoint

		if (getRandomNumber(0, 1) == 1) then
			startPoint = secondPoint
			endPoint = firstPoint
		end

		alderaSidewalkPatrolPoints[routeName] = {
			{startPoint[1], 28, startPoint[2], 0, false},
			{endPoint[1], 28, endPoint[2], 0, false}
		}

		local routeProgress = getRandomNumber(5, 95) / 100
		local spawnX = startPoint[1] + ((endPoint[1] - startPoint[1]) * routeProgress)
		local spawnY = startPoint[2] + ((endPoint[2] - startPoint[2]) * routeProgress)

		table.insert(alderaSidewalkPatrolMobiles, {
			routeName, "patrolNpc", spawnX, 28, spawnY,
			startPoint[3], 0, "", false
		})
	end
end

AlderaCityScreenPlay = CityScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "AlderaCityScreenPlay",
	planet = "alderaan",
	patrolNpcs = {
		"commoner_patrol", "commoner_patrol", "commoner_patrol",
		"commoner_old_patrol", "commoner_fat_patrol", "businessman_patrol",
		"businessman_patrol", "noble_patrol", "scientist_patrol",
		"explorer_patrol", "gambler_patrol", "commoner_technician_patrol",
		"official_patrol", "miner_patrol"
	},
	patrolMobiles = alderaSidewalkPatrolMobiles,
	patrolPoints = alderaSidewalkPatrolPoints
}

registerScreenPlay("AlderaCityScreenPlay", true)

AlderaCityPatrolRoutes = {}

function AlderaCityScreenPlay:start()
	if (isZoneEnabled("alderaan")) then
		self:spawnMobiles()
		self:spawnTheaterSceneObjects()
	end
end

function AlderaCityScreenPlay:spawnPatrols(routes)
	local pedestrians = {
		"commoner", "commoner", "businessman", "artisan", "commoner", "noble",
		"commoner", "alderaan_security_force", "commoner", "stormtrooper",
		"businessman", "alderaan_security_force"
	}

	AlderaCityPatrolRoutes = routes

	for routeIndex = 1, #routes, 1 do
		local route = routes[routeIndex]

		for i = 1, route.population, 1 do
			local pointIndex = getRandomNumber(1, #route.points)
			local point = route.points[pointIndex]
			local nextPoint = route.points[(pointIndex % #route.points) + 1]
			local routeProgress = getRandomNumber(0, 100) / 100
			local spawnX = point[1] + ((nextPoint[1] - point[1]) * routeProgress)
			local spawnY = point[2] + ((nextPoint[2] - point[2]) * routeProgress)
			local templates = route.templates or pedestrians
			local template = templates[((i + routeIndex - 2) % #templates) + 1]
			local pMobile = spawnMobile("alderaan", template, 60, spawnX, 28, spawnY, point[3], 0)

			if (pMobile ~= nil and SceneObject(pMobile):isAiAgent()) then
				local objectID = SceneObject(pMobile):getObjectID()

				writeData(objectID .. ":AlderaCity:route", routeIndex)
				writeData(objectID .. ":AlderaCity:point", pointIndex)
				AiAgent(pMobile):setAITemplate()
				AiAgent(pMobile):setMovementState(AI_PATROLLING)
				createObserver(DESTINATIONREACHED, "AlderaCityScreenPlay", "patrolDestinationReached", pMobile)
				createEvent(getRandomNumber(3, 12) * 1000, "AlderaCityScreenPlay", "walkPatrol", pMobile, "")
			end
		end
	end
end

function AlderaCityScreenPlay:spawnCantinaMobiles()
	local cantinaCellID = 610000068
	local cantinaMobiles = {
		-- Staff work from inside the U-shaped bar.
		{"bartender", -11.5, -0.9, 2.0, 230, "conversation"},
		{"bartender", 8.6, -0.9, 0.6, 90, "neutral"},

		-- Customers line the public side of the bar.
		{"patron", 10.65, -0.895, 1.91, 330, "npc_standing_drinking"},
		{"commoner", -4.11, -0.895, 5.4, 27, "happy"},
		{"gambler", 10.17, -0.895, 2.74, 125, "conversation"},
		{"businessman", 2.11, -0.895, 5.4, 180, "npc_standing_drinking"},
		{"mercenary", 3.11, 0, 5.4, 161, "bored"},
		{"noble", 1.11, 0, 5.4, 330, "npc_standing_drinking"},
		{"artisan", -3.11, 0, 5.4, 17, "npc_standing_drinking"},
		{"info_broker", 4.11, -0.895, 5.4, 158, "npc_standing_drinking"},
		{"devaronian_male", 9.4, 0, 3.9, 310, "conversation"},

		-- Seated patrons at the southern tables.
		{"chiss_female", 13.7, -0.9, -5.6, 67, "npc_sitting_chair"},
		{"sullustan_male", 13.6, -0.9, -2.4, 147, "npc_sitting_chair"},
		{"commoner_old", 16.3, -0.9, -5.6, 320, "npc_sitting_chair"},
		{"patron", -3.2, -0.9, -10.8, 65, "npc_sitting_table_eating"},

		-- Seated patrons at the northern tables.
		{"ithorian_male", -3.1, -0.9, 11.6, 97, "npc_sitting_table"},
		{"businessman", 1.2, -0.9, 11.6, 269, "npc_sitting_chair"},
		{"commoner", 14.1, -0.9, 4.3, 51, "npc_sitting_table"},
		{"noble", 14.4, -0.9, 7.5, 139, "npc_sitting_chair"},

		-- Additional occupied tables and a nearby conversation.
		{"artisan", 17.1, -0.9, 7.8, 226, "npc_sitting_chair"},
		{"commoner", 23.5, -0.9, -8.9, 51, "npc_sitting_table"},
		{"info_broker", 26.3, -0.9, -8.8, 317, "npc_sitting_table_eating"},
		{"patron", 1.99, -0.895, -8.44, 325, "conversation"},

		-- Small standing conversations and activity near the stage side.
		{"bounty_hunter", 1.19, -0.895, -7.63, 152, "conversation"},
		{"mercenary", 8.0, -0.9, -4.5, -21, "angry"},
		{"commoner", 6.8, -0.9, -4.5, -22, "npc_worried"},
		{"commoner_old", 16.1, -0.9, 4.1, 340, "conversation"},
		{"entertainer", 19.1, -0.9, 6.1, 41, "entertained"},
		{"entertainer", 22.2, -0.9, 4.3, 22, "entertained"},
		{"patron", 8.49, -0.895, 4.64, 129, "conversation"}
	}

	for i = 1, #cantinaMobiles, 1 do
		local mobile = cantinaMobiles[i]
		local pMobile = spawnMobile("alderaan", mobile[1], 60, mobile[2], mobile[3], mobile[4], mobile[5], cantinaCellID)

		if (pMobile ~= nil) then
			CreatureObject(pMobile):setMoodString(mobile[6])

			if (SceneObject(pMobile):isAiAgent()) then
				AiAgent(pMobile):addObjectFlag(AI_STATIC)

				if (CreatureObject(pMobile):getPvpStatusBitmask() == 0) then
					CreatureObject(pMobile):clearOptionBit(AIENABLED)
				end
			end
		end
	end
end

function AlderaCityScreenPlay:walkPatrol(pMobile)
	if (pMobile == nil or not SceneObject(pMobile):isAiAgent() or SceneObject(pMobile):getZoneName() == "" or CreatureObject(pMobile):isDead()) then
		return
	end

	if (CreatureObject(pMobile):isInCombat()) then
		createEvent(10 * 1000, "AlderaCityScreenPlay", "walkPatrol", pMobile, "")
		return
	end

	local objectID = SceneObject(pMobile):getObjectID()
	local routeIndex = readData(objectID .. ":AlderaCity:route")
	local route = AlderaCityPatrolRoutes[routeIndex]

	if (route == nil) then
		return
	end

	local pointIndex = readData(objectID .. ":AlderaCity:point") + 1

	if (pointIndex > #route.points) then
		pointIndex = 1
	end

	local point = route.points[pointIndex]

	writeData(objectID .. ":AlderaCity:point", pointIndex)
	AiAgent(pMobile):setMovementState(AI_PATROLLING)
	AiAgent(pMobile):stopWaiting()
	AiAgent(pMobile):setWait(0)
	AiAgent(pMobile):setNextPosition(point[1], 28, point[2], 0)
	AiAgent(pMobile):executeBehavior()
end

function AlderaCityScreenPlay:patrolDestinationReached(pMobile)
	if (pMobile ~= nil and SceneObject(pMobile):getZoneName() ~= "" and not CreatureObject(pMobile):isDead()) then
		createEvent(getRandomNumber(4, 15) * 1000, "AlderaCityScreenPlay", "walkPatrol", pMobile, "")
	end

	return 0
end

function AlderaCityScreenPlay:spawnCapitolMobiles()
	local capitolCellID = 610000021
	local capitolMobiles = {
		-- Coronet capitol cell 1855463 layout, remapped to Aldera City's main cell.
		{"noble", 60, 5.22842, 0.3, 2.91677, 0, "conversation"},
		{"info_broker", 60, 5.22842, 0.3, 4.01677, 180.005, "conversation"},
		{"corellia_times_reporter", 60, 5.43518, 2.27819, -27.0615, 344.925, "conversation"},
		{"brawler", 60, -1.72746, 7.9, -32.175, 0, "conversation"},
		{"comm_operator", 300, -0.332123, 0.3, -2.90219, 134.998, "conversation"},
		{"entertainer", 60, 0.767877, 0.3, -2.90219, 180.005, "conversation"},
		{"farmer", 60, -18.6014, 1.30259, -11.3146, 360.011, "conversation"},
		{"farmer", 60, 0.767877, 0.3, -4.00219, 0, "conversation"},
		{"medic", 60, -0.332123, 0.3, -4.00219, 45.0054, "conversation"},
		{"medic", 60, 5.18395, 2.27819, -26.1292, 164.924, "conversation"},
		{"noble", 60, 4.12842, 0.3, 4.01677, 134.998, "conversation"},
		{"scientist", 60, -1.72746, 7.9, -31.075, 180.005, "conversation"},
		{"mercenary", 300, -18.6014, 1.30292, -10.2146, 180.006, "conversation"}
	}

	for i = 1, #capitolMobiles, 1 do
		local mobile = capitolMobiles[i]
		local pMobile = spawnMobile("alderaan", mobile[1], mobile[2], mobile[3], mobile[4], mobile[5], mobile[6], capitolCellID)

		if (pMobile ~= nil) then
			CreatureObject(pMobile):setMoodString(mobile[7])
			AiAgent(pMobile):addObjectFlag(AI_STATIC)

			if (CreatureObject(pMobile):getPvpStatusBitmask() == 0) then
				CreatureObject(pMobile):clearOptionBit(AIENABLED)
			end
		end
	end
end

function AlderaCityScreenPlay:spawnTheaterMobiles()
	local theaterCellID = 610000087
	local theaterMobiles = {
		-- Band on the raised stage, facing the audience.
		{"droopy_mccool", -5.5, 2.1, 50.5, 180, "themepark_music_3"},
		{"nalan_cheel", -2.75, 2.1, 51.5, 180, "themepark_music_1"},
		{"figrin_dan", 0, 2.1, 50.5, 180, "themepark_music_3"},
		{"doikk_nats", 2.75, 2.1, 51.5, 180, "themepark_music_3"},
		{"tedn_dahai", 5.5, 2.1, 50.5, 180, "themepark_music_3"},

		-- Audience rows follow the theater's tiered floor and face the stage.
		{"noble", -6.5, 2.2, 27.3, 5, "entertained"},
		{"commoner", -3.2, 2.2, 27.3, 355, "applause_polite"},
		{"artisan", 0, 2.2, 27.3, 2, "entertained"},
		{"businessman", 3.2, 2.2, 27.3, 358, "applause_excited"},
		{"commoner_old", 6.5, 2.2, 27.3, 4, "entertained"},
		{"scientist", -7, 1.8, 31.4, 7, "entertained"},
		{"commoner", -3.5, 1.8, 31.4, 353, "applause_excited"},
		{"info_broker", 0, 1.8, 31.4, 0, "entertained"},
		{"farmer", 3.5, 1.8, 31.4, 6, "applause_polite"},
		{"noble", 7, 1.8, 31.4, 354, "entertained"},
		{"commoner_technician", -6.5, 1.4, 35.9, 3, "entertained"},
		{"medic", -3.2, 1.4, 35.9, 357, "applause_polite"},
		{"mercenary", 0, 1.4, 35.9, 0, "entertained"},
		{"commoner", 3.2, 1.4, 35.9, 5, "applause_excited"},
		{"official", 6.5, 1.4, 35.9, 355, "entertained"},
		{"brawler", -6, 1.0, 39.7, 8, "applause_excited"},
		{"commoner", -2, 1.0, 39.7, 356, "entertained"},
		{"farmer_rancher", 2, 1.0, 39.7, 4, "applause_polite"},
		{"noble", 6, 1.0, 39.7, 352, "entertained"},
		{"explorer", -5, 0.7, 43.3, 10, "entertained"},
		{"commoner", 0, 0.7, 43.3, 0, "applause_excited"},
		{"gambler", 5, 0.7, 43.3, 350, "entertained"}
	}

	for i = 1, #theaterMobiles, 1 do
		local mobile = theaterMobiles[i]
		local pMobile = spawnMobile("alderaan", mobile[1], 60, mobile[2], mobile[3], mobile[4], mobile[5], theaterCellID)

		if (pMobile ~= nil) then
			CreatureObject(pMobile):setMoodString(mobile[6])
			AiAgent(pMobile):addObjectFlag(AI_STATIC)

			if (CreatureObject(pMobile):getPvpStatusBitmask() == 0) then
				CreatureObject(pMobile):clearOptionBit(AIENABLED)
			end
		end
	end
end

function AlderaCityScreenPlay:spawnTheaterSceneObjects()
	local theaterCellID = 610000087
	local lampTemplate = "object/tangible/furniture/all/frn_all_light_lamp_free_s01.iff"

	-- Four stage lamps provide the strongest illumination around the band.
	spawnSceneObject("alderaan", lampTemplate, -8, 2.1, 48.5, theaterCellID, math.rad(0))
	spawnSceneObject("alderaan", lampTemplate, 8, 2.1, 48.5, theaterCellID, math.rad(0))
	spawnSceneObject("alderaan", lampTemplate, -8, 2.1, 53, theaterCellID, math.rad(180))
	spawnSceneObject("alderaan", lampTemplate, 8, 2.1, 53, theaterCellID, math.rad(180))

	-- Lower-level aisle lighting keeps the audience area readable.
	spawnSceneObject("alderaan", lampTemplate, -8.5, 1.8, 31.5, theaterCellID, math.rad(0))
	spawnSceneObject("alderaan", lampTemplate, 8.5, 1.8, 31.5, theaterCellID, math.rad(0))
	spawnSceneObject("alderaan", lampTemplate, -8.5, 0.7, 43, theaterCellID, math.rad(0))
	spawnSceneObject("alderaan", lampTemplate, 8.5, 0.7, 43, theaterCellID, math.rad(0))
end

function AlderaCityScreenPlay:spawnHotelMobiles()
	local townspersonTemplates = {
		"commoner", "commoner", "commoner_old", "commoner_fat", "artisan",
		"businessman", "farmer", "gambler", "info_broker", "medic",
		"noble", "official", "pilot", "scientist"
	}
	local hotelMobiles = {
		-- Bar and stage in cell 610000052.
		{"bartender", 20.1, 1.6, 12.3, 180, 610000052, "neutral"},
		{"entertainer", 24.3, 2.0, -15.5, 0, 610000052, "entertained"},
		{"patron", 17.5, 1.3, 9.9, 70, 610000052, "conversation"},
		{"businessman", 18.9, 1.3, 10.2, 275, 610000052, "conversation"},
		{"commoner", 21.6, 1.3, 10.6, 351, 610000052, "entertained"},
		{"noble", 14.2, 1.3, 6.8, 210, 610000052, "entertained"},
		{"commoner_old", 16.0, 1.3, 5.7, 195, 610000052, "applause_polite"},
		{"artisan", 19.2, 1.3, 4.8, 185, 610000052, "entertained"},
		{"gambler", 22.4, 1.3, 5.5, 170, 610000052, "applause_excited"},
		{"pilot", 25.2, 1.3, 7.2, 155, 610000052, "entertained"},
		{"info_broker", 14.8, 1.3, 0.6, 205, 610000052, "entertained"},
		{"farmer", 18.0, 1.3, -0.5, 190, 610000052, "applause_polite"},
		{"commoner", 21.4, 1.3, 0.2, 175, 610000052, "entertained"},
		{"medic", 24.8, 1.3, -1.0, 160, 610000052, "applause_excited"},
		{"mercenary", 15.5, 1.3, -6.2, 210, 610000052, "entertained"},
		{"commoner", 19.4, 1.3, -7.0, 190, 610000052, "applause_polite"},
		{"noble", 23.0, 1.3, -6.4, 165, 610000052, "entertained"},

		-- Entry lobby, cell 610000051.
		{"townsperson", -6.0, 1.0, 8.0, 120, 610000051, "conversation"},
		{"townsperson", -4.8, 1.0, 7.2, 300, 610000051, "conversation"},
		{"townsperson", 4.8, 1.0, 8.5, 215, 610000051, "calm"},
		{"townsperson", 6.2, 1.0, 6.8, 45, 610000051, "conversation"},
		{"townsperson", -5.5, 1.0, -7.5, 80, 610000051, "neutral"},
		{"townsperson", 0.5, 1.0, -2.0, 330, 610000051, "happy"},
		{"townsperson", 5.8, 1.0, -8.0, 270, 610000051, "conversation"},
		{"townsperson", 4.5, 1.0, -8.0, 90, 610000051, "conversation"},

		-- Adjoining lobby and lounge, cells 610000053 and 610000054.
		{"townsperson", -13.5, 1.6, 10.5, 210, 610000053, "calm"},
		{"townsperson", -17.5, 1.6, 8.0, 45, 610000053, "conversation"},
		{"townsperson", -18.8, 1.6, 9.2, 225, 610000053, "conversation"},
		{"townsperson", -24.0, 1.6, 4.0, 320, 610000053, "neutral"},
		{"townsperson", -21.0, 1.6, -3.5, 160, 610000053, "conversation"},
		{"townsperson", -19.7, 1.6, -4.4, 340, 610000053, "conversation"},
		{"townsperson", -18.5, 1.6, -11.0, 30, 610000054, "calm"},
		{"townsperson", -14.5, 1.6, -10.5, 135, 610000054, "conversation"},
		{"townsperson", -12.8, 1.6, -11.5, 315, 610000054, "conversation"},
		{"townsperson", -16.0, 1.6, -6.5, 180, 610000054, "neutral"}
	}

	for i = 1, #hotelMobiles, 1 do
		local mobile = hotelMobiles[i]
		local template = mobile[1]

		if (template == "townsperson") then
			template = townspersonTemplates[getRandomNumber(#townspersonTemplates)]
		end

		local pMobile = spawnMobile("alderaan", template, 60, mobile[2], mobile[3], mobile[4], mobile[5], mobile[6])

		if (pMobile ~= nil) then
			CreatureObject(pMobile):setMoodString(mobile[7])
			AiAgent(pMobile):addObjectFlag(AI_STATIC)

			if (CreatureObject(pMobile):getPvpStatusBitmask() == 0) then
				CreatureObject(pMobile):clearOptionBit(AIENABLED)
			end
		end
	end
end

function AlderaCityScreenPlay:spawnMobiles()
	local pBailOrgana = spawnMobile("alderaan", "bail_organa", 60, -35.3, 1.3, -2.8, 84, 610000025)

	if (pBailOrgana ~= nil and SceneObject(pBailOrgana):isAiAgent()) then
		AiAgent(pBailOrgana):addObjectFlag(AI_STATIC)
	end

	local pLeiaOrgana = spawnMobile("alderaan", "leia_organa", 60, -35.6, 1.3, -0.5, 153, 610000025)

	if (pLeiaOrgana ~= nil and SceneObject(pLeiaOrgana):isAiAgent()) then
		AiAgent(pLeiaOrgana):addObjectFlag(AI_STATIC)
	end

	self:spawnCapitolMobiles()
	self:spawnTheaterMobiles()
	self:spawnHotelMobiles()

	-- Derived from every unambiguous rectangular CityFlattenToo layer beneath
	-- Aldera City in terrain/alderaan.trn. Every segment stays inside its layer.
	local pedestrianRoutes = {
		{population = 7, points = {{1134, -1540, 0}, {1166, -1540, 0}, {1166, -1205, 0}, {1134, -1205, 0}}},
		{population = 7, points = {{889, -1401, 0}, {1390, -1401, 0}, {1390, -1365, 0}, {889, -1365, 0}}},
		{population = 3, points = {{945, -1473, 0}, {1006, -1473, 0}, {1006, -1408, 0}, {945, -1408, 0}}},
		{population = 3, points = {{1360, -1359, 0}, {1389, -1359, 0}, {1389, -1331, 0}, {1360, -1331, 0}}},
		{population = 5, points = {{902, -1297, 0}, {1046, -1297, 0}, {1046, -1178, 0}, {902, -1178, 0}}},
		{population = 3, points = {{822, -1200, 0}, {894, -1200, 0}, {894, -1178, 0}, {822, -1178, 0}}},
		{population = 5, points = {{822, -1346, 0}, {838, -1346, 0}, {838, -1206, 0}, {822, -1206, 0}}},
		{population = 4, points = {{790, -1433, 0}, {817, -1433, 0}, {817, -1326, 0}, {790, -1326, 0}}},
		{population = 4, points = {{820.75, -1419.5, 0}, {941.25, -1419.5, 0}}},
		{population = 4, points = {{802, -1509, 0}, {919, -1509, 0}, {919, -1478, 0}, {802, -1478, 0}}},
		{population = 3, points = {{827.5, -1470.25, 0}, {827.5, -1426.75, 0}}},
		{population = 3, points = {{1052.25, -1307.5, 0}, {1127.75, -1307.5, 0}}},
		{population = 3, points = {{1044, -1309, 0}, {1044, -1293, 0}}},
		{population = 4, points = {{1391, -1349, 0}, {1508, -1349, 0}, {1508, -1332, 0}, {1391, -1332, 0}}},
		{population = 3, points = {{1415, -1468, 0}, {1493, -1468, 0}, {1493, -1415, 0}, {1415, -1415, 0}}},
		{population = 3, points = {{1360.75, -1422.25, 0}, {1407.25, -1422.25, 0}, {1407.25, -1414.75, 0}, {1360.75, -1414.75, 0}}},
		{population = 3, points = {{1361, -1422, 0}, {1389, -1422, 0}, {1389, -1408, 0}, {1361, -1408, 0}}},
		{population = 3, points = {{1347, -1492, 0}, {1428, -1492, 0}, {1428, -1476, 0}, {1347, -1476, 0}}},
		{population = 3, points = {{1427, -1529.5, 0}, {1427, -1496.5, 0}}},
		{population = 3, points = {{1370, -1591, 0}, {1428, -1591, 0}, {1428, -1535, 0}, {1370, -1535, 0}}},
		{population = 3, points = {{1347.5, -1542.5, 0}, {1354.5, -1542.5, 0}, {1354.5, -1499.5, 0}, {1347.5, -1499.5, 0}}},
		{population = 3, points = {{1362, -1544, 0}, {1362, -1534, 0}}},
		{population = 4, points = {{1242, -1515, 0}, {1340, -1515, 0}, {1340, -1502, 0}, {1242, -1502, 0}}},
		{population = 4, points = {{1255, -1495, 0}, {1255, -1405, 0}}},
		{
			population = 24,
			templates = {
				"stormtrooper", "stormtrooper", "imperial_trooper", "imperial_private",
				"imperial_noncom", "imperial_staff_sergeant", "imperial_medic",
				"imperial_pilot", "imperial_officer", "imperial_first_lieutenant",
				"alderaan_security_force"
			},
			points = {{1218, -1730, 0}, {1357, -1730, 0}, {1357, -1554, 0}, {1218, -1554, 0}}
		},
		{population = 4, points = {{1082, -1737, 0}, {1205, -1737, 0}, {1205, -1702, 0}, {1082, -1702, 0}}},
		{population = 3, points = {{1130, -1693, 0}, {1171, -1693, 0}, {1171, -1661, 0}, {1130, -1661, 0}}},
		{population = 3, points = {{1045, -1711, 0}, {1097, -1711, 0}, {1097, -1659, 0}, {1045, -1659, 0}}},
		{population = 4, points = {{922, -1683, 0}, {1038, -1683, 0}}},
		{population = 3, points = {{923, -1676, 0}, {972, -1676, 0}, {972, -1642, 0}, {923, -1642, 0}}},
		{population = 3, points = {{923, -1633, 0}, {937, -1633, 0}, {937, -1609, 0}, {923, -1609, 0}}},
		{population = 3, points = {{882, -1628, 0}, {915, -1628, 0}, {915, -1580, 0}, {882, -1580, 0}}},
		{population = 3, points = {{833, -1596, 0}, {874, -1596, 0}, {874, -1580, 0}, {833, -1580, 0}}},
		{population = 3, points = {{833, -1577, 0}, {841, -1577, 0}, {841, -1515, 0}, {833, -1515, 0}}},
		{population = 3, points = {{1349, -1290, 0}, {1402, -1290, 0}, {1402, -1246, 0}, {1349, -1246, 0}}},
		{population = 4, points = {{1377, -1290, 0}, {1402, -1290, 0}, {1402, -1173, 0}, {1377, -1173, 0}}},
		{population = 3, points = {{1306, -1201, 0}, {1372, -1201, 0}, {1372, -1173, 0}, {1306, -1173, 0}}},
		{population = 3, points = {{1402, -1326, 0}, {1402, -1295, 0}}},
		{population = 3, points = {{1366, -1166, 0}, {1384, -1166, 0}, {1384, -1092, 0}, {1366, -1092, 0}}},
		{population = 3, points = {{1457, -1284, 0}, {1482, -1284, 0}, {1482, -1229, 0}, {1457, -1229, 0}}},
		{population = 3, points = {{1409, -1261, 0}, {1450, -1261, 0}, {1450, -1245, 0}, {1409, -1245, 0}}},
		{population = 3, points = {{1457.5, -1221.5, 0}, {1464.5, -1221.5, 0}, {1464.5, -1161.5, 0}, {1457.5, -1161.5, 0}}},
		{population = 4, points = {{1247.75, -1104.5, 0}, {1358.25, -1104.5, 0}}},
		{population = 3, points = {{1233, -1164, 0}, {1252, -1164, 0}, {1252, -1103, 0}, {1233, -1103, 0}}},
		{population = 4, points = {{1216, -1129, 0}, {1216, -1040, 0}}},
		{population = 3, points = {{1216, -1127, 0}, {1226, -1127, 0}, {1226, -1103, 0}, {1216, -1103, 0}}},
		{population = 3, points = {{1213, -1054, 0}, {1239, -1054, 0}, {1239, -1023, 0}, {1213, -1023, 0}}},
		{population = 4, points = {{1091, -1033, 0}, {1207, -1033, 0}, {1207, -1024, 0}, {1091, -1024, 0}}},
		{population = 4, points = {{974, -1061, 0}, {1085, -1061, 0}, {1085, -1024, 0}, {974, -1024, 0}}}
	}

	self:spawnPatrols(pedestrianRoutes)

	-- Use the stock CityScreenPlay patrol framework used by Mos Eisley's CLL-8
	-- load lifters. These tables are attached before screenplay registration so
	-- delayed callbacks resolve the same patrol definitions used at spawn time.
	self:spawnPatrolMobiles()
	self:spawnCantinaMobiles()
end
