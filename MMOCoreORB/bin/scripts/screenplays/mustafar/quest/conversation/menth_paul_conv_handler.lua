--[[
	Menth Paul -- conversation handler for som_kenobi_cursed_shard_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_menth_paul.lua, which carries the
	string-table provenance and the two corrections the live tree forced. This file routes by
	quest stage, plays the animations and settles the price.

	All state lives in cursedShardScreenPlay's persistent screenplay data on the player's ghost;
	nothing is kept here. One screenplay owns both quests, so its stages are what live's five
	task tests reduce to.

	FIVE OPENINGS, IN LIVE'S ORDER. One flag each, first match wins:

	  isTaskActive shard_2 givingUpShard  -> s_136 in_progress  STAGE_DISPOSE
	  shard_1 done, shard_2 neither       -> s_135 plea         -- see PLEA
	  shard_1 or shard_2 active, or
	    shard_2 done                      -> s_67  finished     STAGE_SHARD, STAGE_BROOD,
	                                                            STAGE_DONE
	  level > 60                          -> s_110 greeting     stage 0, Level 61+
	  default                             -> s_72  too_low      stage 0, under 61

	WHOSE LINE IS s_67 -- everyone holding the shard, not just the player who is done

	This file used to send STAGE_SHARD, STAGE_BROOD and STAGE_DISPOSE all to in_progress and
	keep s_67 for STAGE_DONE alone. Live does the opposite. s_67 -- "Since you took the
	crystal, my luck sure has turned!" -- goes to anyone whose shard quest is running or
	finished, because the sentence is about the sale, not about the ending. He is not
	congratulating the player on disposing of it; he is saying that getting rid of it fixed
	HIS luck, which was true the moment the money changed hands.

	s_136 is much narrower: live gates it on isTaskActive givingUpShard, the Wait for Signal
	task in _2 that is only up while the player is looking for someone to palm the shard off
	on. That is exactly STAGE_DISPOSE -- givingUpShard is a sibling of the volcano chain in
	the .qst, so it is active for the whole of _2 -- and it is the one state in which walking
	up to Menth Paul is an attempt to hand it back. Then, and only then, does he ask "What do
	you want..?" and refuse.

	ROOT CAUSE: taking the tone of the two screens as the state test. s_136 is curt and s_67
	is cheerful, so the curt one was given to the whole of the quest and the cheerful one held
	back as a reward for finishing. Live tests one task flag at a time. Reading it the old way
	also cost the tree its point -- s_137 and s_138 are both offers to give the crystal BACK,
	which is only a thing to say on the give-it-away branch.

	PLEA -- s_135, the second opener, which nothing here reaches yet

	Live has a fifth root: hasCompletedQuest(_1) and neither active nor completed on _2. That
	is a player who abandoned the disposal quest, and live sells him another shard -- s_135
	opens the same four options s_110 does. This screenplay has no abandon path: endBrood
	moves STAGE_BROOD straight to STAGE_DISPOSE and nothing takes _2 away again, so no stage
	satisfies the test and getInitialScreen never returns plea.

	The screen is in the tree anyway, wired as live wires it. It puts s_135 where it belongs
	instead of spending it inside the tree, and if an abandon hook is ever added the root is
	already there. Recorded rather than quietly dropped, and not pretended to work.

	Live also defines playerJedi and hermitChat2 conditions that its own tree never uses.
	Nothing here needs them.

	THE LEVEL GATE  --  61, not the .qst's 75

	The refusal line is shipped and is used as shipped: s_72, "I wish you were more experienced...
	I could really use some help.", the one string in the table that fits no other beat. Only the
	number changed. Menth Paul's server-side conversation gates his ask on a level test against
	60 -- the ask is reached when the player's level is greater than 60 -- so the first level that
	can take this job is 61.

	The condition is named levelTooLow and returns TRUE for the players who ARE high enough. The
	name is inverted relative to what it does; read the body, not the identifier. Q4P3 and the
	mining executive carry the same condition the same way round.

	The .qst's [list] Level 75 is a client-side display value. An earlier revision enforced it
	because the conversation had not been found yet. The number lives in
	cursedShardScreenPlay.requiredLevel, which this file compares against, so there is one place
	to change it and it is not here.

	THE PRICE

	The .qst awards Bank Credits 0 and has no cost task: SOE's quest file does not model the sale
	at all, because on the retail client the shard changed hands in the conversation, not in the
	quest. The string table is where the prices live -- s_118 and s_161 both ask a thousand, s_121
	and s_185 drop to 500 -- so those two numbers come from SOE's own text.

	Four "you don't have the money on you" strings shipped (s_154, s_134, s_177, s_225), one per
	accept screen. That is SOE telling us the check exists, so it is implemented here: if the
	player cannot cover the price, the handler redirects from the accept screen to the matching
	no_money screen and the quest does not start. Redirecting out of runScreenHandlers is the
	engine's own idiom (see cities/cantinas/bartender_conv_handler.lua).

	Live confirms the check and the shape of it: on each accept option it tests dontHave1000 or
	dontHave500 first and falls through to the grant, which is the redirect this file already
	made. Only the wallet arithmetic is ours -- live calls money.hasFunds and money.pay.

	The four "then take it for free" screens cost nothing -- he is desperate and gives up. A
	player who refuses to pay still ends up holding the shard, which is the point of the quest.

	Cash is spent before bank, matching how the rest of the codebase charges players.

	THE ANIMATIONS -- these were missing entirely

	Live fires 47, across 30 of the 32 screens. Every screen is reached exactly one way, so
	keying by destination cannot produce a disagreement. Four of the five roots carry one;
	runScreenHandlers runs on the initial screen as well, so they sit in the same table as the
	rest rather than in getInitialScreen.

	The accept options are the one place the destination is decided here rather than by the
	option, so the animations are looked up AFTER the money check and against the screen the
	player actually sees -- the no_money screens have their own pair, npc weeping instead of
	npc nod_head_multiple, and playing the accept screen's gestures over a refusal would read
	as him thanking a player he just turned away.

	Two screens get nothing: story_c2 (s_146) and story_d1 (s_125). Their opposite numbers in
	the other two story runs get nothing either -- story_a2 (s_169), story_b2 (s_217) -- but
	those are covered because the edge INTO them carries no gesture and the edge out does. All
	four are the same beat, the blue-glowing-man story itself, and live plays nothing over it.

	ROOT CAUSE of the omission: the tree was reconstructed from the string table, and a string
	table records text and nothing else -- no wiring, no actions, no gestures.
--]]

