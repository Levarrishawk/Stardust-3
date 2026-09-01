--[[
	THE CELL MAP -- the one place Mustafar's facility cell ids are derived.

	Every Mensix placement in this tree is a cell id, and the ids are not
	guessable: the building is snapshot node 12112217 and its 30 cell children
	run 12112218..12112249 with 12112233 and 12112239 absent, so
	buildingID + cellIndex drifts by one past index 15 and by two past index 20.

	The map below is not inferred. It is the join of two files:

	  * appearance/thm_must_mining_outpost.pob -- the portal layout the building
	    template points at. Its CELS form holds 31 CELL records in order; record
	    0 is the exterior r0 and records 1..30 carry the cell names.
	  * snapshot/mustafar.ws -- node 12112217's 30 child NODE records, each
	    carrying its own object id and its cell index.

	PlanetManagerImplementation::loadSnapshotObject is what ties them: it creates
	each cell with objectID = the .ws node id and files it under the node's cell
	index, so POB record N is snapshot child index N is the id in this table.

	  1  main_entrance_01  12112218      16  small_room_03      12112234
	  2  main_entrance_02  12112219      17  hall_ramp_01       12112235
	  3  hall_junction_01  12112220      18  hub_room           12112236
	  4  hall_01           12112221      19  hall_05            12112237
	  5  entrance_room_01  12112222      20  small_room_04      12112238
	  6  connecting_hall   12112223      21  hall_06            12112240
	  7  entrance_room_02  12112224      22  conference_room    12112241
	  8  hall_junction_02  12112225      23  hall_07            12112242
	  9  medium_room_01    12112226      24  small_room_05      12112243
	 10  control_room_01   12112227      25  hall_08            12112244
	 11  small_room_01     12112228      26  control_room_02    12112245
	 12  hall_02           12112229      27  hall_09            12112246
	 13  hall_03           12112230      28  hall_10            12112247
	 14  hall_04           12112231      29  landing_deck_room  12112248
	 15  small_room_02     12112232      30  mountain_entrance  12112249

	medium_room_01 is the cantina, conference_room is Milo's office, and
	hub_room is the mining network floor. BuildingObject(pBuilding):getNamedCell
	resolves the same names at runtime and is the cross-check if the snapshot is
	ever re-cut; the ids are written out here so a spawn line stays one line.

	The building sits at (-2420.50, h 199.40, 1767.08) with an identity rotation,
	so a cell-local coordinate is simply world minus that origin. That is what
	makes the published Mensix waypoints line up with the table this file is
	placed from -- e.g. Chief Ulon Glost at /way 449 -1156 is cell-local
	(-9.5, 52.6) in entrance_room_01, and the junk dealer's /way height of 222
	is 199.40 + 22.7.
--]]

local ObjectManager = require("managers.object.object_manager")

mensix_mining_facility_main = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "mensix_mining_facility_main",

	-- Counters for the boot-log line at the end of start().  See placed() below.
	placedCount = 0,
	expectedCount = 15
}

registerScreenPlay("mensix_mining_facility_main", true)

