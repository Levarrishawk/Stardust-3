--[[
	Minstyngar Hunt  --  ep3_rryatt_krepauk_kill_elite_minstyngar

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_rryatt_krepauk_kill_elite_minstyngar.qst and the shipped stf.

	THE TASK TREE
		task 0  Nothing            (invisible)
		task 1  Destroy Multiple   Count 24, Social Group minstyngar_elite (bloodspillers, deathcallers, bonecrushers)
		task 2  Wait for Signal    krepauk_eliteMinstyngarHuntCompleted  -- conversation turn-in

	OPEN: social group minstyngar_elite has no exact repo template. Lair headers
	map named creatures ep3_rryatt_minstyngar_elite_bloodspiller / deathcaller /
	bonecrusher onto minstyngar by iff (kashyyyk_rryatt_minstyngar_elite_*.lua
	line 10), but that name is not the social group, and counting minstyngar
	would also count non-elite spawns. No observer is attached. The stage
	machine still exists; the kill task cannot land.

	Giver ep3_rryatt_krepauk is placed by the Rryatt NPC screenplay.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the matching .qst. Do not call the journal engine.

	XP: quest_experience[82][TIER_4] = 141708. See rryatt_quest_xp.lua / kashyyyk_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

rryattKrepaukEliteMinstyngarScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rryattKrepaukEliteMinstyngarScreenPlay",
	questKey = "ep3_rryatt_krepauk_kill_elite_minstyngar",
	stf = "quest/ground/ep3_rryatt_krepauk_kill_elite_minstyngar",
	repeatable = true,
	killCount = 24,
	killTemplates = {
	},
}

registerScreenPlay("rryattKrepaukEliteMinstyngarScreenPlay", true)

function rryattKrepaukEliteMinstyngarScreenPlay:start()
end

function rryattKrepaukEliteMinstyngarScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rryattKrepaukEliteMinstyngarScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rryattKrepaukEliteMinstyngarScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rryattKrepaukEliteMinstyngarScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function rryattKrepaukEliteMinstyngarScreenPlay:isComplete(pPlayer)
	return self:getStage(pPlayer) == 0 and self:getRuns(pPlayer) > 0
end

function rryattKrepaukEliteMinstyngarScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rryattKrepaukEliteMinstyngarScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function rryattKrepaukEliteMinstyngarScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":task01_journal_entry_title")

	return true
end

function rryattKrepaukEliteMinstyngarScreenPlay:signalTurnIn(pPlayer)
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

function rryattKrepaukEliteMinstyngarScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rryattKrepaukEliteMinstyngarScreenPlay:attachKillObserver(pPlayer)
	return
end

function rryattKrepaukEliteMinstyngarScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rryattKrepaukEliteMinstyngarScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rryattKrepaukEliteMinstyngarScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
