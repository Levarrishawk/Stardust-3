--[[
	Ikt -- conversation handler for som_kenobi_serpent_shard_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_ikt.lua, which carries
	the note on how it was reconstructed from the shipped string table. This file
	only routes by quest stage and fires the grant and the reward. All state lives
	in serpentShardScreenPlay's persistent screenplay data on the player's ghost;
	nothing is kept here.

	WHERE THE HOOKS SIT

	The quest is granted on the directions screens, not on the "I'll take the job"
	options, because the directions are the only thing that makes the go-to-location
	step findable -- s_88 / s_100 "The ruins are to the west of that, across the
	river of molten lava" is the waypoint in Ikt's own words. Granting a screen
	earlier would hand a player a quest before he had been told where to go.

	The reward fires on s_170 / s_172, the two "Oh yeah, the shard. And another one,
	you say" screens -- the point in each turn-in chain where he actually takes both
	shards off the player. s_174 onward is him refusing to keep it, which is
	flavour, not payment.

	NO LEVEL GATE

	som_kenobi_serpent_shard_1.qst carries no [list] level requirement at all --
	unlike cursed_shard_1 and the two historian files, which say Level 75. Nothing
	is gated here because nothing was gated there, and Ikt's table shipped no
	refusal line to say it with.

	WALKING AWAY

	s_143 (turning the offer down) and s_147 (both mid-quest walk-aways) end the
	conversation and change no state -- the player can hail him again. The .qst
	models no abandon, and Ikt has no line for taking the job back, so neither
	screen is a hook.
--]]

ikt_conv_handler = conv_handler:new {}

ikt_conv_handler.screenPlayName = "serpentShardScreenPlay"

-- the two directions screens; each hands out the quest
ikt_conv_handler.grantScreens = {
	directions_a = true,
	directions_b = true,
}

-- the two screens where he takes both shards and pays
ikt_conv_handler.rewardScreens = {
	reward_asked = true,
	reward_told = true,
}

function ikt_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = serpentShardScreenPlay:getStage(pPlayer)

	if (stage == serpentShardScreenPlay.STAGE_TURNIN) then
		return convoTemplate:getScreen("turnin")
	elseif (stage == serpentShardScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("all_done")
	elseif (stage ~= 0) then
		-- s_67 "Already back?" -- anywhere between the grant and the second shard.
		return convoTemplate:getScreen("progress")
	end

	return convoTemplate:getScreen("greeting")
end

function ikt_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	if (self.grantScreens[screenID]) then
		serpentShardScreenPlay:startQuest(pPlayer)
	elseif (self.rewardScreens[screenID]) then
		serpentShardScreenPlay:finishQuest(pPlayer)
	end

	return screen:cloneScreen()
end
