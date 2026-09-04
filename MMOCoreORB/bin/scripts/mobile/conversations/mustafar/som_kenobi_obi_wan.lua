--[[
	som_kenobi_obi_wan -- Ben Kenobi, for the whole Mustafar Kenobi arc.

	SOURCE. Two shipped conversation tables, merged into this one tree:
	  string/en/conversation/som_obi_wan_kenobi.stf   17 strings -- the prologue,
	      the two som_obi_wan_signal_* quests. Screens from it are prefixed pro_.
	  string/en/conversation/som_kenobi_obi_wan.stf  178 strings -- the spine,
	      som_kenobi_main_quest_1 through som_kenobi_main_quest_3.
	Every speaking string in both tables is used below; s_2 is empty in each and
	is skipped. The English text rides along as a trailing comment on every
	reference. %TU is SOE's own token and is left in place.

	Each half has its own live conversation script, and BOTH are the authority
	for their own screens -- som_obi_wan_kenobi for the pro_ ones, som_kenobi_obi_wan
	for the rest. The two id spaces do not collide, so merging the text is safe;
	the ids only look like one table because they are read side by side here.

	WHY ONE TREE AND NOT TWO. conversationTemplate binds per creature template,
	not per instance, so two trees would mean two Ben Kenobis standing on the
	same shore. The shipped text names exactly one place to find him -- s_266 and
	s_302, "the northeastern shoreline between the old and new mining
	facilities" -- so there is one of him, and the handler picks the root screen
	from the spine's stage.

	WHY THIS IS NOT obi_wan_ghost. object/mobile/som/obi_wan_ghost.iff already
	has a Creature bound to conversationTemplate "obi_wan_elysium", which is
	Levarris's World Beyond Worlds content. That is left exactly as it is. This
	arc gets its own additive Creature, som_kenobi_obi_wan, reusing the same
	registered appearance -- the same thing som_kenobi_moral_exec does with
	neimoidian.iff.

	WHERE THE EDGES COME FROM -- and what they used to come from.

	Both .stf files are flat lists with no parent links; SwgConversationEditor
	numbers screens in creation order. So the string table gives the text and
	says nothing about the shape. This file used to say the edges were
	"reconstructed by matching each option to the screen its wording answers",
	and that is exactly what was wrong with them.

	The edges are now taken from the live conversation itself, which states them
	outright: every screen names its options, and every option names the screen
	it leads to. 35 of the 91 screens here had at least one option in the wrong
	place and were rewritten from it. Every one of them still reads perfectly
	well the way it was -- that is the trap. A string table records an option's
	TEXT but not its POSITION, so a fluent answer is not evidence of the right
	answer. Coherence proves nothing; only the conversation says where an option
	hangs.

	The one edge live does NOT state flatly is s_97, which forks on whether the
	player spared or killed the hermit. That is why s_96 appears twice below, as
	shard_spared and shard_killed, with the handler picking between them.

	THE PROLOGUE WAS CHECKED SEPARATELY, AND WAS ALREADY RIGHT. The count above
	is the spine. The eleven pro_ screens answer to som_obi_wan_kenobi's own
	script, and every edge, terminal and action in them already matched it: s_10
	offers s_12 and s_30, s_14 offers s_16, s_18 offers s_22, s_20 offers s_24,
	s_25 offers s_27; s_26 ends on grantQuest1 and s_28 on sendSignal2; s_32,
	s_19 and s_34 end where they end. Nothing was moved. This is a checked
	absence of defects, not an unchecked half.

	Worth knowing because it read as a defect for a while: a checker pointed at
	one source reports the OTHER half's edges as having no live screen, since it
	is comparing them to a conversation they were never part of. Six edges here
	looked unmatched for exactly that reason. "Not found in the source I loaded"
	is a statement about the load, not about the edge -- the same trap as reading
	a string's absence from a reconstruction as evidence SOE never used it. A
	merged tree has to be checked against every source it names.

	THE ANIMATIONS ARE HERE, NOT IN THE HANDLER.

	Live plays 73 gestures across this conversation -- 72 hung off player answers
	and one on the opening line. 69 of them are on the screens below, in
	ConvoScreen's own "animation" (Ben's) and "playerAnimation" (the player's)
	fields, which the engine plays when it sends the screen. 57 screens carry at
	least one.

	Live keys a gesture to the ANSWER, and the field keys it to the SCREEN. Four
	screens are reached by two answers carrying different gestures, so a field on
	them could hold only one of the two -- s_188 is a nod from one answer and
	rub_chin_thoughtful from the other. Those five gestures are the only ones in
	code, in obi_wan_conv_handler's edgeAnimations table, keyed by the answer.
	The reasoning is written out there.

	The screens with no animation field have none live. They are absent, not
	defaulted.

	ON THE DUPLICATE SUBTREES. som_kenobi_obi_wan.stf carries near-identical
	twins of most of the long history -- s_178/s_204, s_182/s_208, s_188/s_214,
	s_192/s_218, s_196/s_222, s_207/s_226, s_215/s_230, s_223/s_234, and four
	copies each of the conduit briefing and the chamber directions. That is what
	the editor produces when an author duplicates a subtree under a second
	branch. They are all kept rather than collapsed, because collapsing them
	would throw away shipped text.

	WHICH TWIN HANGS OFF WHAT was also backwards here, for the same reason. The
	split is not the opening line; both openings can reach either twin. It is
	the player's SECOND answer that decides, and it splits on manners:

	  A -- the curt answers. who_b s_176 "Fine, I'm all ears", ben_b s_354
	       "Fine, what is it you need help with?"
	  B -- the courteous ones. who_a s_200 and who_b s_174 "Please explain",
	       ben_a s_202 "Of course. My apologies."

	The four conduit and chamber variants hang off the four ways the shard
	conversation can arrive.
]]

som_kenobi_obi_wan = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "obi_wan_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- PROLOGUE -- som_obi_wan_kenobi.stf. Drives som_obi_wan_signal_1 (signal
-- 'dyingMiner') and som_obi_wan_signal_2 (signal 'returnToObiWan').
--------------------------------------------------------------------------------

pro_greeting = ConvoScreen:new {
	id = "pro_greeting",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_10", -- Greetings, young Jedi. What has brought you here to this distant world?
	stopConversation = "false",
	options = {
		{"@conversation/som_obi_wan_kenobi:s_12", "pro_reflect"},   -- Master Kenobi, I didn't expect to find you here!
		{"@conversation/som_obi_wan_kenobi:s_30", "pro_adventure"}, -- I have come seeking adventure.
	}
}
som_kenobi_obi_wan:addScreen(pro_greeting)

