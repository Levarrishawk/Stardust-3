--[[
	The crazed Mustafarian hermit -- conversation handler for
	som_kenobi_main_quest_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_crazed_hermit.lua,
	which carries the note on how it was reconstructed, what the live tree
	corrected in it, and why both meetings live in one tree. This file picks the
	root, gates the Force options, plays the animations and fires the signals.

	WHAT THE .qst ASKS FOR, in order:
	  task 10  signal 'talkedHermit1'  -- the first meeting ends
	  task 14  Encounter som_kenobi_blistmok, Count 4, 5-50   ('attacked')
	  task 15  signal 'talkedHermit2'  -- the shard changes hands, SPARED
	  task 21  Destroy Multiple and Loot the hermit           -- KILLED
	Both endings are real endings; task 17 grants som_kenobi_main_quest_spared
	and task 22 grants som_kenobi_main_quest_killed. This handler never picks
	one -- the player does, by which screen they walk into.

	THE ROOT, IN LIVE'S ORDER, AND ITS DEFAULT -- the default was wrong

	Live tests four things and in this order:
	  hermitChat2  -> s_67   quiet     the wave is dead, the shard is in play
	  hermitChat1  -> s_93   greeting  the first meeting
	  underAttack  -> s_108  ambient   the blistmoks are on him
	  default      -> s_110  rest      everyone else

	The last line is the correction. This handler used to fall through to
	`greeting`, so a character who was not on som_kenobi_main_quest_1 at all --
	or who had already taken the shard -- got the first meeting handed to them.
	Live gives both of them s_110, "Please, leave me alone. I need to rest."
	The stage guard below is what makes the default mean what live means: not on
	STAGE_HUNT, or past it, is `rest`.

	ROOT CAUSE: writing the fall-through as "the beginning" rather than as "none
	of the above". The tree's own first screen is the greeting, so returning it
	when nothing else matched looked like the safe default. It is the opposite --
	it is the one screen that fires a quest signal, and it was reachable by
	anyone who walked up to him.

	THE FOUR FORCE OPTIONS ARE GATED -- this was missing entirely

	Live guards s_52, s_75, s_89 and s_104 with condition_playerJedi, which is
	jedi.isForceSensitive(player). This handler had no gate at all, so every
	player saw all four.

	Root cause: the tree was reconstructed from the string table, and a string
	table records an option's TEXT but not its condition. The "[Use the Force]"
	prefix is the only hint it carries, and the earlier revision read that as
	flavour rather than as a gate.

	Each of the four is the ONLY incoming edge to its reply, so for a
	non-sensitive mad_calm, mad_force, kill_fade and kill_forcestop are simply
	unreachable. Nothing else closes. Checked screen by screen:
	  gem   keeps s_44  -> curse -> madness, so the first meeting still ends
	  wants keeps s_64  -> nopain -> mad_demand, likewise
	  hold  keeps s_74 and s_77, so both sounds and one provocation survive
	  yell  keeps s_87 and s_88, so both killhim and one provocation survive
	Both handovers are ungated, and four of the six provocations are, so the
	spared ending and the killed ending are open to everyone.

	WHAT ENDS THE FIRST MEETING IS NOT WHAT STARTS THE FIGHT -- this was one list

	The earlier revision made him hostile on nine screens, on the grounds that
	all nine end with the voice shouting "kill him". Live splits them:

	  signalTalked1, no combat -- all four are in the FIRST meeting
	      madness s_50   mad_calm s_54   mad_demand s_102   mad_force s_106
	  removeInvuln + attack -- all six are in the SECOND meeting
	      kill_fade s_76      kill_promise s_81   kill_torment s_85
	      kill_forcestop s_90 kill_stop s_91      kill_gem s_96

	Three screens moved sides: s_54, s_102 and s_106. They read like combat
	because the voice says the same words, but the blistmok wave has not happened
	yet, and what live does there is fire the first signal and let the wave come.
	Making him hostile on them broke the quest outright -- the player killed him
	before task 14 could run, so the wave never spawned and the second meeting
	never existed.

	ROOT CAUSE: reading the screen TEXT for what the screen does. "Kill him now!"
	is a stage direction about the voice in the crystal, not an instruction to the
	server. The tree renames those three mad_* so the next reader does not group
	them by their last line again.

	HE STAYS PROVOKED. Once he has turned, there is nothing in the table for
	talking him back down and the .qst has no path back either, so the killed
	branch is committed at that point. That is not a design choice made here;
	SOE wrote no reconciliation line.

	THE ANIMATIONS -- these were missing entirely

	Live fires 45, across 27 screens, and every one of the 27 is reached exactly
	one way -- there is not a single screen in this tree with two inbound edges --
	so keying by destination screen cannot produce a disagreement. All four root
	screens carry one too; runScreenHandlers runs on the initial screen as well,
	so they sit in the same table as the rest rather than in getInitialScreen.

	Two screens get nothing: kill_promise (s_81) and kill_forcestop (s_90). That
	is live, not an omission.

	ROOT CAUSE of the omission: the tree was reconstructed from the string table,
	and a string table records text and nothing else -- no wiring, no conditions,
	no gestures.
]]

