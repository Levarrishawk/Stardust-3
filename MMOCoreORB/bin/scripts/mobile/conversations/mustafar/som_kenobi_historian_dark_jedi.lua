--[[
	The dark Jedi who ambushes you at the historian's camp -- som_kenobi_historian_2,
	task 2.

	SOURCE OF RECORD -- NOT A RECONSTRUCTION

	  Read off Mustafar's server-side som_kenobi_historian_dark_jedi conversation.
	  It is the smallest conversation in the arc and the only one in it that is not
	  a conversation at all:

	    OnStartNpcConversation   two conditions, first match wins, and BOTH end in
	                             action_attack + chat.chat. Neither opens a window.
	    OnNpcConversationResponse  has no branches. Not one. It can only fall
	                             through to its own error line.

	  So there is no tree. She is bait: she sits meditating, you hail her, and she
	  kills you for it. The two shipped strings are the only two things she ever
	  says, and which one you get is decided by whether you are force sensitive:

	    s_4  force sensitive   npc belly_laugh    "...your feeble powers will not
	                                              save you, young one!"
	    s_6  everyone else     npc point_forward  "Inferior fool! You disturbed
	                                              death incarnate."

	  s_2 ships empty and live never references it. That is the whole string table.

	THE AMBUSH IS THE POINT, AND THE MOBILE HAD IT BACKWARDS

	  Live sets her up in OnInitialize and OnAttach as
	  BEHAVIOR_SENTINEL calm behaviour, "npc_meditate" calm mood, and
	  CONDITION_CONVERSABLE -- set in OnInitialize, again in OnAttach, and a third
	  time in OnObjectMenuRequest, which also adds the CONVERSE_START radial. She
	  is a meditating statue you are invited to walk up and talk to.

	  som_kenobi_historian_dark_jedi.lua had her as pvpBitmask AGGRESSIVE with no
	  conversationTemplate at all, which inverts the encounter: an AGGRESSIVE agent
	  charges on sight (AiAgentImplementation.cpp:4324 returns the bit straight out
	  of isAggressive), so the player never gets to hail her and every line above is
	  dead. Both are corrected, and her own sibling is the proof of the shape:
	  som_kenobi_serpent_dark_jedi is the same creature to the stat -- same level,
	  HAM, weapons and attacks -- and is already ATTACKABLE + ENEMY with
	  CONVERSABLE and a conversationTemplate, because she taunts before her fight
	  too.

	  Root cause: the mobile was written from the spawn-type table, which gives a
	  group size and nothing else, and from the fact that she is an enemy. Being an
	  enemy and being aggressive are different things, and only the conversation
	  script says which one she is.

	DEVIATION -- both screens, and the same one as twice before

	  Live delivers both lines with chat.chat, a spatial bubble, and never opens a
	  window. Core3 cannot do that: AiAgentImplementation.cpp:4122 sends
	  StartNpcConversation to the client before any Lua runs, and returning nil
	  from getInitialScreen drops the session with forceClose=false
	  (ConversationObserver.idl:54), which leaves the window open and empty.

	  So both are one-line terminal screens. Same words, same animation, same
	  combat, one extra click to dismiss. This is the third time -- see the
	  brush-off in som_kenobi_serpent_thief and the rebuff in
	  som_kenobi_cursed_shard_sucker.

	  Combat does not eat the line. ConversationObserverImplementation.cpp:129-136
	  picks the screen, runs the handlers and sends it, and nothing on that path
	  cancels for a fight the handler just started.

	COUNTS RECONCILE
	    0 live screens  + 2  both deviations, above  = 2
	    0 options -- live ships no player response anywhere in this conversation
	    2 animations, one per opening, both on the npc
	    3 strings shipped, 1 empty, 2 used

	QUEST
	  She is worth a tablet piece. historian.lua's notifyKilledCreature matches her
	  template for som_kenobi_historian_2 task 2 -- see that file's Kill credit.
]]

som_kenobi_historian_dark_jedi = ConvoTemplate:new {
	initialScreen = "taunt",
	templateType = "Lua",
	luaClassHandler = "historian_dark_jedi_conv_handler",
	screens = {}
}

------------------------------------------------------------------------------
-- Neither screen is reachable from the other. The handler picks one and that
-- is the end of the conversation -- and the start of the fight.
------------------------------------------------------------------------------

historian_dark_jedi_taunt = ConvoScreen:new {
	id = "taunt",
	leftDialog = "@conversation/som_kenobi_historian_dark_jedi:s_6", -- Inferior fool! You disturbed death incarnate. Prepare to pay the price!
	stopConversation = "true",
	options = {}
}
som_kenobi_historian_dark_jedi:addScreen(historian_dark_jedi_taunt)

historian_dark_jedi_taunt_sensitive = ConvoScreen:new {
	id = "taunt_sensitive",
	leftDialog = "@conversation/som_kenobi_historian_dark_jedi:s_4", -- Haha, your feeble powers will not save you, young one! Coming here was a mistake that will cost you your life!
	stopConversation = "true",
	options = {}
}
som_kenobi_historian_dark_jedi:addScreen(historian_dark_jedi_taunt_sensitive)

addConversationTemplate("som_kenobi_historian_dark_jedi", som_kenobi_historian_dark_jedi)
