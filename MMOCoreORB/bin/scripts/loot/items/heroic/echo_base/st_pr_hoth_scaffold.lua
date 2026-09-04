-- Live master_item key st_pr_hoth_scaffold (master_item.tab:5895).
-- string_name "Hoth-style Scaffold". template_name
-- object/tangible/storyteller/story_token_prop.iff. All st_pr_hoth_*
-- share this iff and differ only in name.

st_pr_hoth_scaffold = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Hoth-style Scaffold",
	directObjectTemplate = "object/tangible/storyteller/story_token_prop.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_pr_hoth_scaffold", st_pr_hoth_scaffold)
