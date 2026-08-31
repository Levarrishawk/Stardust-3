--[[
	Pwwoz Pwwa -- conversation handler for som_kenobi_samaritan_1 and _2.

	The tree is in mobile/conversations/mustafar/som_kenobi_pwwoz_pwwa.lua, which
	carries the note on how it was reconstructed from the shipped string table.
	This file routes by quest stage, fires the grant, and settles the one decision
	the quest is built around. All state lives in samaritanScreenPlay's persistent
	screenplay data on the player's ghost; nothing is kept here.

	SIX OPENINGS IN LIVE'S ORDER. One flag each, first match wins:

	  isTaskActive killIthorian  -> s_82  enraged      STAGE_POSSESSED
	  isQuestActive/Completed _2 -> s_225 grudge       STAGE_DONE_KEPT
	  hasCompletedQuest _1       -> s_226 epilogue     STAGE_DONE_KILLED
	  isTaskActive returnPwwoz   -> s_173 has_crystal  STAGE_DECIDE
	  isQuestActive _1           -> s_172 progress     STAGE_ACTIVE, STAGE_HUNT
	  default                    -> s_110 greeting     no quest

	Live's third test is hasCompletedQuest _1 AND NOT hasCompletedQuest _2, which
	after the keptCrystal test above it can only be the player who killed him.
	The stages here are mutually exclusive, so the order below is live's for
	readability rather than for correctness.

	THE POSSESSED OPENING -- s_82, not s_186

	som_kenobi_samaritan_1.qst task 9 is a Destroy Multiple on Pwwoz himself, so
	a player who hands the crystal over and then walks away has an unfinished
	kill step. This file used to put s_186 -- the give screen -- back on screen
	for him and re-aggro on sight. Live gives that player a screen of his own:
	s_82 "You will not escape my wrath, %TU!", with one option, s_84 "If you
	think you can take me. Let's do this!", answered by s_85 and the fight.

	So the re-aggro moved one screen later, onto enraged_fight. Live puts its
	removeInvuln2 and secondAttack there and nothing at all on s_82: hailing him
	is not accepting. samaritanScreenPlay:giveCrystal is idempotent, so the
	second call only re-arms the fight -- the crystal is taken the first time.

	ROOT CAUSE: reusing a screen the player had already seen instead of looking
	for the one that was missing. s_186 fitted the state well enough to stop the
	search, and three strings that had been written off as combat barks were
	sitting unused in the same table. See CORRECTING THE BARKS in the tree.

	THE LEVEL GATE, AND THE ONE DEVIATION IN THIS FILE

	som_kenobi_samaritan_1.qst's [list] block says Level = 75, and 75 is what is
	enforced here -- but for a weaker reason than it looks.

	A .qst [list] level is a client-side display value. Where a Mustafar quest is
	really gated the number comes from the giver's server-side conversation:
	Menth Paul, the mining executive and Q4P3 each test level against 60, so each
	enforces 61 and each ignores the 75 its .qst displays. Pwwoz carries no level
	test -- his live conversation defines six conditions, playerJedi, foundCrystal,
	onQuest, keptCrystal, gaveCrystal and killPwwoz, and not one of them looks at
	level. That was inferred from the absence of a refusal line before the live
	script was read; it is now confirmed from the script itself. There is no
	better number to replace his 75 with, so it stands as the fallback rather
	than as a gate anyone found.

	Pwwoz shipped no refusal line either. Menth Paul's table has s_72 ("I wish
	you were more experienced..."); Pwwoz's has nothing of the kind. So the
	refusal is stated in a system message and the conversation is routed to s_114
	-- "Bah! What could be more...ex.. excuse me, where's my manners. Have a nice
	day." -- which is the shipped brush-off. The system message is the deviation:
	it is text SOE did not write, and it exists only because leaving the player
	with s_114 alone gives no reason for the refusal.

	THE FORCE GATE

	Four of the player's options are prefixed "[Use the Force]" in SOE's own
	string table (s_181, s_193, s_208, s_218) and each is answered by Pwwoz
	fighting the suggestion off (s_182, s_195, s_209, s_220). Those are mind
	tricks, so a non-Jedi must not see them; they are stripped at runtime the
	same way cursed_shard_sucker_conv_handler strips its three. Every screen that
	carries one also carries a plain give and a plain keep, so stripping never
	corners a player.

	s_195 is the odd one out: it is a Force screen that ends the conversation
	itself rather than handing the choice back, so it is a keep screen in its own
	right and is listed as one below.

	WALKING AWAY

	refuse_a (s_125) and refuse_b (s_171) turn the offer down and change no state
	-- the player can hail him again. The .qst models no abandon and Pwwoz has no
	line for taking the job back, so neither is a hook. Confirmed against live:
	neither carries an action.

	THE ANIMATIONS -- these were missing entirely

	Live fires 68, across 35 of the 38 screens. Three get nothing: blunt, where
	the player is brusque and Pwwoz answers flat, and the two halves of the
	possessed opening, where he is past gesturing.

	Keying by destination is safe here even though give (s_186) and keep (s_185)
	each have seven inbound edges. Every give edge plays player:sigh_deeply then
	npc:heavy_cough_vomit and every keep edge plays player:shake_head_no then
	npc:point_accusingly, whichever of the four attitudes and two Force screens
	the player came through. Live wrote the two endings once and let all seven
	roads reach them unchanged.

	The five root screens that carry a gesture -- greeting, progress,
	has_crystal, grudge and epilogue -- sit in the same table as the rest,
	because runScreenHandlers runs on the initial screen too.

	ROOT CAUSE of the omission: the tree was reconstructed from the string table,
	and a string table records text and nothing else -- no wiring, no actions, no
	gestures.
--]]

