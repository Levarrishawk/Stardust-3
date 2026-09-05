--[[
	ep3_trando_boshaz_zssik_02

	ruling 2026-09-04

	THE TASK TREE
		task 0  Go to Location   Find Chawroo  kashyyyk_main (-155, 22, 848) r=15
		task 1  Encounter        ep3_slaver_blackscale_guard x5
		task 3  Wait for Signal  chawrooLifeDebt
		task 4  Wait for Signal  rewardBoshaz
		task 6  Reward           2000

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.
]]

trandoBoshazZssik02ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoBoshazZssik02ScreenPlay",
	repeatable = true,
	turnInStage = 4,
	rewardCredits = 2000,
	gotoX = -155.00,
	gotoZ = 22.0,
	gotoY = 848.00,
	gotoRadius = 15,
	gotoZone = "kashyyyk",
	killCount = 5,
	killTemplates = {
		"ep3_blackscale_guard_m_01",
		"ep3_blackscale_guard_m_02",
		"ep3_blackscale_guard_m_03",
		"ep3_blackscale_guard_m_04",
	},
}

registerScreenPlay("trandoBoshazZssik02ScreenPlay", true)

function trandoBoshazZssik02ScreenPlay:start()
end

function trandoBoshazZssik02ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoBoshazZssik02ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoBoshazZssik02ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoBoshazZssik02ScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoBoshazZssik02ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoBoshazZssik02ScreenPlay:attachGoto(pPlayer)
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
	createObserver(ENTEREDAREA, "trandoBoshazZssik02ScreenPlay", "notifyEnteredGoto", pArea)

	if (CreatureObject(pPlayer):getZoneName() == self.gotoZone) then
		local dx = SceneObject(pPlayer):getWorldPositionX() - self.gotoX
		local dy = SceneObject(pPlayer):getWorldPositionY() - self.gotoY

		if ((dx * dx + dy * dy) <= (self.gotoRadius * self.gotoRadius)) then
			self:completeGoto(pPlayer)
		end
	end
end

function trandoBoshazZssik02ScreenPlay:detachGoto(pPlayer)
	local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "gotoArea"))

	if (oid ~= nil and oid ~= 0) then
		local pArea = getSceneObject(oid)

		if (pArea ~= nil) then
			dropObserver(ENTEREDAREA, "trandoBoshazZssik02ScreenPlay", "notifyEnteredGoto", pArea)
			SceneObject(pArea):destroyObjectFromWorld()
		end
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "gotoArea")
end

function trandoBoshazZssik02ScreenPlay:completeGoto(pPlayer)
	if (self:getStage(pPlayer) ~= 1) then
		return
	end

	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_boshaz_zssik_02:task01_journal_entry_title")
	self:onGotoComplete(pPlayer)
end

function trandoBoshazZssik02ScreenPlay:onGotoComplete(pPlayer)
end

function trandoBoshazZssik02ScreenPlay:notifyEnteredGoto(pArea, pPlayer)
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

function trandoBoshazZssik02ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function trandoBoshazZssik02ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "trandoBoshazZssik02ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function trandoBoshazZssik02ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "trandoBoshazZssik02ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function trandoBoshazZssik02ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 2) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil or not self:isKillTemplate(victimTemplate)) then
		return 0
	end

	if (self.lootDropPercent ~= nil and getRandomNumber(100) > self.lootDropPercent) then
		return 0
	end

	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_boshaz_zssik_02:task01_journal_entry_title")

	if (n >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 3)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_boshaz_zssik_02:task03_journal_entry_title")
	end

	return 0
end

function trandoBoshazZssik02ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	self:detachGoto(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function trandoBoshazZssik02ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_boshaz_zssik_02:journal_entry_title")
	self:attachGoto(pPlayer)
	return true
end

function trandoBoshazZssik02ScreenPlay:onGotoComplete(pPlayer)
	self:spawnAmbush(pPlayer)
	self:attachKillObserver(pPlayer)
end

function trandoBoshazZssik02ScreenPlay:spawnAmbush(pPlayer)
	local x = SceneObject(pPlayer):getWorldPositionX()
	local y = SceneObject(pPlayer):getWorldPositionY()
	local z = SceneObject(pPlayer):getWorldPositionZ()
	local zone = CreatureObject(pPlayer):getZoneName()

	for i = 1, 5 do
		local tpl = self.killTemplates[((i - 1) % #self.killTemplates) + 1]
		spawnMobile(zone, tpl, 0, x + getRandomNumber(-12, 12), z, y + getRandomNumber(-12, 12), 0, 0)
	end
end

function trandoBoshazZssik02ScreenPlay:signalChawrooLifeDebt(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	self:setStage(pPlayer, 4)
	return true
end

function trandoBoshazZssik02ScreenPlay:signalRewardBoshaz(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 4) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_trando_boshaz_zssik_02")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)
	return true
end
