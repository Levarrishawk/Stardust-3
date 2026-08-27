local SpaceHelpers = require("utils.space_helpers")

--[[
	Dravis -- Smuggler Alliance Squadron (Neutral) Tier 1 recruiter/trainer.
	Control-flow port of the proven Inquisition/Havoc recruiter handler, swapping:
		imperial -> neutral (freelance), imperial cert -> neutral cert,
		HavocSquadronScreenplay -> SmugglerSquadronScreenplay,
		HAVOC_SQUADRON -> SMUGGLER_SQUADRON,
		corellia_rebel_* quests -> tatooine_privateer_* quests,
		@conversation/naboo_imperial_trainer_1 -> @conversation/tatooine_privateer_trainer_1 (real Live STF).
	All gating mechanisms (incrementPilotTier on hasCompletedPilotTier, reward-once status keys,
	faction standing) are the same Live mechanisms used by the template.
]]

dravisConvoHandler = conv_handler:new {}

function dravisConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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
	local isDravis = npcTemplate == "object/mobile/space_privateer_tier1_tatooine.iff"
	local isShamdon = npcTemplate == "object/mobile/space_privateer_tier2_shamdon.iff"
	local isBeissa = npcTemplate == "object/mobile/space_rebel_tier3_beissa.iff"
	local isNirame = npcTemplate == "object/mobile/space_privateer_tier4_tatooine_nirame.iff"

	-- Check if player is a neutral pilot
	local isNeutralPilot = SpaceHelpers:isNeutralPilot(pPlayer)

	-- Player is Imperial Pilot (turned away)
	if (SpaceHelpers:isImperialPilot(pPlayer)) then
		return convoTemplate:getScreen("imperial_pilot")
	-- Player is a Rebel pilot and cannot join a neutral squadron concurrently
	elseif (SpaceHelpers:isRebelPilot(pPlayer)) then
		return convoTemplate:getScreen("rebel_pilot")
	end

	if (SpaceHelpers:isSmugglerSquadron(pPlayer)) then
		local pilotTier = ghost:getPilotTier()
		local correctTrainer = (pilotTier <= 1 and isDravis) or (pilotTier == 2 and isShamdon) or
			(pilotTier == 3 and isBeissa) or (pilotTier == 4 and isNirame)

		if (pilotTier < 5 and not correctTrainer) then
			return convoTemplate:getScreen("go_to_next")
		end
	end

	-- Check for a starter ship
	local hasShip = SpaceHelpers:hasCertifiedShip(pPlayer, true)

	local questOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_1.type, SmugglerSquadronScreenplay.QUEST_STRING_1.name)
	local questTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_2.type, SmugglerSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_3.type, SmugglerSquadronScreenplay.QUEST_STRING_3.name)
	local questFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_4.type, SmugglerSquadronScreenplay.QUEST_STRING_4.name)

	local questOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_1.type, SmugglerSquadronScreenplay.QUEST_STRING_1.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_1_SIDE.type, SmugglerSquadronScreenplay.QUEST_STRING_1_SIDE.name)
	local questTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_2.type, SmugglerSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_3.type, SmugglerSquadronScreenplay.QUEST_STRING_3.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_3_SIDE.type, SmugglerSquadronScreenplay.QUEST_STRING_3_SIDE.name)
	local questFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_4.type, SmugglerSquadronScreenplay.QUEST_STRING_4.name)

	local destroyDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_DUTY_1.type, SmugglerSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local escortDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_DUTY_2.type, SmugglerSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	local destroyDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_DUTY_1.type, SmugglerSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local escortDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.QUEST_STRING_DUTY_2.type, SmugglerSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	-- Player is a neutral pilot but belongs to a different squadron
	if (isNeutralPilot and not SpaceHelpers:isSmugglerSquadron(pPlayer)) then
		return convoTemplate:getScreen("non_inquisition_pilot")
	-- Player is elligible for recruitment
	elseif (not isNeutralPilot) then
		return convoTemplate:getScreen("recruitment")
	-- Check to ensure player has a starter ship or one they can use
	elseif (not hasShip and not questOneStarted) then
		return convoTemplate:getScreen("no_ship")
	end

	-- Player destroyed their ship control device
	if (not hasShip) then
		-- Replace the neutral starter ship if its control device was destroyed
		grantStarterShip(pPlayer, "neutral")
	end

	--[[
			Tier 4 (Dinge-pattern dispatch; SmugglerSquadronScreenplay tier 4 chains)
	--]]

	if (ghost:getPilotTier() >= 4) then
		-- NOTE: Several TIER3/TIER4 *_SIDE* constants in SmugglerSquadronScreenplay.lua carry
		-- class-style names (e.g. "space_battle_tatooine_privateer_tier4_1_a") instead of the
		-- registered questName ("tatooine_privateer_tier4_1_a"). Space quest journal keys hash
		-- the questName, so those constants can never match. The local literals below carry the
		-- registered questNames (verified against the quest bodies in SmugglerSquadronScreenplay.lua).
		local T4_SIDE_1A = { type = "space_battle", name = "tatooine_privateer_tier4_1_a" }
		local T4_SIDE_1B = { type = "space_battle", name = "tatooine_privateer_tier4_1_b" }
		local T4_SIDE_2A = { type = "delivery_no_pickup", name = "tatooine_privateer_tier4_2_a" }
		local T4_SIDE_2B = { type = "rescue", name = "tatooine_privateer_tier4_2_b" }
		local T4_SIDE_3A = { type = "space_battle", name = "tatooine_privateer_tier4_3_a" }
		local T4_SIDE_3B = { type = "survival", name = "tatooine_privateer_tier4_3_b" }
		local T4_SIDE_4A = { type = "assassinate", name = "tatooine_privateer_tier4_4_a" }
		local T4_SIDE_4B = { type = "rescue", name = "tatooine_privateer_tier4_4_b" }

		local t4QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_1.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T4_SIDE_1A.type, T4_SIDE_1A.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T4_SIDE_1B.type, T4_SIDE_1B.name)
		local t4QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_2.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T4_SIDE_2A.type, T4_SIDE_2A.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T4_SIDE_2B.type, T4_SIDE_2B.name)
		local t4QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_3.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T4_SIDE_3A.type, T4_SIDE_3A.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T4_SIDE_3B.type, T4_SIDE_3B.name)
		local t4QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T4_SIDE_4A.type, T4_SIDE_4A.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T4_SIDE_4B.type, T4_SIDE_4B.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)

		local t4QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, T4_SIDE_1A.type, T4_SIDE_1A.name) or
								SpaceHelpers:isSpaceQuestComplete(pPlayer, T4_SIDE_1B.type, T4_SIDE_1B.name)
		local t4QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, T4_SIDE_2A.type, T4_SIDE_2A.name) or
								SpaceHelpers:isSpaceQuestComplete(pPlayer, T4_SIDE_2B.type, T4_SIDE_2B.name)
		local t4QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, T4_SIDE_3A.type, T4_SIDE_3A.name) or
								SpaceHelpers:isSpaceQuestComplete(pPlayer, T4_SIDE_3B.type, T4_SIDE_3B.name)
		local t4QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)

		local t4Duty1Started = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.name)
		local t4Duty2Started = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.name)
		local t4Duty3Started = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.name)
		local t4Duty4Started = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.name)

		local t4Duty1Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_1.name)
		local t4Duty2Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_2.name)
		local t4Duty3Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_3.name)
		local t4Duty4Complete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_DUTY_4.name)

		local masterStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_MASTER.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_MASTER.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.name)
		local masterComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_MASTER_2.name)

		local completedTier4 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 4)

		-- Player has an active tier 4 mission from Dravis
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
			SpaceHelpers:addWillhamBurkeWaypoint(pPlayer)

			-- Player has not earned the master box yet (pilot_neutral_master is granted inside the Kessel screenplay)
			if (not SpaceHelpers:hasMasterSkill(pPlayer, "neutral")) then
				return convoTemplate:getScreen("master_mission")
			else
				return convoTemplate:getScreen("tier4_completed")
			end

		-- Reward Checks
		elseif (t4QuestFourComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_fourth_mission_success")
		elseif (t4QuestThreeComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_third_mission_success")
		elseif (t4QuestTwoComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_second_mission_success")
		elseif (t4QuestOneComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier4_first_mission_success")

		-- Pilot is able to train
		elseif (not completedTier4 and SpaceHelpers:hasExperienceForTraining(pPlayer, 4)) then
			return convoTemplate:getScreen("ready_train_tier4")

		-- Has not received the tier 4 briefing from Dravis yet
		elseif (getQuestStatus(playerID .. "SmugglerSquadronScreenplay:StartedTier4") ~= "1") then
			setQuestStatus(playerID .. "SmugglerSquadronScreenplay:StartedTier4", 1)

			return convoTemplate:getScreen("tier4_initial_briefing")

		-- Missions are not complete yet
		elseif (not t4QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t4QuestThreeComplete and not t4QuestFourStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_fourth_mission")
				else
					return convoTemplate:getScreen("tier4_fourth_mission")
				end
			-- Player is able to start third mission
			elseif (t4QuestTwoComplete and not t4QuestThreeStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_third_mission")
				else
					return convoTemplate:getScreen("tier4_third_mission")
				end
			-- Player is able to start second mission
			elseif (t4QuestOneComplete and not t4QuestTwoStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_second_mission")
				else
					return convoTemplate:getScreen("tier4_second_mission")
				end
			-- Player is ready for first mission, so either was not given it after training first box or failed
			elseif (not t4QuestOneComplete and SpaceHelpers:hasPilotTierSkill(pPlayer, "neutral", 4)) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("failed_tier4_first_mission")
				else
					return convoTemplate:getScreen("tier4_first_mission")
				end
			end
		end

		return convoTemplate:getScreen("tier4_duty_repeat")
	end

	--[[
			Tier 3 (Dulios-pattern dispatch; missions only, no XP gate)
	--]]

	local t2QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name)

	if (ghost:getPilotTier() >= 3 and t2QuestFourComplete) then
		-- Same questName-vs-className constant defect as tier 4 (see NOTE above); literals below
		-- carry the registered questNames.
		local T3_SIDE_1A = { type = "patrol", name = "tatooine_privateer_tier3_1_A" }
		local T3_SIDE_2A = { type = "delivery", name = "tatooine_privateer_tier3_2_a" }
		local T3_SIDE_4A = { type = "patrol", name = "tatooine_privateer_tier3_4_a" }

		local t3QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T3_SIDE_1A.type, T3_SIDE_1A.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE2.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE3.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.name)
		local t3QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T3_SIDE_2A.type, T3_SIDE_2A.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE2.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.name)
		local t3QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE1.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE2.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE3.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE3.name)
		local t3QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T3_SIDE_4A.type, T3_SIDE_4A.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE2.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE2.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE3.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE3.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE4.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE4.name)

		local t3QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1_SIDE4.name)
		local t3QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2_SIDE3.name)
		local t3QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE3.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3_SIDE3.name)
		local t3QuestFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE4.type, SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4_SIDE4.name)

		local completedTier3 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 3)

		-- Check if players have all the tier3 skill boxes and finished the last mission, then move them on.
		if (t3QuestFourComplete and completedTier3) then
			-- Player has all the skill boxes, they should be a tier 4. Increment if not proper
			if (ghost:getPilotTier() <= 3) then
				-- Increment pilot to Tier 4
				ghost:incrementPilotTier()
			end
			SpaceHelpers:addNirameSakuteWaypoint(pPlayer)

			return convoTemplate:getScreen("tier3_completed_dulios")
		end

		-- Player has an active tier 3 mission from Dravis
		if ((t3QuestOneStarted and not t3QuestOneComplete) or (t3QuestTwoStarted and not t3QuestTwoComplete) or (t3QuestThreeStarted and not t3QuestThreeComplete) or (t3QuestFourStarted and not t3QuestFourComplete)) then
			return convoTemplate:getScreen("tier3_on_mission")
		end

		local tier3SkillCount = SpaceHelpers:getPilotTierSkillCount(pPlayer, "neutral", 3)

		-- Reward Checks. Tier3 grants a skill box for each mission
		if (t3QuestFourComplete and tier3SkillCount == 3) then
			if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":reward", 1)

				-- Grant Reward
				assassinate_tatooine_privateer_tier3_4:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_complete_mission4")
		elseif (t3QuestThreeComplete and tier3SkillCount == 2) then
			if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":reward", 1)

				-- Grant Reward
				delivery_tatooine_privateer_tier3_3:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_complete_mission3")
		elseif (t3QuestTwoComplete and tier3SkillCount == 1) then
			if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":reward", 1)

				-- Grant Reward
				inspect_tatooine_privateer_tier3_2:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_complete_mission2")
		elseif (t3QuestOneComplete and tier3SkillCount < 1) then
			if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward") ~= "1") then
				setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":reward", 1)

				-- Grant Reward
				recovery_tatooine_privateer_tier3_1:rewardPlayer(pPlayer)
			end

			return convoTemplate:getScreen("tier3_complete_mission1")

		-- Mission Starters
		elseif (not t3QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t3QuestThreeComplete and not t3QuestFourStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier3_failed_fourth_mission")
				else
					return convoTemplate:getScreen("tier3_fourth_mission")
				end
			-- Player is able to start third mission
			elseif (t3QuestTwoComplete and not t3QuestThreeStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier3_failed_third_mission")
				else
					return convoTemplate:getScreen("tier3_third_mission")
				end
			-- Player is able to start second mission
			elseif (t3QuestOneComplete and not t3QuestTwoStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier3_failed_second_mission")
				else
					return convoTemplate:getScreen("tier3_second_mission")
				end
			-- Player is ready for first mission, so either was not given it after training first box or failed
			elseif (not t3QuestOneComplete) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier3_failed_first_mission")
				else
					return convoTemplate:getScreen("tier3_first_mission")
				end
			end
		end

		return convoTemplate:getScreen("tier3_on_mission")
	end

	--[[
			Tier 2 (Kaydine-pattern dispatch; XP-gated training)
	--]]

	if (ghost:getPilotTier() >= 2) then
		-- Quest one chains a completion side quest carrying the same questName under
		-- type destroy_surpriseattack; that chain terminal is the real completion marker.
		local T2_SIDE_1 = { type = "destroy_surpriseattack", name = "tatooine_privateer_tier2_1" }

		local t2QuestOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name) or
								SpaceHelpers:isSpaceQuestActive(pPlayer, T2_SIDE_1.type, T2_SIDE_1.name)
		local t2QuestTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name)
		local t2QuestThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name)
		local t2QuestFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name)

		local t2QuestOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, T2_SIDE_1.type, T2_SIDE_1.name)
		local t2QuestTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name)
		local t2QuestThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name)

		local t2DestroyDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.name)
		local t2RecoveryDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.name)
		local t2EscortDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.name)

		local t2DestroyDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_1.name)
		local t2RecoveryDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_2.name)
		local t2EscortDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_DUTY_3.name)

		local completedTier2 = SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 2)

		-- Player has an active tier 2 mission from Dravis
		if ((t2QuestOneStarted and not t2QuestOneComplete) or (t2QuestTwoStarted and not t2QuestTwoComplete) or (t2QuestThreeStarted and not t2QuestThreeComplete) or (t2QuestFourStarted and not t2QuestFourComplete) or
			(t2DestroyDutyStarted and not t2DestroyDutyComplete) or (t2RecoveryDutyStarted and not t2RecoveryDutyComplete) or (t2EscortDutyStarted and not t2EscortDutyComplete)) then

			return convoTemplate:getScreen("tier2_on_mission")

		-- Check if players have all the tier2 skill boxes and finished the last mission, then move them on.
		elseif (t2QuestFourComplete and completedTier2) then
			-- Player has all the skill boxes, they should be tier 3. Increment if not proper
			if (ghost:getPilotTier() <= 2) then
				ghost:incrementPilotTier()
			end
			SpaceHelpers:addBeissaWaypoint(pPlayer)

			return convoTemplate:getScreen("tier2_completed_kaydine")
		-- Reward Checks
		elseif (t2QuestFourComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier2_complete_fourth_mission")
		elseif (t2QuestThreeComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier2_complete_third_mission")
		elseif (t2QuestTwoComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier2_complete_second_mission")
		elseif (t2QuestOneComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward") ~= "1") then
			return convoTemplate:getScreen("tier2_complete_first_mission")
		-- Pilot is able to train
		elseif (not completedTier2 and SpaceHelpers:hasExperienceForTraining(pPlayer, 2)) then
			return convoTemplate:getScreen("tier2_ready_train_pilot")
		elseif (not t2QuestFourComplete) then
			-- Player is able to start fourth mission
			if (t2QuestThreeComplete and not t2QuestFourStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier2_failed_fourth_mission")
				else
					return convoTemplate:getScreen("tier2_fourth_mission")
				end
			-- Player is able to start third mission
			elseif (t2QuestTwoComplete and not t2QuestThreeStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier2_failed_third_mission")
				else
					return convoTemplate:getScreen("tier2_third_mission")
				end
			-- Player is able to start second mission
			elseif (t2QuestOneComplete and not t2QuestTwoStarted) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier2_failed_second_mission")
				else
					return convoTemplate:getScreen("tier2_second_mission")
				end
			-- Player is ready for first mission
			elseif (not t2QuestOneComplete and SpaceHelpers:hasPilotTierSkill(pPlayer, "neutral", 2)) then
				if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted") == "1") then
					return convoTemplate:getScreen("tier2_failed_first_mission")
				else
					return convoTemplate:getScreen("tier2_first_mission")
				end
			end
		end

		return convoTemplate:getScreen("tier2_here_for_work")
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
	elseif (getQuestStatus(playerID .. "SmugglerSquadronScreenplay:dravis_finished") == "1") then
		return convoTemplate:getScreen("go_to_next")
	-- Check if players have all the tier1 skill boxes, send them to next trainer.
	elseif (SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 1)) then
		return convoTemplate:getScreen("completed_sinkko")
	-- Player is not a member of the Imperial Faction
	elseif (faction ~= FACTIONNEUTRAL) then
		return convoTemplate:getScreen("recruitment_not_imperial")
	-- Player is an Inquisition pilot and has at least one of the Tier1 skill boxes
	elseif (SpaceHelpers:hasPilotTierSkill(pPlayer, "neutral", 1)) then
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
		if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_4.name .. ":reward") ~= "1") then
			-- Give player the reward and update that they received it
			setQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_4.name .. ":reward", 1)

			-- Grant Reward
			assassinate_tatooine_privateer_4:rewardPlayer(pPlayer)

		end

		return convoTemplate:getScreen("missions_complete")
	-- Player has attempted quest 4 but failed/aborted
	elseif (getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_4.name .. ":attempted") == "1" and not questFourComplete) then
		return convoTemplate:getScreen("failed_quest4")
	-- Player has finished 3, has received the reward and needs to start quest 4
	elseif (questThreeComplete and not questFourStarted and getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_3.name .. ":reward") == "1") then
		return convoTemplate:getScreen("grant_quest4")
	-- Player has completed quest 3 and needs reward (reward given in runScreenHandlers when they respond)
	elseif (questThreeComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
		return convoTemplate:getScreen("excellent_work3")
	-- Player has attempted quest 3 but failed/aborted
	elseif (getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_3.name .. ":attempted") == "1" and not questThreeComplete) then
		return convoTemplate:getScreen("failed_quest3")
	-- Player has finished 2, has received the reward and needs to start quest 3
	elseif (questTwoComplete and not questThreeStarted and getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_2.name .. ":reward") == "1") then
		return convoTemplate:getScreen("excellent_work2")
	-- Player has completed quest 2 and needs reward
	elseif (questTwoComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_2.name .. ":reward") ~= "1") then
		-- Give player the reward and update that they received it
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_2.name .. ":reward", 1)

		-- Grant Reward
		destroy_tatooine_privateer_2:rewardPlayer(pPlayer)

		return convoTemplate:getScreen("excellent_work2")
	-- Player has attempted quest 2 but failed/aborted
	elseif (getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_2.name .. ":attempted") == "1" and not questTwoComplete) then
		return convoTemplate:getScreen("failed_quest2")
	-- Player has finished quest 1, received reward, needs to start quest 2
	elseif (questOneComplete and not questTwoStarted and getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_1.name .. ":reward") == "1") then
		return convoTemplate:getScreen("grant_quest2")
	-- Player has finished quest 1 and needs to report to Sinkko
	elseif (questOneComplete and getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= "1") then
		return convoTemplate:getScreen("excellent_work")
	-- Player has attempted quest 1 but failed/aborted
	elseif (getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_1.name .. ":attempted") == "1" and not questOneComplete) then
		return convoTemplate:getScreen("failed_quest1")
	-- Player needs to start quest 1
	elseif (not questOneComplete) then
		return convoTemplate:getScreen("yes_ship")
	end

	return convoTemplate:getScreen("no_jtl")
