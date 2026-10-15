-- Client .qst task IDs, not DSRC questtask row numbers. Screenplay data remains authoritative.
local Journal = require("managers.quest.journal")
local KashyyykQuestJournal = {}

KashyyykQuestJournal.quests = {
	rryattTrailMasteryScreenPlay = { quest = "ep3_rryatt_trail_mastery", stages = {{1, 14, 13, 12, 11}}, initial = {0}, flags = {[14] = "l1", [13] = "l2", [12] = "l3", [11] = "l4"} },
	kachirhoKillWkeScreenPlay = { quest = "ep3_kachirho_kill_wke", stages = {{0}, {1}}, reward = {2}, counter = {"kills", 1, 0} },
	kachirhoVaractylHuntScreenPlay = { quest = "ep3_kachirho_varactyl_hunt", stages = {{0}, {1}}, reward = {2}, counter = {"plumes", 1, 0}, loot = true },
	kachirhoSurveyDataScreenPlay = { quest = "ep3_kachirho_survey_data", stages = {{0, 1, 2, 3, 4}, {5}}, reward = {6}, survey = true },
	kachirhoMissingSonScreenPlay = { quest = "ep3_kachirho_missing_son", stages = {{0}, {2}, {3}}, reward = {4} },
	kachirhoVaractylEggScreenPlay = { quest = "ep3_kachirho_varactyl_egg", stages = {{0}, {1}}, reward = {2} },
	kachirhoTakookCommScreenPlay = { quest = "ep3_kachirho_takook_comm", stages = {{0}} },
	kachirhoDestroyedCampScreenPlay = { quest = "ep3_kachirho_destroyed_camp", stages = {{0}, {1}, {5}, {6}, {2}, {4}, {7}}, counter = {"kills", 5, 2} },
	kachirhoTrandoRifleCraftingScreenPlay = { quest = "ep3_kachirho_trando_rifle_crafting", stages = {{4}, {6}}, initial = {0}, reward = {5}, craft = true },
	trandoBoshazZssik02ScreenPlay = { quest = "ep3_trando_boshaz_zssik_02", stages = {{0}, {1}, {3}, {4}}, reward = {6}, counter = {"kills", 2, 1} },
	trandoSsiksikScreenPlay = { quest = "ep3_trando_ssiksik", stages = {{2}, {4}, {}, {}, {12}}, initial = {0}, reward = {14}, waves = true },
	trandoBorantok01ScreenPlay = { quest = "ep3_trando_borantok_01", stages = {{2}, {3}, {8, 12}}, counter = {"bags", 2, 3}, retrieval = true },
	trandoBorantok02ScreenPlay = { quest = "ep3_trando_borantok_02", stages = {{6}, {7}, {8}, {9}}, reward = {10} },
	trandoBoshazTransferScreenPlay = { quest = "ep3_trando_boshaz_transfer", stages = {{0}} },
	trandoDakarZssik03ScreenPlay = { quest = "ep3_trando_dakar_zssik_03", stages = {{0}, {1}, {2}}, reward = {3}, counter = {"kills", 2, 1}, loot = true },
	trandoHarwakokokZssik09ScreenPlay = { quest = "ep3_trando_harwakokok_zssik_09", stages = {{0}, {1}}, counter = {"kills", 1, 0}, loot = true },
	trandoHeraldScreenPlay = { quest = "ep3_trando_herald", stages = {{0}}, reward = {2}, counter = {"kills", 1, 0} },
	trandoHssisskZssik10ScreenPlay = { quest = "ep3_trando_hssissk_zssik_10", stages = {{0, 1, 2}, {3}}, reward = {4} },
	trandoJessokkScreenPlay = { quest = "ep3_trando_jessokk", stages = {{3, 4}}, initial = {2} },
	trandoMololiumZssikGotoScreenPlay = { quest = "ep3_trando_mololium_zssik_goto", stages = {{0}} },
	trandoMosoliumTransferScreenPlay = { quest = "ep3_trando_mosolium_transfer", stages = {{0}} },
	trandoMosoliumZssik05ScreenPlay = { quest = "ep3_trando_mosolium_zssik_05", stages = {{0}, {1}, {2}}, reward = {3}, counter = {"kills", 2, 1}, loot = true },
	trandoMosoliumZssik07ScreenPlay = { quest = "ep3_trando_mosolium_zssik_07", stages = {{6}, {7, 8}, {9, 10}} },
	trandoOlimaGruncScreenPlay = { quest = "ep3_trando_olima_grunc", stages = {{4}, {5}, {6}}, reward = {7}, counter = {"kills", 2, 5}, loot = true },
	trandoOroorooTransferScreenPlay = { quest = "ep3_trando_orooroo_transfer", stages = {{0}} },
	trandoOroorooZssik08ScreenPlay = { quest = "ep3_trando_orooroo_zssik_08", stages = {{0}, {1}, {2}}, reward = {3} },
	trandoTempalBunchoScreenPlay = { quest = "ep3_trando_tempal_buncho", stages = {{0}, {1}}, reward = {2}, counter = {"kills", 1, 0} },
	trandoYsithScreenPlay = { quest = "ep3_trando_ysith", stages = {{3}, {8}, {10}}, reward = {11}, counter = {"kills", 2, 8} },
	trandoYsithRewardScreenPlay = { quest = "ep3_trando_ysith_reward", stages = {{0}} },
	slaverGursanEntryQuestScreenPlay = { quest = "ep3_slaver_gursan_entry_quest", stages = {{8}, {9}, {10}}, counter = {"kills", 2, 9} },
	slaveCampControlRoomAccessScreenPlay = { quest = "ep3_slave_camp_control_room_access", stages = {{0}, {1}}, counter = {"kills", 1, 0}, loot = true },
	arenaChallengeScreenPlay = { quest = "ep3_arena_challenge", stages = {{0}} },
}

