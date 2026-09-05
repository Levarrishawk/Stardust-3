--[[
	Kirrir's Warl Leaves  --  ep3_myyydril_kirirr_gather_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_kirirr_gather_1.qst and string/en/quest/ground/ep3_myyydril_kirirr_gather_1.stf.

	THE TASK TREE
		task 0  Retrieve Item  Count 10; LootDropPercent 100; Server Object Template object/tangible/quest/warl_cave_plant.iff; ItemName Warl Leaf
		        title Myyydril Trust - Kirrir's Warl Leaves
			task 1  Wait for Signal  Signal Name giveReward
				task 2  Reward  Bank Credits 2000
				        title Reward Issued

	spawned by the Myyydril POB object rows; this screenplay attaches its collect radial to
	the spawned object by template name. No object lookup exists here; the POB populator
	must call myyydrilKirirrGather1ScreenPlay:attachObject(pObject).
	ep3_myyydril_caverns.tab:292 warl_cave_plant.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[37][TIER_3] = 17424. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilKirirrGather1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilKirirrGather1ScreenPlay",
	repeatable = false,
	rewardCredits = 2000,
}

registerScreenPlay("myyydrilKirirrGather1ScreenPlay", true)

function myyydrilKirirrGather1ScreenPlay:start()
end

function myyydrilKirirrGather1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilKirirrGather1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilKirirrGather1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilKirirrGather1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilKirirrGather1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilKirirrGather1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilKirirrGather1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kirirr_gather_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kirirr_gather_1:task00_journal_entry_title")

	return true
end

function myyydrilKirirrGather1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_kirirr_gather_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilKirirrGather1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilKirirrGather1ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilKirirrGather1ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilKirirrGather1ScreenPlay:collect(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	local n = self:getCount(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kirirr_gather_1:task00_journal_entry_title")

	if (n >= 10) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kirirr_gather_1:task01_journal_entry_title")
	end

	return true
end

function myyydrilKirirrGather1ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilKirirrGather1MenuComponent")
end

MyyydrilKirirrGather1MenuComponent = {}

function MyyydrilKirirrGather1MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilKirirrGather1ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_kirirr_gather_1:task00_journal_entry_title")
end

function MyyydrilKirirrGather1MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	myyydrilKirirrGather1ScreenPlay:collect(pPlayer)

	return 0
end

