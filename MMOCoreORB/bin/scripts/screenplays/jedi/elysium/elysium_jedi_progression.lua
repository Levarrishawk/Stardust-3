ElysiumJediProgression = ScreenPlay:new {
	screenplayData = "ElysiumJediProgression",
	stageKey = "stage",

	NOT_STARTED = 0,
	DROID_QUEST_ACTIVE = 1,
	GLOWING = 2,
	NPC_SEARCH_ACTIVE = 3,
	NPC_FOUND = 4,
	FORCE_TRIALS_ACTIVE = 5,
	UNLOCK_COMPLETE = 6,
	PADAWAN_ELIGIBLE = 7,
}

registerScreenPlay("ElysiumJediProgression", false)

function ElysiumJediProgression:getStage(pPlayer)
	if (pPlayer == nil) then
		return self.NOT_STARTED
	end

	local stage = tonumber(readScreenPlayData(pPlayer, self.screenplayData, self.stageKey))

	if (stage == nil) then
		return self.NOT_STARTED
	end

	return stage
end

function ElysiumJediProgression:setStage(pPlayer, stage)
	if (pPlayer == nil or stage == nil) then
		return false
	end

	local currentStage = self:getStage(pPlayer)

	if (stage <= currentStage) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayData, self.stageKey, stage)
	return true
end

function ElysiumJediProgression:isPlayerOnElysium(pPlayer)
	return pPlayer ~= nil and SceneObject(pPlayer):getZoneName() == "elysium"
end

function ElysiumJediProgression:startDroidQuest(pPlayer)
	if (not self:isPlayerOnElysium(pPlayer) or self:getStage(pPlayer) ~= self.NOT_STARTED) then
		return false
	end

	return self:setStage(pPlayer, self.DROID_QUEST_ACTIVE)
end

function ElysiumJediProgression:completeDroidQuest(pPlayer)
	if (not self:isPlayerOnElysium(pPlayer) or self:getStage(pPlayer) ~= self.DROID_QUEST_ACTIVE) then
		return false
	end

	if (not self:setStage(pPlayer, self.GLOWING)) then
		return false
	end

	return self:startNpcSearch(pPlayer)
end

function ElysiumJediProgression:startNpcSearch(pPlayer)
	if (not self:isPlayerOnElysium(pPlayer) or self:getStage(pPlayer) ~= self.GLOWING) then
		return false
	end

	return self:setStage(pPlayer, self.NPC_SEARCH_ACTIVE)
end

function ElysiumJediProgression:completeNpcSearch(pPlayer)
	if (not self:isPlayerOnElysium(pPlayer) or self:getStage(pPlayer) ~= self.NPC_SEARCH_ACTIVE) then
		return false
	end

	return self:setStage(pPlayer, self.NPC_FOUND)
end

function ElysiumJediProgression:isGlowing(pPlayer)
	return self:getStage(pPlayer) >= self.GLOWING
end

function ElysiumJediProgression:isPadawanEligible(pPlayer)
	return self:getStage(pPlayer) >= self.PADAWAN_ELIGIBLE
end

function ElysiumJediProgression:getDroidPrompt(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == self.NOT_STARTED) then
		return "You have arrived at a place between life and the Force. I may be able to help you understand why, but the path ahead will not be easy."
	elseif (stage == self.DROID_QUEST_ACTIVE) then
		return "Your first task has begun. Return to me when you have completed what is required of you."
	elseif (stage == self.GLOWING) then
		return "Something within you has changed. There is another presence somewhere in Elysium that you must seek out."
	elseif (stage == self.NPC_SEARCH_ACTIVE) then
		return "The presence you seek is somewhere in Elysium. I cannot tell you where. You must find it yourself."
	elseif (stage == self.NPC_FOUND) then
		return "You found the one who was hidden. Your journey through the Force has only begun."
	elseif (stage < self.UNLOCK_COMPLETE) then
		return "Continue the trials set before you. The Force will reveal the way forward when you are ready."
	end

	return "Your path no longer begins here."
end
