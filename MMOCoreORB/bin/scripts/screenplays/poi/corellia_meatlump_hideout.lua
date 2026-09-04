-- Meatlump hideout on corellia: a persistent shared walk-in hub, not a dungeon instance.
-- Buildings and cells come from snapshot/corellia.ws. Ladders, grills and in-cell props
-- are spawned here because a warm clientobjects DB never re-walks persisted building children
-- (ZoneServerImplementation.cpp returns before the child loop). Persistence level 0, no DB write.
-- Pattern: chandrila_chandriltech_facility.lua / corellia_coronet.lua (zone-enabled only).

MeatlumpHideoutScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MeatlumpHideoutScreenPlay",
	planet = "corellia",

	-- snapshot/corellia.ws (mtg_patch_023)
	ENTRANCE_ID = 602454237, -- meatlump_hideout_entrance @ -516.66, 28.00, -4448.90
	MAIN_ID     = 602454250, -- meatlump_hideout_main      @ -516.66, -10.00, -4448.90

	-- 27 SOE strSpawns names from corellia_4_2.tab hideout interior (pack said 28; the tab has 27).
	npcMap = {
		["mtp_hideout_food_supplies_tech"] = "dressed_meatlump_hideout_food_supply_tech", -- exact dressed match (supply vs supplies)
		["mtp_hideout_weapon_supply_tech"] = "dressed_meatlump_hideout_weapon_supply_tech", -- exact dressed match
		["mtp_hideout_map_tech"] = "dressed_meatlump_hideout_map_tech", -- exact dressed match
		["mtp_hideout_bomb_tech"] = "dressed_meatlump_hideout_bomb_tech", -- exact dressed match
		["mtp_hideout_safe_tech"] = "dressed_meatlump_hideout_safe_tech", -- exact dressed match
		["mtp_hideout_quest_meatlump_captain_coptszt"] = "dressed_meatlump_captain_coptszt", -- exact dressed match
		["mtp_meatlump_king"] = "meatlump_king_static", -- the NPC, not the boss meatlump_king
		["mtp_meatlump_vendor"] = "meatlump_m_01_nonvendor_vendor", -- scenery only; no vendor stock this round
		["mtp_hideout_chef_01"] = "dressed_meatlump_male_chef_02", -- only male chef template in the fork
		["mtp_hideout_chef_02"] = "dressed_meatlump_female_chef_02", -- female pair
		["mtp_kissing_meatlump_male"] = "dressed_meatlump_hideout_male_01", -- no kissing-booth template; nearest hideout male
		["mtp_kissing_meatlump_female"] = "dressed_meatlump_hideout_female_01", -- nearest hideout female
		["mtp_hideout_complaint_dept_01"] = "dressed_meatlump_hideout_male_02", -- no complaint-dept template; next hideout male
		["mtp_hideout_complaint_dept_02"] = "dressed_meatlump_hideout_male_03", -- pair, distinct from 01
		["mtp_hideout_col_eavesdrop_npc_01"] = "dressed_meatlump_hideout_male_04", -- collection NPC as scenery; grants nothing
		["mtp_hideout_col_recon_npc_01"] = "dressed_meatlump_hideout_male_05", -- collection NPC as scenery; grants nothing
		["mtp_hideout_col_doll_npc_01"] = "dressed_meatlump_hideout_female_02", -- doll collector; female hideout dressed
		["mtp_hideout_col_recruit_01"] = "dressed_meatlump_hideout_male_06", -- collection NPC as scenery; grants nothing
		["mtp_hideout_angry_meatlump_giver"] = "dressed_meatlump_hideout_male_07", -- quest giver later; scenery now
		["mtp_hideout_some_droids_giver"] = "dressed_meatlump_hideout_male_08", -- quest giver later; scenery now
		["mtp_hideout_all_droids_giver"] = "dressed_meatlump_hideout_male_09", -- quest giver later; scenery now
		["mtp_hideout_trapped_meatlump_giver"] = "dressed_meatlump_hideout_female_03", -- quest giver later; scenery now
		["mtp_hideout_meatlump_supplies_giver"] = "dressed_meatlump_hideout_female_04", -- quest giver later; scenery now
		["meatlump_hideout_thug"] = "meatlump_stooge", -- no hideout_thug template; stock Pre-CU meatlump, ATTACKABLE
		["meatlump_hideout_leader"] = "meatlump_loon", -- next rank in the stock meatlump chain (lvl 10 vs stooge 7), ATTACKABLE
		["meatlump_kreetle"] = "kreetle", -- stock kreetle; no meatlump_kreetle template. AGGRESSIVE as SOE rodents
		["meatlump_worrt"] = "worrt", -- fork meatlump_worrt is townsperson/NONE; stock worrt is ATTACKABLE as SOE rodents
	},
}