pwwoz_pwwa_conv_handler = conv_handler:new {}

pwwoz_pwwa_conv_handler.screenPlayName = "samaritanScreenPlay"

-- option links whose option text is prefixed "[Use the Force]" in the string table
pwwoz_pwwa_conv_handler.forceOptions = {
	obsessed_force = true,
	lied_force = true,
	reward_force = true,
	tired_force = true,
}

-- the two directions screens; each hands out the quest
pwwoz_pwwa_conv_handler.grantScreens = {
	directions_a = true,
	directions_b = true,
}

-- .qst signal giveCrystal. enraged_fight is the second call, which only re-arms
-- the fight; see THE POSSESSED OPENING.
pwwoz_pwwa_conv_handler.giveScreens = {
	give = true,
	enraged_fight = true,
}

-- [destination screen] = { { actor, animation }, ... } in the order live plays
-- them. See THE ANIMATIONS for why keying by destination is safe here.
pwwoz_pwwa_conv_handler.screenAnimations = {
	-- the openings; enraged carries none
	greeting         = { { "npc", "bow" }, { "player", "greet" } },
	progress         = { { "npc", "stamp_feet" } },
	has_crystal      = { { "npc", "celebrate" }, { "player", "greet" } },
	grudge           = { { "npc", "point_accusingly" }, { "player", "sigh_deeply" } },
	epilogue         = { { "npc", "bow" } },

	-- the offer, and the one way out of it
	busy             = { { "player", "shakefist" }, { "npc", "bow" } },
	polite           = { { "player", "nod" } },
	fleas_a          = { { "npc", "nod" } },
	what_a           = { { "npc", "shrug_hands" } },
	trouble_a        = { { "npc", "implore" } },
	directions_a     = { { "player", "slow_down" }, { "npc", "offer_affection" } },
	refuse_a         = { { "player", "slow_down" }, { "npc", "stamp_feet" }, { "player", "taken_aback" } },
	fleas_b          = { { "player", "laugh" }, { "npc", "nod" } },
	what_b           = { { "player", "nod" }, { "npc", "shrug_hands" } },
	trouble_b        = { { "player", "wtf" }, { "npc", "implore" } },
	directions_b     = { { "player", "slow_down" }, { "npc", "offer_affection" }, { "player", "refuse_offer_affection" } },
	refuse_b         = { { "player", "shake_head_disgust" }, { "npc", "stamp_feet" }, { "player", "cuckoo" } },

	-- the decision
	obsessed         = { { "player", "rub_chin_thoughtful" }, { "npc", "stamp_feet" } },
	obsessed_force   = { { "player", "wave_finger_warning" }, { "npc", "twitch" } },
	lied             = { { "player", "shake_head_no" }, { "npc", "gesticulate_wildly" } },
	lied_force       = { { "player", "wave_finger_warning" }, { "npc", "twitch" } },
	reward_asked     = { { "player", "slow_down" }, { "npc", "squirm" } },
	reward_force     = { { "player", "wave_finger_warning" }, { "npc", "shake_head_disgust" } },
	tired            = { { "player", "shake_head_no" } },
	tired_force      = { { "player", "wave_finger_warning" }, { "npc", "shake_head_disgust" } },
	give             = { { "player", "sigh_deeply" }, { "npc", "heavy_cough_vomit" } },
	keep             = { { "player", "shake_head_no" }, { "npc", "point_accusingly" } },

	-- afterwards
	sorry            = { { "player", "hug_tandem" }, { "npc", "shake_head_no" } },
	farewell_a       = { { "player", "goodbye" }, { "npc", "bow" }, { "player", "goodbye" } },
	ghost_a          = { { "player", "rub_chin_thoughtful" }, { "npc", "rub_chin_thoughtful" } },
	farewell_ghost_a = { { "player", "nod" }, { "npc", "bow" }, { "player", "goodbye" } },
	sloppy           = { { "player", "rub_chin_thoughtful" }, { "npc", "belly_laugh" } },
	farewell_b       = { { "player", "goodbye" } },
	ghost_b          = { { "player", "rub_chin_thoughtful" }, { "npc", "rub_chin_thoughtful" } },
	farewell_ghost_b = { { "player", "nod" }, { "npc", "bow" }, { "player", "goodbye" } },

	-- blunt (s_151), enraged (s_82) and enraged_fight (s_85) carry none, in
	-- live too.
}

