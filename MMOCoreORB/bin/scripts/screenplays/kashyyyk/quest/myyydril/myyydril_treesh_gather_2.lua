--[[
	Nak'tra Crystals  --  ep3_myyydril_treesh_gather_2

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_treesh_gather_2.qst and string/en/quest/ground/ep3_myyydril_treesh_gather_2.stf.

	THE TASK TREE
		task 0  Retrieve Item  Count 10; LootDropPercent 100; Server Object Template object/tangible/quest/rrwii_root.iff; ItemName Nak'tra Crystal
			task 1  Immediately Complete Quest  

	SOURCED spawn: rrwii_root kashyyyk_hunting.tab:1095 (and sibling rows of the same iff).
	Merged-zone frame {#kash-offset} hunting dx -2048 dz -5048.
	collect() is the Retrieve path. Immediately Complete Quest on count 10. Repeatable.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[80][TIER_3] = 103219. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 1.
]]
myyydrilTreeshGather2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilTreeshGather2ScreenPlay",
	repeatable = true,
	itemTemplate = "object/tangible/quest/rrwii_root.iff",
	items = {
		{ row = 1095, x = -560.34, z = 21.5221, y = -3472.91, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1096, x = 1008, z = 6.67315, y = -3560.85, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1097, x = -1036.22, z = 0.942628, y = -2226.76, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 1098, x = 843.66, z = 4.82644, y = -2863.32, qw = 1, qx = 0, qy = 0, qz = 0 },
		{ row = 2249, x = -1102.003, z = 1.95867, y = -2965.35, qw = 1, qx = 0, qy = 0, qz = 0 },
	},
}

registerScreenPlay("myyydrilTreeshGather2ScreenPlay", true)

function myyydrilTreeshGather2ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnItems()
	end
end

function myyydrilTreeshGather2ScreenPlay:spawnItems()
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

function myyydrilTreeshGather2ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilTreeshGather2MenuComponent")
end

function myyydrilTreeshGather2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilTreeshGather2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilTreeshGather2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilTreeshGather2ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilTreeshGather2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilTreeshGather2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilTreeshGather2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_treesh_gather_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_treesh_gather_2:task00_journal_entry_title")

	return true
end

function myyydrilTreeshGather2ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_treesh_gather_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

end

function myyydrilTreeshGather2ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilTreeshGather2ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilTreeshGather2ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilTreeshGather2ScreenPlay:collect(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	local n = self:getCount(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count", tostring(n))

	if (n >= 10) then
		self:awardQuest(pPlayer)
	end

	return true
end

MyyydrilTreeshGather2MenuComponent = {}

function MyyydrilTreeshGather2MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilTreeshGather2ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_treesh_gather_2:task00_journal_entry_title")
end

function MyyydrilTreeshGather2MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	myyydrilTreeshGather2ScreenPlay:collect(pPlayer)

	return 0
end

