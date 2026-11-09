--[[
	Mensix cell indices come from appearance/thm_must_mining_outpost.pob.
	The table gives the legacy ID for each room. MustafarBuildout.objects
	resolves those keys to the native cells in mustafar_main_se.

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
	hub_room is the mining network floor.

	The building sits at (-2420.50, h 199.40, 1767.08) with an identity rotation,
	so a cell-local coordinate is simply world minus that origin. That is what
	makes the published Mensix waypoints line up with the table this file is
	placed from -- e.g. Chief Ulon Glost at /way 449 -1156 is cell-local
	(-9.5, 52.6) in entrance_room_01, and the junk dealer's /way height of 222
	is 199.40 + 22.7.
--]]

mensix_mining_facility_main = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "mensix_mining_facility_main",

	-- Counters for the boot-log line at the end of start().  See placed() below.
	placedCount = 0,
	expectedCount = 16
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
		if (getSceneObject(MustafarBuildout.objects[12112217]) == nil) then
			printLuaError("MensixMiningFacility: native building is missing")
			return
		end

		self:spawnMobiles()
		self:spawnSceneObjects()
		self:startAmbientSequences()

		if (self.placedCount == self.expectedCount) then
			print("MensixMiningFacility: screenplay loaded successfully")
		end
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

     WHAT THIS DOES.  Four of these five -- the beads, the hologram, the
     lava_flea_bounty and the lava_lizard_food -- are the static props a player
     clicks to start the matching hunt in quest/bounty_hunts.lua.  The table's
     `script` column is EMPTY on all five rows; that was a red herring.  On live
     the script is attached at the TEMPLATE level (.tpf), not the spawn-table
     level, and BountyHuntGiverMenuComponent.lua is that attach in this tree.
     Placement here is still just placement -- the click wiring lives on the
     templates. ]]
function mensix_mining_facility_main:spawnSceneObjects()

	-- Stardust Specific Droid:  Remove for other servers.
  spawnSceneObject("mustafar", "object/tangible/terminal/terminal_event_buffs.iff", -83.7, 10.3, 122, MustafarBuildout.objects[12112227], math.rad(173) )

  -- row 16  control_room_02   -93 / 23.2 / -47.4  yaw 58.  Three metres from the
  -- junk dealer spawned below, which is the cross-check that 12112245 is right.
  self:placed(spawnSceneObject("mustafar", "object/tangible/item/som/lava_beetle_beads.iff", -93, 23.2, -47.4, MustafarBuildout.objects[12112245], math.rad(58) ), "row 16 lava_beetle_beads")

  -- row 22  small_room_01     -120.7 / 10.8 / 122.1   yaw blank
  self:placed(spawnSceneObject("mustafar", "object/static/structure/general/cloning_tube.iff", -120.7, 10.8, 122.1, MustafarBuildout.objects[12112228], 0 ), "row 22 cloning_tube")

  -- row 23  control_room_01   -73.3 / 10.8 / 128.1    yaw blank
  self:placed(spawnSceneObject("mustafar", "object/tangible/item/som/jundak_hunter_hologram.iff", -73.3, 10.8, 128.1, MustafarBuildout.objects[12112227], 0 ), "row 23 jundak_hunter_hologram")

  -- row 28  control_room_02   -80.1 / 23.96 / -35.8   yaw blank
  self:placed(spawnSceneObject("mustafar", "object/tangible/item/som/lava_flea_bounty.iff", -80.1, 23.96, -35.8, MustafarBuildout.objects[12112245], 0 ), "row 28 lava_flea_bounty")

  -- row 29  medium_room_01    -71.3 / 11.53 / 41      yaw blank.  This is the
  -- "Plate of Tanray Meat" -- see the cross-check in the header for why that
  -- identification is sourced and not a guess at the filename.
  self:placed(spawnSceneObject("mustafar", "object/tangible/item/som/lava_lizard_food.iff", -71.3, 11.53, 41, MustafarBuildout.objects[12112226], 0 ), "row 29 lava_lizard_food")

