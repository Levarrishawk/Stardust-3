--[[
	The Outcasts  --  ep3_forest_outcast_contact

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_forest_outcast_contact.qst and string/en/quest/ground/ep3_forest_outcast_contact.stf.

	THE TASK TREE
		task 0  Wait for Signal  Signal contact  [The Outcasts]

	The journal engine lives on the journal branches. The client already
	ships quest/ep3_forest_outcast_contact.qst; the journal row comes from the
	integration branch later. This arc does not call the Journal API.

	XP: quest_experience[35][TIER_1] = 193. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 0.
]]

forestOutcastContactScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "forestOutcastContactScreenPlay",
	repeatable = false,
	rewardCredits = 0,
}

registerScreenPlay("forestOutcastContactScreenPlay", true)

function forestOutcastContactScreenPlay:start()
end

function forestOutcastContactScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function forestOutcastContactScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function forestOutcastContactScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function forestOutcastContactScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function forestOutcastContactScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:setStage(pPlayer, 0)
end

function forestOutcastContactScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_outcast_contact:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_outcast_contact:journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_forest_outcast_contact:task00_journal_entry_title")
	return true
end

function forestOutcastContactScreenPlay:awardQuest(pPlayer)
	if (pPlayer == nil) then
		return false
	end
	KashyyykQuestXp:award(pPlayer, "ep3_forest_outcast_contact")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	self:clearQuest(pPlayer)
	return true
end

function forestOutcastContactScreenPlay:signalContact(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:awardQuest(pPlayer)
	return true
end

function forestOutcastContactScreenPlay:signalTurnIn(pPlayer)
	return self:signalContact(pPlayer)
end

