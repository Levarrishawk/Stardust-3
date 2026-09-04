local SpaceHelpers = require("utils.space_helpers")

--[[
	Hakasha Sireen -- Black Epsilon Squadron (Imperial) Tier 1 recruiter/trainer.
	Control-flow port of the proven Inquisition/Havoc recruiter handler, swapping:
		rebel -> imperial, rebel_navy -> imperial_navy,
		HavocSquadronScreenplay -> BlackEpsilonSquadronScreenplay,
		HAVOC_SQUADRON -> BLACK_EPSILON_SQUADRON,
		corellia_rebel_* quests -> corellia_imperial_* quests,
		@conversation/corellia_rebel_trainer_1 -> @conversation/corellia_imperial_trainer_1 (real Live STF).
	All gating mechanisms (incrementPilotTier on hasCompletedPilotTier, reward-once status keys,
	faction standing) are the same Live mechanisms used by the template.
]]

hakasshaSireenConvoHandler = conv_handler:new {}

function hakasshaSireenConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return convoTemplate:getScreen("no_jtl")
	end

	local ghost = LuaPlayerObject(pGhost)

	if (ghost == nil) then
		return convoTemplate:getScreen("no_jtl")
	end

	local npcTemplate = SceneObject(pNpc):getTemplateObjectPath()
	local isPrisk = npcTemplate == "object/mobile/space_imperial_tier2_corellia.iff"
	local isHaymir = npcTemplate == "object/mobile/space_imperial_tier3_yavin_blackepsilon.iff"
	local isInsurgent = npcTemplate == "object/mobile/space_imperial_tier4_corellia_nin_gursawe.iff"

	-- Check if player is an imperial pilot
	local isImperialPilot = SpaceHelpers:isImperialPilot(pPlayer)

	-- Player is Rebel Pilot
	if (SpaceHelpers:isRebelPilot(pPlayer) or (not isImperialPilot and ghost:getFactionStanding("imperial") < 0)) then
		return convoTemplate:getScreen("rebel_pilot")
	-- Player is Neutral Pilot
	elseif (SpaceHelpers:isNeutralPilot(pPlayer)) then
		return convoTemplate:getScreen("neutral_pilot")
	end

	-- Each campaign tier belongs to its named trainer. Earlier trainers only
	-- repeat their handoff after the player has advanced.
	if (SpaceHelpers:isBlackEpsilonSquadron(pPlayer)) then
		local pilotTier = ghost:getPilotTier()
		if ((pilotTier == 2 and not isPrisk) or (pilotTier == 3 and not isHaymir) or (pilotTier >= 4 and not isInsurgent)) then
			return convoTemplate:getScreen("go_to_next")
		elseif ((isPrisk and pilotTier ~= 2) or (isHaymir and pilotTier ~= 3) or (isInsurgent and pilotTier < 4)) then
			return convoTemplate:getScreen("go_to_next")
		end
	end

	-- Check for a starter ship
	local hasShip = SpaceHelpers:hasCertifiedShip(pPlayer, true)

	local questOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_1.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_1.name)
	local questTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_2.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_3.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_3.name)
	local questFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_4.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_4.name)

	local questOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_1.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_1.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_1_SIDE.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_1_SIDE.name)
	local questTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_2.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_3.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_3.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_3_SIDE.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_3_SIDE.name)
	local questFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_4.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_4.name)

	local destroyDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_DUTY_1.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local escortDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_DUTY_2.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	local destroyDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_DUTY_1.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local escortDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.QUEST_STRING_DUTY_2.type, BlackEpsilonSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	-- Player is an Imperial Pilot but a different squadron
	if (isImperialPilot and not SpaceHelpers:isBlackEpsilonSquadron(pPlayer)) then
		return convoTemplate:getScreen("non_inquisition_pilot")
	-- Player is elligible for recruitment
	elseif (not isImperialPilot) then
		return convoTemplate:getScreen("recruitment")
	-- Check to ensure player has a starter ship or one they can use
	elseif (not hasShip and not questOneStarted) then
		return convoTemplate:getScreen("no_ship")
	end

	-- Player destroyed their ship control device
	if (not hasShip) then
		-- Grant Imperial Newbie Ship
		grantStarterShip(pPlayer, "imperial")
	end

	--[[
			Tier 4
	--]]

	if (ghost:getPilotTier() >= 4) then
		local t4QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2.name)
		local t4QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE1.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.name)
		local t4QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE1.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, "patrol", "corellia_imperial_tier4_3_b") or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.name)
		local t4QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE1.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, "space_battle", "corellia_imperial_tier4_4_c") or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)

		local t4QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2.name)
		local t4QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.name)
		local t4QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.name)
		local t4QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)

		local t4Duty1Started = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.name)
		local t4Duty2Started = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.name)
		local t4Duty3Started = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.name)
		local t4Duty4Started = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.name)

		local t4Duty1Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.name)
		local t4Duty2Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.name)
		local t4Duty3Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.name)
		local t4Duty4Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.name)

		local masterStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_MASTER.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_MASTER.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.name)
		local masterComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.name)

		local completedTier4 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "imperial_navy", 4)
		local tier4SkillCount = SpaceHelpers:getPilotTierSkillCount(pPlayer, "imperial_navy", 4)
		local requiredTier4Skills = t4QuestFourComplete and 4 or t4QuestThreeComplete and 3 or t4QuestTwoComplete and 2 or t4QuestOneComplete and 1 or 0

		-- Player has an active tier 4 mission from Sireen
		if ((t4QuestOneStarted and not t4QuestOneComplete) or (t4QuestTwoStarted and not t4QuestTwoComplete) or (t4QuestThreeStarted and not t4QuestThreeComplete) or (t4QuestFourStarted and not t4QuestFourComplete) or
			(t4Duty1Started and not t4Duty1Complete) or (t4Duty2Started and not t4Duty2Complete) or (t4Duty3Started and not t4Duty3Complete) or (t4Duty4Started and not t4Duty4Complete) or
			(masterStarted and not masterComplete)) then

			return convoTemplate:getScreen("tier4_on_mission")

		-- Player finished the final tier 4 mission and has all the tier 4 skill boxes
		elseif (t4QuestFourComplete and completedTier4 and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward") == "1") then
			if (ghost:getPilotTier() <= 4) then
				-- Increment pilot to Tier 5!
				ghost:incrementPilotTier()
			end

			-- Player has not earned the master box yet
			if (not SpaceHelpers:hasMasterSkill(pPlayer, "imperial_navy")) then
				return convoTemplate:getScreen("master_mission")
			else
				return convoTemplate:getScreen("tier4_completed")
			end

		-- Reward Checks
		elseif (t4QuestFourComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_fourth_mission_success")
		elseif (t4QuestThreeComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_third_mission_success")
		elseif (t4QuestTwoComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_second_mission_success")
		elseif (t4QuestOneComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_first_mission_success")

		elseif (tier4SkillCount < requiredTier4Skills) then
			if (SpaceHelpers:hasExperienceForTraining(pPlayer, 4)) then
				return convoTemplate:getScreen("ready_train_tier4")
			end
			return convoTemplate:getScreen("tier4_duty_repeat")

		-- Has not received the tier 4 briefing from Sireen yet
		elseif (getQuestStatus(playerID .. "BlackEpsilonSquadronScreenplay:StartedSireenTier4") ~= "1") then
			setQuestStatus(playerID .. "BlackEpsilonSquadronScreenplay:StartedSireenTier4", 1)

			return convoTemplate:getScreen("tier4_initial_briefing")

		-- Missions are not complete yet
		elseif (not t4QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t4QuestThreeComplete and not t4QuestFourStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_fourth_mission")
				else
					return convoTemplate:getScreen("tier4_fourth_mission")
				end
			-- Player is able to start third mission
			elseif (t4QuestTwoComplete and not t4QuestThreeStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_third_mission")
				else
					return convoTemplate:getScreen("tier4_third_mission")
				end
			-- Player is able to start second mission
			elseif (t4QuestOneComplete and not t4QuestTwoStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_second_mission")
				else
					return convoTemplate:getScreen("tier4_second_mission")
				end
			-- Player is ready for first mission, so either was not given it after training first box or failed
			elseif (not t4QuestOneComplete) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_first_mission")
				else
					return convoTemplate:getScreen("tier4_first_mission")
				end
			end
		end

		return convoTemplate:getScreen("tier4_duty_repeat")
	end

	--[[
			Tier 3
	--]]

	if (ghost:getPilotTier() == 3) then
		local t3QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE1.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.name)
		local t3QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE1.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.name)
		local t3QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE1.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE3.name)
		local t3QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE1.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE2.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE4.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE4.name)

		local t3QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.name)
		local t3QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.name)
		local t3QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE3.name)
		local t3QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE4.type, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE4.name)

		local completedTier3 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "imperial_navy", 3)

		-- Check if players have all the tier 3 skill boxes and finished last mission
		if (t3QuestFourComplete and completedTier3) then
			if (ghost:getPilotTier() <= 3) then
				ghost:incrementPilotTier()
			end

			SpaceHelpers:addBlackEpsilonInsurgentWaypoint(pPlayer)

			return convoTemplate:getScreen("tier3_completed")
		end

		-- Player has an active tier 3 mission from Sireen
		if ((t3QuestOneStarted and not t3QuestOneComplete) or (t3QuestTwoStarted and not t3QuestTwoComplete) or (t3QuestThreeStarted and not t3QuestThreeComplete) or (t3QuestFourStarted and not t3QuestFourComplete)) then
			return convoTemplate:getScreen("tier3_on_mission")
		end

		local tier3SkillCount = SpaceHelpers:getPilotTierSkillCount(pPlayer, "imperial_navy", 3)

		-- Reward + Training Checks. Tier 3 grants a skill box for each mission completed
		if (t3QuestFourComplete and tier3SkillCount == 3) then
			if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward", 1)

				assassinate_corellia_imperial_tier3_4:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_fourth_mission_success")
		elseif (t3QuestThreeComplete and tier3SkillCount == 2) then
			if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward", 1)

				delivery_corellia_imperial_tier3_3:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_third_mission_success")
		elseif (t3QuestTwoComplete and tier3SkillCount == 1) then
			if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward", 1)

				inspect_corellia_imperial_tier3_2:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_second_mission_success")
		elseif (t3QuestOneComplete and tier3SkillCount < 1) then
			if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward", 1)

				recovery_corellia_imperial_tier3_1:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_first_mission_success")
		end

		-- Quest Starters
		if (not t3QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t3QuestThreeComplete and not t3QuestFourStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier3_fourth_mission")
				else
					return convoTemplate:getScreen("tier3_fourth_mission")
				end
			-- Player is able to start third mission
			elseif (t3QuestTwoComplete and not t3QuestThreeStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier3_third_mission")
				else
					return convoTemplate:getScreen("tier3_third_mission")
				end
			-- Player is able to start second mission
			elseif (t3QuestOneComplete and not t3QuestTwoStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier3_second_mission")
				else
					return convoTemplate:getScreen("tier3_second_mission")
				end
			-- Player is ready for first mission
			elseif (not t3QuestOneComplete) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier3_first_mission")
				else
					return convoTemplate:getScreen("tier3_first_mission")
				end
			end
		end

		return convoTemplate:getScreen("tier3_first_mission")
	end

	--[[
			Tier 2
	--]]

	if (ghost:getPilotTier() == 2) then
		local t2QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1.name) or
			SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1_SIDE.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1_SIDE.name)
		local t2QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_2.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_2.name)
		local t2QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_3.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_3.name)
		t2QuestThreeStarted = t2QuestThreeStarted or SpaceHelpers:isSpaceQuestActive(pPlayer, "patrol", "corellia_imperial_15")
		local t2QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.name) or
			SpaceHelpers:isSpaceQuestActive(pPlayer, "inspect", "corellia_imperial_13") or SpaceHelpers:isSpaceQuestActive(pPlayer, "assassinate", "corellia_imperial_17")

		local t2QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1_SIDE.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1_SIDE.name)
		local t2QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_2.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_2.name)
		local t2QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_3.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_3.name)
		local t2QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.name)

		local t2Duty1Started = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.name)
		local t2Duty2Started = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.name)
		local t2Duty3Started = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.name)
		local t2Duty4Started = SpaceHelpers:isSpaceQuestActive(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_4.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_4.name)

		local t2Duty1Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.name)
		local t2Duty2Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.name)
		local t2Duty3Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.name)
		local t2Duty4Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_4.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_DUTY_4.name)

		local completedTier2 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "imperial_navy", 2)
		local tier2SkillCount = SpaceHelpers:getPilotTierSkillCount(pPlayer, "imperial_navy", 2)
		local requiredTier2Skills = t2QuestFourComplete and 4 or t2QuestThreeComplete and 3 or t2QuestTwoComplete and 2 or t2QuestOneComplete and 1 or 0

		-- Player has an active tier 2 mission from Sireen
		if ((t2QuestOneStarted and not t2QuestOneComplete) or (t2QuestTwoStarted and not t2QuestTwoComplete) or (t2QuestThreeStarted and not t2QuestThreeComplete) or (t2QuestFourStarted and not t2QuestFourComplete) or
			(t2Duty1Started and not t2Duty1Complete) or (t2Duty2Started and not t2Duty2Complete) or (t2Duty3Started and not t2Duty3Complete) or (t2Duty4Started and not t2Duty4Complete)) then

			return convoTemplate:getScreen("tier2_on_mission")

		-- Player finished the final tier 2 mission and has all the tier 2 skill boxes
		elseif (t2QuestFourComplete and completedTier2 and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward") == "1") then
			if (ghost:getPilotTier() <= 2) then
				-- Increment pilot to Tier 3!
				ghost:incrementPilotTier()
			end

			SpaceHelpers:addBlackEpsilonHaymirWaypoint(pPlayer)

			return convoTemplate:getScreen("tier2_completed")

		-- Reward Checks
		elseif (t2QuestFourComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier2_fourth_mission_success")
		elseif (t2QuestThreeComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier2_third_mission_success")
		elseif (t2QuestTwoComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier2_second_mission_success")
		elseif (t2QuestOneComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier2_first_mission_success")

		elseif (tier2SkillCount < requiredTier2Skills) then
			if (SpaceHelpers:hasExperienceForTraining(pPlayer, 2)) then
				return convoTemplate:getScreen("ready_train_tier2")
			end
			return convoTemplate:getScreen("tier2_duty_repeat")

		-- Has not received the tier 2 briefing from Sireen yet
		elseif (getQuestStatus(playerID .. "BlackEpsilonSquadronScreenplay:StartedSireenTier2") ~= "1") then
			setQuestStatus(playerID .. "BlackEpsilonSquadronScreenplay:StartedSireenTier2", 1)

			return convoTemplate:getScreen("tier2_initial_briefing")

		-- Missions are not complete yet
		elseif (not t2QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t2QuestThreeComplete and not t2QuestFourStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier2_fourth_mission")
				else
					return convoTemplate:getScreen("tier2_fourth_mission")
				end
			-- Player is able to start third mission
			elseif (t2QuestTwoComplete and not t2QuestThreeStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier2_third_mission")
				else
					return convoTemplate:getScreen("tier2_third_mission")
				end
			-- Player is able to start second mission
			elseif (t2QuestOneComplete and not t2QuestTwoStarted) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier2_second_mission")
				else
					return convoTemplate:getScreen("tier2_second_mission")
				end
			-- Player is ready for first mission
			elseif (not t2QuestOneComplete) then
				if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier2_first_mission")
				else
					return convoTemplate:getScreen("tier2_first_mission")
				end
			end
		end

		return convoTemplate:getScreen("tier2_duty_repeat")
	end

	--[[
			Quests
	--]]

	-- Player has an active quest from Sinkko
	if ((questTwoStarted and not questTwoComplete) or (questThreeStarted and not questThreeComplete) or (questFourStarted and not questFourComplete) or (destroyDutyStarted and not destroyDutyComplete) or (escortDutyStarted and not escortDutyComplete)) then
		return convoTemplate:getScreen("has_mission")
	-- Player has first quest active, the mission giver will offer assistance
	elseif (questOneStarted and not questOneComplete) then
		return convoTemplate:getScreen("first_quest_active")
	-- Player has already finished and been sent to the next trainer
	elseif (getQuestStatus(playerID .. "BlackEpsilonSquadronScreenplay:sireen_finished") == "1") then
		return convoTemplate:getScreen("go_to_next")
	-- Check if players have all the tier1 skill boxes, send them to next trainer.
	elseif (SpaceHelpers:hasCompletedPilotTier(pPlayer, "imperial_navy", 1)) then
		return convoTemplate:getScreen("completed_sinkko")
	-- Player is not a member of the Imperial Faction
	elseif (faction ~= FACTIONIMPERIAL) then
		return convoTemplate:getScreen("recruitment_not_imperial")
	-- Player is an Inquisition pilot and has at least one of the Tier1 skill boxes
	elseif (SpaceHelpers:hasPilotTierSkill(pPlayer, "imperial_navy", 1)) then
		-- Check if the player can be trained in the remaining Tier1 Skills
		if (SpaceHelpers:hasExperienceForTraining(pPlayer, 1)) then
			return convoTemplate:getScreen("more_training")
		-- Offer Duty missions
		else
			CreatureObject(pPlayer):doAnimation("salute1")

			return convoTemplate:getScreen("duty_missions")
		end
	-- Player has completed quest 4 and needs reward
	elseif (questFourComplete) then
		if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_4.name .. ":reward") ~= "1") then
			-- Give player the reward and update that they received it
			setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_4.name .. ":reward", 1)

			-- Grant Reward
			assassinate_corellia_imperial_4:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			ghost:increaseFactionStanding("imperial", 75)
		end

		return convoTemplate:getScreen("missions_complete")
	-- Player has attempted quest 4 but failed/aborted
	elseif (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_4.name .. ":attempted") == "1" and not questFourComplete) then
		return convoTemplate:getScreen("failed_quest4")
	-- Player has finished 3, has received the reward and needs to start quest 4
	elseif (questThreeComplete and not questFourStarted and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_3.name .. ":reward") == "1") then
		return convoTemplate:getScreen("grant_quest4")
	-- Player has completed quest 3 and needs reward (reward given in runScreenHandlers when they respond)
	elseif (questThreeComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
		return convoTemplate:getScreen("excellent_work3")
	-- Player has attempted quest 3 but failed/aborted
	elseif (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_3.name .. ":attempted") == "1" and not questThreeComplete) then
		return convoTemplate:getScreen("failed_quest3")
	-- Player has finished 2, has received the reward and needs to start quest 3
	elseif (questTwoComplete and not questThreeStarted and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_2.name .. ":reward") == "1") then
		return convoTemplate:getScreen("excellent_work2")
	-- Player has completed quest 2 and needs reward
	elseif (questTwoComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_2.name .. ":reward") ~= "1") then
		-- Give player the reward and update that they received it
		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_2.name .. ":reward", 1)

		-- Grant Reward
		destroy_corellia_imperial_2:rewardPlayer(pPlayer)

		-- Grant Faction Standing
		ghost:increaseFactionStanding("imperial", 50)

		return convoTemplate:getScreen("excellent_work2")
	-- Player has attempted quest 2 but failed/aborted
	elseif (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_2.name .. ":attempted") == "1" and not questTwoComplete) then
		return convoTemplate:getScreen("failed_quest2")
	-- Player has finished quest 1, received reward, needs to start quest 2
	elseif (questOneComplete and not questTwoStarted and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_1.name .. ":reward") == "1") then
		return convoTemplate:getScreen("grant_quest2")
	-- Player has finished quest 1 and needs to report to Sinkko
	elseif (questOneComplete and getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= "1") then
		return convoTemplate:getScreen("excellent_work")
	-- Player has attempted quest 1 but failed/aborted
	elseif (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_1.name .. ":attempted") == "1" and not questOneComplete) then
		return convoTemplate:getScreen("failed_quest1")
	-- Player needs to start quest 1
	elseif (not questOneComplete) then
		return convoTemplate:getScreen("yes_ship")
	end

	return convoTemplate:getScreen("no_jtl")
