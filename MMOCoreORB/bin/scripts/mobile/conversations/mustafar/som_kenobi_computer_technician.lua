--[[
	som_kenobi_computer_technician -- the mining facility technician who guards
	the search terminal in som_kenobi_main_quest_1.

	SOURCE. Every line below is a shipped string. The table is
	string/en/conversation/som_kenobi_computer_technician.stf, 35 strings, and
	all 33 speaking ones are used here; s_2 is empty and is skipped. The English
	text is repeated as a trailing comment on each reference so the tree can be
	read without the STF in hand.

	WHAT THE .qst NEEDS FROM THIS TREE. som_kenobi_main_quest_1 task 0 is a
	Wait-for-Signal on 'talkedToTechnician'. Nothing else in the quest touches
	him. So the only thing this tree has to do is reach a screen where he lets
	the player at a computer, and the handler fires that signal there.

	RECONSTRUCTED. The .stf stores screen text and option text in one flat list
	with no parent links -- SwgConversationEditor numbers screens in creation
	order, not tree order, so the branch wiring is not recoverable from the file.
	The wiring below is reconstructed from the text itself: each option is placed
	on the screen its wording answers, and each screen follows the option it
	replies to. Three routes to the same grant are visible in the text and are
	all kept:
	  intimidate  s_123 -> s_124 -> s_126 -> s_127 -> s_128 -> s_134 -> s_136/s_138
	  the Force   s_146 -> s_147   and   s_144 -> s_145
	  pay         s_143 -> s_148 (500) -> s_149, or s_151 -> s_153 (350) -> s_173,
	              with s_176 -> s_177 as the free way out of the shakedown
	s_178 and s_179 are his two "You don't even have that kind of cash" screens,
	one per price; the handler picks them when the player cannot pay.

	NOT MODELLED. He has no idle chatter beyond s_93, so s_93 is used as the
	ambient screen for a player who has already been granted access or who has
	no business with him yet.
]]

som_kenobi_computer_technician = ConvoTemplate:new {
	initialScreen = "greeting",
	templateType = "Lua",
	luaClassHandler = "computer_technician_conv_handler",
	screens = {}
}

--------------------------------------------------------------------------------
-- ambient
--------------------------------------------------------------------------------

kenobi_tech_ambient = ConvoScreen:new {
	id = "ambient",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_93", -- Do I look like I'm here to chat? I have a job to do.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_ambient)

--------------------------------------------------------------------------------
-- opening
--------------------------------------------------------------------------------

kenobi_tech_greeting = ConvoScreen:new {
	id = "greeting",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_121", -- What are you doing here?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_computer_technician:s_122", "busy"},   -- I have a favor to ask.
		{"@conversation/som_kenobi_computer_technician:s_123", "who"},    -- I need to access your computer for a bit.
	}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_greeting)

--------------------------------------------------------------------------------
-- intimidate route
--------------------------------------------------------------------------------

kenobi_tech_who = ConvoScreen:new {
	id = "who",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_124", -- Say what?! Who are you?!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_computer_technician:s_126", "notallowed"}, -- Who I am is not important. Now I need to borrow your computer.
	}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_who)

kenobi_tech_notallowed = ConvoScreen:new {
	id = "notallowed",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_127", -- You are doing no such thing! You are not even supposed to be here!
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_computer_technician:s_128", "preposterous"}, -- Either I use your computer, or you end up in the med facility.
	}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_notallowed)

kenobi_tech_preposterous = ConvoScreen:new {
	id = "preposterous",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_134", -- Please, this is preposterous. What is it you intend to do with it?
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_computer_technician:s_135", "watching"}, -- I'm looking for someone out in the lava fields.
	}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_preposterous)

-- GRANT. He gives way here; the handler fires 'talkedToTechnician' on this
-- screen and on the two that follow, so the player who stops talking now is
-- not left without the quest.
kenobi_tech_watching = ConvoScreen:new {
	id = "watching",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_136", -- Very well, but I'm staying to make sure you don't break anything.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_computer_technician:s_137", "notfunny"}, -- Of course, but get in my way and I will break something.
	}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_watching)

