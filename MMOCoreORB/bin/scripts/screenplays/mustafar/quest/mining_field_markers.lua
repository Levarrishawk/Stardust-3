--[[
	The Mining Field Markers -- Surveyor Jo Keslev, Mensix Mining Facility

	Live NGE reference (transcribed from the SWG wiki article; flavor text below is the
	verbatim "tidbit" each marker printed when activated):

	  Start:   Surveyor Jo Keslev, /wp 313 -1267, inside the Mensix Mining Facility.
	  Rewards: 290 quest XP + 5000 credits per completed area set,
	           Master Mustafar Trailblazer badge,
	           Tanray Heart Crystal once every area has been completed.
	  Level:   recommended CL75+ (the markers are not guarded, but the travel between
	           them crosses high-CL world spawns).
	  Areas:   Berken's Flow (5), Burning Plains (5), Central Volcano (3),
	           Crystal Flats (5), Mining Field (5), Smoking Forest (5),
	           Tulrus Nesting Grounds (3) -- 31 markers total.

	COORDINATE FRAME
	  The /way values quoted in the wiki are in the client waypoint frame, which is offset
	  from the server world frame by a constant translation:

	      world_x = way_x - 2880        world_y = way_y + 2976

	  Every marker below satisfies that relation against its quoted /way to within ~1m, and
	  the transform is independently corroborated by mustafar_regions.lua (produced by the
	  World Spawner Tool against the terrain):

	      Jedi Ruins    /way 2959 996   -> (79, 3972)    vs storm_lord_ruins      (193, 4163) r500
	      N Jedi Ruins  /way -2572 3220 -> (-5452, 6196) vs nw_jedi_ruins        (-5424, 6028) r200
	      S Jedi Ruins  /way -1404 400  -> (-4284, 3376) vs blackguard_jedi_ruins (-4373, 3255) r200

	  Keep the /way in each entry's comment: it is the check value for the world coordinate.

	Final conversation:
	  "Hello again. my friend. You certainly have done a wonderful job and saved me all sorts
	   of trouble trying to check all of those markers out. And as promised, here is your
	   Tanray Heart Crystal. Thank you again."
--]]

local QuestManager = require("managers.quest.quest_manager")
local ObjectManager = require("managers.object.object_manager")

miningFieldMarkersScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "miningFieldMarkersScreenPlay",

	queststring = "miningfieldmarkerscreenplay",

	-- Paid by Jo Keslev per completed area set (NGE: "five thousand credits per area
	-- searched", 290 quest XP).
	areaCreditReward = 5000,
	areaXpReward = 290,

	-- NGE's completion reward is exactly two things: the Tanray Heart Crystal and the
	-- Master Mustafar Trailblazer badge. NEITHER can be granted from this tree as it stands:
	--
	--   * There is no Tanray Heart Crystal template. Grepping "tanray" across object/ returns
	--     only object/mobile/skeleton/tanray, the beast/pet intangibles and the beast draft
	--     schematics -- no tangible item, client-side or server-side. Authoring an IFF for it
	--     would put an object in this repo that no stock client has, which breaks the client
	--     for everyone who is not running our TREs. So it stays unwired: set completionItem
	--     to the real template path if one turns up in a fuller TRE set and the reward hands
	--     it over with no other change.
	--   * Badges have no screenplay-side API here -- only the grantBadge/revokeBadge admin
	--     commands -- so the Trailblazer badge cannot be awarded from Lua at all.
	--
	-- The stock dialog line on finished_all still promises the crystal; that is client text
	-- and is left alone. The seven area payouts (35,000 credits, 2,030 xp) are the part of
	-- the NGE reward this tree can actually deliver.
	completionItem = nil,

	-- Ordered list of the seven marker areas. Each area carries:
	--   key        internal id, also the conversation option key in jo_kelsev_conv_handler
	--   name       display name used in system messages
	--   setQuest   quest handed out by Jo Keslev when the player picks the area
	--   doneQuest  quest activated once every marker in the area has been touched;
	--              turning it in to Jo Keslev pays the 5000cr / 290xp
	--   markers    the marker objects, in NGE listing order
	markerAreas = {
		{
			key = "berkens_flow",
			name = "Berken's Flow",
			setQuest = "SOM_BERKENS_FLOW_MARKERS",
			doneQuest = "SOM_BERKENS_FLOW",
			waypointX = -244, waypointY = 3679,
			markers = {
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_01",
					object = "object/tangible/quest/som_berken_marker_01.iff",
					name = "Berken's Flow Marker",
					x = -507.47, z = 58, y = 3681.4, -- /way 2373 706
					tidbit = "Named after the famed Mustafarian Jesl Berken, Berken's Flow was once the richest source of raw materials in the known galaxy. The wealth of Mustafar all started with the discovery of Berken's Flow. Today, most of its minerals extracted, Berken's Flow is used only for the smallest of mining operations.",
				},
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_02",
					object = "object/tangible/quest/som_berken_marker_02.iff",
					name = "Tulrus Isle Bridge Marker",
					x = -574.82, z = 61.786, y = 2491.94, -- /way 2305 -486
					tidbit = "The Klegger Corp. bridge connects Berken's Flow to the Tulrus Nesting Grounds. Due to the highly dangerous nature of the nesting grounds and their relative lack of resources, this bridge is hardly ever used.",
				},
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_03",
					object = "object/tangible/quest/som_berken_marker_03.iff",
					name = "Droid Factory Marker",
					x = 392.49, z = 45.1373, y = 2220.11, -- /way 3272 -758
					tidbit = "Built by the separatists shortly before they were found slain in the old Klegger Mining Facility at the end of the Clone Wars. No mining crews who have entered this factory have ever come back.",
				},
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_04",
					object = "object/tangible/quest/som_berken_marker_04.iff",
					name = "Jedi Ruins Marker",
					x = 79.3501, z = 128.963, y = 3971.21, -- /way 2959 996
					tidbit = "WARNING: The party of archeologists who were examining these ruins formed themselves into some sort of dangerous cult. They worship a man they call the Storm Lord and will attack anyone who does not accept him as a god.",
				},
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_05",
					object = "object/tangible/quest/som_berken_marker_05.iff",
					name = "Old Republic Facility Marker",
					x = -610.59, z = 87.1491, y = 6031.32, -- /way 2269 3056
					tidbit = "WARNING: Sealed by the order of Milo Mensix. This ancient facility, dating back to the days of the Old Republic, is overrun with still active security droids and the occasional beast which gets trapped inside.",
				},
			},
		},
		{
			key = "burning_plains",
			name = "the Burning Plains",
			setQuest = "SOM_BURNING_PLAINS_MARKERS",
			doneQuest = "SOM_BURNING_PLAINS",
			waypointX = -3003, waypointY = 5412,
			markers = {
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_01",
					object = "object/tangible/quest/som_burning_marker_01.iff",
					name = "Berken's Flow Bridge Marker",
					x = -2155.66, z = 62.7735, y = 5511.92, -- /way 764 2536
					tidbit = "Another Klegger Corp. bridge that shows the wear of time on its steel frame. This bridge connects the Burning Plains to Berken's Flow.",
				},
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_02",
					object = "object/tangible/quest/som_burning_marker_02.iff",
					name = "Central Volcano Bridge Marker",
					x = -2776.59, z = 23.5186, y = 4593.53, -- /way 103 1618
					tidbit = "Another bridge built by the Klegger Corporation. This bridge leads to the second largest volcano in the region. Although a poor source of resources, the volcano is invaluable as a landmark on a ever-shifting world.",
				},
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_03",
					object = "object/tangible/quest/som_burning_marker_03.iff",
					name = "Central Burning Plains Marker",
					x = -2805.63, z = 122.179, y = 5131.71, -- /way 74 2156
					tidbit = "There are only a few points of high elevation in the Burning Plains. When the plains finally are swallowed by the lava, these areas will become important mining islands.",
				},
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_04",
					object = "object/tangible/quest/som_burning_marker_04.iff",
					name = "Temple Ruins Marker",
					x = -2789.93, z = 21.4531, y = 5921.04, -- /way 90 2945
					tidbit = "WARNING: These ruins are closed by the order of Milo Mensix. Everyone who spends any time in these ruins seems to lose their mind. Miners who have visited these ruins and returned have reported a very uneasy feeling, like they were being watched. The ruins themselves seem to be that of a great temple of unknown origin.",
				},
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_05",
					object = "object/tangible/quest/som_burning_marker_05.iff",
					name = "Northern Burning Plains Marker",
					x = -4490.58, z = 15.909, y = 5905.25, -- /way -1610 2930
					tidbit = "The surface crust of the Burning Plains is especially thin. This allows lava to nearly bubble through the surface. Most experts agree that, if the area suffers a big enough earthquake, the entire plain will become a sea of lava.",
				},
			},
		},
		{
			key = "central_volcano",
			name = "the Central Volcano",
			setQuest = "SOM_CENTRAL_VOLCANO_MARKERS",
			doneQuest = "SOM_CENTRAL_VOLCANO",
			waypointX = -3153, waypointY = 3578,
			markers = {
				{
					quest = "SOM_CENTRAL_VOLCANO_MARKERS_01",
					object = "object/tangible/quest/som_volcano_marker_01.iff",
					name = "Main Lava Flow Marker",
					x = -2974.96, z = 118.937, y = 4176.87, -- /way -95 1201
					tidbit = "The central volcano deposits close to 20,000 gallons of lava per second into the lava pools below. Unfortunately, this volcano's deposits are rather poor in usable resources. This is why the majority of the mining operations are in the higher grounds to the south.",
				},
				{
					quest = "SOM_CENTRAL_VOLCANO_MARKERS_02",
					object = "object/tangible/quest/som_volcano_marker_02.iff",
					name = "Kubaza Beetle Cavern Marker",
					x = -3703.1, z = 136.583, y = 3405.69, -- /way -823 430
					tidbit = "The cavern was originally built by the separatists during their excavation of the Old Republic cruiser. After they left, it became a hive for kubaza beetles, hence the name. WARNING: The cavern was closed by order of Milo Mensix after a field crew of miners was lost to the beetles while surveying the cavern.",
				},
				{
					quest = "SOM_CENTRAL_VOLCANO_MARKERS_03",
					object = "object/tangible/quest/som_volcano_marker_03.iff",
					name = "Old Republic Cruiser Crash Site Marker",
					x = -2783.21, z = 144.265, y = 3154.02, -- /way 97 179
					tidbit = "The remains of this cruiser were excavated during the Clone Wars by the separatists. After a brief period where they had sealed the area off, the separatists left the area and began work on their new factory. WARNING: Salvage Bandits have moved into this region and have begun dismantling the ship. They are highly dangerous and will kill on sight.",
				},
			},
		},
		{
			key = "crystal_flats",
			name = "the Crystal Flats",
			setQuest = "SOM_CRYSTAL_FLATS_MARKERS",
			doneQuest = "SOM_CRYSTAL_FLATS",
			waypointX = -4808, waypointY = 1381,
			markers = {
				{
					quest = "SOM_CRYSTAL_FLATS_MARKERS_01",
					object = "object/tangible/quest/som_crystal_marker_01.iff",
					name = "Crystal Fields Marker",
					x = -4018.92, z = 75.1095, y = 2432.66, -- /way -1139 -543
					tidbit = "Like most of Mustafar, the crystal fields were formed relatively quickly. The sudden shift of the moon's orbit is causing the world to tear itself apart. This has made many geologic formations, like the crystal fields, that normally take millions of years to form on other worlds to sprout up virtually over night.",
				},
				{
					quest = "SOM_CRYSTAL_FLATS_MARKERS_02",
					object = "object/tangible/quest/som_crystal_marker_02.iff",
					name = "Crystal Flats Bridge",
					x = -5207.46, z = 5.71105, y = 2506.45, -- /way -2329 -468
					tidbit = "Built by the Klegger Corporation when they were the dominant mining company on Mustafar, these bridges were originally formed out of steel, although you wouldn't know it by looking at them now. Years in the harsh environment have coated the bridges with volcanic ash and rock so that they now look like natural rock formations.",
				},
				{
					quest = "SOM_CRYSTAL_FLATS_MARKERS_03",
					object = "object/tangible/quest/som_crystal_marker_03.iff",
					name = "Crystal Falls Marker",
					x = -4650.37, z = 186.342, y = 1692.05, -- /way -1771 -1283
					tidbit = "The crystal falls are a rich source of crystalline ore. The area at the base of the falls is covered with rocks that have grown from the rich crystal minerals that flow out of these falls.",
				},
				{
					quest = "SOM_CRYSTAL_FLATS_MARKERS_04",
					object = "object/tangible/quest/som_crystal_marker_04.iff",
					name = "Salvage Bandit Camp",
					x = -5920.99, z = 86.3664, y = 102.05, -- /way -3041 -2873
					tidbit = "WARNING: Proceed at your own risk. This used to be a field miners' camp until it was overrun by salvage bandits. These Mustafarians belong to no company and will simply steal anything that isn't nailed down.",
				},
				{
					quest = "SOM_CRYSTAL_FLATS_MARKERS_05",
					object = "object/tangible/quest/som_crystal_marker_05.iff",
					name = "Crossroads",
					x = -4248.21, z = 73.8265, y = 177.7, -- /way -1369 -2797
					tidbit = "The crossroads is not really located at any sort of road. There are no true roads on Mustafar. The ever-shifting moon makes it impossible to maintain any sort of permanent road system. The name comes from what the locals call the strip where they leave the relative safety of the mining fields for the more wild parts of the planet.",
				},
			},
		},
		{
			key = "mining_field",
			name = "the mining facility",
			setQuest = "SOM_MINING_FIELD_MARKERS",
			doneQuest = "SOM_MINING_FIELD",
			waypointX = -1618, waypointY = 331,
			markers = {
				{
					quest = "SOM_MINING_FIELD_MARKERS_01",
					object = "object/tangible/quest/som_mining_marker_01.iff",
					name = "Mensix Mining Facility",
					x = -2949.52, z = 133.114, y = 1293.82, -- /way -66 -1681
					tidbit = "The Mensix Mining facility was built shortly after the destruction of the old mining facility. The new facility is nearly an exact replica of the old facility and most of its technology dates back to the days of the Old Republic.",
				},
				{
					quest = "SOM_MINING_FIELD_MARKERS_02",
					object = "object/tangible/quest/som_mining_marker_02.iff",
					name = "Destroyed Mining Facility",
					x = -2035.3, z = 151.1, y = 704.2, -- /way 842 -2273
					tidbit = "This facility was destroyed and abandoned shortly before the end of the Clone Wars. Salvage crews who investigated the facility after its destruction found the bodies of the separatist leaders, including Viceroy Gunray, murdered by a lightsaber.",
				},
				{
					quest = "SOM_MINING_FIELD_MARKERS_03",
					object = "object/tangible/quest/som_mining_marker_03.iff",
					name = "Chu-Gon Dar Ruins",
					x = -2542.81, z = 147.81, y = 58.28, -- /way 336 -2921
					tidbit = "These ruins date back well into the earliest days of the Old Republic. Some experts date them from before the time of the first Sith War. Certain experts believe that this ruin was the laboratory of the great Jedi Master Chu-Gon Dar, an expert at using the force to manipulate physical objects.",
				},
				{
					quest = "SOM_MINING_FIELD_MARKERS_04",
					object = "object/tangible/quest/som_mining_marker_04.iff",
					name = "Southern Lava Falls",
					x = -734.32, z = 103.559, y = -193.217, -- /way 2148 -3165
					tidbit = "Mustafar's wealth comes entirely from its natural resources. The lava brings up rare metals and ores to the surface, where they are easily collected by the miners.",
				},
				{
					quest = "SOM_MINING_FIELD_MARKERS_05",
					object = "object/tangible/quest/som_mining_marker_05.iff",
					name = "Koseyet Bridge",
					x = 168.49, z = 127.989, y = -205.708, -- /way 3045 -3186
					tidbit = "This natural land bridge connects the main mining fields to the Koseyet Mining Camp. The Koseyet mining camp sits on one of the richest mineral deposits on Mustafar and is heavily defended by the miners.",
				},
			},
		},
		{
			key = "smoking_forest",
			name = "the Smoking Forest",
			setQuest = "SOM_SMOKING_FOREST_MARKERS",
			doneQuest = "SOM_SMOKING_FOREST",
			waypointX = -5108, waypointY = 4632,
			markers = {
				{
					quest = "SOM_SMOKING_FOREST_MARKERS_01",
					object = "object/tangible/quest/som_smoking_marker_01.iff",
					name = "Southern Jedi Ruins Marker",
					x = -4284.06, z = 80.8645, y = 3375.31, -- /way -1404 400
					tidbit = "These ruins were uncovered roughly 18 years after the end of the Clone Wars. Mustafar simply shifted, and they were revealed. Offworlders have become very excited by the discovery of these ruins and others like them.",
				},
				{
					quest = "SOM_SMOKING_FOREST_MARKERS_02",
					object = "object/tangible/quest/som_smoking_marker_02.iff",
					name = "Field Miner Camp Marker",
					x = -5151.03, z = 180.804, y = 4243.6, -- /way -2271 1268
					tidbit = "Mines like those in the Smoking Forest are very rare on Mustafar because they actually involve digging into the lava rock to extract minerals. While much harder than lava mining, the mines in the Smoking Forest produce some very rich veins of raw materials.",
				},
				{
					quest = "SOM_SMOKING_FOREST_MARKERS_03",
					object = "object/tangible/quest/som_smoking_marker_03.iff",
					name = "Western Smoking Forest Marker",
					x = -6225.11, z = 41.474, y = 4388.46, -- /way -3345 1413
					tidbit = "The smoking forest was once thick with black smoke that was released by giant rock formations. Over time, the formations sealed off, and they eventually toppled down.",
				},
				{
					quest = "SOM_SMOKING_FOREST_MARKERS_04",
					object = "object/tangible/quest/som_smoking_marker_04.iff",
					name = "Burning Plains Bridge Marker",
					-- /way -1551 1985. The y was previously signed negative, which put this
					-- marker at (-4430.97, -4960.32) -- an empty stretch of the southern
					-- hemisphere with no bridge and no path to it, making the Smoking Forest
					-- set impossible to finish. x already matched the /way exactly.
					x = -4430.97, z = 44.4592, y = 4960.32,
					tidbit = "Like the rest of the bridges on Mustafar, this bridge was built by the Klegger Corporation long before the start of the Clone Wars to connect the Smoking Forest to the Burning Plains.",
				},
				{
					quest = "SOM_SMOKING_FOREST_MARKERS_05",
					object = "object/tangible/quest/som_smoking_marker_05.iff",
					name = "Northern Jedi Ruins Marker",
					x = -5453.01, z = 137.572, y = 6194.37, -- /way -2572 3220
					tidbit = "Like the other ruins located around Mustafar, this ruin appeared after a major earthquake. It's in remarkably good shape; our geologists place its age to be at least 5000 years old.",
				},
			},
		},
		{
			key = "nesting_grounds",
			name = "the Tulrus Nesting Grounds",
			setQuest = "SOM_NESTING_GROUNDS_MARKERS",
			doneQuest = "SOM_NESTING_GROUNDS",
			waypointX = -1809, waypointY = 3185,
			markers = {
				{
					quest = "SOM_NESTING_GROUNDS_MARKERS_01",
					object = "object/tangible/quest/som_tulrus_marker_01.iff",
					name = "Tulrus Nesting Grounds Entrance Marker",
					x = -1660.25, z = 74.0196, y = 2445.78, -- /way 1220 -530
					tidbit = "WARNING: Proceed past this point at your own risk. Tulrus are extremely protective of their breeding grounds and will attack any intruder on sight.",
				},
				{
					quest = "SOM_NESTING_GROUNDS_MARKERS_02",
					object = "object/tangible/quest/som_tulrus_marker_02.iff",
					name = "Tulrus Nesting Grounds Marker",
					x = -1797.86, z = 83.2939, y = 3038.4, -- /way 1082 63
					tidbit = "The nesting grounds are the traditional breeding grounds of the tulrus. The tulrus have successfully driven out most predators from their island in order to better protect their young. Only the jundak (and Sher Kar, of course) manage to survive on the island.",
				},
				{
					quest = "SOM_NESTING_GROUNDS_MARKERS_03",
					object = "object/tangible/quest/som_tulrus_marker_03.iff",
					name = "Sher Kar Cave Marker",
					x = -1971, z = 85.2697, y = 4073.65, -- /way 909 1098
					tidbit = "WARNING: Entering into the Sher Kar Cave is very foolish and will result in your death. By order of Milo Mensix, the cave has been sealed by a relic we located at the Jedi ruins.",
				},
			},
		},
	},

	-- Populated by spawnObjects(); maps a spawned marker's object id back to its
	-- table entry so a single observer callback can serve all 31 markers.
	markerByObjectID = {},
}