end

function mensix_mining_facility_main:spawnMobiles()

    local landingDeck = MustafarBuildout.objects[12112248]
    self:registerAmbientActor("male_traveler", spawnMobile("mustafar", "traveler_m", 0, -55.1, 31.5, -120.3, -53, landingDeck))
    self:registerAmbientActor("female_traveler", spawnMobile("mustafar", "traveler_f", 0, -56.5, 31.5, -119.1, 135, landingDeck))

     -- Was "junk_dealer_mustafar", which is not a creature template anywhere in this tree --
     -- CreatureTemplateManager would fail the lookup and the facility's junk dealer simply
     -- never appeared. The Mustafar junk dealer template is must_junk
     -- (mobile/custom_content/som/must_junk.lua, customName "Junk Dealer").
     -- Live row: som_mustafarian_junk, control_room_02, -90 / 22.7 / -47.9, yaw 49.
     spawnMobile("mustafar", "must_junk",0,-90,22.7,-47.9,49,MustafarBuildout.objects[12112245])
     
     
     -- Background NPCs
     local pMiner_b1 = spawnMobile("mustafar", "mustafarian_miner_01",0,-82.3,23.2,-35.2,0,MustafarBuildout.objects[12112245])
     self:registerAmbientActor("waiting1", pMiner_b1)
     local pMiner_b2 = spawnMobile("mustafar", "mustafarian_miner_01",0,-154.8,19.1,-66.6,0,MustafarBuildout.objects[12112243])
     self:registerAmbientActor("technician1", pMiner_b2)
     local pMiner_b5 = spawnMobile("mustafar", "mustafarian_miner_01",0,-86.7,10.8,41.8,0,MustafarBuildout.objects[12112226])
     self:registerAmbientActor("patron2", pMiner_b5)
     local pMiner_b6 = spawnMobile("mustafar", "mustafarian_miner_01",0,-80.6,10.8,41.9,0,MustafarBuildout.objects[12112226])
     self:registerAmbientActor("patron1", pMiner_b6)
     -- Quest Givers.  Positions and headings are the live ones (see THE CELL MAP
     -- below for where the numbers come from); the mood column is empty on every
     -- one of these rows, so none of them gets a setMoodString.
     spawnMobile("mustafar", "pei_yi",0,-77.2,10.8,67.4,117,MustafarBuildout.objects[12112226])
     spawnMobile("mustafar", "diskret_stahn",0,-75.5,10.8,66.3,-85,MustafarBuildout.objects[12112226])

     spawnMobile("mustafar", "foreman_donko",0,-13.5,10.8,35,180,MustafarBuildout.objects[12112222])
     spawnMobile("mustafar", "urup_falco",0,-152.7,19.1,-17.4,-68,MustafarBuildout.objects[12112241])
     spawnMobile("mustafar", "chief_armstrong",0,-150,18.6,-61,0,MustafarBuildout.objects[12112243])
     spawnMobile("mustafar", "chief_glost",0,-9.5,10.8,52.6,90,MustafarBuildout.objects[12112222])

     -- rows 44-46  hall_08  12112244.  The only three rows in the table with a real
     -- yaw on a background miner; the rest are blank.
     local pMiner_b8  = self:placed(spawnMobile("mustafar", "mustafarian_miner_02",0,-126.9,19.1,-44.6,50,MustafarBuildout.objects[12112244]), "row 44 miner_b hall_08")
     self:registerAmbientActor("joker1", pMiner_b8)
     local pMiner_b9  = self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-126,19.1,-41.8,-161,MustafarBuildout.objects[12112244]), "row 45 miner_a hall_08")
     self:registerAmbientActor("joker2", pMiner_b9)
     local pMiner_b10 = self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-124.3,19.1,-44,-95,MustafarBuildout.objects[12112244]), "row 46 miner_a hall_08")
     self:registerAmbientActor("joker3", pMiner_b10)

     -- Row 47, hub room miner.
     local pMiner_b13 = self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-94,14.9,3,-90,MustafarBuildout.objects[12112236]), "row 47 miner_a hub_room")
     self:registerAmbientActor("miner1", pMiner_b13)

     -- rows 52, 53  the two corridor miners.  hall_04 12112231, hall_03 12112230.
     self:registerAmbientActor("patrol1", self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-107.8,10.8,32.5,0,MustafarBuildout.objects[12112231]), "row 52 miner_a hall_04"))
     self:registerAmbientActor("patrol2", self:placed(spawnMobile("mustafar", "mustafarian_miner_02",0,-59.7,10.8,32.5,0,MustafarBuildout.objects[12112230]), "row 53 miner_b hall_03"))

     -- rows 68, 71  medium_room_01 12112226 -- the cantina.  Rows 69 and 70 of the
     -- same group are already up as pMiner_b6 and pMiner_b5; these two are the
     -- pair that was missed.
     local pMiner_b11 = self:placed(spawnMobile("mustafar", "mustafarian_miner_02",0,-85.6,10.8,39.6,0,MustafarBuildout.objects[12112226]), "row 68 miner_b medium_room_01")
     self:registerAmbientActor("bartender", pMiner_b11)
     local pMiner_b12 = self:placed(spawnMobile("mustafar", "mustafarian_miner_01",0,-94.3,10.8,55,0,MustafarBuildout.objects[12112226]), "row 71 miner_a medium_room_01")
     self:registerAmbientActor("drunk1", pMiner_b12)

     -- DSRC mob/creatures.tab assigns Mark III to fork and Mark II to claw.
     self:registerAmbientActor("droid2", self:placed(spawnMobile("mustafar", "must_mining_droid_mark_03",0,-120.9,10.8,38.6,0,MustafarBuildout.objects[12112234]), "row 62 mining_droid_fork -> mark_03"))
     self:registerAmbientActor("droid3", self:placed(spawnMobile("mustafar", "must_mining_droid_mark_02",0,-125.4,10.8,46.7,0,MustafarBuildout.objects[12112234]), "row 63 mining_droid_claw -> mark_02"))

     -- row 79  small_room_01 12112228, yaw -121.  clone_droid is a real registered
     -- template (mobile/custom_content/mobile/clone_droid.lua, included at
     -- mobile/custom_content/mobile/serverobjects.lua:166) -- no substitution.  It
     -- stands beside the cloning tube placed from row 22 in the same room.
     -- conversationTemplate is "" on the template, so it is silent by design.
     self:placed(spawnMobile("mustafar", "clone_droid",0,-104,10.8,126.6,-121,MustafarBuildout.objects[12112228]), "row 79 clone_droid")


