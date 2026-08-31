--[[
The Mensix prelude  --  som_story_arc_prelude_01, _02, _03 and som_prelude_obiwan_check

SOURCE OF RECORD

quest/som_story_arc_prelude_01.qst, _02.qst, _03.qst and som_prelude_obiwan_check.qst
in the client TREs. Every coordinate, radius, count, credit figure, retrieve menu
text, item name, signal name and line of journal prose below is quoted from them.
Foreman Chivos's own words are quoted from string/en/conversation/
story_arc_prelude_chivos.stf (60 strings, in mtg_patch_019.tre and mtg_planets.tre).

All four are run by one screenplay because they are one chain: _01 task 2 carries
grantQuestOnComplete = quest/som_story_arc_prelude_02, and _03 is the job Chivos
offers once _02 is paid out. cursed_shard.lua and reunite_shard.lua cover their
multiple .qst files the same way.

SOM_PRELUDE_OBIWAN_CHECK IS NOT A GATE ON THE THREE PRELUDES

It has three Wait for Tasks tasks, and none of them names a prelude. Its
prerequisiteTasks fields are all empty; the dependency is carried by the XML
nesting and by the Task<n> Quest Filename / Task<n> taskName pairs. Read
literally, they are:

  task 2  Wait for Tasks, taskName other_task_2
     Task1  quest/som_kenobi_reunite_shard_3        taskName reward
     Task2  quest/som_kenobi_samaritan_1            taskName reward
     Task3  quest/som_kenobi_serpent_shard_1        taskName reward
     Task4  quest/som_kenobi_symbiosis_1            taskName reward
     Task5  quest/som_kenobi_historian_1            taskName reward

  task 3  Wait for Tasks, taskName other_task_1
     Task1  quest/som_kenobi_collectors_business_1  taskName reward
     Task2  quest/som_kenobi_cursed_shard_2         taskName reward
     Task3  quest/som_kenobi_hidden_treasure_2      taskName reward
     Task4  quest/som_kenobi_historian_2            taskName reward
     Task5  quest/som_kenobi_moral_choice_1         taskName reward

  task 4  Wait for Tasks, no taskName
     Task1  som_prelude_obiwan_check                taskName other_task_1
     Task2  som_prelude_obiwan_check                taskName other_task_2

  task 5  Immediately Complete Quest,
          grantQuestOnComplete = whatever we call talk to obi on beach quest

So the three tasks it waits on are its own two halves and the join of them, and
what it really gates on is the ten Kenobi side quests being rewarded -- five in
each half. That is the join between this arc's side content and whatever comes
after Obi-Wan on the beach, which is why it is implemented here for real rather
than stubbed.

Its grantQuestOnComplete is the literal string "whatever we call talk to obi on
beach quest" -- an unresolved SOE developer placeholder, not a quest name. Nothing
is granted here on that account; see WHAT IS NOT MODELLED.

The ten map onto ten screenplays that already exist in this directory, each with
its own terminal stage. They are read through _G[name], the lookup
screenplays/utils/quest_spawner.lua:24 already uses, so a screenplay that is not
loaded logs and fails the half rather than raising.

WHERE THINGS ARE  --  snapshot, not spawned

All three object/tangible/quest/must_*.iff props the preludes interact with are
already placed by snapshot/mustafar.ws, and the node counts equal the .qst Counts
exactly:

  must_supply_locker        1 node   .qst _01 Count 1
  must_ventilation_station  4 nodes  .qst _02 Count 4
  must_power_rod            3 nodes  .qst _03 Count 3

PlanetManagerImplementation::loadSnapshotObject() gives a snapshot object an
objectID equal to its node id, so getSceneObject(nodeID) returns the very object
the client is already drawing. These are attached to, never respawned -- the rule
map_exploration.lua documents for the crash site terminals. Spawning our own on
top would leave the player with two overlapping objects, only one of which does
anything.

The locker node (-2901.85, h 103.47, -261.45) is 36 m from _01 task 4's own
waypoint (-2875, 103, -237), inside the same field camp -- the camp
mensix_facility_region.lua already fills with four mustafarian_m_01 lava miners at
h 103.6. All three power rod nodes fall inside _03 task 15's Radius 500 around
(-2672, 130, 3154): 96 m, 107 m and 488 m out.

WHO GRANTS THEM  --  Foreman Chivos, and not either table that was suggested

som_battlefield_miner_leader.stf is a squad-command tree ("Stop here.", "Deploy
your people in this area.", "We are ready to move out.") and som_doctor_lu.stf is
the Blackguard / San'sii archaeologist arc ("I am Doctor Mi Fon Lu of the Theed
Academy"). Neither has a line touching supplies, vents, couriers or power rods.

The table that does is story_arc_prelude_chivos.stf, and it matches all three
quests end to end: s_99 "...I have been authorized to hire outside help to restock
the base camps. How would you like to be a courier for a while?" is _01, s_101
"I thought I asked you to clean out those air vents which are around the facility"
is _02, s_78 "Our engineers say they just need four of those rods to keep us in
power" is _03, and s_29 pays the last one out. The .qst names him too: _03's
journal prose says "Foreman Chivos seems convinced that extra power rods can be
found around the crashed capital ship".

must_foreman_chivos is registered (mobile/custom_content/som/serverobjects.lua:76,
customName "Foreman Chivos") and its conversationTemplate is empty, so he is given
a radial here and answers in his own shipped strings. The 60-string tree itself is
not reconstructed in this file -- see WHAT IS NOT MODELLED.

Live names him som_foreman_chivos and hangs conversation.story_arc_prelude_chivos
off him. This tree keeps must_foreman_chivos, the registered template that ships
an appearance; the live name is recorded here because it is what identifies his
row in the facility spawn table.

WHERE CHIVOS STANDS  --  live position, recovered

The facility's dungeon spawn table places him: small_room_02, cell 12112232, at
(-125.7, 10.3, 82.8) facing 180. His row also names his conversation script, which
is what confirms this row is the quest-giving Chivos and not a lookalike.

An earlier revision read s_68 "Welcome to Mensix Corp." as putting him in the
facility -- correct -- and then put him in the cantina at (-82, 10.8, 55) because
that is where the other two givers stand: pei_yi (-77.1, 10.8, 67.5) and
diskret_stahn (-75.4, 10.8, 66.3), both in cell 12112226, with four background
miners around them. The room reasoning was "the givers cluster here, so he does
too". He does not. A foreman has an office, and small_room_02 is about 45 m and
one room away from the bar. Right building, wrong room, for the second time in
this wave -- see cursed_shard.lua for the same mistake made bigger.

His respawn timer is 300 rather than the 0 the neighbouring spawns use, because
his pvpBitmask is ATTACKABLE and he is the only way into all three quests:
AiAgentImplementation.cpp:2283 only builds a RespawnCreatureTask when the timer is
greater than 0, so at 0 a player who kills him closes the prelude for everyone
until the next restart.

THE SALVAGE LEADERS  --  placed, not quoted, and the absence is CHECKED

The crash site has a server-side dungeon spawn table of its own, and it was read
before this claim was left standing. It contains exactly one row -- the ship's
computer on the bridge -- and no creatures at all, so there is no live position
for a salvage leader to be quoted from. This is a checked absence, not an
unchecked one. Anywhere else in the Mustafar set that a spawn table exists, it
won and the guess was replaced; here there is nothing to lose to.

_03 task 13 wants som_mustafarian_salvage_leader. The template that shipped in
this tree is must_salvage_bandit_leader_01 (registered at
mobile/custom_content/som/serverobjects.lua:83, customName "Salvage Bandit
Leader") -- the same som_ prefix the .qst files carry on lava_flea_smoldering and
tulrus. It is spawned nowhere: mensix_facility_region.lua's south-west camp is
twelve must_salvage_bandit_01 and boss_uruli, 3400 m from the wreck and with no
leader in it. Without a placement here the quest cannot be finished at all.

Where they go is corroborated twice: the .qst sends the player to (-2672, 130,
3154) Radius 500, and Chivos's own handout s_120 says "When our crew was there,
they reported seeing a bunch of salvage bandits crawling all over the ship, so
watch your back." So three stand at the wreck, beside the hull (node 12112171),
the forward gun (12112169) and the far engine (12112173), all inside that radius.
Their respawn timer is 300 for the same reason as Chivos's: they are the only
source of the scepter rod.

PROGRESS TRACKING

None of the four has a row in datatables/player/quests.iff -- the table the server
loads is stardust_03.tre's, whose only Mustafar rows are the 45 exploration
markers. So there is no journal. Progress lives in persistent screenplay data on
the player's ghost, and the journalEntryDescription lines go out as system
messages and as waypoint descriptions, which is where the player would otherwise
have read them.

That is also why _02 task 1 and _03 task 15 get waypoints even though both say
createWaypoint 0 / false: on live the journal entry carried the location, and with
no journal the waypoint is the only thing left that can. _01 task 4 asks for one
outright.

NO TIMERS, AND WHAT SETTLES ON READ INSTEAD

Unusually for this arc, not one of the four .qst files carries a timer: every
Time To Complete and CountdownTimer in all four is 0, and there is no Timer task.
So there is no createEvent anywhere in this file and nothing that a restart can
strand mid-transition -- the cursed_shard.lua:332-351 broodUntil problem does not
arise.

The one transition that still cannot be driven by an event is
som_prelude_obiwan_check, because the ten quests it waits on are owned by ten
other screenplays that this one does not observe. It is therefore settled on read,
the same discipline for the same reason: isObiwanCheckComplete recomputes the two
halves from those screenplays' own stage accessors on demand, and the writer it
funnels into, completeObiwanCheck, is guarded on the raw getter rather than on the
settling one, so it cannot recurse and whichever caller arrives first wins.

Every player-facing entry point in this file settles it, and so does an
ENTEREDAREA ring over the Mensix travel point (-2471, 230, 1620) --
planet_manager.lua:726, the one and only planetTravelPoint on Mustafar, so it is
the one place every player on the planet passes through. Height 230 is the travel
point's own, deliberately not getWorldFloor: cursed_shard.lua records that the
server's terrain returns 100.68 at that x/y, over the shelf edge.

THE REWARD  --  substituted

_01 and _02 award Bank Credits 5000 and nothing else, which is quoted as it
stands. _03 awards Bank Credits 5000 plus lootCount 1 / lootName
item_tow_necklace_03_01 -- a live server-side static-item name rather than an
object template. The name resolves to "Miners Medallion" in
string/en/static_item_n.stf, but an exhaustive sweep of every shipped
shared_*.iff finds no object template carrying that objectName, so granting the
live item would mean authoring an object. Every other TOW reward in this arc has
the same problem and is handled the same way, by matching on what the name says
it is.

What it says it is: a necklace. What this tree has for that:
object/tangible/loot/npc/loot/green_stone_necklace_generic.iff, a registered
server template (object/custom_content/tangible/loot/npc_loot/
green_stone_necklace_generic.lua, included from that folder's serverobjects.lua at
line 58, itself included from custom_content/tangible/loot/serverobjects.lua:10).
Handed over with giveItem() into the player's inventory, which creates the object
for real.

To restore the live item later, only rewardItem below changes.

WHAT IS NOT MODELLED

_01 task 2 is a Comm Player with NPC Appearance Server Template
object/mobile/som/mustafarian_m_01.iff. There is no CommPlayerMessage anywhere in
this tree -- not in bin/scripts and not in src -- so the comm cannot be rendered
with its portrait. Its Comm Message Text is delivered verbatim in a message box
titled with the task's own journalEntryTitle instead, and the appearance is lost.

WITHDRAWN -- CHIVOS'S TREE IS RECONSTRUCTED

This section used to read, verbatim:

    "Chivos's conversation tree is not reconstructed. story_arc_prelude_chivos.stf's
    do_not_edit row says the file "is automatically generated by the
    SwgConversationEditor", so a real branching tree existed, but wiring one needs a
    new mobile/conversations/mustafar/ file, a handler, an include in
    mobile/conversations.lua and a conversationTemplate on the creature -- two of them
    shared files this file is not the owner of. His lines are quoted into the radial
    and its message boxes so that nothing he says is lost in the meantime."

It was wrong twice.

ROOT CAUSE 1 -- the tree was looked for under the som_ name prefix, because every
quest in this arc is som_story_arc_prelude_NN and their strings are in som_ tables.
The conversation carries no som_: it is conversation/story_arc_prelude_chivos, in
the BASE string/en/conversation/ set. All 32 screens and 26 options were recoverable
the whole time, along with SOE's own eight-condition greeting order, its five
actions and all 23 of its gestures.

ROOT CAUSE 2 -- "a conversationTemplate on the creature" was treated as work the
brief forbids. What the brief forbids is REPOINTING an existing conversationTemplate.
must_foreman_chivos.lua's field was the empty string; filling an empty field with a
new template repoints nothing and was never forbidden.

The tree is mobile/conversations/mustafar/story_arc_prelude_chivos.lua and the
handler is screenplays/mustafar/quest/conversation/chivos_conv_handler.lua. The
radial and its message boxes are retired; see the headstone above getRadialText.

som_prelude_obiwan_check's own reward is nothing: its [list] is journalVisible
false, allowRepeats true, with journalEntryTitle "Welcome to Mustafar!" and
journalEntryDescription "Enjoy your stay." It has no player-facing completion text
of any kind, so settling it is silent by design. Its grantQuestOnComplete is a
placeholder string and nothing is granted from it; isObiwanCheckComplete is public
so that whatever ends up being the beach quest can read the gate.
--]]

storyArcPreludeScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "storyArcPreludeScreenPlay",

	-- .qst [list] Level, on all three preludes -- re-read and confirmed in all
	-- three. obiwan_check carries none.
	--
	-- NOTHING GATES ON THIS ANY MORE. It is the level the JOURNAL DISPLAYS, not an
	-- entry requirement, and live's Chivos has no level test anywhere: not in his
	-- eight conditions, not in his five actions, not in OnStartNpcConversation. The
	-- refusal that used to sit in startSupplies was the retired radial's invention,
	-- and it went with the radial. Kept as the recorded .qst value.
	requiredLevel = 75,

	-- Live position; see WHERE CHIVOS STANDS. small_room_02 = cell 12112232 of
	-- the Mensix mining facility POB -- his own office, not the cantina.
	chivos = {
		template = "must_foreman_chivos",
		cellID = 12112232,
		x = -125.7,
		z = 10.3,
		y = 82.8,
		heading = 180,
		respawn = 300,
	},

	-- kenobi_spine.lua:234 -- the facility's world position, which is what a
	-- waypoint pointing at Chivos can aim at from outside.
	facility = { x = -2420.5, y = 1767.08 },

	--[[ The snapshot props. Node ids and positions are ws_dump output from
	     _som/snapshot/stardust_03.tre/snapshot/mustafar.ws; positions are
	     recorded for the record only, since getSceneObject finds them by id. ]]

	-- .qst _01 task 4: Count 1. (-2901.85, h 103.47, -261.45)
	locker = { nodeID = 12112260 },

	-- .qst _02 task 1: Count 4.
	vents = {
		12112644,   -- (-2887.53, h 151.52, 1384.76)
		12112645,   -- (-3157.32, h 145.23, 1331.70)
		12112646,   -- (-3385.52, h 151.72, 1375.13)
		12112857,   -- (-3064.01, h 145.64, 1359.12)
	},

	-- .qst _03 task 12: Count 3.
	rods = {
		12112128,   -- (-2733.85, h 127.73, 3080.30)
		12112129,   -- (-2740.11, h 163.21, 3236.79)
		12112130,   -- (-2742.13, h 246.58, 3636.59)
	},

	-- .qst _01 task 4: createWaypoint true, waypointName quoted, mustafar
	-- (-2875, 103, -237) -- x = LocationX, y = LocationZ.
	fieldCamp = { x = -2875, y = -237, waypointName = "Mustafarian Miner Field Camp" },

	-- .qst _03 task 15: mustafar (-2672, 130, 3154), Radius 500.
	crashSite = { x = -2672, z = 130, y = 3154, radius = 500 },

	-- Placed, not quoted; see THE SALVAGE LEADERS. All three inside the Radius 500.
	salvageLeader = { template = "must_salvage_bandit_leader_01", respawn = 300 },
	salvageLeaders = {
		{ x = -2652, y = 3130, heading = 40 },    -- beside the hull, node 12112171
		{ x = -2690, y = 3178, heading = 190 },   -- beside the forward gun, node 12112169
		{ x = -2662, y = 3282, heading = 300 },   -- beside the far engine, node 12112173
	},

	-- planet_manager.lua:726, the planet's only travel point. Height is the travel
	-- point's own; see NO TIMERS.
	arrival = { x = -2471, z = 230, y = 1620, radius = 150 },

	-- .qst Bank Credits: 5000 on all three Reward tasks.
	rewardCredits = 5000,

	-- Substituted for _03 task 14's item_tow_necklace_03_01; see THE REWARD.
	rewardItem = "object/tangible/loot/npc/loot/green_stone_necklace_generic.iff",

	--[[ som_prelude_obiwan_check tasks 2 and 3, one entry per Task<n> pair. The
	     stage is the point at which that quest's own screenplay has paid its
	     reward out, which is what taskName "reward" means. ]]

	-- task 3, taskName other_task_1.
	obiwanHalfOne = {
		{ quest = "som_kenobi_collectors_business_1", screenplay = "collectorsBusinessScreenPlay", stage = 4 },
		{ quest = "som_kenobi_cursed_shard_2",        screenplay = "cursedShardScreenPlay",        stage = 4 },
		{ quest = "som_kenobi_hidden_treasure_2",     screenplay = "hiddenTreasureScreenPlay",     stage = 6 },
		{ quest = "som_kenobi_historian_2",           screenplay = "historianScreenPlay",          stage = 6 },
		{ quest = "som_kenobi_moral_choice_1",        screenplay = "moralChoiceScreenPlay",        stage = 6 },
	},

	-- task 2, taskName other_task_2.
	obiwanHalfTwo = {
		{ quest = "som_kenobi_reunite_shard_3", screenplay = "reuniteShardScreenPlay", stage = 7 },
		{ quest = "som_kenobi_samaritan_1",     screenplay = "samaritanScreenPlay",    stage = 5 },
		{ quest = "som_kenobi_serpent_shard_1", screenplay = "serpentShardScreenPlay", stage = 6 },
		{ quest = "som_kenobi_symbiosis_1",     screenplay = "symbiosisScreenPlay",    stage = 5 },
		{ quest = "som_kenobi_historian_1",     screenplay = "historianScreenPlay",    stage = 3 },
	},

	STAGE_SUPPLIES = 1,
	STAGE_FILTERS = 2,
	STAGE_FILTERS_DONE = 3,
	STAGE_REACTOR_OFFER = 4,
	STAGE_TRAVEL = 5,
	STAGE_SALVAGE = 6,
	STAGE_RODS_DONE = 7,
	STAGE_DONE = 8,

	-- Filled in by start(); these object ids are only known once the areas exist.
	crashAreaID = 0,
	arrivalAreaID = 0,
	chivosID = 0,
}

registerScreenPlay("storyArcPreludeScreenPlay", true)

function storyArcPreludeScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachQuestObjects()
		self:spawnChivos()
		self:spawnSalvageLeaders()
		self:spawnCrashArea()
		self:spawnArrivalArea()
	end
end

--[[ Attach to what the world snapshot already placed rather than spawning
     duplicates; see WHERE THINGS ARE. The component is a single global table
     shared by every object, and reads the role back to know which one it is
     talking about. ]]
function storyArcPreludeScreenPlay:attachQuestObjects()
	self:attachOne(self.locker.nodeID, "locker")

	for i = 1, #self.vents do
		self:attachOne(self.vents[i], "vent")
	end

	for i = 1, #self.rods do
		self:attachOne(self.rods[i], "rod")
	end
end

function storyArcPreludeScreenPlay:attachOne(nodeID, role)
	local pObject = getSceneObject(nodeID)

	if (pObject == nil) then
		print("storyArcPreludeScreenPlay: snapshot object " .. nodeID .. " (" .. role .. ") was not found; that step of the prelude will be unreachable")
		return
	end

	writeStringData(nodeID .. ":storyArcPreludeRole", role)
	SceneObject(pObject):setObjectMenuComponent("StoryArcPreludeMenuComponent")
end

function storyArcPreludeScreenPlay:spawnChivos()
	local chivos = self.chivos
	local pChivos = spawnMobile("mustafar", chivos.template, chivos.respawn, chivos.x, chivos.z, chivos.y, chivos.heading, chivos.cellID)

	if (pChivos == nil) then
		print("storyArcPreludeScreenPlay: failed to spawn " .. chivos.template .. "; none of the three preludes can be started or turned in")
		return
	end

	-- He has no snapshot node, so nothing else in the world knows an id to find
	-- him by; keep the one the spawn just handed back, as cursed_shard.lua does.
	-- Nothing reads it today -- he is reached through his conversation now, not by
	-- id -- but it is the only handle on him that exists, so it stays.
	--
	-- The role write and the menu component that used to follow are gone with the
	-- radial. The snapshot props still get both; only Chivos does not.
	self.chivosID = SceneObject(pChivos):getObjectID()
end

function storyArcPreludeScreenPlay:spawnSalvageLeaders()
	for i = 1, #self.salvageLeaders do
		local spot = self.salvageLeaders[i]
		local z = getWorldFloor(spot.x, spot.y, "mustafar")
		local pLeader = spawnMobile("mustafar", self.salvageLeader.template, self.salvageLeader.respawn, spot.x, z, spot.y, spot.heading, 0)

		if (pLeader == nil) then
			print("storyArcPreludeScreenPlay: failed to spawn " .. self.salvageLeader.template .. " at the wreck; som_story_arc_prelude_03 cannot be finished")
		end
	end
end

-- .qst _03 task 15, Go to Location: the two collection tasks are nested under it,
-- so neither goes live until the player has been here.
function storyArcPreludeScreenPlay:spawnCrashArea()
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.crashSite.x, self.crashSite.z, self.crashSite.y, self.crashSite.radius, 0)

	if (pArea == nil) then
		print("storyArcPreludeScreenPlay: failed to spawn the crash site area; som_story_arc_prelude_03 cannot progress past the travel task")
		return
	end

	self.crashAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "storyArcPreludeScreenPlay", "notifyEnteredCrashSite", pArea)
