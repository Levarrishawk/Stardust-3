# ROUND G(b2a) — the Kenobi finale scripted event: ladder, waves, movers

Target file: `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/kenobi_spine.lua`
**This is the ONLY file you may edit.** Do not commit. Do not run git. Do not push.

Round G(b1) already placed the setpiece (pedestal, buff crystal, exit stone, Obi-Wan,
boss) and wrote `useCrystal` / `destroyCrystal` / `takeCrystal_finale` / `leaveLair` /
`grantFinaleBadge`. **Do not re-touch any of that** except where this spec says so
explicitly. Do not touch the quest-XP work from round G(a).

Fenced files — never open, never edit: `obi_wan_ghost.lua`, `surveyor_jo.lua`, the
retune-fenced `serverobjects.lua`, `jo_kelsev_conv_handler.lua`,
`MMOCoreORB/bin/conf/config.lua`.

Every touched file must pass `luac5.3 -p`.

**Amend findings forward. Never delete a recorded finding to make room for a new one.**
When this round overturns something G(b1) wrote, leave the old text in place and add an
`OVERTURNED -- ROUND G(b2)` paragraph under it saying what changed and why. That is this
file's established convention; match it.

---

## 1. What this round builds

Live's finale is a scripted six-beat encounter, not a boss standing in a room. The beat
ladder is `obiwan_event_manager.java:141-238` (`lightsCameraAction`), and it advances on
two triggers: a minion wave being cleared, and the boss being fought down.

The full sourced ladder, with every timing taken from the java:

| beat | what happens | advances when |
|---|---|---|
| 0 | boss laughs, `threaten`, taunts. Wave 1 (1 minion) at +20 s. | wave 1 cleared |
| 1 | boss `point_forward`, taunts. Obi-Wan warns at +3 s. Wave 2 (3 minions) at +6 s. | wave 2 cleared |
| 2 | boss taunts, **the buff crystal becomes usable**. Boss becomes vulnerable at +23 s — FIGHT ONE. | boss fought down to the floor |
| 3 | boss re-heals and re-locks. Wave 3 (5 minions) at +10 s. | wave 3 cleared |
| 4 | boss cries out. Boss becomes vulnerable at +10 s — FIGHT TWO, and this one can kill it. | boss dies |
| 5 | Obi-Wan congratulates, tells the player to destroy the crystal. | — (end) |

Beat 5 is **already** `bossKilled`. Round G(b2b) extends it. This round builds beats 0-4.

### What G(b1) got right and this round keeps

The boss fighting stand `(31, 0, 6)` (`moveBossToHomeLoc`, `obiwan_event_manager.java:486`)
and every setpiece coordinate. Unchanged.

### What this round OVERTURNS from G(b1)

**`lair.respawn = 600` and the boss being placed by `furnishLair`.**

G(b1) placed one boss per copy at `start()` with a 600 s respawn, and its comment
(`kenobi_spine.lua:536-541`) reasoned that without a respawn the first kill would empty
the copy for good. That reasoning was correct *for a static boss*, but the boss must not
be static at all.

Two things force this:

1. The boss has to be `INVULNERABLE` for most of the encounter. A respawn timer creates a
   **fresh** mobile with a clean options bitmask, so a respawned boss would stand there
   attackable and killable with no ladder running — the player could kill it without ever
   fighting the event.
2. Live does not place the boss statically either. `obiwan_event_manager.java:239-246`
   (`spawnBossDelay`) calls `mustafar.spawnContents(self, "boss", 1)` — the boss is
   spawned **into** the event.

So: `furnishLair` no longer spawns the boss. The ladder spawns it on entry with
`respawn = 0` and despawns any leftover from a previous run. That removes the
empty-copy problem entirely rather than papering over it with a timer.

Write this as an `OVERTURNED -- ROUND G(b2)` paragraph under the existing `respawn`
comment. Keep the old comment.

---

## 2. Where the state lives

