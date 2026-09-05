--[[
The cursed shard  --  som_kenobi_cursed_shard_1 and som_kenobi_cursed_shard_2

SOURCE OF RECORD

quest/som_kenobi_cursed_shard_1.qst and quest/som_kenobi_cursed_shard_2.qst in the
client TREs. Every location and radius, every message box title and body, both
encounter creature counts and distances and all four timer ranges are quoted from
them. The level gate is NOT the .qst's -- see THE LEVEL GATE. The two conversation
trees are
mobile/conversations/mustafar/som_kenobi_menth_paul.lua and
som_kenobi_cursed_shard_sucker.lua.

Both quests are run by this one screenplay because _1's last task is
"Immediately Complete Quest, grantQuestOnComplete = quest/som_kenobi_cursed_shard_2":
they are one continuous arc with a single carried object, and splitting them would
mean two screenplays sharing one player's shard. reunite_shard.lua covers its three
.qst files the same way.

THE SHAPE OF IT

_1 has no directed step at all. Both of its Go to Location tasks are isVisible
false with createWaypoint 0, and its only visible task is "What to do?", which has
no location -- the player is told to hold onto the shard and nothing else. The two
locations are ambushes that trip whenever the player happens to wander into them,
which is what SOE's own task names for them say: "Mysterious Event One" and
"Mysterious Event Two". So _1 hands out no waypoint, on purpose.

_2 is the opposite: its two branches are both isVisible true, and Branch A carries
a location. That one does get a waypoint, for the reason under PROGRESS TRACKING.

The two branches of _2 are alternatives -- destroy the shard in the volcano, or
palm it off on someone else -- and either completes the quest.

THE LEVEL GATE  --  61, not 75

Both .qst files carry [list] Level 75 and an earlier revision quoted it. The giver
does not enforce it. Menth Paul's server-side conversation gates his opening screen
on a condition of its own, and that condition is a level test against 60: the offer
screen s_110 is only reached when the player's level is greater than 60. So the real
minimum is 61 and requiredLevel below says 61.

The condition is named levelTooLow and it returns TRUE for the players who ARE high
enough. The name is inverted relative to what it does. Read the body, not the name --
this trips anyone who greps for the gate and stops at the identifier.

The .qst Level field is a client-side display value. Where it and the server-side
conversation disagree, the conversation is what the player experiences, so that is
what this tree honours.

WHERE THE NPCs STAND  --  live positions, recovered

Both are creature templates (object/mobile/som/som_kenobi_menth_paul.iff,
som_kenobi_sucker.iff), not snapshot nodes, so their absence from every .ws is
expected: in live they were server-side spawns. An earlier revision read that as
"nothing ships either position" and placed both by reasoning. That was wrong, and it
was wrong in a way worth recording, because the two errors are different.

The facility's dungeon spawn table is the position. Both stand INSIDE the Mensix
mining facility, in medium_room_01 -- the cantina, cell 12112226 -- not outdoors:

  Menth Paul    (-73.6, 10.8, 53.8) facing -90
  the sucker    (-75.7, 10.8, 40.4) facing -95

Menth Paul's error was small and the reasoning behind it was sound. His opening line
is s_110 "Please, help me... I have to get off this planet" and the player's reply is
s_111 "Why don't you just take the shuttle then friend?", which only works where
players arrive; Mensix is the only entry in mustafar's planetTravelPoints
(scripts/managers/planet/planet_manager.lua:726). That got him to the right
settlement. It then put him on the terrain shelf outside at (-2506, 1652) instead of
in the cantina thirteen metres in. Right building, wrong side of the door.

The sucker's error was large. He was placed at the smuggler outpost in the far
north-east, by snapshot node 12110169 floor_travel_01 (185.87, 207.77, 4250.08),
roughly 2.7 km from where he actually stands. The argument for it read his
socialGroup thug, his STALKER creatureBitmask, his ATTACKABLE + ENEMY flags and his
line s_8 "I have job to do", and concluded a hostile with a job belongs at an
outpost rather than in the hub every player walks through. Every one of those facts
is true. The conclusion was still wrong -- SOE put him in the cantina anyway. This
is the lesson the whole position sweep turns on: a chain of correct observations
about a character is not evidence about that character's coordinates.

Both creature templates had an empty conversationTemplate and are wired by this
wave, the same way pei_yi carries "som_pei_yi".

Live names the second one som_kenobi_cursed_shard_sucker. This tree keeps
som_kenobi_sucker, which is the registered template with the shipped appearance.

One consequence of moving them indoors: the outdoor placements resolved height with
getWorldFloor, which is right for terrain and meaningless in a cell. Cell-local
height is the table's own 10.8, the floor every NPC in that room stands on.

THE VOLCANO BRIDGE  --  corroboration, not invention

_2 task 1's journal text says "there's a bridge goes across the river of fresh
molten lava descending the volcano from the north". Snapshot node 12111801,
must_bridge_rock_arch_120m, sits at (-2840.68, 28.41, 4316.05) -- 7.3 m from the
task's own waypoint, inside its Radius 10 -- and node 12111459,
must_lava_falls_ribbon_25x50, sits 130 m north-west of it. The object SOE described
is really there, so the .qst coordinates are used as they stand.

THE CREATURE NAMES

The .qst calls the ambushers "som_lava_flea_smoldering" and "som_tulrus". The
templates that shipped in this tree are registered as "lava_flea_smoldering" and
"tulrus" (mobile/custom_content/som/serverobjects.lua lines 46 and 147). Same
creatures; SOE's client-side quest files carry a som_ prefix our mobile scripts do
not. spawnMobile needs the repo name.

PROGRESS TRACKING

Neither quest has a row in datatables/player/quests.iff -- the table the server
loads is stardust_03.tre's, which wins the TreFiles order in conf/config.lua, and
its only Mustafar rows are the 45 exploration markers. So there is no journal.
Progress lives in persistent screenplay data on the player's ghost, and the
journalEntryDescription lines go out as system messages and as the waypoint
description instead, which is where the player would otherwise have read them.

That is also why Branch A gets a waypoint even though the task says
createWaypoint 0: on live the journal entry carried the location, and with no
journal the waypoint is the only thing left that can.

The [list] block says allowRepeats true on both, but there is no abandon path
anywhere in either .qst or in Menth Paul's strings -- he refuses to take the shard
back (s_139, s_140) -- so nothing here resets a player mid-arc.

THE REWARD  --  substituted

Both Reward tasks award Bank Credits 0 and Experience Amount 0, so the item is the
whole reward. The stored Experience Amount 0 is real; live still paid, because the
server recomputed from quest_experience (see mustafar_quest_xp.lua). Both name
lootCount 1 / lootName item_tow_gloves_microsensory_02_01,
a live server-side static-item name rather than an object template. The name
resolves to "Microsensory Mesh Gloves" in string/en/static_item_n.stf, but an
exhaustive sweep of every shipped shared_*.iff finds no object template carrying
that objectName, so granting the live item would mean authoring an object. As
with every other TOW reward in this arc it can only be matched by description.

What the .qst says it is: task 11's message box, "It looks to be a pair of strange
alien gloves!"

What this tree has for that: object/tangible/tcg/series8/wearable_exogorth_gloves.iff.
It is a registered server template
(object/custom_content/tangible/tcg/series8/wearable_exogorth_gloves.lua, included
from that folder's serverobjects.lua at line 39), and its appearance,
shared_wearable_exogorth_gloves.iff, ships in mtg_patch_022.tre. An exogorth is
a Star Wars alien, so "strange alien gloves" describes them literally. They exist,
which the live-named item does not.

Handed over with giveItem() into the player's inventory, which creates the object
for real -- deliberately not addRewardedSchematic, which fails closed when the path
is not in scripts/managers/crafting/schematics.lua and would silently grant nothing
(the defect hidden_treasure.lua's reward had to be corrected for).

To restore the live item later, only rewardItem below changes.

THE PRICE OF THE SHARD

Not here. The .qst does not model the sale at all; the 1000 and 500 credit prices
live in Menth Paul's string table and are settled in menth_paul_conv_handler, which
explains them.

WHAT IS NOT MODELLED

_1 task 0 and _2 task 0 are Show Message Box tasks that fire the instant each quest
is granted. Both are shown here, so the player gets "Cursed?" as Menth Paul hands
the shard over and "Too much" when the brooding timer turns _1 into _2.

The shard itself is never an inventory object: no task in either quest is a
Retrieve Item, and no shard template ships in this arc. It is a stage number, which
is exactly what it is in the .qst.

_2's Wait for Signal "gaveAwayShard" is the Whiphid conversation, not a task; see
cursed_shard_sucker_conv_handler.
--]]

local JournalMirror = require("managers.quest.journal_mirror")

cursedShardScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "cursedShardScreenPlay",

	-- The gate the giver actually enforces, not the .qst's; see THE LEVEL GATE.
	requiredLevel = 61,

	-- Live positions; see WHERE THE NPCs STAND. Both are cell-local coordinates
	-- inside the Mensix cantina, medium_room_01 = cell 12112226.
	menthPaul = {
		template = "som_kenobi_menth_paul",
		cell = 12112226,
		x = -73.6,
		z = 10.8,
		y = 53.8,
		heading = -90,
	},

	sucker = {
		template = "som_kenobi_sucker",
		cell = 12112226,
		x = -75.7,
		z = 10.8,
		y = 40.4,
		heading = -95,
	},

	--[[ _1: the two ambushes. Both Go to Location, both Radius 300, both
	     isVisible false with no waypoint -- SOE's "Mysterious Event One" and
	     "Mysterious Event Two". Creature names are the repo's, not the .qst's;
	     see THE CREATURE NAMES. ]]
	events = {
		{
			key = "event1",                                        -- .qst _1 task 6 taskName
			x = -4100, y = 1257, radius = 300,                     -- task 3
			delayMin = 10, delayMax = 20,                          -- task 6 Min/Max Time
			template = "tulrus", count = 3,                        -- task 7, Count 3
			minDistance = 35, maxDistance = 50,                    -- task 7
			title = "A bad feeling",                               -- task 4
			text = "Suddenly the crystal that you were given by Menth Paul a while ago springs to life. It's emitting a sharp sound that pierces your ears for a few seconds... Then it goes quiet again, like nothing had ever happened.",
		},
		{
			key = "event2",                                        -- .qst _1 task 8 taskName
			x = -3100, y = 4966, radius = 300,                     -- task 2
			delayMin = 5, delayMax = 15,                           -- task 8 Min/Max Time
			template = "lava_flea_smoldering", count = 2,          -- task 9, Count 2
			minDistance = 35, maxDistance = 50,                    -- task 9
			title = "Is it dangerous?",                            -- task 5
			text = "Suddenly your backpack becomes really warm. As you take it off and look inside, you see the that the crystal Menth Paul gave you earlier is glowing red, sizzling and melting things around it. When you cover your hands and reach for it, it all of a sudden stops glowing and is now cold to the touch, like what you just saw had never happened.",
		},
	},

	-- .qst _1 task 11: Timer Min 180 / Max 560, then _1 completes and grants _2.
	broodMin = 180,
	broodMax = 560,

	--[[ _2 Branch A: the volcano bridge. Tasks 1 and 4 name the same point with
	     Radius 200 and Radius 10 -- the approach and the bridge itself. ]]
	volcano = { x = -2848, y = 4316, approachRadius = 200, bridgeRadius = 10 },

	-- .qst _2 task 6: Timer Min 15 / Max 25 between the toss and the gloves.
	glovesMin = 15,
	glovesMax = 25,

	-- Substituted; see THE REWARD.
	rewardItem = "object/tangible/tcg/series8/wearable_exogorth_gloves.iff",

	STAGE_SHARD = 1,
	STAGE_BROOD = 2,
	STAGE_DISPOSE = 3,
	STAGE_DONE = 4,

	-- Filled in by start(); these object ids are only known once the objects exist.
	eventByAreaID = {},
	approachAreaID = 0,
	bridgeAreaID = 0,
	npcIDByTemplate = {},
}

-- JOURNAL MIRROR (J-3, 2026-09-04): stage -> client journal task bits, from the SOE task tree in
-- this header and scratch/mustafar-stage-task-map.md §cursed_shard. Screenplay data stays truth.
cursedShardScreenPlay.journalMap = {
	[1] = { quest = "som_kenobi_cursed_shard_1", complete = {0}, activate = {10} }, -- 1→_1 t10 "What to do?"
	[2] = { quest = "som_kenobi_cursed_shard_1", complete = {10}, activate = {11} }, -- 2→_1 t11 brood Timer
	[3] = { -- 3→_1 t12 complete + _2 granted; both branches live
		{ quest = "som_kenobi_cursed_shard_1", complete = {11, 12}, finish = true },
		{ quest = "som_kenobi_cursed_shard_2", complete = {0}, activate = {1, 2, 4, 11} }, -- _2 t1/t4/t11 or t2
	},
	[4] = { quest = "som_kenobi_cursed_shard_2", finish = true }, -- 4→_2 t7/t8 or t9/t10; both branches share STAGE_DONE
}

registerScreenPlay("cursedShardScreenPlay", true)

function cursedShardScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnQuestNpcs()
		self:spawnEventAreas()
		self:spawnVolcanoAreas()
	end
end

function cursedShardScreenPlay:spawnQuestNpcs()
	local npcs = { self.menthPaul, self.sucker }

	for i = 1, #npcs do
		local npc = npcs[i]
		-- Cell-local, so no getWorldFloor: npc.z is the cantina floor the table
		-- gives, and a terrain sample inside a building means nothing.
		local pNpc = spawnMobile("mustafar", npc.template, 0, npc.x, npc.z, npc.y, npc.heading, npc.cell)

		if (pNpc == nil) then
			print("cursedShardScreenPlay: failed to spawn " .. npc.template .. "; that half of the quest is unreachable")
		else
			-- Neither of these two has a snapshot node, so nothing else in the world
			-- knows an id to find them by; keep the one the spawn just handed back.
			-- Same reason reunite_shard.lua keeps legByAreaID.
			self.npcIDByTemplate[npc.template] = SceneObject(pNpc):getObjectID()
		end
	end
end

function cursedShardScreenPlay:spawnEventAreas()
	for i = 1, #self.events do
		local event = self.events[i]
		local z = getWorldFloor(event.x, event.y, "mustafar")
		local pArea = spawnActiveArea("mustafar", "object/active_area.iff", event.x, z, event.y, event.radius, 0)

		if (pArea == nil) then
			print("cursedShardScreenPlay: failed to spawn the area for " .. event.key .. "; that event cannot fire")
		else
			self.eventByAreaID[SceneObject(pArea):getObjectID()] = event
			createObserver(ENTEREDAREA, "cursedShardScreenPlay", "notifyEnteredEventArea", pArea)
		end
	end
end

-- The two rings are concentric, so a player walking in crosses the 200 boundary
-- 190 m before the 10 one. The bridge handler still checks the approach flag
-- rather than trusting that ordering.
function cursedShardScreenPlay:spawnVolcanoAreas()
	local z = getWorldFloor(self.volcano.x, self.volcano.y, "mustafar")
	local pApproach = spawnActiveArea("mustafar", "object/active_area.iff", self.volcano.x, z, self.volcano.y, self.volcano.approachRadius, 0)

	if (pApproach == nil) then
		print("cursedShardScreenPlay: failed to spawn the volcano approach area; cursed_shard_2 branch A cannot be started")
	else
		self.approachAreaID = SceneObject(pApproach):getObjectID()
		createObserver(ENTEREDAREA, "cursedShardScreenPlay", "notifyEnteredApproachArea", pApproach)
	end

	local pBridge = spawnActiveArea("mustafar", "object/active_area.iff", self.volcano.x, z, self.volcano.y, self.volcano.bridgeRadius, 0)

	if (pBridge == nil) then
		print("cursedShardScreenPlay: failed to spawn the volcano bridge area; cursed_shard_2 branch A cannot be finished")
	else
		self.bridgeAreaID = SceneObject(pBridge):getObjectID()
		createObserver(ENTEREDAREA, "cursedShardScreenPlay", "notifyEnteredBridgeArea", pBridge)
	end
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage        0  never bought the shard
	             1  carrying it; _1's two mysterious events are live
	             2  both events seen; the 180-560 s brood before _2 is granted
	             3  _2 is live: volcano or Whiphid
	             4  disposed of, either way
	event1       1 once the tulrus ambush has fired
	event2       1 once the lava flea ambush has fired
	broodUntil   unix seconds the brood ends at; see getStage
	approach     1 once the volcano approach message has been shown
	wp           waypoint id currently handed out, 0 if none
--]]

