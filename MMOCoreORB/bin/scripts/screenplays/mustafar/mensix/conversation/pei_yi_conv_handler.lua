--[[
	Pei Yi -- conversation handler for the stranded dancer in the Mensix cantina.

	The tree is in mobile/conversations/mustafar/som_pei_yi.lua, which also carries the note on
	why the lesson is a conversation rather than an ability grant. This file only routes.

	State is one flag, kept in persistent screenplay data under the screenplay that spawns her,
	so a character who has had the lesson still gets the return-visit greeting after a restart.
	readScreenPlayData returns "" for a key never written, hence comparing to "1" rather than
	testing for nil.
--]]

pei_yi_conv_handler = conv_handler:new {}

pei_yi_conv_handler.screenPlayName = "mensix_mining_facility_main"
pei_yi_conv_handler.taughtKey = "pei_yi_taught"
pei_yi_conv_handler.requiredSkill = "social_dancer_novice"

function pei_yi_conv_handler:hasBeenTaught(pPlayer)
	return readScreenPlayData(pPlayer, self.screenPlayName, self.taughtKey) == "1"
end

function pei_yi_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:hasBeenTaught(pPlayer)) then
		return convoTemplate:getScreen("greeting_taught")
	end

	return convoTemplate:getScreen("greeting")
end

function pei_yi_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "offer_lesson") then
		-- The skill check happens here rather than on a "learn" screen, so the player is never
		-- shown an accept option that leads somewhere it should not.
		if (CreatureObject(pPlayer):hasSkill(self.requiredSkill)) then
			clonedConversation:addOption("@conversation/som_pei_yi:s_60", "taught")
		else
			clonedConversation:addOption("@conversation/som_pei_yi:s_60", "too_unskilled")
		end

		clonedConversation:addOption("@conversation/som_pei_yi:s_66", "bye_another")

	elseif (screenID == "taught") then
		writeScreenPlayData(pPlayer, self.screenPlayName, self.taughtKey, "1")
	end

	return pClonedScreen
end
