--[[
	Nawika's Jewelry Box  --  ep3_myyydril_nawika_escort_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_nawika_escort_1.qst and string/en/quest/ground/ep3_myyydril_nawika_escort_1.stf.

	THE TASK TREE
		task 5  Retrieve Item  Count 1; LootDropPercent 100; Server Object Template object/tangible/quest/nawika_jewel_box.iff; ItemName Nawika's Jewelry Box
		        title Myyydril Trust - Nawika's Jewelry Box
			task 6  Wait for Signal  Signal Name giveReward
			        title The Necklace
				task 7  Reward  Bank Credits 2000
				        title Reward Issued

	Quest name says escort; the .qst is Retrieve nawika_jewel_box.iff.
	spawned by the Myyydril POB object rows; this screenplay attaches its collect radial to
	the spawned object by template name. No object lookup exists here; the POB populator
	must call myyydrilNawikaEscort1ScreenPlay:attachObject(pObject).
	ep3_myyydril_caverns.tab:834 nawika_jewel_box.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[78][TIER_1] = 424. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilNawikaEscort1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilNawikaEscort1ScreenPlay",
	repeatable = false,
	rewardCredits = 2000,
}

registerScreenPlay("myyydrilNawikaEscort1ScreenPlay", true)

function myyydrilNawikaEscort1ScreenPlay:start()
end

function myyydrilNawikaEscort1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilNawikaEscort1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilNawikaEscort1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilNawikaEscort1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilNawikaEscort1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilNawikaEscort1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilNawikaEscort1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_nawika_escort_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_nawika_escort_1:task00_journal_entry_title")

	return true
end

function myyydrilNawikaEscort1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_nawika_escort_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilNawikaEscort1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function myyydrilNawikaEscort1ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilNawikaEscort1ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilNawikaEscort1ScreenPlay:collect(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	local n = self:getCount(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_nawika_escort_1:task00_journal_entry_title")

	if (n >= 1) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_nawika_escort_1:task01_journal_entry_title")
	end

	return true
end

function myyydrilNawikaEscort1ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilNawikaEscort1MenuComponent")
end

MyyydrilNawikaEscort1MenuComponent = {}

function MyyydrilNawikaEscort1MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilNawikaEscort1ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_nawika_escort_1:task00_journal_entry_title")
end

function MyyydrilNawikaEscort1MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	myyydrilNawikaEscort1ScreenPlay:collect(pPlayer)

	return 0
end

