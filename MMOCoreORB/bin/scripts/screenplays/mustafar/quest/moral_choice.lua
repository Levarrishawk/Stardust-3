--[[ som_kenobi_moral_choice_1 -- "A moral choice"

A mining corporation executive pays the player to sabotage a striking miners'
camp. The striking miners' leader, if the player talks to him while he is out
there, offers him the other side of the story and a disk full of proof. Only one
of the two can be finished.

THE .QST, AS IT SHIPPED

Root task 1 is a Nothing with isVisible false and two children, and that shape is
the whole quest -- the two branches are SIBLINGS, not alternatives chosen up
front, and nothing orders them:

  BRANCH A -- the corporation
    task 0   Retrieve Item  "Tear out cables"   Destroyed power generator
             createWaypoint, mustafar (-5267, 316, 4491) "Striking miners camp"
      task 4   Encounter  som_mustafarian_striking_miner  Count 2, 5-15 m
      task 3   Retrieve Item  "Steal core"  Power core
        task 5   Encounter  som_mustafarian_striking_miner  Count 2, 5-15 m
        task 7   Wait for Signal  givenCore
          task 8   Reward  Bank Credits 20000
                   + object/tangible/item/som/frn_holo_mustafarian_c_reward.iff
            task 9   Immediately Complete Quest

  BRANCH B -- the miners
    task 10  Wait for Signal  talkedLeader   isVisible false
      task 11  Retrieve Item  "Upload data"  Uploaded data
               object/tangible/quest/som_kenobi_network_computer.iff
        task 16  Timer  Min 30 / Max 90
          task 15  Encounter  som_mustafarian_corrupt_security_guard  Count 3, 25-50 m
        task 12  Wait for Signal  talkedLeader2
          task 13  Reward  Bank Credits 20000
                   + object/tangible/item/som/frn_holo_mustafarian_a_reward.iff
            task 14  Immediately Complete Quest

Both Retrieve Item tasks in branch A name the same Server Object Template,
object/tangible/quest/som_kenobi_power_generator.iff, with LootDropPercent 100 --
one object, two radials, in the order the .qst lists them. That is why the
generator's radial text changes rather than a second object appearing.

Task 10 hanging off root task 1 rather than off task 0 means the .qst PERMITS
switching sides at any point before the core is handed over. switchSides below
accepts STAGE_CABLES, STAGE_CORE and STAGE_RETURN for that reason, and taking
the disk is what closes branch A -- there is no signal that reopens it.

WHAT THE .QST PERMITS IS NOT WHAT THE LEADER OFFERS. His live conversation puts
the whole switch tree behind isTaskActive "needDestroy" -- STAGE_CABLES alone.
Once the cables are torn out that task is no longer active, and every later
stage of branch A falls through to the isQuestActive brush-off, s_139 "I don't
like your look. You should move along...". So in practice the disk can only be
taken before the cables come down, and switchSides' STAGE_CORE / STAGE_RETURN
arms are unreachable through the only thing that calls it.

ROOT CAUSE of the old claim: reading permission out of the task tree and writing
it down as behaviour. The .qst says what MAY be signalled, never who offers to
signal it -- that lives in the conversation, and the conversation had not been
found when this was written. The arms stay: they are correct if anything ever
reaches them, and they are what the .qst allows.

[list]: Level 75, Tier 4, Type solo, category Mustafar, allowRepeats true,
completeWhenTasksComplete true, Bank Credits 0, Experience Amount 0.

THE LEVEL GATE  --  61, not 75

The .qst's Level 75 is a client-side display value and the exec does not enforce
it. His server-side conversation gates the offer on a level test against 60: the
offer is only reached when the player's level is greater than 60, so the real
minimum is 61 and requiredLevel below says 61.

The condition is named levelTooLow and it returns TRUE for the players who ARE
high enough -- the name is inverted relative to what it does. Read the body, not
the identifier. Menth Paul's tree has the same condition, the same way round;
cursed_shard.lua records it too.

THE TWO THINGS THE PLAYER CLICKS, AND WHERE THEY ARE

The generator ships. snapshot/mustafar.ws carries exactly one
som_kenobi_power_generator: node 12111382, cell 0, at (-5261.18, h 316.00,
z 4495.92). That is 8 m from the .qst's own waypoint (-5267, 316, 4491), inside
the striking miners' fenced compound, so the radial is attached to the world
object rather than a copy being spawned next to it.

The network computer does not ship as a snapshot node -- zero nodes -- so it is
spawned. Both it and the executive have live positions, and this file now uses
them. The facility's dungeon spawn table carries a row for each:

  the computer   hub_room         cell 12112236  (-87.9, 14.4, -6.3)  heading 0
  the executive  conference_room  cell 12112241  (-152.4, 19.1, -13.3)  heading -116

The room-to-id map is mensix_mining_facility_main.lua's, which resolves all 30
cells off the .pob record order against node 12112217's 30 snapshot children.

An earlier revision placed both by reasoning, and it is worth recording how each
one went wrong, because they failed differently.

  The executive was near-miss. conference_room was correct -- the .ilf box is
  x -155.82..-138.26, y -20.01..-10.93, with a conference table and twelve chairs
  -- and "he stands at the head of it" put him about two metres from where SOE
  did. The heading was the real error: 90 versus -116, so he faced across the
  table instead of down it. Its cellID field was left 0 and leaned entirely on
  the name lookup; it is filled in now.

  The computer was in the wrong room. It went to small_room_05 at
  (-154.887, 19.070, -69.109), which is a real console position in the .ilf --
  flush against that room's -y wall, hence heading 0 -- and which is about 90 m
  from the hub_room floor where it belongs. The .ilf furniture argument was
  sound as far as it went: Core3 never calls InteriorLayoutTemplate, so no .ilf
  furniture spawns and that spot is empty floor at runtime. But an .ilf console
  slot is a place a console COULD go, not the place this quest's computer does
  go, and the quest calls it the mining network computer -- hub_room is the
  mining network floor.

Cells are still resolved by name off the building first and fall back to the
recorded snapshot node id, with the boot probe printing which one answered. That
belt-and-braces stays: it costs nothing and it catches a re-cut snapshot.

THE CREATURES  --  all three substituted

som_mustafarian_striking_miner, som_mustafarian_corrupt_security_guard and the
strike leader are all named by the .qst and none of them exists.

  the strikers   miner_on_strike, used as it ships. It is the template
                 smoking_forest_region.lua:37-59 already spawns eight of at this
                 camp, it is level 70, and the .qst's Encounter is two more of
                 the same. ATTACKABLE only, so the fight is started for them.
  the leader     som_kenobi_moral_strike_leader, new
  the executive  som_kenobi_moral_exec, new
  the guards     som_kenobi_moral_corrupt_guard, new

Each of the three new mobile files carries its own note on what it was built
from and why it is a new template rather than an edit to an existing one.

PROGRESS TRACKING

som_kenobi_moral_choice_1 has no row in datatables/player/quests.iff, so there is
no journal in spite of the .qst's journalVisible = true. All progress lives in
persistent screenplay data on the player's ghost; the journalEntryDescription
lines go out as system messages and as waypoint descriptions instead, which is
where the player would otherwise have read them. Only task 0 has createWaypoint,
so the .qst quotes exactly one waypoint -- "Striking miners camp" at
(-5267, 4491) -- and the return legs get substitute waypoints, because a quest
that says "head back to the new mining facility" with no journal and no marker
is unfinishable by anyone who did not read the coordinates out of the file.

The gate itself is 61, not the .qst's 75 -- see THE LEVEL GATE above. It is
enforced in the executive's conversation handler, on his own shipped s_47. No
invented text; only the number changed.

WHAT IS NOT MODELLED

allowRepeats = true: stage stops at done, as in every other quest in this wave.

Task 0 and task 3's ItemName strings ("Destroyed power generator", "Power core")
are not minted as inventory items. They are progress markers, nothing downstream
reads them, and the executive takes the core back in conversation anyway.

Task 11's ItemName "Uploaded data" the same.

The Reward tasks' CountItem/CountWeapon/CountArmor, Faction Name and quality
floats are that task type's unused columns; the file grants no faction points,
no weapon and no armour. Experience Amount is 0 in the .qst. The stored Experience
Amount 0 is real; live still paid, because the server recomputed from
quest_experience (see mustafar_quest_xp.lua).
--]]

moralChoiceScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "moralChoiceScreenPlay",

	-- The gate the exec actually enforces, not the .qst's 75; see THE LEVEL GATE.
	-- Enforced in moral_exec_conv_handler.
	requiredLevel = 61,

	-- The new mining facility, snapshot node 12112217; see THE TWO THINGS THE
	-- PLAYER CLICKS.
	facility = {
		buildingID = 12112217,
		x = -2420.5,
		y = 1767.08,
	},

	-- Both are the live facility spawn table's, cell-local; see THE TWO THINGS
	-- THE PLAYER CLICKS. cellID is the snapshot node, used only if the name
	-- does not resolve -- and it is now filled in for both, which it was not.
	exec = {
		template = "som_kenobi_moral_exec",
		cellName = "conference_room",
		cellID = 12112241,
		x = -152.4,
		z = 19.1,
		y = -13.3,
		heading = -116,
	},

	-- NOT small_room_05. The computer is on the mining network floor.
	terminal = {
		template = "object/tangible/quest/som_kenobi_network_computer.iff",
		cellName = "hub_room",
		cellID = 12112236,
		x = -87.9,
		z = 14.4,
		y = -6.3,
		heading = 0,
	},

	-- Task 0's waypoint, quoted, and the one snapshot node that is the generator.
	camp = {
		x = -5267,
		y = 4491,
		waypointName = "Striking miners camp",
	},

	generatorID = 12111382,

	-- Placed. 19 m from the generator, inside the compound, among the nine
	-- miner_on_strike smoking_forest_region.lua already puts there.
	strikeLeader = {
		template = "som_kenobi_moral_strike_leader",
		x = -5280,
		y = 4498,
		heading = 60,
		respawn = 60,
	},

	-- Tasks 4 and 5: Count 2, Min Distance 5, Max Distance 15, one lot per step.
	minerEncounter = {
		template = "miner_on_strike",
		count = 2,
		minDistance = 5,
		maxDistance = 15,
	},

	-- Task 16's Timer and task 15's Encounter.
	guardEncounter = {
		template = "som_kenobi_moral_corrupt_guard",
		count = 3,
		minDistance = 25,
		maxDistance = 50,
		delayMin = 30,
		delayMax = 90,

		-- Not from the .qst; see spawnGuards.
		maxTries = 12,
	},

	-- Task 8 and task 13. Both branches pay the same 20000; the hologram differs.
	rewardCredits = 20000,
	rewardHoloCorp = "object/tangible/item/som/frn_holo_mustafarian_c_reward.iff",
	rewardHoloMiners = "object/tangible/item/som/frn_holo_mustafarian_a_reward.iff",

	STAGE_CABLES = 1,
	STAGE_CORE = 2,
	STAGE_RETURN = 3,
	STAGE_UPLOAD = 4,
	STAGE_TELL = 5,
	STAGE_DONE_CORP = 6,
	STAGE_DONE_MINERS = 7,

	-- What start() actually placed, and which way each cell resolved. None of it
	-- is snapshot data except the generator, so recording the ids is the only way
	-- a boot check can tell a silent failure from a success.
	execID = 0,
	execCellID = 0,
	execCellBy = "none",
	strikeLeaderID = 0,
	terminalID = 0,
	terminalCellID = 0,
	terminalCellBy = "none",
	generatorAttached = false,
}

