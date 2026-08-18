--[[
	Ben Kenobi -- conversation handler for the whole Mustafar Kenobi arc.

	The tree is in mobile/conversations/mustafar/som_kenobi_obi_wan.lua, which
	carries the note on why the two shipped tables were merged into one template
	and why this is not obi_wan_ghost.

	WHAT THE .qst FILES ASK FOR. Six quests hang off this one conversation, and
	every one of them is a Wait-for-Signal that this handler has to fire:
	  som_obi_wan_signal_1     task 0  signal 'dyingMiner'       given at pro_task
	  som_obi_wan_signal_2     task 0  signal 'returnToObiWan'   fired at pro_west
	  som_kenobi_main_quest_1                                    given at give_quest_a/b
	  som_kenobi_main_quest_spared / _killed
	                           task 0  signal 'talkedKenobi1'    fired at send_a..d
	  som_kenobi_main_quest_3  task 0  signal 'talkedKenobi2'    fired at goluck_a..d
	                           task 6  signal 'talkedKenobi3'    fired at hurry_a/b
	Nothing else in those files touches him.

	TWO PLACES, ONE CREATURE. s_266 and s_302 send the player to "the
	northeastern shoreline between the old and new mining facilities" for his
	help; s_162, "I'm glad to see you made it", is at the chamber entrance,
	where s_269 has already promised "I can't come with you, but will meet you
	there". So the screenplay spawns him twice from the same template and tags
	each spawn, and this handler asks which one is being talked to before it
	picks a screen. Everything else routes off the spine stage.

	THE A/B TWINS. The shipped table carries duplicated subtrees. urgency_a and
	urgency_b hang off the spared branch, urgency_c and urgency_d off the killed
	one -- that is how the tree is already wired -- so the chamber briefing
	follows the same split: chamber_a (which feeds where_a/where_b) for a player
	who spared the hermit, chamber_b (where_c/where_d) for one who killed him.

	THE LEVEL GATE IS SOE'S NUMBER. som_kenobi_main_quest_1 is Level 75, Tier 4,
	so a player under that gets pro_nothing, s_34, "I have nothing more for you
	at this time". The prologue itself carries no level, so it is not gated.

	NOT GATED ON BEING A JEDI. Every prologue line calls the player "young
	Jedi", but neither .qst carries a Jedi requirement -- only the level -- so
	none is imposed here. If that gate is wanted it is one line in
	getInitialScreen; it is flagged rather than invented.
]]

obi_wan_conv_handler = conv_handler:new {}

obi_wan_conv_handler.screenPlayName = "kenobiSpineScreenPlay"

-- The four send-offs, all firing 'talkedKenobi1'.
obi_wan_conv_handler.sendScreens = {
	send_a = true,  -- s_287
	send_b = true,  -- s_289
	send_c = true,  -- s_326
	send_d = true,  -- s_340
}

-- The four chamber farewells, all firing 'talkedKenobi2'.
obi_wan_conv_handler.goluckScreens = {
	goluck_a = true,  -- s_277
	goluck_b = true,  -- s_285
	goluck_c = true,  -- s_299
	goluck_d = true,  -- s_307
}

-- The two "now hurry" screens at the entrance stone, firing 'talkedKenobi3'.
obi_wan_conv_handler.hurryScreens = {
	hurry_a = true,  -- s_170
	hurry_b = true,  -- s_172
}

-- The two farewells that hand over som_kenobi_main_quest_1.
obi_wan_conv_handler.questScreens = {
	give_quest_a = true,  -- s_270
	give_quest_b = true,  -- s_351
}

--------------------------------------------------------------------------------
-- The man at the chamber entrance. He has nothing to say until the player has
-- been sent there, and nothing after Sinistro is dead but s_333.
--------------------------------------------------------------------------------

function obi_wan_conv_handler:getChamberScreen(pPlayer, convoTemplate)
	local stage = kenobiSpineScreenPlay:getStage(pPlayer)

	if (stage >= kenobiSpineScreenPlay.STAGE_DONE) then
		-- s_333, "You're a hero unlike any others, my young friend."
		return convoTemplate:getScreen("hero")
	elseif (stage == kenobiSpineScreenPlay.STAGE_LAIR) then
		-- already told how to get in, and back out here again. s_313.
		return convoTemplate:getScreen("ready_enter")
	elseif (stage == kenobiSpineScreenPlay.STAGE_ENTRANCE) then
		-- s_162, the meeting the send-off promised.
		return convoTemplate:getScreen("chamber_meet")
	end

	-- s_356, "My business is not with you, %TU. Please step aside."
	return convoTemplate:getScreen("aside")
