--[[
Symbiosis  --  som_kenobi_symbiosis_1 + som_kenobi_symbiosis_2

SOURCE OF RECORD

quest/som_kenobi_symbiosis_1.qst and _2.qst in the client TREs. Every message box
title and body below is quoted verbatim from them, as are the radial text
("Examine corpse", "Seal and grab container"), the two locations and their radii,
the encounter counts and distances, and the two timers.

_1's last task is Immediately Complete Quest with grantQuestOnComplete =
som_kenobi_symbiosis_2, and _2 is a pure delayed ambush with journalVisible false,
so the two are one player-facing sequence and live in one screenplay here.

WHERE THE OBJECTS COME FROM

The fluid container is a snapshot prop. snapshot/mustafar.ws in stardust_03.tre
places it and PlanetManagerImplementation::loadSnapshotObject() instantiates each
node with objectID == the node ID, so getSceneObject(<nodeID>) returns the object
the client is already drawing:

    node 12112643  quest_start/som_kenobi_symbiosis_fluid_container  (-1551.38, 115.97, 467.68)

(Cross-checked against mtg_patch_023.tre's copy of mustafar.ws: same node, same
position, so Levarris's snapshot work did not move it.)

The three treasure-hunter corpses are NOT in any snapshot -- they are
object/mobile/som/... creature templates, and no .ws in any TRE here carries them.
They were server-side spawns in live, and that spawn data did not ship. They are
therefore spawnMobile'd by this screenplay.

CORPSE POSITIONS  --  two of the three are placed, not quoted

The .qst gives a position for exactly one corpse: task 7 (corpse_03) carries
createWaypoint true, Planet mustafar, (-1545, 116, 460), waypointName "Corpses".
Tasks 1 and 2 (corpse_02 and corpse_01) carry no position at all -- Planet
tatooine, 0/0/0, which is this quest format's "unset".

So corpse_03 sits exactly on its own waypoint, and corpse_01/_02 are placed a few
metres either side of it. That is a choice, and here is the reasoning behind it:
the waypoint is named "Corpses" plural, task 12's text sends the player to it with
"Go back and search around the area", and the opening box at the container says
"Maybe the corpses nearby holds a clue" -- the container is ~10 m away at
(-1551.38, 467.68). One tight cluster on the "Corpses" waypoint is the only
reading all three of those support.

Height is not hardcoded for any of them. getWorldFloor(x, y, "mustafar") resolves
it at spawn time, so the corpses sit on whatever the terrain actually is rather
than on a number copied out of a snapshot -- which matters here, because the
Mustafar terrain in this tree is Levarris's and is not the shipped terrain.

RADIALS

The .qst drives the corpses and the container through Retrieve Item tasks, whose
retrieveMenuText only shows while that task is live. There is no quest journal to
hang that off here (see PROGRESS TRACKING), so each object gets a Lua
ObjectMenuComponent that offers its radial only to a player whose stored stage
says that step is next.

One string is this file's wording rather than a shipped one: "Examine the
container". The .qst's opening task is a Show Message Box with no retrieveMenuText,
because in live the quest_start object's own use action fired it. Everything else
is quoted.

PROGRESS TRACKING

Neither quest has a row in datatables/player/quests.iff -- the table the server
loads is stardust_03.tre's, which wins the TreFiles order in conf/config.lua, and
its only Mustafar rows are the 45 exploration markers. Adding a row would mean
authoring a TRE. Progress therefore lives in persistent screenplay data on the
player's ghost: waypoints, message boxes and system messages, but no journal entry.

THE REWARD  --  SUBSTITUTED, and here is exactly why

_1's Reward task pays Experience Amount 0 and Bank Credits 0, and awards
lootCount 1 / lootName weapon_tow_sword_1h_03_02. The stored Experience Amount 0
is real; live still paid, because the server recomputed from quest_experience
(see mustafar_quest_xp.lua). As with the other TOW rewards in
this arc, lootName is a live server-side static-item name, not itself an
object-template path. The name resolves to "Caller of Storms" in
string/en/static_item_n.stf, and unlike most of this arc an object carrying that
exact objectName does ship --
object/tangible/collection/shared_rare_melee_caller_storms.iff (and its server
pair) -- but it is a non-functional display tangible
(SharedTangibleObjectTemplate, gameObjectType = 8211, no damage, no attackSpeed,
no xpType, no cert). Swapping the working sword granted below for that display
piece would pay the quest out in an ornament the player cannot swing, and that is
not a choice anyone needs to make -- a reward that cannot be used is a defect.
The name-exact object is therefore refused on purpose and the reward stays a
substitution matched by description.

What the name says: a one-handed sword ("sword_1h"), from Trials of Obi-Wan
("tow"), and task 11 describes it as "a strange sword, wrapped up in cloth".

What this tree actually grants for that: object/weapon/melee/sword/som_sword_obsidian.iff
-- the Mustafar obsidian blade. It is a real, complete server weapon template
(object/custom_content/weapon/melee/som_sword_obsidian.lua: MELEEATTACK, KINETIC,
60-250 damage, 3.5 attack speed, xpType combat_meleespecialize_onehand, cert
cert_sword_01), it is registered via ObjectTemplates:addTemplate and included from
custom_content/weapon/melee/serverobjects.lua:130, and its appearance ships in the
client (shared_som_sword_obsidian.iff, present in mtg_patch_010_object_01.tre and
mtg_patch_022.tre). It is a one-handed sword, it is Mustafar's, and it is
functional -- unlike the exact-named collection display tangible above.

It is handed over with giveItem() into the player's inventory, which creates the
object for real. This is deliberately NOT addRewardedSchematic: that call fails
closed when the path is not in scripts/managers/crafting/schematics.lua and would
silently grant nothing (the defect this arc's hidden_treasure.lua reward already
had to be corrected for).

If the name-exact sword_1h_tow_obsidian is ever rebuilt as a real weapon template
instead of the collection display tangible it currently is, only rewardWeapon
below changes. Nothing else in this file reads the reward path.

WHAT IS NOT MODELLED

_1 tasks 1/2/6/7 are Retrieve Item, so in live the player ended up carrying
"Examined corpse", "Sealed container" and "Clues" as inventory objects. No tangible
exists here for any of them and inventing three quest items would be content
authoring, not wiring, so those steps advance the stage and show their message box
without minting an item. Nothing downstream in either .qst reads them; they were
progress markers.
--]]

local JournalMirror = require("managers.quest.journal_mirror")

symbiosisScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "symbiosisScreenPlay",

	-- Snapshot node; see the header.
	containerNodeID = 12112643,

	-- corpse_03's position is .qst task 7 verbatim. corpse_01 and corpse_02 are
	-- placed around it; see CORPSE POSITIONS in the header. Height is resolved at
	-- spawn time, never taken from here.
	corpses = {
		{ role = "corpse1", template = "som_kenobi_treasure_hunter_corpse_01", x = -1543, y = 462, heading = 40 },
		{ role = "corpse2", template = "som_kenobi_treasure_hunter_corpse_02", x = -1547, y = 458, heading = 200 },
		{ role = "corpse3", template = "som_kenobi_treasure_hunter_corpse_03", x = -1545, y = 460, heading = 120 },
	},

	-- .qst _1 task 15, Go to Location: mustafar (-1584, 101, 701), Radius 3,
	-- waypointName "Lava river".
	lava = { x = -1584, z = 101, y = 701, radius = 3, waypointName = "Lava river" },

	-- .qst _1 task 7's waypoint, which is also where corpse_03 is spawned.
	cluster = { x = -1545, z = 116, y = 460, waypointName = "Corpses" },

	-- .qst _1 tasks 4 and 5, Encounter: Count 2, Min Distance 1, Max Distance 2.
	burstEncounter = { count = 2, minDistance = 1, maxDistance = 2 },

	-- .qst _2: Timer 5-8 s, then Encounter Count 6 / Min 10 / Max 20, then a 20 s
	-- Timer and Immediately Clear Quest.
	ambush = { delayMin = 5, delayMax = 8, count = 6, minDistance = 10, maxDistance = 20, clearAfter = 20 },

	-- The repo name is som_alien_parasite; the .qst calls the same creature
	-- som_kenobi_alien_parasite. spawnMobile needs the repo name.
	parasite = "som_alien_parasite",

	-- Substituted for the .qst's weapon_tow_sword_1h_03_02; see THE REWARD.
	rewardWeapon = "object/weapon/melee/sword/som_sword_obsidian.iff",

	lavaAreaID = 0,
}

