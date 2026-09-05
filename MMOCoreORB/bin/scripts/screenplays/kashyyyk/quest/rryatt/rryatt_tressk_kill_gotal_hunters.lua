--[[
	Defeat the Gotal Hunters  --  ep3_rryatt_tressk_kill_gotal_hunters

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_rryatt_tressk_kill_gotal_hunters.qst and the shipped stf.

	THE TASK TREE
		task 0  Nothing            (invisible)
		task 1  Destroy Multiple   Count 18, Social Group gotal_hunter_rryatt
		task 2  Wait for Signal    tressk_gotalHuntersCompleted

	Kill templates:
		gotal_hunter_rryatt -> numbered set hunter/trapper/champion/leader
		cited: kashyyyk_rryatt_gotal_hunter.lua line 10 and
		kashyyyk_rryatt_gotal_hunter_leader.lua

	Giver ep3_rryatt_tressk is placed by the Rryatt NPC screenplay.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the matching .qst. Do not call the journal engine.

	XP: quest_experience[82][TIER_4] = 141708. See rryatt_quest_xp.lua / kashyyyk_quest_xp.lua.
	ALLOW_REPEATS 1.

	OPEN: .qst Wait signal is tressk_gotalHuntersCompleted; java never sends it.
	Do not invent a raise. Kill-count complete is the completed state; the
	conversation then shows the weapon-choice branch and raises
	tressk_chooseJuntiMace / tressk_chooseFlechettePistol as the java names them.
	Java does not giveItem. sword_mace_junti.iff and pistol_flechette.iff exist
	and are not granted.
	Templates ship socialGroup townsperson, not gotal_hunter_rryatt.
]]

rryattTresskGotalHuntersScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rryattTresskGotalHuntersScreenPlay",
	questKey = "ep3_rryatt_tressk_kill_gotal_hunters",
	stf = "quest/ground/ep3_rryatt_tressk_kill_gotal_hunters",
	repeatable = true,
	killCount = 18,
	killTemplates = {
		"ep3_rryatt_gotal_hunter_01",
		"ep3_rryatt_gotal_hunter_02",
		"ep3_rryatt_gotal_hunter_trapper_01",
		"ep3_rryatt_gotal_hunter_trapper_02",
		"ep3_rryatt_gotal_hunter_champion_01",
		"ep3_rryatt_gotal_hunter_champion_02",
		"ep3_rryatt_gotal_hunter_leader"
	},
}

registerScreenPlay("rryattTresskGotalHuntersScreenPlay", true)

function rryattTresskGotalHuntersScreenPlay:start()
end

function rryattTresskGotalHuntersScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rryattTresskGotalHuntersScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rryattTresskGotalHuntersScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rryattTresskGotalHuntersScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function rryattTresskGotalHuntersScreenPlay:isComplete(pPlayer)
	return self:getStage(pPlayer) == 0 and self:getRuns(pPlayer) > 0
end

function rryattTresskGotalHuntersScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rryattTresskGotalHuntersScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "weapon")
	self:setStage(pPlayer, 0)
end

function rryattTresskGotalHuntersScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "weapon")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":journal_entry_description")
	CreatureObject(pPlayer):sendSystemMessage("@" .. self.stf .. ":task01_journal_entry_title")

	return true
end

function rryattTresskGotalHuntersScreenPlay:signalTurnIn(pPlayer)
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

function rryattTresskGotalHuntersScreenPlay:hasChosenWeapon(pPlayer)
	local weapon = readScreenPlayData(pPlayer, self.screenplayName, "weapon")

	return weapon ~= nil and weapon ~= ""
end

function rryattTresskGotalHuntersScreenPlay:raiseWeaponChoice(pPlayer, signalName)
	if (pPlayer == nil or signalName == nil) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "weapon", signalName)
end

function rryattTresskGotalHuntersScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rryattTresskGotalHuntersScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rryattTresskGotalHuntersScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rryattTresskGotalHuntersScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rryattTresskGotalHuntersScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rryattTresskGotalHuntersScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
		KashyyykQuestXp:award(pPlayer, self.questKey)
		writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
		deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
		self:setStage(pPlayer, 0)
	end

	return 0
end