end

--------------------------------------------------------------------------------
-- The man on the shoreline. Prologue first, then the spine.
--------------------------------------------------------------------------------

function obi_wan_conv_handler:getShoreScreen(pPlayer, convoTemplate)
	local stage = kenobiSpineScreenPlay:getStage(pPlayer)

	-- prologue -- som_obi_wan_kenobi.stf
	if (stage == kenobiSpineScreenPlay.STAGE_START) then
		return convoTemplate:getScreen("pro_greeting")
	elseif (stage == kenobiSpineScreenPlay.STAGE_MINER) then
		-- s_19, "I've given you your task, young Jedi."
		return convoTemplate:getScreen("pro_progress")
	elseif (stage == kenobiSpineScreenPlay.STAGE_REPORT) then
		-- s_20, "Have you done as I asked, young Jedi?"
		return convoTemplate:getScreen("pro_return")
	end

	-- spine -- som_kenobi_obi_wan.stf
	if (stage == kenobiSpineScreenPlay.STAGE_WEST) then
		if (CreatureObject(pPlayer):getLevel() < kenobiSpineScreenPlay.requiredLevel) then
			return convoTemplate:getScreen("pro_nothing")
		end

		return convoTemplate:getScreen("greeting")
	elseif (stage == kenobiSpineScreenPlay.STAGE_HUNT) then
		-- s_227, with s_350 as the shipped way out of a lost trail.
		return convoTemplate:getScreen("busy")
	elseif (stage == kenobiSpineScreenPlay.STAGE_SHARD_SPARED) then
		return convoTemplate:getScreen("shard_spared")
	elseif (stage == kenobiSpineScreenPlay.STAGE_SHARD_KILLED) then
		return convoTemplate:getScreen("shard_killed")
	elseif (stage == kenobiSpineScreenPlay.STAGE_CHAMBER) then
		if (kenobiSpineScreenPlay:sparedTheHermit(pPlayer)) then
			return convoTemplate:getScreen("chamber_a")
		end

		return convoTemplate:getScreen("chamber_b")
	elseif (stage == kenobiSpineScreenPlay.STAGE_ENTRANCE or stage == kenobiSpineScreenPlay.STAGE_LAIR) then
		-- he is supposed to be at the stone by now. s_335, "Are you ready to
		-- pick up where we left off?", with s_341 pointing back at the lair.
		return convoTemplate:getScreen("resume")
	elseif (stage >= kenobiSpineScreenPlay.STAGE_DONE) then
		return convoTemplate:getScreen("hero")
	end

	-- STAGE_CONDUITS: the three enclaves are his errand, not the player's to
	-- ask about. s_356.
	return convoTemplate:getScreen("aside")
end

function obi_wan_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	if (kenobiSpineScreenPlay:getKenobiRole(pNpc) == "chamber") then
		return self:getChamberScreen(pPlayer, convoTemplate)
	end

	return self:getShoreScreen(pPlayer, convoTemplate)
end

function obi_wan_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()
	local pClonedScreen = screen:cloneScreen()

	if (screenID == "pro_task") then
		-- s_26 sends him after the dying miner. som_obi_wan_signal_1.
		kenobiSpineScreenPlay:giveMinerTask(pPlayer)

	elseif (screenID == "pro_west") then
		-- s_28. 'returnToObiWan' -- closes som_obi_wan_signal_2.
		kenobiSpineScreenPlay:finishPrologue(pPlayer)

	elseif (self.questScreens[screenID]) then
		-- som_kenobi_main_quest_1: find the hermit, via the Mensix network.
		kenobiSpineScreenPlay:giveHermitHunt(pPlayer)

	elseif (screenID == "research") then
		-- s_352, "you will have to perform another search for him".
		kenobiSpineScreenPlay:restartHermitSearch(pPlayer)

	elseif (self.sendScreens[screenID]) then
		-- 'talkedKenobi1' -- arms the three conduits.
		kenobiSpineScreenPlay:talkedKenobi1(pPlayer)

	elseif (self.goluckScreens[screenID]) then
		-- 'talkedKenobi2' -- waypoint to the entrance stone.
		kenobiSpineScreenPlay:talkedKenobi2(pPlayer)

	elseif (self.hurryScreens[screenID]) then
		-- 'talkedKenobi3' -- the way into the lair opens.
		kenobiSpineScreenPlay:talkedKenobi3(pPlayer)
	end

	return pClonedScreen
end
