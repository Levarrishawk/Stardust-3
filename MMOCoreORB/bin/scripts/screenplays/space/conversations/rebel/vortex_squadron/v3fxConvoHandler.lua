local SpaceHelpers = require("utils.space_helpers")

--[[
	V3-FX (droid) -- Vortex Squadron (Rebel) Tier 1 recruiter/trainer.
	Control-flow port of the proven Inquisition/Havoc recruiter handler, swapping:
		imperial -> rebel, imperial_navy -> rebel_navy,
		HavocSquadronScreenplay -> VortexSquadronScreenplay,
		HAVOC_SQUADRON -> VORTEX_SQUADRON,
		corellia_rebel_* quests -> naboo_rebel_* quests,
		@conversation/naboo_imperial_trainer_1 -> @conversation/naboo_rebel_trainer_1 (real Live STF).
	All gating mechanisms (incrementPilotTier on hasCompletedPilotTier, reward-once status keys,
	faction standing) are the same Live mechanisms used by the template.
]]

v3fxConvoHandler = conv_handler:new {}

function v3fxConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	local questOneStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, VortexSquadronScreenplay.QUEST_STRING_1.type, VortexSquadronScreenplay.QUEST_STRING_1.name)
	local questTwoStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, VortexSquadronScreenplay.QUEST_STRING_2.type, VortexSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, VortexSquadronScreenplay.QUEST_STRING_3.type, VortexSquadronScreenplay.QUEST_STRING_3.name)
	local questFourStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, VortexSquadronScreenplay.QUEST_STRING_4.type, VortexSquadronScreenplay.QUEST_STRING_4.name)

	local questOneComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_1.type, VortexSquadronScreenplay.QUEST_STRING_1.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_1_SIDE.type, VortexSquadronScreenplay.QUEST_STRING_1_SIDE.name)
	local questTwoComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_2.type, VortexSquadronScreenplay.QUEST_STRING_2.name)
	local questThreeComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_3.type, VortexSquadronScreenplay.QUEST_STRING_3.name) and SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_3_SIDE.type, VortexSquadronScreenplay.QUEST_STRING_3_SIDE.name)
	local questFourComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_4.type, VortexSquadronScreenplay.QUEST_STRING_4.name)

	local destroyDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, VortexSquadronScreenplay.QUEST_STRING_DUTY_1.type, VortexSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local escortDutyStarted = SpaceHelpers:isSpaceQuestActive(pPlayer, VortexSquadronScreenplay.QUEST_STRING_DUTY_2.type, VortexSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	local destroyDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_DUTY_1.type, VortexSquadronScreenplay.QUEST_STRING_DUTY_1.name)
	local escortDutyComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, VortexSquadronScreenplay.QUEST_STRING_DUTY_2.type, VortexSquadronScreenplay.QUEST_STRING_DUTY_2.name)

	-- Player is an Imperial Pilot but a different squadron
	if (isRebelPilot and not SpaceHelpers:isVortexSquadron(pPlayer)) then
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
			Quests
	--]]

	-- Player has an active quest from Sinkko
	if ((questTwoStarted and not questTwoComplete) or (questThreeStarted and not questThreeComplete) or (questFourStarted and not questFourComplete) or (destroyDutyStarted and not destroyDutyComplete) or (escortDutyStarted and not escortDutyComplete)) then
		return convoTemplate:getScreen("has_mission")
	-- Player has first quest active, the mission giver will offer assistance
	elseif (questOneStarted and not questOneComplete) then
		return convoTemplate:getScreen("first_quest_active")
	-- Player has already finished and been sent to the next trainer
	elseif (getQuestStatus(playerID .. "VortexSquadronScreenplay:v3fx_finished") == "1") then
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
		if (getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_4.name .. ":reward") ~= "1") then
			-- Give player the reward and update that they received it
			setQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_4.name .. ":reward", 1)

			-- Grant Reward
			assassinate_naboo_rebel_4:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			ghost:increaseFactionStanding("rebel", 75)
		end

		return convoTemplate:getScreen("missions_complete")
	-- Player has attempted quest 4 but failed/aborted
	elseif (getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_4.name .. ":attempted") == "1" and not questFourComplete) then
		return convoTemplate:getScreen("failed_quest4")
	-- Player has finished 3, has received the reward and needs to start quest 4
	elseif (questThreeComplete and not questFourStarted and getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_3.name .. ":reward") == "1") then
		return convoTemplate:getScreen("grant_quest4")
	-- Player has completed quest 3 and needs reward (reward given in runScreenHandlers when they respond)
	elseif (questThreeComplete and getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
		return convoTemplate:getScreen("excellent_work3")
	-- Player has attempted quest 3 but failed/aborted
	elseif (getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_3.name .. ":attempted") == "1" and not questThreeComplete) then
		return convoTemplate:getScreen("failed_quest3")
	-- Player has finished 2, has received the reward and needs to start quest 3
	elseif (questTwoComplete and not questThreeStarted and getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_2.name .. ":reward") == "1") then
		return convoTemplate:getScreen("excellent_work2")
	-- Player has completed quest 2 and needs reward
	elseif (questTwoComplete and getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_2.name .. ":reward") ~= "1") then
		-- Give player the reward and update that they received it
		setQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_2.name .. ":reward", 1)

		-- Grant Reward
		destroy_naboo_rebel_2:rewardPlayer(pPlayer)

		-- Grant Faction Standing
		ghost:increaseFactionStanding("rebel", 50)

		return convoTemplate:getScreen("excellent_work2")
	-- Player has attempted quest 2 but failed/aborted
	elseif (getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_2.name .. ":attempted") == "1" and not questTwoComplete) then
		return convoTemplate:getScreen("failed_quest2")
	-- Player has finished quest 1, received reward, needs to start quest 2
	elseif (questOneComplete and not questTwoStarted and getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_1.name .. ":reward") == "1") then
		return convoTemplate:getScreen("grant_quest2")
	-- Player has finished quest 1 and needs to report to Sinkko
	elseif (questOneComplete and getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= "1") then
		return convoTemplate:getScreen("excellent_work")
	-- Player has attempted quest 1 but failed/aborted
	elseif (getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_1.name .. ":attempted") == "1" and not questOneComplete) then
		return convoTemplate:getScreen("failed_quest1")
	-- Player needs to start quest 1
	elseif (not questOneComplete) then
		return convoTemplate:getScreen("yes_ship")
	end

	return convoTemplate:getScreen("no_jtl")
