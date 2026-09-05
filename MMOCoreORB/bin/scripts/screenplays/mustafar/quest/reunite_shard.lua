--[[
Fragments of the past  --  som_kenobi_reunite_shard_1 + _2 + _3

SOURCE OF RECORD

quest/som_kenobi_reunite_shard_1.qst, _2.qst and _3.qst in the client TREs. Every
message box title and body below is quoted verbatim from them, as are the radial
strings ("Gather up splinters", "Start fusion process", "Retrieve crystal"), the
five locations and their radii, the creature types, the loot drop percentages and
the fusion timer.

_1's last task is Show Message Box with grantQuestOnComplete =
som_kenobi_reunite_shard_2; _2's last task is Immediately Complete Quest with
grantQuestOnComplete = som_kenobi_reunite_shard_3. The three are one continuous
player-facing chain, so they live in one screenplay here.

WHERE THE OBJECTS COME FROM

Three of the four are snapshot props. snapshot/mustafar.ws in stardust_03.tre --
the snapshot the server actually loads, checked against its TreFiles order in
conf/config.lua -- places them, and PlanetManagerImplementation::loadSnapshotObjects()
instantiates each node with objectID == the node ID, so getSceneObject(<nodeID>)
returns the object the client is already drawing:

    node 12111454  quest_start/som_kenobi_reunite_shard          (-4385.03, 86.81, 3165.60)
    node 12111453  som_kenobi_reunite_shard_splinters_1          (-4370.84, 94.28, 3229.57)
    node 12110454  som_kenobi_reunite_shard_splinters_2          ( -744.49, 87.10, 6137.30)

(Cross-checked against mtg_patch_023.tre's copy of mustafar.ws: same three nodes,
same positions, so Levarris's snapshot work did not move them.)

Note how well those line up with the .qst on their own: node 12111453 sits 1 m
from _1 task 1's Go to Location (-4370, 3229), and node 12110454 sits 6 m from
_2 task 5's (-742, 6132). That is the confirmation that these node IDs are the
right objects, not a guess.

THE FUSION MACHINE  --  INSIDE THE OLD RESEARCH FACILITY

_3 hangs on object/tangible/quest/som_kenobi_fusion_machine.iff. The server
template exists here (object/custom_content/tangible/quest/som_kenobi_fusion_machine.lua,
included from that directory's serverobjects.lua:362) and its appearance ships in
the client, but no mustafar.ws in any TRE places it, so there is no snapshot node
to attach to and it has to be spawned.

CORRECTION. An earlier version of this file said the machine could not go indoors
because "no mustafar snapshot places that building either", and stood it out on the
surface instead. That was wrong, and the wrong half was the premise, not the
reasoning built on it. snapshot/mustafar.ws does place the Old Research Facility --
twelve copies of it, at z=-4746.16, x=-6748.81 to 951.18, spaced 700 apart, off the
playable map. That is SOE's instance pool, and the copies load live with working
cells; a boot probe resolved 22 of 22 of the facility's named cells on copy
12115823. The building was there the whole time. The search that missed it was
looking on the playable map. The pool, and how a player gets into a copy, live in
screenplays/mustafar/mustafar_instances.lua.

So the machine goes inside, in mediumroom28 -- and the position is now QUOTED. The
facility's server-side dungeon spawn table carries a row for this exact template:
room mediumroom28, 24.0179 / -67.2 / -12.6178, yaw 89.9999. That is where it stood
in live, and the table is the authority. The entry below rounds that yaw to 90 and
says so; everything else is the table's to the digit.

SECOND CORRECTION, and the room was the only part of the old note that survived it.
This section used to open "So the machine goes where it stood in live" and then
DERIVE the spot, which is not the same thing as reading it. The derivation went:
mediumroom28 is the facility's power hall -- som_old_republic_facility.ilf puts 25
barrels, 14 Corellian power box nodes, 12 power connectors, 9 bandit cooling units,
a tank farm and sixteen terminal banks in it, and no other room in the building
reads anything like it, while _3's journal line asks for "a machine with an extreme
heat and energy output". Then the coordinate was bracketed between real objects
rather than picked out of a gap: at that z band the .ilf places floor terminals at
x=27.67 and x=42.33, so x=34 went between them, at those terminals' own floor
height, facing 0.

The room pick was right and the floor height was right -- -67.2 is live's value to
the decimal. Everything else was wrong: x by 10 m, z by 6.4 m, and the heading by a
full 90 degrees.

ROOT CAUSE: the dungeon spawn tables were not in the searched set, so the .ilf was
treated as the best available evidence when it is not evidence of placement at all.
A .ilf says what the building was FURNISHED with; the dungeon spawn table says what
the server PUTS in it. Only the second is a placement, and only the second carries a
yaw -- and the yaw is the tell, because a derivation cannot produce one and this
entry had to default it to 0. A heading of 0 sitting next to two hard-won position
values is the shape of a guess.

Worth keeping straight, because the two corrections here are easy to conflate: the
CORRECTION above is about the BUILDING and it was sound. This one is about the SPOT
INSIDE it. Getting the first one right is what kept the second error hidden -- the
machine was in the right room, so nothing ever looked wrong.

_3's tasks give no location at all (Planet tatooine, 0/0/0 -- this format's
"unset"), so the .qst was never going to settle this either way.

One machine is spawned per pool copy, because each copy is a separate building.
They are stateless furniture -- progress lives on the player, so which copy a
player is standing in does not matter. The copy list comes from
MustafarInstances:getPoolBuildings and is never re-listed here, so the two files
cannot drift apart.

The waypoint for this step points at the facility's exterior door on the surface
(snapshot node 12110161, -775.93/6088.28), not at the machine: an interior
coordinate in a waypoint means nothing to the client. The player is guided to the
door and goes in from there. That door is still inside som_kenobi_historian_1.qst
task 0's Go to Location (mustafar -745/6048 radius 65, "an old bunker that used to
belong to what was known as the Old Republic ... in the very North East edge of the
continent"), which is the shipped confirmation that this building is that bunker.

CREATURE SPAWNS  --  two of the three legs, and only two

_2 has three Destroy-and-Loot legs:

  * som_mustafarian_phantom_bandit (taskName shard6) already lives in the world.
    screenplays/mustafar/regions/storm_lord_region.lua spawns five of them on the
    canyon approach at 457-483 / 5692-5796, and the .qst's own task area for that
    leg is (485, 5764) radius 100 -- every one of the five is inside it. Levarris's
    population serves this leg; this screenplay spawns nothing there.

  * som_kenobi_reunite_tulrus (taskName shard5) and som_kenobi_reunite_dark_jedi
    (taskName shard4) appear in no spawn table, no lair table and no region
    screenplay in this tree. They were server-side spawns in live and that data did
    not ship, so they are spawned here, at their own .qst task areas, with a
    respawn timer.

    The counts are a placement choice, not a shipped number: three tulrus (the
    template is MOB_HERBIVORE with a herd read) and one dark jedi. Checked first
    for collisions -- (-1881, 3986) has no existing mustafar spawn within 200 m at
    all, and (-4349, 3397) has treasure-hunter and blackguard camps around its
    edges but nothing at the centre.

The .qst names the tulrus "som_kenobi_tulrus"; the template that shipped in this
tree is "som_kenobi_reunite_tulrus". Same creature, different name -- spawnMobile
and the kill credit both use the repo name.

KILL CREDIT

createObserver(KILLEDCREATURE, ...) on the player, the same mechanism
map_exploration.lua in this arc uses. It is registered with persistence 1
(DirectorManager.cpp:createObserver takes persistence as its optional 5th
argument) so the observer object is saved and kill credit survives a logout --
without it the chain would silently stop counting after a relog.

Only the area gate is needed on top of the template match: none of the three
target templates exists anywhere on Mustafar except in its own leg's area, so a
matching kill is by definition the right kill.

RADIALS

The .qst drives the box, both splinter piles and the fusion machine through
Retrieve Item tasks, whose retrieveMenuText only shows while that task is live.
There is no quest journal to hang that off here (see PROGRESS TRACKING), so each
object gets a Lua ObjectMenuComponent that offers its radial only to a player whose
stored stage says that step is next.

One string is this file's wording rather than a shipped one: "Search the old box".
_1's opening task is a Show Message Box with no retrieveMenuText, because in live
the quest_start object's own use action fired it. Everything else is quoted.

PROGRESS TRACKING

None of the three quests has a row in datatables/player/quests.iff -- the table the
server loads is stardust_03.tre's, whose only Mustafar rows are the 45 exploration
markers. Adding a row would mean authoring a TRE. Progress therefore lives in
persistent screenplay data on the player's ghost: waypoints, message boxes and
system messages, but no journal entry.

WAYPOINTS  --  a deviation, one line to revert

Every task in all three .qst files carries createWaypoint = 0: live gave this chain
no waypoints at all, because the crystal humming when you get close was meant to be
the whole navigation mechanic. That works when a few thousand people are comparing
notes. self.hintWaypoints below marks the objective locations instead, matching how
the rest of this arc's screenplays already behave. Set it to false for the shipped
behaviour; the humming messages fire either way.

THE REWARD  --  SUBSTITUTED, and it is cosmetic

_3's Reward task pays Experience Amount 0 and Bank Credits 0 and awards lootCount 1
/ lootName item_tow_buff_crystal_02_02. The stored Experience Amount 0 is real;
live still paid, because the server recomputed from quest_experience (see
mustafar_quest_xp.lua). As with the other TOW rewards in this arc,
lootName is a live server-side static-item name, not an object template. The name
resolves to "Wild Force Shard" in string/en/static_item_n.stf, but an exhaustive
sweep of every shipped shared_*.iff finds no object template carrying that
objectName, so granting the live item would mean authoring an object. Live wikis
name it "Wild Force Shard (Defensive Burst)", which can only be matched by
description.

The substitute is object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_buff_crystal_usable.iff
-- a real server template registered via ObjectTemplates:addTemplate in
object/custom_content/tangible/dungeon/mustafar/obiwan_finale/, included from that
directory's serverobjects.lua:4, appearance shipping in mtg_patch_019.tre. It is
Mustafar's, it is Obi-Wan's, it is a buff crystal, and it exists.

BE CLEAR ABOUT WHAT IT DOES: it is a trophy. It grants no buff. Handing out a real
buff from Lua is not possible in this tree -- CreatureObject::addBuff (CreatureObject.idl:720)
takes a Buff object, Buff has no DirectorManager registration, and there is no way
to construct one from script. Anything claiming otherwise here would be a grant
that silently does nothing. If a buff is wanted later it needs C++, not this file.

It is handed over with giveItem() into the player's inventory, which creates the
object for real -- deliberately NOT addRewardedSchematic, which fails closed when
the path is not in scripts/managers/crafting/schematics.lua and would grant nothing.

To restore the live item later, only self.rewardItem changes.

WHAT IS NOT MODELLED

The Retrieve Item tasks mean that in live the player carried "Crystal splinters",
"Assemble crystal" and "Assembled crystal" as inventory objects. Only the splinter
tangibles exist here, and they exist as world props rather than as carryable items;
minting inventory copies would be content authoring, not wiring. Those steps
advance the stage and show their message box without minting an item. Nothing
downstream in any of the three .qst files reads them; they were progress markers.

_2's Faction Amount and Experience Amount are 0 on every task. Faction stays unpaid;
the stored Experience Amount 0 is real, but live still paid because the server
recomputed from quest_experience (see mustafar_quest_xp.lua).
--]]

local JournalMirror = require("managers.quest.journal_mirror")

reuniteShardScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "reuniteShardScreenPlay",

	-- Snapshot nodes; see the header.
	questStartNodeID = 12111454,
	splinters1NodeID = 12111453,

	-- _1 task 1, Go to Location: mustafar (-4370, 94, 3229), Radius 25.
	vibration = { x = -4370, z = 94, y = 3229, radius = 25, name = "Crystal splinters" },

	-- _2's four legs. Each is a Go to Location whose child is a Show Message Box
	-- ("Splinters awake", same text on all four) and then the collection task.
	-- They are siblings under task 0, so all four are open at once and can be done
	-- in any order.
	legs = {
		{
			key = "shard6",                                     -- _2 task 16
			x = 485, z = 129, y = 5764, radius = 100,
			kind = "kill",
			template = "som_mustafarian_phantom_bandit",
			dropPercent = 60,
			spawnCount = 0,                                     -- storm_lord_region.lua already places five
			waypointName = "Canyon approach",
		},
		{
			key = "shard5",                                     -- _2 task 15
			x = -1881, z = 85, y = 3986, radius = 100,
			kind = "kill",
			template = "som_kenobi_reunite_tulrus",             -- .qst calls it som_kenobi_tulrus
			dropPercent = 100,
			spawnCount = 3,
			waypointName = "Tulrus grazing ground",
		},
		{
			key = "shard4",                                     -- _2 task 14
			x = -4349, z = 81, y = 3397, radius = 50,
			kind = "kill",
			template = "som_kenobi_reunite_dark_jedi",
			dropPercent = 100,
			spawnCount = 1,
			waypointName = "Dark presence",
		},
		{
			key = "shard3",                                     -- _2 task 13
			x = -742, z = 87, y = 6132, radius = 100,
			kind = "retrieve",
			nodeID = 12110454,
			waypointName = "Old research facility",
		},
	},

	-- Inside the Old Research Facility, one per pool copy. See THE FUSION MACHINE
	-- in the header for the room, the coordinate and why they are what they are.
	-- x/z/y follow this tree's spawnSceneObject order: z is the height.
	fusion = {
		template = "object/tangible/quest/som_kenobi_fusion_machine.iff",

		pool = "old_republic_facility",
		cell = "mediumroom28",

		-- LIVE ROW: the facility's dungeon spawn table places this exact template
		-- here. Was 34.0 / -67.2 / -19.0 heading 0, derived off the .ilf's floor
		-- terminals -- right room, right height, 10 m and 6.4 m and 90 degrees out.
		-- See the SECOND CORRECTION under THE FUSION MACHINE.
		--
		-- The three positions are the table's to the digit. The heading is the one
		-- value that is NOT verbatim: live stores 89.9999, which is a right angle
		-- that has been through a float. It is rounded to 90 deliberately, and the
		-- rounding is written down rather than done silently, because "quoted" has
		-- to mean quoted -- the difference is 1.7e-6 radians after math.rad and
		-- cannot matter, but a label that is loosely true is how the old guesses
		-- survived as long as they did.
		x = 24.0179, z = -67.2, y = -12.6178, heading = 90,

		minTime = 10,                                           -- _3 task 3, Min Time
		maxTime = 15,                                           -- _3 task 3, Max Time

		-- Surface waypoint: the facility's exterior door, snapshot node 12110161.
		waypointName = "Old Republic Facility",
		waypointX = -775.93, waypointY = 6088.28,
	},

	-- Substituted for the .qst's item_tow_buff_crystal_02_02; see THE REWARD.
	rewardItem = "object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_buff_crystal_usable.iff",

	-- See WAYPOINTS in the header. false is the shipped behaviour.
	hintWaypoints = true,

	-- Filled in at start(); active areas only exist at runtime.
	legByAreaID = {},
	vibrationAreaID = 0,
}