-- JOURNAL MIRROR (J-3, 2026-09-04): stage -> client journal task bits, from the SOE task tree in
-- this header and scratch/mustafar-stage-task-map.md §symbiosis. Screenplay data stays truth.
symbiosisScreenPlay.journalMap = {
	[1] = { quest = "som_kenobi_symbiosis_1", complete = {0}, activate = {1, 2, 3} }, -- 1→_1 t1+t2 under t3
	[2] = { quest = "som_kenobi_symbiosis_1", complete = {1, 2, 3}, activate = {6} }, -- 2→_1 t13 OOR; t6 live
	[3] = { quest = "som_kenobi_symbiosis_1", complete = {6} }, -- 3→_1 t15 Go to Location (t15 OOR)
	[4] = { quest = "som_kenobi_symbiosis_1", activate = {7} }, -- 4→_1 t12 OOR; t7 Retrieve
	[5] = { quest = "som_kenobi_symbiosis_1", complete = {7, 9, 10}, finish = true }, -- 5→_1 t9 Reward / t10 Complete; _2 journalVisible false
	-- 6 unmapped: _2 is journalVisible false (delayed ambush), no journal bit
}

registerScreenPlay("symbiosisScreenPlay", true)

function symbiosisScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachContainer()
		self:spawnCorpses()
		self:spawnLavaArea()
	end
