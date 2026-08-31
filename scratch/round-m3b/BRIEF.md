# Round M3b — two gate findings from Round M3

Repo root: `C:\stardust-3-space-port\server`. Branch `mustafar-content`.

You are the coder seat. **Two** edits, in two files. Both came out of the M3 gate, where two
independent review seats found the same two defects. Both are already verified first-hand by the
orchestrator. Make exactly these two changes and nothing else.

## Governing rules — these override any instinct to improve things

- **Live-faithful. Invent nothing.** Do not add, move, or guess a coordinate, an NPC name, a
  display string, or a piece of dialogue. Both edits below are pure control flow — no new content.
  If a fix seems to need content, STOP and report it instead of writing it.
- **Lua only.** Never touch C++, `.tre`, `snapshot/*.ws`, `conf/`, `quests.iff`, or
  `quest_manager.lua`.
- **Do not commit. Do not `git push`. Do not add a remote.** Leave the tree dirty.
- **Do not delete any file.**
- The tree contains prior uncommitted work (Rounds M1, M2 and M3) across
  `screenplays/mustafar/**`, `managers/object/object_manager.lua`, `mobile/**` and
  `conf/config.lua`. **Leave all of it alone.**
- **Do not touch the comment blocks or header prose in either file.** M3 had an unrequested prose
  edit; it was verified and kept, but do not repeat it. Only the comments explicitly quoted below
  may change.
- If you disagree with a fix, implement it as written and say so in your report. Do not substitute
  your own design.

---

## E1 — `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/cursed_shard.lua`

**The finding (HIGH, found independently by both review seats).**

Round M3 added a brood catch-up, but hung it on `notifyEnteredEventArea` only. That call site is
reached only when the player physically re-enters one of two 300 m areas, at `(-4100, 1257)` and
`(-3100, 4966)` (`:198`, `:207`). A player who logged out or zoned off Mustafar during the ambush
delay, came back, and never walked into those two spots again is **still stranded at
`STAGE_SHARD` with both flags set, forever.** The M3 fix is real but incomplete.

**The fix — move the catch-up into `getStage`, which is this file's own reconciliation hook.**

`getStage` at `:338-352` already does exactly this for the next stage, and the block comment above
it at `:333-337` states the design intent in the author's own words:

```lua
--[[ The brood is driven by createEvent, which does not survive a server restart.
     Reading the stage settles an overdue brood as well, so a restart during those
     180-560 s cannot strand a player on a quest with nothing left in it. Both
     paths funnel into endBrood, which is guarded, so whichever arrives first wins
     and the other does nothing. ]]
```

The `STAGE_SHARD` strand is the same class of bug at the previous stage, and it was left
unhandled. `reunite_shard.lua:422-438` and `hidden_treasure.lua:205-220` use the same idiom.

### E1a — add the reconciliation to `getStage`

Current (`:338-352`):

```lua
function cursedShardScreenPlay:getStage(pPlayer)
	local stage = self:rawStage(pPlayer)

	if (stage == self.STAGE_BROOD) then
		local due = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "broodUntil")) or 0

		if (due ~= 0 and getTimestamp() >= due) then
			self:endBrood(pPlayer)

			return self:rawStage(pPlayer)
		end
	end

	return stage
end
```

Add a second reconciliation branch for `STAGE_SHARD`, in the same shape as the existing one —
do the work, then re-read and return `rawStage`, because the stage may have just advanced:

```lua
	if (stage == self.STAGE_SHARD) then
		self:checkBroodGate(pPlayer)

		return self:rawStage(pPlayer)
	end
```

Place it after the existing `STAGE_BROOD` block and before the final `return stage`.

Also extend the block comment at `:333-337` so it covers the new branch. Keep the author's voice
and keep every existing sentence — add one sentence saying that reading the stage also picks up a
brood whose delayed `springAmbush` never reached the gate.

Notes you must respect:
- **Do NOT gate this on `isPresent`.** `startBrood` (`:524`) touches no client API at all — it
  only writes screenplay data and calls `createEvent` — and `endBrood` (`:544`) already handles
  the offline case itself at `:554-556`. Gating on `isPresent` would block the catch-up for
  precisely the offline players it exists to rescue.
- **There is no recursion risk, and you must keep it that way.** `checkBroodGate` reads
  `rawStage`, not `getStage`, and `startBrood` writes via `setStage`. Do not change either to
  call `getStage`.
- `startBrood` already returns immediately if the `"brood"` flag is set, so repeated `getStage`
  calls cannot double-start.

