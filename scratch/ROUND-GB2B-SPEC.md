# ROUND G(b2b) — the Kenobi finale: the two fights, the force attacks, the ending

Target file: `MMOCoreORB/bin/scripts/screenplays/mustafar/quest/kenobi_spine.lua`
**This is the ONLY file you may edit.** Do not commit. Do not run git. Do not push.

This round runs **after** round G(b2a) and builds on the structures that round put in
place: `lairKey`, `liveLair`, `moveLairActor`, `startLair`, `clearLair`, `lairBeat`,
`lairWave`, `notifyLairMinionKilled`, and the `lairStartFight` stub.

**Do not re-touch** the round G(a) quest-XP work, and do not rewrite anything G(b2a)
wrote except where this spec names the function.

Fenced files — never open, never edit: `obi_wan_ghost.lua`, `surveyor_jo.lua`, the
retune-fenced `serverobjects.lua`, `jo_kelsev_conv_handler.lua`,
`MMOCoreORB/bin/conf/config.lua`.

Every touched file must pass `luac5.3 -p`.

**Amend findings forward. Never delete a recorded finding to make room for a new one.**
When this round overturns something an earlier round wrote, leave the old text in place
and add an `OVERTURNED -- ROUND G(b2b)` paragraph under it. That is this file's
established convention; match it.

Observer contract, everywhere in this round: the handler **must** return a number.
**1 drops the observer, 0 keeps it** (`ScreenPlayObserverImplementation.cpp:40`).

---

## 1. What this round builds

G(b2a) built the beat ladder and the waves. It left both fights as a stub that only
unlocks the boss. This round builds what happens *inside* a fight, and the ending.

Four things, all from `obiwan_lair_boss.java`:

1. **The special force-power attack cycle** — a windup every 10-20 s, an execute 15 s
   later, four attack rows with their own damage bands and effects
   (`:311-355`, `:356-438`).
2. **The interrupt.** A single hit for more than 2000 damage while the boss is winding
   up cancels the attack, staggers him, and Obi-Wan calls it out (`:35`, `:101-140`).
3. **The end of fight one** — live cancels the boss's death and heals him back
   (`:54-87`, `stopFighting` `:192-207`).
4. **Banter** — the boss taunts, Obi-Wan encourages, both on their own timers
   (`:236-276`, `:277-310`).

Plus beat 5: Obi-Wan congratulates the player and tells them to destroy the crystal
(`obiwan_event_manager.java:214-229`, `:491-531`).

---

## 2. The fight-one problem, and the ruling

This is the one place the port cannot be a transcription. Write the reasoning into the
file as a block comment above `notifyLairBossDamaged`, in these terms.

**Live.** The boss has 155000 HP (`obiwan_lair_boss.java:41`) and fight one runs the
whole bar down to zero. At the moment of death `OnAboutToBeIncapacitated` (`:54-87`)
returns `SCRIPT_OVERRIDE`, which **cancels the incapacitation**, and `stopFighting`
(`:192-207`) re-locks him, plays a heal effect, and puts 150000 health back
(`addToHealth(self, 150000)`). So live's encounter is two full bars of boss.

**Here.** There is no pre-death hook. `OBJECTDESTRUCTION` fires *after* posture DEAD is
already set, so returning from its handler cannot un-kill anything. Nothing in this tree
corresponds to `SCRIPT_OVERRIDE`.

**Ruling: end fight one at a health floor instead of at zero.** A `DAMAGERECEIVED`
observer on the boss watches health after every hit; when it crosses 25 % of max, fight
one ends — full heal, re-lock, ladder advances. Chosen over the volcano arena's polling
timer (`volcano_battlefield.lua`) because a poll can be outrun: a 3000 ms tick against a
boss losing health every swing can find him already dead. `DAMAGERECEIVED` fires on the
swing itself, so the only way to skip the floor is one hit for 25 % of the bar.

