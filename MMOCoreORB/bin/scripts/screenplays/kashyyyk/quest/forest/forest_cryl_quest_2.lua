--[[
	The Society: Zhadran  --  ep3_forest_cryl_quest_2

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_cryl_quest_2.qst and string/en/quest/ground/ep3_forest_cryl_quest_2.stf.

	THE TASK TREE
		task 0  Wait for Signal  Signal zhadran  [The Society: Zhadran]
		task 1  Wait for Signal  Signal finish
		task 2  Reward  credits 5000 item   [Reward Issued]

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_cryl_quest_2.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[38][TIER_1] = 209. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestCrylQuest2ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestCrylQuest2ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
}

registerScreenPlay("forestCrylQuest2ScreenPlay", true)

function forestCrylQuest2ScreenPlay:start()
end

function forestCrylQuest2ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestCrylQuest2ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestCrylQuest2ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestCrylQuest2ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestCrylQuest2ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:setStage(pPlayer, 0)
end

function forestCrylQuest2ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_cryl_quest_2:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_cryl_quest_2:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_cryl_quest_2:task00_journal_entry_title")
	return true
end

function forestCrylQuest2ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_cryl_quest_2")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestCrylQuest2ScreenPlay:signalZhadran(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:setStage(pPlayer, 2)
	return true
end

function forestCrylQuest2ScreenPlay:signalFinish(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestCrylQuest2ScreenPlay:signalTurnIn(pPlayer)
	return self:signalFinish(pPlayer)
end

