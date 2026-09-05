--[[
	The Art of Smuggling  --  ep3_myyydril_pers_retrieve_4

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_pers_retrieve_4.qst and string/en/quest/ground/ep3_myyydril_pers_retrieve_4.stf.

	THE TASK TREE
		task 0  Retrieve Item  Count 1; LootDropPercent 100; Server Object Template object/tangible/quest/naktra_weapons.iff; ItemName Crate of Nak'tra Weapons
		        title The Art of Smuggling
			task 1  Wait for Signal  Signal Name giveLewtSmug
				task 2  Reward  Bank Credits 3000; Item weapon/ranged/rifle/ep3/rifle_naktra_crystal.iff
				        title Reward Issued

	SOURCED spawn: naktra_weapons kashyyyk_dead_forest.tab:1404.
	Merged-zone frame {#kash-offset} dead forest dx -3548 dz -548.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[38][TIER_3] = 18337. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilPersRetrieve4ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilPersRetrieve4ScreenPlay",
	repeatable = false,
	rewardCredits = 3000,
	rewardItem = "object/weapon/ranged/rifle/ep3/rifle_naktra_crystal.iff",
	itemTemplate = "object/tangible/quest/naktra_weapons.iff",
	items = {
		{ row = 1404, x = -1780.33, z = 23.8157, y = 1128.43, qw = 0.860269, qx = 0, qy = -0.509841, qz = 0 },
	},
}

registerScreenPlay("myyydrilPersRetrieve4ScreenPlay", true)

function myyydrilPersRetrieve4ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnItems()
	end
end

function myyydrilPersRetrieve4ScreenPlay:spawnItems()
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

function myyydrilPersRetrieve4ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilPersRetrieve4MenuComponent")
end

function myyydrilPersRetrieve4ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilPersRetrieve4ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilPersRetrieve4ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilPersRetrieve4ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilPersRetrieve4ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilPersRetrieve4ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilPersRetrieve4ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_pers_retrieve_4:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_pers_retrieve_4:task00_journal_entry_title")

	return true
end

function myyydrilPersRetrieve4ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_pers_retrieve_4")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, self.rewardItem, -1, true)
	end
	self:clearQuest(pPlayer)

end

function myyydrilPersRetrieve4ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilPersRetrieve4ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilPersRetrieve4ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilPersRetrieve4ScreenPlay:collect(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	local n = self:getCount(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_pers_retrieve_4:task00_journal_entry_title")

	if (n >= 1) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_pers_retrieve_4:task01_journal_entry_title")
	end

	return true
end

MyyydrilPersRetrieve4MenuComponent = {}

function MyyydrilPersRetrieve4MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilPersRetrieve4ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_pers_retrieve_4:task00_journal_entry_title")
end

function MyyydrilPersRetrieve4MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	myyydrilPersRetrieve4ScreenPlay:collect(pPlayer)

	return 0
end

