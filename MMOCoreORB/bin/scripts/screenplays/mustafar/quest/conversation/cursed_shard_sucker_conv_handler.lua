--[[
	The Hungry Whiphid -- conversation handler for som_kenobi_cursed_shard_2, Branch B.

	The tree is in mobile/conversations/mustafar/som_kenobi_cursed_shard_sucker.lua, which carries
	the note on what the live conversation corrected in it. This file gates the mind tricks, plays
	the animations and fires the .qst's signal.

	THE FORCE GATE

	Three of the player's options are prefixed "[Use the Force]" in SOE's own string table
	(s_22, s_33, s_50), and each is answered by the Whiphid parroting the suggestion straight back
	(s_24, s_36, s_52). Those are mind tricks, so a player who is not a Jedi must not see them.
	They are removed at runtime rather than living on separate screens because the alternative --
	a duplicate Jedi and non-Jedi copy of each of the three screens -- is six screens SOE did not
	ship strings for.

	removeAllOptions + addOption rebuilds the option list on the CLONED screen, and the session
	stores that clone, so getOptionLink still resolves on the next turn (same mechanism
	keslev_conv_handler relies on).

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

	THE ANIMATIONS -- these were missing entirely

	Live fires 27. 3 are the greeting on each opening and live in getInitialScreen below. The
	other 24 hang off the 14 player options, and they land on 13 distinct screens, which is
	what the table below has:

	    live calls   24
	    less  -2     food_ask is reached TWICE, once from the food lie (s_29) and once from
	                 the luck lie falling back on it (s_58), and both fire the same
	                 player thumb_up + npc dismiss
	    = 13 rows, 22 animations

	Keying by destination screen is safe here precisely because those two edges play the
	same pair. It is not safe everywhere -- som_kenobi_serpent_thief has two screens
	reachable two ways with DIFFERENT animations, and its handler keys by edge instead.
--]]

cursed_shard_sucker_conv_handler = conv_handler:new {}

cursed_shard_sucker_conv_handler.screenPlayName = "cursedShardScreenPlay"

-- option links whose option text is prefixed "[Use the Force]" in the string table
cursed_shard_sucker_conv_handler.forceOptions = {
	take_pretty = true,
	take_fool = true,
	take_fortune = true,
}

-- Keyed by the screen the player's option LEADS TO. Each entry is { actor, animation }
-- in the order live plays them. See THE ANIMATIONS.
cursed_shard_sucker_conv_handler.screenAnimations = {
	-- The pitch.
	not_interested = { { "player", "thumbs_up" },            { "npc", "shake_head_no" } },
	shiny          = { { "npc", "rub_chin_thoughtful" } },
	what_it_do     = { { "player", "point_forward" },        { "npc", "shrug_shoulders" } },

	-- The three lies.
	nothing_ask    = { { "player", "rub_chin_thoughtful" }, { "npc", "shrug_hands" } },
	food_ask       = { { "player", "thumb_up" },            { "npc", "dismiss" } },
	luck_ask       = { { "player", "thumb_up" },            { "npc", "shrug_shoulders" } },

	-- He takes it.
	take_pretty    = { { "player", "wave_finger_warning" } },
	take_fool      = { { "player", "wave_finger_warning" }, { "npc", "nod_head_multiple" } },
	take_night     = { { "npc", "nod_head_multiple" } },
	take_fortune   = { { "player", "wave_finger_warning" } },

	-- He does not.
	fail_pretty    = { { "player", "thumb_up" },   { "npc", "shake_head_no" } },
	fail_water     = { { "player", "shrug_hands" }, { "npc", "threaten" }, { "player", "taken_aback" } },
	fail_fortune   = { { "npc", "stamp_feet" } },
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

	-- Live's condition_givingAwayCrystal. See THE OPENING in the tree.
	if (cursedShardScreenPlay:getStage(pPlayer) ~= cursedShardScreenPlay.STAGE_DISPOSE) then
		CreatureObject(pNpc):doAnimation("stop")
		CreatureObject(pPlayer):doAnimation("greet")

		return convoTemplate:getScreen("rebuffed")
	end

	CreatureObject(pNpc):doAnimation("nod_head_once")

	return convoTemplate:getScreen("greeting")
end

function cursed_shard_sucker_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	if (self.handover[screenID]) then
		cursedShardScreenPlay:giveAwayShard(pPlayer)
	elseif (not self:canUseTheForce(pPlayer)) then
		self:stripForceOptions(screen, clonedConversation)
	end

	return pClonedScreen
end

-- Live's condition_playerJedi is jedi.isForceSensitive(player) -- force sensitive, NOT
-- Padawan. This used to test force_title_jedi_rank_01, which is Padawan and is strictly
-- narrower: village_jedi_manager.lua:113 will not grant rank_01 until the character has
-- 24 force-sensitive skills, and force_title_jedi_novice is what is awarded the moment a
-- character becomes force sensitive at all (village_jedi_manager.lua:59, fs_intro.lua:373).
-- The old test hid the mind tricks from every FS character below Padawan, which live shows
-- them to. helper_droid.lua:291 is the in-repo precedent for the novice test.
function cursed_shard_sucker_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")
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
