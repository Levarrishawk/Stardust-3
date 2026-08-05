--[[
	Captain Koh -- the ground giver for the five mining quest heads that had no giver:

		space_mining_destroy/kashyyyk_mining_quest_5   "Extract 500 Units of Organometallic Asteroid"
		convoy/kashyyyk_mining_quest_11                "Protect the Y-8 Convoy"
		assassinate/kashyyyk_mining_quest_12           "Intercept the Gilded Wookiee"
		space_mining_destroy/kashyyyk_mining_quest_8   "Broad Sample Part I"
		space_mining_destroy/kessel_mining_quest_13    "Kessel System:  Space Diamonds"

	The first four globals live in screenplays/space/squadrons/KashyyykMiningScreenplay.lua and are
	registered there:

		space_mining_destroy_kashyyyk_mining_quest_5   global line 31,  registerScreenPlay line 65
		space_mining_destroy_kashyyyk_mining_quest_8    global line 76,  registerScreenPlay line 109
		convoy_kashyyyk_mining_quest_11                global line 118, registerScreenPlay line 173
		assassinate_kashyyyk_mining_quest_12           global line 181, registerScreenPlay line 222

	The fifth lives in screenplays/space/squadrons/KesselDutyScreenplay.lua, because its questZone is
	space_light1 (the Kessel System) and not space_kashyyyk:

		space_mining_destroy_kessel_mining_quest_13    global line 178, registerScreenPlay line 215

	Both files are included by screenplays/space/screenplays.lua before this one -- KesselDutyScreenplay
	at line 31, KashyyykMiningScreenplay at line 60, this handler at line 137 -- so all five globals are
	loaded by the time this handler runs. In any case every reference below is inside a function body,
	so it resolves at call time, not at load time.

	Before this file nothing in the repo handed any of the five out. None of them declares a sideQuest
	and none declares a parentQuest, so nothing chained them either. quest_11 appeared elsewhere in the
	repo only inside a comment in SpaceConvoyScreenplay.lua, which starts nothing.

	THE ORDER IS ENFORCED HERE, NOT BY THE SCREENPLAYS. The client text fixes the order --
	quest_12's own title_d says it uses "the path you cleared previously for the mining convoy" and
	Koh's s_161 says "Remember clearing a path for that convoy?", which is why the quest_12
	targetPatrols re-use the quest_11 corridor. The screenplays themselves carry no gate: parentQuest
	is a fail-cascade only (it fails the parent when the child fails -- see
	SpaceAssassinateScreenplay.lua:121-122) and none of these five even declares one. So the ladder
	quest_5 -> quest_11 -> quest_12 -> quest_8 -> quest_13 exists only in this handler's
	getInitialScreen.

	FLAGGED INTERPRETATION -- WHERE quest_8 AND quest_13 SIT. Koh's shipped chain (see the convo file
	header) runs Kashyyyk samples -> a Lok raid -> the Y-8 convoy -> the Gilded Wookiee -> a Corellia
	siphon -> the broad sample -> Kessel -> a Y-8 deed. The Lok and Corellia legs were never shipped as
	quests at all, so this handler collapses the ladder onto the five legs that exist, keeping the
	client's relative order: quest_8 ("Welcome back, pilot") then quest_13 ("This is it pilot.  Your
	big break.") last, exactly as they fall in the .stf key order, with the Y-8 deed hanging off
	quest_13's debrief where the .stf puts it. The relative order is client fact; the collapsing is
	ours.

	FLAGGED INTERPRETATION -- FAILURE DETECTION. SpaceMiningDestroyScreenplay, SpaceConvoyScreenplay
	and SpaceAssassinateScreenplay leave no distinguishable failure record a conversation can read, so
	a per-leg "took it once" latch is written on a successful grant and a leg's failure screen is shown
	to anyone who once accepted that leg and now has it neither active nor complete. That cannot
	separate "failed it" from "abandoned it".

	FLAGGED INTERPRETATION -- s_270 AS THE FLIGHT GATE. See the convo file header. The engine exposes
	no generic "player already holds a space mission" test, so every accept point falls back to
	ep3_koh_no_space when the player plainly cannot fly: JTL off, not a pilot, or no certified ship.

	REACHABILITY, STATED PLAINLY. ep3_mining_captain_koh is not spawned anywhere in this repo, there
	are no Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of those
	are addressed.
]]

Ep3MiningCaptainKohConvoHandler = conv_handler:new {}

