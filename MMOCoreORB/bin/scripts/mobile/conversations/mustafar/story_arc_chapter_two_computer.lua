-- scripts/mobile/conversations/mustafar/story_arc_chapter_two_computer.lua
--
-- The same Old Republic AI, one building later: it has transferred itself out of
-- the crashed cruiser and into the Old Republic Facility, and it now wants the
-- droid factory switched on.  Runs on storyArcChaptersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/story_arc_chapter_two_computer, read node for node, and the
-- strings are the shipped rows of
-- string/en/conversation/story_arc_chapter_two_computer.stf.
--
-- ==================== WHAT LIVE ATTACHES IT TO ====================
-- One row of the Old Republic Facility dungeon spawn table:
--
--   object/tangible/furniture/terminal/terminal_bank_floor_on_02.iff,
--   name "Terminal Delta Five", room core_tower8,
--   loc 70.0275 / -34.106 / 14.0088, yaw 123.759,
--   script conversation.story_arc_chapter_two_computer
--
-- So this is the repo's orfDeltaFive object, and the whole of chapter one 03's
-- last step happens in here.  Two consequences:
--
-- 1. It is a TANGIBLE, so the same DEVIATION as the cruiser applies -- Core3 can
--    only start a conversation from an AiAgent.  The terminal stays exactly where
--    the row puts it and an invisible carrier stands on the same spot.  See
--    mobile/custom_content/som/must_facility_ai.lua and spawnFacilityTerminals.
--
-- 2. The terminal it names is a plain furniture terminal, not must_orc_computer.
--    The screenplay used to spawn must_orc_computer here, INFERRED from the
--    cruiser.  Corrected.
-- ==================================================================
--
-- SOE's greeting dispatch is six conditions plus a default, first match wins.
-- Read against the repo's stage numbers:
--
--   isNotFinalStep         building objvar "status" < 11   see below   s_79
--   completedTransfer      factory_three done, or
--                          chapter two 01 complete         >= WARN_MILO      s_19
--   factoryIsRepaired      factory_three active            == RETURN_ORF     s_16
--   isFixingFactory        factory_one or factory_two
--                          active                          == FIND_FACTORY or
--                                                             REPAIR_FACTORY s_15
--   hasCompleteChapterOne  chapter one 03 complete         -- see below      s_51
--   isReadyForChapTwo      uplink_four active              == DELTA_FIVE     s_25
--   default                                                everything else  s_72
--
-- isNotFinalStep IS NOT A QUEST TEST.  It reads "status" off the building, and
-- that objvar belongs to the eight-object mustafar_trials puzzle the same spawn
-- table lays out across the facility (Power Access Terminal, Storage Chest,
-- Journal Screen, Security Station, Ventilation System, Air Systems Terminal,
-- Box of Computer Parts, Main Computer Terminal).  Below 11 the terminal is not
-- even conversable: the live script's OnObjectMenuRequest offers an SUI box
-- reading @mustafar/old_republic_facility:computer_terminal_inactive_prompt
-- instead of a Converse option.
--
-- The repo has no trials puzzle, so there is no building state to read.
-- DEVIATION: the per-player stage stands in, and it is split so that both dead
-- screens keep a distinct trigger --
--
--   before the player has any business in the facility   stage < TRAVEL_ORF
--     -> s_79, "Terminal Offline"
--   arrived, power not yet restored                      TRAVEL_ORF, ORF_POWER
--     -> s_72, "[This terminal appears to be functional, but offline.]"
--
-- That is one axis standing in for two.  Live's is per-building and this is
-- per-player; said plainly rather than dressed up as equivalent.
--
-- s_79 IS A BARK.  The live script delivers it with chat.chat -- a spatial
-- speech bubble and no conversation window.  Core3 cannot render that from a
-- conversation, so it becomes a one-line terminal screen, the same deviation
-- miner_madness_chief_drono.lua and the other Mustafar trees already carry.
--
-- hasCompleteChapterOne is structurally unreachable in the repo, and SOE's own
-- ordering is why.  It catches a player who finished chapter one 03 but has no
-- chapter two 01 -- but completeChapterOne grants chapter two 01 in the same
-- breath as finishing chapter one 03, so every stage from FIND_FACTORY up is
-- swallowed by the three conditions tested ahead of it.  It is written in SOE's
-- position with the faithful action anyway; the strings ship and the screens
-- exist.  Same honest treatment as chapter one's abandonedFirstMission.
--
-- TWO ACTIONS FIRE, both on a terminal option, none on a greeting.  Unlike the
-- cruiser, where four of five actions fire on the greeting, this whole tree is
-- inert until the player picks the last line of a chain:
--
--   s_61 -> s_63   grantMission        grant som_story_arc_chapter_two_01
--                                      (java:192, handleBranch10)
--   s_68 -> s_70   completeChapterOne  signal mustafar_uplink_finish
--                                      + grant som_story_arc_chapter_two_01
--                                      + badge bdg_must_victory_orf
--                                      (java:511, handleBranch20)
--
-- A THIRD ACTION IS DEFINED AND NEVER CALLED: hkShowsUp, a bare sendSignal of
-- "mustafar_factory_transfer" (java:60-63).  Counted the call sites -- one, the
-- definition itself.  SOE authored it and then hung it on no edge, the same
-- authored-then-abandoned shape the other Mustafar scripts keep showing.  It is
-- named here so that nobody re-reads the java, finds a third action, and files
-- this reconstruction as incomplete.  Defined is not fires.
--
-- THE BADGE LANDS HERE.  bdg_must_victory_orf is granted nowhere else in the
-- seven story-arc scripts, and it was missing from this port entirely.  Root
-- cause: the search that built the arc looked at the .qst files, and the .qst
-- files carry no reward rows -- the badge is in the conversation.  Exactly the
-- same miss, for exactly the same reason, as the Keslev exploration badge that
-- mining_field_markers.lua now records.
--
-- ZERO ANIMATIONS.  doAnimationAction appears nowhere in the shipped script --
-- it is a terminal, not a person -- so the empty animation fields below are
-- SOE's, not a gap in this reconstruction.

