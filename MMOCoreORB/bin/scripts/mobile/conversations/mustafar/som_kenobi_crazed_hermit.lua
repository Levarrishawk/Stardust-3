--[[
	som_kenobi_crazed_hermit -- the hermit who carries the Soul Crystal shard in
	som_kenobi_main_quest_1.

	SOURCE. string/en/conversation/som_kenobi_crazed_hermit.stf, 55 strings. All
	54 speaking ones are used below; s_2 is empty and is skipped. The English
	text rides along as a trailing comment on every reference.

	RECONSTRUCTED, THEN CHECKED AGAINST THE LIVE TREE. The .stf is a flat list
	with no parent links, so the wiring below was first reconstructed by matching
	each option to the screen its wording answers. The live conversation script
	has since been read, and it disagreed in six places. Every one is corrected
	here with what caused it, because the same reading habit will produce the
	same mistake again on the next tree.

	WHAT THE .qst NEEDS FROM THIS TREE. som_kenobi_main_quest_1 talks to him
	twice, with a blistmok wave in between:
	  task 6   Encounter som_kenobi_crazed_hermit, Count 1
	  task 10  Wait for Signal 'talkedHermit1'   (taskName talkHermit1)
	  task 14  Encounter som_kenobi_blistmok, Count 4          <-- the wave
	  task 15  Wait for Signal 'talkedHermit2'   (taskName talkHermit2)
	  task 17  Immediately Complete -> grants som_kenobi_main_quest_spared
	  task 21  Destroy Multiple and Loot som_kenobi_crazed_hermit
	           "You remove the Soul Crystal from the corpse of the Crazed Hermit."
	  task 22  -> grants som_kenobi_main_quest_killed
	So the tree has to do exactly two things: end the first meeting in a way that
	fires 'talkedHermit1', and, after the wave, either reach a handover screen
	(fires 'talkedHermit2', the spared branch) or provoke him into attacking
	(the player kills him and loots the shard, the killed branch).

	TWO MEETINGS, ONE TREE. conversationTemplate binds per creature template, so
	both meetings live in this one tree and the handler picks the root:
	  before the wave -> "greeting" (s_93, the blistmok he was keeping)
	  after the wave  -> "quiet"    (s_67, "No more fun left")
	The second root is where every handover and every provocation hangs, so the
	shard cannot be taken on the first meeting. Live splits it the same way --
	condition_hermitChat1 opens on s_93, condition_hermitChat2 on s_67.

	CORRECTING THE BOUNDARY BETWEEN THE TWO MEETINGS. Four player lines were on
	the wrong side of it. Live is:

	    s_69   "Please, I implore you, give me the crystal."  SECOND, off quiet
	    s_100  "You're not going anywhere."                   FIRST, off nopain
	    s_104  "[Use the Force] Hand me the gem, now!"        FIRST, off wants
	    s_72   "Just let me hold the gem for a second."       SECOND, off tired

	That moves `tired` (s_71) out of the first meeting entirely and makes it the
	second meeting's second screen, and it turns `nopain` (s_66) from a dead end
	into a screen with one option on it.

	ROOT CAUSE: reading the two meetings as two separate conversations, when the
	.stf is one flat list and does not say which meeting a line belongs to. Every
	line above is a player pressing for the crystal, and pressing for the crystal
	reads like the second meeting -- so s_69 and s_72 were put there and the two
	that actually belong there were pulled back to the first. What the .stf could
	not show is that SOE wrote the FIRST meeting with two demands in it as well.
	They just do not work: the voice answers both with a threat and the meeting
	ends. Nothing distinguishes a demand that fails from a demand that succeeds
	except which screen answers it, and only the live script has that.

	CORRECTING THE SECOND MEETING'S SPINE. It follows from the boundary fix and
	is worth stating on its own, because the shape changed. Live runs one line
	down from the greeting rather than fanning out of it:

	    quiet -> tired -> hold -> sounds -> handover_free
	    quiet -> yell  -> killhim -> handover_trade

	`quiet` carries two options, not four. `hold` gained s_77 and now leads to
	`sounds` on s_74 instead of straight to the handover, and `sounds` gained
	s_80 as its handover and lost s_72. The gentle road is four screens long
	before the shard changes hands, not two.

	CORRECTING TWO SWAPPED PAIRS. Both are places where two screens answer the
	same idea in nearly the same words, and the earlier revision paired them by
	which reply sounded like a better fit.

	  off `yell`   live answers s_87 with s_91 and s_89 with s_90. They were the
	               other way round here.
	  off `killhim` live answers s_94 with s_97 -- a handover -- and s_95 with
	               s_96, the refusal. They were the other way round here.

	ROOT CAUSE, both: the text reads the wrong way. s_90 opens "If I give you the
	crystal, it will finally..." which is almost word for word s_87's "Give me the
	crystal and it will stop!", so it was paired with it; live pairs s_87 with
	s_91. And s_96 says "You don't know where he is", which answers s_94's "I can
	find him and kill him" far better than it answers s_95's "I need the gem to
	find him" -- but live sends s_94 to the handover and s_95 to the refusal. In
	both pairs the closest echo is not the live edge. Note that the header of this
	file already described the killhim pair correctly in prose -- "s_97 by
	promising to hunt the voice down" is s_94 -- while the wiring underneath it
	said the opposite. The prose was right and unread.

	WHAT ENDS THE FIRST MEETING, AND WHAT STARTS THE FIGHT. These were run
	together, and they are not the same list.

	  fires 'talkedHermit1', ends the first meeting, no combat
	      s_50  madness     s_54  mad_calm
	      s_102 mad_demand  s_106 mad_force
	  makes him hostile, all in the SECOND meeting
	      s_76  s_81  s_85  s_90  s_91  s_96

	The earlier revision called nine screens the combat trigger, on the grounds
	that all nine end with the voice shouting "kill him". Six of them do that and
	then he attacks. The other three -- s_54, s_102, s_106 -- are the voice
	shouting the same thing in the FIRST meeting, where he cannot attack because
	the blistmok wave has not happened yet, and where live fires signalTalked1
	instead. Same words, different consequence.

	ROOT CAUSE: reading the screen TEXT for what the screen does. "Kill him now!"
	is a stage direction about the voice, not about the server. The four screens
	that end the first meeting are named mad_* here rather than kill_* for exactly
	this reason -- the old names invited the mistake back in.

	NOTE ON THE FORCE OPTIONS. s_52, s_75, s_89 and s_104 are the four
	[Use the Force] lines, and live gates every one with condition_playerJedi.
	Every one of them also fails: the shipped replies are s_54, s_76, s_90 and
	s_106, all of them the voice shouting the suggestion down. That is SOE's
	writing, not a wiring choice; the crystal is what is resisting. See the
	handler for the gate itself.
]]