**Why 25 % and not lower.** This tree's boss is `som_dark_jedi_boss`, `baseHAM = 44000`,
`baseHAMmax = 54000` (`mobile/custom_content/som/som_dark_jedi_boss.lua:27-28`). A 25 %
floor leaves 11000-13500 health in the pool — far above any single player hit at this
level, so the floor cannot be jumped. Use the fraction, not a literal: read
`getMaxHAM(0)` so the check is correct whatever the roll gave him.

**What it costs.** Live asks for 155000 + 150000 ≈ two full bars. This asks for 0.75 of
a bar, then a full one — 1.75 bars. The encounter is slightly shorter than live's and
the shape is identical: fight, interrupted, wave, fight again to the death.

**And if he dies anyway.** He degrades into the normal ending. `bossKilled` is the
existing beat-5 handler and it does not care which fight killed him, so a freak
one-shot gives the player a correct, completed quest instead of a hung instance. That is
deliberate; say so in the comment.

---

## 3. Config to add to the `lair` table

Everything transcribed. Write the citations into the file.

```lua
		--[[ The special force-power attack. Four rows, obiwan_event_data.tab's
		     forcePowerAttack entries -- name, the animation the boss plays on
		     execute, the client effect played on the PLAYER, and the damage band.
		     The band is the whole difficulty curve of the attack: a multiStoneThrow
		     that lands is 3000-4000, which is why blocking it matters. ]]
		forceAttacks = {
			{ name = "singleStoneThrow", animation = "force_push",     effect = "clienteffect/mustafar/dark_jedi_rock_attack_1.cef",  minDamage = 500,  maxDamage = 1000 },
			{ name = "doubleStoneThrow", animation = "force_strength", effect = "clienteffect/mustafar/dark_jedi_rock_attack_2.cef",  minDamage = 1000, maxDamage = 2000 },
			{ name = "tripleStoneThrow", animation = "force_strength", effect = "clienteffect/mustafar/dark_jedi_rock_attack_3.cef",  minDamage = 2000, maxDamage = 3000 },
			{ name = "multiStoneThrow",  animation = "force_choke",    effect = "clienteffect/mustafar/dark_jedi_rock_attack_10.cef", minDamage = 3000, maxDamage = 4000 },
		},

		--[[ The WINDUP is deliberately not the same effect as the execute. On windup
		     the boss plays one of three animations and one of four client effects on
		     HIMSELF, all picked at random and none of them tied to the row that will
		     actually fire (obiwan_lair_boss.java:348-352 rolls the row, the anim and
		     the cef independently). That is the tell the player has to read: something
		     is coming, but not what. Lists are FORCE_ATTACK_ANIMS :15-20 and
		     FORCE_ATTACK_CEFS :21-27. ]]
		forceWindupAnims = { "force_push", "force_strength", "force_choke" },
		forceWindupEffects = {
			"clienteffect/pl_force_tangle.cef",
			"clienteffect/pl_force_lightning_begin.cef",
			"clienteffect/pl_force_weaken.cef",
			"clienteffect/pl_force_blast.cef",
		},

		-- FORCE_ATTACK_ABORT_DAMAGE_REQUIRED, obiwan_lair_boss.java:35. One hit over
		-- this while he is winding up cancels the attack.
		forceInterruptDamage = 2000,
		-- messageTo "specialForcePowerAttackWindup", rand(10, 20) -- :233, :365, :433.
		forceWindupMin = 10,
		forceWindupMax = 20,
		-- messageTo "specialForcePowerAttackExecute", 15 -- :351. Fixed, not a roll.
		forceExecuteDelay = 15,
		-- randomTaunter rand(10, 30) :231 / :267; randomPraiser rand(15, 30) :232 / :306.
		tauntMin = 10,
		tauntMax = 30,
		praiseMin = 15,
		praiseMax = 30,
		--[[ Fight one ends here instead of at zero. See notifyLairBossDamaged for why
		     a health floor replaces live's OnAboutToBeIncapacitated + SCRIPT_OVERRIDE. ]]
		fightOneFloor = 0.25,
		-- obiRepeatsDestroyCrystal, obiwan_event_manager.java:501, :529.
		nagMin = 20,
		nagMax = 40,
```

