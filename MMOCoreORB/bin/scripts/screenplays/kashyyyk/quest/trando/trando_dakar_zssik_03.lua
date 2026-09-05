--[[
	@quest/ground/ep3_trando_dakar_zssik_03:journal_entry_title  --  ep3_trando_dakar_zssik_03

	ruling 2026-09-04

	SOURCE: quest/ep3_trando_dakar_zssik_03.qst and string/en/quest/ground/ep3_trando_dakar_zssik_03.stf.

	THE TASK TREE
		task 0  Go to Location  Travel to the Kkowir Forest
		task 1  Destroy Multiple and Loot  Kill Tagged Wookiees
		task 2  Wait for Signal  Return to Dakar
		task 3  Reward  Reward Issued

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	XP: quest_experience[34][TIER_3] = 14850. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

trandoDakarZssik03ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoDakarZssik03ScreenPlay",
	repeatable = true,
	turnInStage = 3,
	rewardCredits = 10000,
	killCount = 10,
	lootDropPercent = 60,
	killTemplates = {
		"ep3_wke_civilian_01",
	},
	gotoX = -3464.00,
	gotoZ = 26.00,
	gotoY = -1009.00,
	gotoRadius = 25,
	gotoZone = "kashyyyk",
}

registerScreenPlay("trandoDakarZssik03ScreenPlay", true)

function trandoDakarZssik03ScreenPlay:start()
end

function trandoDakarZssik03ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoDakarZssik03ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoDakarZssik03ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoDakarZssik03ScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoDakarZssik03ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoDakarZssik03ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 0)
end

function trandoDakarZssik03ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_dakar_zssik_03:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_dakar_zssik_03:task00_journal_entry_title")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_accept.snd")
	self:attachGoto(pPlayer)

	return true
end

function trandoDakarZssik03ScreenPlay:attachGoto(pPlayer)
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
	createObserver(ENTEREDAREA, "trandoDakarZssik03ScreenPlay", "notifyEnteredGoto", pArea)

	if (CreatureObject(pPlayer):getZoneName() == self.gotoZone) then
		local dx = SceneObject(pPlayer):getWorldPositionX() - self.gotoX
		local dy = SceneObject(pPlayer):getWorldPositionY() - self.gotoY

		if ((dx * dx + dy * dy) <= (self.gotoRadius * self.gotoRadius)) then
			self:completeGoto(pPlayer)
		end
	end
end

function trandoDakarZssik03ScreenPlay:detachGoto(pPlayer)
	local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "gotoArea"))

	if (oid ~= nil and oid ~= 0) then
		local pArea = getSceneObject(oid)

		if (pArea ~= nil) then
			dropObserver(ENTEREDAREA, "trandoDakarZssik03ScreenPlay", "notifyEnteredGoto", pArea)
			SceneObject(pArea):destroyObjectFromWorld()
		end
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "gotoArea")
end

function trandoDakarZssik03ScreenPlay:completeGoto(pPlayer)
	if (self:getStage(pPlayer) ~= 1) then
		return
	end

	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_dakar_zssik_03:task01_journal_entry_title")
	self:onGotoComplete(pPlayer)
end

function trandoDakarZssik03ScreenPlay:onGotoComplete(pPlayer)
	self:attachKillObserver(pPlayer)
end

function trandoDakarZssik03ScreenPlay:notifyEnteredGoto(pArea, pPlayer)
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

function trandoDakarZssik03ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function trandoDakarZssik03ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "trandoDakarZssik03ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function trandoDakarZssik03ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "trandoDakarZssik03ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function trandoDakarZssik03ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_dakar_zssik_03:task01_journal_entry_title")

	if (n >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 3)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_dakar_zssik_03:task02_journal_entry_title")
	end

	return 0
end

function trandoDakarZssik03ScreenPlay:signalRewardDakar(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	self:awardQuest(pPlayer)
	return true
end

function trandoDakarZssik03ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_trando_dakar_zssik_03")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_sucess.snd")
	self:clearQuest(pPlayer)
end
