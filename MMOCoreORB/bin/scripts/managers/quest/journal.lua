-- Journal: the one Lua module every quest feed calls for System B (PlayerQuestData).
-- Mirror, never source of truth. Every feed keeps its own state store. A journal
-- call never gates a quest -- every function returns a boolean the caller may ignore.
--
-- Engine caveats (PlayerObjectImplementation.cpp):
--   1. activateJournalQuest (:3187-3207) refuses silently when ownerId != 0.
--      A quest ever granted (active OR completed) cannot be re-granted without
--      clearJournalQuest first. begin honours that; regrant is the clear-then-
--      activate path for repeatable feeds. Resets both masks, auto-activates task 0.
--   2. clearJournalQuest / clearPlayerQuestData (:3556) needs a relog before the
--      client drops the row. Known caveat; this module does not work around it.
--
-- Natives (LuaPlayerObject.cpp:57-66): activateJournalQuest(crc, notify),
-- completeJournalQuest, clearJournalQuest, activate/complete/clearJournalQuestTask,
-- isJournalQuestActive/Complete, isJournalQuestTaskActive/Complete.
-- completeJournalQuest does not touch task bits (:3210-3228). Tasks are 0..15
-- (uint16 masks; natives reject taskNum > 15). completeJournalQuestTask no-ops
-- unless that task is active (:3296-3298). notify=true: the native sends
-- @quest/quests:quest_journal_updated / @quest/quests:task_complete -- this
-- module does not send those again.
--
-- CRC: Journal.crc wraps the global Lua hash (DirectorManager.cpp:452,2131) =
-- String::hashCode(), same CRC as misc/quest_crc_string_table.iff.
-- space_helpers.lua:1230 uses it; quest_manager.lua:421 pins QUEST_C_SINK_IMP
-- = 0x75B55B94 for "quest/c_sink_imp".
--
-- Waypoints are datapad-only. addWaypoint order from LuaPlayerObject.cpp:204-226
-- (comment at :189 omits z): planet, name, desc, x, z, y, color, active,
-- notifyClient, specialTypeID[, persist]. specialTypeID is server bookkeeping
-- (WaypointObject.idl:25); a quest CRC will not collide with SPECIALTYPE_* (idl:36-46).

local Journal = {}

Journal.MAX_TASK = 15 -- SOURCED: uint16 masks, PlayerObjectImplementation.cpp

-- Task index guard: the natives reject taskNum > 15 but not a negative or fractional n,
-- which would reach C++ 1 << taskNum. Every task-taking function goes through this.
local function validTask(n)
	return type(n) == "number" and n >= 0 and n <= Journal.MAX_TASK and n == math.floor(n)
end

local function getGhost(pPlayer)
	if (pPlayer == nil) then
		return nil
	end

	return CreatureObject(pPlayer):getPlayerObject()
end

function Journal.key(name)
	return "quest/" .. (name or "")
end

function Journal.keySpace(questType, name)
	return "spacequest/" .. (questType or "") .. "/" .. (name or "")
end

function Journal.keyMission(missionType)
	return "mission/" .. (missionType or "")
end

function Journal.crc(questKey)
	return getHashCode(questKey)
end

function Journal.begin(pPlayer, questKey, notify)
	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	local crc = Journal.crc(questKey)

	-- ownerId refusal: already active or already complete. Do not clear-and-regrant.
	if (PlayerObject(pGhost):isJournalQuestActive(crc) or PlayerObject(pGhost):isJournalQuestComplete(crc)) then
		return false
	end

	PlayerObject(pGhost):activateJournalQuest(crc, notify)

	return PlayerObject(pGhost):isJournalQuestActive(crc)
end

function Journal.regrant(pPlayer, questKey, notify)
	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	local crc = Journal.crc(questKey)

	-- Silent clear so notify=true yields one journal-updated (from activate / task 0).
	PlayerObject(pGhost):clearJournalQuest(crc, false)
	PlayerObject(pGhost):activateJournalQuest(crc, notify)

	return PlayerObject(pGhost):isJournalQuestActive(crc)
end