menth_paul_conv_handler = conv_handler:new {}

menth_paul_conv_handler.screenPlayName = "cursedShardScreenPlay"

-- accept screen -> { price, screen to send instead when the player is short }
menth_paul_conv_handler.priced = {
	accept_1000  = { 1000, "no_money_1000" },
	accept_500   = {  500, "no_money_500" },
	accept_1000b = { 1000, "no_money_1000b" },
	accept_500b  = {  500, "no_money_500b" },
}

-- screens where he hands it over for nothing
menth_paul_conv_handler.free = {
	free_1000 = true,
	free_500 = true,
	free_1000b = true,
	free_500b = true,
}

-- [destination screen] = { { actor, animation }, ... } in the order live plays them.
-- See THE ANIMATIONS.
menth_paul_conv_handler.screenAnimations = {
	-- the roots
	greeting        = { { "npc", "implore" } },
	plea            = { { "npc", "implore" } },
	too_low         = { { "npc", "sigh_deeply" } },
	in_progress     = { { "npc", "nervous" } },
	finished        = { { "npc", "greet" }, { "player", "nod" } },

	-- off the opener
	pitch_explain   = { { "player", "shrug_hands" } },
	pitch_sell      = { { "player", "shrug_shoulders" }, { "npc", "implore" } },
	come_back       = { { "player", "refuse_offer_affection" } },
	lost_everything = { { "player", "dismiss" }, { "npc", "heavy_cough_vomit" } },
	bye_plea        = { { "player", "nod" }, { "npc", "sigh_deeply" } },

	-- short pitch at 1000
	story_c1        = { { "player", "rub_chin_thoughtful" } },
	story_c3        = { { "player", "shrug_hands" } },
	no_money_1000   = { { "player", "shrug_shoulders" }, { "npc", "weeping" } },
	accept_1000     = { { "player", "shrug_shoulders" }, { "npc", "nod_head_multiple" } },
	free_1000       = { { "player", "shake_head_no" }, { "npc", "stamp_feet" } },

	-- short pitch, haggled to 500
	haggle_500      = { { "player", "shake_head_no" }, { "npc", "weeping" } },
	denies          = { { "player", "point_accusingly" }, { "npc", "shake_head_no" } },
	story_d3        = { { "player", "shrug_hands" } },
	no_money_500    = { { "player", "shrug_shoulders" }, { "npc", "weeping" } },
	accept_500      = { { "player", "shrug_shoulders" }, { "npc", "nod_head_multiple" } },
	free_500        = { { "player", "shake_head_no" }, { "npc", "stamp_feet" } },

	-- long pitch at 1000
	story_a1        = { { "player", "rub_chin_thoughtful" } },
	story_a3        = { { "player", "shrug_hands" } },
	no_money_1000b  = { { "player", "shrug_shoulders" }, { "npc", "weeping" } },
	accept_1000b    = { { "player", "shrug_shoulders" }, { "npc", "nod_head_multiple" } },
	free_1000b      = { { "player", "shake_head_no" }, { "npc", "stamp_feet" } },

	-- long pitch, dropped to 500
	drop_500        = { { "player", "slow_down" }, { "npc", "sigh_deeply" } },
	story_b1        = { { "player", "rub_chin_thoughtful" } },
	story_b3        = { { "player", "shrug_hands" } },
	no_money_500b   = { { "player", "shrug_shoulders" }, { "npc", "weeping" } },
	accept_500b     = { { "player", "shrug_shoulders" }, { "npc", "nod_head_multiple" } },
	free_500b       = { { "player", "shake_head_no" }, { "npc", "stamp_feet" } },

	-- he will not take it back
	refuse_back     = { { "player", "thumb_up" }, { "npc", "dismiss" } },
	refuse_evil     = { { "player", "nod_head_once" }, { "npc", "dismiss" } },

	-- story_c2 (s_146) and story_d1 (s_125) carry none, in live too.
}

