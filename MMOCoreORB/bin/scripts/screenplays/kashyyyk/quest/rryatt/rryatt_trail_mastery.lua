local KashyyykQuestJournal = require("screenplays.kashyyyk.quest.kashyyyk_quest_journal")

-- DSRC ep3_rryatt_trail_mastery: four independent downward-travel signals.
-- Preserve the existing repeat policy and XP award; journal task IDs are from the client .qst.
rryattTrailMasteryScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rryattTrailMasteryScreenPlay",
	repeatable = true,
	levelKeys = { "l1", "l2", "l3", "l4" },
	levelTitles = {
		"@quest/ground/ep3_rryatt_trail_mastery:task02_journal_entry_title",
		"@quest/ground/ep3_rryatt_trail_mastery:task03_journal_entry_title",
		"@quest/ground/ep3_rryatt_trail_mastery:task04_journal_entry_title",
		"@quest/ground/ep3_rryatt_trail_mastery:task05_journal_entry_title",
	},
	zoneLineToLevel = {
		rryattOne_rryattTwo = 1,
		rryattTwo_rryattThree = 2,
		rryattThree_rryattFour = 3,
		rryattFour_rryattFive = 4,
	},
}

registerScreenPlay("rryattTrailMasteryScreenPlay", true)

function rryattTrailMasteryScreenPlay:start()
end

function rryattTrailMasteryScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rryattTrailMasteryScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	KashyyykQuestJournal.sync(self, pPlayer, stage)
end

function rryattTrailMasteryScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rryattTrailMasteryScreenPlay:hasLevel(pPlayer, n)
	if (pPlayer == nil or type(n) ~= "number" or n ~= math.floor(n) or n < 1 or n > #self.levelKeys) then
		return false
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, self.levelKeys[n])) == 1
		or self:getRuns(pPlayer) > 0
end

function rryattTrailMasteryScreenPlay:levelCount(pPlayer)
	local n = 0

	for i = 1, #self.levelKeys do
		if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, self.levelKeys[i])) == 1) then
			n = n + 1
		end
	end

	return n
end

function rryattTrailMasteryScreenPlay:isComplete(pPlayer)
	return self:getStage(pPlayer) == 0 and self:getRuns(pPlayer) > 0
end

function rryattTrailMasteryScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rryattTrailMasteryScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	KashyyykQuestJournal.clear(self, pPlayer)
	for i = 1, #self.levelKeys do
		deleteScreenPlayData(pPlayer, self.screenplayName, self.levelKeys[i])
	end

	self:setStage(pPlayer, 0)
end

function rryattTrailMasteryScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	KashyyykQuestJournal.begin(self, pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rryatt_trail_mastery:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rryatt_trail_mastery:task01_journal_entry_title")

	return true
end

function rryattTrailMasteryScreenPlay:signalLevel(pPlayer, n)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	if (type(n) ~= "number" or n ~= math.floor(n) or n < 1 or n > #self.levelKeys) then
		return false
	end

	if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, self.levelKeys[n])) == 1) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, self.levelKeys[n], "1")
	KashyyykQuestJournal.sync(self, pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage(self.levelTitles[n])

	if (self:levelCount(pPlayer) >= #self.levelKeys) then
		KashyyykQuestJournal.complete(self, pPlayer)
		KashyyykQuestXp:award(pPlayer, "ep3_rryatt_trail_mastery")
		writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
		self:clearQuest(pPlayer)
	end

	return true
end

function rryattTrailMasteryScreenPlay:signalFromZoneLine(pPlayer, zoneLine)
	if (zoneLine == nil or zoneLine == "") then
		return false
	end

	local n = self.zoneLineToLevel[zoneLine]

	if (n == nil) then
		return false
	end

	return self:signalLevel(pPlayer, n)
end