### Lines to add to `lair.lines`

Same ruling as G(b2a) §4 — this repo ships no `.stf` files, strings are TRE-side, and a
missing key renders raw in the chat window. Author the English, cite the live key.

```lua
			--[[ som_dark_jedi_you_die_1 .. _15, rolled by randomTaunter
			     (obiwan_lair_boss.java:263). Eight authored rather than fifteen --
			     the point of the list is that he does not repeat himself inside one
			     fight, and at rand(10,30) seconds a fight will not draw eight. ]]
			bossTaunts = {
				"You fight well. It will not be enough.",
				"Is that all the Force gave you?",
				"You are already tired. I can hear it.",
				"Every one of you dies the same way.",
				"The crystal is watching you fail.",
				"Kneel, and I may make it quick.",
				"You should have stayed on the shore.",
				"I have killed better and forgotten them.",
			},
			--[[ som_obiwan_sayings_1 .. _10, rolled by randomPraiser (:302). Six
			     authored, same reasoning. Obi-Wan is a ghost giving encouragement,
			     not a combatant -- he never intervenes. ]]
			obiSayings = {
				"Steady. Do not let his anger become yours.",
				"Good. You see the opening before he does.",
				"He is stronger than you. That is not the same as better.",
				"Breathe. The Force is not in a hurry.",
				"He fights to be feared. You fight to be finished.",
				"You are doing well. Do not stop.",
			},
			-- som_obi_lookout_special, obiwan_event_manager.java:295.
			obiLookoutSpecial = "Look out -- he is gathering something. Break his focus!",
			-- som_obi_block_special, :311.
			obiBlockSpecial = "Yes! You broke it. He cannot hold that and take a hit.",
			-- som_obi_won_congrats, :224.
			obiWonCongrats = "It is over. You did what I could not ask anyone else to do.",
			-- som_obi_destroy_crystal, :496.
			obiDestroyCrystal = "The crystal is what he came for. Destroy it, and none of this happens again.",
			-- som_obi_destroy_crystal_short, :525.
			obiDestroyCrystalShort = "The crystal. Deal with it.",
```

---

## 4. One addition to `startLair`

`bossKilled` is reached through `notifyKilledCreature` (`kenobi_spine.lua:1408-1411`),
which has the player and the victim but no copy. Give it the copy:

```lua
	-- bossKilled arrives through notifyKilledCreature, which has no building. Record
	-- the copy on the player so the ending can find the ladder it has to shut down.
	writeScreenPlayData(pPlayer, self.screenplayName, "lairCopy", tostring(buildingID))
```

Add `lairCopy` to the STATE doc block, one line, matching its neighbours.

---

## 5. `lairStartFight` — replace the G(b2a) stub

`obiwan_lair_boss.java:208-235`, `startFighting`.

Keep the stub's body (clear `INVULNERABLE`, set `fight`, set the defender) and add:

- Bump a fight token and store it:
  `local fightNum = readData(self:lairKey(buildingID, "fightNum")) + 1`, write it back.
- Clear `noForce` and `forceAtk` to 0.
- `CreatureObject(pBoss):engageCombat(pPlayer)` after `AiAgent(pBoss):setDefender(pPlayer)`
  — live calls `startCombat(self, target)` (`:229`), and `engageCombat` is the binding
  for it (`LuaCreatureObject.cpp:87`).
- Attach the damage observer, once per ladder run, not once per fight:

```lua
	if (readData(self:lairKey(buildingID, "dmgObs")) ~= 1) then
		createObserver(DAMAGERECEIVED, "kenobiSpineScreenPlay", "notifyLairBossDamaged", pBoss)
		writeData(self:lairKey(buildingID, "dmgObs"), 1)
	end
```

- Start the three chains, each carrying the fight token as a third args field:

```lua
	local fightArgs = buildingID .. ":" .. session .. ":" .. fightNum

	createEvent(getRandomNumber(self.lair.forceWindupMin, self.lair.forceWindupMax) * 1000, "kenobiSpineScreenPlay", "lairForceWindup", pPlayer, fightArgs)
	createEvent(getRandomNumber(self.lair.tauntMin, self.lair.tauntMax) * 1000, "kenobiSpineScreenPlay", "lairTaunt", pPlayer, fightArgs)
	createEvent(getRandomNumber(self.lair.praiseMin, self.lair.praiseMax) * 1000, "kenobiSpineScreenPlay", "lairPraise", pPlayer, fightArgs)
```

### The fight-token helper

G(b2a)'s `liveLair` already tolerates a trailing `:%d+` third field. Add a companion
that reads it and checks it, and use it at the top of every handler in this round that
belongs to a fight chain:

```lua
--[[ The session token says "this ladder run is still the live one". The fight token
     says "this is still the same FIGHT". Both are needed: fight one and fight two are
     the same ladder run, so a taunt timer left over from fight one would otherwise
     re-arm itself inside fight two and the player would face two overlapping chains of
     force attacks. Bumped in lairStartFight, checked here. ]]
function kenobiSpineScreenPlay:liveFight(buildingID, args)
	local fightNum = tonumber(string.match(tostring(args), "^%d+:%d+:(%d+)$"))

	if (fightNum == nil) then
		return false
	end

	if (readData(self:lairKey(buildingID, "fight")) ~= 1) then
		return false
	end

	return readData(self:lairKey(buildingID, "fightNum")) == fightNum
end
```

---

## 6. `notifyLairBossDamaged` — the damage observer

Signature is fixed by the engine: `(pObservable, pArg1, arg2)`, and for
`DAMAGERECEIVED` that is the boss, the attacker, and the damage
(`ObserverEventType.h:43`, `CombatManager.cpp:2002`). The in-tree precedent with exactly
this shape is `deathWatchBunker.lua`'s `haldoDamage` — same health-fraction test, same
1/0 return.

```lua
function kenobiSpineScreenPlay:notifyLairBossDamaged(pBoss, pAttacker, damage)
```

Carry the whole §2 ruling as the block comment above it.

Body, in order:

- `if (pBoss == nil) then return 1 end` — nothing to watch.
- Find the copy: `local pBuilding = SceneObject(pBoss):getRootParent()`, then its object
  id. Bail with `return 1` if there is no building parent. This is `leaveLair`'s pattern
  (`kenobi_spine.lua:1974`).
- `if (readData(self:lairKey(buildingID, "fight")) ~= 1) then return 0 end` — he is
  locked between fights; keep the observer, do nothing.
- Recover the player: `getSceneObject(readData(self:lairKey(buildingID, "player")))`.
  `return 0` if nil.
- **The interrupt**, first, because live checks it first (`:124-138`):

```lua
	if (damage ~= nil and damage > self.lair.forceInterruptDamage and readData(self:lairKey(buildingID, "forceAtk")) ~= 0) then
		--[[ obiwan_lair_boss.java:124-138. One hit over 2000 while he is winding up
		     cancels the attack outright -- the queued row is dropped, he takes the
		     heavy-hit stagger, and the execute timer finds noForce set and re-winds
		     instead of firing. This is the encounter's only real mechanic: the player
		     is meant to save a hard hit for the windup tell. ]]
		writeData(self:lairKey(buildingID, "forceAtk"), 0)
		writeData(self:lairKey(buildingID, "noForce"), 1)
		CreatureObject(pBoss):doAnimation("anims.HUMAN_REA_STAND_COMBAT_GET_HIT_HEAVY")

		local pObiwan = getSceneObject(readData(self:lairKey(buildingID, "obiwan")))

		if (pObiwan ~= nil) then
			SceneObject(pObiwan):faceObject(pPlayer, true)
			spatialChat(pObiwan, self.lair.lines.obiBlockSpecial)
		end
	end
```

