ElysiumForceSensitiveTrainer = conv_handler:new {
	masterSkill = "",
	trainerBit = 0,
	skills = {},
}

function ElysiumForceSensitiveTrainer:isEligible(pPlayer)
	if (pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium2" or
		ElysiumJediProgression:getStage(pPlayer) < ElysiumJediProgression.UNLOCK_COMPLETE) then
		return false
	end

	return ElysiumJediProgression:unlockForceSensitiveTrees(pPlayer)
end

function ElysiumForceSensitiveTrainer:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (pNpc == nil or not self:isEligible(pPlayer)) then
		return convoTemplate:getScreen("silent")
	end

	if (CreatureObject(pPlayer):hasSkill(self.masterSkill)) then
		ElysiumJediProgression:completeTrainer(pPlayer, self.trainerBit)
		return convoTemplate:getScreen("already_complete")
	end

	return convoTemplate:getScreen("intro")
end

function ElysiumForceSensitiveTrainer:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pNpc == nil) then
		return pConvScreen
	end

	local screen = LuaConversationScreen(pConvScreen)

	if (screen:getScreenID() == "complete" and self:isEligible(pPlayer)) then
		for i = 1, #self.skills do
			if (not CreatureObject(pPlayer):hasSkill(self.skills[i])) then
				awardSkill(pPlayer, self.skills[i])
			end
		end

		if (CreatureObject(pPlayer):hasSkill(self.masterSkill)) then
			ElysiumJediProgression:completeTrainer(pPlayer, self.trainerBit)
		end
	end

	return pConvScreen
end

elysiumTwoForceSpiritConvoHandler = conv_handler:new {}

function elysiumTwoForceSpiritConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (pPlayer == nil or pNpc == nil or SceneObject(pPlayer):getZoneName() ~= "elysium2") then
		return convoTemplate:getScreen("silent")
	end

	if (ElysiumJediProgression:getStage(pPlayer) >= ElysiumJediProgression.UNLOCK_COMPLETE) then
		ElysiumJediProgression:unlockForceSensitiveTrees(pPlayer)
	end

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage == ElysiumJediProgression.FORCE_TRIALS_ACTIVE) then
		return convoTemplate:getScreen("intro")
	elseif (stage >= ElysiumJediProgression.UNLOCK_COMPLETE) then
		return convoTemplate:getScreen("already_complete")
	end

	return convoTemplate:getScreen("silent")
end

function elysiumTwoForceSpiritConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer ~= nil and pNpc ~= nil and LuaConversationScreen(pConvScreen):getScreenID() == "complete") then
		ElysiumJediProgression:unlockForceSensitiveTrees(pPlayer)
	end

	return pConvScreen
end

local function buildTree(prefix, branches)
	local skills = {prefix .. "_novice"}

	for i = 1, #branches do
		for box = 1, 4 do
			table.insert(skills, prefix .. "_" .. branches[i] .. "_0" .. box)
		end
	end

	table.insert(skills, prefix .. "_master")
	return skills
end

elysiumCombatSpiritConvoHandler = ElysiumForceSensitiveTrainer:new {
	masterSkill = "force_sensitive_combat_prowess_master",
	trainerBit = 1,
	skills = buildTree("force_sensitive_combat_prowess", {"ranged_accuracy", "ranged_speed", "melee_accuracy", "melee_speed"}),
}

elysiumReflexesSpiritConvoHandler = ElysiumForceSensitiveTrainer:new {
	masterSkill = "force_sensitive_enhanced_reflexes_master",
	trainerBit = 2,
	skills = buildTree("force_sensitive_enhanced_reflexes", {"ranged_defense", "melee_defense", "vehicle_control", "survival"}),
}

elysiumCraftingSpiritConvoHandler = ElysiumForceSensitiveTrainer:new {
	masterSkill = "force_sensitive_crafting_mastery_master",
	trainerBit = 4,
	skills = buildTree("force_sensitive_crafting_mastery", {"experimentation", "assembly", "repair", "technique"}),
}

elysiumSensesSpiritConvoHandler = ElysiumForceSensitiveTrainer:new {
	masterSkill = "force_sensitive_heightened_senses_master",
	trainerBit = 8,
	skills = buildTree("force_sensitive_heightened_senses", {"healing", "surveying", "persuasion", "luck"}),
}

elysiumInitiateSpiritConvoHandler = conv_handler:new {}

function elysiumInitiateSpiritConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (pPlayer == nil or pNpc == nil or SceneObject(pPlayer):getZoneName() ~= "elysium2") then
		return convoTemplate:getScreen("silent")
	end

	ElysiumJediProgression:syncTrainerCompletion(pPlayer)

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage == ElysiumJediProgression.FS_TRAINING_COMPLETE) then
		return convoTemplate:getScreen("intro")
	elseif (stage >= ElysiumJediProgression.PADAWAN_ELIGIBLE) then
		return convoTemplate:getScreen("complete")
	end

	return convoTemplate:getScreen("silent")
end

function elysiumInitiateSpiritConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer ~= nil and pNpc ~= nil and LuaConversationScreen(pConvScreen):getScreenID() == "depart") then
		self:beginPadawanPath(pPlayer)
	end

	return pConvScreen
end

function elysiumInitiateSpiritConvoHandler:beginPadawanPath(pPlayer)
	if (pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium2" or
		ElysiumJediProgression:getStage(pPlayer) ~= ElysiumJediProgression.FS_TRAINING_COMPLETE) then
		return false
	end

	local shrinePlanet = JediTrials:getRandomDifferentShrinePlanet(pPlayer)

	if (shrinePlanet == nil) then
		CreatureObject(pPlayer):sendSystemMessage("The spirit cannot open the way at this time. Return and try again later.")
		return false
	end

	local pShrine = JediTrials:getRandomShrineOnPlanet(shrinePlanet)

	if (pShrine == nil) then
		CreatureObject(pPlayer):sendSystemMessage("The spirit cannot open the way at this time. Return and try again later.")
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return false
	end

	if (PlayerObject(pGhost):getJediState() < 1) then
		PlayerObject(pGhost):setJediState(1)
	end

	if (not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_01")) then
		awardSkill(pPlayer, "force_title_jedi_rank_01")
	end

	if (not CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_01") or
		not ElysiumJediProgression:setStage(pPlayer, ElysiumJediProgression.PADAWAN_ELIGIBLE)) then
		return false
	end

	PlayerObject(pGhost):setCloneCounter(5)

	local x = SceneObject(pShrine):getWorldPositionX()
	local y = SceneObject(pShrine):getWorldPositionY() + 5
	local z = getWorldFloor(x, y, shrinePlanet)

	SceneObject(pPlayer):switchZone(shrinePlanet, x, z, y, 0)
	return true
end
