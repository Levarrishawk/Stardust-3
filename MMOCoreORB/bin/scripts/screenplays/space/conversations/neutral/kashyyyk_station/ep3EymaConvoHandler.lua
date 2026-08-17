--[[
	Eyma -- the ground giver for the four Kashyyyk station-file quest heads that had no giver:

		escort/ep3_kash_station_escort_ghrag                (questZone space_kashyyyk)
		assassinate/ep3_kash_station_assassinate_imperial   (questZone space_kashyyyk)
		assassinate/ep3_kash_station_assassinate_rebel      (questZone space_kashyyyk)
		assassinate/ep3_kash_station_assassinate_neutral    (questZone space_kashyyyk)

	All four globals live in screenplays/space/squadrons/KashyyykStationScreenplay.lua (lines 124, 433,
	389 and 473; className/questName/questType directly beneath each). That file is included by
	screenplays/space/screenplays.lua before this one, so the globals are loaded by the time this
	handler runs.

	Before this file nothing in the repo handed any of the four out. None of them is named as a
	sideQuest anywhere, so nothing chained them either.

	ORDERING IS ENFORCED HERE, NOT BY parentQuest. All three assassinates declare
	parentQuest = "escort_ep3_kash_station_escort_ghrag", but every Space*Screenplay uses parentQuest
	only as a fail-cascade (createEvent(200, ..., "failQuest", ...)); it starts nothing and gates
	nothing. The client's own ordering is enforced in getInitialScreen: the dealer briefing is not
	offered until the escort is COMPLETE, because the dealer intel comes from the escorted defector --
	s_347 "The ex-mercenary that you escorted out of Kashyyyk space has provided us with detailed
	tactical information", s_363 "According to our friend the ex-Ghrag...".

	THE FACTION SPLIT IS THE CLIENT'S. The stf ships three complete weapons-dealer briefings and names
	the faction in each (s_355 Imperial pilot / s_373 Rebel pilot / s_423 neither, "you have been
	talking to Rian Ry and myself"); the screenplay ships three matching quests. The test used here is
	TangibleObject(pPlayer):isImperial() / :isRebel(), the same test the sibling files
	spacestation_kash_imperial_conv_handler.lua:201-205 and
	spacestation_kash_rebel_conv_handler.lua:172-176 already use.

	HOW THE ROUTING WORKS. A ConvoScreen option can name only one destination, so the two branch
	points in the convo file (s_349 out of the escort debrief, s_311 out of the final screen, plus
	s_422 out of the failure re-offer) declare the NEUTRAL screen as their target and this handler
	swaps in the Imperial or Rebel screen before it is shown. That is the same mechanism the flight
	gate uses.

	FLAGGED INTERPRETATION -- FAILURE DETECTION. SpaceEscortScreenplay/SpaceAssassinateScreenplay clear
	the quest on failure, so "failed" is not directly observable. It is inferred the same way it is in
	Ep3MiningCaptainKohConvoHandler: a TAKEN latch is written at grant time, and a player who is
	latched but is neither active nor complete has lost it. The latches below are the only state this
	handler keeps.

	FLAGGED INTERPRETATION -- THE MET LATCH. s_652 "Greetings kind spirit" is a first meeting and s_470
	"It is good to see you again!" is not; the client distinguishes them but ships no flag. MET is
	latched the first time the greeting is shown.

	FLAGGED INTERPRETATION -- THE FLIGHT GATE. Every accept point re-checks JTL / pilot / certified
	ship and deflects to s_679 ("I suggest you contact Rian Ry at the Kashyyyk space station") rather
	than granting. The text is client fact; the trigger is not.

	NOT GIVEN HERE, ON PURPOSE. Eyma's stf also carries the civilian-rescue arc and the
	tactical-situation debrief that unlocks Rian's duty contracts. Both of those quest families already
	have a giver in screenplays/space/spacestations/spacestation_kashyyyk_conv_handler.lua, so they are
	enumerated in the convo file's UNUSED list rather than double-issued.

	REACHABILITY, STATED PLAINLY. ep3_eyma is not spawned anywhere in this repo, there are no Kashyyyk
	ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only SpaceZonesEnabled
	has "space_kashyyyk"). This handler is correct and inert until all three of those are addressed.
]]

