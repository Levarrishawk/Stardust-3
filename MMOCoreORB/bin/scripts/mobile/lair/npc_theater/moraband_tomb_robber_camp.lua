moraband_tomb_robber_camp = Lair:new {
	mobiles = {{"moraband_tomb_robber",3},{"moraband_relic_smuggler",1}},
	spawnLimit = 6,
	buildingsVeryEasy = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff"},
	buildingsEasy = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff"},
	buildingsMedium = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff"},
	buildingsHard = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff"},
	buildingsVeryHard = {"object/building/poi/tatooine_hutt_businessmen_camp_small1.iff"},
	missionBuilding = "object/tangible/lair/base/objective_banner_generic_2.iff",
	mobType = "npc",
	buildingType = "theater"
}

addLairTemplate("moraband_tomb_robber_camp", moraband_tomb_robber_camp)
