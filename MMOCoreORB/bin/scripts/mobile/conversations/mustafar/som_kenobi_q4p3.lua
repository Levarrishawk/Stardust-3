--[[
	Q4P3 -- Pann's protocol droid, quest giver for som_kenobi_collectors_business_1.

	Every line below is an existing @conversation/som_kenobi_collectors_business_q4p3 entry,
	so this works against a stock client with no new strings. As with som_pei_yi, SOE kept the
	conversation trees server-side and only the string table shipped
	(string/en/conversation/som_kenobi_collectors_business_q4p3.stf), so the tree is
	reconstructed from the strings.

	THE PAIRING IS NOT GUESSWORK

	This table numbers a player line and the NPC line that answers it consecutively, which
	pins almost every edge:

	    s_53 -> s_57, s_58 -> s_59, s_61 -> s_62, s_63 -> s_64, s_65 -> s_66, s_67 -> s_68,
	    s_69 -> s_70, s_71 -> s_74, s_75 -> s_76, s_77 -> s_79,
	    s_81 -> s_83, s_85 -> s_87, s_89 -> s_91, s_94 -> s_96, s_98 -> s_100,
	    s_102 -> s_104, s_109 -> s_111, s_113 -> s_115, s_117 -> s_150, s_152 -> s_154,
	    s_39 -> s_159, s_160 -> s_161, s_162 -> s_163, s_164 -> s_165,
	    s_40 -> s_166, s_167 -> s_168, s_169 -> s_170, s_171 -> s_172,
	    s_107 -> s_55, s_108 -> s_56, s_130 -> s_132, s_131 -> s_133,
	    s_155 -> s_157, s_156 -> s_158

	Two whole branches fall out of that: a civil one (s_57..s_76) and a hostile one
	(s_83..s_150) that retell the same briefing in a ruder register and end at the same
	accept. Each has its own decline (s_77/s_79 and s_152/s_154). Both accepts hand over the
	same three things -- scanner, communicator, coordinates -- which is why the handler fires
	the quest on either.

	The remaining lines are the four non-briefing greetings:

	    s_106  the opener, before the quest is taken
	    s_122  "you seem to lack the experience to assist me" -- the level gate. The .qst's
	           [list] block says Level 75, so that is the number this checks.
	    s_129  mid-quest, "How may I be of service?"
	    s_5    the turn-in, "I'm getting the feeling that you have good news for me"
	    s_93   after the quest, "Soon I will be on my way to the next planet"

	s_2 is empty in the shipped table and is not used.

	%TU is substituted by the client from the conversation packet; it is left in the strings
	rather than rewritten.

	WHAT THE TURN-IN ACTUALLY SAYS

	Both turn-in branches say the Codex is NOT the Codex -- it is "an information storage
	device" with "a secondary function". Q4P3 pays anyway (s_163 / s_170, 10,000 credits) and
	tells the player to keep the device. The screenplay honours both halves of that; see
	THE REWARD in collectors_business.lua.
--]]

som_kenobi_q4p3 = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "q4p3_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- Greetings. The handler picks which one opens, from the player's stage.
--------------------------------------------------------------------------------

q4p3_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_106", -- Excuse me, friend. I'm terribly sorry for interrupting you, but I am in need of assistance. Are you skilled in the...'arts' of combat.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_53", "ask_civil"},   -- I can hold my own if I'm forced to. Why?
		{"@conversation/som_kenobi_collectors_business_q4p3:s_81", "ask_rude"},    -- Yes, why? Do you need a beating?
		{"@conversation/som_kenobi_collectors_business_q4p3:s_107", "bye_not_me"}, -- No, I'm sorry. That's not what I do.
		{"@conversation/som_kenobi_collectors_business_q4p3:s_108", "bye_leave"},  -- I don't have time for your nonsense, droid. Leave me be.
	}
}
som_kenobi_q4p3:addScreen(q4p3_greeting)