-- JOURNAL MIRROR (J-3, 2026-09-04): stage -> client journal task bits, from the SOE task tree in
-- this header and scratch/mustafar-stage-task-map.md §reunite_shard. Screenplay data stays truth.
reuniteShardScreenPlay.journalMap = {
	[1] = { quest = "som_kenobi_reunite_shard_1", complete = {0}, activate = {1} }, -- 1→_1 t1 Go to Location
	[2] = { quest = "som_kenobi_reunite_shard_1", complete = {1}, activate = {3} }, -- 2→_1 t3 Retrieve
	[3] = { -- 3→_1 t4 complete + _2 t13-t16 all live (t16 OOR)
		{ quest = "som_kenobi_reunite_shard_1", complete = {3, 4}, finish = true },
		{ quest = "som_kenobi_reunite_shard_2", activate = {13, 14, 15} },
	},
	[4] = { -- 4→_2 t12 grants _3; _3 t2 live
		{ quest = "som_kenobi_reunite_shard_2", finish = true },
		{ quest = "som_kenobi_reunite_shard_3", activate = {2} },
	},
	[5] = { quest = "som_kenobi_reunite_shard_3", complete = {2}, activate = {3} }, -- 5→_3 t3 Timer
	[6] = { quest = "som_kenobi_reunite_shard_3", complete = {3}, activate = {4} }, -- 6→_3 t4 Retrieve
	[7] = { quest = "som_kenobi_reunite_shard_3", complete = {4, 5, 6}, finish = true }, -- 7→_3 t6 Reward
}

