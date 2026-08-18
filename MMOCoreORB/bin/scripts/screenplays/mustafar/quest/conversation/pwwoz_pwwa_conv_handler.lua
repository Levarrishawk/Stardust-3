--[[
	Pwwoz Pwwa -- conversation handler for som_kenobi_samaritan_1 and _2.

	The tree is in mobile/conversations/mustafar/som_kenobi_pwwoz_pwwa.lua, which
	carries the note on how it was reconstructed from the shipped string table.
	This file routes by quest stage, fires the grant, and settles the one decision
	the quest is built around. All state lives in samaritanScreenPlay's persistent
	screenplay data on the player's ghost; nothing is kept here.

	FIVE OPENINGS, ONE PER STAGE

	The string table shipped a distinct first line for every state the player can
	be in, which is what fixes the routing -- none of it is invented:

	  s_110 greeting     never spoken to him
	  s_172 progress     quest running, no crystal yet
	  s_173 has_crystal  crystal in hand, back to decide
	  s_186 give         he is possessed and still coming for the player
	  s_225 grudge       the player kept it
	  s_226 epilogue     the player gave it and had to put him down

	give is reused as an opening on purpose. som_kenobi_samaritan_1.qst task 9 is
	a Destroy Multiple on Pwwoz himself, so a player who hands the crystal over
	and then runs has an unfinished kill step; hailing him again puts s_186 back
	on screen and samaritanScreenPlay:giveCrystal re-aggros him. giveCrystal is
	idempotent -- the crystal is only taken the first time.

	THE LEVEL GATE, AND THE ONE DEVIATION IN THIS FILE

	som_kenobi_samaritan_1.qst's [list] block says Level = 75. Unlike Menth Paul,
	whose table shipped s_72 ("I wish you were more experienced..."), Pwwoz's
	table shipped no too-low-level refusal line at all. So the gate is enforced
	with the .qst's number and stated in a system message, and the conversation
	is routed to s_114 -- "Bah! What could be more...ex.. excuse me, where's my
	manners. Have a nice day." -- which is the shipped brush-off. The system
	message is the deviation: it is text SOE did not write, and it exists only
	because leaving the player with s_114 alone gives no reason for the refusal.

	THE FORCE GATE

	Four of the player's options are prefixed "[Use the Force]" in SOE's own
	string table (s_181, s_193, s_208, s_218) and each is answered by Pwwoz
	fighting the suggestion off (s_182, s_195, s_209, s_220). Those are mind
	tricks, so a non-Jedi must not see them; they are stripped at runtime the
	same way cursed_shard_sucker_conv_handler strips its three. Every screen that
	carries one also carries a plain give and a plain keep, so stripping never
	corners a player.

	s_195 is the odd one out: it is a Force screen that ends the conversation
	itself rather than handing the choice back, so it is a keep screen in its own
	right and is listed as one below.

	WALKING AWAY

	refuse_a (s_125) and refuse_b (s_171) turn the offer down and change no state
	-- the player can hail him again. The .qst models no abandon and Pwwoz has no
	line for taking the job back, so neither is a hook.
--]]

pwwoz_pwwa_conv_handler = conv_handler:new {}

pwwoz_pwwa_conv_handler.screenPlayName = "samaritanScreenPlay"

-- option links whose option text is prefixed "[Use the Force]" in the string table
pwwoz_pwwa_conv_handler.forceOptions = {
	obsessed_force = true,
	lied_force = true,
	reward_force = true,
	tired_force = true,
}

-- the two directions screens; each hands out the quest
pwwoz_pwwa_conv_handler.grantScreens = {
	directions_a = true,
	directions_b = true,
}

-- .qst signal giveCrystal
pwwoz_pwwa_conv_handler.giveScreens = {
	give = true,
}

-- .qst signal keepCrystal. lied_force is here because s_195 ends on "I will have
-- my revenge. Mark my words!" without offering the choice again.
pwwoz_pwwa_conv_handler.keepScreens = {
	keep = true,
	lied_force = true,
}

function pwwoz_pwwa_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)
	local stage = samaritanScreenPlay:getStage(pPlayer)

	if (stage == 0) then
		if (CreatureObject(pPlayer):getLevel() < samaritanScreenPlay.requiredLevel) then
			CreatureObject(pPlayer):sendSystemMessage("Pwwoz Pwwa will not trust his errand to someone of your experience. (Requires combat level "
				.. samaritanScreenPlay.requiredLevel .. ".)")

			return convoTemplate:getScreen("busy")
		end

		return convoTemplate:getScreen("greeting")
	elseif (stage == samaritanScreenPlay.STAGE_DECIDE) then
		return convoTemplate:getScreen("has_crystal")
	elseif (stage == samaritanScreenPlay.STAGE_POSSESSED) then
		return convoTemplate:getScreen("give")
	elseif (stage == samaritanScreenPlay.STAGE_DONE_KEPT) then
		return convoTemplate:getScreen("grudge")
	elseif (stage == samaritanScreenPlay.STAGE_DONE_KILLED) then
		return convoTemplate:getScreen("epilogue")
	end

	-- STAGE_ACTIVE and STAGE_HUNT: s_172, "You need to find that crystal. Now!"
	return convoTemplate:getScreen("progress")
end

function pwwoz_pwwa_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)

	if (self.grantScreens[screenID]) then
		samaritanScreenPlay:startQuest(pPlayer)
	elseif (self.giveScreens[screenID]) then
		samaritanScreenPlay:giveCrystal(pPlayer, pNpc)
	elseif (self.keepScreens[screenID]) then
		samaritanScreenPlay:keepCrystal(pPlayer)
	elseif (not self:canUseTheForce(pPlayer)) then
		self:stripForceOptions(screen, clonedConversation)
	end

	return pClonedScreen
end

function pwwoz_pwwa_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_rank_01")
end

-- Rebuilds the option list without the mind tricks. Option indices are 0-based:
-- conv_handler passes the client's selectedOption straight to getOptionLink.
function pwwoz_pwwa_conv_handler:stripForceOptions(screen, clonedConversation)
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
