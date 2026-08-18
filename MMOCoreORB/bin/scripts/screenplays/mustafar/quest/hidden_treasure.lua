--[[
A hidden treasure  --  som_kenobi_hidden_treasure_1 + som_kenobi_hidden_treasure_2

SOURCE OF RECORD

Both halves come from the shipped quest definitions, quest/som_kenobi_hidden_treasure_1.qst
and _2.qst in the client TREs. Every message box title and body below is quoted
verbatim from them, as are the radial texts ("Turn to 8", "Click saber symbol",
"Pull lever"), the travel location and its 10 m radius, the encounter distances,
and the reward. The strings also appear in string/en/quest/... and match.

The two files are one player-facing chain: _1's last task carries
grantQuestOnComplete = som_kenobi_hidden_treasure_2, and _2's list block sets
allowRepeats = false, so the whole thing runs once per character. They are kept in
one screenplay here because splitting them would mean duplicating the vault object
wiring for no gain.

WHERE THE OBJECTS COME FROM

Nothing here is spawned except the guardian and one active area. snapshot/mustafar.ws
in stardust_03.tre already places the plaque, the dial, the holocron and both levers,
and PlanetManagerImplementation::loadSnapshotObject() instantiates each snapshot node
with objectID == the node ID. getSceneObject(<nodeID>) therefore returns the exact
object the client is already drawing, and spawning our own copies would double them up.

The ordering that makes this safe: ZoneServerImplementation::start() runs
startGroundZones() -- which blocks until every zone reports hasManagersStarted(), and
PlanetManager::initialize() calls loadSnapshotObjects() -- strictly before
startManagers() reaches startGlobalScreenPlays(). Snapshot objects exist before any
screenplay :start() runs.

    node 12110146  quest_start/som_kenobi_hidden_treasure_plaque   ( 36.53, 130.36, 4387.13)
    node 12110959  som_vault_dial                                  (-1128.72, 48.66, 4194.32)
    node 12110960  som_vault_holocron                              (-1128.51, 48.10, 4194.31)
    node 12110958  som_vault_lever                                 (-1127.53, 48.23, 4195.75)
    node 12110956  som_vault_lever_2                               (-1127.45, 48.24, 4195.84)

(.ws stores x / height / z; Core3's spawn and waypoint calls take x, z, y with z as
the height, so a .ws triple maps across unchanged in that order.)

RADIALS

The .qst drives these objects through Retrieve Item tasks, whose retrieveMenuText
only appears while the task is live. There is no quest journal to hang that off here
(see PROGRESS TRACKING), so each object gets a Lua ObjectMenuComponent that offers
its radial item only to a player whose stored stage says that step is next. A player
who has not started, or who is past that step, sees the object's ordinary radial.

The plaque is the one exception: the .qst's opening task is a Show Message Box with
no retrieveMenuText, because in live the quest_start object's own use action fired it.
"Read the tablet" is therefore this file's wording, not a shipped string -- it is the
only invented player-visible text in the chain.

PROGRESS TRACKING

Neither quest has a row in datatables/player/quests.iff. The table the server loads
is the one in stardust_03.tre, which wins the TreFiles order in conf/config.lua; it
holds 307 rows whose only Mustafar entries are the 45 exploration markers. Adding a
row would mean authoring a TRE, so progress lives in persistent screenplay data on
the player's ghost instead: waypoints, message boxes and system messages, but no
journal entry.

THE REWARD  --  SUBSTITUTED, and here is exactly why

The .qst awards lootCount 1 / lootName item_tow_schematic_reactor_02_01, with Bank
Credits 0 and Experience Amount 0. lootName is a live server-side static-item name;
it is not an object template, and the client ships no table that maps it to one --
there are no datatables/quest/* or datatables/loot/* entries in any TRE here, and no
string/en STF row for it either. So the live item cannot be resolved, only matched by
name.

The obvious match is object/draft_schematic/space/reactor/collection_reward_reactor_02_mk1
-- same reactor family, same mark -- and this tree does declare it, in
object/custom_content/draft_schematic/space/reactor/. It cannot be granted, for two
independent reasons:

  1. SchematicMap is populated only from scripts/managers/crafting/schematics.lua
     (SchematicMap.cpp:36). The collection_reward_reactor_01_mk1..mk5 and _02_mk1..mk4
     entries are not in that list, so SchematicMap::get() returns nullptr and
     LuaPlayerObject::addRewardedSchematic (LuaPlayerObject.cpp:297-302) pushes false
     without granting anything. Granting it would have been a silent no-op.
  2. Registering it would not help. Those server templates are empty shells --
     collection_reward_reactor_02_mk1.lua is `shared_...:new { }` with no body -- and
     for draft schematics all the crafting data (ingredientTemplateNames,
     resourceTypes, targetTemplate, xpType, complexity) lives in the SERVER lua; see
     object/draft_schematic/space/reactor/fusion_reactor_mk1.lua for a complete one.
     There is also no object/tangible/ship/crafted/reactor/collection_reward_reactor_*
     to be the craft target. Filling those in would mean inventing a recipe and a
     crafted item, which is content authoring, not wiring.

So the reward granted here is object/draft_schematic/space/reactor/fusion_reactor_mk5.iff
-- the top of the real, registered, craftable space-reactor family (schematics.lua:1618,
targetTemplate object/tangible/ship/crafted/reactor/fusion_reactor_mk5.iff). It keeps
the quest's payout a working endgame space reactor schematic, which is what the reward
was, and it grants something that actually exists.

To restore the live item later, the collection_reward_reactor_02_mk1 server template
needs a real recipe plus a crafted tangible, and the path needs adding to
scripts/managers/crafting/schematics.lua; then only rewardSchematic below changes.

It is granted as a QUEST-type rewarded schematic (SchematicList.h:25 -- MISSION 0,
LOOT 1, QUEST 2) with an unlimited use count, matching the other quest schematic
rewards in this tree (sivarra_phase1_conv_handler.lua:62, ris_armor_quest.lua:146).
--]]

hiddenTreasureScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "hiddenTreasureScreenPlay",

	-- Snapshot node IDs; see the header. Each is paired with the role name the
	-- menu component dispatches on.
	questObjects = {
		{ role = "plaque",  nodeID = 12110146 },
		{ role = "dial",    nodeID = 12110959 },
		{ role = "holocron",nodeID = 12110960 },
		{ role = "lever",   nodeID = 12110958 },
		{ role = "lever2",  nodeID = 12110956 },
	},

	-- .qst _1 task 14, Go to Location: mustafar (-1130, 46, 4190), Radius 10,
	-- waypointName "Secret vault".
	vault = { x = -1130, z = 46, y = 4190, radius = 10, waypointName = "Secret vault" },

	-- .qst _2 tasks 16 and 12, Encounter: Count 1, Min Distance 5, Max Distance 50.
	encounter = { count = 1, minDistance = 5, maxDistance = 50 },

	-- lever  (node 12110958) wakes the droideka, lever_2 (node 12110956) wakes the
	-- IG. Otherwise the two branches are identical in the .qst.
	guardians = { lever = "som_ancient_guardian_droideka", lever2 = "som_ancient_guardian_ig" },

	-- Substituted for the .qst's item_tow_schematic_reactor_02_01; see THE REWARD
	-- in the header for why the live-named schematic cannot be granted.
	rewardSchematic = "object/draft_schematic/space/reactor/fusion_reactor_mk5.iff",

	vaultAreaID = 0,
}

registerScreenPlay("hiddenTreasureScreenPlay", true)

function hiddenTreasureScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachQuestObjects()
		self:spawnVaultArea()
	end
end

function hiddenTreasureScreenPlay:attachQuestObjects()
	for i = 1, #self.questObjects do
		local entry = self.questObjects[i]
		local pObject = getSceneObject(entry.nodeID)

		if (pObject == nil) then
			print("hiddenTreasureScreenPlay: snapshot object " .. entry.nodeID .. " (" .. entry.role .. ") was not found; that step of the quest will be unreachable")
		else
			-- The component is a single global table shared by all five objects;
			-- it reads this back to know which one it is talking about.
			writeStringData(entry.nodeID .. ":hiddenTreasureRole", entry.role)
			SceneObject(pObject):setObjectMenuComponent("HiddenTreasureMenuComponent")
		end
	end
end

function hiddenTreasureScreenPlay:spawnVaultArea()
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.vault.x, self.vault.z, self.vault.y, self.vault.radius, 0)

	if (pArea == nil) then
		print("hiddenTreasureScreenPlay: failed to spawn the vault arrival area")
		return
	end

	self.vaultAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "hiddenTreasureScreenPlay", "notifyEnteredVault", pArea)
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage    0  not started
	         1  tablet read, travelling to the vault
	         2  at the vault, dial not yet turned
	         3  dial turned, holocron not yet clicked
	         4  holocron clicked -- hidden_treasure_2 is now live, both levers armed
	         5  a lever has been pulled, the guardian is up
	         6  finished
	wp_vault waypoint id handed out for the vault
--]]

function hiddenTreasureScreenPlay:rawStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

--[[ Stage 5 hangs entirely off the guardian, and spawnMobile's mobs are not persistent --
     DirectorManager passes persistent = false into CreatureManager::spawnCreature -- so a
     restart takes the guardian and leaves the stage behind. There is no stage-5 radial on
     either lever and nothing but notifyGuardianKilled writes stage 6, so that player would
     be done with the quest still open. Reading the stage rolls an orphaned stage 5 back to
     4, which is the same anti-strand rollback spawnGuardian already performs on both of
     its spawn-failure paths: both levers are armed again and pulling one re-runs the
     encounter from the top. ]]
function hiddenTreasureScreenPlay:getStage(pPlayer)
	local stage = self:rawStage(pPlayer)

	if (stage == 5) then
		local guardianID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "guardian")) or 0

		if (guardianID == 0 or getSceneObject(guardianID) == nil) then
			self:setStage(pPlayer, 4)
			deleteScreenPlayData(pPlayer, self.screenplayName, "guardian")

			return 4
		end
	end

	return stage
end

function hiddenTreasureScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

-- Which radial, if any, this player should be offered on a given object.
function hiddenTreasureScreenPlay:getRadialText(pPlayer, role)
	local stage = self:getStage(pPlayer)

	if (role == "plaque" and stage == 0) then
		return "Read the tablet"                    -- not a shipped string; see the header
	elseif (role == "dial" and stage == 2) then
		return "Turn to 8"                          -- .qst _1 task 15 retrieveMenuText
	elseif (role == "holocron" and stage == 3) then
		return "Click saber symbol"                 -- .qst _1 task 16 retrieveMenuText
	elseif ((role == "lever" or role == "lever2") and stage == 4) then
		return "Pull lever"                         -- .qst _2 tasks 9 and 7 retrieveMenuText
	end

	return nil
end

function hiddenTreasureScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("hiddenTreasureScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

-- The .qst message boxes are read-and-dismiss; nothing branches on the button.
function hiddenTreasureScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

--[[ hidden_treasure_1 ]]

-- .qst _1 task 0: Show Message Box "The buried tablet",
-- musicOnActivate sound/mus_mustafar_quest_exception.snd.
function hiddenTreasureScreenPlay:readTablet(pPlayer, pPlaque)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, 1)

	self:showMessageBox(pPlayer, pPlaque, "The buried tablet",
		"There's a buried tablet stuck in the lava rock. You can only see the top half of what is written on it. From what you can make out, someone referring to themselves as a 'knight', explains that with recent developments, she's forced to hide something in the vault. The location of this vault is on the tablet, as well as the sequence needed to disable the security system. Unfortunately, that part is cut in half. You quickly copy down what is written on the plaque in to your datapad.")

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", self.vault.waypointName, "A hidden treasure?", self.vault.x, 0, self.vault.y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
		writeScreenPlayData(pPlayer, self.screenplayName, "wp_vault", tostring(waypointID))
	end
end

-- .qst _1 task 14 completing, which fires task 17: Show Message Box
-- "Disabling security, step 1".
function hiddenTreasureScreenPlay:notifyEnteredVault(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (SceneObject(pArea):getObjectID() ~= self.vaultAreaID or self:getStage(pPlayer) ~= 1) then
		return 0
	end

	self:setStage(pPlayer, 2)
	self:removeVaultWaypoint(pPlayer)

	self:showMessageBox(pPlayer, nil, "Disabling security, step 1",
		"There is indeed a vault here. The first thing to do according to the tablet is turning the left dial to the number 8.")

	return 0
end

function hiddenTreasureScreenPlay:removeVaultWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp_vault")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp_vault")
end

-- .qst _1 task 15 completing, which fires task 18.
function hiddenTreasureScreenPlay:turnDial(pPlayer, pDial)
	if (self:getStage(pPlayer) ~= 2) then
		return
	end

	self:setStage(pPlayer, 3)

	self:showMessageBox(pPlayer, pDial, "Disabling security, step 2",
		"Click the saber symbol on the holocron.")
end

-- .qst _1 task 16 completing, which fires task 19 -- the task that carries
-- grantQuestOnComplete = som_kenobi_hidden_treasure_2.
function hiddenTreasureScreenPlay:clickHolocron(pPlayer, pHolocron)
	if (self:getStage(pPlayer) ~= 3) then
		return
	end

	self:setStage(pPlayer, 4)

	self:showMessageBox(pPlayer, pHolocron, "No more clues",
		"That was all the help you got out of the tablet. There's two levers on the wall, which one to pull is up to you...")
end

--[[ hidden_treasure_2 ]]

-- .qst _2 tasks 7 and 9 completing, each firing its own copy of the "Wrong lever?"
-- box (tasks 11 and 10) and then its Encounter (tasks 16 and 12).
function hiddenTreasureScreenPlay:pullLever(pPlayer, pLever, role)
	if (self:getStage(pPlayer) ~= 4) then
		return
	end

	self:setStage(pPlayer, 5)

	self:showMessageBox(pPlayer, pLever, "Wrong lever?",
		"As you force the lever down, sounds of squealing mechanics and electronics coming to life is heard from inside.")

	self:spawnGuardian(pPlayer, self.guardians[role])
end

function hiddenTreasureScreenPlay:spawnGuardian(pPlayer, guardianTemplate)
	local playerID = SceneObject(pPlayer):getObjectID()
	local spawnPoint = getSpawnPoint("mustafar", SceneObject(pPlayer):getWorldPositionX(), SceneObject(pPlayer):getWorldPositionY(), self.encounter.minDistance, self.encounter.maxDistance, true)

	if (spawnPoint == nil) then
		print("hiddenTreasureScreenPlay: no spawn point near the vault for " .. guardianTemplate)
		-- Do not strand the player at stage 5 with nothing to kill.
		self:setStage(pPlayer, 4)
		return
	end

	local pGuardian = spawnMobile("mustafar", guardianTemplate, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], 0, 0)

	if (pGuardian == nil) then
		print("hiddenTreasureScreenPlay: failed to spawn " .. guardianTemplate)
		self:setStage(pPlayer, 4)
		return
	end

	-- Spawned mobs do not survive a restart, so this bookkeeping is deliberately
	-- in the non-persistent store; the player's stage is what persists.
	writeData(SceneObject(pGuardian):getObjectID() .. ":hiddenTreasurePlayer", playerID)

	-- The reverse link, on the player, is what lets getStage tell "guardian still up" from
	-- "guardian went away with the process" and roll stage 5 back rather than strand it.
	writeScreenPlayData(pPlayer, self.screenplayName, "guardian", tostring(SceneObject(pGuardian):getObjectID()))

	createObserver(OBJECTDESTRUCTION, "hiddenTreasureScreenPlay", "notifyGuardianKilled", pGuardian)
	AiAgent(pGuardian):setDefender(pPlayer)
end

-- .qst _2 tasks 25 and 24 (Destroy Multiple, Count 1) completing, each firing its
-- copy of the "Something more?" box (tasks 23 and 22) and then the Reward task.
function hiddenTreasureScreenPlay:notifyGuardianKilled(pGuardian, pKiller)
	if (pGuardian == nil) then
		return 1
	end

	local ownerID = readData(SceneObject(pGuardian):getObjectID() .. ":hiddenTreasurePlayer")
	local pPlayer = getSceneObject(ownerID)

	deleteData(SceneObject(pGuardian):getObjectID() .. ":hiddenTreasurePlayer")

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	-- Raw, not getStage: the guardian is being destroyed as this fires, so the reverse link
	-- may no longer resolve and getStage's orphan rollback would take the reward away.
	if (self:rawStage(pPlayer) ~= 5) then
		return 1
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "guardian")

	self:showMessageBox(pPlayer, nil, "Something more?",
		"As you lay the ancient machine to rest, you notice a glimmer among its remains of something. As you bend down to look at it, you see that it's a small ornamented box. Inside it is a strange glowing crystal and a holodisc with a message recorded. As you play the message, the blue holo image of an elderly woman in a robe appears and starts to speak. '...this schematic seems to describe part of a doomsday device. I don't have time to investigate it further, or try and find schematics for the rest of the machine as my former padawan is already here. I fear that he's beyond redemption and that his power might actually exceed my own at this point. To avoid it ending up in the wrong hands, I will secure the schematic in this old vault, guarded by a droid. To you, the finder of the schematic, I urge you to travel to the Jedi Council on Coruscant and entrust the masters there with it and this disc. ...It is strange, last night I had a dream of a situation so similar to mine...a master facing down his student on this very world. It seemed so real, so strong; perhaps if I survive Master Yoda will have an explanation. He is newly raised to the rank of master but still seems to have wisdom well beyond his years. ' The message is on a loop and keeps playing until you turn it off.")

	self:awardQuest(pPlayer)

	return 1
end

function hiddenTreasureScreenPlay:awardQuest(pPlayer)
	self:setStage(pPlayer, 6)

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		-- type 2 = SchematicList::QUEST, use count -1 = unlimited.
		if (not PlayerObject(pGhost):addRewardedSchematic(self.rewardSchematic, 2, -1, true)) then
			CreatureObject(pPlayer):sendSystemMessage("You already know the schematic sealed in the box.")
		else
			CreatureObject(pPlayer):sendSystemMessage("You have learned the schematic sealed in the ornamented box.")
		end
	end

	-- .qst _2 task 15/19, Immediately Complete Quest,
	-- musicOnComplete sound/mus_mustafar_quest_success.snd.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
end

--[[ Radial dispatch

One component table serves all five objects. SceneObjectImplementation::
setObjectMenuComponent() falls through to LuaObjectMenuComponent when no C++
component of that name is registered, and LuaObjectMenuComponent replaces the
object's menu entirely -- so fillObjectMenuResponse has to add every item we want
to see, and adds nothing at all when this player has no business touching the object.
--]]

HiddenTreasureMenuComponent = {}

function HiddenTreasureMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":hiddenTreasureRole")
	local text = hiddenTreasureScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function HiddenTreasureMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":hiddenTreasureRole")

	if (role == "plaque") then
		hiddenTreasureScreenPlay:readTablet(pPlayer, pSceneObject)
	elseif (role == "dial") then
		hiddenTreasureScreenPlay:turnDial(pPlayer, pSceneObject)
	elseif (role == "holocron") then
		hiddenTreasureScreenPlay:clickHolocron(pPlayer, pSceneObject)
	elseif (role == "lever" or role == "lever2") then
		hiddenTreasureScreenPlay:pullLever(pPlayer, pSceneObject, role)
	end

	return 0
end
