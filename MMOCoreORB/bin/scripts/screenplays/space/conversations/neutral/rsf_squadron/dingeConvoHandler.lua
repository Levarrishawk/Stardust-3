dingeConvoHandler = conv_handler:new {}

function dingeConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return nil
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local faction = CreatureObject(pPlayer):getFaction()
	local playerID = CreatureObject(pPlayer):getObjectID()

	-- JTL is disabled
	if (not isJtlEnabled()) then
		return convoTemplate:getScreen("no_jtl")
	end

	-- Player is Rebel Pilot
	if (SpaceHelpers:isRebelPilot(pPlayer)) then
		return convoTemplate:getScreen("rebel_pilot")
	-- Player is Imperial Pilot
	elseif (SpaceHelpers:isImperialPilot(pPlayer)) then
		return convoTemplate:getScreen("imperial_pilot")
	end

	local isNeutralPilot = SpaceHelpers:isNeutralPilot(pPlayer)
	local hasShip = SpaceHelpers:hasCertifiedShip(pPlayer, true)

	local questOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.QUEST_STRING_1.type, RsfSquadronScreenplay.QUEST_STRING_1.name)
	local questTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.QUEST_STRING_2.type, RsfSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.QUEST_STRING_3.type, RsfSquadronScreenplay.QUEST_STRING_3.name)
	local questFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.QUEST_STRING_4.type, RsfSquadronScreenplay.QUEST_STRING_4.name)

	local questOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.QUEST_STRING_1.type, RsfSquadronScreenplay.QUEST_STRING_1.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.QUEST_STRING_1_SIDE.type, RsfSquadronScreenplay.QUEST_STRING_1_SIDE.name)
	local questTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.QUEST_STRING_2.type, RsfSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.QUEST_STRING_3.type, RsfSquadronScreenplay.QUEST_STRING_3.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.QUEST_STRING_3_SIDE.type, RsfSquadronScreenplay.QUEST_STRING_3_SIDE.name)
	local questFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.QUEST_STRING_4.type, RsfSquadronScreenplay.QUEST_STRING_4.name)

	local destroyDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.QUEST_STRING_DUTY_4_1.type, RsfSquadronScreenplay.QUEST_STRING_DUTY_4_1.name)
	local escortDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.QUEST_STRING_DUTY_4_2.type, RsfSquadronScreenplay.QUEST_STRING_DUTY_4_2.name)

	local destroyDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.QUEST_STRING_DUTY_4_1.type, RsfSquadronScreenplay.QUEST_STRING_DUTY_4_1.name)
	local escortDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.QUEST_STRING_DUTY_4_2.type, RsfSquadronScreenplay.QUEST_STRING_DUTY_4_2.name)

	-- Player is a Neutral Pilot but not RSF
	if (isNeutralPilot and not SpaceHelpers:isRSFSquadron(pPlayer)) then
		return convoTemplate:getScreen("non_rsf_pilot")
	-- Player does not have neutral pilot novice skill
	elseif (not isNeutralPilot) then
		return convoTemplate:getScreen("recruitment")

	-- Check to ensure player has a starter ship or one they can use
	elseif (not hasShip and not questOneStarted) then
		return convoTemplate:getScreen("no_ship")
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return convoTemplate:getScreen("no_jtl")
	end

	local ghost = LuaPlayerObject(pGhost)

	if (ghost == nil) then
		return convoTemplate:getScreen("no_jtl")
	end

	local npcTemplate = SceneObject(pNpc):getTemplateObjectPath()
	local isDinge = npcTemplate == "object/mobile/space_privateer_tier1_naboo.iff"
	local isDiness = npcTemplate == "object/mobile/space_privateer_tier4_naboo_diness.iff"

	if (SpaceHelpers:isRSFSquadron(pPlayer)) then
		local pilotTier = ghost:getPilotTier()
		local correctTrainer = (pilotTier <= 1 and isDinge) or (pilotTier == 4 and isDiness)

		if ((pilotTier < 5 and not correctTrainer) or (pilotTier >= 5 and not isDiness)) then
			return convoTemplate:getScreen("go_to_next")
		end
	end

	-- Player destroyed their ship control device
	if (not hasShip) then
		grantStarterShip(pPlayer, "neutral")
	end

	--[[
			Tier 4
	--]]

	if (ghost:getPilotTier() >= 4) then
		local t4QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_1.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1.name)
		local t4QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_2.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE1.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE3.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE4.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE4.name)
		local t4QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_3.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE1.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.name)
		local t4QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_4.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_4.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE1.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2A.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2A.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2B.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2B.name)

		local t4QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1.name)
		local t4QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE4.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE4.name)
		local t4QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.name)
		local t4QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2A.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2A.name) or
								SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2B.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2B.name)

		local t4Duty1Started = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.name)
		local t4Duty2Started = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.name)
		local t4Duty3Started = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.name)
		local t4Duty4Started = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.name)

		local t4Duty1Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.name)
		local t4Duty2Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.name)
		local t4Duty3Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.name)
		local t4Duty4Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.name)

		local masterStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.MASTER_QUEST_STRING.type, RsfSquadronScreenplay.MASTER_QUEST_STRING.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, RsfSquadronScreenplay.MASTER_QUEST_STRING_2.type, RsfSquadronScreenplay.MASTER_QUEST_STRING_2.name)
		local masterComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.MASTER_QUEST_STRING_2.type, RsfSquadronScreenplay.MASTER_QUEST_STRING_2.name)

		local completedTier4 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 4)
		local tier4SkillCount = SpaceHelpers:getPilotTierSkillCount(pPlayer, "neutral", 4)
		local requiredTier4Skills = t4QuestFourComplete and 4 or t4QuestThreeComplete and 3 or t4QuestTwoComplete and 2 or t4QuestOneComplete and 1 or 0

		-- Player has an active tier 4 mission from Dinge
		if ((t4QuestOneStarted and not t4QuestOneComplete) or (t4QuestTwoStarted and not t4QuestTwoComplete) or (t4QuestThreeStarted and not t4QuestThreeComplete) or (t4QuestFourStarted and not t4QuestFourComplete) or
			(t4Duty1Started and not t4Duty1Complete) or (t4Duty2Started and not t4Duty2Complete) or (t4Duty3Started and not t4Duty3Complete) or (t4Duty4Started and not t4Duty4Complete) or
			(masterStarted and not masterComplete)) then

			return convoTemplate:getScreen("tier4_on_mission")

		-- Player finished the final tier 4 mission and has all the tier 4 skill boxes
		elseif (t4QuestFourComplete and completedTier4 and getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward") == "1") then
			if (ghost:getPilotTier() <= 4) then
				-- Increment pilot to Tier 5!
				ghost:incrementPilotTier()
			end
			SpaceHelpers:addImperialMasterTrainerWaypoint(pPlayer)

			-- Player has not earned the master box yet
			if (not SpaceHelpers:hasMasterSkill(pPlayer, "neutral")) then
				return convoTemplate:getScreen("master_mission")
			else
				return convoTemplate:getScreen("tier4_completed")
			end

		-- Reward Checks
		elseif (t4QuestFourComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_fourth_mission_success")
		elseif (t4QuestThreeComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_third_mission_success")
		elseif (t4QuestTwoComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_second_mission_success")
		elseif (t4QuestOneComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_first_mission_success")

		elseif (tier4SkillCount < requiredTier4Skills) then
			if (SpaceHelpers:hasExperienceForTraining(pPlayer, 4)) then
				return convoTemplate:getScreen("ready_train_tier4")
			end
			return convoTemplate:getScreen("tier4_duty_repeat")

		-- Has not received the tier 4 briefing from Dinge yet
		elseif (getQuestStatus(playerID .. "RsfSquadronScreenplay:StartedDingeTier4") ~= "1") then
			setQuestStatus(playerID .. "RsfSquadronScreenplay:StartedDingeTier4", 1)

			return convoTemplate:getScreen("tier4_initial_briefing")

		-- Missions are not complete yet
		elseif (not t4QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t4QuestThreeComplete and not t4QuestFourStarted) then
				if (getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_fourth_mission")
				else
					return convoTemplate:getScreen("tier4_fourth_mission")
				end
			-- Player is able to start third mission
			elseif (t4QuestTwoComplete and not t4QuestThreeStarted) then
				if (getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_third_mission")
				else
					return convoTemplate:getScreen("tier4_third_mission")
				end
			-- Player is able to start second mission
			elseif (t4QuestOneComplete and not t4QuestTwoStarted) then
				if (getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_second_mission")
				else
					return convoTemplate:getScreen("tier4_second_mission")
				end
			-- Player is ready for first mission, so either was not given it after training first box or failed
			elseif (not t4QuestOneComplete) then
				if (getQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_first_mission")
				else
					return convoTemplate:getScreen("tier4_first_mission")
				end
			end
		end

		return convoTemplate:getScreen("tier4_duty_repeat")
	end

	--[[
			Quests
	--]]

	-- Player has an active quest from this trainer
	if ((questTwoStarted and not questTwoComplete) or (questThreeStarted and not questThreeComplete) or (questFourStarted and not questFourComplete) or (destroyDutyStarted and not destroyDutyComplete) or (escortDutyStarted and not escortDutyComplete)) then
		return convoTemplate:getScreen("has_mission")
	-- Check if players have all the tier1 skill boxes, send them to next trainer.
	elseif (SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 1)) then
		return convoTemplate:getScreen("completed_tier1")
	-- Player is an RSF pilot and has at least one of the Tier1 skill boxes
	elseif (SpaceHelpers:hasPilotTierSkill(pPlayer, "neutral", 1)) then
		-- Check if the player can be trained in the remaining Tier1 Skills
		if (SpaceHelpers:hasExperienceForTraining(pPlayer, 1)) then
			return convoTemplate:getScreen("more_training")
		-- Offer Duty missions
		else
			CreatureObject(pPlayer):doAnimation("salute1")
			return convoTemplate:getScreen("duty_missions")
		end
	-- Player has finished 4 and has received the reward, but needs to accept training of first pilot skill
	elseif (questFourComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_4.name .. ":reward") == "1") then
		return convoTemplate:getScreen("missions_complete")
	-- Player has completed quest 4 and needs reward
	elseif (questFourComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_4.name .. ":reward") ~= "1") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_4.name .. ":reward", 1)
		assassinate_naboo_privateer_tier1_4a:rewardPlayer(pPlayer)
		return convoTemplate:getScreen("missions_complete")
	-- Player has finished 3, has received the reward and needs to start quest 4
	elseif (questThreeComplete and not questFourStarted and getQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_3.name .. ":reward") == "1") then
		return convoTemplate:getScreen("excellent_work3")
	-- Player has completed quest 3 and needs reward
	elseif (questThreeComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_3.name .. ":reward", 1)
		patrol_naboo_privateer_3:rewardPlayer(pPlayer)
		return convoTemplate:getScreen("excellent_work3")
	-- Player has finished 2, has received the reward and needs to start quest 3
	elseif (questTwoComplete and not questThreeStarted and getQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_2.name .. ":reward") == "1") then
		return convoTemplate:getScreen("excellent_work2")
	-- Player has completed quest 2 and needs reward
	elseif (questTwoComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_2.name .. ":reward") ~= "1") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_2.name .. ":reward", 1)
		destroy_naboo_privateer_2:rewardPlayer(pPlayer)
		return convoTemplate:getScreen("excellent_work2")
	-- Player has finished quest 1, has received the reward and needs to start quest 2
	elseif (questOneComplete and not questTwoStarted and getQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_1.name .. ":reward") == "1") then
		return convoTemplate:getScreen("excellent_work")
	-- Player has finished quest 1 and needs reward
	elseif (questOneComplete and getQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= 1) then
		setQuestStatus(playerID .. RsfSquadronScreenplay.QUEST_STRING_1.name .. ":reward", 1)
		patrol_naboo_privateer_1:rewardPlayer(pPlayer)
		return convoTemplate:getScreen("excellent_work")
	-- Player has first quest active, the mission giver will offer assistance
	elseif (questOneStarted and not questOneComplete) then
		return convoTemplate:getScreen("first_assignment")
	-- Player has failed or aborted the first quest
	elseif (not questOneComplete) then
		return convoTemplate:getScreen("yes_im_ready")
	end

	return convoTemplate:getScreen("no_jtl")