--[[ THE PROOF THAT A PLACEMENT LANDED.

     spawnSceneObject and spawnMobile both return nil on failure and say nothing.
     An unregistered server template, a cell id that is not a cell, or a creature
     name with a typo all fail exactly that way -- silently, at boot, months before
     anyone walks into the room and notices the prop is missing.  This tree has
     already been bitten by the silent half of that three times (the Symbiosis
     sword, the Chu-Gon Dar cube and the som pet control devices were all
     unregistered server templates whose client halves resolved fine).

     So every placement added below goes through this, and start() prints the
     tally.  A shortfall is visible in the boot log on the line it happens, which
     is the same convention mustafar_dungeon_population.lua:456 uses and the same
     line that proved Sher Kar's twelve lair copies actually spawned. ]]
function mensix_mining_facility_main:placed(pObject, label)
	if (pObject == nil) then
		print("mensix_mining_facility_main: FAILED to place " .. label)
		return nil
	end

	self.placedCount = self.placedCount + 1
	return pObject
end

function mensix_mining_facility_main:start()
	if (isZoneEnabled("mustafar")) then
		writeData("mensix_mining_facility_main:travelerConvoInProgress", 0)
		writeData("mensix_mining_facility_main:travelerConvoState", 0)

		writeData("mensix_mining_facility_main:minerConvoInProgress", 0)
    writeData("mensix_mining_facility_main:minerConvoState", 0)

		self:spawnMobiles()
		self:spawnSceneObjects()
		self:startMinerConvo()
		self:startTravelerConvo()

		print("MensixMiningFacility: " .. self.placedCount .. " of " .. self.expectedCount .. " som_mining_facility.tab rows placed")
	end
end



--[[ THE PROPS -- five rows of som_mining_facility.tab this file never consumed.

     The table is the same one the NPCs above are placed from, and these rows sit
     in it alongside them.  They were left out, not ruled out: bleach_vat (row 26),
     mustafar_damaged_map (row 27), jundak_skull (row 24) and blistmok_rug (row 25)
     are all placed elsewhere in this tree from this same table, so the table was
     always trusted for props.  These five just had no arc asking for them.

     AXIS MAPPING, and it is the opposite of the one next door.  The table columns
     are loc_x / loc_y / loc_z / yaw, and loc_y is HEIGHT.  spawnSceneObject takes
     (zone, template, x, z, y, cellID, RADIANS) with z as height, so:

         repo x  <- loc_x        repo z  <- loc_y (height)
         repo y  <- loc_z        radians <- math.rad(yaw)

     math.rad is required here.  spawnMobile below takes DEGREES and the yaw goes
     across raw; spawnSceneObject does not.  Mixing the two is the single easiest
     mistake to make in this file, which is why both halves say so.

     Cell ids are from THE CELL MAP in the header -- control_room_01 12112227,
     control_room_02 12112245, small_room_01 12112228, medium_room_01 12112226.

     yaw is BLANK on four of the five rows.  Blank is not zero-by-guess: the .tab
     column is a float and an empty float field reads as 0, which is what the four
     unrotated props get.  Only the beads carry a real yaw (58).

     THE CROSS-CHECK, and it is a good one.  Three of these props were sighted by
     players and their /way figures are recorded in scratch/MUSTAFAR-GAPS.md.  Run
     those through the header's transform -- cell_x = way_x - 459.50 and
     cell_y = way_y + 1208.92, which is the Mustafar waypoint offset
     (-2880 / +2976) folded into the building origin (-2420.50, 1767.08) -- and
     they land on SOE's own rows:

         row 23  hologram     /way 386 -1080  ->  (-73.50, 128.92)  vs (-73.3, 128.1)  0.84 m
         row 29  tanray meat  /way 388 -1167  ->  (-71.50,  41.92)  vs (-71.3,  41.0)  0.94 m
         row 28  flea bounty  /way 379 -1245  ->  (-80.50, -36.08)  vs (-80.1, -35.8)  0.49 m

     Two independent sources -- a shipped datatable and players standing in the
     room years later -- agreeing under a metre, with /way rounded to whole metres
     in the first place.  That is what makes these placements transcription rather
     than a reading.  It also settles an identification that no filename gives:
     row 29 is `lava_lizard_food.iff`, and the only reason we know it is the Plate
     of Tanray Meat is that the tanray /way lands on it.

     The same check on row 24 (`jundak_skull`, already placed by trophy_hunts.lua)
     comes out at 3.22 m -- same room, same wall, looser.  Reported rather than
     hidden, because it is the one that does not tighten.

     WHAT THIS DOES NOT DO.  Three of these five -- the beads, the hologram and the
     lava_flea_bounty -- are the props a player would plausibly click to start the
     matching hunt in quest/bounty_hunts.lua, and that arc is still waiting on a
     giver (see its NO GIVER header).  Placing them does NOT wire them to it.  The
     table's `script` column is EMPTY on all five rows, so nothing in the shipped
     data says a click does anything, and grantHunt stays uncalled until Aaron says
     what the giver is.  These are props standing where SOE put them, no more. ]]
function mensix_mining_facility_main:spawnSceneObjects()

	-- Stardust Specific Droid:  Remove for other servers.
  spawnSceneObject("mustafar", "object/tangible/terminal/terminal_event_buffs.iff", -83.7, 10.3, 122, 12112227, math.rad(173) )

  -- row 16  control_room_02   -93 / 23.2 / -47.4  yaw 58.  Three metres from the
  -- junk dealer spawned below, which is the cross-check that 12112245 is right.
  self:placed(spawnSceneObject("mustafar", "object/tangible/item/som/lava_beetle_beads.iff", -93, 23.2, -47.4, 12112245, math.rad(58) ), "row 16 lava_beetle_beads")

  -- row 22  small_room_01     -120.7 / 10.8 / 122.1   yaw blank
  self:placed(spawnSceneObject("mustafar", "object/static/structure/general/cloning_tube.iff", -120.7, 10.8, 122.1, 12112228, 0 ), "row 22 cloning_tube")

  -- row 23  control_room_01   -73.3 / 10.8 / 128.1    yaw blank
  self:placed(spawnSceneObject("mustafar", "object/tangible/item/som/jundak_hunter_hologram.iff", -73.3, 10.8, 128.1, 12112227, 0 ), "row 23 jundak_hunter_hologram")

  -- row 28  control_room_02   -80.1 / 23.96 / -35.8   yaw blank
  self:placed(spawnSceneObject("mustafar", "object/tangible/item/som/lava_flea_bounty.iff", -80.1, 23.96, -35.8, 12112245, 0 ), "row 28 lava_flea_bounty")

  -- row 29  medium_room_01    -71.3 / 11.53 / 41      yaw blank.  This is the
  -- "Plate of Tanray Meat" -- see the cross-check in the header for why that
  -- identification is sourced and not a guess at the filename.
  self:placed(spawnSceneObject("mustafar", "object/tangible/item/som/lava_lizard_food.iff", -71.3, 11.53, 41, 12112226, 0 ), "row 29 lava_lizard_food")

end

function mensix_mining_facility_main:spawnMobiles()

    local pTraveler_m = spawnMobile("mustafar", "traveler_m",0,-2481,230.1,1633.7,-51,0)  -- -55.1,31.5,-120.3,-53,12112248  Original NGE Position (changed to outdoors due to spatialChat not working in cell)
      self:setMoodString(pTraveler_m, "npc_consoling")    
    local pTraveler_f = spawnMobile("mustafar", "traveler_f",0,-2483.1,230.1,1635.7,-90,0)  -- -56.5,31.5,-119.1,135,12112248 Original NGE Position (changed to outdoors due to spatialChat not working in cell)
      self:setMoodString(pTraveler_f, "angry")    
      
     writeData("mensix_mining_facility_main:traveler_m_objectID", SceneObject(pTraveler_m):getObjectID() )
     writeData("mensix_mining_facility_main:traveler_f_objectID", SceneObject(pTraveler_f):getObjectID() )    
     
     local pMiner1 = spawnMobile("mustafar", "mustafarian_miner_02",0,-2384.0,210.2,1809.9,-35,0)
     local pMiner2 = spawnMobile("mustafar", "mustafarian_miner_01",0,-2384.3,210.2,1813.2,165,0)
     local pMiner3 = spawnMobile("mustafar", "mustafarian_miner_01",0,-2387.6,210.2,1812.2,123,0)
     
     writeData("mensix_mining_facility_main:pMiner1_objectID", SceneObject(pMiner1):getObjectID() )
     writeData("mensix_mining_facility_main:pMiner2_objectID", SceneObject(pMiner2):getObjectID() )
     writeData("mensix_mining_facility_main:pMiner3_objectID", SceneObject(pMiner3):getObjectID() )
     
     -- Was "junk_dealer_mustafar", which is not a creature template anywhere in this tree --
     -- CreatureTemplateManager would fail the lookup and the facility's junk dealer simply
     -- never appeared. The Mustafar junk dealer template is must_junk
     -- (mobile/custom_content/som/must_junk.lua, customName "Junk Dealer").
     -- Live row: som_mustafarian_junk, control_room_02, -90 / 22.7 / -47.9, yaw 49.
     spawnMobile("mustafar", "must_junk",0,-90,22.7,-47.9,49,12112245)
     
     
     -- Background NPCs
     local pMiner_b1 = spawnMobile("mustafar", "mustafarian_miner_01",0,-82.4,23.2,-35.5,-3,12112245)
     self:setMoodString(pMiner_b1, "npc_use_terminal_high")  
     local pMiner_b2 = spawnMobile("mustafar", "mustafarian_miner_01",0,-154.4,19.1,-66.4,-158,12112243)
     self:setMoodString(pMiner_b2, "npc_use_terminal_high") 
     local pMiner_b3 = spawnMobile("mustafar", "mustafarian_miner_01",0,-78.8,14.9,1.7,88,12112236)
     self:setMoodString(pMiner_b3, "npc_use_terminal_high")
     local pMiner_b4 = spawnMobile("mustafar", "mustafarian_miner_01",0,-88.3,10.8,49.4,28,12112226)
     self:setMoodString(pMiner_b4, "entertained")
     local pMiner_b5 = spawnMobile("mustafar", "mustafarian_miner_01",0,-86.8,10.8,41.9,113,12112226)
     self:setMoodString(pMiner_b5, "entertained")
     local pMiner_b6 = spawnMobile("mustafar", "mustafarian_miner_01",0,-80.6,10.8,42.2,179,12112226)
     self:setMoodString(pMiner_b6, "npc_accusing")
     local pMiner_b7 = spawnMobile("mustafar", "mustafarian_miner_01",0,-81.1,10.8,39.7,1,12112226)
     self:setMoodString(pMiner_b7, "npc_accusing")
     
     -- Quest Givers.  Positions and headings are the live ones (see THE CELL MAP
     -- below for where the numbers come from); the mood column is empty on every
     -- one of these rows, so none of them gets a setMoodString.
     spawnMobile("mustafar", "pei_yi",0,-77.2,10.8,67.4,117,12112226)
     spawnMobile("mustafar", "diskret_stahn",0,-75.5,10.8,66.3,-85,12112226)

     spawnMobile("mustafar", "foreman_donko",0,-13.5,10.8,35,180,12112222)
     spawnMobile("mustafar", "urup_falco",0,-152.7,19.1,-17.4,-68,12112241)
     spawnMobile("mustafar", "chief_armstrong",0,-150,18.6,-61,0,12112243)
     spawnMobile("mustafar", "chief_glost",0,-9.5,10.8,52.6,90,12112222)

     --[[ THE REST OF THE TABLE.  Everything above came out of
          som_mining_facility.tab; so does everything below.  The rows below were
          simply never transcribed.  Nothing here is placed by eye and nothing here
          is read off a .ilf -- same standard as the block above it.

          spawnMobile takes heading in DEGREES, so yaw crosses unconverted.  That is
          the opposite of spawnSceneObjects() above.  Blank yaw reads 0.

          miner_a -> mustafarian_miner_01 and miner_b -> mustafarian_miner_02 is not
          a new mapping.  It is the one the seven background miners above already
          use: row 39 (miner_a, control_room_02, -82.3/23.2/-35.2) is pMiner_b1 and
          row 34 (miner_a, small_room_05) is pMiner_b2, both spawned as _01.  These
          seven rows are the ones that mapping never got applied to. ]]

     -- rows 44-46  hall_08  12112244.  The only three rows in the table with a real
     -- yaw on a background miner; the rest are blank.
     local pMiner_b8  = self:placed(spawnMobile("mustafar", "mustafarian_miner_02",0,-126.9,19.1,-44.6,50,12112244), "row 44 miner_b hall_08")
     self:setMoodString(pMiner_b8, "npc_accusing")
     local pMiner_b9  = self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-126,19.1,-41.8,-161,12112244), "row 45 miner_a hall_08")
     self:setMoodString(pMiner_b9, "npc_accusing")
     local pMiner_b10 = self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-124.3,19.1,-44,-95,12112244), "row 46 miner_a hall_08")
     self:setMoodString(pMiner_b10, "entertained")

     -- rows 52, 53  the two corridor miners.  hall_04 12112231, hall_03 12112230.
     self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-107.8,10.8,32.5,0,12112231), "row 52 miner_a hall_04")
     self:placed(spawnMobile("mustafar", "mustafarian_miner_02",0,-59.7,10.8,32.5,0,12112230), "row 53 miner_b hall_03")

     -- rows 68, 71  medium_room_01 12112226 -- the cantina.  Rows 69 and 70 of the
     -- same group are already up as pMiner_b6 and pMiner_b5; these two are the
     -- pair that was missed.
     local pMiner_b11 = self:placed(spawnMobile("mustafar", "mustafarian_miner_02",0,-85.6,10.8,39.6,0,12112226), "row 68 miner_b medium_room_01")
     self:setMoodString(pMiner_b11, "entertained")
     local pMiner_b12 = self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-94.3,10.8,55,0,12112226), "row 71 miner_a medium_room_01")
     self:setMoodString(pMiner_b12, "entertained")

     --[[ THE TWO MINING DROIDS -- rows 62 and 63, small_room_03 12112234.

          SUBSTITUTED, and this is the disclosure.  The table asks for
          som_mining_droid_fork and som_mining_droid_claw.  Neither exists as a
          template in this repo or anywhere in the extracted source; like the
          seventeen names in mustafar_dungeon_population.lua, they are strings in a
          table and nothing else.

          What this repo ships is must_mining_droid_mark_01 / _02 / _03 -- "Mark I /
          II / III Mining Droid".  Live has exactly three mining droid variants too:
          ground_spawning/types/mustafar/mining_droids.tab lists bucket, claw and
          fork.  Three for three.  But the two naming schemes describe different
          things -- an attachment versus a model generation -- so there is no
          mapping between them, and nothing in either tree supplies one.

          So: THE PLACEMENT IS SOURCED (room, coordinates, both rows verbatim) and
          WHICH MARK STANDS IN IS OURS.  The rule used is alphabetical against the
          live list, bucket/claw/fork -> mark_01/_02/_03, which is arbitrary but
          stated and reproducible rather than a coin toss left undocumented.  Same
          trade dungeon_population makes and says out loud: the encounter is real,
          the exact droid is not. ]]
     self:placed(spawnMobile("mustafar", "must_mining_droid_mark_03",0,-120.9,10.8,38.6,0,12112234), "row 62 mining_droid_fork -> mark_03")
     self:placed(spawnMobile("mustafar", "must_mining_droid_mark_02",0,-125.4,10.8,46.7,0,12112234), "row 63 mining_droid_claw -> mark_02")

     -- row 79  small_room_01 12112228, yaw -121.  clone_droid is a real registered
     -- template (mobile/custom_content/mobile/clone_droid.lua, included at
     -- mobile/custom_content/mobile/serverobjects.lua:166) -- no substitution.  It
     -- stands beside the cloning tube placed from row 22 in the same room.
     -- conversationTemplate is "" on the template, so it is silent by design.
     self:placed(spawnMobile("mustafar", "clone_droid",0,-104,10.8,126.6,-121,12112228), "row 79 clone_droid")

     --[[ NOT PLACED, and deliberately: the 30 object/tangible/npe/npe_node.iff rows.
          They are the NPE system's anchor markers, not content -- each one sits on
          top of a creature row to the centimetre (row 47 miner_a hub_room -94/14.9/3
          and row 48 npe_node hub_room -94/14.9/3 are the same point).  Core3 has no
          NPE node consumer, so placing 30 invisible objects would add nothing a
          player can see and nothing any code reads.  Skipped on purpose, recorded
          here so the next person does not re-derive it as a gap. ]]

