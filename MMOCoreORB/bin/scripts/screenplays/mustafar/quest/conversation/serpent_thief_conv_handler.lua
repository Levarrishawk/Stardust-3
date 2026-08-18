--[[
	The Dark Jedi Thief -- conversation handler for the stakeout beat of
	som_kenobi_serpent_shard_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_serpent_thief.lua, which
	carries the note on how it was reconstructed from the shipped string table. This
	file gates the two mind tricks and fires the .qst's talkedThief signal.

	THE SIGNAL

	som_kenobi_serpent_shard_1.qst task 5 is a Wait for Signal on "talkedThief",
	and task 6 -- Destroy Multiple and Loot on som_kenobi_serpent_thief -- only
	opens once it fires. There is no other task between them, so the signal is the
	conversation ending in a fight, and all four of the tree's fight screens fire it.

	Killing her before ever speaking to her therefore does nothing, which is what
	the .qst says: she is CONVERSABLE and not aggressive (pvpBitmask ATTACKABLE +
	ENEMY, no AGGRESSIVE), so she will not open on the player and the encounter has
	to start here.

	setPvpStatusBit(AGGRESSIVE) + setDefender is the engine's own way of turning a
	conversation into a fight -- see events/coa/conversations/coa3_lookout_conv_handler.lua.
	The bit is set as well as the defender because without it she drops the player
	the moment he breaks line of sight and goes back to being a talkable NPC holding
	a quest item.

	THE FORCE GATE

	Two of the player's options are prefixed "[Use the Force]" in SOE's own string
	table (s_97 and s_131), one per chain, and each is answered by her jeering at
	the attempt (s_99, s_133). Those are Force pushes, so a player who is not a
	Jedi must not see them. They are removed at runtime rather than living on
	separate screens, exactly as cursed_shard_sucker_conv_handler does it -- the
	alternative is a duplicate Jedi and non-Jedi copy of both refusal screens, which
	SOE shipped no strings for.

	Stripped of the two pushes, each chain still has one way into the fight:
	s_95 "Why not? Don't make this any harder than it needs to be" on chain B, and
	s_129 "If you don't give it up right now, I'm forced to hurt you" on chain A.
	No path is closed to a non-Jedi.
--]]

serpent_thief_conv_handler = conv_handler:new {}

serpent_thief_conv_handler.screenPlayName = "serpentShardScreenPlay"

-- option links whose option text is prefixed "[Use the Force]" in the string table
serpent_thief_conv_handler.forceOptions = {
	fight_a_force = true,
	fight_b_force = true,
}

-- every screen the encounter can end on; all four fire talkedThief
serpent_thief_conv_handler.fightScreens = {
	fight_a = true,
	fight_b = true,
	fight_a_force = true,
	fight_b_force = true,
}

function serpent_thief_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	return LuaConversationTemplate(pConvTemplate):getScreen("greeting")
end

function serpent_thief_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (self.fightScreens[screenID]) then
		serpentShardScreenPlay:talkedThief(pPlayer, pNpc)
	elseif (not self:canUseTheForce(pPlayer)) then
		self:stripForceOptions(screen, LuaConversationScreen(pClonedScreen))
	end

	return pClonedScreen
end

function serpent_thief_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_01")
end

-- Rebuilds the option list without the Force pushes. Option indices are 0-based:
-- conv_handler passes the client's selectedOption straight to getOptionLink.
function serpent_thief_conv_handler:stripForceOptions(screen, clonedConversation)
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
