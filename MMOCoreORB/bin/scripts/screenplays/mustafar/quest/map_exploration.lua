--[[
INFO:

Exploration of Mustafar

Reward
Quest XP: 31930
Credits: 10,000
Map of Mustafar
Difficulty
Recommended combat levels: 70 and higher

You receive this quest by right clicking on map console at starport entrance. then you have to travel to 6 different regions of the planet to complete, and at some of them you will have to kill some of the local animals to see what their combat skills are will fill in more as i go.
Tulrus Isle

Travel to (/wp 1920 -525) and kill 5 Tulrus, they are around (CL78+)
Berken's Flow

Travel to (/wp 1055 2466) and kill 5 of any Xandank, they are around (CL75+)
Central Volcano

Travel to (/wp 44 1367) then examine the Crash Site at (/wp 100 555)
Burning Plain

Travel to (/wp -1177 2038) and kill 5 Kubaza Beetles, they are around (CL70+)
If you can't find any at the above location check out either (/wp -1075 2352) or (/wp 88 1633)
Smoking Forest

Travel to the bridge at (/wp -2200 -247) and kill 5 Blistmoks. The bridge connects northern part of Crystal Flats to Smoking Forest.
Crystal Flats

Travel to (/wp -1159 -2911) and kill 5 Lava Fleas, they are around (CL80+)

/wp 1920 -525 Tulrus Isle;
/wp 1055 2466 Berkens Flow;
/wp 44 1367 Central Volcano;
/wp 95 555 Crash Site;
/wp -1177 2038 Burning Plains;
/wp -2195 -355 Smoking Forest;
/wp -1159 -2911 Crystal Flats;


SOURCE OF RECORD

Everything below now comes from the shipped quest definition rather than from the
player guide quoted above. `quest/som_mustafar_exploration.qst` in the client TREs
(mtg_patch_017.tre) is the SOE-authored quest, XML, with the six travel legs, their
exact world coordinates, the 25 m arrival radius, the five hunt legs and their
counts, and the reward. Coordinates below are quoted from it verbatim; the guide
waypoints are kept only as comments showing how close each one was.

The .qst stores positions as LocationX / LocationY / LocationZ where LocationY is
the height, so each one maps onto Core3's (x, z, y) argument order as
x = LocationX, z = LocationY, y = LocationZ.

An earlier revision of this file anchored several objectives on spawn regions
instead of the guide waypoints, on the theory that the guide was unreliable. The
quest file shows the guide was in fact accurate to a few tens of metres and those
overrides moved four objectives off-target -- Berken's Flow by 1.9 km and the
Burning Plain by 1.2 km. The .qst coordinates supersede both.

Travel is area-gated (the player must physically reach the location). The kill
counter for an objective only starts once its travel leg is done, and then counts
that creature anywhere on Mustafar. The .qst matches kills by Social Group
("tulrus", "xandank", "lava_beetle", "blistmok", "lava_flea"), but the ported
SOM creature templates in this tree all carry socialGroup "townsperson" or "",
so the group is not usable as a discriminator here. Each objective therefore
lists every wild template belonging to that group, which is the same set the
social group would have selected. Tamed pets (trained_blistmok) are left out.

PROGRESS TRACKING

This quest has no row in datatables/player/quests.iff. The table the server
actually loads is the one in stardust_03.tre (it wins the TreFiles order in
conf/config.lua); it holds 307 rows, of which the only Mustafar entries are the
45 exploration-marker quests at indices 188-232 used by mining_field_markers.lua.
There is no som_mustafar_exploration row in it, nor in the mtg_patch_023 or
mtg_patch_013 copies. Progress is therefore held in persistent screenplay data
rather than in journal bits -- the player gets waypoints and system messages but
no journal entry, which is the most this can do without adding a TRE.
--]]

exploreMustafarScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "exploreMustafarScreenPlay",

	-- Reward task 19 of the .qst: Bank Credits 10000, lootName
	-- item_tow_painting_02_01 x1, Experience Amount 0, no badge, Faction Amount 0.
	-- The guide above quotes "Quest XP: 31930"; the shipped reward task carries no
	-- experience at all, so nothing is awarded here rather than inventing a type.
	-- CORRECTION: the stored 0 was never what live paid. SOE recomputed from
	-- quest_experience[60][TIER_2] = 35123 (see mustafar_quest_xp.lua). The guide's
	-- 31930 matches neither 35123 nor any cell of the table -- same publish-drift
	-- shape as the Skull of the Jundak walkthrough figure.
	rewardCredits = 10000,
	-- item_tow_painting_02_01 is a Trials of Obi-Wan loot item that was never
	-- ported into this tree (no template, no loot entry). The damaged map is the
	-- SOM item that is present and is what the guide calls the reward, so it
	-- stands in until the painting exists.
	rewardItem = "object/tangible/item/som/mustafar_damaged_map.iff",
	minimumLevel = 70,

	-- QUOTED, som_mining_facility.tab: object/tangible/item/som/mustafar_damaged_map.iff
	-- in landing_deck_room at loc_x -48.9 / loc_y 31 / loc_z -112.9, yaw 180. Under the
	-- axis mapping that is x -48.9, z 31 (height), y -112.9, heading 180. An earlier
	-- revision carried -113 and heading 0 from the SD1 port; both are corrected here
	-- against the shipped row.
	mapConsole = {
		template = "object/tangible/item/som/mustafar_damaged_map.iff",
		x = -48.9, z = 31, y = -112.9, cell = 12112248, heading = 180,
	},

	-- Old Republic Cruiser Crash Site. Task 21 of the .qst, "Examine the Crash
	-- Site".
	--
	-- The terminals are NOT spawned here. snapshot/mustafar.ws (stardust_03.tre,
	-- which wins the TreFiles order) already places two of them, and
	-- PlanetManagerImplementation::loadSnapshotObject() instantiates every
	-- snapshot node with objectID == the node ID, so getSceneObject(nodeID)
	-- returns the very object the client is already drawing. Spawning our own
	-- would put a second, unbacked terminal in the world.
	--
	-- The load order that makes this safe: ZoneServerImplementation::start()
	-- runs startGroundZones() -- which blocks on hasManagersStarted(), and
	-- PlanetManager::initialize() calls loadSnapshotObjects() -- strictly before
	-- startManagers() reaches startGlobalScreenPlays(). Snapshot objects exist by
	-- the time any screenplay :start() runs.
	--
	-- The .qst quotes the task location as (-2747, 234, 3534), which is ~280 m
	-- north of the wreck and 90 m above it; that is an approach hint, not the
	-- prop. The debris field itself (must_crashed_republic_ship* nodes 12112169
	-- -12112205) runs from z 3008 to z 3288, and the two terminals sit at its
	-- north end. The waypoint uses the terminal the player actually clicks.
	crashSite = {
		x = -2668.84, z = 145.20, y = 3263.38,
		nodeIDs = { 12111401, 12112127 },
	},

	-- Radius(m) is 25 on every "Go to Location" task in the .qst.
	arrivalRadius = 25,

	-- Listed in the play order the .qst names them (mustafar_exploration_one is
	-- the Crystal Flats, _six is Tulrus Isle). They are parallel tasks, so the
	-- order is presentation only.
	objectives = {
		{
			key = "crystal_flats",
			name = "the Crystal Flats",
			-- .qst task 13 mustafar_exploration_one. Guide /wp -1159 -2911 -> (-4039, 65), 33m off.
			x = -4070, z = 80, y = 76,
			killTarget = 5,
			killName = "Lava Flea",
			-- Social Group "lava_flea".
			killTemplates = { ["lava_flea"] = true, ["lava_flea_smoldering"] = true },
		},
		{
			key = "smoking_forest",
			name = "the Smoking Forest",
			-- .qst task 12 mustafar_exploration_two. Guide /wp -2200 -247 -> (-5080, 2729), 3m off.
			x = -5083, z = 8, y = 2730,
			killTarget = 5,
			killName = "Blistmok",
			-- Social Group "blistmok". trained_blistmok is a pet and is excluded.
			killTemplates = { ["blistmok"] = true, ["blistmok_shrieker"] = true, ["blistmok_trampler"] = true },
		},
		{
			key = "burning_plain",
			name = "the Burning Plain",
			-- .qst task 11 mustafar_exploration_three. Guide /wp -1177 2038 -> (-4057, 5014), 19m off.
			x = -4040, z = 11, y = 5022,
			killTarget = 5,
			killName = "Kubaza Beetle",
			-- Social Group "lava_beetle" -- the kubaza beetle is the lava beetle.
			killTemplates = { ["kubaza_beetle"] = true, ["kubaza_soldier_beetle"] = true, ["kubaza_worker_beetle"] = true },
		},
		{
			key = "central_volcano",
			name = "the Central Volcano",
			-- .qst task 10 mustafar_exploration_four. Guide /wp 44 1367 -> (-2836, 4343), 20m off.
			-- No hunt leg; the crash site hangs off this one as task 21.
			x = -2855, z = 61, y = 4335,
			killTarget = 0,
		},
		{
			key = "berkens_flow",
			name = "Berken's Flow",
			-- .qst task 9 mustafar_exploration_five. Guide /wp 1055 2466 -> (-1825, 5442), 24m off.
			x = -1805, z = 8, y = 5455,
			killTarget = 5,
			killName = "Xandank",
			-- Social Group "xandank".
			killTemplates = { ["xandank"] = true, ["xandank_onyx_plated"] = true, ["xandank_patriarch"] = true, ["orf_xandank"] = true },
		},
		{
			key = "tulrus_isle",
			name = "Tulrus Isle",
			-- .qst task 8 mustafar_exploration_six. Guide /wp 1920 -525 -> (-960, 2451), 3m off.
			x = -962, z = 9, y = 2448,
			killTarget = 5,
			killName = "Tulrus",
			-- Social Group "tulrus".
			killTemplates = { ["tulrus"] = true, ["tulrus_magma_drenched"] = true, ["orf_tulrus"] = true },
		},
	},

	areaByObjectID = {},
}