som_kenobi_crazed_hermit = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "crazed_hermit_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- the two one-liners. s_108 while the blistmok wave is on him, s_110 for
-- everyone live has nothing else to say to -- which is both a character who
-- already has the shard and a character who was never on the quest.
--------------------------------------------------------------------------------

kenobi_hermit_ambient = ConvoScreen:new {
	id = "ambient",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_108", -- Hahaha, they are dancing! So pretty. Look at them! You're missing it!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_ambient)

kenobi_hermit_rest = ConvoScreen:new {
	id = "rest",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_110", -- Please, leave me alone. I need to rest.
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_rest)

--------------------------------------------------------------------------------
-- first meeting. Two roads down from s_93, each ending twice: the pleading end
-- and the demanding end. All four fire 'talkedHermit1' and bring on the wave.
--------------------------------------------------------------------------------

kenobi_hermit_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_93", -- Did you hurt those beautiful animals?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_37", "forced"},   -- I was forced to. They were trying to kill me.
		{"@conversation/som_kenobi_crazed_hermit:s_56", "critters"}, -- Beautiful? Whatever, I'm not here to talk about critters.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_greeting)

kenobi_hermit_forced = ConvoScreen:new {
	id = "forced",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_40", -- Exactly what I said as the gem was screaming at me!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_41", "gem"}, -- You don't say...this gem, can I see it?
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_forced)

kenobi_hermit_gem = ConvoScreen:new {
	id = "gem",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_42", -- Gem? They are everywhere! Up, down, wherever they please! I can't stand them anymore. Always blabbing. Never quiet. I have to get away. Go where it's quiet!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_44", "curse"},    -- You're not making any sense, friend. Please calm down.
		{"@conversation/som_kenobi_crazed_hermit:s_52", "mad_calm"}, -- [Use the Force] Sssh, calm yourself.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_gem)

kenobi_hermit_curse = ConvoScreen:new {
	id = "curse",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_46", -- Do you think that it's easy?! Carrying the curse?! Aww, the noises. Make them stop!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_48", "madness"}, -- What can I do? How can I help you?
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_curse)

kenobi_hermit_critters = ConvoScreen:new {
	id = "critters",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_58", -- Talk? That's all you ever do! Go there, go here, do that.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_60", "wants"}, -- What are you blabbing about? I need something you have.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_critters)