story_arc_chapter_two_computer = ConvoTemplate:new {
	initialScreen = "functional_offline",
	templateType = "Lua",
	luaClassHandler = "facility_computer_conv_handler",
	screens = {}
}

-- =====================================================================
-- THE ARRIVAL.  s_25 and the ten-step chain behind it.  One option per
-- step; the last one finishes chapter one, opens chapter two and pays
-- the badge.
-- =====================================================================

story_arc_chapter_two_computer_arrived = ConvoScreen:new {
	id = "arrived",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_25", -- I think I like being a facility even less then being a starship. This place doesn't even have blasters. I am not sure how these computers stand it.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_27", "cleaned_out"}, -- Did you manage to find the information I need?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_arrived)

story_arc_chapter_two_computer_cleaned_out = ConvoScreen:new {
	id = "cleaned_out",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_29", -- Answer: No. A search through this facility's memory banks show that they were cleaned out sometime ago. They must have been taken to the droid factory.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_31", "neimodians"}, -- What droid factory?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_cleaned_out)

story_arc_chapter_two_computer_neimodians = ConvoScreen:new {
	id = "neimodians",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_33", -- The one that was built by those Neimodians several years ago. Seriously, how does anything stand this? I feel so empty inside.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_35", "factory_offline"}, -- It's okay. Can you tell me about the droid factory?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_neimodians)

story_arc_chapter_two_computer_factory_offline = ConvoScreen:new {
	id = "factory_offline",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_37", -- Answer: It was built a little more then twenty years ago. It is currently offline. And all the information that you are searching for is located there.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_39", "walk_down"}, -- Alright. So what should I do now?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_factory_offline)

story_arc_chapter_two_computer_walk_down = ConvoScreen:new {
	id = "walk_down",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_41", -- You should walk your little, mea...legs down to the factory and turn it on. The relay from this station is operational. If the droid factory is online, I can swing down there. Do you think that factory will have blasters?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_45", "architects"}, -- I doubt it. Most architects think that blasters are not aesthetically pleasing.
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_walk_down)

story_arc_chapter_two_computer_architects = ConvoScreen:new {
	id = "architects",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_47", -- Thank you. I will make a note to deal with architects first.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_49", "spoke_out"}, -- What does that mean?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_architects)

story_arc_chapter_two_computer_spoke_out = ConvoScreen:new {
	id = "spoke_out",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_52", -- I am sorry. I shouldn't have spoken out like that. I really think you should go down to the droid factory and turn it on so I can recover the information you requested. It is located a few clicks to the south.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_56", "sure_its_there"}, -- Alright, are you sure the information is there?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_spoke_out)

story_arc_chapter_two_computer_sure_its_there = ConvoScreen:new {
	id = "sure_its_there",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_60", -- Answer: Of course it is there. I am sorry that I led you astray the first time, but I didn't know that those Neimodians built a droid factory. I really hope I get a chance to thank them in person.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_64", "very_sad"}, -- The Neimodians left here a long time ago.
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_sure_its_there)

story_arc_chapter_two_computer_very_sad = ConvoScreen:new {
	id = "very_sad",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_66", -- That makes me very sad. Maybe I will visit their homeworld someday. Then I will be very happy.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_68", "to_the_south"}, -- Ummm...okay. To the south you say?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_very_sad)

