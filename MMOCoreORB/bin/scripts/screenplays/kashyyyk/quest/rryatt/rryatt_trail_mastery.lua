--[[
	Rryatt Trail Mastery  --  ep3_rryatt_trail_mastery

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_rryatt_trail_mastery.qst and the shipped stf.

	THE TASK TREE
		task 0   Nothing
		task 1   Wait for Tasks    rryattTrailMasterRoot  -- levelOne..levelFour
		task 14  Wait for Signal   signalLevelOne    (stf task02)
		task 13  Wait for Signal   signalLevelTwo    (stf task03)
		task 12  Wait for Signal   signalLevelThree  (stf task04)
		task 11  Wait for Signal   signalLevelFour   (stf task05)

	OPEN: Core3 has no Wait-for-Tasks journal primitive. Four flags stand in;
	the quest awards when all four signals have been raised.

	Raise site: conversation/rryatt_trail_guide.java action_zoneToNextLevel reads
	NPC objvar zoneLine (rryattOne_rryattTwo .. rryattFour_rryattFive) and sends
	the matching signal. Trail-guide templates exist (ep3_rryatt_trail_guide_m_01..04
	and ep3_rryatt_trail_guide_f_01..04).

	Givers are placed by the Rryatt NPC screenplay. Zone warps
	(handleZoneTransitionRequest) are not implemented. Signals fire from the
	guide conversation when zoneLine is present; without it they do not.

	Grant site: conversation/ep3_achonnko.java. Object iff exists
	(object/mobile/ep3/ep3_achonnko.iff). OPEN: no Creature:new template, so
	conversationTemplate cannot be attached.

	OPEN: Achonnko also grants ep3_achonnko_camo_kit and warps by trailMastery*
	objvars. Camo-kit and the warps are not this arc.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the matching .qst. Do not call the journal engine.

	XP: quest_experience[75][TIER_2] = 62178. See rryatt_quest_xp.lua.
	ALLOW_REPEATS 1. No Reward credits in the .qst.
]]

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
end

function rryattTrailMasteryScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rryattTrailMasteryScreenPlay:hasLevel(pPlayer, n)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, self.levelKeys[n])) == 1
		or self:isComplete(pPlayer)
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
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rryatt_trail_mastery:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rryatt_trail_mastery:task01_journal_entry_title")

	return true
end

function rryattTrailMasteryScreenPlay:signalLevel(pPlayer, n)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	if (n < 1 or n > #self.levelKeys) then
		return false
	end

	if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, self.levelKeys[n])) == 1) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, self.levelKeys[n], "1")
	CreatureObject(pPlayer):sendSystemMessage(self.levelTitles[n])

	if (self:levelCount(pPlayer) >= #self.levelKeys) then
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