end

function symbiosisScreenPlay:attachContainer()
	local pContainer = getSceneObject(self.containerNodeID)

	if (pContainer == nil) then
		print("symbiosisScreenPlay: snapshot object " .. self.containerNodeID .. " (fluid container) was not found; the quest cannot be started")
		return
	end

	writeStringData(self.containerNodeID .. ":symbiosisRole", "container")
	SceneObject(pContainer):setObjectMenuComponent("SymbiosisMenuComponent")
end

function symbiosisScreenPlay:spawnCorpses()
	for i = 1, #self.corpses do
		local entry = self.corpses[i]
		local z = getWorldFloor(entry.x, entry.y, "mustafar")
		local pCorpse = spawnMobile("mustafar", entry.template, 0, entry.x, z, entry.y, entry.heading, 0)

		if (pCorpse == nil) then
			print("symbiosisScreenPlay: failed to spawn " .. entry.template .. "; that step of the quest will be unreachable")
		else
			writeStringData(SceneObject(pCorpse):getObjectID() .. ":symbiosisRole", entry.role)
			SceneObject(pCorpse):setObjectMenuComponent("SymbiosisMenuComponent")
		end
	end
end

function symbiosisScreenPlay:spawnLavaArea()
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.lava.x, self.lava.z, self.lava.y, self.lava.radius, 0)

	if (pArea == nil) then
		print("symbiosisScreenPlay: failed to spawn the lava river area")
		return
	end

	self.lavaAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "symbiosisScreenPlay", "notifyEnteredLava", pArea)
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage      0  not started
	           1  container examined; both corpses still to examine
	           2  both corpses examined, container ready to seal and grab
	           3  container taken, heading for the lava river
	           4  tubes destroyed, heading back to the corpses
	           5  symbiosis_1 complete and rewarded; symbiosis_2 armed
	           6  symbiosis_2 ambush fired and cleared
	corpse1    1 once that corpse has been examined
	corpse2    1 once that corpse has been examined
	wp         waypoint id currently handed out, 0 if none
--]]

function symbiosisScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function symbiosisScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	JournalMirror.applyStage(pPlayer, self.journalMap, stage)   -- J-3 journal mirror
end

function symbiosisScreenPlay:isExamined(pPlayer, role)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, role)) or 0) == 1
end

-- Which radial, if any, this player should be offered on a given object.
function symbiosisScreenPlay:getRadialText(pPlayer, role)
	local stage = self:getStage(pPlayer)

	if (role == "container") then
		if (stage == 0) then
			return "Examine the container"           -- not a shipped string; see the header
		elseif (stage == 2) then
			return "Seal and grab container"         -- .qst _1 task 6 retrieveMenuText
		end
	elseif (role == "corpse1" or role == "corpse2") then
		if (stage == 1 and not self:isExamined(pPlayer, role)) then
			return "Examine corpse"                  -- .qst _1 tasks 1 and 2 retrieveMenuText
		end
	elseif (role == "corpse3") then
		if (stage == 4) then
			return "Examine corpse"                  -- .qst _1 task 7 retrieveMenuText
		end
	end

	return nil
