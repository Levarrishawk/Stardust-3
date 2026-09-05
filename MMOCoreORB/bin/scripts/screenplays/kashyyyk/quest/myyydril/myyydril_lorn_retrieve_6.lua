--[[
	N-K "Necrosis"  --  ep3_myyydril_lorn_retrieve_6

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_lorn_retrieve_6.qst and string/en/quest/ground/ep3_myyydril_lorn_retrieve_6.stf.

	THE TASK TREE
		task 0  Retrieve Item  Count 1; LootDropPercent 100; Server Object Template object/tangible/quest/r_naktra_crystals.iff; ItemName Radiated Crystal
		        title N-K "Necrosis"
			task 1  Wait for Signal  Signal Name signalLornRetrieveCompleted
				task 3  Immediately Clear Quest  

	spawned by the Myyydril POB object rows; this screenplay attaches its collect radial to
	the spawned object by template name. No object lookup exists here; the POB populator
	must call myyydrilLornRetrieve6ScreenPlay:attachObject(pObject).
	ep3_myyydril_caverns.tab:765 r_naktra_crystals.
	Wait for Signal signalLornRetrieveCompleted is raised by theme_park.dungeon.myyydril.grievous_player,
	which is outside this arc. Immediately Clear Quest: no runs, no XP (TIER -1).
	OPEN: lorn_servant has no repo template (POB row is OPEN).

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[80][TIER_n/a] = 0. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilLornRetrieve6ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilLornRetrieve6ScreenPlay",
	repeatable = false,

}

registerScreenPlay("myyydrilLornRetrieve6ScreenPlay", true)

function myyydrilLornRetrieve6ScreenPlay:start()
end

function myyydrilLornRetrieve6ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilLornRetrieve6ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilLornRetrieve6ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilLornRetrieve6ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilLornRetrieve6ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilLornRetrieve6ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilLornRetrieve6ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_lorn_retrieve_6:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_lorn_retrieve_6:task00_journal_entry_title")

	return true
end

function myyydrilLornRetrieve6ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_lorn_retrieve_6")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

end

function myyydrilLornRetrieve6ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilLornRetrieve6ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilLornRetrieve6ScreenPlay:collect(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "count", "1")
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_lorn_retrieve_6:task00_journal_entry_title")

	return true
end

function myyydrilLornRetrieve6ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	-- Immediately Clear Quest: do not complete, do not award runs.
	self:clearQuest(pPlayer)

	return true
end

function myyydrilLornRetrieve6ScreenPlay:attachObject(pObject)
	if (pObject == nil) then
		return
	end

	SceneObject(pObject):setObjectMenuComponent("MyyydrilLornRetrieve6MenuComponent")
end

MyyydrilLornRetrieve6MenuComponent = {}

function MyyydrilLornRetrieve6MenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (myyydrilLornRetrieve6ScreenPlay:getStage(pPlayer) ~= 1) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_myyydril_lorn_retrieve_6:task00_journal_entry_title")
end

function MyyydrilLornRetrieve6MenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	myyydrilLornRetrieve6ScreenPlay:collect(pPlayer)

	return 0
end

