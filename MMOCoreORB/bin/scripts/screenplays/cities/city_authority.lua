CityAuthorityScreenPlay = ScreenPlay:new {
	screenplayName = "CityAuthorityScreenPlay",
	arrestDelay = 1000,
	sentenceDuration = 24 * 60 * 60,
	releaseFine = 20000,

	arrestDestination = {
		zone = "coruscant",
		x = -99.9,
		z = -23.0,
		y = 219.3,
		cellID = 37002253,
	},

	wardenLocation = {
		x = -3.4,
		z = -9.0,
		y = 32.7,
		cellID = 37002244,
	},

	releaseDestination = {
		zone = "coruscant",
		x = -121.0,
		z = 40.0,
		y = 5517.0,
		cellID = 0,
	},
}

registerScreenPlay("CityAuthorityScreenPlay", true)

function CityAuthorityScreenPlay:start()
	if (not isZoneEnabled("coruscant")) then
		return
	end

	local location = self.wardenLocation
	local pWarden = spawnMobile("coruscant", "city_authority_warden", 0,
			location.x, location.z, location.y, 180, location.cellID)

	if (pWarden ~= nil) then
		CreatureObject(pWarden):setMoodString("neutral")
	end
end

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

	writeScreenPlayData(pPlayer, self.screenplayName, "sentenceEnd",
			tostring(getTimestamp() + self.sentenceDuration))

	player:sendSystemMessage("You have been arrested by local authorities.")

	for _, attribute in ipairs({ 0, 3, 6 }) do
		if (player:getHAM(attribute) < 1) then
			player:setHAM(attribute, 1)
		end
	end

	player:setPosture(UPRIGHT)
	SceneObject(pPlayer):switchZone(destination.zone, destination.x, destination.z, destination.y, destination.cellID)
end

function CityAuthorityScreenPlay:getSentenceEnd(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "sentenceEnd")) or 0
end

function CityAuthorityScreenPlay:getRemainingSentence(pPlayer)
	return math.max(0, self:getSentenceEnd(pPlayer) - getTimestamp())
end

function CityAuthorityScreenPlay:releasePlayer(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature() or
			self:getSentenceEnd(pPlayer) == 0 or self:getRemainingSentence(pPlayer) > 0) then
		return false, "Your sentence has not been completed."
	end

	local player = CreatureObject(pPlayer)
	local cash = player:getCashCredits()
	local bank = player:getBankCredits()

	if (cash + bank < self.releaseFine) then
		return false, "You do not have the 20,000 credits required to pay your release fine."
	end

	if (cash >= self.releaseFine) then
		player:subtractCashCredits(self.releaseFine)
	else
		player:subtractCashCredits(cash)
		player:subtractBankCredits(self.releaseFine - cash)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "sentenceEnd")
	player:sendSystemMessage("Your fine has been paid. You are released from Imperial custody.")

	local destination = self.releaseDestination
	SceneObject(pPlayer):switchZone(destination.zone, destination.x, destination.z,
			destination.y, destination.cellID)

	return true, "Your release has been processed."
end
