--[[
	The Dark Jedi Thief -- conversation handler for the stakeout beat of
	som_kenobi_serpent_shard_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_serpent_thief.lua, which carries
	the note on what the live conversation corrected in it. This file gates the hail, gates
	the two Force pushes, plays the 36 animations and fires the fight.

	THE HAIL IS GATED -- this was missing entirely

	Live's OnStartNpcConversation tests one condition before anything else:

	    isTaskActive(player, "som_kenobi_serpent_shard_1", "talkThief")

	A player who is not on that task gets no conversation at all. She says s_43 -- "You're
	a cute one, maybe too cute..." -- with a laugh_titter and that is the end of it. Only a
	player on the task sees the curtsey and the s_110 greeting.

	The earlier revision had no gate and had turned s_43 into a screen in the middle of the
	tree. Both are fixed. The Core3 stand-in for the task test is the screenplay's own
	STAGE_STAKEOUT, which is the stage task 5 opens on.

	DEVIATION, and it is small: live delivers s_43 with chat.chat, a spatial bubble, and
	never opens a conversation window. Core3 cannot do that from getInitialScreen -- the
	client has already been sent into a conversation by the time this runs, and returning
	nil drops the session with forceClose=false (ConversationObserver.idl:54), which leaves
	the window open on the client with nothing in it. So s_43 is a one-line terminal screen
	here. Same words, same animation, one extra click to dismiss.

	THE FORCE GATE

	s_97 and s_131 are the two "[Use the Force]" options, one per chain. Live gates both on
	condition_playerJedi, which is jedi.isForceSensitive(player) -- force sensitive, NOT
	Padawan.

	This file used to test force_title_jedi_rank_01, which is Padawan and is strictly
	narrower: village_jedi_manager.lua:113 will not grant rank_01 until the character has
	24 force-sensitive skills, and force_title_jedi_novice is what is awarded the moment a
	character becomes force sensitive at all (village_jedi_manager.lua:59, fs_intro.lua:373).
	So the old test hid the Force option from every FS character below Padawan, which live
	shows it to. helper_droid.lua:291 is the in-repo precedent for the novice test.

	Stripped of the two pushes, each chain still has a way into the fight: s_95 on chain B
	and s_129 on chain A. No path is closed to a non-sensitive.

	THE FIGHT

	All four endings fire live's two actions together, in this order:

	    action_talked   sendSignal "talkedThief" + setInvulnerable(npc, false)
	    action_attack   startCombat(npc, player) + clearCondition(CONVERSABLE)

	serpentShardScreenPlay:talkedThief does the signal half and the aggro; the invulnerable
	half is there too, because live spawns her invulnerable so she cannot be killed before
	the conversation -- which would strand the quest with task 5 unsignalled and the only
	thief dead. clearCondition(CONVERSABLE) is the last line here.

	THE ANIMATIONS

	Live fires 36. Two are the greeting -- curtsey on the gated hail, laugh_titter on the
	brush-off -- and are in getInitialScreen. The other 34 hang off the 20 player options.

	They are keyed by EDGE, from-screen to to-screen, not by destination screen alone,
	because two screens are reached two ways with different animations and keying by
	destination would silently pick one:

	    seen_that    from seen_it  is player explain + npc nod
	                 from specific is player nod     + npc nod
	    seen_that_a  from what_taken is player explain
	                 from trust_a    is player rub_chin_thoughtful

	The from-screen is the conversation session's last screen. It is still the PREVIOUS
	screen while runScreenHandlers runs: the session is only updated in
	ConversationScreen.h:232, inside sendTo, which ConversationObserver calls after this
	returns.
--]]

serpent_thief_conv_handler = conv_handler:new {}

serpent_thief_conv_handler.screenPlayName = "serpentShardScreenPlay"

-- option links whose option text is prefixed "[Use the Force]" in the string table
serpent_thief_conv_handler.forceOptions = {
	fight_a_force = true,
	fight_b_force = true,
}

-- every screen the encounter can end on; all four fire talked + attack
serpent_thief_conv_handler.fightScreens = {
	fight_a = true,
	fight_b = true,
	fight_a_force = true,
	fight_b_force = true,
}