pro_adventure = ConvoScreen:new {
	id = "pro_adventure",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_32", -- A Jedi should be seeking to offer their assistance, not adventuring for personal gain. May the Force be with you.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(pro_adventure)

pro_reflect = ConvoScreen:new {
	id = "pro_reflect",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_14", -- I come here sometimes to reflect upon the past. Terrible things happened here...
	stopConversation = "false",
	options = {
		{"@conversation/som_obi_wan_kenobi:s_16", "pro_imbalance"}, -- I know...
	}
}
som_kenobi_obi_wan:addScreen(pro_reflect)

pro_imbalance = ConvoScreen:new {
	id = "pro_imbalance",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_18", -- What happened has happened, and even I cannot change history. This planet, though, still resonates with his energy. I fear there is a great imbalance in the Force.
	stopConversation = "false",
	options = {
		{"@conversation/som_obi_wan_kenobi:s_22", "pro_task"}, -- Perhaps I could help, Master Kenobi?
	}
}
som_kenobi_obi_wan:addScreen(pro_imbalance)

-- GIVES som_obi_wan_signal_1
pro_task = ConvoScreen:new {
	id = "pro_task",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_26", -- Yes! Go seek out a dying miner who is at the new mining facility...
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(pro_task)

pro_progress = ConvoScreen:new {
	id = "pro_progress",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_19", -- I've given you your task, young Jedi.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(pro_progress)

pro_return = ConvoScreen:new {
	id = "pro_return",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_20", -- Have you done as I asked, young Jedi?
	stopConversation = "false",
	options = {
		{"@conversation/som_obi_wan_kenobi:s_24", "pro_and"}, -- Yes, I have, Master Obi-Wan.
	}
}
som_kenobi_obi_wan:addScreen(pro_return)

pro_and = ConvoScreen:new {
	id = "pro_and",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_25", -- And?
	stopConversation = "false",
	options = {
		{"@conversation/som_obi_wan_kenobi:s_27", "pro_west"}, -- The miner had been attacked with a lightsaber.
	}
}
som_kenobi_obi_wan:addScreen(pro_and)

-- COMPLETES som_obi_wan_signal_2
pro_west = ConvoScreen:new {
	id = "pro_west",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_28", -- You are positive? Then there is more afoot here than I feared. Head west to a small camp of nomads and bandits. Maybe you'll find a clue there.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(pro_west)

pro_nothing = ConvoScreen:new {
	id = "pro_nothing",
	leftDialog = "@conversation/som_obi_wan_kenobi:s_34", -- I have nothing more for you at this time.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(pro_nothing)

--------------------------------------------------------------------------------
-- SPINE, first contact -- som_kenobi_obi_wan.stf
--------------------------------------------------------------------------------

greeting = ConvoScreen:new {
	id = "greeting",
	animation = "point_forward",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_106", -- I am in dire need of your assistance, %TU. I've been watching you for some time, hoping that you would be the one I could entrust with this difficult task.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_121", "who_a"}, -- What...who are you?
		{"@conversation/som_kenobi_obi_wan:s_152", "who_b"}, -- Interesting. Who, or maybe I should say what, are you?
	}
}
som_kenobi_obi_wan:addScreen(greeting)

who_a = ConvoScreen:new {
	id = "who_a",
	playerAnimation = "taken_aback",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_123", -- Who I am is not of any importance. What I need help with, on the other hand, may affect the future of the entire galaxy.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_198", "ben_a"}, -- Then, what would I call you?
		{"@conversation/som_kenobi_obi_wan:s_199", "ben_b"}, -- I like to know who I'm doing favors for.
		{"@conversation/som_kenobi_obi_wan:s_200", "hist_b"}, -- Please explain.
	}
}
som_kenobi_obi_wan:addScreen(who_a)

who_b = ConvoScreen:new {
	id = "who_b",
	animation = "shake_head_no",
	playerAnimation = "rub_chin_thoughtful",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_161", -- Who I am is not of any importance. What I need help with, on the other hand, may affect the future of the entire galaxy.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_174", "hist_b"}, -- Please explain.
		{"@conversation/som_kenobi_obi_wan:s_176", "hist_a"}, -- Fine, I'm all ears.
		{"@conversation/som_kenobi_obi_wan:s_346", "ben_b"}, -- I like to know who I'm doing favors for.
	}
}
som_kenobi_obi_wan:addScreen(who_b)

ben_a = ConvoScreen:new {
	id = "ben_a",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_201", -- You can call me Ben. Now let me continue, please.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_202", "hist_b"}, -- Of course. My apologies.
	}
}
som_kenobi_obi_wan:addScreen(ben_a)

ben_b = ConvoScreen:new {
	id = "ben_b",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_348", -- I just told you, the entire galaxy. Very well, you can call me Ben. Now can I go on?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_354", "hist_a"}, -- Fine, what is it you need help with?
	}
}
som_kenobi_obi_wan:addScreen(ben_b)

--------------------------------------------------------------------------------
-- HISTORY, variant A -- reached by the curt answer (s_176 / s_354)
--------------------------------------------------------------------------------

hist_a = ConvoScreen:new {
	id = "hist_a",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_178", -- I'm not sure how much of this planet's history you have uncovered, but I'll tell you what I know. Thousands of years ago, long before my time, there was a large chapter of Jedi Knights located here. The planet was a center of Jedi information and artifacts, which attracted the vicious Sith.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_180", "hist_a_sith"}, -- The Sith?
		{"@conversation/som_kenobi_obi_wan:s_186", "hist_a_crystal"}, -- As I suspected.
	}
}
som_kenobi_obi_wan:addScreen(hist_a)

hist_a_sith = ConvoScreen:new {
	id = "hist_a_sith",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_182", -- The Sith were an ancient race that, for the lack of a better term, were pure evil. Their leaders were great wielders of the Force, but they didn't wield it for great things. They became a danger to the rest of the galaxy when their powers corrupted Jedi that came to their planet.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_184", "hist_a_crystal"}, -- Hmm, alright, carry on.
	}
}
som_kenobi_obi_wan:addScreen(hist_a_sith)

