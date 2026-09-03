-- Transcribes datatables/loot/loot_items/mustafar/hk47_loot.tab.
-- Live's strRequiredItems for that table is
-- object/tangible/ship/crafted/chassis/yt2400_reward_deed.iff, a chronicle/ship-deed
-- reward outside Mustafar's scope; not delivered here.
-- Weights sum to 10000000 as transcribed; do not recompute.
hk47_loot = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "item_tow_hk47_move_immune_06_01", weight = 1000000},
		{itemTemplate = "weapon_tow_carbine_sfor_05_01", weight = 1000000},
		{itemTemplate = "weapon_tow_rifle_must_disruptor_05_01", weight = 1000000},
		{itemTemplate = "weapon_tow_pistol_intimidator_05_01", weight = 1000000},
		{itemTemplate = "weapon_tow_knuckler_massassi_05_01", weight = 1000000},
		{itemTemplate = "weapon_tow_1h_must_bandit_sword_05_01", weight = 1000000},
		{itemTemplate = "weapon_tow_polearm_xandak_lance_05_01", weight = 1000000},
		{itemTemplate = "weapon_tow_2h_tulrus_sword_05_01", weight = 1000000},
		{itemTemplate = "cube_loot_3m", weight = 1000000},
		{itemTemplate = "item_tow_schematic_saber_03_01", weight = 1000000}
	}
}

addLootGroupTemplate("hk47_loot", hk47_loot)