Per **copy** (building), not per player — the setpiece is per copy and the pool grants one
player one copy at a time. Use `writeData`/`readData`, which is exactly the convention
`mustafar_instances.lua:625-632` already uses for this pool. It is in-memory only
(`DirectorSharedMemory.h`), which is correct: a scripted encounter cannot survive a
restart anyway, and neither can `createEvent`.

Key prefix: `"kenobiLair:" .. buildingID .. ":" .. field`.

| field | meaning |
|---|---|
| `session` | monotonically increasing token, bumped every time the ladder starts |
| `phase` | the beat number, 0-5 |
| `player` | object id of the player the ladder is running for |
| `boss` | object id of the ladder-spawned boss, 0 if none |
| `minions` | how many minions of the current wave are still alive |
| `fight` | 1 while the boss is vulnerable, else 0 (G(b2b) uses this) |

**Every** `createEvent` in this round passes `buildingID .. ":" .. session` as its args
string, and **every** handler re-reads the live session for that building and returns
immediately if it does not match. This is the volcano's session-guard idiom
(`volcano_battlefield.lua:996-1000`) and it is what stops a stale timer chain from a
previous run driving a new one. Do not skip it.

Add two small helpers next to the other lair code and use them everywhere:

```lua
function kenobiSpineScreenPlay:lairKey(buildingID, field)
	return "kenobiLair:" .. buildingID .. ":" .. field
end

-- Splits a "buildingID:session" event args string and verifies the session is still
-- the live one for that copy. Returns the buildingID, or 0 if the chain is stale.
function kenobiSpineScreenPlay:liveLair(args)
	local buildingID, session = string.match(tostring(args), "^(%d+):(%d+)$")

	if (buildingID == nil) then
		return 0
	end

	buildingID = tonumber(buildingID)

	if (readData(self:lairKey(buildingID, "session")) ~= tonumber(session)) then
		return 0
	end

	return buildingID
end
```

The spine's own `createEvent` idiom always passes `pPlayer` as the 4th argument
(`kenobi_spine.lua:1246, 1327, 1600, 1603, 1727`). Match it: pass `pPlayer`, and carry the
copy in the args string.

---

## 3. Config to add to the `lair` table

Add these next to the existing sub-tables. Every number is transcribed from the sources
named in the comments; write those citations into the file.

```lua
		--[[ The scripted event. Beats and timings are obiwan_event_manager.java's
		     lightsCameraAction ladder (:141-238) and the handlers it messages.
		     Positions are cell-local, same axis mapping as the setpiece above. ]]

		-- moveBossToHomeLoc, obiwan_event_manager.java:486. The fighting stand.
		bossHome = { x = 31, z = 0, y = 6 },
		-- moveBossToPostureLoc, :473. Where the boss retreats to monologue between waves.
		bossPosture = { x = 53, z = 0, y = 5 },
		-- moveObiwanToPostureLocation :554 and moveObiwanForCrystalComment :582.
		obiwanPosture = { x = 53.8, z = -0.4, y = 5.9 },
		-- moveObiwanOuttaTheWay, :568. Where he stands while minions are up.
		obiwanClear = { x = 48, z = 0, y = 9 },
		-- moveMinionIntoRoom, :540 -- every minion paths here, then
		-- utils.getRandomAwayLocation(home, 1.0f, 4.0f) scatters it 1-4 m off.
		minionMuster = { x = 55, z = 0, y = 6 },
		minionScatterMin = 1,
		minionScatterMax = 4,

		--[[ Wave sizes are minionWaveLaunch's switch, obiwan_event_manager.java:352-382:
		     wave 1 = spawnContents("minionA", 1); wave 2 = ("minionA", 2) + ("minionB", 1);
		     wave 3 = ("minionB", 2) + ("minionB", 3). So 1, 3, 5.

		     Live splits them by template -- minionA is som_kenobi_finale_minion_mix and
		     minionB is som_kenobi_finale_minion_melee (obiwan_event_data.tab). This tree
		     has neither. It has som_dark_jedi_minion_1..8, and all eight are the SAME
		     stat block -- level 85, baseHAM 12000/15000, PACK + STALKER, primary
		     dark_jedi_weapons_gen3 and secondary dark_jedi_weapons_ranged (verified
		     across all eight files). They differ only in appearance .iff. So live's
		     mix/melee split has no analogue here and carries no mechanical meaning;
		     only the wave SIZES survive the port. The eight variants are cycled purely
		     so the player does not fight the same face nine times. ]]
		waves = { 1, 3, 5 },
		minionTemplates = {
			"som_dark_jedi_minion_1", "som_dark_jedi_minion_2",
			"som_dark_jedi_minion_3", "som_dark_jedi_minion_4",
			"som_dark_jedi_minion_5", "som_dark_jedi_minion_6",
			"som_dark_jedi_minion_7", "som_dark_jedi_minion_8",
		},
```

