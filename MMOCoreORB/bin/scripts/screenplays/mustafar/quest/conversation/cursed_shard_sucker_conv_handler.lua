--[[
	The Hungry Whiphid -- conversation handler for som_kenobi_cursed_shard_2, Branch B.

	The tree is in mobile/conversations/mustafar/som_kenobi_cursed_shard_sucker.lua, which carries
	the note on how it was reconstructed from the shipped string table. This file gates the mind
	tricks and fires the .qst's signal.

	THE FORCE GATE

	Three of the player's options are prefixed "[Use the Force]" in SOE's own string table
	(s_22, s_33, s_50), and each is answered by the Whiphid parroting the suggestion straight back
	(s_24, s_36, s_52). Those are mind tricks, so a player who is not a Jedi must not see them.
	They are removed at runtime rather than living on separate screens because the alternative --
	a duplicate Jedi and non-Jedi copy of each of the three screens -- is six screens SOE did not
	ship strings for.

	removeAllOptions + addOption rebuilds the option list on the CLONED screen, and the session
	stores that clone, so getOptionLink still resolves on the next turn (same mechanism
	jo_kelsev_conv_handler relies on).

	Stripped of the three tricks, a non-Jedi has exactly one way through: s_42, "It only works
	during night time", under the food lie. That is a real lie rather than a Force suggestion, and
	it is the only success screen in the table that is not a parroted mind trick -- so the shipped
	strings themselves say a non-Jedi is meant to have a path.

	FAILURE

	som_kenobi_cursed_shard_2.qst models no failure: Branch B is a single Wait for Signal task
	with no counterpart for a failed attempt. So the three failure screens (s_35, s_40, s_56) only
	end the conversation -- the player can hail him again and try a different lie. Nothing here
	locks the player out, and Branch A (the volcano) stays open regardless.

	s_60 "Step back or be hurt!" is what he says to anyone who has no shard to offer him.
--]]

cursed_shard_sucker_conv_handler = conv_handler:new {}

cursed_shard_sucker_conv_handler.screenPlayName = "cursedShardScreenPlay"

-- option links whose option text is prefixed "[Use the Force]" in the string table
cursed_shard_sucker_conv_handler.forceOptions = {
	take_pretty = true,
	take_fool = true,
	take_fortune = true,
}

-- screens where he accepts the shard
cursed_shard_sucker_conv_handler.handover = {
	take_pretty = true,
	take_fool = true,
	take_night = true,
	take_fortune = true,
}

function cursed_shard_sucker_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (cursedShardScreenPlay:getStage(pPlayer) ~= cursedShardScreenPlay.STAGE_DISPOSE) then
		return convoTemplate:getScreen("rebuffed")
	end

	return convoTemplate:getScreen("greeting")
end

function cursed_shard_sucker_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.handover[screenID]) then
		cursedShardScreenPlay:giveAwayShard(pPlayer)
	elseif (not self:canUseTheForce(pPlayer)) then
		self:stripForceOptions(screen, clonedConversation)
	end

	return pClonedScreen
end

function cursed_shard_sucker_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_01")
end

-- Rebuilds the option list without the mind tricks. Option indices are 0-based:
-- conv_handler passes the client's selectedOption straight to getOptionLink.
function cursed_shard_sucker_conv_handler:stripForceOptions(screen, clonedConversation)
	local count = screen:getOptionCount()
	local kept = {}

	for i = 0, count - 1 do
		local link = screen:getOptionLink(i)

		if (not self.forceOptions[link]) then
			table.insert(kept, { screen:getOptionText(i), link })
		end
	end

	if (#kept == count) then
		return
	end

	clonedConversation:removeAllOptions()

	for i = 1, #kept do
		clonedConversation:addOption(kept[i][1], kept[i][2])
	end
end
