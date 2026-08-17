--[[
	Belga Daeri -- the ground giver for the one Kashyyyk slaver-file quest head that had no giver:

		assassinate/ep3_stren_dorn_lackey   (questZone space_kashyyyk)

	The global lives in screenplays/space/squadrons/KashyyykSlaverScreenplay.lua (line 366,
	className/questName/questType at 367/369/370). That file is included by
	screenplays/space/screenplays.lua before this one, so the global is loaded by the time this
	handler runs.

	Before this file nothing in the repo handed it out. It declares no parentQuest, and nothing else
	names it as a sideQuest, so nothing chained it either.

	It DOES declare a sideQuest of its own -- destroy_surpriseattack/ep3_stren_dorn_bounty on
	SIDE_QUEST_SPLIT_TYPES.COMPLETION -- which is Dorn Nerausu himself coming after the pilot once the
	lackeys are down. That fires from SpaceQuestLogic.lua:128 on completion and needs nothing here.

	WHY BELGA AND NOT STREN COLO. Stren Colo's own shipped text sends the player to her and names her
	as the one who placed the bounty (ep3_stren_colo:s_91), and pays out on her confirmation
	(s_63). Stren posts and redeems; Belga briefs. See the convo file header for the quotes.

	FLAGGED INTERPRETATION -- s_414 AS THE STANDING SCREEN AND THE FLIGHT GATE. See the convo file
	header. She ships no dismissal and no failure line, so s_414 carries both roles and a player who
	no longer holds the contract simply walks the pitch again.

	REACHABILITY, STATED PLAINLY. ep3_belga_daeri is not spawned anywhere in this repo, there are no
	Kashyyyk ground spawn areas, and config.lua ZonesEnabled has no Kashyyyk ground zone (only
	SpaceZonesEnabled has "space_kashyyyk"). This handler is correct and inert until all three of
	those are addressed.
]]

Ep3BelgaDaeriConvoHandler = conv_handler:new {}

-- Copied from KashyyykSlaverScreenplay.lua verbatim (questName/questType at 369-370).
EP3_BELGA_DORN_LACKEY = {type = "assassinate", name = "ep3_stren_dorn_lackey"}

-- Hand the quest out and report whether it actually landed. Same shape as
-- Ep3CpgVeteranConvoHandler:grant(). The quest name does not contain "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal does not apply; the re-check is
-- kept anyway so a refused grant leaves no residue.
function Ep3BelgaDaeriConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3BelgaDaeriConvoHandler:canFly(pPlayer)
	return isJtlEnabled() and SpaceHelpers:isPilot(pPlayer) and SpaceHelpers:hasCertifiedShip(pPlayer, true)
end

function Ep3BelgaDaeriConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_BELGA_DORN_LACKEY.type, EP3_BELGA_DORN_LACKEY.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_BELGA_DORN_LACKEY.type, EP3_BELGA_DORN_LACKEY.name)) then
		return convoTemplate:getScreen("ep3_belga_standing")
	end

	return convoTemplate:getScreen("ep3_belga_greeting")
end

function Ep3BelgaDaeriConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	if (screenID == "ep3_belga_accept") then
		if (not self:canFly(pPlayer)) then
			return LuaConversationTemplate(pConvTemplate):getScreen("ep3_belga_standing")
		end

		self:grant(pPlayer, pNpc, assassinate_ep3_stren_dorn_lackey, EP3_BELGA_DORN_LACKEY)
	end

	return pScreenClone
end