Also add a counter `lairObserverCopies = 0` alongside the other `*Copies` fields.

---

## 4. Dialogue

Live's lines live in `mustafar/obiwan_finale.stf` (`mustafar.java:12`,
`STF_OBI_MSGS = "mustafar/obiwan_finale"`). **This repo ships no `.stf` files at all** —
`find . -name '*.stf'` under the server tree returns nothing; strings are TRE-side. So
whether that file is in this server's TRE set is unknown and cannot be settled from the
repo.

Ruling: **author the lines in plain English and cite the live key each one stands in for.**
If the stf is missing, an `@mustafar/obiwan_finale:som_dark_jedi_you_die_1` would render
as that raw string in the player's chat window — a visible defect. Authored English is
always correct-looking, and the cited key means anyone who later confirms the stf can swap
them mechanically. This is the same call this file already made for the radial strings,
for the same reason.

Put the lines in a table on `lair` so they are all in one place:

```lua
		--[[ Live delivers these through mustafar/obiwan_finale.stf (mustafar.java:12).
		     This repo ships no .stf files -- strings are TRE-side -- so whether that
		     file is present cannot be determined here, and a missing key would print
		     raw in the chat window. Authored instead, with the live key each line
		     stands in for. Swap them for "@mustafar/obiwan_finale:<key>" if the stf is
		     ever confirmed. ]]
		lines = {
			-- som_dark_jedi_crystal_speech1
			bossOpening = "So. Another one comes crawling to the crystal. It is mine, and you are nothing.",
			-- som_dark_jedi_attack_minions_1 / _2 / _3
			bossWave = {
				"Kill this one. I have waited long enough.",
				"More of you! Tear the fool apart!",
				"All of you! I will not be denied!",
			},
			-- som_dark_jedi_cannot_defeat_me
			bossCannotDefeat = "You cannot defeat me. Better than you have tried and been broken.",
			-- som_dark_jedi_destroy_you_myself
			bossDestroyYou = "Enough. If it must be done, I will destroy you myself.",
			-- som_dark_jedi_snap_you_half
			bossSnapYouHalf = "I am going to snap you in half.",
			-- som_dark_jedi_nooo
			bossNooo = "No! The crystal is MINE!",
			-- som_obi_be_careful
			obiBeCareful = "Careful. He is stronger than he looks, and he is not fighting alone.",
			-- som_obi_be_careful2
			obiBeCareful2 = "The crystal behind him -- draw on it if you must. It will not last.",
		},
```

Delivery: `spatialChat(pSpeaker, text)` — `DirectorManager.cpp:449`, 2 args, in-tree at
`deathWatchBunker.lua:1094` and `warren.lua:125`.

---

## 5. `furnishLair` changes

Three edits, and nothing else in that function.

1. **Stop spawning the boss.** Remove the `spawnMobile(... self.lair.boss ...)` block and
   the `self.bossCopies` increment. Leave `bossCopies` declared in the config block (it is
   now written by the ladder, not by `furnishLair` — say so in a one-line comment).

