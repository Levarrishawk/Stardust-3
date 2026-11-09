require("scripts.managers.planet.regions")

-- Ambient spawns use the DSRC South Dungeons population screenplay.
kashyyyk_south_dungeons_regions = {
	-- No Build Zones
	-- INFERRED (convention, not shipped rows). Dimensionally justified: the
	-- governing terrain/kashyyyk_south_dungeons.trn is mapWidth 16384 (+/-8192),
	-- identical to the Kashyyyk surface, which uses these exact bounds.
	{"northedge_kashyyyk_south_dungeons_nobuild", -8000, 7640, {RECTANGLE, 8000, 8000}, NOBUILDZONEAREA},
	{"westedge_kashyyyk_south_dungeons_nobuild", -8000, -7640, {RECTANGLE, -7640, 7640}, NOBUILDZONEAREA},
	{"southedge_kashyyyk_south_dungeons_nobuild", -8000, -8000, {RECTANGLE, 8000, -7640}, NOBUILDZONEAREA},
	{"eastedge_kashyyyk_south_dungeons_nobuild", 7640, -7640, {RECTANGLE, 8000, 7640}, NOBUILDZONEAREA},
}
