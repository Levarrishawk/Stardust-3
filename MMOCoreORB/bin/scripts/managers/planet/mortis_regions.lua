-- Planet Region Definitions
-- Rectangles use their southwest and northeast corners.
-- Ordinary spawn areas keep each creature pool inside its half of Mortis.
-- Outer edges stay inside the active-area quadtree's exclusive upper bounds.

require("scripts.managers.planet.regions")

mortis_regions = {
	{"mortis_central_tiles_nospawn", 0, 0, {CIRCLE, 100}, NOSPAWNAREA},
	{"mortis_daughter_spawner", -8191, -8191, {RECTANGLE, 0, 8191}, SPAWNAREA, {"mortis_daughter"}, 1024},
	{"mortis_son_spawner", 0, -8191, {RECTANGLE, 8191, 8191}, SPAWNAREA, {"mortis_son"}, 1024}
}
