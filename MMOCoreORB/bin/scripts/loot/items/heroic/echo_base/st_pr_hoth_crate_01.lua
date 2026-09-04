-- Live master_item key st_pr_hoth_crate_01 (master_item.tab:5887).
-- string_name "Hoth-style Crate 01". template_name
-- object/tangible/storyteller/story_token_prop.iff. All st_pr_hoth_*
-- share this iff and differ only in name.

st_pr_hoth_crate_01 = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "Hoth-style Crate 01",
	directObjectTemplate = "object/tangible/storyteller/story_token_prop.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("st_pr_hoth_crate_01", st_pr_hoth_crate_01)
