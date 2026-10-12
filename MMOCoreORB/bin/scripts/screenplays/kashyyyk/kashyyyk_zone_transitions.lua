-- Gate rows: retail datatables/buildout/<zone>/<zone>.tab.
-- Surface buildout coordinates are local coordinates plus 2048 (main: 4096).
-- Rryatt uses the same first layout as KashyyykRryattNpcs: x-3908, y+3365.
KashyyykZoneTransitions = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykZoneTransitions",
	gateTemplate = "object/tangible/door/thm_kash_zonegate_door_simple.iff",
	gateRange = 6,

	gates = {
		{line = "kachirho_deadforest", zone = "kashyyyk_main", x = -743.39, z = 18.646, y = 258.36, ow = -0.37166, oy = 0.928369},
		{line = "kachirho_huntinggrounds", zone = "kashyyyk_main", x = 185.96, z = 20.4075, y = -431.25, ow = 0.77657, oy = 0.630031},
		{line = "kachirho_rryatt", zone = "kashyyyk_main", x = -58.63, z = 21.5704, y = 843.85, ow = -0.150225, oy = 0.988652},
		{line = "deadforest_kachirho", zone = "kashyyyk_dead_forest", x = 87.68, z = 29.3555, y = -477.38, ow = 0.995953, oy = -0.0898784, snapshotID = 14913591},
		{line = "huntinggrounds_kachirho", zone = "kashyyyk_hunting", x = 670.77, z = 10.4887, y = 676.16, ow = -0.540302, oy = 0.841471, snapshotID = 12118091},
		{line = "rryatt_kachirho", zone = "kashyyyk_rryatt_trail", x = -3837.6797, z = 173.457, y = 3613.17, ow = 0.702713, oy = 0.711473},
		-- Three elevator doors at each landing, already present in kashyyyk_main.ws.
		{key = "tree_ground_first", line = "kachirho_tree_first_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level1_main.iff", snapshotID = 14602795, x = -478.73, z = 29.8601, y = -12.33, ow = 0.346843, oy = 0.937923},
		{key = "tree_ground_second", line = "kachirho_tree_second_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level2_main.iff", snapshotID = 14602796, x = -472.64, z = 29.8355, y = -9.26, ow = -0.209239, oy = 0.977865},
		{key = "tree_ground_third", line = "kachirho_tree_third_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level3_main.iff", snapshotID = 14602797, x = -470.35, z = 29.8791, y = -15.88, ow = -0.700285, oy = 0.713864},
		{key = "tree_first_second", line = "kachirho_tree_second_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level2.iff", snapshotID = 14602494, x = -459.48, z = 157.163, y = -78.55, ow = 0.930507, oy = -0.366273},
		{key = "tree_first_ground", line = "kachirho_tree_ground_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level_ground.iff", snapshotID = 14602495, x = -463.57, z = 157.164, y = -79.81, ow = 0.995953, oy = 0.0898785},
		{key = "tree_first_third", line = "kachirho_tree_third_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level3.iff", snapshotID = 14602496, x = -466.99, z = 157.155, y = -77.12, ow = 0.865324, oy = 0.501213},
		{key = "tree_second_first", line = "kachirho_tree_first_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level1.iff", snapshotID = 14602497, x = -458.66, z = 179.442, y = -85.63, ow = -0.536088, oy = 0.844161},
		{key = "tree_second_ground", line = "kachirho_tree_ground_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level_ground.iff", snapshotID = 14602498, x = -458.54, z = 179.456, y = -89.83, ow = 0.844588, oy = -0.535416},
		{key = "tree_second_third", line = "kachirho_tree_third_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level3.iff", snapshotID = 14602499, x = -461.88, z = 179.457, y = -92.46, ow = 0.993956, oy = -0.109778},
		{key = "tree_third_first", line = "kachirho_tree_first_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level1.iff", snapshotID = 14602500, x = -450.90, z = 210.857, y = -91.51, ow = 0.802096, oy = -0.597195},
		{key = "tree_third_ground", line = "kachirho_tree_ground_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level_ground.iff", snapshotID = 14602501, x = -453.85, z = 210.878, y = -94.50, ow = 0.986418, oy = -0.164252},
		{key = "tree_third_second", line = "kachirho_tree_second_level", zone = "kashyyyk_main", template = "object/building/kashyyyk/mun_kash_tree_door_level2.iff", snapshotID = 14602502, x = -458.11, z = 210.836, y = -93.96, ow = 0.955336, oy = 0.295521}
	},

	-- Retail datatables/travel/zone_transition.tab. Rryatt's arrival is the
	-- public controller row (131.885,168.235,250.53) plus (-41.2,3.5,-3.2).
	destinations = {
		kachirho_deadforest = {zone = "kashyyyk_dead_forest", x = 84, z = 26, y = -460},
		kachirho_huntinggrounds = {zone = "kashyyyk_hunting", x = 658, z = 8, y = 666, requiresLicence = true},
		kachirho_rryatt = {zone = "kashyyyk_rryatt_trail", x = -3817.315, z = 171.735, y = 3612.33},
		deadforest_kachirho = {zone = "kashyyyk_main", x = -756, z = 18, y = 245},
		huntinggrounds_kachirho = {zone = "kashyyyk_main", x = 203, z = 18, y = -425},
		rryatt_kachirho = {zone = "kashyyyk_main", x = -63, z = 19, y = 827},
		kachirho_tree_ground_level = {zone = "kashyyyk_main", x = -479, z = 29, y = -24},
		kachirho_tree_first_level = {zone = "kashyyyk_main", x = -461, z = 157, y = -71},
		kachirho_tree_second_level = {zone = "kashyyyk_main", x = -466, z = 179, y = -86},
		kachirho_tree_third_level = {zone = "kashyyyk_main", x = -457, z = 210, y = -84}
	}
}

