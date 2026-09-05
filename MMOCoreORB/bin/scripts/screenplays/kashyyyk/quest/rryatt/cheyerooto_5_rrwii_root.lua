--[[
	Collect the Rrwii root  --  ep3_cheyerooto_5_rrwii_root

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_cheyerooto_5_rrwii_root.qst and the shipped stf.

	THE TASK TREE
		task 0  Retrieve Item      object/tangible/quest/rrwii_root.iff  Count 5,
		                           ItemName "Rrwii Root", LootDropPercent 100
		task 1  Wait for Signal    rrwiiCollectReward  -- conversation turn-in
		task 2  Reward             Bank Credits 10000

	Iff object/tangible/quest/rrwii_root.iff exists. The five roots sit near
	where the <???> roams. No world origin was in the qst or the surface
	buildout dump.

	OPEN: no spawn coordinates. Roots are not spawned here. Retrieve machine is
	the collect-flag shape; nothing raises collectRoot until the objects are placed.

	OPEN: java sendSignal is rrwiiGiveReward and isTaskActive looks for
	cheyerootoRrwiiComplete. The .qst Wait signal is rrwiiCollectReward. Turn-in
	is the conversation screen s_514.

	OPEN: java grants this quest only after ep3_sera_wrhisch_liver is complete.
	That quest is not in this arc. Conversation still carries the gate.

	Giver ep3_cheyerooto already stands via kashyyyk_static_npcs.lua (main row 1649).
	Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the matching .qst. Do not call the journal engine.

	XP: quest_experience[48][TIER_3] = 29442. See rryatt_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

rryattCheyerootoRrwiiRootScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rryattCheyerootoRrwiiRootScreenPlay",
	repeatable = true,
	rootCount = 5,
	rewardCredits = 10000,
	rootTemplate = "object/tangible/quest/rrwii_root.iff",
}

registerScreenPlay("rryattCheyerootoRrwiiRootScreenPlay", true)

function rryattCheyerootoRrwiiRootScreenPlay:start()
end

function rryattCheyerootoRrwiiRootScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rryattCheyerootoRrwiiRootScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rryattCheyerootoRrwiiRootScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rryattCheyerootoRrwiiRootScreenPlay:getRoots(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "roots")) or 0
end

function rryattCheyerootoRrwiiRootScreenPlay:isComplete(pPlayer)
	return self:getStage(pPlayer) == 0 and self:getRuns(pPlayer) > 0
end

function rryattCheyerootoRrwiiRootScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rryattCheyerootoRrwiiRootScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "roots")
	self:setStage(pPlayer, 0)
end

function rryattCheyerootoRrwiiRootScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_cheyerooto_5_rrwii_root:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_cheyerooto_5_rrwii_root:task00_journal_entry_title")

	return true
end

function rryattCheyerootoRrwiiRootScreenPlay:collectRoot(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	local n = self:getRoots(pPlayer)

	if (n >= self.rootCount) then
		return false
	end

	n = n + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "roots", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_cheyerooto_5_rrwii_root:task00_item_name")

	if (n >= self.rootCount) then
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_cheyerooto_5_rrwii_root:task01_journal_entry_title")
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_cheyerooto_5_rrwii_root:task01_journal_entry_description")
	end

	return true
end

function rryattCheyerootoRrwiiRootScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_cheyerooto_5_rrwii_root")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

	return true
end