hist_a_crystal = ConvoScreen:new {
	id = "hist_a_crystal",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_188", -- The Jedi on Mustafar uncovered a magnificent crystal of unknown origin. It was as tall as a tower, and the Jedi quickly discovered that it was attuned to the Force within them. When news of an impending Sith invasion reached them, they desperately began to experiment with the crystal, hoping to find a way to use it in their defense.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_190", "hist_a_channel"}, -- I can see where this is heading.
	}
}
som_kenobi_obi_wan:addScreen(hist_a_crystal)

hist_a_channel = ConvoScreen:new {
	id = "hist_a_channel",
	animation = "nod_head_once",
	playerAnimation = "nod",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_192", -- Yes, I'm sure you can piece it together by now, but let me go on. The Jedi believed they could channel their powers through the crystal and dampen the Sith's powers while strengthening their own. As the Sith warships pierced the atmosphere, the Jedi Masters began channeling the Force through the crystal while the younger Jedi led the troops in battle.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_194", "hist_a_crack"}, -- But everything didn't go as they planned, did it?
	}
}
som_kenobi_obi_wan:addScreen(hist_a_channel)

hist_a_crack = ConvoScreen:new {
	id = "hist_a_crack",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_196", -- Indeed it didn't. At first, it worked perfectly. The Sith could barely use their powers at all while the young Jedi in the field could wield more power than ever. But they hadn't had time to do enough research on the crystal and its limits, and as the battle went on, it began to crack. Close to victory, the Jedi could have stopped using it and would have still won the battle.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_203", "hist_a_boom"}, -- But they didn't?
	}
}
som_kenobi_obi_wan:addScreen(hist_a_crack)

hist_a_boom = ConvoScreen:new {
	id = "hist_a_boom",
	animation = "shake_head_no",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_207", -- No, and I'm not sure why. Some believe that the Sith Lord, facing certain defeat, somehow corrupted the vulnerable Jedi Masters as they were channeling. The result was catastrophic. When the crystal exploded, it sent the planet itself out of its orbit and wiped out all of the Sith and Jedi. All but one, that is.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_211", "hist_a_krow"}, -- Who?
		{"@conversation/som_kenobi_obi_wan:s_311", "hist_b_assume"}, -- The Sith Lord I assume?
	}
}
som_kenobi_obi_wan:addScreen(hist_a_boom)

hist_a_vanquished = ConvoScreen:new {
	id = "hist_a_vanquished",
	animation = "shake_head_no",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_274", -- No, thankfully they weren't. All records point to the Sith Lord being vanquished.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_276", "hist_b_krow"}, -- Good. So who did survive?
	}
}
som_kenobi_obi_wan:addScreen(hist_a_vanquished)

hist_a_krow = ConvoScreen:new {
	id = "hist_a_krow",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_215", -- The elder of the masters, Erg Krow. As the crystal exploded, he managed to shield himself from some of the destruction. Clinging onto life, he found a large shard of the crystal in front of the dead masters.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_219", "hist_a_shield"}, -- Very interesting.
	}
}
som_kenobi_obi_wan:addScreen(hist_a_krow)

hist_a_shield = ConvoScreen:new {
	id = "hist_a_shield",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_223", -- Sensing that this large shard still had tremendous power, he dragged it with him into hiding. He then spent his remaining energy using the Force to put a protective shield around it, to make sure that no other Force wielder could sense its presence. Unfortunately, Krow, dying from his injuries, wasn't as strong as he had once been, and the power of his shield has diminished after several thousand years.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_229", "hist_b_unprotected"}, -- You mean that we can find it now?
	}
}
som_kenobi_obi_wan:addScreen(hist_a_shield)

hist_a_unprotected = ConvoScreen:new {
	id = "hist_a_unprotected",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_238", -- I already have, but the forces of evil are swiftly closing in to claim it. You have seen some of them yourself. That is why we must act quickly, %TU. We can't let it fall into their hands.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_240", "cheat_state"}, -- Most definitely not. So why haven't you taken it?
	}
}
som_kenobi_obi_wan:addScreen(hist_a_unprotected)

cheat_simple = ConvoScreen:new {
	id = "cheat_simple",
	animation = "shake_head_no",
	playerAnimation = "nod_head_multiple",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_243", -- I wish it was that simple. Even though the shielding is all but gone, Krow made sure that it wouldn't be easy to gain access. He made the entrance only passable by someone with great Force powers, and since you don't have that, we have to cheat.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_247", "key_b"}, -- Sounds good. What's the plan?
	}
}
som_kenobi_obi_wan:addScreen(cheat_simple)

key_a = ConvoScreen:new {
	id = "key_a",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_246", -- There's a shard of the crystal that has an unusually active soul of a Jedi trapped inside it. I'm fairly certain that we can use that shard as a key to gain entrance to Krow's chamber.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_248", "horrible"}, -- A soul trapped inside? That's horrible.
	}
}
som_kenobi_obi_wan:addScreen(key_a)

horrible = ConvoScreen:new {
	id = "horrible",
	animation = "nod_head_once",
	playerAnimation = "shrug_hands",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_250", -- I agree, but that's a problem that will have to wait.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_252", "destroy"}, -- Understood. So where do we take the shard if we get it?
	}
}
som_kenobi_obi_wan:addScreen(horrible)

--------------------------------------------------------------------------------
-- HISTORY, variant B -- reached by the courteous answer (s_200 / s_174 / s_202)
--------------------------------------------------------------------------------

hist_b = ConvoScreen:new {
	id = "hist_b",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_204", -- I'm not sure how much of this planet's history you have uncovered, but I'll tell you what I know. Thousands of years ago, long before my time, there was a large chapter of Jedi Knights located here. The planet was a center of Jedi information and artifacts, which attracted the vicious Sith.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_206", "hist_b_sith"}, -- Who are the Sith?
		{"@conversation/som_kenobi_obi_wan:s_212", "hist_b_crystal"}, -- Yes, I've learned some of this, but please continue.
	}
}
som_kenobi_obi_wan:addScreen(hist_b)

hist_b_sith = ConvoScreen:new {
	id = "hist_b_sith",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_208", -- The Sith were an ancient race that, for the lack of a better term, were pure evil. Their leaders were great wielders of the Force; but they didn't wield it for great things. They became a danger to the rest of the galaxy when their powers corrupted Jedi that came to their planet.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_210", "hist_b_crystal"}, -- I understand.
	}
}
som_kenobi_obi_wan:addScreen(hist_b_sith)