local function task(pPlayer, key, id, complete)
	if (complete) then
		if (not Journal.taskDone(pPlayer, key, id)) then
			Journal.task(pPlayer, key, id, "complete", false)
		end
	elseif (not Journal.taskActive(pPlayer, key, id) and not Journal.taskDone(pPlayer, key, id)) then
		Journal.task(pPlayer, key, id, "active", false)
	end
end

function KashyyykQuestJournal.begin(screenplay, pPlayer)
	local spec = KashyyykQuestJournal.quests[screenplay.screenplayName]
	if (spec ~= nil) then
		Journal.regrant(pPlayer, Journal.key(spec.quest), false)
	end
end

function KashyyykQuestJournal.sync(screenplay, pPlayer, stage)
	local spec = KashyyykQuestJournal.quests[screenplay.screenplayName]
	if (pPlayer == nil or spec == nil or spec.stages[stage] == nil) then
		return
	end
	local key = Journal.key(spec.quest)
	-- Older characters can already be partway through a quest when this mirror is installed.
	if (Journal.done(pPlayer, key)) then
		Journal.regrant(pPlayer, key, false)
	else
		Journal.begin(pPlayer, key, false)
	end
	local hasTaskZero = false
	for i = 1, #spec.stages do
		for _, id in ipairs(spec.stages[i]) do
			if (id == 0) then hasTaskZero = true end
			if (i <= stage) then
				local complete = i < stage
				if (spec.flags ~= nil and spec.flags[id] ~= nil) then
					complete = complete or tonumber(readScreenPlayData(pPlayer, screenplay.screenplayName, spec.flags[id])) == 1
				end
				if (spec.survey and i == 1) then
					complete = complete or tonumber(readScreenPlayData(pPlayer, screenplay.screenplayName, "d" .. id)) == 1
				end
				task(pPlayer, key, id, complete)
			end
		end
	end
	for _, id in ipairs(spec.initial or {}) do
		task(pPlayer, key, id, true)
		if (id == 0) then hasTaskZero = true end
	end
	-- activateJournalQuest implicitly activates task zero, even when the .qst has no such task.
	if (not hasTaskZero and Journal.taskActive(pPlayer, key, 0)) then
		Journal.task(pPlayer, key, 0, "clear", false)
	end
	if (spec.counter ~= nil and stage == spec.counter[2]) then
		local current = tonumber(readScreenPlayData(pPlayer, screenplay.screenplayName, spec.counter[1])) or 0
		local limit = screenplay.killCount or screenplay.plumeCount or screenplay.bagNeed
		if (limit ~= nil) then
			local label = spec.retrieval and "@quest/groundquests:retrieve_item_counter" or (spec.loot and "@quest/groundquests:destroy_and_loot_counter" or nil)
			Journal.count(pPlayer, key, spec.counter[3], current, limit, label)
		end
	end
	if (spec.craft and stage == 2 and (screenplay:hasBowcaster(pPlayer) or Journal.taskDone(pPlayer, key, 6))) then
		task(pPlayer, key, 6, true)
		task(pPlayer, key, 5, false)
	end
	if (spec.waves and stage >= 3) then
		-- Client task 16 (aggregate wait) exceeds the native uint16 mask. Mirror its three waves instead.
		local timers, encounters = {8, 7, 5}, {9, 10, 6}
		for wave = 1, 3 do
			local prefix = "wave" .. wave
			local done = stage == 5 or tonumber(readScreenPlayData(pPlayer, screenplay.screenplayName, prefix)) == 1
			local spawned = done or readScreenPlayData(pPlayer, screenplay.screenplayName, prefix .. "kills") ~= ""
			task(pPlayer, key, timers[wave], spawned)
			if (spawned) then
				task(pPlayer, key, encounters[wave], done)
				local count = tonumber(readScreenPlayData(pPlayer, screenplay.screenplayName, prefix .. "kills")) or 0
				Journal.count(pPlayer, key, encounters[wave], done and screenplay.killCount or count, screenplay.killCount)
			end
		end
	end