end


function mensix_mining_facility_main:startTravelerConvo(pActiveArea1, pMovingObject, pPlayer, pTraveler_m, pTraveler_f)
  
   local pTraveler_f = getSceneObject(readData("mensix_mining_facility_main:traveler_f_objectID"))
   local pTraveler_m = getSceneObject(readData("mensix_mining_facility_main:traveler_m_objectID"))

   if not(readData("mensix_mining_facility_main:travelerConvoInProgress") == 1) then       
          writeData("mensix_mining_facility_main:travelerConvoInProgress", 1)
          createEvent(90 * 1000, "mensix_mining_facility_main", "touristConvoF1", pTraveler_f, "")
          createEvent(100 * 1000, "mensix_mining_facility_main", "touristConvoM1", pTraveler_m, "")
   else
      return 0
   end              
end






function mensix_mining_facility_main:touristConvoF1(pTraveler_f, pPlayer)
  
  local pTraveler_f = getSceneObject(readData("mensix_mining_facility_main:traveler_f_objectID"))
  
  if (readData("mensix_mining_facility_main:travelerConvoState") == 0) then
      spatialChat(pTraveler_f, "I cannot believe you took me to this flaming hunk of rock! What were you thinking? This world is a nightmare.")     
        writeData("mensix_mining_facility_main:travelerConvoState", 1)   
        createEvent(20 * 1000, "mensix_mining_facility_main", "touristConvoF2", pTraveler_f, "")  
  end
