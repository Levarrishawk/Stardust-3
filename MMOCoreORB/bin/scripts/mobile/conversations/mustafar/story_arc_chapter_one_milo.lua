-- scripts/mobile/conversations/mustafar/story_arc_chapter_one_milo.lua
--
-- Milo Mensix, head of the mining operation and the spine of the whole Mustafar
-- story arc.  He opens it, he takes every report, and he closes it.  Runs on
-- storyArcChaptersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/story_arc_chapter_one_milo, read node for node, and the strings
-- are the shipped rows of
-- string/en/conversation/story_arc_chapter_one_milo.stf.
--
-- ==================== CORRECTING A FALSE CLAIM ====================
-- story_arc_chapters.lua used to say, at spawnMilo:
--
--   "Milo Mensix. He has conversationTemplate "" in his own template, so he is
--    radial-driven; see the header for why no conversation table is authored
--    here."
--
-- The first half is true and the second half does not follow.  The empty
-- conversationTemplate is the REPO's gap, not evidence that live had none.  Live
-- ships a 43-screen tree for him.
--
-- ROOT CAUSE, recorded so the same miss stops repeating: the search that built
-- the arc was scoped to the "som_" name prefix and the som_* string tables,
-- because that is how the quests, the mobiles and the datatables are named.
-- These conversations are named story_arc_* and ship in the base
-- string/en/conversation/ set.  Everything under that prefix was invisible to
-- the search, so "no rows found" was read as "did not ship".  Identical root
-- cause to the cobar, scout, pilot and both computer trees.
--
-- Milo needs no invisible carrier, unlike the two computer terminals: he is
-- already a real AiAgent (must_milo_mensix).  Filling in his empty
-- conversationTemplate is the whole of the attachment.
-- ==================================================================
--
-- SOE's greeting dispatch is FIFTEEN conditions plus a default, first match
-- wins.  Read against the repo's stage numbers (story_arc_chapters.lua:557-595):
--
--    1 hasWonStoryArc            ch3_03 complete        == DONE            s_101
--    2 messageWaiting            ch3_03/volcano_five    == CHECK_MESSAGE   s_123
--    3 hasDefeatedHK             ch3_03/volcano_four    == REPORT_SUCCESS  s_114
--    4 isFightingHK              ch3_03 active          FIND_PILOT..KILL_HK47 s_111
--    5 hasWonFactory             ch3_01/milo_report or
--                                ch3_01 complete        == REPORT_MILO     s_94
--    6 isFightingDroids          ch3_01 active          DROID_ARMY..SHUTDOWN s_93
--    7 hk47IsAlive               ch2_01/factory_five or
--                                ch2_01 complete        == WARN_MILO       s_20
--    8 hasCompletedFourthMission ch2_01 complete        -- unreachable     s_132
--    9 isOnSecondMission         ch2_01 active          FIND_FACTORY..RETURN_ORF s_32
--   10 hasCompletedThirdMission  ch1_03 complete        -- unreachable     s_129
--   11 hasCompletedSecondMission ch1_02 complete        UPLINK..DELTA_FIVE s_126
--   12 hasCompletedFirstMission  ch1_01 complete        SALVAGE..ACTIVATE  s_125
--   13 isOnFirstMission          ch1_01/02/03 active    TRAVEL_WRECK,FIND_TERMINAL s_36
--   14 hasCompletedPrelude       prelude_03 complete    STAGE_NONE + prelude done s_40
--   15 default                                          everything else    s_124
--
-- TWO CONDITIONS ARE STRUCTURALLY UNREACHABLE, and SOE's own ordering is why,
-- not the port.  #8 hasCompletedFourthMission tests chapter two 01 complete --
-- but #5, #6 and #7 all catch a player in that state first, because finishing
-- chapter two 01 is what sets the factory tasks those three read.  #10
-- hasCompletedThirdMission tests chapter one 03 complete, and #9 catches every
-- such player, because completeChapterOne grants chapter two 01 in the same
-- breath as finishing chapter one 03.  Both are written in SOE's position with
-- the faithful action anyway; the strings ship and the screens exist.  Same
-- honest treatment as chapter two's hasCompleteChapterOne.
--
-- FIVE ACTIONS ARE DEFINED AND ALL FIVE FIRE (java:96-120):
--
--   greeting s_20    checkForError      see below
--   s_92  -> s_103   grantFirstMission  grant som_story_arc_chapter_one_01
--   s_81  -> s_82    checkForError
--   s_87  -> s_90    grantFinalChapter  signal mustafar_factory_finish
--                                       + grant som_story_arc_chapter_three_01
--   s_97  -> s_98    checkForError
--   s_112 -> s_113   startVolcanoQuest  signal mustafar_droidfactory_victory
--                                       + grant som_story_arc_chapter_three_03
--   s_115 -> s_116   grantFinalReward   signal hk_story_arc_completed
--   s_127 -> s_128   checkForError
--   s_130 -> s_131   checkForError
--   s_133 -> s_134   checkForError
--
-- checkForError IS A NO-OP HERE, and that is a real finding, not a shortcut.
-- Live's body is: if chapter one 01 is still active, complete it.  It exists to
-- repair a journal that got stuck with a finished mission still showing.  The
-- repo tracks progress as ONE stage integer, so there is no second copy of the
-- state to fall out of step with -- nothing can be stuck the way that repair
-- expects.  It is wired as an empty call so the shape stays visible; see
-- milo_conv_handler.lua.
--
-- THE REPO HAS NO SIGNAL BUS.  mustafar_factory_finish,
-- mustafar_droidfactory_victory and hk_story_arc_completed are live's
-- cross-script wake-ups.  Here the screenplay advances its own stage directly,
-- which is what those signals were for.  Stated, not hidden.
--
-- FIVE GREETINGS ARE BARKS ON LIVE, not conversations: s_101, s_123, s_111,
-- s_125 and s_124.  Each is delivered with chat.chat and returns immediately --
-- a spatial speech bubble, no window, no options.  Core3 cannot render that from
-- a conversation, so all five become one-line terminal screens here.  The same
-- deviation miner_madness_chief_drono.lua and the other Mustafar trees already
-- carry, named again rather than assumed known.  The other ten greetings do open
-- a real window.
--
-- ANIMATIONS ARE HEAVY IN THIS TREE -- 23 of them, both NPC and player, all
-- lifted from the shipped doAnimationAction calls.  Per ConversationScreen.h:203
-- both fields sit on the TARGET screen of an edge, so a greeting carries only an
-- npc animation (the player has not spoken yet) and a reply can carry both.