registerScreenPlay("reuniteShardScreenPlay", true)

function reuniteShardScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachSnapshotObjects()
		self:spawnLegAreas()
		self:spawnLegMobiles()
		self:spawnFusionMachine()
	end
end

function reuniteShardScreenPlay:attachSnapshotObjects()
	local props = {
		{ nodeID = self.questStartNodeID, role = "box" },
		{ nodeID = self.splinters1NodeID, role = "splinters1" },
	}

	for i = 1, #self.legs do
		if (self.legs[i].kind == "retrieve") then
			props[#props + 1] = { nodeID = self.legs[i].nodeID, role = "splinters2" }
		end
	end

	for i = 1, #props do
		local pObject = getSceneObject(props[i].nodeID)

		if (pObject == nil) then
			print("reuniteShardScreenPlay: snapshot object " .. props[i].nodeID .. " (" .. props[i].role .. ") was not found; that step of the chain will be unreachable")
		else
			writeStringData(props[i].nodeID .. ":reuniteRole", props[i].role)
			SceneObject(pObject):setObjectMenuComponent("ReuniteShardMenuComponent")
		end
	end
end

function reuniteShardScreenPlay:spawnLegAreas()
	local pVibration = spawnActiveArea("mustafar", "object/active_area.iff", self.vibration.x, self.vibration.z, self.vibration.y, self.vibration.radius, 0)

	if (pVibration == nil) then
		print("reuniteShardScreenPlay: failed to spawn the vibration area; reunite_shard_1 cannot be finished")
	else
		self.vibrationAreaID = SceneObject(pVibration):getObjectID()
		createObserver(ENTEREDAREA, "reuniteShardScreenPlay", "notifyEnteredVibrationArea", pVibration)
	end

	for i = 1, #self.legs do
		local leg = self.legs[i]
		local pArea = spawnActiveArea("mustafar", "object/active_area.iff", leg.x, leg.z, leg.y, leg.radius, 0)

		if (pArea == nil) then
			print("reuniteShardScreenPlay: failed to spawn the area for leg " .. leg.key .. "; that leg cannot be started")
		else
			self.legByAreaID[SceneObject(pArea):getObjectID()] = leg
			createObserver(ENTEREDAREA, "reuniteShardScreenPlay", "notifyEnteredLegArea", pArea)
		end
	end
end

-- Only the two legs whose creatures ship with no spawn data anywhere; see
-- CREATURE SPAWNS in the header.
function reuniteShardScreenPlay:spawnLegMobiles()
	for i = 1, #self.legs do
		local leg = self.legs[i]

		for n = 1, (leg.spawnCount or 0) do
			local x = leg.x + getRandomNumber(-12, 12)
			local y = leg.y + getRandomNumber(-12, 12)
			local z = getWorldFloor(x, y, "mustafar")

			if (spawnMobile("mustafar", leg.template, 300, x, z, y, getRandomNumber(360) - 180, 0) == nil) then
				print("reuniteShardScreenPlay: failed to spawn " .. leg.template .. "; leg " .. leg.key .. " will have nothing to kill")
			end
		end
	end
end

-- One machine per copy of the Old Research Facility; see THE FUSION MACHINE.
function reuniteShardScreenPlay:spawnFusionMachine()
	local buildings = MustafarInstances:getPoolBuildings(self.fusion.pool)

	if (#buildings == 0) then
		print("reuniteShardScreenPlay: MustafarInstances has no " .. self.fusion.pool .. " pool; reunite_shard_3 cannot be finished")
		return
	end

	local placed = 0

	for i = 1, #buildings do
		local pBuilding = getSceneObject(buildings[i])

		if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
			print("reuniteShardScreenPlay: " .. self.fusion.pool .. " copy " .. buildings[i] .. " is missing; it gets no fusion machine")
		else
			local pCell = BuildingObject(pBuilding):getNamedCell(self.fusion.cell)

			if (pCell == nil) then
				print("reuniteShardScreenPlay: copy " .. buildings[i] .. " has no cell named " .. self.fusion.cell .. "; it gets no fusion machine")
			else
				local pMachine = spawnSceneObject("mustafar", self.fusion.template, self.fusion.x, self.fusion.z, self.fusion.y, SceneObject(pCell):getObjectID(), math.rad(self.fusion.heading))

				if (pMachine == nil) then
					print("reuniteShardScreenPlay: failed to spawn " .. self.fusion.template .. " in copy " .. buildings[i])
				else
					writeStringData(SceneObject(pMachine):getObjectID() .. ":reuniteRole", "fusion")
					SceneObject(pMachine):setObjectMenuComponent("ReuniteShardMenuComponent")
					placed = placed + 1
				end
			end
		end
	end

	if (placed == 0) then
		print("reuniteShardScreenPlay: no fusion machine was placed in any " .. self.fusion.pool .. " copy; reunite_shard_3 cannot be finished")
	end
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage      0  not started
	           1  splinters taken from the box, heading for the vibration area
	           2  vibration area reached; splinters_1 ready to gather
	           3  reunite_shard_2 active; the four legs are open
	           4  reunite_shard_3 active; the fusion machine is ready to start
	           5  fusion process running
	           6  fusion finished; the crystal is ready to retrieve
	           7  complete
	seen_<key> 1 once the player has entered that leg's area (its collection task
	           only goes live after the "Splinters awake" box, exactly as the .qst
	           nests it)
	got_<key>  1 once that leg's splinter has been collected
	wp_<key>   waypoint id currently handed out for that objective, absent if none
--]]

