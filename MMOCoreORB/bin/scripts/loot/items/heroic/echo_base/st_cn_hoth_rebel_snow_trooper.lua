-- Live master_item key st_cn_hoth_rebel_snow_trooper (master_item.tab:5901).
-- string_name "Rebel Snow Trooper". template_name
-- object/tangible/storyteller/story_token_combat_npc.iff. All st_cn_hoth_*
-- share this iff and differ only in name.

st_cn_hoth_rebel_snow_trooper = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Rebel Snow Trooper",
	directObjectTemplate = "object/tangible/storyteller/story_token_combat_npc.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_cn_hoth_rebel_snow_trooper", st_cn_hoth_rebel_snow_trooper)