hist_b_crystal = ConvoScreen:new {
	id = "hist_b_crystal",
	playerAnimation = "nod",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_214", -- The Jedi on Mustafar uncovered a magnificent crystal of unknown origin. It was as tall as a tower, and the Jedi quickly discovered that it was attuned to the Force within them. When news of an impending Sith invasion reached them, they desperately began to experiment with the crystal, hoping to find a way to use it in their defense.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_216", "hist_b_channel"}, -- I'm assuming things didn't go according to plans..?
	}
}
som_kenobi_obi_wan:addScreen(hist_b_crystal)

hist_b_channel = ConvoScreen:new {
	id = "hist_b_channel",
	animation = "nod_head_once",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_218", -- You are correct, my friend. The Jedi believed they could channel their powers through the crystal and dampen the Sith's powers while strengthening their own. As the Sith warships pierced the atmosphere, the Jedi Masters began channeling the Force through the crystal while the younger Jedi led the troops in battle.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_220", "hist_b_crack"}, -- What happened?
	}
}
som_kenobi_obi_wan:addScreen(hist_b_channel)

hist_b_crack = ConvoScreen:new {
	id = "hist_b_crack",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_222", -- At first, it worked perfectly. The Sith could barely use their powers at all, while the young Jedi in the field could wield more power than ever. But they hadn't had time to do enough research on the crystal and its limits, and as the battle went on, it began to crack. Close to victory, the Jedi could have stopped using it and would have still won the battle.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_224", "hist_b_boom"}, -- Why didn't they? Jedi are quite wise from what I know.
	}
}
som_kenobi_obi_wan:addScreen(hist_b_crack)

hist_b_boom = ConvoScreen:new {
	id = "hist_b_boom",
	animation = "nod_head_once",
	playerAnimation = "shrug_hands",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_226", -- But they have their flaws like everyone else. Some believe that the Sith Lord, facing certain defeat, somehow corrupted the vulnerable Jedi Masters as they were channeling. The result was catastrophic. When the crystal exploded, it sent the planet itself out of its orbit and wiped out all of the Sith and Jedi. All but one, that is.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_228", "hist_b_krow"}, -- Who could possibly have survived that?
		{"@conversation/som_kenobi_obi_wan:s_272", "hist_a_vanquished"}, -- They couldn't have been unfortunate enough that the Sith Lord survived?
	}
}
som_kenobi_obi_wan:addScreen(hist_b_boom)

hist_b_assume = ConvoScreen:new {
	id = "hist_b_assume",
	animation = "rub_chin_thoughtful",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_323", -- No...why would you assume that?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_327", "hist_b_weak"}, -- Well, he must have been very powerful...corrupting the Jedi Masters.
	}
}
som_kenobi_obi_wan:addScreen(hist_b_assume)

hist_b_weak = ConvoScreen:new {
	id = "hist_b_weak",
	animation = "nod_head_once",
	playerAnimation = "shrug_hands",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_331", -- True, but when it comes to preserving life, the dark side of the Force will always be weak.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_344", "hist_a_krow"}, -- Well, I wouldn't know. So who survived then?
	}
}
som_kenobi_obi_wan:addScreen(hist_b_weak)

hist_b_krow = ConvoScreen:new {
	id = "hist_b_krow",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_230", -- The elder of the masters, Erg Krow. As the crystal exploded, he managed to shield himself from some of the destruction. Clinging onto life, he found a large shard of the crystal in front of the dead masters.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_232", "hist_b_shield"}, -- Amazing. What did he do?
	}
}
som_kenobi_obi_wan:addScreen(hist_b_krow)

hist_b_shield = ConvoScreen:new {
	id = "hist_b_shield",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_234", -- Sensing that this large shard still had tremendous power, he dragged it with him into hiding. He then spent his remaining energy using the Force to put a protective shield around it, to make sure that no other Force wielder could sense its presence. Unfortunately, Krow, dying from his injuries, wasn't as strong as he had once been, and the power of his shield has diminished after several thousand years.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_236", "hist_a_unprotected"}, -- Then it is now unprotected and it's possible to find it?
	}
}
som_kenobi_obi_wan:addScreen(hist_b_shield)

hist_b_unprotected = ConvoScreen:new {
	id = "hist_b_unprotected",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_235", -- I already have, but the forces of evil are swiftly closing in to claim it. You have seen some of them yourself. That is why we must act quickly, %TU. We can't let it fall into their hands.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_239", "cheat_simple"}, -- I agree. So where is it? Let's go get it right away.
	}
}
som_kenobi_obi_wan:addScreen(hist_b_unprotected)

cheat_state = ConvoScreen:new {
	id = "cheat_state",
	animation = "shake_head_no",
	playerAnimation = "rub_chin_thoughtful",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_242", -- In my state, I can't, which is why I need you. I wish it were as easy as us just going there right now and getting it, but there are some problems. Even though the shielding is all but gone, Krow made sure that it wouldn't be easy to gain access. He made the entrance only passable by someone with great Force powers and since you don't have that, we have to cheat.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_244", "key_a"}, -- Cheat how?
	}
}
som_kenobi_obi_wan:addScreen(cheat_state)

key_b = ConvoScreen:new {
	id = "key_b",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_251", -- There's a shard of the crystal that has an unusually active soul of a Jedi trapped inside it. I'm fairly certain that we can use that shard as a key to gain entrance to Krow's chamber.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_255", "mycrystal"}, -- Fairly certain? What if it doesn't work and someone takes my crystal?
	}
}
som_kenobi_obi_wan:addScreen(key_b)

destroy = ConvoScreen:new {
	id = "destroy",
	playerAnimation = "nod",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_254", -- Nowhere. We will destroy it, which is what Krow should have done in the first place. I think that some of the Sith's taint had touched him and that's why he couldn't. The crystal is much too powerful to be entrusted to anyone. No one is immune to the corruption of the Dark Side. Trust me.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_256", "hermit_a"}, -- I agree. So where do we find the 'key'?
	}
}
som_kenobi_obi_wan:addScreen(destroy)

mycrystal = ConvoScreen:new {
	id = "mycrystal",
	playerAnimation = "shrug_hands",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_259", -- Your crystal? We are not going there to take it. We are going to destroy it.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_263", "why_destroy"}, -- Why?!
	}
}
som_kenobi_obi_wan:addScreen(mycrystal)

