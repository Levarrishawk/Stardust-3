-- Live master_item key weapon_a280_blaster_rifle (master_item.tab:5874).
-- string_name "A280 Blaster Rifle". template_name object/weapon/ranged/rifle/rifle_a280.iff.
-- Blue-frog template stats are kept (empty craftingValues so LootManager
-- does not overwrite): minDamage 9999998, maxDamage 9999999, attackSpeed 1,
-- certificationsRequired cert_rifle_cdef. Unbalanced as a heroic reward
-- -- board X-4. Do not retune here.

weapon_a280_blaster_rifle = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "A280 Blaster Rifle",
	directObjectTemplate = "object/weapon/ranged/rifle/rifle_a280.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("weapon_a280_blaster_rifle", weapon_a280_blaster_rifle)
