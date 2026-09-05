-- ep3_rodian_junk_dealer
-- ruling 2026-09-04
-- getInitialScreen is live condition order. runScreenHandlers fires start_dealing.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.
-- Sell option s_54fab04f is shown only when JunkDealer:getEligibleJunk has items
-- (the Core3 check_inv equivalent).

local JunkDealer = require("screenplays.junk_dealer.junk_dealer")

ep3_rodian_junk_dealer_conv_handler = conv_handler:new {}

function ep3_rodian_junk_dealer_conv_handler:hasSellableJunk(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local junkList = JunkDealer:getEligibleJunk(pPlayer, "generic")

	return junkList ~= nil and #junkList > 0
end

function ep3_rodian_junk_dealer_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (self:hasSellableJunk(pPlayer)) then
		return convoTemplate:getScreen("s_bef51e38")
	end

	return convoTemplate:getScreen("s_bef51e38_no_inv")
end

function ep3_rodian_junk_dealer_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_84a67771") then
		JunkDealer:sendSellJunkSelection(pPlayer, pNpc, "generic")
	end

	return pClonedScreen
end
