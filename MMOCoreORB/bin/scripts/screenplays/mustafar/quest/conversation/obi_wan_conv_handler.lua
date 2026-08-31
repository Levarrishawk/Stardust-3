--[[
	Ben Kenobi -- conversation handler for the whole Mustafar Kenobi arc.

	The tree is in mobile/conversations/mustafar/som_kenobi_obi_wan.lua, which
	carries the note on why the two shipped tables were merged into one template
	and why this is not obi_wan_ghost.

	WHAT THE .qst FILES ASK FOR. Six quests hang off this one conversation, and
	every one of them is a Wait-for-Signal that this handler has to fire:
	  som_obi_wan_signal_1     task 0  signal 'dyingMiner'       given at pro_task
	  som_obi_wan_signal_2     task 0  signal 'returnToObiWan'   fired at pro_west
	  som_kenobi_main_quest_1                                    given at give_quest_a/b
	  som_kenobi_main_quest_spared / _killed
	                           task 0  signal 'talkedKenobi1'    fired at send_a..d
	  som_kenobi_main_quest_3  task 0  signal 'talkedKenobi2'    fired at goluck_a..d
	                           task 6  signal 'talkedKenobi3'    fired at hurry_a/b
	Nothing else in those files touches him.

	TWO PLACES, ONE CREATURE. s_266 and s_302 send the player to "the
	northeastern shoreline between the old and new mining facilities" for his
	help; s_162, "I'm glad to see you made it", is at the chamber entrance,
	where s_269 has already promised "I can't come with you, but will meet you
	there". So the screenplay spawns him twice from the same template and tags
	each spawn, and this handler asks which one is being talked to before it
	picks a screen. Everything else routes off the spine stage.

	THE A/B TWINS. The shipped table carries duplicated subtrees. urgency_a and
	urgency_b hang off the spared branch, urgency_c and urgency_d off the killed
	one -- that is how the tree is already wired -- so the chamber briefing
	follows the same split: chamber_a (which feeds where_a/where_b) for a player
	who spared the hermit, chamber_b (where_c/where_d) for one who killed him.

	THE GATE -- this was wrong, and the .qst is why.

	This file used to gate the main quest on som_kenobi_main_quest_1's Level 75
	and say so out loud: "nothing contradicts the 75 and there is nothing better
	to put in its place." Both halves were false.

	Obi-Wan's conversation does carry a gate, and it is not a level. Live's
	condition_startFirstQuest ANDs nine completed side quests -- collectors
	business, cursed shard, hidden treasure, historian, moral choice, reunite
	shard, samaritan, serpent shard, symbiosis. Finish Mustafar's side content
	and he talks to you; miss one and he does not. There is no level test
	anywhere in the file: grep it for "level" and nothing comes back.

	The root cause is the same one this arc keeps producing. A [list] Level is a
	client-side display value; the real gate lives in the giver's server-side
	conversation. That much the old note had right -- Menth Paul, the mining
	executive and Q4P3 each test level against 60 and so enforce 61. What it got
	wrong was the next step: not finding a level test in Obi-Wan's conversation,
	it kept the .qst's number as a fallback instead of reading the rest of the
	file. The gate was sitting three conditions further down. Absence of the
	thing being looked for is not absence of a gate.

	So the number is gone, not corrected. kenobiSpineScreenPlay.requiredLevel is
	deleted rather than re-valued, and the test is
	kenobiSpineScreenPlay:hasCompletedPrerequisites, which carries the nine and
	the mapping onto this tree's screenplay stages.

	What a player who has not finished the nine hears is unchanged: pro_nothing,
	s_34, "I have nothing more for you at this time". That is still right, and
	for a reason worth writing down, because the merged template makes it look
	wrong. In live the spine's own fall-through is s_356, not s_34. But s_34 is
	the PROLOGUE conversation's _defaultCondition, and a player who has finished
	the prologue and nothing else is exactly who reaches it there. Since the two
	tables are merged here, s_34 is the faithful line for that player and s_356
	stays where it is, on the stages that have no business with him.

	THE ONE ACTION DELIBERATELY NOT WIRED. Live fires action_finalScriptVar on
	three screens -- s_170, s_172 and s_321 -- and all it does is set the objvar
	sawObiwanAtLauncher to 1. Nothing reads it. Not this conversation, not any
	other conversation, not a screenplay, not a quest: the whole shipped script
	tree writes that name once and reads it never. It is a dead flag, so nothing
	here writes one. This is a checked absence, not a missed action.

	THE ANIMATIONS, AND THE FIVE THAT COULD NOT GO IN THE TREE.

	Live plays 73 animations across this conversation: 72 hung off player
	responses and one on the opening line. They are not decoration. The shipped
	script is specific about which gesture goes where -- Obi-Wan shakes his head
	at one answer and nods at another, and the player twitches at bad news.

	ConvoScreen already has a slot for this. The engine reads "animation" and
	"playerAnimation" off each screen and plays them when the screen is sent
	(ConversationScreen.h, sendTo). Seven other Mustafar trees here use it. So
	that is where 69 of them went: in the tree, declaratively, no code.

	It does not fit all of them, because live keys an animation to the OPTION
	and the engine field keys it to the SCREEN. Almost always that is the same
	thing. Five times it is not, because two different answers reach the same
	screen carrying different gestures. s_188 is the clearest: reached from
	s_186 it plays nod, reached from s_184 it plays rub_chin_thoughtful. A field
	on s_188 can only hold one of the two, and would then play it on both paths.

	The four screens whose inbound answers disagree are hist_a_crystal,
	hist_a_krow, hist_b and hist_b_krow. Their five gestures are the
	edgeAnimations table below, keyed by the screen the player was LOOKING AT
	and the option they picked, and played from here instead.

	WHY THAT KEY WORKS. runScreenHandlers runs before the new screen is sent
	(ConversationObserverImplementation.cpp:133, then :136), and the session's
	last screen is only updated on the send path (ConversationScreen.h:232). So
	inside this function getLastConversationScreen() still returns the screen
	the option was picked FROM. selectedOption is the engine's index into that
	screen's option list and it is 0-based (ConversationScreen.h, options.get),
	which is the +1 in playEdgeAnimation.

	The split is deliberate: the tree holds everything the tree can hold, and
	code holds only the five it cannot.

	NOT GATED ON BEING A JEDI. Every prologue line calls the player "young
	Jedi", but no .qst carries a Jedi requirement and neither conversation tests
	for one -- all thirteen of the spine's conditions are quest-state tests. So
	none is imposed here.

	NO STAFF BYPASS. Live's condition_startFirstQuest opens with isGod(player).
	Nothing equivalent is wired here; a staff bypass is a decision, not a
	reconstruction, so it is flagged rather than invented.
]]

