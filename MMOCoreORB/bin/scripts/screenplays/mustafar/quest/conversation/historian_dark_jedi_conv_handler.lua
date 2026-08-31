--[[
	The dark Jedi ambusher at the historian's camp -- conversation handler for
	som_kenobi_historian_2.

	The tree is in mobile/conversations/mustafar/som_kenobi_historian_dark_jedi.lua,
	which carries the note on why there is no tree to speak of and what the mobile
	had backwards.

	This is the whole conversation, both branches of it:

	    condition_playerJedi   npc belly_laugh    action_attack  s_4
	    _defaultCondition      npc point_forward  action_attack  s_6

	Live runs them in that order, and inside each it runs the animation, THEN the
	attack, THEN the line. That order is kept: getInitialScreen animates and starts
	the fight, and Core3 sends the screen afterwards
	(ConversationObserverImplementation.cpp:129-136).

	Both branches attack. There is no way to hail her and walk away, and no option
	anywhere for the player to say anything back.

	WHY THIS IS IN getInitialScreen AND NOT runScreenHandlers

	Both run before the line reaches the player, so either would work. The animation
	and the screen are the same decision here -- one condition picks both -- so
	splitting them across two functions would mean testing force sensitivity twice
	and keeping the two tests in step by hand. som_kenobi_serpent_thief and
	som_kenobi_cursed_shard_sucker already play their opening animations in
	getInitialScreen for the same reason.

	NO RE-HAIL

	Live's OnStartNpcConversation opens with

	    if (ai_lib.isInCombat(npc) || ai_lib.isInCombat(player)) return SCRIPT_OVERRIDE;

	so once the fight is on she cannot be hailed again. Core3 has no equivalent
	early-out -- the window is already open by the time any Lua runs -- so the
	CONVERSABLE option bit is cleared instead, which takes the radial away entirely.
	Same effect, earlier. serpent_thief_conv_handler:runScreenHandlers does this on
	its own fight screens for the same reason.

	Live also clears the condition in OnIncapacitated. Nothing is needed for that
	here: Core3 will not converse with a dead agent (AiAgentImplementation.cpp:4088
	returns false on isDead), and she is already unconversable from the moment she
	swings.
]]

historian_dark_jedi_conv_handler = conv_handler:new {}

historian_dark_jedi_conv_handler.screenPlayName = "historianScreenPlay"

function historian_dark_jedi_conv_handler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	-- Live's condition_playerJedi. First match wins, so this is tested first.
	if (self:canUseTheForce(pPlayer)) then
		CreatureObject(pNpc):doAnimation("belly_laugh")
		self:ambush(pPlayer, pNpc)

		return convoTemplate:getScreen("taunt_sensitive")
	end

	CreatureObject(pNpc):doAnimation("point_forward")
	self:ambush(pPlayer, pNpc)

	return convoTemplate:getScreen("taunt")
end

-- Live's action_attack: startCombat(npc, player). She is not AGGRESSIVE -- see the
-- tree header for why she must not be -- so the fight has to be started for her, and
-- the bit goes on as well as the defender or she drops the player the moment he
-- breaks line of sight and goes back to being a meditating statue. Same two calls,
-- same reason, as serpentShardScreenPlay:talkedThief.
function historian_dark_jedi_conv_handler:ambush(pPlayer, pNpc)
	if (pPlayer == nil or pNpc == nil) then
		return
	end

	-- Stands in for live's isInCombat guard. See NO RE-HAIL.
	CreatureObject(pNpc):clearOptionBit(CONVERSABLE)

	TangibleObject(pNpc):setPvpStatusBit(AGGRESSIVE)
	AiAgent(pNpc):setDefender(pPlayer)
end

-- Live's condition_playerJedi is jedi.isForceSensitive(player) -- force sensitive, NOT
-- Padawan. force_title_jedi_rank_01 is Padawan and is strictly narrower:
-- village_jedi_manager.lua:113 will not grant rank_01 until the character has 24
-- force-sensitive skills, and force_title_jedi_novice is what is awarded the moment a
-- character becomes force sensitive at all (village_jedi_manager.lua:59, fs_intro.lua:373).
-- helper_droid.lua:291 is the in-repo precedent for the novice test.
--
-- Nothing is gated on this, unlike everywhere else in the arc -- it only picks which
-- taunt she uses. Both end in the same fight.
function historian_dark_jedi_conv_handler:canUseTheForce(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	return CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")
end
