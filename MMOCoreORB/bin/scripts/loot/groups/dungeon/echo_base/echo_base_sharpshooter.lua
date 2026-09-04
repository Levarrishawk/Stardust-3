-- echo_base_sharpshooter -- named-kill required hop.
--
-- SOURCED (SOE, datatables/loot/loot_items/dungeon/heroic_drops.tab col 20
-- echo_base_sharpshooter): weapon_a280_blaster_rifle, weapon_eweb_blaster_rifle,
-- st_cn_hoth_imperial_atst x2 (double weight). 4 parts, 10 000 000 / 4 =
-- 2 500 000; the AT-ST token is 5 000 000.
--
-- Hop-2 echo_base_sharpshooter.tab is strItems = echo_base_soldier_junk and
-- strRequiredItems = this table. Core3 cannot express "always drop A AND
-- also roll B" in one group (same as echo_base_wampa_boss). When the ten
-- sharpshooter mobiles exist, wire two 100% rolls: this group plus
-- echo_base_soldier_junk. EB-c/EB-d did not spawn them; no mobile to edit.

echo_base_sharpshooter = {
	description = "",
	minimumLevel = 0,
	maximumLevel = -1,
	lootItems = {
		{itemTemplate = "weapon_a280_blaster_rifle", weight = 2500000},
		{itemTemplate = "weapon_eweb_blaster_rifle", weight = 2500000},
		{itemTemplate = "st_cn_hoth_imperial_atst", weight = 5000000},
	}
}

addLootGroupTemplate("echo_base_sharpshooter", echo_base_sharpshooter)