end

-- Not a quest location. This is the poll that lets som_prelude_obiwan_check settle
-- for a player who finished the tenth side quest somewhere else and never touches
-- anything in this file again; see NO TIMERS.
function storyArcPreludeScreenPlay:spawnArrivalArea()
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.arrival.x, self.arrival.z, self.arrival.y, self.arrival.radius, 0)

	if (pArea == nil) then
		print("storyArcPreludeScreenPlay: failed to spawn the Mensix arrival area; som_prelude_obiwan_check will only settle when the player uses this quest's own objects")
		return
	end

	self.arrivalAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "storyArcPreludeScreenPlay", "notifyEnteredArrival", pArea)
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage         0  not started
	              1  prelude_01: carrying the supplies to the field locker
	              2  prelude_02: the four air filters
	              3  filters replaced, Chivos owes the reward
	              4  prelude_02 paid; the reactor job is on offer
	              5  prelude_03: travelling to the crashed cruiser
	              6  at the wreck; the scepter and the three rods are collectable
	              7  four rods in hand, Chivos owes the reward
	              8  prelude_03 paid; the prelude is over
	vent_<nodeID> 1 once that ventilation station's filter has been replaced
	rod_<nodeID>  1 once that power rod has been taken from its core housing
	scepter       1 once a salvage leader has dropped his rod
	obiwanCheck   1 once som_prelude_obiwan_check has been satisfied and closed
	wp_<key>      waypoint id currently handed out for that objective, absent if none