end

function mensix_mining_facility_main:touristConvoM1(pTraveler_m, pPlayer)
  
  local pTraveler_m = getSceneObject(readData("mensix_mining_facility_main:traveler_m_objectID"))
  
  if (readData("mensix_mining_facility_main:travelerConvoState") == 1) then
      spatialChat(pTraveler_m, "Please, Clarrisa, don't start. I thought this would be a nice change of pace for us. You said you wanted to go some place full of adventure and mystery. With all of the discoveries here on Mustafar I thought you would love it.")     
        writeData("mensix_mining_facility_main:travelerConvoState", 2)   
        createEvent(20 * 1000, "mensix_mining_facility_main", "touristConvoM2", pTraveler_m, "")   
  end
end

function mensix_mining_facility_main:touristConvoF2(pTraveler_f, pPlayer)
  
  local pTraveler_f = getSceneObject(readData("mensix_mining_facility_main:traveler_f_objectID"))
  
  if (readData("mensix_mining_facility_main:travelerConvoState") == 2) then
      spatialChat(pTraveler_f, "Adventure! When I said that, I meant we should go someplace nice like Naboo. You drag me half way across the galaxy to show me a burning rock! We are going to have a serious talk about your concept of adventure when we get home. Are you listening to me?")     
        writeData("mensix_mining_facility_main:travelerConvoState", 3)    
        createEvent(20 * 1000, "mensix_mining_facility_main", "touristConvoF3", pTraveler_f, "")  
  end
