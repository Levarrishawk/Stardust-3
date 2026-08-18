--[[
	Mustafar trophy hunts.

	Three shipped SOM quests in one screenplay:

		som_blistmok_rug        "Skin the Blistmoks"
		som_jundak_skull        "Skull of the Jundak"
		som_xandank_trophey     "A Whole Pack of Trouble"

	SOURCE OF RECORD
	----------------
	Every title, description, item name, count, drop percent, coordinate,
	radius, signal name, sound and reward id below is quoted verbatim from the
	shipped .qst files:

		datatables/quest/som_blistmok_rug.qst
		datatables/quest/som_jundak_skull.qst
		datatables/quest/som_xandank_trophey.qst

	Provenance comments name the .qst task each string came from.  Nothing in
	this file is quest prose I wrote; where a string had to be authored because
	the .qst has no line for it, the comment says so in as many words.

	NO JOURNAL / PROGRESS TRACKING
	------------------------------
	None of these three quests has a row in datatables/player/quests.iff, so
	there is no journal to drive and nothing is added to
	managers/quest/quest_manager.lua.  Progress lives in persistent screenplay
	data and the .qst's journalEntryDescription lines go out as system messages
	and waypoint descriptions instead.

	WHO GRANTS THESE -- OPEN, DELIBERATELY NOT FILLED
	-------------------------------------------------
	The .qst files do not name a giver, and none of the three has a shipped
	start hook:

	  * som_xandank_trophey's [list] description says "Renlo Hens has told you
	    about a pack of xandank".  mobile/custom_content/som/miner_hens.lua does
	    ship ("Miner Renlo Hens", level 70, CONVERSABLE) and is already spawned
	    by screenplays/mustafar/regions/smoking_forest_region.lua:32 at
	    (-5406.1, 296.0, 4429.8) -- 29 m from this quest's own "Striking
	    Miner's Camp" waypoint.  But his conversationTemplate is "" and no
	    som_*renlo* / som_*hens* conversation ships anywhere.  He has no
	    dialogue to hang a grant on.  That screenplay and that mobile file are
	    not mine to edit.

	  * som_blistmok_rug's [list] says "You found a blistmok skin rug in the
	    mining facility".  No trophey_blistmok_skin node exists anywhere in
	    snapshot/mustafar.ws and no rug/skin/carpet prop exists anywhere in
	    appearance/must_mining_facility.ilf.  The object the player is supposed
	    to find does not ship.

	  * som_jundak_skull's [list] says "You found a bleached skull of a jundak".
	    appearance/must_mining_facility.ilf does place
	    object/tangible/loot/mustafar/shared_bones_must_monster_jaw_small.iff in
	    small_room_03 at cell-local (-133.647, 14.086, 39.545) -- that is the
	    skull, and it is exactly the item this quest rewards.  But Core3 never
	    calls InteriorLayoutTemplate, so .ilf furniture is client-side dressing
	    only; there is no server object there to click.

	So this screenplay places all of the world content and drives all of the
	progression, and exposes

		trophyHuntsScreenPlay:grantBlistmokRug(pPlayer)
		trophyHuntsScreenPlay:grantJundakSkull(pPlayer)
		trophyHuntsScreenPlay:grantXandankTrophey(pPlayer)
		trophyHuntsScreenPlay:turnInXandank(pPlayer)

	as the entry points a giver's conversation handler calls once Aaron rules
	how these are handed out.  Nothing calls them yet.  This follows the same
	precedent bounty_hunts.lua set for the same gap.

	THE CREATURES -- FOUR SUBSTITUTED, ALL FLAGGED
	----------------------------------------------
	The .qst names four creature templates.  None of the four exists: a full
	name-table scan of every client .tre returns no file for any of them, they
	appear in zero files in this repo, and string/en/mob/creature_names.stf has
	no row for any of them in any of its six shipped copies.  Substitutes:

	  som_blistmok_ura_jen    -> blistmok_trampler, setCustomObjectName("Ura Jen")
	  som_ancient_jundak      -> jundak_devourer,   setCustomObjectName("Ancient Jundak")
	  som_xandank_packleader  -> xandank_patriarch, setCustomObjectName("Xandank Packleader")
	  som_xandank_pack        -> xandank

	som_xandank_pack -> xandank is the only one with in-repo evidence:
	mobile/lair/creature_dynamic/mustafar_xandank_pack.lua:2 is the sole place
	the string "xandank_pack" appears in this repo and its roster is
	{{"xandank",2},{"xandank",1}}.

	The other three are my pick of the closest shipped variant and are OPEN
	QUESTIONS, not findings.  Note in particular that blistmok, blistmok_shrieker
	and blistmok_trampler are stat-identical, so choosing trampler for Ura Jen is
	flavour only -- it does not make her the "exceptional blistmok" the .qst
	describes.  If these four should be authored as real creature templates
	instead, that is mobile/ work nobody has assigned.

	All four substitutes are registered and reachable:
	blistmok_trampler.lua:40 + som/serverobjects.lua:32,
	jundak_devourer.lua:40 + :54, xandank_patriarch.lua:40 + :181,
	xandank.lua:40 + :179.

	THE REWARDS -- ALL THREE RESOLVED, NOTHING SUBSTITUTED
	------------------------------------------------------
	Each Reward task's lootName resolves to a shipped, registered server
	template.  The objectName key is read out of the shipped shared client
	template; the display name is the string/en/static_item_n.stf row.

	  item_tow_trophey_02_06  "Blistmok Skin Rug"
	      object/tangible/loot/mustafar/trophey_blistmok_skin.iff
	      trophey_blistmok_skin.lua:5 addTemplate, serverobjects.lua:47

	  item_tow_trophey_02_04  "Jundak Skull"
	      object/tangible/loot/mustafar/bones_must_monster_jaw_small.iff
	      bones_must_monster_jaw_small.lua:3 addTemplate, serverobjects.lua:5

	  item_tow_trophey_02_03  "Mounted Xandank Head"
	      object/tangible/loot/mustafar/trophey_xandank.iff
	      trophey_xandank.lua:3 addTemplate, serverobjects.lua:17

	THE PROPS THE PLAYER CLICKS -- ALL SHIPPED IN THE SNAPSHOT
	----------------------------------------------------------
	Chem lockers (som_blistmok_rug task 2, "Server Object Template =
	object/tangible/quest/must_chem_locker.iff", Count 3):
	object/tangible/quest/shared_must_chem_locker.iff has exactly five nodes in
	snapshot/mustafar.ws, byte-identical in stardust_03.tre and mtg_patch_023.tre:

	    12110160   (-402.36,   58.08,  3076.12)
	    12111127   (-3399.31,  34.10,  5322.66)
	    12111128   (-5363.90, 295.95,  4420.65)   the Striking Miner's Camp
	    12112910   (-2865.86, 103.61,  -273.10)
	    12113486   (-5555.74, 205.35,   955.53)

	Five lockers against a Count of 3 is exactly the .qst's "You will need to
	travel to at least three field camps".  No other screenplay claims these ids.

	Pack traces (som_xandank_trophey tasks 18 and 19, "Search the Area"):

	    12111126  object/tangible/item/som/shared_xandank_lair.iff
	              (-4776.14, 194.15, 4478.05) --  4.5 m from task 16's waypoint
	    12111108  object/tangible/item/som/shared_xandank_lair_two.iff
	              (-4338.77,  50.82, 4460.94) -- 25.8 m from task 17's waypoint

	These are the only two som/xandank_lair* props in the entire snapshot and
	they sit at the two sites the .qst sends the player to search, both inside
	the .qst's own Radius 50.  Server templates are registered at
	object/custom_content/tangible/item/som/xandank_lair.lua and
	xandank_lair_two.lua, serverobjects.lua:30-31.

	The den (task 20, Radius 75 around -4586 / 5104) holds five
	object/building/mustafar/terrain/creature_lairs/shared_must_xandank_lair.iff
	nodes 13.9-32.8 m from that point: 12111121 12111122 12111123 12111124
	12111125.  The pack is spawned on those five positions plus the den point
	itself, which is where its Count of 6 comes from.

	Nothing at all exists within 150 m of the Ura Jen site (-3791 / 2625) or the
	Ancient Jundak site (-1616 / 4275).  Those two are bare terrain.

	THE BLEACH VAT -- PLACED, NOT QUOTED
	------------------------------------
	som_jundak_skull task 5 says "you noticed a vat of bleach in the lab".  The
	.qst gives no template, no coordinate and no cell.  So:

	  * No cell in the mining facility is named "lab".  small_room_03 is the one
	    that reads as one: 14 item_medic_bacta_tank_advanced, two
	    must_mining_console_02, two floor consoles, a must_bandit_cooling_unit,
	    and -- decisively -- the shared_bones_must_monster_jaw_small.iff the
	    [list] says the player found in the mining facility.
	  * small_room_03 is appearance/thm_must_mining_outpost.pob cell index 16.
	    Facility building node 12112217 has 30 cell children whose ids are NOT
	    contiguous (12112233 and 12112239 are absent), so buildingID + index is
	    wrong; index 16 resolves to node 12112234.  resolveCell() prefers
	    getNamedCell("small_room_03") and only falls back to that id.
	  * object/tangible/quest/must_coolant_system.iff is registered
	    (must_coolant_system.lua:5, serverobjects.lua:254) and is the closest
	    thing to a vat the SOM quest set ships.
	  * It is NOT placed on the .ilf's cooling-unit slot:
	    shared_must_coolant_system.iff and shared_must_bandit_cooling_unit.iff
	    share the same appearance (appearance/poi_all_force_bandit_cooling_unit.apt),
	    so putting it there would double a mesh the client already draws.  It
	    goes on clear floor 2.9 m clear of the nearest .ilf prop, at the cooling
	    unit's height because it is the same appearance.

	The template, the cell and the coordinate are all my placement.  OPEN.

	REPEATS
	-------
	All three .qst [list] blocks carry allowRepeats = true, so each quest resets
	to available on completion and keeps a run counter.

	KILL COUNTING
	-------------
	One persistent KILLEDCREATURE observer per player (5th arg 1, or counts stop
	after a relog), attached on grant, dropped when no trophy quest is active.
	Named uniques are credited by objectID, not by template -- respawn re-inserts
	the same object so the id survives.

	WHAT IS NOT MODELLED
	--------------------
	  * The .qst's per-task ItemName progress markers ("Preservative",
	    "Pristine Blistmok Skin", "Jundak Skull", "Head of the Packleader") are
	    counters here, not minted inventory items.  No such server templates
	    ship and inventing them is content authoring nobody asked for.  OPEN.
	  * The Reward tasks' CountItem / CountWeapon / CountArmor / Faction / quality
	    float fields are all zero or empty in all three .qst files and are unused.
	  * Bank Credits 0 and Experience Amount 0 are honoured literally: no credits
	    and no XP are granted, because that is what the .qst says.
--]]

trophyHuntsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trophyHuntsScreenPlay",

	-- .qst task 0 / 15, musicOnActivate; Reward task, musicOnComplete.  Same in all three.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst.  Counter ticks have no shipped sound; this is the one
	-- map_exploration.lua:412 uses for its own hunt ticks.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	-- snapshot/mustafar.ws, object/tangible/quest/shared_must_chem_locker.iff
	chemLockers = { 12110160, 12111127, 12111128, 12112910, 12113486 },

	-- snapshot node 12112217, object/building/mustafar/structures/shared_must_new_mining_facility.iff
	facilityID = 12112217,

	bleachVat = {
		template = "object/tangible/quest/must_coolant_system.iff",
		cellName = "small_room_03",
		cellID = 12112234,
		x = -131.5,
		z = 10.322,
		y = 47.5,
		heading = 0,
	},

	respawnTimer = 300,

	areaByObjectID = {},
	uraJenID = 0,
	ancientJundakID = 0,
	packLeaderID = 0,
	packMemberIDs = {},

	quests = {

		-- ================================================================
		-- som_blistmok_rug
		-- ================================================================
		blistmokRug = {
			dataPrefix = "rug",
			questKey = "blistmokRug",

			-- [list]
			title = "Skin the Blistmoks",
			description = "You found a blistmok skin rug in the mining facility. It looks like it would be fairly simple to make one of your own if you can gather the correct materials.",
			level = 65,
			rewardItem = "object/tangible/loot/mustafar/trophey_blistmok_skin.iff",	-- task 7, lootName item_tow_trophey_02_06
			rewardName = "Blistmok Skin Rug",

			STAGE_GATHER = 1,
			STAGE_URA_JEN = 2,
			STAGE_DONE = 3,

			-- task 3, Wait for Tasks (blistmok_rug_one) -- the umbrella over tasks 1 and 2
			gatherTitle = "Collect Rug Materials",
			gatherDescription = "In order to make a rug you are going to need to gather the raw materials needed to put it together. You will need to gather a selection of pristine blistmok skins and enough preservatives to cure them.",

			-- task 1, Destroy Multiple and Loot (blistmok_rug_three)
			skinTitle = "Collect Pristine Blistmok Skins",
			skinDescription = "In order to make the perfect rug, you need to gather a selection of undamaged skins. Gather 10 pristine skins of the blistmok.",
			skinItemName = "Pristine Blistmok Skin",
			skinsRequired = 10,
			skinDropPercent = 15,
			-- .qst "Social Group = blistmok" is unusable: every ported SOM creature's
			-- socialGroup is "townsperson" or "".  Enumerated instead, tamed pets
			-- (trained_*) excluded.
			skinTemplates = {
				["blistmok"] = true,
				["blistmok_shrieker"] = true,
				["blistmok_trampler"] = true,
			},

			-- task 2, Retrieve Item (blistmok_rug_two)
			preservativeTitle = "Collect Preservatives",
			preservativeDescription = "In order to make sure the rug stays in good condition it will need to be treated with a powerful preservative compound. Unfortunately all of the mining facility's stock is out in the field. You will need to travel to several field camps in order to gather the preservatives it will take to cure the rug. You should only take a little from each camp so that the miners do not run out. You will need to travel to at least three field camps to gather the supplies from the chemical lockers.",
			preservativeItemName = "Preservative",
			preservativesRequired = 3,
			preservativeMenuText = "Take Preservative",	-- task 2, retrieveMenuText

			-- task 4, Destroy Multiple and Loot (blistmok_rug_five)
			uraJenTitle = "Gather Skin of Ura Jen",
			uraJenDescription = "None of the skins that you gathered from the regular blistmoks are exceptional enough to make the rug out of. You will need to get the hide of an exceptional blistmok. Perhaps if you kill Ura Jen, it will have the skin that will be perfect for your new rug.",
			uraJenItemName = "Skin of Ura Jen",
			uraJenWaypointName = "Ura Jen",		-- task 4, waypointName
			-- task 4: LocationX -3791, LocationY 66 (height), LocationZ 2625
			uraJenX = -3791,
			uraJenZ = 66,
			uraJenY = 2625,
			-- som_blistmok_ura_jen does not ship anywhere.  SUBSTITUTE -- see header.
			uraJenTemplate = "blistmok_trampler",
			uraJenName = "Ura Jen",
		},

		-- ================================================================
		-- som_jundak_skull
		-- ================================================================
		jundakSkull = {
			dataPrefix = "skull",
			questKey = "jundakSkull",

			-- [list]
			title = "Skull of the Jundak",
			description = "You found a bleached skull of a jundak that looks like it would make a nice trophy. The inscription on the skull tells a tale of how the hunter fought two jundaks. One was turned into the trophy and the other got away. Maybe if you were to return to the location where this fight took place, you could find the jundak that escaped, and make a trophy from its skull.",
			level = 75,
			rewardItem = "object/tangible/loot/mustafar/bones_must_monster_jaw_small.iff",	-- task 7, lootName item_tow_trophey_02_04
			rewardName = "Jundak Skull",

			STAGE_HUNT = 1,
			STAGE_BLEACH = 2,
			STAGE_SOAK = 3,
			STAGE_READY = 4,
			STAGE_DONE = 5,
			soakStage = 3,

			-- task 1, Destroy Multiple and Loot (jundak_skull_one)
			huntTitle = "Collect Skull of an Ancient Jundak",
			huntDescription = "Return to the area where the last hunter fought the jundak, find the ancient jundak, and take its skull.",
			huntItemName = "Jundak Skull",
			huntWaypointName = "Ancient Jundak",	-- task 1, waypointName
			-- task 1: LocationX -1616, LocationY 40 (height), LocationZ 4275
			huntX = -1616,
			huntZ = 40,
			huntY = 4275,
			-- som_ancient_jundak does not ship anywhere.  SUBSTITUTE -- see header.
			huntTemplate = "jundak_devourer",
			huntName = "Ancient Jundak",

			-- task 5, Wait for Signal (jundak_skull_two), Signal Name jundak_skull_signal_one
			bleachTitle = "Bleach the Skull",
			bleachDescription = "While exploring the mining facility, you noticed a vat of bleach in the lab. If you were to place the skull inside of that vat, it should clean it up rather quickly.",

			-- task 6, Wait for Signal (jundak_skull_three), Signal Name jundak_skull_signal_two
			soakTitle = "Bleaching the Skull",
			soakDescription = "It will take a little bit of time for the skull to be completely cleansed. Wait for the skull to become completely bleached before removing it from the vat.",
			-- The .qst says "a little bit of time" and gives no number.  180 s is
			-- MINE, not the .qst's.  OPEN.
			soakSeconds = 180,
		},

		-- ================================================================
		-- som_xandank_trophey
		-- ================================================================
		xandankTrophey = {
			dataPrefix = "pack",
			questKey = "xandankTrophey",

			-- [list]
			title = "A Whole Pack of Trouble",
			description = "Renlo Hens has told you about a pack of xandank who have been causing trouble with the miners in the area. He has explained that with the strike they do not have any spare men who can hunt down these troublesome xandank. He has asked you to track down this pack and see if you can eliminate them.",
			level = 75,
			rewardItem = "object/tangible/loot/mustafar/trophey_xandank.iff",	-- task 26, lootName item_tow_trophey_02_03
			rewardName = "Mounted Xandank Head",

			STAGE_SITE_ONE = 1,
			STAGE_SEARCH_ONE = 2,
			STAGE_SITE_TWO = 3,
			STAGE_SEARCH_TWO = 4,
			STAGE_DEN = 5,
			STAGE_FIGHT = 6,
			STAGE_RETURN = 7,
			STAGE_DONE = 8,

			-- task 16, Go to Location (xandank_trophy_one)
			siteOneTitle = "Travel to the Pack's Last Location",
			siteOneDescription = "Renlo has asked that you travel east to the location that the pack was last seen and see if you can track them from there. Once you reach the area search around for any sign of the direction that the pack went.",
			siteOneWaypointName = "Xandank Pack Last Location",
			siteOneX = -4780,	-- LocationX
			siteOneZ = 194,		-- LocationY, height
			siteOneY = 4474,	-- LocationZ
			siteOneRadius = 50,

			-- task 18, Wait for Signal (xandank_trophy_two), Signal Name xandank_trophy_signal_one
			searchOneTitle = "Search the Area",
			searchOneDescription = "Search the area for any physical traces that indicate that the pack was here.",
			searchOneNodeID = 12111126,	-- shared_xandank_lair.iff, 4.5 m from the task 16 waypoint

			-- task 17, Go to Location (xandank_trophy_three)
			siteTwoTitle = "Follow the Pack's Trail",
			siteTwoDescription = "Follow the pack's trail east, until you find out where they were heading.",
			siteTwoWaypointName = "Xandank Pack Location",
			siteTwoX = -4361,
			siteTwoZ = 55,
			siteTwoY = 4474,
			siteTwoRadius = 50,

			-- task 19, Wait for Signal (xandank_trophy_four), Signal Name xandank_trophy_signal_two
			searchTwoTitle = "Search the Area",
			searchTwoDescription = "You found where the pack stopped and rested for a while. Look around for any physical traces that may indicate where they went next.",
			searchTwoNodeID = 12111108,	-- shared_xandank_lair_two.iff, 25.8 m from the task 17 waypoint

			-- task 20, Go to Location (xandank_trophy_five)
			denTitle = "Follow the Pack's Trail",
			denDescription = "The pack has moved onto a different location. Follow their trail north to see where they went.",
			denWaypointName = "Xandank Pack",
			denX = -4586,
			denZ = 48,
			denY = 5104,
			denRadius = 75,

			-- The five shared_must_xandank_lair.iff nodes that sit inside task 20's
			-- Radius 75, read out of snapshot/mustafar.ws.  The pack spawns on them;
			-- the sixth member and the packleader take the .qst's own den coordinate.
			packSpawns = {
				{ x = -4556.56, z = 51.93, y = 5118.53 },	-- lair node 12111121
				{ x = -4580.00, z = 51.01, y = 5082.46 },	-- lair node 12111122
				{ x = -4602.76, z = 45.67, y = 5097.91 },	-- lair node 12111123
				{ x = -4571.51, z = 49.62, y = 5102.81 },	-- lair node 12111124
				{ x = -4595.75, z = 47.90, y = 5113.97 },	-- lair node 12111125
				{ x = -4586.00, z = 48.00, y = 5104.00 },	-- task 20's own coordinate
			},

			-- task 22, Wait for Tasks (xandank_trophy_eight) -- the umbrella over 23 and 27
			fightTitle = "Eliminate the Pack",
			fightDescription = "You have managed to find the dangerous and troublesome pack. You will need to not only kill the xandank packleader and bring its head back to Renlo, you will also need to eliminate all members of the pack.",

			-- task 23, Destroy Multiple (xandank_trophy_seven)
			packTitle = "Eliminate the Xandank Pack",
			packDescription = "To make sure that this xandank pack never causes any trouble again, you should eliminate the entire pack.",
			packRequired = 6,
			-- .qst "Target Server Template = som_xandank_pack".  Does not ship.
			-- SUBSTITUTE per mustafar_xandank_pack.lua:2 -- see header.
			packTemplates = {
				["xandank"] = true,
				["xandank_onyx_plated"] = true,
				["xandank_patriarch"] = true,
			},
			packTemplate = "xandank",

			-- task 27, Destroy Multiple and Loot (xandank_trophy_six)
			leaderTitle = "Remove the Head of the Packleader",
			leaderDescription = "Renlo Hens has asked you to gather the head of the xandank packleader to bring back to him as proof that the pack is taken care of.",
			leaderItemName = "Head of the Packleader",
			-- som_xandank_packleader does not ship anywhere.  SUBSTITUTE -- see header.
			leaderTemplate = "xandank_patriarch",
			leaderName = "Xandank Packleader",

			-- task 25, Wait for Signal (xandank_trophy_nine), Signal Name xandank_trophy_signal_three
			returnTitle = "Return to Miner Renlo Hens",
			returnDescription = "Bring the head of the packleader back to Renlo and report that the dangerous pack will not be troubling them anymore.",
			returnWaypointName = "Striking Miner's Camp",
			returnX = -5380,
			returnZ = 294,
			returnY = 4440,
			-- The .qst gives no radius for task 25 (Wait for Signal tasks have no
			-- Radius field).  40 is MINE, picked so the area covers both the .qst's
			-- own waypoint and Renlo's actual spawn 28 m away.  OPEN.
			returnRadius = 40,
		},
	},
}

