-- Planet Region Definitions
-- Rectangles use their southwest and northeast corners.
-- Ordinary spawn areas keep each creature pool inside its half of Mortis.

require("scripts.managers.planet.regions")

mortis_regions = {
	{"mortis_daughter_spawner", -8192, -8192, {RECTANGLE, 0, 8192}, SPAWNAREA, {"mortis_daughter"}, 1024},
	{"mortis_son_spawner", 0, -8192, {RECTANGLE, 8192, 8192}, SPAWNAREA, {"mortis_son"}, 1024}
}
