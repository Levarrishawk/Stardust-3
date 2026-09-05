--[[
	Arena Challenge: Face Wirartu  --  ep3_forest_kerritamba_epic_6

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_kerritamba_epic_6.qst and string/en/quest/ground/ep3_forest_kerritamba_epic_6.stf.

	THE TASK TREE
		task 0  Wait for Signal  Signal wirartu  [Arena Challenge: Face Wirartu]

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_kerritamba_epic_6.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[65][TIER_-1] = 0. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

forestKerritambaEpic6ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestKerritambaEpic6ScreenPlay",
	repeatable = true,
	rewardCredits = 0,
}

registerScreenPlay("forestKerritambaEpic6ScreenPlay", true)

function forestKerritambaEpic6ScreenPlay:start()
end

function forestKerritambaEpic6ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestKerritambaEpic6ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestKerritambaEpic6ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestKerritambaEpic6ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestKerritambaEpic6ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	deleteScreenPlayData(pPlayer, self.screenplayName, "arena")
	self:setStage(pPlayer, 0)
end

function forestKerritambaEpic6ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_6:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_6:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_kerritamba_epic_6:task00_journal_entry_title")
	writeScreenPlayData(pPlayer, self.screenplayName, "arena", "1")
	return true
end

function forestKerritambaEpic6ScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_kerritamba_epic_6")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestKerritambaEpic6ScreenPlay:signalWirartu(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestKerritambaEpic6ScreenPlay:signalTurnIn(pPlayer)
	return self:signalWirartu(pPlayer)
end

function forestKerritambaEpic6ScreenPlay:hasArenaChallenge(pPlayer)
	return self:getStage(pPlayer) > 0 or (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "arena")) or 0) == 1 or self:getRuns(pPlayer) > 0
end

