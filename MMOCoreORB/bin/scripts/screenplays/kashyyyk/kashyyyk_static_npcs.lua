-- Kachirho static spawns come from the main population data.
-- Hunting keeps its existing buildout placements below.

KashyyykStaticNpcsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykStaticNpcsScreenPlay",

	mainNpcs = KashyyykMainPopulationData.actors,

	-- Separated surface zones use buildout coordinates minus 2048 on both axes.
	huntingNpcs = {
		{"ep3_etyyy_sordaan_xris", 276.31, 48, 494.23, -72.766, "ep3_etyyy_sordaan_xris (hunting row 356)"}, -- registered name equals spawns
		{"ep3_etyyy_ziven_tissak", 419.72, 47.8055, 521.01, 204.878, "ep3_etyyy_ziven_tissak (hunting row 357)"}, -- registered name equals spawns
		{"ep3_etyyy_banol_starkiller", 246.27, 40.9675, 459.26, 25.628, "ep3_etyyy_banol_starkiller (hunting row 358)"}, -- registered name equals spawns
		{"ep3_etyyy_manfred_carter", 115.31, 33.4733, 445.33, 175.382, "ep3_etyyy_manfred_carter (hunting row 359)"}, -- registered name equals spawns
		{"ep3_etyyy_tripp_rar", 169.81, 43.9677, 608.37, 157.915, "ep3_etyyy_tripp_rar (hunting row 360)"}, -- registered name equals spawns
		{"ep3_etyyy_ehartt_brihnt", 182.29, 24.7251, 462.42, 126.051, "ep3_etyyy_ehartt_brihnt (hunting row 361)"}, -- registered name equals spawns
		{"ep3_etyyy_harroom", 292.17, 48, 508.95, 237.918, "ep3_etyyy_harroom (hunting row 362)"}, -- registered name equals spawns
		{"ep3_etyyy_iluna_mystuk", 176.94, 40.3682, 549.88, 33.905, "ep3_etyyy_iluna_mystuk (hunting row 363)"}, -- registered name equals spawns
		{"ep3_etyyy_kint_zsam", -99.77, 25.7985, -249.88, 42.543, "ep3_etyyy_kint_zsam (hunting row 364)"}, -- registered name equals spawns
		{"ep3_etyyy_tuwezz_vol", -28.78, 17.5286, -201.51, 157.341, "ep3_etyyy_tuwezz_vol (hunting row 365)"}, -- registered name equals spawns
		{"ep3_etyyy_johnson_smith", -392.80, 80.5588, 867.26, 218.18, "ep3_etyyy_johnson_smith (hunting row 366)"}, -- registered name equals spawns
		{"ep3_etyyy_kara_corlon", -383.62, 80.5588, 853.64, -58.206, "ep3_etyyy_kara_corlon (hunting row 367)"}, -- registered name equals spawns
		{"ep3_etyyy_jerrol_chupapa", -621.99, 9.0258, 915.00, 132.52, "ep3_etyyy_jerrol_chupapa (hunting row 368)"}, -- registered name equals spawns
		{"ep3_etyyy_ryoo_finn", -614.96, 8.7683, 851.23, 0, "ep3_etyyy_ryoo_finn (hunting row 369)"}, -- registered name equals spawns
		{"ep3_etyyy_pilot_to_bocctyyy", 381.47, 41.7397, 611.80, 243.577, "ep3_etyyy_pilot_to_bocctyyy (hunting row 370)"}, -- registered name equals spawns
		{"ep3_rodian_camp_doctor_01", 224.39, 23.0029, 571.00, 119.358, "ep3_etyyy_rodian_camp_doctor_01 (hunting row 371)"}, -- single repo candidate
		{"ep3_rodian_trader", 185.39, 40.3779, 547.18, -64.174, "ep3_etyyy_rodian_trader (hunting row 372)"}, -- single repo candidate
	},
}

registerScreenPlay("KashyyykStaticNpcsScreenPlay", true)

function KashyyykStaticNpcsScreenPlay:start()
	if (isZoneEnabled("kashyyyk_main")) then
		self:spawnNpcs("kashyyyk_main", self.mainNpcs)
		self:spawnBunkerNpcs()
	end

	if (isZoneEnabled("kashyyyk_hunting")) then
		self:spawnNpcs("kashyyyk_hunting", self.huntingNpcs)
	end
end

function KashyyykStaticNpcsScreenPlay:spawnNpcs(zone, npcs)
	for i = 1, #npcs, 1 do
		local npc = npcs[i]
		local key = zone == "kashyyyk_main" and (self.screenplayName .. ":actor:" .. npc[6])
		if (not key or getSceneObject(readData(key)) == nil) then
			local pMobile = spawnMobile(zone, npc[1], 0, npc[2], npc[3], npc[4], npc[5], 0)
			if (pMobile ~= nil and SceneObject(pMobile):isAiAgent()) then
				AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
				if (key) then
					writeData(key, SceneObject(pMobile):getObjectID())
				end
				if (npc[7]) then
					CreatureObject(pMobile):setMoodString("npc_dead_01")
				end
			end
		end
	end
end

function KashyyykStaticNpcsScreenPlay:spawnBunkerNpcs()
	-- The split map supports both the snapshot building and the native buildout copy.
	local pBunker = getSceneObject(14602403) or getSceneObject(-6029991)
	if (pBunker == nil or not SceneObject(pBunker):isBuildingObject()
		or SceneObject(pBunker):getZoneName() ~= "kashyyyk_main"
		or SceneObject(pBunker):getTemplateObjectPath() ~= "object/building/general/bunker_imperial_kashyyyk_01.iff") then
		return
	end

	local buildingID = SceneObject(pBunker):getObjectID()
	for index, npc in ipairs(KashyyykMainPopulationData.bunker) do
		local key = self.screenplayName .. ":bunker:" .. buildingID .. ":" .. index
		local pCell = BuildingObject(pBunker):getNamedCell(npc[2])
		if (pCell ~= nil and getSceneObject(readData(key)) == nil) then
			local pMobile = spawnMobile("kashyyyk_main", npc[1], 0, npc[3], npc[4], npc[5], npc[6], SceneObject(pCell):getObjectID())
			if (pMobile ~= nil and SceneObject(pMobile):isAiAgent()) then
				writeData(key, SceneObject(pMobile):getObjectID())
				AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
				if (npc[7] ~= "") then
					CreatureObject(pMobile):setMoodString(npc[7])
				end
			end
		end
	end
end
