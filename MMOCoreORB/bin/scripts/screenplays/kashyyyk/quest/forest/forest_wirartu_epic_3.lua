--[[
	Kerritamba  --  ep3_forest_wirartu_epic_3

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_wirartu_epic_3.qst and string/en/quest/ground/ep3_forest_wirartu_epic_3.stf.

	THE TASK TREE
		task 0  Wait for Signal  Signal goodguys  [Kerritamba]
		task 1  Reward  credits 5000 item Badge: Arena Champion  [Reward Issued]

	OPEN
		Reward Item Badge: Arena Champion — no matching Core3 badge

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_wirartu_epic_3.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[65][TIER_1] = 347. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestWirartuEpic3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestWirartuEpic3ScreenPlay",
	repeatable = false,
	rewardCredits = 5000,
}

registerScreenPlay("forestWirartuEpic3ScreenPlay", true)

function forestWirartuEpic3ScreenPlay:start()
end

function forestWirartuEpic3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestWirartuEpic3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestWirartuEpic3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestWirartuEpic3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestWirartuEpic3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:setStage(pPlayer, 0)
end

function forestWirartuEpic3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_wirartu_epic_3:task00_journal_entry_title")
	return true
end

function forestWirartuEpic3ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_wirartu_epic_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	-- OPEN: Badge: Arena Champion
	self:clearQuest(pPlayer)
	return true
end

function forestWirartuEpic3ScreenPlay:signalGoodguys(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestWirartuEpic3ScreenPlay:signalTurnIn(pPlayer)
	return self:signalGoodguys(pPlayer)
end