end

-- Positions of the sequencer targets in spawning/dungeon/som_mining_facility.tab.
local ambientTargets = {
	traveler_object = { "landing_deck_room", -58.5, 31.5, -119.1 },
	patrol_rt1 = { "hall_04", -107.8, 10.8, 32.5 },
	patrol_rt2 = { "hall_03", -59.7, 10.8, 32.5 },
	patrol_rt3 = { "hall_junction_01", -59.6, 10.8, 63.8 },
	patrol_rt4 = { "hall_junction_01", -44, 10.8, 64.4 },
	patrol_rt5 = { "hall_01", -44, 10.8, 90.8 },
	patrol_rt6 = { "hall_02", -107.8, 10.8, 90.8 },
	patrol_mt1 = { "hall_junction_02", -85.4, 10.8, 90.7 },
	patrol_mt2 = { "hall_junction_02", -82, 10.8, 90.5 },
	tech_face1 = { "small_room_05", -154.8, 19.1, -67.2 },
	tech_face2 = { "small_room_05", -140, 19.1, -62.7 },
	tech_goto2 = { "small_room_05", -154.8, 19.1, -66.5 },
	tech_goto1 = { "small_room_05", -140, 19.1, -63.3 },
	wait_goto1 = { "control_room_02", -82.3, 23.2, -35.4 },
	wait_faceto1 = { "control_room_02", -82.3, 23.2, -34.7 },
	wait_faceto2 = { "control_room_02", -77.8, 23.2, -52.3 },
	wait_goto2 = { "control_room_02", -77.8, 23.2, -51.7 },
	miner1_go1 = { "hub_room", -94, 14.9, 3 },
	miner1_face1 = { "hub_room", -94.9, 14.9, 2.98 },
	miner1_go2 = { "hub_room", -78.4, 14.9, 1.7 },
	miner1_face2 = { "hub_room", -78.3, 14.9, 0.97 },
	droid2_go1 = { "small_room_03", -120.9, 10.8, 38.6 },
	droid2_go2 = { "small_room_03", -121.6, 10.3, 43.1 },
	droid2_go3 = { "small_room_03", -121.8, 10.3, 46.7 },
	droid2_go4 = { "small_room_03", -125.4, 10.8, 52 },
	bar1 = { "medium_room_01", -85.6, 10.8, 39.6 },
	bar2 = { "medium_room_01", -80.6, 10.8, 39.6 },
	drunk_go1 = { "medium_room_01", -94.3, 10.8, 55 },
	drunk_go2 = { "medium_room_01", -83.8, 11.3, 49.7 },
	drunk_face1 = { "medium_room_01", -83.9, 11.3, 50.9 },
}

