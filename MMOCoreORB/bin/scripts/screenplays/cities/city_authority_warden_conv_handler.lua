cityAuthorityWardenConvoHandler = conv_handler:new {}

function cityAuthorityWardenConvoHandler:formatRemainingTime(seconds)
	local days = math.floor(seconds / 86400)
	local hours = math.floor((seconds % 86400) / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local remainingSeconds = seconds % 60

	return string.format("%d days, %d hours, %d minutes, and %d seconds",
			days, hours, minutes, remainingSeconds)
end

function cityAuthorityWardenConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedScreen = LuaConversationScreen(pClonedScreen)

	clonedScreen:removeAllOptions()

	if (screenID == "sentence_info_end") then
		clonedScreen:setCustomDialogText("Speak with the warden in his office near the entrance if you wish to discuss parole.")

		return pClonedScreen
	end

	if (screenID == "sentence_info") then
		local sentenceEnd = CityAuthorityScreenPlay:getSentenceEnd(pPlayer)
		local remaining = CityAuthorityScreenPlay:getRemainingSentence(pPlayer)

		if (sentenceEnd == 0) then
			clonedScreen:setCustomDialogText("I have no active city-authority sentence recorded for you. Speak with the warden in his office near the entrance to discuss parole.")
		elseif (remaining > 0) then
			clonedScreen:setCustomDialogText("You have " .. self:formatRemainingTime(remaining) ..
					" remaining on your sentence. Speak with the warden in his office near the entrance to discuss parole.")
		else
			clonedScreen:setCustomDialogText("Your sentence has elapsed. Speak with the warden in his office near the entrance to discuss parole.")
		end

		clonedScreen:addOption("Understood.", "sentence_info_end")

		return pClonedScreen
	end

	if (screenID == "end_conversation") then
		clonedScreen:setCustomDialogText("Very well.")

		return pClonedScreen
	end

	if (screenID == "pay_fine") then
		local _, message = CityAuthorityScreenPlay:releasePlayer(pPlayer)
		clonedScreen:setCustomDialogText(message)

		return pClonedScreen
	end

	local sentenceEnd = CityAuthorityScreenPlay:getSentenceEnd(pPlayer)

	if (sentenceEnd == 0) then
		clonedScreen:setCustomDialogText("You have no active sentence recorded. I can process your release after payment of a 20,000 credit fine.")
		clonedScreen:addOption("Pay the 20,000 credit fine and process my release.", "pay_fine")
		clonedScreen:addOption("Not now.", "end_conversation")

		return pClonedScreen
	end

	local remaining = CityAuthorityScreenPlay:getRemainingSentence(pPlayer)

	if (remaining > 0) then
		clonedScreen:setCustomDialogText("You have " .. self:formatRemainingTime(remaining) ..
				" remaining on your sentence.")
		clonedScreen:addOption("Understood.", "end_conversation")
	else
		clonedScreen:setCustomDialogText("Your sentence has elapsed. I can process your release after payment of a 20,000 credit fine.")
		clonedScreen:addOption("Pay the 20,000 credit fine and process my release.", "pay_fine")
		clonedScreen:addOption("Not now.", "end_conversation")
	end

	return pClonedScreen
end