function reuniteShardScreenPlay:rawStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

--[[ The fusion is driven by createEvent, which does not survive a server restart, while
     the stage does. Reading the stage settles an overdue fusion as well, so a restart
     inside those 10-15 s cannot park a player at stage 5, where the machine offers no
     radial at all and finishFusion is the only writer of stage 6. Both paths funnel into
     finishFusion, which is guarded on the raw stage, so whichever arrives first wins. ]]
function reuniteShardScreenPlay:getStage(pPlayer)
	local stage = self:rawStage(pPlayer)

	if (stage == 5) then
		local due = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "fusionUntil")) or 0

		if (due ~= 0 and getTimestamp() >= due) then
			self:finishFusion(pPlayer)

			return self:rawStage(pPlayer)
		end
	end

	return stage
end

function reuniteShardScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	JournalMirror.applyStage(pPlayer, self.journalMap, stage)   -- J-3 journal mirror
end

function reuniteShardScreenPlay:hasFlag(pPlayer, key)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) == 1
end

function reuniteShardScreenPlay:setFlag(pPlayer, key)
	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
end

function reuniteShardScreenPlay:getLeg(key)
	for i = 1, #self.legs do
		if (self.legs[i].key == key) then
			return self.legs[i]
		end
	end

	return nil
end