end

function dravisConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_starships_01")) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_3818dc2a", "train_player_fighters_free") -- I am interested in basic fighters.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_weapons_01")) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_3fa70900", "train_player_component_free") -- I am interested in basic starship component use.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_procedures_01")) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_7d57477f", "train_player_basics_free") -- I am interested in basic training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_droid_01")) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_9480f430", "train_player_droid_free") -- I am interested in droid interface basics.
		end
	-- Handle additional training (requires XP)
	elseif (screenID == "more_training") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_starships_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_starships_01")) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_3818dc2a", "train_player_fighters") -- I am interested in basic fighters.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_weapons_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_weapons_01")) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_3fa70900", "train_player_component") -- I am interested in basic starship component use.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_procedures_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_procedures_01")) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_7d57477f", "train_player_basics") -- I am interested in basic training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_droid_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_droid_01")) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_9480f430", "train_player_droid") -- I am interested in droid interface basics.
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
			-- Increment pilot to Tier 2!
			ghost:incrementPilotTier()
		end

		return pClonedScreen
	elseif (screenID == "destroy_duty") then
		destroy_duty_tatooine_privateer_6:startQuest(pPlayer, pNpc)
	elseif (screenID == "escort_duty") then
		escort_duty_tatooine_privateer_7:startQuest(pPlayer, pNpc)
	-- Recruitment flow - confirm entry into the Smuggler Squadron
	elseif (screenID == "yes_join") then
		local convoTemplate = LuaConversationTemplate(pConvTemplate)

		return convoTemplate:getScreen("join_confirm")
	-- Recruitment accepted: grant the neutral pilot novice box and set squadron/tier
	elseif (screenID == "yes_i_am" or screenID == "welcome_navy") then
		-- Grant neutral pilot novice box
		SpaceHelpers:grantNovicePilot(pPlayer, "neutralPilot")

		-- Set Smuggler Squadron
		SpaceHelpers:setSquadronType(pPlayer, SMUGGLER_SQUADRON)

		-- Set pilot tier
		if (ghost:getPilotTier() < 1) then
			ghost:incrementPilotTier()
		end

		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_4358efe9", "no_ship") -- Where is my ship?
		else
			clonedConversation:addOption("@conversation/tatooine_privateer_trainer_1:s_d335136f", "yes_ship") -- Yes I am.
		end
	elseif (screenID == "no_ship") then
		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			-- Grant neutral starter ship
			grantStarterShip(pPlayer, "neutral")
		end
	-- Missions
	elseif (screenID == "yes_im_ready") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Track that quest was attempted
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_1.name .. ":attempted", 1)

		patrol_tatooine_privateer_1:resetQuest(pPlayer)
		patrol_tatooine_privateer_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest1") then
		patrol_tatooine_privateer_1:resetQuest(pPlayer)
		patrol_tatooine_privateer_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest2") then
		destroy_tatooine_privateer_2:resetQuest(pPlayer)
		destroy_tatooine_privateer_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest3") then
		patrol_tatooine_privateer_3:resetQuest(pPlayer)
		patrol_tatooine_privateer_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest4") then
		assassinate_tatooine_privateer_4:resetQuest(pPlayer)
		assassinate_tatooine_privateer_4:startQuest(pPlayer, pNpc)
	-- Quest 1 completion screens - give reward
	elseif (screenID == "i_was_attacked" or screenID == "rebel_ambush" or screenID == "patrol_complete") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Only give reward once
		if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_1.name .. ":reward", 1)

			-- Grant Reward
			patrol_tatooine_privateer_1:rewardPlayer(pPlayer)

		end
	elseif (screenID == "quest2_accepted") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_2.name .. ":attempted", 1)
		destroy_tatooine_privateer_2:resetQuest(pPlayer)
		destroy_tatooine_privateer_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "train_me3") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_3.name .. ":attempted", 1)
		patrol_tatooine_privateer_3:resetQuest(pPlayer)
		patrol_tatooine_privateer_3:startQuest(pPlayer, pNpc)
	-- Quest 3 Rewarded - give reward
	elseif (screenID == "quest3_rewarded") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Only give reward once
		if (getQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_3.name .. ":reward", 1)

			-- Grant Reward
			patrol_tatooine_privateer_3:rewardPlayer(pPlayer)

		end
	-- Quest 4 accepted - start the assassinate mission
	elseif (screenID == "quest4_accepted") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.QUEST_STRING_4.name .. ":attempted", 1)
		assassinate_tatooine_privateer_4:resetQuest(pPlayer)
		assassinate_tatooine_privateer_4:startQuest(pPlayer, pNpc)
	-- Finished: completed all Tier 1 skills, reassigned to Under Inquisitor Fa'Zoll (next trainer)
	elseif (screenID == "directions_to_next" or screenID == "report_to_fazoll") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. "SmugglerSquadronScreenplay:dravis_finished", 1)
		SpaceHelpers:addSmugglerNextWaypoint(pPlayer)
	-- Tier 2 Training (Kaydine-pattern; XP-gated, player-paced)
	elseif (screenID == "tier2_ready_train_pilot") then
		local skillManager = LuaSkillManager()

		local responseString = "tier2_initial_"

		if (SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name)) then
			responseString = "tier2_final_"
		elseif (SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name)) then
			responseString = "tier2_mission4_"
		elseif (SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name)) then
			responseString = "tier2_mission3_"
		elseif (SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.type, SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name)) then
			responseString = "tier2_mission2_"
		end

		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_starships_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_starships_02")) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_2:s_45b71b4d", responseString .. "train_fighters") -- I am interested in advanced fighters.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_weapons_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_weapons_02")) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_2:s_197f4f94", responseString .. "train_components") -- I am interested in intermediate starship component use.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_procedures_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_procedures_02")) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_2:s_8f5942fa", responseString .. "train_techniques") -- I am interested in starship defense training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_droid_02") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_droid_02")) then
			clonedConversation:addOption("@conversation/naboo_privateer_trainer_2:s_eff66f4d", responseString .. "train_algorithms") -- I am interested in reactor engineering algorithms.
		end

	-- Handle Tier 2 Skill box granting
	elseif (string.find(screenID, "tier2_") and string.find(screenID, "_train_")) then
		local skillManager = LuaSkillManager()

		if (string.find(screenID, "train_fighters")) then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_starships_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_starships_02", true)
			end
		elseif (string.find(screenID, "train_components")) then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_weapons_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_weapons_02", true)
			end
		elseif (string.find(screenID, "train_techniques")) then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_procedures_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_procedures_02", true)
			end
		elseif (string.find(screenID, "train_algorithms")) then
			if (skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_neutral_droid_02")) then
				SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_droid_02", true)
			end
		end

		if (ghost:getPilotTier() <= 2 and SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 2)) then
			ghost:incrementPilotTier()
			SpaceHelpers:addBeissaWaypoint(pPlayer)
		end

		return pClonedScreen

	-- Tier 2 Duty Missions
	elseif (screenID == "tier2_accept_duty_destroy1") then
		destroy_duty_tatooine_privateer_tier2_destroyduty:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_accept_duty_escort") then
		escort_duty_tatooine_privateer_tier2_escortduty:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_accept_duty_recovery") then
		recovery_duty_tatooine_privateer_tier2_recoveryduty:startQuest(pPlayer, pNpc)

	-- Tier 2 Mission Rewards
	elseif (screenID == "tier2_fourth_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":reward", 1)
		assassinate_tatooine_privateer_tier2_4:rewardPlayer(pPlayer)
	elseif (screenID == "tier2_turnover_intelligence") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":reward", 1)
		recovery_tatooine_privateer_tier2_3:rewardPlayer(pPlayer)
	elseif (screenID == "tier2_duty_calls" or screenID == "tier2_here_is_pay") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":reward", 1)
		escort_tatooine_privateer_tier2_2:rewardPlayer(pPlayer)
	elseif (screenID == "tier2_according_to_plan" or screenID == "tier2_first_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":reward", 1)
		inspect_tatooine_privateer_tier2_1:rewardPlayer(pPlayer)

	-- Give Tier 2 Missions
	elseif (screenID == "tier2_accept_assassinate" or screenID == "tier2_nonsense" or screenID == "tier2_let_me_know" or screenID == "tier2_report_back_success" or screenID == "tier2_key_to_success" or screenID == "tier2_just_malfunctioned") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_4.name .. ":attempted", 1)
		assassinate_tatooine_privateer_tier2_4:resetQuest(pPlayer)
		assassinate_tatooine_privateer_tier2_4:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_accept_inspect" or screenID == "tier2_on_your_way" or screenID == "tier2_take_it_serious" or screenID == "tier2_bad_liar") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_3.name .. ":attempted", 1)
		recovery_tatooine_privateer_tier2_3:resetQuest(pPlayer)
		recovery_tatooine_privateer_tier2_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_accept_escort" or screenID == "tier2_back_to_escort" or screenID == "tier2_now_is_good" or screenID == "tier2_be_smarter") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_2.name .. ":attempted", 1)
		escort_tatooine_privateer_tier2_2:resetQuest(pPlayer)
		escort_tatooine_privateer_tier2_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier2_start_first_mission" or screenID == "tier2_try_first_mission" or screenID == "tier2_cant_wait_first") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER2_QUEST_STRING_1.name .. ":attempted", 1)
		inspect_tatooine_privateer_tier2_1:resetQuest(pPlayer)
		inspect_tatooine_privateer_tier2_1:startQuest(pPlayer, pNpc)

	-- Tier 3 Training (Dulios-pattern; one skill box per mission, no XP deduction)
	elseif (string.find(screenID, "tier3_complete_mission")) then
		local screenAppend = ""

		if (screenID == "tier3_complete_mission4") then
			screenAppend = "_final"
		end

		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_starships_03")) then
			clonedConversation:addOption("@conversation/naboo_privateer_tier3:s_aa766bd6", "tier3_train_warships" .. screenAppend) -- I want to know about special warships.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_weapons_03")) then
			clonedConversation:addOption("@conversation/naboo_privateer_tier3:s_a70b470e", "tier3_train_components" .. screenAppend) -- I want to know about advanced starship components.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_procedures_03")) then
			clonedConversation:addOption("@conversation/naboo_privateer_tier3:s_da0e8cd0", "tier3_train_techniques" .. screenAppend) -- I want to know about advanced techniques.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_neutral_droid_03")) then
			clonedConversation:addOption("@conversation/naboo_privateer_tier3:s_c28a300f", "tier3_train_programming" .. screenAppend) -- I want to know about system balance programming.
		end

	-- Handle Tier 3 Skill box granting
	elseif (string.find(screenID, "tier3_train_")) then
		if (string.find(screenID, "train_warships")) then
			-- Train player Skill Box
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_starships_03", false)
		elseif (string.find(screenID, "train_components")) then
			-- Train player Skill Box
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_weapons_03", false)
		elseif (string.find(screenID, "train_techniques")) then
			-- Train player Skill Box
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_procedures_03", false)
		elseif (string.find(screenID, "train_programming")) then
			-- Train player Skill Box
			SpaceHelpers:grantSpaceSkill(pPlayer, "pilot_neutral_droid_03", false)
		end

		if (ghost:getPilotTier() <= 3 and SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 3)) then
			-- If player has all of the Tier 3 skills, increment their pilot tier
			ghost:incrementPilotTier()
			SpaceHelpers:addNirameSakuteWaypoint(pPlayer)
		end

	-- Give Tier 3 Missions
	elseif (screenID == "tier3_accept_fourth_mission" or screenID == "tier3_nothing_cant_handle") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_4.name .. ":attempted", 1)

		--	Give fourth mission to player
		assassinate_tatooine_privateer_tier3_4:resetQuest(pPlayer)
		assassinate_tatooine_privateer_tier3_4:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier3_accept_third_mission" or screenID == "tier3_i_was_better") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_3.name .. ":attempted", 1)

		--	Give third mission to player
		delivery_tatooine_privateer_tier3_3:resetQuest(pPlayer)
		delivery_tatooine_privateer_tier3_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier3_accept_second_mission" or screenID == "tier3_stories_about_me") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_2.name .. ":attempted", 1)

		--	Give second mission to player
		inspect_tatooine_privateer_tier3_2:resetQuest(pPlayer)
		inspect_tatooine_privateer_tier3_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "tier3_accept_first_mission" or screenID == "tier3_try_first_again") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER3_QUEST_STRING_1.name .. ":attempted", 1)

		--	Give First mission to player
		recovery_tatooine_privateer_tier3_1:resetQuest(pPlayer)
		recovery_tatooine_privateer_tier3_1:startQuest(pPlayer, pNpc)

	-- Tier 4 Training (Dinge-pattern)
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
			SpaceHelpers:addWillhamBurkeWaypoint(pPlayer)
		end

		-- Either the player is ready to train again or they have all of the missions finished, so send them back to the main screen
		if (SpaceHelpers:hasExperienceForTraining(pPlayer, 4) or
				SpaceHelpers:isSpaceQuestComplete(pPlayer, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.type, SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4_SIDE3.name)) then
			return self:getInitialScreen(pPlayer, pNpc, pConvTemplate)
		end

	-- Tier 4 Duty Missions
	elseif (screenID == "accept_tier4_duty1") then
		destroy_duty_tatooine_privateer_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty2") then
		escort_duty_tatooine_privateer_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty3") then
		recovery_duty_tatooine_privateer_tier4_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_duty4") then
		rescue_duty_tatooine_privateer_tier4_1:startQuest(pPlayer, pNpc)

	-- Tier 4 Mission Rewards
	elseif (screenID == "tier4_fourth_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":reward", 1)
		recovery_tatooine_privateer_tier4_4:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_third_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":reward", 1)
		space_battle_tatooine_privateer_tier4_3:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_second_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":reward", 1)
		assassinate_tatooine_privateer_tier4_2:rewardPlayer(pPlayer)
	elseif (screenID == "tier4_first_mission_success") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":reward", 1)
		survival_tatooine_privateer_tier4_1:rewardPlayer(pPlayer)

	-- Give Tier 4 Missions
	elseif (screenID == "accept_tier4_fourth_mission" or screenID == "failed_tier4_fourth_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_4.name .. ":attempted", 1)

		recovery_tatooine_privateer_tier4_4:resetQuest(pPlayer)
		recovery_tatooine_privateer_tier4_4:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_third_mission" or screenID == "failed_tier4_third_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_3.name .. ":attempted", 1)

		space_battle_tatooine_privateer_tier4_3:resetQuest(pPlayer)
		space_battle_tatooine_privateer_tier4_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_second_mission" or screenID == "failed_tier4_second_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_2.name .. ":attempted", 1)

		assassinate_tatooine_privateer_tier4_2:resetQuest(pPlayer)
		assassinate_tatooine_privateer_tier4_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "accept_tier4_first_mission" or screenID == "failed_tier4_first_mission") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. SmugglerSquadronScreenplay.TIER4_QUEST_STRING_1.name .. ":attempted", 1)

		survival_tatooine_privateer_tier4_1:resetQuest(pPlayer)
		survival_tatooine_privateer_tier4_1:startQuest(pPlayer, pNpc)

	-- Tier 5 hand-off to Admiral Burke. Burke owns both finale mission starts.
	elseif (screenID == "accept_master_mission") then
		-- Player must hold the full tier 4 pilot training before the master hand-off;
		-- pilot_neutral_master is granted inside the Kessel screenplay, never here.
		if (SpaceHelpers:hasCompletedPilotTier(pPlayer, "neutral", 4)) then
			local playerID = CreatureObject(pPlayer):getObjectID()
			setQuestStatus(playerID .. "SmugglerSquadronScreenplay:reportToBurke", 1)
			SpaceHelpers:addWillhamBurkeWaypoint(pPlayer)
		end
	end

	return pClonedScreen
end
