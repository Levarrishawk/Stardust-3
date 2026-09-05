-- MissionJournal: terminal / bounty missions into the client journal.
--
-- Observer attachment: the PLAYER. MissionObjective is a ManagedObject, not a
-- SceneObject, so Lua createObserver cannot register on it
-- (DirectorManager.cpp:3408 sceneObject->registerObserver). C++ therefore
-- notifies on the owner creature, matching QUESTKILL
-- (CreatureManagerImplementation.cpp:625 attackerCreo->notifyObservers).
-- Arg1 is the MissionObject (ObserverEventType.h MISSIONACTIVATED comment;
-- MissionObjectiveImplementation.cpp activate/complete/abort/fail).
--
-- Bounty objectiveStatus (INITSTATUS / HASBIOSIGNATURESTATUS / HASTALKED) lives
-- in BountyMissionObjectiveImplementation.cpp:269-291, which is outside this
-- round's C++ fence. No observer fires on those transitions; tasks 1/2 stay
-- table rows until a later hook.

local Journal = require("managers.quest.journal")
local MissionTypes = require("managers.quest.mission_types")

MissionJournal = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MissionJournal"
}

registerScreenPlay("MissionJournal", true)

function MissionJournal:start()
end

function MissionJournal:onPlayerLoggedIn(pPlayer)
	if (pPlayer == nil) then
		return
	end

	dropObserver(MISSIONACTIVATED, "MissionJournal", "onMissionActivated", pPlayer)
	dropObserver(MISSIONCOMPLETED, "MissionJournal", "onMissionCompleted", pPlayer)
	dropObserver(MISSIONABORTED, "MissionJournal", "onMissionAborted", pPlayer)
	dropObserver(MISSIONFAILED, "MissionJournal", "onMissionFailed", pPlayer)

	createObserver(MISSIONACTIVATED, "MissionJournal", "onMissionActivated", pPlayer)
	createObserver(MISSIONCOMPLETED, "MissionJournal", "onMissionCompleted", pPlayer)
	createObserver(MISSIONABORTED, "MissionJournal", "onMissionAborted", pPlayer)
	createObserver(MISSIONFAILED, "MissionJournal", "onMissionFailed", pPlayer)
end

local function missionTypeOf(pMission)
	if (pMission == nil) then
		return nil
	end

	local mission = LuaMissionObject(pMission)

	if (mission == nil) then
		return nil
	end

	if (mission:getQuestType() ~= "mission") then
		return nil
	end

	local questName = mission:getQuestName()

	if (questName == nil or questName == "" or MissionTypes[questName] == nil) then
		return nil
	end

	return questName, mission
end

function MissionJournal:onMissionActivated(pPlayer, pMission)
	if (pPlayer == nil) then
		return 0
	end

	local missionType, mission = missionTypeOf(pMission)

	if (missionType == nil) then
		return 0
	end

	local questKey = Journal.keyMission(missionType)

	-- notify=true: native sends @quest/quests:quest_journal_updated. Do not send it again.
	Journal.regrant(pPlayer, questKey, true)

	local planet = mission:getEndPlanet()

	if (planet == nil or planet == "") then
		planet = mission:getStartPlanet()
	end

	if (planet ~= nil and planet ~= "") then
		local targetName = mission:getTargetName() or ""
		Journal.waypoint(pPlayer, questKey, planet, mission:getEndPositionX(), 0, mission:getEndPositionY(), targetName, "")
	end

	local targetName = mission:getTargetName()

	if (targetName ~= nil and targetName ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(targetName)
	end

	return 0
end

function MissionJournal:onMissionCompleted(pPlayer, pMission)
	if (pPlayer == nil) then
		return 0
	end

	local missionType = missionTypeOf(pMission)

	if (missionType == nil) then
		return 0
	end

	Journal.complete(pPlayer, Journal.keyMission(missionType), true)
	Journal.clearWaypoint(pPlayer, Journal.keyMission(missionType))

	return 0
end

function MissionJournal:onMissionAborted(pPlayer, pMission)
	if (pPlayer == nil) then
		return 0
	end

	local missionType = missionTypeOf(pMission)

	if (missionType == nil) then
		return 0
	end

	-- Relog caveat: clearJournalQuest needs a relog before the client drops the row.
	Journal.abort(pPlayer, Journal.keyMission(missionType), true)
	Journal.clearWaypoint(pPlayer, Journal.keyMission(missionType))

	return 0
end

function MissionJournal:onMissionFailed(pPlayer, pMission)
	return self:onMissionAborted(pPlayer, pMission)
end