registerScreenPlay("MeatlumpHideoutScreenPlay", true)

function MeatlumpHideoutScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self.propsPresent = 0
		self.propsSpawned = 0
		self:spawnLadders()
		self:spawnProps()
		self:spawnMobiles()
		print("[meatlump] hideout props: present=" .. self.propsPresent .. " spawned=" .. self.propsSpawned)
	end
end

function MeatlumpHideoutScreenPlay:cellId(buildingId, cellName)
	local pBuilding = getSceneObject(buildingId)
	if (pBuilding == nil) then return nil end
	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)
	if (pCell == nil) then return nil end
	return SceneObject(pCell):getObjectID()
end

function MeatlumpHideoutScreenPlay:spawnIfMissing(template, x, z, y, buildingKey, cellName, qw, qx, qy, qz)
	-- oid parameter removed: nothing else used it, and oid 0 bypassed the existence check.
	-- Scan the destination cell for this template. Fresh DB / snapshot children: skip.
	-- Warm clientobjects DB never re-walks those children, so the scan finds none and we spawn.
	local buildingId = self.ENTRANCE_ID

	if (buildingKey == "main") then
		buildingId = self.MAIN_ID
	end

	local cellID = self:cellId(buildingId, cellName)

	if (cellID == nil) then
		print("[meatlump] cell not found: " .. cellName)
		return
	end

	local pCell = getSceneObject(cellID)

	if (pCell == nil) then
		print("[meatlump] cell not found: " .. cellName)
		return
	end

	for i = 0, SceneObject(pCell):getContainerObjectsSize() - 1, 1 do
		local pObj = SceneObject(pCell):getContainerObject(i)

		if (pObj ~= nil and SceneObject(pObj):getTemplateObjectPath() == template) then
			self.propsPresent = self.propsPresent + 1
			return
		end
	end

	spawnSceneObject(self.planet, template, x, z, y, cellID, qw, qx, qy, qz)
	self.propsSpawned = self.propsSpawned + 1
end

function MeatlumpHideoutScreenPlay:spawnLadders()
	-- corellia.ws node, parent bunker
	self:spawnIfMissing("object/tangible/meatlump/hideout/mtp_hideout_ladder_enter.iff", 1.38, -20.256, 32.21, "entrance", "bunker", 0, 0.70711, -0.70711, 0)
	-- corellia.ws node, parent rightguardroom
	self:spawnIfMissing("object/tangible/meatlump/hideout/mtp_hideout_ladder_exit.iff", -60.439, -33.402, 109.901, "main", "rightguardroom", 1, 0, 0, 0)
end

