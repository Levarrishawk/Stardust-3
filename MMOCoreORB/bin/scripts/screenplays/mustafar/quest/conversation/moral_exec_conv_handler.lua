--[[
	The mining corporation executive -- conversation handler for
	som_kenobi_moral_choice_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_moral_exec.lua, which
	carries the note on how it was reconstructed from the shipped string table.
	This file routes by quest stage, fires the grant and pays the corporation's
	reward. All state lives in moralChoiceScreenPlay's persistent screenplay data
	on the player's ghost; nothing is kept here.

	SIX OPENINGS, IN LIVE'S ORDER. None of this routing is invented -- the
	string table has a first line for each state, and the live script tests them
	in exactly this sequence:

	  done       s_171 epilogue   hasCompletedQuest
	  haveCore   s_140 has_core   isTaskActive gotCore
	  defected   s_45  betrayed   hasCompletedTask switchedSides
	  onQuest    s_139 progress   isQuestActive
	  level > 60 s_110 greeting
	  default    s_47  toolow

	The order is not cosmetic here, because done and defected overlap. Both of
	this quest's branches end in an Immediately Complete Quest task -- 9 on the
	corporation side, 14 on the miners' side -- so a player who sided with the
	miners and finished satisfies hasCompletedQuest AND hasCompletedTask
	switchedSides at once, and live's first-match wins.

	CORRECTING WHO HEARS "YOU HAVE RUINED ME"

	This file used to route both STAGE_TELL and STAGE_DONE_MINERS to betrayed.
	Only STAGE_TELL belongs there. s_45 is what he says in the window between
	the upload and the player telling the strike leader -- switchedSides is
	complete, the quest is still running. Once the miners' branch completes,
	live gives the same neutral s_171 the corporation branch gets: "I don't
	believe we have anything more to say to each other now, do we?"

	ROOT CAUSE: routing on the fiction rather than on the conditions. A player
	who defected has ruined him whether the quest is finished or not, so both
	defected stages were sent to the betrayal line. Live does not model an
	opinion; it models one flag, checked in one order, and completion is checked
	first. The two endings are indistinguishable to him afterwards -- which is
	the point of s_171 being neutral.

	THE LEVEL GATE  --  61, not the .qst's 75. No text is invented here either
	way: unlike Pwwoz Pwwa -- whose table shipped nothing of the kind, so his
	handler has to explain the refusal in a system message -- this executive has
	s_47: "I'm busy and you're too wet behind the ears. Come back when you've
	gained some experience and I may have a job for you." That line is used as
	shipped. Only the number changed. His server-side conversation gates the
	offer on a level test against 60 -- the offer is reached when the player's
	level is greater than 60 -- so the first level that can take this job is 61.

	The condition is named levelTooLow and returns TRUE for the players who ARE
	high enough. The name is inverted relative to what it does; read the body,
	not the identifier. Q4P3 and Menth Paul carry the same condition the same
	way round.

	The .qst's [list] Level = 75 is a client-side display value. An earlier
	revision enforced it because the conversation had not been found yet. The
	number lives in moralChoiceScreenPlay.requiredLevel, which this file compares
	against, so there is one place to change it and it is not here.

	STAGE_UPLOAD FALLS THROUGH TO s_139 ON PURPOSE. A player who has taken the
	miners' disk but not yet uploaded it is, as far as the executive knows,
	still running his errand -- "What are you doing back here already? Get out
	there and finish the job!" is exactly right, and s_45 is held back until the
	upload actually happens.

	REFUSING is not a hook. refuse_a (s_69) and refuse_b (s_138) both end the
	conversation and change no state, so the player can hail him again. Live
	fires no action on either -- checked, not assumed. The .qst models no
	abandon and the executive has no line for taking the job back.

	THE ANIMATIONS -- these were missing entirely

	Live fires 33, across 24 of the 25 screens. Every screen in this tree is
	reached exactly one way, so keying by destination cannot produce a
	disagreement. All six root screens carry one; runScreenHandlers runs on the
	initial screen as well, so they sit in the same table as the rest rather
	than in getInitialScreen.

	One screen gets nothing: grant_b (s_130), the "let me mark it down in your
	datapad" that grants the quest on the second chain. Its opposite number on
	the first chain, grant_a (s_70), does carry one. That is live, not an
	omission.

	ROOT CAUSE of the omission: the tree was reconstructed from the string
	table, and a string table records text and nothing else -- no wiring, no
	actions, no gestures.
--]]

