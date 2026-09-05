--[[
	Mystical Stones  --  ep3_myyydril_isdan_retrieve_5

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_isdan_retrieve_5.qst and string/en/quest/ground/ep3_myyydril_isdan_retrieve_5.stf.

	THE TASK TREE
		task 0  Retrieve Item  Count 10; LootDropPercent 100; Server Object Template object/tangible/quest/forest_smooth_rocks.iff; ItemName Smooth Stone
		        title Mystical Stones
			task 1  Wait for Signal  Signal Name giveNeat
				task 2  Reward  Bank Credits 2000; Item object/tangible/theme_park/myyydril/myyydril_magic_stone.iff
				        title Reward Issued

	SOURCED spawn: kashyyyk_dead_forest.tab:1209 (and sibling rows of the same iff),
	merged-zone frame {#kash-offset} dead forest dx -3548 dz -548.
	OPEN: object/tangible/theme_park/myyydril/myyydril_magic_stone.iff has no repo template; not granted.
	Credits and XP still award.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[80][TIER_3] = 103219. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilIsdanRetrieve5ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilIsdanRetrieve5ScreenPlay",
	repeatable = false,
	rewardCredits = 2000,
	itemTemplate = "object/tangible/quest/forest_smooth_rocks.iff",
	items = {
		{ row = 1209, x = -1789.94, z = 0.389601, y = 1599.84, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1210, x = -1796.14, z = 1.066, y = 1594.53, qw = 0.992809, qx = 0, qy = 0, qz = -0.119712 },
		{ row = 1211, x = -1802.47, z = 1.23961, y = 1585.5, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1212, x = -1808.02, z = 1.37552, y = 1578.73, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1213, x = -1809.44, z = 1.38824, y = 1578.95, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1214, x = -1808.03, z = 1.38265, y = 1582.12, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1215, x = -1814.33, z = 1.3636, y = 1573.86, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1216, x = -1818.33, z = 1.38824, y = 1573.01, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1217, x = -1826.41, z = 1.38824, y = 1565.59, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1218, x = -1829.98, z = 1.38824, y = 1563.72, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1219, x = -1831.92, z = 1.37015, y = 1558.4, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1220, x = -1837.02, z = 1.39786, y = 1554.76, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1221, x = -1694.74, z = 37.7868, y = 1840.26, qw = 0.989506, qx = 0.144492, qy = 0, qz = 0 },
		{ row = 1222, x = -1693.49, z = 38.9259, y = 1835.94, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1223, x = -1702.04, z = 38.7072, y = 1839.9, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1224, x = -1708.78, z = 38.9412, y = 1841.51, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1225, x = -1714.65, z = 38.925, y = 1840.64, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1226, x = -1720.85, z = 38.7112, y = 1853.1, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1227, x = -1724.38, z = 38.8746, y = 1859.67, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1228, x = -1727.77, z = 38.8228, y = 1863.76, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1229, x = -1731.61, z = 38.7845, y = 1868.69, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1230, x = -1728.7, z = 38.8321, y = 1873.9, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1231, x = -1740.69, z = 38.9412, y = 1894.25, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1232, x = -1732.6, z = 38.9179, y = 1892.55, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1233, x = -1736.19, z = 38.9412, y = 1884.77, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1234, x = -1731.67, z = 38.9071, y = 1881.81, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1235, x = -1730.16, z = 38.6431, y = 1885.35, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1236, x = -1676.06, z = 34.1643, y = 1838.6, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1237, x = -1678.74, z = 33.7781, y = 1841.9, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1238, x = -1686.93, z = 33.9404, y = 1845.86, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1239, x = -1688.33, z = 34.0212, y = 1851.33, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1240, x = -1684.21, z = 34.1068, y = 1851.39, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1241, x = -1681.31, z = 33.9814, y = 1849.03, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1242, x = -1672.75, z = 34.0429, y = 1856.23, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1243, x = -1670.96, z = 33.9011, y = 1850.79, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1244, x = -1667.44, z = 33.9114, y = 1844.31, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1245, x = -1664.75, z = 34.0681, y = 1857.24, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1246, x = -1662.32, z = 34.0925, y = 1838.77, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1247, x = -1664.16, z = 34.205, y = 1832.49, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1248, x = -1672.08, z = 33.99, y = 1837.04, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1249, x = -1701.81, z = 34.0179, y = 1860.37, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1250, x = -1702.79, z = 33.9645, y = 1868.17, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1251, x = -1695.73, z = 34.0839, y = 1870.95, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1252, x = -1692.79, z = 33.8814, y = 1860.58, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1253, x = -1685.66, z = 38.9385, y = 1828.05, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1254, x = -1686.68, z = 38.9412, y = 1824.69, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1255, x = -1681.76, z = 38.9412, y = 1823.48, qw = 1, qx = 0, qy = 0, qz = 0 },
	},
}

registerScreenPlay("myyydrilIsdanRetrieve5ScreenPlay", true)

function myyydrilIsdanRetrieve5ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnItems()
	end
end

function myyydrilIsdanRetrieve5ScreenPlay:spawnItems()
	for i = 1, #self.items do
		local d = self.items[i]
		local z = getWorldFloor(d.x, d.y, "kashyyyk")

		if (z == nil or z == 0) then
			z = d.z
		end

		local pObj = spawnSceneObject("kashyyyk", self.itemTemplate, d.x, z, d.y, 0, d.qw, d.qx, d.qy, d.qz)

		if (pObj ~= nil) then
			self:attachObject(pObj)
		end
	end
end

function myyydrilIsdanRetrieve5ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilIsdanRetrieve5MenuComponent")
end

function myyydrilIsdanRetrieve5ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilIsdanRetrieve5ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilIsdanRetrieve5ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilIsdanRetrieve5ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilIsdanRetrieve5ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilIsdanRetrieve5ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilIsdanRetrieve5ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_isdan_retrieve_5:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_isdan_retrieve_5:task00_journal_entry_title")

	return true
end

function myyydrilIsdanRetrieve5ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_isdan_retrieve_5")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilIsdanRetrieve5ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilIsdanRetrieve5ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilIsdanRetrieve5ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilIsdanRetrieve5ScreenPlay:collect(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	local n = self:getCount(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_isdan_retrieve_5:task00_journal_entry_title")

	if (n >= 10) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_isdan_retrieve_5:task01_journal_entry_title")
	end

	return true
end

MyyydrilIsdanRetrieve5MenuComponent = {}

function MyyydrilIsdanRetrieve5MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilIsdanRetrieve5ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_isdan_retrieve_5:task00_journal_entry_title")
end

function MyyydrilIsdanRetrieve5MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	myyydrilIsdanRetrieve5ScreenPlay:collect(pPlayer)

	return 0
end
