local SpaceHelpers = require("utils.space_helpers")

--[[
	Commander Da'la Socuna -- Crimson Phoenix Squadron (Rebel) Tier 1 recruiter/trainer.
	Control-flow port of the proven Inquisition/Havoc recruiter handler, swapping:
		imperial -> rebel, imperial_navy -> rebel_navy,
		HavocSquadronScreenplay -> CrimsonPhoenixSquadronScreenplay,
		HAVOC_SQUADRON -> CRIMSON_PHOENIX_SQUADRON,
		corellia_rebel_* quests -> tatooine_rebel_* quests,
		@conversation/naboo_imperial_trainer_1 -> @conversation/tatooine_rebel_trainer_1 (real Live STF).
	All gating mechanisms (incrementPilotTier on hasCompletedPilotTier, reward-once status keys,
	faction standing) are the same Live mechanisms used by the template.
]]

daLaSocunaConvoHandler = conv_handler:new {}

function daLaSocunaConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	-- Check if player is a rebel pilot
	local isRebelPilot = SpaceHelpers:isRebelPilot(pPlayer)

	-- Player is Imperial Pilot (opposing faction, turned away)
	if (SpaceHelpers:isImperialPilot(pPlayer) or (not isRebelPilot and ghost:getFactionStanding("rebel") < 0)) then
		return convoTemplate:getScreen("imperial_pilot")
	-- Player is Neutral Pilot
	elseif (SpaceHelpers:isNeutralPilot(pPlayer)) then
		return convoTemplate:getScreen("neutral_pilot")
	end

	-- Check for a starter ship
	local hasShip = SpaceHelpers:hasCertifiedShip(pPlayer, true)

	local questOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.name)
	local questTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.name)
	local questFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_4.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_4.name)

	local questOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1_SIDE.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1_SIDE.name)
	local questTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3_SIDE.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3_SIDE.name)
	local questFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_4.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_4.name)

	local destroyDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_DUTY_1.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local escortDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_DUTY_2.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	local destroyDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_DUTY_1.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local escortDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_DUTY_2.type, CrimsonPhoenixSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	-- Player is an Imperial Pilot but a different squadron
	if (isRebelPilot and not SpaceHelpers:isCrimsonPhoenixSquadron(pPlayer)) then
		return convoTemplate:getScreen("non_inquisition_pilot")
	-- Player is elligible for recruitment
	elseif (not isRebelPilot) then
		return convoTemplate:getScreen("recruitment")
	-- Check to ensure player has a starter ship or one they can use
	elseif (not hasShip and not questOneStarted) then
		return convoTemplate:getScreen("no_ship")
	end

	-- Player destroyed their ship control device
	if (not hasShip) then
		-- Grant Imperial Newbie Ship
		grantStarterShip(pPlayer, "rebel")
	end

	--[[
			Tier 4
	--]]

	if (ghost:getPilotTier() >= 4) then
		local t4QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2.name)
		local t4QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE1.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.name)
		local t4QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE1.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.name)
		local t4QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE1.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)

		local t4QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1_SIDE2.name)
		local t4QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2_SIDE2.name)
		local t4QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3_SIDE2.name)
		local t4QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)

		local t4Duty1Started = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.name)
		local t4Duty2Started = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.name)
		local t4Duty3Started = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.name)
		local t4Duty4Started = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.name)

		local t4Duty1Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.name)
		local t4Duty2Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.name)
		local t4Duty3Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.name)
		local t4Duty4Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.name)

		local masterStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.name)
		local masterComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.name)

		local completedTier4 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 4)

		-- Player has an active tier 4 mission from Da'la Socuna
		if ((t4QuestOneStarted and not t4QuestOneComplete) or (t4QuestTwoStarted and not t4QuestTwoComplete) or (t4QuestThreeStarted and not t4QuestThreeComplete) or (t4QuestFourStarted and not t4QuestFourComplete) or
			(t4Duty1Started and not t4Duty1Complete) or (t4Duty2Started and not t4Duty2Complete) or (t4Duty3Started and not t4Duty3Complete) or (t4Duty4Started and not t4Duty4Complete) or
			(masterStarted and not masterComplete)) then

			return convoTemplate:getScreen("tier4_on_mission")

		-- Player finished the final tier 4 mission and has all the tier 4 skill boxes
		elseif (t4QuestFourComplete and completedTier4) then
			if (ghost:getPilotTier() <= 4) then
				-- Increment pilot to Tier 5!
				ghost:incrementPilotTier()
			end

			-- Player has not earned the master box yet
			if (not SpaceHelpers:hasMasterSkill(pPlayer, "rebel_navy")) then
				return convoTemplate:getScreen("master_mission")
			else
				return convoTemplate:getScreen("tier4_completed")
			end

		-- Reward Checks
		elseif (t4QuestFourComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_fourth_mission_success")
		elseif (t4QuestThreeComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_third_mission_success")
		elseif (t4QuestTwoComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_second_mission_success")
		elseif (t4QuestOneComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_first_mission_success")

		-- Pilot is able to train
		elseif (not completedTier4 and SpaceHelpers:hasExperienceForTraining(pPlayer, 4)) then
			return convoTemplate:getScreen("ready_train_tier4")

		-- Has not received the tier 4 briefing from Da'la Socuna yet
		elseif (getQuestStatus(playerID .. "CrimsonPhoenixSquadronScreenplay:StartedSocunaTier4") ~= "1") then
			setQuestStatus(playerID .. "CrimsonPhoenixSquadronScreenplay:StartedSocunaTier4", 1)

			return convoTemplate:getScreen("tier4_initial_briefing")

		-- Missions are not complete yet
		elseif (not t4QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t4QuestThreeComplete and not t4QuestFourStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_fourth_mission")
				else
					return convoTemplate:getScreen("tier4_fourth_mission")
				end
			-- Player is able to start third mission
			elseif (t4QuestTwoComplete and not t4QuestThreeStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_third_mission")
				else
					return convoTemplate:getScreen("tier4_third_mission")
				end
			-- Player is able to start second mission
			elseif (t4QuestOneComplete and not t4QuestTwoStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_second_mission")
				else
					return convoTemplate:getScreen("tier4_second_mission")
				end
			-- Player is ready for first mission, so either was not given it after training first box or failed
			elseif (not t4QuestOneComplete and SpaceHelpers:hasPilotTierSkill(pPlayer, "rebel_navy", 4)) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted") == "1") then
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
		-- Check if player has completed Tier 2 (required before Tier 3 missions)
		if (not SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 2)) then
			return convoTemplate:getScreen("tier3_not_ready")
		end

		local t3QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_1.type, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_1.name)
		local t3QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_2.type, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_2.name)
		local t3QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_3.type, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_3.name)
		local t3QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_4.type, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_4.name)

		local t3QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_1.type, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_1.name)
		local t3QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_2.type, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_2.name)
		local t3QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_3.type, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_3.name)
		local t3QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_4.type, CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_4.name)

		local completedTier3 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 3)

		-- Check if players have all the tier 3 skill boxes and finished last mission, ready for Tier 4
		if (t3QuestFourComplete and completedTier3) then
			if (ghost:getPilotTier() <= 3) then
				ghost:incrementPilotTier()
			end

			return convoTemplate:getScreen("tier3_completed")
		end

		-- Player has an active story quest
		if ((t3QuestOneStarted and not t3QuestOneComplete) or (t3QuestTwoStarted and not t3QuestTwoComplete) or (t3QuestThreeStarted and not t3QuestThreeComplete) or (t3QuestFourStarted and not t3QuestFourComplete)) then
			return convoTemplate:getScreen("tier3_has_mission")
		end

		local tier3SkillCount = SpaceHelpers:getPilotTierSkillCount(pPlayer, "rebel_navy", 3)

		-- Reward + Training Checks. Tier 3 grants a skill box for each mission completed
		if (t3QuestFourComplete and tier3SkillCount == 3) then
			if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward", 1)

				assassinate_tatooine_rebel_tier3_4:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_excellent_work4")
		elseif (t3QuestThreeComplete and tier3SkillCount == 2) then
			if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward", 1)

				delivery_tatooine_rebel_tier3_3:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_excellent_work3")
		elseif (t3QuestTwoComplete and tier3SkillCount == 1) then
			if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward", 1)

				inspect_tatooine_rebel_tier3_2:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_excellent_work2")
		elseif (t3QuestOneComplete and tier3SkillCount < 1) then
			if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward", 1)

				recovery_tatooine_rebel_tier3_1:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_excellent_work1")
		end

		-- Quest Starters
		if (not t3QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t3QuestThreeComplete and not t3QuestFourStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier3_failed_mission4")
				else
					return convoTemplate:getScreen("tier3_mission4_brief")
				end
			-- Player is able to start third mission
			elseif (t3QuestTwoComplete and not t3QuestThreeStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier3_failed_mission3")
				else
					return convoTemplate:getScreen("tier3_mission3_brief")
				end
			-- Player is able to start second mission
			elseif (t3QuestOneComplete and not t3QuestTwoStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier3_failed_mission2")
				else
					return convoTemplate:getScreen("tier3_mission2_brief")
				end
			-- Player is ready for first mission
			elseif (not t3QuestOneComplete) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier3_failed_mission1")
				end
			end
		end

		return convoTemplate:getScreen("tier3_mission1_brief")
	end

	--[[
			Tier 2
	--]]

	if (ghost:getPilotTier() == 2) then
		local t2QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_1.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_1.name)
		local t2QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_2.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_2.name)
		local t2QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_3.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_3.name)
		local t2QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_4.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_4.name)

		local t2QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_1.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_1.name)
		local t2QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_2.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_2.name)
		local t2QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_3.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_3.name)
		local t2QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_4.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_4.name)

		local t2DestroyDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.name)
		local t2RecoveryDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.name)
		local t2EscortDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.name)

		local t2DestroyDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.name)
		local t2RecoveryDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.name)
		local t2EscortDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.type, CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.name)

		local completedTier2 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 2)

		-- Player has an active tier 2 mission
		if ((t2QuestOneStarted and not t2QuestOneComplete) or (t2QuestTwoStarted and not t2QuestTwoComplete) or (t2QuestThreeStarted and not t2QuestThreeComplete) or (t2QuestFourStarted and not t2QuestFourComplete) or
			(t2DestroyDutyStarted and not t2DestroyDutyComplete) or (t2RecoveryDutyStarted and not t2RecoveryDutyComplete) or (t2EscortDutyStarted and not t2EscortDutyComplete)) then

			return convoTemplate:getScreen("tier2_has_mission")

		-- Check if players have all the tier2 skill boxes and finished the last mission, ready for Tier 3
		elseif (t2QuestFourComplete and completedTier2) then
			-- Player has all the skill boxes, they should be tier 3. Increment if not proper
			if (ghost:getPilotTier() <= 2) then
				ghost:incrementPilotTier()
			end

			return convoTemplate:getScreen("tier2_completed")

		-- Reward Checks
		elseif (t2QuestFourComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward", 1)

			assassinate_tatooine_rebel_tier2_4:rewardPlayer(pPlayer)

			return convoTemplate:getScreen("tier2_mission4_rewarded")
		elseif (t2QuestThreeComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward", 1)

			recovery_tatooine_rebel_tier2_3:rewardPlayer(pPlayer)

			return convoTemplate:getScreen("tier2_mission3_rewarded")
		elseif (t2QuestTwoComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward", 1)

			escort_tatooine_rebel_tier2_2:rewardPlayer(pPlayer)

			return convoTemplate:getScreen("tier2_mission2_rewarded")
		elseif (t2QuestOneComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward", 1)

			inspect_tatooine_rebel_tier2_1:rewardPlayer(pPlayer)

			return convoTemplate:getScreen("tier2_mission1_rewarded")

		-- Pilot is able to train
		elseif (not completedTier2 and SpaceHelpers:hasExperienceForTraining(pPlayer, 2)) then
			return convoTemplate:getScreen("tier2_training_menu")

		elseif (not t2QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t2QuestThreeComplete and not t2QuestFourStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier2_failed_mission4")
				else
					return convoTemplate:getScreen("tier2_mission4_brief")
				end
			-- Player is able to start third mission
			elseif (t2QuestTwoComplete and not t2QuestThreeStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier2_failed_mission3")
				else
					return convoTemplate:getScreen("tier2_mission3_brief")
				end
			-- Player is able to start second mission
			elseif (t2QuestOneComplete and not t2QuestTwoStarted) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier2_failed_mission2")
				else
					return convoTemplate:getScreen("tier2_mission2_brief")
				end
			-- Player is ready for first mission
			elseif (not t2QuestOneComplete and SpaceHelpers:hasPilotTierSkill(pPlayer, "rebel_navy", 2)) then
				if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier2_failed_mission1")
				else
					return convoTemplate:getScreen("tier2_mission1_brief")
				end
			end
		end

		-- Player has been introduced but hasn't started quest 1 yet - show duty missions
		if (getQuestStatus(playerID .. "CrimsonPhoenixSquadronScreenplay:tier2_introduced") == "1") then
			return convoTemplate:getScreen("tier2_duty_missions")
		end

		-- New tier 2 pilot
		return convoTemplate:getScreen("tier2_introduction")
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
	elseif (getQuestStatus(playerID .. "CrimsonPhoenixSquadronScreenplay:socuna_finished") == "1") then
		return convoTemplate:getScreen("go_to_next")
	-- Check if players have all the tier1 skill boxes, send them to next trainer.
	elseif (SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 1)) then
		return convoTemplate:getScreen("completed_sinkko")
	-- Player is not a member of the Imperial Faction
	elseif (faction ~= FACTIONREBEL) then
		return convoTemplate:getScreen("recruitment_not_imperial")
	-- Player is an Inquisition pilot and has at least one of the Tier1 skill boxes
	elseif (SpaceHelpers:hasPilotTierSkill(pPlayer, "rebel_navy", 1)) then
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
		if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_4.name .. ":reward") ~= "1") then
			-- Give player the reward and update that they received it
			setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_4.name .. ":reward", 1)

			-- Grant Reward
			assassinate_tatooine_rebel_4:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			ghost:increaseFactionStanding("rebel", 75)
		end

		return convoTemplate:getScreen("missions_complete")
	-- Player has attempted quest 4 but failed/aborted
	elseif (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_4.name .. ":attempted") == "1" and not questFourComplete) then
		return convoTemplate:getScreen("failed_quest4")
	-- Player has finished 3, has received the reward and needs to start quest 4
	elseif (questThreeComplete and not questFourStarted and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.name .. ":reward") == "1") then
		return convoTemplate:getScreen("grant_quest4")
	-- Player has completed quest 3 and needs reward (reward given in runScreenHandlers when they respond)
	elseif (questThreeComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
		return convoTemplate:getScreen("excellent_work3")
	-- Player has attempted quest 3 but failed/aborted
	elseif (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.name .. ":attempted") == "1" and not questThreeComplete) then
		return convoTemplate:getScreen("failed_quest3")
	-- Player has finished 2, has received the reward and needs to start quest 3
	elseif (questTwoComplete and not questThreeStarted and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.name .. ":reward") == "1") then
		return convoTemplate:getScreen("excellent_work2")
	-- Player has completed quest 2 and needs reward
	elseif (questTwoComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.name .. ":reward") ~= "1") then
		-- Give player the reward and update that they received it
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.name .. ":reward", 1)

		-- Grant Reward
		destroy_tatooine_rebel_2:rewardPlayer(pPlayer)

		-- Grant Faction Standing
		ghost:increaseFactionStanding("rebel", 50)

		return convoTemplate:getScreen("excellent_work2")
	-- Player has attempted quest 2 but failed/aborted
	elseif (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.name .. ":attempted") == "1" and not questTwoComplete) then
		return convoTemplate:getScreen("failed_quest2")
	-- Player has finished quest 1, received reward, needs to start quest 2
	elseif (questOneComplete and not questTwoStarted and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.name .. ":reward") == "1") then
		return convoTemplate:getScreen("grant_quest2")
	-- Player has finished quest 1 and needs to report to Sinkko
	elseif (questOneComplete and getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= "1") then
		return convoTemplate:getScreen("excellent_work")
	-- Player has attempted quest 1 but failed/aborted
	elseif (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.name .. ":attempted") == "1" and not questOneComplete) then
		return convoTemplate:getScreen("failed_quest1")
	-- Player needs to start quest 1
	elseif (not questOneComplete) then
		return convoTemplate:getScreen("yes_ship")
	end

	return convoTemplate:getScreen("no_jtl")
