--[[
	Ithes Olok -- conversation handler for the Jenha Tar cube
	(somJenhaTarCubeScreenPlay).

	The tree is in mobile/conversations/mustafar/som_cube_ithes_olok.lua.
	This file only routes.

	THE TWO GATED OPTIONS

	Live gates one option on each of its two return greetings, and in both cases the
	ungated option is offered either way:

	    s_118  s_119 [hasNotes]  s_120 [default]
	    s_140  s_193 [lostCube]  s_141 [default]  s_142 [default]

	    condition_hasNotes -> groundquests.hasCompletedTask(player, "som_jenha_tar_cube",
	                                                        "take_notes")
	    condition_lostCube -> !utils.playerHasItemByTemplateInBankOrInventory(player,
	                              "object/tangible/container/loot/som_cube.iff")

	so a player who has the notes sees BOTH "Yes. I have them for you right here." and
	"No, I'm still working on it.", and a player who still has the cube sees the stage-4
	greeting without the lost-cube line. This file used to offer exactly one of s_119 /
	s_120 and to offer s_193 unconditionally; both are corrected.

	LuaConversationScreen binds removeAllOptions and not removeOption
	(LuaConversationScreen.cpp:21), so s_193 is dropped by clearing s_140's options and
	re-adding the two survivors in live's order.
--]]

cube_ithes_olok_conv_handler = conv_handler:new {}

function cube_ithes_olok_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = somJenhaTarCubeScreenPlay:getStage(pPlayer)

	if (stage == 1) or (stage == 2) or (stage == 3) then
		return convoTemplate:getScreen("notes_progress")
	elseif (stage == 4) then
		return convoTemplate:getScreen("greeting_done")
	end

	-- stage 0, not started
	return convoTemplate:getScreen("greeting")
end

function cube_ithes_olok_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	local stage = somJenhaTarCubeScreenPlay:getStage(pPlayer)

	if (screenID == "notes_progress") then
		somJenhaTarCubeScreenPlay:reportProgress(pPlayer)

		-- hasNotes: stage 3 is all three stones copied, which is live's completed
		-- take_notes task. s_120 is offered either way; see THE TWO GATED OPTIONS.
		if (stage == 3) then
			clonedConversation:addOption("@conversation/som_cube_ithes_olok:s_119", "notes_handin") -- Yes. I have them for you right here.
		end

		clonedConversation:addOption("@conversation/som_cube_ithes_olok:s_120", "still_working") -- No, I'm still working on it.

	elseif (screenID == "greeting_done") then
		-- lostCube. hasCube is the inventory half of live's check; see the note above
		-- somJenhaTarCubeScreenPlay:hasCube for what live looked at.
		if (somJenhaTarCubeScreenPlay:hasCube(pPlayer)) then
			clonedConversation:removeAllOptions()
			clonedConversation:addOption("@conversation/som_cube_ithes_olok:s_141", "cube_howto") -- Yes, please.
			clonedConversation:addOption("@conversation/som_cube_ithes_olok:s_142", "take_care") -- No, I've got it figured out.
		end

	elseif (screenID == "accept_notes") then
		if (somJenhaTarCubeScreenPlay:canGrantQuest(pPlayer)) then
			somJenhaTarCubeScreenPlay:grantQuest(pPlayer)
		end

	elseif (screenID == "notes_handin") then
		if (stage == 3) then
			somJenhaTarCubeScreenPlay:signalReturnNotes(pPlayer)
		end

	elseif (screenID == "lost_cube") then
		-- s_194 says he hands over another. replaceCube self-guards on stage 4 and
		-- on a base inventory check, so a player who still has one gets the line
		-- and no second cube.
		somJenhaTarCubeScreenPlay:replaceCube(pPlayer)
	end

	return pClonedScreen
end