-- .qst signal keepCrystal. lied_force is here because s_195 ends on "I will have
-- my revenge. Mark my words!" without offering the choice again.
pwwoz_pwwa_conv_handler.keepScreens = {
	keep = true,
	lied_force = true,
}

function pwwoz_pwwa_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = samaritanScreenPlay:getStage(pPlayer)

	if (stage == 0) then
		if (CreatureObject(pPlayer):getLevel() < samaritanScreenPlay.requiredLevel) then
			CreatureObject(pPlayer):sendSystemMessage("Pwwoz Pwwa will not trust his errand to someone of your experience. (Requires combat level "
				.. samaritanScreenPlay.requiredLevel .. ".)")

			return convoTemplate:getScreen("busy")
		end

		return convoTemplate:getScreen("greeting")
	elseif (stage == samaritanScreenPlay.STAGE_DECIDE) then
		return convoTemplate:getScreen("has_crystal")
	elseif (stage == samaritanScreenPlay.STAGE_POSSESSED) then
		-- s_82, not s_186; see THE POSSESSED OPENING.
		return convoTemplate:getScreen("enraged")
	elseif (stage == samaritanScreenPlay.STAGE_DONE_KEPT) then
		return convoTemplate:getScreen("grudge")
	elseif (stage == samaritanScreenPlay.STAGE_DONE_KILLED) then
		return convoTemplate:getScreen("epilogue")
	end

	-- STAGE_ACTIVE and STAGE_HUNT: s_172, "You need to find that crystal. Now!"
	return convoTemplate:getScreen("progress")
end

function pwwoz_pwwa_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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

	-- s_82 is the one line in this table with a chat token in it. See
	-- CORRECTING THE BARKS in the tree.
	if (screenID == "enraged") then
		clonedConversation:setDialogTextTU(CreatureObject(pPlayer):getFirstName())
	end

	if (self.grantScreens[screenID]) then
		samaritanScreenPlay:startQuest(pPlayer)
	elseif (self.giveScreens[screenID]) then
		samaritanScreenPlay:giveCrystal(pPlayer, pNpc)
	elseif (self.keepScreens[screenID]) then
		samaritanScreenPlay:keepCrystal(pPlayer)
	end

	-- Independent of the hooks above: no screen that carries a mind trick is
	-- also a hook screen today, and an elseif would only hide it if one ever is.
	if (not self:canUseTheForce(pPlayer)) then
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
function pwwoz_pwwa_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")
end

-- Rebuilds the option list without the mind tricks. Option indices are 0-based:
-- conv_handler passes the client's selectedOption straight to getOptionLink.
function pwwoz_pwwa_conv_handler:stripForceOptions(screen, clonedConversation)
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
