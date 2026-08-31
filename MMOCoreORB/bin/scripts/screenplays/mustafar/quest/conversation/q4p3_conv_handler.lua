--[[
	Q4P3 -- conversation handler for som_kenobi_collectors_business_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_q4p3.lua, which carries the note on
	how it was checked against Q4P3's live server-side conversation. This file routes, fires the
	three state changes the .qst asks for -- quest start, abandon, reward -- and plays the
	animations.

	All state lives in collectorsBusinessScreenPlay's persistent screenplay data on the player's
	ghost; nothing is kept here. readScreenPlayData returns "" for a key never written, which is
	why getStage does "tonumber(...) or 0".

	THE LEVEL GATE  --  61, not the .qst's 75

	The refusal line is shipped and is used as shipped: s_122, "you seem to lack the experience
	to assist me". Only the number changed. Q4P3's server-side conversation gates his briefing
	on a level test against 60 -- the briefing is reached when the player's level is greater
	than 60 -- and s_122 is the fallback screen every other branch falls through to. So the
	first level that can take this job is 61.

	The condition is named levelTooLow and returns TRUE for the players who ARE high enough.
	The name is inverted relative to what it does; read the body, not the identifier. Menth
	Paul and the mining executive carry the same condition the same way round.

	The .qst's [list] Level 75 is a client-side display value. An earlier revision enforced it
	because the conversation had not been found yet. The number lives in
	collectorsBusinessScreenPlay.requiredLevel, which this file compares against, so there is
	one place to change it and it is not here.

	WHERE THE ACTIONS FIRE  --  one screen later than they used to

	Live, each action hangs off the player's OPTION, and fires before the screen that option
	leads to is shown. Core3 gives runScreenHandlers the screen the player arrived AT, so the
	faithful place for an action is the screen the option leads to -- not the screen the option
	is listed on.

	An earlier revision put the quest start and the reward one screen too early, on the screen
	that offers the last option rather than the screen that option reaches. The visible bug is
	small but real: a player who opened accept_civil and then walked away without clicking
	"Good, looks like I'm set" still got the quest. Both now fire on the farewell:

	    start   bye_all_set (s_76) and bye_marvelous (s_150)   -- was accept_civil / accept_rude
	    reward  bye_kind (s_165) and bye_money (s_172)         -- was reward / reward_rude
	    abandon give_up (s_158) and give_up_rude (s_133)       -- already correct

	The two abandons were right by luck rather than by rule: their options happen to lead
	straight to a farewell, so "screen the option is on" and "screen it leads to" coincide.

	THE ANIMATIONS  --  and a correction about where they could have lived

	This file and the tree both used to say the animations sit in code "because a Core3
	ConvoScreen has no animation field". That is false. ConvoScreen reads "animation" and
	"playerAnimation" off each screen and plays them when the screen is sent
	(ConversationScreen.h, readObject and sendTo), and seven other Mustafar trees here
	already use them. The claim was written from not finding the fields rather than from
	looking for them -- the same mistake as the .qst level gate two sections up.

	The table stays, and that it is safe is checked rather than assumed. A screen-keyed
	table only loses data when two options reach the SAME screen carrying DIFFERENT
	gestures; in this conversation no screen does, so this plays exactly what live plays.
	Obi-Wan's does, in four places, which is why his handler is keyed by option instead --
	see THE ANIMATIONS in obi_wan_conv_handler.lua.

	Q4P3's conversation fires 30 of them. 25 hang off player options and are in the table
	below, keyed by the screen the option leads to -- same rule as the actions. 4 more are the
	"nod" on each opening that starts a conversation, and 1 is Q4P3's own "greet"; those five
	are in getInitialScreen.

	All but the "greet" animate the PLAYER. They are the player's own reactions to what the
	droid just said, not the droid's gestures, and reading them the other way round would put
	a belly laugh on a protocol droid being threatened.

	bye_money carries two, in order. Live they straddle the reward signal -- point_accusingly,
	signal, dismiss -- and here both play and then the signal is sent. A sendSignal is not
	something the player can see happen, so the order between them is not observable.

	The screens with no entry have no animation live; they are absent rather than defaulted,
	so a missing key means SOE fired nothing there.
--]]

