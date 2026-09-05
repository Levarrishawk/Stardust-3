--[[
	CollectionManager — Lua port of the SOE collection natives over CollectionData.

	Read natives (base_class.java:15290-15382), same names, same argument order:
	  getCollectionSlotInfo(slotName) -> {book, page, collection, music}
	  isCollectionSlotATitle(slotName) / isCollectionATitle(collectionName) / isCollectionPageATitle(pageName)
	  getCollectionSlotCategoryInfo(slotName)
	  getCollectionSlotPrereqInfo(slotName)
	  getCollectionSlotName(slotId)
	  getAllCollectionSlotsInCollection(collectionName)
	  getAllCollectionSlotsInPage(pageName) / getAllCollectionsInPage(pageName)
	  getAllCollectionSlotsInBook(bookName) / getAllCollectionsInBook(bookName) / getAllCollectionPagesInBook(bookName)
	  getAllCollectionBooks()
	  getAllCollectionSlotsInCategory(categoryName)
	  getAllCollectionSlotsInCategoryInCollection(collectionName, categoryName)
	  getAllCollectionSlotsInCategoryInPage(pageName, categoryName)
	  getAllCollectionSlotsInCategoryInBook(bookName, categoryName)
	  getAllCollectionSlotCategoriesInCollection(collectionName)
	  getAllCollectionSlotCategoriesInPage(pageName)
	  getAllCollectionSlotCategoriesInBook(bookName)
	  getAllCollectionSlotCategories()
	  getCollectionSlotMaxValue(slotName)

	Player state (base_class.java:15163-15221), persisted writeScreenPlayData/readScreenPlayData
	as screenPlay "Collections" + variable slotName (the Collections:<slotName> key). Never sent
	on the wire.
	  modifyCollectionSlotValue(pPlayer, slotName, delta)
	  getCollectionSlotValue(pPlayer, slotName)
	  hasCompletedCollectionSlotPrereq(pPlayer, slotName)
	  hasCompletedCollectionSlot(pPlayer, slotName)
	  hasCompletedCollection(pPlayer, collectionName)
	  hasCompletedCollectionPage(pPlayer, pageName)
	  hasCompletedCollectionBook(pPlayer, bookName)

	On every actual change: onSlotModified(pPlayer, book, page, collection, slot, isCounter,
	prev, cur, max, completed) — addListener(fn) is the OnCollectionSlotModified hook.

	Rewards (collection.java:95 grantCollectionReward; player_collection.java:27):
	  rewardsFor(collectionName)
	  grantCollectionReward(pPlayer, collectionName, canReset)
	  updateCraftingSlot(pPlayer, template) — collection.java:272 (not a grant kind)
	Implemented kinds: item (iff path and CollectionStaticItems bridge), xpModifier
	(OURS scale * xp.java:2023 repeatCollectionXpModifier), quest_signal (hook),
	reward_text (shipped prose),
	slot_name (modifyCollectionSlotValue; badge_book slots go through grantBadgeSlot),
	command (PlayerObject:addAbility when the name is in the command/ability table),
	grantRandomItem / grantWeightedRandom (java roll; names resolve through the bridge),
	quest (raised on questGrant for the journal branch's listener),
	skill_mod (OPEN — CreatureObject:addSkillMod is not bound in Lua -- the ONE item that needs C++),
	crafting_template (updateCraftingSlot reverse-index; not a schematic grant).
	item static_item names whose template is not in the fork: template absent from this server (102),
	lootSchematic: 93 items; loot_schematic.java -- .schematic grants a schematic via
	PlayerObject:addRewardedSchematic (LuaPlayerObject.cpp:291); .beast / .ability / .skill
	are NGE beast-master / expertise. 8 rows are beast-master holocrons (absent system,
	item still granted). 85 rows carry loot_schematic.schematic. Command names not in
	the command table stay unggranted. stackAmount (81 rows): OURS giveItem in a loop
	so the player holds the shipped count (no setUseCount binding).
]]

require("managers.collections.collection_data")
require("managers.collections.collection_static_items")

CollectionManager = CollectionManager or {}
require("managers.collections.collection_badges")

CollectionManager.SCREENPLAY = "Collections"
CollectionManager.BADGE_BOOK = "badge_book"
CollectionManager.REWARD_ON_UPDATE = "rewardOnUpdate"
CollectionManager.REWARD_ON_COMPLETE = "rewardOnComplete"
CollectionManager.CLEAR_ON_COMPLETE = "clearOnComplete"
CollectionManager.UPDATE_ON_COUNT = "updateOnCount"
CollectionManager.NO_MESSAGE = "noMessage"
CollectionManager.NO_SCRIPT_NOTIFY = "noScriptNotifyOnModify"

-- XP amount rule (OURS). SOE xp.java:1933 grantCollectionXP is xpModifier * (XP in the current
-- NGE combat-level band) * xp.java:2023 repeatCollectionXpModifier, and grantXpByTemplate uses
-- quest_combat / quest_crafting / quest_social, none of which this tree has. mustafar_quest_xp.lua
-- already ruled combat_general as the substitution for unknown NGE XP types
-- (PlayerObjectImplementation.cpp falls through to a 2000 cap on an unknown type). Amount:
-- math.floor(xpModifier * 1000 * repeat) combat_general, or space_combat_general when isSpaceXp
-- is set (PlayerManagerImplementation.cpp already awards that type). xpModifier in rewards.tab
-- is 0 / 0.1 / 0.2 / 0.25 / 0.3, so the first grant is 0 / 100 / 200 / 250 / 300 — the same
-- scale as kidnappedNobleConvoHandler.lua:21 (250 combat_general). The NGE level band does not
-- exist Pre-CU, so XP_MODIFIER_SCALE stays. Repeat: max(0.1, 1 - repeat/10) where repeat =
-- slot value of <collectionName>_tracker minus 1 (xp.java:1945, 2023-2032), applied when
-- repeat > 0.
CollectionManager.XP_MODIFIER_SCALE = 1000
CollectionManager.XP_TYPE = "combat_general"
CollectionManager.SPACE_XP_TYPE = "space_combat_general"

CollectionManager.OPEN_REWARD_KINDS = {
	"skill_mod apply: CreatureObject:addSkillMod is not bound in Lua -- the ONE item that needs C++",
}

-- loot_schematic.java: VAR_SCHEMATIC grants a schematic; VAR_BEAST / VAR_ABILITY /
-- VAR_SKILL are NGE beast-master / expertise (TYPE_BEAST_ABILITY = 5). 8 beast
-- holocrons: absent system, item still granted. 85 rows carry .schematic.
-- Use: PlayerObject:addRewardedSchematic (LuaPlayerObject.cpp:291) type
-- SchematicList::LOOT = 1 (LootSchematicMenuComponent.cpp:82).
CollectionManager.LOOT_SCHEMATICS = {
	["col_feather_pillow_reward_02_01"]={schematic="object/draft_schematic/furniture/furniture_throwpillow_hue_s01.iff",uses=2},
	["col_fish_tank_reward_schematic_02_01"]={schematic="object/draft_schematic/furniture/furniture_collection_fish_tank.iff",uses=2},
	["col_fried_icecream_fryer_schematic"]={schematic="object/draft_schematic/item/collection_ice_cream_fryer.iff",uses=1},
	["col_glass_shelving_reward_02_01"]={schematic="object/draft_schematic/furniture/furniture_collection_glass_shelves_01.iff",uses=2},
	["col_ig_88_schematic_02_01"]={schematic="object/draft_schematic/item/collection_posed_ig_88.iff",uses=1},
	["col_jeweled_necklace_schematic_02_01"]={schematic="object/draft_schematic/clothing/clothing_collection_jeweled_necklace.iff",uses=1},
	["col_reward_dejarik_table_schematic_02_01"]={schematic="object/draft_schematic/furniture/furniture_collection_dejarik_table.iff",uses=1},
	["col_stormtrooper_schematic_02_01"]={schematic="object/draft_schematic/item/collection_posed_stormtrooper.iff",uses=1},
	["item_collection_dancing_droid_module_schematic_01_01"]={schematic="object/draft_schematic/droid/component/droid_dance_module.iff",uses=1},
	["item_collection_hanging_light_schematic_01_01"]={schematic="object/draft_schematic/furniture/furniture_collection_hanging_light_01.iff",uses=2},
	["item_collection_hanging_light_schematic_01_02"]={schematic="object/draft_schematic/furniture/furniture_collection_hanging_light_02.iff",uses=1},
	["item_collection_reward_booster_01_mk1_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk1.iff",uses=1},
	["item_collection_reward_booster_01_mk2_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk2.iff",uses=1},
	["item_collection_reward_booster_01_mk3_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk3.iff",uses=1},
	["item_collection_reward_booster_01_mk4_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk4.iff",uses=1},
	["item_collection_reward_booster_01_mk5_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk5.iff",uses=1},
	["item_collection_reward_capacitor_01_mk1_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk1.iff",uses=1},
	["item_collection_reward_capacitor_01_mk2_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk2.iff",uses=1},
	["item_collection_reward_capacitor_01_mk3_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk3.iff",uses=1},
	["item_collection_reward_capacitor_01_mk4_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk4.iff",uses=1},
	["item_collection_reward_capacitor_01_mk5_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk5.iff",uses=1},
	["item_collection_reward_engine_01_mk1_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk1.iff",uses=1},
	["item_collection_reward_engine_01_mk2_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk2.iff",uses=1},
	["item_collection_reward_engine_01_mk3_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk3.iff",uses=1},
	["item_collection_reward_engine_01_mk4_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk4.iff",uses=1},
	["item_collection_reward_engine_01_mk5_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk5.iff",uses=1},
	["item_collection_reward_potted_flower_schematic_01_01"]={schematic="object/draft_schematic/furniture/furniture_flowers_collection_potted_s01.iff",uses=1},
	["item_collection_reward_potted_plant_schematic_01_01"]={schematic="object/draft_schematic/furniture/furniture_plants_collection_potted_large_s01.iff",uses=1},
	["item_collection_reward_reactor_01_mk1_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_02_mk1.iff",uses=1},
	["item_collection_reward_reactor_01_mk2_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_02_mk2.iff",uses=1},
	["item_collection_reward_reactor_01_mk3_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_02_mk3.iff",uses=1},
	["item_collection_reward_reactor_01_mk4_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_02_mk4.iff",uses=1},
	["item_collection_reward_reactor_01_mk5_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_01_mk5.iff",uses=1},
	["item_crafting_collection_gunship_cargo_hold"]={schematic="object/draft_schematic/space/cargo_hold/crg_pob_gunship_huge.iff",uses=3},
	["item_crafting_collection_gunship_imperial_schematic"]={schematic="object/draft_schematic/space/chassis/player_gunship_imperial.iff",uses=3},
	["item_crafting_collection_gunship_neutral_schematic"]={schematic="object/draft_schematic/space/chassis/player_gunship_neutral.iff",uses=3},
	["item_crafting_collection_gunship_rebel_schematic"]={schematic="object/draft_schematic/space/chassis/player_gunship_rebel.iff",uses=3},
	["item_crafting_collection_pob_furniture_chair_schematic"]={schematic="object/draft_schematic/furniture/furniture_collection_pob_chair.iff",uses=3},
	["item_crafting_collection_pob_furniture_couch_schematic"]={schematic="object/draft_schematic/furniture/furniture_collection_pob_couch.iff",uses=3},
	["item_crafting_collection_reward_booster_01_mk1_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk1.iff",uses=3},
	["item_crafting_collection_reward_booster_01_mk2_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk2.iff",uses=3},
	["item_crafting_collection_reward_booster_01_mk3_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk3.iff",uses=3},
	["item_crafting_collection_reward_booster_01_mk4_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk4.iff",uses=3},
	["item_crafting_collection_reward_booster_01_mk5_schematic"]={schematic="object/draft_schematic/space/booster/collection_reward_booster_01_mk5.iff",uses=3},
	["item_crafting_collection_reward_capacitor_01_mk1_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk1.iff",uses=3},
	["item_crafting_collection_reward_capacitor_01_mk2_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk2.iff",uses=3},
	["item_crafting_collection_reward_capacitor_01_mk3_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk3.iff",uses=3},
	["item_crafting_collection_reward_capacitor_01_mk4_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk4.iff",uses=3},
	["item_crafting_collection_reward_capacitor_01_mk5_schematic"]={schematic="object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk5.iff",uses=3},
	["item_crafting_collection_reward_engine_01_mk1_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk1.iff",uses=3},
	["item_crafting_collection_reward_engine_01_mk2_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk2.iff",uses=3},
	["item_crafting_collection_reward_engine_01_mk3_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk3.iff",uses=3},
	["item_crafting_collection_reward_engine_01_mk4_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk4.iff",uses=3},
	["item_crafting_collection_reward_engine_01_mk5_schematic"]={schematic="object/draft_schematic/space/engine/collection_reward_engine_01_mk5.iff",uses=3},
	["item_crafting_collection_reward_reactor_01_mk1_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_02_mk1.iff",uses=3},
	["item_crafting_collection_reward_reactor_01_mk2_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_02_mk2.iff",uses=3},
	["item_crafting_collection_reward_reactor_01_mk3_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_02_mk3.iff",uses=3},
	["item_crafting_collection_reward_reactor_01_mk4_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_02_mk4.iff",uses=3},
	["item_crafting_collection_reward_reactor_01_mk5_schematic"]={schematic="object/draft_schematic/space/reactor/collection_reward_reactor_01_mk5.iff",uses=3},
	["item_dwartii_statue_braata_schematic_01"]={schematic="object/draft_schematic/item/collection_dwartii_statue_braata.iff",uses=1},
	["item_dwartii_statue_faya_schematic_01"]={schematic="object/draft_schematic/item/collection_dwartii_statue_faya.iff",uses=1},
	["item_dwartii_statue_sistros_schematic_01"]={schematic="object/draft_schematic/item/collection_dwartii_statue_sistros.iff",uses=1},
	["item_dwartii_statue_yanjon_schematic_01"]={schematic="object/draft_schematic/item/collection_dwartii_statue_yanjon.iff",uses=1},
	["item_framed_beetle_specimen_schematic_01"]={schematic="object/draft_schematic/furniture/furniture_framed_beetle_specimen_collection_reward.iff",uses=1},
	["item_gunship_cargo_hold_01"]={schematic="object/draft_schematic/space/cargo_hold/crg_pob_gunship_huge.iff",uses=1},
	["item_gunship_imperial_schematic"]={schematic="object/draft_schematic/space/chassis/player_gunship_imperial.iff",uses=1},
	["item_gunship_neutral_schematic"]={schematic="object/draft_schematic/space/chassis/player_gunship_neutral.iff",uses=1},
	["item_gunship_rebel_schematic"]={schematic="object/draft_schematic/space/chassis/player_gunship_rebel.iff",uses=1},
	["item_limited_use_combat_fan_l_02_01"]={schematic="object/draft_schematic/dance_prop/prop_combat_fan_l.iff",uses=1},
	["item_limited_use_schematic_backdrop_generator_01_01"]={schematic="object/draft_schematic/furniture/furniture_stage_backdrop.iff",uses=1},
	["item_limited_use_schematic_bounty_dc15_04_01"]={schematic="object/draft_schematic/weapon/appearance/weapon_appearance_rifle_dc15_bounty.iff",uses=1},
	["item_limited_use_schematic_bounty_ee3_04_01"]={schematic="object/draft_schematic/weapon/appearance/weapon_appearance_carbine_ee3_bounty.iff",uses=1},
	["item_limited_use_schematic_green_gem_01_01"]={schematic="object/draft_schematic/furniture/furniture_light_gem_green.iff",uses=1},
	["item_limited_use_schematic_jessoon"]={schematic="object/draft_schematic/instrument/instrument_flanged_jessoon.iff",uses=1},
	["item_limited_use_schematic_purple_gem_01_01"]={schematic="object/draft_schematic/furniture/furniture_light_gem_purple.iff",uses=1},
	["item_limited_use_schematic_pyro_machine_01_01"]={schematic="object/draft_schematic/furniture/furniture_stage_pyro.iff",uses=1},
	["item_limited_use_schematic_red_gem_01_01"]={schematic="object/draft_schematic/furniture/furniture_light_gem_red.iff",uses=1},
	["item_limited_use_schematic_smoke_machine_01_01"]={schematic="object/draft_schematic/furniture/furniture_stage_smoke.iff",uses=1},
	["item_limited_use_schematic_stage_controller_01_01"]={schematic="object/draft_schematic/furniture/furniture_stage_controller.iff",uses=1},
	["item_pob_furniture_chair_schematic_01"]={schematic="object/draft_schematic/furniture/furniture_collection_pob_chair.iff",uses=1},
	["item_pob_furniture_couch_schematic_01"]={schematic="object/draft_schematic/furniture/furniture_collection_pob_couch.iff",uses=1},
	["item_schematic_fifth_gen_saber_03_01"]={schematic="object/draft_schematic/weapon/lightsaber_one_handed_gen5.iff",uses=1},
	["item_schematic_fifth_gen_saber_03_02"]={schematic="object/draft_schematic/weapon/lightsaber_two_handed_gen5.iff",uses=1},
	["item_schematic_fifth_gen_saber_03_03"]={schematic="object/draft_schematic/weapon/lightsaber_polearm_gen5.iff",uses=1},
	["item_schematic_pistol_dd6_01_01"]={schematic="object/draft_schematic/weapon/appearance/weapon_appearance_pistol_dd6.iff",uses=1},
}


-- The 25 drafts whose crafted object has no client file. Use must not
-- claim a grant (addRewardedSchematic is not called).
CollectionManager.LOOT_SCHEMATIC_CLIENT_ABSENT = {
	["object/draft_schematic/instrument/instrument_flanged_jessoon.iff"]=true,
	["object/draft_schematic/space/booster/collection_reward_booster_01_mk1.iff"]=true,
	["object/draft_schematic/space/booster/collection_reward_booster_01_mk2.iff"]=true,
	["object/draft_schematic/space/booster/collection_reward_booster_01_mk3.iff"]=true,
	["object/draft_schematic/space/booster/collection_reward_booster_01_mk4.iff"]=true,
	["object/draft_schematic/space/booster/collection_reward_booster_01_mk5.iff"]=true,
	["object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk1.iff"]=true,
	["object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk2.iff"]=true,
	["object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk3.iff"]=true,
	["object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk4.iff"]=true,
	["object/draft_schematic/space/capacitor/collection_reward_capacitor_01_mk5.iff"]=true,
	["object/draft_schematic/space/cargo_hold/crg_pob_gunship_huge.iff"]=true,
	["object/draft_schematic/space/chassis/player_gunship_imperial.iff"]=true,
	["object/draft_schematic/space/chassis/player_gunship_neutral.iff"]=true,
	["object/draft_schematic/space/chassis/player_gunship_rebel.iff"]=true,
	["object/draft_schematic/space/engine/collection_reward_engine_01_mk1.iff"]=true,
	["object/draft_schematic/space/engine/collection_reward_engine_01_mk2.iff"]=true,
	["object/draft_schematic/space/engine/collection_reward_engine_01_mk3.iff"]=true,
	["object/draft_schematic/space/engine/collection_reward_engine_01_mk4.iff"]=true,
	["object/draft_schematic/space/engine/collection_reward_engine_01_mk5.iff"]=true,
	["object/draft_schematic/space/reactor/collection_reward_reactor_01_mk5.iff"]=true,
	["object/draft_schematic/space/reactor/collection_reward_reactor_02_mk1.iff"]=true,
	["object/draft_schematic/space/reactor/collection_reward_reactor_02_mk2.iff"]=true,
	["object/draft_schematic/space/reactor/collection_reward_reactor_02_mk3.iff"]=true,
	["object/draft_schematic/space/reactor/collection_reward_reactor_02_mk4.iff"]=true,
}

CollectionManager.LOOT_SCHEMATIC_BEAST = {
	["item_beast_holocron_04_01"]=true,
	["item_beast_holocron_04_02"]=true,
	["item_beast_holocron_04_03"]=true,
	["item_beast_holocron_04_04"]=true,
	["item_beast_holocron_04_05"]=true,
	["item_beast_holocron_04_08"]=true,
	["item_beast_holocron_04_09"]=true,
	["item_beast_holocron_04_10"]=true,
}

-- collection.java:38 MAXLOOP for grantWeightedRandom
CollectionManager.WEIGHTED_RANDOM_MAXLOOP = 7
-- rewards.tab skill_mod_amount column default i[1]
CollectionManager.SKILL_MOD_AMOUNT_DEFAULT = 1
-- Hook name the journal branch consumes (parallel to quest_signal)
CollectionManager.QUEST_GRANT_HOOK = "questGrant"

CollectionManager.listeners = CollectionManager.listeners or {}
CollectionManager.questSignalListeners = CollectionManager.questSignalListeners or {}
CollectionManager.questGrantListeners = CollectionManager.questGrantListeners or {}

function CollectionManager.addListener(fn)
	if fn == nil then
		return
	end

	CollectionManager.listeners[#CollectionManager.listeners + 1] = fn
end

function CollectionManager.addQuestSignalListener(fn)
	if fn == nil then
		return
	end

	CollectionManager.questSignalListeners[#CollectionManager.questSignalListeners + 1] = fn
end

function CollectionManager.addQuestGrantListener(fn)
	if fn == nil then
		return
	end

	CollectionManager.questGrantListeners[#CollectionManager.questGrantListeners + 1] = fn
end

local function slotIndex(slotName)
	return CollectionData.slotByName[slotName]
end

local function collectionIndex(collectionName)
	return CollectionData.collectionByName[collectionName]
end

local function pageIndex(pageName)
	return CollectionData.pageByName[pageName]
end

local function bookIndex(bookName)
	return CollectionData.bookByName[bookName]
end

local function bookAt(bi)
	return CollectionData.books[bi]
end

local function pageAt(bi, pi)
	local book = bookAt(bi)
	if book == nil then
		return nil
	end

	return book.pages[pi]
end

local function collectionAt(bi, pi, ci)
	local page = pageAt(bi, pi)
	if page == nil then
		return nil
	end

	return page.collections[ci]
end

local function slotAt(bi, pi, ci, si)
	local collection = collectionAt(bi, pi, ci)
	if collection == nil then
		return nil
	end

	return collection.slots[si]
end

local function resolveSlot(slotName)
	local idx = slotIndex(slotName)
	if idx == nil then
		return nil
	end

	local book = bookAt(idx[1])
	local page = pageAt(idx[1], idx[2])
	local collection = collectionAt(idx[1], idx[2], idx[3])
	local slot = slotAt(idx[1], idx[2], idx[3], idx[4])
	if book == nil or page == nil or collection == nil or slot == nil then
		return nil
	end

	return book, page, collection, slot
end

local function hasCategory(slot, categoryName)
	local categories = slot.categories
	if categories == nil then
		return false
	end

	for i = 1, #categories do
		if categories[i] == categoryName then
			return true
		end
	end

	return false
end

local function uniqueAppend(list, seen, value)
	if value == nil or value == "" or seen[value] then
		return
	end

	seen[value] = true
	list[#list + 1] = value
end

local function slotsInCollection(collection)
	local names = {}
	if collection == nil or collection.slots == nil then
		return names
	end

	for i = 1, #collection.slots do
		names[#names + 1] = collection.slots[i].name
	end

	return names
end

local function slotsInPage(page)
	local names = {}
	if page == nil or page.collections == nil then
		return names
	end

	for ci = 1, #page.collections do
		local slots = page.collections[ci].slots
		if slots ~= nil then
			for si = 1, #slots do
				names[#names + 1] = slots[si].name
			end
		end
	end

	return names
end

local function slotsInBook(book)
	local names = {}
	if book == nil or book.pages == nil then
		return names
	end

	for pi = 1, #book.pages do
		local pageSlots = slotsInPage(book.pages[pi])
		for i = 1, #pageSlots do
			names[#names + 1] = pageSlots[i]
		end
	end

	return names
end

local function collectionsInPage(page)
	local names = {}
	if page == nil or page.collections == nil then
		return names
	end

	for i = 1, #page.collections do
		names[#names + 1] = page.collections[i].name
	end

	return names
end

local function collectionsInBook(book)
	local names = {}
	if book == nil or book.pages == nil then
		return names
	end

	for pi = 1, #book.pages do
		local pageCols = collectionsInPage(book.pages[pi])
		for i = 1, #pageCols do
			names[#names + 1] = pageCols[i]
		end
	end

	return names
end

local function filterSlotsByCategory(slotNames, categoryName)
	local out = {}
	for i = 1, #slotNames do
		local idx = slotIndex(slotNames[i])
		if idx ~= nil then
			local slot = slotAt(idx[1], idx[2], idx[3], idx[4])
			if slot ~= nil and hasCategory(slot, categoryName) then
				out[#out + 1] = slotNames[i]
			end
		end
	end

	return out
end

local function categoriesInSlotNames(slotNames)
	local out = {}
	local seen = {}
	for i = 1, #slotNames do
		local idx = slotIndex(slotNames[i])
		if idx ~= nil then
			local slot = slotAt(idx[1], idx[2], idx[3], idx[4])
			if slot ~= nil and slot.categories ~= nil then
				for ci = 1, #slot.categories do
					uniqueAppend(out, seen, slot.categories[ci])
				end
			end
		end
	end

	return out
end

function CollectionManager.getCollectionSlotInfo(slotName)
	local book, page, collection, slot = resolveSlot(slotName)
	if slot == nil then
		return nil
	end

	return {book.name, page.name, collection.name, slot.music or ""}
end

function CollectionManager.isCollectionSlotATitle(slotName)
	local _, _, _, slot = resolveSlot(slotName)
	return slot ~= nil and slot.title == 1
end

function CollectionManager.isCollectionATitle(collectionName)
	local idx = collectionIndex(collectionName)
	if idx == nil then
		return false
	end

	local collection = collectionAt(idx[1], idx[2], idx[3])
	return collection ~= nil and collection.title == 1
end

function CollectionManager.isCollectionPageATitle(pageName)
	local idx = pageIndex(pageName)
	if idx == nil then
		return false
	end

	local page = pageAt(idx[1], idx[2])
	return page ~= nil and page.title == 1
end

function CollectionManager.getCollectionSlotCategoryInfo(slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if slot == nil then
		return {}
	end

	return slot.categories or {}
end

function CollectionManager.getCollectionSlotPrereqInfo(slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if slot == nil then
		return {}
	end

	return slot.prereqs or {}
end

function CollectionManager.getCollectionSlotName(slotId)
	return CollectionData.slotById[slotId]
end

function CollectionManager.getAllCollectionSlotsInCollection(collectionName)
	local idx = collectionIndex(collectionName)
	if idx == nil then
		return {}
	end

	return slotsInCollection(collectionAt(idx[1], idx[2], idx[3]))
end

function CollectionManager.getAllCollectionSlotsInPage(pageName)
	local idx = pageIndex(pageName)
	if idx == nil then
		return {}
	end

	return slotsInPage(pageAt(idx[1], idx[2]))
end

function CollectionManager.getAllCollectionsInPage(pageName)
	local idx = pageIndex(pageName)
	if idx == nil then
		return {}
	end

	return collectionsInPage(pageAt(idx[1], idx[2]))
end

function CollectionManager.getAllCollectionSlotsInBook(bookName)
	local idx = bookIndex(bookName)
	if idx == nil then
		return {}
	end

	return slotsInBook(bookAt(idx))
end

function CollectionManager.getAllCollectionsInBook(bookName)
	local idx = bookIndex(bookName)
	if idx == nil then
		return {}
	end

	return collectionsInBook(bookAt(idx))
end

function CollectionManager.getAllCollectionPagesInBook(bookName)
	local idx = bookIndex(bookName)
	if idx == nil then
		return {}
	end

	local book = bookAt(idx)
	local names = {}
	if book == nil or book.pages == nil then
		return names
	end

	for i = 1, #book.pages do
		names[#names + 1] = book.pages[i].name
	end

	return names
end

function CollectionManager.getAllCollectionBooks()
	local names = {}
	for i = 1, #CollectionData.books do
		names[#names + 1] = CollectionData.books[i].name
	end

	return names
end

function CollectionManager.getAllCollectionSlotsInCategory(categoryName)
	local out = {}
	for i = 1, #CollectionData.books do
		local names = filterSlotsByCategory(slotsInBook(CollectionData.books[i]), categoryName)
		for n = 1, #names do
			out[#out + 1] = names[n]
		end
	end

	return out
end

function CollectionManager.getAllCollectionSlotsInCategoryInCollection(collectionName, categoryName)
	return filterSlotsByCategory(CollectionManager.getAllCollectionSlotsInCollection(collectionName), categoryName)
end

function CollectionManager.getAllCollectionSlotsInCategoryInPage(pageName, categoryName)
	return filterSlotsByCategory(CollectionManager.getAllCollectionSlotsInPage(pageName), categoryName)
end

function CollectionManager.getAllCollectionSlotsInCategoryInBook(bookName, categoryName)
	return filterSlotsByCategory(CollectionManager.getAllCollectionSlotsInBook(bookName), categoryName)
end

function CollectionManager.getAllCollectionSlotCategoriesInCollection(collectionName)
	return categoriesInSlotNames(CollectionManager.getAllCollectionSlotsInCollection(collectionName))
end

function CollectionManager.getAllCollectionSlotCategoriesInPage(pageName)
	return categoriesInSlotNames(CollectionManager.getAllCollectionSlotsInPage(pageName))
end

function CollectionManager.getAllCollectionSlotCategoriesInBook(bookName)
	return categoriesInSlotNames(CollectionManager.getAllCollectionSlotsInBook(bookName))
end

function CollectionManager.getAllCollectionSlotCategories()
	local out = {}
	local seen = {}
	for i = 1, #CollectionData.books do
		local cats = CollectionManager.getAllCollectionSlotCategoriesInBook(CollectionData.books[i].name)
		for c = 1, #cats do
			uniqueAppend(out, seen, cats[c])
		end
	end

	return out
end

function CollectionManager.getCollectionSlotMaxValue(slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if slot == nil then
		return 0
	end

	return slot.maxValue
end

function CollectionManager.getCollectionSlotValue(pPlayer, slotName)
	if pPlayer == nil or slotName == nil or slotIndex(slotName) == nil then
		return 0
	end

	local stored = readScreenPlayData(pPlayer, CollectionManager.SCREENPLAY, slotName)
	return tonumber(stored) or 0
end

function CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if pPlayer == nil or slot == nil then
		return false
	end

	local value = CollectionManager.getCollectionSlotValue(pPlayer, slotName)
	if slot.maxValue < 0 then
		return value >= 1
	end

	return value >= slot.maxValue
end

function CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, slotName)
	local _, _, _, slot = resolveSlot(slotName)
	if pPlayer == nil or slot == nil then
		return false
	end

	local prereqs = slot.prereqs
	if prereqs == nil or #prereqs == 0 then
		return true
	end

	for i = 1, #prereqs do
		if not CollectionManager.hasCompletedCollectionSlot(pPlayer, prereqs[i]) then
			return false
		end
	end

	return true
end

function CollectionManager.hasCompletedCollection(pPlayer, collectionName)
	local names = CollectionManager.getAllCollectionSlotsInCollection(collectionName)
	if pPlayer == nil or #names == 0 then
		return false
	end

	for i = 1, #names do
		if not CollectionManager.hasCompletedCollectionSlot(pPlayer, names[i]) then
			return false
		end
	end

	return true
end

function CollectionManager.hasCompletedCollectionPage(pPlayer, pageName)
	local names = CollectionManager.getAllCollectionsInPage(pageName)
	if pPlayer == nil or #names == 0 then
		return false
	end

	for i = 1, #names do
		if not CollectionManager.hasCompletedCollection(pPlayer, names[i]) then
			return false
		end
	end

	return true
end

function CollectionManager.hasCompletedCollectionBook(pPlayer, bookName)
	local names = CollectionManager.getAllCollectionPagesInBook(bookName)
	if pPlayer == nil or #names == 0 then
		return false
	end

	for i = 1, #names do
		if not CollectionManager.hasCompletedCollectionPage(pPlayer, names[i]) then
			return false
		end
	end

	return true
end

local function storeSlotValue(pPlayer, slotName, value)
	if value == 0 then
		deleteScreenPlayData(pPlayer, CollectionManager.SCREENPLAY, slotName)
		return
	end

	writeScreenPlayData(pPlayer, CollectionManager.SCREENPLAY, slotName, tostring(value))
end

function CollectionManager.clearCollection(pPlayer, collectionName)
	if pPlayer == nil then
		return
	end

	local names = CollectionManager.getAllCollectionSlotsInCollection(collectionName)
	for i = 1, #names do
		deleteScreenPlayData(pPlayer, CollectionManager.SCREENPLAY, names[i])
	end
end

function CollectionManager.onSlotModified(pPlayer, bookName, pageName, collectionName, slotName, isCounter, prev, cur, maxValue, completed)
	CollectionManager.handleCollectionSlotModified(pPlayer, bookName, pageName, collectionName, slotName, isCounter, prev, cur, maxValue, completed)

	for i = 1, #CollectionManager.listeners do
		CollectionManager.listeners[i](pPlayer, bookName, pageName, collectionName, slotName, isCounter, prev, cur, maxValue, completed)
	end
end

function CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, delta)
	local book, page, collection, slot = resolveSlot(slotName)
	if pPlayer == nil or slot == nil then
		return false
	end

	delta = tonumber(delta) or 0
	if delta == 0 then
		return false
	end

	local prev = CollectionManager.getCollectionSlotValue(pPlayer, slotName)
	local isCounter = slot.maxValue >= 0
	local cur = prev
	if isCounter then
		cur = prev + delta
		if cur < 0 then
			cur = 0
		end
		if slot.maxValue >= 0 and cur > slot.maxValue then
			cur = slot.maxValue
		end
	else
		if delta > 0 then
			cur = 1
		else
			cur = 0
		end
	end

	if cur == prev then
		return false
	end

	storeSlotValue(pPlayer, slotName, cur)

	local completed = false
	if isCounter then
		completed = cur >= slot.maxValue
	else
		completed = cur >= 1
	end

	if not hasCategory(slot, CollectionManager.NO_SCRIPT_NOTIFY) then
		CollectionManager.onSlotModified(pPlayer, book.name, page.name, collection.name, slotName, isCounter, prev, cur, slot.maxValue, completed)
	end

	return true
end

local function sendCollectionProse(pPlayer, stringId, slotName, collectionName)
	local messageString = LuaStringIdChatParameter(stringId)
	if slotName ~= nil then
		messageString:setTU("@collection_n:" .. slotName)
	end
	if collectionName ~= nil then
		messageString:setTO("@collection_n:" .. collectionName)
	end
	CreatureObject(pPlayer):sendSystemMessage(messageString:_getObject())
end

-- player_collection.java:27 OnCollectionSlotModified
function CollectionManager.handleCollectionSlotModified(pPlayer, bookName, pageName, collectionName, slotName, isCounter, prev, cur, maxValue, completed)
	if pPlayer == nil then
		return
	end

	-- player_collection.java:29 — badge_book has its own message path.
	-- NGE: the native slot IS the badge. OURS: award the Core3 badge on complete.
	if bookName == CollectionManager.BADGE_BOOK then
		if completed then
			CollectionManager.grantBadgeSlot(pPlayer, slotName)
		end
		return
	end

	local collectionSlots = CollectionManager.getAllCollectionSlotsInCollection(collectionName)
	if #collectionSlots == 0 then
		return
	end

	local newCollection = true
	local canResetCollection = false
	for i = 1, #collectionSlots do
		if collectionSlots[i] ~= slotName then
			if CollectionManager.getCollectionSlotValue(pPlayer, collectionSlots[i]) > 0 then
				newCollection = false
				break
			end
		end
	end

	local _, _, _, slot = resolveSlot(slotName)
	if slot == nil then
		return
	end

	local isHidden = slot.hidden == 1
	-- player_collection.java:56-63 first slot of a new collection, not hidden
	if newCollection and cur == 1 and not isHidden then
		sendCollectionProse(pPlayer, "@collection:player_hidden_slot_added", slotName, collectionName)
		CreatureObject(pPlayer):playMusicMessage("sound/utinni.snd")
	end

	local categories = slot.categories or {}
	for i = 1, #categories do
		local category = categories[i]
		-- player_collection.java:68-69 rewardOnUpdate
		if category == CollectionManager.REWARD_ON_UPDATE then
			CollectionManager.grantCollectionReward(pPlayer, slotName, false)
		end
		-- player_collection.java:71-77 updateOnCount:<n>
		if string.sub(category, 1, string.len(CollectionManager.UPDATE_ON_COUNT)) == CollectionManager.UPDATE_ON_COUNT then
			local countToUpdateAt = tonumber(string.match(category, ":(%d+)$"))
			if countToUpdateAt ~= nil and countToUpdateAt == cur and isCounter then
				CollectionManager.grantCollectionReward(pPlayer, slotName .. ":" .. tostring(countToUpdateAt), false)
			end
		end
	end

	if not completed then
		return
	end

	local giveMessage = true
	for i = 1, #categories do
		local category = categories[i]
		-- player_collection.java:88-89 rewardOnComplete
		if category == CollectionManager.REWARD_ON_COMPLETE then
			CollectionManager.grantCollectionReward(pPlayer, slotName, false)
		end
		-- player_collection.java:91-92 noMessage
		if category == CollectionManager.NO_MESSAGE then
			giveMessage = false
		end
		-- player_collection.java:94-96
		if bookName == "saga_relic_book" then
			giveMessage = false
		end
		-- player_collection.java:97-98 clearOnComplete
		if category == CollectionManager.CLEAR_ON_COMPLETE and CollectionManager.hasCompletedCollection(pPlayer, collectionName) then
			canResetCollection = true
		end
	end

	if isHidden and giveMessage then
		-- player_collection.java:102-108
		sendCollectionProse(pPlayer, "@collection:player_hidden_slot_added", slotName, collectionName)
		CreatureObject(pPlayer):playMusicMessage("sound/utinni.snd")
	elseif giveMessage then
		-- player_collection.java:110-116
		sendCollectionProse(pPlayer, "@collection:player_slot_added", slotName, collectionName)
		CreatureObject(pPlayer):playMusicMessage("sound/utinni.snd")
	end

	if CollectionManager.hasCompletedCollection(pPlayer, collectionName) then
		local colIdx = collectionIndex(collectionName)
		local collection = nil
		if colIdx ~= nil then
			collection = collectionAt(colIdx[1], colIdx[2], colIdx[3])
		end
		local collectionHidden = collection ~= nil and collection.hidden == 1
		-- player_collection.java:123-133
		if not collectionHidden then
			sendCollectionProse(pPlayer, "@collection:player_collection_complete", nil, collectionName)
		end
		CollectionManager.grantCollectionReward(pPlayer, collectionName, canResetCollection)
	end
end

function CollectionManager.rewardsFor(collectionName)
	local indices = CollectionData.rewardsByName[collectionName]
	local rows = {}
	if indices == nil then
		return rows
	end

	for i = 1, #indices do
		rows[#rows + 1] = CollectionData.rewards[indices[i]]
	end

	return rows
end

local function splitComma(text)
	local out = {}
	if text == nil or text == "" then
		return out
	end

	for part in string.gmatch(text, "[^,]+") do
		local trimmed = string.match(part, "^%s*(.-)%s*$")
		if trimmed ~= nil and trimmed ~= "" then
			out[#out + 1] = trimmed
		end
	end

	return out
end

local function itemIsIff(item)
	if string.find(item, ".iff", 1, true) ~= nil then
		return true
	end

	if string.sub(item, 1, 7) == "object/" then
		return true
	end

	return false
end

local function playerGhost(pPlayer)
	if pPlayer == nil then
		return nil
	end

	return CreatureObject(pPlayer):getPlayerObject()
end

local function giveIffItem(pPlayer, template)
	local pInventory = CreatureObject(pPlayer):getSlottedObject("inventory")
	if pInventory == nil then
		return nil
	end

	if string.sub(template, -4) ~= ".iff" then
		template = template .. ".iff"
	end

	-- DirectorManager.cpp:2431 giveItem (register :479)
	return giveItem(pInventory, template, -1)
end

-- collection.java:1321-1322: last ':' segment of item_stats objvars is the slot.
local function staticItemSlotName(info)
	if info == nil or info.slot == nil or info.slot == "" then
		return nil
	end

	return string.match(info.slot, "([^:]+)$")
end

-- collection.java:179-235. Iff paths go through giveItem. Static-item names
-- resolve through CollectionStaticItems (static_item.java:16-19). Grant with
-- DirectorManager.cpp:2431 giveItem when inFork. loot_schematic.beast items
-- are beast-master holocrons (absent system); the item is still granted.
-- loot_schematic.schematic: attach Use -> PlayerObject:addRewardedSchematic.
local function bindLootSchematic(pItem, itemName)
	if pItem == nil or itemName == nil then
		return
	end

	if CollectionManager.LOOT_SCHEMATIC_BEAST[itemName] == true then
		return
	end

	local rec = CollectionManager.LOOT_SCHEMATICS[itemName]
	if rec == nil or rec.schematic == nil or rec.schematic == "" then
		return
	end

	local oid = SceneObject(pItem):getObjectID()
	writeStringData(oid .. ":collection.lootSchematic", rec.schematic)
	writeData(oid .. ":collection.lootSchematicUses", rec.uses or 1)
	SceneObject(pItem):setObjectMenuComponent("CollectionLootSchematicMenuComponent")
end

local function sendRewardItemMessage(pPlayer, pItem)
	if pPlayer == nil or pItem == nil then
		return
	end

	-- collection.java:1351 / 1375 SID_REWARD_ITEM
	local itemMessage = LuaStringIdChatParameter("@collection:reward_item")
	itemMessage:setTT(SceneObject(pItem):getDisplayedName())
	CreatureObject(pPlayer):sendSystemMessage(itemMessage:_getObject())
end

local function grantOneStaticItem(pPlayer, itemName)
	local info = CollectionStaticItems[itemName]
	if info == nil then
		print("CollectionManager: template absent from this server (unknown): " .. itemName)
		return nil
	end

	if info.inFork ~= true then
		print("CollectionManager: template absent from this server: " .. itemName)
		return nil
	end

	local pItem = giveIffItem(pPlayer, info.template)
	if pItem ~= nil then
		if CollectionLoot ~= nil and info.consumeLoot == true then
			CollectionLoot.attachLootItemComponent(pItem)
		end
		if info.displayName ~= nil and info.displayName ~= "" then
			-- OURS: Core3 has no master_item string_name; setCustomObjectName (LuaSceneObject.cpp:39)
			SceneObject(pItem):setCustomObjectName(info.displayName)
		end
		if info.slot ~= nil and info.slot ~= "" then
			-- OURS: Core3 has no per-object item_stats; writeStringData(oid .. ":collection.slot", slot)
			local oid = SceneObject(pItem):getObjectID()
			writeStringData(oid .. ":collection.slot", info.slot)
		end
		if info.lootSchematic == true then
			bindLootSchematic(pItem, itemName)
		end
	end

	return pItem
end

local function grantRewardItem(pPlayer, itemName, stackAmount)
	if itemName == nil or itemName == "" then
		return nil
	end

	-- OURS: no setUseCount Lua binding. grant the item N times so the player
	-- holds the shipped stackAmount (collection.java:193-196 setCount).
	local count = tonumber(stackAmount) or 1
	if count < 1 then
		count = 1
	end

	local pItem = nil
	for _ = 1, count do
		if itemIsIff(itemName) then
			pItem = giveIffItem(pPlayer, itemName)
		else
			pItem = grantOneStaticItem(pPlayer, itemName)
			if pItem == nil then
				return nil
			end
		end
	end

	sendRewardItemMessage(pPlayer, pItem)
	return pItem
end

-- collection.java:1303 getRandomItem — rand(0, length-1)
local function pickRandomItem(items)
	if items == nil or #items == 0 then
		return nil
	end

	local index = getRandomNumber(1, #items)
	return items[index]
end

-- collection.java:1313-1339 getWeightedRandomItem. Re-roll only while the
-- picked item's item_stats slot is already completed (MAXLOOP tries). The last
-- pick is kept when every try is complete (java leaves randomChoice there).
local function pickWeightedRandomItem(pPlayer, items)
	if items == nil or #items == 0 then
		return nil
	end

	local choice = items[1]
	for _ = 1, CollectionManager.WEIGHTED_RANDOM_MAXLOOP do
		choice = pickRandomItem(items)
		local info = CollectionStaticItems[choice]
		local slotName = staticItemSlotName(info)
		if slotName == nil or not CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName) then
			break
		end
	end

	return choice
end

-- xp.java:2023-2032 repeatCollectionXpModifier
local function repeatCollectionXpModifier(repeatSlotValue)
	local repeatMultiplier = 1.0 - (repeatSlotValue / 10.0)
	if repeatMultiplier < 0.1 then
		repeatMultiplier = 0.1
	end

	return repeatMultiplier
end

-- collection.java:236-242 grantCommand. Core3: PlayerObject:addAbility.
local function grantRewardCommand(pPlayer, commandName)
	local pGhost = playerGhost(pPlayer)
	if pGhost == nil or commandName == nil or commandName == "" then
		return false
	end

	local ghost = PlayerObject(pGhost)
	if not ghost:hasAbility(commandName) then
		ghost:addAbility(commandName)
	end

	return ghost:hasAbility(commandName)
end

-- collection.java:244-259. Permanence: applySkillStatisticModifier (not a buff).
-- Lua has CreatureObject:getSkillMod only; addSkillMod is not bound.
-- OPEN: CreatureObject:addSkillMod is not bound in Lua -- the ONE item that needs C++
-- Amount: rewards.tab skill_mod_amount default i[1] when the cell is empty.
-- Cap: skip when current >= skillModMax unless skillModMax == -1.
local function grantRewardSkillMod(pPlayer, skillMod, amount, skillModMax)
	if pPlayer == nil or skillMod == nil or skillMod == "" then
		return false
	end

	amount = tonumber(amount) or CollectionManager.SKILL_MOD_AMOUNT_DEFAULT
	skillModMax = tonumber(skillModMax) or 10
	local current = CreatureObject(pPlayer):getSkillMod(skillMod)
	if current >= skillModMax and skillModMax ~= -1 then
		return true
	end

	return false
end

-- collection.java:169-177 groundquests.grantQuestNoAcceptUI. Raised on
-- questGrant for the journal branch's listener.
local function raiseQuestGrant(pPlayer, questName)
	if questName == nil or questName == "" then
		return
	end

	for i = 1, #CollectionManager.questGrantListeners do
		CollectionManager.questGrantListeners[i](pPlayer, questName)
	end
end

function CollectionManager.grantCollectionReward(pPlayer, collectionName, canReset)
	-- collection.java:95-104
	if pPlayer == nil or collectionName == nil or collectionName == "" then
		return false
	end

	local rows = CollectionManager.rewardsFor(collectionName)
	if #rows == 0 then
		return false
	end

	-- collection.java:105 dataTableSearchColumnForString — first matching row
	local row = rows[1]

	-- collection.java:126-139 slot_name (comma list). badge_book slots: java
	-- badge.grantBadge; OURS modifyCollectionSlotValue which completes the slot
	-- and grantBadgeSlot awards the Core3 badge (handleCollectionSlotModified).
	if row.slotName ~= nil and row.slotName ~= "" then
		local slots = splitComma(row.slotName)
		for i = 1, #slots do
			CollectionManager.modifyCollectionSlotValue(pPlayer, slots[i], 1)
		end
	end

	-- collection.java:142-167 xpModifier. Amount rule: CollectionManager.XP_MODIFIER_SCALE
	-- (OURS; the NGE level-band width does not exist Pre-CU). Repeat:
	-- xp.java:1945-1952 / 2023-2032 repeatCollectionXpModifier.
	-- isSpaceXp -> space_combat_general (collection.java:144-166).
	local xpModifier = tonumber(row.xpModifier) or 0
	if xpModifier > 0 then
		local xpAmount = math.floor(xpModifier * CollectionManager.XP_MODIFIER_SCALE)
		local repeatSlotValue = CollectionManager.getCollectionSlotValue(pPlayer, collectionName .. "_tracker") - 1
		if repeatSlotValue > 0 then
			xpAmount = math.floor(xpModifier * CollectionManager.XP_MODIFIER_SCALE * repeatCollectionXpModifier(repeatSlotValue))
		end
		if xpAmount > 0 then
			local xpType = CollectionManager.XP_TYPE
			if row.isSpaceXp == 1 then
				xpType = CollectionManager.SPACE_XP_TYPE
			end
			CreatureObject(pPlayer):awardExperience(xpType, xpAmount, true)
			local xpMessage = LuaStringIdChatParameter("@collection:reward_xp_amount")
			xpMessage:setDI(xpAmount)
			CreatureObject(pPlayer):sendSystemMessage(xpMessage:_getObject())
		end
	end

	-- collection.java:169-177 quest — raised on questGrant for the journal branch's listener
	if row.quest ~= nil and row.quest ~= "" then
		local quests = splitComma(row.quest)
		for i = 1, #quests do
			raiseQuestGrant(pPlayer, quests[i])
		end
	end

	-- collection.java:179-235 item, including grantRandomItem / grantWeightedRandom
	if row.item ~= nil and row.item ~= "" then
		local items = splitComma(row.item)
		local stackAmount = row.stackAmount or 1
		if row.grantRandomItem == 1 then
			-- collection.java:185-196
			grantRewardItem(pPlayer, pickRandomItem(items), stackAmount)
		elseif row.grantWeightedRandom == 1 then
			-- collection.java:198-209
			grantRewardItem(pPlayer, pickWeightedRandomItem(pPlayer, items), stackAmount)
		else
			for i = 1, #items do
				grantRewardItem(pPlayer, items[i], stackAmount)
			end
		end
	end

	-- collection.java:236-242 command
	if row.command ~= nil and row.command ~= "" then
		local commands = splitComma(row.command)
		for i = 1, #commands do
			grantRewardCommand(pPlayer, commands[i])
		end
	end

	-- collection.java:244-259 skill_mod. OPEN: CreatureObject:addSkillMod is not bound in Lua -- the ONE item that needs C++
	if row.skillMod ~= nil and row.skillMod ~= "" then
		local skillMods = splitComma(row.skillMod)
		local amount = row.skillModAmount or CollectionManager.SKILL_MOD_AMOUNT_DEFAULT
		local skillModMax = row.skillModMax
		for i = 1, #skillMods do
			grantRewardSkillMod(pPlayer, skillMods[i], amount, skillModMax)
		end
	end

	-- collection.java:261-264 quest_signal
	if row.questSignal ~= nil and row.questSignal ~= "" then
		for i = 1, #CollectionManager.questSignalListeners do
			CollectionManager.questSignalListeners[i](pPlayer, row.questSignal)
		end
	end

	-- reward_text is type `c` in rewards.tab — shipped prose, not an STF key.
	if row.rewardText ~= nil and row.rewardText ~= "" then
		CreatureObject(pPlayer):sendSystemMessage(row.rewardText)
	end

	-- collection.java:266-268 clearOnComplete
	if canReset == true then
		CollectionManager.clearCollection(pPlayer, collectionName)
	end

	return true
end

-- Completing a badge_book slot whose name matches a Core3 badge key awards
-- that badge. OURS: player_collection.java has no equivalent (NGE slot == badge).
function CollectionManager.grantBadgeSlot(pPlayer, slotName)
	if pPlayer == nil or slotName == nil or slotName == "" then
		return false
	end

	local badgeId = CollectionBadges.badgeIdForSlot(slotName)
	if badgeId == nil then
		return false
	end

	local pGhost = playerGhost(pPlayer)
	if pGhost == nil then
		return false
	end

	local ghost = PlayerObject(pGhost)
	if not ghost:hasBadge(badgeId) then
		ghost:awardBadge(badgeId)
	end

	return true
end

-- collection.java:272 updateCraftingSlot. crafting_template + category are a
-- reverse index (rewards.tab comments: "nothing to do with the rest of the
-- table"). First matching craftingTemplate row, then increment every incomplete
-- slot in that category.
function CollectionManager.updateCraftingSlot(pPlayer, template)
	if pPlayer == nil or template == nil or template == "" then
		return false
	end

	local row = nil
	for i = 1, #CollectionData.rewards do
		if CollectionData.rewards[i].craftingTemplate == template then
			row = CollectionData.rewards[i]
			break
		end
	end

	if row == nil or row.category == nil or row.category == "" then
		return false
	end

	local slotNames = CollectionManager.getAllCollectionSlotsInCategory(row.category)
	if #slotNames == 0 then
		return false
	end

	for i = 1, #slotNames do
		local slotName = slotNames[i]
		if not CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName) then
			CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, 1)
			if not CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName) then
				local info = CollectionManager.getCollectionSlotInfo(slotName)
				local collectionName = nil
				if info ~= nil then
					collectionName = info[3]
				end
				sendCollectionProse(pPlayer, "@collection:player_slot_increment", slotName, collectionName)
			end
		end
	end

	return true
end

-- Login sync: badges already earned -> matching badge_book slots.
-- player_collection.java has no login sync (NGE badges are the slots).
function CollectionManager.syncBadgesOnLogin(pPlayer)
	if pPlayer == nil then
		return
	end

	local pGhost = playerGhost(pPlayer)
	if pGhost == nil then
		return
	end

	local ghost = PlayerObject(pGhost)
	local slotNames = CollectionManager.getAllCollectionSlotsInBook(CollectionManager.BADGE_BOOK)
	for i = 1, #slotNames do
		local slotName = slotNames[i]
		if not CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName) then
			local badgeId = CollectionBadges.badgeIdForSlot(slotName)
			if badgeId ~= nil and ghost:hasBadge(badgeId) then
				CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, 1)
			end
		end
	end
end

-- loot_schematic.java:86-117 ITEM_USE; :165-198 TYPE_SCHEMATIC grantSchematic.
-- Core3: PlayerObject:addRewardedSchematic (LuaPlayerObject.cpp:291) type 1 =
-- SchematicList::LOOT (LootSchematicMenuComponent.cpp:82). Radial 20 ITEM_USE.
CollectionLootSchematicMenuComponent = { }

function CollectionLootSchematicMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if pSceneObject == nil or pPlayer == nil then
		return
	end

	if SceneObject(pSceneObject):isASubChildOf(pPlayer) == false then
		return
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@loot_schematic:use_schematic")
end

function CollectionLootSchematicMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if pPlayer == nil or pSceneObject == nil or selectedID ~= 20 then
		return 0
	end

	if SceneObject(pSceneObject):isASubChildOf(pPlayer) == false then
		CreatureObject(pPlayer):sendSystemMessage("@loot_schematic:must_be_holding")
		return 0
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	if pGhost == nil then
		return 0
	end

	local oid = SceneObject(pSceneObject):getObjectID()
	local schematic = readStringData(oid .. ":collection.lootSchematic")
	if schematic == nil or schematic == "" then
		print("CollectionManager: schematic absent")
		return 0
	end

	if CollectionManager.LOOT_SCHEMATIC_CLIENT_ABSENT[schematic] == true then
		print("CollectionManager: schematic's crafted object absent from this client")
		return 0
	end

	local uses = readData(oid .. ":collection.lootSchematicUses")
	if uses == nil or uses == 0 then
		uses = 1
	end

	-- LuaPlayerObject.cpp:297-302: false when SchematicMap has no draft of that path.
	local learned = PlayerObject(pGhost):addRewardedSchematic(schematic, 1, uses, true)
	if learned ~= true then
		print("CollectionManager: schematic absent: " .. schematic)
		return 0
	end

	CreatureObject(pPlayer):sendSystemMessage("@loot_schematic:schematic_learned")
	SceneObject(pSceneObject):destroyObjectFromWorld()
	SceneObject(pSceneObject):destroyObjectFromDatabase()
	return 0
end

return CollectionManager
