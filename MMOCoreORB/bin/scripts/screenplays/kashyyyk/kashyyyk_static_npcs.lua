-- Kachirho static spawns come from the main population data.

KashyyykStaticNpcsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykStaticNpcsScreenPlay",

	mainNpcs = KashyyykMainPopulationData.actors,
}

registerScreenPlay("KashyyykStaticNpcsScreenPlay", true)

function KashyyykStaticNpcsScreenPlay:start()
	if (isZoneEnabled("kashyyyk_main")) then
		self:spawnNpcs("kashyyyk_main", self.mainNpcs)
		self:spawnBunkerNpcs()
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