why_destroy = ConvoScreen:new {
	id = "why_destroy",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_271", -- That is what Krow should have done in the first place. I think that some of the Sith's taint had touched him and that's why he couldn't. The crystal is much too powerful to be entrusted to anyone. No one is immune to the corruption of the Dark Side. Trust me.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_278", "hermit_b"}, -- But... Fine. So where do we find the 'key'?
	}
}
som_kenobi_obi_wan:addScreen(why_destroy)

--------------------------------------------------------------------------------
-- THE HERMIT HUNT. Both variants end on a farewell that gives
-- som_kenobi_main_quest_1. s_266 and s_302 are where the arc says he waits:
-- "the northeastern shoreline between the old and new mining facilities".
--------------------------------------------------------------------------------

hermit_a = ConvoScreen:new {
	id = "hermit_a",
	playerAnimation = "rub_chin_thoughtful",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_258", -- That is the tricky part. It's currently in the possession of a crazed Mustafarian. I'm not sure what's driven him to insanity, but he's become a hermit, wandering the scorched lands erratically...making him hard to track, even for me. You need to find him.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_260", "droids_a"}, -- That will be difficult. He could be anywhere.
	}
}
som_kenobi_obi_wan:addScreen(hermit_a)

droids_a = ConvoScreen:new {
	id = "droids_a",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_262", -- Yes, but I've thought of something that might help. The Mustafarian survey droids scour the planet constantly trying to find new resources. If you can gain access to their computer network, you might be able to find an approximate location of where the hermit was spotted last.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_264", "shore_a"}, -- Will the Mustafarians assist me?
	}
}
som_kenobi_obi_wan:addScreen(droids_a)

shore_a = ConvoScreen:new {
	id = "shore_a",
	animation = "shake_head_no",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_266", -- That is unlikely. They are mostly interested in profit and would probably shrug you off as a lunatic if you tried to explain to them. You will have to find another way. I'm afraid I have urgent matters to take care of, but I will see you again, %TU. Please be swift in solving this. We are rapidly running out of time. If you need my assistance, go to the northeastern shoreline between the old and new mining facilities and I will try to answer your call.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_268", "give_quest_a"}, -- I will do my best. You be careful.
	}
}
som_kenobi_obi_wan:addScreen(shore_a)

-- GIVES som_kenobi_main_quest_1
give_quest_a = ConvoScreen:new {
	id = "give_quest_a",
	animation = "laugh_cackle",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_270", -- Oh, this old man will be fine. You just worry about yourself, my friend. May the Force be with you, %TU.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(give_quest_a)

hermit_b = ConvoScreen:new {
	id = "hermit_b",
	playerAnimation = "sigh_deeply",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_282", -- That is the tricky part. It's currently in the possession of a crazed Mustafarian. I'm not sure what's driven him to insanity, but he's become a hermit, wandering the scorched lands erratically...making him hard to track, even for me. You need to find him.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_290", "droids_b"}, -- How? Just start running around hoping I bump in to him?
	}
}
som_kenobi_obi_wan:addScreen(hermit_b)

droids_b = ConvoScreen:new {
	id = "droids_b",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_294", -- Amusing, but no. I have a plan. The Mustafarian survey droids scour the planet constantly, trying to find new resources. If you can gain access to their computer network, you might be able to find an approximate location of where the hermit was spotted last.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_298", "shore_b"}, -- I don't think the Mustafarians will let me use their network.
	}
}
som_kenobi_obi_wan:addScreen(droids_b)

shore_b = ConvoScreen:new {
	id = "shore_b",
	animation = "shake_head_no",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_302", -- Probably not, but I'm sure you can find a way. Now, I have urgent matters to take care of. I will see you again, %TU. Please be swift in solving this. We are rapidly running out of time. If you need my assistance, go to northeastern shoreline between the old and new mining facilities and I will try to answer your call.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_306", "give_quest_b"}, -- What could possibly be more important than helping with this?
	}
}
som_kenobi_obi_wan:addScreen(shore_b)

-- GIVES som_kenobi_main_quest_1
give_quest_b = ConvoScreen:new {
	id = "give_quest_b",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_309", -- The forces of evil are marching rapidly, %TU, and this old man needs to put a wrench in their cogs before it's too late. Farewell, for now.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(give_quest_b)

--------------------------------------------------------------------------------
-- WHILE THE HERMIT HUNT IS RUNNING. Two ways off s_227: take your leave, or say
-- you have lost the trail and be sent back to the Mensix network.
--
-- TWO OPTIONS WERE ON THE WRONG SCREENS, AND THE STRING TABLE IS WHY.
--
-- s_306 used to hang here and s_349 used to hang on shore_b. It is the other way
-- round: s_306 is shore_b's only option and s_349 is this screen's first. Both
-- pairings read perfectly well, which is exactly the trap --
--
--   s_302 "I have urgent matters to take care of" -> s_306 "What could possibly
--   be more important?" -> s_309 "The forces of evil are marching rapidly"
--   s_227 "I can't assist you further right now" -> s_349 "Alright. I will do
--   as you have asked." -> s_351 "Thank you. The fate of galaxy rests in your
--   hands."
--
-- and so does the swap. The reconstruction matched options to screens by reading
-- the string table, and a string table records an option's TEXT but not its
-- POSITION. Coherence is not evidence; only the conversation says where an
-- option hangs. Same defect class as the two already found in the sucker.
--
-- What it cost: the b-variant handed the quest over on s_351, which gives
-- nothing, while s_309 -- the screen that actually gives it -- fired nothing at
-- all. So give_quest_b is now s_309, and s_351 is the plain farewell below.
--------------------------------------------------------------------------------

busy = ConvoScreen:new {
	id = "busy",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_227", -- I can't assist you any further right now, %TU. I have things that have to be done if we are to succeed.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_349", "will_do"},   -- Alright. I will do as you have asked.
		{"@conversation/som_kenobi_obi_wan:s_350", "research"},  -- I have lost the hermit.
	}
}
som_kenobi_obi_wan:addScreen(busy)

