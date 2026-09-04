-- scripts/mobile/conversations/mustafar/story_arc_chapter_three_cobar.lua
--
-- Engineer Cobar -- the giver of the terminal override tool for
-- som_story_arc_chapter_three_02, "Get a Terminal Override".
-- Runs on storyArcChaptersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/story_arc_chapter_three_cobar, read node for node, and the
-- strings are the shipped rows of
-- string/en/conversation/story_arc_chapter_three_cobar.stf.  The script also
-- supplies his display name: it renames the mob "Engineer Cobar" on attach.
--
-- WHY THIS FILE EXISTS AT ALL.  story_arc_chapters.lua used to say no engineer
-- ships and had Milo hand the tool over as a SUBSTITUTION.  That claim was
-- false.  Its root cause is the same one that produced the other stale "did not
-- ship" claims in this directory: the enumeration that produced it was scoped to
-- conversation scripts whose NAME begins som_, and to the som_ string tables.
-- Cobar's script is named story_arc_*, so it was never in the set that was
-- searched.  Absence from a search is not absence from the game.
--
-- SOE's greeting dispatch is two conditions, first match wins:
--
--   isTaskActive("som_story_arc_chapter_three_02",
--                "mustafar_droid_factory_slicing")        s_4   greeting
--   default                                               s_14  bark, busy
--
-- The default is a chat.chat bark -- SOE says the line over his head and never
-- opens a window.  Core3 cannot do that: AiAgentImplementation.cpp:4122 sends
-- StartNpcConversation to the client before any Lua runs, and returning nil from
-- getInitialScreen drops the session with forceClose false
-- (ConversationObserver.idl:54), which leaves an empty window open.  So the bark
-- is a one-line terminal screen, the same DEVIATION recorded in
-- som_kenobi_historian_dark_jedi.lua and maneater_ulon.lua.
--
-- Task mapping onto storyArcChaptersScreenPlay:
--   mustafar_droid_factory_slicing is the SOLO SIDE QUEST that runs alongside
--   STAGE_FACTORY_TERMINAL (18), so it gets no stage integer of its own.  The
--   screenplay opens it with the "sliceQuest" flag when the factory terminal
--   first refuses the player, and closes it with the "overrideTool" flag when
--   the tool is handed over.  Cobar's condition is those two flags, which is
--   exactly what isTaskActive on a one-task quest means.
--
-- ONE SIDE EFFECT, where SOE put it:
--   s_10 -> s_12   grantTool   sendSignal(player,
--                              "mustafar_droid_factory_tool_recieved")
--   The misspelling is SOE's and is reproduced, because it is the signal name
--   the .qst's Wait for Signal task actually listens for.
--
-- ZERO ANIMATIONS.  Cobar's script calls doAnimationAction nowhere -- unusual
-- for a story-arc NPC, and stated here so a later reader does not read the empty
-- animation fields as an omission.

story_arc_chapter_three_cobar = ConvoTemplate:new {
	initialScreen = "busy",
	templateType = "Lua",
	luaClassHandler = "cobar_conv_handler",
	screens = {}
}

-- =====================================================================
-- The side quest is live.  s_4 -> s_8 -> s_12, no branch anywhere: SOE
-- authored a single option on each screen.  The player is walked through
-- asking for the favour rather than being offered a choice.
-- =====================================================================

story_arc_chapter_three_cobar_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/story_arc_chapter_three_cobar:s_4", -- Hey, I heard you were doing some work for Milo. That is good because we need all the help we can get around here.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_cobar:s_6", "favor"}, -- I need to ask you for a favor.
	}
}
story_arc_chapter_three_cobar:addScreen(story_arc_chapter_three_cobar_greeting)

story_arc_chapter_three_cobar_favor = ConvoScreen:new {
	id = "favor",
	leftDialog = "@conversation/story_arc_chapter_three_cobar:s_8", -- Sure. If it is within my power, I will certainly help you out.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_cobar:s_10", "grant_tool"}, -- I need something to bypass a terminal's security system.
	}
}
story_arc_chapter_three_cobar:addScreen(story_arc_chapter_three_cobar_favor)

-- ACTION grantTool: sendSignal(player, "mustafar_droid_factory_tool_recieved")
story_arc_chapter_three_cobar_grant_tool = ConvoScreen:new {
	id = "grant_tool",
	leftDialog = "@conversation/story_arc_chapter_three_cobar:s_12", -- Oh, really? That isn't the sort of tool that I give out to just anyone, but since you are working for Milo, I just might have what you need. Here, this is a Cypress Yunitronic...never mind...this is a tool that will bypass most security systems. Just use it on the terminal you wish to gain access to. Good luck to you.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_cobar:addScreen(story_arc_chapter_three_cobar_grant_tool)

-- =====================================================================
-- Every other time.  s_14, a bark.  This is also initialScreen, because a
-- ConvoTemplate needs one and the busy line is the state a player who has
-- never touched the arc will see.
-- =====================================================================

story_arc_chapter_three_cobar_busy = ConvoScreen:new {
	id = "busy",
	leftDialog = "@conversation/story_arc_chapter_three_cobar:s_14", -- Sorry, my friend, but I am really busy. This computer terminal isn't going to fix itself. The access matrix is a complete mess and I am going to have to bypass our security system to fix it. Fortunately, I have one of my special tools that makes that job a snap.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_cobar:addScreen(story_arc_chapter_three_cobar_busy)

addConversationTemplate("story_arc_chapter_three_cobar", story_arc_chapter_three_cobar)