moral_exec_conv_handler = conv_handler:new {}

moral_exec_conv_handler.screenPlayName = "moralChoiceScreenPlay"

-- the two "let me mark it down in your datapad" screens, one per pitch chain
moral_exec_conv_handler.grantScreens = {
	grant_a = true,
	grant_b = true,
}

-- the two reward speeches, one per attitude the player took on the way back
moral_exec_conv_handler.rewardScreens = {
	reward_a = true,
	reward_b = true,
}

-- [destination screen] = { { actor, animation }, ... } in the order live plays them.
-- See THE ANIMATIONS.
moral_exec_conv_handler.screenAnimations = {
	-- the six openings
	epilogue     = { { "npc", "dismiss" } },
	has_core     = { { "player", "greet" } },
	betrayed     = { { "npc", "stamp_feet" } },
	progress     = { { "npc", "point_accusingly" } },
	greeting     = { { "npc", "point_forward" }, { "player", "greet" } },
	toolow       = { { "npc", "dismiss" } },

	-- the two ways out of the greeting
	later        = { { "player", "shake_head_no" } },
	dismiss      = { { "player", "dismiss" }, { "npc", "rub_chin_thoughtful" } },

	-- chain A, off "That depends on what you need assistance with."
	pitch_a      = { { "player", "shrug_shoulders" } },
	plan_a       = { { "npc", "nod" } },
	grant_a      = { { "player", "nod" } },
	resist_a     = { { "player", "nod" }, { "npc", "shrug_hands" } },
	refuse_a     = { { "player", "dismiss" } },

	-- chain B, off "Sure am. What did you have in mind?"
	pitch_b      = { { "player", "nod" } },
	plan_b       = { { "npc", "nod" } },
	noother      = { { "player", "nod" } },
	walkin       = { { "player", "shrug_hands" }, { "npc", "nod" } },
	refuse_b     = { { "player", "shake_head_no" }, { "npc", "dismiss" } },

	-- the return, the peaceful attitude
	peace        = { { "npc", "belly_laugh" } },
	reward_a     = { { "npc", "nod" } },
	holo_a       = { { "player", "shrug_hands" }, { "npc", "thumb_up" } },

	-- the return, the pleased-with-himself attitude
	style        = { { "player", "shrug_shoulders" }, { "npc", "belly_laugh" } },
	reward_b     = { { "player", "shrug_hands" }, { "npc", "nod" } },
	holo_b       = { { "player", "point_accusingly" }, { "npc", "slow_down" } },

	-- grant_b (s_130) carries none, in live too.
}

function moral_exec_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = moralChoiceScreenPlay:getStage(pPlayer)

	-- Live's order. See SIX OPENINGS, IN LIVE'S ORDER -- done is tested before
	-- defected, and that is what decides the finished miners' player.
	if (stage == moralChoiceScreenPlay.STAGE_DONE_CORP or stage == moralChoiceScreenPlay.STAGE_DONE_MINERS) then
		return convoTemplate:getScreen("epilogue")
	elseif (stage == moralChoiceScreenPlay.STAGE_RETURN) then
		return convoTemplate:getScreen("has_core")
	elseif (stage == moralChoiceScreenPlay.STAGE_TELL) then
		return convoTemplate:getScreen("betrayed")
	elseif (stage ~= 0) then
		-- STAGE_CABLES, STAGE_CORE and STAGE_UPLOAD: s_139, "Get out there and
		-- finish the job!"
		return convoTemplate:getScreen("progress")
	end

	if (CreatureObject(pPlayer):getLevel() < moralChoiceScreenPlay.requiredLevel) then
		return convoTemplate:getScreen("toolow")
	end

	return convoTemplate:getScreen("greeting")
end

function moral_exec_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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

	if (self.grantScreens[screenID]) then
		moralChoiceScreenPlay:startQuest(pPlayer)
	elseif (self.rewardScreens[screenID]) then
		moralChoiceScreenPlay:finishForCorporation(pPlayer)
	end

	return pClonedScreen
end