function cursedShardScreenPlay:rawStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

--[[ The brood is driven by createEvent, which does not survive a server restart.
     Reading the stage settles an overdue brood as well, so a restart during those
     180-560 s cannot strand a player on a quest with nothing left in it. Both
     paths funnel into endBrood, which is guarded, so whichever arrives first wins
     and the other does nothing. Reading the stage also picks up a brood whose
     delayed springAmbush never reached the gate. ]]
function cursedShardScreenPlay:getStage(pPlayer)
	local stage = self:rawStage(pPlayer)

	if (stage == self.STAGE_BROOD) then
		local due = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "broodUntil")) or 0

		if (due ~= 0 and getTimestamp() >= due) then
			self:endBrood(pPlayer)

			return self:rawStage(pPlayer)
		end
	end

	if (stage == self.STAGE_SHARD) then
		self:checkBroodGate(pPlayer)

		return self:rawStage(pPlayer)
	end

	return stage
end

function cursedShardScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	JournalMirror.applyStage(pPlayer, self.journalMap, stage)   -- J-3 journal mirror
end

function cursedShardScreenPlay:hasFlag(pPlayer, key)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) == 1
end

function cursedShardScreenPlay:setFlag(pPlayer, key)
	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
end

function cursedShardScreenPlay:clearFlag(pPlayer, key)
	deleteScreenPlayData(pPlayer, self.screenplayName, key)