story_arc_chapter_one_milo = ConvoTemplate:new {
	initialScreen = "see_chivos",
	templateType = "Lua",
	luaClassHandler = "milo_conv_handler",
	screens = {}
}

-- =====================================================================
-- THE OFFER.  s_40 and the eleven-step chain that opens the story arc.
-- Two ways to walk out of it early (s_119, s_109) and one that takes the
-- job (s_92 -> grantFirstMission).
-- =====================================================================

story_arc_chapter_one_milo_welcome = ConvoScreen:new {
	id = "welcome",
	animation = "greet",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_40", -- Hello and welcome. I am Milo Mensix, head of this little operation here. Chivos has kept me informed about your good work for us. I was hoping that maybe I could persuade you to do some extra work for us...work that would require your obvious talents.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_42", "what_work"}, -- What sort of work are you talking about?
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_welcome)

story_arc_chapter_one_milo_what_work = ConvoScreen:new {
	id = "what_work",
	animation = "explain",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_44", -- I am sure that you have noticed that we are experiencing many different problems here. It is of the utmost importance that we find a way to quickly upgrade this facility so that we can stay on schedule and meet our clients' demands.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_46", "why_client"}, -- Why is this latest client so important that you would risk your entire facility?
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_what_work)

story_arc_chapter_one_milo_why_client = ConvoScreen:new {
	id = "why_client",
	animation = "explain",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_48", -- It goes well beyond the financial reward, I assure you. If this contract fails, the entire company fails. All of these people will be out of work and I am not so sure that anyone will come back to pick up the pieces like we did with Klegger.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_50", "who_clients"}, -- This doesn't sound right. Who are these clients?
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_why_client)