-- s_349 is ungated; s_350 is shown only while the hunt is running. The handler
-- serves this screen at STAGE_HUNT and nowhere else, so both are always up.
will_do = ConvoScreen:new {
	id = "will_do",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_351", -- Thank you. The fate of galaxy rests in your hands.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(will_do)

-- RE-ARMS the hermit search
research = ConvoScreen:new {
	id = "research",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_352", -- Very well, you will have to perform another search for him using the miner's network. Return to the Mensix Mining Facility and perform another search for the hermit. Good luck to you.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(research)

aside = ConvoScreen:new {
	id = "aside",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_356", -- My business is not with you, %TU. Please step aside.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(aside)

--------------------------------------------------------------------------------
-- BACK WITH THE SHARD. som_kenobi_main_quest_1 forked here: task 17 grants
-- som_kenobi_main_quest_spared, task 22 grants som_kenobi_main_quest_killed.
-- The fork is visible in the shipped text -- s_99 says "the poor Mustafarian
-- you saved", s_103 says "I wish you hadn't killed the Mustafarian" -- so the
-- handler picks the root by which quest the player is carrying. Both roots
-- reuse s_96/s_97 because SOE wrote only one of each.
--------------------------------------------------------------------------------

shard_spared = ConvoScreen:new {
	id = "shard_spared",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_96", -- Good, you have the key. We are ready to proceed, %TU.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_97", "spared_soul"}, -- Good, this thing is strange. I don't like it at all.
	}
}
som_kenobi_obi_wan:addScreen(shard_spared)

spared_soul = ConvoScreen:new {
	id = "spared_soul",
	animation = "nod_head_once",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_99", -- Yes, the Jedi trapped within is clearly in great pain and he must have been what drove the poor Mustafarian you saved insane. I will try to come up with a way to help free him later, but right now we have more pressing matters.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_159", "urgency_d"}, -- Yes, I would like to get rid of this crystal sooner rather than later.
		{"@conversation/som_kenobi_obi_wan:s_160", "urgency_c"}, -- Yes, he can wait. What's the next step?
	}
}
som_kenobi_obi_wan:addScreen(spared_soul)

shard_killed = ConvoScreen:new {
	id = "shard_killed",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_96", -- Good, you have the key. We are ready to proceed, %TU.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_97", "killed_soul"}, -- Good, this thing is strange. I don't like it at all.
	}
}
som_kenobi_obi_wan:addScreen(shard_killed)

-- NO NPC GESTURE, and that is live's asymmetry, not an omission here.  s_97 is
-- one option with two replies: finishedQuestSpared answers s_99 with a nod, and
-- finishedQuestKilled answers s_103 with nothing.  Only the player's twitch,
-- which fires on picking the option, is common to both.  The nod that used to
-- sit here was copied off spared_soul, its twin.  The animation checker could
-- not see it because it collected every gesture under a response together
-- instead of keying each one to the reply it belongs to.
killed_soul = ConvoScreen:new {
	id = "killed_soul",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_103", -- Yes, the Jedi trapped within is clearly in great pain and he must have been what drove the poor Mustafarian insane. I will try to come up with a way to help free him later, but right now, we have more pressing matters. I wish you hadn't killed the Mustafarian, though. He was as much a victim as the Jedi in the crystal and if he had been spared, he could have been a help in saving the Jedi...
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_104", "compassion"}, -- I had no choice but to put the crazy fool out of his misery.
		{"@conversation/som_kenobi_obi_wan:s_105", "violence"}, -- I was trying to avoid it, but I couldn't save him.
	}
}
som_kenobi_obi_wan:addScreen(killed_soul)

violence = ConvoScreen:new {
	id = "violence",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_114", -- I understand. Sometimes violence is the only outcome, my friend. At least you did your best. Now, let's focus on the task at hand.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_115", "urgency_b"}, -- Yes, I would like to get rid of this crystal sooner rather than later.
	}
}
som_kenobi_obi_wan:addScreen(violence)

compassion = ConvoScreen:new {
	id = "compassion",
	animation = "shake_head_no",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_107", -- There's almost always another way, %TU. You have to be more compassionate. All that anger can only cause you pain.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_108", "urgency_a"}, -- I've done alright so far. Now what is the next step?
	}
}
som_kenobi_obi_wan:addScreen(compassion)

--------------------------------------------------------------------------------
-- THE FOUR URGENCY SCREENS. Near-identical shipped twins, one per way in.
--------------------------------------------------------------------------------

urgency_a = ConvoScreen:new {
	id = "urgency_a",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_109", -- We are rapidly running out of time. A great evil has arrived and it's quickly making its way over to the chamber. Not only that, but your actions have drawn the attention of its minions and I fear that they are closing in on you as we speak.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_110", "conduits_a"}, -- Then why are we standing around here? What's the next step?
	}
}
som_kenobi_obi_wan:addScreen(urgency_a)

urgency_b = ConvoScreen:new {
	id = "urgency_b",
	playerAnimation = "nod",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_116", -- Yes, time is against us, in more ways than one. A great evil has arrived and it's quickly making its way over to the chamber. Not only that, but your actions have drawn the attention of its minions and I fear that they are closing in on you as we speak.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_117", "conduits_b"}, -- I will be as fast as I can. What do I do next?
	}
}
som_kenobi_obi_wan:addScreen(urgency_b)

urgency_c = ConvoScreen:new {
	id = "urgency_c",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_314", -- We are rapidly running out of time. A great evil has arrived and it's quickly making its way over to the chamber. Not only that, but your actions have drawn the attention of its minions and I fear that they are closing in on you as we speak.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_316", "conduits_c"}, -- Then why are we standing around here? What's the next step?
	}
}
som_kenobi_obi_wan:addScreen(urgency_c)

urgency_d = ConvoScreen:new {
	id = "urgency_d",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_328", -- Yes, time is against us, in more ways than one. A great evil has arrived and it's quickly making its way over to the chamber. Not only that, but your actions have drawn the attention of its minions, and I fear that they are closing in on you as we speak.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_330", "conduits_d"}, -- I will be as fast as I can. What do I do next?
	}
}
som_kenobi_obi_wan:addScreen(urgency_d)

--------------------------------------------------------------------------------
-- THE CONDUIT BRIEFING. s_156/s_158/s_322/s_336 name the three enclaves --
-- northwest corner, just west of the central volcano, and straight east of the
-- same volcano on the edge of the continent. Those three directions match the
-- three som_kenobi_jedi_conduit_* nodes in the mustafar snapshot exactly:
--   _nw  node 12112107  (-5302.96, 6010.56)  northwest corner
--   _w   node 12112110  (-4467.51, 3206.98)  west of the volcano
--   _e   node 12110936  (  206.66, 4126.13)  east edge of the continent
--------------------------------------------------------------------------------

