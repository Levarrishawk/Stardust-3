--[[
	Mystic Runestone  --  ep3_forest_adressa_retrieve_1

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_adressa_retrieve_1.qst and string/en/quest/ground/ep3_forest_adressa_retrieve_1.stf.

	THE TASK TREE
		task 0  Wait for Signal  Signal curse  [Mystic Runestone]
		task 1  Reward  credits 0 item 
		task 2  Immediately Complete Quest

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_adressa_retrieve_1.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[33][TIER_1] = 187. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

forestAdressaRetrieve1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestAdressaRetrieve1ScreenPlay",
	repeatable = true,
	rewardCredits = 0,
}

registerScreenPlay("forestAdressaRetrieve1ScreenPlay", true)

function forestAdressaRetrieve1ScreenPlay:start()
end

function forestAdressaRetrieve1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestAdressaRetrieve1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestAdressaRetrieve1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestAdressaRetrieve1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestAdressaRetrieve1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:setStage(pPlayer, 0)
end

function forestAdressaRetrieve1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_adressa_retrieve_1:task00_journal_entry_title")
	return true
end

function forestAdressaRetrieve1ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_adressa_retrieve_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestAdressaRetrieve1ScreenPlay:signalCurse(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestAdressaRetrieve1ScreenPlay:signalTurnIn(pPlayer)
	return self:signalCurse(pPlayer)
end