registerScreenPlay("moralChoiceScreenPlay", true)

function moralChoiceScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachGenerator()
		self:spawnStrikeLeader()
		self:spawnFacilityObjects()
	end
end

-- Snapshot node 12111382. The radial is attached to the world object; nothing is
-- spawned for branch A.
function moralChoiceScreenPlay:attachGenerator()
	local pGenerator = getSceneObject(self.generatorID)

	if (pGenerator == nil) then
		print("moralChoiceScreenPlay: snapshot object " .. self.generatorID .. " (the power generator) was not found; branch A cannot be started")
		return
	end

	writeStringData(self.generatorID .. ":moralChoiceRole", "generator")
	SceneObject(pGenerator):setObjectMenuComponent("MoralChoiceMenuComponent")
	self.generatorAttached = true
end

function moralChoiceScreenPlay:spawnStrikeLeader()
	local leader = self.strikeLeader
	local z = getWorldFloor(leader.x, leader.y, "mustafar")
	local pNpc = spawnMobile("mustafar", leader.template, leader.respawn, leader.x, z, leader.y, leader.heading, 0)

	if (pNpc == nil) then
		print("moralChoiceScreenPlay: failed to spawn " .. leader.template .. "; branch B cannot be started")
	else
		self.strikeLeaderID = SceneObject(pNpc):getObjectID()
	end
end

-- Cell name first, recorded snapshot node id second. Returns the cell id and how
-- it was found, so the boot probe can say which answered.
function moralChoiceScreenPlay:resolveCell(pBuilding, cellName, cellID)
	if (pBuilding ~= nil) then
		local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

		if (pCell ~= nil) then
			return SceneObject(pCell):getObjectID(), "name"
		end
	end

	if (cellID ~= 0 and getSceneObject(cellID) ~= nil) then
		return cellID, "snapshot"
	end

	return 0, "none"
