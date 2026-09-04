-- Live master_item key st_pr_hoth_radio (master_item.tab:5894).
-- string_name "Hoth-style Radio". template_name
-- object/tangible/storyteller/story_token_prop.iff. All st_pr_hoth_*
-- share this iff and differ only in name.

st_pr_hoth_radio = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Hoth-style Radio",
	directObjectTemplate = "object/tangible/storyteller/story_token_prop.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_pr_hoth_radio", st_pr_hoth_radio)
