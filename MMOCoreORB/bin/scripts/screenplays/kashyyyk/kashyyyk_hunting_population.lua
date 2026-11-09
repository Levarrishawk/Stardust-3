KashyyykHuntingPopulation = KashyyykSpawnController:new {
	numberOfActs = 1,
	screenplayName = "KashyyykHuntingPopulation",
	zone = "kashyyyk_hunting",
	dataKey = "HuntingPopulation",
	data = KashyyykHuntingData,
	nativePatrols = true
}

registerScreenPlay("KashyyykHuntingPopulation", true)

function KashyyykHuntingPopulation:start()
	local zone = self:getLayout()
	if (zone == nil) then
		return
	end
	for _, actor in ipairs(self.data.actors) do
		local key = self.screenplayName .. ":actor:" .. actor.id
		if (getSceneObject(readData(key)) == nil) then
			local pMobile = spawnMobile(zone, actor.mobile, 0, actor.x, actor.z, actor.y, actor.heading, 0)
			if (pMobile ~= nil) then
				writeData(key, SceneObject(pMobile):getObjectID())
				if (SceneObject(pMobile):isAiAgent()) then
					AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
				end
			else
				print(self.screenplayName .. ": failed to place " .. actor.item)
			end
		end
	end
	KashyyykSpawnController.start(self)
end
