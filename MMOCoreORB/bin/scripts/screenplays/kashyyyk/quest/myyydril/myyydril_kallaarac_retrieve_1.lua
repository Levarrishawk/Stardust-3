--[[
	Urnsor'is Eggs  --  ep3_myyydril_kallaarac_retrieve_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_kallaarac_retrieve_1.qst and string/en/quest/ground/ep3_myyydril_kallaarac_retrieve_1.stf.

	THE TASK TREE
		task 0  Retrieve Item  Count 20; LootDropPercent 100; Server Object Template object/tangible/quest/pod_egg_sacs.iff; ItemName Urnsor'is Egg
		        title Urnsor'is Eggs
			task 1  Wait for Signal  Signal Name giveStuff
				task 2  Reward  Bank Credits 10000
				        title Reward Issued

	spawned by the Myyydril POB object rows; this screenplay attaches its collect radial to
	the spawned object by template name. No object lookup exists here; the POB populator
	must call myyydrilKallaaracRetrieve1ScreenPlay:attachObject(pObject).
	ep3_myyydril_caverns.tab:593 pod_egg_sacs.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[80][TIER_3] = 103219. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilKallaaracRetrieve1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilKallaaracRetrieve1ScreenPlay",
	repeatable = false,
	rewardCredits = 10000,
}

registerScreenPlay("myyydrilKallaaracRetrieve1ScreenPlay", true)

function myyydrilKallaaracRetrieve1ScreenPlay:start()
end

function myyydrilKallaaracRetrieve1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilKallaaracRetrieve1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilKallaaracRetrieve1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilKallaaracRetrieve1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilKallaaracRetrieve1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilKallaaracRetrieve1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilKallaaracRetrieve1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kallaarac_retrieve_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kallaarac_retrieve_1:task00_journal_entry_title")

	return true
end

function myyydrilKallaaracRetrieve1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_kallaarac_retrieve_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilKallaaracRetrieve1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilKallaaracRetrieve1ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilKallaaracRetrieve1ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilKallaaracRetrieve1ScreenPlay:collect(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	local n = self:getCount(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kallaarac_retrieve_1:task00_journal_entry_title")

	if (n >= 20) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_kallaarac_retrieve_1:task01_journal_entry_title")
	end

	return true
end

function myyydrilKallaaracRetrieve1ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilKallaaracRetrieve1MenuComponent")
end

MyyydrilKallaaracRetrieve1MenuComponent = {}

function MyyydrilKallaaracRetrieve1MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilKallaaracRetrieve1ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_kallaarac_retrieve_1:task00_journal_entry_title")
end

function MyyydrilKallaaracRetrieve1MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	myyydrilKallaaracRetrieve1ScreenPlay:collect(pPlayer)

	return 0
end

