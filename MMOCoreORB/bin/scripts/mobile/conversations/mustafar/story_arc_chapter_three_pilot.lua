-- scripts/mobile/conversations/mustafar/story_arc_chapter_three_pilot.lua
--
-- Master Pilot Menddle -- the Mon Cal pilot who flies the player into the
-- volcano crater for som_story_arc_chapter_three_03, "Talk to a Pilot".
-- Runs on storyArcChaptersScreenPlay.
--
-- THIS TREE IS NOT INFERRED.  It is SOE's own conversation script,
-- conversation/story_arc_chapter_three_pilot, read node for node, and the
-- strings are the shipped rows of
-- string/en/conversation/story_arc_chapter_three_pilot.stf.  The script also
-- supplies his display name -- setName(self, "Master Pilot Menddle") -- which is
-- why miner_pilot.lua no longer carries the descriptive "Miner Pilot".
--
-- SOE's greeting dispatch is three conditions, first match wins:
--
--   travelToVolcanoTwo   the flight task/quest is COMPLETE   s_7
--   travelToVolcano      the flight task is ACTIVE           s_16
--   default                                                  s_42
--
-- s_16 and s_42 are the same speech cut at different lengths -- s_42 is the full
-- sales pitch and s_16 is the version the player cuts off.  They are two shipped
-- rows, not a duplicate.  So are s_31 and s_36: SOE typed "than" in one and
-- "then" in the other, and both are reproduced as shipped.
--
-- ============================ DEVIATION ============================
-- Live does not fight HK-47 in the open world.  Both of SOE's conditions call
-- instance.flagPlayerForInstance(player, "mustafar_volcano"), the departure
-- action calls instance.requestInstanceMovement, and the script's OnAttach sets
-- space_dungeon.ticket.dungeon = "volcano_battlefield".  The crater was an
-- instanced battlefield Menddle flew you into.
--
-- Core3 has no mustafar_volcano instance and no space-dungeon ticketing for this
-- planet, so storyArcChaptersScreenPlay leaves HK-47 standing in the open world
-- and hands out a waypoint instead of a flight.  The CONVERSATION is faithful;
-- where Menddle says "let's fly", the player is not moved.  Stated, not hidden.
-- ===================================================================
--
-- Task mapping onto storyArcChaptersScreenPlay:
--   volcano_arena_one = STAGE_FIND_PILOT (22); completing it is STAGE_KILL_HK47
--   (23) and beyond, which is what the "already been" screen tests.
--
-- TWO SIDE EFFECTS, both on the same two screens, exactly where SOE put them:
--   s_29 -> s_31   sendFirstSignal, sendGroupToVolcano
--   s_34 -> s_36   sendFirstSignal, sendGroupToVolcano
--
-- sendFirstSignal is GROUP-AWARE on live: if the player is grouped it walks
-- group.getPCMembersInRange(player, 80f) and sends volcano_arena_pilot to every
-- member with the task active, so a whole group is advanced by one person
-- talking.  The screenplay reproduces that; see sendPartyToVolcano.
--
-- Animations are SOE's.  animation is the NPC's and playerAnimation the
-- player's (ConversationScreen.h:203-208).

story_arc_chapter_three_pilot = ConvoTemplate:new {
	initialScreen = "busy",
	templateType = "Lua",
	luaClassHandler = "pilot_conv_handler",
	screens = {}
}

-- =====================================================================
-- The long way round, first time.  s_16 -> s_18 -> s_20 -> s_22 -> s_24
-- -> s_26 -> s_28, then the branch: s_34 flies, s_38 waits for the group.
-- Every step is a single option -- SOE walks the player through the pitch
-- rather than offering a choice until the very end.
-- =====================================================================

story_arc_chapter_three_pilot_greeting = ConvoScreen:new {
	id = "greeting",
	animation = "pose_proudly",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_16", -- Menddle is my name and flying is my game. If you need to get somewhere in a hurry, I am the...
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_pilot:s_18", "destination"}, -- That's great but I am in a hurry.
	}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_greeting)

story_arc_chapter_three_pilot_destination = ConvoScreen:new {
	id = "destination",
	animation = "salute1",
	playerAnimation = "wave_on_dismissing",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_20", -- Well then, let's not waste anytime with idle chitchat. Just tell me where you need to go and leave the rest to me.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_pilot:s_22", "crater"}, -- I need to be dropped off in the crater of that volcano.
	}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_destination)

story_arc_chapter_three_pilot_crater = ConvoScreen:new {
	id = "crater",
	animation = "snap_finger1",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_24", -- Volcano crater flight, eh? Lava shooting up all around us. Intense heat. High risk factor. That will be no problem at all. One thing I learned about flying around this rock is that if you come in low, the heat from the lava helps keep your ship up...most of the time.
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_pilot:s_26", "depart"}, -- That's great. But I really need to get up there...now!
	}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_crater)

story_arc_chapter_three_pilot_depart = ConvoScreen:new {
	id = "depart",
	animation = "slow_down",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_28", -- Say no more...say no more. We can leave at once. Hold onto your hat...or whatever. This is going to be a bumpy ride. Is your party ready to go?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_pilot:s_34", "fly"},  -- Yep, let's fly.
		{"@conversation/story_arc_chapter_three_pilot:s_38", "wait"}, -- Not yet.
	}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_depart)

-- ACTIONS sendFirstSignal, sendGroupToVolcano
story_arc_chapter_three_pilot_fly = ConvoScreen:new {
	id = "fly",
	animation = "celebrate",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_36", -- That is what I like to hear. Nothing better then a nice crater flight.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_fly)

story_arc_chapter_three_pilot_wait = ConvoScreen:new {
	id = "wait",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_40", -- Well, then we better wait until they all show.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_wait)

-- =====================================================================
-- Been up there already.  s_7 -> s_29 flies, s_30 does not.  Menddle skips
-- the whole sales pitch on a return trip.
-- =====================================================================

story_arc_chapter_three_pilot_ready = ConvoScreen:new {
	id = "ready",
	animation = "snap_finger1",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_7", -- You want to go back? Are you ready to go now?
	stopConversation = "false",
	options = {
		{"@conversation/story_arc_chapter_three_pilot:s_29", "ready_go"},   -- I am ready.
		{"@conversation/story_arc_chapter_three_pilot:s_30", "ready_wait"}, -- Not yet.
	}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_ready)

-- ACTIONS sendFirstSignal, sendGroupToVolcano
story_arc_chapter_three_pilot_ready_go = ConvoScreen:new {
	id = "ready_go",
	animation = "thumb_up",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_31", -- That is what I like to hear. Nothing better than a nice crater flight.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_ready_go)

story_arc_chapter_three_pilot_ready_wait = ConvoScreen:new {
	id = "ready_wait",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_32", -- Just let me know when you want to go back.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_ready_wait)

-- =====================================================================
-- Everyone else gets the full pitch and nothing else.  s_42, a bark, and
-- the template's initialScreen.
-- =====================================================================

story_arc_chapter_three_pilot_busy = ConvoScreen:new {
	id = "busy",
	animation = "pound_fist_chest",
	leftDialog = "@conversation/story_arc_chapter_three_pilot:s_42", -- Menddle is my name and flying is my game. If you need to get somewhere in a hurry, I am the man...well, Mon Cal, anyways. Don't be fooled into letting someone else fly you around this rock. No job is too hard; no location too unattainable.
	stopConversation = "true",
	options = {}
}
story_arc_chapter_three_pilot:addScreen(story_arc_chapter_three_pilot_busy)

addConversationTemplate("story_arc_chapter_three_pilot", story_arc_chapter_three_pilot)