-- Times and actions from datatables/sequencer/event_sequence.
local ambientSequences = {
	must_joker = {
		{ 9000, "joker3", "faceTo", "joker1" },
		{ 10000, "joker2", "faceTo", "joker1" },
		{ 11000, "joker3", "say", "do_humans" },
		{ 14000, "joker1", "say", "alright_humans" },
		{ 17000, "joker1", "animation", "curtsey" },
		{ 17100, "joker1", "say", "i_am_human" },
		{ 20000, "joker1", "animation", "scared" },
		{ 20100, "joker2", "animation", "laugh" },
		{ 20200, "joker3", "animation", "laugh_pointing" },
		{ 20500, "joker3", "say", "i_love_that" },
		{ 60000, "joker2", "say", "do_wookiee" },
		{ 64000, "joker1", "animation", "hold_nose" },
		{ 64100, "joker1", "say", "wookiee_smell" },
		{ 65000, "joker2", "animation", "belly_laugh" },
		{ 65100, "joker3", "animation", "rofl" },
		{ 120000, "joker1", "animation", "mock" },
		{ 120100, "joker1", "say", "offworlders" },
		{ 121000, "joker2", "animation", "laugh_cackle" },
		{ 121100, "joker3", "animation", "laugh_cackle" },
		{ 124000, "joker1", "animation", "smackbottom" },
		{ 125000, "joker2", "animation", "laugh_cackle" },
		{ 125100, "joker3", "animation", "laugh" },
		{ 128000, "joker1", "animation", "loser" },
		{ 129000, "joker2", "animation", "rofl" },
		{ 129100, "joker3", "animation", "rofl" },
		{ 130000, "joker1", "animation", "rofl" },
		{ 145000, "joker2", "say", "do_rodian" },
		{ 145100, "joker2", "animation", "point_forward" },
		{ 145500, "joker3", "animation", "nod_head_multiple" },
		{ 150000, "joker1", "say", "okay_rodian" },
		{ 150100, "joker1", "animation", "rub_chin_thoughtful" },
		{ 152000, "joker1", "animation", "chicken" },
		{ 152100, "joker1", "say", "i_am_rodian" },
		{ 152200, "joker3", "animation", "belly_laugh" },
		{ 153000, "joker2", "animation", "wft" },
		{ 155000, "joker2", "say", "i_dont_get_it" },
		{ 159000, "joker1", "animation", "smack_self" },
		{ 159100, "joker1", "say", "rodian_yellow" },
		{ 163000, "joker2", "animation", "laugh_titter" },
		{ 163100, "joker2", "say", "no_i_get_it" },
		{ 300000 },
	},
	must_mining_traveler = {
		{ 9000, "female_traveler", "faceTo", "male_traveler" },
		{ 10000, "female_traveler", "animation", "point_accusingly" },
		{ 10100, "female_traveler", "say", "cant_believe" },
		{ 20000, "male_traveler", "say", "do_not_start" },
		{ 20100, "male_traveler", "animation", "standing_placate" },
		{ 30000, "female_traveler", "animation", "wave_finger_warning" },
		{ 30100, "female_traveler", "say", "want_to_leave" },
		{ 40000, "male_traveler", "animation", "sigh_deeply" },
		{ 40100, "male_traveler", "say", "of_course_dear" },
		{ 50000, "female_traveler", "animation", "wave_finger_warning" },
		{ 50100, "female_traveler", "say", "we_better" },
		{ 53000, "female_traveler", "faceTo", "traveler_object" },
		{ 59000, "female_traveler", "setAnimationMood", "angry" },
		{ 60000, "male_traveler", "say", "yes_dear" },
		{ 60100, "male_traveler", "animation", "sigh_deeply" },
		{ 70000, "male_traveler", "setAnimationMood", "sorry" },
		{ 100000, "male_traveler", "animation", "implore" },
		{ 200000, "male_traveler", "animation", "implore" },
		{ 300000, "male_traveler", "animation", "implore" },
		{ 400000, "male_traveler", "animation", "implore" },
		{ 500000, "male_traveler", "animation", "implore" },
		{ 600000 },
	},
	must_miner_patrol = {
		{ 5000, "patrol2", "moveTo", "patrol_rt3" },
		{ 9000, "patrol1", "moveTo", "patrol_rt6" },
		{ 20000, "patrol2", "moveTo", "patrol_rt4" },
		{ 35000, "patrol2", "moveTo", "patrol_rt5" },
		{ 45000, "patrol1", "faceTo", "patrol_mt2" },
		{ 46000, "patrol1", "animation", "tap_foot" },
		{ 63000, "patrol1", "moveTo", "patrol_mt1" },
		{ 63100, "patrol2", "moveTo", "patrol_mt2" },
		{ 83000, "patrol1", "faceTo", "patrol_mt2" },
		{ 83100, "patrol2", "faceTo", "patrol_mt1" },
		{ 83500, "patrol1", "say", "hi" },
		{ 83600, "patrol1", "animation", "wave1" },
		{ 84000, "patrol2", "animation", "greet" },
		{ 89000, "patrol2", "say", "hows_work" },
		{ 94000, "patrol1", "animation", "shrug_hands" },
		{ 94100, "patrol1", "say", "same" },
		{ 99000, "patrol2", "say", "obi_wan" },
		{ 99100, "patrol2", "animation", "nervous" },
		{ 105000, "patrol1", "animation", "stop" },
		{ 105100, "patrol1", "say", "not_again" },
		{ 110000, "patrol2", "animation", "explain" },
		{ 110100, "patrol2", "say", "no_really" },
		{ 111000, "patrol1", "animation", "yawn" },
		{ 115000, "patrol1", "animation", "cuckoo" },
		{ 115100, "patrol1", "say", "you_are_crazy" },
		{ 120000, "patrol1", "moveTo", "patrol_rt6" },
		{ 122000, "patrol2", "animation", "sigh_deeply" },
		{ 125000, "patrol2", "moveTo", "patrol_rt5" },
		{ 145000, "patrol1", "moveTo", "patrol_rt1" },
		{ 150000, "patrol2", "moveTo", "patrol_rt4" },
		{ 170000, "patrol2", "moveTo", "patrol_rt3" },
		{ 185000, "patrol2", "moveTo", "patrol_rt2" },
		{ 195000, "patrol1", "faceTo", "patrol_rt6" },
		{ 200000, "patrol1", "animation", "tap_foot" },
		{ 210000, "patrol2", "faceTo", "patrol_rt3" },
		{ 210100, "patrol1", "animation", "tap_foot" },
		{ 215000, "patrol2", "animation", "check_wrist_device" },
		{ 220000 },
	},
	must_miner1 = {
		{ 5000, "miner1", "faceTo", "miner1_face1" },
		{ 8000, "miner1", "animation", "manipulate_medium" },
		{ 13000, "miner1", "animation", "manipulate_medium" },
		{ 18000, "miner1", "animation", "scream" },
		{ 23000, "miner1", "animation", "door_pound" },
		{ 27000, "miner1", "effect", "clienteffect/trap_electric_01.cef" },
		{ 27500, "miner1", "animation", "gesticulate_wildly" },
		{ 32000, "miner1", "animation", "pet_creature_medium" },
		{ 37000, "miner1", "animation", "sweat" },
		{ 42000, "miner1", "animation", "threaten" },
		{ 47000, "miner1", "animation", "giveup" },
		{ 52000, "miner1", "moveTo", "miner1_go2" },
		{ 65000, "miner1", "faceTo", "miner1_face2" },
		{ 68000, "miner1", "animation", "manipulate_medium" },
		{ 78000, "miner1", "animation", "manipulate_medium" },
		{ 88000, "miner1", "animation", "manipulate_medium" },
		{ 98000, "miner1", "animation", "manipulate_medium" },
		{ 108000, "miner1", "animation", "manipulate_medium" },
		{ 128000, "miner1", "animation", "manipulate_medium" },
		{ 148000, "miner1", "animation", "manipulate_medium" },
		{ 188000, "miner1", "animation", "manipulate_medium" },
		{ 250000, "miner1", "animation", "manipulate_medium" },
		{ 275000, "miner1", "animation", "manipulate_medium" },
		{ 300000, "miner1", "animation", "manipulate_medium" },
		{ 350000, "miner1", "animation", "manipulate_medium" },
		{ 400000, "miner1", "animation", "manipulate_medium" },
		{ 450000, "miner1", "moveTo", "miner1_go1" },
		{ 465000 },
	},
	must_waiting_one = {
		{ 9000, "waiting1", "faceTo", "wait_faceto1" },
		{ 10000, "waiting1", "animation", "manipulate_medium" },
		{ 25000, "waiting1", "animation", "manipulate_medium" },
		{ 45000, "waiting1", "animation", "manipulate_medium" },
		{ 65000, "waiting1", "animation", "manipulate_medium" },
		{ 80000, "waiting1", "animation", "manipulate_medium" },
		{ 95000, "waiting1", "animation", "manipulate_medium" },
		{ 120000, "waiting1", "animation", "manipulate_medium" },
		{ 130000, "waiting1", "animation", "check_wrist_device" },
		{ 134000, "waiting1", "moveTo", "wait_goto2" },
		{ 144000, "waiting1", "faceTo", "wait_faceto2" },
		{ 150000, "waiting1", "animation", "manipulate_medium" },
		{ 165000, "waiting1", "animation", "manipulate_medium" },
		{ 180000, "waiting1", "animation", "manipulate_medium" },
		{ 195000, "waiting1", "animation", "manipulate_medium" },
		{ 210000, "waiting1", "animation", "manipulate_medium" },
		{ 235000, "waiting1", "animation", "manipulate_medium" },
		{ 250000, "waiting1", "animation", "manipulate_medium" },
		{ 265000, "waiting1", "animation", "check_wrist_device" },
		{ 270000, "waiting1", "", "wait_goto1" },
		{ 271000 },
	},
	must_technician_one = {
		{ 5000, "technician1", "faceTo", "tech_face1" },
		{ 10000, "technician1", "animation", "manipulate_medium" },
		{ 15000, "technician1", "animation", "manipulate_medium" },
		{ 20000, "technician1", "animation", "manipulate_medium" },
		{ 25000, "technician1", "animation", "manipulate_medium" },
		{ 35000, "technician1", "animation", "manipulate_medium" },
		{ 38000, "technician1", "animation", "rub_chin_thoughtful" },
		{ 40000, "technician1", "moveTo", "tech_goto1" },
		{ 49000, "technician1", "faceTo", "tech_face2" },
		{ 52000, "technician1", "animation", "manipulate_medium" },
		{ 55000, "technician1", "animation", "manipulate_medium" },
		{ 60000, "technician1", "animation", "manipulate_medium" },
		{ 65000, "technician1", "animation", "manipulate_medium" },
		{ 70000, "technician1", "animation", "manipulate_medium" },
		{ 75000, "technician1", "animation", "manipulate_medium" },
		{ 80000, "technician1", "animation", "rub_chin_thoughtful" },
		{ 83000, "technician1", "moveTo", "tech_goto2" },
		{ 88000 },
	},
	must_droid2 = {
		{ 5000, "droid2", "moveTo", "droid2_go2" },
		{ 30000, "droid3", "moveTo", "droid2_go4" },
		{ 30500, "droid2", "moveTo", "droid2_go1" },
		{ 60000, "droid3", "moveTo", "droid2_go3" },
		{ 60500 },
	},
	must_cantina1 = {
		{ 5000, "bartender", "faceTo", "patron1" },
		{ 6000, "bartender", "animation", "thumb_up" },
		{ 8000, "patron1", "animation", "nod_head_multiple" },
		{ 10000, "bartender", "animation", "point_forward" },
		{ 14000, "bartender", "animation", "expect_tip" },
		{ 14500, "patron1", "animation", "point_forward" },
		{ 18000, "patron2", "faceTo", "bartender" },
		{ 19000, "patron2", "animation", "wave1" },
		{ 19500, "bartender", "animation", "explain" },
		{ 20000, "patron1", "animation", "listen" },
		{ 22000, "patron2", "animation", "wave1" },
		{ 23000, "bartender", "animation", "airguitar" },
		{ 23500, "patron1", "animation", "laugh" },
		{ 24000, "patron2", "animation", "stamp_feet" },
		{ 27000, "patron1", "animation", "rub_belly" },
		{ 27500, "bartender", "animation", "laugh" },
		{ 29000, "patron2", "animation", "beckon" },
		{ 31000, "bartender", "animation", "explain" },
		{ 31500, "patron1", "animation", "listen" },
		{ 33000, "patron1", "animation", "laugh" },
		{ 33100, "patron2", "animation", "scream" },
		{ 34000, "bartender", "faceTo", "patron2" },
		{ 34100, "patron1", "faceTo", "patron2" },
		{ 35000, "bartender", "animation", "point_accusingly" },
		{ 39000, "patron2", "animation", "apologize" },
		{ 40000, "bartender", "moveTo", "bar1" },
		{ 44000, "bartender", "faceTo", "patron2" },
		{ 46000, "patron2", "faceTo", "bartender" },
		{ 47000, "patron1", "animation", "loser" },
		{ 48000, "patron2", "animation", "explain" },
		{ 51000, "bartender", "animation", "shake_head_no" },
		{ 53000, "patron2", "animation", "explain" },
		{ 54000, "patron1", "animation", "mock" },
		{ 57000, "bartender", "animation", "shake_head_no" },
		{ 60000, "patron2", "animation", "shrug_hands" },
		{ 62000, "bartender", "animation", "shakefist" },
		{ 63000, "patron1", "animation", "belly_laugh" },
		{ 67000, "bartender", "moveTo", "bar2" },
		{ 68000, "patron2", "animation", "weeping" },
		{ 71000, "bartender", "faceTo", "patron1" },
		{ 71500, "patron1", "faceTo", "bartender" },
		{ 75000 },
	},
	must_cantina2 = {
		{ 5000, "drunk1", "animation", "tap_foot" },
		{ 8000, "drunk1", "animation", "nod_head_multiple" },
		{ 12000, "drunk1", "animation", "celebrate" },
		{ 15000, "drunk1", "animation", "snap_finger1" },
		{ 18000, "drunk1", "animation", "clap_rousing" },
		{ 24000, "drunk1", "moveTo", "drunk_go2" },
		{ 30000, "drunk1", "faceTo", "drunk_face1" },
		{ 32000, "drunk1", "animation", "nod_head_multiple" },
		{ 34000, "drunk1", "animation", "point_to_self" },
		{ 38000, "drunk1", "animation", "bounce" },
		{ 43000, "drunk1", "animation", "airguitar" },
		{ 47000, "drunk1", "animation", "bounce" },
		{ 51000, "drunk1", "animation", "bump" },
		{ 55000, "drunk1", "animation", "celebrate" },
		{ 59000, "drunk1", "animation", "clap_rousing" },
		{ 63000, "drunk1", "animation", "nervous" },
		{ 67000, "drunk1", "animation", "embarrassed" },
		{ 70000, "drunk1", "moveTo", "drunk_go1" },
		{ 76000, "drunk1", "faceTo", "drunk_face1" },
		{ 120000 },
	},
}

