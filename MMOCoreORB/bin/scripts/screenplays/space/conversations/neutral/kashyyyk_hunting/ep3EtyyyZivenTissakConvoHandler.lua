--[[
	Ziven Tissak -- the ground giver for the three Kashyyyk hunting quest heads that had no giver:

		rescue/ep3_hunting_ziven_fordans_ship                   (head, questZone space_kashyyyk)
		assassinate/ep3_hunting_ziven_vs_sordaans_freighter_01  (head, questZone space_kashyyyk)
		assassinate/ep3_hunting_ziven_vs_sordaans_freighter_02  (questZone space_kashyyyk)

	All three globals live in screenplays/space/squadrons/KashyyykHuntingScreenplay.lua (443/503,
	505/544, 546/585). That file is included by screenplays/space/screenplays.lua before this one, so
	all three globals are loaded by the time this handler runs.

	None of the three declares a sideQuest, so nothing hands any of them out on its own. freighter_02
	declares parentQuest = freighter_01, but that field is a fail-cascade only
	(SpaceAssassinateScreenplay.lua:121-122 fails the parent when the child fails) -- it is not a gate
	and it does not start anything. The ordering is enforced here instead, matching s_761 "Once you
	succeeded in that, we'll give you the location of the second freighter."

	This arc is the other half of Banol Starkiller's. Banol's recovery quest leaves Fordan's ship
	stripped at recoveryPoints[3] {3400, 3400, 3200}; Ziven's rescue quest sets rescueLocation to the
	same coordinate. Neither screenplay references the other, so a player can run either side first --
	which is correct, they are rival employers, not a single ladder.

	Ground screens and java OnStartNpcConversation order folded in. ruling 2026-09-04.
	NO JOURNAL: do not call the journal engine.

	alreadyHasSpaceMission is space_quest.hasQuest (any datapad mission), not the hunting-arc list.
]]

Ep3EtyyyZivenTissakConvoHandler = conv_handler:new {}

-- Copied from KashyyykHuntingScreenplay.lua verbatim (questType/questName at 446-447, 508-509, 549-550).
EP3_ZIVEN_FORDAN = {type = "rescue", name = "ep3_hunting_ziven_fordans_ship"}
EP3_ZIVEN_FREIGHTER_1 = {type = "assassinate", name = "ep3_hunting_ziven_vs_sordaans_freighter_01"}
EP3_ZIVEN_FREIGHTER_2 = {type = "assassinate", name = "ep3_hunting_ziven_vs_sordaans_freighter_02"}

EP3_ZIVEN_FORDAN_TAKEN_KEY = ":ep3_ziven:fordan_taken"
EP3_ZIVEN_FREIGHTER_1_TAKEN_KEY = ":ep3_ziven:freighter1_taken"
EP3_ZIVEN_FREIGHTER_2_TAKEN_KEY = ":ep3_ziven:freighter2_taken"

function Ep3EtyyyZivenTissakConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3EtyyyZivenTissakConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- Hand the quest out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). None of the three quest names contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply; the re-check is kept
-- anyway so a refused grant leaves no residue.
function Ep3EtyyyZivenTissakConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3EtyyyZivenTissakConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3EtyyyZivenTissakConvoHandler:alreadyHasSpaceMission(pPlayer)
	return EtyyyHuntState:hasAnySpaceQuest(pPlayer)
end

function Ep3EtyyyZivenTissakConvoHandler:canSpeakWookiee(pPlayer)
	return CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")
end

function Ep3EtyyyZivenTissakConvoHandler:spaceFailedOrTaken(pPlayer, takenKey, quest)
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name) or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)) then
		return false
	end
	return self:getFlag(pPlayer, takenKey) == 1 or EtyyyHuntState:spaceFailed(pPlayer, quest.type, quest.name)
end

function Ep3EtyyyZivenTissakConvoHandler:hasCompletedZivenHunts(pPlayer)
	return huntZivenCollectWebweaverEyesScreenPlay:hasCompletedQuest(pPlayer)
end

function Ep3EtyyyZivenTissakConvoHandler:killedSilkthrower(pPlayer)
	return huntLootSilkthrowerKilledScreenPlay:isQuestActive(pPlayer)
end

function Ep3EtyyyZivenTissakConvoHandler:killedSilkthrowerPlusAll(pPlayer)
	return huntLootBrightclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootPaleclawKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootStonelegKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootSpiketopKilledScreenPlay:hasCompletedQuest(pPlayer) and huntLootGreyclimberKilledScreenPlay:hasCompletedQuest(pPlayer)