story_arc_chapter_one_milo_who_clients = ConvoScreen:new {
	id = "who_clients",
	animation = "apologize",
	playerAnimation = "rub_chin_thoughtful",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_52", -- I am going to be completely honest with you because I...we need your help in a most desperate way. The client we are working for is the Empire. They came to us with a very generous offer last year, but they keep altering the deal. Always demanding more...faster. We cannot keep up anymore.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_54", "get_out_of_deal"}, -- So, get out of the deal.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_who_clients)

story_arc_chapter_one_milo_get_out_of_deal = ConvoScreen:new {
	id = "get_out_of_deal",
	animation = "gesticulate_wildly",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_56", -- Do you not think I have tried that? They said that if I fail to meet their expectations, they would take over the operation. They also made it pretty clear that if they had to take over, me and my men would no longer be needed. I can only guess by the presence of those Star Destroyers, they didn't mean we would be fired.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_58", "nothing_you_can_do"}, -- So there is nothing you can do?
		{"@conversation/story_arc_chapter_one_milo:s_119", "uphold_bargain"}, -- Maybe you should uphold your end of the bargain.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_get_out_of_deal)

-- Walk-out one. No action; the arc simply is not taken today.
story_arc_chapter_one_milo_uphold_bargain = ConvoScreen:new {
	id = "uphold_bargain",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_121", -- It's impossible! We are already running way over capacity and they just keep upping the requirements. My men's lives are at stake, all because I thought I could trust the Empire. Listen, I know you have no reason to, but would you please help us? Not for me, but for my men. They don't even know why they are working so hard and now they might die because of it.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_uphold_bargain)

story_arc_chapter_one_milo_nothing_you_can_do = ConvoScreen:new {
	id = "nothing_you_can_do",
	animation = "embarrassed",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_60", -- We are working way over capacity now. I just received a message that they want to meet with me later this week. They only do that when they are planning on increasing the requirements yet again. I wish I had never made that deal, but there is nothing I can do about that now. I have to find some way to save my men. I was hoping you could help me.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_62", "what_can_i_do"}, -- What can I do to help?
		{"@conversation/story_arc_chapter_one_milo:s_109", "your_own_mess"}, -- I am sorry. But you got yourself into this mess...
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_nothing_you_can_do)

-- Walk-out two. Also no action.
story_arc_chapter_one_milo_your_own_mess = ConvoScreen:new {
	id = "your_own_mess",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_117", -- Yes. I got us into this mess and would gladly pay for my mistake. But it isn't right that all of my boys should pay as well.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_your_own_mess)

story_arc_chapter_one_milo_what_can_i_do = ConvoScreen:new {
	id = "what_can_i_do",
	animation = "small",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_64", -- It is a pretty slim chance, but I was hoping that maybe some of that old technology could have an answer to our problems. Our engineers say that even though it is from so long ago, it is incredibly powerful. In many ways, more powerful than anything we have now.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_66", "what_old_tech"}, -- What old technology?
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_what_can_i_do)

story_arc_chapter_one_milo_what_old_tech = ConvoScreen:new {
	id = "what_old_tech",
	animation = "explain",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_68", -- It is said that Mustafar wasn't always like it is now. I don't know if that is true or not, but occasionally, we find things...old things that don't belong here. The surface of our world can shift violently, swallowing an entire building, and then years later, spit it back up. Like that cruiser you already visited...it just showed up one day about twenty years ago.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_70", "why_it_matters"}, -- What does this have to do with ancient technology?
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_what_old_tech)

story_arc_chapter_one_milo_why_it_matters = ConvoScreen:new {
	id = "why_it_matters",
	animation = "implore",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_72", -- These things that show up are where we find it. Maybe you could go back to the crashed ship and search it for anything that will enable us to increase our power output or make our mining techniques faster. Anything that can help us.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_74", "what_to_look_for"}, -- What makes you think I will even know what to look for?
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_why_it_matters)