local ambientMovers = {
	bartender = true,
	droid2 = true,
	droid3 = true,
	drunk1 = true,
	miner1 = true,
	patrol1 = true,
	patrol2 = true,
	technician1 = true,
	waiting1 = true,
}

function mensix_mining_facility_main:registerAmbientActor(name, pActor)
	if (pActor ~= nil) then
		writeData("mensixAmbient:" .. name, SceneObject(pActor):getObjectID())
		if (ambientMovers[name]) then
			AiAgent(pActor):setAITemplate()
		end
	end
end

function mensix_mining_facility_main:startAmbientSequences()
	for name, sequence in pairs(ambientSequences) do
		createEvent(sequence[1][1], self.screenplayName, "ambientStep", nil, name .. ":1")
	end
end

function mensix_mining_facility_main:ambientStep(pUnused, args)
	local name, index = string.match(args or "", "^([%w_]+):(%d+)$")
	local sequence = ambientSequences[name]
	index = tonumber(index)
	local step = sequence and sequence[index]
	if (step == nil) then
		return
	end

	local time, actor, action, arg = step[1], step[2], step[3], step[4]
	if (actor == nil) then
		createEvent(sequence[1][1], self.screenplayName, "ambientStep", nil, name .. ":1")
		return
	end

	local pActor = getSceneObject(readData("mensixAmbient:" .. actor))
	if (pActor ~= nil and SceneObject(pActor):getZoneName() == "mustafar" and not CreatureObject(pActor):isDead()) then
		self:performAmbientAction(name, pActor, action, arg)
	end

	local nextStep = sequence[index + 1]
	createEvent(nextStep[1] - time, self.screenplayName, "ambientStep", nil, name .. ":" .. (index + 1))