kenobi_tech_notfunny = ConvoScreen:new {
	id = "notfunny",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_138", -- That...that's not funny. Please hurry up so I can get back to work.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_notfunny)

--------------------------------------------------------------------------------
-- polite route, which forks into the Force and the shakedown
--------------------------------------------------------------------------------

kenobi_tech_busy = ConvoScreen:new {
	id = "busy",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_125", -- I'm really busy here, so make it quick.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_computer_technician:s_139", "droids"}, -- I'm looking for someone out in the lava fields and...
	}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_busy)

kenobi_tech_droids = ConvoScreen:new {
	id = "droids",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_140", -- You were hoping that one of our droids has spotted them? That's very possible, but I can't spend my days trying to find people lost out there. I have a real job to do.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_computer_technician:s_141", "rentalfee"}, -- Maybe I can use one of the computers for a minute?
		{"@conversation/som_kenobi_computer_technician:s_146", "force_know"}, -- [Use the Force] You don't need to know that.
	}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_droids)

-- GRANT
kenobi_tech_force_know = ConvoScreen:new {
	id = "force_know",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_147", -- I don't need to know that. You can go ahead and use that one over there. Just hurry up so I can get back to work.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_force_know)

kenobi_tech_rentalfee = ConvoScreen:new {
	id = "rentalfee",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_142", -- That is highly unusual...and the rental fee on these computers is quite steep.
	stopConversation = "false",
	options = {
		{"@conversation/som_kenobi_computer_technician:s_143", "price"},     -- How steep?
		{"@conversation/som_kenobi_computer_technician:s_144", "force_pay"}, -- [Use the Force] But I don't have to pay.
	}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_rentalfee)

-- GRANT
kenobi_tech_force_pay = ConvoScreen:new {
	id = "force_pay",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_145", -- But you don't have to pay. Go ahead. Just be quick so I can get back to work.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_force_pay)

--------------------------------------------------------------------------------
-- the shakedown. 500 first, 350 after a refusal, free if he is threatened with
-- his supervisor. The two "not enough cash" screens are reached from the
-- handler, not from an option, so they carry no options of their own.
--------------------------------------------------------------------------------

kenobi_tech_price = ConvoScreen:new {
	id = "price",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_148", -- I believe the going rate is 500 credits.
	stopConversation = "false",
	-- Options are added by the handler, because s_149 has to lead to a different
	-- screen depending on whether the player is actually carrying 500 credits:
	--   affordable  s_149 -> pay_full     can't pay  s_149 -> broke_full (s_178)
	-- The same-text-different-target trick is corvetteTicketTakerConvoHandler's.
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_price)

-- GRANT, 500 credits taken by the handler
kenobi_tech_pay_full = ConvoScreen:new {
	id = "pay_full",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_174", -- A pleasure doing business with you. Use that one over there. Now hurry up so I can get back to work.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_pay_full)

kenobi_tech_broke_full = ConvoScreen:new {
	id = "broke_full",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_178", -- You don't even have that kind of cash. Come back when you do.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_broke_full)

kenobi_tech_discount = ConvoScreen:new {
	id = "discount",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_153", -- I might be convinced to give you a discount. 350 is my final offer. Take it or leave it.
	stopConversation = "false",
	-- Same as price, at 350:
	--   affordable  s_173 -> pay_discount   can't pay  s_173 -> broke_discount (s_179)
	-- s_176, the supervisor threat, is added unconditionally.
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_discount)

-- GRANT, 350 credits taken by the handler
kenobi_tech_pay_discount = ConvoScreen:new {
	id = "pay_discount",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_175", -- A pleasure doing business with you. Use that one over there. Now hurry up so I can get back to work.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_pay_discount)

kenobi_tech_broke_discount = ConvoScreen:new {
	id = "broke_discount",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_179", -- You don't even have that kind of cash. Come back when you do.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_broke_discount)

-- GRANT, nothing taken
kenobi_tech_supervisor = ConvoScreen:new {
	id = "supervisor",
	leftDialog = "@conversation/som_kenobi_computer_technician:s_177", -- No need to get testy! One has to make a living you know. Very well, use the computer over there, but hurry up so I can get back to work.
	stopConversation = "true",
	options = {}
}
som_kenobi_computer_technician:addScreen(kenobi_tech_supervisor)

addConversationTemplate("som_kenobi_computer_technician", som_kenobi_computer_technician)