registerScreenPlay("exploreMustafarScreenPlay", true)

function exploreMustafarScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnObjects()
		self:spawnAreas()
	end
end

function exploreMustafarScreenPlay:spawnObjects()
	local console = self.mapConsole
	-- spawnSceneObject takes RADIANS -- DirectorManager's spawnSceneObject passes the
	-- angle straight through, while spawnMobile deg2rads it first. Every heading in
	-- this tree is stored in degrees, as the live tables write it, so it converts here.
	local pMap = spawnSceneObject("mustafar", console.template, console.x, console.z, console.y, console.cell, math.rad(console.heading))

	if (pMap == nil) then
		print("exploreMustafarScreenPlay: failed to spawn the map console")
	else
		createObserver(OBJECTRADIALUSED, "exploreMustafarScreenPlay", "mapUsed", pMap)
	end

	-- Attach to the terminals the world snapshot already placed rather than
	-- spawning duplicates. Both are wired, since either one is a reasonable
	-- thing for the player to walk up to.
	local attached = 0

	for i = 1, #self.crashSite.nodeIDs do
		local nodeID = self.crashSite.nodeIDs[i]
		local pCrash = getSceneObject(nodeID)

		if (pCrash == nil) then
			print("exploreMustafarScreenPlay: crash site terminal " .. nodeID .. " is not in the world snapshot")
		else
			createObserver(OBJECTRADIALUSED, "exploreMustafarScreenPlay", "crashSiteUsed", pCrash)
			attached = attached + 1
		end
	end

	if (attached == 0) then
		print("exploreMustafarScreenPlay: no crash site terminal could be found; the quest cannot be completed")
	end
end

function exploreMustafarScreenPlay:spawnAreas()
	self.areaByObjectID = {}

	for i = 1, #self.objectives do
		local objective = self.objectives[i]
		local pArea = spawnActiveArea("mustafar", "object/active_area.iff", objective.x, objective.z, objective.y, self.arrivalRadius, 0)

		if (pArea == nil) then
			print("exploreMustafarScreenPlay: failed to spawn the area for " .. objective.key)
		else
			self.areaByObjectID[SceneObject(pArea):getObjectID()] = objective
			createObserver(ENTEREDAREA, "exploreMustafarScreenPlay", "notifyEnteredArea", pArea)
		end
	end
end

--[[ State

All of it lives in persistent screenplay data on the player's ghost, so a
character keeps their progress across a restart. readScreenPlayData returns ""
for a key that was never written, and tonumber("") is nil, hence the "or 0".

	state          0 not offered / 1 accepted / 2 finished
	reached_<key>  1 once the player has stood inside that objective's area
	kills_<key>    running count for that objective
	done_<key>     1 once the objective is fully charted
	crash_site     1 once the wreck has been examined
	wp_<key>       object id of the waypoint handed out for that objective
--]]

function exploreMustafarScreenPlay:getObjective(key)
	for i = 1, #self.objectives do
		if (self.objectives[i].key == key) then
			return self.objectives[i]
		end
	end

	return nil
end

function exploreMustafarScreenPlay:getState(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "state")) or 0
end

function exploreMustafarScreenPlay:setState(pPlayer, state)
	writeScreenPlayData(pPlayer, self.screenplayName, "state", tostring(state))
end

function exploreMustafarScreenPlay:isQuestActive(pPlayer)
	return self:getState(pPlayer) == 1
