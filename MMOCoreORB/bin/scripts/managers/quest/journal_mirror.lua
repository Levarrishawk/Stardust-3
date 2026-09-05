-- JournalMirror: stage integer -> client journal task bits. Mirror only.
-- Screenplay data stays the source of truth. applyStage never aborts, never
-- clears, never gates a quest, holds no state, and sends no system messages.

local Journal = require("managers.quest.journal")
local JournalMirror = {}

-- map: { [stage] = { quest = "som_x", complete = {n, ...}, activate = {n, ...}, finish = true|nil }, ... }
-- A stage may also be a list of those entries (quest-boundary: finish A, begin B).
-- stage 0 or a stage with no entry: no-op, returns false.
-- Order inside an entry: Journal.begin -> complete[] -> activate[] -> if finish then Journal.complete.
-- notify = true on the LAST journal write of the stage only.

local function appendOps(ops, entry)
	if (entry == nil or entry.quest == nil) then
		return
	end
	local key = Journal.key(entry.quest)
	table.insert(ops, { kind = "begin", key = key })
	if (entry.complete ~= nil) then
		for i = 1, #entry.complete do
			table.insert(ops, { kind = "task", key = key, n = entry.complete[i], state = "complete" })
		end
	end
	if (entry.activate ~= nil) then
		for i = 1, #entry.activate do
			table.insert(ops, { kind = "task", key = key, n = entry.activate[i], state = "active" })
		end
	end
	if (entry.count ~= nil and type(entry.count) == "table") then
		table.insert(ops, { kind = "count", key = key, n = entry.count[1], current = entry.count[2], max = entry.count[3] })
	end
	if (entry.finish) then
		table.insert(ops, { kind = "finish", key = key })
	end
end

function JournalMirror.applyStage(pPlayer, map, stage)
	if (pPlayer == nil or map == nil or stage == nil) then
		return false
	end

	stage = tonumber(stage)

	if (stage == nil or stage == 0) then
		return false
	end

	local spec = map[stage]

	if (spec == nil) then
		return false
	end

	local ops = {}

	if (spec.quest ~= nil) then
		appendOps(ops, spec)
	else
		for i = 1, #spec do
			appendOps(ops, spec[i])
		end
	end

	local writes = {}

	for i = 1, #ops do
		local op = ops[i]

		if (op.kind == "task") then
			if (type(op.n) ~= "number" or op.n < 0 or op.n > 15 or op.n ~= math.floor(op.n)) then
				print("[journal_mirror] task out of range: " .. tostring(op.n))
			else
				table.insert(writes, op)
			end
		elseif (op.kind == "count") then
			if (type(op.n) ~= "number" or op.n < 0 or op.n > 15 or op.n ~= math.floor(op.n)) then
				print("[journal_mirror] count task out of range: " .. tostring(op.n))
			else
				table.insert(writes, op)
			end
		else
			table.insert(writes, op)
		end
	end

	if (#writes == 0) then
		return false
	end

	for i = 1, #writes do
		local op = writes[i]
		local notify = (i == #writes)

		if (op.kind == "begin") then
			Journal.begin(pPlayer, op.key, notify)
		elseif (op.kind == "task") then
			Journal.task(pPlayer, op.key, op.n, op.state, notify)
		elseif (op.kind == "count") then
			Journal.count(pPlayer, op.key, op.n, op.current, op.max)
		else
			Journal.complete(pPlayer, op.key, notify)
		end
	end

	return true
end

return JournalMirror
