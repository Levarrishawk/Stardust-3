-- Live master_item key st_cn_hoth_imperial_snowtrooper (master_item.tab:5900).
-- string_name "Imperial Snowtrooper". template_name
-- object/tangible/storyteller/story_token_combat_npc.iff. All st_cn_hoth_*
-- share this iff and differ only in name.

st_cn_hoth_imperial_snowtrooper = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Imperial Snowtrooper",
	directObjectTemplate = "object/tangible/storyteller/story_token_combat_npc.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_cn_hoth_imperial_snowtrooper", st_cn_hoth_imperial_snowtrooper)