end

function dingeConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local playerID = CreatureObject(pPlayer):getObjectID()

	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	clonedConversation:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pClonedScreen
	end

	local ghost = LuaPlayerObject(pGhost)

	if (ghost == nil) then
		return pClonedScreen
	end

	-- Handle additional training
	if (screenID == "more_training") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_starships_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_starships_01")) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_1:s_e94f494b", "train_player_fighters") -- I want to know about basic fighters.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_weapons_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_weapons_01")) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_1:s_939b6844", "train_player_component") -- I want to know about basic starship component use.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_procedures_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_procedures_01")) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_1:s_ac00d21e", "train_player_basics") -- I want to know about basic training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_droid_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_droid_01")) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_1:s_1726d8a5", "train_player_droid") -- I want to know about droid interface basics.
		end
	-- Handle Skill box granting
	elseif (string.find(screenID, "train_player_")) then
		local skillManager = LuaSkillManager()

		local deductExperience = (string.find(screenID, "_free") == nil)

		screenID = string.gsub(screenID, "_free", "")

		if (screenID == "train_player_droid") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_droid_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_droid_01", deductExperience)
			end
		elseif (screenID == "train_player_basics") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_procedures_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_procedures_01", deductExperience)
			end
		elseif (screenID == "train_player_fighters") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_starships_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_starships_01", deductExperience)
			end
		elseif (screenID == "train_player_component") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_weapons_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_weapons_01", deductExperience)
			end
		end

		if (SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 1) and ghost:getPilotTier() == 1) then
			ghost:incrementPilotTier()
			SpaceHelpers:addKaydineWaypoint(pPlayer)
		end

		return pClonedScreen
	elseif (screenID == "go_to_tier2") then
		-- Increment tier when player is sent to Kaydine
		if (ghost:getPilotTier() == 1) then
			ghost:incrementPilotTier()
		end
		SpaceHelpers:addKaydineWaypoint(pPlayer)
	elseif (screenID == "destroy_duty") then
		destroy_duty_naboo_privateer_6:startQuest(pPlayer, pNpc)
	elseif (screenID == "escort_duty") then
		escort_duty_naboo_privateer_7:startQuest(pPlayer, pNpc)
	elseif (screenID == "yes_enlist") then
		CreatureObject(pPlayer):doAnimation("nod_head_once")

		-- Grant freelance pilot novice box
		SpaceHelpers:grantNovicePilot(pPlayer, "neutralPilot")

		-- Sets RSF Squadron
		SpaceHelpers:setSquadronType(pPlayer, RSF_SQUADRON)

		-- Set pilot tier
		if (ghost:getPilotTier() < 1) then
			ghost:incrementPilotTier()
		end

		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_1:s_9817b9bb", "no_ship") -- No, I don't.
		else
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_1:s_d70dba34", "yes_ship") -- Yes.
		end
	elseif (screenID == "no_ship") then
		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			grantStarterShip(pPlayer, "neutral")
		end

	-- Missions
	elseif (screenID == "yes_im_ready") then
		patrol_naboo_privateer_1:resetQuest(pPlayer)
		patrol_naboo_privateer_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "train_me2") then
		destroy_naboo_privateer_2:resetQuest(pPlayer)
		destroy_naboo_privateer_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "train_me3") then
		patrol_naboo_privateer_3:resetQuest(pPlayer)
		patrol_naboo_privateer_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "train_me4") then
		assassinate_naboo_privateer_tier1_4a:resetQuest(pPlayer)
		assassinate_naboo_privateer_tier1_4a:startQuest(pPlayer, pNpc)

	-- Tier 4 Training
	elseif (screenID == "ready_train_tier4") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_starships_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_starships_04")) then
			clonedConversation:addOption("@conversation/naboo_privateer_tier4:s_ada4db16", "tier4_train_fighters") -- Teach me about exotic vessels.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_weapons_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_weapons_04")) then
			clonedConversation:addOption("@conversation/naboo_privateer_tier4:s_25506b23", "tier4_train_component") -- Teach me about heavy starship component use.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_procedures_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_procedures_04")) then
			clonedConversation:addOption("@conversation/naboo_privateer_tier4:s_fd7e4ac8", "tier4_train_basics") -- Teach me about expert techniques.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_droid_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_droid_04")) then
			clonedConversation:addOption("@conversation/naboo_privateer_tier4:s_1813de4d", "tier4_train_droid") -- Teach me about droid intelligence theory.
		end

	-- Handle Tier 4 Skill box granting
	elseif (string.find(screenID, "tier4_train_")) then
		local skillManager = LuaSkillManager()

		if (screenID == "tier4_train_fighters") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_starships_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_starships_04", true)
			end
		elseif (screenID == "tier4_train_component") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_weapons_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_weapons_04", true)
			end
		elseif (screenID == "tier4_train_basics") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_procedures_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_procedures_04", true)
			end
		elseif (screenID == "tier4_train_droid") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_droid_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_droid_04", true)
			end
		end

		if (ghost:getPilotTier() <= 4 and SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 4)) then
			-- If player has all of the Tier 4 skills, increment their pilot tier
			ghost:incrementPilotTier()
			SpaceHelpers:addImperialMasterTrainerWaypoint(pPlayer)
		end

		-- Either the player is ready to train again or they have all of the missions finished, so send them back to the main screen
		if (SpaceHelpers:hasExperienceForTraining(pPlayer, 4) or
				SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2A.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2A.name) or
				SpaceHelpers:isSpaceQuestComplete(pPlayer, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2B.type, RsfSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2B.name)) then
			return self:getInitialScreen(pPlayer, pNpc, pConvTemplate)
		end

	-- Tier 4 Duty Missions
	elseif (screenID == "accept_tier4_duty1") then
		destroy_duty_naboo_privateer_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty2") then
		escort_duty_naboo_privateer_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty3") then
		recovery_duty_naboo_privateer_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty4") then
		rescue_duty_naboo_privateer_tier4_1:startQuest(pPlayer, pNpc)

	-- Tier 4 Mission Rewards
	elseif (screenID == "tier4_fourth_mission_success") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward", 1)
		space_battle_naboo_privateer_tier4_4a:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_third_mission_success") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward", 1)
		delivery_naboo_privateer_tier4_3a:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_second_mission_success") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward", 1)
		inspect_naboo_privateer_tier4_2a:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_first_mission_success") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward", 1)
		escort_naboo_privateer_tier4_1a:rewardPlayer(pPlayer)

	-- Give Tier 4 Missions
	elseif (screenID == "accept_tier4_fourth_mission" or screenID == "failed_tier4_fourth_mission") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted", 1)

		space_battle_naboo_privateer_tier4_4a:resetQuest(pPlayer)
		space_battle_naboo_privateer_tier4_4a:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_third_mission" or screenID == "failed_tier4_third_mission") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted", 1)

		delivery_naboo_privateer_tier4_3a:resetQuest(pPlayer)
		delivery_naboo_privateer_tier4_3a:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_second_mission" or screenID == "failed_tier4_second_mission") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted", 1)

		inspect_naboo_privateer_tier4_2a:resetQuest(pPlayer)
		inspect_naboo_privateer_tier4_2a:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_first_mission" or screenID == "failed_tier4_first_mission") then
		setQuestStatus(playerID .. RsfSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted", 1)

		escort_naboo_privateer_tier4_1a:resetQuest(pPlayer)
		escort_naboo_privateer_tier4_1a:startQuest(pPlayer, pNpc)

	-- Tier 5 hand-off. Declann owns both Imperial finale mission starts.
	elseif (screenID == "accept_master_mission") then
		if (SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 4)) then
			setQuestStatus(playerID .. "RsfSquadronScreenplay:reportToDeclann", 1)
			SpaceHelpers:addImperialMasterTrainerWaypoint(pPlayer)
		end
	end

	return pClonedScreen
end