function menth_paul_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = cursedShardScreenPlay:getStage(pPlayer)

	-- Live's order. See FIVE OPENINGS, IN LIVE'S ORDER. The plea root is live's
	-- second test and no stage here satisfies it; see PLEA.
	if (stage == cursedShardScreenPlay.STAGE_DISPOSE) then
		return convoTemplate:getScreen("in_progress")
	elseif (stage ~= 0) then
		-- STAGE_SHARD, STAGE_BROOD and STAGE_DONE: s_67, his luck has turned.
		return convoTemplate:getScreen("finished")
	end

	if (CreatureObject(pPlayer):getLevel() < cursedShardScreenPlay.requiredLevel) then
		return convoTemplate:getScreen("too_low")
	end

	return convoTemplate:getScreen("greeting")
end

function menth_paul_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local priced = self.priced[screenID]
	local pNextScreen = nil

	-- The money check first: it decides which screen the player sees, and the
	-- gestures belong to that screen. See THE ANIMATIONS.
	if (priced ~= nil) then
		if (self:takeCredits(pPlayer, priced[1])) then
			cursedShardScreenPlay:startQuest(pPlayer)
		else
			local convoTemplate = LuaConversationTemplate(pConvTemplate)

			pNextScreen = convoTemplate:getScreen(priced[2])
			screenID = priced[2]
		end
	elseif (self.free[screenID]) then
		cursedShardScreenPlay:startQuest(pPlayer)
	end

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	if (pNextScreen ~= nil) then
		return pNextScreen
	end

	return screen:cloneScreen()
end

-- true only if the whole price was taken; nothing is deducted on failure.
function menth_paul_conv_handler:takeCredits(pPlayer, price)
	if (pPlayer == nil or price <= 0) then
		return true
	end

	local cash = CreatureObject(pPlayer):getCashCredits()
	local bank = CreatureObject(pPlayer):getBankCredits()

	if (cash + bank < price) then
		return false
	end

	if (cash >= price) then
		CreatureObject(pPlayer):subtractCashCredits(price)
	else
		CreatureObject(pPlayer):subtractCashCredits(cash)
		CreatureObject(pPlayer):subtractBankCredits(price - cash)
	end

	return true
end
