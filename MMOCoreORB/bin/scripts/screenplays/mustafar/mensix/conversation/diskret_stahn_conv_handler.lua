--[[
	Captain Diskret Stahn -- conversation handler for the grounded pilot in the Mensix cantina.

	Same shape as pei_yi_conv_handler: the tree lives in
	mobile/conversations/mustafar/som_diskret_stahn.lua, one persistent flag records that he has
	passed the tune on, and the musicianship check builds the accept option rather than sitting
	behind it.
--]]

diskret_stahn_conv_handler = conv_handler:new {}

diskret_stahn_conv_handler.screenPlayName = "mensix_mining_facility_main"
diskret_stahn_conv_handler.taughtKey = "diskret_stahn_taught"
diskret_stahn_conv_handler.requiredSkill = "social_musician_novice"

function diskret_stahn_conv_handler:hasBeenTaught(pPlayer)
	return readScreenPlayData(pPlayer, self.screenPlayName, self.taughtKey) == "1"
end

function diskret_stahn_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:hasBeenTaught(pPlayer)) then
		return convoTemplate:getScreen("greeting_taught")
	end

	return convoTemplate:getScreen("greeting")
end

function diskret_stahn_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "ask_tune") then
		if (CreatureObject(pPlayer):hasSkill(self.requiredSkill)) then
			clonedConversation:addOption("@conversation/som_diskret_stahn:s_45", "taught")
		else
			clonedConversation:addOption("@conversation/som_diskret_stahn:s_45", "too_unskilled")
		end

		clonedConversation:addOption("@conversation/som_diskret_stahn:s_52", "bye_nevermind")

	elseif (screenID == "taught") then
		writeScreenPlayData(pPlayer, self.screenPlayName, self.taughtKey, "1")
	end

	return pClonedScreen
end
