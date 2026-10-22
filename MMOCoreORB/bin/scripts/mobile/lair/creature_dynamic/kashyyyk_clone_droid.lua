-- Source: datatables/spawning/ground_spawning/types/clone_droid.tab.
-- fltSize=0 is clearance, not a selection weight. The sole creature needs a
-- positive Core3 weight; zero leaves getWeightedMobiles() empty and spawning fails.
kashyyyk_clone_droid = Lair:new {
	mobiles = {{"clone_droid",1}},
	spawnLimit = 1,
	buildingsVeryEasy = {},
  buildingsEasy = {},
  buildingsMedium = {},
  buildingsHard = {},
  buildingsVeryHard = {},
	buildingType = "none"
}

addLairTemplate("kashyyyk_clone_droid", kashyyyk_clone_droid)