obi_wan_conv_handler = conv_handler:new {}

obi_wan_conv_handler.screenPlayName = "kenobiSpineScreenPlay"

-- The four send-offs, all firing 'talkedKenobi1'.
obi_wan_conv_handler.sendScreens = {
	send_a = true,  -- s_287
	send_b = true,  -- s_289
	send_c = true,  -- s_326
	send_d = true,  -- s_340
}

-- The four chamber farewells, all firing 'talkedKenobi2'.
obi_wan_conv_handler.goluckScreens = {
	goluck_a = true,  -- s_277
	goluck_b = true,  -- s_285
	goluck_c = true,  -- s_299
	goluck_d = true,  -- s_307
}

-- The two "now hurry" screens at the entrance stone, firing 'talkedKenobi3'.
obi_wan_conv_handler.hurryScreens = {
	hurry_a = true,  -- s_170
	hurry_b = true,  -- s_172
}

-- The two farewells that hand over som_kenobi_main_quest_1. give_quest_b used to
-- be s_351, which gives nothing; see the swap note in the tree for why it moved.
obi_wan_conv_handler.questScreens = {
	give_quest_a = true,  -- s_270
	give_quest_b = true,  -- s_309
}

-- The five gestures that could not live on a screen, because another answer
-- reaches the same screen carrying a different one. Keyed by the screen being
-- looked at, then by the option picked. See THE ANIMATIONS above.
obi_wan_conv_handler.edgeAnimations = {
	who_b = {
		[1] = { {"player", "nod"} },  -- s_174, into hist_b
	},
	hist_a = {
		[2] = { {"player", "nod"} },  -- s_186, into hist_a_crystal
	},
	hist_a_sith = {
		[1] = { {"player", "rub_chin_thoughtful"} },  -- s_184, into hist_a_crystal
	},
	hist_a_vanquished = {
		[1] = { {"player", "nod"} },  -- s_276, into hist_b_krow
	},
	hist_b_weak = {
		[1] = { {"player", "shrug_shoulders"} },  -- s_344, into hist_a_krow
	},
}