registerScreenPlay("trophyHuntsScreenPlay", true)

-- ====================================================================
-- World setup
--
-- DirectorManager::startScreenPlay calls this by name on every screenplay
-- registered with true, so everything here runs once per server start.
-- ====================================================================

function trophyHuntsScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachChemLockers()
		self:attachPackTraces()
		self:spawnBleachVat()
		self:spawnUniques()
		self:spawnAreas()
	end
end

-- The five shipped must_chem_locker snapshot nodes get the radial that
-- som_blistmok_rug task 2 asks for.  Nothing is spawned; these already exist.
function trophyHuntsScreenPlay:attachChemLockers()
	for i = 1, #self.chemLockers do
		local nodeID = self.chemLockers[i]
		local pLocker = getSceneObject(nodeID)

		if (pLocker == nil) then
			print("trophyHuntsScreenPlay: chem locker snapshot object " .. nodeID .. " was not found; that field camp will be unusable")
		else
			writeStringData(nodeID .. ":trophyRole", "chemLocker")
			SceneObject(pLocker):setObjectMenuComponent("TrophyHuntsMenuComponent")
		end
	end
end

-- The two som/xandank_lair props the player searches in
-- som_xandank_trophey tasks 18 and 19.  Also already in the snapshot.
function trophyHuntsScreenPlay:attachPackTraces()
	local pack = self.quests.xandankTrophey
	local traces = {
		{ id = pack.searchOneNodeID, role = "packTrace1" },
		{ id = pack.searchTwoNodeID, role = "packTrace2" },
	}

	for i = 1, #traces do
		local pTrace = getSceneObject(traces[i].id)

		if (pTrace == nil) then
			print("trophyHuntsScreenPlay: snapshot object " .. traces[i].id .. " (" .. traces[i].role .. ") was not found; that step of som_xandank_trophey will be unreachable")
		else
			writeStringData(traces[i].id .. ":trophyRole", traces[i].role)
			SceneObject(pTrace):setObjectMenuComponent("TrophyHuntsMenuComponent")
		end
	end
