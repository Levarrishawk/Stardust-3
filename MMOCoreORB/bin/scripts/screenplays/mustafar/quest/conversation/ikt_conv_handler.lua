--[[
	Ikt -- conversation handler for som_kenobi_serpent_shard_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_ikt.lua, which carries
	the note on how it was reconstructed and what the live tree corrected in it.
	This file picks the root, plays the animations and fires the three actions.
	All state lives in serpentShardScreenPlay's persistent screenplay data on the
	player's ghost; nothing is kept here.

	THE ROOT, IN LIVE'S ORDER
	  done       -> s_186  all_done
	  haveShard  -> s_149  turnin
	  onQuest    -> s_67   progress
	  default    -> s_110  greeting
	The four are mutually exclusive, so the order does not change what a player
	sees. It is written live's way so the two files read against each other.

	WHERE THE HOOKS SIT -- the grant and the reward both moved

	giveQuest fires on s_104 and s_90, the LAST screen of each offer chain, not on
	the directions screens. The earlier revision put it on the directions -- s_88
	and s_100, "the ruins are to the west of that" -- reasoning that the directions
	are what make the go-to-location step findable, so granting any earlier would
	hand out a quest before telling the player where to go. Live grants one screen
	later still, at the end of Ikt's "no one steals from Ikt" sign-off, which is
	where the conversation actually closes. The reasoning was sound and the answer
	was wrong; only the live script says where SOE put it.

	reward fires on s_180 and s_184, which are likewise the last screen of each
	turn-in chain. This is a bigger move than it looks, because the two chains do
	not converge -- see CORRECTING THE TURN-IN in the tree. It used to fire on
	s_170 / s_172, the two "here's your payment for a job well done" screens, on
	the reading that everything after them was flavour. In live those screens are
	Ikt SAYING he is paying; the server pays at the end of the exchange, four
	screens later on the long route and two on the short one.

	WALKING AWAY -- this was doing nothing

	s_147 and s_143 both carry live's removeQuest. This handler used to fire
	nothing on either, and said so in a comment: "the .qst models no abandon, and
	Ikt has no line for taking the job back, so neither screen is a hook." The
	first half is true and the second is false -- both screens are exactly that
	line, and live drops the quest on both.

	ROOT CAUSE: checking the .qst and stopping there. The .qst has no abandon task
	because abandoning is not a task; it is an action on a conversation edge, and
	the .qst has no way to express one. Reading the datatable as the whole contract
	made an absence of evidence into evidence of absence. serpentShardScreenPlay
	had no abandonQuest to call either, so one is added there rather than open-
	coded here -- the state it has to unwind (waypoint, persistent observer, the
	spawned thief) all belongs to the screenplay.

	Note what this makes possible that could not happen before: a player can now
	take Ikt's job, give up, and take it again. That is live's behaviour, and it is
	why startQuest's stage-0 guard matters.

	NO LEVEL GATE

	som_kenobi_serpent_shard_1.qst carries no [list] level requirement at all --
	unlike cursed_shard_1 and the two historian files, which display Level 75.
	That 75 is a client-side display value anyway; the only Mustafar gate that is
	really enforced comes from a server-side conversation, and Ikt's has no level
	test. Nothing is gated here because nothing was gated there.

	THE ANIMATIONS -- these were missing entirely

	Live fires 45, across 29 screens, and every one of the 29 is reached exactly
	one way -- no screen in this tree has two inbound edges -- so keying by
	destination cannot produce a disagreement. All four root screens carry one;
	runScreenHandlers runs on the initial screen as well, so they sit in the same
	table as the rest rather than in getInitialScreen.

	Two screens get nothing: directions_ask (s_100) and directions_pay (s_88).
	That is live, not an omission.

	ROOT CAUSE of the omission: the tree was reconstructed from the string table,
	and a string table records text and nothing else -- no wiring, no actions, no
	gestures.
--]]

ikt_conv_handler = conv_handler:new {}

ikt_conv_handler.screenPlayName = "serpentShardScreenPlay"

-- live's giveQuest: the closing screen of each offer chain.
ikt_conv_handler.grantScreens = {
	closing_ask = true,  -- s_104
	closing_pay = true,  -- s_90
}