Ep3EymaConvoHandler = conv_handler:new {}

-- Copied from KashyyykStationScreenplay.lua verbatim.
EP3_EYMA_ESCORT = {type = "escort", name = "ep3_kash_station_escort_ghrag"}
EP3_EYMA_DEALER_IMPERIAL = {type = "assassinate", name = "ep3_kash_station_assassinate_imperial"}
EP3_EYMA_DEALER_REBEL = {type = "assassinate", name = "ep3_kash_station_assassinate_rebel"}
EP3_EYMA_DEALER_NEUTRAL = {type = "assassinate", name = "ep3_kash_station_assassinate_neutral"}

EP3_EYMA_MET_KEY = ":ep3_eyma:met"
EP3_EYMA_ESCORT_TAKEN_KEY = ":ep3_eyma:escort_taken"
EP3_EYMA_DEALER_TAKEN_KEY = ":ep3_eyma:dealer_taken"

function Ep3EymaConvoHandler:getFlag(pPlayer, key)
	if (pPlayer == nil) then
		return false
	end

	return readData(SceneObject(pPlayer):getObjectID() .. key) == 1
end

function Ep3EymaConvoHandler:setFlag(pPlayer, key)
	if (pPlayer == nil) then
		return
	end

	writeData(SceneObject(pPlayer):getObjectID() .. key, 1)
end

function Ep3EymaConvoHandler:clearFlag(pPlayer, key)
	if (pPlayer == nil) then
		return
	end

	deleteData(SceneObject(pPlayer):getObjectID() .. key)
end

-- Which of the three assassinate variants this player is on. The client ships one briefing per
-- faction and the screenplay ships one quest per faction; this is the only place that choice is made.
function Ep3EymaConvoHandler:getDealerQuest(pPlayer)
	if (pPlayer == nil) then
		return EP3_EYMA_DEALER_NEUTRAL
	end

	if (TangibleObject(pPlayer):isImperial()) then
		return EP3_EYMA_DEALER_IMPERIAL
	end

	if (TangibleObject(pPlayer):isRebel()) then
		return EP3_EYMA_DEALER_REBEL
	end

	return EP3_EYMA_DEALER_NEUTRAL
end

function Ep3EymaConvoHandler:getDealerScreenplay(pPlayer)
	local quest = self:getDealerQuest(pPlayer)

	if (quest == EP3_EYMA_DEALER_IMPERIAL) then
		return assassinate_ep3_kash_station_assassinate_imperial
	end

	if (quest == EP3_EYMA_DEALER_REBEL) then
		return assassinate_ep3_kash_station_assassinate_rebel
	end

	return assassinate_ep3_kash_station_assassinate_neutral
end

-- The briefing screen this player should be shown, given their faction.
function Ep3EymaConvoHandler:getDealerOfferID(pPlayer)
	local quest = self:getDealerQuest(pPlayer)

	if (quest == EP3_EYMA_DEALER_IMPERIAL) then
		return "ep3_eyma_imperial_offer"
	end

	if (quest == EP3_EYMA_DEALER_REBEL) then
		return "ep3_eyma_rebel_offer"
	end

	return "ep3_eyma_neutral_offer"
end

-- The closing screen this player should be shown, given their faction.
function Ep3EymaConvoHandler:getMoreScreenID(pPlayer)
	local quest = self:getDealerQuest(pPlayer)

	if (quest == EP3_EYMA_DEALER_IMPERIAL) then
		return "ep3_eyma_more_imperial"
	end

	if (quest == EP3_EYMA_DEALER_REBEL) then
		return "ep3_eyma_more_rebel"
	end

	return "ep3_eyma_more_neutral"
end