end

function mensix_mining_facility_main:touristConvoM2(pTraveler_m, pPlayer)
  
  local pTraveler_m = getSceneObject(readData("mensix_mining_facility_main:traveler_m_objectID"))
  
  if (readData("mensix_mining_facility_main:travelerConvoState") == 3) then
      spatialChat(pTraveler_m, "Of course dear. I was just trying to be exciting and unexpected for you. We could have explored some of those ruins and maybe make a discovery of our own.")     
        writeData("mensix_mining_facility_main:travelerConvoState", 4)  
        createEvent(22 * 1000, "mensix_mining_facility_main", "touristConvoM3", pTraveler_m, "")   
  end
end

function mensix_mining_facility_main:touristConvoF3(pTraveler_f, pPlayer)
  
  local pTraveler_f = getSceneObject(readData("mensix_mining_facility_main:traveler_f_objectID"))
  
  if (readData("mensix_mining_facility_main:travelerConvoState") == 4) then
      spatialChat(pTraveler_f, "Next time you want to be exciting...don't. I will not have any such foolishness like you digging around in the dirt like some grubby archeologist. What would people back home say? Now we are just going to wait until the next shuttle and never speak of this again. Is that understood?")     
        writeData("mensix_mining_facility_main:travelerConvoState", 5)           
  end
