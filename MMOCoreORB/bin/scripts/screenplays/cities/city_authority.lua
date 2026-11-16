CityAuthorityScreenPlay = ScreenPlay:new {
	screenplayName = "CityAuthorityScreenPlay",
	arrestDelay = 1000,
	sentences = {
		surrender = { duration = 24 * 60 * 60, fine = 20000 },
		escalation = { duration = 48 * 60 * 60, fine = 50000 },
		murder = { duration = 7 * 24 * 60 * 60, fine = 100000 },
	},

	arrestDestination = {
		zone = "coruscant",
		x = -99.9,
		z = -23.0,
		y = 219.3,
		cellID = 37002253,
	},

	wardenLocation = {
		x = 3.4,
		z = -9.0,
		y = 32.7,
		cellID = 37002244,
	},

	sentenceOfficerLocation = {
		x = -51.7,
		z = -23.0,
		y = 215.1,
		cellID = 37002253,
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

	local officerLocation = self.sentenceOfficerLocation
	local pOfficer = spawnMobile("coruscant", "city_authority_sentence_officer", 0,
			officerLocation.x, officerLocation.z, officerLocation.y, 0, officerLocation.cellID)

	if (pOfficer ~= nil) then
		CreatureObject(pOfficer):setMoodString("neutral")
	end
end

function CityAuthorityScreenPlay:arrestPlayer(pPlayer, offense)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	createEvent(self.arrestDelay, self.screenplayName, "completeArrest", pPlayer, offense or "")
end

function CityAuthorityScreenPlay:completeArrest(pPlayer, offense, surrendered)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local scene = SceneObject(pPlayer)
	local player = CreatureObject(pPlayer)
	local destination = self.arrestDestination
	if (scene:getZoneName() == "" or not isZoneEnabled(destination.zone) or player:isDead() or
			(not surrendered and not player:isIncapacitated())) then
		return
	end

	for _, attribute in ipairs({ 0, 3, 6 }) do
		if (player:getHAM(attribute) < 1) then
			player:setHAM(attribute, 1)
		end
	end

	player:setPosture(UPRIGHT)
	scene:switchZone(destination.zone, destination.x, destination.z, destination.y, destination.cellID)

	if (scene:getZoneName() ~= destination.zone or scene:getParentID() ~= destination.cellID) then
		return
	end

	local sentence = self.sentences[offense] or self.sentences.surrender
	writeScreenPlayData(pPlayer, self.screenplayName, "sentenceEnd",
			tostring(getTimestamp() + sentence.duration))
	writeScreenPlayData(pPlayer, self.screenplayName, "sentenceFine", tostring(sentence.fine))
	player:sendSystemMessage("You have been arrested by local authorities.")
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

function CityAuthorityScreenPlay:getReleaseFine(pPlayer)
	local fine = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "sentenceFine"))
	if (fine ~= nil and fine > 0) then
		return fine
	end

	return self.sentences.surrender.fine
end

function CityAuthorityScreenPlay:releasePlayer(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature() or
			self:getRemainingSentence(pPlayer) > 0) then
		return false, "Your sentence has not been completed."
	end

	local player = CreatureObject(pPlayer)
	local cash = player:getCashCredits()
	local bank = player:getBankCredits()
	local fine = self:getReleaseFine(pPlayer)

	if (cash + bank < fine) then
		return false, "You do not have the " .. fine .. " credits required to pay your release fine."
	end

	if (cash >= fine) then
		player:subtractCashCredits(fine)
	else
		player:subtractCashCredits(cash)
		player:subtractBankCredits(fine - cash)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "sentenceEnd")
	deleteScreenPlayData(pPlayer, self.screenplayName, "sentenceFine")
	player:sendSystemMessage("Your fine has been paid. You are released from Imperial custody.")

	local destination = self.releaseDestination
	SceneObject(pPlayer):switchZone(destination.zone, destination.x, destination.z,
			destination.y, destination.cellID)

	return true, "Your release has been processed."
end
