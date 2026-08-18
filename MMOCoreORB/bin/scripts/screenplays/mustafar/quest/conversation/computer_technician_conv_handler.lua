--[[
	The Mensix mining facility computer technician -- conversation handler for
	som_kenobi_main_quest_1.

	The tree is in mobile/conversations/mustafar/som_kenobi_computer_technician.lua,
	which carries the note on how it was reconstructed from the shipped string
	table. This file routes by spine stage and fires the one signal the .qst
	actually waits on.

	WHAT THE .qst ASKS FOR. som_kenobi_main_quest_1 task 0 is a Wait-for-Signal
	on 'talkedToTechnician', taskName accessMainframe. Nothing else in the quest
	mentions him. So every route through the tree that ends with him giving way
	calls kenobiSpineScreenPlay:grantMainframe(), and that is the whole contract.

	FIVE WAYS HE GIVES WAY, all shipped:
	  notfunny     s_138  intimidated, then needled
	  watching     s_136  intimidated, plainly
	  force_know   s_147  the Force, at the droid question
	  force_pay    s_145  the Force, at the rental fee
	  pay_full     s_174  500 credits
	  pay_discount s_175  350 credits
	  supervisor   s_177  threatened with his supervisor, free

	THE PRICE IS SHIPPED, AND SO IS BEING BROKE. s_148 names 500 credits, s_153
	names 350, and s_178/s_179 are his two "You don't even have that kind of
	cash" screens -- one per price. Since the same player line has to lead
	somewhere different depending on what is in the player's pocket, the pay
	options are added here rather than declared in the tree, which is what
	corvetteTicketTakerConvoHandler does for its ticket check.

	NO ABANDON. The table has no line for taking the favour back and the .qst
	models none, so once 'talkedToTechnician' has fired he drops to s_93 and
	stays there.
]]

computer_technician_conv_handler = conv_handler:new {}

computer_technician_conv_handler.screenPlayName = "kenobiSpineScreenPlay"

computer_technician_conv_handler.fullPrice = 500      -- s_148
computer_technician_conv_handler.discountPrice = 350  -- s_153

-- The screens on which he gives way for nothing. pay_full and pay_discount also
-- grant, but they are handled on their own below because they take credits
-- first, so they are deliberately not in this table.
computer_technician_conv_handler.grantScreens = {
	watching = true,
	notfunny = true,
	force_know = true,
	force_pay = true,
	supervisor = true,
}

function computer_technician_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (not kenobiSpineScreenPlay:needsMainframe(pPlayer)) then
		-- s_93, "Do I look like I'm here to chat? I have a job to do."
		return convoTemplate:getScreen("ambient")
	end

	return convoTemplate:getScreen("greeting")
end

function computer_technician_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (screenID == "price") then
		if (CreatureObject(pPlayer):getCashCredits() >= self.fullPrice) then
			clonedConversation:addOption("@conversation/som_kenobi_computer_technician:s_149", "pay_full")
		else
			clonedConversation:addOption("@conversation/som_kenobi_computer_technician:s_149", "broke_full")
		end
		clonedConversation:addOption("@conversation/som_kenobi_computer_technician:s_151", "discount")

	elseif (screenID == "discount") then
		if (CreatureObject(pPlayer):getCashCredits() >= self.discountPrice) then
			clonedConversation:addOption("@conversation/som_kenobi_computer_technician:s_173", "pay_discount")
		else
			clonedConversation:addOption("@conversation/som_kenobi_computer_technician:s_173", "broke_discount")
		end
		clonedConversation:addOption("@conversation/som_kenobi_computer_technician:s_176", "supervisor")

	elseif (screenID == "pay_full") then
		CreatureObject(pPlayer):subtractCashCredits(self.fullPrice)
		kenobiSpineScreenPlay:grantMainframe(pPlayer)

	elseif (screenID == "pay_discount") then
		CreatureObject(pPlayer):subtractCashCredits(self.discountPrice)
		kenobiSpineScreenPlay:grantMainframe(pPlayer)

	elseif (self.grantScreens[screenID]) then
		kenobiSpineScreenPlay:grantMainframe(pPlayer)
	end

	return pClonedScreen
end