registerScreenPlay("miningFieldMarkersScreenPlay", true)

function miningFieldMarkersScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnMobiles()
		self:spawnObjects()
	end
end

function miningFieldMarkersScreenPlay:spawnMobiles()
	-- Surveyor Jo Keslev, inside the Mensix Mining Facility (/wp 313 -1267).
	spawnMobile("mustafar", "surveyor_jo", 1, 145.6, 18.6, -58.0, -50, 12112243)
end

function miningFieldMarkersScreenPlay:spawnObjects()
	self.markerByObjectID = {}

	for i = 1, #self.markerAreas do
		local area = self.markerAreas[i]

		for j = 1, #area.markers do
			local marker = area.markers[j]
			local pMarker = spawnSceneObject("mustafar", marker.object, marker.x, marker.z, marker.y, 0, 0)

			if (pMarker == nil) then
				print("miningFieldMarkersScreenPlay: failed to spawn " .. marker.object)
			else
				self.markerByObjectID[SceneObject(pMarker):getObjectID()] = { area = area, marker = marker }
				createObserver(OBJECTRADIALUSED, "miningFieldMarkersScreenPlay", "markerUsed", pMarker)
			end
		end
	end
end

-- Returns the area table whose setQuest the player currently has active, or nil.
function miningFieldMarkersScreenPlay:getActiveArea(pPlayer)
	for i = 1, #self.markerAreas do
		local area = self.markerAreas[i]

		if (QuestManager.hasActiveQuest(pPlayer, QuestManager.quests[area.setQuest])) then
			return area
		end
	end

	return nil
