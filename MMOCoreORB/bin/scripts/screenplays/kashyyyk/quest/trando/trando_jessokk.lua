--[[
	ep3_trando_jessokk

	ruling 2026-09-04

	THE TASK TREE (nested)
		task 2  Nothing
		task 3  Wait for Signal
			task 5  Timer -> task 10 Wait for Signal -> task 11 Reward -> task 12 Immediately Complete
			task 6  Timer -> task 7 Encounter -> task 8 Immediately Clear
		task 4  Escort -> task 9 Immediately Clear

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	OPEN: see header list. grantQuest exists so a later raise can start the machine; escort and blank encounter do not complete.
]]

trandoJessokkScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoJessokkScreenPlay",
	repeatable = true,
}


registerScreenPlay("trandoJessokkScreenPlay", true)

function trandoJessokkScreenPlay:start()
end

function trandoJessokkScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoJessokkScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoJessokkScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoJessokkScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoJessokkScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoJessokkScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function trandoJessokkScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_jessokk:journal_entry_title")
	return true
end
