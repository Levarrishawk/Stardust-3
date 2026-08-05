--[[
	Kkrax -- the ground giver for the Boba Fett clone-relics space quest that had no giver:

		recovery/ep3_clone_relics_boba_fett_2   "Dantooine system: Tracking down Ogveer."

	The global lives in screenplays/space/squadrons/KesselDutyScreenplay.lua and is registered there:

		recovery_ep3_clone_relics_boba_fett_2   global line 232, registerScreenPlay line 292

	That file is included by screenplays/space/screenplays.lua at line 31, before this handler, so the
	global is loaded by the time this handler runs. In any case the reference below is inside a function
	body, so it resolves at call time, not at load time.

	Before this file nothing in the repo handed it out: it had zero :startQuest call sites, declares no
	parentQuest, and is nobody's sideQuest.

	WIRING THIS ONE GIVER REACHES TWO QUESTS. boba_fett_2 declares
	sideQuestType = "destroy_surpriseattack", sideQuestName = "ep3_clone_relics_boba_fett_3" with
	sideQuestSplitType = SpaceQuestLogic.SIDE_QUEST_SPLIT_TYPES.COMPLETION, so
	SpaceQuestLogic:triggerCompletionSplitQuest (SpaceQuestLogic.lua:128) grants
	destroy_surpriseattack/ep3_clone_relics_boba_fett_3 on completion, after sideQuestDelay = 8
	seconds. boba_fett_3 needs no giver of its own and must not be given one.

	FLAGGED INTERPRETATION -- NO FLIGHT GATE. Kkrax's .stf ships no dismissal line, so unlike Captain
	Koh (s_270) there is nothing verbatim to show a player who cannot fly, and nothing is authored for
	him. The canonical grant site in this repo, rheaConvoHandler.lua:237, gates nothing either. grant()
	below still re-reads the journal after the grant so a refused grant leaves no latch behind.

	FLAGGED INTERPRETATION -- FAILURE DETECTION. SpaceRecoveryScreenplay leaves no distinguishable
	failure record a conversation can read, so a "took it once" latch is written on a successful grant
	and the shipped re-approach block (s_780 "What do you want?!" / s_782 "I need the directions to
	Ogveer again.") is shown to anyone who once took it and now has it neither active nor complete.
	That cannot separate "failed it" from "abandoned it".

	REACHABILITY, STATED PLAINLY. ep3_clone_relics_kkrax is not spawned anywhere in this repo -- no
	screenplay references any ep3_clone_relics_* mobile at all. The mobile exists
	(mobile/custom_content/ep3/ep3_clone_relics_kkrax.lua, registered in that directory's
	serverobjects.lua) and is now conversable, but this handler is correct and inert until a spawn
	exists.
]]

Ep3CloneRelicsKkraxConvoHandler = conv_handler:new {}

-- Copied from KesselDutyScreenplay.lua verbatim (questName/questType at 235-236).
EP3_KKRAX_QUEST = {type = "recovery", name = "ep3_clone_relics_boba_fett_2"}

EP3_KKRAX_TAKEN_KEY = ":ep3_kkrax:taken"

function Ep3CloneRelicsKkraxConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function Ep3CloneRelicsKkraxConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- Ep3MiningCaptainKohConvoHandler:grant(). The quest name does not contain "_duty", so
-- SpaceHelpers:activateSpaceQuest()'s one-duty-at-a-time refusal (space_helpers.lua:959) does not
-- apply; the re-check is kept anyway so a refused grant leaves no residue.
function Ep3CloneRelicsKkraxConvoHandler:grant(pPlayer, pNpc, screenplay, quest)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end

	screenplay:startQuest(pPlayer, pNpc)

	return SpaceHelpers:isSpaceQuestActive(pPlayer, quest.type, quest.name)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, quest.type, quest.name)
end

function Ep3CloneRelicsKkraxConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (SpaceHelpers:isSpaceQuestActive(pPlayer, EP3_KKRAX_QUEST.type, EP3_KKRAX_QUEST.name)) then
		return convoTemplate:getScreen("ep3_kkrax_active")
	end

	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, EP3_KKRAX_QUEST.type, EP3_KKRAX_QUEST.name)) then
		return convoTemplate:getScreen("ep3_kkrax_done")
	end

	if (self:getFlag(pPlayer, EP3_KKRAX_TAKEN_KEY) == 1) then
		return convoTemplate:getScreen("ep3_kkrax_retry_greeting")
	end

	return convoTemplate:getScreen("ep3_kkrax_greeting")
end

function Ep3CloneRelicsKkraxConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	-- GRANT / RE-GRANT. Both ids are the moment the coordinates change hands: s_818 on the first pass,
	-- s_788 ("Here's the location of his smuggling route in the Dantooine system") on the re-approach.
	if (screenID == "ep3_kkrax_coords" or screenID == "ep3_kkrax_retry_coords") then
		if (self:grant(pPlayer, pNpc, recovery_ep3_clone_relics_boba_fett_2, EP3_KKRAX_QUEST)) then
			self:setFlag(pPlayer, EP3_KKRAX_TAKEN_KEY, 1)
		end
	end

	return pScreenClone
end