story_arc_chapter_one_milo_what_to_look_for = ConvoScreen:new {
	id = "what_to_look_for",
	animation = "explain",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_76", -- I have been thinking about that. Those ship's memory cores are almost completely destruction-proof. If you can get a terminal online, you should be able to access its memory and find the answers we need. Of course, that is, if there even are any answers to find. Please...help us. I promise you will be well-paid for your trouble.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_92", "i_will_help"}, -- I will do my best to help you.
		{"@conversation/story_arc_chapter_one_milo:s_105", "i_will_pass"}, -- I am going to have to pass. I am sorry.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_what_to_look_for)

-- ACTION grantFirstMission -- this is where the story arc actually starts.
story_arc_chapter_one_milo_i_will_help = ConvoScreen:new {
	id = "i_will_help",
	animation = "thank",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_103", -- Thank you. I promise you will not regret this.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_i_will_help)

-- Walk-out three. Declining is free and repeatable; nothing is recorded.
story_arc_chapter_one_milo_i_will_pass = ConvoScreen:new {
	id = "i_will_pass",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_107", -- Very well. Well, thank you for listening to me. Good day.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_i_will_pass)

-- =====================================================================
-- THE HK-47 CONFESSION.  Greeting s_20, the tree's longest mid-arc
-- branch, and the one that opens chapter three.  Declining here is a
-- real dead end -- s_88 gives no second offer and no action.
-- =====================================================================

-- ACTION checkForError fires on this GREETING -- a no-op here; see the header.
story_arc_chapter_one_milo_worried = ConvoScreen:new {
	id = "worried",
	animation = "sweat",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_20", -- Whew, I was worried that you wouldn't return. Have you discovered anything that will help us?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_81", "what_worse"}, -- Not exactly. I think I might have made things worse.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_worried)

-- ACTION checkForError
story_arc_chapter_one_milo_what_worse = ConvoScreen:new {
	id = "what_worse",
	animation = "huh",
	playerAnimation = "embarrassed",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_82", -- What do you mean, worse? How could things get any worse than they already are?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_83", "field_reports"}, -- I sort of woke up a psychotic robot and now he has control of a droid factory.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_what_worse)

story_arc_chapter_one_milo_field_reports = ConvoScreen:new {
	id = "field_reports",
	animation = "gesticulate_wildly",
	playerAnimation = "explain",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_84", -- What! That would explain the reports I have been getting from the field crews in the eastern sector. They said that a large group of unknown machines were seen heading this way. I figured it was just trilom sickness, but to be safe, I sent out a few scouts. What do you think this robot wants?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_85", "only_hope"}, -- Well, the phrase 'kill all meatbags' did turn up.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_field_reports)

story_arc_chapter_one_milo_only_hope = ConvoScreen:new {
	id = "only_hope",
	animation = "shakefist",
	playerAnimation = "shrug_hands",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_86", -- That is great! Just great! Not only do we have to worry about the Empire, we also need to worry about an army of robots coming and killing us all. Listen, you have to fix this. You have to stop that army of droids. We are miners, not soldiers. You are our only hope.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_87", "clean_it_up"}, -- I made this mess. I will clean it up.
		{"@conversation/story_arc_chapter_one_milo:s_88", "nothing_i_can_do"}, -- I am sorry, but there is nothing I can do.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_only_hope)

