CityAuthorityScreenPlay = ScreenPlay:new {
	arrestDelay = 1000,

	arrestDestination = {
		zone = "coruscant",
		x = -99.9,
		z = -23.0,
		y = 219.3,
		cellID = 37002253,
	},
}

registerScreenPlay("CityAuthorityScreenPlay", false)

function CityAuthorityScreenPlay:arrestPlayer(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	createEvent(self.arrestDelay, "CityAuthorityScreenPlay", "completeArrest", pPlayer, "")
end

function CityAuthorityScreenPlay:completeArrest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local player = CreatureObject(pPlayer)

	if (not player:isIncapacitated() or player:isDead()) then
		return
	end

	local destination = self.arrestDestination

	player:sendSystemMessage("You have been arrested by local authorities.")
	SceneObject(pPlayer):switchZone(destination.zone, destination.x, destination.z, destination.y, destination.cellID)
end