crazed_hermit_conv_handler = conv_handler:new {}

crazed_hermit_conv_handler.screenPlayName = "kenobiSpineScreenPlay"

-- the two screens where the shard actually changes hands
crazed_hermit_conv_handler.handoverScreens = {
	handover_free = true,   -- s_82, off sounds -- he is talked free of the voice
	handover_trade = true,  -- s_97, off killhim -- the player promises to hunt the voice down
}

-- the six screens live answers with removeInvuln + attack. All second meeting.
crazed_hermit_conv_handler.provokeScreens = {
	kill_fade = true,       -- s_76
	kill_promise = true,    -- s_81
	kill_torment = true,    -- s_85
	kill_forcestop = true,  -- s_90
	kill_stop = true,       -- s_91
	kill_gem = true,        -- s_96
}

-- the four screens live answers with signalTalked1. All first meeting, and
-- three of them sound exactly like the six above. See WHAT ENDS THE FIRST
-- MEETING IS NOT WHAT STARTS THE FIGHT.
crazed_hermit_conv_handler.firstMeetingEnds = {
	madness = true,     -- s_50
	mad_calm = true,    -- s_54
	mad_demand = true,  -- s_102
	mad_force = true,   -- s_106
}

-- option links whose option text is prefixed "[Use the Force]" in the string table.
-- Live guards all four with condition_playerJedi. See THE FOUR FORCE OPTIONS ARE GATED.
crazed_hermit_conv_handler.forceOptions = {
	mad_calm = true,        -- s_52,  off gem
	mad_force = true,       -- s_104, off wants
	kill_fade = true,       -- s_75,  off hold
	kill_forcestop = true,  -- s_89,  off yell
}

