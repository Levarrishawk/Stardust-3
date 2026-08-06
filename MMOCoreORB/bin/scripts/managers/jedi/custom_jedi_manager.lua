JediManager = require("managers.jedi.jedi_manager")

jediManagerName = "CustomJediManager"

CustomJediManager = JediManager:new {
	screenplayName = jediManagerName,
	jediManagerName = jediManagerName,
	jediProgressionType = CUSTOMJEDIPROGRESSION,
	startingEvent = nil,
}

function CustomJediManager:onPlayerLoggedIn(pPlayer)
	if (pPlayer == nil) then
		return
	end

	ElysiumJediProgression:syncScreenPlayState(pPlayer)
	JediTrials:onPlayerLoggedIn(pPlayer)
end

function CustomJediManager:checkForceStatusCommand(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage == ElysiumJediProgression.NOT_STARTED) then
		CreatureObject(pPlayer):sendSystemMessage("You have not yet begun your journey toward the Force.")
	elseif (stage < ElysiumJediProgression.UNLOCK_COMPLETE) then
		CreatureObject(pPlayer):sendSystemMessage("Your connection to the Force is still taking shape.")
	else
		CreatureObject(pPlayer):sendSystemMessage("The Force is with you. Your training must continue.")
	end
end

function CustomJediManager:canLearnSkill(pPlayer, skillName)
	-- Preserve existing skill behavior while the custom Force-sensitive trees are built.
	return true
end

function CustomJediManager:canSurrenderSkill(pPlayer, skillName)
	return true
end

function CustomJediManager:onFSTreeCompleted(pPlayer, branch)
	-- Custom Force-sensitive branch progression will be handled here.
end

registerScreenPlay("CustomJediManager", true)

return CustomJediManager