--]]

function storyArcPreludeScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function storyArcPreludeScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function storyArcPreludeScreenPlay:hasFlag(pPlayer, key)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) == 1
end

function storyArcPreludeScreenPlay:setFlag(pPlayer, key)
	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
end

function storyArcPreludeScreenPlay:countFlags(pPlayer, nodeIDs, prefix)
	local done = 0

	for i = 1, #nodeIDs do
		if (self:hasFlag(pPlayer, prefix .. nodeIDs[i])) then
			done = done + 1
		end
	end

	return done
end

function storyArcPreludeScreenPlay:giveWaypoint(pPlayer, key, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer, key)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key, tostring(waypointID))
end

function storyArcPreludeScreenPlay:removeWaypoint(pPlayer, key)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)
end

function storyArcPreludeScreenPlay:showMessageBox(pPlayer, title, prompt)
	local sui = SuiMessageBox.new("storyArcPreludeScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)
	sui.sendTo(pPlayer)
end

-- Every box here is read-and-dismiss; nothing branches on the button.
function storyArcPreludeScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

function storyArcPreludeScreenPlay:payCredits(pPlayer, amount)
	CreatureObject(pPlayer):addBankCredits(amount, true)
	CreatureObject(pPlayer):sendSystemMessage("You have received " .. amount .. " credits.")
end

--[[ som_story_arc_prelude_01 -- "Supplies for the Miners" ]]

--[[ ACTION grantMissionOne, on screen ill_take_the_job (s_110). His pitch is
     s_87 -> s_91 -> s_95 -> s_99 and s_108 "You said you would pay? Sure, I would
     like a job." is the acceptance -- all of it a real conversation now, not a
     radial. The level refusal that used to stand here was the radial's own
     invention; see requiredLevel. ]]
function storyArcPreludeScreenPlay:startSupplies(pPlayer)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, self.STAGE_SUPPLIES)

	-- .qst _01 task 0, musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- s_110 used to be repeated into a message box here. He is saying it in the
	-- conversation window that called this, so the copy is gone.

	-- _01's [list] journalEntryDescription, then task 4's.
	CreatureObject(pPlayer):sendSystemMessage("Normally, droids bring necessary supplies to the miners in the field. Recently, the droids have not been recharging correctly and all deliveries have fallen behind. The miners are in need of their supplies and the company is hiring couriers to bring them shipments of goods.")
	CreatureObject(pPlayer):sendSystemMessage("The Mustafar Mining Company has hired you to bring supplies to field crews, since their droids are not operating correctly. Travel to the mining camp and drop the supplies off in the field supply locker located in the camp.")

	-- task 4: createWaypoint true, waypointName quoted.
	self:giveWaypoint(pPlayer, "camp", self.fieldCamp.waypointName, "Supplies for the Miners", self.fieldCamp.x, self.fieldCamp.y)