end

function hakasshaSireenConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	-- Set player as conversation target
	clonedConversation:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return pClonedScreen
	end

	local ghost = LuaPlayerObject(pGhost)

	if (ghost == nil) then
		return pClonedScreen
	end

	-- Handle first free training after completing all 4 missions (player chooses which skill)
	if (screenID == "missions_complete") then
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_starships_01")) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_fb13007f", "train_player_fighters_free") -- I'm interested in Imperial operations.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_weapons_01")) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_577aca95", "train_player_component_free") -- I'm interested in weapons.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_procedures_01")) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_5e3cf461", "train_player_basics_free") -- I'm interested in Imperial technology.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_droid_01")) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_a57e647c", "train_player_droid_free") -- I'm interested in astromech management.
		end
	-- Handle additional training (requires XP)
	elseif (screenID == "more_training") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_starships_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_starships_01")) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_fb13007f", "train_player_fighters") -- I'm interested in Imperial operations.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_weapons_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_weapons_01")) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_577aca95", "train_player_component") -- I'm interested in weapons.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_procedures_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_procedures_01")) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_5e3cf461", "train_player_basics") -- I'm interested in Imperial technology.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_droid_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_droid_01")) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_a57e647c", "train_player_droid") -- I'm interested in astromech management.
		end
	-- Handle Skill box granting
	elseif (string.find(screenID, "train_player_")) then
		local skillManager = LuaSkillManager()

		local deductExperience = (string.find(screenID, "_free") == nil)

		screenID = string.gsub(screenID, "_free", "")

		if (screenID == "train_player_droid") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_droid_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_droid_01", deductExperience)
			end
		elseif (screenID == "train_player_basics") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_procedures_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_procedures_01", deductExperience)
			end
		elseif (screenID == "train_player_fighters") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_starships_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_starships_01", deductExperience)
			end
		elseif (screenID == "train_player_component") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_weapons_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_weapons_01", deductExperience)
			end
		end

		if (SpaceHelpers:hasCompletedPilotTier(pPlayer, "imperial_navy", 1) and ghost:getPilotTier() == 1) then
			-- Increment pilot to Tier 2!
			ghost:incrementPilotTier()
		end

		return pClonedScreen
	--[[
			Tier 2 Screens
	--]]

	-- Handle tier 2 training (requires XP)
	elseif (screenID == "ready_train_tier2") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_starships_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_starships_02")) then
			clonedConversation:addOption("@conversation/naboo_imperial_trainer_2:s_594a07fa", "tier2_train_fighters")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_weapons_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_weapons_02")) then
			clonedConversation:addOption("@conversation/naboo_imperial_trainer_2:s_be30f309", "tier2_train_component")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_procedures_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_procedures_02")) then
			clonedConversation:addOption("@conversation/naboo_imperial_trainer_2:s_e73e5d21", "tier2_train_basics")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_droid_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_droid_02")) then
			clonedConversation:addOption("@conversation/naboo_imperial_trainer_2:s_c76594d7", "tier2_train_droid")
		end
	-- Handle tier 2 skill box granting
	elseif (string.find(screenID, "tier2_train_")) then
		local skillManager = LuaSkillManager()

		if (screenID == "tier2_train_droid") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_droid_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_droid_02", true)
			end
		elseif (screenID == "tier2_train_basics") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_procedures_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_procedures_02", true)
			end
		elseif (screenID == "tier2_train_fighters") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_starships_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_starships_02", true)
			end
		elseif (screenID == "tier2_train_component") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_weapons_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_weapons_02", true)
			end
		end

		if (ghost:getPilotTier() <= 2 and SpaceHelpers:hasCompletedPilotTier(pPlayer, "imperial_navy", 2)) then
			-- Increment pilot to Tier 3!
			ghost:incrementPilotTier()
		end

		if (SpaceHelpers:hasExperienceForTraining(pPlayer, 2) or SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.type, BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.name)) then
			return self:getInitialScreen(pPlayer, pNpc, pConvTemplate)
		end

		return pClonedScreen
	-- Tier 2 mission rewards
	elseif (screenID == "tier2_fourth_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward", 1)

		assassinate_corellia_imperial_tier2_4:rewardPlayer(pPlayer)
	elseif (screenID == "tier2_third_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward", 1)

		recovery_corellia_imperial_tier2_3:rewardPlayer(pPlayer)
	elseif (screenID == "tier2_second_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward", 1)

		escort_corellia_imperial_tier2_2:rewardPlayer(pPlayer)
	elseif (screenID == "tier2_first_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward", 1)

		inspect_corellia_imperial_tier2_1:rewardPlayer(pPlayer)
	-- Tier 2 mission starters
	elseif (screenID == "accept_tier2_first_mission" or screenID == "failed_tier2_first_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{recovery_corellia_imperial_16, assassinate_corellia_imperial_12},
			{{type = "recovery", name = "corellia_imperial_16"}, {type = "assassinate", name = "corellia_imperial_12"}})
		recovery_corellia_imperial_16:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier2_second_mission" or screenID == "failed_tier2_second_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer, {assassinate_corellia_imperial_14}, {{type = "assassinate", name = "corellia_imperial_14"}})
		assassinate_corellia_imperial_14:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier2_third_mission" or screenID == "failed_tier2_third_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{patrol_corellia_imperial_15, destroy_surpriseattack_corellia_imperial_15_split},
			{{type = "patrol", name = "corellia_imperial_15"}, {type = "destroy_surpriseattack", name = "corellia_imperial_15_split"}})
		patrol_corellia_imperial_15:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier2_fourth_mission" or screenID == "failed_tier2_fourth_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{inspect_corellia_imperial_13, assassinate_corellia_imperial_17, destroy_corellia_imperial_17},
			{{type = "inspect", name = "corellia_imperial_13"}, {type = "assassinate", name = "corellia_imperial_17"}, {type = "destroy", name = "corellia_imperial_17"}})
		inspect_corellia_imperial_13:startQuest(pPlayer, pNpc)
	-- Tier 2 duty missions
	elseif (screenID == "accept_tier2_duty1") then
		destroy_duty_corellia_imperial_tier2_destroyduty:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier2_duty2") then
		recovery_duty_corellia_imperial_tier2_recoveryduty:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier2_duty3") then
		escort_duty_corellia_imperial_tier2_escortduty:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier2_duty4") then
		escort_duty_corellia_imperial_11:startQuest(pPlayer, pNpc)

	--[[
			Tier 3 Screens
	--]]

	-- Tier 3 training options (missions only, no experience check)
	elseif (screenID == "tier3_first_mission_success" or screenID == "tier3_second_mission_success" or screenID == "tier3_third_mission_success" or screenID == "tier3_fourth_mission_success") then
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_starships_03")) then
			clonedConversation:addOption("@conversation/naboo_imperial_tier3:s_40cda759", "tier3_train_fighters")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_weapons_03")) then
			clonedConversation:addOption("@conversation/naboo_imperial_tier3:s_a9aeb386", "tier3_train_component")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_procedures_03")) then
			clonedConversation:addOption("@conversation/naboo_imperial_tier3:s_ef7a2df5", "tier3_train_procedures")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_droid_03")) then
			clonedConversation:addOption("@conversation/naboo_imperial_tier3:s_473d09d8", "tier3_train_droid")
		end
	-- Handle tier 3 skill box granting
	elseif (string.find(screenID, "tier3_train_")) then
		if (screenID == "tier3_train_droid") then
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_droid_03", false)
		elseif (screenID == "tier3_train_procedures") then
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_procedures_03", false)
		elseif (screenID == "tier3_train_fighters") then
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_starships_03", false)
		elseif (screenID == "tier3_train_component") then
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_weapons_03", false)
		end

		if (ghost:getPilotTier() <= 3 and SpaceHelpers:hasCompletedPilotTier(pPlayer, "imperial_navy", 3)) then
			-- Increment pilot to Tier 4!
			ghost:incrementPilotTier()
		end

		return pClonedScreen
	-- Tier 3 mission starters
	elseif (screenID == "accept_tier3_first_mission" or screenID == "failed_tier3_first_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{patrol_corellia_imperial_tier3_1, inspect_corellia_imperial_tier3_1_a, delivery_no_pickup_corellia_imperial_tier3_1_b, recovery_corellia_imperial_tier3_1_c},
			{BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE1, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE2, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE3})
		patrol_corellia_imperial_tier3_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier3_second_mission" or screenID == "failed_tier3_second_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{recovery_corellia_imperial_tier3_2, survival_corellia_imperial_tier3_2_a, escort_corellia_imperial_tier3_2_b, space_battle_corellia_imperial_tier3_2_c},
			{BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE1, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE2, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3})
		recovery_corellia_imperial_tier3_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier3_third_mission" or screenID == "failed_tier3_third_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{rescue_corellia_imperial_tier3_3, assassinate_corellia_imperial_tier3_3_a},
			{BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE1})
		rescue_corellia_imperial_tier3_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier3_fourth_mission" or screenID == "failed_tier3_fourth_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{recovery_corellia_imperial_tier3_4, assassinate_corellia_imperial_tier3_4_a, survival_corellia_imperial_tier3_4_b, assassinate_corellia_imperial_tier3_4_c},
			{BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE1, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE2, BlackEpsilonSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE3})
		recovery_corellia_imperial_tier3_4:startQuest(pPlayer, pNpc)

	--[[
			Tier 4 Screens
	--]]

	-- Handle tier 4 training (requires XP)
	elseif (screenID == "ready_train_tier4") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_starships_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_starships_04")) then
			clonedConversation:addOption("@conversation/naboo_imperial_tier4:s_d8355c02", "tier4_train_fighters")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_weapons_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_weapons_04")) then
			clonedConversation:addOption("@conversation/naboo_imperial_tier4:s_96a0374a", "tier4_train_component")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_procedures_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_procedures_04")) then
			clonedConversation:addOption("@conversation/naboo_imperial_tier4:s_d8efd03b", "tier4_train_basics")
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_droid_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_droid_04")) then
			clonedConversation:addOption("@conversation/naboo_imperial_tier4:s_7e1308bc", "tier4_train_droid")
		end
	-- Handle tier 4 skill box granting
	elseif (string.find(screenID, "tier4_train_")) then
		local skillManager = LuaSkillManager()

		if (screenID == "tier4_train_droid") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_droid_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_droid_04", true)
			end
		elseif (screenID == "tier4_train_basics") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_procedures_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_procedures_04", true)
			end
		elseif (screenID == "tier4_train_fighters") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_starships_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_starships_04", true)
			end
		elseif (screenID == "tier4_train_component") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_imperial_navy_weapons_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_imperial_navy_weapons_04", true)
			end
		end

		if (ghost:getPilotTier() <= 4 and SpaceHelpers:hasCompletedPilotTier(pPlayer, "imperial_navy", 4)) then
			-- Increment pilot to Tier 5!
			ghost:incrementPilotTier()
		end

		if (SpaceHelpers:hasExperienceForTraining(pPlayer, 4) or SpaceHelpers:isSpaceQuestComplete(pPlayer, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)) then
			return self:getInitialScreen(pPlayer, pNpc, pConvTemplate)
		end

		return pClonedScreen
	-- Tier 4 mission rewards
	elseif (screenID == "tier4_fourth_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward", 1)

		recovery_corellia_imperial_tier4_4:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_third_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward", 1)

		space_battle_corellia_imperial_tier4_3:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_second_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward", 1)

		assassinate_corellia_imperial_tier4_2:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_first_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward", 1)

		survival_corellia_imperial_tier4_1:rewardPlayer(pPlayer)
	-- Tier 4 mission starters
	elseif (screenID == "accept_tier4_first_mission" or screenID == "failed_tier4_first_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{patrol_corellia_imperial_tier4_1, inspect_corellia_imperial_tier4_1_a, survival_corellia_imperial_tier4_1_b},
			{BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2})
		patrol_corellia_imperial_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_second_mission" or screenID == "failed_tier4_second_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{recovery_corellia_imperial_tier4_2, inspect_corellia_imperial_tier4_2_a, delivery_no_pickup_corellia_imperial_tier4_2_b},
			{BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE1, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2})
		recovery_corellia_imperial_tier4_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_third_mission" or screenID == "failed_tier4_third_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{escort_corellia_imperial_tier4_3, rescue_corellia_imperial_tier4_3_a, patrol_corellia_imperial_tier4_3_b, inspect_corellia_imperial_tier4_3_c},
			{BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE1, {type = "patrol", name = "corellia_imperial_tier4_3_b"}, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2})
		escort_corellia_imperial_tier4_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_fourth_mission" or screenID == "failed_tier4_fourth_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted", 1)

		BlackEpsilonSquadronScreenplay:prepareMissionChainAttempt(pPlayer,
			{assassinate_corellia_imperial_tier4_4, recovery_corellia_imperial_tier4_4_a, destroy_surpriseattack_corellia_imperial_tier4_4_b, space_battle_corellia_imperial_tier4_4_c, assassinate_corellia_imperial_tier4_4_d},
			{BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE1, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2, {type = "space_battle", name = "corellia_imperial_tier4_4_c"}, BlackEpsilonSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3})
		assassinate_corellia_imperial_tier4_4:startQuest(pPlayer, pNpc)
	-- Tier 4 duty missions
	elseif (screenID == "accept_tier4_duty1") then
		destroy_duty_corellia_imperial_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty2") then
		escort_duty_corellia_imperial_tier4_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty3") then
		recovery_duty_corellia_imperial_tier4_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty4") then
		rescue_duty_corellia_imperial_tier4_4:startQuest(pPlayer, pNpc)
	-- Master mission hand-off
	elseif (screenID == "accept_master_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. "ImperialMasterPilot:DeclannHandoff", 1)
		SpaceHelpers:addImperialMasterTrainerWaypoint(pPlayer)
	elseif (screenID == "destroy_duty") then
		destroy_duty_corellia_imperial_6:startQuest(pPlayer, pNpc)
	elseif (screenID == "escort_duty") then
		escort_duty_corellia_imperial_7:startQuest(pPlayer, pNpc)
	-- Recruitment flow - confirm enlistment into the Imperial Navy
	elseif (screenID == "yes_join") then
		local convoTemplate = LuaConversationTemplate(pConvTemplate)

		return convoTemplate:getScreen("join_confirm")
	-- Enlistment accepted: grant Imperial pilot novice box + set squadron + tier
	elseif (screenID == "yes_i_am" or screenID == "welcome_navy") then
		-- Grant imperial pilot novice box
		SpaceHelpers:grantNovicePilot(pPlayer, "imperialPilot")

		-- Sets Inquisition Squadron
		SpaceHelpers:setSquadronType(pPlayer, BLACK_EPSILON_SQUADRON)

		-- Set pilot tier
		if (ghost:getPilotTier() < 1) then
			ghost:incrementPilotTier()
		end

		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_4358efe9", "no_ship") -- Where is my ship?
		else
			clonedConversation:addOption("@conversation/corellia_imperial_trainer_1:s_b9b27823", "yes_ship") -- Thank you.
		end
	elseif (screenID == "no_ship") then
		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			-- Grant Imperial Newbie Ship
			grantStarterShip(pPlayer, "imperial")
		end
	-- Missions
	elseif (screenID == "yes_im_ready") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Track that quest was attempted
		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_1.name .. ":attempted", 1)

		patrol_corellia_imperial_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest1") then
		patrol_corellia_imperial_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest2") then
		destroy_corellia_imperial_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest3") then
		patrol_corellia_imperial_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest4") then
		assassinate_corellia_imperial_4:startQuest(pPlayer, pNpc)
	-- Quest 1 completion screens - give reward
	elseif (screenID == "i_was_attacked" or screenID == "rebel_ambush" or screenID == "patrol_complete") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Only give reward once
		if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_1.name .. ":reward", 1)

			-- Grant Reward
			patrol_corellia_imperial_1:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			PlayerObject(pGhost):increaseFactionStanding("imperial", 25)
		end
	elseif (screenID == "quest2_accepted") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_2.name .. ":attempted", 1)
		destroy_corellia_imperial_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "train_me3") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_3.name .. ":attempted", 1)
		patrol_corellia_imperial_3:startQuest(pPlayer, pNpc)
	-- Quest 3 Rewarded - give reward
	elseif (screenID == "quest3_rewarded") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Only give reward once
		if (getQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_3.name .. ":reward", 1)

			-- Grant Reward
			patrol_corellia_imperial_3:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			PlayerObject(pGhost):increaseFactionStanding("imperial", 50)
		end
	-- Quest 4 accepted - start the assassinate mission
	elseif (screenID == "quest4_accepted") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. BlackEpsilonSquadronScreenplay.QUEST_STRING_4.name .. ":attempted", 1)
		assassinate_corellia_imperial_4:startQuest(pPlayer, pNpc)
	-- Finished: completed all Tier 1 skills, reassigned to Under Inquisitor Fa'Zoll (next trainer)
	elseif (screenID == "directions_to_next" or screenID == "report_to_fazoll") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. "BlackEpsilonSquadronScreenplay:sireen_finished", 1)
		SpaceHelpers:addBlackEpsilonNextWaypoint(pPlayer)
	end

	return pClonedScreen
end
