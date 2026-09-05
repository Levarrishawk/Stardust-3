-- Transcribes datatables/loot/loot_types/kashyyyk/wke_resistance.tab
-- strItems lists: kashyyyk/wke_resistance
-- OURS: equal weights (SOE gives no per-item weights in these tables). Sum 10000000.
-- ruling 2026-09-04: ensure kashyyyk is done in full.
wke_resistance = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "blaster_power_handler_faux_bowcaster", weight = 10000000},
	}
}

addLootGroupTemplate("wke_resistance", wke_resistance)