-- live's reward: the last screen of each turn-in chain, not the two "here's your
-- payment" screens. See WHERE THE HOOKS SIT.
ikt_conv_handler.rewardScreens = {
	dontforget = true,  -- s_180, the long chain
	farewell = true,    -- s_184, the short chain
}

-- live's removeQuest: both mid-quest walk-aways. See WALKING AWAY.
ikt_conv_handler.abandonScreens = {
	abandon_direct = true,  -- s_147, straight off s_67
	abandon_asked = true,   -- s_143, after being pressed
}

-- [destination screen] = { { actor, animation }, ... } in the order live plays them.
-- See THE ANIMATIONS for why keying by destination is safe in this tree.
ikt_conv_handler.screenAnimations = {
	-- the four roots
	all_done       = { { "npc", "belly_laugh" } },
	turnin         = { { "npc", "nod_head_once" }, { "player", "greet" } },
	progress       = { { "npc", "nod_head_once" }, { "player", "greet" } },
	greeting       = { { "npc", "nod_head_once" }, { "player", "greet" } },

	-- the offer
	job_ask        = { { "player", "shrug_hands" } },
	job_pay        = { { "player", "shrug_shoulders" } },
	decline_later  = { { "player", "shake_head_no" }, { "npc", "nod_head_once" } },
	decline_flat   = { { "player", "dismiss" } },
	decline_nofit  = { { "player", "shake_head_no" }, { "npc", "nod" } },
	job_pay_thief  = { { "player", "nod" } },
	decline_busy   = { { "player", "dismiss" }, { "npc", "shrug_shoulders" } },

	-- the backstory, off "What is the job?"
	story_ask      = { { "player", "nod" }, { "npc", "explain" } },
	watched_ask    = { { "player", "rub_chin_thoughtful" } },
	closing_ask    = { { "player", "nod" }, { "npc", "pound_fist_palm" } },

	-- the backstory, off "If it pays well enough."
	story_pay      = { { "player", "nod" }, { "npc", "explain" } },
	watched_pay    = { { "player", "shrug_shoulders" } },
	closing_pay    = { { "npc", "pound_fist_palm" } },

	-- mid-quest
	progress_end   = { { "player", "shrug_shoulders" }, { "npc", "nod" } },
	abandon_press  = { { "player", "nod" } },
	abandon_direct = { { "player", "nod" }, { "npc", "shrug_shoulders" } },
	abandon_asked  = { { "player", "sigh_deeply" }, { "npc", "shrug_shoulders" } },

	-- turn-in, the long chain
	thief_asked    = { { "player", "thumb_up" } },
	praise_asked   = { { "player", "slump_head" }, { "npc", "pound_fist_palm" } },
	pay_asked      = { { "npc", "nod" } },
	notinterested  = { { "player", "shrug_hands" } },
	dontforget     = { { "player", "dismiss" }, { "npc", "point_accusingly" } },

	-- turn-in, the short chain
	thief_told     = { { "player", "nod" }, { "npc", "pound_fist_palm" } },
	pay_told       = { { "npc", "nod" } },
	farewell       = { { "player", "nod" }, { "npc", "belly_laugh" } },

	-- directions_ask (s_100) and directions_pay (s_88) carry none, in live too.
}

function ikt_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = serpentShardScreenPlay:getStage(pPlayer)

	-- Live's order. See THE ROOT, IN LIVE'S ORDER.
	if (stage == serpentShardScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("all_done")
	elseif (stage == serpentShardScreenPlay.STAGE_TURNIN) then
		return convoTemplate:getScreen("turnin")
	elseif (stage ~= 0) then
		-- s_67 "Already back?" -- anywhere between the grant and the second shard.
		return convoTemplate:getScreen("progress")
	end

	return convoTemplate:getScreen("greeting")
end

function ikt_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	if (self.grantScreens[screenID]) then
		serpentShardScreenPlay:startQuest(pPlayer)
	elseif (self.rewardScreens[screenID]) then
		serpentShardScreenPlay:finishQuest(pPlayer)
	elseif (self.abandonScreens[screenID]) then
		serpentShardScreenPlay:abandonQuest(pPlayer)
	end

	return screen:cloneScreen()
end