-- ACTION completeChapterOne -- finishes chapter one 03, opens chapter two 01 and
-- grants bdg_must_victory_orf.
story_arc_chapter_two_computer_to_the_south = ConvoScreen:new {
	id = "to_the_south",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_70", -- Answer: That is correct. The droid factory is located to the south of here. Once it is activated, I will transfer myself into it.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_to_the_south)

-- =====================================================================
-- THE NAG.  SOE's recovery branch for a player who finished chapter one
-- but has no chapter two.  Unreachable in the repo; see the header.
-- =====================================================================

story_arc_chapter_two_computer_troublesome = ConvoScreen:new {
	id = "troublesome",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_51", -- Statement: You fleshy people are very troublesome. I was under the impression that you were going to activate that droid factory for me. Perhaps I should rethink my take-care-of-you-last policy?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_53", "what_mean"}, -- What does that mean?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_troublesome)

story_arc_chapter_two_computer_what_mean = ConvoScreen:new {
	id = "what_mean",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_55", -- What does what mean?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_57", "hearing_voices"}, -- The take-care-of-me-last thing.
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_what_mean)

story_arc_chapter_two_computer_hearing_voices = ConvoScreen:new {
	id = "hearing_voices",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_59", -- I am not sure what you are talking about. Perhaps you are hearing voices. I understand that is quite a common problem with fleshy brains. Maybe you would like to go to the droid factory now, before you hear more voices?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_61", "turn_it_on"}, -- Sure, I will do it.
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_hearing_voices)

-- ACTION grantMission -- chapter two 01 only, no signal and no badge.
story_arc_chapter_two_computer_turn_it_on = ConvoScreen:new {
	id = "turn_it_on",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_63", -- That is good. You must make sure to turn it on for me. Then I will solve all your problems.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_turn_it_on)

-- =====================================================================
-- THE SHORT SCREENS.  One pair per remaining greeting condition, plus
-- the bark.
-- =====================================================================

-- isNotFinalStep. A bark on live -- see the header for why it is a screen here.
story_arc_chapter_two_computer_offline_bark = ConvoScreen:new {
	id = "offline_bark",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_79", -- Terminal Offline
	stopConversation = "true",
	options = {}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_offline_bark)

-- Mid-factory, and the AI is unimpressed.
story_arc_chapter_two_computer_you_lied = ConvoScreen:new {
	id = "you_lied",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_15", -- Statement: You said you would go down to the droid factory and fix it. I do not like it when meatbags lie to me.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_43", "glitch"}, -- Meatbag? What are you talking about?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_you_lied)

story_arc_chapter_two_computer_glitch = ConvoScreen:new {
	id = "glitch",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_44", -- There seems to be a glitch in my system. Think nothing of it.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_glitch)

-- The factory is running and the AI is already halfway out the door.
story_arc_chapter_two_computer_well_done = ConvoScreen:new {
	id = "well_done",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_16", -- For a meatbag, you have done better then I would have expected.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_17", "gone_offline"}, -- When will I get the information about how to help the miners?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_well_done)

story_arc_chapter_two_computer_gone_offline = ConvoScreen:new {
	id = "gone_offline",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_18", -- [This terminal has gone offline.]
	stopConversation = "true",
	options = {}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_gone_offline)

-- It has moved into the factory. Nobody home, the same joke as the cruiser.
story_arc_chapter_two_computer_transferred = ConvoScreen:new {
	id = "transferred",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_19", -- [This terminal is offline.]
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_73", "transferred_reply"}, -- Yep, he is still gone.
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_transferred)

story_arc_chapter_two_computer_transferred_reply = ConvoScreen:new {
	id = "transferred_reply",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_74", -- [no response]
	stopConversation = "true",
	options = {}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_transferred_reply)

-- The default, and the template's initialScreen. In the repo it is the player who
-- has reached the facility but not yet restored its power.
story_arc_chapter_two_computer_functional_offline = ConvoScreen:new {
	id = "functional_offline",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_72", -- [This terminal appears to be functional, but offline.]
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_two_computer:s_76", "no_response"}, -- I wonder how to turn it on?
	}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_functional_offline)

story_arc_chapter_two_computer_no_response = ConvoScreen:new {
	id = "no_response",
	leftDialog = "@conversation/story_arc_chapter_two_computer:s_78", -- [no response]
	stopConversation = "true",
	options = {}
}
story_arc_chapter_two_computer:addScreen(story_arc_chapter_two_computer_no_response)

addConversationTemplate("story_arc_chapter_two_computer", story_arc_chapter_two_computer)
