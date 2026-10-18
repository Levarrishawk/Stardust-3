-- Public Rryatt layout (copy 0). Placements: DSRC buildout/kashyyyk_rryatt_trail/*.tab.
-- DSRC creatures.tab maps the rryatt_* spawn names to these existing mobile templates.
-- Snapshot geometry uses origins (-3908,3365), (-2208,2614), (-3908,1864), (-2208,1864).
KashyyykRryattNpcs = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykRryattNpcs",
	zoneName = "kashyyyk_rryatt_trail",
	travelRange = 6,

	-- {template, world x, height, world y, heading}; level is the NPC's trail level.
	npcs = {
		{"ep3_rryatt_krepauk", -3766.64, 168.235, 3637.19, 183.919},
		{"ep3_carl_mosik", -3764.73, 168.235, 3590.66, -10.886},
		{"ep3_zhailaut", -3767.72, 168.235, 3589.84, 0},
		-- Vritol follows the individually aligned tree 100000019 and bridge 100000030.
		{"ep3_rryatt_vritol", -3512.059545, 144.314383, 4001.166023, 126.218},
		{"ep3_negal_teklon", -3337.896, 140, 4039.61, -51.457},
		{"ep3_rryatt_tressk", -3040.29, 120, 4554.44, 123.186},
		{"ep3_rryatt_trail_guide_f_01", -3182.251, 114.705, 4073.97, -33.232, level = 1, zoneLine = "rryattOne_rryattTwo", startingLocation = "rryattOneF_zoneIn"},
		{"ep3_rryatt_trail_guide_m_01", -2945.898, 70.1953, 4256.578, -66.457, level = 2, up = true, zoneLine = "rryattTwo_rryattOne", startingLocation = "rryattTwoM_zoneIn"},
		{"ep3_rryatt_trail_guide_f_02", -2692.67, 120, 4210.16, -55.302, level = 2, zoneLine = "rryattTwo_rryattThree", startingLocation = "rryattTwoF_zoneIn"},
		{"ep3_achonnko", -3782.1, 169.417, 3582.29, 53.286, level = 1, mastery = true},
		{"ep3_rryatt_trail_guide_m_02", -1840.83, 184.024, 3008, 130.135, level = 3, up = true, zoneLine = "rryattThree_rryattTwo", startingLocation = "rryattThreeM_zoneIn"},
		{"ep3_rryatt_trail_guide_f_03", -1296.499, 188.038, 4059.8, 10.629, level = 3, zoneLine = "rryattThree_rryattFour", startingLocation = "rryattThreeF_zoneIn"},
		{"ep3_rryatt_trail_guide_m_03", -3595.582, 140, 2829.839, 64.77, level = 4, up = true, zoneLine = "rryattFour_rryattThree", startingLocation = "rryattFourM_zoneIn"},
		{"ep3_rryatt_trail_guide_f_04", -2592.53, 142.647, 2827.239, 252.596, level = 4, zoneLine = "rryattFour_rryattFive", startingLocation = "rryattFourF_zoneIn"},
		{"ep3_rryatt_trail_guide_m_04", -1878.51, -23.4006, 2360.739, 137.177, level = 5, up = true, zoneLine = "rryattFive_rryattFour", startingLocation = "rryattFiveM_zoneIn"},
	},

	-- DSRC travel/zone_transition.tab: x, height, y offsets relative to the NPC, destination level.
	transitions = {
		rryattOne_rryattTwo = {233, -45.3, 183, 2},
		rryattTwo_rryattOne = {-240, 43, -177, 1},
		rryattTwo_rryattThree = {853, 62.3, -955, 3},
		rryattThree_rryattTwo = {-856, -62.2, 953, 2},
		rryattThree_rryattFour = {-2294, -46, -1228, 4},
		rryattFour_rryattThree = {2300, 46, 1232, 3},
		rryattFour_rryattFive = {716.5, -166.3, -467.2, 5},
		rryattFive_rryattFour = {-718.5, 166, 465.3, 4},
		rryattOneF_zoneIn = {-593.5, 53.6, -464.2, 1},
		rryattTwoF_zoneIn = {-1083, 48.2, -600, 1},
		rryattTwoM_zoneIn = {-830, 98.2, -641.6, 1},
		rryattThreeF_zoneIn = {-2481, -18, -698, 1},
		rryattThreeM_zoneIn = {-1934.5, -14, 351, 1},
		rryattFourF_zoneIn = {-1183, 28.2, 533, 1},
		rryattFourM_zoneIn = {-182, 28.2, 530, 1},
		rryattFiveM_zoneIn = {-1898, 191.8, 1000, 1},
		rryattGate_rryattTwo = {827, -100, 675, 2},
		rryattGate_rryattThree = {1942, 12.9, -327.2, 3},
		rryattGate_rryattFour = {189.7, -29.3, -500, 4},
		rryattGate_rryattFive = {1906, -193, -973, 5},
	},
	masteryDestinations = {"rryattGate_rryattTwo", "rryattGate_rryattThree", "rryattGate_rryattFour", "rryattGate_rryattFive"},
	-- Only the converted first layout is shifted north from DSRC areas_* origins.
	layoutShift = {251, 251, 0, 0, 0},
}

registerScreenPlay("KashyyykRryattNpcs", true)

function KashyyykRryattNpcs:start()
	if (isZoneEnabled(self.zoneName) and self:spawnNpcs()) then
		print("KashyyykRryattNpcs: screenplay loaded successfully")
	end
end

function KashyyykRryattNpcs:matchesNpc(pNpc, npc)
	return pNpc ~= nil and SceneObject(pNpc):isAiAgent()
		and SceneObject(pNpc):getZoneName() == self.zoneName
		and SceneObject(pNpc):getParentID() == 0
		and AiAgent(pNpc):getCreatureTemplateName() == npc[1]
end

function KashyyykRryattNpcs:spawnNpcs()
	local placed = 0
	for i = 1, #self.npcs do
		local npc = self.npcs[i]
		local key = self.screenplayName .. ":npc:" .. i
		local pNpc = getSceneObject(readData(key))
		if (not self:matchesNpc(pNpc, npc)) then
			pNpc = spawnMobile(self.zoneName, npc[1], 0, npc[2], npc[3], npc[4], npc[5], 0)
		end
		if (pNpc ~= nil) then
			local oid = SceneObject(pNpc):getObjectID()
			writeData(key, oid)
			writeData(self.screenplayName .. ":index:" .. oid, i)
			if (npc.zoneLine ~= nil) then
				writeStringData(oid .. ":zoneLine", npc.zoneLine)
				writeStringData(oid .. ":startingLocation", npc.startingLocation)
			end
			AiAgent(pNpc):addObjectFlag(AI_STATIONARY)
			placed = placed + 1
		else
			print("KashyyykRryattNpcs: failed to spawn " .. npc[1])
		end
	end
	return placed == #self.npcs
end

function KashyyykRryattNpcs:getNpc(pNpc)
	if (pNpc == nil) then return nil end
	local oid = SceneObject(pNpc):getObjectID()
	local index = tonumber(readData(self.screenplayName .. ":index:" .. oid)) or 0
	local npc = self.npcs[index]
	if (npc == nil or readData(self.screenplayName .. ":npc:" .. index) ~= oid or not self:matchesNpc(pNpc, npc)) then
		return nil
	end
	return npc
end

function KashyyykRryattNpcs:canUseNpc(pPlayer, pNpc)
	return pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and self:getNpc(pNpc) ~= nil
		and isZoneEnabled(self.zoneName) and SceneObject(pPlayer):getZoneName() == self.zoneName
		and (SceneObject(pPlayer):getParentID() == 0 or CreatureObject(pPlayer):isRidingMount())
		and not CreatureObject(pPlayer):isDead() and not CreatureObject(pPlayer):isIncapacitated()
		and not CreatureObject(pNpc):isDead() and not CreatureObject(pNpc):isIncapacitated()
		and not CreatureObject(pPlayer):isInCombat() and not CreatureObject(pNpc):isInCombat()
		and SceneObject(pPlayer):getDistanceTo3d(pNpc) <= self.travelRange
end

function KashyyykRryattNpcs:travel(pPlayer, pNpc, returnToGate, masteryLevel)
	if (not self:canUseNpc(pPlayer, pNpc)) then return false end
	local npc = self:getNpc(pNpc)
	local line = npc.zoneLine
	if (masteryLevel ~= nil) then
		if (not npc.mastery or type(masteryLevel) ~= "number" or masteryLevel ~= math.floor(masteryLevel)
			or masteryLevel < 1 or masteryLevel > 4
			or not rryattTrailMasteryScreenPlay:hasLevel(pPlayer, masteryLevel)
			or (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")
			and not CreatureObject(pPlayer):hasSkill("combat_smuggler_underworld_01"))) then
			return false
		end
		line = self.masteryDestinations[masteryLevel]
	elseif (returnToGate) then
		line = npc.startingLocation
	end
	local destination = self.transitions[line]
	if (destination == nil) then return false end
	local x = SceneObject(pNpc):getWorldPositionX() + destination[1]
	local z = SceneObject(pNpc):getWorldPositionZ() + destination[2]
	local y = SceneObject(pNpc):getWorldPositionY() + destination[3]
		+ self.layoutShift[destination[4]] - self.layoutShift[npc.level]
	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end
	if (CreatureObject(pPlayer):isRidingMount() or SceneObject(pPlayer):getParentID() ~= 0) then
		return false
	end
	SceneObject(pPlayer):teleport(x, z, y, 0)
	local dx = SceneObject(pPlayer):getWorldPositionX() - x
	local dz = SceneObject(pPlayer):getWorldPositionZ() - z
	local dy = SceneObject(pPlayer):getWorldPositionY() - y
	if (SceneObject(pPlayer):getZoneName() ~= self.zoneName or dx * dx + dz * dz + dy * dy > 0.01) then
		return false
	end
	if (not returnToGate and masteryLevel == nil) then
		rryattTrailMasteryScreenPlay:signalFromZoneLine(pPlayer, line)
	end
	return true
end