end

function mensix_mining_facility_main:touristConvoM3(pTraveler_m, pPlayer)
  
  local pTraveler_m = getSceneObject(readData("mensix_mining_facility_main:traveler_m_objectID"))
  
  if (readData("mensix_mining_facility_main:travelerConvoState") == 5) then
      spatialChat(pTraveler_m, "Yes, dear. Whatever you say.") 
        writeData("mensix_mining_facility_main:travelerConvoState", 0)   
        createEvent(6 * 100 * 1000, "mensix_mining_facility_main", "resetTravelerConvo", pTraveler_m, "")   
  end
end

function mensix_mining_facility_main:resetTravelerConvo(pPlayer, pTraveler_f, pTraveler_m)
    writeData("mensix_mining_facility_main:travelerConvoInProgress", 0)    
    self:startTravelerConvo()
end

-- Miner Jokes

function mensix_mining_facility_main:startMinerConvo(pActiveArea1, pMovingObject, pPlayer, pMiner1, pMiner2, pMiner3)
  
   local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
   local pMiner2 = getSceneObject(readData("mensix_mining_facility_main:pMiner2_objectID"))
   local pMiner3 = getSceneObject(readData("mensix_mining_facility_main:pMiner3_objectID"))

   if not(readData("mensix_mining_facility_main:minerConvoInProgress") == 1) then       
          writeData("mensix_mining_facility_main:minerConvoInProgress", 1)
          writeData("mensix_mining_facility_main:minerConvoState", 1)
          createEvent(90 * 1000, "mensix_mining_facility_main", "minerConvo_miner3_1", pMiner3, "")          
          createEvent(94 * 1000, "mensix_mining_facility_main", "minerConvo_miner1_1", pMiner1, "")
          createEvent(141 * 1000, "mensix_mining_facility_main", "minerConvo_miner2_1", pMiner2, "")
   else
      return 0
   end              
