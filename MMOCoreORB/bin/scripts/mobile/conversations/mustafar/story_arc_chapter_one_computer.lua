-- scripts/mobile/conversations/mustafar/story_arc_chapter_one_computer.lua
--
-- The crashed Old Republic cruiser's AI -- the blaster-obsessed ship's computer
-- on the bridge.  Runs on storyArcChaptersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/story_arc_chapter_one_computer, read node for node, and the
-- strings are the shipped rows of
-- string/en/conversation/story_arc_chapter_one_computer.stf.
--
-- ==================== WHAT LIVE ATTACHES IT TO ====================
-- One row of the live crash-site dungeon spawn table carries it:
--
--   object/tangible/quest/must_orc_computer.iff, room "bridge",
--   loc 2.2 / 1.9 / 8, yaw -90, and TWO scripts on the one object:
--     quest.task.ground.retrieve_item_on_item
--     conversation.story_arc_chapter_one_computer
--
-- Two things follow from that row and both matter here.
--
-- 1. The object is a TANGIBLE.  In Core3 a conversation can only start from an
--    AiAgent -- AiAgentImplementation.cpp:4087 sendConversationStartTo has no
--    TangibleObject counterpart -- so the tree cannot hang on the terminal.
--    DEVIATION: storyArcChaptersScreenPlay keeps the terminal exactly where the
--    row puts it and stands an invisible AiAgent carrier on the same spot to
--    hold the conversation.  See spawnCruiserComputer.
--
-- 2. "Install Circuit Boards" is NOT part of this conversation.  It is the
--    OTHER script on the same object, retrieve_item_on_item, which is why no
--    condition here tests mustafar_motor_three.  That step stays on the
--    terminal's radial, and it stays there on purpose.
-- ==================================================================
--
-- SOE's greeting dispatch is six conditions plus a default, first match wins.
-- Read against the repo's stage numbers:
--
--   hasCompletedMission     ch1_03 complete            > DELTA_FIVE      s_13
--   hasCompletedFirstTask   uplink_one complete        == UPLINK_REPORT  s_7
--   isOnFirstTask           uplink_one active          == UPLINK         s_76
--   isOnStoryArc            ch1_02 complete, or
--                           motor_four active          == ACTIVATE_COMPUTER,
--                                                      or TRAVEL_ORF..DELTA_FIVE
--                                                                        s_16
--   abandonedFirstMission   ch1_01 done, ch1_02 not
--                           active                     -- see below      s_105
--   ChapOneFirstStep        mustafar_orc_two active    == FIND_TERMINAL  s_80
--   default                                            everything else   s_86
--
-- isOnStoryArc catching TRAVEL_ORF..DELTA_FIVE is not a slip.  Those three
-- stages pass "ch1_02 complete" and are not caught by any earlier condition, so
-- on live the player really could walk back to the bridge and re-hear the whole
-- briefing.  That is reproduced; makeUpLink is a no-op past UPLINK.
--
-- abandonedFirstMission is SOE's recovery for a player who dropped chapter one
-- 02 from the quest journal.  The repo's stage counter cannot be dropped, so
-- the branch is structurally unreachable here.  It is written in SOE's position
-- with the faithful test anyway -- the strings ship, the screen exists, and if a
-- later stage model ever gains an abandon it works with no edit.  Recorded so it
-- does not read as an omission.
--
-- FOUR SIDE EFFECTS, exactly where SOE put them:
--   greeting s_7    sendTransferSignal   signal mustafar_uplink_make_transfer
--   greeting s_16   startedComputerTalk  signal access_computer_fixed
--   greeting s_105  regrantMission       grant som_story_arc_chapter_one_02
--   greeting s_80   fixTerminal          signal mustafar_orc_complete
--                                        + grant som_story_arc_chapter_one_02
--   s_98 -> s_100   makeUpLink           grant som_story_arc_chapter_one_03
--
-- The first four fire on the GREETING, before the player picks anything, so the
-- handler runs them in getInitialScreen.  Only makeUpLink is an option effect.
--
-- ZERO ANIMATIONS.  The shipped script calls doAnimationAction nowhere in this
-- conversation -- it is a terminal, not a person -- so the empty animation
-- fields below are SOE's, not a gap in this reconstruction.

story_arc_chapter_one_computer = ConvoTemplate:new {
	initialScreen = "offline",
	templateType = "Lua",
	luaClassHandler = "cruiser_computer_conv_handler",
	screens = {}
}

-- =====================================================================
-- THE BRIEFING.  s_16 and the fourteen-step exposition chain behind it.
-- Every step is a single option; SOE walks the player through the whole
-- thing rather than branching.  The last one grants the uplink quest.
-- =====================================================================

