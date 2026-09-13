AlderaCityScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "AlderaCityScreenPlay"
}

registerScreenPlay("AlderaCityScreenPlay", true)

AlderaCityPatrolRoutes = {}

function AlderaCityScreenPlay:start()
	if (isZoneEnabled("alderaan")) then
		self:spawnMobiles()
	end
end

function AlderaCityScreenPlay:spawnCityMobile(template, x, z, y, direction, mood)
	local pMobile = spawnMobile("alderaan", template, 60, x, z, y, direction, 0)

	if (pMobile ~= nil and mood ~= nil) then
		self:setMoodString(pMobile, mood)
	end

	if (pMobile ~= nil and SceneObject(pMobile):isAiAgent()) then
		AiAgent(pMobile):addObjectFlag(AI_STATIC)
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

		for i = 1, #route * 5, 1 do
			local pointIndex = ((i - 1) % #route) + 1
			local point = route[pointIndex]
			local nextPoint = route[(pointIndex % #route) + 1]
			local routeProgress = getRandomNumber(0, 80) / 100
			local spawnX = point[1] + ((nextPoint[1] - point[1]) * routeProgress)
			local spawnY = point[2] + ((nextPoint[2] - point[2]) * routeProgress)
			local template = pedestrians[((i + routeIndex - 2) % #pedestrians) + 1]
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
	local pointIndex = readData(objectID .. ":AlderaCity:point") + 1

	if (route == nil) then
		return
	end

	if (pointIndex > #route) then
		pointIndex = 1
	end

	local point = route[pointIndex]

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

function AlderaCityScreenPlay:spawnMobiles()
	-- Starport concourse and arrival plaza: travelers, port staff, and security.
	local starport = {
		{"commoner", 1118, 28, -1143, 42, "conversation"},
		{"commoner", 1121, 28, -1140, -132, "conversation"},
		{"businessman", 1140, 28, -1160, 8, "neutral"},
		{"artisan", 1152, 28, -1168, -35, "neutral"},
		{"commoner", 1105, 28, -1172, 68, "neutral"},
		{"commoner", 1098, 28, -1155, -78, "neutral"},
		{"noble", 1137, 28, -1123, 174, "neutral"},
		{"commoner", 1163, 28, -1139, -99, "conversation"},
		{"commoner", 1160, 28, -1142, 83, "conversation"},
		{"artisan", 1086, 28, -1181, 24, "neutral"},
		{"alderaan_security_force", 1119, 28, -1125, 179, "neutral"},
		{"alderaan_security_force", 1142, 28, -1125, 179, "neutral"},
		{"stormtrooper", 1102, 28, -1190, 12, "neutral"},
		{"stormtrooper", 1167, 28, -1184, -18, "neutral"}
	}

	-- Central civic square: officials, professionals, residents, and patrols.
	local civicSquare = {
		{"noble", 1135, 28, -1360, -12, "conversation"},
		{"businessman", 1138, 28, -1357, 164, "conversation"},
		{"commoner", 1162, 28, -1372, 83, "conversation"},
		{"commoner", 1166, 28, -1372, -91, "conversation"},
		{"scientist", 1185, 28, -1394, 28, "neutral"},
		{"medic", 1191, 28, -1387, -148, "neutral"},
		{"artisan", 1108, 28, -1402, 52, "neutral"},
		{"noble", 1124, 28, -1418, -30, "neutral"},
		{"commoner", 1149, 28, -1426, 7, "neutral"},
		{"commoner", 1177, 28, -1414, -58, "neutral"},
		{"businessman", 1092, 28, -1377, 91, "neutral"},
		{"commoner", 1087, 28, -1365, -47, "neutral"},
		{"commoner", 1203, 28, -1360, -112, "neutral"},
		{"noble", 1210, 28, -1403, 126, "neutral"},
		{"alderaan_security_force", 1114, 28, -1341, 8, "neutral"},
		{"alderaan_security_force", 1188, 28, -1342, -8, "neutral"},
		{"alderaan_security_force", 1110, 28, -1427, 174, "neutral"},
		{"alderaan_security_force", 1190, 28, -1427, -174, "neutral"},
		{"stormtrooper", 1150, 28, -1333, 180, "neutral"},
		{"stormtrooper", 1150, 28, -1439, 0, "neutral"}
	}

	-- Market streets: merchants and artisans mixed with shoppers and couriers.
	local market = {
		{"artisan", 967, 28, -1370, 86, "neutral"},
		{"businessman", 974, 28, -1361, -103, "neutral"},
		{"commoner", 990, 28, -1385, 31, "conversation"},
		{"commoner", 993, 28, -1382, -142, "conversation"},
		{"artisan", 1011, 28, -1404, 72, "neutral"},
		{"commoner", 1025, 28, -1374, -21, "neutral"},
		{"commoner", 945, 28, -1408, 113, "neutral"},
		{"businessman", 935, 28, -1389, -69, "neutral"},
		{"artisan", 1002, 28, -1430, 9, "neutral"},
		{"commoner", 1033, 28, -1420, -122, "neutral"},
		{"commoner", 955, 28, -1345, 155, "neutral"},
		{"noble", 1019, 28, -1340, -158, "neutral"},
		{"alderaan_security_force", 925, 28, -1370, 90, "neutral"},
		{"alderaan_security_force", 1044, 28, -1401, -90, "neutral"},
		{"alderaan_security_force", 982, 28, -1442, 5, "neutral"}
	}

	-- Cultural and leisure quarter: entertainers, patrons, and evening foot traffic.
	local leisure = {
		{"entertainer", 1244, 28, -1268, -72, "happy"},
		{"patron", 1238, 28, -1270, 89, "conversation"},
		{"patron", 1248, 28, -1283, -28, "neutral"},
		{"commoner", 1270, 28, -1291, 138, "conversation"},
		{"commoner", 1267, 28, -1295, -41, "conversation"},
		{"noble", 1219, 28, -1307, 26, "neutral"},
		{"entertainer", 1290, 28, -1320, -116, "happy"},
		{"patron", 1284, 28, -1324, 61, "neutral"},
		{"commoner", 1225, 28, -1245, -12, "neutral"},
		{"businessman", 1260, 28, -1241, 176, "neutral"},
		{"alderaan_security_force", 1209, 28, -1282, 77, "neutral"},
		{"alderaan_security_force", 1302, 28, -1301, -94, "neutral"}
	}

	-- West shuttleport and the connecting promenade.
	local westTransit = {
		{"commoner", 807, 28, -1443, 32, "neutral"},
		{"commoner", 825, 28, -1445, -38, "neutral"},
		{"businessman", 805, 28, -1468, 124, "neutral"},
		{"artisan", 832, 28, -1465, -126, "neutral"},
		{"commoner", 862, 28, -1448, 74, "conversation"},
		{"commoner", 866, 28, -1448, -91, "conversation"},
		{"noble", 889, 28, -1429, -154, "neutral"},
		{"commoner", 902, 28, -1469, 8, "neutral"},
		{"alderaan_security_force", 801, 28, -1431, 158, "neutral"},
		{"alderaan_security_force", 834, 28, -1431, -158, "neutral"},
		{"stormtrooper", 816, 28, -1480, 0, "neutral"}
	}

	-- East shuttleport and commercial approach.
	local eastTransit = {
		{"commoner", 1294, 28, -1512, 44, "neutral"},
		{"commoner", 1317, 28, -1514, -48, "neutral"},
		{"businessman", 1291, 28, -1537, 137, "neutral"},
		{"artisan", 1320, 28, -1538, -137, "neutral"},
		{"commoner", 1262, 28, -1494, 68, "conversation"},
		{"commoner", 1266, 28, -1494, -104, "conversation"},
		{"scientist", 1235, 28, -1473, 19, "neutral"},
		{"medic", 1227, 28, -1481, -152, "neutral"},
		{"noble", 1350, 28, -1490, -166, "neutral"},
		{"commoner", 1364, 28, -1525, 94, "neutral"},
		{"alderaan_security_force", 1290, 28, -1500, 161, "neutral"},
		{"alderaan_security_force", 1320, 28, -1500, -161, "neutral"},
		{"stormtrooper", 1305, 28, -1550, 0, "neutral"}
	}

	-- Dense pedestrian traffic along the city's principal boulevards and promenades.
	local pedestrianRoutes = {
		{
			{1128, -1200, 176}, {1134, -1220, 174}, {1138, -1240, 178},
			{1142, -1260, 180}, {1145, -1280, 176}, {1148, -1300, 181}
		},
		{
			{1150, -1320, 178}, {1151, -1458, 2}, {1155, -1480, -3},
			{1160, -1502, 4}, {1164, -1524, 1}, {1168, -1546, -5}
		},
		{
			{1055, -1408, 84}, {1032, -1414, 88}, {1009, -1420, 91},
			{986, -1427, 87}, {963, -1434, 92}, {940, -1440, 89},
			{917, -1446, 94}, {894, -1450, 88}, {871, -1453, 91}
		},
		{
			{1214, -1435, -71}, {1235, -1448, -68}, {1256, -1461, -65},
			{1277, -1474, -69}, {1298, -1487, -66}, {1320, -1500, -71}
		},
		{
			{1068, -1312, 62}, {1085, -1296, 48}, {1100, -1280, 43},
			{1085, -1296, -132}
		}
	}

	-- Residential gardens and neighborhood plazas: families, workers, and local services.
	local residential = {
		{"commoner", 1038, 28, -1242, 37, "conversation"},
		{"commoner", 1041, 28, -1239, -141, "conversation"},
		{"medic", 1060, 28, -1224, 82, "neutral"},
		{"artisan", 1078, 28, -1208, -97, "neutral"},
		{"commoner", 1018, 28, -1270, 12, "neutral"},
		{"noble", 1002, 28, -1292, 54, "neutral"},
		{"commoner", 988, 28, -1261, -73, "neutral"},
		{"businessman", 1064, 28, -1268, 144, "neutral"},
		{"commoner", 1280, 28, -1390, 72, "conversation"},
		{"commoner", 1284, 28, -1390, -94, "conversation"},
		{"artisan", 1300, 28, -1371, 131, "neutral"},
		{"medic", 1322, 28, -1398, -118, "neutral"},
		{"noble", 1340, 28, -1378, 166, "neutral"},
		{"commoner", 1356, 28, -1410, -24, "neutral"},
		{"commoner", 1308, 28, -1426, 19, "neutral"},
		{"businessman", 1274, 28, -1422, -153, "neutral"}
	}

	-- Government and medical approaches: clerks, specialists, and waiting citizens.
	local publicServices = {
		{"businessman", 1072, 28, -1338, 94, "conversation"},
		{"noble", 1075, 28, -1338, -91, "conversation"},
		{"scientist", 1098, 28, -1323, 32, "neutral"},
		{"medic", 1220, 28, -1380, -72, "neutral"},
		{"medic", 1225, 28, -1386, 108, "conversation"},
		{"commoner", 1222, 28, -1389, -45, "conversation"},
		{"scientist", 1198, 28, -1460, 18, "neutral"},
		{"businessman", 1178, 28, -1468, 126, "neutral"},
		{"commoner", 1090, 28, -1438, -9, "neutral"},
		{"commoner", 1072, 28, -1428, 77, "neutral"},
		{"noble", 1170, 28, -1308, 173, "neutral"},
		{"businessman", 1181, 28, -1290, -139, "neutral"}
	}

	-- Additional checkpoints keep the larger crowd visibly under Imperial control.
	local checkpoints = {
		{"alderaan_security_force", 1120, 28, -1210, 176, "neutral"},
		{"alderaan_security_force", 1150, 28, -1260, 178, "neutral"},
		{"alderaan_security_force", 1137, 28, -1308, 180, "neutral"},
		{"alderaan_security_force", 1158, 28, -1470, 0, "neutral"},
		{"alderaan_security_force", 1090, 28, -1460, 112, "neutral"},
		{"alderaan_security_force", 1030, 28, -1422, 88, "neutral"},
		{"alderaan_security_force", 965, 28, -1438, 91, "neutral"},
		{"alderaan_security_force", 900, 28, -1458, 90, "neutral"},
		{"alderaan_security_force", 1228, 28, -1442, -68, "neutral"},
		{"alderaan_security_force", 1270, 28, -1470, -67, "neutral"},
		{"alderaan_security_force", 1340, 28, -1507, -71, "neutral"},
		{"alderaan_security_force", 1044, 28, -1255, 43, "neutral"},
		{"alderaan_security_force", 1302, 28, -1390, -90, "neutral"},
		{"stormtrooper", 1108, 28, -1270, 178, "neutral"},
		{"stormtrooper", 1195, 28, -1445, -65, "neutral"},
		{"stormtrooper", 930, 28, -1448, 90, "neutral"}
	}

	-- The surrounding filler structures exist only in the client snapshot. Core3 cannot
	-- collision-test their footprints, so do not use the inferred district coordinates
	-- above as spawn points. Until the client snapshot is decoded into verified lanes,
	-- every active city spawn is anchored to one of the explicit pedestrian routes.
	local areas = {}

	for i = 1, #areas, 1 do
		local area = areas[i]

		for j = 1, #area, 1 do
			local npc = area[j]
			self:spawnCityMobile(npc[1], npc[2], npc[3], npc[4], npc[5], npc[6])
		end
	end

	self:spawnPatrols(pedestrianRoutes)
end
