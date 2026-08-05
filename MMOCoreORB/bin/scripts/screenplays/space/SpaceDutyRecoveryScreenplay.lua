SpaceDutyRecoveryScreenplay = SpaceRecoveryScreenplay:new {
	className = "SpaceDutyRecoveryScreenplay",

	-- Screenplay Specific Variables

	DEBUG_SPACE_DUTY_RECOVERY = false,

	arrivalDelay = 5, -- In Seconds

	recoverShip = "",
	recoveryConversationMobile = "",

	preRecoveryPoints = {
		--{zoneName = "space_corellia", x = -4381, z = -4943, y = -7262, patrolNumber = 1, radius = 150},
	},

	recoveryPoints = {
		--{zoneName = "space_corellia", x = -4381, z = -4943, y = -7262, patrolNumber = 1, radius = 150},
	},

	escortSpeed = 20,
	testEscortSpeed = 40,

	attackDelay = 30, -- In Seconds

	attackShips = {
		{},
	},

	recoveryDelay = 5,

	tauntData = {
		panicCount = 5,
		thanksCount = 5,
	},
}

registerScreenPlay("SpaceDutyRecoveryScreenplay", false)

--[[

		Space Duty Recovery Quest Functions

--]]

-- Every recovery duty mission declares a creditReward, but nothing ever paid it:
-- SpaceRecoveryScreenplay:completeQuest has no reward call, and unlike the non-duty
-- recovery quests -- which are paid by their squadron conversation handler calling
-- <quest>:rewardPlayer -- duty missions have no turn-in conversation. The sibling
-- duty classes both pay on completion (SpaceDutyEscortScreenplay:240-254,
-- SpaceDutyDestroyScreenplay:735+), so this one was simply missing it.
--
-- Overridden here rather than on SpaceRecoveryScreenplay so the 22 conversation-paid
-- non-duty recovery quests are not paid twice.
function SpaceDutyRecoveryScreenplay:completeQuest(pPlayer, notifyClient)
	if (pPlayer == nil) then
		return
	end

	self:rewardPlayer(pPlayer)

	SpaceRecoveryScreenplay.completeQuest(self, pPlayer, notifyClient)
end