conduits_a = ConvoScreen:new {
	id = "conduits_a",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_150", -- It's dangerous, but we need to forge a stronger bond between you and the crystal. That would probably happen over time if you kept it, but we can't wait. On this planet, there are three old enclaves, remains of the Jedi temples. At each of these, there is a conduit that was used to link the enclaves together.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_155", "dir_a"}, -- I thought we were in a hurry? Get to the point.
	}
}
som_kenobi_obi_wan:addScreen(conduits_a)

conduits_b = ConvoScreen:new {
	id = "conduits_b",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_154", -- It's dangerous, but we need to forge a stronger bond between you and the crystal. That would probably happen over time if you kept it, but we can't wait. On this planet, there are three old enclaves, remains of the Jedi temples. At each of these, there is a conduit that was used to link the enclaves together.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_157", "dir_b"}, -- I'm not sure I like this...
	}
}
som_kenobi_obi_wan:addScreen(conduits_b)

conduits_c = ConvoScreen:new {
	id = "conduits_c",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_318", -- It's dangerous, but we need to forge a stronger bond between you and the crystal. That would probably happen over time if you kept it, but we can't wait. On this planet, there are three old enclaves, remains of the Jedi temples. At each of these there is a conduit that was used to link the enclaves together.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_320", "dir_c"}, -- I thought we were in a hurry? Get to the point.
	}
}
som_kenobi_obi_wan:addScreen(conduits_c)

conduits_d = ConvoScreen:new {
	id = "conduits_d",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_332", -- It's dangerous, but we need to forge a stronger bond between you and the crystal. That would probably happen over time if you kept it, but we can't wait. On this planet, there are three old enclaves, remains of the Jedi temples. At each of these, there is a conduit that was used to link the enclaves together.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_334", "dir_d"}, -- I'm not sure I like this...
	}
}
som_kenobi_obi_wan:addScreen(conduits_d)

dir_a = ConvoScreen:new {
	id = "dir_a",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_156", -- Patience, %TU. I'm getting there. You will have to go to each of these three conduits, wedge the crystal into it and wait while the power channels through it. The first enclave is located in the northwest corner of the continent. The second is just west of the central volcano and the final one is straight east of the same volcano, all the way on the edge of the continent.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_288", "send_b"}, -- Alright, enough chatting. I'm on my way!
	}
}
som_kenobi_obi_wan:addScreen(dir_a)

dir_b = ConvoScreen:new {
	id = "dir_b",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_158", -- I know, my friend, but we have no choice. You will have to go to each of these three conduits, wedge the crystal into it, and wait while the power channels through it. The first enclave is located in the northwest corner of the continent. The second is just west of the central volcano and the final one is straight east of the same volcano, all the way on the edge of the continent.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_286", "send_a"}, -- Very well, I will be on my way immediately.
	}
}
som_kenobi_obi_wan:addScreen(dir_b)

dir_c = ConvoScreen:new {
	id = "dir_c",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_322", -- Patience, %TU. I'm getting there. You will have to go to each of these three conduits, wedge the crystal into it, and wait while the power channels through it. The first enclave is located in the northwest corner of the continent. The second is just west of the central volcano and the final one is straight east of the same volcano, all the way on the edge of the continent.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_324", "send_c"}, -- Alright, enough chatting. I'm on my way!
	}
}
som_kenobi_obi_wan:addScreen(dir_c)

dir_d = ConvoScreen:new {
	id = "dir_d",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_336", -- I know, my friend, but we have no choice. You will have to go to each of these three conduits, wedge the crystal into it, and wait while the power channels through it. The first enclave is located in the northwest corner of the continent. The second is just west of the central volcano and the final one is straight east of the same volcano, all the way on the edge of the continent.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_338", "send_d"}, -- Very well, I will be on my way immediately.
	}
}
som_kenobi_obi_wan:addScreen(dir_d)

-- The four send-offs. All of them fire 'talkedKenobi1', which is task 0 of
-- som_kenobi_main_quest_spared and som_kenobi_main_quest_killed.
send_a = ConvoScreen:new {
	id = "send_a",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_287", -- Be very careful, my friend. These are dangerous times indeed. May the Force be with you, %TU!
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(send_a)

send_b = ConvoScreen:new {
	id = "send_b",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_289", -- Very well. Stay on your guard, %TU. Danger is everywhere now. May the Force be with you!
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(send_b)

send_c = ConvoScreen:new {
	id = "send_c",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_326", -- Very well. Stay on your guard, %TU. Danger is everywhere now. May the Force be with you!
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(send_c)

send_d = ConvoScreen:new {
	id = "send_d",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_340", -- Be very careful, my friend. These are dangerous times indeed. May the Force be with you, %TU!
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(send_d)

--------------------------------------------------------------------------------
-- ALL THREE CONDUITS CHARGED. som_kenobi_main_quest_3 task 14 watches
-- conduit1/2/3 and then waits on 'talkedKenobi2'. The directions here --
-- "North of the central volcano is what's called the Burning Plains. In the
-- northeast corner of the plains, you will find the entrance to the chamber" --
-- point at snapshot node 12112106, obiwan_finale_entrance_stone, at
-- (-2693.52, 6075.59). The .qst's own Go-to-Location for the same step is
-- (-2694, 42, 6077), one metre away.
--------------------------------------------------------------------------------

chamber_a = ConvoScreen:new {
	id = "chamber_a",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_233", -- Everything is set, %TU. It is time to end this. You must quickly head to the hidden chamber, before it's too late.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_265", "where_a"}, -- How do I get there?
		{"@conversation/som_kenobi_obi_wan:s_279", "where_b"}, -- Where is it?
	}
}
som_kenobi_obi_wan:addScreen(chamber_a)

chamber_b = ConvoScreen:new {
	id = "chamber_b",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_291", -- Everything is set, %TU. Now you need to make it to the hidden chamber quickly.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_293", "where_c"}, -- How do I get there?
		{"@conversation/som_kenobi_obi_wan:s_301", "where_d"}, -- Where is it?
	}
}
som_kenobi_obi_wan:addScreen(chamber_b)

where_a = ConvoScreen:new {
	id = "where_a",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_269", -- North of the central volcano is what's called the Burning Plains. In the northeast corner of the plains, you will find the entrance to the chamber. I can't come with you, but will meet you there. The minions of the dark are closing in on you. I will have to try and throw them off track.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_273", "goluck_a"}, -- Thank you. I will make my way over there as fast as I can!
	}
}
som_kenobi_obi_wan:addScreen(where_a)