2. **Record the Obi-Wan pointer per copy.** The existing Obi-Wan spawn already returns a
   pointer that is currently discarded. Capture it and store it so the ladder can make him
   speak and move:

```lua
					local pObiwan = spawnMobile("mustafar", obiwan.template, 0, obiwan.x, obiwan.z, obiwan.y, obiwan.heading, cellID)

					if (pObiwan == nil) then
						printLuaError("kenobiSpineScreenPlay: failed to spawn " .. obiwan.template .. " in the lair copy " .. buildings[i])
					else
						writeData(self:lairKey(buildings[i], "obiwan"), SceneObject(pObiwan):getObjectID())
						self.obiwanLairCopies = self.obiwanLairCopies + 1
					end
```

3. **Attach the entry observer.** At the end of the per-copy block, once the cell resolved:

```lua
				if (createObserver(ENTEREDBUILDING, "kenobiSpineScreenPlay", "notifyEnteredLair", pBuilding) ~= nil) then
					self.lairObserverCopies = self.lairObserverCopies + 1
				end
```

`ENTEREDBUILDING` is a registered Lua global (`DirectorManager.cpp:601`). `createObserver`
is 4 or 5 args (`DirectorManager.cpp:3363-3403`); the 4-arg form is what this file already
uses for its two areas (`kenobi_spine.lua:814, 824`). `MustafarInstances` also observes
`ENTEREDBUILDING` on these same copies (`mustafar_instances.lua:465`) — that is fine,
observers are a list, and both handlers return 0 to stay attached.

---

## 6. The trigger

```lua
--[[ The ladder starts when a STAGE_LAIR player walks into a lair copy.

     Live starts it from the boss's own OnAttach (obiwan_lair_boss.java:37-52), which
     fires when the event manager spawns the boss into the freshly-created instance --
     i.e. on arrival. Arrival is therefore the faithful trigger, and it is also the only
     workable one: the boss is INVULNERABLE for most of the encounter, and an
     INVULNERABLE agent is not attackable at all (AiAgentImplementation.cpp:4358 --
     isAttackableBy returns false on the bit), so "the player swung at the boss" could
     never fire.

     Observer contract: return 0 to stay attached, 1 to drop
     (ScreenPlayObserverImplementation.cpp:40). This one stays -- the copy is reused. ]]
function kenobiSpineScreenPlay:notifyEnteredLair(pBuilding, pPlayer)
```

Body, in order:

- nil-guard both; `return 0` on nil.
- `if (not CreatureObject(pPlayer):isPlayerCreature()) then return 0 end` — the observer
  also fires for spawned NPCs entering.
- `if (self:getStage(pPlayer) ~= self.STAGE_LAIR) then return 0 end`
- `local buildingID = SceneObject(pBuilding):getObjectID()`
- If a ladder is already running for this copy **for this same player**, return 0 — do not
  restart it on a re-entry. Compare `readData(self:lairKey(buildingID, "player"))` with the
  player's object id and check `readData(self:lairKey(buildingID, "phase"))`.
- Otherwise `self:startLair(buildingID, pPlayer)`.
- `return 0`.

---

## 7. `startLair`

```lua
function kenobiSpineScreenPlay:startLair(buildingID, pPlayer)
```

- `self:clearLair(buildingID)` first — see §11. A copy is reused, and the previous
  occupant may have left a boss and minions standing.
- Bump the session: `local session = readData(self:lairKey(buildingID, "session")) + 1`
  then write it back.
- Write `player` = player object id, `phase` = 0, `minions` = 0, `fight` = 0.
- Resolve the cell: `local pBuilding = getSceneObject(buildingID)`, then
  `local cellID = self:resolveCell(pBuilding, self.lair.cellName, 0)`. Bail with a
  `printLuaError` if it is 0.
- Spawn the boss at the fighting stand, **respawn 0**, and lock it:

