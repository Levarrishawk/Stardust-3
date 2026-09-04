-- Mustafar bounty-hunt trophy items. Live drops these off the matching creature
-- at 12.5% per kill (creatures.tab intLootRolls=1/intRollPercent=100, then a uniform
-- 1-of-2 pool pick and a uniform 1-of-4 item pick). Encoded here as a single-item
-- group; the creature carries the 12.5% as its lootChance.
--
-- Paths are rooted at scripts/loot/ by LootGroupMap::includeFile, so they climb out.
includeFile("../custom_scripts/loot/items/blistmok_heart.lua")
includeFile("../custom_scripts/loot/items/tulrus_parts.lua")
includeFile("../custom_scripts/loot/items/xandank_jaw.lua")

includeFile("../custom_scripts/loot/groups/som_blistmok_trophy.lua")
includeFile("../custom_scripts/loot/groups/som_tulrus_trophy.lua")
includeFile("../custom_scripts/loot/groups/som_xandank_trophy.lua")