### E1b — remove the now-redundant explicit catch-up

With E1a in place, the block M3 added at `:441-445` of `notifyEnteredEventArea` is dead weight —
`:449` in that same function already calls `self:getStage(pPlayer)` on the very next statement.
Delete these five lines and the blank line after them:

```lua
	-- Catch-up: both event flags may already be set from a prior visit where the
	-- delayed springAmbush never reached startBrood (logout / zone-off).
	if (self:isPresent(pPlayer)) then
		self:checkBroodGate(pPlayer)
	end
```

The behaviour is preserved and improved: if the catch-up now starts the brood, `getStage` returns
`STAGE_BROOD`, the `:449` condition is true, and the function returns 0 without also springing an
ambush. That is correct — the brood has started, the ambush is done with.

**Do not change** `checkBroodGate`, `startBrood`, `springAmbush`, the flag names, the ambush
delay, or any message text.

---

## E2 — `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/samaritan.lua`

**The finding (MEDIUM, found independently by both review seats).**

Round M3 stopped `calmQuestGiver` from disarming a live fight, which was correct. But it does it
with a **bare `return`, and nothing ever re-arms the timer.** `calmQuestGiver` is armed only from
`giveCrystal:568`, i.e. only when the player hails Pwwoz.

So: a player at `STAGE_POSSESSED` walks away while Pwwoz is still swinging → the last queued calm
event fires mid-fight → returns → the fight later ends without anyone killing him →
**`AGGRESSIVE` is never cleared and nothing re-arms it.** He stays permanently hostile-on-sight
at the travel pad until someone kills him or the server restarts.

Confirmed: respawn does reset the bit (`AiAgentImplementation.cpp:2282` → `reloadTemplate` →
`setPvpStatusBitmask` from `som_pwwoz_pwwa.lua:29`, `pvpBitmask = ATTACKABLE`), and
`samaritan.lua:193` sets `respawn = 60`. But that only helps if he **dies**. The walk-away case
never kills him, so respawn never happens. The in-code comment "a later arm, or his respawn,
still clears the bit" is therefore only half true.

**The fix.** Reschedule instead of returning bare, so the cleanup retries after the fight ends.
Current (`:571-586`):

```lua
	-- Hailing Pwwoz again re-arms this timer, so an earlier arm can land in the middle
	-- of the fight it was meant to clean up after. Leave a live fight alone; a later
	-- arm, or his respawn, still clears the bit.
	if (AiAgent(pNpc):isInCombat()) then
		return
	end
```

Replace with a re-arm on the same `self.calmSeconds` interval already used at `:568`, and correct
the comment so it no longer claims something that is not reliably true:

```lua
	-- Hailing Pwwoz again re-arms this timer, so an earlier arm can land in the middle
	-- of the fight it was meant to clean up after. Leave a live fight alone and come back
	-- for it: a bare return would strand him AGGRESSIVE for good when the player walks
	-- away and the fight ends without anyone finishing him, since only giveCrystal arms
	-- this and respawn only clears the bit if he actually dies.
	if (AiAgent(pNpc):isInCombat()) then
		createEvent(self.calmSeconds * 1000, "samaritanScreenPlay", "calmQuestGiver", pNpc, "")
		return
	end
```

Notes you must respect:
- Use `self.calmSeconds` (`:233`, value 300), not a new literal. Do not add a new config field.
- The retry terminates on its own: the `:572` guard already returns on `pNpc == nil` or
  `isDead()`, and the underlying task holds a weak reference, so a destroyed NPC ends the chain.
  **Do not add a retry counter or a new stop flag** — there is nothing to persist it on and it
  would be inventing mechanism.
- Do NOT change `giveCrystal`, `calmSeconds`, the aggro lines, or the system message.

---

## Done means

- Exactly two files changed: `screenplays/mustafar/quest/cursed_shard.lua` and
  `screenplays/mustafar/quest/samaritan.lua`.
- No other file created, modified, deleted, or committed.
- Both parse under `luac5.3 -p`. The system Lua is at `/usr/bin/luac5.3` inside the WSL distro
  **`StardustDev`** — `wsl.exe -d StardustDev -- /usr/bin/luac5.3 -p <path>`. The default WSL
  distro is Ubuntu and does not have this tree; you must pass `-d StardustDev`.

## Report

Write `scratch/round-m3b/grok-report.txt` containing, for each edit: the file, the line range you
changed, and the final text of the changed region. Then list anything you were asked to do that
you could not do, and anything you noticed but were fenced off from. Be blunt about both.