-- ACTION grantFinalChapter -- opens chapter three and points at the scout.
story_arc_chapter_one_milo_clean_it_up = ConvoScreen:new {
	id = "clean_it_up",
	animation = "point_away",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_90", -- Thank you. The scouts that I sent out are to the southeast of here. If anything is coming from that factory, it will head right through a small valley in that direction. I will give you a tracking code to my best scout... If the droids are out there, he will have found them. Good luck.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_clean_it_up)

story_arc_chapter_one_milo_nothing_i_can_do = ConvoScreen:new {
	id = "nothing_i_can_do",
	animation = "wave_on_dismissing",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_89", -- So, you are just going to leave us to the mercy of a droid. Thanks for nothing.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_nothing_i_can_do)

-- =====================================================================
-- THE VOLCANO.  Greeting s_94, the report that the factory is down but
-- HK-47 got away, ending in startVolcanoQuest.
-- =====================================================================

story_arc_chapter_one_milo_army_gone = ConvoScreen:new {
	id = "army_gone",
	animation = "beckon",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_94", -- The droid army is gone, but did you stop the problem at its source?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_97", "crater_signal"}, -- The droid factory is offline, but HK-47 was nowhere to be seen.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_army_gone)

-- ACTION checkForError
story_arc_chapter_one_milo_crater_signal = ConvoScreen:new {
	id = "crater_signal",
	animation = "rub_chin_thoughtful",
	playerAnimation = "explain",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_98", -- That would explain the strange signals we have been monitoring from the volcano crater. We managed to decipher the signal, and it sounds like someone is trying to flag down a passing ship. It must be HK-47.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_99", "no_one_else"}, -- And I suppose I must be the one to stop him.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_crater_signal)

story_arc_chapter_one_milo_no_one_else = ConvoScreen:new {
	id = "no_one_else",
	animation = "nod",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_100", -- There isn't anyone else who can do it. Please, we cannot let him escape. If he were to get away, he could come back at any time and turn that factory back on. We might not get another chance.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_112", "need_a_pilot"}, -- And how am I suppose to get up there?
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_no_one_else)