-- Hand the quest out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). None of these four names contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply; the re-check is kept
-- anyway so a refused grant leaves no residue.
function Ep3EymaConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3EymaConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3EymaConvoHandler:isActive(pPlayer, quest)
	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
end

function Ep3EymaConvoHandler:isComplete(pPlayer, quest)
	return SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3EymaConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local dealer = self:getDealerQuest(pPlayer)

	-- The dealer contract, deepest first.
	if (self:isActive(pPlayer, dealer)) then
		return convoTemplate:getScreen("ep3_eyma_dealer_active")
	end

	if (self:isComplete(pPlayer, dealer)) then
		return convoTemplate:getScreen("ep3_eyma_dealer_done")
	end

	if (self:getFlag(pPlayer, EP3_EYMA_DEALER_TAKEN_KEY)) then
		return convoTemplate:getScreen("ep3_eyma_dealer_failed")
	end

	-- The escort.
	if (self:isActive(pPlayer, EP3_EYMA_ESCORT)) then
		return convoTemplate:getScreen("ep3_eyma_escort_active")
	end

	if (self:isComplete(pPlayer, EP3_EYMA_ESCORT)) then
		return convoTemplate:getScreen("ep3_eyma_escort_done")
	end

	if (self:getFlag(pPlayer, EP3_EYMA_ESCORT_TAKEN_KEY)) then
		return convoTemplate:getScreen("ep3_eyma_escort_failed")
	end

	if (self:getFlag(pPlayer, EP3_EYMA_MET_KEY)) then
		return convoTemplate:getScreen("ep3_eyma_escort_offer")
	end

	return convoTemplate:getScreen("ep3_eyma_greeting")
end

function Ep3EymaConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (screenID == "ep3_eyma_greeting") then
		self:setFlag(pPlayer, EP3_EYMA_MET_KEY)

	-- Escort grants. s_493 and s_501 are the two shipped endings of the same pitch; s_286 is the
	-- shipped ending of the retry pitch.
	elseif (screenID == "ep3_eyma_escort_accept"
		or screenID == "ep3_eyma_escort_accept_fast"
		or screenID == "ep3_eyma_escort_retry") then
		if (not self:canFly(pPlayer)) then
			return convoTemplate:getScreen("ep3_eyma_see_rian")
		end

		if (self:grant(pPlayer, pNpc, escort_ep3_kash_station_escort_ghrag, EP3_EYMA_ESCORT)) then
			self:setFlag(pPlayer, EP3_EYMA_ESCORT_TAKEN_KEY)
		end

	-- Faction routing. See the header.
	elseif (screenID == "ep3_eyma_neutral_offer") then
		local wanted = self:getDealerOfferID(pPlayer)

		if (wanted ~= "ep3_eyma_neutral_offer") then
			return convoTemplate:getScreen(wanted)
		end

	elseif (screenID == "ep3_eyma_more_neutral") then
		local wanted = self:getMoreScreenID(pPlayer)

		if (wanted ~= "ep3_eyma_more_neutral") then
			return convoTemplate:getScreen(wanted)
		end

	-- Dealer grants. Each faction ships more than one route to the same ending, so every shipped
	-- ending is listed.
	elseif (screenID == "ep3_eyma_imperial_accept"
		or screenID == "ep3_eyma_rebel_accept"
		or screenID == "ep3_eyma_rebel_coy_accept"
		or screenID == "ep3_eyma_rebel_denial_accept"
		or screenID == "ep3_eyma_neutral_accept"
		or screenID == "ep3_eyma_neutral_rian_accept") then
		if (not self:canFly(pPlayer)) then
			return convoTemplate:getScreen("ep3_eyma_see_rian")
		end

		local dealer = self:getDealerQuest(pPlayer)

		if (self:grant(pPlayer, pNpc, self:getDealerScreenplay(pPlayer), dealer)) then
			self:setFlag(pPlayer, EP3_EYMA_DEALER_TAKEN_KEY)
		end
	end

	return pScreenClone
end