q4p3_too_low = ConvoScreen:new {
	id = "too_low",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_122", -- Greetings! If you come looking for work, I do have something I need help with. Unfortunately you seem to lack the experience to assist me. Please come back when you have gained some though, as I really could use the help.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_too_low)

q4p3_in_progress = ConvoScreen:new {
	id = "in_progress",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_129", -- It's %TU! Great to see you. How may I be of service?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_155", "still_on_it"},      -- I just wanted to let you know that I'm still working on your mission.
		{"@conversation/som_kenobi_collectors_business_q4p3:s_130", "still_on_it_rude"}, -- Save the pleasantries, wire brain. I'm working on your mission.
		{"@conversation/som_kenobi_collectors_business_q4p3:s_156", "give_up"},          -- I'm sorry, Q4P3, but something has come up. I can't do this right now.
		{"@conversation/som_kenobi_collectors_business_q4p3:s_131", "give_up_rude"},     -- You may not! I don't have time for your crazy mission!
	}
}
som_kenobi_q4p3:addScreen(q4p3_in_progress)

q4p3_turn_in = ConvoScreen:new {
	id = "turn_in",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_5", -- You are back, %TU! It is marvelous to see you again. I'm getting the feeling that you have good news for me as well.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_39", "not_it"},      -- I hope so, Q4P3. I found this little thing.
		{"@conversation/som_kenobi_collectors_business_q4p3:s_40", "not_it_rude"}, -- Blah, blah, blah. Here, is this thing it?
	}
}
som_kenobi_q4p3:addScreen(q4p3_turn_in)

q4p3_finished = ConvoScreen:new {
	id = "finished",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_93", -- Yes, I'm still here, %TU. Soon I will be on my way to the next planet to see if I can find the 'Codex' for my master there. Be well, friend.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_finished)

--------------------------------------------------------------------------------
-- The civil briefing
--------------------------------------------------------------------------------

q4p3_ask_civil = ConvoScreen:new {
	id = "ask_civil",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_57", -- Thank you for taking the time to listen to me, friend. My master has sent me on a mission to find an item of great importance to him. But where are my manners? I am Q4P3. May I bother you for your name? %TU? What an extraordinary name. Now where was I?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_58", "sent_to_find"}, -- Your master has sent you to...
	}
}
som_kenobi_q4p3:addScreen(q4p3_ask_civil)

q4p3_sent_to_find = ConvoScreen:new {
	id = "sent_to_find",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_59", -- Yes, of course, to find this item. That is right. It's a little pyramid-shaped trinket that is called the 'Codex'. I wouldn't know what it is for, but it must be terribly important to my master. Now why do I need your help? Well, I may have found the 'Codex' on this here fine planet, but it's much too dangerous out in the wilderness for me.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_61", "how_you_know"}, -- I see. Well, if you haven't been there, how do you know...
	}
}
som_kenobi_q4p3:addScreen(q4p3_sent_to_find)

q4p3_how_you_know = ConvoScreen:new {
	id = "how_you_know",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_62", -- Where the 'Codex' is? That it's actually the 'Codex'? It will be my pleasure to explain that, %TU. You see, the droids on this planet are not afraid to venture out into the wilds; in fact, it is their duty to work out there. I've been communicating with a few of them, which wasn't easy...let me tell you. Terribly basic communication skills.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_63", "basic_comms"}, -- Well, they don't really need to communicate that much...
	}
}
som_kenobi_q4p3:addScreen(q4p3_how_you_know)

q4p3_basic_comms = ConvoScreen:new {
	id = "basic_comms",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_64", -- You are absolutely right, %TU. Very true indeed. Anyway, from the droids, I found out that one of their units reported coming across what fits with the description of the 'Codex' that my master gave me. Seeing how these very basic droids have no interest in such things, the unit just moved on to continue with his work.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_65", "from_the_droids"}, -- So you got the location from communicating with these droids?
	}
}
som_kenobi_q4p3:addScreen(q4p3_basic_comms)

q4p3_from_the_droids = ConvoScreen:new {
	id = "from_the_droids",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_66", -- Yes! Actually, no. Since this happened a while ago, they had already wiped the coordinates from their mainframe. Luckily for us though, the droid in question, shortly after he had found the item, malfunctioned. He's still out there, waiting to be collected by his owners. He should still have the location in his memory bank, and I know where he is!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_67", "the_task"}, -- So you want me to go out there, find the droid...
	}
}
som_kenobi_q4p3:addScreen(q4p3_from_the_droids)