end

function Ep3EtyyyZivenTissakConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- ep3_etyyy_ziven_tissak.java OnStartNpcConversation:1365-2029
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_ZIVEN_FREIGHTER_2.type, EP3_ZIVEN_FREIGHTER_2.name)) then
		return convoTemplate:getScreen("s_882")
	elseif (self:spaceFailedOrTaken(pPlayer, EP3_ZIVEN_FREIGHTER_2_TAKEN_KEY, EP3_ZIVEN_FREIGHTER_2)) then
		return convoTemplate:getScreen("s_883")
	elseif (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_ZIVEN_FREIGHTER_2.type, EP3_ZIVEN_FREIGHTER_2.name)) then
		return convoTemplate:getScreen("s_763")
	elseif (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_ZIVEN_FREIGHTER_1.type, EP3_ZIVEN_FREIGHTER_1.name)) then
		return convoTemplate:getScreen("s_764")
	elseif (self:spaceFailedOrTaken(pPlayer, EP3_ZIVEN_FREIGHTER_1_TAKEN_KEY, EP3_ZIVEN_FREIGHTER_1)) then
		return convoTemplate:getScreen("s_875")
	elseif (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_ZIVEN_FREIGHTER_1.type, EP3_ZIVEN_FREIGHTER_1.name)) then
		return convoTemplate:getScreen("s_765")
	elseif (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_ZIVEN_FORDAN.type, EP3_ZIVEN_FORDAN.name)) then
		return convoTemplate:getScreen("s_576")
	elseif (self:spaceFailedOrTaken(pPlayer, EP3_ZIVEN_FORDAN_TAKEN_KEY, EP3_ZIVEN_FORDAN)) then
		return convoTemplate:getScreen("s_575")
	elseif (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_ZIVEN_FORDAN.type, EP3_ZIVEN_FORDAN.name)) then
		return convoTemplate:getScreen("s_748")
	elseif (self:killedSilkthrowerPlusAll(pPlayer) and self:killedSilkthrower(pPlayer)) then
		return convoTemplate:getScreen("s_1763")
	elseif (self:killedSilkthrower(pPlayer)) then
		return convoTemplate:getScreen("s_1769")
	elseif (huntZivenCollectWebweaverEyesScreenPlay:hasCompletedQuest(pPlayer) and SpaceHelpers:isSpaceQuestComplete(pPlayer, "recovery", "ep3_hunting_banol_capture_fordan")) then
		return convoTemplate:getScreen("s_366")
	elseif (self:hasCompletedZivenHunts(pPlayer)) then
		return convoTemplate:getScreen("s_1699")
	elseif (huntZivenCollectWebweaverEyesScreenPlay:isTaskActive(pPlayer, "ziven_webweaverEyes")) then
		return convoTemplate:getScreen("s_1703")
	elseif (huntZivenCollectWebweaverEyesScreenPlay:isTaskActive(pPlayer, "ziven_collectWebweaverEyes")) then
		return convoTemplate:getScreen("s_1715")
	elseif (huntZivenCollectWebweaverFangsScreenPlay:isTaskActive(pPlayer, "ziven_webweaverFangs") or huntZivenCollectWebweaverFangsScreenPlay:hasCompletedQuest(pPlayer)) then
		EtyyyHuntState:raise(pPlayer, "ziven_webweaverFangs")
		return convoTemplate:getScreen("s_1719")
	elseif (huntZivenCollectWebweaverFangsScreenPlay:isTaskActive(pPlayer, "ziven_collectWebweaverFangs")) then
		return convoTemplate:getScreen("s_1731")
	elseif (huntZivenCollectWebweaverFangsScreenPlay:isTaskActive(pPlayer, "ziven_talkToZiven")) then
		if (pNpc ~= nil) then
			CreatureObject(pNpc):doAnimation("greet")
		end
		return convoTemplate:getScreen("s_1735")
	elseif (huntKerssocEnterEtyyyScreenPlay:isTaskActive(pPlayer, "etyyy_talkToZiven")) then
		return convoTemplate:getScreen("s_1747")
	end
	return convoTemplate:getScreen("s_1759")
end