end

function mensix_mining_facility_main:minerConvo_miner3_1(pMiner3, pPlayer)
  
  local pMiner3 = getSceneObject(readData("mensix_mining_facility_main:pMiner3_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 1) then
      spatialChat(pMiner3, "Hey, do your impression of those human fellas.") --@must_joker:do_humans
        writeData("mensix_mining_facility_main:minerConvoState", 2)   
        createEvent(11 * 1000, "mensix_mining_facility_main", "minerConvo_miner3_2", pMiner3, "")   
  end
end

function mensix_mining_facility_main:minerConvo_miner1_1(pMiner1, pPlayer)
  
  local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 2) then
      spatialChat(pMiner1, "So you want to see what humans are like, eh? Well just you watch this...it is uncanny.") --@must_joker:alright_humans
        writeData("mensix_mining_facility_main:minerConvoState", 3)   
        createEvent(4 * 1000, "mensix_mining_facility_main", "minerConvo_miner1_2", pMiner1, "")   
  end
end

function mensix_mining_facility_main:minerConvo_miner1_2(pMiner1, pPlayer)
  
  local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 3) then
      spatialChat(pMiner1, "Hey look at me. I am human. I am so pretty. This lava is too hot for my tender pink skin. Oooo, it is a scary blistmok...help me...help me.") --@must_joker:i_am_human
        writeData("mensix_mining_facility_main:minerConvoState", 4)   
        createEvent(48 * 1000, "mensix_mining_facility_main", "minerConvo_miner1_3", pMiner1, "")   -- 43
  end
end