--[[ Waypoints

Keyed, because reunite_shard_2 has four objectives open at once. See WAYPOINTS in
the header for why these exist at all.
--]]

function reuniteShardScreenPlay:giveWaypoint(pPlayer, key, name, description, x, y)
	if (not self.hintWaypoints) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer, key)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key, tostring(waypointID))
end

function reuniteShardScreenPlay:removeWaypoint(pPlayer, key)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)
end

function reuniteShardScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("reuniteShardScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

-- The .qst message boxes are read-and-dismiss; nothing branches on the button.
function reuniteShardScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

-- Which radial, if any, this player should be offered on a given object.
function reuniteShardScreenPlay:getRadialText(pPlayer, role)
	local stage = self:getStage(pPlayer)

	if (role == "box") then
		if (stage == 0) then
			return "Search the old box"                  -- not a shipped string; see the header
		end
	elseif (role == "splinters1") then
		if (stage == 2) then
			return "Gather up splinters"                 -- _1 task 3 retrieveMenuText
		end
	elseif (role == "splinters2") then
		if (stage == 3 and self:hasFlag(pPlayer, "seen_shard3") and not self:hasFlag(pPlayer, "got_shard3")) then
			return "Gather up splinters"                 -- _2 task 13 retrieveMenuText
		end
	elseif (role == "fusion") then
		if (stage == 4) then
			return "Start fusion process"                -- _3 task 2 retrieveMenuText
		elseif (stage == 6) then
			return "Retrieve crystal"                    -- _3 task 4 retrieveMenuText
		end
	end

	return nil
end

--[[ reunite_shard_1 ]]

-- _1 task 0: Show Message Box "Splinters of a crystal",
-- musicOnActivate sound/mus_mustafar_quest_exception.snd.
function reuniteShardScreenPlay:searchBox(pPlayer, pBox)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, 1)

	self:showMessageBox(pPlayer, pBox, "Splinters of a crystal",
		"Inside the old box you find some small splinters of what appears to be a crystal. You scoop them up and put them in your backpack for now.")

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- _1 task 1's journal entry, "Crystal splinters".
	CreatureObject(pPlayer):sendSystemMessage("You've found some splinters of a crystal in a box. Not sure what to do with them yet you're just holding on to them.")

	self:giveWaypoint(pPlayer, "vibration", self.vibration.name, "Fragments of the past", self.vibration.x, self.vibration.y)