function MeatlumpHideoutScreenPlay:spawnProps()
	-- Two grills. corellia.ws nodes, parent deathroom.
	-- corellia_4_2.tab grill rows; coordinates match the .ws to 2 decimals.
	self:spawnIfMissing("object/tangible/meatlump/hideout/meatlump_hotdog_grill_01.iff", 22.090, -59.782, 149.079, "main", "deathroom", 0.71091, 0, -0.70328, 0)
	self:spawnIfMissing("object/tangible/meatlump/hideout/meatlump_hotdog_grill_02.iff", 22.183, -59.806, 153.063, "main", "deathroom", 0.70739, 0, -0.70683, 0)

	-- 10 in-cell map_location. Pack §1.8 counted 10; snapshot agrees.
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", 7.662, -20.750, 34.431, "entrance", "bunker", 0.71091, 0, 0, -0.70328) -- ws entrance/bunker
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", 82.642, -36.000, 118.255, "main", "leftguardroom", 0.75836, 0, 0, -0.65183) -- ws leftguardroom
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", 40.573, -35.981, 73.409, "main", "guards01", -0.67550, 0.23259, -0.22781, 0.66159) -- ws guards01
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", 45.473, -35.985, 125.574, "main", "storage", -0.70607, 0.04318, -0.04315, 0.70551) -- ws storage
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", -7.820, -35.991, 151.889, "main", "guardpost01", 0.70946, 0.14843, -0.12077, -0.67827) -- ws guardpost01
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", -72.502, -35.975, 104.388, "main", "rightguardroom", 0.72150, -0.06947, 0.06603, -0.68575) -- ws rightguardroom
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", -55.240, -35.970, 80.598, "main", "kitchen", -0.62156, 0.36613, -0.35149, 0.59671) -- ws kitchen
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", -91.409, -35.956, 220.720, "main", "elevatorroom01", -0.64789, -0.27501, 0.27756, 0.65388) -- ws elevatorroom01
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", -5.270, -36.000, 260.405, "main", "quarters02", -0.30804, -0.63133, 0.64460, 0.30170) -- ws quarters02
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_hideout_map_location.iff", 64.400, -36.000, 180.627, "main", "masterroom", 0.02557, -0.69927, 0.71396, -0.02504) -- ws masterroom

	-- Puzzle palettes. Pack §1.8 said 5; snapshot/corellia.ws has 10 (_01_11 and _01_12 of each type). Followed the .ws.
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_weapon_palette_01_11.iff", 42.973, -36.000, 133.226, "main", "storage", 0.02920, 0, 0.99957, 0) -- ws storage
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_food_palette_01_11.iff", -46.125, -36.000, 83.332, "main", "kitchen", 1, 0, 0, 0) -- ws kitchen
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_safe_01_11.iff", -79.911, -36.000, 159.775, "main", "greathall", 0.64483, 0, 0.76433, 0) -- ws greathall
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_container_01_11.iff", -83.671, -36.000, 185.470, "main", "greathall", 0.54030, 0, 0.84147, 0) -- ws greathall
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_map_01_11.iff", -43.160, -35.991, 235.665, "main", "quarters01", -0.42785, -0.56165, 0.56775, 0.42326) -- ws quarters01
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_safe_01_12.iff", -8.035, -36.000, 256.012, "main", "quarters02", -0.68587, 0, 0.72773, 0) -- ws quarters02
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_container_01_12.iff", -19.894, -36.000, 182.433, "main", "quarters03", 0.74517, 0, 0.66687, 0) -- ws quarters03
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_map_01_12.iff", 80.258, -36.000, 216.843, "main", "premasterroom", -0.26014, -0.64882, 0.66912, 0.25225) -- ws premasterroom
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_weapon_palette_01_12.iff", 66.197, -36.000, 159.255, "main", "masterroom", 1, 0, 0, 0) -- ws masterroom
	self:spawnIfMissing("object/tangible/meatlump/event/meatlump_food_palette_01_12.iff", 78.587, -36.000, 159.922, "main", "masterroom", 1, 0, 0, 0) -- ws masterroom

	-- D5: instance enter as a prop, no menu component. Not in corellia.ws.
	-- corellia_4_2.tab L248 template object/tangible/meatlump/hideout/mtp_hideout_instance_enter.iff is unregistered in this fork.
	-- Spawned the registered analogue mtp_hideout_instance_entryb_controller.iff at the tab coordinates.
	self:spawnIfMissing("object/tangible/meatlump/hideout/mtp_hideout_instance_entryb_controller.iff", 48.7528, -59.5329, 162.362, "main", "deathroom", 0.707132, 0, 0, -0.707081)
end