end

-- .qst _01 task 4 completing: the supply locker's radial, retrieveMenuText
-- "Restock Supplies", Count 1, LootDropPercent 100.
function storyArcPreludeScreenPlay:restockLocker(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_SUPPLIES) then
		return
	end

	self:removeWaypoint(pPlayer, "camp")

	-- task 4's ItemName is written as the completion line, which is what it reads
	-- as: "The field crew has been resupplied."
	CreatureObject(pPlayer):sendSystemMessage("The field crew has been resupplied.")

	self:sendCompanyComm(pPlayer)
end

--[[ .qst _01 task 2, Comm Player. Its Comm Message Text goes out verbatim; the
     NPC Appearance Server Template cannot be honoured, see WHAT IS NOT MODELLED.
     Task 3 (Reward) is nested under this one, and grantQuestOnComplete
     quest/som_story_arc_prelude_02 hangs off it, so the pay-out and prelude_02
     both start here. ]]
function storyArcPreludeScreenPlay:sendCompanyComm(pPlayer)
	self:setStage(pPlayer, self.STAGE_FILTERS)

	CreatureObject(pPlayer):sendSystemMessage("Foreman Chivos has contacted you with an message about a new job.")

	self:showMessageBox(pPlayer, "Message from Company Headquarters",
		"Nice work on resupplying those miners. While you are outside of the main facility, I need you to do another job for me. We are having a problem with our ventilation cleaning system. Normally the vents around the facility clean themselves but the automatic system has completely gone offline. I need you to head to the four main ventilation shafts located just south of the mining facility and clean the debris off of the filters. Once you are done with that come back and talk to me.")

	-- task 3: Bank Credits 5000, Experience Amount 0, musicOnComplete.
	self:payCredits(pPlayer, self.rewardCredits)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")

	self:startFilters(pPlayer)