end

--[[ Every key this screenplay ever writes, in one place.

     The screenplay sets five flags -- event1/event2 (:467), brood (:543), approach
     (:604), tossed (:630) -- and until now cleared none of them. That is safe only
     while the arc is strictly one-shot, which today it is: startQuest returns early
     on stage ~= 0 and nothing anywhere sets the stage back to 0. The header at
     :123-125 explains why -- Menth Paul refuses to take the shard back (s_139,
     s_140), so there is no abandon path in either .qst.

     The exposure is that the shipped [list] block says allowRepeats true on both
     .qst files, which invites a reset being added later. The moment one exists
     without this, "brood" stays set, the gate at :511 never opens again, and the
     player deadlocks in STAGE_SHARD with the quest silently unfinishable.

     No caller today, deliberately -- same shape as the seam at bounty_hunts.lua:287
     and som_sceismic_charges.lua:326, which also exist ahead of their callers with
     the reason written in. A reset path must call this. ]]
function cursedShardScreenPlay:resetProgress(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	self:clearFlag(pPlayer, "event1")
	self:clearFlag(pPlayer, "event2")
	self:clearFlag(pPlayer, "brood")
	self:clearFlag(pPlayer, "approach")
	self:clearFlag(pPlayer, "tossed")

	deleteScreenPlayData(pPlayer, self.screenplayName, "broodUntil")
	self:removeWaypoint(pPlayer)
	self:setStage(pPlayer, 0)

	return true
end

function cursedShardScreenPlay:showMessageBox(pPlayer, title, prompt)
	local sui = SuiMessageBox.new("cursedShardScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)
	sui.sendTo(pPlayer)
end

-- The .qst message boxes are read-and-dismiss; nothing branches on the button.
function cursedShardScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

function cursedShardScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function cursedShardScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

-- True only if this player is on Mustafar and logged in -- every delayed step
-- here fires into a world the player may have left.
function cursedShardScreenPlay:isPresent(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	return pGhost ~= nil and PlayerObject(pGhost):isOnline() and SceneObject(pPlayer):getZoneName() == "mustafar"
end

--[[ som_kenobi_cursed_shard_1 ]]

-- Every accept screen in Menth Paul's tree lands here; see the conversation
-- handler. .qst _1 task 0, musicOnActivate sound/mus_mustafar_quest_exception.snd.
function cursedShardScreenPlay:startQuest(pPlayer)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, self.STAGE_SHARD)

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	self:showMessageBox(pPlayer, "Cursed?",
		"As soon as you take the shard in your hand, you get the feeling that you made the wrong decision accepting it. Not really sure what to do with it, you put it away for now. Maybe it will become useful later.")

	-- _1's [list] journalEntryDescription and task 10's, going out as system
	-- messages because there is no journal. No waypoint: see THE SHAPE OF IT.
	CreatureObject(pPlayer):sendSystemMessage("You've agreed to relieve a treasure hunter of a crystal shard he claims has brought him nothing but bad luck. Could it really be cursed?")
	CreatureObject(pPlayer):sendSystemMessage("You're not sure what to do with the supposedly 'cursed' shard, and have decided to just hold onto it until you can figure something out.")
end

-- _1 tasks 2 and 3 completing, each firing its message box and then its timer.
function cursedShardScreenPlay:notifyEnteredEventArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local event = self.eventByAreaID[SceneObject(pArea):getObjectID()]

	if (event == nil or self:getStage(pPlayer) ~= self.STAGE_SHARD or self:hasFlag(pPlayer, event.key)) then
		return 0
	end

	self:setFlag(pPlayer, event.key)

	self:showMessageBox(pPlayer, event.title, event.text)

	-- The .qst delays the ambush so it does not arrive on top of the message box.
	createEvent(getRandomNumber(event.delayMin, event.delayMax) * 1000, "cursedShardScreenPlay", "springAmbush", pPlayer, event.key)

	return 0
end

-- _1 tasks 7 and 9. Both are isVisible false with showSystemMessages off, so the
-- creatures arrive with no warning at all.
function cursedShardScreenPlay:springAmbush(pPlayer, key)
	if (not self:isPresent(pPlayer)) then
		return
	end

	local event = nil

	for i = 1, #self.events do
		if (self.events[i].key == key) then
			event = self.events[i]
		end
	end

	if (event == nil) then
		return
	end

	for i = 1, event.count do
		self:spawnAmbusher(pPlayer, event)
	end

	-- _1 tasks 15 and 16, the same box on both branches.
	self:showMessageBox(pPlayer, "Coincidence?",
		"That was strange, almost like the crystal that Menth Paul gave you called for those creatures...")

	-- Task 10 is a Wait for Tasks on both goto1 and goto2, so the brood only
	-- starts once the second one has fired.
	self:checkBroodGate(pPlayer)
end

-- Both event flags set, still in STAGE_SHARD, brood not yet started.
function cursedShardScreenPlay:checkBroodGate(pPlayer)
	if (self:hasFlag(pPlayer, "event1") and self:hasFlag(pPlayer, "event2") and self:rawStage(pPlayer) == self.STAGE_SHARD and not self:hasFlag(pPlayer, "brood")) then
		self:startBrood(pPlayer)
	end
end

function cursedShardScreenPlay:spawnAmbusher(pPlayer, event)
	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()
	local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, event.minDistance, event.maxDistance, true)

	if (spawnPoint == nil) then
		print("cursedShardScreenPlay: no spawn point near the player for " .. event.template)
		return
	end

	local pMobile = spawnMobile("mustafar", event.template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

	if (pMobile == nil) then
		print("cursedShardScreenPlay: failed to spawn " .. event.template)
		return
	end

	AiAgent(pMobile):setDefender(pPlayer)
end

-- _1 task 11: Timer Min 180 / Max 560. The due time is stored as well as timed so
-- a restart cannot swallow it; see getStage.
function cursedShardScreenPlay:startBrood(pPlayer)
	if (self:hasFlag(pPlayer, "brood")) then
		return
	end

	self:setFlag(pPlayer, "brood")

	local delay = getRandomNumber(self.broodMin, self.broodMax)

	self:setStage(pPlayer, self.STAGE_BROOD)
	writeScreenPlayData(pPlayer, self.screenplayName, "broodUntil", tostring(getTimestamp() + delay))

	createEvent(delay * 1000, "cursedShardScreenPlay", "endBrood", pPlayer, "")
end

--[[ som_kenobi_cursed_shard_2 ]]

-- _1 task 12, Immediately Complete Quest with
-- grantQuestOnComplete = quest/som_kenobi_cursed_shard_2, and then _2 task 0,
-- musicOnActivate sound/mus_mustafar_quest_exception.snd.
function cursedShardScreenPlay:endBrood(pPlayer)
	if (pPlayer == nil or self:rawStage(pPlayer) ~= self.STAGE_BROOD) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DISPOSE)
	deleteScreenPlayData(pPlayer, self.screenplayName, "broodUntil")

	-- Offline or off-planet, the stage still advances -- the shard is carried, not
	-- placed -- but the flavour is skipped rather than shouted into an empty seat.
	if (not self:isPresent(pPlayer)) then
		return
	end

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	self:showMessageBox(pPlayer, "Too much",
		"You can feel warmth emitting from Menth Paul's shard again. Not as hot this time but you can swear that you hear a voice whispering in your head '...this can all go away, just set me free...' over and over again. You may want to think about getting rid of this cursed thing.")

	self:sendDisposeBriefing(pPlayer)
end

-- _2's [list] entry plus both branches' journal entries, and Branch A's waypoint.
-- The waypoint name is task 1's journalEntryTitle: the task carries no
-- waypointName of its own because on live the journal held the location.
function cursedShardScreenPlay:sendDisposeBriefing(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("The shard indeed seems cursed with something. You've decided to get rid of it as it's brought you nothing but trouble.")

	self:giveWaypoint(pPlayer, "Destroy the menace", "The cursed shard, part II", self.volcano.x, self.volcano.y)
	CreatureObject(pPlayer):sendSystemMessage("In the center of this continent, there's an enormous active volcano. You've heard that a bridge goes across the river of fresh molten lava descending the volcano from the north. Throwing the crystal in to the lava from there should destroy it once and for all.")

	-- Branch B, task 2. isVisible true with showSystemMessages true and no
	-- location, so it is a system message and nothing else.
	CreatureObject(pPlayer):sendSystemMessage("Maybe you should try and find someone to give it to and let them deal with it.")
end

-- _2 task 1 completing: the Radius 200 ring.
function cursedShardScreenPlay:notifyEnteredApproachArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_DISPOSE or self:hasFlag(pPlayer, "approach")) then
		return 0
	end

	self:setFlag(pPlayer, "approach")

	self:showMessageBox(pPlayer, "What it wants?",
		"As you get closer to the volcano, the shard springs to life again and the whispers in your head grows stronger '...yes, keep going! Set me free at last! I can't take anymore...'")

	-- Task 4's journal entry, and its waypoint retargeted onto the bridge itself.
	CreatureObject(pPlayer):sendSystemMessage("What ever it is that keeps whispering to you through the crystal, it seems to want you to throw it in the volcano to set it free. Hopefully that's a good thing.")
	self:giveWaypoint(pPlayer, "What it wants?", "The cursed shard, part II", self.volcano.x, self.volcano.y)

	return 0
end

-- _2 task 4 completing: the Radius 10 ring, on the bridge.
function cursedShardScreenPlay:notifyEnteredBridgeArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_DISPOSE or not self:hasFlag(pPlayer, "approach")) then
		return 0
	end

	if (self:hasFlag(pPlayer, "tossed")) then
		return 0
	end

	self:setFlag(pPlayer, "tossed")
	self:removeWaypoint(pPlayer)

	self:showMessageBox(pPlayer, "Time to end it",
		"You take one last look at the shard and then toss it in to the molten lava. As it sizzles and disappears under the surface, you can swear that you hear a whisper saying '...Free, finally I'm fr...'")

	-- Task 6: Timer Min 15 / Max 25, "as you start to leave the area".
	createEvent(getRandomNumber(self.glovesMin, self.glovesMax) * 1000, "cursedShardScreenPlay", "findGloves", pPlayer, "")

	return 0