kenobi_hermit_wants = ConvoScreen:new {
	id = "wants",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_62", -- Everyone wants something. You, you want the gem. They all do. They don't know though, they don't understand!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_64", "nopain"},    -- Yes, I want the gem and you will give it to me, or you might get hurt.
		{"@conversation/som_kenobi_crazed_hermit:s_104", "mad_force"}, -- [Use the Force] Hand me the gem, now!
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_wants)

kenobi_hermit_nopain = ConvoScreen:new {
	id = "nopain",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_66", -- No pain! I don't need more pain! Do you need pain? No, what am I saying. We can just walk away, always walk away.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_100", "mad_demand"}, -- You're not going anywhere. Now hand over the crystal.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_nopain)

--------------------------------------------------------------------------------
-- the four first-meeting endings. Named mad_* and not kill_* on purpose: the
-- voice says "kill him" on three of them and he does not, because the wave has
-- not happened yet. See WHAT ENDS THE FIRST MEETING.
--------------------------------------------------------------------------------

kenobi_hermit_madness = ConvoScreen:new {
	id = "madness",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_50", -- Help me? Help me?! You're the one that needs help! Accept your faith, puny one. Do not fight it!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_madness)

kenobi_hermit_mad_calm = ConvoScreen:new {
	id = "mad_calm",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_54", -- Your insolence will not go unpunished! Kneel before me and accept your fate as your life trickles down onto the molten ground!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_mad_calm)

kenobi_hermit_mad_demand = ConvoScreen:new {
	id = "mad_demand",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_102", -- No! You kneel before me and accept what's coming your way! This is your final moment. Welcome it with grace!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_mad_demand)

kenobi_hermit_mad_force = ConvoScreen:new {
	id = "mad_force",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_106", -- Where you're going, you won't need it! You're nothing but a puppet and it's time to cut the strings!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_mad_force)

--------------------------------------------------------------------------------
-- second meeting, after the blistmok wave. This root is the only way to the
-- shard and the only way to provoke him. Two roads: pleading, through tired,
-- and shouting, through yell.
--------------------------------------------------------------------------------

kenobi_hermit_quiet = ConvoScreen:new {
	id = "quiet",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_67", -- No more fun left. They are quiet now. Finally, quiet...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_69", "tired"}, -- Please, I implore you, give me the crystal. It's hurting you.
		{"@conversation/som_kenobi_crazed_hermit:s_70", "yell"},  -- Yes, and you will join them unless you hand over that gem!
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_quiet)

--------------------------------------------------------------------------------
-- the gentle road: tired -> hold -> sounds -> handover_free
--------------------------------------------------------------------------------

kenobi_hermit_tired = ConvoScreen:new {
	id = "tired",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_71", -- Sssh, I'm tired. Tired of it all. Please, no more. I can't take any more of this...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_72", "hold"}, -- I can help you. Just let me hold the gem for a second.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_tired)

kenobi_hermit_hold = ConvoScreen:new {
	id = "hold",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_73", -- Yes, that might be it. But no, I can't. He won't let me. He's mine and I'm his.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_74", "sounds"},       -- You don't need him anymore. You can be truly free.
		{"@conversation/som_kenobi_crazed_hermit:s_77", "kill_torment"}, -- I can stop your torment. Give me the gem and it will go away.
		{"@conversation/som_kenobi_crazed_hermit:s_75", "kill_fade"},    -- [Use the Force] But the sounds will fade. You will be in peace.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_hold)

kenobi_hermit_sounds = ConvoScreen:new {
	id = "sounds",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_78", -- But who will keep the sounds away? They hurt so much and they keep coming back. I can't do this by myself.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_79", "kill_promise"},  -- I promise they will go away when you give me the gem.
		{"@conversation/som_kenobi_crazed_hermit:s_80", "handover_free"}, -- I will help you. I will make them go away.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_sounds)

-- HANDOVER
kenobi_hermit_handover_free = ConvoScreen:new {
	id = "handover_free",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_82", -- You...you will help me? He might be telling the truth...no you say? He's lying? I don't believe you! This one is kind. He's not like the others! I will give you to him. I don't need you anymore now that I have him! < The hermit shakes as he holds out his hand and slowly lets go of the crystal shard. As soon as it touches your palm, you can feel the terror within. Whispers in your head. Screams of pain. >
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_83", "free_end"}, -- Ugh...how...how do you feel?
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_handover_free)

