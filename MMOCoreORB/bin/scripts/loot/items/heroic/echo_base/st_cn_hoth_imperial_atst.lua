-- Live master_item key st_cn_hoth_imperial_atst (master_item.tab:5899).
-- string_name "Imperial AT-ST". template_name
-- object/tangible/storyteller/story_token_combat_npc.iff. All st_cn_hoth_*
-- share this iff and differ only in name.

st_cn_hoth_imperial_atst = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Imperial AT-ST",
	directObjectTemplate = "object/tangible/storyteller/story_token_combat_npc.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_cn_hoth_imperial_atst", st_cn_hoth_imperial_atst)
