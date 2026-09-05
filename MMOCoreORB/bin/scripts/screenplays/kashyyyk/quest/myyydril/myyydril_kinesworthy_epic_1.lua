--[[
	Kines' Lost Equipment  --  ep3_myyydril_kinesworthy_epic_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_kinesworthy_epic_1.qst and string/en/quest/ground/ep3_myyydril_kinesworthy_epic_1.stf.

	THE TASK TREE
		task 0  Retrieve Item  Count 1; LootDropPercent 100; Server Object Template object/tangible/quest/camp_crate.iff; ItemName Officer's Log
		        title Kines' Lost Equipment
			task 1  Retrieve Item  Count 1; LootDropPercent 100; Server Object Template object/tangible/quest/kines_equipment.iff; ItemName Kinesworthy's Equipment
			        title Kines' Lost Equipment
				task 2  Wait for Signal  Signal Name phatLewts
					task 3  Reward  Bank Credits 5000; Item object/tangible/wearables/cybernetic/s05/cybernetic_s05_arm_r.iff
					        title Reward Issued

	SOURCED spawn: camp_crate kashyyyk_dead_forest.tab:1294; kines_equipment :1270.
	Merged-zone frame {#kash-offset} dead forest dx -3548 dz -548.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[65][TIER_1] = 347. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilKinesworthyEpic1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilKinesworthyEpic1ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
	rewardItem = "object/tangible/wearables/cybernetic/s05/cybernetic_s05_arm_r.iff",
	items = {
		{ key = "log", template = "object/tangible/quest/camp_crate.iff", row = 1294, x = -1218.29, z = 9.12908, y = 1471.08, qw = 0.926798, qx = 0, qy = -0.375559, qz = 0 },
		{ key = "equip", template = "object/tangible/quest/kines_equipment.iff", row = 1270, x = -1800.9, z = 24.7643, y = 1119.71, qw = 0.911039, qx = 0, qy = -0.412321, qz = 0 },
	},
}

registerScreenPlay("myyydrilKinesworthyEpic1ScreenPlay", true)

function myyydrilKinesworthyEpic1ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnItems()
	end
end

function myyydrilKinesworthyEpic1ScreenPlay:spawnItems()
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

function myyydrilKinesworthyEpic1ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilKinesworthyEpic1MenuComponent")
end

function myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilKinesworthyEpic1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilKinesworthyEpic1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilKinesworthyEpic1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilKinesworthyEpic1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilKinesworthyEpic1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")
	deleteScreenPlayData(pPlayer, self.screenplayName, "log")
	deleteScreenPlayData(pPlayer, self.screenplayName, "equip")

	self:setStage(pPlayer, 0)
end

function myyydrilKinesworthyEpic1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_1:task00_journal_entry_title")

	return true
end

function myyydrilKinesworthyEpic1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_kinesworthy_epic_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, self.rewardItem, -1, true)
	end
	self:clearQuest(pPlayer)

end

function myyydrilKinesworthyEpic1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilKinesworthyEpic1ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilKinesworthyEpic1ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilKinesworthyEpic1ScreenPlay:collect(pPlayer, which)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	if (which ~= "log" and which ~= "equip") then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, which, "1")

	local log = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "log")) or 0
	local equip = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "equip")) or 0

	if (log == 1 and equip == 1) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kinesworthy_epic_1:task02_journal_entry_title")
	end

	return true
end

MyyydrilKinesworthyEpic1MenuComponent = {}

function MyyydrilKinesworthyEpic1MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilKinesworthyEpic1ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_kinesworthy_epic_1:task00_journal_entry_title")
end

function MyyydrilKinesworthyEpic1MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local which = readStringData(SceneObject(pSceneObject):getObjectID() .. ":myyydrilItem")

	myyydrilKinesworthyEpic1ScreenPlay:collect(pPlayer, which)

	return 0
end

