local KashyyykQuestJournal = require("screenplays.kashyyyk.quest.kashyyyk_quest_journal")

--[[
	ep3_trando_ssiksik

	ruling 2026-09-04

	THE TASK TREE
		task 0  Nothing
		task 2  Go to Location   Rally with the Slavers  kashyyyk_main (-103, 18, 97) r=25
		task 4  Wait for Signal  startWookieeAttack (Pressk)
		task 8  Timer 30s -> Encounter wave one   ep3_npc_wookiee_freedom_fighters x5
		task 7  Timer 200s -> Encounter wave two  ep3_npc_wookiee_freedom_fighters x5
		task 5  Timer 400s -> Encounter wave three ep3_npc_wookiee_commando x5
		task 16 Wait for Tasks   all three waves
		task 12 Wait for Signal  rewardSlaverLeader
		task 14 Reward           10000 + lance_trando.iff

	Journal stages mirror the existing screenplay state through KashyyykQuestJournal.

	Each wkeWave* is completed only from that wave's own five spawn ids.
]]

trandoSsiksikScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoSsiksikScreenPlay",
	repeatable = true,
	turnInStage = 5,
	rewardCredits = 10000,
	rewardItem = "object/weapon/melee/polearm/ep3/lance_trando.iff",
	gotoX = -103.00,
	gotoZ = 18.0,
	gotoY = 97.00,
	gotoRadius = 25,
	gotoZone = "kashyyyk_main",
	killCount = 5,
	killTemplates = {
		"ep3_wke_freedom_fighter_01",
		"ep3_wke_freedom_fighter_02",
		"ep3_wke_freedom_fighter_03",
		"ep3_wke_freedom_fighter_04",
		"ep3_wke_freedom_fighter_05",
	},
	wave3Templates = {
		"ep3_wke_commando_01",
		"ep3_wke_commando_02",
		"ep3_wke_commando_03",
	},
}

registerScreenPlay("trandoSsiksikScreenPlay", true)

function trandoSsiksikScreenPlay:start()
end

function trandoSsiksikScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoSsiksikScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	KashyyykQuestJournal.sync(self, pPlayer, stage)
end

function trandoSsiksikScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoSsiksikScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoSsiksikScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoSsiksikScreenPlay:attachGoto(pPlayer)
	self:detachGoto(pPlayer)

	if (self.gotoZone == nil or self.gotoZone == "OPEN") then
		return
	end

	local pArea = spawnActiveArea(self.gotoZone, "object/active_area.iff", self.gotoX, self.gotoZ, self.gotoY, self.gotoRadius, 0)

	if (pArea == nil) then
		return
	end

	writeStringData(SceneObject(pArea):getObjectID() .. ":trandoGotoSp", self.screenplayName)
	writeData(SceneObject(pArea):getObjectID() .. ":trandoGotoPlayer", SceneObject(pPlayer):getObjectID())
	writeScreenPlayData(pPlayer, self.screenplayName, "gotoArea", tostring(SceneObject(pArea):getObjectID()))
	createObserver(ENTEREDAREA, "trandoSsiksikScreenPlay", "notifyEnteredGoto", pArea)

	if (CreatureObject(pPlayer):getZoneName() == self.gotoZone) then
		local dx = SceneObject(pPlayer):getWorldPositionX() - self.gotoX
		local dy = SceneObject(pPlayer):getWorldPositionY() - self.gotoY

		if ((dx * dx + dy * dy) <= (self.gotoRadius * self.gotoRadius)) then
			self:completeGoto(pPlayer)
		end
	end
end

function trandoSsiksikScreenPlay:detachGoto(pPlayer)
	local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "gotoArea"))

	if (oid ~= nil and oid ~= 0) then
		local pArea = getSceneObject(oid)

		if (pArea ~= nil) then
			dropObserver(ENTEREDAREA, "trandoSsiksikScreenPlay", "notifyEnteredGoto", pArea)
			SceneObject(pArea):destroyObjectFromWorld()
		end
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "gotoArea")
end

