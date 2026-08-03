ElysiumJediProgression = ScreenPlay:new {
	screenplayData = "ElysiumJediProgression",
	stageKey = "stage",
	droidHandoffComplete = 1,

	NOT_STARTED = 0,
	DROID_QUEST_ACTIVE = 1,
	GLOWING = 2,
	SHRINE_SEARCH_ACTIVE = 3,
	SHRINE_FOUND = 4,
	NPC_SEARCH_ACTIVE = 5,
	NPC_FOUND = 6,
	FORCE_TRIALS_ACTIVE = 7,
	UNLOCK_COMPLETE = 8,
	PADAWAN_ELIGIBLE = 9,
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

	if (not self:startShrineSearch(pPlayer)) then
		return false
	end

	CreatureObject(pPlayer):setScreenPlayState(self.droidHandoffComplete, self.screenplayData)
	return true
end

function ElysiumJediProgression:syncScreenPlayState(pPlayer)
	if (pPlayer ~= nil and self:getStage(pPlayer) >= self.SHRINE_SEARCH_ACTIVE) then
		CreatureObject(pPlayer):setScreenPlayState(self.droidHandoffComplete, self.screenplayData)
	end
end

function ElysiumJediProgression:startShrineSearch(pPlayer)
	if (not self:isPlayerOnElysium(pPlayer) or self:getStage(pPlayer) ~= self.GLOWING) then
		return false
	end

	return self:setStage(pPlayer, self.SHRINE_SEARCH_ACTIVE)
end

function ElysiumJediProgression:completeShrineSearch(pPlayer)
	if (not self:isPlayerOnElysium(pPlayer) or self:getStage(pPlayer) ~= self.SHRINE_SEARCH_ACTIVE) then
		return false
	end

	return self:setStage(pPlayer, self.SHRINE_FOUND)
end

function ElysiumJediProgression:startNpcSearch(pPlayer)
	if (not self:isPlayerOnElysium(pPlayer) or self:getStage(pPlayer) ~= self.SHRINE_FOUND) then
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

function ElysiumJediProgression:startForceTrials(pPlayer)
	if (not self:isPlayerOnElysium(pPlayer) or self:getStage(pPlayer) ~= self.NPC_FOUND) then
		return false
	end

	return self:setStage(pPlayer, self.FORCE_TRIALS_ACTIVE)
end

function ElysiumJediProgression:unlockForceSensitiveTrees(pPlayer)
	if (pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium2" or self:getStage(pPlayer) < self.FORCE_TRIALS_ACTIVE) then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return false
	end

	if (PlayerObject(pGhost):getJediState() < 1) then
		PlayerObject(pGhost):setJediState(1)
	end

	if (not CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")) then
		awardSkill(pPlayer, "force_title_jedi_novice")
	end

	if (not CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")) then
		return false
	end

	if (self:getStage(pPlayer) == self.FORCE_TRIALS_ACTIVE) then
		return self:setStage(pPlayer, self.UNLOCK_COMPLETE)
	end

	return true
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
		return "You're not going to believe this. My sensors have found something nearby, it could be an artificial structure of some kind.  There is a lot of interference but it is close by."
	elseif (stage == self.DROID_QUEST_ACTIVE) then
		return "You can either go find the structure or not it's up to you."
	elseif (stage == self.GLOWING) then
		return "Something within you has changed. My sensors have located what appears to be an artificial structure somewhere nearby. You should investigate it."
	elseif (stage == self.SHRINE_SEARCH_ACTIVE) then
		return "The artificial structure is close to where you entered Elysium. Investigate it and determine why my sensors reacted to it."
	elseif (stage == self.SHRINE_FOUND) then
		return "You found the structure. Whatever purpose brought you there is beyond my programming. Return to it if you wish to continue."
	elseif (stage == self.NPC_SEARCH_ACTIVE) then
		return "The structure has sent you searching for someone in Elysium. I cannot locate that individual for you."
	elseif (stage == self.NPC_FOUND) then
		return "You found the individual the structure revealed to you. Your journey through the Force has only begun."
	elseif (stage < self.UNLOCK_COMPLETE) then
		return "Continue the trials set before you. The Force will reveal the way forward when you are ready."
	end

	return "Your path no longer begins here."
end
