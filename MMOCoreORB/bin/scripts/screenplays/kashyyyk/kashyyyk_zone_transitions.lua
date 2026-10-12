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
		{line = "rryatt_kachirho", zone = "kashyyyk_rryatt_trail", x = -3837.6797, z = 173.457, y = 3613.17, ow = 0.702713, oy = 0.711473}
	},

	-- Retail datatables/travel/zone_transition.tab. Rryatt's arrival is the
	-- public controller row (131.885,168.235,250.53) plus (-41.2,3.5,-3.2).
	destinations = {
		kachirho_deadforest = {zone = "kashyyyk_dead_forest", x = 84, z = 26, y = -460},
		kachirho_huntinggrounds = {zone = "kashyyyk_hunting", x = 658, z = 8, y = 666, requiresLicence = true},
		kachirho_rryatt = {zone = "kashyyyk_rryatt_trail", x = -3817.315, z = 171.735, y = 3612.33},
		deadforest_kachirho = {zone = "kashyyyk_main", x = -756, z = 18, y = 245},
		huntinggrounds_kachirho = {zone = "kashyyyk_main", x = 203, z = 18, y = -425},
		rryatt_kachirho = {zone = "kashyyyk_main", x = -63, z = 19, y = 827}
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
		and SceneObject(pGate):getTemplateObjectPath() == self.gateTemplate
end

function KashyyykZoneTransitions:setupGate(gate)
	local key = "KashyyykZoneTransitions:gate:" .. gate.line
	local pGate = getSceneObject(readData(key))
	if (not self:matchesGate(pGate, gate) and gate.snapshotID ~= nil) then
		pGate = getSceneObject(gate.snapshotID)
	end
	if (not self:matchesGate(pGate, gate)) then
		pGate = spawnSceneObject(gate.zone, self.gateTemplate, gate.x, gate.z, gate.y, 0, gate.ow, 0, gate.oy, 0)
	end
	if (pGate == nil) then
		print("KashyyykZoneTransitions: failed to spawn " .. gate.line)
		return
	end

	SceneObject(pGate):setObjectName("travel/zone_transition", gate.line, true)
	SceneObject(pGate):setObjectMenuComponent("KashyyykZoneGateMenuComponent")
	writeData(key, SceneObject(pGate):getObjectID())
	writeStringData("KashyyykZoneTransitions:line:" .. SceneObject(pGate):getObjectID(), gate.line)
end

function KashyyykZoneTransitions:getGate(pGate)
	if (pGate == nil) then
		return nil
	end
	local line = readStringData("KashyyykZoneTransitions:line:" .. SceneObject(pGate):getObjectID())
	for i = 1, #self.gates do
		if (self.gates[i].line == line and self:matchesGate(pGate, self.gates[i])) then
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
		if (not godMode and (huntKerssocEnterEtyyyScreenPlay == nil
			or not (huntKerssocEnterEtyyyScreenPlay:isQuestActive(pPlayer)
			or huntKerssocEnterEtyyyScreenPlay:hasCompletedQuest(pPlayer)))) then
			CreatureObject(pPlayer):sendSystemMessage("@travel/zone_transition:kerssoc_hunting_licence")
			return
		end
	end
	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end
	SceneObject(pPlayer):switchZone(destination.zone, destination.x, destination.z, destination.y, 0)
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
