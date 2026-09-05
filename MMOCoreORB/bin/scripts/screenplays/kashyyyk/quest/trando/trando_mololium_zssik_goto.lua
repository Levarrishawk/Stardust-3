--[[
	@quest/ground/ep3_trando_mololium_zssik_goto:journal_entry_title  --  ep3_trando_mololium_zssik_goto

	ruling 2026-09-04

	SOURCE: quest/ep3_trando_mololium_zssik_goto.qst.

	THE TASK TREE
		task 0  Wait for Signal    readyForMosoliumMission

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	XP: LEVEL 80 TIER 1 = 435.
]]

trandoMololiumZssikGotoScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoMololiumZssikGotoScreenPlay",
	repeatable = true,
	turnInStage = 1,
}


registerScreenPlay("trandoMololiumZssikGotoScreenPlay", true)

function trandoMololiumZssikGotoScreenPlay:start()
end

function trandoMololiumZssikGotoScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoMololiumZssikGotoScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoMololiumZssikGotoScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoMololiumZssikGotoScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoMololiumZssikGotoScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoMololiumZssikGotoScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function trandoMololiumZssikGotoScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_mololium_zssik_goto:journal_entry_title")
	return true
end

function trandoMololiumZssikGotoScreenPlay:signalReadyForMosoliumMission(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_trando_mololium_zssik_goto")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)
	return true
end
