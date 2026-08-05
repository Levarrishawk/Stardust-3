corellia = {
	jtlLaunchPoint = {"space_corellia", 6520, -5400, -2600}
}

dantooine = {
	jtlLaunchPoint = {"space_dantooine", 1380, -750, -5900}
}

dathomir = {
	jtlLaunchPoint = {"space_dathomir", -6900, 2750, -4000}
}

endor = {
	jtlLaunchPoint = {"space_endor", -5300, -1500, 5250}
}

lok = {
	jtlLaunchPoint = {"space_lok", -6200, -5350, 113}
}

naboo = {
	jtlLaunchPoint = {"space_naboo", -2500, 900, -6500}
}

rori = {
	jtlLaunchPoint = {"space_naboo", 6300, -4400, 500}
}

talus = {
	jtlLaunchPoint = {"space_corellia", -6400, -5300, -4000}
}

tatooine = {
	jtlLaunchPoint = {"space_tatooine",2300,-5900,1900},
}

yavin4 = {
	jtlLaunchPoint = {"space_yavin4", -5600, -5200, -5200}
}

tutorial = {
	jtlLaunchPoint = {"space_dathomir", -6900, 2750, -4000},
}

dungeon1 = {
}

space_corellia = {
	spaceStations = {
		{templateFile = "spacestation_rebel", x = -7132.79, z = 2340.4, y = 2013.98, ow = 0.641545, ox = -0.0633626, oy = 0.76035, oz = 0.079203, parentid = 0},
		{templateFile = "spacestation_talus", x = -6345.5, z = -5274.5, y = -3957.25, ow = 0.640802, ox = 0.015822, oy = 0.76738, oz = -0.0158223, parentid = 0},
		{templateFile = "spacestation_rebel", x = -1463.42, z = 318.86, y = -1012.24, ow = 0.759136, ox = -0.0474463, oy = 0.648429, oz = 0.0316307, parentid = 0},
		{templateFile = "spacestation_corellia", x = 6519.75, z = -5373.75, y = -2600.25, ow = -0.428073, ox = -1.39125e-08, oy = 0.90371, oz = -0.00792732, parentid = 0}
	}
}