```lua
	local pBoss = spawnMobile("mustafar", self.lair.boss, 0, self.lair.x, self.lair.z, self.lair.y, self.lair.heading, cellID)

	if (pBoss == nil) then
		printLuaError("kenobiSpineScreenPlay: failed to spawn " .. self.lair.boss .. " in lair copy " .. buildingID)
		return
	end

	-- Live holds the boss with setInvulnerable(true) (obiwan_lair_boss.java:40). There is
	-- no setInvulnerable binding in this tree; the substitution is the INVULNERABLE
	-- option bit (DirectorManager.cpp:737 registers the global,
	-- LuaTangibleObject.cpp:49-51 binds the setters), which zeroes all damage
	-- (CreatureObjectImplementation.cpp:1199) and makes the agent untargetable
	-- (AiAgentImplementation.cpp:4358). Same substitution the volcano arena already
	-- ruled and uses -- volcano_battlefield.lua:448 and :2214.
	TangibleObject(pBoss):setOptionBit(INVULNERABLE)
	writeData(self:lairKey(buildingID, "boss"), SceneObject(pBoss):getObjectID())
	self.bossCopies = self.bossCopies + 1
```

- Then fire beat 0 after a short beat so the player is settled — live delays the first
  `lightsCameraAction` by 16 s from the boss's OnAttach (`obiwan_lair_boss.java:51`). Use
  that:

```lua
	createEvent(16 * 1000, "kenobiSpineScreenPlay", "lairBeat", pPlayer, buildingID .. ":" .. session)
```

---

## 8. `lairBeat` — the ladder

```lua
function kenobiSpineScreenPlay:lairBeat(pPlayer, args)
```

This is `lightsCameraAction`. Structure it exactly as the java does: read the phase, run
that phase's block, then increment the phase.

Preamble every handler in this round shares:

```lua
	local buildingID = self:liveLair(args)

	if (buildingID == 0) then
		return
	end

	local session = readData(self:lairKey(buildingID, "session"))
	local pBoss = getSceneObject(readData(self:lairKey(buildingID, "boss")))
	local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end
```

Then the phase switch. Each `createEvent` below uses the same 5-arg shape,
`pPlayer` as the object and `buildingID .. ":" .. session` as the args.

**phase 0** — `obiwan_event_manager.java:159-169`, then `darkJediThrowsDownPartOne` :247-257
```lua
		CreatureObject(pPlayer):playEffect("clienteffect/mustafar/som_dark_jedi_laugh.cef", "")
		CreatureObject(pBoss):doAnimation("threaten")
		spatialChat(pBoss, self.lair.lines.bossOpening)
		-- :168 messages darkJediThrowsDownPartOne at +10 s, which then schedules the
		-- wave at +10 s (:255) and the boss's walk home at +14 s (:254).
		createEvent(20 * 1000, "kenobiSpineScreenPlay", "lairWave", pPlayer, args)
		createEvent(24 * 1000, "kenobiSpineScreenPlay", "lairBossHome", pPlayer, args)
```

**phase 1** — `:170-183`
```lua
		CreatureObject(pBoss):doAnimation("point_forward")
		spatialChat(pBoss, self.lair.lines.bossCannotDefeat)
		createEvent(3 * 1000, "kenobiSpineScreenPlay", "lairObiWarns", pPlayer, args)
		createEvent(6 * 1000, "kenobiSpineScreenPlay", "lairWave", pPlayer, args)
		createEvent(10 * 1000, "kenobiSpineScreenPlay", "lairBossHome", pPlayer, args)
```

**phase 2** — `:184-195`. Note `:191` sets `readyToUseCrystal` on the player; that is what
makes the buff crystal usable, and §10 wires it.
```lua
		spatialChat(pBoss, self.lair.lines.bossDestroyYou)
		writeScreenPlayData(pPlayer, self.screenplayName, "crystalReady", "1")
		createEvent(1 * 1000, "kenobiSpineScreenPlay", "lairObiToCrystal", pPlayer, args)
		createEvent(17 * 1000, "kenobiSpineScreenPlay", "lairBossThrowsDown", pPlayer, args)
		createEvent(23 * 1000, "kenobiSpineScreenPlay", "lairStartFight", pPlayer, args)
```