end

-- Prefer the live cell by name; fall back to the snapshot node id only if the
-- building did not hand one back.  Copied from moral_choice.lua:282.
function trophyHuntsScreenPlay:resolveCell(pBuilding, cellName, cellID)
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

function trophyHuntsScreenPlay:spawnBleachVat()
	local vat = self.bleachVat
	local pBuilding = getSceneObject(self.facilityID)

	if (pBuilding == nil) then
		print("trophyHuntsScreenPlay: mining facility " .. self.facilityID .. " was not found; the bleach vat will not be spawned and som_jundak_skull cannot be finished")
		return
	end

	local cellID, how = self:resolveCell(pBuilding, vat.cellName, vat.cellID)

	if (cellID == 0) then
		print("trophyHuntsScreenPlay: cell " .. vat.cellName .. " of the mining facility was not found; the bleach vat will not be spawned and som_jundak_skull cannot be finished")
		return
	end

	local pVat = spawnSceneObject("mustafar", vat.template, vat.x, vat.z, vat.y, cellID, math.rad(vat.heading))

	if (pVat == nil) then
		print("trophyHuntsScreenPlay: the bleach vat failed to spawn in " .. vat.cellName .. " (cell resolved by " .. how .. "); som_jundak_skull cannot be finished")
		return
	end

	self.bleachVatID = SceneObject(pVat):getObjectID()
	writeStringData(self.bleachVatID .. ":trophyRole", "bleachVat")
	SceneObject(pVat):setObjectMenuComponent("TrophyHuntsMenuComponent")
end

