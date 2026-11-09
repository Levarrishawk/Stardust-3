local KashyyykQuestJournal = require("screenplays.kashyyyk.quest.kashyyyk_quest_journal")

--[[
	ep3_slaver_gursan_entry_quest  --  ep3_slaver_gursan_entry_quest

	ruling 2026-09-04

	THE TASK TREE
		task 8  Wait for Signal  Captain of the Guard / signalSlaverEnterGate
		task 9  Encounter  Captain Beshk / ep3_slaver_blackscale_captain_beshk
		task 10  Wait for Signal  Enter the Compound / signalSlaverCampEntered

	Journal stages mirror the existing screenplay state through KashyyykQuestJournal.

	IFF MATCH (not a look-alike): creatures.tab:1559 maps
		ep3_slaver_blackscale_captain_beshk -> ep3/ep3_blackscale_captain_beshk.iff;
		repo template ep3_blackscale_captain_beshk.lua:29 uses that same iff.
		Enter-gate (stage 1) spawns the encounter; Beshk kill is stage 2;
		signalSlaverCampEntered is stage 3 only.

	OPEN:
		signalSlaverEnterGate / signalSlaverCampEntered raise sites are dungeon scripts
	XP: quest_experience[84][TIER_5] = 185229.
]]

slaverGursanEntryQuestScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "slaverGursanEntryQuestScreenPlay",
	repeatable = true,
	turnInStage = 3,
	killCount = 1,
}
registerScreenPlay("slaverGursanEntryQuestScreenPlay", true)

function slaverGursanEntryQuestScreenPlay:start()
end

function slaverGursanEntryQuestScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function slaverGursanEntryQuestScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	KashyyykQuestJournal.sync(self, pPlayer, stage)
end

function slaverGursanEntryQuestScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function slaverGursanEntryQuestScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function slaverGursanEntryQuestScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function slaverGursanEntryQuestScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "slaverGursanEntryQuestScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function slaverGursanEntryQuestScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "slaverGursanEntryQuestScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function slaverGursanEntryQuestScreenPlay:notifyEncounterDestroyed(pVictim, pKiller)
	if (pVictim == nil) then return 1 end
	local key = SceneObject(pVictim):getObjectID() .. ":" .. self.screenplayName .. ":owner"
	local pPlayer = getSceneObject(readData(key))
	if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature()) then
		self:notifyKilledCreature(pPlayer, pVictim)
	end
	deleteData(key)
	return 1
end

function slaverGursanEntryQuestScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 2) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimOid = SceneObject(pVictim):getObjectID()
	if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "beshkOid")) ~= victimOid) then
		return 0
	end
	writeScreenPlayData(pPlayer, self.screenplayName, "beshkOid", "-1")
	deleteData(victimOid .. ":" .. self.screenplayName .. ":owner")

	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(n))
	KashyyykQuestJournal.sync(self, pPlayer, self:getStage(pPlayer))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slaver_gursan_entry_quest:task01_journal_entry_title")

	if (n >= self.killCount) then
		self:BeshkDefeated(pPlayer)
	end

	return 0
end

function slaverGursanEntryQuestScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	KashyyykQuestJournal.clear(self, pPlayer)

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "beshkOid")) or 0
	local pMob = getSceneObject(oid)
	if (pMob ~= nil) then
		dropObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyEncounterDestroyed", pMob)
	end
	deleteData(oid .. ":" .. self.screenplayName .. ":owner")
	deleteScreenPlayData(pPlayer, self.screenplayName, "beshkOid")
	self:setStage(pPlayer, 0)
end

function slaverGursanEntryQuestScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	KashyyykQuestJournal.begin(self, pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slaver_gursan_entry_quest:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slaver_gursan_entry_quest:task00_journal_entry_title")
	return true
end

function slaverGursanEntryQuestScreenPlay:spawnBeshk(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local existing = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "beshkOid")) or 0
	if (existing ~= 0 and getSceneObject(existing) ~= nil) then
		return true
	end

	local pMob = KashyyykMainPopulation:spawnEncounterMobile(pPlayer, KashyyykMainPopulationData.encounters.slaverCaptainBeshk)
	if (pMob == nil) then
		return false
	end
	local oid = SceneObject(pMob):getObjectID()
	writeScreenPlayData(pPlayer, self.screenplayName, "beshkOid", tostring(oid))
	writeData(oid .. ":" .. self.screenplayName .. ":owner", SceneObject(pPlayer):getObjectID())
	createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyEncounterDestroyed", pMob)
	return true
end

function slaverGursanEntryQuestScreenPlay:signalSlaverEnterGate(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	if (not self:spawnBeshk(pPlayer)) then
		return false
	end
	self:setStage(pPlayer, 2)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slaver_gursan_entry_quest:task01_journal_entry_title")
	return true
end

function slaverGursanEntryQuestScreenPlay:BeshkDefeated(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 3)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slaver_gursan_entry_quest:task02_journal_entry_title")
	return true
end

function slaverGursanEntryQuestScreenPlay:signalSlaverCampEntered(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	KashyyykQuestJournal.complete(self, pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_slaver_gursan_entry_quest")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)
	return true
end

function slaverGursanEntryQuestScreenPlay:playerLoggedIn(pPlayer)
	if (self:getStage(pPlayer) ~= 2) then return end
	self:spawnBeshk(pPlayer)
	local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "beshkOid")) or 0
	local pMob = getSceneObject(oid)
	if (pMob ~= nil and CreatureObject(pMob):isDead()) then
		self:notifyKilledCreature(pPlayer, pMob)
	elseif (pMob ~= nil) then
		writeData(oid .. ":" .. self.screenplayName .. ":owner", SceneObject(pPlayer):getObjectID())
		dropObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyEncounterDestroyed", pMob)
		createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyEncounterDestroyed", pMob)
	end
	self:detachKillObserver(pPlayer)
	if (self:getStage(pPlayer) == 2) then
		self:attachKillObserver(pPlayer)
	end
end
