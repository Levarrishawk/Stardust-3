--[[
	Takook's Last Message  --  ep3_kachirho_takook_comm

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	SOURCE: quest/ep3_kachirho_takook_comm.qst and string/en/quest/ground/ep3_kachirho_takook_comm.stf.

	THE TASK TREE
		task 0  Comm Player   NPC Appearance object/mobile/ep3/ep3_kachirho_takook.iff
		                      Comm Message Text is task00_comm_message_text

	The recorder is kashyyyk_main row 2142 at wx=-95.14, wz=547.5. Java on-use:
		grantQuest("ep3_kachirho_takook_comm")
		sendSignal("takookTale")   -- advances missing_son
		particle pt_light_blink_green

	Comm Player is implemented as a system message from the shipped comm-text key.
	completeWhenTasksComplete is true, so the comm is the whole quest.

	NO JOURNAL: do not call Journal.*. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: LEVEL 1 TIER -1 passthrough of stored 0. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
]]

kachirhoTakookCommScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "kachirhoTakookCommScreenPlay",
	repeatable = true,
	recorderTemplate = "object/tangible/item/ep3/kachirho_takook_recorder.iff",
	recorderX = -95.14,
	recorderZ = 22.4999,
	recorderY = 547.5,
}

registerScreenPlay("kachirhoTakookCommScreenPlay", true)

function kachirhoTakookCommScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnRecorder()
	end
end

function kachirhoTakookCommScreenPlay:spawnRecorder()
	local z = getWorldFloor(self.recorderX, self.recorderY, "kashyyyk")

	if (z == nil or z == 0) then
		z = self.recorderZ
	end

	local pObj = spawnSceneObject("kashyyyk", self.recorderTemplate, self.recorderX, z, self.recorderY, 0, 0)

	if (pObj ~= nil) then
		SceneObject(pObj):setObjectMenuComponent("KashTakookRecorderMenuComponent")
	end
end

function kachirhoTakookCommScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kachirhoTakookCommScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function kachirhoTakookCommScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function kachirhoTakookCommScreenPlay:playRecording(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_takook_comm:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_takook_comm:task00_comm_message_text")
	KashyyykQuestXp:award(pPlayer, "ep3_kachirho_takook_comm")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:setStage(pPlayer, 0)

	if (kachirhoMissingSonScreenPlay ~= nil) then
		kachirhoMissingSonScreenPlay:signalTakookTale(pPlayer)
	end

	return true
end

KashTakookRecorderMenuComponent = {}

function KashTakookRecorderMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/ep3_kachirho_takook_comm:task00_journal_entry_title")
end

function KashTakookRecorderMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	kachirhoTakookCommScreenPlay:playRecording(pPlayer)

	local x = SceneObject(pSceneObject):getWorldPositionX()
	local y = SceneObject(pSceneObject):getWorldPositionY()
	local z = SceneObject(pSceneObject):getWorldPositionZ()

	spawnSceneObject("kashyyyk", "object/static/particle/pt_light_blink_green.iff", x, z, y, 0, 0)

	return 0
end
