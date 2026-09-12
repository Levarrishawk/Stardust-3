SpaceDutyRescueScreenplay = SpaceRescueScreenplay:new {
	className = "SpaceDutyRescueScreenplay",

	-- Screenplay Specific Variables

	DEBUG_SPACE_DUTY_RESCUE = false,


}

registerScreenPlay("SpaceDutyRescueScreenplay", false)

--[[

		Space Duty Rescue Quest Functions

--]]

function SpaceDutyRescueScreenplay:enteredZone(pPlayer, nill, zoneNameHash)
	local dutyExitResult = self:endDutyOnZoneExit(pPlayer, zoneNameHash)

	if (dutyExitResult ~= nil) then
		return dutyExitResult
	end

	return SpaceRescueScreenplay.enteredZone(self, pPlayer, nill, zoneNameHash)
end

-- Same gap as SpaceDutyRecoveryScreenplay: rescue duty missions declare a
-- creditReward that nothing ever paid, because SpaceRescueScreenplay:completeQuest
-- has no reward call and duty missions have no turn-in conversation to pay from.
-- Overridden on the duty subclass so the conversation-paid non-duty rescue quests
-- are not paid twice.
function SpaceDutyRescueScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		return
	end

	self:rewardPlayer(pPlayer)

	SpaceRescueScreenplay.completeQuest(self, pPlayer, notifyClient)

	local pPlayerShip = SceneObject(pPlayer):getRootParent()

	if (SceneObject(pPlayer):getZoneName() == self.questZone and pPlayerShip ~= nil and SceneObject(pPlayerShip):isShipObject() and not SpaceHelpers:isInYacht(pPlayer)) then
		self:startQuest(pPlayer, "")
	else
		SpaceHelpers:failSpaceQuest(pPlayer, self.questType, self.questName, false)
	end
end