-- Copied from KashyyykMiningScreenplay.lua verbatim (questType/questName at 32-33, 77-78, 119-120,
-- 182-183).
EP3_KOH_Q5 = {type = "space_mining_destroy", name = "kashyyyk_mining_quest_5"}
EP3_KOH_Q8 = {type = "space_mining_destroy", name = "kashyyyk_mining_quest_8"}
EP3_KOH_Q11 = {type = "convoy", name = "kashyyyk_mining_quest_11"}
EP3_KOH_Q12 = {type = "assassinate", name = "kashyyyk_mining_quest_12"}
-- Copied from KesselDutyScreenplay.lua verbatim (questName/questType at 181-182).
EP3_KOH_Q13 = {type = "space_mining_destroy", name = "kessel_mining_quest_13"}

EP3_KOH_MET_KEY = ":ep3_koh:met"
EP3_KOH_Q5_TAKEN_KEY = ":ep3_koh:q5_taken"
EP3_KOH_Q8_TAKEN_KEY = ":ep3_koh:q8_taken"
EP3_KOH_Q11_TAKEN_KEY = ":ep3_koh:q11_taken"
EP3_KOH_Q12_TAKEN_KEY = ":ep3_koh:q12_taken"
EP3_KOH_Q13_TAKEN_KEY = ":ep3_koh:q13_taken"

EP3_KOH_Q5_DEBRIEFED_KEY = ":ep3_koh:q5_debriefed"
EP3_KOH_Q8_DEBRIEFED_KEY = ":ep3_koh:q8_debriefed"
EP3_KOH_Q11_DEBRIEFED_KEY = ":ep3_koh:q11_debriefed"
EP3_KOH_Q12_DEBRIEFED_KEY = ":ep3_koh:q12_debriefed"
EP3_KOH_Q13_DEBRIEFED_KEY = ":ep3_koh:q13_debriefed"

