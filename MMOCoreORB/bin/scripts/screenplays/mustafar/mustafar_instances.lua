--[[
Mustafar instance pools  --  the six SOE dungeon pools

WHAT THIS IS, AND WHAT IT SITS ON TOP OF

Mustafar content in this tree is ours to write. We are sanctioned to do Mustafar
for Levarris (Aaron, 2026-08-31), so nothing here is deferred to another owner and
no part of this file is somebody else's to finish.

What is genuinely his, and is true, is the layer underneath: the C++ POB ('0001')
and CellPortal ('0002') parsing in the portal-layout reader, which is what makes
these buildings load with working cells at all. That is already compiled into the
server and is left exactly alone -- not because it belongs to someone else's
scope, but because it works and this file is Lua. What was missing on top of it
was any script that lets a player reach the interiors. That is this file.

THE POOLS ARE SOE'S, AND THEY ARE ALREADY LOADED

snapshot/mustafar.ws in stardust_03.tre -- the snapshot the server actually loads --
places six dungeon buildings many times over, in evenly spaced rows well outside
the playable map:

    old_republic_facility    12 copies   z = -4746.16, x = -6748.81 .. 951.18, 700 apart
    working_droid_factory    12 copies   z = -3745.18, x = -6753.41 .. 946.59, 700 apart
    decrepit_droid_factory    9 copies   z = -2745.18, x = -6753.41 .. -1853.41
    monster_lair             12 copies
    lair_of_the_crystal      12 copies   x =  6748.99, z =  6954.54 .. -745.46, 700 apart
    uplink_cave               9 copies   x =  5947.36, z =  6255.33 .. 1355.33, 700 apart

That is SOE's instancing model: a fixed pool of identical off-map copies, one
handed to each party. Nothing has to be created for it. A boot probe on the devbox
enumerated all 66 copies live with cells attached and zero portal errors in the
log, so the pool is real at runtime and not just in the snapshot.

(Two positions in the snapshot are duplicated -- uplink 12114801/12114804 both at
z=2055.33, and decrepit 12115008/12115037 both at x=-2553.41. They are still
distinct buildings with distinct cells, so both are usable; SOE simply stacked
them. Noted so the coordinates above are not read as a transcription error.)

CELL NAMES COME FROM THE .ilf FILES

Each dungeon has an interior layout file (interiorlayout/*.ilf) listing every
placed object as a template, a cell name and a 4x3 transform. Those files are the
authoritative record of the interiors. Core3 has an InteriorLayoutTemplate parser
for them but nothing calls it, so the buildings load as correct geometry with none
of the furniture -- anything wanted inside has to be spawned from script.

The cell names read out of som_old_republic_facility.ilf were checked against a
live server: BuildingObject:getNamedCell resolved 22 of 22 of them on copy
12115823, and the first cell of each of the three single-room dungeons resolved
too. So getNamedCell against .ilf names is a sound way to address these interiors.

The ORF has 35 cells but the .ilf names only 22, because the .ilf only lists cells
that contain objects. The 13 unnamed ones are empty by construction.

RESERVATIONS

One copy per entrant, claimed on entry and released when it empties. Not per party:
there is no getGroup call anywhere in this file, so grouped players each claim their
own copy and land in different ones. Group entry is an open design question, not a
thing this file half-implements.

    mustafarInstance:<buildingID>              1 while the copy is claimed
    mustafarInstance:<buildingID>:claimedAt    os.time() of the claim
    <playerID>:mustafarInstance                the copy that player is inside
    <playerID>:mustafarInstanceEjecting        set while an eject is in flight

A copy is released when a sweep finds nobody in any of its cells and the claim is
older than claimGrace. The grace matters: between reserving a copy and the
switchZone landing the player in it, the copy is legitimately empty, and without
the grace it would be handed to somebody else in that window.

The sweep is a self-terminating chain rather than a global timer -- checkCopy
reschedules itself only while the copy is still claimed, so events exist only for
copies actually in use. EXITEDBUILDING also fires a one-shot releaseIfEmpty so a
copy normally frees within seconds rather than waiting for the next sweep.

initialize() does call deleteData on both reservation keys and then ejectAllPlayers,
in prepareCopy -- but at boot both are no-ops, and the paragraph that used to stand
here credited them with covering a stranded logout. They do not.

start() runs inside startManagers() (ZoneServerImplementation.cpp:230), which is
before serverState = ONLINE (:233), so no player is logged in yet. And reservations
live in DirectorSharedMemory, which is four plain in-memory HashTables (see
DirectorSharedMemory.h) constructed fresh by new DirectorSharedMemory() at
DirectorManager.cpp:125 -- nothing serializes it, so it is already empty on every
boot. reloadscreenplays never re-runs initialize() either.

What actually covers a stranded logout is the ordinary path: logging out removes the
creature from the world (PlayerObjectImplementation.cpp:419), so countPlayersInside
falls to 0 and the 120 s checkCopy sweep releases the copy once claimGrace has
passed. The slot is not leaked within a run either.

WHAT IS WIRED, AND WHAT DELIBERATELY IS NOT

Five of the six pools have an entry. This paragraph has now been wrong twice: it
first said only the Old Republic Facility had one, then it said two did. Both
readings were written without checking the story arc that actually drives these
dungeons, and the second one was used to justify leaving three pools unwired.

  old_republic_facility   entry, own prop 12110161   ungated
  lair_of_the_crystal     entry, own prop 12112106   gate = "kenobi_spine"
  uplink_cave             entry, own prop 12111281   gate = "story_arc_uplink"
  working_droid_factory   entry, NO prop             gate = "story_arc_factory"
  decrepit_droid_factory  entry, NO prop             gate = "story_arc_factory"

som_kenobi_historian_1 sends the player to the Old Republic Facility and
reunite_shard_3's fusion machine stands inside it. The lair is the shard site; its
gate string is resolved against the screenplay of that name, so the radial only
appears once kenobiSpineScreenPlay:mayEnterLair (kenobi_spine.lua:1491) says the
player is at that point in the spine.

An entry whose nodeID is nil is the case this file did not have before, and it is
the whole point of the seam. A pool needs a landing spot -- cell, x, z, y -- to be
enterable at all, but it does not have to own a radial to get one.

Both factories share exterior door 12112909, and story_arc_chapters.lua already
owns that node's menu for "restart the main computer processor" (chapter two 01
task 1) and "shut down the factory" (chapter three 01 task 16).
setObjectMenuComponent REPLACES an object's menu wholesale, so attaching a prop
here would silently destroy those two radials. So the factory pools carry
nodeID = nil, attachEntryProp skips them, and storyArcChaptersScreenPlay's own
radial calls MustafarInstances:enterInstance directly. One owner for the node, one
owner for the pool, and no collision to leave behind as a warning.

uplink_cave does NOT need that treatment, and the note that used to claim it did
was wrong on the node numbers. The cave's door is 12111281; the node
story_arc_chapters owns is 12111374, the bunker entrance standing beside it. Two
different objects, so the cave keeps its own prop and its own radial.

monster_lair used to be the only pool still carrying entry = nil. Its note gave
two reasons -- no .qst in this tree points at Sherkar's lair, and no screenplay
populates it -- and called the pair an honest gap. They were one blocker, not
two. old_republic_facility has no .qst either and has always been enterable, so
the missing .qst never blocked anything on its own; the empty room did. So the
room was populated (mustafar_dungeon_population's lairBosses table puts Sher Kar
in cell r1 of all 12 copies) and the entry was wired. Every pool is now
enterable. The lesson the old note half-learned still stands: the other three
nil entries were justified the same way and it was not true of them either --
the arc drives all three. They were not gaps, they were unfinished connections.

STRINGS

"Enter the facility" is this file's wording, not a shipped one. The live entry was
a door you walked through, not a radial, so there is no SOE string for it.
--]]

MustafarInstances = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "MustafarInstances",

	-- Seconds a claimed-but-empty copy is held before it can be reissued; see
	-- RESERVATIONS in the header.
	claimGrace = 60,

	-- How often the self-rescheduling sweep revisits a claimed copy.
	sweepSeconds = 120,

	pools = {
		{
			key = "old_republic_facility",
			label = "Old Republic Facility",

			buildings = { 12115823, 12115861, 12115785, 12115747, 12115709, 12115671,
				12115633, 12115595, 12115557, 12115519, 12115481, 12115443 },

			-- Snapshot node 12110161,
			-- object/building/mustafar/structures/shared_old_republic_facility_door_exterior.iff
			-- at (-775.93, 89.14, 6088.28). This is the door the client already draws.
			entry = {
				nodeID = 12110161,
				text = "Enter the facility",

				-- entrance cell, from som_old_republic_facility.ilf. Its floor is at
				-- y=0 and its clutter sits at x 4.4-14 / z +7..+9.4, x 19-23.4 at both
				-- ends, and x 6-8 / z -9. x=12 z=0 is open floor between them.
				-- .ilf y (up) becomes the switchZone height argument.
				cell = "entrance",
				x = 12.0, z = 0.0, y = 0.0,
			},

			-- Just outside the door, stepped ~7m along the vector from the facility
			-- exterior (node 12110934, -782.04/6096.14) through the door, so the
			-- player lands facing away from the building rather than inside its mass.
			-- Height is resolved with getWorldFloor, never hardcoded.
			exit = { x = -771.6, y = 6082.8 },
		},
		{
			key = "monster_lair",
			label = "Sherkar's Lair",
			buildings = { 12115929, 12115932, 12115926, 12115923, 12115920, 12115917,
				12115914, 12115911, 12115908, 12115905, 12115902, 12115899 },

			--[[ WIRED. This block used to read `entry = nil` with a note saying an
			     entry "would drop the player into an empty room". That was true when
			     it was written and is no longer: the room is furnished by
			     MustafarDungeonPopulation:populateLairBosses(), which puts the
			     finished level-200 sher_kar in every copy. The two reasons that note
			     gave for holding off -- nothing populates it, no .qst points at it --
			     were one blocker, not two. The second never mattered;
			     old_republic_facility has no .qst pointing at it either and has been
			     enterable all along.

			     THE DOOR IS SOURCED. Snapshot node 12110143,
			     shared_must_sherkar_door.iff at (-2077.07, h 87.16, 4276.08), beside
			     exterior 12110517 shared_must_sherkar_lair_exterior.iff at
			     (-2128.27, h 86.79, 4356.34). Both re-read from
			     snapshot/mustafar.ws (stardust_03) rather than copied.

			     THE CELL NAME IS CERTAIN. must_monster_lair.ilf holds 456 nodes and
			     every single one is in cell "r1" -- there is no second cell to pick
			     wrong. master_index.txt agrees: the only interior collision floor
			     shipped is thm_must_monster_lair_s01_r1_collision_floor.flr.

			     THE ARRIVAL POINT IS OURS. There is no monster_lair entry in
			     datatables/spawning/dungeon/ (the only SoM ones are
			     crash_site_cruiser, decrepit_droid_factory, mining_facility,
			     old_republic_facility and working_droid_factory), and
			     thm_must_monster_lair_s01.pob is listed in master_index.txt but is
			     not present in any TRE available here, so the collision floor cannot
			     be read. Live has no arrival point of its own to copy either -- it
			     opened this lair through the Mustafarian bandit chain, not a portal
			     drop -- so this one stays ours.

			     THE BOSS POINT IS NOT OURS ANY MORE. This block used to give a
			     second fitted point for Sher Kar himself and call it ours on the
			     same reasoning. That was a wrong-tree search: the SoM trials keep
			     their spawn data in datatables/dungeon/mustafar_trials/<system>/,
			     a different tree from datatables/spawning/dungeon/, and
			     sher_kar/sher_kar_data.tab does exist there. It gives Sher Kar and
			     his four guards, and mustafar_dungeon_population.lua now uses those
			     rows. Only the arrival point below is still a fit.

			     What it IS derived from, rather than guessed: the .ilf's only
			     furnished area is the nest at the far end -- 44 ground-resting props
			     (nine trash piles, eight human skeletons, bith and ithorian
			     skeletons, poi_ev9d9head, r2_head, r5_torso, AT-AT/AT-ST and Death
			     Star debris) spanning x -94.96..-69.08, z -207.24..-194.86. Fitting
			     a plane to those 44 heights gives floor h = -3.74 + -0.1966*(z +
			     202.35), mean residual 0.24 m, max 1.30 m. That is a well-attested
			     26 m x 12 m floor, and the arrival point sits inside it, so it does
			     not rely on extrapolating into the unmapped tunnel.

			       arrival  x -86.3, z(height) -5.19, y -195.5   (near edge of the nest)

			     THAT PLANE IS CORROBORATED BY LIVE, which is worth recording because
			     it is what confirms the axis mapping in the line below. Applied to
			     the sher_kar_data.tab rows -- which were found later and were not
			     available when it was fitted -- it predicts -18.29 at guard0
			     (y -128.367) against live's -18.2924, and -17.37 at guard4
			     (y -133.004) against live's -17.1073. It only breaks far up the
			     tunnel where the floor flattens out, so it is trustworthy exactly
			     where it is used: the nest.

			     Sher Kar himself now stands at his own sourced point about 43 m up
			     the tunnel, so the player lands in the bone field and sees him and
			     his guards down its length rather than face to face. sher_kar.lua is
			     pvpBitmask ATTACKABLE and not AGGRESSIVE, so that distance does not
			     force an instant pull -- and it is now a longer distance, not a
			     shorter one.

			     Field order is (x, height, y) per switchZone at :567 -- .ilf y (up)
			     becomes the middle argument, .ilf z becomes the last, the same
			     mapping old_republic_facility's entry above already uses.

			     NO GATE, deliberately. isEntryAllowed is an if-chain on pool.gate and
			     the header at :476 warns every new gate costs a branch. Live opened
			     this lair through the Mustafarian bandit chain, which this tree does
			     not have, so there is nothing faithful to gate on -- and a level-200
			     boss gates itself by difficulty. ]]
			entry = {
				nodeID = 12110143,
				text = "Enter the lair",
				cell = "r1",
				x = -86.3, z = -5.19, y = -195.5,
			},

			-- Stepped 7 m past the door along the exterior->door vector, the same
			-- convention as the other pools: exterior (-2128.27, 4356.34) -> door
			-- (-2077.07, 4276.08) is (51.20, -80.26), length 95.20, unit
			-- (0.5378, -0.8431). Height is resolved by sendToExit with getWorldFloor
			-- and is never stored here.
			exit = { x = -2073.3, y = 4270.2 },

			door = 12110143,
		},
		{
			key = "uplink_cave",
			label = "Uplink Cave",
			buildings = { 12114807, 12114801, 12114804, 12114798, 12114795, 12114792,
				12114789, 12114786, 12114783 },
			-- Snapshot node 12111281,
			-- shared_must_uplink_bunker_entrance_door.iff at (-3591.53, 3489.44).
			-- This is the cave's OWN door. It is not node 12111374 -- that is the
			-- bunker entrance standing 0.5 m away, and story_arc_chapters.lua owns
			-- that one for the surface work site. Two nodes, two owners, no clash.
			entry = {
				nodeID = 12111281,
				text = "Enter the cave",

				-- INVENTED PLACEMENT, and the absence behind it is a checked one.
				-- som_uplink_cave has NO table under datatables/spawning/dungeon/ --
				-- the five that ship there are som_mining_facility,
				-- som_old_republic_facility, som_crash_site_cruiser,
				-- som_working_droid_factory and som_decrepit_droid_factory. Its
				-- placement table lives elsewhere:
				-- datatables/dungeon/mustafar_trials/link_establish/link_event_data.tab
				-- (26 content rows), reached from the building's own server template
				-- through link_event_manager, and read by
				-- mustafar_dungeon_population.lua. That table has no ENTRY row, so
				-- the entry coordinate below is still invented -- the .ilf is the
				-- best evidence that exists for where the player lands -- which is
				-- exactly the use of a .ilf this tree already calls fair: Core3
				-- never instantiates .ilf furniture, so these coordinates are not
				-- "where the prop is", they are shipped evidence of where SOE left
				-- open floor.
				--
				-- som_uplink_cave.ilf has one cell, mainroom, and 197 nodes. Within 20 m
				-- of the cell origin the only ground-level fixtures are two
				-- must_miner_tower, at (-3.879, h -2.012, -6.071) and
				-- (-4.271, h -1.978, 5.125), so the floor there sits at h = -2.0.
				-- Everything else near the origin is overhead -- cargo and death-star
				-- debris from h +1.5 to +15. x = 0, z = 0 is open floor between the two
				-- towers with the nearest fixture 5.5 m away.
				cell = "mainroom",
				x = 0.0, z = -2.0, y = 0.0,
			},

			-- Stepped 6 m out from the door toward the .qst's own work-site waypoint
			-- (-3604 / 3483), which is the direction the player arrives from. The
			-- door and the bunker entrance are only 0.5 m apart, so that pair is far
			-- too short a baseline to take a direction from; the authored waypoint is
			-- the one real bearing available. Lands 5.8 m clear of the bunker.
			-- Height is resolved with getWorldFloor, never hardcoded.
			exit = { x = -3596.9, y = 3486.7 },

			-- Chapter one 03's work site. Entering before that chapter would put the
			-- player in a cave with no droid, no relay and no reason to be there.
			gate = "story_arc_uplink",

			door = 12111281,
		},
		{
			key = "lair_of_the_crystal",
			label = "Lair of the Crystal",
			buildings = { 12114830, 12114828, 12114832, 12114826, 12114824, 12114822,
				12114820, 12114818, 12114816, 12114814, 12114812, 12114810 },
			-- Snapshot node 12112106,
			-- object/tangible/dungeon/mustafar/obiwan_finale/shared_obiwan_finale_entrance_stone.iff
			-- at (-2693.52, 42.57, 6075.59). This is the end of the arc's main
			-- spine, not a side door, so unlike every other pool here it is gated:
			-- see gate below and kenobiSpineScreenPlay:mayEnterLair.
			entry = {
				nodeID = 12112106,

				-- Authored. main_quest_3 task 1 is a Go to Location and carries no
				-- retrieveMenuText, because in live the stone was a client-side
				-- dungeon portal rather than a quest object.
				text = "Wedge the crystal shard into the pillar",

				-- mainroom, from som_obiwan_crystal_lair.ilf. Its floor is at y=0
				-- and the statue gallery runs x 21..40 in two rows at z 2.5 and
				-- z 7.68; x=24 z=5.1 is the open aisle between them, at the near
				-- end. The boss waits at x=37 down the same aisle.
				cell = "mainroom",
				x = 24.0, z = 0.0, y = 5.1,
			},

			-- Stepped ~6 m back from the stone along the vector out of the temple
			-- ruin, so the player lands on open ground rather than inside the
			-- jeditemple wall at 7.67 m or the dome at 8.10 m. Height is resolved
			-- with getWorldFloor, never hardcoded.
			exit = { x = -2693.5, y = 6069.6 },

			-- One of four gated pools now, not the only one. See isEntryAllowed.
			gate = "kenobi_spine",

			door = 12112106,
		},
		{
			key = "working_droid_factory",
			label = "Working Droid Factory",
			buildings = { 12115385, 12115414, 12115356, 12115327, 12115298, 12115269,
				12115240, 12115211, 12115182, 12115153, 12115124, 12115095 },
			-- nodeID = nil ON PURPOSE. The door is snapshot node 12112909
			-- (shared_droid_factory_exterior_door.iff, 532.71/1977.03), and beside it
			-- the snapshot places a keypad (12112269) and a history terminal
			-- (12112268). story_arc_chapters.lua owns 12112909's menu component for
			-- its two factory tasks, and setObjectMenuComponent replaces a menu
			-- wholesale -- so this pool takes a landing spot and no prop, and
			-- storyArcChaptersScreenPlay:useFactoryDoor calls enterInstance for it.
			--
			-- In live the keypad gated the door behind a code from the factory quest
			-- line, and both factories share the one door, so which pool a player got
			-- was part of that quest's logic. That code puzzle does not ship here;
			-- the arc stage decides instead, which is the deviation, not a gap.
			entry = {
				nodeID = nil,
				text = "Enter the factory",

				-- QUOTED, from the working factory's own dungeon spawn table. Its
				-- interior door row is
				-- object/building/mustafar/structures/droid_factory_interior_door.iff
				-- in cell hall1 at loc_x 0.091872, loc_y 4.00E-06, loc_z 0.141262 --
				-- the arrival door, effectively the cell origin. The player is put
				-- 3 m inside it along hall1, clear of the door's own mass. hall1 also
				-- carries the exit_terminal access_controller at (-1.99229, h 0.189741,
				-- 2.81714), so the floor there is h = 0.19.
				cell = "hall1",
				x = 0.0, z = 0.19, y = 3.0,
			},

			-- Stepped 6 m out from the door along the vector from the factory
			-- exterior (node 12112250, 538.25/1972.65) through the door, so the
			-- player lands facing away from the building rather than inside its
			-- mass -- the same construction the ORF exit uses. Height is resolved
			-- with getWorldFloor, never hardcoded.
			exit = { x = 528.0, y = 1980.8 },

			-- Chapter two 01 task 1 onward. See storyArcChaptersScreenPlay:mayEnterDroidFactory.
			gate = "story_arc_factory",

			door = 12112909,
		},
		{
			key = "decrepit_droid_factory",
			label = "Decrepit Droid Factory",
			buildings = { 12115066, 12115008, 12115037, 12114979, 12114950, 12114921,
				12114892, 12114863, 12114834 },
			-- Same door, same seam, same reason as working_droid_factory above:
			-- nodeID = nil because story_arc_chapters.lua owns 12112909's menu.
			entry = {
				nodeID = nil,
				text = "Enter the factory",

				-- QUOTED. The decrepit factory's own table carries the identical
				-- interior door row -- droid_factory_interior_door.iff in hall1 at
				-- 0.091872 / 4.00E-06 / 0.141262 -- and the identical hall1
				-- exit_terminal at (-1.99229, h 0.189741, 2.81714). The two buildings
				-- share a floor plan, so they share the arrival spot.
				cell = "hall1",
				x = 0.0, z = 0.19, y = 3.0,
			},

			-- The same door, so the same exit as working_droid_factory.
			exit = { x = 528.0, y = 1980.8 },

			gate = "story_arc_factory",

			door = 12112909,
		},
	},
}

registerScreenPlay("MustafarInstances", true)

function MustafarInstances:start()
	if (isZoneEnabled("mustafar")) then
		self:initialize()
	end
end

--[[ Setup ]]

function MustafarInstances:initialize()
	for i = 1, #self.pools do
		local pool = self.pools[i]

		if (pool.entry ~= nil) then
			for j = 1, #pool.buildings do
				self:prepareCopy(pool, pool.buildings[j])
			end

			self:attachEntryProp(pool)
		end
	end
end

-- Clear any reservation left over from the last run and get anybody who logged
-- out inside back onto the surface; see RESERVATIONS in the header.
function MustafarInstances:prepareCopy(pool, buildingID)
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		printLuaError("MustafarInstances: " .. pool.key .. " copy " .. buildingID .. " is missing or is not a building; that copy is out of the pool")
		return
	end

	deleteData("mustafarInstance:" .. buildingID)
	deleteData("mustafarInstance:" .. buildingID .. ":claimedAt")

	self:ejectAllPlayers(pBuilding)

	createObserver(ENTEREDBUILDING, "MustafarInstances", "onEnteredInstance", pBuilding)
	createObserver(EXITEDBUILDING, "MustafarInstances", "onExitedInstance", pBuilding)
end

--[[ A pool may have an entry point without owning a prop's radial. entry.nodeID
     nil means "somebody else owns the node that leads here" -- the two droid
     factory pools share door 12112909 with story_arc_chapters.lua, which holds
     that node's menu component for its own two tasks. setObjectMenuComponent
     REPLACES a menu rather than stacking, so attaching here would destroy those
     radials silently. Skipping is the whole mechanism that lets the factories be
     entered without a collision; it is not a disabled pool. ]]
function MustafarInstances:attachEntryProp(pool)
	if (pool.entry.nodeID == nil) then
		return
	end

	local pProp = getSceneObject(pool.entry.nodeID)

	if (pProp == nil) then
		printLuaError("MustafarInstances: entry prop " .. pool.entry.nodeID .. " for " .. pool.key .. " was not found; that dungeon cannot be entered")
		return
	end

	writeStringData(pool.entry.nodeID .. ":mustafarInstancePool", pool.key)
	SceneObject(pProp):setObjectMenuComponent("MustafarInstanceMenuComponent")
end

--[[ Lookups ]]

function MustafarInstances:getPool(key)
	for i = 1, #self.pools do
		if (self.pools[i].key == key) then
			return self.pools[i]
		end
	end

	return nil
end

function MustafarInstances:getPoolByBuildingID(buildingID)
	for i = 1, #self.pools do
		local pool = self.pools[i]

		for j = 1, #pool.buildings do
			if (pool.buildings[j] == buildingID) then
				return pool
			end
		end
	end

	return nil
end

-- The building id list, so quest screenplays can furnish every copy of a dungeon
-- without duplicating the pool. reunite_shard.lua uses this for the fusion machine.
function MustafarInstances:getPoolBuildings(key)
	local pool = self:getPool(key)

	if (pool == nil) then
		return {}
	end

	return pool.buildings
end

--[[ Entry ]]

--[[ The Old Republic Facility is open ground with a door on it; whoever walks up
     may go in. The other four wired pools are not. lair_of_the_crystal is the
     last room of the Kenobi spine, and walking into it early would put the player
     in front of Sinistro with none of the arc behind them. uplink_cave and the two
     droid factories are story-arc work sites that are empty and meaningless before
     their chapter. So a pool may name a gate, and the gate is asked in both places:
     the radial is not offered to a player who cannot enter, and the selection is
     refused as well, because a radial the client already drew can still be clicked.

     Both screenplays named below live in this same Lua state, so calling them
     directly is safe.

     This block used to claim the lookup shape meant "a second gated pool does not
     have to edit this function". That was wrong, and adding the second and third
     gates is what proved it: the gate string is resolved by an if-chain here, so
     every new gate costs a branch. The shape is still worth keeping -- it puts all
     three gates in one readable place (three gate strings serve four pools, because
     both factories share story_arc_factory) -- but it is not the extension point the
     old comment advertised, and the next person should not plan around that. ]]

function MustafarInstances:isEntryAllowed(pool, pPlayer)
	if (pool == nil or pPlayer == nil) then
		return false
	end

	if (pool.gate == nil) then
		return true
	end

	-- Guards fail closed: a missing gate screenplay must refuse, never admit.
	if (pool.gate == "kenobi_spine") then
		if (kenobiSpineScreenPlay == nil) then
			printLuaError("MustafarInstances: pool " .. pool.key .. " is gated on kenobi_spine.lua, which is not loaded; refusing entry")
			return false
		end

		return kenobiSpineScreenPlay:mayEnterLair(pPlayer)
	end

	if (pool.gate == "story_arc_uplink") then
		if (storyArcChaptersScreenPlay == nil) then
			printLuaError("MustafarInstances: pool " .. pool.key .. " is gated on story_arc_chapters.lua, which is not loaded; refusing entry")
			return false
		end

		return storyArcChaptersScreenPlay:mayEnterUplinkCave(pPlayer)
	end

	if (pool.gate == "story_arc_factory") then
		if (storyArcChaptersScreenPlay == nil) then
			printLuaError("MustafarInstances: pool " .. pool.key .. " is gated on story_arc_chapters.lua, which is not loaded; refusing entry")
			return false
		end

		return storyArcChaptersScreenPlay:mayEnterDroidFactory(pPlayer)
	end

	printLuaError("MustafarInstances: pool " .. pool.key .. " names an unknown gate '" .. pool.gate .. "'; it cannot be entered")

	return false
end

function MustafarInstances:enterInstance(pPlayer, poolKey)
	local pool = self:getPool(poolKey)

	if (pPlayer == nil or pool == nil or pool.entry == nil) then
		return
	end

	if (not self:isEntryAllowed(pool, pPlayer)) then
		-- Say so. A silent return is indistinguishable from a broken radial, and that
		-- is how a wrong gate threshold sat unnoticed: the task inside was refused at
		-- the door and nothing reported it.
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:not_ready") -- You are not ready to enter that area.
		return
	end

	local buildingID = self:findFreeCopy(pool)

	if (buildingID == 0) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon") -- That area is currently unavailable. Please try again later.
		return
	end

	local pBuilding = getSceneObject(buildingID)
	local pCell = BuildingObject(pBuilding):getNamedCell(pool.entry.cell)

	if (pCell == nil) then
		printLuaError("MustafarInstances: copy " .. buildingID .. " has no cell named " .. pool.entry.cell .. "; " .. pool.key .. " cannot be entered")
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
		return
	end

	writeData("mustafarInstance:" .. buildingID, 1)
	writeData("mustafarInstance:" .. buildingID .. ":claimedAt", os.time())

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	writeData(SceneObject(pPlayer):getObjectID() .. ":mustafarInstance", buildingID)

	SceneObject(pPlayer):switchZone("mustafar", pool.entry.x, pool.entry.z, pool.entry.y, SceneObject(pCell):getObjectID())

	-- Starts the sweep chain for this copy; it ends itself when the copy is released.
	createEvent(self.sweepSeconds * 1000, "MustafarInstances", "checkCopy", pBuilding, "")
end

function MustafarInstances:findFreeCopy(pool)
	for i = 1, #pool.buildings do
		local buildingID = pool.buildings[i]

		if (readData("mustafarInstance:" .. buildingID) ~= 1 and getSceneObject(buildingID) ~= nil) then
			return buildingID
		end
	end

	return 0
end

--[[ Occupancy ]]

function MustafarInstances:countPlayersInside(pBuilding)
	if (pBuilding == nil) then
		return 0
	end

	local count = 0

	for i = 1, BuildingObject(pBuilding):getTotalCellNumber() do
		local pCell = BuildingObject(pBuilding):getCell(i)

		if (pCell ~= nil) then
			for j = 1, SceneObject(pCell):getContainerObjectsSize() do
				local pObject = SceneObject(pCell):getContainerObject(j - 1)

				if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
					count = count + 1
				end
			end
		end
	end

	return count
end

function MustafarInstances:ejectAllPlayers(pBuilding)
	if (pBuilding == nil) then
		return
	end

	local toEject = {}

	for i = 1, BuildingObject(pBuilding):getTotalCellNumber() do
		local pCell = BuildingObject(pBuilding):getCell(i)

		if (pCell ~= nil) then
			for j = 1, SceneObject(pCell):getContainerObjectsSize() do
				local pObject = SceneObject(pCell):getContainerObject(j - 1)

				if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
					table.insert(toEject, pObject)
				end
			end
		end
	end

	-- Collected first, then moved: switchZone mutates the cell's container while
	-- getContainerObject is walking it.
	for i = 1, #toEject do
		self:sendToExit(toEject[i], pBuilding)
	end
end

--[[ Exit ]]

function MustafarInstances:sendToExit(pPlayer, pBuilding)
	if (pPlayer == nil or pBuilding == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- An eject is itself a switchZone out of a cell, which fires EXITEDBUILDING
	-- and lands back here. The flag makes the second pass a no-op.
	if (readData(playerID .. ":mustafarInstanceEjecting") == 1) then
		return
	end

	local pool = self:getPoolByBuildingID(SceneObject(pBuilding):getObjectID())

	if (pool == nil or pool.exit == nil) then
		printLuaError("MustafarInstances: no exit point for building " .. SceneObject(pBuilding):getObjectID() .. "; player " .. playerID .. " was left inside")
		return
	end

	writeData(playerID .. ":mustafarInstanceEjecting", 1)

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local height = getWorldFloor(pool.exit.x, pool.exit.y, "mustafar")

	SceneObject(pPlayer):switchZone("mustafar", pool.exit.x, height, pool.exit.y, 0)

	deleteData(playerID .. ":mustafarInstance")
	createEvent(2000, "MustafarInstances", "clearEjecting", pPlayer, "")
end

function MustafarInstances:clearEjecting(pPlayer)
	if (pPlayer ~= nil) then
		deleteData(SceneObject(pPlayer):getObjectID() .. ":mustafarInstanceEjecting")
	end
end

--[[ Observers ]]

function MustafarInstances:onEnteredInstance(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local buildingID = SceneObject(pBuilding):getObjectID()

	-- Somebody who reached a copy without going through enterInstance -- the pool
	-- sits off the map, so in practice this is a stale reference or a warp. Claim
	-- the copy for them rather than leave it able to be handed to somebody else.
	if (readData("mustafarInstance:" .. buildingID) ~= 1) then
		writeData("mustafarInstance:" .. buildingID, 1)
		writeData("mustafarInstance:" .. buildingID .. ":claimedAt", os.time())
		createEvent(self.sweepSeconds * 1000, "MustafarInstances", "checkCopy", pBuilding, "")
	end

	writeData(SceneObject(pPlayer):getObjectID() .. ":mustafarInstance", buildingID)

	return 0
end

function MustafarInstances:onExitedInstance(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	self:sendToExit(pPlayer, pBuilding)
	createEvent(3000, "MustafarInstances", "releaseIfEmpty", pBuilding, "")

	return 0
end

--[[ Release

releaseIfEmpty is the one-shot fired by an exit; checkCopy is the recurring
backstop chain. Only checkCopy reschedules, so the two cannot multiply.
--]]

function MustafarInstances:releaseCopy(buildingID)
	deleteData("mustafarInstance:" .. buildingID)
	deleteData("mustafarInstance:" .. buildingID .. ":claimedAt")
end

function MustafarInstances:isReleasable(pBuilding)
	local buildingID = SceneObject(pBuilding):getObjectID()

	if (readData("mustafarInstance:" .. buildingID) ~= 1) then
		return false
	end

	if (self:countPlayersInside(pBuilding) > 0) then
		return false
	end

	local claimedAt = readData("mustafarInstance:" .. buildingID .. ":claimedAt")

	return (os.time() - claimedAt) >= self.claimGrace
end

function MustafarInstances:releaseIfEmpty(pBuilding)
	if (pBuilding ~= nil and self:isReleasable(pBuilding)) then
		self:releaseCopy(SceneObject(pBuilding):getObjectID())
	end
end

function MustafarInstances:checkCopy(pBuilding)
	if (pBuilding == nil) then
		return
	end

	local buildingID = SceneObject(pBuilding):getObjectID()

	if (readData("mustafarInstance:" .. buildingID) ~= 1) then
		return
	end

	if (self:isReleasable(pBuilding)) then
		self:releaseCopy(buildingID)
		return
	end

	createEvent(self.sweepSeconds * 1000, "MustafarInstances", "checkCopy", pBuilding, "")
end

--[[ Radial dispatch

Same shape as reunite_shard.lua's component: setObjectMenuComponent falls through
to LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely, so this has to add
every item that should appear.
--]]

MustafarInstanceMenuComponent = {}

function MustafarInstanceMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local poolKey = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mustafarInstancePool")
	local pool = MustafarInstances:getPool(poolKey)

	if (pool ~= nil and pool.entry ~= nil and MustafarInstances:isEntryAllowed(pool, pPlayer)) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, pool.entry.text)
	end
end

function MustafarInstanceMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 10)) then
		return 0
	end

	local poolKey = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mustafarInstancePool")

	MustafarInstances:enterInstance(pPlayer, poolKey)

	return 0
end
