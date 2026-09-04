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
	  force_know   s_147  the Force, at "Who are you?!"
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

	THE TWO FORCE OPTIONS ARE GATED -- this was missing entirely

	Live guards s_144 and s_146 with condition_playerJedi, which is
	jedi.isForceSensitive(player). This handler had no gate at all, so every
	player saw "[Use the Force] You don't need to know that." and got the
	mainframe for free. That is two of the seven routes handed to characters
	live never offers them to, and it made the 500/350 credit fork pointless.

	Root cause: the tree was reconstructed from the string table, and a string
	table records an option's TEXT but not its condition. The "[Use the Force]"
	prefix is the only hint it carries, and the earlier revision read that as
	flavour rather than as a gate.

	Force sensitive, NOT Padawan -- see canUseTheForce for why the distinction
	matters and which skill is the right one.

	Stripped of both, every other route still works: the two intimidation
	screens, the two prices and the supervisor threat are all ungated. No path
	is closed to a non-sensitive.

	THE ANIMATIONS -- these were missing entirely

	Live fires 17. All 17 hang off a player option -- the greeting and the ambient
	screen carry none -- and they land on 12 distinct screens, which is what
	screenAnimations below has:

	    live calls   17
	    plus  +1     s_173's player sigh_deeply is fired once, before the cash
	                 test, so it plays on the way to pay_discount AND on the way
	                 to broke_discount. One live call, two rows.
	    = 12 rows, 18 animations

	Keying by destination screen is safe here because no screen in this tree has
	two inbound edges -- each of the twelve is reached exactly one way, so nothing
	can disagree about what to play. Where that is not true the gesture has to go
	on the edge instead, which is what serpent_thief_conv_handler and
	lava_beetle_nest_destroy_donko_conv_handler do.

	Five rows carry the player's gesture and the NPC's, in SOE's order, so a row
	is a list played in order, not a single pair.

	force_know and force_pay get the identical snap_finger1 + shake_head_no: live
	gives both Force pushes the same gesture. It is written twice because the two
	land on different screens.

	ROOT CAUSE of the omission: the tree was reconstructed from the string table,
	and a string table records text and nothing else -- no conditions, no wiring,
	no gestures. Everything this handler adds is something the .stf could not have
	told the earlier revision.

	A NOTE ON SOE'S CONDITION NAMES, so a future reader does not "fix" this. Live's
	s_149 fork tests condition_have500 and answers the TRUE side with "You don't
	even have that kind of cash"; s_173 tests condition_have350 the same way. The
	names read backwards from what the branches do. The test below is written the
	way it reads -- enough credits goes to pay_full -- which produces live's
	behaviour. Do not invert it to match the name.
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

-- option links whose option text is prefixed "[Use the Force]" in the string table.
-- Live guards both with condition_playerJedi. See THE TWO FORCE OPTIONS ARE GATED.
computer_technician_conv_handler.forceOptions = {
	force_know = true, -- s_146, off who
	force_pay = true,  -- s_144, off rentalfee
}

-- [destination screen] = { { actor, animation }, ... } in the order live plays them.
-- See THE ANIMATIONS for why keying by destination is safe in this tree.
computer_technician_conv_handler.screenAnimations = {
	who            = { { "npc", "taken_aback" } },
	notallowed     = { { "npc", "point_accusingly" } },
	preposterous   = { { "player", "threaten" }, { "npc", "squirm" } },
	notfunny       = { { "npc", "nervous" } },
	force_know     = { { "player", "snap_finger1" }, { "npc", "shake_head_no" } },
	rentalfee      = { { "player", "shrug_hands" }, { "npc", "rub_chin_thoughtful" } },
	force_pay      = { { "player", "snap_finger1" }, { "npc", "shake_head_no" } },
	broke_full     = { { "npc", "shake_head_disgust" } },
	discount       = { { "player", "shake_head_no" } },
	pay_discount   = { { "player", "sigh_deeply" } },
	broke_discount = { { "player", "sigh_deeply" }, { "npc", "shake_head_disgust" } },
	supervisor     = { { "player", "threaten" }, { "npc", "taken_aback" } },
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

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

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

	-- who and rentalfee are the only screens carrying a Force option, and neither is
	-- price or discount, so this cannot collide with the two rebuilds above.
	elseif (not self:canUseTheForce(pPlayer)) then
		self:stripForceOptions(screen, clonedConversation)
	end

	return pClonedScreen
end

-- Live's condition_playerJedi is jedi.isForceSensitive(player) -- force sensitive, NOT
-- Padawan. force_title_jedi_rank_01 is Padawan and is strictly narrower:
-- village_jedi_manager.lua:113 will not grant rank_01 until the character has 24
-- force-sensitive skills, and force_title_jedi_novice is what is awarded the moment a
-- character becomes force sensitive at all (village_jedi_manager.lua:59, fs_intro.lua:373).
-- helper_droid.lua:291 is the in-repo precedent for the novice test.
function computer_technician_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")
end

-- Rebuilds the option list without the Force pushes. Option indices are 0-based:
-- conv_handler passes the client's selectedOption straight to getOptionLink.
function computer_technician_conv_handler:stripForceOptions(screen, clonedConversation)
	local count = screen:getOptionCount()
	local kept = {}

	for i = 0, count - 1 do
		local link = screen:getOptionLink(i)

		if (not self.forceOptions[link]) then
			table.insert(kept, { screen:getOptionText(i), link })
		end
	end

	if (#kept == count) then
		return
	end

	clonedConversation:removeAllOptions()

	for i = 1, #kept do
		clonedConversation:addOption(kept[i][1], kept[i][2])
	end
end
