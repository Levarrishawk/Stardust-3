-- scripts/mobile/conversations/mustafar/story_arc_chapter_three_scout.lua
--
-- Scout Olon Lono -- the scout who sends the player into the droid battlefield
-- for som_story_arc_chapter_three_01, "Defeat the Droid Army".
-- Runs on storyArcChaptersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/story_arc_chapter_three_scout, read node for node, and the
-- strings are the shipped rows of
-- string/en/conversation/story_arc_chapter_three_scout.stf.  The script also
-- supplies his display name -- setName(self, "Scout Olon Lono") -- which is why
-- must_scout.lua no longer carries the placeholder "must_scout".
--
-- SOE's greeting dispatch is three conditions, first match wins:
--
--   readyToEnterAgain   flagged, or the battle task/quest is COMPLETE   s_7
--   readyToEnterOne     the battle task is ACTIVE                       s_15
--   default                                                             s_34
--
-- godModeWalkAround (isGod) is DEFINED in the shipped script and called from
-- nowhere -- zero call sites.  It is authored-then-abandoned code, not a gate
-- this reconstruction dropped, and it is recorded here so a later reader does
-- not go looking for it.
--
-- ============================ DEVIATION ============================
-- Live does not stage this fight in the open world.  Both of SOE's conditions
-- call instance.flagPlayerForInstance(player, "mustafar_droid_army") and the
-- accept action calls instance.requestInstanceMovement -- and the script's
-- OnAttach sets space_dungeon.ticket.dungeon = "droid_battlefield".  The droid
-- army was an instanced battlefield the scout teleported you into.
--
-- Core3 has no mustafar_droid_army instance and no space-dungeon ticketing for
-- this planet, so storyArcChaptersScreenPlay stages the army in the open world
-- at the scout's own post instead.  The CONVERSATION is faithful; where it says
-- "let's go", the player is not moved -- the army is spawned around them.  That
-- is the whole of the deviation and it is stated rather than hidden.
-- ===================================================================
--
-- Task mapping onto storyArcChaptersScreenPlay:
--   mustafar_droidarmy_battle = STAGE_DROID_ARMY (16).
--   "flagged for the instance" has no equivalent, so the repo uses its own
--   armyReleased flag: once the army is out, the player gets the "want to head
--   back in?" screen, which is what a flagged player got on live.
--
-- ONE SIDE EFFECT, on two screens, exactly where SOE put it:
--   s_9  -> s_11   sendGroupToBattlefield
--   s_23 -> s_25   sendGroupToBattlefield
--
-- Animations are SOE's.  animation is the NPC's and playerAnimation the
-- player's (ConversationScreen.h:203-208); where SOE fires the player's on
-- selecting the option and the NPC's on the reply, both land on the resulting
-- screen because there is no earlier screen to hang them on.

story_arc_chapter_three_scout = ConvoTemplate:new {
	initialScreen = "busy",
	templateType = "Lua",
	luaClassHandler = "scout_conv_handler",
	screens = {}
}

-- =====================================================================
-- First briefing.  s_15 -> s_17 -> s_19, then the branch: s_23 goes in,
-- s_27 goes looking for a group first.
-- =====================================================================

story_arc_chapter_three_scout_briefing = ConvoScreen:new {
	id = "briefing",
	animation = "explain",
	leftDialog = "@conversation/story_arc_chapter_three_scout:s_15", -- The droids are massing up ahead. They look like they are getting ready to make a strike at the facility, but they are being held up in the pass. A few of the boys got some weapons and are doing their best to slow their advance. We even managed to install a shield generator. I would bet everything that the droids are going to strike there first.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_scout:s_17", "orders"}, -- So what do you need me to do?
	}
}
story_arc_chapter_three_scout:addScreen(story_arc_chapter_three_scout_briefing)

story_arc_chapter_three_scout_orders = ConvoScreen:new {
	id = "orders",
	animation = "pound_fist_palm",
	leftDialog = "@conversation/story_arc_chapter_three_scout:s_19", -- Get in there and help our boys guard that shield generator. If that goes down, there isn't a whole lot that stands between the droids and us.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_scout:s_23", "accept"},   -- Ok, I am ready to face them down.
		{"@conversation/story_arc_chapter_three_scout:s_27", "get_help"}, -- Maybe I should go get some help?
	}
}
story_arc_chapter_three_scout:addScreen(story_arc_chapter_three_scout_orders)

-- ACTION sendGroupToBattlefield
story_arc_chapter_three_scout_accept = ConvoScreen:new {
	id = "accept",
	animation = "nod",
	leftDialog = "@conversation/story_arc_chapter_three_scout:s_25", -- Good. Those droids mean business, so watch your back and keep that shield generator safe. Let's move.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_scout:addScreen(story_arc_chapter_three_scout_accept)

story_arc_chapter_three_scout_get_help = ConvoScreen:new {
	id = "get_help",
	animation = "nod",
	leftDialog = "@conversation/story_arc_chapter_three_scout:s_32", -- Yeah, why don't you do that. But remember, our boys cannot slow them down for very much longer.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_scout:addScreen(story_arc_chapter_three_scout_get_help)

-- =====================================================================
-- Coming back.  s_7 -> s_9 goes in again, s_21 does not.  On live this is
-- the screen a player already flagged for the instance saw; here it is the
-- screen a player who has already released the army sees.
-- =====================================================================

story_arc_chapter_three_scout_return = ConvoScreen:new {
	id = "return",
	leftDialog = "@conversation/story_arc_chapter_three_scout:s_7", -- You want to head back in?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_scout:s_9", "return_yes"}, -- Yes.
		{"@conversation/story_arc_chapter_three_scout:s_21", "return_no"}, -- Nope.
	}
}
story_arc_chapter_three_scout:addScreen(story_arc_chapter_three_scout_return)

-- ACTION sendGroupToBattlefield
story_arc_chapter_three_scout_return_yes = ConvoScreen:new {
	id = "return_yes",
	animation = "nervous",
	playerAnimation = "nod",
	leftDialog = "@conversation/story_arc_chapter_three_scout:s_11", -- You are braver than I would have thought. Alright, let's go. And remember: keep them from destroying that generator.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_scout:addScreen(story_arc_chapter_three_scout_return_yes)

story_arc_chapter_three_scout_return_no = ConvoScreen:new {
	id = "return_no",
	leftDialog = "@conversation/story_arc_chapter_three_scout:s_22", -- Yeah, it is a battleground in there.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_scout:addScreen(story_arc_chapter_three_scout_return_no)

-- =====================================================================
-- Everyone else.  s_34, a bark, and the template's initialScreen.
-- =====================================================================

story_arc_chapter_three_scout_busy = ConvoScreen:new {
	id = "busy",
	animation = "shush",
	leftDialog = "@conversation/story_arc_chapter_three_scout:s_34", -- Shhhh. I am on a very important mission and can't be disturbed. If you are looking to help out, why don't you go talk to someone back at the facility? We probably could use the hand.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_scout:addScreen(story_arc_chapter_three_scout_busy)

addConversationTemplate("story_arc_chapter_three_scout", story_arc_chapter_three_scout)