-- [from screen][to screen] = { { actor, animation }, ... } in the order live plays them.
-- See THE ANIMATIONS for why this is keyed by edge.
serpent_thief_conv_handler.edgeAnimations = {
	greeting = {
		asked_first = { { "player", "bow" },         { "npc", "laugh_titter" } },
		no_fair     = { { "player", "taken_aback" }, { "npc", "laugh_titter" } },
	},

	-- CHAIN B
	asked_first = {
		seen_it = { { "player", "shrug_shoulders" }, { "npc", "shrug_hands" } },
	},
	seen_it = {
		trust_b   = { { "player", "rub_chin_thoughtful" }, { "npc", "point_to_self" } },
		seen_that = { { "player", "explain" },             { "npc", "nod" } },
	},
	trust_b = {
		specific = { { "player", "sigh_deeply" }, { "npc", "laugh_titter" } },
	},
	specific = {
		seen_that = { { "player", "nod" }, { "npc", "nod" } },
	},
	seen_that = {
		pocket_b = { { "npc", "thumb_up" } },
	},
	pocket_b = {
		refuse_b = { { "player", "point_forward" }, { "npc", "shake_head_no" } },
	},
	refuse_b = {
		burial_ground = { { "player", "shrug_hands" },         { "npc", "shrug_shoulders" } },
		fight_b_force = { { "player", "wave_finger_warning" }, { "npc", "laugh_cackle" } },
	},
	burial_ground = {
		fight_b = { { "player", "shake_head_no" } },
	},

	-- CHAIN A
	no_fair = {
		what_taken = { { "player", "sigh_deeply" }, { "npc", "nervous" } },
	},
	what_taken = {
		seen_that_a = { { "player", "explain" } },
		trust_a     = { { "player", "point_accusingly" }, { "npc", "laugh_titter" } },
	},
	trust_a = {
		seen_that_a = { { "player", "rub_chin_thoughtful" } },
	},
	seen_that_a = {
		pocket_a = { { "npc", "thumb_up" } },
	},
	pocket_a = {
		refuse_a = { { "npc", "shake_head_no" } },
	},
	refuse_a = {
		fight_a       = { { "player", "threaten" },            { "npc", "shake_head_no" } },
		fight_a_force = { { "player", "wave_finger_warning" }, { "npc", "laugh_cackle" } },
	},
}

function serpent_thief_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Live's condition_thief. See THE HAIL IS GATED.
	if (serpentShardScreenPlay:getStage(pPlayer) ~= serpentShardScreenPlay.STAGE_STAKEOUT) then
		CreatureObject(pNpc):doAnimation("laugh_titter")

		return convoTemplate:getScreen("brush_off")
	end

	CreatureObject(pNpc):doAnimation("curtsey")

	return convoTemplate:getScreen("greeting")
end

function serpent_thief_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	self:playEdgeAnimations(pPlayer, pNpc, self:getLastScreenID(pPlayer), screenID)

	if (self.fightScreens[screenID]) then
		serpentShardScreenPlay:talkedThief(pPlayer, pNpc)

		-- live's action_attack, second half
		CreatureObject(pNpc):clearOptionBit(CONVERSABLE)

	elseif (not self:canUseTheForce(pPlayer)) then
		self:stripForceOptions(screen, LuaConversationScreen(pClonedScreen))
	end

	return pClonedScreen
end

-- The screen the player was looking at when he picked the option. Still the previous
-- screen at this point -- see THE ANIMATIONS. nil on the opening screen.
function serpent_thief_conv_handler:getLastScreenID(pPlayer)
	if (pPlayer == nil) then
		return nil
	end

	local pSession = CreatureObject(pPlayer):getConversationSession()

	if (pSession == nil) then
		return nil
	end

	local pLastScreen = LuaConversationSession(pSession):getLastConversationScreen()

	if (pLastScreen == nil) then
		return nil
	end

	return LuaConversationScreen(pLastScreen):getScreenID()
end

function serpent_thief_conv_handler:playEdgeAnimations(pPlayer, pNpc, fromID, toID)
	if (fromID == nil) then
		return
	end

	local edges = self.edgeAnimations[fromID]

	if (edges == nil) then
		return
	end

	local animations = edges[toID]

	if (animations == nil) then
		return
	end

	for i = 1, #animations do
		local actor = animations[i][1] == "npc" and pNpc or pPlayer

		CreatureObject(actor):doAnimation(animations[i][2])
	end
end

-- Live's condition_playerJedi is jedi.isForceSensitive, not a Padawan test.
-- See THE FORCE GATE.
function serpent_thief_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")
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