q4p3_the_task = ConvoScreen:new {
	id = "the_task",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_68", -- ...get the location of the item from his memory bank, using a scanner that I will lend you, then go and find the item and bring it back to me. Exactly, %TU! I couldn't have said it better myself. Upon conclusion of your services, my master has instructed me to pay a handsome reward.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_69", "the_master"}, -- Who is your master anyway?
	}
}
som_kenobi_q4p3:addScreen(q4p3_the_task)

q4p3_the_master = ConvoScreen:new {
	id = "the_master",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_70", -- My master is the honorable Pann! Respected throughout the galaxy for his wisdom and chivalry!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_71", "accept_civil"},  -- Very well, I believe I can assist you with this, Q4P3.
		{"@conversation/som_kenobi_collectors_business_q4p3:s_77", "decline_civil"}, -- I will have to pass for now, Q4P3. I have a lot to do.
	}
}
som_kenobi_q4p3:addScreen(q4p3_the_master)

-- The handler starts the quest on this screen.
q4p3_accept_civil = ConvoScreen:new {
	id = "accept_civil",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_74", -- This is fantastic news, %TU! Do you want a hug? No? Of course not. How stupid of me. Take this scanner and use that on the droid to find the 'Codex'. Also, you will need this communicator, so that we can stay in touch, and these coordinates to the last known location of the malfunctioned droid.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_75", "bye_all_set"}, -- Good, looks like I'm set.
	}
}
som_kenobi_q4p3:addScreen(q4p3_accept_civil)

q4p3_bye_all_set = ConvoScreen:new {
	id = "bye_all_set",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_76", -- I agree, %TU! I wish you the best of luck and I can't wait to hear from you.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_bye_all_set)

q4p3_decline_civil = ConvoScreen:new {
	id = "decline_civil",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_79", -- That is terribly bad news, %TU, but I completely understand and hold no grudge. I apologize for taking up so much of your time and wish you the best of luck.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_decline_civil)

--------------------------------------------------------------------------------
-- The hostile briefing. Same errand, ruder register, same accept.
--------------------------------------------------------------------------------

q4p3_ask_rude = ConvoScreen:new {
	id = "ask_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_83", -- Goodness no! I would like your assistance, though. My master has sent me on a mission to find an item of great importance to him. But where are my manners? I am Q4P3. May I bother you for your name? %TU? Thank you. Now where was I?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_85", "sent_to_find_rude"}, -- Your master had sent you to this forsaken place for...
	}
}
som_kenobi_q4p3:addScreen(q4p3_ask_rude)

q4p3_sent_to_find_rude = ConvoScreen:new {
	id = "sent_to_find_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_87", -- Yes, of course. To find this item, that is right. It's a little pyramid-shaped trinket that is called the 'Codex'. I wouldn't know what it is for, but it must be terribly important to my master. Now why do I need your help? Well, I may have found the 'Codex' on this here fine planet, but it's much too dangerous out in the wilderness for me.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_89", "how_you_know_rude"}, -- Interesting...but if you haven't been there, how do you know...
	}
}
som_kenobi_q4p3:addScreen(q4p3_sent_to_find_rude)

q4p3_how_you_know_rude = ConvoScreen:new {
	id = "how_you_know_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_91", -- Where the 'Codex' is? That it's actually the 'Codex'? Well, %TU. You see, the droids on this planet are not afraid to venture out into the wilds; in fact, it is their duty to work out there. I've been communicating with a few of them, which wasn't easy...let me tell you. Terribly basic communication skills.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_94", "from_the_droids_rude"}, -- Get to the point before I do something to your communication system.
	}
}
som_kenobi_q4p3:addScreen(q4p3_how_you_know_rude)