-- spawnMobile's 3rd argument must be > 0 or RespawnCreatureTask never fires.
-- Respawn re-inserts the SAME object, so the objectID recorded here survives a
-- respawn and is what the kill observer matches on.
function trophyHuntsScreenPlay:spawnNamed(template, name, x, z, y)
	local pMobile = spawnMobile("mustafar", template, self.respawnTimer, x, z, y, getRandomNumber(360) - 180, 0)

	if (pMobile == nil) then
		print("trophyHuntsScreenPlay: " .. template .. " failed to spawn at " .. x .. " " .. y)
		return 0
	end

	if (name ~= nil) then
		CreatureObject(pMobile):setCustomObjectName(name)
	end

	return SceneObject(pMobile):getObjectID()
end

function trophyHuntsScreenPlay:spawnUniques()
	local rug = self.quests.blistmokRug
	local skull = self.quests.jundakSkull
	local pack = self.quests.xandankTrophey

	self.uraJenID = self:spawnNamed(rug.uraJenTemplate, rug.uraJenName, rug.uraJenX, rug.uraJenZ, rug.uraJenY)
	self.ancientJundakID = self:spawnNamed(skull.huntTemplate, skull.huntName, skull.huntX, skull.huntZ, skull.huntY)
	self.packLeaderID = self:spawnNamed(pack.leaderTemplate, pack.leaderName, pack.denX, pack.denZ, pack.denY)

	self.packMemberIDs = {}

	for i = 1, #pack.packSpawns do
		local spot = pack.packSpawns[i]
		local memberID = self:spawnNamed(pack.packTemplate, nil, spot.x, spot.z, spot.y)

		if (memberID ~= 0) then
			table.insert(self.packMemberIDs, memberID)
		end
	end
end

function trophyHuntsScreenPlay:spawnArea(role, x, z, y, radius)
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", x, z, y, radius, 0)

	if (pArea == nil) then
		print("trophyHuntsScreenPlay: active area " .. role .. " failed to spawn; that step of som_xandank_trophey will be unreachable")
		return
	end

	self.areaByObjectID[SceneObject(pArea):getObjectID()] = role
	createObserver(ENTEREDAREA, "trophyHuntsScreenPlay", "notifyEnteredArea", pArea)
end

function trophyHuntsScreenPlay:spawnAreas()
	local pack = self.quests.xandankTrophey

	self:spawnArea("siteOne", pack.siteOneX, pack.siteOneZ, pack.siteOneY, pack.siteOneRadius)
	self:spawnArea("siteTwo", pack.siteTwoX, pack.siteTwoZ, pack.siteTwoY, pack.siteTwoRadius)
	self:spawnArea("den", pack.denX, pack.denZ, pack.denY, pack.denRadius)
	self:spawnArea("camp", pack.returnX, pack.returnZ, pack.returnY, pack.returnRadius)
end

-- ====================================================================
-- Per-quest state
--
-- readScreenPlayData returns "" for a key that was never written and
-- tonumber("") is nil, hence "or 0" everywhere.
-- ====================================================================

function trophyHuntsScreenPlay:key(quest, name)
	return quest.dataPrefix .. "_" .. name
end

function trophyHuntsScreenPlay:getNumber(pPlayer, quest, name)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, self:key(quest, name))) or 0
end

function trophyHuntsScreenPlay:setNumber(pPlayer, quest, name, value)
	writeScreenPlayData(pPlayer, self.screenplayName, self:key(quest, name), tostring(value))
end

function trophyHuntsScreenPlay:rawStage(pPlayer, quest)
	return self:getNumber(pPlayer, quest, "stage")
end

-- createEvent does not survive a restart, so the soak is stamped with a
-- deadline and settled lazily the next time anything reads the stage.  This
-- is the cursed_shard.lua:332 idiom.  Anything reached from the settle path
-- must read rawStage, never getStage, or it recurses.
function trophyHuntsScreenPlay:getStage(pPlayer, quest)
	local stage = self:rawStage(pPlayer, quest)

	if (quest.soakStage ~= nil and stage == quest.soakStage) then
		local due = self:getNumber(pPlayer, quest, "until")

		if (due ~= 0 and getTimestamp() >= due) then
			self:finishBleaching(pPlayer)
			return self:rawStage(pPlayer, quest)
		end
	end

	return stage
end

function trophyHuntsScreenPlay:setStage(pPlayer, quest, stage)
	self:setNumber(pPlayer, quest, "stage", stage)
end

function trophyHuntsScreenPlay:isActive(pPlayer, quest)
	local stage = self:getStage(pPlayer, quest)

	return stage > 0 and stage ~= quest.STAGE_DONE
end

function trophyHuntsScreenPlay:anyActive(pPlayer)
	return self:isActive(pPlayer, self.quests.blistmokRug)
		or self:isActive(pPlayer, self.quests.jundakSkull)
		or self:isActive(pPlayer, self.quests.xandankTrophey)
end

-- ====================================================================
-- Waypoints and messaging
--
-- There is no journal row for any of these three quests, so the .qst's
-- journalEntryTitle goes out as the waypoint name and its
-- journalEntryDescription as the waypoint description and a system message.
-- ====================================================================

function trophyHuntsScreenPlay:clearWaypoint(pPlayer, quest)
	local waypointID = self:getNumber(pPlayer, quest, "wp")

	if (waypointID == 0) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, self:key(quest, "wp"))
end

function trophyHuntsScreenPlay:setWaypoint(pPlayer, quest, name, description, x, y)
	self:clearWaypoint(pPlayer, quest)

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)

	self:setNumber(pPlayer, quest, "wp", waypointID)
end

