-- Live master_item key st_pr_hoth_crate_02 (master_item.tab:5888).
-- string_name "Hoth-style Crate 02". template_name
-- object/tangible/storyteller/story_token_prop.iff. All st_pr_hoth_*
-- share this iff and differ only in name.

st_pr_hoth_crate_02 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Hoth-style Crate 02",
	directObjectTemplate = "object/tangible/storyteller/story_token_prop.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_pr_hoth_crate_02", st_pr_hoth_crate_02)