end

--[[ som_story_arc_prelude_02 -- "Replace Air Filters" ]]

--[[ ACTION grantVentQuest, on screen ill_do_it (s_107): live's
     "if (!isQuestActive(som_story_arc_prelude_02)) grantQuest(...)".

     It is a REPAIR path. On live prelude_01 and prelude_02 are separate grants, so
     a player can finish the supply run and never pick the vent job up; greeting 7
     and this action exist to put him back on track.

     This file cannot produce that state. sendCompanyComm sets STAGE_FILTERS and
     calls startFilters in the same breath, so finishing the supply run IS starting
     the vent job -- the two stages are adjacent with nothing between them, which is
     what the guard below says out loud. Reconstructed and wired anyway so that if
     the stage machine is ever split the repair comes back on its own. Its greeting
     is unreachable for the same reason; see chivos_conv_handler.lua. ]]
function storyArcPreludeScreenPlay:grantVentQuest(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage <= self.STAGE_SUPPLIES or stage >= self.STAGE_FILTERS) then
		return
	end

	self:setStage(pPlayer, self.STAGE_FILTERS)
	self:startFilters(pPlayer)
end

function storyArcPreludeScreenPlay:startFilters(pPlayer)
	-- _02's [list] journalEntryDescription, then task 1's.
	CreatureObject(pPlayer):sendSystemMessage("There are four main air filter stations for the mining facility. Foreman Chivos tells you that they are all located to the south of the mining facility. Since the automated system is offline the stations need to be activated manually. It would appear that the mining facility is having more problems than could be seen on the surface.")
	CreatureObject(pPlayer):sendSystemMessage("The air filters for the mining facility's air ventilation system have become clogged with debris and need to be replaced. Find each of the ventilation shafts and replace the filters. There are four air filters located to the south of the mining facility.")

	-- One waypoint per station. The task says createWaypoint 0; see PROGRESS
	-- TRACKING for why they are handed out anyway. The stations are only
	-- distinguishable by where they stand, so each gets its own.
	for i = 1, #self.vents do
		local nodeID = self.vents[i]
		local pVent = getSceneObject(nodeID)

		if (pVent ~= nil) then
			self:giveWaypoint(pPlayer, "vent" .. nodeID, "Replace Air Filters", "Replace Air Filters",
				SceneObject(pVent):getWorldPositionX(), SceneObject(pVent):getWorldPositionY())
		end
	end