function trophyHuntsScreenPlay:announce(pPlayer, title, description)
	if (title ~= nil and title ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(title)
	end

	if (description ~= nil and description ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(description)
	end
end

-- ====================================================================
-- Kill observer
--
-- One observer per player, shared by all three quests.  The 5th argument to
-- createObserver is the persistence flag; without it the counts stop after a
-- relog.
-- ====================================================================

function trophyHuntsScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "trophyHuntsScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function trophyHuntsScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "trophyHuntsScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function trophyHuntsScreenPlay:refreshKillObserver(pPlayer)
	if (self:anyActive(pPlayer)) then
		self:attachKillObserver(pPlayer)
	else
		self:detachKillObserver(pPlayer)
	end
end

function trophyHuntsScreenPlay:isPackMember(objectID)
	for i = 1, #self.packMemberIDs do
		if (self.packMemberIDs[i] == objectID) then
			return true
		end
	end

	return false
end

function trophyHuntsScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	local victimID = SceneObject(pVictim):getObjectID()
	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	self:creditUraJen(pPlayer, victimID)
	self:creditBlistmokSkin(pPlayer, victimTemplate)
	self:creditAncientJundak(pPlayer, victimID)
	self:creditPackLeader(pPlayer, victimID)
	self:creditPackMember(pPlayer, victimID, victimTemplate)

	return 0
end

-- ====================================================================
-- Area observer -- som_xandank_trophey tasks 16, 17, 20 and 25
-- ====================================================================

function trophyHuntsScreenPlay:notifyEnteredArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local role = self.areaByObjectID[SceneObject(pArea):getObjectID()]

	if (role == nil) then
		return 0
	end

	local pack = self.quests.xandankTrophey
	local stage = self:getStage(pPlayer, pack)

	if (role == "siteOne" and stage == pack.STAGE_SITE_ONE) then
		self:advanceXandank(pPlayer, pack.STAGE_SEARCH_ONE)
	elseif (role == "siteTwo" and stage == pack.STAGE_SITE_TWO) then
		self:advanceXandank(pPlayer, pack.STAGE_SEARCH_TWO)
	elseif (role == "den" and stage == pack.STAGE_DEN) then
		self:advanceXandank(pPlayer, pack.STAGE_FIGHT)
	elseif (role == "camp" and stage == pack.STAGE_RETURN) then
		self:turnInXandank(pPlayer)
	end

	return 0
end

-- ====================================================================
-- som_blistmok_rug
--
-- task 0  Nothing                    -- musicOnActivate only
-- task 3  Wait for Tasks             -- STAGE_GATHER, umbrella over 1 and 2
-- task 1  Destroy Multiple and Loot  -- 10 skins at 15%
-- task 2  Retrieve Item              -- 3 preservatives from the chem lockers
-- task 4  Destroy Multiple and Loot  -- Ura Jen
-- task 7  Reward                     -- item_tow_trophey_02_06
-- ====================================================================

function trophyHuntsScreenPlay:clearLockerFlags(pPlayer)
	local quest = self.quests.blistmokRug

	for i = 1, #self.chemLockers do
		deleteScreenPlayData(pPlayer, self.screenplayName, self:key(quest, "locker" .. self.chemLockers[i]))
	end
end

-- Entry point for whoever ends up granting this.  Nothing calls it yet.
function trophyHuntsScreenPlay:grantBlistmokRug(pPlayer)
	local quest = self.quests.blistmokRug

	if (pPlayer == nil or self:isActive(pPlayer, quest)) then
		return false
	end

	self:setStage(pPlayer, quest, quest.STAGE_GATHER)
	self:setNumber(pPlayer, quest, "skins", 0)
	self:setNumber(pPlayer, quest, "pres", 0)
	self:clearLockerFlags(pPlayer)
	self:attachKillObserver(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)
	self:announce(pPlayer, quest.title, quest.description)
	self:announce(pPlayer, quest.gatherTitle, quest.gatherDescription)
	self:announce(pPlayer, quest.skinTitle, quest.skinDescription)
	self:announce(pPlayer, quest.preservativeTitle, quest.preservativeDescription)

	return true
end

function trophyHuntsScreenPlay:creditBlistmokSkin(pPlayer, victimTemplate)
	local quest = self.quests.blistmokRug

	if (self:getStage(pPlayer, quest) ~= quest.STAGE_GATHER) then
		return
	end

	if (quest.skinTemplates[victimTemplate] ~= true) then
		return
	end

	local skins = self:getNumber(pPlayer, quest, "skins")

	if (skins >= quest.skinsRequired) then
		return
	end

	-- task 1, LootDropPercent 15.  A miss is silent -- the .qst has no line for it.
	if (getRandomNumber(1, 100) > quest.skinDropPercent) then
		return
	end

	skins = skins + 1
	self:setNumber(pPlayer, quest, "skins", skins)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
	CreatureObject(pPlayer):sendSystemMessage(quest.skinItemName .. " " .. skins .. "/" .. quest.skinsRequired)

	self:checkRugGathering(pPlayer)
end

-- Called from the chem locker radial.  One preservative per locker, because
-- task 2 says "You should only take a little from each camp so that the miners
-- do not run out" and "travel to at least three field camps".
function trophyHuntsScreenPlay:takePreservative(pPlayer, lockerID)
	local quest = self.quests.blistmokRug

	if (self:getStage(pPlayer, quest) ~= quest.STAGE_GATHER) then
		return
	end

	local count = self:getNumber(pPlayer, quest, "pres")

	if (count >= quest.preservativesRequired) then
		return
	end

	local flag = self:key(quest, "locker" .. lockerID)

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, flag)) or 0) == 1) then
		-- Written here, not quoted; the .qst has no refusal line.
		CreatureObject(pPlayer):sendSystemMessage("You have already taken preservative from this chemical locker.")
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, flag, "1")

	count = count + 1
	self:setNumber(pPlayer, quest, "pres", count)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
	CreatureObject(pPlayer):sendSystemMessage(quest.preservativeItemName .. " " .. count .. "/" .. quest.preservativesRequired)

	self:checkRugGathering(pPlayer)
end

-- task 3, Wait for Tasks: both legs done before the hunt for Ura Jen opens.
function trophyHuntsScreenPlay:checkRugGathering(pPlayer)
	local quest = self.quests.blistmokRug

	if (self:rawStage(pPlayer, quest) ~= quest.STAGE_GATHER) then
		return
	end

	if (self:getNumber(pPlayer, quest, "skins") < quest.skinsRequired) then
		return
	end

	if (self:getNumber(pPlayer, quest, "pres") < quest.preservativesRequired) then
		return
	end

	self:setStage(pPlayer, quest, quest.STAGE_URA_JEN)
	self:announce(pPlayer, quest.uraJenTitle, quest.uraJenDescription)
	-- task 4, createWaypoint true
	self:setWaypoint(pPlayer, quest, quest.uraJenWaypointName, quest.uraJenDescription, quest.uraJenX, quest.uraJenY)
end

function trophyHuntsScreenPlay:creditUraJen(pPlayer, victimID)
	local quest = self.quests.blistmokRug

	if (self:getStage(pPlayer, quest) ~= quest.STAGE_URA_JEN) then
		return
	end

	if (self.uraJenID == 0 or victimID ~= self.uraJenID) then
		return
	end

	-- task 4: LootItemName "Skin of Ura Jen", 1 at 100%
	CreatureObject(pPlayer):sendSystemMessage(quest.uraJenItemName .. " 1/1")
	self:clearWaypoint(pPlayer, quest)
	self:completeQuest(pPlayer, quest)
end

-- ====================================================================
-- som_jundak_skull
--
-- task 0  Nothing                    -- musicOnActivate only
-- task 1  Destroy Multiple and Loot  -- the ancient jundak
-- task 5  Wait for Signal            -- jundak_skull_signal_one, the vat radial
-- task 6  Wait for Signal            -- jundak_skull_signal_two, the soak elapsing
-- task 7  Reward                     -- item_tow_trophey_02_04
-- ====================================================================

-- Entry point for whoever ends up granting this.  Nothing calls it yet.
function trophyHuntsScreenPlay:grantJundakSkull(pPlayer)
	local quest = self.quests.jundakSkull

	if (pPlayer == nil or self:isActive(pPlayer, quest)) then
		return false
	end

	self:setStage(pPlayer, quest, quest.STAGE_HUNT)
	self:attachKillObserver(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)
	self:announce(pPlayer, quest.title, quest.description)
	self:announce(pPlayer, quest.huntTitle, quest.huntDescription)
	-- task 1, createWaypoint true
	self:setWaypoint(pPlayer, quest, quest.huntWaypointName, quest.huntDescription, quest.huntX, quest.huntY)

	return true