**phase 3** — `:196-203`
```lua
		createEvent(1 * 1000, "kenobiSpineScreenPlay", "lairBossHome", pPlayer, args)
		createEvent(10 * 1000, "kenobiSpineScreenPlay", "lairWave", pPlayer, args)
```

**phase 4** — `:204-213`
```lua
		spatialChat(pBoss, self.lair.lines.bossNooo)
		createEvent(10 * 1000, "kenobiSpineScreenPlay", "lairStartFight", pPlayer, args)
```

**phase 5 or higher** — return without incrementing. Beat 5 is `bossKilled`, which round
G(b2b) owns; the ladder does not drive it. Write that as a comment.

Then, for phases 0-4 only:
```lua
	writeData(self:lairKey(buildingID, "phase"), phase + 1)
```

`lairStartFight` is **defined in round G(b2b)**. For this round, write it as a stub that
only clears the invulnerability bit and sets `fight` to 1, with a comment saying G(b2b)
adds the force-power attacks and the fight-end detection on top:

```lua
--[[ obiwan_lair_boss.java:208-235, startFighting. Round G(b2b) adds the force-power
     attack cycle and the fight-end detection; this is the part both fights share. ]]
function kenobiSpineScreenPlay:lairStartFight(pPlayer, args)
	-- preamble as above
	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)
	writeData(self:lairKey(buildingID, "fight"), 1)
	AiAgent(pBoss):setDefender(pPlayer)
end
```

---

## 9. The small handlers

All take `(pPlayer, args)` and all open with the same preamble.

**`lairObiWarns`** — `obiSaysBeCareful`, `:258-268`. `spatialChat(pObiwan, self.lair.lines.obiBeCareful)`.
Bail quietly if `pObiwan` is nil.

**`lairObiToCrystal`** — `moveObiwanForCrystalComment`, `:574-588`. Move Obi-Wan to
`self.lair.obiwanPosture`, then `createEvent(4 * 1000, ..., "lairObiWarns2", ...)` — the
java messages `obiSaysBeCareful2` at +4 s (`:585`).

**`lairObiWarns2`** — `obiSaysBeCareful2`, `:269-280`. Say `obiBeCareful2`, then at +5 s
(`:278`, `moveObiwanHomeAfterCommenting`) move him back to `self.lair.obiwan` — his
hangBackLocation. Schedule `lairObiHome` for that.

**`lairObiHome`** — move Obi-Wan to `self.lair.obiwan`.

**`lairObiClear`** — `moveObiwanOuttaTheWay`, `:560-573`. Move him to
`self.lair.obiwanClear`. `minionWaveLaunch` messages this at +5 s (`:383`).

**`lairBossThrowsDown`** — `darkJediThrowsDownPartTwo`, `:317-328`.
`spatialChat(pBoss, self.lair.lines.bossSnapYouHalf)`.

**`lairBossHome`** — `moveBossToHomeLoc`, `:478-490`. Move the boss to `self.lair.bossHome`.

**`lairBossPosture`** — `moveBossToPostureLoc`, `:465-477`. Move the boss to
`self.lair.bossPosture`.

### The mover helper

Write one helper and have all six movers call it:

```lua
--[[ Live moves everyone with ai_lib.aiPathTo + setHomeLocation
     (obiwan_event_manager.java:474-475 and friends). This tree binds
     AiAgent:setNextPosition(x, z, y, cellID) -- LuaAiAgent.cpp:45, and the cellID is a
     NUMERIC id, which is what an in-cell move needs. The sequence around it is
     fs_cs_commander.lua:321-327's.

     setHomeLocation is deliberately NOT called. Its binding takes the cell as
     lightuserdata, not as an id, and every screenplay in the tree passes a literal 0 --
     which for an in-cell mob would pin its home to an outdoor position and make it try
     to leash out of the building. setNextPosition alone is the correct in-cell move. ]]
function kenobiSpineScreenPlay:moveLairActor(pActor, where, cellID)
	if (pActor == nil or where == nil or cellID == 0) then
		return
	end

	AiAgent(pActor):stopWaiting()
	AiAgent(pActor):setWait(0)
	AiAgent(pActor):setNextPosition(where.x, where.z, where.y, cellID)
	AiAgent(pActor):executeBehavior()
end
```

Each mover resolves its cell the same way `furnishLair` does — `getSceneObject(buildingID)`
then `self:resolveCell(pBuilding, self.lair.cellName, 0)`.

---

## 10. Gating the buff crystal on the ladder

`useCrystal` currently gates only on `STAGE_LAIR`. Live gates it on the player's
`readyToUseCrystal` scriptvar, which `lightsCameraAction` sets at beat 2
(`obiwan_event_manager.java:191`) and clears on entry to every other beat (`:147-150`).

Add the gate to `useCrystal`, right after the existing stage check, and record why:

```lua
	--[[ Live sets readyToUseCrystal on the player at beat 2 only
	     (obiwan_event_manager.java:191) and strips it at the top of every other beat
	     (:147-150), so the crystal is a lifeline for the two fights and nothing else.
	     Without this gate the player could drain it before the first minion lands. ]]
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crystalReady")) or 0) ~= 1) then
		CreatureObject(pPlayer):sendSystemMessage("The crystal is dark. Whatever power it holds, it is not yours to take yet.")
		return
	end
```

Add `crystalReady` to the STATE doc block, one line, in the same style as its neighbours.

---

## 11. Waves, wave clear, and cleanup

### `lairWave`

Preamble, then:

```lua
	local phase = readData(self:lairKey(buildingID, "phase"))
	local size = self.lair.waves[phase] or 0
```

Beat 0 launches wave 1, beat 1 wave 2, beat 3 wave 3. Beats 2 and 4 are fights and never
call this. Since `phase` has **not** yet been incremented when `lairWave` is scheduled but
**has** been by the time it fires, index the wave table by a value carried in the args
instead of by the live phase — safer than reasoning about ordering. Extend the args string
for this one call to `buildingID .. ":" .. session .. ":" .. waveIndex` and have `lairWave`
parse the third field. Keep `liveLair` working by making its pattern tolerate a trailing
`:%d+`.

Body:
- `spatialChat(pBoss, self.lair.lines.bossWave[waveIndex])` — `minionWaveLaunch` :344-347.
- `writeData(self:lairKey(buildingID, "minions"), size)`.
- Spawn `size` minions:

```lua
	for i = 1, size do
		local muster = self.lair.minionMuster
		local dx = getRandomNumber(self.lair.minionScatterMin, self.lair.minionScatterMax)
		local dy = getRandomNumber(self.lair.minionScatterMin, self.lair.minionScatterMax)
		local template = self.lair.minionTemplates[((waveIndex * 3 + i) % #self.lair.minionTemplates) + 1]
		local pMinion = spawnMobile("mustafar", template, 0, muster.x + dx, muster.z, muster.y + dy, getRandomNumber(0, 359), cellID)

		if (pMinion == nil) then
			printLuaError("kenobiSpineScreenPlay: failed to spawn " .. template .. " in lair copy " .. buildingID)
		else
			createObserver(OBJECTDESTRUCTION, "kenobiSpineScreenPlay", "notifyLairMinionKilled", pMinion)
			AiAgent(pMinion):setDefender(pPlayer)
		end
	end
```

Carry this comment on the spawn loop:

```lua
	--[[ Live spawns minions at the tab's (9, 0, -3.5) doorway and then paths each one to
	     (55, 0, 6) with utils.getRandomAwayLocation(home, 1.0f, 4.0f)
	     (obiwan_event_manager.java:532-544, moveMinionIntoRoom). Collapsed here into a
	     direct spawn at the destination with the same 1-4 m scatter: this tree has no
	     in-cell aiPathTo, and setNextPosition gives no arrival guarantee inside a
	     building, so pathing them from the doorway risks a wave that never reaches the
	     player and a ladder that never advances. The end state -- a scattered wave at
	     (55, 0, 6) attacking the player -- is identical.

	     OBJECTDESTRUCTION per minion rather than counting through the player's
	     KILLEDCREATURE observer: this fires whoever lands the kill, so a minion that
	     dies to anything else still advances the ladder. Same pattern as
	     lava_beetle_nests.lua:692-720, in this same directory. ]]
```

- Then `createEvent(5 * 1000, "kenobiSpineScreenPlay", "lairObiClear", pPlayer, args)` —
  `minionWaveLaunch` :383.

### `notifyLairMinionKilled`

Observer on the minion. `pMinion` is the observable; find its copy with
`SceneObject(pMinion):getRootParent()` — the pattern `leaveLair` already uses
(`kenobi_spine.lua:1974`).

- Decrement `minions` for that copy, floor at 0.
- If it reaches 0: `minionDied`, `obiwan_event_manager.java:386-396` — move the boss to the
  posture spot at +1 s and fire the next beat at +8 s.

```lua
		createEvent(1 * 1000, "kenobiSpineScreenPlay", "lairBossPosture", pPlayer, args)
		createEvent(8 * 1000, "kenobiSpineScreenPlay", "lairBeat", pPlayer, args)
```

- **Return 1** — drop the observer, the minion is gone
  (`ScreenPlayObserverImplementation.cpp:40`). Every other return in this round is 0.

### `clearLair`

```lua
--[[ A copy is reused. Whatever the previous occupant left standing -- a boss they never
     killed, a half-cleared wave -- has to go before a new ladder starts, or the next
     player walks into someone else's fight. Bumping the session in startLair kills the
     old timer chain; this kills the old bodies. ]]
function kenobiSpineScreenPlay:clearLair(buildingID)
```

- Despawn the recorded boss if it is still there: `getSceneObject` the stored id, and if
  non-nil `SceneObject(pBoss):destroyObjectFromWorld()` (`LuaSceneObject.cpp:61`).
- Zero every field for that copy: `boss`, `minions`, `phase`, `player`, `fight`.
- Minions are not individually recorded. Note in the comment that they are left to their
  own `OBJECTDESTRUCTION`/despawn handling and that the session bump stops them counting
  toward the new ladder — the `minions` counter being reset to 0 is what matters, and a
  stale minion killed later hits `notifyLairMinionKilled`, which floors at 0 and finds no
  live session, so it cannot advance the new ladder. Make sure the handler actually does
  check the session before advancing; that is what makes this safe.

---

## 12. Where the new code goes

Put the whole event block **after** `furnishLair` and **before** the STATE doc block, in
this order: `lairKey`, `liveLair`, `moveLairActor`, `notifyEnteredLair`, `startLair`,
`clearLair`, `lairBeat`, `lairWave`, `notifyLairMinionKilled`, then the small handlers,
then the `lairStartFight` stub.

Extend the `WHERE EVERYTHING IS` header block with a short paragraph naming the new
section and the two source files it came from. Do not rewrite what is already there.

---

## 13. Done means

- `luac5.3 -p` passes on `kenobi_spine.lua`.
- No file other than `kenobi_spine.lua` is modified.
- Every `createEvent` carries the session and every handler checks it.
- Every sourced number in this spec appears in the file with its citation comment.
- The G(b1) `respawn` comment is still present, with the `OVERTURNED -- ROUND G(b2)`
  paragraph added under it.

Do not commit. Do not run git. Do not push.