end

function KashyyykQuestJournal.complete(screenplay, pPlayer)
	local spec = KashyyykQuestJournal.quests[screenplay.screenplayName]
	if (spec == nil) then return end
	local key = Journal.key(spec.quest)
	Journal.begin(pPlayer, key, false)
	KashyyykQuestJournal.sync(screenplay, pPlayer, #spec.stages)
	for _, id in ipairs(spec.stages[#spec.stages]) do task(pPlayer, key, id, true) end
	for _, id in ipairs(spec.reward or {}) do task(pPlayer, key, id, true) end
	Journal.complete(pPlayer, key, true)
end

function KashyyykQuestJournal.crafted(screenplay, pPlayer)
	local key = Journal.key(KashyyykQuestJournal.quests[screenplay.screenplayName].quest)
	task(pPlayer, key, 6, true)
	task(pPlayer, key, 5, false)
end

function KashyyykQuestJournal.clear(screenplay, pPlayer)
	local spec = KashyyykQuestJournal.quests[screenplay.screenplayName]
	if (spec ~= nil and Journal.active(pPlayer, Journal.key(spec.quest))) then
		Journal.abort(pPlayer, Journal.key(spec.quest), false)
	end
end

function KashyyykQuestJournal.playerLoggedIn(pPlayer)
	for name, spec in pairs(KashyyykQuestJournal.quests) do
		local screenplay = _G[name]
		if (screenplay ~= nil) then
			local stage = tonumber(readScreenPlayData(pPlayer, name, "stage")) or 0
			KashyyykQuestJournal.sync(screenplay, pPlayer, stage)
			if (spec.craft and stage == 2) then screenplay:attachCraftObserver(pPlayer) end
		end
	end
end

return KashyyykQuestJournal