q4p3_from_the_droids_rude = ConvoScreen:new {
	id = "from_the_droids_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_96", -- Of course, %TU. Of course! From the droids, I found out that one of their units reported coming across what fits with the description of the 'Codex' that my master gave me. Seeing how these very basic droids have no interest in such things, the unit just moved on to continue with his work.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_98", "coords_rude"}, -- So give me the location and I'll go get it.
	}
}
som_kenobi_q4p3:addScreen(q4p3_from_the_droids_rude)

q4p3_coords_rude = ConvoScreen:new {
	id = "coords_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_100", -- Yes, of course. No. Wait. I can't! Since this happened a while ago, they had already wiped the coordinates from their mainframe. Luckily for us, the droid in question, shortly after he had found the item, malfunctioned. He's still out there, waiting to be collected by his owners. He should still have the location in his memory bank, and I know where he's at!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_102", "the_task_rude"}, -- So let me guess... You want me to find this tin can...
	}
}
som_kenobi_q4p3:addScreen(q4p3_coords_rude)

q4p3_the_task_rude = ConvoScreen:new {
	id = "the_task_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_104", -- ...get the location of the item from his memory bank, using a scanner that I will lend you, then go and find the item and bring it back to me. Exactly, %TU! I couldn't have said it better myself. Upon conclusion of your services, my master has instructed me to pay a handsome reward.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_109", "the_master_rude"}, -- Reward, eh? Who is your master anyway?
		{"@conversation/som_kenobi_collectors_business_q4p3:s_152", "decline_rude"},    -- Sounds like a bunch of crap to me. I'm out of here, crazy droid.
	}
}
som_kenobi_q4p3:addScreen(q4p3_the_task_rude)

q4p3_the_master_rude = ConvoScreen:new {
	id = "the_master_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_111", -- My master is the honorable Pann! Respected throughout the galaxy for his wisdom and chivalry!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_113", "accept_rude"}, -- Sounds like a wimp to me. Very well, I'll help you out.
	}
}
som_kenobi_q4p3:addScreen(q4p3_the_master_rude)

-- The handler starts the quest on this screen too.
q4p3_accept_rude = ConvoScreen:new {
	id = "accept_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_115", -- This is fantastic news, %TU! Take this scanner and use that on the droid to find the 'Codex'. Also, you will need this communicator, so that we can stay in touch, and these coordinates to the last known location of the malfunctioned droid.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_117", "bye_marvelous"}, -- Alright, bucket boy, I'm out of here.
	}
}
som_kenobi_q4p3:addScreen(q4p3_accept_rude)

q4p3_bye_marvelous = ConvoScreen:new {
	id = "bye_marvelous",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_150", -- Marvelous, %TU! I hope something terrible happens to you...I mean, nothing terrible happens to you! I'm looking forward to hearing from you again soon.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_bye_marvelous)

q4p3_decline_rude = ConvoScreen:new {
	id = "decline_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_154", -- Of course, of course. A bunch of nonsense is all. A thousand apologies for keeping you from squandering all your credits in the Cantina...I mean from your important business! Farewell!
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_decline_rude)

--------------------------------------------------------------------------------
-- Mid-quest
--------------------------------------------------------------------------------

q4p3_still_on_it = ConvoScreen:new {
	id = "still_on_it",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_157", -- Excellent, %TU. Be very careful out there.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_still_on_it)

q4p3_still_on_it_rude = ConvoScreen:new {
	id = "still_on_it_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_132", -- Great! I hope you don't get lost out there or eaten by any huge monsters, robbed by bandits, step into molten lava, or die from thirst. I'm sure nothing like that would happen to someone of your caliber, though, %TU.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_still_on_it_rude)

-- The handler resets the player's progress on both give-up screens.
q4p3_give_up = ConvoScreen:new {
	id = "give_up",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_158", -- That is sad news indeed, %TU. I was sure that you would solve this for me. I understand, though. I'm sure you have important things to do and I wish you the best of luck.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_give_up)

q4p3_give_up_rude = ConvoScreen:new {
	id = "give_up_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_133", -- Oh no! How will I ever get by without your friendly wit and charming personality, %TU? I guess I will have to make due. You take care now.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_give_up_rude)

--------------------------------------------------------------------------------
-- Turn-in. Both branches pay; see THE REWARD in collectors_business.lua.
--------------------------------------------------------------------------------

q4p3_not_it = ConvoScreen:new {
	id = "not_it",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_159", -- Yes! This looks...wait, no, this is not it. It's interesting though...seems to be an information storage device. Something odd about it. I think it has a secondary function, but I'm not sure what it is.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_160", "fragment"}, -- What kind of information is stored on it?
	}
}
som_kenobi_q4p3:addScreen(q4p3_not_it)

q4p3_fragment = ConvoScreen:new {
	id = "fragment",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_161", -- It's very old and I can only discern a fragment of it. The rest seems to be corrupted. It says, '...was going according to plans until yesterday. The weakling Jedi has some sort of secret weapon and I can feel the effects of it already now. I can sense that our master knows what it is, but he has revealed nothing, only forced us to press on even harder...'
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_162", "reward"}, -- How odd. I wonder how old it is. Anyway, I'm sorry it's not the 'Codex'.
	}
}
som_kenobi_q4p3:addScreen(q4p3_fragment)