end

function miningFieldMarkersScreenPlay:hasCompletedArea(pPlayer, area)
	for i = 1, #area.markers do
		if (not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests[area.markers[i].quest])) then
			return false
		end
	end

	return true
end

-- True once every one of the seven area sets has been turned in.
function miningFieldMarkersScreenPlay:hasCompletedAllAreas(pPlayer)
	for i = 1, #self.markerAreas do
		if (not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests[self.markerAreas[i].doneQuest])) then
			return false
		end
	end

	return true
end

function miningFieldMarkersScreenPlay:getAreaByKey(key)
	for i = 1, #self.markerAreas do
		if (self.markerAreas[i].key == key) then
			return self.markerAreas[i]
		end
	end

	return nil
end

-- The area whose set is finished and waiting to be turned in to Jo Keslev, or nil.
function miningFieldMarkersScreenPlay:getAreaAwaitingTurnIn(pPlayer)
	for i = 1, #self.markerAreas do
		local area = self.markerAreas[i]

		if (QuestManager.hasActiveQuest(pPlayer, QuestManager.quests[area.doneQuest])
			and not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests[area.doneQuest])) then
			return area
		end
	end

	return nil
end

-- Areas the player has neither started nor finished, in NGE listing order.
function miningFieldMarkersScreenPlay:getRemainingAreas(pPlayer)
	local remaining = {}

	for i = 1, #self.markerAreas do
		local area = self.markerAreas[i]

		if (not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests[area.doneQuest])
			and not QuestManager.hasActiveQuest(pPlayer, QuestManager.quests[area.setQuest])) then
			remaining[#remaining + 1] = area
		end
	end

	return remaining
end

-- Jo Keslev only ever gives out general directions -- "due to the shifting of our moon's
-- surface, I cannot give you precise locations" -- so the player gets one waypoint at the
-- centroid of the area's markers, never a waypoint per marker.
function miningFieldMarkersScreenPlay:startArea(pPlayer, area)
	QuestManager.activateQuest(pPlayer, QuestManager.quests[area.setQuest])

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", area.name, "The Mining Field Markers", area.waypointX, 0, area.waypointY, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
		writeData(SceneObject(pPlayer):getObjectID() .. ":miningFieldMarkers:wp:" .. area.key, waypointID)
	end

	CreatureObject(pPlayer):sendSystemMessage("Find and activate every marker in " .. area.name .. ", then return to Surveyor Keslev.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_accepted.snd")
end

function miningFieldMarkersScreenPlay:turnInArea(pPlayer, area)
	QuestManager.completeQuest(pPlayer, QuestManager.quests[area.doneQuest])

	-- The search quest has to be closed as well. completeQuest clears the active bit only
	-- for the id it is handed, so leaving setQuest active leaves getActiveArea matching this
	-- finished area forever, which pins getInitialScreen on the option-less "in_progress"
	-- screen and makes welcome_back unreachable -- the remaining areas can never be started.
	QuestManager.completeQuest(pPlayer, QuestManager.quests[area.setQuest])

	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local playerID = SceneObject(pPlayer):getObjectID()

	if (pGhost ~= nil) then
		local waypointID = readData(playerID .. ":miningFieldMarkers:wp:" .. area.key)

		if (waypointID ~= 0) then
			PlayerObject(pGhost):removeWaypoint(waypointID, true)
			deleteData(playerID .. ":miningFieldMarkers:wp:" .. area.key)
		end
	end

	-- 290 quest XP + 5000 credits per area set. Live NGE awards "Quest XP"; Core3's
	-- experience table has no such type, so combat_general carries the value -- the same
	-- mapping map_exploration.lua makes.
	CreatureObject(pPlayer):awardExperience("combat_general", self.areaXpReward, true)
	CreatureObject(pPlayer):addCashCredits(self.areaCreditReward, true)

	CreatureObject(pPlayer):sendSystemMessage("Surveyor Keslev pays you " .. self.areaCreditReward .. " credits for surveying " .. area.name .. ".")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_completed.snd")
end

-- Fired when the player hails Jo Keslev with all seven sets paid off. runScreenHandlers runs
-- for the initial screen too, so this is guarded to fire once and only once per player.
function miningFieldMarkersScreenPlay:grantCompletionReward(pPlayer)
	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":miningFieldMarkers:rewarded") == 1) then
		return
	end

	writeData(playerID .. ":miningFieldMarkers:rewarded", 1)

	if (self.completionItem ~= nil) then
		local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

		if (pInventory ~= nil and not SceneObject(pInventory):isContainerFullRecursive()) then
			giveItem(pInventory, self.completionItem, -1)
		else
			CreatureObject(pPlayer):sendSystemMessage("@error_message:inv_full")
			-- Let them collect it on the next hail rather than losing it to a full pack.
			deleteData(playerID .. ":miningFieldMarkers:rewarded")
			return
		end
	end

	CreatureObject(pPlayer):sendSystemMessage("You have surveyed every marker on Mustafar for Surveyor Keslev.")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_completed.snd")