end

function trophyHuntsScreenPlay:creditAncientJundak(pPlayer, victimID)
	local quest = self.quests.jundakSkull

	if (self:getStage(pPlayer, quest) ~= quest.STAGE_HUNT) then
		return
	end

	if (self.ancientJundakID == 0 or victimID ~= self.ancientJundakID) then
		return
	end

	-- task 1: LootItemName "Jundak Skull", 1 at 100%
	CreatureObject(pPlayer):sendSystemMessage(quest.huntItemName .. " 1/1")
	self:clearWaypoint(pPlayer, quest)
	self:setStage(pPlayer, quest, quest.STAGE_BLEACH)
	self:announce(pPlayer, quest.bleachTitle, quest.bleachDescription)
end

-- task 5's signal: the player puts the skull in the vat.
function trophyHuntsScreenPlay:placeSkullInVat(pPlayer)
	local quest = self.quests.jundakSkull

	if (self:getStage(pPlayer, quest) ~= quest.STAGE_BLEACH) then
		return
	end

	self:setStage(pPlayer, quest, quest.STAGE_SOAK)
	self:setNumber(pPlayer, quest, "until", getTimestamp() + quest.soakSeconds)
	self:announce(pPlayer, quest.soakTitle, quest.soakDescription)

	createEvent(quest.soakSeconds * 1000, "trophyHuntsScreenPlay", "finishBleaching", pPlayer, "")
end

-- task 6's signal.  Reached both from the timer above and from the lazy settle
-- in getStage after a restart, so it must guard on rawStage or it recurses.
function trophyHuntsScreenPlay:finishBleaching(pPlayer)
	local quest = self.quests.jundakSkull

	if (pPlayer == nil or self:rawStage(pPlayer, quest) ~= quest.STAGE_SOAK) then
		return
	end

	self:setStage(pPlayer, quest, quest.STAGE_READY)
	deleteScreenPlayData(pPlayer, self.screenplayName, self:key(quest, "until"))

	-- Written here, not quoted; task 6 describes the wait but gives no line for
	-- the moment it ends.
	CreatureObject(pPlayer):sendSystemMessage("The skull is completely bleached.")
end

function trophyHuntsScreenPlay:takeBleachedSkull(pPlayer)
	local quest = self.quests.jundakSkull

	if (self:getStage(pPlayer, quest) ~= quest.STAGE_READY) then
		return
	end

	self:completeQuest(pPlayer, quest)
end

-- ====================================================================
-- som_xandank_trophey
--
-- task 15  Nothing                    -- musicOnActivate only
-- task 16  Go to Location             -- (-4780, 4474) r50
-- task 18  Wait for Signal            -- xandank_trophy_signal_one, trace radial
-- task 17  Go to Location             -- (-4361, 4474) r50
-- task 19  Wait for Signal            -- xandank_trophy_signal_two, trace radial
-- task 20  Go to Location             -- (-4586, 5104) r75, the den
-- task 22  Wait for Tasks             -- umbrella over 23 and 27
-- task 23  Destroy Multiple           -- 6 pack members
-- task 27  Destroy Multiple and Loot  -- the packleader's head
-- task 25  Wait for Signal            -- xandank_trophy_signal_three, back at camp
-- task 26  Reward                     -- item_tow_trophey_02_03
-- ====================================================================

function trophyHuntsScreenPlay:advanceXandank(pPlayer, stage)
	local quest = self.quests.xandankTrophey

	self:setStage(pPlayer, quest, stage)

	if (stage == quest.STAGE_SITE_ONE) then
		self:announce(pPlayer, quest.siteOneTitle, quest.siteOneDescription)
		self:setWaypoint(pPlayer, quest, quest.siteOneWaypointName, quest.siteOneDescription, quest.siteOneX, quest.siteOneY)
	elseif (stage == quest.STAGE_SEARCH_ONE) then
		self:clearWaypoint(pPlayer, quest)
		self:announce(pPlayer, quest.searchOneTitle, quest.searchOneDescription)
	elseif (stage == quest.STAGE_SITE_TWO) then
		self:announce(pPlayer, quest.siteTwoTitle, quest.siteTwoDescription)
		self:setWaypoint(pPlayer, quest, quest.siteTwoWaypointName, quest.siteTwoDescription, quest.siteTwoX, quest.siteTwoY)
	elseif (stage == quest.STAGE_SEARCH_TWO) then
		self:clearWaypoint(pPlayer, quest)
		self:announce(pPlayer, quest.searchTwoTitle, quest.searchTwoDescription)
	elseif (stage == quest.STAGE_DEN) then
		self:announce(pPlayer, quest.denTitle, quest.denDescription)
		self:setWaypoint(pPlayer, quest, quest.denWaypointName, quest.denDescription, quest.denX, quest.denY)
	elseif (stage == quest.STAGE_FIGHT) then
		self:clearWaypoint(pPlayer, quest)
		self:setNumber(pPlayer, quest, "kills", 0)
		self:setNumber(pPlayer, quest, "head", 0)
		self:announce(pPlayer, quest.fightTitle, quest.fightDescription)
		self:announce(pPlayer, quest.leaderTitle, quest.leaderDescription)
		self:announce(pPlayer, quest.packTitle, quest.packDescription)
	elseif (stage == quest.STAGE_RETURN) then
		-- task 25 sets showSystemMessages 0, so this leg is silent on purpose;
		-- its createWaypoint is true, so the waypoint is the direction.
		self:setWaypoint(pPlayer, quest, quest.returnWaypointName, quest.returnDescription, quest.returnX, quest.returnY)
	end
end

-- Entry point for whoever ends up granting this.  Nothing calls it yet.
function trophyHuntsScreenPlay:grantXandankTrophey(pPlayer)
	local quest = self.quests.xandankTrophey

	if (pPlayer == nil or self:isActive(pPlayer, quest)) then
		return false
	end

	self:setNumber(pPlayer, quest, "kills", 0)
	self:setNumber(pPlayer, quest, "head", 0)
	self:attachKillObserver(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)
	self:announce(pPlayer, quest.title, quest.description)
	self:advanceXandank(pPlayer, quest.STAGE_SITE_ONE)

	return true
end

-- tasks 18 and 19: the signal fires off the shipped xandank_lair props.
function trophyHuntsScreenPlay:searchTrace(pPlayer, role)
	local quest = self.quests.xandankTrophey
	local stage = self:getStage(pPlayer, quest)

	if (role == "packTrace1" and stage == quest.STAGE_SEARCH_ONE) then
		self:advanceXandank(pPlayer, quest.STAGE_SITE_TWO)
	elseif (role == "packTrace2" and stage == quest.STAGE_SEARCH_TWO) then
		self:advanceXandank(pPlayer, quest.STAGE_DEN)
	end