end

function moralChoiceScreenPlay:spawnFacilityObjects()
	local pBuilding = getSceneObject(self.facility.buildingID)

	if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
		print("moralChoiceScreenPlay: the new mining facility (" .. self.facility.buildingID .. ") is missing; the quest has no giver and no terminal")
		pBuilding = nil
	end

	self:spawnExec(pBuilding)
	self:spawnTerminal(pBuilding)
end

function moralChoiceScreenPlay:spawnExec(pBuilding)
	local exec = self.exec

	self.execCellID, self.execCellBy = self:resolveCell(pBuilding, exec.cellName, exec.cellID)

	if (self.execCellID == 0) then
		print("moralChoiceScreenPlay: no cell " .. exec.cellName .. " in the new mining facility; the quest cannot be started")
		return
	end

	local pNpc = spawnMobile("mustafar", exec.template, 0, exec.x, exec.z, exec.y, exec.heading, self.execCellID)

	if (pNpc == nil) then
		print("moralChoiceScreenPlay: failed to spawn " .. exec.template .. "; the quest cannot be started")
	else
		self.execID = SceneObject(pNpc):getObjectID()
	end
end

function moralChoiceScreenPlay:spawnTerminal(pBuilding)
	local terminal = self.terminal

	self.terminalCellID, self.terminalCellBy = self:resolveCell(pBuilding, terminal.cellName, terminal.cellID)

	if (self.terminalCellID == 0) then
		print("moralChoiceScreenPlay: no cell " .. terminal.cellName .. " in the new mining facility; branch B cannot be finished")
		return
	end

	local pTerminal = spawnSceneObject("mustafar", terminal.template, terminal.x, terminal.z, terminal.y, self.terminalCellID, math.rad(terminal.heading))

	if (pTerminal == nil) then
		print("moralChoiceScreenPlay: failed to spawn the network computer; branch B cannot be finished")
		return
	end

	self.terminalID = SceneObject(pTerminal):getObjectID()

	writeStringData(self.terminalID .. ":moralChoiceRole", "terminal")
	SceneObject(pTerminal):setObjectMenuComponent("MoralChoiceMenuComponent")
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0".

	stage   0  not started
	        1  hired; the cables are still in the generator
	        2  cables torn out; the core is still in it
	        3  core in hand; back to the executive
	        4  took the miners' disk; the data is not uploaded yet
	        5  uploaded; back to the strike leader
	        6  paid by the corporation
	        7  paid by the miners
	guards  0 the ambush is not armed, 1 armed, 2 sent or given up on
	gtries  how many times the ambush has been re-armed off-planet
	wp      waypoint id currently handed out, absent if none
--]]

function moralChoiceScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function moralChoiceScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function moralChoiceScreenPlay:isPresent(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	return pGhost ~= nil and PlayerObject(pGhost):isOnline() and SceneObject(pPlayer):getZoneName() == "mustafar"
end

-- One waypoint at a time: the quest never has two fixed-location objectives open.
-- See PROGRESS TRACKING for why it exists at all.
function moralChoiceScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function moralChoiceScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

function moralChoiceScreenPlay:giveReward(pPlayer, template, what)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("moralChoiceScreenPlay: player has no inventory; " .. template .. " could not be handed over")
	elseif (giveItem(pInventory, template, -1, true) == nil) then
		print("moralChoiceScreenPlay: failed to create " .. template)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for " .. what .. ".")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have taken " .. what .. ".")
	end
end

--[[ Branch A -- the corporation ]]

-- Both grant screens in the executive's tree land here; see moral_exec_conv_handler.
function moralChoiceScreenPlay:startQuest(pPlayer)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, self.STAGE_CABLES)

	-- Task 0's createWaypoint and waypointName, both quoted.
	self:giveWaypoint(pPlayer, self.camp.waypointName, "A moral choice", self.camp.x, self.camp.y)

	-- The quest's own journal_entry_description, then task 0's.
	CreatureObject(pPlayer):sendSystemMessage("An executive from the mining corporation has hired you to deal with some striking miners.")
	CreatureObject(pPlayer):sendSystemMessage("An executive from the mining corporation has hired you to destroy the power generator at the striking mining facility in the North West of the continent. The first step is to tear out the cables surrounding the power core of the machine.")

	-- Root task 1's musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")
