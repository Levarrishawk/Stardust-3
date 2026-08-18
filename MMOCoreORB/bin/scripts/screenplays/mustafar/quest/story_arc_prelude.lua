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

must_foreman_chivos is registered (mobile/custom_content/som/serverobjects.lua:66,
customName "Foreman Chivos") and its conversationTemplate is empty, so he is given
a radial here and answers in his own shipped strings. The 60-string tree itself is
not reconstructed in this file -- see WHAT IS NOT MODELLED.

WHERE CHIVOS STANDS  --  placed, not quoted

Nothing places him. s_68 "Welcome to Mensix Corp." puts him inside the company's
own facility, and mensix_mining_facility_main.lua already stands both of the
facility's other quest givers -- pei_yi (-77.1, 10.8, 67.5) and diskret_stahn
(-75.4, 10.8, 66.3) -- in cell 12112226 of that POB, along with four background
miners at (-88.3, 49.4), (-86.8, 41.9), (-80.6, 42.2) and (-81.1, 39.7), all at
cell height 10.8. He is set at (-82, 10.8, 55), inside the ground those seven
occupants bound and at least 8 m clear of every one of them.

His respawn timer is 300 rather than the 0 the neighbouring spawns use, because
his pvpBitmask is ATTACKABLE and he is the only way into all three quests:
AiAgentImplementation.cpp:2283 only builds a RespawnCreatureTask when the timer is
greater than 0, so at 0 a player who kills him closes the prelude for everyone
until the next restart.

THE SALVAGE LEADERS  --  placed, not quoted