end

function symbiosisScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("symbiosisScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

-- The .qst message boxes are read-and-dismiss; nothing branches on the button.
function symbiosisScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

function symbiosisScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function symbiosisScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

--[[ symbiosis_1 ]]

-- .qst _1 task 0: Show Message Box "Poison?",
-- musicOnActivate sound/mus_mustafar_quest_exception.snd.
function symbiosisScreenPlay:examineContainer(pPlayer, pContainer)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, 1)

	self:showMessageBox(pPlayer, pContainer, "Poison?",
		"Inside the bag you find several test tubes with a slow floating fluid inside them. One has broken open and the goo coming out of it has small black things floating around in it, like tiny pearls or eggs. You probably shouldn't touch it. Maybe the corpses nearby holds a clue to what happened here?")

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- .qst _1 task 3, Wait for Tasks on taskName "examine": journal entry
	-- "A virus?". No journal here, so the same steer goes out as a waypoint on
	-- the corpse cluster plus a system message.
	self:giveWaypoint(pPlayer, self.cluster.waypointName, "A virus?", self.cluster.x, self.cluster.y)
	CreatureObject(pPlayer):sendSystemMessage("You've come across a container full of some hazardous fluid that has leaked out of it. Maybe the corpses near it holds a clue to what has happened here.")
end

-- .qst _1 tasks 1 and 2 completing, each firing its own Encounter (tasks 5 and 4).
-- Task 3 waits for both before task 13's box fires.
function symbiosisScreenPlay:examineCorpse(pPlayer, pCorpse, role)
	if (self:getStage(pPlayer) ~= 1 or self:isExamined(pPlayer, role)) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, role, "1")

	self:spawnParasites(pPlayer, self.burstEncounter)

	if (not (self:isExamined(pPlayer, "corpse1") and self:isExamined(pPlayer, "corpse2"))) then
		return
	end

	-- .qst _1 task 13: Show Message Box "Dangerous indeed".
	self:setStage(pPlayer, 2)
	self:removeWaypoint(pPlayer)

	self:showMessageBox(pPlayer, pCorpse, "Dangerous indeed",
		"Those two creatures burst out of the corpse as you were examining it! You should take the test tubes and throw them in the lava before a plague infests the entire planet!")
end

-- .qst _1 task 6 completing, which fires task 14: Show Message Box
-- "Stop the plague." and then the Go to Location.
function symbiosisScreenPlay:grabContainer(pPlayer, pContainer)
	if (self:getStage(pPlayer) ~= 2) then
		return
	end

	self:setStage(pPlayer, 3)

	self:showMessageBox(pPlayer, pContainer, "Stop the plague.",
		"You very carefully pick up the test tubes from the bag, making sure not to come in to contact with the goo from the broken one. Take the tubes over to the lava and throw them in.")

	self:giveWaypoint(pPlayer, self.lava.waypointName, "Stop the plague", self.lava.x, self.lava.y)
end