end

function trophyHuntsScreenPlay:creditPackLeader(pPlayer, victimID)
	local quest = self.quests.xandankTrophey

	if (self:getStage(pPlayer, quest) ~= quest.STAGE_FIGHT) then
		return
	end

	if (self.packLeaderID == 0 or victimID ~= self.packLeaderID) then
		return
	end

	if (self:getNumber(pPlayer, quest, "head") == 1) then
		return
	end

	self:setNumber(pPlayer, quest, "head", 1)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
	-- task 27: LootItemName "Head of the Packleader", 1 at 100%
	CreatureObject(pPlayer):sendSystemMessage(quest.leaderItemName .. " 1/1")

	self:checkPackFight(pPlayer)
end

function trophyHuntsScreenPlay:creditPackMember(pPlayer, victimID, victimTemplate)
	local quest = self.quests.xandankTrophey

	if (self:getStage(pPlayer, quest) ~= quest.STAGE_FIGHT) then
		return
	end

	-- The leader is not one of task 23's six.
	if (victimID == self.packLeaderID) then
		return
	end

	-- Prefer the recorded spawn ids; fall back to the template set so a spawn
	-- lost to a restart cannot strand this leg.
	if (not self:isPackMember(victimID) and quest.packTemplates[victimTemplate] ~= true) then
		return
	end

	local kills = self:getNumber(pPlayer, quest, "kills")

	if (kills >= quest.packRequired) then
		return
	end

	kills = kills + 1
	self:setNumber(pPlayer, quest, "kills", kills)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
	CreatureObject(pPlayer):sendSystemMessage(quest.packTitle .. " " .. kills .. "/" .. quest.packRequired)

	self:checkPackFight(pPlayer)
end

-- task 22, Wait for Tasks: the head and all six before the return leg opens.
function trophyHuntsScreenPlay:checkPackFight(pPlayer)
	local quest = self.quests.xandankTrophey

	if (self:rawStage(pPlayer, quest) ~= quest.STAGE_FIGHT) then
		return
	end

	if (self:getNumber(pPlayer, quest, "head") ~= 1) then
		return
	end

	if (self:getNumber(pPlayer, quest, "kills") < quest.packRequired) then
		return
	end

	self:advanceXandank(pPlayer, quest.STAGE_RETURN)
end

-- task 25's signal.  Fired by the camp active area, and exposed so a Renlo
-- conversation can fire it instead once there is one.
function trophyHuntsScreenPlay:turnInXandank(pPlayer)
	local quest = self.quests.xandankTrophey

	if (pPlayer == nil or self:getStage(pPlayer, quest) ~= quest.STAGE_RETURN) then
		return
	end

	self:completeQuest(pPlayer, quest)
end

-- ====================================================================
-- The Reward tasks
--
-- Bank Credits 0 and Experience Amount 0 in all three .qst files, so no
-- credits and no XP are granted.  [list] allowRepeats is true everywhere, so
-- STAGE_DONE is a record, not a lock -- the grant entry points reset from it.
-- ====================================================================

function trophyHuntsScreenPlay:completeQuest(pPlayer, quest)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("trophyHuntsScreenPlay: player has no inventory; " .. quest.rewardName .. " could not be handed over")
		return
	end

	if (giveItem(pInventory, quest.rewardItem, -1, true) == nil) then
		print("trophyHuntsScreenPlay: failed to create " .. quest.rewardItem)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for the " .. quest.rewardName .. ".")
		return
	end

	self:clearWaypoint(pPlayer, quest)
	self:setStage(pPlayer, quest, quest.STAGE_DONE)
	self:setNumber(pPlayer, quest, "runs", self:getNumber(pPlayer, quest, "runs") + 1)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)
	CreatureObject(pPlayer):sendSystemMessage("You have received the " .. quest.rewardName .. ".")

	self:refreshKillObserver(pPlayer)
end

--[[ Radial dispatch

One component table serves the five chem lockers, both xandank_lair traces and
the bleach vat.  SceneObjectImplementation::setObjectMenuComponent() falls
through to LuaObjectMenuComponent when no C++ component of that name is
registered, and LuaObjectMenuComponent replaces the object's menu entirely --
so fillObjectMenuResponse has to add every item we want to see, and adds
nothing at all when this player has no business touching the object.

Every radial label except one is the .qst's own wording: "Take Preservative" is
task 2's retrieveMenuText, "Search the Area" is tasks 18 and 19's
journalEntryTitle, "Bleach the Skull" is task 5's.  Only the label for taking
the skull back out is written here -- task 6 describes the wait but never names
that action.
--]]

TrophyHuntsMenuComponent = {}

function trophyHuntsScreenPlay:getRadialText(pPlayer, role)
	local rug = self.quests.blistmokRug
	local skull = self.quests.jundakSkull
	local pack = self.quests.xandankTrophey

	if (role == "chemLocker") then
		if (self:getStage(pPlayer, rug) == rug.STAGE_GATHER and self:getNumber(pPlayer, rug, "pres") < rug.preservativesRequired) then
			return rug.preservativeMenuText
		end
	elseif (role == "packTrace1") then
		if (self:getStage(pPlayer, pack) == pack.STAGE_SEARCH_ONE) then
			return pack.searchOneTitle
		end
	elseif (role == "packTrace2") then
		if (self:getStage(pPlayer, pack) == pack.STAGE_SEARCH_TWO) then
			return pack.searchTwoTitle
		end
	elseif (role == "bleachVat") then
		local stage = self:getStage(pPlayer, skull)

		if (stage == skull.STAGE_BLEACH) then
			return skull.bleachTitle
		elseif (stage == skull.STAGE_READY) then
			return "Remove the skull from the vat"
		end
	end

	return nil
end

function TrophyHuntsMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":trophyRole")
	local text = trophyHuntsScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function TrophyHuntsMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local objectID = SceneObject(pSceneObject):getObjectID()
	local role = readStringData(objectID .. ":trophyRole")

	if (role == "chemLocker") then
		trophyHuntsScreenPlay:takePreservative(pPlayer, objectID)
	elseif (role == "packTrace1" or role == "packTrace2") then
		trophyHuntsScreenPlay:searchTrace(pPlayer, role)
	elseif (role == "bleachVat") then
		local skull = trophyHuntsScreenPlay.quests.jundakSkull
		local stage = trophyHuntsScreenPlay:getStage(pPlayer, skull)

		if (stage == skull.STAGE_BLEACH) then
			trophyHuntsScreenPlay:placeSkullInVat(pPlayer)
		elseif (stage == skull.STAGE_READY) then
			trophyHuntsScreenPlay:takeBleachedSkull(pPlayer)
		end
	end

	return 0
end
