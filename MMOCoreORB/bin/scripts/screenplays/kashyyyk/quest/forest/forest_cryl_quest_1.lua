--[[
	The Society: Risyl  --  ep3_forest_cryl_quest_1

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_cryl_quest_1.qst and string/en/quest/ground/ep3_forest_cryl_quest_1.stf.

	THE TASK TREE
		task 0  Wait for Signal  Signal bile
		task 1  Wait for Signal  Signal mix
		task 2  Reward  credits 5000 item   [Reward Issued]

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_cryl_quest_1.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[38][TIER_0] = 0. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestCrylQuest1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestCrylQuest1ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
}

registerScreenPlay("forestCrylQuest1ScreenPlay", true)

function forestCrylQuest1ScreenPlay:start()
end

function forestCrylQuest1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestCrylQuest1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestCrylQuest1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestCrylQuest1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestCrylQuest1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:setStage(pPlayer, 0)
end

function forestCrylQuest1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_cryl_quest_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_cryl_quest_1:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_cryl_quest_1:task02_journal_entry_title")
	return true
end

function forestCrylQuest1ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_cryl_quest_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestCrylQuest1ScreenPlay:signalBile(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:setStage(pPlayer, 2)
	return true
end

function forestCrylQuest1ScreenPlay:signalMix(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestCrylQuest1ScreenPlay:signalTurnIn(pPlayer)
	return self:signalMix(pPlayer)
end