- **The floor.** Only during fight one. G(b2a)'s ladder makes `phase` a clean
  discriminator: `lairStartFight` is scheduled from the phase-2 block, and `lairBeat`
  increments after the block, so `phase` is 3 for the whole of fight one and 5 for the
  whole of fight two. Write that reasoning as a comment — it is not obvious from the
  code.

```lua
	if (readData(self:lairKey(buildingID, "phase")) == 3) then
		local maxHealth = CreatureObject(pBoss):getMaxHAM(0)

		if (maxHealth > 0 and CreatureObject(pBoss):getHAM(0) <= (maxHealth * self.lair.fightOneFloor)) then
			self:lairEndFightOne(buildingID, pPlayer, pBoss)
		end
	end
```

- `return 0` — the observer has to survive fight one to police fight two.

---

## 7. `lairEndFightOne`

`obiwan_lair_boss.java`'s `stopFighting` (`:192-207`) plus the `lightsCameraAction`
message `OnAboutToBeIncapacitated` sends at `:84`.

```lua
function kenobiSpineScreenPlay:lairEndFightOne(buildingID, pPlayer, pBoss)
```

In order:

- `writeData(self:lairKey(buildingID, "fight"), 0)` **first** — that alone kills the
  taunt, praise and force chains at their next tick.
- `writeData(self:lairKey(buildingID, "forceAtk"), 0)` and `noForce` 1.
- `AiAgent(pBoss):clearCombatState(true)` — the binding takes a `clearDefenders` boolean
  (`LuaAiAgent.cpp:103`); live calls `stopCombat(self)` at `:201`.
- `AiAgent(pBoss):setOblivious()` — so he does not immediately re-acquire the player and
  stand there swinging at someone he cannot hurt.
- `SceneObject(pBoss):playEffect("clienteffect/pl_force_healing.cef", "")` — live's
  effect verbatim (`:202-203`).
- Heal him back to full, all three pools. Live adds a flat 150000
  (`addToHealth(self, 150000)`); here that is a full restore, since the pool is 44000-54000
  and a flat number tuned to a 155000 boss is meaningless against it. Use the same
  loop `useCrystal` already uses — pools `{ 0, 3, 6 }`, `healDamage(missing, pool)` — and
  say in the comment that it stands in for live's flat 150000.
- Re-lock: `TangibleObject(pBoss):setOptionBit(INVULNERABLE)`.
- `spatialChat(pBoss, self.lair.lines.bossCannotDefeat)` — he is not beaten and says so.
- Advance the ladder at +2 s, which is live's delay (`:84`):

```lua
	createEvent(2 * 1000, "kenobiSpineScreenPlay", "lairBeat", pPlayer, buildingID .. ":" .. readData(self:lairKey(buildingID, "session")))
```

---

## 8. The force-power attack cycle

### `lairForceWindup(pPlayer, args)`

`obiwan_lair_boss.java:311-355`. Preamble as G(b2a) §8, then
`if (not self:liveFight(buildingID, args)) then return end`.

- If `noForce` is 1: clear it and **return without re-arming**. Live does exactly this
  (`:314-318`) — the flag is consumed by whichever of windup/execute reaches it first.
- If `forceAtk` is already non-zero, return — one queued attack at a time (`:325-329`).
- Roll and store the row: `local row = getRandomNumber(1, #self.lair.forceAttacks)`,
  `writeData(self:lairKey(buildingID, "forceAtk"), row)`.
- The tell — anim and effect rolled **independently** of the row:

```lua
	CreatureObject(pBoss):doAnimation(self.lair.forceWindupAnims[getRandomNumber(1, #self.lair.forceWindupAnims)])
	SceneObject(pBoss):playEffect(self.lair.forceWindupEffects[getRandomNumber(1, #self.lair.forceWindupEffects)], "")
```

- Obi-Wan warns, immediately — `obiwanWarnsOfSpecialAttack`,
  `obiwan_event_manager.java:281-300`, messaged at delay 0 (`obiwan_lair_boss.java:353`).
  Face the player first, then `spatialChat(pObiwan, self.lair.lines.obiLookoutSpecial)`.