function trandoSsiksikScreenPlay:completeGoto(pPlayer)
	if (self:getStage(pPlayer) ~= 1) then
		return
	end

	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_ssiksik:task02_journal_entry_title")
	self:onGotoComplete(pPlayer)
end

function trandoSsiksikScreenPlay:onGotoComplete(pPlayer)
end

function trandoSsiksikScreenPlay:notifyEnteredGoto(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local spName = readStringData(SceneObject(pArea):getObjectID() .. ":trandoGotoSp")

	if (spName ~= self.screenplayName) then
		return 0
	end

	if (SceneObject(pPlayer):getObjectID() ~= readData(SceneObject(pArea):getObjectID() .. ":trandoGotoPlayer")) then
		return 0
	end

	self:completeGoto(pPlayer)
	return 1
end

function trandoSsiksikScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function trandoSsiksikScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "trandoSsiksikScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function trandoSsiksikScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "trandoSsiksikScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function trandoSsiksikScreenPlay:notifyEncounterDestroyed(pVictim, pKiller)
	if (pVictim == nil) then return 1 end
	local key = SceneObject(pVictim):getObjectID() .. ":" .. self.screenplayName .. ":owner"
	local pPlayer = getSceneObject(readData(key))
	if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature()) then
		self:notifyKilledCreature(pPlayer, pVictim)
	end
	deleteData(key)
	return 1
end

function trandoSsiksikScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	local stage = self:getStage(pPlayer)

	if (stage < 3 or stage > 4) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimOid = SceneObject(pVictim):getObjectID()
	local wave, slot = nil, nil
	for w = 1, 3 do
		for i = 1, self.killCount do
			if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wave" .. w .. "s" .. i)) == victimOid) then
				wave, slot = w, i
				break
			end
		end
		if (wave ~= nil) then break end
	end
	if (wave == nil) then return 0 end

	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wave" .. tostring(wave))) or 0) == 1) then
		return 0
	end

	if (not self:isWaveSpawn(pPlayer, wave, victimOid)) then
		return 0
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "wave" .. wave .. "s" .. slot, "-1")
	deleteData(victimOid .. ":" .. self.screenplayName .. ":owner")
	deleteData(victimOid .. ":ssiksikWave")
	deleteData(victimOid .. ":ssiksikOwner")

	local key = "wave" .. tostring(wave) .. "kills"
	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, key, tostring(n))
	KashyyykQuestJournal.sync(self, pPlayer, self:getStage(pPlayer))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_ssiksik:task04_journal_entry_title")

	if (n >= self.killCount) then
		writeScreenPlayData(pPlayer, self.screenplayName, "wave" .. tostring(wave), "1")
		KashyyykQuestJournal.sync(self, pPlayer, stage)
		self:maybeWavesDone(pPlayer)
	end

	return 0
end

function trandoSsiksikScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	KashyyykQuestJournal.clear(self, pPlayer)

	local run = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "encounterRun")) or 0) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "encounterRun", tostring(run))
	self:detachKillObserver(pPlayer)
	self:detachGoto(pPlayer)
	self:clearWaveSpawns(pPlayer, 1)
	self:clearWaveSpawns(pPlayer, 2)
	self:clearWaveSpawns(pPlayer, 3)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "wave1")
	deleteScreenPlayData(pPlayer, self.screenplayName, "wave2")
	deleteScreenPlayData(pPlayer, self.screenplayName, "wave3")
	deleteScreenPlayData(pPlayer, self.screenplayName, "wave1kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "wave2kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "wave3kills")
	deleteScreenPlayData(pPlayer, self.screenplayName, "activeWave")
	deleteScreenPlayData(pPlayer, self.screenplayName, "attackStarted")
	self:setStage(pPlayer, 0)
end

function trandoSsiksikScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	KashyyykQuestJournal.begin(self, pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_ssiksik:journal_entry_title")
	self:attachGoto(pPlayer)
	return true
end

function trandoSsiksikScreenPlay:onGotoComplete(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_ssiksik:task02_journal_entry_title")
end

function trandoSsiksikScreenPlay:signalStartWookieeAttack(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "attackStarted", tostring(getTimestamp()))
	self:setStage(pPlayer, 3)
	createEvent(30000, "trandoSsiksikScreenPlay", "timerWaveOne", pPlayer, readScreenPlayData(pPlayer, self.screenplayName, "encounterRun"))
	createEvent(200000, "trandoSsiksikScreenPlay", "timerWaveTwo", pPlayer, readScreenPlayData(pPlayer, self.screenplayName, "encounterRun"))
	createEvent(400000, "trandoSsiksikScreenPlay", "timerWaveThree", pPlayer, readScreenPlayData(pPlayer, self.screenplayName, "encounterRun"))
	return true
end

function trandoSsiksikScreenPlay:timerWaveOne(pPlayer, arg)
	if (pPlayer == nil or tostring(arg) ~= readScreenPlayData(pPlayer, self.screenplayName, "encounterRun")
		or (self:getStage(pPlayer) ~= 3 and self:getStage(pPlayer) ~= 4)) then
		return 0
	end

	self:spawnWave(pPlayer, 1)
	return 0
end

function trandoSsiksikScreenPlay:timerWaveTwo(pPlayer, arg)
	if (pPlayer == nil or tostring(arg) ~= readScreenPlayData(pPlayer, self.screenplayName, "encounterRun")
		or (self:getStage(pPlayer) ~= 3 and self:getStage(pPlayer) ~= 4)) then
		return 0
	end

	self:spawnWave(pPlayer, 2)
	return 0
end

function trandoSsiksikScreenPlay:timerWaveThree(pPlayer, arg)
	if (pPlayer == nil or tostring(arg) ~= readScreenPlayData(pPlayer, self.screenplayName, "encounterRun")
		or (self:getStage(pPlayer) ~= 3 and self:getStage(pPlayer) ~= 4)) then
		return 0
	end

	self:spawnWave(pPlayer, 3)
	return 0
end

function trandoSsiksikScreenPlay:waveTemplates(wave)
	if (wave == 3) then
		return self.wave3Templates
	end

	return self.killTemplates
end

function trandoSsiksikScreenPlay:isWaveSpawn(pPlayer, wave, victimOid)
	for i = 1, 5 do
		local stored = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wave" .. tostring(wave) .. "s" .. tostring(i)))

		if (stored ~= nil and stored == victimOid) then
			return true
		end
	end

	return false
end

function trandoSsiksikScreenPlay:clearWaveSpawns(pPlayer, wave)
	for i = 1, 5 do
		local key = "wave" .. tostring(wave) .. "s" .. tostring(i)
		local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, key))

		if (oid ~= nil and oid ~= 0) then
			local pMob = getSceneObject(oid)
			if (pMob ~= nil) then
				dropObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyEncounterDestroyed", pMob)
			end
			deleteData(oid .. ":" .. self.screenplayName .. ":owner")
			deleteData(oid .. ":ssiksikWave")
			deleteData(oid .. ":ssiksikOwner")
		end

		deleteScreenPlayData(pPlayer, self.screenplayName, key)
	end
end