--------------------------------------------------------------------------------
-- The man at the chamber entrance. He has nothing to say until the player has
-- been sent there, and nothing after Sinistro is dead but s_333.
--------------------------------------------------------------------------------

function obi_wan_conv_handler:getChamberScreen(pPlayer, convoTemplate)
	local stage = kenobiSpineScreenPlay:getStage(pPlayer)

	if (stage >= kenobiSpineScreenPlay.STAGE_DONE) then
		-- s_333, "You're a hero unlike any others, my young friend."
		return convoTemplate:getScreen("hero")
	elseif (stage == kenobiSpineScreenPlay.STAGE_LAIR) then
		-- already told how to get in, and back out here again. s_313.
		return convoTemplate:getScreen("ready_enter")
	elseif (stage == kenobiSpineScreenPlay.STAGE_ENTRANCE) then
		-- s_162, the meeting the send-off promised.
		return convoTemplate:getScreen("chamber_meet")
	end

	-- s_356, "My business is not with you, %TU. Please step aside."
	return convoTemplate:getScreen("aside")
end

--------------------------------------------------------------------------------
-- The man on the shoreline. Prologue first, then the spine.
--------------------------------------------------------------------------------

function obi_wan_conv_handler:getShoreScreen(pPlayer, convoTemplate)
	local stage = kenobiSpineScreenPlay:getStage(pPlayer)

	-- prologue -- som_obi_wan_kenobi.stf
	if (stage == kenobiSpineScreenPlay.STAGE_START) then
		return convoTemplate:getScreen("pro_greeting")
	elseif (stage == kenobiSpineScreenPlay.STAGE_MINER) then
		-- s_19, "I've given you your task, young Jedi."
		return convoTemplate:getScreen("pro_progress")
	elseif (stage == kenobiSpineScreenPlay.STAGE_REPORT) then
		-- s_20, "Have you done as I asked, young Jedi?"
		return convoTemplate:getScreen("pro_return")
	end

	-- spine -- som_kenobi_obi_wan.stf
	if (stage == kenobiSpineScreenPlay.STAGE_WEST) then
		-- Live's condition_startFirstQuest. See THE GATE.
		if (not kenobiSpineScreenPlay:hasCompletedPrerequisites(pPlayer)) then
			return convoTemplate:getScreen("pro_nothing")
		end

		return convoTemplate:getScreen("greeting")
	elseif (stage == kenobiSpineScreenPlay.STAGE_HUNT) then
		-- s_227, with s_350 as the shipped way out of a lost trail.
		return convoTemplate:getScreen("busy")
	elseif (stage == kenobiSpineScreenPlay.STAGE_SHARD_SPARED) then
		return convoTemplate:getScreen("shard_spared")
	elseif (stage == kenobiSpineScreenPlay.STAGE_SHARD_KILLED) then
		return convoTemplate:getScreen("shard_killed")
	elseif (stage == kenobiSpineScreenPlay.STAGE_CHAMBER) then
		if (kenobiSpineScreenPlay:sparedTheHermit(pPlayer)) then
			return convoTemplate:getScreen("chamber_a")
		end

		return convoTemplate:getScreen("chamber_b")
	elseif (stage == kenobiSpineScreenPlay.STAGE_ENTRANCE or stage == kenobiSpineScreenPlay.STAGE_LAIR) then
		-- he is supposed to be at the stone by now. s_335, "Are you ready to
		-- pick up where we left off?", with s_341 pointing back at the lair.
		return convoTemplate:getScreen("resume")
	elseif (stage >= kenobiSpineScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("hero")
	end

	-- STAGE_CONDUITS: the three enclaves are his errand, not the player's to
	-- ask about. s_356.
	return convoTemplate:getScreen("aside")
end

function obi_wan_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (kenobiSpineScreenPlay:getKenobiRole(pNpc) == "chamber") then
		return self:getChamberScreen(pPlayer, convoTemplate)
	end

	return self:getShoreScreen(pPlayer, convoTemplate)
end

--------------------------------------------------------------------------------
-- The handful of animations that belong to an option rather than to a screen.
--------------------------------------------------------------------------------

function obi_wan_conv_handler:playEdgeAnimation(pPlayer, pNpc, selectedOption)
	local pSession = CreatureObject(pPlayer):getConversationSession()

	if (pSession == nil) then
		return
	end

	-- Still the screen the option was picked FROM. See WHY THAT KEY WORKS.
	local pLastScreen = LuaConversationSession(pSession):getLastConversationScreen()

	if (pLastScreen == nil) then
		return
	end

	local fromScreen = self.edgeAnimations[LuaConversationScreen(pLastScreen):getScreenID()]

	if (fromScreen == nil) then
		return
	end

	local animations = fromScreen[selectedOption + 1]

	if (animations == nil) then
		return
	end

	for i = 1, #animations do
		if (animations[i][1] == "npc") then
			CreatureObject(pNpc):doAnimation(animations[i][2])
		else
			CreatureObject(pPlayer):doAnimation(animations[i][2])
		end
	end
end

function obi_wan_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	self:playEdgeAnimation(pPlayer, pNpc, selectedOption)

	if (screenID == "pro_task") then
		-- s_26 sends him after the dying miner. som_obi_wan_signal_1.
		kenobiSpineScreenPlay:giveMinerTask(pPlayer)

	elseif (screenID == "pro_west") then
		-- s_28. 'returnToObiWan' -- closes som_obi_wan_signal_2.
		kenobiSpineScreenPlay:finishPrologue(pPlayer)

	elseif (self.questScreens[screenID]) then
		-- som_kenobi_main_quest_1: find the hermit, via the Mensix network.
		kenobiSpineScreenPlay:giveHermitHunt(pPlayer)

	elseif (screenID == "research") then
		-- s_352, "you will have to perform another search for him".
		kenobiSpineScreenPlay:restartHermitSearch(pPlayer)

	elseif (self.sendScreens[screenID]) then
		-- 'talkedKenobi1' -- arms the three conduits.
		kenobiSpineScreenPlay:talkedKenobi1(pPlayer)

	elseif (self.goluckScreens[screenID]) then
		-- 'talkedKenobi2' -- waypoint to the entrance stone.
		kenobiSpineScreenPlay:talkedKenobi2(pPlayer)

	elseif (self.hurryScreens[screenID]) then
		-- 'talkedKenobi3' -- the way into the lair opens.
		kenobiSpineScreenPlay:talkedKenobi3(pPlayer)

	elseif (screenID == "resume_yes") then
		-- s_341. Live's regiveQuest3 + talkNumber2, less the half that has no
		-- meaning here. See resumeJourney for what survives and why.
		kenobiSpineScreenPlay:resumeJourney(pPlayer)
	end

	return pClonedScreen
end