function Ep3EtyyyZivenTissakConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "s_1763") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedSilkthrower")
		huntLootCompletedAllScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1769") then
		EtyyyHuntState:raise(pPlayer, "lootQuest_defeatedSilkthrower")
	elseif (screenID == "s_769") then
		if (self:alreadyHasSpaceMission(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_768")
		end
		SpaceHelpers:clearSpaceQuest(pPlayer, "assassinate", "ep3_hunting_ziven_vs_sordaans_freighter_02", false)
		EtyyyHuntState:grantSpace(pPlayer, pNpc, assassinate_ep3_hunting_ziven_vs_sordaans_freighter_02, "assassinate", "ep3_hunting_ziven_vs_sordaans_freighter_02")
		self:setFlag(pPlayer, EP3_ZIVEN_FREIGHTER_2_TAKEN_KEY, 1)
	elseif (screenID == "s_761") then
		if (self:alreadyHasSpaceMission(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_760")
		end
		SpaceHelpers:clearSpaceQuest(pPlayer, "assassinate", "ep3_hunting_ziven_vs_sordaans_freighter_01", false)
		EtyyyHuntState:grantSpace(pPlayer, pNpc, assassinate_ep3_hunting_ziven_vs_sordaans_freighter_01, "assassinate", "ep3_hunting_ziven_vs_sordaans_freighter_01")
		self:setFlag(pPlayer, EP3_ZIVEN_FREIGHTER_1_TAKEN_KEY, 1)
	elseif (screenID == "s_580") then
		if (self:alreadyHasSpaceMission(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_747")
		end
		SpaceHelpers:clearSpaceQuest(pPlayer, "rescue", "ep3_hunting_ziven_fordans_ship", false)
		EtyyyHuntState:grantSpace(pPlayer, pNpc, rescue_ep3_hunting_ziven_fordans_ship, "rescue", "ep3_hunting_ziven_fordans_ship")
		self:setFlag(pPlayer, EP3_ZIVEN_FORDAN_TAKEN_KEY, 1)
	elseif (screenID == "s_573") then
		if (self:alreadyHasSpaceMission(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("s_745")
		end
		SpaceHelpers:clearSpaceQuest(pPlayer, "rescue", "ep3_hunting_ziven_fordans_ship", false)
		EtyyyHuntState:grantSpace(pPlayer, pNpc, rescue_ep3_hunting_ziven_fordans_ship, "rescue", "ep3_hunting_ziven_fordans_ship")
		self:setFlag(pPlayer, EP3_ZIVEN_FORDAN_TAKEN_KEY, 1)
	elseif (screenID == "s_1707") then
		EtyyyHuntState:raise(pPlayer, "ziven_webweaverEyes")
		EtyyyHuntState:raise(pPlayer, "sordaan_zivenSendsYou")
		huntSordaanSeekSordaanScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1723") then
		huntZivenCollectWebweaverEyesScreenPlay:grantQuest(pPlayer)
	elseif (screenID == "s_1739") then
		EtyyyHuntState:raise(pPlayer, "ziven_talkToZiven")
	elseif (screenID == "s_1751") then
		EtyyyHuntState:raise(pPlayer, "etyyy_talkToZiven")
		if (huntTuwezzKillDiseasedUllersScreenPlay:canGrantQuest(pPlayer)) then
			huntTuwezzKillDiseasedUllersScreenPlay:grantQuest(pPlayer)
		end
	-- THE RESCUE GRANT / RE-GRANT.
	elseif (screenID == "ep3_ziven_fordan_accept" or screenID == "ep3_ziven_fordan_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_ziven_no_space")
		end

		if (self:grant(pPlayer, pNpc, rescue_ep3_hunting_ziven_fordans_ship, EP3_ZIVEN_FORDAN)) then
			self:setFlag(pPlayer, EP3_ZIVEN_FORDAN_TAKEN_KEY, 1)
		end

	-- THE FIRST FREIGHTER GRANT / RE-GRANT.
	elseif (screenID == "ep3_ziven_freighter1_accept" or screenID == "ep3_ziven_freighter1_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_ziven_no_space")
		end

		if (self:grant(pPlayer, pNpc, assassinate_ep3_hunting_ziven_vs_sordaans_freighter_01, EP3_ZIVEN_FREIGHTER_1)) then
			self:setFlag(pPlayer, EP3_ZIVEN_FREIGHTER_1_TAKEN_KEY, 1)
		end

	-- THE SECOND FREIGHTER GRANT / RE-GRANT.
	elseif (screenID == "ep3_ziven_freighter2_accept" or screenID == "ep3_ziven_freighter2_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_ziven_no_space")
		end

		if (self:grant(pPlayer, pNpc, assassinate_ep3_hunting_ziven_vs_sordaans_freighter_02, EP3_ZIVEN_FREIGHTER_2)) then
			self:setFlag(pPlayer, EP3_ZIVEN_FREIGHTER_2_TAKEN_KEY, 1)
		end
	end

	return pScreenClone
end