registerScreenPlay("KashyyykZoneTransitions", true)

function KashyyykZoneTransitions:start()
	for i = 1, #self.gates do
		local gate = self.gates[i]
		if (isZoneEnabled(gate.zone)) then
			self:setupGate(gate)
		end
	end
end

function KashyyykZoneTransitions:matchesGate(pGate, gate)
	return pGate ~= nil and SceneObject(pGate):getZoneName() == gate.zone
		and SceneObject(pGate):getParentID() == 0
		and SceneObject(pGate):getTemplateObjectPath() == (gate.template or self.gateTemplate)
end

function KashyyykZoneTransitions:setupGate(gate)
	local key = "KashyyykZoneTransitions:gate:" .. (gate.key or gate.line)
	local pGate = getSceneObject(readData(key))
	if (not self:matchesGate(pGate, gate) and gate.snapshotID ~= nil) then
		pGate = getSceneObject(gate.snapshotID)
	end
	if (not self:matchesGate(pGate, gate)) then
		pGate = spawnSceneObject(gate.zone, gate.template or self.gateTemplate, gate.x, gate.z, gate.y, 0, gate.ow, 0, gate.oy, 0)
	end
	if (pGate == nil) then
		print("KashyyykZoneTransitions: failed to spawn " .. gate.line)
		return
	end

	SceneObject(pGate):setObjectName("travel/zone_transition", gate.line, true)
	SceneObject(pGate):setObjectMenuComponent("KashyyykZoneGateMenuComponent")
	writeData(key, SceneObject(pGate):getObjectID())
	writeStringData("KashyyykZoneTransitions:line:" .. SceneObject(pGate):getObjectID(), gate.key or gate.line)
end

function KashyyykZoneTransitions:getGate(pGate)
	if (pGate == nil) then
		return nil
	end
	local key = readStringData("KashyyykZoneTransitions:line:" .. SceneObject(pGate):getObjectID())
	for i = 1, #self.gates do
		if ((self.gates[i].key or self.gates[i].line) == key and self:matchesGate(pGate, self.gates[i])) then
			return self.gates[i]
		end
	end
	return nil
end

function KashyyykZoneTransitions:useGate(pGate, pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local gate = self:getGate(pGate)
	if (gate == nil or SceneObject(pPlayer):getZoneName() ~= gate.zone
		or SceneObject(pPlayer):getParentID() ~= 0
		or SceneObject(pPlayer):getDistanceTo(pGate) > self.gateRange) then
		return
	end
	local destination = self.destinations[gate.line]
	if (not isZoneEnabled(destination.zone)) then
		CreatureObject(pPlayer):sendSystemMessage("That destination is currently unavailable.")
		return
	end
	if (destination.requiresLicence == true) then
		local pGhost = CreatureObject(pPlayer):getPlayerObject()
		local godMode = pGhost ~= nil and PlayerObject(pGhost):hasGodMode()
		local privileged = pGhost ~= nil and PlayerObject(pGhost):isPrivileged()
		if (not godMode and not privileged and (huntKerssocEnterEtyyyScreenPlay == nil
			or not (huntKerssocEnterEtyyyScreenPlay:isQuestActive(pPlayer)
			or huntKerssocEnterEtyyyScreenPlay:hasCompletedQuest(pPlayer)))) then
			CreatureObject(pPlayer):sendSystemMessage("@travel/zone_transition:kerssoc_hunting_licence")
			return
		end
	end
	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end
	if (destination.zone == gate.zone) then
		SceneObject(pPlayer):teleport(destination.x, destination.z, destination.y, 0)
	else
		SceneObject(pPlayer):switchZone(destination.zone, destination.x, destination.z, destination.y, 0)
	end
end

KashyyykZoneGateMenuComponent = {}

function KashyyykZoneGateMenuComponent:fillObjectMenuResponse(pGate, pMenuResponse, pPlayer)
	local gate = KashyyykZoneTransitions:getGate(pGate)
	if (gate == nil or pPlayer == nil) then
		return
	end
	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@travel/zone_transition:" .. gate.line)
end

function KashyyykZoneGateMenuComponent:handleObjectMenuSelect(pGate, pPlayer, selectedID)
	if (selectedID == 20) then
		KashyyykZoneTransitions:useGate(pGate, pPlayer)
	end
	return 0
end