- `createEvent(self.lair.forceExecuteDelay * 1000, "kenobiSpineScreenPlay", "lairForceExecute", pPlayer, args)`.

### `lairForceExecute(pPlayer, args)`

`obiwan_lair_boss.java:356-438`. Same preamble and `liveFight` check.

- If `noForce` is 1 — the player interrupted him. Clear it and re-arm the windup at
  `rand(forceWindupMin, forceWindupMax)`. Live at `:359-368`. Nothing else happens; the
  attack is lost. Comment it: **this is what the player earns by breaking the windup.**
- If `forceAtk` is 0, return.
- Otherwise read the row, clear `forceAtk`, and land it:

```lua
		local attack = self.lair.forceAttacks[row]
		local damage = getRandomNumber(attack.minDamage, attack.maxDamage)

		--[[ Live builds a hit_result by hand and calls doDamage
		     (obiwan_lair_boss.java:421-430) so the attack bypasses the combat roll --
		     it is scripted, it always lands. inflictDamage is the equivalent here:
		     inflictDamage(pAttacker, damageType, damage, destroy), attacker read as
		     lightuserdata (LuaCreatureObject.cpp:46). damageType 0 is HEALTH
		     (DirectorManager.cpp:700); destroy 0, because the death path is the
		     player's normal one, not this call's. Same shape as
		     deathWatchBunker.lua:1427. ]]
		CreatureObject(pPlayer):inflictDamage(pBoss, 0, damage, 0)
		CreatureObject(pPlayer):playEffect(attack.effect, "")
		CreatureObject(pBoss):doAnimation(attack.animation)
```

- Re-arm the windup at `rand(forceWindupMin, forceWindupMax)` (`:433`).

---

## 9. Banter

### `lairTaunt(pPlayer, args)`

`randomTaunter`, `obiwan_lair_boss.java:236-276`. Preamble, `liveFight` check.

- 50/50 laugh: live rolls `rand(1,10)` and plays the laugh on `> 5` (`:258-262`).
  `CreatureObject(pPlayer):playEffect("clienteffect/mustafar/som_dark_jedi_laugh.cef", "")`.
- `spatialChat(pBoss, self.lair.lines.bossTaunts[getRandomNumber(1, #self.lair.lines.bossTaunts)])`.
- Re-arm itself at `rand(tauntMin, tauntMax)`.

### `lairPraise(pPlayer, args)`

`randomPraiser`, `:277-310`. Same shape, Obi-Wan speaking, from `obiSayings`, re-arming
at `rand(praiseMin, praiseMax)`. Bail quietly if `pObiwan` is nil.

Note in a comment that live gates the praiser on the boss's `ignoreTaunt` flag (`:281`)
— i.e. Obi-Wan goes quiet whenever the boss does. The `liveFight` check covers the same
ground here, because both chains die the moment `fight` goes to 0.

---

## 10. Beat 5 — extending `bossKilled`

`bossKilled` (`kenobi_spine.lua:1839`) already does the quest side correctly: stage,
XP, drop the kill observer, message, sting. **Do not change any of that.** Add the
event side after it, and keep the existing comment block above the function.

`obiwan_event_manager.java:214-229` and `obiSaysDestroyCrystal` `:491-503`.

- Find the copy: `local buildingID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "lairCopy")) or 0`.
- If it is non-zero:
  - **Shut the ladder down.** Bump `session` — that one write kills every pending timer
    in the run, including any left over from the fight the player just won. Then set
    `fight` 0, `forceAtk` 0, `phase` 6.
  - Live also strips `readyToUseCrystal` at beat 5 (`:217-220`) — the crystal was a
    lifeline for the fight and the fight is over. Write `crystalReady` back to `"0"`.
  - Obi-Wan congratulates at +10 s. Live's delay is the one `OnIncapacitated` sends
    (`obiwan_lair_boss.java:97`), and it is deliberately long — the boss's death
    animation plays out first.

```lua
		createEvent(10 * 1000, "kenobiSpineScreenPlay", "lairObiCongratulates", pPlayer, buildingID .. ":" .. readData(self:lairKey(buildingID, "session")))
```