story_arc_chapter_one_computer_awake = ConvoScreen:new {
	id = "awake",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_16", -- Query: Where am I?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_23", "starship"}, -- You mean that you don't know?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_awake)

story_arc_chapter_one_computer_starship = ConvoScreen:new {
	id = "starship",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_25", -- Application: Searching memory banks. Thruster control; navigation computer; large, bulbous body. I think I am a starship.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_26", "blasters_offline"}, -- Yes, you are a crashed Old Republic cruiser.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_starship)

story_arc_chapter_one_computer_blasters_offline = ConvoScreen:new {
	id = "blasters_offline",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_27", -- This is most interesting. I do not recall being a starship. My blasters are offline.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_28", "safe_not_sorry"}, -- You do not recall... Did you... What do you need blasters for?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_blasters_offline)

story_arc_chapter_one_computer_safe_not_sorry = ConvoScreen:new {
	id = "safe_not_sorry",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_29", -- Statement: It is better to be safe than sorry.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_30", "thrusters_offline"}, -- I don't think you are going to need your blasters.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_safe_not_sorry)

story_arc_chapter_one_computer_thrusters_offline = ConvoScreen:new {
	id = "thrusters_offline",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_32", -- Statement: It has been my experience that it is much harder to blow things up without them. Of course, I could just land on them, but my thrusters appear to be offline as well.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_34", "located_it"}, -- Okay, moving on. I need to ask you some questions.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_thrusters_offline)

story_arc_chapter_one_computer_located_it = ConvoScreen:new {
	id = "located_it",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_36", -- I believe I have located it. I find it very odd that it isn't here. It should be, but then again I have been offline for a very long time.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_38", "personal_problem"}, -- Located what?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_located_it)

story_arc_chapter_one_computer_personal_problem = ConvoScreen:new {
	id = "personal_problem",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_40", -- I don't think you need to worry about that. It is more of a personal problem. You wanted to ask me some questions? I might have answers.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_42", "search_database"}, -- I need to find out a way to increase the output in a mining facility.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_personal_problem)

story_arc_chapter_one_computer_search_database = ConvoScreen:new {
	id = "search_database",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_44", -- Oh, I was hoping it would involve blasters. If you wait for a moment, I will search my database to see if there is any information on mining facility: increased productivity of...
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_46", "query_missing"}, -- You really like blasters.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_search_database)

story_arc_chapter_one_computer_query_missing = ConvoScreen:new {
	id = "query_missing",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_48", -- Statement: What is not to like? The light, the noise, the screaming... Oh, I have located the information on the mining facility. If you reroute the lower subroutine in the main reactor to the...QUERY MISSING...output increase of 300 percent. I hope that answered your query to satisfaction.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_50", "transfer_me"}, -- Wait! What about that part missing in the middle?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_query_missing)

story_arc_chapter_one_computer_transfer_me = ConvoScreen:new {
	id = "transfer_me",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_52", -- You mean the QUERY MISSING part? I am afraid that is all that is located in my memory banks. I cannot be positive, but I do not think I am functioning correctly. You should transfer me to the Republic facility that is nearby. They will definitely have the information you require.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_54", "northeast_facility"}, -- What Republic facility?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_transfer_me)

story_arc_chapter_one_computer_northeast_facility = ConvoScreen:new {
	id = "northeast_facility",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_56", -- The one that is several clicks to the northeast of this location. Was there another 5000-year-old relic of the past in this area I was not aware of? You simply need to hook up the satellite uplink to my mainframe and I can transfer to that facility. From there, I am sure I can find what you are looking for.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_58", "uplink_cavern"}, -- Now there is a satellite uplink around here?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_northeast_facility)

story_arc_chapter_one_computer_uplink_cavern = ConvoScreen:new {
	id = "uplink_cavern",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_60", -- Answer: Of course. The strange people with all the droids left it not too long ago. You just need to enter the cavern and the automated repair system will come online. Like the nice mindless droid it is, it will reconnect the uplink. Of course, the kubaza beetles might be a problem. Since you lack a guidance system, I will supply you with the location of the cavern.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_91", "kubaza"}, -- What kubaza beetles?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_uplink_cavern)

story_arc_chapter_one_computer_kubaza = ConvoScreen:new {
	id = "kubaza",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_92", -- While running a short-range scan of the area, I discovered that the kubaza beetles have moved into that cavern. It was probably them that tore down the uplink relay in the first place. There is a ninety-eight percent chance that they will not like you being there. I recommend that you kill them before they kill you.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_94", "close_to_positive"}, -- And then you can get me the information I need?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_kubaza)