q4p3_conv_handler = conv_handler:new {}

q4p3_conv_handler.screenPlayName = "collectorsBusinessScreenPlay"

-- Keyed by the screen the player's option LEADS TO. See THE ANIMATIONS.
q4p3_conv_handler.screenAnimations = {
	-- Off the briefing offer, s_106.
	bye_not_me           = { "shake_head_no" },
	bye_leave            = { "shake_head_disgust" },
	ask_civil            = { "shrug_shoulders" },
	ask_rude             = { "belly_laugh" },

	-- The civil briefing.
	from_the_droids      = { "shrug_hands" },
	the_master           = { "rub_chin_thoughtful" },
	bye_all_set          = { "goodbye" },

	-- The rude briefing.
	how_you_know_rude    = { "rub_chin_thoughtful" },
	from_the_droids_rude = { "pound_fist_palm" },
	coords_rude          = { "shrug_shoulders" },
	the_task_rude        = { "sigh_deeply" },
	the_master_rude      = { "rub_chin_thoughtful" },
	bye_marvelous        = { "goodbye" },

	-- Mid-quest. still_on_it_rude has none.
	give_up_rude         = { "shake_head_disgust" },
	still_on_it          = { "goodbye" },
	give_up              = { "goodbye" },

	-- The civil turn-in.
	not_it               = { "nod_head_multiple" },
	fragment             = { "rub_chin_thoughtful" },
	reward               = { "shrug_shoulders" },
	bye_kind             = { "bow" },

	-- The rude turn-in.
	not_it_rude          = { "mock" },
	fragment_rude        = { "sigh_deeply" },
	reward_rude          = { "rub_chin_thoughtful" },
	bye_money            = { "point_accusingly", "dismiss" },
}

function q4p3_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = collectorsBusinessScreenPlay:getStage(pPlayer)

	if (stage == 0) then
		if (CreatureObject(pPlayer):getLevel() < collectorsBusinessScreenPlay.requiredLevel) then
			-- The one opening where the droid moves and the player does not.
			CreatureObject(pNpc):doAnimation("greet")

			return convoTemplate:getScreen("too_low")
		end

		CreatureObject(pPlayer):doAnimation("nod")

		return convoTemplate:getScreen("greeting")
	end

	-- Every opening that starts a real conversation opens on the same player nod.
	CreatureObject(pPlayer):doAnimation("nod")

	if (stage == collectorsBusinessScreenPlay.STAGE_RETURN) then
		return convoTemplate:getScreen("turn_in")
	elseif (stage == collectorsBusinessScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("finished")
	end

	return convoTemplate:getScreen("in_progress")
end

function q4p3_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			CreatureObject(pPlayer):doAnimation(animations[i])
		end
	end

	-- Both briefings end at the same handover -- scanner, communicator, coordinates -- so both
	-- farewells start the quest. See WHERE THE ACTIONS FIRE for why it is the farewell and not
	-- the handover screen itself.
	if (screenID == "bye_all_set" or screenID == "bye_marvelous") then
		collectorsBusinessScreenPlay:startQuest(pPlayer)

	-- .qst has no abandon task; the strings do (s_158 / s_133). Giving up puts the player back
	-- to stage 0 so the briefing can be taken again -- the [list] block says allowRepeats true.
	elseif (screenID == "give_up" or screenID == "give_up_rude") then
		collectorsBusinessScreenPlay:abandonQuest(pPlayer)

	-- task 19 Reward. Live this is a "talkedDroid" signal fired as the player takes his leave,
	-- one screen after Q4P3 says he is paying.
	elseif (screenID == "bye_kind" or screenID == "bye_money") then
		collectorsBusinessScreenPlay:awardQuest(pPlayer)
	end

	return pClonedScreen
end