end

-- _2 task 11, then task 7 (Reward) and task 8 (Immediately Complete Quest).
function cursedShardScreenPlay:findGloves(pPlayer)
	if (not self:isPresent(pPlayer) or self:rawStage(pPlayer) ~= self.STAGE_DISPOSE) then
		return
	end

	self:showMessageBox(pPlayer, "The tide turns",
		"As you start to leave the area you notice something shining among the rubble of lava rocks at your feet. It looks to be a pair of strange alien gloves! Maybe the bad luck the cursed shard brought with it is gone already...")

	self:completeQuest(pPlayer)
end

-- _2 Branch B: the "gaveAwayShard" signal, fired from every success screen in the
-- Whiphid's tree, then task 9 (Reward) and task 10 (Immediately Complete Quest).
function cursedShardScreenPlay:giveAwayShard(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_DISPOSE) then
		return
	end

	self:completeQuest(pPlayer)
end

-- Both branches award the same thing: lootCount 1 of one item, no credits.
-- Experience Amount 0 is the stored field; live still paid via quest_experience
-- (see mustafar_quest_xp.lua).
function cursedShardScreenPlay:completeQuest(pPlayer)
	if (self:rawStage(pPlayer) ~= self.STAGE_DISPOSE) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE)
	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_cursed_shard_2")
	self:removeWaypoint(pPlayer)

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("cursedShardScreenPlay: player has no inventory; the gloves could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		print("cursedShardScreenPlay: failed to create " .. self.rewardItem)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for the gloves.")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have taken a pair of strange alien gloves.")
	end

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
	CreatureObject(pPlayer):sendSystemMessage("You are rid of the cursed shard.")
end
