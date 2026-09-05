--[[
	ep3_forest_ardon_quest_3  --  ep3_forest_ardon_quest_3

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_ardon_quest_3.qst and string/en/quest/ground/ep3_forest_ardon_quest_3.stf.

	THE TASK TREE
		task 0  Escort
		task 1  Wait for Signal  Signal alldone
		task 2  Reward  credits 0 item 
		task 3  Immediately Complete Quest

	OPEN
		Escort — Core3 has no SOE escort destination (Planet tatooine 0,0,0); not faked

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_ardon_quest_3.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[0][TIER_0] = 0. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

forestArdonQuest3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestArdonQuest3ScreenPlay",
	repeatable = true,
	rewardCredits = 0,
}

registerScreenPlay("forestArdonQuest3ScreenPlay", true)

function forestArdonQuest3ScreenPlay:start()
end

function forestArdonQuest3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestArdonQuest3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestArdonQuest3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestArdonQuest3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestArdonQuest3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:setStage(pPlayer, 0)
end

function forestArdonQuest3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	return true
end

function forestArdonQuest3ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_ardon_quest_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestArdonQuest3ScreenPlay:signalAlldone(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestArdonQuest3ScreenPlay:signalTurnIn(pPlayer)
	return self:signalAlldone(pPlayer)
end

function forestArdonQuest3ScreenPlay:onWorkComplete(pPlayer)
	self:setStage(pPlayer, 2)
end