_03 task 13 wants som_mustafarian_salvage_leader. The template that shipped in
this tree is must_salvage_bandit_leader_01 (registered at
mobile/custom_content/som/serverobjects.lua:73, customName "Salvage Bandit
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
object template. Nothing here resolves it: no datatables/quest/* or
datatables/loot/* row in any TRE, no string/en STF row, and no item_tow or
tow_necklace path anywhere in this tree. Every other TOW reward in this arc has
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

Chivos's conversation tree is not reconstructed. story_arc_prelude_chivos.stf's
do_not_edit row says the file "is automatically generated by the
SwgConversationEditor", so a real branching tree existed, but wiring one needs a
new mobile/conversations/mustafar/ file, a handler, an include in
mobile/conversations.lua and a conversationTemplate on the creature -- two of them
shared files this file is not the owner of. His lines are quoted into the radial
and its message boxes so that nothing he says is lost in the meantime.

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

	-- .qst [list] Level, on all three preludes. obiwan_check carries none.
	requiredLevel = 75,

	-- Placed, not quoted; see WHERE CHIVOS STANDS. Cell 12112226 of the Mensix
	-- mining facility POB, the room pei_yi and diskret_stahn already stand in.
	chivos = {
		template = "must_foreman_chivos",
		cellID = 12112226,
		x = -82,
		z = 10.8,
		y = 55,
		heading = 0,
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
	self.chivosID = SceneObject(pChivos):getObjectID()

	writeStringData(self.chivosID .. ":storyArcPreludeRole", "chivos")
	SceneObject(pChivos):setObjectMenuComponent("StoryArcPreludeMenuComponent")
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

-- Chivos's radial at stage 0. His pitch is s_93 -> s_95 -> s_97 -> s_99, and s_108
-- "You said you would pay? Sure, I would like a job." is the acceptance.
function storyArcPreludeScreenPlay:startSupplies(pPlayer)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	if (CreatureObject(pPlayer):getLevel() < self.requiredLevel) then
		CreatureObject(pPlayer):sendSystemMessage("Foreman Chivos will not trust a company contract to someone of your experience. (Requires combat level "
			.. self.requiredLevel .. ".)")
		return
	end

	self:setStage(pPlayer, self.STAGE_SUPPLIES)

	-- .qst _01 task 0, musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- s_110, his handout.
	self:showMessageBox(pPlayer, "Supplies for the Miners",
		"That is great news. Here are the supplies that need to be delivered, and I will put the location of the camp that they need to be delivered to in your datapad. All you need to do is find the supply locker and put the goods directly in there. If you do a good enough job, maybe I will have another job for you. Oh, watch your step out there. Mustafar is not a gentle world, but I guess you could tell that just by looking around.")

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

	self:showMessageBox(pPlayer, "Return to Foreman Chivos",
		"Miners restocked...check. Vents nice and clean...check. Good work out there. I knew you were the type of person to get things done. Mensix has need of good people like you. Granted, our company bylaws forbid us to officially hire anyone who isn't a Mustafarian, but we do occasionally hire freelancers.")

	-- task 6: Bank Credits 5000, musicOnComplete.
	self:payCredits(pPlayer, self.rewardCredits)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")

	-- s_36, the freelance offer that leads straight into the reactor briefing.
	CreatureObject(pPlayer):sendSystemMessage("Whew! I am glad you said that because we have a major problem that needs to be solved immediately. The way you took care of the other jobs makes me sure that you are just the person we need.")
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

	self:showMessageBox(pPlayer, "Salvage or Die",
		"You have not only my thanks but the company's thanks as well. Look around the wreckage of the crash on the slopes of the central volcano. When our crew was there, they reported seeing a bunch of salvage bandits crawling all over the ship, so watch your back. Those Mustafarians don't work for any company and will do anything to make a buck...including shooting anyone they don't know.")

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

	self:showMessageBox(pPlayer, "Return to Foreman Chivos",
		"You did a great job. As promised, here is your payment for saving us all. I knew you were going places when we first talked...Milo Mensix wants to talk to you.")

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

-- s_84 / s_85, the only thing left to ask him once the prelude is over. Milo
-- Mensix is not in this batch, so this is flavour and grants nothing.
function storyArcPreludeScreenPlay:askAboutMensix(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_DONE) then
		return
	end

	self:showMessageBox(pPlayer, "Who is Milo Mensix?",
		"Only the head of Mensix Corp. If he wants to see you, it is about something big. You should go see him right away. Thanks again for coming through.")
end

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

One component table serves Chivos and all eight snapshot props.
SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely -- so
fillObjectMenuResponse has to add every item we want to see, and adds nothing at
all when this player has no business touching the object.
--]]

-- Which radial, if any, this player should be offered on a given object. The prop
-- texts are the .qst's own retrieveMenuText; Chivos's are his own shipped player
-- lines except the two marked, which nothing ships.
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
	elseif (role == "chivos") then
		if (stage == 0) then
			return "You mentioned that you needed some help?"  -- s_93
		elseif (stage == self.STAGE_FILTERS) then
			return "Yeah, where were those vents again?"       -- s_102
		elseif (stage == self.STAGE_FILTERS_DONE) then
			return "Report the air filters replaced"           -- not a shipped string
		elseif (stage == self.STAGE_REACTOR_OFFER) then
			return "Yeah, I can use the work now."             -- s_21
		elseif (stage == self.STAGE_RODS_DONE) then
			return "Yes, here they are."                       -- s_28
		elseif (stage == self.STAGE_DONE) then
			return "Who is Milo Mensix?"                       -- s_84
		end

		return "Ask Foreman Chivos about the job"              -- not a shipped string
	end

	return nil
end

-- Chivos answering. Everything he says is quoted; the two reminders are the
-- exchanges SOE wrote for a player who comes back mid-task.
function storyArcPreludeScreenPlay:talkToChivos(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == 0) then
		self:startSupplies(pPlayer)
	elseif (stage == self.STAGE_SUPPLIES) then
		-- s_55 and s_59.
		CreatureObject(pPlayer):sendSystemMessage("Have you finish those tasks I asked you to do?")
		CreatureObject(pPlayer):sendSystemMessage("Ok, you should get back to work then. Come back and talk to me when you are done. Thanks again.")
	elseif (stage == self.STAGE_FILTERS) then
		-- s_101 and s_103.
		CreatureObject(pPlayer):sendSystemMessage("You shouldn't be back here. I thought I asked you to clean out those air vents which are around the facility.")
		CreatureObject(pPlayer):sendSystemMessage("There are four of them that surround the facility. None of them are very far from here, so you shouldn't have that much trouble finding them.")
	elseif (stage == self.STAGE_FILTERS_DONE) then
		self:signalFilterReward(pPlayer)
	elseif (stage == self.STAGE_REACTOR_OFFER) then
		self:startSalvage(pPlayer)
	elseif (stage == self.STAGE_TRAVEL or stage == self.STAGE_SALVAGE) then
		-- s_11 and s_26.
		CreatureObject(pPlayer):sendSystemMessage("Did you manage to get all of my power rods yet?")
		CreatureObject(pPlayer):sendSystemMessage("Ok, keep up the good work.")
	elseif (stage == self.STAGE_RODS_DONE) then
		self:signalRodReward(pPlayer)
	elseif (stage == self.STAGE_DONE) then
		self:askAboutMensix(pPlayer)
	end
end

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
	elseif (role == "chivos") then
		storyArcPreludeScreenPlay:talkToChivos(pPlayer)
	end

	return 0
end
