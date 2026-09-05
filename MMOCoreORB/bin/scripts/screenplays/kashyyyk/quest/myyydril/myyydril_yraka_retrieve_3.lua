--[[
	Medical Boxes  --  ep3_myyydril_yraka_retrieve_3

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_yraka_retrieve_3.qst and string/en/quest/ground/ep3_myyydril_yraka_retrieve_3.stf.

	THE TASK TREE
		task 0  Retrieve Item  Count 10; LootDropPercent 100; Server Object Template object/tangible/quest/medical_boxes.iff; ItemName Medical Box
		        title Medical Boxes
			task 1  Wait for Signal  Signal Name giveReward
				task 2  Reward  Bank Credits 3000
				        title Reward Issued

	SOURCED spawn: medical_boxes kashyyyk_dead_forest.tab:1256 (and sibling rows of the same iff).
	Merged-zone frame {#kash-offset} dead forest dx -3548 dz -548.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[38][TIER_3] = 18337. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilYrakaRetrieve3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilYrakaRetrieve3ScreenPlay",
	repeatable = false,
	rewardCredits = 3000,
	itemTemplate = "object/tangible/quest/medical_boxes.iff",
	items = {
		{ row = 1256, x = -1757.28, z = 38.4196, y = 1811.25, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1257, x = -1765.34, z = 38.4196, y = 1811.77, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1258, x = -1765.42, z = 38.4774, y = 1804.89, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1259, x = -1751.04, z = 36.8549, y = 1786.34, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1260, x = -1746.28, z = 37.9924, y = 1775.16, qw = 0.982004, qx = 0, qy = 0, qz = 0.188859 },
		{ row = 1261, x = -1728.97, z = 38.4196, y = 1808.14, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1262, x = -1710.75, z = 38.4196, y = 1804.04, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1263, x = -1714.58, z = 38.4196, y = 1824.27, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1264, x = -1703.15, z = 38.6679, y = 1825.11, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1265, x = -1692.9, z = 38.7299, y = 1820.21, qw = 1, qx = 0, qy = 0, qz = 0 },
	},
}

registerScreenPlay("myyydrilYrakaRetrieve3ScreenPlay", true)

function myyydrilYrakaRetrieve3ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnItems()
	end
end

function myyydrilYrakaRetrieve3ScreenPlay:spawnItems()
	for i = 1, #self.items do
		local d = self.items[i]
		local z = getWorldFloor(d.x, d.y, "kashyyyk")

		if (z == nil or z == 0) then
			z = d.z
		end

		local pObj = spawnSceneObject("kashyyyk", d.template or self.itemTemplate, d.x, z, d.y, 0, d.qw, d.qx, d.qy, d.qz)

		if (pObj ~= nil) then
			if (d.key ~= nil) then
				writeStringData(SceneObject(pObj):getObjectID() .. ":myyydrilItem", d.key)
			end

			self:attachObject(pObj)
		end
	end
end

function myyydrilYrakaRetrieve3ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilYrakaRetrieve3MenuComponent")
end

function myyydrilYrakaRetrieve3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilYrakaRetrieve3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilYrakaRetrieve3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilYrakaRetrieve3ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilYrakaRetrieve3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilYrakaRetrieve3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilYrakaRetrieve3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_retrieve_3:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_retrieve_3:task00_journal_entry_title")

	return true
end

function myyydrilYrakaRetrieve3ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_yraka_retrieve_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilYrakaRetrieve3ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilYrakaRetrieve3ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilYrakaRetrieve3ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilYrakaRetrieve3ScreenPlay:collect(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	local n = self:getCount(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_retrieve_3:task00_journal_entry_title")

	if (n >= 10) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_yraka_retrieve_3:task01_journal_entry_title")
	end

	return true
end

MyyydrilYrakaRetrieve3MenuComponent = {}

function MyyydrilYrakaRetrieve3MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilYrakaRetrieve3ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_yraka_retrieve_3:task00_journal_entry_title")
end

function MyyydrilYrakaRetrieve3MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	myyydrilYrakaRetrieve3ScreenPlay:collect(pPlayer)

	return 0
end