end

-- _1 task 1 completing, which fires task 2: Show Message Box "Strange vibrations".
function reuniteShardScreenPlay:notifyEnteredVibrationArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (SceneObject(pArea):getObjectID() ~= self.vibrationAreaID or self:getStage(pPlayer) ~= 1) then
		return 0
	end

	self:setStage(pPlayer, 2)
	self:removeWaypoint(pPlayer, "vibration")

	self:showMessageBox(pPlayer, nil, "Strange vibrations",
		"All of a sudden you feel something vibrate in your backpack and you hear a low humming sound. As you open your backpack you see that it seems to come from the crystal splinters you found in the box earlier...")

	return 0
end

-- _1 task 3 completing, which fires task 4: Show Message Box "More splinters",
-- grantQuestOnComplete som_kenobi_reunite_shard_2.
function reuniteShardScreenPlay:gatherFirstSplinters(pPlayer, pSplinters)
	if (self:getStage(pPlayer) ~= 2) then
		return
	end

	self:setStage(pPlayer, 3)
	-- Quest XP: quest_experience[75][TIER_1]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_reunite_shard_1")

	self:showMessageBox(pPlayer, pSplinters, "More splinters",
		"You've found some more crystal splinters. As soon as you put them in your backpack with the others, the old ones stop vibrating and glowing...")

	self:startShard2(pPlayer)
