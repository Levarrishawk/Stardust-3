MustafarOverworld = KashyyykSpawnController:new {
	numberOfActs = 1,
	screenplayName = "MustafarOverworld",
	zone = "mustafar",
	dataKey = "MustafarOverworld",
	data = MustafarOverworldData,
	nativePatrols = true,
}

registerScreenPlay("MustafarOverworld", true)

function MustafarOverworld:spawnSearchRadius(entry)
	-- DSRC's requestLocation searches 100–200 m from the offset point.
	return getRandomNumber(100, 200)
end

function MustafarOverworld.questTemplate(template)
	return MustafarOverworldData.questTemplates[template] or template
end

function MustafarOverworld:start()
	if (self:getLayout() == nil) then
		return
	end

	for name, actors in pairs(self.data.actors) do
		for index = 1, #actors do
			self:spawnActor(name, index)
		end
	end

	KashyyykSpawnController.start(self)
end

function MustafarOverworld:spawnActor(name, index)
	local actor = self.data.actors[name][index or 1]
	local key = self.screenplayName .. ":actor:" .. actor.id
	local pMobile = getSceneObject(readData(key))
	if (pMobile ~= nil) then
		return pMobile
	end

	pMobile = spawnMobile(self.zone, actor.mobile, 0, actor.x, actor.z, actor.y, actor.heading, 0)
	if (pMobile == nil) then
		printLuaError(self.screenplayName .. ": failed to place " .. name .. " (" .. actor.id .. ")")
		return nil
	end

	writeData(key, SceneObject(pMobile):getObjectID())
	if (SceneObject(pMobile):isAiAgent()) then
		AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
	end
	if (actor.corpse) then
		CreatureObject(pMobile):setMoodString("npc_dead_01")
	end
	return pMobile
end
