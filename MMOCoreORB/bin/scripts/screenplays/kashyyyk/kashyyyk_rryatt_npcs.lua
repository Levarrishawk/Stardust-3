-- Public Rryatt layout (copy 0). Placements: DSRC buildout/kashyyyk_rryatt_trail/*.tab.
-- DSRC creatures.tab maps the rryatt_* spawn names to these existing mobile templates.
-- Native public instance: first four areas_* rows, with no custom snapshot offsets.
KashyyykRryattNpcs = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykRryattNpcs",
	zoneName = "kashyyyk_rryatt_trail",
	travelRange = 6,
	nativeGateID = -141018963347066332, -- Scene row5, area row0, native door objid -15027676.

	-- {template, world x, height, world y, heading}; level is the NPC's trail level.
	npcs = {
		{"ep3_rryatt_krepauk", -3766.64, 168.235, 3386.19, 183.919452158},
		{"ep3_carl_mosik", -3764.73, 168.235, 3339.66, 349.11379948},
		{"ep3_zhailaut", -3767.72, 168.235, 3338.84, 0},
		{"ep3_rryatt_vritol", -3513.75, 143.421, 3807.75, 126.218187028},
		{"ep3_negal_teklon", -3337.896, 140, 3788.61, 308.543015215},
		{"ep3_rryatt_tressk", -3040.29, 120, 4303.44, 123.185942269},
		{"ep3_rryatt_trail_guide_f_01", -3182.251, 114.705, 3822.97, 326.76847668, level = 1, zoneLine = "rryattOne_rryattTwo", startingLocation = "rryattOneF_zoneIn"},
		{"ep3_rryatt_trail_guide_m_01", -2945.898, 70.1953, 4005.578, 293.543204829, level = 2, up = true, zoneLine = "rryattTwo_rryattOne", startingLocation = "rryattTwoM_zoneIn"},
		{"ep3_rryatt_trail_guide_f_02", -2692.67, 120, 3959.16, 304.698333427, level = 2, zoneLine = "rryattTwo_rryattThree", startingLocation = "rryattTwoF_zoneIn"},
		{"ep3_achonnko", -3782.1, 169.417, 3331.29, 53.286149286, level = 1, mastery = true},
		{"ep3_rryatt_trail_guide_m_02", -1840.83, 184.024, 3008, 130.135231707, level = 3, up = true, zoneLine = "rryattThree_rryattTwo", startingLocation = "rryattThreeM_zoneIn"},
		{"ep3_rryatt_trail_guide_f_03", -1296.499, 188.038, 4059.8, 10.62885757, level = 3, zoneLine = "rryattThree_rryattFour", startingLocation = "rryattThreeF_zoneIn"},
		{"ep3_rryatt_trail_guide_m_03", -3595.582, 140, 2829.839, 64.770291623, level = 4, up = true, zoneLine = "rryattFour_rryattThree", startingLocation = "rryattFourM_zoneIn"},
		{"ep3_rryatt_trail_guide_f_04", -2592.53, 142.647, 2827.239, 252.596404867, level = 4, zoneLine = "rryattFour_rryattFive", startingLocation = "rryattFourF_zoneIn"},
		{"ep3_rryatt_trail_guide_m_04", -1878.51, -23.4006, 2360.739, 137.176577483, level = 5, up = true, zoneLine = "rryattFive_rryattFour", startingLocation = "rryattFiveM_zoneIn"},
	},

	-- Original DSRC offsets; all NPCs now share the native public-instance frame.
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
}

registerScreenPlay("KashyyykRryattNpcs", true)

function KashyyykRryattNpcs:start()
	if (not isZoneEnabled(self.zoneName)) then return end
	local pGate = getSceneObject(self.nativeGateID)
	if (pGate == nil or SceneObject(pGate):getZoneName() ~= self.zoneName
		or SceneObject(pGate):getParentID() ~= 0
		or SceneObject(pGate):getTemplateObjectPath() ~= "object/tangible/door/thm_kash_zonegate_door_simple.iff") then
		print("KashyyykRryattNpcs: native buildouts are unavailable; static NPC placement deferred")
		return
	end
	if (self:spawnNpcs()) then
		print("KashyyykRryattNpcs: screenplay loaded successfully")
	end
end

function KashyyykRryattNpcs:matchesNpc(pNpc, npc)
	if (pNpc == nil or not SceneObject(pNpc):isAiAgent()
		or SceneObject(pNpc):getZoneName() ~= self.zoneName or SceneObject(pNpc):getParentID() ~= 0) then
		return false
	end
	local template = AiAgent(pNpc):getCreatureTemplateName()
	template = template:gsub("^ep3_rryatt_trail_guild_f_(0[1-4])$", "ep3_rryatt_trail_guide_f_%1")
	return template == npc[1]
end

function KashyyykRryattNpcs:spawnNpcs()
	local placed = 0
	for i = 1, #self.npcs do
		local npc = self.npcs[i]
		local key = self.screenplayName .. ":npc:" .. i
		local pNpc = getSceneObject(readData(key))
		if (not self:matchesNpc(pNpc, npc)) then
			pNpc = spawnMobile(self.zoneName, npc[1], 0, npc[2], npc[3], npc[4], npc[5], 0)
		else
			-- Reuse only our owned NPC, but migrate its old saved placement too.
			SceneObject(pNpc):teleport(npc[2], npc[3], npc[4], 0)
			SceneObject(pNpc):setDirectionalHeading(math.rad(npc[5]))
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
		-- Recover the reverse lookup only for an NPC already owned by this screenplay.
		for i, entry in ipairs(self.npcs) do
			if (readData(self.screenplayName .. ":npc:" .. i) == oid and self:matchesNpc(pNpc, entry)) then
				writeData(self.screenplayName .. ":index:" .. oid, i)
				return entry
			end
		end
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
