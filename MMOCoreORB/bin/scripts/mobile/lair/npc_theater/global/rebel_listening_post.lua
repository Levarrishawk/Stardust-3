rebel_listening_post = Lair:new {
	mobiles = {
		{"separatist_s_battle_droid",1},
    {"separatist_droideka",2},    
    {"separatist_battle_droid",4}
	},
	spawnLimit = 12,
	buildingsVeryEasy = {"object/building/poi/rebel_listening_post.iff"},
	buildingsEasy = {"object/building/poi/rebel_listening_post.iff"},
	buildingsMedium = {"object/building/poi/rebel_listening_post.iff"},
	buildingsHard = {"object/building/poi/rebel_listening_post.iff"},
	buildingsVeryHard = {"object/building/poi/rebel_listening_post.iff"},
	missionBuilding = "object/tangible/lair/base/objective_banner_rebel.iff",
	mobType = "npc",
	buildingType = "theater",
	faction = "separatist"
}

addLairTemplate("rebel_listening_post", rebel_listening_post)
