--[[
	@quest/ground/ep3_trando_orooroo_zssik_08:journal_entry_title  --  ep3_trando_orooroo_zssik_08

	ruling 2026-09-04

	SOURCE: quest/ep3_trando_orooroo_zssik_08.qst and string/en/quest/ground/ep3_trando_orooroo_zssik_08.stf.

	THE TASK TREE
		task 0  Go to Location  Travel to Kachirho
		task 1  Wait for Signal  Speak with Harwakokok
		task 2  Wait for Signal  Return to Orooroo
		task 3  Reward  Reward Issued

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	XP: quest_experience[80][TIER_1] = 435. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

trandoOroorooZssik08ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoOroorooZssik08ScreenPlay",
	repeatable = true,
	turnInStage = 3,
	rewardCredits = 15000,
	rewardItem = "object/weapon/ranged/rifle/ep3/rifle_trando_hunter.iff",
	gotoX = -530.00,
	gotoZ = 18.00,
	gotoY = -100.00,
	gotoRadius = 25,
	gotoZone = "kashyyyk",
}

registerScreenPlay("trandoOroorooZssik08ScreenPlay", true)

function trandoOroorooZssik08ScreenPlay:start()
end

function trandoOroorooZssik08ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoOroorooZssik08ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoOroorooZssik08ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoOroorooZssik08ScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoOroorooZssik08ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoOroorooZssik08ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 0)
end

function trandoOroorooZssik08ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_orooroo_zssik_08:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_orooroo_zssik_08:task00_journal_entry_title")
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_accept.snd")
	self:attachGoto(pPlayer)

	return true
end

function trandoOroorooZssik08ScreenPlay:attachGoto(pPlayer)
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
	createObserver(ENTEREDAREA, "trandoOroorooZssik08ScreenPlay", "notifyEnteredGoto", pArea)

	if (CreatureObject(pPlayer):getZoneName() == self.gotoZone) then
		local dx = SceneObject(pPlayer):getWorldPositionX() - self.gotoX
		local dy = SceneObject(pPlayer):getWorldPositionY() - self.gotoY

		if ((dx * dx + dy * dy) <= (self.gotoRadius * self.gotoRadius)) then
			self:completeGoto(pPlayer)
		end
	end
end

function trandoOroorooZssik08ScreenPlay:detachGoto(pPlayer)
	local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "gotoArea"))

	if (oid ~= nil and oid ~= 0) then
		local pArea = getSceneObject(oid)

		if (pArea ~= nil) then
			dropObserver(ENTEREDAREA, "trandoOroorooZssik08ScreenPlay", "notifyEnteredGoto", pArea)
			SceneObject(pArea):destroyObjectFromWorld()
		end
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "gotoArea")
end

function trandoOroorooZssik08ScreenPlay:completeGoto(pPlayer)
	if (self:getStage(pPlayer) ~= 1) then
		return
	end

	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_orooroo_zssik_08:task01_journal_entry_title")
	self:onGotoComplete(pPlayer)
end

function trandoOroorooZssik08ScreenPlay:onGotoComplete(pPlayer)
end

function trandoOroorooZssik08ScreenPlay:notifyEnteredGoto(pArea, pPlayer)
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

function trandoOroorooZssik08ScreenPlay:signalReturnToOrooroo(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:setStage(pPlayer, 3)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_orooroo_zssik_08:task02_journal_entry_title")
	return true
end

function trandoOroorooZssik08ScreenPlay:signalRewardOrooroo(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	self:awardQuest(pPlayer)
	return true
end

function trandoOroorooZssik08ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_trando_orooroo_zssik_08")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, self.rewardItem, -1, true)
	end
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_sucess.snd")
	self:clearQuest(pPlayer)
end