function trandoSsiksikScreenPlay:spawnWave(pPlayer, wave)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wave" .. tostring(wave))) or 0) == 1) then
		return
	end

	local x = SceneObject(pPlayer):getWorldPositionX()
	local y = SceneObject(pPlayer):getWorldPositionY()
	local z = SceneObject(pPlayer):getWorldPositionZ()
	local zone = CreatureObject(pPlayer):getZoneName()
	local tpls = self:waveTemplates(wave)
	local playerOid = SceneObject(pPlayer):getObjectID()

	for i = 1, self.killCount do
		local key = "wave" .. wave .. "s" .. i
		local stored = tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0
		if (stored ~= -1 and getSceneObject(stored) == nil) then
			local dx = getRandomNumber(10, 25)
			local dy = getRandomNumber(10, 25)
			local tpl = tpls[((i - 1) % #tpls) + 1]
			local pMob = spawnMobile(zone, tpl, 0, x + dx, z, y + dy, 0, 0)

			if (pMob ~= nil) then
				local oid = SceneObject(pMob):getObjectID()
				writeData(oid .. ":ssiksikWave", wave)
				writeData(oid .. ":ssiksikOwner", playerOid)
				writeData(oid .. ":" .. self.screenplayName .. ":owner", playerOid)
				createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyEncounterDestroyed", pMob)
				writeScreenPlayData(pPlayer, self.screenplayName, "wave" .. tostring(wave) .. "s" .. tostring(i), tostring(oid))
			end
		end
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "wave" .. tostring(wave), "0")
	if (readScreenPlayData(pPlayer, self.screenplayName, "wave" .. wave .. "kills") == "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "wave" .. wave .. "kills", "0")
	end
	self:setStage(pPlayer, 4)
	self:attachKillObserver(pPlayer)
end

function trandoSsiksikScreenPlay:maybeWavesDone(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wave1")) or 0) == 1
		and (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wave2")) or 0) == 1
		and (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wave3")) or 0) == 1) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 5)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_ssiksik:task12_journal_entry_title")
	end
end

function trandoSsiksikScreenPlay:signalRewardSlaverLeader(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 5) then
		return false
	end

	self:awardQuest(pPlayer)
	return true
end

function trandoSsiksikScreenPlay:awardQuest(pPlayer)
	KashyyykQuestJournal.complete(self, pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_trando_ssiksik")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, self.rewardItem, -1, true)
	end

	self:clearQuest(pPlayer)
end

function trandoSsiksikScreenPlay:playerLoggedIn(pPlayer)
	local stage = self:getStage(pPlayer)
	if (stage ~= 3 and stage ~= 4) then return end
	local run = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "encounterRun")) or 0) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "encounterRun", tostring(run))
	local now = getTimestamp()
	local started = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "attackStarted")) or now
	writeScreenPlayData(pPlayer, self.screenplayName, "attackStarted", tostring(started))
	local callbacks, delays = {"timerWaveOne", "timerWaveTwo", "timerWaveThree"}, {30, 200, 400}
	for wave = 1, 3 do
		local prefix = "wave" .. wave
		if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, prefix)) ~= 1) then
			if (readScreenPlayData(pPlayer, self.screenplayName, prefix .. "kills") ~= "") then
				-- Older scripts left credited corpse IDs in the spawn list. Preserve their kill count.
				local credited = tonumber(readScreenPlayData(pPlayer, self.screenplayName, prefix .. "kills")) or 0
				for i = 1, self.killCount do
					if (tonumber(readScreenPlayData(pPlayer, self.screenplayName, prefix .. "s" .. i)) == -1) then
						credited = credited - 1
					end
				end
				for i = 1, self.killCount do
					local key = prefix .. "s" .. i
					local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0
					local pMob = getSceneObject(oid)
					if (oid ~= -1 and (pMob == nil or CreatureObject(pMob):isDead())) then
						if (credited > 0) then
							writeScreenPlayData(pPlayer, self.screenplayName, key, "-1")
							credited = credited - 1
						elseif (pMob ~= nil) then
							self:notifyKilledCreature(pPlayer, pMob)
						end
					elseif (pMob ~= nil) then
						writeData(oid .. ":" .. self.screenplayName .. ":owner", SceneObject(pPlayer):getObjectID())
						dropObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyEncounterDestroyed", pMob)
						createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyEncounterDestroyed", pMob)
					end
				end
				self:spawnWave(pPlayer, wave)
			else
				createEvent(math.max(1, (started + delays[wave] - now) * 1000), self.screenplayName, callbacks[wave], pPlayer, tostring(run))
			end
		end
	end
	self:detachKillObserver(pPlayer)
	self:attachKillObserver(pPlayer)
	self:maybeWavesDone(pPlayer)
end