-- .qst _1 task 15 completing, which fires task 12: Show Message Box
-- "Dangerous indeed" (the lava-throw copy of that title).
function symbiosisScreenPlay:notifyEnteredLava(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (SceneObject(pArea):getObjectID() ~= self.lavaAreaID or self:getStage(pPlayer) ~= 3) then
		return 0
	end

	self:setStage(pPlayer, 4)

	self:showMessageBox(pPlayer, nil, "Dangerous indeed",
		"You throw the doomsday tubes in to the lava and watch as they sizzle, melt and disappear in to the hot liquid. Go back and search around the area to see if you can find any more clues to what happened and to make sure there's no more.")

	-- .qst _1 task 7 carries createWaypoint true, waypointName "Corpses".
	self:giveWaypoint(pPlayer, self.cluster.waypointName, "Looking for clues", self.cluster.x, self.cluster.y)

	return 0
end

-- .qst _1 task 7 completing, which fires task 8 then task 11 then the Reward.
function symbiosisScreenPlay:examineFinalCorpse(pPlayer, pCorpse)
	if (self:getStage(pPlayer) ~= 4) then
		return
	end

	self:setStage(pPlayer, 5)
	self:removeWaypoint(pPlayer)

	self:showMessageBox(pPlayer, pCorpse, "Clues",
		"On the corpse of this Treasure Hunter you find a holo recording where he talks about how they came across the test tubes. He explains that they found them inside a crashed escape pod. As well as the tubes they found one of the little monsters (which they dispatched of) and a datapad that seemed to be a mission briefing. In the mission briefing someone was given the order to spread the fluid on Mustafar in the new mining facility. The briefing was just signed X. Maybe someone is planning a hostile take over of the mining resources on Mustafar?")

	self:showMessageBox(pPlayer, nil, "All you can do",
		"Inside the treasure hunter's jacket you also find a strange sword, wrapped up in cloth. You decide that you've done what you can here and are content with having destroyed the test tubes to avoid these parasites spreading any further.")

	self:awardQuest(pPlayer)
end

-- .qst _1 task 9 (Reward) and task 10 (Immediately Complete Quest,
-- musicOnComplete sound/mus_mustafar_quest_success.snd,
-- grantQuestOnComplete som_kenobi_symbiosis_2).
function symbiosisScreenPlay:awardQuest(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("symbiosisScreenPlay: player has no inventory; the sword could not be handed over")
	elseif (giveItem(pInventory, self.rewardWeapon, -1, true) == nil) then
		print("symbiosisScreenPlay: failed to create " .. self.rewardWeapon)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for the sword wrapped in cloth.")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have taken the sword wrapped in cloth.")
	end

	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_symbiosis_1")

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")

	-- symbiosis_2 starts here: .qst _2 task 0, Timer Min 5 / Max 8.
	createEvent(getRandomNumber(self.ambush.delayMin, self.ambush.delayMax) * 1000, "symbiosisScreenPlay", "springAmbush", pPlayer, "")
end

--[[ symbiosis_2 ]]

-- .qst _2 task 1, Encounter: som_kenobi_alien_parasite, Count 6,
-- Min Distance 10, Max Distance 20. The .qst shows no message box for it -- the
-- ambush is meant to be a surprise.
function symbiosisScreenPlay:springAmbush(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 5) then
		return
	end

	self:spawnParasites(pPlayer, self.ambush)

	-- .qst _2 task 3, Timer Min 20 / Max 20, then task 2 Immediately Clear Quest.
	-- Clearing only ends the quest; the parasites already spawned stay up.
	createEvent(self.ambush.clearAfter * 1000, "symbiosisScreenPlay", "clearAmbush", pPlayer, "")
end

function symbiosisScreenPlay:clearAmbush(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 5) then
		return
	end

	self:setStage(pPlayer, 6)
end

--[[ Shared spawning ]]

function symbiosisScreenPlay:spawnParasites(pPlayer, encounter)
	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()

	for i = 1, encounter.count do
		local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, encounter.minDistance, encounter.maxDistance, true)

		if (spawnPoint == nil) then
			print("symbiosisScreenPlay: no spawn point near the player for " .. self.parasite)
			return
		end

		local pParasite = spawnMobile("mustafar", self.parasite, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

		if (pParasite == nil) then
			print("symbiosisScreenPlay: failed to spawn " .. self.parasite)
			return
		end

		AiAgent(pParasite):setDefender(pPlayer)
	end
end

--[[ Radial dispatch

One component table serves the container and all three corpses.
SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely -- so
fillObjectMenuResponse has to add every item we want to see, and adds nothing at
all when this player has no business touching the object.
--]]

SymbiosisMenuComponent = {}

function SymbiosisMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":symbiosisRole")
	local text = symbiosisScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function SymbiosisMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":symbiosisRole")
	local stage = symbiosisScreenPlay:getStage(pPlayer)

	if (role == "container") then
		if (stage == 0) then
			symbiosisScreenPlay:examineContainer(pPlayer, pSceneObject)
		else
			symbiosisScreenPlay:grabContainer(pPlayer, pSceneObject)
		end
	elseif (role == "corpse1" or role == "corpse2") then
		symbiosisScreenPlay:examineCorpse(pPlayer, pSceneObject, role)
	elseif (role == "corpse3") then
		symbiosisScreenPlay:examineFinalCorpse(pPlayer, pSceneObject)
	end

	return 0
end