end

-- .qst _02 task 1: retrieveMenuText "Replace Air Filters", Count 4,
-- LootDropPercent 100. One "item" per station, so the flags are the count.
function storyArcPreludeScreenPlay:replaceFilter(pPlayer, nodeID)
	if (self:getStage(pPlayer) ~= self.STAGE_FILTERS or self:hasFlag(pPlayer, "vent" .. nodeID)) then
		return
	end

	self:setFlag(pPlayer, "vent" .. nodeID)
	self:removeWaypoint(pPlayer, "vent" .. nodeID)

	local done = self:countFlags(pPlayer, self.vents, "vent")

	if (done < #self.vents) then
		-- task 1's ItemName, with the count the journal would have carried.
		CreatureObject(pPlayer):sendSystemMessage("Air filters have been replaced: " .. done .. " of " .. #self.vents .. ".")
		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
		return
	end

	CreatureObject(pPlayer):sendSystemMessage("Air filters have been replaced")

	self:setStage(pPlayer, self.STAGE_FILTERS_DONE)

	-- task 5's journal entry, and a waypoint back to him for the same reason.
	CreatureObject(pPlayer):sendSystemMessage("Now that the air filters on the ventilation system have been replaced, Foreman Chivos asked that you go see him again.")
	self:giveWaypoint(pPlayer, "chivos", "Return to Foreman Chivos", "Replace Air Filters", self.facility.x, self.facility.y)
end

--[[ .qst _02 task 5, Wait for Signal "mustafar_air_filter_reward". The signal is
     Chivos accepting the report; his answer is s_20. Task 6 (Reward) is nested
     under it. ]]
function storyArcPreludeScreenPlay:signalFilterReward(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_FILTERS_DONE) then
		return
	end

	self:setStage(pPlayer, self.STAGE_REACTOR_OFFER)
	self:removeWaypoint(pPlayer, "chivos")

	-- s_20 (the greeting that opened this) and s_36 (the briefing two options
	-- later) used to be repeated here, into a message box and a system message. He
	-- is saying both in the conversation window now, so both copies are gone.

	-- task 6: Bank Credits 5000, musicOnComplete.
	self:payCredits(pPlayer, self.rewardCredits)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
end

--[[ som_story_arc_prelude_03 -- "Salvage or Die" ]]

-- Chivos's radial at stage 4. The briefing is s_70 through s_78 and s_116; s_118
-- "Yeah, I will see if I can find any." is the acceptance, s_120 the handout.
function storyArcPreludeScreenPlay:startSalvage(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_REACTOR_OFFER) then
		return
	end

	self:setStage(pPlayer, self.STAGE_TRAVEL)

	-- .qst _03 task 1, musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- s_120 used to be repeated into a message box here; it is the screen that
	-- called this, so the copy is gone.

	-- _03's [list] journalEntryDescription, then task 15's.
	CreatureObject(pPlayer):sendSystemMessage("Foreman Chivos has informed you that the core to the mining facility is being overworked. The power rods have already been replaced several times and the core will not last long enough to get a new shipment of the rods before it completely shuts down. The miners recently uncovered the remains of an Old Republic cruiser that crashed into the central volcano which uses the same power rods as the facility. Chivos wants you to scour the area and see if you can salvage some power rods that are in good enough shape to hold the reactor over until a shipment of new rods come in.")
	CreatureObject(pPlayer):sendSystemMessage("Foreman Chivos seems convinced that extra power rods can be found around the crashed capital ship. Travel to the crashed ship and see if you can locate any of these rods. He has told you that the central volcano can be reached by a bridge that connects the burning plains to the volcano.")

	-- task 15 says createWaypoint false; see PROGRESS TRACKING.
	self:giveWaypoint(pPlayer, "crash", "Investigate Crashed Capital Ship", "Salvage or Die", self.crashSite.x, self.crashSite.y)
end

-- .qst _03 task 15 completing: the Radius 500 ring around the wreck. Tasks 13, 12
-- and 6 are all nested under it, so they only go live here.
function storyArcPreludeScreenPlay:notifyEnteredCrashSite(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	self:isObiwanCheckComplete(pPlayer)

	if (self:getStage(pPlayer) ~= self.STAGE_TRAVEL) then
		return 0
	end

	self:setStage(pPlayer, self.STAGE_SALVAGE)
	self:removeWaypoint(pPlayer, "crash")

	-- task 6's journal entry, then the two collection tasks' own.
	CreatureObject(pPlayer):sendSystemMessage("In order to hold the facility over until a shipment can come in the miners need four power rods. Search the area for Power Rod Core Housings to see if any are still intact.")
	CreatureObject(pPlayer):sendSystemMessage("The leaders of the Mustafarian salvage bandits are using power rods as a makeshift scepter. With the lack of apparent rods in the area you will need to take one of these scepters.")
	CreatureObject(pPlayer):sendSystemMessage("Look around the wreckage of the crashed Old Republic cruiser and see if you can find any undamaged power rods.")

	-- Persistence 1 so the observer object is saved and kill credit survives a
	-- logout, the same reason reunite_shard.lua gives for its own.
	createObserver(KILLEDCREATURE, "storyArcPreludeScreenPlay", "notifyKilledCreature", pPlayer, 1)

	return 0
end

-- .qst _03 task 13, Destroy Multiple and Loot: CreatureType
-- som_mustafarian_salvage_leader, NumberItemsRequired 1, LootDropPercent 100.
function storyArcPreludeScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) > self.STAGE_SALVAGE) then
		-- The salvage leg is over; stop listening on this player.
		return 1
	end

	if (self:getStage(pPlayer) ~= self.STAGE_SALVAGE or self:hasFlag(pPlayer, "scepter")) then
		return 0
	end

	if (AiAgent(pVictim):getCreatureTemplateName() ~= self.salvageLeader.template) then
		return 0
	end

	self:setFlag(pPlayer, "scepter")

	-- task 13's LootItemName.
	CreatureObject(pPlayer):sendSystemMessage("You have taken a Power Rod.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:checkRodTasks(pPlayer)

	return 0
end

-- .qst _03 task 12: retrieveMenuText "Remove Power Rod from Core", Count 3,
-- LootDropPercent 100.
function storyArcPreludeScreenPlay:takeRod(pPlayer, nodeID)
	if (self:getStage(pPlayer) ~= self.STAGE_SALVAGE or self:hasFlag(pPlayer, "rod" .. nodeID)) then
		return
	end

	self:setFlag(pPlayer, "rod" .. nodeID)

	local done = self:countFlags(pPlayer, self.rods, "rod")

	CreatureObject(pPlayer):sendSystemMessage("Power Rod recovered: " .. done .. " of " .. #self.rods .. ".")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:checkRodTasks(pPlayer)
end

--[[ .qst _03 task 6, Wait for Tasks on mustafar_rod_one and mustafar_rod_two --
     its own Display Strings are "Take power rod from a leader of the salvage
     bandits." and "Pick-up 3 power rods from around the wreckage.", which is the
     scepter plus the three housings, four rods in all. ]]
function storyArcPreludeScreenPlay:checkRodTasks(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_SALVAGE) then
		return
	end

	if (not self:hasFlag(pPlayer, "scepter") or self:countFlags(pPlayer, self.rods, "rod") < #self.rods) then
		return
	end

	self:setStage(pPlayer, self.STAGE_RODS_DONE)

	-- task 7's journal entry, and a waypoint back to him.
	CreatureObject(pPlayer):sendSystemMessage("Bring the four rods that you found back to Foreman Chivos.")
	self:giveWaypoint(pPlayer, "chivos", "Return to Foreman Chivos", "Salvage or Die", self.facility.x, self.facility.y)
end

--[[ .qst _03 task 7, Wait for Signal "mustafar_rod_reward". The signal is handing
     the rods over; his answer is s_29. Task 14 (Reward) is nested under it. ]]
function storyArcPreludeScreenPlay:signalRodReward(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_RODS_DONE) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE)
	self:removeWaypoint(pPlayer, "chivos")

	-- The observer was created persistent, so an unfired one would sit in the
	-- database forever on a player who never kills anything again; reunite_shard
	-- drops its own for the same reason.
	dropObserver(KILLEDCREATURE, "storyArcPreludeScreenPlay", "notifyKilledCreature", pPlayer)

	-- s_29 used to be repeated into a message box here; it is the screen that
	-- called this, so the copy is gone.

	-- task 14: Bank Credits 5000, lootCount 1, musicOnComplete.
	self:payCredits(pPlayer, self.rewardCredits)
	self:giveReward(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
end

-- Substituted; see THE REWARD. giveItem() into the inventory creates the object
-- for real, which is what the .qst's lootCount 1 asks for.
function storyArcPreludeScreenPlay:giveReward(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("storyArcPreludeScreenPlay: player has no inventory; the necklace could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		print("storyArcPreludeScreenPlay: failed to create " .. self.rewardItem)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for your reward.")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have received a necklace.")
	end
end

--[[ RETIRED: askAboutMensix.

     It put s_85 in a message box behind a radial the player could re-open forever
     at STAGE_DONE. Live does not work that way: s_84 / s_85 sit in branch 3, one
     step after handing the rods over, and once prelude_03 is complete Chivos barks
     s_27 and the tree gives no way back to them. Both are screens in
     story_arc_prelude_chivos.lua now, in that shape. ]]

--[[ som_prelude_obiwan_check

The real gate; see the header for the field values it is built from. Nothing in
this file drives it and no event can, so it is settled on read.
--]]

function storyArcPreludeScreenPlay:rawObiwanCheck(pPlayer)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "obiwanCheck")) or 0) == 1
end

-- One Wait for Tasks task's worth of Task<n> pairs. _G[name] is the lookup
-- screenplays/utils/quest_spawner.lua:24 uses; a screenplay that is not loaded
-- fails the half loudly rather than raising on a nil index.
function storyArcPreludeScreenPlay:isHalfComplete(pPlayer, half)
	for i = 1, #half do
		local entry = half[i]
		local pPlay = _G[entry.screenplay]

		if (pPlay == nil) then
			print("storyArcPreludeScreenPlay: " .. entry.screenplay .. " is not loaded, so " .. entry.quest .. " can never satisfy som_prelude_obiwan_check")
			return false
		end

		if ((tonumber(pPlay:getStage(pPlayer)) or 0) < entry.stage) then
			return false
		end
	end

	return true
end

--[[ The settling getter. Both halves and then their join, which is exactly the
     nesting of tasks 2, 3 and 4. Public: this is what whatever follows the
     prelude should read to know the gate has closed. ]]
function storyArcPreludeScreenPlay:isObiwanCheckComplete(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	if (self:rawObiwanCheck(pPlayer)) then
		return true
	end

	if (not self:isHalfComplete(pPlayer, self.obiwanHalfOne)) then
		return false
	end

	if (not self:isHalfComplete(pPlayer, self.obiwanHalfTwo)) then
		return false
	end

	self:completeObiwanCheck(pPlayer)

	return self:rawObiwanCheck(pPlayer)
end

--[[ .qst task 5, Immediately Complete Quest. Guarded on the raw getter and not on
     isObiwanCheckComplete, or the two would recurse. The quest is journalVisible
     false with no completion text of any kind, so this is silent to the player by
     design; its grantQuestOnComplete is a placeholder and grants nothing. ]]
function storyArcPreludeScreenPlay:completeObiwanCheck(pPlayer)
	if (self:rawObiwanCheck(pPlayer)) then
		return
	end

	self:setFlag(pPlayer, "obiwanCheck")

	print("storyArcPreludeScreenPlay: som_prelude_obiwan_check satisfied for " .. SceneObject(pPlayer):getObjectID()
		.. "; its grantQuestOnComplete is the unresolved placeholder 'whatever we call talk to obi on beach quest', so nothing was granted")
end

-- The Mensix travel point ring. It exists only to settle the gate; see NO TIMERS.
function storyArcPreludeScreenPlay:notifyEnteredArrival(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	self:isObiwanCheckComplete(pPlayer)

	return 0
end

--[[ Radial dispatch

One component table serves all eight snapshot props.
SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely -- so
fillObjectMenuResponse has to add every item we want to see, and adds nothing at
all when this player has no business touching the object.

CHIVOS IS NO LONGER ONE OF THEM.

He used to be, because his conversation was believed lost -- see WITHDRAWN in the
header for why that was wrong. Three things went when the tree arrived:

  * his seven radial labels in getRadialText, two of which ("Report the air filters
    replaced" and "Ask Foreman Chivos about the job") were invented because nothing
    shipped them;
  * talkToChivos, which answered by pushing his lines out as system messages and
    SUI boxes, and which turned s_101 / s_103 -- live's REPAIR path for a player who
    never picked the vent job up -- into a routine mid-task reminder it is not;
  * the level 75 refusal in front of startSupplies, which live has nowhere.

All of it is a real conversation now:
mobile/conversations/mustafar/story_arc_prelude_chivos.lua, dispatched by
screenplays/mustafar/quest/conversation/chivos_conv_handler.lua. The five functions
those radials used to call are unchanged and are what the tree's five actions call.
--]]

-- Which radial, if any, this player should be offered on a given prop. The texts
-- are the .qst's own retrieveMenuText.
function storyArcPreludeScreenPlay:getRadialText(pPlayer, role, objectID)
	local stage = self:getStage(pPlayer)

	if (role == "locker") then
		if (stage == self.STAGE_SUPPLIES) then
			return "Restock Supplies"                          -- _01 task 4
		end
	elseif (role == "vent") then
		if (stage == self.STAGE_FILTERS and not self:hasFlag(pPlayer, "vent" .. objectID)) then
			return "Replace Air Filters"                       -- _02 task 1
		end
	elseif (role == "rod") then
		if (stage == self.STAGE_SALVAGE and not self:hasFlag(pPlayer, "rod" .. objectID)) then
			return "Remove Power Rod from Core"                -- _03 task 12
		end
	end

	return nil
end

--[[ RETIRED: talkToChivos. See CHIVOS IS NO LONGER ONE OF THEM above.

     Its stage-by-stage answers are chivos_conv_handler:getInitialScreen now, in
     SOE's own eight-condition order, and the lines it pushed out as pairs of system
     messages are screens with the player's shipped replies attached. Two of its
     stage arms were also wrong about what they were quoting:

       * STAGE_SUPPLIES said s_55 then s_59 in one breath. Live makes s_59 the
         answer to the player choosing s_57 "Not yet." -- it is an exchange, not a
         monologue.
       * STAGE_FILTERS said s_101 then s_103. Those belong to live's condition 7,
         hasCompletedSupply -- the REPAIR greeting for a player whose vent job was
         never granted, ending in grantVentQuest. Using them as the routine
         mid-filters reminder put a repair path in front of a player who did not
         need one. Live's routine reminder at that point is condition 6's s_55. ]]

StoryArcPreludeMenuComponent = {}

function StoryArcPreludeMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local objectID = SceneObject(pSceneObject):getObjectID()
	local role = readStringData(objectID .. ":storyArcPreludeRole")
	local text = storyArcPreludeScreenPlay:getRadialText(pPlayer, role, objectID)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function StoryArcPreludeMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local objectID = SceneObject(pSceneObject):getObjectID()
	local role = readStringData(objectID .. ":storyArcPreludeRole")

	-- Every radial is also a chance to settle the gate; see NO TIMERS.
	storyArcPreludeScreenPlay:isObiwanCheckComplete(pPlayer)

	if (role == "locker") then
		storyArcPreludeScreenPlay:restockLocker(pPlayer)
	elseif (role == "vent") then
		storyArcPreludeScreenPlay:replaceFilter(pPlayer, objectID)
	elseif (role == "rod") then
		storyArcPreludeScreenPlay:takeRod(pPlayer, objectID)
	end

	return 0
end