where_b = ConvoScreen:new {
	id = "where_b",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_281", -- North of the central volcano is what's called the Burning Plains. In the northeast corner of the plains, you will find the entrance to the chamber. I can't come with you, but will meet you there. The minions of the dark are closing in on you. I will have to try and throw them off track.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_283", "goluck_b"}, -- Don't worry. I won't let them get the crystal.
	}
}
som_kenobi_obi_wan:addScreen(where_b)

where_c = ConvoScreen:new {
	id = "where_c",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_295", -- North of the central volcano is what's called the Burning Plains. In the northeast corner of the plains, you will find the entrance to the chamber. I can't come with you, but will meet you there. The minions of the dark are closing in on you. I will have to try and throw them off track.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_297", "goluck_c"}, -- Thank you. I will make my way over there as fast as I can!
	}
}
som_kenobi_obi_wan:addScreen(where_c)

where_d = ConvoScreen:new {
	id = "where_d",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_303", -- North of the central volcano is what's called the Burning Plains. In the northeast corner of the plains, you will find the entrance to the chamber. I can't come with you, but will meet you there. The minions of the dark are closing in on you. I will have to try and throw them off track.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_305", "goluck_d"}, -- Don't worry, I won't let them get the crystal.
	}
}
som_kenobi_obi_wan:addScreen(where_d)

-- All four fire 'talkedKenobi2' and hand over the waypoint to the entrance.
goluck_a = ConvoScreen:new {
	id = "goluck_a",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_277", -- Good luck, my friend, and may the Force be with you. You will need it.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(goluck_a)

goluck_b = ConvoScreen:new {
	id = "goluck_b",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_285", -- I hope you are right. May the Force be with you, %TU. You will need it.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(goluck_b)

goluck_c = ConvoScreen:new {
	id = "goluck_c",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_299", -- Good luck, my friend and may the Force be with you. You will need it.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(goluck_c)

goluck_d = ConvoScreen:new {
	id = "goluck_d",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_307", -- I hope you are right. May the Force be with you, %TU. You will need it.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(goluck_d)

--------------------------------------------------------------------------------
-- AT THE ENTRANCE STONE. som_kenobi_main_quest_3 task 6 waits on
-- 'talkedKenobi3', then task 15 is the boss kill. s_167 and s_168 are the
-- shipped instruction to wedge the shard into the pillar and transfer inside,
-- which is what the lair_of_the_crystal instance door does.
--------------------------------------------------------------------------------

chamber_meet = ConvoScreen:new {
	id = "chamber_meet",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_162", -- I'm glad to see you made it, %TU. Let me explain how to do this.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_163", "toomany"},   -- What happened to you slowing down these guys?!
		{"@conversation/som_kenobi_obi_wan:s_164", "breakdown"}, -- Please... I... I can't take much more of this...
	}
}
som_kenobi_obi_wan:addScreen(chamber_meet)

toomany = ConvoScreen:new {
	id = "toomany",
	playerAnimation = "point_accusingly",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_165", -- There's too many of them and they are closing in too fast! We have to get inside, now!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_166", "wedge"}, -- Fine, how do I get inside? Shut up! Did you hear that?
	}
}
som_kenobi_obi_wan:addScreen(toomany)

wedge = ConvoScreen:new {
	id = "wedge",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_167", -- It's the crystal. It's playing tricks with your mind. Wedge it into one of the cracks on the pillar, then place your hands on it and focus on transferring yourself inside.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_169", "hurry_a"}, -- This better work!
	}
}
som_kenobi_obi_wan:addScreen(wedge)

breakdown = ConvoScreen:new {
	id = "breakdown",
	playerAnimation = "squirm",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_168", -- The crystal is trying to break you down, but you will be free from it in a second, my friend. Take it and wedge it into one of the cracks of the pillar, then place your hands on it and focus on transferring yourself inside.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_171", "hurry_b"}, -- Alright, I... I hope this works...
	}
}
som_kenobi_obi_wan:addScreen(breakdown)

-- Both fire 'talkedKenobi3' and open the way into the lair.
hurry_a = ConvoScreen:new {
	id = "hurry_a",
	playerAnimation = "squirm",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_170", -- I believe it will, %TU. Now hurry!
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(hurry_a)

hurry_b = ConvoScreen:new {
	id = "hurry_b",
	playerAnimation = "twitch",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_172", -- It will, my friend. Now hurry!
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(hurry_b)

--------------------------------------------------------------------------------
-- THE TWO READY CHECKS, for a player who walks back to him after the way in is
-- already open, and the greeting once Sinistro is dead.
--------------------------------------------------------------------------------

ready_enter = ConvoScreen:new {
	id = "ready_enter",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_313", -- Are you ready to enter the chamber, %TU?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_315", "ready_yes"}, -- I think so.
		{"@conversation/som_kenobi_obi_wan:s_317", "ready_no"},  -- Give me a moment to recover.
	}
}
som_kenobi_obi_wan:addScreen(ready_enter)

ready_yes = ConvoScreen:new {
	id = "ready_yes",
	animation = "nod",
	playerAnimation = "nod",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_321", -- Good, let us finish this, %TU.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(ready_yes)

ready_no = ConvoScreen:new {
	id = "ready_no",
	animation = "nod",
	playerAnimation = "shake_head_no",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_319", -- Very well, but don't take too long, %TU. We need to finish this.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(ready_no)

resume = ConvoScreen:new {
	id = "resume",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_335", -- Are you ready to pick up where we left off, %TU?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_obi_wan:s_337", "resume_yes"}, -- Yes, I feel that I am.
		{"@conversation/som_kenobi_obi_wan:s_339", "resume_no"},  -- No. Not yet I'm afraid.
	}
}
som_kenobi_obi_wan:addScreen(resume)

resume_yes = ConvoScreen:new {
	id = "resume_yes",
	playerAnimation = "nod",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_341", -- Good. Make your way to the lair immediately. We haven't much time.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(resume_yes)

resume_no = ConvoScreen:new {
	id = "resume_no",
	playerAnimation = "shake_head_no",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_342", -- Very well, but I hope you will be soon. We don't have much time.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(resume_no)

hero = ConvoScreen:new {
	id = "hero",
	leftDialog = "@conversation/som_kenobi_obi_wan:s_333", -- Good to see you again, %TU. You're a hero unlike any others, my young friend.
	stopConversation = "true",
	options = {}
}
som_kenobi_obi_wan:addScreen(hero)

addConversationTemplate("som_kenobi_obi_wan", som_kenobi_obi_wan)