-- The handler pays out on this screen.
q4p3_reward = ConvoScreen:new {
	id = "reward",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_163", -- As am I, %TU. Nevertheless, you have performed your part flawlessly. I am obligated and honored to reward you for your services. You can keep this device and I will deposit 10,000 credits to your bank account immediately.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_164", "bye_kind"}, -- Most kind Q4P3, thank your master for me.
	}
}
som_kenobi_q4p3:addScreen(q4p3_reward)

q4p3_bye_kind = ConvoScreen:new {
	id = "bye_kind",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_165", -- I will indeed, %TU. You take well care of yourself now.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_bye_kind)

q4p3_not_it_rude = ConvoScreen:new {
	id = "not_it_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_166", -- Let me see. No, sadly it's not. This seems to be an information storage device. Something odd about it... I think it has a secondary function, but I'm not sure what it is.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_167", "fragment_rude"}, -- Well, isn't that great. What does it say?
	}
}
som_kenobi_q4p3:addScreen(q4p3_not_it_rude)

q4p3_fragment_rude = ConvoScreen:new {
	id = "fragment_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_168", -- It's very old and I can only discern a fragment of it. The rest seems to be corrupted. It says, '...was going according to plans until yesterday. The weakling Jedi has some sort of secret weapon and I can feel the effects of it already now. I can sense that our master knows what it is, but he has revealed nothing, only forced us to press on even harder...'
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_169", "reward_rude"}, -- Interesting...well since it isn't the 'Codex', I can keep it right?
	}
}
som_kenobi_q4p3:addScreen(q4p3_fragment_rude)

-- The handler pays out on this screen too.
q4p3_reward_rude = ConvoScreen:new {
	id = "reward_rude",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_170", -- Yes, of course. Since you did your part, I'm also obligated to pay you for your services, so 10,000 credits will be deposited to your account immediately.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_collectors_business_q4p3:s_171", "bye_money"}, -- That money better be there when I get to the bank droid.
	}
}
som_kenobi_q4p3:addScreen(q4p3_reward_rude)

q4p3_bye_money = ConvoScreen:new {
	id = "bye_money",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_172", -- Absolutely, %TU. You have a pleasant day now, and don't spend all that money in the cantina.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_bye_money)

--------------------------------------------------------------------------------
-- Farewells off the opening screen
--------------------------------------------------------------------------------

q4p3_bye_not_me = ConvoScreen:new {
	id = "bye_not_me",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_55", -- My mistake then, friend. Let me take up no more of your valuable time.
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_bye_not_me)

q4p3_bye_leave = ConvoScreen:new {
	id = "bye_leave",
	leftDialog = "@conversation/som_kenobi_collectors_business_q4p3:s_56", -- A thousand apologies, friend!
	stopConversation = "true",
	options = {}
}
som_kenobi_q4p3:addScreen(q4p3_bye_leave)

addConversationTemplate("som_kenobi_q4p3", som_kenobi_q4p3)
