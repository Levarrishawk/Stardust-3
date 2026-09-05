--[[
	Cleanse the Trail  --  ep3_rryatt_krepauk_cleanse_feral_wookiees

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_rryatt_krepauk_cleanse_feral_wookiees.qst and the shipped stf.

	THE TASK TREE
		task 0  Nothing            (invisible)
		task 1  Destroy Multiple   Count 24, Target Server Template ep3_rryatt_feral_wookiee
		task 2  Wait for Signal    krepauk_feralWookieesCleansed  -- conversation turn-in

	Kill templates:
		ep3_rryatt_feral_wookiee -> ep3_rryatt_feral_wookiee_01..04
		cited: kashyyyk_rryatt_feral_wookiee.lua line 10 (set-rotate numbered set)

	Giver ep3_rryatt_krepauk is placed by the Rryatt NPC screenplay.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the matching .qst. Do not call the journal engine.

	XP: quest_experience[79][TIER_3] = 99572. See rryatt_quest_xp.lua / kashyyyk_quest_xp.lua.
	ALLOW_REPEATS 1.

]]

rryattKrepaukCleanseFeralWookieesScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rryattKrepaukCleanseFeralWookieesScreenPlay",
	questKey = "ep3_rryatt_krepauk_cleanse_feral_wookiees",
	stf = "quest/ground/ep3_rryatt_krepauk_cleanse_feral_wookiees",
	repeatable = true,
	killCount = 24,
	killTemplates = {
		"ep3_rryatt_feral_wookiee_01",
		"ep3_rryatt_feral_wookiee_02",
		"ep3_rryatt_feral_wookiee_03",
		"ep3_rryatt_feral_wookiee_04"
	},
}

registerScreenPlay("rryattKrepaukCleanseFeralWookieesScreenPlay", true)

function rryattKrepaukCleanseFeralWookieesScreenPlay:start()
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:isComplete(pPlayer)
	return self:getStage(pPlayer) == 0 and self:getRuns(pPlayer) > 0
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:grantQuest(pPlayer)
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

function rryattKrepaukCleanseFeralWookieesScreenPlay:signalTurnIn(pPlayer)
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

function rryattKrepaukCleanseFeralWookieesScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rryattKrepaukCleanseFeralWookieesScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rryattKrepaukCleanseFeralWookieesScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rryattKrepaukCleanseFeralWookieesScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