function mensix_mining_facility_main:minerConvo_miner3_2(pMiner3, pPlayer)
  
  local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
  local pMiner2 = getSceneObject(readData("mensix_mining_facility_main:pMiner2_objectID"))
  local pMiner3 = getSceneObject(readData("mensix_mining_facility_main:pMiner3_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 4) then
      spatialChat(pMiner3, "It is funny because it is true.") --@must_joker:i_love_that
      CreatureObject(pMiner1):doAnimation("emt_rofl")
      CreatureObject(pMiner2):doAnimation("emt_rofl")
      CreatureObject(pMiner3):doAnimation("emt_rofl")
        writeData("mensix_mining_facility_main:minerConvoState", 5)   
        createEvent(2 * 64 * 1000, "mensix_mining_facility_main", "minerConvo_miner3_3", pMiner3, "")   --
  end
end

function mensix_mining_facility_main:minerConvo_miner2_1(pMiner2, pPlayer)
  
  local pMiner2 = getSceneObject(readData("mensix_mining_facility_main:pMiner2_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 5) then
      spatialChat(pMiner2, "Hey, hey...now do a Wookiee.") --@must_joker:do_wookiee
        writeData("mensix_mining_facility_main:minerConvoState", 6)   
        createEvent(76 * 1000, "mensix_mining_facility_main", "minerConvo_miner2_2", pMiner2, "")   --76
  end
end

function mensix_mining_facility_main:minerConvo_miner1_3(pMiner1, pPlayer)
  
  local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
  local pMiner2 = getSceneObject(readData("mensix_mining_facility_main:pMiner2_objectID"))
  local pMiner3 = getSceneObject(readData("mensix_mining_facility_main:pMiner3_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 6) then
      spatialChat(pMiner1, "No way! Those walking furballs smell something fierce.") -- @must_joker:wookiee_smell
      CreatureObject(pMiner1):doAnimation("emt_rofl")
      CreatureObject(pMiner2):doAnimation("emt_rofl")
      CreatureObject(pMiner3):doAnimation("emt_rofl")
        writeData("mensix_mining_facility_main:minerConvoState", 7)   
        createEvent(45 * 1000, "mensix_mining_facility_main", "minerConvo_miner1_4", pMiner1, "")   -- 43
  end
end

function mensix_mining_facility_main:minerConvo_miner1_4(pMiner1, pPlayer)
  
  local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 7) then
      spatialChat(pMiner1, "Hey, guys. Watch this. I am going to do all those treasure hunters out in those ruins thinking they are going to get rich. Silly off-worlders...there are more credits floating in the lava pools than they will ever find in those dumb ruins.") --@must_joker:offworlders
        writeData("mensix_mining_facility_main:minerConvoState", 8)   
        createEvent(31 * 1000, "mensix_mining_facility_main", "minerConvo_miner1_5", pMiner1, "")   -- 43
  end
end

function mensix_mining_facility_main:minerConvo_miner2_2(pMiner2, pPlayer)
  
  local pMiner2 = getSceneObject(readData("mensix_mining_facility_main:pMiner2_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 8) then
      spatialChat(pMiner2, "I bet you can't do a Rodian.") --@must_joker:do_rodian
        writeData("mensix_mining_facility_main:minerConvoState", 9)   
       
  end
end

function mensix_mining_facility_main:minerConvo_miner1_5(pMiner1, pPlayer)
  
  local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 9) then
      spatialChat(pMiner1, "Hmmmmm...rodian eh? That could be a tough one...") --@must_joker:okay_rodian
        writeData("mensix_mining_facility_main:minerConvoState", 10)   
        createEvent(5 * 1000, "mensix_mining_facility_main", "minerConvo_miner1_6", pMiner1, "")   -- 43
  end
end

function mensix_mining_facility_main:minerConvo_miner1_6(pMiner1, pPlayer)
  
  local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 10) then
      spatialChat(pMiner1, "Hey everyone, I am Rodian.  Look at me with my skinny green legs and my flappy little lips. I am a scary bounty hunter...OoooOOooO. ") --@must_joker:i_am_rodian
        writeData("mensix_mining_facility_main:minerConvoState", 11)   
        createEvent(3 * 1000, "mensix_mining_facility_main", "minerConvo_miner1_7", pMiner1, "")   -- 43
  end
end

function mensix_mining_facility_main:minerConvo_miner3_3(pMiner3, pPlayer)
  
  local pMiner3 = getSceneObject(readData("mensix_mining_facility_main:pMiner3_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 11) then
      spatialChat(pMiner3, "I don't get it.") --@must_joker:i_dont_get_it
        writeData("mensix_mining_facility_main:minerConvoState", 12)   
        createEvent(9 * 1000, "mensix_mining_facility_main", "minerConvo_miner3_4", pMiner3, "")   --
  end
end

function mensix_mining_facility_main:minerConvo_miner1_7(pMiner1, pPlayer)
  
  local pMiner1 = getSceneObject(readData("mensix_mining_facility_main:pMiner1_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 12) then
      spatialChat(pMiner1, "Rodians are all yella...well green anyways. They are all supposed to be scary but how can you be scary with those weird things sticking out of your head?") --@must_joker:rodian_yellow
        writeData("mensix_mining_facility_main:minerConvoState", 13)   
       
  end
end

function mensix_mining_facility_main:minerConvo_miner3_4(pMiner3, pPlayer)
  
  local pMiner3 = getSceneObject(readData("mensix_mining_facility_main:pMiner3_objectID"))
  
  if (readData("mensix_mining_facility_main:minerConvoState") == 13) then
      spatialChat(pMiner3, "Oh...yeah...that was a good one...") --@must_joker:no_i_get_it
        writeData("mensix_mining_facility_main:minerConvoState", 0) 
        writeData("mensix_mining_facility_main:minerConvoInProgress", 0)   
        createEvent(3 * 100 * 1000, "mensix_mining_facility_main", "startMinerConvo", pMiner3, "")   
  end
end


