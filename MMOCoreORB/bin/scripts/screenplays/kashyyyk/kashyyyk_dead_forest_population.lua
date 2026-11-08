KashyyykDeadForestPopulation = KashyyykSpawnController:new {
	numberOfActs = 1,
	screenplayName = "KashyyykDeadForestPopulation",
	dataKey = "DeadForestPopulation",
	data = KashyyykDeadForestData,
	nativePatrols = true
}

registerScreenPlay("KashyyykDeadForestPopulation", true)

function KashyyykDeadForestPopulation:getLayout()
	if (isZoneEnabled("kashyyyk_dead_forest")) then
		return "kashyyyk_dead_forest", 0, 0, 14913083
	elseif (isZoneEnabled("kashyyyk")) then
		return "kashyyyk", -1500, 1500, 6292864
	end
end

function KashyyykDeadForestPopulation:start()
	local zone, offsetX, offsetY = self:getLayout()
	if (zone == nil) then
		return
	end
	for _, npc in ipairs(self.data.npcs) do
		local key = self.screenplayName .. ":npc:" .. npc.id
		if (getSceneObject(readData(key)) == nil) then
			local pMobile = spawnMobile(zone, "dead_forest_" .. npc.item, 0,
				npc.x + offsetX, npc.z, npc.y + offsetY, npc.heading, 0)
			if (pMobile ~= nil) then
				writeData(key, SceneObject(pMobile):getObjectID())
				if (SceneObject(pMobile):isAiAgent()) then
					AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
				end
			else
				print(self.screenplayName .. ": failed to place " .. npc.item)
			end
		end
	end
	KashyyykSpawnController.start(self)
end
