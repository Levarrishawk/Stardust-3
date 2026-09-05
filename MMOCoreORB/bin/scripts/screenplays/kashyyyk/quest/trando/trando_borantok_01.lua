--[[
	ep3_trando_borantok_01

	ruling 2026-09-04

	THE TASK TREE
		task 2  Go to Location   Search for the Bodies  kashyyyk_main (-530, 18, -100) r=50
		task 3  Retrieve Item    rodian_body_bag.iff x2
		task 8  Go to Location   Get to Negal Tek'lon  kashyyyk_rryatt_trail  OPEN
		task 12 Wait for Signal  hideBodies

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.
]]

trandoBorantok01ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoBorantok01ScreenPlay",
	repeatable = true,
	turnInStage = 3,
	gotoX = -530.00,
	gotoZ = 18.0,
	gotoY = -100.00,
	gotoRadius = 50,
	gotoZone = "kashyyyk",
	bagTemplate = "object/tangible/quest/rodian_body_bag.iff",
	bagNeed = 2,
}


registerScreenPlay("trandoBorantok01ScreenPlay", true)

function trandoBorantok01ScreenPlay:start()
end

function trandoBorantok01ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoBorantok01ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoBorantok01ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoBorantok01ScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoBorantok01ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoBorantok01ScreenPlay:attachGoto(pPlayer)
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
	createObserver(ENTEREDAREA, "trandoBorantok01ScreenPlay", "notifyEnteredGoto", pArea)

	if (CreatureObject(pPlayer):getZoneName() == self.gotoZone) then
		local dx = SceneObject(pPlayer):getWorldPositionX() - self.gotoX
		local dy = SceneObject(pPlayer):getWorldPositionY() - self.gotoY

		if ((dx * dx + dy * dy) <= (self.gotoRadius * self.gotoRadius)) then
			self:completeGoto(pPlayer)
		end
	end
end

function trandoBorantok01ScreenPlay:detachGoto(pPlayer)
	local oid = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "gotoArea"))

	if (oid ~= nil and oid ~= 0) then
		local pArea = getSceneObject(oid)

		if (pArea ~= nil) then
			dropObserver(ENTEREDAREA, "trandoBorantok01ScreenPlay", "notifyEnteredGoto", pArea)
			SceneObject(pArea):destroyObjectFromWorld()
		end
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "gotoArea")
end

function trandoBorantok01ScreenPlay:completeGoto(pPlayer)
	if (self:getStage(pPlayer) ~= 1) then
		return
	end

	self:detachGoto(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_01:task01_journal_entry_title")
	self:onGotoComplete(pPlayer)
end

function trandoBorantok01ScreenPlay:onGotoComplete(pPlayer)
end

function trandoBorantok01ScreenPlay:notifyEnteredGoto(pArea, pPlayer)
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

function trandoBorantok01ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnBags()
	end
end

function trandoBorantok01ScreenPlay:spawnBags()
	for i = 1, 2 do
		local x = self.gotoX + ((i == 1) and 2 or -2)
		local z = getWorldFloor(x, self.gotoY, "kashyyyk")

		if (z == nil or z == 0) then
			z = self.gotoZ
		end

		local pObj = spawnSceneObject("kashyyyk", self.bagTemplate, x, z, self.gotoY, 0, 0)

		if (pObj ~= nil) then
			writeStringData(SceneObject(pObj):getObjectID() .. ":trandoBag", "bag")
			SceneObject(pObj):setObjectMenuComponent("TrandoBorantokBagMenuComponent")
		end
	end
end

function trandoBorantok01ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachGoto(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "bags")
	self:setStage(pPlayer, 0)
end

function trandoBorantok01ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_01:journal_entry_title")
	self:attachGoto(pPlayer)
	return true
end

function trandoBorantok01ScreenPlay:collectBag(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "bags")) or 0) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "bags", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_01:task01_journal_entry_title")

	if (n >= self.bagNeed) then
		self:setStage(pPlayer, 3)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_borantok_01:task02_journal_entry_title")
	end

	return true
end

function trandoBorantok01ScreenPlay:signalHideBodies(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_trando_borantok_01")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)
	return true
end

TrandoBorantokBagMenuComponent = {}

function TrandoBorantokBagMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (trandoBorantok01ScreenPlay:getStage(pPlayer) == 2) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_trando_borantok_01:task01_journal_entry_title")
	end
end

function TrandoBorantokBagMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	trandoBorantok01ScreenPlay:collectBag(pPlayer)
	return 0
end
