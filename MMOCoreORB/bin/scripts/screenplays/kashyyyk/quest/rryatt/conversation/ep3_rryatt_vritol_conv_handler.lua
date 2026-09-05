-- Vritol -- ep3_hunt_vritol_reward_mount (not one of the ten Rryatt .qst files)
-- ruling 2026-09-04: "ensure kashyyyk is fully done"
-- getInitialScreen is live condition order.
-- Hunt screenplay name (stem without ep3_ prefix, camel-cased): huntVritolRewardMountScreenPlay.
-- Active = stage > 0. Java grantKashBanthaMount on s_218 sends vritol_speakToVritol;
-- the hunt Reward item is object/tangible/deed/ep3_pet_deed/kashyyyk_bantha_deed.iff.
-- OPEN: that iff has no repo template, so the deed is not given here.
-- If huntVritolRewardMountScreenPlay:raiseSignal exists, s_218 calls it.
-- NO JOURNAL: this branch has no managers/quest/journal.lua.

ep3_rryatt_vritol_conv_handler = conv_handler:new {}

ep3_rryatt_vritol_conv_handler.screenAnimations = {
}

local HUNT_MOUNT_SCREENPLAY = "huntVritolRewardMountScreenPlay"

local function huntMountStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, HUNT_MOUNT_SCREENPLAY, "stage")) or 0
end

local function huntMountActive(pPlayer)
	return huntMountStage(pPlayer) > 0
end

local function grantKashBanthaMount(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (huntVritolRewardMountScreenPlay ~= nil and huntVritolRewardMountScreenPlay.raiseSignal ~= nil) then
		huntVritolRewardMountScreenPlay:raiseSignal(pPlayer, "vritol_speakToVritol")
	end
end

function ep3_rryatt_vritol_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not CreatureObject(pPlayer):hasSkill("social_language_wookiee_comprehend")) then
		return convoTemplate:getScreen("s_226")
	end

	if (huntMountActive(pPlayer)) then
		grantKashBanthaMount(pPlayer)
		return convoTemplate:getScreen("s_218")
	end

	return convoTemplate:getScreen("s_669")
end

function ep3_rryatt_vritol_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "s_218") then
		grantKashBanthaMount(pPlayer)
	end

	return pClonedScreen
end
