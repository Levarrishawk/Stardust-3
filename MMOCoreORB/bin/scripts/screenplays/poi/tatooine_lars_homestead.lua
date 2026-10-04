includeFile("poi/lars_homestead_ben_conv_handler.lua")

TatooineLarsHomesteadScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "TatooineLarsHomesteadScreenPlay",

	kenobiCaveCellID = 9995395,
	kenobiCaveOrigin = {x = 1.1, z = 1, y = -2.1},

	-- Template, x offset, height offset, y offset, heading.
	kenobiCaveFurnishings = {
		-- Sleeping corner and bedside storage.
		{"object/tangible/furniture/all/frn_all_bed_sm_s1.iff", -3, 0, 2, 0},
		{"object/tangible/furniture/cheap/end_table_s01.iff", -1.5, 0, 3, 0},
		{"object/tangible/furniture/all/frn_all_lamp_candlestick_free_s01_lit.iff", -4.2, 0, 3.5, 0},
		{"object/tangible/furniture/plain/plain_chest_s01.iff", -3, 0, -0.5, 90},

		-- Sitting area, leaving the center clear.
		{"object/tangible/furniture/modern/rug_rect_sml_s01.iff", 0.5, 0.02, 1, 0},
		{"object/tangible/furniture/cheap/chair_s01.iff", 0.5, 0, 2.6, 180},
		{"object/tangible/furniture/cheap/coffee_table_s01.iff", 0.5, 0, 0.7, 0},
		{"object/static/item/item_con_tato_cup_s2.iff", 0.2, 0.45, 0.7, 15},
		{"object/static/item/item_bowl_plain.iff", 0.8, 0.45, 0.7, 0},
		{"object/tangible/furniture/all/frn_all_lamp_candlestick_free_s01_lit.iff", 2.3, 0, 3.5, 0},

		-- Cooking supplies and a pair of well-used storage chests.
		{"object/tangible/furniture/tatooine/frn_tato_table_small_style_01.iff", 3.3, 0, -1.2, 0},
		{"object/tangible/furniture/decorative/portable_stove.iff", 3.3, 0, -3, 90},
		{"object/tangible/furniture/decorative/kitchen_utensils.iff", 3, 0.75, -1.2, 0},
		{"object/static/item/item_con_pitcher_full.iff", 3.6, 0.75, -1.2, 20},
		{"object/tangible/furniture/plain/plain_chest_s01.iff", -2.4, 0, -3.5, 0},
		{"object/tangible/furniture/cheap/chest_s01.iff", -0.9, 0, -3.5, 0},
		{"object/tangible/furniture/all/frn_all_lamp_candlestick_free_s01_lit.iff", 4.3, 0, -3.7, 0}
	},

	-- Template, x, y, heading. All spawns are outdoors.
	family = {
		{"luke_skywalker", -2582, -5511, 180},
		{"owen_lars", -2585, -5513, 90},
		{"beru_lars", -2579, -5513, -90}
	},

	droids = {
		{"r2", -2602, -5495, 90},
		{"r5", -2562, -5492, -90},
		{"eg6_power_droid", -2605, -5530, 0},
		{"cll8_binary_load_lifter", -2558, -5532, 180},
		{"r2", -2584, -5476, 180},
		{"r5", -2580, -5548, 0}
	}
}

registerScreenPlay("TatooineLarsHomesteadScreenPlay", true)

function TatooineLarsHomesteadScreenPlay:start()
	if (isZoneEnabled("tatooine")) then
		self:spawnMobiles()
		self:spawnKenobiCaveFurnishings()
	end
end

function TatooineLarsHomesteadScreenPlay:spawnKenobiCaveFurnishings()
	local pCell = getSceneObject(self.kenobiCaveCellID)

	if (pCell == nil or not SceneObject(pCell):isCellObject() or SceneObject(pCell):getZoneName() ~= "tatooine") then
		return
	end

	local origin = self.kenobiCaveOrigin

	for i = 1, #self.kenobiCaveFurnishings do
		local item = self.kenobiCaveFurnishings[i]
		spawnSceneObject("tatooine", item[1], origin.x + item[2], origin.z + item[3], origin.y + item[4], self.kenobiCaveCellID, math.rad(item[5]))
	end
end

function TatooineLarsHomesteadScreenPlay:spawnFarmMobile(mobile)
	local pMobile = spawnMobile("tatooine", mobile[1], 0, mobile[2], 0, mobile[3], mobile[4], 0)

	if (pMobile ~= nil) then
		local height = getTerrainHeight(pMobile, mobile[2], mobile[3])
		SceneObject(pMobile):teleport(mobile[2], height, mobile[3], 0)
		AiAgent(pMobile):setHomeLocation(mobile[2], height, mobile[3], 0)
	end

	return pMobile
end

function TatooineLarsHomesteadScreenPlay:spawnMobiles()
	local pBen = self:spawnFarmMobile({"obi_wan_ghost_lars_homestead", -3408, -6845, 0})

	if (pBen ~= nil) then
		AiAgent(pBen):addObjectFlag(AI_STATIC)
		CreatureObject(pBen):clearOptionBit(AIENABLED)
	end

	for i = 1, #self.family do
		local pMobile = self:spawnFarmMobile(self.family[i])

		if (pMobile ~= nil) then
			AiAgent(pMobile):addObjectFlag(AI_STATIC)
			CreatureObject(pMobile):clearOptionBit(AIENABLED)
		end
	end

	for i = 1, #self.droids do
		local pMobile = self:spawnFarmMobile(self.droids[i])

		if (pMobile ~= nil) then
			CreatureObject(pMobile):setPvpStatusBitmask(0)
			self:droidPatrol(pMobile)
		end
	end
end

function TatooineLarsHomesteadScreenPlay:droidPatrol(pMobile)
	if (pMobile == nil or CreatureObject(pMobile):isDead() or SceneObject(pMobile):getZoneName() ~= "tatooine") then
		return
	end

	if (AiAgent(pMobile):getPatrolPointsSize() == 0) then
		AiAgent(pMobile):generatePatrol(3, 12)
	end

	createEvent(30000, self.screenplayName, "droidPatrol", pMobile, "")
end

function TatooineLarsHomesteadScreenPlay:sendToAnchorhead(pPlayer, key)
	deleteData(key)

	if (pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "tatooine") then
		return
	end

	-- Allow the final conversation screen to display before moving the player.
	-- Anchorhead Shuttleport landing point from planet_manager.lua.
	SceneObject(pPlayer):teleport(47.565128, 52, -5338.9072, 0)
end