end

function mensix_mining_facility_main:performAmbientAction(sequence, pActor, action, arg)
	if (action == "say") then
		spatialChat(pActor, "@" .. sequence .. ":" .. arg)
	elseif (action == "animation") then
		CreatureObject(pActor):doAnimation(arg)
	elseif (action == "effect") then
		SceneObject(pActor):playEffect(arg, "")
	elseif (action == "setAnimationMood") then
		self:setMoodString(pActor, arg)
	elseif (action == "faceTo") then
		local point = ambientTargets[arg]
		local actor = SceneObject(pActor)
		if (point ~= nil) then
			actor:setDirectionalHeading(math.atan(point[2] - actor:getPositionX(), point[4] - actor:getPositionY()))
		else
			local pTarget = getSceneObject(readData("mensixAmbient:" .. arg))
			if (pTarget ~= nil) then
				actor:faceObject(pTarget, true)
			end
		end
	elseif (action == "moveTo") then
		local point = ambientTargets[arg]
		local pBuilding = SceneObject(pActor):getRootParent()
		if (point == nil or pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
			return
		end
		local pCell = BuildingObject(pBuilding):getNamedCell(point[1])
		if (pCell ~= nil) then
			local agent = AiAgent(pActor)
			agent:setMovementState(AI_PATROLLING)
			agent:stopWaiting()
			agent:setWait(0)
			agent:setNextPosition(point[2], point[3], point[4], SceneObject(pCell):getObjectID())
			agent:executeBehavior()
		end
	end
end
