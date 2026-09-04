--[[
	The Mining Field Markers -- Surveyor Keslev, Mensix Mining Facility

	  Start:   Surveyor Keslev, /wp 313 -1267, inside the Mensix Mining Facility.
	  Areas:   Berken's Flow (5), Burning Plains (5), Central Volcano (3),
	           Crystal Flats (5), Mining Field (5), Smoking Forest (5),
	           Tulrus Nesting Grounds (3) -- 31 markers total.
	  Level:   recommended CL75+ (the markers are not guarded, but the travel between
	           them crosses high-CL world spawns).

	SOURCE OF RECORD

	The seven area quests are SOE-authored XML in the client TREs:
	quest/som_exploration_{berken,burning,crystal,mining,smoking,tulrus,volcano}.qst.
	Each is a nested task tree, not a flat list:

	    task 0   Nothing            quest root
	      task N   Retrieve Item      one marker -- carries "Server Object Template"
	        task M   Show Message Box   that marker's tidbit, as messageBoxText
	      ...
	      task K   Wait for Tasks     gates on every marker in the area
	        task R   Reward             Bank Credits 5000

	The template and the prose are parent and child of the same task, so the
	marker-to-text binding is read off the file rather than inferred. Every
	`object =` and `tidbit =` below is that pairing verbatim, shipped typos included
	("seperatists", "dominate", "elavation", and the unfinished "The ruins were
	uncovered...edit..." line SOE left in som_berken_marker_03) -- the same
	convention hk_history.lua follows.

	COORDINATE FRAME

	World positions come from the world snapshot mustafar_mtg_patch_023.ws, which is
	what places every som_*_marker_NN.iff in the client. Parsed with
	C:\swg-extract\ws_dump.py. The snapshot stores (x, height, z) and Core3 lua takes
	(x, z = height, y), so each row is x = snapshot x, z = snapshot height,
	y = snapshot z. All 31 rows sit on their own template's snapshot node.

	The /way comment on each row is the client waypoint frame, kept as a human check
	value against the world coordinate:

	    world_x = way_x - 2880        world_y = way_y + 2976

	An earlier revision of this file was transcribed from the SWG wiki article and
	numbered its `object =` paths 01..NN in its own listing order. That left 20 of
	the 31 rows pointing at a template standing somewhere else. The .qst binding and
	the snapshot placement agree with each other against that numbering, so both the
	templates and the coordinates were re-derived from the shipped data.

	REWARDS -- and a correction

	The Reward task in each area quest grants Bank Credits 5000 and nothing else:
	Experience Amount 0, Experience Type empty, Reward Badge empty, Item empty,
	lootName empty. That part still holds, and it is why the wiki's "290 quest XP" has
	no backing. The 290 XP is still awarded below (areaXpReward) because that is what
	this file has always done and combat_general is the only XP pool this screenplay tree
	uses -- flagged here rather than changed, since dropping it is a reward-economy call.
	CORRECTION: the stored 0 was never what live paid. SOE recomputed from
	quest_experience[60][TIER_1] = 319 (see mustafar_quest_xp.lua / som_exploration_area).
	areaXpReward is now 319; combat_general still carries it.

	The completion reward was the wrong call, and this is the root cause: it was looked
	for in the .qst files, and it is not in them. It is in the conversation. Mustafar's
	server-side som_exploration_marker grants all three of these at once, off the last
	option of the last screen:

	    static item  item_tow_trophey_02_05
	    objvar       mustafar.tanray_heart
	    badge        bdg_must_mustafar_exploration

	So both of the reasons this file gave for not granting it were wrong:

	  * "There is no Tanray Heart Crystal template." The grep that produced that looked
	    for "tanray", and the item is not filed under that name.
	    item_tow_trophey_02_05 is "Mounted Lava Lizard Heart" in static_item_n.stf --
	    the fifth member of the same item_tow_trophey_02_NN family lava_beetle_nests.lua
	    and trophy_hunts.lua already resolved four of. Its object ships:
	    object/tangible/loot/mustafar/trophey_lava_lizard_heart.iff, registered at
	    object/custom_content/tangible/loot/mustafar/trophey_lava_lizard_heart.lua and
	    listed in that folder's serverobjects.lua. It is granted below.
	  * "Badges have no screenplay-side API here." They do.
	    PlayerObject:awardBadge is bound in LuaPlayerObject.cpp:43 and is used by ten
	    screenplays already -- heroOfTatooine.lua:321 and coa2Screenplay.lua:685 among
	    them. Badge keys are also exported to Lua as uppercase globals holding their
	    index (DirectorManager.cpp:862-869), so the shipped key name is usable directly.
	    The badge is granted below, guarded on the global existing so a .tre set without
	    that badge row fails soft instead of erroring.

	The wiki's "Master Mustafar Trailblazer" name for the badge is still unsupported. The
	shipped key is bdg_must_mustafar_exploration; its display name is not readable here,
	and neither is the badge row itself -- datatables/badge/badge_map.iff is in no .tre in
	gamedev/tre or gamedev/client-play (a sweep of all 76 turned up no file with "badge"
	in its name), because this working set is the Mustafar patch tres, not the base
	install. So the key is live-sourced but UNVERIFIED against this server's badge list.
	That is exactly what the guard below is for.

	NO TURN-IN -- a deviation this file used to have, now removed

	An earlier revision had the player walk each finished area back to Keslev to be paid,
	through turn_in and in_progress conversation screens. Live has neither screen and
	neither state: the 5000 credits come from the area quest's own Reward task, which
	fires the moment its Wait-for-Tasks gate closes. Payment now happens in markerUsed,
	where that gate closes, and the two invented screens are gone from the tree.

	This also removes the deadlock the old turnInArea had to work around: an area whose
	setQuest was left active pinned the conversation on an option-less screen forever.

	Live also lets several areas run at once -- each area's option is hidden only by
	!isQuestActiveOrComplete on its own quest, not by "some other area is active".
	getRemainingAreas already matches that; nothing forces one at a time.
--]]

local QuestManager = require("managers.quest.quest_manager")
local ObjectManager = require("managers.object.object_manager")

miningFieldMarkersScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "miningFieldMarkersScreenPlay",

	queststring = "miningfieldmarkerscreenplay",

	-- Paid per completed area set. The 5000 is the shipped Reward task's
	-- Bank Credits; the 319 XP is quest_experience[60][TIER_1] (see
	-- mustafar_quest_xp.lua / som_exploration_area). The wiki's 290 had no backing.
	areaCreditReward = 5000,
	areaXpReward = 319,

	-- The Tanray Heart Crystal Keslev promises on s_31 and hands over on s_6. Live grants
	-- static item item_tow_trophey_02_05, which is "Mounted Lava Lizard Heart" in
	-- static_item_n.stf and ships as this template. See REWARDS in the header for why an
	-- earlier revision concluded it did not exist.
	completionItem = "object/tangible/loot/mustafar/trophey_lava_lizard_heart.iff",

	-- Live badge key name. DirectorManager exports every badge key as an uppercase Lua
	-- global holding its index, so this is looked up by name at grant time. This
	-- server's badge_map.iff has no row for it, so the _G[...] guard skips the award
	-- silently; the fix is a TRE row, not a script change.
	completionBadge = "BDG_MUST_MUSTAFAR_EXPLORATION",

	-- Ordered list of the seven marker areas. Each area carries:
	--   key        internal id, also the conversation option key in keslev_conv_handler
	--   name       display name used in system messages
	--   setQuest   quest handed out by Keslev when the player picks the area
	--   doneQuest  completed, and paid, the moment every marker in the area has been
	--              touched -- this is the .qst's Wait-for-Tasks gate and its Reward task.
	--              It is not a hand-in; see NO TURN-IN in the header.
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
					tidbit = "Named after the famed Mustafarian Jesl Berken, Berken's Flow was once the richest source of raw minerals in the known galaxy. The wealth of Mustafar all started with the discovery of Berken's Flow. Today, most of its minerals extracted, Berken's Flow is used only for the smallest of mining operations.",
				},
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_02",
					object = "object/tangible/quest/som_berken_marker_04.iff",
					name = "Tulrus Isle Bridge Marker",
					x = -574.82, z = 61.786, y = 2491.94, -- /way 2305 -486
					tidbit = "This Klegger Corp. bridge connects Berken's Flow to the Tulrus Nesting Grounds. Due to the highly dangerous nature of the nesting grounds and their relative lack of resources, this bridge is hardly ever used.",
				},
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_03",
					object = "object/tangible/quest/som_berken_marker_05.iff",
					name = "Droid Factory Marker",
					x = 392.49, z = 45.1373, y = 2220.11, -- /way 3272 -758
					tidbit = "Built by the seperatists shortly before they were found slain in the old Klegger Mining Facility at the end of the Clone Wars. No mining crews who have entered this factory have ever come back.",
				},
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_04",
					object = "object/tangible/quest/som_berken_marker_03.iff",
					name = "Jedi Ruins Marker",
					x = 79.3501, z = 128.963, y = 3971.21, -- /way 2959 996
					tidbit = "The ruins were uncovered...edit...WARNING: The party of archeologists who were examining these ruins formed themselves into some sort of dangerous cult. They worship a man they call the Storm Lord and will attack anyone who does not accept him as a god.",
				},
				{
					quest = "SOM_BERKENS_FLOW_MARKERS_05",
					object = "object/tangible/quest/som_berken_marker_02.iff",
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
					object = "object/tangible/quest/som_burning_marker_04.iff",
					name = "Berken's Flow Bridge Marker",
					x = -2115.66, z = 62.7735, y = 5511.92, -- /way 764 2536
					tidbit = "Another Klegger Corp. bridge that shows the wear of time on its steel frame. This bridge connects the Burning Plains to Berken's Flow.",
				},
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_02",
					object = "object/tangible/quest/som_burning_marker_03.iff",
					name = "Central Volcano Bridge Marker",
					x = -2776.59, z = 23.5186, y = 4593.53, -- /way 103 1618
					tidbit = "Another bridge built by the Klegger Corporation. This bridge leads to the second largest volcano in the region. Although a poor source of resources, the volcano is invaluable as a landmark on an ever-shifting world.",
				},
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_03",
					object = "object/tangible/quest/som_burning_marker_02.iff",
					name = "Central Burning Plains Marker",
					x = -2805.63, z = 122.179, y = 5131.71, -- /way 74 2156
					tidbit = "There are only a few points of high elavation in the Burning Plains. When the plains finally are swallowed by the lava, these areas will become important mining islands.",
				},
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_04",
					object = "object/tangible/quest/som_burning_marker_05.iff",
					name = "Temple Ruins Marker",
					x = -2789.93, z = 21.4531, y = 5921.04, -- /way 90 2945
					tidbit = "WARNING: These ruins are closed by order of Milo Mensix. Everyone who spends any time in these ruins seems to lose their mind. Miners who have visited these ruins and returned have reported a very uneasy feeling, like they were being watched. The ruins themselves seem to be that of a great temple of unknown origin.",
				},
				{
					quest = "SOM_BURNING_PLAINS_MARKERS_05",
					object = "object/tangible/quest/som_burning_marker_01.iff",
					name = "Northern Burning Plains Marker",
					x = -4490.58, z = 15.909, y = 5905.25, -- /way -1610 2930
					tidbit = "The surface crust on the Burning Plains is especially thin. This allows lava to nearly bubble through the surface. Most experts agree that, if the area suffers a big enough earthquake, the entire plain will become a sea of lava.",
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
					object = "object/tangible/quest/som_volcano_marker_03.iff",
					name = "Kubaza Beetle Cavern Marker",
					x = -3703.1, z = 136.583, y = 3405.69, -- /way -823 430
					tidbit = "This cavern was originally built by the seperatists during their excavation of the Old Republic cruiser. After they left, it became a hive for kubaza beetles, hence the name. WARNING: The cavern was closed by order of Milo Mensix after a field crew of miners was lost to the beetles while surveying the cavern.",
				},
				{
					quest = "SOM_CENTRAL_VOLCANO_MARKERS_03",
					object = "object/tangible/quest/som_volcano_marker_02.iff",
					name = "Old Republic Cruiser Crash Site Marker",
					x = -2783.21, z = 144.265, y = 3154.02, -- /way 97 179
					tidbit = "The remains of this cruiser were excavated during the Clone Wars by the seperatists. After a brief period where they had sealed the area off, the seperatists left the area and began work on their new factory. Warning: Salvage Bandits have moved into this region and have begun dismantling the ship. They are highly dangerous and will kill on sight.",
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
					object = "object/tangible/quest/som_crystal_marker_04.iff",
					name = "Crystal Fields Marker",
					x = -4018.92, z = 75.1095, y = 2432.66, -- /way -1139 -543
					tidbit = "Like most of Mustafar, the crystal fields were formed relatively quickly. The sudden shift of the moon's orbit is causing the world to tear itself apart. This has made many geologic formations, like the crystal fields, that normally take millions of years to form on other worlds to sprout up virtually over night.",
				},
				{
					quest = "SOM_CRYSTAL_FLATS_MARKERS_02",
					object = "object/tangible/quest/som_crystal_marker_05.iff",
					name = "Crystal Flats Bridge",
					x = -5207.46, z = 5.71105, y = 2506.45, -- /way -2329 -468
					tidbit = "Built by the Klegger Corporation when they were the dominate mining company on Mustafar, these bridges were originally formed out of steel, although you wouldn't know it by looking at them now. Years in the harsh environment have coated the bridges with volcanic ash and rock so that they now look like natural rock formations.",
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
					object = "object/tangible/quest/som_crystal_marker_02.iff",
					name = "Salvage Bandit Camp",
					x = -5920.99, z = 86.3664, y = 102.05, -- /way -3041 -2873
					tidbit = "WARNING: Proceed at your own risk. This used to be a field miners' camp until it was overrun by the salvage bandits. These Mustafarians belong to no company and will simply steal anything that isn't nailed down.",
				},
				{
					quest = "SOM_CRYSTAL_FLATS_MARKERS_05",
					object = "object/tangible/quest/som_crystal_marker_01.iff",
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
					x = -2035.22, z = 153.899, y = 704.12, -- /way 842 -2273
					tidbit = "This facility was destroyed and abandoned shortly before the end of the Clone Wars. Salvage crews who investigated the facility after its destruction found the bodies of the separatist leaders, including Viceroy Gunray, murdered by a lightsaber.",
				},
				{
					quest = "SOM_MINING_FIELD_MARKERS_03",
					object = "object/tangible/quest/som_mining_marker_05.iff",
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
					object = "object/tangible/quest/som_mining_marker_03.iff",
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
					object = "object/tangible/quest/som_smoking_marker_02.iff",
					name = "Southern Jedi Ruins Marker",
					x = -4284.06, z = 80.8645, y = 3375.31, -- /way -1404 400
					tidbit = "These ruins were uncovered roughly 18 years after the end of the Clone Wars. Mustafar simply shifted, and they were revealed. Offworlders have become very excited by the discovery of these ruins and others like them.",
				},
				{
					quest = "SOM_SMOKING_FOREST_MARKERS_02",
					object = "object/tangible/quest/som_smoking_marker_03.iff",
					name = "Field Miner Camp Marker",
					x = -5151.03, z = 180.804, y = 4243.6, -- /way -2271 1268
					tidbit = "Mines like those in the Smoking Forest are very rare on Mustafar because they actually involve digging into the lava rock to extract minerals. While much harder than lava mining, the mines in the Smoking Forest produce some very rich veins of raw materials.",
				},
				{
					quest = "SOM_SMOKING_FOREST_MARKERS_03",
					object = "object/tangible/quest/som_smoking_marker_01.iff",
					name = "Western Smoking Forest Marker",
					x = -6225.11, z = 41.474, y = 4388.46, -- /way -3345 1413
					tidbit = "The smoking forest was once thick with the black smoke that was released by giant rock formations. Over time, the formations sealed off, and they eventually toppled down.",
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
					tidbit = "Like the other ruins located around Mustafar, this ruin appeared after a major earthquake. It's in remarkably good shape; our geologists place its age to be at least 5000 years old. ",
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
					x = -1971.31, z = 85.2697, y = 4073.65, -- /way 909 1098
					tidbit = "WARNING: Entering into the Sher Kar Cave is very foolish and will result in your death. By order of Milo Mensix, the cave is sealed by a relic that we located at the Jedi ruins.",
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
	--[[ Surveyor Keslev, cell 12112243 (small_room_05) of the Mensix Mining
	     Facility, world origin (-2420.50, 199.40, 1767.08). The template is now
	     som_surveyor_keslev, matching the live spawn table row. "Jo" was never part
	     of the name -- all seven shipped quest journals say "Surveyor Keslev" -- and
	     the old surveyor_jo template is retired in place.

	     x was +145.6 and is a sign error. Three sources give /way 313 -1267;
	     through this file's own offset above that is world (-2567.00, 1709.00),
	     so cell-local (-146.50, -58.08) against that origin. y already agreed to
	     0.08 m and x agreed in magnitude to 0.9 m -- only the sign was wrong.
	     +145.6 put him ~300 m outside the building shell. Everything else in
	     small_room_05 sits at negative cell-local x: the sibling miner at
	     mensix_mining_facility_main.lua:64 is at -154.4, the .ilf console at
	     -154.887, and the room's own .ilf furniture box runs x -160.29 ..
	     -138.19, y -69.66 .. -47.77 -- which contains both -145.6 and -146.5.
	     (Do not quote -155.82 .. -138.26 here; that box is conference_room's.)

	     The live facility spawn table settles it: som_surveyor_keslev,
	     small_room_05, (-145.6, 18.6, -58.1) facing -80, carrying
	     conversation.som_exploration_marker -- this screenplay's own conversation.
	     The shipped magnitude was right to the tenth and the published /way was
	     the 0.9 m out. Only the heading was wrong here: -50 was a guess and the
	     real value is -80. y is snapped from -58.0 to the table's -58.1. ]]
	spawnMobile("mustafar", "som_surveyor_keslev", 1, -145.6, 18.6, -58.1, -80, 12112243)
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
-- Live allows more than one at a time, so this returns the first and is a convenience
-- for callers that only need "is anything running" -- it is not a routing gate.
function miningFieldMarkersScreenPlay:getActiveArea(pPlayer)
	for i = 1, #self.markerAreas do
		local area = self.markerAreas[i]

		if (QuestManager.hasActiveQuest(pPlayer, QuestManager.quests[area.setQuest])) then
			return area
		end
	end

	return nil
end

-- True once the completion reward has been handed over. Live's equivalent is the objvar
-- mustafar.tanray_heart that its grantReward sets; this is the flag
-- grantCompletionReward writes, which is the same gate in the Core3 store.
function miningFieldMarkersScreenPlay:hasTakenCompletionReward(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "rewarded")) == 1
end

function miningFieldMarkersScreenPlay:hasCompletedArea(pPlayer, area)
	for i = 1, #area.markers do
		if (not QuestManager.hasCompletedQuest(pPlayer, QuestManager.quests[area.markers[i].quest])) then
			return false
		end
	end

	return true
end

-- True once every one of the seven area sets has been finished. This is live's
-- condition_completeAll, which ANDs hasCompletedQuest over the seven som_exploration_*
-- quests -- so it reads the done ids, not the search ids.
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

-- Areas the player has neither started nor finished. This is live's per-area guard,
-- !isQuestActiveOrComplete, over the seven area quests. The order is markerAreas' own;
-- keslev_conv_handler.areaListOrder is what puts the options in live's listing order.
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

-- Keslev only ever gives out general directions -- "due to the shifting of our moon's
-- surface, I cannot give you precise locations" -- so the player gets one waypoint at the
-- centroid of the area's markers, never a waypoint per marker.
function miningFieldMarkersScreenPlay:startArea(pPlayer, area)
	QuestManager.activateQuest(pPlayer, QuestManager.quests[area.setQuest])

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", area.name, "The Mining Field Markers", area.waypointX, 0, area.waypointY, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
		writeData(SceneObject(pPlayer):getObjectID() .. ":miningFieldMarkers:wp:" .. area.key, waypointID)
	end

	CreatureObject(pPlayer):sendSystemMessage("Find and activate every marker in " .. area.name .. ".")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_accepted.snd")
end

-- Called from markerUsed the moment an area's last marker is activated. This is the
-- .qst's Wait-for-Tasks gate closing and its Reward task firing; there is no hand-in.
function miningFieldMarkersScreenPlay:completeArea(pPlayer, area)
	QuestManager.completeQuest(pPlayer, QuestManager.quests[area.doneQuest])

	-- The search quest has to be closed as well. completeQuest clears the active bit only
	-- for the id it is handed, so leaving setQuest active would keep this finished area
	-- out of getRemainingAreas forever and Keslev would never offer it back.
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

	-- 319 quest XP + 5000 credits per area set. Live NGE awards "Quest XP"; Core3's
	-- experience table has no such type, so combat_general carries the value -- the same
	-- mapping map_exploration.lua makes. 319 is quest_experience[60][TIER_1]; see
	-- mustafar_quest_xp.lua.
	CreatureObject(pPlayer):awardExperience("combat_general", self.areaXpReward, true)
	CreatureObject(pPlayer):addCashCredits(self.areaCreditReward, true)

	CreatureObject(pPlayer):sendSystemMessage("Surveyor Keslev pays you " .. self.areaCreditReward .. " credits for surveying " .. area.name .. ".")
	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_completed.snd")
end

-- Fired from the reward screen -- the one the player reaches by ASKING for the reward, not
-- the one that offers it. Live hangs action_grantReward off that option, so a player who
-- opens the thank-you screen and walks away is not paid. Still guarded once per player via
-- persistent screenplay data, because runScreenHandlers can be re-entered.
function miningFieldMarkersScreenPlay:grantCompletionReward(pPlayer)
	if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "rewarded")) == 1) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "rewarded", 1)

	--[[ Every failure path must clear the same persistent key the guard above writes.
	     `rewarded` is set at :623 BEFORE the item is handed over, so any path that
	     leaves without the item and without clearing it costs the player the reward
	     permanently. Clearing the old shared-memory key instead would leave the guard
	     set and lock it for good.

	     The full-pack check is not sufficient on its own: giveItem returns nil when
	     either createObject or transferObject fails (DirectorManager.cpp:2461-2479),
	     neither of which isContainerFullRecursive() can see. Discarding that return was
	     the defect. It is not latent -- completionItem is a real template at :130 and
	     keslev_conv_handler.lua:208 reaches this function -- so it could fire in play.

	     Shape and the 4th `true` (overload) copied from the nearest sibling,
	     maneater.lua:702-710. ]]
	if (self.completionItem ~= nil) then
		local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

		if (pInventory == nil) then
			print("miningFieldMarkersScreenPlay: player has no inventory; the lava lizard heart could not be handed over")
			deleteScreenPlayData(pPlayer, self.screenplayName, "rewarded")
			return
		elseif (SceneObject(pInventory):isContainerFullRecursive()) then
			CreatureObject(pPlayer):sendSystemMessage("@error_message:inv_full")
			-- Let them collect it on the next hail rather than losing it to a full pack.
			deleteScreenPlayData(pPlayer, self.screenplayName, "rewarded")
			return
		elseif (giveItem(pInventory, self.completionItem, -1, true) == nil) then
			CreatureObject(pPlayer):sendSystemMessage("You have no room for the lava lizard heart.")
			deleteScreenPlayData(pPlayer, self.screenplayName, "rewarded")
			return
		end
	end

	-- Live's grantReward closes with badge.grantBadge(player, "bdg_must_mustafar_exploration").
	-- Badge keys arrive in Lua as uppercase globals holding their index, so the guard is
	-- "does this server's badge_map have that row" -- see the header; it could not be checked
	-- from the tre set here, and an unknown badge index would be an error, not a no-op.
	if (self.completionBadge ~= nil and _G[self.completionBadge] ~= nil) then
		local pGhost = CreatureObject(pPlayer):getPlayerObject()

		if (pGhost ~= nil) then
			PlayerObject(pGhost):awardBadge(_G[self.completionBadge])
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

	-- The last marker in a set closes the set. Nothing to walk back for: completeArea is
	-- the .qst's Wait-for-Tasks gate closing and its Reward task firing, and it sends its
	-- own completion message and sound.
	if (self:hasCompletedArea(pPlayer, area)) then
		self:completeArea(pPlayer, area)
	end

	return 0
end