end

--[[ reunite_shard_2 ]]

-- _2 task 6's journal entry, "Reunited?", is the only steer the player gets in
-- live. The four Go to Location tasks under task 0 all go live at once.
function reuniteShardScreenPlay:startShard2(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("It seems like the crystal splinters can sense when they are near more splinters from their original crystal. The missing splinters could be anywhere though. From looking at the pieces you have, you guess that there is at least four pieces missing.")

	for i = 1, #self.legs do
		local leg = self.legs[i]
		self:giveWaypoint(pPlayer, leg.key, leg.waypointName, "Fragments of the past, II", leg.x, leg.y)
	end

	-- Persistence 1 so the observer object is saved and kill credit survives a
	-- logout; see KILL CREDIT in the header.
	createObserver(KILLEDCREATURE, "reuniteShardScreenPlay", "notifyKilledCreature", pPlayer, 1)
end

-- Each leg's Go to Location completing, which fires its Show Message Box
-- "Splinters awake" and only then makes that leg's collection task live.
function reuniteShardScreenPlay:notifyEnteredLegArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local leg = self.legByAreaID[SceneObject(pArea):getObjectID()]

	if (leg == nil or self:getStage(pPlayer) ~= 3) then
		return 0
	end

	if (self:hasFlag(pPlayer, "seen_" .. leg.key) or self:hasFlag(pPlayer, "got_" .. leg.key)) then
		return 0
	end

	self:setFlag(pPlayer, "seen_" .. leg.key)

	self:showMessageBox(pPlayer, nil, "Splinters awake",
		"All of a sudden the now familiar vibrations and humming sounds from the crystal splinters in your backpack start again...")

	-- The collection task's journal entry, identical on all four legs.
	CreatureObject(pPlayer):sendSystemMessage("The crystal splinters started making a noise in this area again. Maybe there's more fragments somewhere around here.")

	return 0
end

-- The three Destroy Multiple and Loot legs. NumberItemsRequired is 1 on all of
-- them; LootDropPercent is 60 on the bandit and 100 on the other two.
function reuniteShardScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) > 3) then
		-- reunite_shard_2 is over; stop listening on this player.
		return 1
	end

	if (self:getStage(pPlayer) ~= 3) then
		return 0
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil) then
		return 0
	end

	for i = 1, #self.legs do
		local leg = self.legs[i]

		if (leg.kind == "kill" and leg.template == victimTemplate
			and self:hasFlag(pPlayer, "seen_" .. leg.key)
			and not self:hasFlag(pPlayer, "got_" .. leg.key)) then

			if (getRandomNumber(1, 100) > leg.dropPercent) then
				return 0
			end

			self:collectSplinter(pPlayer, leg)
			return 0
		end
	end

	return 0
end

-- _2 task 13, the one leg that is a Retrieve Item off a snapshot prop rather than
-- a kill.
function reuniteShardScreenPlay:gatherSecondSplinters(pPlayer)
	local leg = self:getLeg("shard3")

	if (leg == nil or self:getStage(pPlayer) ~= 3) then
		return
	end

	if (not self:hasFlag(pPlayer, "seen_" .. leg.key) or self:hasFlag(pPlayer, "got_" .. leg.key)) then
		return
	end

	self:collectSplinter(pPlayer, leg)
end

