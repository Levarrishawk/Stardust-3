-- Live master_item key st_pr_hoth_terminal_01 (master_item.tab:5897).
-- string_name "Hoth-style Terminal". template_name
-- object/tangible/storyteller/story_token_prop.iff. All st_pr_hoth_*
-- share this iff and differ only in name.

st_pr_hoth_terminal_01 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Hoth-style Terminal",
	directObjectTemplate = "object/tangible/storyteller/story_token_prop.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_pr_hoth_terminal_01", st_pr_hoth_terminal_01)