end

-- Single observer callback for all 31 markers. The marker that fired is identified by
-- its object id, so a marker can never be wired to another marker's handler.
function miningFieldMarkersScreenPlay:markerUsed(pMarker, pPlayer)
	if (pMarker == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local entry = self.markerByObjectID[SceneObject(pMarker):getObjectID()]

	if (entry == nil) then
		return 0
	end

	local area = entry.area
	local marker = entry.marker

	if (not QuestManager.hasActiveQuest(pPlayer, QuestManager.quests[area.setQuest])) then
		CreatureObject(pPlayer):sendSystemMessage("This object does not interest you.")
		return 0
	end

	if (QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests[marker.quest])) then
		CreatureObject(pPlayer):sendSystemMessage(marker.name .. " has already been checked.")
		return 0
	end

	QuestManager.completeQuest(pPlayer, QuestManager.quests[marker.quest])
	CreatureObject(pPlayer):sendSystemMessage(marker.name .. " activated.")
	CreatureObject(pPlayer):sendSystemMessage(marker.tidbit)
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	if (self:hasCompletedArea(pPlayer, area)) then
		QuestManager.activateQuest(pPlayer, QuestManager.quests[area.doneQuest])
		CreatureObject(pPlayer):sendSystemMessage("You have activated all of the markers in " .. area.name .. ". Please return to Surveyor Keslev.")
		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_completed.snd")
	end

	return 0
end
