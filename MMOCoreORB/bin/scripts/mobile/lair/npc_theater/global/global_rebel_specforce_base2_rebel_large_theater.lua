global_rebel_specforce_base2_rebel_large_theater = Lair:new {
	mobiles = {
		{"separatist_s_battle_droid",1},
    {"separatist_droideka",2},    
    {"separatist_battle_droid",4}
	},
	spawnLimit = 15,
	buildingsVeryEasy = {"object/building/poi/anywhere_rebel_base_large_1.iff"},
	buildingsEasy = {"object/building/poi/anywhere_rebel_base_large_1.iff"},
	buildingsMedium = {"object/building/poi/anywhere_rebel_base_large_1.iff"},
	buildingsHard = {"object/building/poi/anywhere_rebel_base_large_1.iff"},
	buildingsVeryHard = {"object/building/poi/anywhere_rebel_base_large_1.iff"},
	missionBuilding = "object/tangible/lair/base/objective_banner_rebel.iff",
	mobType = "npc",
	buildingType = "theater",
	faction = "separatist"
}

addLairTemplate("global_rebel_specforce_base2_rebel_large_theater", global_rebel_specforce_base2_rebel_large_theater)