end

function exploreMustafarScreenPlay:isQuestComplete(pPlayer)
	return self:getState(pPlayer) == 2
end

function exploreMustafarScreenPlay:hasReachedArea(pPlayer, objective)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "reached_" .. objective.key)) == 1
end

function exploreMustafarScreenPlay:isObjectiveDone(pPlayer, objective)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. objective.key)) == 1
end

function exploreMustafarScreenPlay:hasExaminedCrashSite(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crash_site")) == 1
end

function exploreMustafarScreenPlay:getKillCount(pPlayer, objective)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills_" .. objective.key)) or 0
end

--[[ Quest start ]]

function exploreMustafarScreenPlay:mapUsed(pMap, pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:isQuestComplete(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("You have already charted Mustafar.")
		return 0
	end

	if (self:isQuestActive(pPlayer)) then
		self:reportProgress(pPlayer)
		return 0
	end

	if (CreatureObject(pPlayer):getLevel() < self.minimumLevel) then
		CreatureObject(pPlayer):sendSystemMessage("The survey work this map calls for is meant for someone of at least combat level " .. self.minimumLevel .. ".")
		return 0
	end

	self:setState(pPlayer, 1)

	self:addObjectiveWaypoints(pPlayer)

	-- Persistence 1 (createObserver's optional 5th argument, DirectorManager.cpp)
	-- so the observer object is saved with the player. Without it the observer is
	-- created non-persistent and the kill counts silently stop being credited after
	-- the player logs out and back in mid-quest.
	createObserver(KILLEDCREATURE, "exploreMustafarScreenPlay", "notifyKilledCreature", pPlayer, 1)

	CreatureObject(pPlayer):sendSystemMessage("The map is badly damaged, but enough of it survives to work from. Six regions are still legible.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_accepted.snd")

	self:reportProgress(pPlayer)

	return 0
end

function exploreMustafarScreenPlay:addObjectiveWaypoints(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	for i = 1, #self.objectives do
		local objective = self.objectives[i]

		if (not self:isObjectiveDone(pPlayer, objective)) then
			local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", objective.name, "Exploration of Mustafar", objective.x, 0, objective.y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
			writeScreenPlayData(pPlayer, self.screenplayName, "wp_" .. objective.key, tostring(waypointID))
		end
	end
end

function exploreMustafarScreenPlay:removeObjectiveWaypoint(pPlayer, key)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)) or 0

	if (waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)
end

--[[ Travel ]]

function exploreMustafarScreenPlay:notifyEnteredArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local objective = self.areaByObjectID[SceneObject(pArea):getObjectID()]

	if (objective == nil or not self:isQuestActive(pPlayer)) then
		return 0
	end

	if (self:hasReachedArea(pPlayer, objective)) then
		return 0
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "reached_" .. objective.key, "1")

	if (objective.killTarget == 0) then
		self:completeObjective(pPlayer, objective)
	else
		CreatureObject(pPlayer):sendSystemMessage("You have reached " .. objective.name .. ". Record the fighting habits of the local " .. objective.killName .. "s: 0 of " .. objective.killTarget .. ".")
		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
	end

	return 0
end

--[[ Kill counting ]]

function exploreMustafarScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (not self:isQuestActive(pPlayer)) then
		-- The quest is over; stop listening on this player.
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil) then
		return 0
	end

	for i = 1, #self.objectives do
		local objective = self.objectives[i]

		if (objective.killTarget > 0 and objective.killTemplates[victimTemplate] ~= nil
			and self:hasReachedArea(pPlayer, objective)
			and not self:isObjectiveDone(pPlayer, objective)) then

			local killed = self:getKillCount(pPlayer, objective) + 1
			writeScreenPlayData(pPlayer, self.screenplayName, "kills_" .. objective.key, tostring(killed))

			if (killed >= objective.killTarget) then
				self:completeObjective(pPlayer, objective)
			else
				CreatureObject(pPlayer):sendSystemMessage(objective.killName .. "s recorded at " .. objective.name .. ": " .. killed .. " of " .. objective.killTarget .. ".")
				CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
			end

			return 0
		end
	end

	return 0
end

--[[ Crash site ]]

function exploreMustafarScreenPlay:crashSiteUsed(pTerminal, pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (not self:isQuestActive(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("The wreck is picked clean. Nothing here means anything to you.")
		return 0
	end

	if (self:hasExaminedCrashSite(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("You have already examined the crash site.")
		return 0
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "crash_site", "1")

	self:removeObjectiveWaypoint(pPlayer, "crash_site")

	CreatureObject(pPlayer):sendSystemMessage("An Old Republic cruiser, down long enough for the lava to have taken most of it. You mark the wreck on the map.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:checkCompletion(pPlayer)

	return 0
end

--[[ Completion ]]

function exploreMustafarScreenPlay:completeObjective(pPlayer, objective)
	writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. objective.key, "1")

	self:removeObjectiveWaypoint(pPlayer, objective.key)

	CreatureObject(pPlayer):sendSystemMessage(objective.name .. " has been charted.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_completed.snd")

	-- Task 21 of the .qst hangs the crash site off the Central Volcano leg, so
	-- the wreck is only pointed out once the volcano itself has been charted.
	if (objective.key == "central_volcano" and not self:hasExaminedCrashSite(pPlayer)) then
		local pGhost = CreatureObject(pPlayer):getPlayerObject()

		if (pGhost ~= nil) then
			local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", "Crash Site", "Exploration of Mustafar", self.crashSite.x, 0, self.crashSite.y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
			writeScreenPlayData(pPlayer, self.screenplayName, "wp_crash_site", tostring(waypointID))
		end

		CreatureObject(pPlayer):sendSystemMessage("Something large came down south of the volcano. Examine the crash site.")
	end

	self:checkCompletion(pPlayer)
end

function exploreMustafarScreenPlay:checkCompletion(pPlayer)
	for i = 1, #self.objectives do
		if (not self:isObjectiveDone(pPlayer, self.objectives[i])) then
			return
		end
	end

	if (not self:hasExaminedCrashSite(pPlayer)) then
		return
	end

	self:awardQuest(pPlayer)
end

function exploreMustafarScreenPlay:awardQuest(pPlayer)
	self:setState(pPlayer, 2)

	self:removeObjectiveWaypoint(pPlayer, "crash_site")

	for i = 1, #self.objectives do
		deleteScreenPlayData(pPlayer, self.screenplayName, "reached_" .. self.objectives[i].key)
		deleteScreenPlayData(pPlayer, self.screenplayName, "kills_" .. self.objectives[i].key)
	end

	dropObserver(KILLEDCREATURE, "exploreMustafarScreenPlay", "notifyKilledCreature", pPlayer)

	-- The .qst reward task carries Experience Amount 0, so credits and the item
	-- are the whole of it. CORRECTION: the stored 0 was never what live paid.
	-- Award is quest_experience[60][TIER_2] = 35123; see mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_mustafar_exploration")
	CreatureObject(pPlayer):addCashCredits(self.rewardCredits, true)

	-- Same discarded-return defect as mining_field_markers.lua had: the full-pack check
	-- does not cover createObject or transferObject failing, and giveItem returns nil for
	-- both (DirectorManager.cpp:2461-2479). Unlike that file there is no flag to unwind --
	-- setState(pPlayer, 2) above IS the completion and re-awarding is not wanted -- so the
	-- correct shape here is report-and-continue, not retry.
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("exploreMustafarScreenPlay: player has no inventory; the redrawn map could not be handed over")
	elseif (SceneObject(pInventory):isContainerFullRecursive() or giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		CreatureObject(pPlayer):sendSystemMessage("Your inventory is full. The redrawn map could not be given to you.")
	end

	CreatureObject(pPlayer):sendSystemMessage("Mustafar is charted. The map is whole again.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_completed.snd")
end

--[[ Progress readout ]]

function exploreMustafarScreenPlay:reportProgress(pPlayer)
	for i = 1, #self.objectives do
		local objective = self.objectives[i]

		if (self:isObjectiveDone(pPlayer, objective)) then
			CreatureObject(pPlayer):sendSystemMessage(objective.name .. ": charted.")
		elseif (not self:hasReachedArea(pPlayer, objective)) then
			CreatureObject(pPlayer):sendSystemMessage(objective.name .. ": not yet reached.")
		elseif (objective.killTarget > 0) then
			CreatureObject(pPlayer):sendSystemMessage(objective.name .. ": " .. objective.killName .. "s recorded " .. self:getKillCount(pPlayer, objective) .. " of " .. objective.killTarget .. ".")
		end
	end

	if (self:hasExaminedCrashSite(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("Crash Site: examined.")
	elseif (self:isObjectiveDone(pPlayer, self:getObjective("central_volcano"))) then
		CreatureObject(pPlayer):sendSystemMessage("Crash Site: not yet examined.")
	end
end