end

function daLaSocunaConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_starships_01")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_26970ef", "train_player_fighters_free") -- I am interested in basic starfighter training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_weapons_01")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_d912490", "train_player_component_free") -- I am interested in basic Alliance component use.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_procedures_01")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_8c272224", "train_player_basics_free") -- I am interested in starfighter survival tactics.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_droid_01")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_9480f430", "train_player_droid_free") -- I am interested in droid interface basics.
		end
	-- Handle additional training (requires XP)
	elseif (screenID == "more_training") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_starships_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_starships_01")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_26970ef", "train_player_fighters") -- I am interested in basic starfighter training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_weapons_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_weapons_01")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_d912490", "train_player_component") -- I am interested in basic Alliance component use.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_procedures_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_procedures_01")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_8c272224", "train_player_basics") -- I am interested in starfighter survival tactics.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_droid_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_droid_01")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_9480f430", "train_player_droid") -- I am interested in droid interface basics.
		end
	-- Handle Skill box granting
	elseif (string.find(screenID, "train_player_")) then
		local skillManager = LuaSkillManager()

		local deductExperience = (string.find(screenID, "_free") == nil)

		screenID = string.gsub(screenID, "_free", "")

		if (screenID == "train_player_droid") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_droid_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_droid_01", deductExperience)
			end
		elseif (screenID == "train_player_basics") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_procedures_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_procedures_01", deductExperience)
			end
		elseif (screenID == "train_player_fighters") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_starships_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_starships_01", deductExperience)
			end
		elseif (screenID == "train_player_component") then
			if (not deductExperience or skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_weapons_01")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_weapons_01", deductExperience)
			end
		end

		if (SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 1) and ghost:getPilotTier() == 1) then
			-- Increment pilot to Tier 2!
			ghost:incrementPilotTier()
		end

		return pClonedScreen
	elseif (screenID == "destroy_duty") then
		destroy_duty_tatooine_rebel_6:startQuest(pPlayer, pNpc)
	elseif (screenID == "escort_duty") then
		escort_duty_tatooine_rebel_7:startQuest(pPlayer, pNpc)
	-- Recruitment flow - confirm enlistment into the Imperial Navy
	elseif (screenID == "yes_join") then
		local convoTemplate = LuaConversationTemplate(pConvTemplate)

		return convoTemplate:getScreen("join_confirm")
	-- Enlistment accepted: grant Imperial pilot novice box + set squadron + tier
	elseif (screenID == "yes_i_am" or screenID == "welcome_navy") then
		-- Grant imperial pilot novice box
		SpaceHelpers:grantNovicePilot(pPlayer, "rebelPilot")

		-- Sets Inquisition Squadron
		SpaceHelpers:setSquadronType(pPlayer, CRIMSON_PHOENIX_SQUADRON)

		-- Set pilot tier
		if (ghost:getPilotTier() < 1) then
			ghost:incrementPilotTier()
		end

		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_5bfac9f1", "no_ship") -- Where's my starship?
		else
			clonedConversation:addOption("@conversation/tatooine_rebel_trainer_1:s_4136c2df", "yes_ship") -- Thank you very much.
		end
	elseif (screenID == "no_ship") then
		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			-- Grant Imperial Newbie Ship
			grantStarterShip(pPlayer, "rebel")
		end
	-- Missions
	elseif (screenID == "yes_im_ready") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Track that quest was attempted
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.name .. ":attempted", 1)

		patrol_tatooine_rebel_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest1") then
		patrol_tatooine_rebel_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest2") then
		destroy_tatooine_rebel_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest3") then
		patrol_tatooine_rebel_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest4") then
		assassinate_tatooine_rebel_4:startQuest(pPlayer, pNpc)
	-- Quest 1 completion screens - give reward
	elseif (screenID == "i_was_attacked" or screenID == "rebel_ambush" or screenID == "patrol_complete") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Only give reward once
		if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_1.name .. ":reward", 1)

			-- Grant Reward
			patrol_tatooine_rebel_1:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			PlayerObject(pGhost):increaseFactionStanding("rebel", 25)
		end
	elseif (screenID == "quest2_accepted") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_2.name .. ":attempted", 1)
		destroy_tatooine_rebel_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "train_me3") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.name .. ":attempted", 1)
		patrol_tatooine_rebel_3:startQuest(pPlayer, pNpc)
	-- Quest 3 Rewarded - give reward
	elseif (screenID == "quest3_rewarded") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Only give reward once
		if (getQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_3.name .. ":reward", 1)

			-- Grant Reward
			patrol_tatooine_rebel_3:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			PlayerObject(pGhost):increaseFactionStanding("rebel", 50)
		end
	-- Quest 4 accepted - start the assassinate mission
	elseif (screenID == "quest4_accepted") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.QUEST_STRING_4.name .. ":attempted", 1)
		assassinate_tatooine_rebel_4:startQuest(pPlayer, pNpc)
	-- Finished: completed all Tier 1 skills, reassigned to Under Inquisitor Fa'Zoll (next trainer)
	elseif (screenID == "directions_to_next" or screenID == "report_to_fazoll") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. "CrimsonPhoenixSquadronScreenplay:socuna_finished", 1)
		SpaceHelpers:addCrimsonPhoenixNextWaypoint(pPlayer)
	elseif (screenID == "tier2_training_menu") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_starships_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_starships_02")) then
			clonedConversation:addOption("@conversation/lok_rebel_trainer_2:s_c6c91897", "tier2_train_fighters") -- Multi-Role Craft
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_weapons_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_weapons_02")) then
			clonedConversation:addOption("@conversation/lok_rebel_trainer_2:s_98d991e7", "tier2_train_component") -- Weapons B, Intermediate Alliance Starship Ordnance
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_procedures_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_procedures_02")) then
			clonedConversation:addOption("@conversation/lok_rebel_trainer_2:s_73ccefde", "tier2_train_basics") -- Intermediate Procedures
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_droid_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_droid_02")) then
			clonedConversation:addOption("@conversation/lok_rebel_trainer_2:s_3c4ff185", "tier2_train_droid") -- Astromech Management
		end

	-- Handle Tier 2 Skill box granting
	elseif (string.find(screenID, "tier2_train_")) then
		local skillManager = LuaSkillManager()

		if (screenID == "tier2_train_fighters") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_starships_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_starships_02", true)
			end
		elseif (screenID == "tier2_train_component") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_weapons_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_weapons_02", true)
			end
		elseif (screenID == "tier2_train_basics") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_procedures_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_procedures_02", true)
			end
		elseif (screenID == "tier2_train_droid") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_droid_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_droid_02", true)
			end
		end

		if (SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 2) and ghost:getPilotTier() == 2) then
			-- Increment pilot to Tier 3!
			ghost:incrementPilotTier()
		end

		return pClonedScreen

	-- Tier 2 introduction accepted
	elseif (screenID == "tier2_intro_accept") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. "CrimsonPhoenixSquadronScreenplay:tier2_introduced", 1)

	-- Tier 2 Duty Missions
	elseif (screenID == "tier2_destroy_duty") then
		destroy_duty_tatooine_rebel_tier2_destroyduty:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_recovery_duty") then
		recovery_duty_tatooine_rebel_tier2_recoveryduty:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_escort_duty") then
		escort_duty_tatooine_rebel_tier2_escortduty:startQuest(pPlayer, pNpc)

	-- Give Tier 2 Missions
	elseif (screenID == "tier2_accept_mission1" or screenID == "tier2_failed_mission1") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted", 1)

		inspect_tatooine_rebel_tier2_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_accept_mission2" or screenID == "tier2_failed_mission2") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted", 1)

		escort_tatooine_rebel_tier2_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_accept_mission3" or screenID == "tier2_failed_mission3") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted", 1)

		recovery_tatooine_rebel_tier2_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_accept_mission4" or screenID == "tier2_failed_mission4") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted", 1)

		assassinate_tatooine_rebel_tier2_4:startQuest(pPlayer, pNpc)

	-- Tier 3 Training - options added on excellent work screens, missions-only (no XP requirement)
	elseif (string.find(screenID, "tier3_excellent_work")) then
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_starships_03")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_tier3:s_c43eb58", "tier3_train_fighters") -- Advanced Fighters
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_weapons_03")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_tier3:s_9b989e16", "tier3_train_component") -- Advanced Weapons
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_procedures_03")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_tier3:s_3a9f883c", "tier3_train_basics") -- Advanced Procedures
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_droid_03")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_tier3:s_473d09d8", "tier3_train_droid") -- Advanced Droid Interface
		end

	-- Handle Tier 3 Skill box granting (mission-earned, no XP deduction)
	elseif (string.find(screenID, "tier3_train_")) then
		if (screenID == "tier3_train_fighters") then
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_starships_03", false)
		elseif (screenID == "tier3_train_component") then
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_weapons_03", false)
		elseif (screenID == "tier3_train_basics") then
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_procedures_03", false)
		elseif (screenID == "tier3_train_droid") then
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_droid_03", false)
		end

		if (ghost:getPilotTier() <= 3 and SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 3)) then
			-- Increment pilot to Tier 4!
			ghost:incrementPilotTier()
		end

		return pClonedScreen

	-- Give Tier 3 Missions
	elseif (screenID == "tier3_accept_mission1" or screenID == "tier3_failed_mission1") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted", 1)

		recovery_tatooine_rebel_tier3_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier3_accept_mission2" or screenID == "tier3_failed_mission2") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted", 1)

		inspect_tatooine_rebel_tier3_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier3_accept_mission3" or screenID == "tier3_failed_mission3") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted", 1)

		delivery_tatooine_rebel_tier3_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier3_accept_mission4" or screenID == "tier3_failed_mission4") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted", 1)

		assassinate_tatooine_rebel_tier3_4:startQuest(pPlayer, pNpc)

	-- Tier 4 Training
	elseif (screenID == "ready_train_tier4") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_starships_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_starships_04")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_tier4:s_efdacfde", "tier4_train_fighters") -- I am interested in advanced starfighter training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_weapons_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_weapons_04")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_tier4:s_270a2a57", "tier4_train_component") -- I am interested in advanced starship component use.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_procedures_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_procedures_04")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_tier4:s_daa1d4f4", "tier4_train_basics") -- I am interested in advanced procedures.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_droid_04") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_droid_04")) then
			clonedConversation:addOption("@conversation/tatooine_rebel_tier4:s_1e8289a2", "tier4_train_droid") -- I am interested in advanced droid interface training.
		end

	-- Handle Tier 4 Skill box granting
	elseif (string.find(screenID, "tier4_train_")) then
		local skillManager = LuaSkillManager()

		if (screenID == "tier4_train_fighters") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_starships_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_starships_04", true)
			end
		elseif (screenID == "tier4_train_component") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_weapons_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_weapons_04", true)
			end
		elseif (screenID == "tier4_train_basics") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_procedures_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_procedures_04", true)
			end
		elseif (screenID == "tier4_train_droid") then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_droid_04")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_rebel_navy_droid_04", true)
			end
		end

		if (ghost:getPilotTier() <= 4 and SpaceHelpers:hasCompletedPilotTier(pPlayer, "rebel_navy", 4)) then
			-- If player has all of the Tier 4 skills, increment their pilot tier
			ghost:incrementPilotTier()
		end

		-- Either the player is ready to train again or they have all of the missions finished, so send them back to the main screen
		if (SpaceHelpers:hasExperienceForTraining(pPlayer, 4) or
				SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)) then
			return self:getInitialScreen(pPlayer, pNpc, pConvTemplate)
		end

	-- Tier 4 Duty Missions
	elseif (screenID == "accept_tier4_duty1") then
		escort_duty_tatooine_rebel_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty2") then
		rescue_duty_tatooine_rebel_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty3") then
		recovery_duty_tatooine_rebel_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty4") then
		destroy_duty_tatooine_rebel_tier4_1:startQuest(pPlayer, pNpc)

	-- Tier 4 Mission Rewards
	elseif (screenID == "tier4_fourth_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward", 1)
		recovery_tatooine_rebel_tier4_4:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_third_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward", 1)
		space_battle_tatooine_rebel_tier4_3:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_second_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward", 1)
		assassinate_tatooine_rebel_tier4_2:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_first_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward", 1)
		survival_tatooine_rebel_tier4_1:rewardPlayer(pPlayer)

	-- Give Tier 4 Missions
	elseif (screenID == "accept_tier4_fourth_mission" or screenID == "failed_tier4_fourth_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted", 1)

		recovery_tatooine_rebel_tier4_4:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_third_mission" or screenID == "failed_tier4_third_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted", 1)

		space_battle_tatooine_rebel_tier4_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_second_mission" or screenID == "failed_tier4_second_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted", 1)

		assassinate_tatooine_rebel_tier4_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_first_mission" or screenID == "failed_tier4_first_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted", 1)

		survival_tatooine_rebel_tier4_1:startQuest(pPlayer, pNpc)

	-- Master mission hand-off
	elseif (screenID == "accept_master_mission") then
		if (not SpaceHelpers:isSpaceQuestActive(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER.name) and
				not SpaceHelpers:isSpaceQuestComplete(pPlayer, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER.type, CrimsonPhoenixSquadronScreenplay.TIER4_QUEST_STRING_MASTER.name)) then
			destroy_master_rebel_1:startQuest(pPlayer, pNpc)
		end
	end

	return pClonedScreen
end