kenobi_hermit_free_end = ConvoScreen:new {
	id = "free_end",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_84", -- I'm free, at last. The madness is gone. I am forever in your debt, friend, but now, please leave me. I want only silence, the sweet silence.
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_free_end)

--------------------------------------------------------------------------------
-- the shouting road: yell -> killhim -> handover_trade
--------------------------------------------------------------------------------

kenobi_hermit_yell = ConvoScreen:new {
	id = "yell",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_86", -- Don't yell! I'm so tired, tired of it all. Please, just be quiet...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_87", "kill_stop"},      -- Give me the crystal and it will stop!
		{"@conversation/som_kenobi_crazed_hermit:s_88", "killhim"},        -- I will kill the one that's making the sounds. It will be over.
		{"@conversation/som_kenobi_crazed_hermit:s_89", "kill_forcestop"}, -- [Use the Force] If you give the crystal to me, it will stop.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_yell)

kenobi_hermit_killhim = ConvoScreen:new {
	id = "killhim",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_92", -- You know of him? You can make him go away? He says that he can make him go away, make the sounds stop. Yes I believe him. You've done nothing for me. But he, he can help!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_95", "kill_gem"},       -- Yes, but I need the gem to find him. Hand it to me.
		{"@conversation/som_kenobi_crazed_hermit:s_94", "handover_trade"}, -- Yes, I can find him and kill him. It will all be over.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_killhim)

-- HANDOVER
kenobi_hermit_handover_trade = ConvoScreen:new {
	id = "handover_trade",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_97", -- Finally, it will all be over. No, he can help me, I know it! You are lying. He's not like the others! He's my savior. You have done nothing for me! Here, take it. Take it now! < The hermit shakes as he holds out his hand and slowly lets go of the crystal shard. As soon as it touches your palm, you can feel the terror within. Whispers in your head. Screams of pain. >
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_crazed_hermit:s_98", "trade_end"}, -- Ugh...fin...finally, I thought you would never come to reason.
	}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_handover_trade)

kenobi_hermit_trade_end = ConvoScreen:new {
	id = "trade_end",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_99", -- It's so beautiful... Thank you, friend. Now please, please leave. I want nothing but the silence, the sweet silence.
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_trade_end)

--------------------------------------------------------------------------------
-- the six refusals. All six are on the second meeting, and only these six make
-- him hostile. Each is named for the player line that reaches it.
--------------------------------------------------------------------------------

kenobi_hermit_kill_torment = ConvoScreen:new {
	id = "kill_torment",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_85", -- Yes, yes, maybe you are right. Maybe he's right? No... NO! He's tricking you! Only I can make the sounds go away. Now kill him. Kill him!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_kill_torment)

kenobi_hermit_kill_fade = ConvoScreen:new {
	id = "kill_fade",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_76", -- But the sounds will go away. I will fin... No you won't! He's tricking you! Only I can make the sounds go away. Now kill him. Kill him!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_kill_fade)

kenobi_hermit_kill_promise = ConvoScreen:new {
	id = "kill_promise",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_81", -- You promise? Everyone keeps promising but no one tells the truth. Maybe this one is different though. Maybe he's right...no, NO! He's not right. He's trying to hurt you! Only I can make the sounds go away. You must kill him. Kill him now!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_kill_promise)

-- s_91 and not s_90 -- see CORRECTING TWO SWAPPED PAIRS.
kenobi_hermit_kill_stop = ConvoScreen:new {
	id = "kill_stop",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_91", -- It would stop? Finally be quiet? Yes! I need the silence. Please... No... NO! It's a trick. He only wants it for himself! Only I can make the sounds go away! Kill him. Kill him now!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_kill_stop)

-- s_90 and not s_91 -- see CORRECTING TWO SWAPPED PAIRS.
kenobi_hermit_kill_forcestop = ConvoScreen:new {
	id = "kill_forcestop",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_90", -- If I give you the crystal, it will finally... No it won't! He's tricking you! Only I can make the sounds go away. Now kill him. Kill him!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_kill_forcestop)

kenobi_hermit_kill_gem = ConvoScreen:new {
	id = "kill_gem",
	leftDialog = "@conversation/som_kenobi_crazed_hermit:s_96", -- Yes! No... No, you're lying. You don't know where he is! There's only one way left. Please. Kill me. Kill me now or I will kill you!
	stopConversation = "true",
	options = {}
}
som_kenobi_crazed_hermit:addScreen(kenobi_hermit_kill_gem)

addConversationTemplate("som_kenobi_crazed_hermit", som_kenobi_crazed_hermit)
