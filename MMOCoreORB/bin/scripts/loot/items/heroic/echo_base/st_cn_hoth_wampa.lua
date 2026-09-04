-- Live master_item key st_cn_hoth_wampa (master_item.tab:5902).
-- string_name "Wampa". template_name
-- object/tangible/storyteller/story_token_combat_npc.iff. Guaranteed Uncle Joe
-- drop (echo_base_wampa_boss.tab strRequiredItems) and the berserker hop-3
-- item (heroic_drops.tab col echo_base_wampa_berserker).

st_cn_hoth_wampa = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Wampa",
	directObjectTemplate = "object/tangible/storyteller/story_token_combat_npc.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_cn_hoth_wampa", st_cn_hoth_wampa)
