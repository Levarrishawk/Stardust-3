--[[
	@quest/ground/ep3_trando_borantok_02:journal_entry_title  --  ep3_trando_borantok_02

	ruling 2026-09-04

	SOURCE: quest/ep3_trando_borantok_02.qst and string/en/quest/ground/ep3_trando_borantok_02.stf.

	THE TASK TREE
		task 6  Wait for Signal  Return to Borantok
		task 7  Go to Location  Go to the Cantina
		task 8  Wait for Signal  Talk to the Bartender
		task 9  Wait for Signal  Return to Borantok
		task 10  Reward  Reward Issued

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	XP: quest_experience[35][TIER_2] = 11325. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

trandoBorantok02ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoBorantok02ScreenPlay",
	repeatable = true,
	turnInStage = 4,
	rewardCredits = 10000,
	gotoX = -530.00,
	gotoZ = 18.00,
	gotoY = -100.00,
	gotoRadius = 50,
	gotoZone = "kashyyyk",
}

registerScreenPlay("trandoBorantok02ScreenPlay", true)

function trandoBorantok02ScreenPlay:start()
end

function trandoBorantok02ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoBorantok02ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoBorantok02ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoBorantok02ScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoBorantok02ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoBorantok02ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 0)
end

function trandoBorantok02ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_02:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_02:task00_journal_entry_title")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_accept.snd")

	return true
end

function trandoBorantok02ScreenPlay:attachGoto(pPlayer)
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
	createObserver(ENTEREDAREA, "trandoBorantok02ScreenPlay", "notifyEnteredGoto", pArea)

	if (CreatureObject(pPlayer):getZoneName() == self.gotoZone) then
		local dx = SceneObject(pPlayer):getWorldPositionX() - self.gotoX
		local dy = SceneObject(pPlayer):getWorldPositionY() - self.gotoY

		if ((dx * dx + dy * dy) <= (self.gotoRadius * self.gotoRadius)) then
			self:completeGoto(pPlayer)
		end
	end
end

function trandoBorantok02ScreenPlay:detachGoto(pPlayer)
	local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "gotoArea"))

	if (oid ~= nil and oid ~= 0) then
		local pArea = getSceneObject(oid)

		if (pArea ~= nil) then
			dropObserver(ENTEREDAREA, "trandoBorantok02ScreenPlay", "notifyEnteredGoto", pArea)
			SceneObject(pArea):destroyObjectFromWorld()
		end
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "gotoArea")
end

function trandoBorantok02ScreenPlay:completeGoto(pPlayer)
	if (self:getStage(pPlayer) ~= 2) then
		return
	end

	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 3)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_02:task02_journal_entry_title")
	self:onGotoComplete(pPlayer)
end

function trandoBorantok02ScreenPlay:onGotoComplete(pPlayer)
end

function trandoBorantok02ScreenPlay:notifyEnteredGoto(pArea, pPlayer)
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

function trandoBorantok02ScreenPlay:signalReportToBorantok(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_02:task01_journal_entry_title")
	self:attachGoto(pPlayer)
	return true
end

function trandoBorantok02ScreenPlay:signalThreatenBartender(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	self:setStage(pPlayer, 4)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_02:task03_journal_entry_title")
	return true
end

function trandoBorantok02ScreenPlay:signalRewardBorantok(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 4) then
		return false
	end

	self:awardQuest(pPlayer)
	return true
end

function trandoBorantok02ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_trando_borantok_02")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_sucess.snd")
	self:clearQuest(pPlayer)
end