end

function v3fxConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_40f3848e", "train_player_fighters_free") -- I'm interested in space combat training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_weapons_01")) then
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_527c6359", "train_player_component_free") -- I'm interested in equipment.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_procedures_01")) then
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_5e3cf461", "train_player_basics_free") -- I'm interested in Imperial technology.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_droid_01")) then
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_a57e647c", "train_player_droid_free") -- I'm interested in astromech management.
		end
	-- Handle additional training (requires XP)
	elseif (screenID == "more_training") then
		local skillManager = LuaSkillManager()

		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_starships_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_starships_01")) then
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_40f3848e", "train_player_fighters") -- I'm interested in space combat training.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_weapons_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_weapons_01")) then
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_527c6359", "train_player_component") -- I'm interested in equipment.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_procedures_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_procedures_01")) then
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_5e3cf461", "train_player_basics") -- I'm interested in Imperial technology.
		end
		if (not CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_droid_01") and skillManager:fulfillsSkillPrerequisitesAndXp(pPlayer, "pilot_rebel_navy_droid_01")) then
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_a57e647c", "train_player_droid") -- I'm interested in astromech management.
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
		destroy_duty_naboo_rebel_6:startQuest(pPlayer, pNpc)
	elseif (screenID == "escort_duty") then
		escort_duty_naboo_rebel_7:startQuest(pPlayer, pNpc)
	-- Recruitment flow - confirm enlistment into the Imperial Navy
	elseif (screenID == "yes_join") then
		local convoTemplate = LuaConversationTemplate(pConvTemplate)

		return convoTemplate:getScreen("join_confirm")
	-- Enlistment accepted: grant Imperial pilot novice box + set squadron + tier
	elseif (screenID == "yes_i_am" or screenID == "welcome_navy") then
		-- Grant imperial pilot novice box
		SpaceHelpers:grantNovicePilot(pPlayer, "rebelPilot")

		-- Sets Inquisition Squadron
		SpaceHelpers:setSquadronType(pPlayer, VORTEX_SQUADRON)

		-- Set pilot tier
		if (ghost:getPilotTier() < 1) then
			ghost:incrementPilotTier()
		end

		if (not SpaceHelpers:hasCertifiedShip(pPlayer, true)) then
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_4358efe9", "no_ship") -- Where is my ship?
		else
			clonedConversation:addOption("@conversation/naboo_rebel_trainer_1:s_729d0338", "yes_ship") -- Thank you, Sir.
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
		setQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_1.name .. ":attempted", 1)

		patrol_naboo_rebel_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest1") then
		patrol_naboo_rebel_1:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest2") then
		destroy_naboo_rebel_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest3") then
		patrol_naboo_rebel_3:startQuest(pPlayer, pNpc)
	elseif (screenID == "retry_quest4") then
		assassinate_naboo_rebel_4:startQuest(pPlayer, pNpc)
	-- Quest 1 completion screens - give reward
	elseif (screenID == "i_was_attacked" or screenID == "rebel_ambush" or screenID == "patrol_complete") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Only give reward once
		if (getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_1.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_1.name .. ":reward", 1)

			-- Grant Reward
			patrol_naboo_rebel_1:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			PlayerObject(pGhost):increaseFactionStanding("rebel", 25)
		end
	elseif (screenID == "quest2_accepted") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_2.name .. ":attempted", 1)
		destroy_naboo_rebel_2:startQuest(pPlayer, pNpc)
	elseif (screenID == "train_me3") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_3.name .. ":attempted", 1)
		patrol_naboo_rebel_3:startQuest(pPlayer, pNpc)
	-- Quest 3 Rewarded - give reward
	elseif (screenID == "quest3_rewarded") then
		local playerID = CreatureObject(pPlayer):getObjectID()

		-- Only give reward once
		if (getQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_3.name .. ":reward") ~= "1") then
			setQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_3.name .. ":reward", 1)

			-- Grant Reward
			patrol_naboo_rebel_3:rewardPlayer(pPlayer)

			-- Grant Faction Standing
			PlayerObject(pGhost):increaseFactionStanding("rebel", 50)
		end
	-- Quest 4 accepted - start the assassinate mission
	elseif (screenID == "quest4_accepted") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. VortexSquadronScreenplay.QUEST_STRING_4.name .. ":attempted", 1)
		assassinate_naboo_rebel_4:startQuest(pPlayer, pNpc)
	-- Finished: completed all Tier 1 skills, reassigned to Under Inquisitor Fa'Zoll (next trainer)
	elseif (screenID == "directions_to_next" or screenID == "report_to_fazoll") then
		local playerID = CreatureObject(pPlayer):getObjectID()
		setQuestStatus(playerID .. "VortexSquadronScreenplay:v3fx_finished", 1)
		SpaceHelpers:addVortexNextWaypoint(pPlayer)
	end

	return pClonedScreen
end
