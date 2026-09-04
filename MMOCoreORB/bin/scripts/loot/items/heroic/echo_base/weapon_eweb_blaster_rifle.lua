-- Live master_item key weapon_eweb_blaster_rifle (master_item.tab:5875).
-- string_name "E-Web Rifle". template_name object/weapon/ranged/rifle/rifle_eweb.iff.
-- Blue-frog template stats are kept (empty craftingValues so LootManager
-- does not overwrite): minDamage 9999998, maxDamage 9999999, attackSpeed 1,
-- certificationsRequired cert_rifle_cdef. Unbalanced as a heroic reward
-- -- board X-4. Do not retune here.

weapon_eweb_blaster_rifle = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "E-Web Rifle",
	directObjectTemplate = "object/weapon/ranged/rifle/rifle_eweb.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("weapon_eweb_blaster_rifle", weapon_eweb_blaster_rifle)