Note in the comment that live's `buff.removeAllBuffs(player)` at `:222` is a no-op here,
for the reason the finale header block already records — this tree has no Lua buff API.

### `lairObiCongratulates(pPlayer, args)`

Preamble. Face the player, `spatialChat(pObiwan, self.lair.lines.obiWonCongrats)`, then
`createEvent(3 * 1000, ..., "lairObiDestroyCrystal", ...)` — `:228`.

Do **not** use the shared preamble's `pBoss == nil or isDead` bail here or in the two
handlers below. The boss is dead; that is the point. Write these three with their own
short preamble: `liveLair`, then the Obi-Wan pointer, and nothing about the boss.

### `lairObiDestroyCrystal(pPlayer, args)`

`obiSaysDestroyCrystal`, `:491-503`.

- Face, `spatialChat(pObiwan, self.lair.lines.obiDestroyCrystal)`.
- `CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_obi_wan_quest.snd")` —
  live's `playMusic` at `:500`; `playMusicMessage` is the binding
  (`LuaCreatureObject.cpp:36`), and `bossKilled` already uses it.
- Arm the nag at `rand(nagMin, nagMax)` (`:501`).

### `lairObiNag(pPlayer, args)`

`obiRepeatsDestroyCrystal`, `:504-531`. Live repeats until the player deals with the
crystal.

- Stop if the player has already dealt with it:
  `readScreenPlayData(pPlayer, self.screenplayName, "crystal") ~= 0` — that key is 1 for
  destroyed and 2 for taken (`destroyCrystal`, `takeCrystal_finale`). Live's equivalent
  is the `dealWithCrystal` scriptvar check at `:516-519`.
- Stop if the player has left the building — live checks
  `mustafar.stillWithinDungeonCheck` (`:520`). Here: compare
  `SceneObject(pPlayer):getRootParent()` against the copy. If it does not match, return
  without re-arming.
- Otherwise say `obiDestroyCrystalShort` and re-arm at `rand(nagMin, nagMax)`.

---

## 11. `clearLair` additions

G(b2a)'s `clearLair` zeroes `boss`, `minions`, `phase`, `player`, `fight`. Add the keys
this round introduced: `fightNum`, `forceAtk`, `noForce`, `dmgObs`.

`dmgObs` matters most — it is the "have I already attached the damage observer" flag,
and it is attached to the boss object, which `clearLair` destroys. Leaving it set would
mean the next run's boss never gets one and fight one would never end. Say that in the
comment.

---

## 12. Where the new code goes

After the G(b2a) block and before the STATE doc block, in this order: `liveFight`,
`lairStartFight` (replacing the stub, in place), `notifyLairBossDamaged`,
`lairEndFightOne`, `lairForceWindup`, `lairForceExecute`, `lairTaunt`, `lairPraise`.

The three ending handlers — `lairObiCongratulates`, `lairObiDestroyCrystal`,
`lairObiNag` — go directly **after** `bossKilled`, so the ending reads top to bottom in
one place.

Extend the `WHERE EVERYTHING IS` header block with a sentence naming this round's
section and `obiwan_lair_boss.java` as its source. Do not rewrite what is there.

---

## 13. Done means

- `luac5.3 -p` passes on `kenobi_spine.lua`.
- No file other than `kenobi_spine.lua` is modified.
- Every `createEvent` carries the session; every fight-chain handler also checks the
  fight token.
- Every observer handler returns a number, and `notifyLairBossDamaged` returns 0 in the
  normal path so it survives into fight two.
- All four `forceAttacks` rows appear with their exact damage bands and effect files,
  including `dark_jedi_rock_attack_10.cef` — the fourth row is `_10`, not `_4`.
- The §2 ruling is written into the file above `notifyLairBossDamaged`, in full.
- `bossKilled`'s existing quest logic is byte-for-byte unchanged; the event teardown is
  added after it.

Do not commit. Do not run git. Do not push.
