-- loot/items/npc_loot/costume_darktrooper_3.lua
-- SOURCED: heroic_drops.tab columns sd_sub_1/2/3 carry costume_darktrooper_3 x1.
--   Server template: object/custom_content/tangible/item/costume_kit/costume_deed.lua:5
--   -> object/tangible/item/costume_kit/costume_deed.iff.
-- OURS, NOT SOURCED: nothing. The loot item name keeps SOE's costume_darktrooper_3
--   so the three sub-boss groups can name it. Required by PART 5.3 (five loot items)
--   and SC4.2 (every itemTemplate must resolve). Not in the 14-file fence list;
--   reported in grok-report.txt.
costume_darktrooper_3 = {
	minimumLevel = 0, maximumLevel = 0, customObjectName = "",
	directObjectTemplate = "object/tangible/item/costume_kit/costume_deed.iff",
	craftingValues = {}, customizationStringNames = {}, customizationValues = {}
}
addLootItemTemplate("costume_darktrooper_3", costume_darktrooper_3)