function MeatlumpHideoutScreenPlay:spawnMobiles()
	-- Each row is one corellia_4_2.tab area_spawner. count = intSpawnCount. heading from the row quaternion.
	local spawns = {
		-- cell 1 leftguardroom
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 94.7585, z = -36.0000, y = 112.4040, heading = 265.8, building = "main", cell = "leftguardroom" }, -- tab L51
		{ soe = "mtp_hideout_food_supplies_tech", count = 1, respawn = 0, x = 82.6597, z = -36.0000, y = 105.5800, heading = 15.8, building = "main", cell = "leftguardroom" }, -- tab L52
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 78.9148, z = -36.0000, y = 111.4840, heading = 269.1, building = "main", cell = "leftguardroom" }, -- tab L53
		-- cell 3 armory
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 84.5704, z = -36.0000, y = 61.1128, heading = 353.2, building = "main", cell = "armory" }, -- tab L56
		-- cell 4 guards01
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 50.0047, z = -36.0000, y = 78.3277, heading = 92.0, building = "main", cell = "guards01" }, -- tab L58
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 32.0812, z = -36.0000, y = 80.5166, heading = 135.8, building = "main", cell = "guards01" }, -- tab L60
		-- cell 6 storage
		{ soe = "mtp_hideout_weapon_supply_tech", count = 1, respawn = 0, x = 41.8921, z = -36.0000, y = 129.8620, heading = 162.4, building = "main", cell = "storage" }, -- tab L65
		-- cell 8 guardpost01
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -12.6277, z = -36.0000, y = 158.2490, heading = 196.6, building = "main", cell = "guardpost01" }, -- tab L70
		-- cell 10 rightguardroom
		{ soe = "meatlump_kreetle", count = 4, respawn = 300, x = -50.6274, z = -36.0000, y = 107.4870, heading = 276.6, building = "main", cell = "rightguardroom" }, -- tab L73
		{ soe = "meatlump_worrt", count = 4, respawn = 300, x = -73.5106, z = -36.0000, y = 111.1900, heading = 336.6, building = "main", cell = "rightguardroom" }, -- tab L74
		{ soe = "mtp_hideout_angry_meatlump_giver", count = 1, respawn = 0, x = -56.7225, z = -36.0000, y = 118.2070, heading = 180.7, building = "main", cell = "rightguardroom" }, -- tab L75
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -66.2813, z = -36.0000, y = 113.3290, heading = 123.2, building = "main", cell = "rightguardroom" }, -- tab L78
		{ soe = "mtp_hideout_col_eavesdrop_npc_01", count = 1, respawn = 0, x = -46.2193, z = -36.0000, y = 114.7580, heading = 326.4, building = "main", cell = "rightguardroom" }, -- tab L79
		-- cell 11 kitchen
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -70.7155, z = -36.0000, y = 77.9316, heading = 63.6, building = "main", cell = "kitchen" }, -- tab L82
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -50.8253, z = -36.0000, y = 75.7646, heading = 62.1, building = "main", cell = "kitchen" }, -- tab L83
		{ soe = "mtp_hideout_quest_meatlump_captain_coptszt", count = 1, respawn = 0, x = -56.3255, z = -36.0000, y = 70.3276, heading = 328.6, building = "main", cell = "kitchen" }, -- tab L85
		{ soe = "meatlump_hideout_leader", count = 1, respawn = 300, x = -60.9553, z = -36.0000, y = 82.5269, heading = 236.8, building = "main", cell = "kitchen" }, -- tab L86
		-- cell 12 greathall
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -85.5155, z = -36.0000, y = 178.2480, heading = 65.8, building = "main", cell = "greathall" }, -- tab L88
		{ soe = "meatlump_kreetle", count = 6, respawn = 300, x = -117.4900, z = -36.0000, y = 174.0810, heading = 277.8, building = "main", cell = "greathall" }, -- tab L89
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -81.1610, z = -36.0000, y = 166.3500, heading = 268.2, building = "main", cell = "greathall" }, -- tab L90
		{ soe = "mtp_hideout_col_recon_npc_01", count = 1, respawn = 0, x = -92.6865, z = -36.0000, y = 165.0790, heading = 18.4, building = "main", cell = "greathall" }, -- tab L91
		{ soe = "mtp_meatlump_vendor", count = 1, respawn = 0, x = -31.4106, z = -36.0000, y = 154.2120, heading = 269.1, building = "main", cell = "greathall" }, -- tab L92
		{ soe = "meatlump_kreetle", count = 6, respawn = 300, x = -44.0087, z = -36.0000, y = 207.8280, heading = 356.3, building = "main", cell = "greathall" }, -- tab L93
		{ soe = "meatlump_worrt", count = 6, respawn = 300, x = -110.1120, z = -36.0000, y = 209.8660, heading = 309.8, building = "main", cell = "greathall" }, -- tab L94
		{ soe = "meatlump_worrt", count = 6, respawn = 300, x = -66.0059, z = -36.0000, y = 210.6170, heading = 79.6, building = "main", cell = "greathall" }, -- tab L97
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -115.1660, z = -36.0000, y = 195.9040, heading = 131.7, building = "main", cell = "greathall" }, -- tab L99
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -81.0372, z = -36.0000, y = 195.5850, heading = 59.5, building = "main", cell = "greathall" }, -- tab L102
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -105.2380, z = -36.0000, y = 175.0850, heading = 51.0, building = "main", cell = "greathall" }, -- tab L103
		{ soe = "meatlump_kreetle", count = 6, respawn = 300, x = -117.0890, z = -36.0000, y = 197.1450, heading = 0.5, building = "main", cell = "greathall" }, -- tab L104
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -96.6436, z = -36.0000, y = 199.1840, heading = 302.6, building = "main", cell = "greathall" }, -- tab L105
		{ soe = "mtp_hideout_col_doll_npc_01", count = 1, respawn = 0, x = -93.0947, z = -36.0000, y = 184.6160, heading = 191.0, building = "main", cell = "greathall" }, -- tab L106
		{ soe = "meatlump_worrt", count = 4, respawn = 300, x = -96.4569, z = -36.0000, y = 176.4460, heading = 309.1, building = "main", cell = "greathall" }, -- tab L108
		-- cell 13 elevatorroom01
		{ soe = "mtp_hideout_col_recruit_01", count = 1, respawn = 0, x = -90.1883, z = -36.0000, y = 231.0990, heading = 146.6, building = "main", cell = "elevatorroom01" }, -- tab L111
		{ soe = "meatlump_kreetle", count = 4, respawn = 300, x = -84.3571, z = -36.0000, y = 224.2820, heading = 47.8, building = "main", cell = "elevatorroom01" }, -- tab L112
		-- cell 15 quarters01
		{ soe = "meatlump_hideout_leader", count = 1, respawn = 300, x = -17.7487, z = -36.0000, y = 237.4610, heading = 256.1, building = "main", cell = "quarters01" }, -- tab L117
		-- cell 16 quarters02
		{ soe = "mtp_hideout_map_tech", count = 1, respawn = 0, x = -5.2936, z = -36.0000, y = 247.4560, heading = 106.2, building = "main", cell = "quarters02" }, -- tab L119
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -0.1153, z = -36.0000, y = 236.5160, heading = 191.9, building = "main", cell = "quarters02" }, -- tab L122
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 0.3715, z = -36.0000, y = 257.0010, heading = 223.7, building = "main", cell = "quarters02" }, -- tab L123
		-- cell 17 quarters03
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -12.8335, z = -36.0000, y = 210.1630, heading = 351.7, building = "main", cell = "quarters03" }, -- tab L126
		-- cell 21 guardpost02
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 46.7325, z = -36.0000, y = 176.4870, heading = 29.1, building = "main", cell = "guardpost02" }, -- tab L132
		-- cell 23 premasterroom
		{ soe = "mtp_hideout_bomb_tech", count = 1, respawn = 0, x = 83.4198, z = -36.0000, y = 226.8820, heading = 158.0, building = "main", cell = "premasterroom" }, -- tab L136
		-- cell 25 masterroom
		{ soe = "mtp_hideout_safe_tech", count = 1, respawn = 0, x = 71.4780, z = -36.0000, y = 177.7760, heading = 85.8, building = "main", cell = "masterroom" }, -- tab L151
		-- cell 38 arena
		{ soe = "mtp_hideout_complaint_dept_01", count = 1, respawn = 0, x = -74.9460, z = -60.0000, y = 180.6690, heading = 135.8, building = "main", cell = "arena" }, -- tab L177
		{ soe = "mtp_hideout_some_droids_giver", count = 1, respawn = 0, x = -24.8523, z = -60.0000, y = 121.3920, heading = 331.9, building = "main", cell = "arena" }, -- tab L181
		{ soe = "mtp_kissing_meatlump_female", count = 1, respawn = 0, x = -50.3629, z = -60.0000, y = 181.5850, heading = 185.5, building = "main", cell = "arena" }, -- tab L182
		{ soe = "meatlump_worrt", count = 6, respawn = 300, x = -41.8447, z = -60.0000, y = 177.0430, heading = 20.7, building = "main", cell = "arena" }, -- tab L183
		{ soe = "meatlump_hideout_leader", count = 2, respawn = 300, x = -26.6965, z = -60.0000, y = 151.3860, heading = 347.9, building = "main", cell = "arena" }, -- tab L187
		{ soe = "meatlump_hideout_leader", count = 1, respawn = 300, x = -31.7153, z = -59.5000, y = 159.8570, heading = 179.2, building = "main", cell = "arena" }, -- tab L189
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -24.8723, z = -60.0000, y = 138.8260, heading = 344.7, building = "main", cell = "arena" }, -- tab L194
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -13.8201, z = -60.0000, y = 153.0470, heading = 327.3, building = "main", cell = "arena" }, -- tab L195
		{ soe = "mtp_hideout_trapped_meatlump_giver", count = 1, respawn = 0, x = -18.8706, z = -60.0000, y = 171.4250, heading = 95.9, building = "main", cell = "arena" }, -- tab L200
		{ soe = "mtp_hideout_all_droids_giver", count = 1, respawn = 0, x = 5.7629, z = -60.0000, y = 181.8870, heading = 173.7, building = "main", cell = "arena" }, -- tab L201
		{ soe = "meatlump_hideout_leader", count = 2, respawn = 300, x = -37.3124, z = -60.0000, y = 153.9420, heading = 35.6, building = "main", cell = "arena" }, -- tab L204
		{ soe = "meatlump_kreetle", count = 8, respawn = 300, x = 14.4669, z = -60.0000, y = 178.4870, heading = 147.5, building = "main", cell = "arena" }, -- tab L208
		{ soe = "meatlump_hideout_leader", count = 2, respawn = 300, x = -15.6097, z = -60.0000, y = 161.5130, heading = 250.3, building = "main", cell = "arena" }, -- tab L209
		{ soe = "meatlump_kreetle", count = 4, respawn = 300, x = -67.5594, z = -60.0000, y = 178.4510, heading = 351.9, building = "main", cell = "arena" }, -- tab L214
		{ soe = "meatlump_worrt", count = 5, respawn = 300, x = -68.9617, z = -60.0000, y = 124.5560, heading = 225.2, building = "main", cell = "arena" }, -- tab L220
		{ soe = "meatlump_kreetle", count = 8, respawn = 300, x = -28.6501, z = -60.0000, y = 144.1930, heading = 72.9, building = "main", cell = "arena" }, -- tab L221
		{ soe = "meatlump_hideout_leader", count = 1, respawn = 300, x = -25.0031, z = -60.0000, y = 159.8570, heading = 180.3, building = "main", cell = "arena" }, -- tab L222
		{ soe = "mtp_hideout_meatlump_supplies_giver", count = 1, respawn = 0, x = -57.8073, z = -60.0000, y = 126.8520, heading = 26.2, building = "main", cell = "arena" }, -- tab L224
		{ soe = "mtp_kissing_meatlump_male", count = 1, respawn = 0, x = -54.3282, z = -60.0000, y = 181.5850, heading = 179.9, building = "main", cell = "arena" }, -- tab L227
		{ soe = "mtp_meatlump_king", count = 1, respawn = 0, x = -28.4580, z = -60.0000, y = 160.9850, heading = 180.5, building = "main", cell = "arena" }, -- tab L228
		{ soe = "meatlump_kreetle", count = 4, respawn = 300, x = -13.3544, z = -60.0000, y = 177.0910, heading = 328.0, building = "main", cell = "arena" }, -- tab L230
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -40.9812, z = -60.0000, y = 144.6970, heading = 38.2, building = "main", cell = "arena" }, -- tab L231
		{ soe = "meatlump_kreetle", count = 4, respawn = 300, x = -72.4384, z = -60.0000, y = 146.2790, heading = 262.8, building = "main", cell = "arena" }, -- tab L232
		{ soe = "meatlump_worrt", count = 6, respawn = 300, x = 14.8004, z = -60.0000, y = 151.0680, heading = 341.6, building = "main", cell = "arena" }, -- tab L233
		{ soe = "mtp_hideout_complaint_dept_02", count = 1, respawn = 0, x = -75.1920, z = -60.0000, y = 179.3220, heading = 164.8, building = "main", cell = "arena" }, -- tab L236
		-- cell 39 deathroom
		{ soe = "meatlump_kreetle", count = 4, respawn = 300, x = 26.8560, z = -60.0000, y = 151.0790, heading = 79.4, building = "main", cell = "deathroom" }, -- tab L242
		{ soe = "meatlump_worrt", count = 6, respawn = 300, x = 49.5072, z = -60.0000, y = 151.0390, heading = 149.7, building = "main", cell = "deathroom" }, -- tab L243
		{ soe = "mtp_hideout_chef_01", count = 1, respawn = 0, x = 31.4075, z = -60.0000, y = 149.4620, heading = 96.3, building = "main", cell = "deathroom" }, -- tab L244
		{ soe = "mtp_hideout_chef_02", count = 1, respawn = 0, x = 23.4968, z = -60.0000, y = 153.7780, heading = 304.2, building = "main", cell = "deathroom" }, -- tab L246
		-- cell 41 jailcells
		{ soe = "meatlump_kreetle", count = 8, respawn = 300, x = 45.4865, z = -58.0000, y = 83.2344, heading = 1.9, building = "main", cell = "jailcells" }, -- tab L252
		{ soe = "meatlump_worrt", count = 6, respawn = 300, x = 41.2090, z = -60.0000, y = 116.9880, heading = 120.7, building = "main", cell = "jailcells" }, -- tab L253
		{ soe = "meatlump_worrt", count = 6, respawn = 300, x = 45.4377, z = -58.0000, y = 98.5103, heading = 184.6, building = "main", cell = "jailcells" }, -- tab L254
		-- cell 45 grandentrance
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = -6.8463, z = -28.0000, y = 129.2130, heading = 101.1, building = "main", cell = "grandentrance" }, -- tab L259
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 34.9622, z = -28.0000, y = 102.0060, heading = 186.0, building = "main", cell = "grandentrance" }, -- tab L260
		{ soe = "meatlump_hideout_thug", count = 2, respawn = 300, x = 2.9168, z = -28.0000, y = 79.1602, heading = 95.8, building = "main", cell = "grandentrance" }, -- tab L261
	}

	for i = 1, #spawns, 1 do
		local s = spawns[i]
		local template = self.npcMap[s.soe]

		if (template ~= nil) then
			local buildingId = self.ENTRANCE_ID

			if (s.building == "main") then
				buildingId = self.MAIN_ID
			end

			local cellID = self:cellId(buildingId, s.cell)

			if (cellID == nil) then
				print("[meatlump] cell not found: " .. s.cell)
			else
				for n = 1, s.count, 1 do
					spawnMobile(self.planet, template, s.respawn, s.x, s.z, s.y, s.heading, cellID)
				end
			end
		end
	end
end

