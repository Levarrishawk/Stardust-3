SpaceDutyRescueScreenplay = SpaceRescueScreenplay:new {
	className = "SpaceDutyRescueScreenplay",

	-- Screenplay Specific Variables

	DEBUG_SPACE_DUTY_RESCUE = false,


}

registerScreenPlay("SpaceDutyRescueScreenplay", false)

--[[

		Space Duty Rescue Quest Functions

--]]

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
end