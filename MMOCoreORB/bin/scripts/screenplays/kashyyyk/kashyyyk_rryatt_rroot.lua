KashyyykRryattRroot = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykRryattRroot",
	zone = "kashyyyk_rryatt_trail",
	quest = "quest/ep3_kymayrr_rescue_rroot"
}

registerScreenPlay("KashyyykRryattRroot", true)

function KashyyykRryattRroot:start()
	if (not isZoneEnabled(self.zone) or getSceneObject(readData(self.screenplayName .. ":area")) ~= nil) then
		return
	end
	local c = KashyyykRryattPopulationData.rroot
	local pArea = spawnActiveArea(self.zone, "object/active_area.iff", c.x, c.z, c.y, 100, 0)
	if (pArea ~= nil) then
		writeData(self.screenplayName .. ":area", SceneObject(pArea):getObjectID())
		createObserver(ENTEREDAREA, self.screenplayName, "notifyEntered", pArea)
		createObserver(EXITEDAREA, self.screenplayName, "notifyExited", pArea)
	end
end

function KashyyykRryattRroot:hasQuest(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	return pGhost ~= nil and PlayerObject(pGhost):isJournalQuestActive(getHashCode(self.quest))
end

function KashyyykRryattRroot:notifyEntered(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature() or not self:hasQuest(pPlayer)) then
		return 0
	end
	if (getSceneObject(readData(self.screenplayName .. ":mobile")) ~= nil) then
		return 0
	end
	local c = KashyyykRryattPopulationData.rroot
	local pMobile = spawnMobile(self.zone, "ep3_rroot", 0, c.x, c.z, c.y, 117, 0)
	if (pMobile ~= nil) then
		local oid = SceneObject(pMobile):getObjectID()
		writeData(self.screenplayName .. ":mobile", oid)
		writeData(self.screenplayName .. ":owner", SceneObject(pPlayer):getObjectID())
		AiAgent(pMobile):addObjectFlag(AI_STATIONARY)
		createObserver(OBJECTDESTRUCTION, self.screenplayName, "notifyDestroyed", pMobile)
		createEvent(300000, self.screenplayName, "expire", nil, tostring(oid))
		createEvent(5000, self.screenplayName, "checkOwner", nil, tostring(oid))
	end
	return 0
end

function KashyyykRryattRroot:notifyExited(pArea, pPlayer)
	if (pPlayer ~= nil and SceneObject(pPlayer):getObjectID() == readData(self.screenplayName .. ":owner")) then
		self:expire(nil, tostring(readData(self.screenplayName .. ":mobile")))
	end
	return 0
end

function KashyyykRryattRroot:expire(pUnused, args)
	local oid = tonumber(args)
	if (oid == nil or readData(self.screenplayName .. ":mobile") ~= oid) then
		return
	end
	local pMobile = getSceneObject(oid)
	deleteData(self.screenplayName .. ":mobile")
	deleteData(self.screenplayName .. ":owner")
	if (pMobile ~= nil) then
		SceneObject(pMobile):destroyObjectFromWorld()
	end
end

function KashyyykRryattRroot:checkOwner(pUnused, args)
	if (tonumber(args) ~= readData(self.screenplayName .. ":mobile")) then
		return
	end
	local pPlayer = getSceneObject(readData(self.screenplayName .. ":owner"))
	if (pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= self.zone
		or not self:hasQuest(pPlayer)) then
		self:expire(nil, args)
	else
		createEvent(5000, self.screenplayName, "checkOwner", nil, args)
	end
end

function KashyyykRryattRroot:notifyDestroyed(pMobile)
	if (pMobile ~= nil and readData(self.screenplayName .. ":mobile") == SceneObject(pMobile):getObjectID()) then
		deleteData(self.screenplayName .. ":mobile")
		deleteData(self.screenplayName .. ":owner")
	end
	return 1
end
