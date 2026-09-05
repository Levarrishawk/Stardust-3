--[[
	Wire hub NPCs and map objects for the Meatlump web quests.

	ruling 2026-09-04

	Walks the hideout cells (same building ids as the hub screenplay) and
	attaches conversations / the map radial. Spawns outdoor givers the hub
	does not place.
]]

MtpWebGivers = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MtpWebGivers",
	planet = "corellia",
	givers = {
		{ template = "dressed_meatlump_hideout_map_tech", convo = "mtp_hideout_map_tech_convo", building = "main", cell = "quarters02" },
		{ template = "dressed_meatlump_hideout_bomb_tech", convo = "mtp_hideout_bomb_tech_convo", building = "main", cell = "premasterroom" },
		{ template = "dressed_meatlump_hideout_food_supply_tech", convo = "mtp_hideout_food_supply_tech_convo", building = "main", cell = "leftguardroom" },
		{ template = "dressed_meatlump_hideout_weapon_supply_tech", convo = "mtp_hideout_weapon_supply_tech_convo", building = "main", cell = "storage" },
		{ template = "dressed_meatlump_hideout_safe_tech", convo = "mtp_hideout_safe_tech_convo", building = "main", cell = "masterroom" },
		{ template = "dressed_meatlump_hideout_male_05", convo = "mtp_hideout_recon_convo", building = "main", cell = "greathall" },
		{ template = "meatlump_king_static", convo = "mtp_meatlump_king_convo", building = "main", cell = "arena" },
		{ template = "meatlump_m_01_nonvendor_vendor", convo = "mtp_vendor_convo", building = "main", cell = "greathall" },
	},
	maps = {
		{ quest = "mtp_map_quest_corellia_01", building = "entrance", cell = "bunker", x = 7.662 },
		{ quest = "mtp_map_quest_dathomir_01", building = "main", cell = "leftguardroom", x = 82.642 },
		{ quest = "mtp_map_quest_naboo_03", building = "main", cell = "guards01", x = 40.573 },
		{ quest = "mtp_map_quest_naboo_02", building = "main", cell = "storage", x = 45.473 },
		{ quest = "mtp_map_quest_naboo_01", building = "main", cell = "guardpost01", x = -7.820 },
		{ quest = "mtp_map_quest_corellia_02", building = "main", cell = "rightguardroom", x = -72.502 },
		{ quest = "mtp_map_quest_tatooine_01", building = "main", cell = "kitchen", x = -55.240 },
		{ quest = "mtp_map_quest_talus_01", building = "main", cell = "elevatorroom01", x = -91.409 },
		{ quest = "mtp_map_quest_endor_01", building = "main", cell = "quarters02", x = -5.270 },
		{ quest = "mtp_map_quest_lok_01", building = "main", cell = "masterroom", x = 64.400 },
	},
	outdoors = {
		{ template = "dressed_mtp_corellian_times_contact", convo = "mtp_corellia_times_contact_convo", x = 1873.0, y = 28.0, z = 1709.0, heading = 0 },
		{ template = "corsec_sgt_hirka", convo = "mtp_corsec_intelligence_officer_convo", x = -175.0, y = 28.0, z = -4435.0, heading = 0 },
		{ template = "dressed_corellia_ragtag_ames_missd", convo = "mtp_ragtag_ames_missd_convo", x = 164.0, y = 27.0, z = -4778.0, heading = 0 },
		{ template = "dressed_meatlump_hideout_infiltrator", convo = "mtp_hideout_infiltrator_convo", x = -90.0, y = -36.0, z = 170.0, heading = 0, indoor = true, building = "main", cell = "greathall" },
		{ template = "dressed_meatlump_hideout_male_01", convo = "mtp_hideout_weapon_supply_smuggler_convo", x = -520.0, y = 28.0, z = -4440.0, heading = 0 },
	},
}

registerScreenPlay("MtpWebGivers", true)

function MtpWebGivers:start()
	if (not isZoneEnabled(self.planet)) then
		return
	end

	self:wireHub()
	self:wireMaps()
	self:spawnOutdoors()
end

function MtpWebGivers:buildingId(key)
	if (key == "entrance") then
		return MeatlumpHideoutScreenPlay.ENTRANCE_ID
	end

	return MeatlumpHideoutScreenPlay.MAIN_ID
end

function MtpWebGivers:cellPtr(buildingKey, cellName)
	local pBuilding = getSceneObject(self:buildingId(buildingKey))

	if (pBuilding == nil) then
		return nil
	end

	return BuildingObject(pBuilding):getNamedCell(cellName)
end

function MtpWebGivers:wireHub()
	for i = 1, #self.givers do
		local g = self.givers[i]
		local pCell = self:cellPtr(g.building, g.cell)

		if (pCell ~= nil) then
			for n = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
				local pObj = SceneObject(pCell):getContainerObject(n)

				if (pObj ~= nil and SceneObject(pObj):isAiAgent()) then
					if (AiAgent(pObj):getCreatureTemplateName() == g.template) then
						CreatureObject(pObj):setOptionBit(CONVERSABLE)
						CreatureObject(pObj):setOptionBit(INVULNERABLE)
						AiAgent(pObj):setConvoTemplate(g.convo)
					end
				end
			end
		end
	end
end

function MtpWebGivers:wireMaps()
	for i = 1, #self.maps do
		local m = self.maps[i]
		local pCell = self:cellPtr(m.building, m.cell)

		if (pCell ~= nil) then
			for n = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
				local pObj = SceneObject(pCell):getContainerObject(n)

				if (pObj ~= nil and SceneObject(pObj):getTemplateObjectPath() == "object/tangible/meatlump/event/meatlump_hideout_map_location.iff") then
					local dx = SceneObject(pObj):getPositionX() - m.x

					if (dx > -1.5 and dx < 1.5) then
						local oid = SceneObject(pObj):getObjectID()
						writeStringData(oid .. ":mtpMapQuest", m.quest)
						SceneObject(pObj):setObjectMenuComponent("MtpMapQuestMenuComponent")
					end
				end
			end
		end
	end
end

function MtpWebGivers:spawnOutdoors()
	for i = 1, #self.outdoors do
		local g = self.outdoors[i]
		local cellID = 0

		if (g.indoor) then
			local pCell = self:cellPtr(g.building, g.cell)

			if (pCell ~= nil) then
				cellID = SceneObject(pCell):getObjectID()
			end
		end

		local z = g.y

		if (not g.indoor) then
			local wz = getWorldFloor(g.x, g.z, self.planet)

			if (wz ~= nil and wz ~= 0) then
				z = wz
			end
		end

		local pMob = spawnMobile(self.planet, g.template, 0, g.x, z, g.z, g.heading, cellID)

		if (pMob ~= nil) then
			CreatureObject(pMob):setOptionBit(CONVERSABLE)
			CreatureObject(pMob):setOptionBit(INVULNERABLE)
			AiAgent(pMob):setConvoTemplate(g.convo)
		end
	end
end