end

-- Task 0's radial, "Tear out cables", then task 4.
function moralChoiceScreenPlay:tearCables(pPlayer, pGenerator)
	if (self:getStage(pPlayer) ~= self.STAGE_CABLES) then
		return
	end

	self:setStage(pPlayer, self.STAGE_CORE)
	self:removeWaypoint(pPlayer)

	-- Task 3's journalEntryDescription, "Take the core".
	CreatureObject(pPlayer):sendSystemMessage("You need to remove the power core from the generator.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:spawnMiners(pPlayer)
end

-- Task 3's radial, "Steal core", then task 5 and task 7.
function moralChoiceScreenPlay:stealCore(pPlayer, pGenerator)
	if (self:getStage(pPlayer) ~= self.STAGE_CORE) then
		return
	end

	self:setStage(pPlayer, self.STAGE_RETURN)

	-- Task 7's journalEntryDescription, "Return". No createWaypoint on that task;
	-- see PROGRESS TRACKING for why one is handed out anyway.
	CreatureObject(pPlayer):sendSystemMessage("Head back to the new mining facility and show the power core to the executive.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:giveWaypoint(pPlayer, "New mining facility", "A moral choice", self.facility.x, self.facility.y)

	self:spawnMiners(pPlayer)
end

-- Tasks 4 and 5, the same Encounter twice: Count 2, Min Distance 5, Max Distance
-- 15. miner_on_strike is ATTACKABLE and nothing else, so the fight is started for
-- them or they stand there while the player robs the camp.
function moralChoiceScreenPlay:spawnMiners(pPlayer)
	if (not self:isPresent(pPlayer)) then
		return
	end

	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()
	local encounter = self.minerEncounter

	for i = 1, encounter.count do
		local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, encounter.minDistance, encounter.maxDistance, true)

		if (spawnPoint == nil) then
			print("moralChoiceScreenPlay: no spawn point near the player for " .. encounter.template)
		else
			local pMiner = spawnMobile("mustafar", encounter.template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

			if (pMiner == nil) then
				print("moralChoiceScreenPlay: failed to spawn " .. encounter.template)
			else
				AiAgent(pMiner):setDefender(pPlayer)
			end
		end
	end
end

-- Task 7's signal givenCore, then task 8 and task 9. Both reward screens in the
-- executive's tree land here.
function moralChoiceScreenPlay:finishForCorporation(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_RETURN) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE_CORP)
	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_moral_choice_1")
	self:removeWaypoint(pPlayer)

	-- Task 8.
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	CreatureObject(pPlayer):sendSystemMessage("You have received " .. self.rewardCredits .. " credits.")
	self:giveReward(pPlayer, self.rewardHoloCorp, "the executive's hologram")

	-- Task 9's musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
	CreatureObject(pPlayer):sendSystemMessage("You have completed the executive's task.")
end

--[[ Branch B -- the miners ]]

-- Task 10's signal talkedLeader, then task 11. Both disk screens in the strike
-- leader's tree land here; see moral_strike_leader_conv_handler.
function moralChoiceScreenPlay:switchSides(pPlayer)
	local stage = self:getStage(pPlayer)

	-- Task 10 is a sibling of task 0 under root task 1, so the .qst allows every
	-- stage of branch A to switch. The leader only OFFERS it at STAGE_CABLES --
	-- see WHAT THE .QST PERMITS IS NOT WHAT THE LEADER OFFERS -- so the other
	-- two arms are unreachable in practice. Taking the disk closes branch A.
	if (stage ~= self.STAGE_CABLES and stage ~= self.STAGE_CORE and stage ~= self.STAGE_RETURN) then
		return
	end

	self:setStage(pPlayer, self.STAGE_UPLOAD)

	-- Task 11's journalEntryDescription, "Switched sides".
	CreatureObject(pPlayer):sendSystemMessage("You have decided to help the striking miners. Return to the new mining facility and upload the proof against the corrupt executive in to their information network.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:giveWaypoint(pPlayer, "New mining facility", "A moral choice", self.facility.x, self.facility.y)
end

-- Task 11's radial, "Upload data", then tasks 16 and 12.
function moralChoiceScreenPlay:uploadData(pPlayer, pTerminal)
	if (self:getStage(pPlayer) ~= self.STAGE_UPLOAD) then
		return
	end

	self:setStage(pPlayer, self.STAGE_TELL)

	-- Task 12's journalEntryDescription, "Mission accomplished".
	CreatureObject(pPlayer):sendSystemMessage("Return to the striking miners leader and let him know that it's done.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:giveWaypoint(pPlayer, self.camp.waypointName, "A moral choice", self.camp.x, self.camp.y)

	self:armGuards(pPlayer)
end

-- Task 16's Timer, Min 30 / Max 90.
function moralChoiceScreenPlay:armGuards(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "guards")) or 0) ~= 0) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "guards", "1")
	createEvent(getRandomNumber(self.guardEncounter.delayMin, self.guardEncounter.delayMax) * 1000, "moralChoiceScreenPlay", "spawnGuards", pPlayer, "")