-- [destination screen] = { { actor, animation }, ... } in the order live plays them.
-- See THE ANIMATIONS for why keying by destination is safe in this tree.
crazed_hermit_conv_handler.screenAnimations = {
	-- the four roots
	quiet          = { { "npc", "shiver" } },
	greeting       = { { "npc", "bounce" } },
	ambient        = { { "npc", "clap_rousing" } },
	rest           = { { "npc", "dismiss" } },

	-- first meeting
	forced         = { { "npc", "squirm" } },
	gem            = { { "player", "rub_chin_thoughtful" }, { "npc", "gesticulate_wildly" } },
	curse          = { { "player", "slow_down" }, { "npc", "heavy_cough_vomit" } },
	madness        = { { "player", "offer_affection" }, { "npc", "scream" }, { "player", "taken_aback" } },
	mad_calm       = { { "player", "shush" }, { "npc", "scream" }, { "player", "taken_aback" } },
	critters       = { { "npc", "blame" } },
	wants          = { { "npc", "gesticulate_wildly" } },
	nopain         = { { "player", "point_accusingly" }, { "npc", "implore" } },
	mad_demand     = { { "player", "shake_head_no" }, { "npc", "scream" } },
	mad_force      = { { "player", "shush" }, { "npc", "scream" } },

	-- second meeting, the gentle road
	tired          = { { "player", "implore" }, { "npc", "sigh_deeply" } },
	hold           = { { "npc", "scared" } },
	sounds         = { { "player", "shake_head_no" }, { "npc", "helpme" } },
	handover_free  = { { "player", "offer_affection" }, { "npc", "shiver" } },
	free_end       = { { "player", "twitch" }, { "npc", "heavy_cough_vomit" } },
	kill_torment   = { { "player", "implore" }, { "npc", "twitch" } },
	kill_fade      = { { "npc", "twitch" } },

	-- second meeting, the shouting road
	yell           = { { "player", "point_accusingly" }, { "npc", "dismiss" } },
	kill_stop      = { { "npc", "twitch" } },
	killhim        = { { "npc", "squirm" } },
	kill_gem       = { { "player", "nod" }, { "npc", "point_accusingly" } },
	handover_trade = { { "player", "nod" }, { "npc", "shiver" } },
	trade_end      = { { "player", "twitch" }, { "npc", "heavy_cough_vomit" } },

	-- kill_promise (s_81) and kill_forcestop (s_90) carry none, in live too.
}

function crazed_hermit_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Live's order, and live's default. See THE ROOT, IN LIVE'S ORDER.
	if (kenobiSpineScreenPlay:getStage(pPlayer) == kenobiSpineScreenPlay.STAGE_HUNT) then
		local hermit = kenobiSpineScreenPlay:getHermitStage(pPlayer)

		if (hermit == kenobiSpineScreenPlay.HERMIT_WAVE_DONE) then
			-- s_67, "No more fun left. They are quiet now. Finally, quiet..."
			return convoTemplate:getScreen("quiet")
		elseif (hermit == kenobiSpineScreenPlay.HERMIT_NONE) then
			-- s_93, "Did you hurt those beautiful animals?"
			return convoTemplate:getScreen("greeting")
		elseif (hermit == kenobiSpineScreenPlay.HERMIT_MET) then
			-- talked to once, the blistmoks are still coming. s_108.
			return convoTemplate:getScreen("ambient")
		end
	end

	-- HERMIT_GAVE, and anyone who was never on the quest. s_110.
	return convoTemplate:getScreen("rest")
end

function crazed_hermit_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	if (self.handoverScreens[screenID]) then
		kenobiSpineScreenPlay:hermitHandsOverShard(pPlayer, pNpc)
	elseif (self.provokeScreens[screenID]) then
		kenobiSpineScreenPlay:hermitTurnsHostile(pPlayer, pNpc)
	elseif (self.firstMeetingEnds[screenID]) then
		kenobiSpineScreenPlay:hermitFirstMeetingDone(pPlayer, pNpc)

	-- gem, wants, hold and yell are the only screens carrying a Force option, and
	-- none of them is in any of the three tables above.
	elseif (not self:canUseTheForce(pPlayer)) then
		self:stripForceOptions(screen, LuaConversationScreen(pClonedScreen))
	end

	return pClonedScreen
end

-- Live's condition_playerJedi is jedi.isForceSensitive(player) -- force sensitive, NOT
-- Padawan. force_title_jedi_rank_01 is Padawan and is strictly narrower:
-- village_jedi_manager.lua:113 will not grant rank_01 until the character has 24
-- force-sensitive skills, and force_title_jedi_novice is what is awarded the moment a
-- character becomes force sensitive at all (village_jedi_manager.lua:59, fs_intro.lua:373).
-- helper_droid.lua:291 is the in-repo precedent for the novice test.
function crazed_hermit_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")
end

-- Rebuilds the option list without the Force pushes. Option indices are 0-based:
-- conv_handler passes the client's selectedOption straight to getOptionLink.
function crazed_hermit_conv_handler:stripForceOptions(screen, clonedConversation)
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