-- ACTION startVolcanoQuest -- sends the player looking for the crazy pilot.
story_arc_chapter_one_milo_need_a_pilot = ConvoScreen:new {
	id = "need_a_pilot",
	animation = "point_away",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_113", -- You will need a pilot. And since you are flying into the crater of an active volcano, you are going to need a crazy pilot. With all of the off-world traffic we have had lately, there must be one around here somewhere. If they need to be paid, tell them to bill Mensix Corp.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_need_a_pilot)

-- =====================================================================
-- THE PAYOFF.  Greeting s_114, HK-47 dead, and the last action in the
-- whole seven-script arc.
-- =====================================================================

story_arc_chapter_one_milo_signal_stopped = ConvoScreen:new {
	id = "signal_stopped",
	animation = "explain",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_114", -- The signal has stopped. You have saved us from that insane droid. That is one major problem off of our backs, but we still are not any closer to solving our Empire problem.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_115", "factory_owner"}, -- Don't be so certain. You now are the proud owner of a fully-stocked droid factory.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_signal_stopped)

-- ACTION grantFinalReward -- and the terminal it points at is the message
-- console the next greeting, s_123, keeps repeating.
story_arc_chapter_one_milo_factory_owner = ConvoScreen:new {
	id = "factory_owner",
	animation = "point_forward",
	playerAnimation = "laugh_titter",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_116", -- What! Of course, we can take the resources that are stockpiled there and sell them off to the Empire to fill or order. That is brilliant! We take care of the Empire and make sure that the factory can never be used again at the same time. You have done us a huge service. By the way, you have a message waiting for you. It was encoded for your eyes only, so I am not sure what it is about. You can use that terminal over there.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_factory_owner)

-- =====================================================================
-- THE NUDGES.  One greeting pair per remaining condition.  Every one of
-- these is a "get back out there" -- no action moves the arc, and the
-- four that carry checkForError carry only that.
-- =====================================================================

-- 1 hasWonStoryArc. The arc is over.
story_arc_chapter_one_milo_all_safe = ConvoScreen:new {
	id = "all_safe",
	animation = "thank",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_101", -- Thank you again for all your help. All my men will be safe because of you.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_all_safe)

-- 2 messageWaiting. Points at the communication console.
story_arc_chapter_one_milo_message_waiting = ConvoScreen:new {
	id = "message_waiting",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_123", -- Hello again. You still have that message stored for you. You can use the communication console in the back of the room to check it if you wish. Thanks again my friend.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_message_waiting)

-- 4 isFightingHK.
story_arc_chapter_one_milo_hk_still_active = ConvoScreen:new {
	id = "hk_still_active",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_111", -- We are still getting those signals from the crater. HK-47 is still active. Get a pilot who will fly you there, and defeat him.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_hk_still_active)

-- 6 isFightingDroids.
story_arc_chapter_one_milo_droids_active = ConvoScreen:new {
	id = "droids_active",
	animation = "implore",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_93", -- I am still getting reports of heavy droid activity. You are the only one qualified to protect us. Please get out there and put an end to this menace.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_95", "be_careful"}, -- I will do what I can.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_droids_active)

story_arc_chapter_one_milo_be_careful = ConvoScreen:new {
	id = "be_careful",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_96", -- Thank you. And be careful. Those droids mean business.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_be_careful)

-- 8 hasCompletedFourthMission. Unreachable -- see the header.
story_arc_chapter_one_milo_discovered_yet = ConvoScreen:new {
	id = "discovered_yet",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_132", -- Have you discovered anything yet?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_133", "working_on_it"}, -- I am working on it.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_discovered_yet)

-- ACTION checkForError
story_arc_chapter_one_milo_working_on_it = ConvoScreen:new {
	id = "working_on_it",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_134", -- Good to hear. Thank you.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_working_on_it)

-- 9 isOnSecondMission.
story_arc_chapter_one_milo_productivity = ConvoScreen:new {
	id = "productivity",
	animation = "beckon",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_32", -- Have you managed to discover how to increase the productivity of this station yet?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_79", "good_news"}, -- I have some leads that I am working on.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_productivity)

story_arc_chapter_one_milo_good_news = ConvoScreen:new {
	id = "good_news",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_80", -- That is great news. Keep up the good work.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_good_news)

-- 10 hasCompletedThirdMission. Unreachable -- see the header.
story_arc_chapter_one_milo_back_to_work = ConvoScreen:new {
	id = "back_to_work",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_129", -- You should get back to work. We really don't have a whole lot of time.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_130", "if_you_say_so"}, -- If you say so.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_back_to_work)

-- ACTION checkForError
story_arc_chapter_one_milo_if_you_say_so = ConvoScreen:new {
	id = "if_you_say_so",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_131", -- Thank you.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_if_you_say_so)

-- 11 hasCompletedSecondMission.
story_arc_chapter_one_milo_follow_leads = ConvoScreen:new {
	id = "follow_leads",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_126", -- Please just follow the leads you have and see what you can do about helping us.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_127", "will_do"}, -- Will do.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_follow_leads)

-- ACTION checkForError
story_arc_chapter_one_milo_will_do = ConvoScreen:new {
	id = "will_do",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_128", -- Glad to hear it. Good luck to you.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_will_do)

-- 12 hasCompletedFirstMission.
story_arc_chapter_one_milo_no_more_help = ConvoScreen:new {
	id = "no_more_help",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_125", -- I don't know how I can be of any more help to you. You were supposed to look for something at the crash site that could help us out and follow through with your information there.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_no_more_help)

-- 13 isOnFirstMission.
story_arc_chapter_one_milo_how_is_search = ConvoScreen:new {
	id = "how_is_search",
	animation = "beckon",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_36", -- How is your search going? Have you managed to find anything that might help us out?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_one_milo:s_77", "still_working"}, -- Not so far. But I am still working on it.
	}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_how_is_search)

story_arc_chapter_one_milo_still_working = ConvoScreen:new {
	id = "still_working",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_78", -- Thank you again for all the help you are giving to us.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_still_working)

-- 15 default, and the template's initialScreen. Anyone who has not finished the
-- prelude gets pointed back at Foreman Chivos, which is exactly the gate the old
-- offerArc SUI box was standing in for.
story_arc_chapter_one_milo_see_chivos = ConvoScreen:new {
	id = "see_chivos",
	animation = "shoo",
	leftDialog = "@conversation/story_arc_chapter_one_milo:s_124", -- If you are interested in a job, perhaps Foreman Chivos has something for you. If you will excuse me...as you can see here, I have some very important matters that need my attention.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_one_milo:addScreen(story_arc_chapter_one_milo_see_chivos)

addConversationTemplate("story_arc_chapter_one_milo", story_arc_chapter_one_milo)