end

-- Task 15's Encounter: Count 3, Min Distance 25, Max Distance 50. They are
-- AGGRESSIVE + ATTACKABLE + ENEMY in their own template, so nothing has to start
-- the fight for them -- which is what the strike leader's s_206 promises.
function moralChoiceScreenPlay:spawnGuards(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- The player logged out or left the planet. The ambush is re-armed rather
	-- than lost, but bounded, so a player who never comes back to Mustafar does
	-- not leave an event rescheduling itself forever.
	if (not self:isPresent(pPlayer)) then
		local tries = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "gtries")) or 0) + 1

		if (tries > self.guardEncounter.maxTries) then
			writeScreenPlayData(pPlayer, self.screenplayName, "guards", "2")
			return
		end

		writeScreenPlayData(pPlayer, self.screenplayName, "gtries", tostring(tries))
		createEvent(getRandomNumber(self.guardEncounter.delayMin, self.guardEncounter.delayMax) * 1000, "moralChoiceScreenPlay", "spawnGuards", pPlayer, "")
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "guards", "2")

	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()
	local encounter = self.guardEncounter

	for i = 1, encounter.count do
		local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, encounter.minDistance, encounter.maxDistance, true)

		if (spawnPoint == nil) then
			print("moralChoiceScreenPlay: no spawn point near the player for " .. encounter.template)
		elseif (spawnMobile("mustafar", encounter.template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0) == nil) then
			print("moralChoiceScreenPlay: failed to spawn " .. encounter.template)
		end
	end
end

-- Task 12's signal talkedLeader2, then task 13 and task 14. The reward screen in
-- the strike leader's tree lands here.
function moralChoiceScreenPlay:finishForMiners(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_TELL) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE_MINERS)
	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_moral_choice_1")
	self:removeWaypoint(pPlayer)

	-- Task 13.
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	CreatureObject(pPlayer):sendSystemMessage("You have received " .. self.rewardCredits .. " credits.")
	self:giveReward(pPlayer, self.rewardHoloMiners, "the striking miners' hologram")

	-- Task 14's musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
	CreatureObject(pPlayer):sendSystemMessage("You have completed the striking miners' task.")
end

--[[ Radial dispatch

One component table serves both objects -- the snapshot generator and the spawned
terminal. SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely, so
fillObjectMenuResponse has to add every item we want to see and adds nothing at
all when this player has no business touching the object.

The generator carries two radials in sequence, which is how the .qst has it: task
0 and task 3 name the same Server Object Template with different retrieveMenuText.
Both strings below are the .qst's own.
--]]

function moralChoiceScreenPlay:getRadialText(pPlayer, role)
	local stage = self:getStage(pPlayer)

	if (role == "generator") then
		if (stage == self.STAGE_CABLES) then
			return "Tear out cables"
		elseif (stage == self.STAGE_CORE) then
			return "Steal core"
		end
	elseif (role == "terminal") then
		if (stage == self.STAGE_UPLOAD) then
			return "Upload data"
		end
	end

	return nil
end

MoralChoiceMenuComponent = {}

function MoralChoiceMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":moralChoiceRole")
	local text = moralChoiceScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function MoralChoiceMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":moralChoiceRole")

	if (role == "generator") then
		local stage = moralChoiceScreenPlay:getStage(pPlayer)

		if (stage == moralChoiceScreenPlay.STAGE_CABLES) then
			moralChoiceScreenPlay:tearCables(pPlayer, pSceneObject)
		elseif (stage == moralChoiceScreenPlay.STAGE_CORE) then
			moralChoiceScreenPlay:stealCore(pPlayer, pSceneObject)
		end
	elseif (role == "terminal") then
		moralChoiceScreenPlay:uploadData(pPlayer, pSceneObject)
	end

	return 0
end
