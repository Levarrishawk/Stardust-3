ElysiumGuardian = ScreenPlay:new {
	screenplayName = "ElysiumGuardian",
}

registerScreenPlay("ElysiumGuardian", false)

function ElysiumGuardian:playerLoggedIn(pPlayer)
	if (pPlayer == nil or CreatureObject(pPlayer):getPlayerObject() == nil) then
		return
	end

	if (not hasObserver(ZONESWITCHED, self.screenplayName, "enteredZone", pPlayer)) then
		createObserver(ZONESWITCHED, self.screenplayName, "enteredZone", pPlayer, 1)
	end

	-- Existing residents have no historical entry date; start on their first login.
	if (SceneObject(pPlayer):getZoneName() == "elysium") then
		self:startWait(pPlayer)
	end
end

function ElysiumGuardian:startWait(pPlayer)
	local entryTime = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "entryTime"))
	if (entryTime == nil or entryTime <= 0) then
		writeScreenPlayData(pPlayer, self.screenplayName, "entryTime", tostring(getTimestamp()))
	end
end

function ElysiumGuardian:enteredZone(pPlayer, pObject, zoneNameHash)
	if (pPlayer == nil or CreatureObject(pPlayer):getPlayerObject() == nil) then
		return 0
	end

	if (zoneNameHash == getHashCode("elysium")) then
		self:startWait(pPlayer)
	else
		deleteScreenPlayData(pPlayer, self.screenplayName, "entryTime")
	end

	return 0
end