space_dantooine = {
	spaceStations = {
		{templateFile = "spacestation_imperial", x = -2629.72, z = 3585.8, y = 3269.39, ow = 0.103184, ox = 0.031749, oy = 0.936596, oz = -0.333365, parentid = 0},
		{templateFile = "spacestation_imperial", x = 178.72, z = -4785.06, y = -6403.03, ow = 0.977105, ox = 0, oy = 0.212757, oz = 0, parentid = 0},
		{templateFile = "spacestation_dantooine", x = 1358.93, z = -741.97, y = -5901.79, ow = 0.907314, ox = 0.110455, oy = 0.394484, oz = -0.0946762, parentid = 0},
		-- Deep Space - Kessel Space Battlefield entry station (Rebel).
		--
		-- LIVE-ATTESTED POSITION. datatables/clientpoi/clientpoi.iff carries the row
		--   {Name = "@clientpoi_n:battlefield_rebel", Planet = "space_dantooine",
		--    X = -4200, Y = -3000, Z = -6000}
		-- and clientpoi X/Y/Z map to this table's x/z/y, so -4200 / -3000 / -6000 is
		-- exactly where Live put it.  clientpoi_n:battlefield_rebel = "Station: Deep
		-- Space"; clientpoi_d:battlefield_rebel = "The Rebel Alliance has discovered a
		-- hyperspace route to an area of Deep Space.  Only the most skillful and
		-- prestigious pilots can be trusted with the knowledge that the Rebel Alliance
		-- has constructed a base in Deep Space." / "To travel to Deep Space (PvP),
		-- approach the Deep Space Station and target it with the 'c'.  Proceed to then
		-- communicate with the station, by typing /comm in spatial chat."
		--
		-- This row previously read templateFile = "spacestation_rebel" (same XYZ), with
		-- a second, offset jumpstation_rebel row at -4400 / -3200 / -6200 carrying the
		-- note "the corpus documents no XYZ for any Deep Space station, so this position
		-- is ours, not Live-attested".  That note was wrong and the offset row was a
		-- duplicate of this POI; both are folded into this single row.
		{templateFile = "jumpstation_rebel", x = -4200, z = -3000, y = -6000, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		{templateFile = "spacestation_rebel", x = 5522.87, z = 3202, y = 5997.74, ow = -0.236536, ox = -0.031538, oy = 0.954028, oz = -0.181344, parentid = 0},
		{templateFile = "spacestation_rebel", x = -3979.37, z = 5423.26, y = -4565.81, ow = 0.917577, ox = 0.0791015, oy = 0.387597, oz = -0.0395508, parentid = 0}
	}
}

space_dathomir = {
	spaceStations = {
		{templateFile = "spacestation_imperial", x = 4842.19, z = -5316.32, y = -4222.79, ow = 0.849126, ox = -0.277752, oy = -0.428531, oz = -0.134908, parentid = 0},
		{templateFile = "spacestation_imperial", x = 6092.23, z = 6223.58, y = -6731.9, ow = 0.967128, ox = 0.182327, oy = -0.1744, oz = 0.0317089, parentid = 0},
		-- Deep Space - Kessel Space Battlefield entry station (Neutral/Freelance).
		--
		-- LIVE-ATTESTED POSITION. datatables/clientpoi/clientpoi.iff carries the row
		--   {Name = "@clientpoi_n:battlefield_neutral", Planet = "space_dathomir",
		--    X = 4000, Y = 200, Z = -4700}
		-- which maps to x = 4000, z = 200, y = -4700 here.  clientpoi_n:battlefield_neutral
		-- = "Last Nav Station (Deep Space)"; clientpoi_d:battlefield_neutral = "To travel
		-- to Deep Space (PvP), approach the Last Nav Station and target it with the 'c'.
		-- Proceed to then communicate with the station, by typing /comm in spatial chat."
		-- This matches the scrapbook: "Freelancers get there from the Neutral Deep Space
		-- Station in the Dathomir System."
		--
		-- This row previously read templateFile = "spacestation_neutral" (same XYZ), with
		-- a second, offset jumpstation_neutral row at 4200 / 400 / -4900 carrying the note
		-- "the corpus documents no XYZ for any Deep Space station, so this position is
		-- ours, not Live-attested".  That note was wrong and the offset row was a
		-- duplicate of this POI; both are folded into this single row.
		{templateFile = "jumpstation_neutral", x = 4000, z = 200, y = -4700, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		{templateFile = "spacestation_dathomir", x = -7078.75, z = 2879, y = -4293.75, ow = 0.946438, ox = 0.173514, oy = 0.268158, oz = -0.0473218, parentid = 0}
	}
}

space_endor = {
	spaceStations = {
		{templateFile = "spacestation_imperial", x = 5773.37, z = -6359.57, y = 6976.04, ow = 0.197218, ox = -0.0157777, oy = 0.978199, oz = 0.0631097, parentid = 0},
		-- Deep Space - Kessel Space Battlefield entry station (Imperial).
		--
		-- LIVE-ATTESTED POSITION. datatables/clientpoi/clientpoi.iff carries the row
		--   {Name = "@clientpoi_n:battlefield_imperial", Planet = "space_endor",
		--    X = 6200, Y = 5000, Z = 6000}
		-- which maps to x = 6200, z = 5000, y = 6000 here.  clientpoi_n:battlefield_imperial
		-- = "Imperial Claw Station (Deep Space)"; clientpoi_d:battlefield_imperial = "This
		-- Imperial Station can grant access to a hyperspace route to deep space.  The route
		-- is highly classified, however, and the Empire will allow only the most advanced,
		-- prestigious pilots to enter Deep Space." / "To travel to Deep Space (PvP),
		-- approach the Imperial Claw Station and target it with the 'c'.  Proceed to then
		-- communicate with the station, by typing /comm in spatial chat."
		--
		-- This row previously read templateFile = "spacestation_imperial" (same XYZ), with
		-- a second, offset jumpstation_imperial row at 6400 / 5200 / 6200.  The offset row
		-- was a duplicate of this POI; both are folded into this single row.
		{templateFile = "jumpstation_imperial", x = 6200, z = 5000, y = 6000, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		{templateFile = "spacestation_imperial", x = -5716.48, z = 7198.22, y = 2009.09, ow = 0.781614, ox = 0.307908, oy = 0.505286, oz = -0.197377, parentid = 0},
		{templateFile = "spacestation_endor", x = -5268.23, z = -1500.23, y = 5209.39, ow = 0.919533, ox = 0.151784, oy = -0.359617, oz = 0.0457911, parentid = 0}
	}
}

-- Deep Space. The spaceStations table must exist (even empty) or
-- SpaceManagerImplementation::loadLuaConfig returns before reading anything else
-- for this zone (SpaceManagerImplementation.cpp:379-380).
--
-- DELIBERATELY EMPTY. clientpoi.iff carries exactly one space_heavy1 row -
--   {Name = "@clientpoi_n:hvy_rebel_station" ("Freedom Station"),
--    Planet = "space_heavy1", X = -6000, Y = 0, Z = 0}
-- - and that station is already placed, at exactly those coordinates, by
-- screenplays/space/spawning/space_heavy1_spawner.lua:15
--   {spawnName = "hvy_rebel_station", shipName = "spacestation_freedom",
--    x = -6000, z = 0, y = 0, ...}.
-- Adding a row here would spawn Freedom Station twice.  The Imperial Star
-- Destroyer opposite it (space_heavy1_spawner.lua:16, 6000/0/0) ships no
-- clientpoi row at all.
space_heavy1 = {
	spaceStations = {
	}
}

-- Rage of the Wookiees space zone. The spaceStations table must exist (even
-- empty) or SpaceManagerImplementation::loadLuaConfig returns before reading
-- anything else for this zone (SpaceManagerImplementation.cpp:379-380).
space_kashyyyk = {
	spaceStations = {
		{templateFile = "spacestation_kashyyyk", x = -5000, z = 250, y = -5000, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		{templateFile = "spacestation_rodian_base", x = 2556, z = 3225, y = 3890, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		{templateFile = "spacestation_rodian_tripp_base", x = -2618, z = 70, y = 2624, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		{templateFile = "station_gotal_pirate_base", x = -5950, z = 2700, y = 4575, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		{templateFile = "station_chiss_poacher_base", x = -6825, z = 763, y = 2065, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		{templateFile = "spacestation_indie_slaver", x = -6830, z = -350, y = 4200, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		-- The Trandoshan Avatar Platform ships no clientpoi row, so this position is
		-- ours, not Live-attested. Set opposite the independent slavers who prey on
		-- its transports (station_indie_slaver:s_193).
		{templateFile = "spacestation_avatar_platform", x = 5900, z = -1200, y = -3400, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		-- The Kashyyyk Rebel Outpost ships no clientpoi row, so this position is ours,
		-- not Live-attested. Kept well clear of the Imperial base below.
		{templateFile = "spacestation_kash_rebel", x = 1200, z = -2600, y = -6100, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0},
		-- The Kashyyyk Imperial Base ships no clientpoi row, so this position is ours,
		-- not Live-attested. Kept well clear of the Rebel outpost above.
		{templateFile = "spacestation_kash_imperial", x = 6100, z = 2900, y = -1800, ow = 1, ox = 0, oy = 0, oz = 0, parentid = 0}
	}
}

-- Kessel. The spaceStations table must exist (even empty) - see the note on
-- space_heavy1 above.
--
-- DELIBERATELY EMPTY. clientpoi.iff carries ZERO space_light1 rows (per-zone row
-- counts: corellia 20, dantooine 25, dathomir 14, endor 14, heavy1 1, kashyyyk 12,
-- lok 24, naboo 23, nova_orion 1, ord_mantell 4, tatooine 24, yavin4 17,
-- light1 0), so no Kessel station has a Live-attested position.  The client does
-- ship object/ship/shared_kessel_mine_turret_tier1..5.iff and the names
-- space/space_mobile_type:kessel_mine_turret_tier1..5 ("Defense Turret"), but no
-- shared template for them is registered under bin/scripts/object/ - see the
-- report's unbuildable list.
space_light1 = {
	spaceStations = {
	}
}

space_lok = {
	spaceStations = {
		{templateFile = "spacestation_imperial", x = -1798.64, z = 2649.25, y = 400.89, ow = -0.031722, ox = 0.0158608, oy = 0.999245, oz = 0.0158608, parentid = 0},
		{templateFile = "spacestation_lok", x = -6235.21, z = -5341.59, y = 113.86, ow = 0.611794, ox = 0.347264, oy = 0.577203, oz = -0.414672, parentid = 0},
		{templateFile = "spacestation_rebel", x = 1799.13, z = -2458.57, y = -3680.29, ow = 0.989635, ox = -0.13459, oy = 0.0475025, oz = 0.0158343, parentid = 0}
	}
}

space_naboo = {
	spaceStations = {
		{templateFile = "spacestation_imperial", x = 3511.83, z = 1774.71, y = 944.36, ow = -0.670707, ox = 0, oy = 0.741723, oz = 0, parentid = 0},
		{templateFile = "spacestation_naboo", x = -2491.26, z = 905.49, y = -6460.67, ow = 0.201287, ox = -0.00687047, oy = 0.968212, oz = 0.148333, parentid = 0},
		{templateFile = "spacestation_rori", x = 6226.22, z = -4450.57, y = 484.75, ow = 0.36384, ox = -0.0206368, oy = 0.924935, oz = 0.108118, parentid = 0}
	}
}

space_tatooine = {
	spaceStations = {
		{templateFile = "spacestation_tatooine", x = 2311.89, z = -5872.72, y = 1865.29, ow = 0.324318, ox = 0.0734025, oy = 0.94172, oz = -0.0509326, parentid = 0}
	}
}

space_yavin4 = {
	spaceStations = {
		{templateFile = "spacestation_imperial", x = -6798.55, z = 4998.69, y = 4760.4, ow = 0.577296, ox = 0.0316324, oy = 0.814541, oz = -0.0474491, parentid = 0},
		{templateFile = "spacestation_imperial", x = -4190.56, z = 1539.35, y = 4596.82, ow = 0.434352, ox = 0.023692, oy = 0.900293, oz = -0.0157947, parentid = 0},
		{templateFile = "spacestation_imperial", x = 85.21, z = -342.3, y = -57.62, ow = 0.627024, ox = 0.0158741, oy = 0.777827, oz = -0.039685, parentid = 0},
		{templateFile = "spacestation_yavin4", x = -5570.46, z = -5168, y = -5234.88, ow = 0.994108, ox = 0.105996, oy = -0.0145207, oz = -0.0173906, parentid = 0}
	}
}