function Journal.task(pPlayer, questKey, n, state, notify)
	if (not validTask(n)) then
		print("[journal] task out of range")
		return false
	end

	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	local crc = Journal.crc(questKey)

	if (not PlayerObject(pGhost):isJournalQuestActive(crc)) then
		return false
	end

	if (state == "active") then
		PlayerObject(pGhost):activateJournalQuestTask(crc, n, notify)
	elseif (state == "complete") then
		-- Engine no-ops completeJournalQuestTask unless the task is active.
		PlayerObject(pGhost):activateJournalQuestTask(crc, n, false)
		PlayerObject(pGhost):completeJournalQuestTask(crc, n, notify)
	elseif (state == "clear") then
		PlayerObject(pGhost):clearJournalQuestTask(crc, n, notify)
	else
		return false
	end

	return true
end

function Journal.complete(pPlayer, questKey, notify)
	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	local crc = Journal.crc(questKey)

	if (not PlayerObject(pGhost):isJournalQuestActive(crc)) then
		return false
	end

	for i = 0, Journal.MAX_TASK do
		if (PlayerObject(pGhost):isJournalQuestTaskActive(crc, i)) then
			PlayerObject(pGhost):completeJournalQuestTask(crc, i, false)
		end
	end

	PlayerObject(pGhost):completeJournalQuest(crc, notify)

	return true
end

function Journal.abort(pPlayer, questKey, notify)
	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	local crc = Journal.crc(questKey)

	if (not PlayerObject(pGhost):isJournalQuestActive(crc) and not PlayerObject(pGhost):isJournalQuestComplete(crc)) then
		return false
	end

	PlayerObject(pGhost):clearJournalQuest(crc, notify)

	return true
end

function Journal.active(pPlayer, questKey)
	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	return PlayerObject(pGhost):isJournalQuestActive(Journal.crc(questKey))
end

function Journal.done(pPlayer, questKey)
	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	return PlayerObject(pGhost):isJournalQuestComplete(Journal.crc(questKey))
end

function Journal.taskActive(pPlayer, questKey, n)
	if (not validTask(n)) then
		return false
	end

	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	local crc = Journal.crc(questKey)

	if (not PlayerObject(pGhost):isJournalQuestActive(crc)) then
		return false
	end

	return PlayerObject(pGhost):isJournalQuestTaskActive(crc, n)
end

function Journal.taskDone(pPlayer, questKey, n)
	if (not validTask(n)) then
		return false
	end

	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	return PlayerObject(pGhost):isJournalQuestTaskComplete(Journal.crc(questKey), n)
end

-- One datapad waypoint per questKey, replaced not stacked. specialTypeID = quest CRC.
function Journal.waypoint(pPlayer, questKey, planet, x, z, y, name, desc)
	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	local crc = Journal.crc(questKey)

	PlayerObject(pGhost):removeWaypointBySpecialType(crc)

	-- WAYPOINT_YELLOW = COLOR_YELLOW (DirectorManager.cpp:689). 10-arg form;
	-- persist defaults to 1 in LuaPlayerObject.cpp:201.
	local waypointID = PlayerObject(pGhost):addWaypoint(planet, name or "", desc or "", x, z, y, WAYPOINT_YELLOW, true, true, crc)

	return waypointID ~= nil
end

function Journal.clearWaypoint(pPlayer, questKey)
	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	PlayerObject(pGhost):removeWaypointBySpecialType(Journal.crc(questKey))

	return true
end

-- Default counter label: @quest/groundquests:destroy_counter ("Killed").
-- Also shipped: destroy_and_loot_counter "Found", retrieve_item_counter "Retrieved".
function Journal.count(pPlayer, questKey, n, current, max, stfKey)
	if (not validTask(n)) then
		print("[journal] task out of range")
		return false
	end

	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	local crc = Journal.crc(questKey)

	if (not PlayerObject(pGhost):isJournalQuestActive(crc) and not PlayerObject(pGhost):isJournalQuestComplete(crc)) then
		return false
	end

	stfKey = stfKey or "@quest/groundquests:destroy_counter"

	PlayerObject(pGhost):setQuestCounter(crc, current)
	PlayerObject(pGhost):sendQuestTaskCounter(questKey, n, stfKey, current, max)

	return true
end

-- Default timer label: @quest/groundquests:timer_timertext ("Time Remaining").
function Journal.timer(pPlayer, questKey, n, seconds, stfKey)
	if (not validTask(n)) then
		print("[journal] task out of range")
		return false
	end

	local pGhost = getGhost(pPlayer)

	if (pGhost == nil) then
		return false
	end

	stfKey = stfKey or "@quest/groundquests:timer_timertext"

	PlayerObject(pGhost):sendQuestTaskTimer(questKey, n, stfKey, seconds)

	return true
end

return Journal
