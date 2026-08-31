--[[
	Pletus Croix -- conversation handler for the Nabooian historian
	("Unlocking the Secrets" / somGlyphHuntScreenPlay).

	The tree is in mobile/conversations/mustafar/som_glyph_hunt.lua, which
	carries the note on what the live conversation corrected in it. This file
	routes by stage, plays the animations and fires the two signals.

	THE ORDER OF THE GATE MATTERS, and it is live's order. A finished character
	is checked FIRST -- ahead of every stage and ahead of the first meeting --
	so Pletus greets him with s_36 and never offers the work again. Live gates
	that on groundquests.hasCompletedQuest; the port's equivalent is the
	screenplay's `runs` counter.

	A CONSEQUENCE WORTH STATING PLAINLY. The .qst's allowRepeats is true and
	somGlyphHuntScreenPlay honours it -- awardQuest resets the stage to 0 and
	canGrantQuest still returns true for a repeater. But live's own giver never
	asks again, so via Pletus the quest is once per character regardless. The
	screenplay is left as it is, because allowRepeats is what the datatable
	says and something else may yet grant it; what changes here is only that
	this NPC behaves the way this NPC behaved.

	WHERE THE FIRST SIGNAL FIRES -- this was one screen too early

	signalGlyphsFound used to fire on two_copies, the moment the player hands
	the rubbings over. Live sends glyph_hunt_found from s_34 instead -- the end
	of the follow-up spine, after the player has said "Not a problem. Who are
	the officers?" and been told who they are.

	The difference is not cosmetic. s_35, "Maybe later. I have other things to
	attend to right now.", is a real decline that lives on the same screen as
	the acceptance. Firing on two_copies started the officer hunt before the
	player was asked, so declining did nothing and the decline screen was
	decoration. Fired on the_officers, the decline works.

	ROOT CAUSE: reading the signal's NAME for its meaning. "glyphs found" sounds
	like it belongs where the glyphs are handed in, and two_copies is that
	screen. What the signal actually does in the screenplay is start the
	commander stage, which is the officer hunt -- so it belongs where the player
	agrees to it. The name described the trigger; the body described the effect;
	only the live script says which one SOE wired it to.

	The stage == 2 guard still holds: two_copies through the_officers is one
	unbroken run of screens inside a single conversation, and nothing moves the
	stage in between.

	THE ANIMATIONS -- these were missing entirely

	Live fires 20, and they land on 17 distinct screens, which is what
	screenAnimations below has. Two of the 17 are greetings; runScreenHandlers
	runs on the initial screen too, so they sit in the same table as the rest
	rather than in getInitialScreen.

	Keying by destination screen is safe here. why_they_care is the only screen
	with two inbound edges -- s_70 straight from the introduction, s_68 after
	the Coyn are named -- and live plays npc:explain on both, so the two cannot
	disagree.

	ROOT CAUSE of the omission: the tree was reconstructed from the string
	table, and a string table records text and nothing else -- no wiring, no
	conditions, no gestures.
--]]

glyph_hunt_conv_handler = conv_handler:new {}

-- [destination screen] = { { actor, animation }, ... } in the order live plays them.
-- See THE ANIMATIONS for why keying by destination is safe in this tree.
glyph_hunt_conv_handler.screenAnimations = {
	already_helped    = { { "npc", "greet" } },
	greeting          = { { "npc", "greet" } },
	not_that_glorious = { { "npc", "search" } },
	who_is_pletus     = { { "player", "slow_down" }, { "npc", "laugh_titter" } },
	who_are_coyn      = { { "npc", "explain" } },
	why_they_care     = { { "npc", "explain" } },
	offer_glyphs      = { { "npc", "nod" } },
	accept_glyphs     = { { "npc", "nod_head_multiple" } },
	decline_glyphs    = { { "player", "stop" }, { "npc", "nod_head_multiple" } },
	two_copies        = { { "player", "manipulate_medium" }, { "npc", "taken_aback" } },
	defaced           = { { "npc", "pound_fist_palm" } },
	start_looking     = { { "npc", "explain" } },
	the_officers      = { { "npc", "shakefist" } },
	ritual            = { { "player", "manipulate_medium" }, { "npc", "rub_chin_thoughtful" } },
	crystal           = { { "npc", "explain" } },
	payment           = { { "npc", "thank" } },
}

function glyph_hunt_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Live checks this first, before any stage. See THE ORDER OF THE GATE.
	if (somGlyphHuntScreenPlay:getRuns(pPlayer) > 0) then
		return convoTemplate:getScreen("already_helped")
	end

	local stage = somGlyphHuntScreenPlay:getStage(pPlayer)

	if (stage == 1) then
		return convoTemplate:getScreen("glyphs_checkin")
	elseif (stage == 2) then
		return convoTemplate:getScreen("glyphs_return")
	elseif (stage == 3) then
		return convoTemplate:getScreen("sections_checkin")
	elseif (stage == 4) then
		return convoTemplate:getScreen("officers_return")
	end

	-- stage 0 (never started) and transient 5
	return convoTemplate:getScreen("greeting")
end

function glyph_hunt_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()
	local clonedConversation = LuaConversationScreen(pClonedScreen)
	local stage = somGlyphHuntScreenPlay:getStage(pPlayer)

	local animations = self.screenAnimations[screenID]

	if (animations ~= nil) then
		for i = 1, #animations do
			local actor = animations[i][1] == "npc" and pNpc or pPlayer

			CreatureObject(actor):doAnimation(animations[i][2])
		end
	end

	if (screenID == "accept_glyphs") then
		if (somGlyphHuntScreenPlay:canGrantQuest(pPlayer)) then
			somGlyphHuntScreenPlay:grantQuest(pPlayer)
		end
	elseif (screenID == "the_officers") then
		-- live's sendFirstSignal, on s_34. See WHERE THE FIRST SIGNAL FIRES.
		if (stage == 2) then
			somGlyphHuntScreenPlay:signalGlyphsFound(pPlayer)
		end
	elseif (screenID == "payment") then
		if (stage == 4) then
			somGlyphHuntScreenPlay:signalGlyphFinish(pPlayer)
		end
	end

	return pClonedScreen
end
