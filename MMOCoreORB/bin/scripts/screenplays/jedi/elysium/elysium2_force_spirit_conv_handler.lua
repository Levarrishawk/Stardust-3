ElysiumForceSensitiveTrainer = conv_handler:new {
	masterSkill = "",
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
	skills = buildTree("force_sensitive_combat_prowess", {"ranged_accuracy", "ranged_speed", "melee_accuracy", "melee_speed"}),
}

elysiumReflexesSpiritConvoHandler = ElysiumForceSensitiveTrainer:new {
	masterSkill = "force_sensitive_enhanced_reflexes_master",
	skills = buildTree("force_sensitive_enhanced_reflexes", {"ranged_defense", "melee_defense", "vehicle_control", "survival"}),
}

elysiumCraftingSpiritConvoHandler = ElysiumForceSensitiveTrainer:new {
	masterSkill = "force_sensitive_crafting_mastery_master",
	skills = buildTree("force_sensitive_crafting_mastery", {"experimentation", "assembly", "repair", "technique"}),
}

elysiumSensesSpiritConvoHandler = ElysiumForceSensitiveTrainer:new {
	masterSkill = "force_sensitive_heightened_senses_master",
	skills = buildTree("force_sensitive_heightened_senses", {"healing", "surveying", "persuasion", "luck"}),
}