function reuniteShardScreenPlay:collectSplinter(pPlayer, leg)
	self:setFlag(pPlayer, "got_" .. leg.key)
	self:removeWaypoint(pPlayer, leg.key)

	local collected = 0

	for i = 1, #self.legs do
		if (self:hasFlag(pPlayer, "got_" .. self.legs[i].key)) then
			collected = collected + 1
		end
	end

	if (collected < #self.legs) then
		CreatureObject(pPlayer):sendSystemMessage("Crystal splinters recovered: " .. collected .. " of " .. #self.legs .. ".")
		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
		return
	end

	-- _2 task 6 (Wait for Tasks on shard3/4/5/6) completing, which fires task 11:
	-- Show Message Box "Done?", then task 12: Immediately Complete Quest,
	-- grantQuestOnComplete som_kenobi_reunite_shard_3.
	self:setStage(pPlayer, 4)
	-- Quest XP: quest_experience[75][TIER_1]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_reunite_shard_2")

	-- Dropped here rather than left to the observer's own "return 1" -- it was
	-- created persistent, so an unfired one would sit in the database forever on a
	-- player who finishes the legs and never kills anything again.
	dropObserver(KILLEDCREATURE, "reuniteShardScreenPlay", "notifyKilledCreature", pPlayer)

	self:showMessageBox(pPlayer, nil, "Done?",
		"Looking at the pieces of crystal you have collected, it seems like you have all the ones it would take to reunite a symmetrical shard. How do you fuse crystal back together though?")

	-- _3 task 2's journal entry, "Assembling a crystal".
	CreatureObject(pPlayer):sendSystemMessage("You think you've found all the fragments of the crystal but how do you fuse them back together? You're guessing it would take a machine with an extreme heat and energy output.")

	self:giveWaypoint(pPlayer, "fusion", self.fusion.waypointName, "Fragments of the past, III", self.fusion.waypointX, self.fusion.waypointY)
end

--[[ reunite_shard_3 ]]

-- _3 task 2 completing, which fires task 3: Timer, Min Time 10 / Max Time 15.
function reuniteShardScreenPlay:startFusion(pPlayer)
	if (self:getStage(pPlayer) ~= 4) then
		return
	end

	self:setStage(pPlayer, 5)
	self:removeWaypoint(pPlayer, "fusion")

	-- _3 task 3's journal entry, "Process under way".
	CreatureObject(pPlayer):sendSystemMessage("Wait for the photon fusion machine to finish the process.")

	-- The deadline is stamped alongside the event so getStage can settle the fusion if the
	-- event is lost with the process.
	local fusionDelay = getRandomNumber(self.fusion.minTime, self.fusion.maxTime)

	writeScreenPlayData(pPlayer, self.screenplayName, "fusionUntil", tostring(getTimestamp() + fusionDelay))
	createEvent(fusionDelay * 1000, "reuniteShardScreenPlay", "finishFusion", pPlayer, "")
end

function reuniteShardScreenPlay:finishFusion(pPlayer)
	-- Raw, not getStage: the catch-up path in getStage calls this function.
	if (pPlayer == nil or self:rawStage(pPlayer) ~= 5) then
		return
	end

	self:setStage(pPlayer, 6)
	deleteScreenPlayData(pPlayer, self.screenplayName, "fusionUntil")

	-- _3 task 4's journal entry, "Finished".
	CreatureObject(pPlayer):sendSystemMessage("The process is complete, hopefully it worked.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
end

-- _3 task 4 completing, which fires task 5: Show Message Box "Success", then
-- task 6: Reward, musicOnComplete sound/mus_mustafar_quest_success.snd.
function reuniteShardScreenPlay:retrieveCrystal(pPlayer, pMachine)
	if (self:getStage(pPlayer) ~= 6) then
		return
	end

	self:setStage(pPlayer, 7)

	self:showMessageBox(pPlayer, pMachine, "Success",
		"The fusion process seems to have worked, the crystal is now complete and the amount of energy streaming out from it into your hands as you grab it is almost overwhelming.")

	self:awardQuest(pPlayer)
end

function reuniteShardScreenPlay:awardQuest(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("reuniteShardScreenPlay: player has no inventory; the crystal could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		print("reuniteShardScreenPlay: failed to create " .. self.rewardItem)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for the reunited crystal.")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have taken the reunited crystal.")
	end

	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_reunite_shard_3")

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
end

--[[ Radial dispatch

One component table serves the quest-start box, both splinter piles and the fusion
machine. SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely -- so
fillObjectMenuResponse has to add every item we want to see, and adds nothing at
all when this player has no business touching the object.
--]]

ReuniteShardMenuComponent = {}

function ReuniteShardMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":reuniteRole")
	local text = reuniteShardScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function ReuniteShardMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":reuniteRole")
	local stage = reuniteShardScreenPlay:getStage(pPlayer)

	if (role == "box") then
		reuniteShardScreenPlay:searchBox(pPlayer, pSceneObject)
	elseif (role == "splinters1") then
		reuniteShardScreenPlay:gatherFirstSplinters(pPlayer, pSceneObject)
	elseif (role == "splinters2") then
		reuniteShardScreenPlay:gatherSecondSplinters(pPlayer)
	elseif (role == "fusion") then
		if (stage == 4) then
			reuniteShardScreenPlay:startFusion(pPlayer)
		elseif (stage == 6) then
			reuniteShardScreenPlay:retrieveCrystal(pPlayer, pSceneObject)
		end
	end

	return 0
end