function Ep3MiningCaptainKohConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3MiningCaptainKohConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3CpgVeteranConvoHandler:grant(). None of the five quest names contains "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply; the re-check is kept
-- anyway so a refused grant leaves no residue.
function Ep3MiningCaptainKohConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3MiningCaptainKohConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3MiningCaptainKohConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Walked backwards, deepest leg first, so a later leg always wins over an earlier one.

	-- quest_13 -- the Kessel diamonds leg, the last of the five. Once its debrief and the Y-8 deed have
	-- been seen, s_209 "I'm sure we will meet again pilot" is Koh's standing screen for good.
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KOH_Q13.type, EP3_KOH_Q13.name)) then
		return convoTemplate:getScreen("ep3_koh_q13_active")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KOH_Q13.type, EP3_KOH_Q13.name)) then
		if (self:getFlag(pPlayer, EP3_KOH_Q13_DEBRIEFED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_koh_q13_farewell")
		end

		return convoTemplate:getScreen("ep3_koh_q13_done")
	end

	if (self:getFlag(pPlayer, EP3_KOH_Q13_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_koh_q13_failed")
	end

	-- quest_8. Its debrief ends on s_124 "Come back when you are ready for another task", which is what
	-- opens the Kessel offer.
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KOH_Q8.type, EP3_KOH_Q8.name)) then
		return convoTemplate:getScreen("ep3_koh_q8_active")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KOH_Q8.type, EP3_KOH_Q8.name)) then
		if (self:getFlag(pPlayer, EP3_KOH_Q8_DEBRIEFED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_koh_q13_offer")
		end

		return convoTemplate:getScreen("ep3_koh_q8_done")
	end

	if (self:getFlag(pPlayer, EP3_KOH_Q8_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_koh_q8_failed")
	end

	-- quest_12.
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KOH_Q12.type, EP3_KOH_Q12.name)) then
		return convoTemplate:getScreen("ep3_koh_q12_active")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KOH_Q12.type, EP3_KOH_Q12.name)) then
		if (self:getFlag(pPlayer, EP3_KOH_Q12_DEBRIEFED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_koh_q8_offer")
		end

		return convoTemplate:getScreen("ep3_koh_q12_done")
	end

	if (self:getFlag(pPlayer, EP3_KOH_Q12_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_koh_q12_failed")
	end

	-- quest_11. Its debrief ends on s_148 "Come back when you are ready for more work!", which is what
	-- opens the quest_12 offer.
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KOH_Q11.type, EP3_KOH_Q11.name)) then
		return convoTemplate:getScreen("ep3_koh_q11_active")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KOH_Q11.type, EP3_KOH_Q11.name)) then
		if (self:getFlag(pPlayer, EP3_KOH_Q11_DEBRIEFED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_koh_q12_offer")
		end

		return convoTemplate:getScreen("ep3_koh_q11_done")
	end

	if (self:getFlag(pPlayer, EP3_KOH_Q11_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_koh_q11_failed")
	end

	-- quest_5. Its debrief says "Come back in a bit to check in with me", which is what opens the
	-- quest_11 offer ("I have an urgent task for you, pilot.").
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KOH_Q5.type, EP3_KOH_Q5.name)) then
		return convoTemplate:getScreen("ep3_koh_q5_active")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KOH_Q5.type, EP3_KOH_Q5.name)) then
		if (self:getFlag(pPlayer, EP3_KOH_Q5_DEBRIEFED_KEY) == 1) then
			return convoTemplate:getScreen("ep3_koh_q11_offer")
		end

		return convoTemplate:getScreen("ep3_koh_q5_done")
	end

	if (self:getFlag(pPlayer, EP3_KOH_Q5_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_koh_q5_failed")
	end

	-- Met him once and never took the first job (or turned it down): s_217 "Ready to do some work for
	-- me?" is the shipped re-approach line.
	if (self:getFlag(pPlayer, EP3_KOH_MET_KEY) == 1) then
		return convoTemplate:getScreen("ep3_koh_q5_reoffer")
	end

	return convoTemplate:getScreen("ep3_koh_greeting")
end

function Ep3MiningCaptainKohConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- Once he has introduced himself he never introduces himself again.
	if (screenID == "ep3_koh_intro") then
		self:setFlag(pPlayer, EP3_KOH_MET_KEY, 1)

	-- QUEST_5 GRANT / RE-GRANT.
	elseif (screenID == "ep3_koh_q5_accept" or screenID == "ep3_koh_q5_reaccept" or screenID == "ep3_koh_q5_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_koh_no_space")
		end

		self:setFlag(pPlayer, EP3_KOH_MET_KEY, 1)

		if (self:grant(pPlayer, pNpc, space_mining_destroy_kashyyyk_mining_quest_5, EP3_KOH_Q5)) then
			self:setFlag(pPlayer, EP3_KOH_Q5_TAKEN_KEY, 1)
		end

	elseif (screenID == "ep3_koh_q5_debrief") then
		self:setFlag(pPlayer, EP3_KOH_Q5_DEBRIEFED_KEY, 1)

	-- QUEST_11 GRANT / RE-GRANT.
	elseif (screenID == "ep3_koh_q11_accept" or screenID == "ep3_koh_q11_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_koh_no_space")
		end

		if (self:grant(pPlayer, pNpc, convoy_kashyyyk_mining_quest_11, EP3_KOH_Q11)) then
			self:setFlag(pPlayer, EP3_KOH_Q11_TAKEN_KEY, 1)
		end

	-- s_148 is the end of the quest_11 debrief, not s_147; the latch waits for it.
	elseif (screenID == "ep3_koh_q11_signoff") then
		self:setFlag(pPlayer, EP3_KOH_Q11_DEBRIEFED_KEY, 1)

	-- QUEST_12 GRANT / RE-GRANT.
	elseif (screenID == "ep3_koh_q12_accept" or screenID == "ep3_koh_q12_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_koh_no_space")
		end

		if (self:grant(pPlayer, pNpc, assassinate_kashyyyk_mining_quest_12, EP3_KOH_Q12)) then
			self:setFlag(pPlayer, EP3_KOH_Q12_TAKEN_KEY, 1)
		end

	elseif (screenID == "ep3_koh_q12_bonus") then
		self:setFlag(pPlayer, EP3_KOH_Q12_DEBRIEFED_KEY, 1)

	-- QUEST_8 GRANT / RE-GRANT.
	elseif (screenID == "ep3_koh_q8_accept" or screenID == "ep3_koh_q8_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_koh_no_space")
		end

		if (self:grant(pPlayer, pNpc, space_mining_destroy_kashyyyk_mining_quest_8, EP3_KOH_Q8)) then
			self:setFlag(pPlayer, EP3_KOH_Q8_TAKEN_KEY, 1)
		end

	-- s_124 is the end of the quest_8 debrief; seeing it opens the Kessel leg on the next approach.
	elseif (screenID == "ep3_koh_q8_end") then
		self:setFlag(pPlayer, EP3_KOH_Q8_DEBRIEFED_KEY, 1)

	-- QUEST_13 GRANT / RE-GRANT (the Kessel diamonds leg).
	elseif (screenID == "ep3_koh_q13_accept" or screenID == "ep3_koh_q13_retry") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_koh_no_space")
		end

		if (self:grant(pPlayer, pNpc, space_mining_destroy_kessel_mining_quest_13, EP3_KOH_Q13)) then
			self:setFlag(pPlayer, EP3_KOH_Q13_TAKEN_KEY, 1)
		end

	-- s_209 is the end of the Y-8 deed hand-off and Koh's standing screen from then on. It is also the
	-- screen getInitialScreen returns once this latch is set, so re-setting it is a no-op.
	elseif (screenID == "ep3_koh_q13_farewell") then
		self:setFlag(pPlayer, EP3_KOH_Q13_DEBRIEFED_KEY, 1)
	end

	return pScreenClone
end
