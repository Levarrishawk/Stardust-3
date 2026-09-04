-- Live master_item key st_pr_hoth_snow_trooper_gun (master_item.tab:5896).
-- string_name "Hoth-style Snow Trooper Gun". template_name
-- object/tangible/storyteller/story_token_prop.iff. All st_pr_hoth_*
-- share this iff and differ only in name.

st_pr_hoth_snow_trooper_gun = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Hoth-style Snow Trooper Gun",
	directObjectTemplate = "object/tangible/storyteller/story_token_prop.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_pr_hoth_snow_trooper_gun", st_pr_hoth_snow_trooper_gun)
