-- Generated from DSRC loot/loot_items/kashyyyk/urnsoris.tab.
for _, path in ipairs({
	"object/tangible/loot/quest/mind_pod_eye.iff",
	"object/tangible/loot/quest/mind_pod_sac.iff",
	"object/tangible/loot/quest/mind_pod_brain.iff",
	"object/tangible/loot/quest/mind_pod_stomach.iff",
	"object/tangible/loot/quest/naktra_crystal.iff",
	"object/tangible/loot/quest/mind_pod_parasites.iff",
	"object/tangible/loot/quest/mind_pod_blood.iff",
	"object/tangible/loot/quest/mind_pod_guts.iff",
	"object/tangible/loot/quest/mind_pod_slime.iff",
	"object/tangible/loot/quest/decomposed_foot.iff",
	"object/tangible/loot/quest/decomposed_hand.iff",
	"object/tangible/loot/quest/decomposed_skull.iff",
	"object/tangible/loot/quest/broken_bottle.iff",
	"object/tangible/loot/quest/runestone.iff",
}) do
	local name = path:match("([^/]+)%.iff$")
	addLootItemTemplate("myyydril_" .. name, {
		minimumLevel = 0, maximumLevel = -1, customObjectName = "", directObjectTemplate = path,
		craftingValues = {}, customizationStringNames = {}, customizationValues = {}
	})
end