story_arc_chapter_one_computer_close_to_positive = ConvoScreen:new {
	id = "close_to_positive",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_96", -- Answer: I am close to positive that the information you need will be there. Of course, I have noticed that I am occasionally wrong. But in this case, I think I am correct. You should hook up the uplink. Besides, I am sure you will get to blast a few things along the way.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_98", "blasted"}, -- Why do you think that?
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_close_to_positive)

-- ACTION makeUpLink -- grant som_story_arc_chapter_one_03, i.e. STAGE_UPLINK.
story_arc_chapter_one_computer_blasted = ConvoScreen:new {
	id = "blasted",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_100", -- Statement: Things have a tendency to get blasted when I am around. ...I wish my blasters worked.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_blasted)

-- =====================================================================
-- THE SHORT SCREENS.  Six one-option exchanges, one per remaining
-- greeting condition.  Each is a bracketed stage direction rather than a
-- line of speech, because at these stages the terminal is dead, empty or
-- already vacated.
-- =====================================================================

-- Mid-uplink.  The AI nags, and wonders about armed beetles.
story_arc_chapter_one_computer_uplink_reminder = ConvoScreen:new {
	id = "uplink_reminder",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_76", -- Shouldn't you be getting that uplink hooked back up? I know that the cavern is swarming with kubaza beetles, but they are not armed, so you shouldn't have any trouble.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_77", "uplink_reply"}, -- Okay, I will go get the uplink set up.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_uplink_reminder)

story_arc_chapter_one_computer_uplink_reply = ConvoScreen:new {
	id = "uplink_reply",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_78", -- Query: I wonder what would happen if kubaza beetles were armed? Does the man make the gun or does the gun make the man...or in this case, beetle.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_uplink_reply)

-- ACTION sendTransferSignal on the greeting -- the AI has gone to the facility.
story_arc_chapter_one_computer_transferred = ConvoScreen:new {
	id = "transferred",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_7", -- [There is no response. The ship's AI must have already transferred itself to that facility to the northeast.]
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_72", "transferred_reply"}, -- Strange...
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_transferred)

story_arc_chapter_one_computer_transferred_reply = ConvoScreen:new {
	id = "transferred_reply",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_73", -- [no response]
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_transferred_reply)

-- Everything already done.
story_arc_chapter_one_computer_silent = ConvoScreen:new {
	id = "silent",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_13", -- [There is no response.]
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_74", "silent_reply"}, -- Oh, yeah...he is gone now.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_silent)

story_arc_chapter_one_computer_silent_reply = ConvoScreen:new {
	id = "silent_reply",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_75", -- [no response]
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_silent_reply)

-- ACTION regrantMission on the greeting. SOE's dropped-quest recovery; see the
-- header for why the repo's stage counter can never reach it.
story_arc_chapter_one_computer_no_boards = ConvoScreen:new {
	id = "no_boards",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_105", -- [This terminal seems to be operational, but is missing its circuit boards.]
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_70", "no_boards_reply"}, -- I should get is some new circuit boards.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_no_boards)

story_arc_chapter_one_computer_no_boards_reply = ConvoScreen:new {
	id = "no_boards_reply",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_71", -- [no response]
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_no_boards_reply)

-- ACTION fixTerminal on the greeting -- finding the terminal IS the step, so
-- walking up to it at STAGE_FIND_TERMINAL completes it and opens chapter one 02.
story_arc_chapter_one_computer_dead_terminal = ConvoScreen:new {
	id = "dead_terminal",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_80", -- [This terminal would be functional if its circuit boards were replaced.]
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_81", "dead_terminal_reply"}, -- Maybe I should find it some circuit boards.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_dead_terminal)

story_arc_chapter_one_computer_dead_terminal_reply = ConvoScreen:new {
	id = "dead_terminal_reply",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_83", -- [no response]
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_dead_terminal_reply)

-- Anyone not on the arc. The template's initialScreen.
story_arc_chapter_one_computer_offline = ConvoScreen:new {
	id = "offline",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_86", -- [This terminal appears to be offline]
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_computer:s_87", "offline_reply"}, -- This doesn't appear to be working.
	}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_offline)

story_arc_chapter_one_computer_offline_reply = ConvoScreen:new {
	id = "offline_reply",
	leftDialog = "@conversation/story_arc_chapter_one_computer:s_89", -- [no response]
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_computer:addScreen(story_arc_chapter_one_computer_offline_reply)

addConversationTemplate("story_arc_chapter_one_computer", story_arc_chapter_one_computer)
