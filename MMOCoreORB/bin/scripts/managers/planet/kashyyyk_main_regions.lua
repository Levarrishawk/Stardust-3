-- Kachirho hub regions for terrain/kashyyyk_main.trn.
-- Main buildout coordinates are buildout x/y minus 4096, matching
-- snapshot/kashyyyk_main.ws. Hunting Grounds and Dead Forest use separate zones.
-- Authored main-map creatures are managed by KashyyykMainPopulation, not dynamic lairs.
require("scripts.managers.planet.regions")

kashyyyk_main_regions = {
	-- Main-map named region and structure exclusion areas.
	{"@kashyyyk_region_names:kachirho", -500, -100, {CIRCLE, 250}, NOBUILDZONEAREA + NOSPAWNAREA + NAMEDREGION},
	{"kachirho_north_arches", -556, 158, {CIRCLE, 40}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"kachirho_west_slave_camp", 154, 157, {CIRCLE, 90}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"kachirho_east_slave_camp", 520, 351, {CIRCLE, 140}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"kachirho_east_homestead", 302, -181, {CIRCLE, 60}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"kachirho_north_ruined_huts", 172, 565, {CIRCLE, 75}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"kachirho_east_weapon_camp", 782, 298, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"kachirho_north_camp", -342, 649, {CIRCLE, 120}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"kachirho_northeast_camp", 586, 734, {CIRCLE, 30}, NOSPAWNAREA + NOBUILDZONEAREA},
	{"kachirho_southeast_camp", 553, -645, {CIRCLE, 35}, NOSPAWNAREA + NOBUILDZONEAREA},

	-- Scripted population: screenplays/kashyyyk/kashyyyk_main_population.lua.
}
