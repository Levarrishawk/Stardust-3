--[[
	Stop the Deep Woods Poachers  --  ep3_rryatt_tressk_kill_deep_woods_poachers

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_rryatt_tressk_kill_deep_woods_poachers.qst and the shipped stf.

	THE TASK TREE
		task 0  Nothing            (invisible)
		task 1  Destroy Multiple   Count 25, Social Group deep_woods_poacher
		task 2  Wait for Signal    tressk_deepWoodsPoachersCompleted  -- conversation turn-in

	Kill templates:
		deep_woods_poacher social group -> ep3_rryatt_deep_woods_poacher_01..04
		(no lair header for this social group; numbered set members, not look-alikes)

	Giver ep3_rryatt_tressk is placed by the Rryatt NPC screenplay.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the matching .qst. Do not call the journal engine.

	XP: quest_experience[65][TIER_3] = 59142. See rryatt_quest_xp.lua / kashyyyk_quest_xp.lua.
	ALLOW_REPEATS 1.

	OPEN: no lair header for social group deep_woods_poacher. Kill list is the
	repo numbered set. Templates ship socialGroup townsperson, not deep_woods_poacher.
]]

rryattTresskDeepWoodsPoachersScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rryattTresskDeepWoodsPoachersScreenPlay",
	questKey = "ep3_rryatt_tressk_kill_deep_woods_poachers",
	stf = "quest/ground/ep3_rryatt_tressk_kill_deep_woods_poachers",
	repeatable = true,
	killCount = 25,
	killTemplates = {
		"ep3_rryatt_deep_woods_poacher_01",
		"ep3_rryatt_deep_woods_poacher_02",
		"ep3_rryatt_deep_woods_poacher_03",
		"ep3_rryatt_deep_woods_poacher_04"
	},
}

registerScreenPlay("rryattTresskDeepWoodsPoachersScreenPlay", true)

function rryattTresskDeepWoodsPoachersScreenPlay:start()
end

function rryattTresskDeepWoodsPoachersScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rryattTresskDeepWoodsPoachersScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rryattTresskDeepWoodsPoachersScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rryattTresskDeepWoodsPoachersScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function rryattTresskDeepWoodsPoachersScreenPlay:isComplete(pPlayer)
	return self:getStage(pPlayer) == 0 and self:getRuns(pPlayer) > 0
end

function rryattTresskDeepWoodsPoachersScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rryattTresskDeepWoodsPoachersScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rryattTresskDeepWoodsPoachersScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":task01_journal_entry_title")

	return true
end

function rryattTresskDeepWoodsPoachersScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, self.questKey)
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)

	return true
end

function rryattTresskDeepWoodsPoachersScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rryattTresskDeepWoodsPoachersScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rryattTresskDeepWoodsPoachersScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rryattTresskDeepWoodsPoachersScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rryattTresskDeepWoodsPoachersScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rryattTresskDeepWoodsPoachersScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 1) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil or not self:isKillTemplate(victimTemplate)) then
		return 0
	end

	local kills = self:getKills(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(kills))
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":task01_journal_entry_title")

	if (kills >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":task02_journal_entry_title")
		CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":task02_journal_entry_description")
	end

	return 0
end
