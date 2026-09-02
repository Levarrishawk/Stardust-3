--[[
Volcano Battlefield  --  SOE's mustafar_volcano instance

WHAT THIS IS

Live ran this as an 8-player outdoor instance (instance_datatable.tab:13):
max_players 8, time_limit 3600 s, daily lockout, key mustafar_volcano.
Six staged encounters on a volcanic plateau culminate in HK-47; players clear
them in order one → two → three → four → five → hk_final.

Core3 has no instance system for outdoor areas, so this is one off-map arena
on mustafar, one session at a time, entered and left by teleport -- the same
model mustafar_instances.lua uses for the six SOE dungeon pools, and the same
model valley_battlefield.lua uses for mustafar_droid_army.

This file covers the full arena: geometry, entry/exit/reset, the six-volume
activation chain, events one through five, and the HK-47 finale. Screenplays
and story-arc wiring live in ROUND-F2B-SPEC-2 §5.

COORDINATE TRANSFORM

Live's controller sits at 647.941 74.7399 448.941. The transform onto this zone:

	repoX = liveX - 939.941
	repoY = liveZ - 2128.941

Live's loc_y (height) is dropped on every row. The whole live buildout has
0.62 m of relief (LIVE-VOLCANO §6.1) and the repo band is dead flat at -5.00 m,
so every spawn ground-places with getWorldFloor(x, y, "mustafar"). Live
setYaw(deg) maps straight onto spawnMobile's heading argument (degrees).

Live offsets are "X:Z" strings added to the spawner's own location. Because the
transform is a pure translation on both axes, an offset (dx, dz) becomes
(dx, dz) added to (x, y) here. No sign flips. No axis swap in the offsets.

PLACEMENT -- ANCHOR SUPERSEDES PLACEMENT.md

scratch/PLACEMENT.md line 12 assumed the anchor was the box centre and wrote
VOLCANO ARENA anchor (x = -400, y = -1600) box 380 x 420 m. The box size is
right -- the arena's true span is 379.97 m by 419.47 m -- but live's arena is
not centred on its controller, so anchoring at (-400, -1600) would have thrown
the footprint to x -698..-318, y -1730..-1310, which is 108 m west and 80 m
north of the box PLACEMENT.md actually measured with its 81-sample fine grid.
The anchor moved to (-292, -1680) so the footprint lands inside the measured
box instead:

	measured box   x -590.000 .. -210.000   y -1810.000 .. -1390.000
	true footprint x -589.909 .. -209.941   y -1809.941 .. -1390.469

PLACEMENT.md's anchor number is superseded; the box itself is not amended.

The east rim of HK's 95 m trigger volume lands at x = -209.941, six centimetres
outside the nominal box. Do not fudge the anchor to hide it: the box was
sampled on a 50 m grid, and the whole southern band measures -5.00 m flat
across x -1400..1400, so six centimetres is inside the measurement's own
granularity.

Both arenas and the exit were re-checked against every one of the 126 boundary
active areas in mustafar_boundaries.lua. All clear; nearest margins: arena
anchor 736 m, exit 218 m. The volcano needs no boundary pocket -- unlike the
valley, whose exit sat inside Se1.

SCOPED OMISSIONS / SUBSTITUTIONS

- Daily lockout (instance.java:659-674, reset 06:00). The valley did not port
  its lockout either; there is no instance system to hang it on.

- The min-player check that closes the instance after three failed passes
  (instance_manager.java:180-245).

- volcano_player.java's 20-second-delayed volcano_arena_pilot signal on entry.
  In this port the pilot conversation is what advances the quest, before entry
  -- see part two.

- Buffs -- there is no Lua buff API at all. addBuff does not appear anywhere in
  the LuaCreatureObject registration array (LuaCreatureObject.cpp:40-160).
  Every buff mechanic is therefore omitted, with no stand-in. This is the same
  ruling valley_battlefield.lua made for its three morale buffs, and its
  wording is the precedent: there is no honest stand-in to write; do not invent
  one. What goes:
    event one's volc_boss_one_1 … volc_boss_one_8 escalation, one per dead
      guard (event_one_boss.java:15-25, :101-124)
    event five's three debuff pools -- ham bio_etheric_shock/torpor/vacuity,
      debuff lethargy/wavering/toxic_dissolution, skill
      obfuscation/confusion/corrosion (event_five_boss.java:312-342)
    HK's two smaller pools (hk_final_boss.java:336-346)
    distraction and enfeeble on both event five and HK
    low_morale on a squad member whose leader died (hk_squad_member.java)
  The damage AEs those bursts are bundled with DO port. Only the buff half
  is lost.

- Buff strip. event_five_guard and hk_gk_septipod strip player buffs via
  queueCommand(self, (1679682244), ...). There is no queueCommand binding and
  no buff API to strip with. Omitted.

- Hate lists. No setHate, clearHateList or removeHateTarget binding exists;
  LuaAiAgent.cpp:30-136 has setDefender, addDefender, setOblivious,
  clearCombatState and nothing else in that family. So:
    live switchTarget → pick a random player in range other than the current
      defender and AiAgent(pMob):setDefender(pOther). The observable effect
      (the boss changes victim on a timer) survives; the hate arithmetic does
      not.
    live clearHateList + stopCombat → AiAgent(pMob):clearCombatState() then
      AiAgent(pMob):setOblivious().
  Both are labeled as substitutions where they appear.

- Corpses. There is no POSTURE_DEAD. DirectorManager.cpp:642-647 registers
  exactly UPRIGHT, PRONE, POSTURESITTING, KNOCKEDDOWN, CROUCHED, LYINGDOWN.
  A corpse here is: spawnMobile the template with respawn 0, then
  CreatureObject(pCorpse):setPosture(KNOCKEDDOWN),
  TangibleObject(pCorpse):setOptionBit(INVULNERABLE), and
  AiAgent(pCorpse):setAITemplate("idle") so it never acquires. Precedent for
  the knocked-down-prop idiom: village_jedi_manager_township.lua:463.
  (setAITemplate ignores its string argument in LuaAiAgent.cpp:174-178; the
  call shape matches the spec so a later binding can honour "idle".)

- Invulnerability. Live setInvulnerable(true/false) →
  TangibleObject(pMob):setOptionBit(INVULNERABLE) /
  clearOptionBit(INVULNERABLE). INVULNERABLE is registered at
  DirectorManager.cpp:737; setOptionBit/clearOptionBit at
  LuaTangibleObject.cpp:49-50.

- Particle and client effects. Live names a dozen .prt / .cef assets
  (trial.java:174-199). SceneObject:playEffect(file, aux) exists
  (LuaSceneObject.cpp:97), but none of those asset paths can be verified
  against this tree's client build, and the sibling valley_battlefield.lua
  uses no playEffect at all. Omit the particle calls. Live's exact effect
  strings, kept as data:

    trial.java:174 PRT_CYM_DISEASE       = "clienteffect/mus_cym_disease.cef"
    trial.java:175 PRT_CYM_POISON        = "clienteffect/mus_cym_poison.cef"
    trial.java:176 PRT_DROID_HEAL        = "clienteffect/mus_droid_heal.cef"
    trial.java:177 PRT_DROID_REVIVE      = "clienteffect/mus_droid_revive.cef"
    trial.java:180 PRT_KUBAZA_EXPLODE    = "clienteffect/exp_ap_landmine.cef"
    trial.java:181 PRT_KUBAZA_WARNING    = "clienteffect/mus_kubaza_warning.cef"
    trial.java:182 PRT_INVULN_SHIELD     = "appearance/pt_flash_shield.prt"
    trial.java:190 PRT_VOLCANO_WAVE_PRE  = "appearance/pt_blast_wave_build_up.prt"
    trial.java:191 PRT_VOLCANO_WAVE_EXE  = "appearance/pt_blast_wave.prt"
    trial.java:192 PRT_VOLCANO_AIR_PRE   = "appearance/pt_rocket_barrage_wind_up.prt"
    trial.java:193 PRT_VOLCANO_AIR_EXE   = "appearance/pt_rocket_barrage.prt"
    trial.java:194 PRT_VOLCANO_CONE_PRE  = "appearance/pt_large_beam_warm_up.prt"
    trial.java:195 PRT_VOLCANO_CONE_EXE  = "appearance/pt_large_beam.prt"
    trial.java:196 PRT_VOLCANO_YT_LANDING = "appearance/must_smoke_plume01.prt"

  Music files DO play -- the valley plays them -- so keep broadcastMusic.

- String ids. Every live message is a string_id in
  mustafar/volcano_battlefield.stf. That stf is not in this tree
  (bin/string/en/mustafar/ does not exist). Use plain English
  sendSystemMessage strings the way the valley does, and quote the live stf
  key in a comment beside each one.

- HP. Do not call setMaxHAM or setHAM anywhere in this file. Live sets
  per-mob HP through trial.setHp (545000 for the event-one boss, 950485 for
  the cyborg prototype, and so on). Round F2(a), commit 34dccdf96c,
  deliberately placed all twenty volcano rows on the retune ladder from
  commit 189d4f1622 instead -- the ladder replaced raw HP, which is why
  live's setHp values have nowhere to land, and the volcano's rows were put
  one rung above the valley's precisely to keep live's difficulty gap.
  Writing live's raw HP back in here would undo that commit. The tier ladder
  IS the tuning. Live HP table, reference only (trial.java:213-231):

    HP_VOLCANO_ONE_GUARD        = 65000     HP_VOLCANO_ONE_BOSS        = 545000
    HP_VOLCANO_TWO_GUARD        = 95250     HP_VOLCANO_TWO_BOSS        = 655280
    HP_VOLCANO_THREE_GUARD      = 33500     HP_VOLCANO_THREE_RISEN     = 60250
    HP_VOLCANO_THREE_BOSS       = 655250    HP_VOLCANO_FOUR_GUARD      = 3000
    HP_VOLCANO_FOUR_BOSS        = 950485    HP_VOLCANO_FIVE_GUARD      = 50000
    HP_VOLCANO_FIVE_MIDGUARD    = 100000    HP_VOLCANO_FIVE_BOSS       = 220000
    HP_VOLCANO_HK_SOLDIER       = 14000     HP_VOLCANO_HK_SQUAD_LEADER = 20000
    HP_VOLCANO_HK_RISEN_GUARD   = 22525     HP_VOLCANO_HK_BEETLE       = 9000
    HP_VOLCANO_HK_SEPTIPOD      = 75250     HP_VOLCANO_HK_CWW          = 55855
    HP_VOLCANO_HK47             = 545852

- Event three bonus loot (event_three_boss.java:23-40): live rolls 12% for
  item_tow_schematic_vehicle_02_02, commented "Lava Transport Skiff". That
  live static-item name does not exist in this tree and is not an object
  template. Substituted
  object/tangible/deed/vehicle_deed/landspeeder_lava_skiff_deed.iff --
  registered at object/custom_content/tangible/deed/vehicle_deed/
  landspeeder_lava_skiff_deed.lua:20, and it generates
  object/mobile/vehicle/landspeeder_lava_skiff.iff, which is the actual Lava
  Transport Skiff. Keep live's 12% roll. Precedent for substituting an
  unresolvable live lootName with the nearest real object of the same family:
  hidden_treasure.lua's THE REWARD block.

- Event four doDiseaseAE is defined in live and never scheduled
  (event_four_boss.java; LIVE-VOLCANO §2.4). Not ported. A reader who diffs
  against the live source must not think it was missed.

- Event four beetles are setMovementRun in live (event_four_guard.java). No
  Lua binding for that was found; omitted.

- Event five health ladder has no damage observer here. Ported as a 3 s poll
  of getHAM(0)/getMaxHAM(0) that fires every crossed rung, not just the newest
  -- a big hit can skip two at once, and live's chained if does the same
  (event_five_boss.java:75-106).

- Event five omitted buffs (named, no stand-in, §5A): ham pool
  bio_etheric_shock/torpor/vacuity, debuff lethargy/wavering/toxic_dissolution,
  skill obfuscation/confusion/corrosion (radius 400, recast 30), distraction
  (recast 24), and enfeeble on switchTarget. Trio guards' buff strip every 16 s
  omitted (§5B).

- HK chooseAEType returns {"wave","wave"} so only the wave is reachable;
  doAirfallBurst is dead code (hk_final_boss.java:405-413). Wave only.

- HK DISEASE_RECAST 120 and FORCE_DRAIN_RECAST 34 are both defined and never
  scheduled in live. Not ported. DEBUFF_RECAST 45 and DISTRACTION_RECAST 24
  are buffs (§5A) and omitted.

- HK 15% bonus loot on his corpse is
  object/building/player/player_mustafar_house_lg.iff -- a building, and this
  tree has no deed for it, so there is nothing a player could receive.
  Omitted, with no substitution. Contrast event three's loot, which was
  substituted because a real deed of the same family exists there.

- YT-2400 landing / exit ship. Live's exit is a conversation with
  som_volcano_autopilot on the bridge of a grounded YT that only exists after
  HK dies (volcano_event_manager.java:258-276).
  object/creature/npc/theme_park/must_yt2400.iff does not exist in this tree.
  object/building/mustafar/structures/must_grounded_yt2400.iff would need
  spawnBuilding → StructureManager::placeStructure (DirectorManager.cpp:2973-
  3009) -- a player-owned structure with a maintenance pool; wrong lifecycle
  for a scripted prop. Autopilot conversation is mustafar/volcano_battlefield.stf,
  not in this tree (§5G). On victory, spawn som_volcano_autopilot on the ground
  at the live landing site (-260.400, -1677.800) with a runtime radial
  "Leave the Volcano". Smoke plume, takeoff, and yt_controller OnInitialize
  self-destruct are consequences of the ship that is not there; omitted.
--]]

VolcanoBattlefield = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "VolcanoBattlefield",

	anchorX = -292,
	anchorY = -1680,

	-- live buildout waypoint zoneIn 389.646, 648.353 → transform
	entryX = -550.295,
	entryY = -1480.588,

	-- live instance_datatable.tab:13 exit_one -2397,210,1850,mustafar -- a
	-- REAL Mustafar world coordinate, kept verbatim, exactly as the valley
	-- kept its own exit_one.
	exitX = -2397,
	exitY = 1850,

	maxPlayers = 8,        -- live max_players
	entryRange = 60,       -- same as the valley
	timeLimit = 3600,      -- live time_limit
	cleanOut = 300,        -- trial.java:1524-1537 setDungeonCleanOutTimer
	-- winPoll is this file's own re-arm, not live's. Live drives progression
	-- off message passing; this port replaces that with polled createEvent
	-- re-arms.
	winPoll = 30,
	-- UPPERCASE, and it has to be. DirectorManager.cpp:863-869 walks BadgeList
	-- and registers each badge as a Lua global under badge->getKey().toUpperCase(),
	-- so the _G[self.victoryBadge] guard below can only ever resolve an uppercase
	-- key. This was written lowercase, which made the guard a permanent no-op --
	-- the badge would have been silently skipped even on a server whose TREs do
	-- carry it. Corrected in round G(b1).
	victoryBadge = "BDG_MUST_VICTORY_VOLCANO",
	victoryMusic = "sound/mus_mustafar_quest_success.snd",
	hkIntroMusic = "sound/mus_mustafar_hk47_intro.snd", -- trial.java:199 MUS_VOLCANO_HK_INTRO

	-- YT landing site (part two exit NPC). Live controller + (31.6, 2.2).
	ytLandingX = -260.400,
	ytLandingY = -1677.800,

	-- Event centres: absolute repo (x, y), volume radius. Order is the live
	-- activation chain (volcano_event_manager.java:174-198).
	events = {
		[1] = { x = -544.909, y = -1611.496, radius = 45 }, -- Taskmaster
		[2] = { x = -487.411, y = -1722.954, radius = 45 }, -- AK Prime
		[3] = { x = -403.277, y = -1572.559, radius = 45 }, -- Forward Commander
		[4] = { x = -409.949, y = -1435.469, radius = 45 }, -- Cyborg Prototype
		[5] = { x = -306.887, y = -1466.889, radius = 45 }, -- Oppressor Septipod
		[6] = { x = -304.941, y = -1714.941, radius = 95 }, -- HK-47 finale
	},

	-- event_one.java:75-111
	eventOneGuardOffsets = {
		{ 3, 2 }, { 6, 4 }, { 9, 7 }, { 12, 10 },
		{ -3, 2 }, { -6, 4 }, { -9, 7 }, { -12, 10 },
	},

	-- event_two.java:70-102
	eventTwoGuardOffsets = {
		{ -6, -6 }, { 6, 6 }, { -6, 6 }, { 6, -6 },
	},

	-- event_three.java:74-118 -- three ranks of five
	eventThreeGuardOffsets = {
		{ -6, -10 }, { -3, -10 }, { 0, -10 }, { 3, -10 }, { 6, -10 },
		{ -6, -8 }, { -3, -8 }, { 0, -8 }, { 3, -8 }, { 6, -8 },
		{ -6, -6 }, { -3, -6 }, { 0, -6 }, { 3, -6 }, { 6, -6 },
	},

	-- event_three.java:202-241 -- corpse slots, consumed in order by corpseIdx
	eventThreeCorpseOffsets = {
		{ 7, 4 }, { 2, -6 }, { 0, -11 }, { -5, 1 }, { 14, -13 },
		{ -18, -32 }, { -18, -23 }, { 6, -2 }, { 16, -8 }, { 18, -14 },
		{ -18, 4 }, { 5, -4 }, { 11, 4 }, { -3, -12 }, { 7, -29 },
	},

	-- live uses event_5_spawn_point marker objects (event_four.java:51-86); this
	-- port keeps the same four offsets as data because there is nothing else
	-- the markers were for.
	eventFourBeetleOffsets = {
		{ 16, -24 }, { -29, -16 }, { -1, 11 }, { 29, -6 },
	},

	-- event_five.java:51-101 -- first three → trioAddSpawn, rest → midguardSpawn
	eventFiveTrioSpawns = {
		{ -19, 20 }, { 24, 23 }, { -4, -32 },
	},
	eventFiveMidguardSpawns = {
		{ -6, -22 }, { -12, -6 }, { -12, 6 }, { 13, 15 }, { 17, 0 }, { 18, 9 },
	},

	-- hk_final.java:56-110 -- ten markers split three ways; same reasoning as
	-- event four (no marker objects, offsets as data).
	hkBeetleSpawns = {
		{ 55, 34 }, { 9, 48 }, { -18, 18 }, { 23, -30 },
	},
	hkWalkerSpawns = {
		{ 15, -1 }, { -18, 3 },
	},
	hkSeptipodSpawns = {
		{ -2, 46 }, { 27, 33 }, { 39, 4 }, { -21, 28 },
	},

	-- hk_final.java:111-137 leaders; each then spawns six members relative to self
	hkLeaderOffsets = {
		{ -1, 32 }, { 32, 25 },
	},
	hkMemberRelativeOffsets = {
		{ -3, 0 }, { -5, 0 }, { -7, 0 }, { -3, 3 }, { -5, 3 }, { -7, 3 },
	},

	-- hk_final.java:163-200 -- 14 fixed corpse slots (ammunition for raiseGuard)
	hkCorpseOffsets = {
		{ 7, 26 }, { -10, 34 }, { 0, 18 }, { -5, 46 }, { 10, 35 }, { 26, 32 }, { -18, 23 },
		{ 6, 39 }, { 24, 38 }, { 18, 27 }, { 31, 19 }, { 5, 26 }, { 11, 21 }, { -3, 31 },
	},

	tracked = {},
}

registerScreenPlay("VolcanoBattlefield", true)

--------------------------------------------------------------------------------
-- Boot
--------------------------------------------------------------------------------

function VolcanoBattlefield:start()
	if (not isZoneEnabled("mustafar")) then
		return
	end

	-- A crash or restart mid-session leaves active = 1 forever without this.
	self:clearSessionKeys()
	self.tracked = {}
end

function VolcanoBattlefield:clearSessionKeys()
	deleteData("volcanoBattlefield:active")
	deleteData("volcanoBattlefield:session")
	deleteData("volcanoBattlefield:owner")
	deleteData("volcanoBattlefield:stage")
	deleteData("volcanoBattlefield:startedAt")
	deleteData("volcanoBattlefield:eventIdx")
	deleteData("volcanoBattlefield:won")
end

function VolcanoBattlefield:currentSession()
	return readData("volcanoBattlefield:session")
end

function VolcanoBattlefield:isSessionCurrent(session)
	return readData("volcanoBattlefield:active") == 1 and self:currentSession() == tonumber(session)
end

function VolcanoBattlefield:getTrack(session)
	session = tonumber(session)

	if (self.tracked[session] == nil) then
		self.tracked[session] = {
			army = {},
			guards = {},
			corpses = {},
			props = {},
			players = {},
			areas = {},
			bossID = 0,
			deadBoss = 0,
			deadGuards = 0,
			corpseIdx = 0,
			-- Per-event bookkeeping beyond the prescribed shape. Valley also
			-- extends getTrack with commanderID / paths / rezzable / demo.
			eventBoss = {},
			eventGuards = {},
			eventActive = {},
			eventCurrentAttacker = 0,
			eventGuardIndex = 0,
			commanders = {},
			originalBossID = 0,
			-- Event five midguards are tracked apart from track.guards so the
			-- gate can count them (LIVE-VOLCANO §3.2).
			midguards = {},
			midguardDead = {},
			-- Event five / HK health-ladder flags. Cleared on wipe reset.
			spawned80 = false,
			spawned60 = false,
			spawned50 = false,
			spawned40 = false,
			spawned20 = false,
			midguardScheduled = false,
			midguardResumed = false,
			-- HK squad wall (14) and risen sustainers from corpse rez.
			squad = {},
			squadDead = {},
			risenGuards = {},
			hkFightActive = false,
			hkActivated = false,
		}
	end

	return self.tracked[session]
end

--------------------------------------------------------------------------------
-- Coordinate helpers
--------------------------------------------------------------------------------

function VolcanoBattlefield:worldXY(locx, locz)
	return self.anchorX + locx, self.anchorY + locz
end

function VolcanoBattlefield:spawnInvulnerableMobile(template, x, y, yaw)
	local z = getWorldFloor(x, y, "mustafar")
	local pMob = spawnMobile("mustafar", template, 0, x, z, y, yaw, 0)

	if (pMob == nil) then
		return nil
	end

	TangibleObject(pMob):setOptionBit(INVULNERABLE)
	return pMob
end

function VolcanoBattlefield:fullHeal(pMob)
	if (pMob == nil or CreatureObject(pMob):isDead()) then
		return
	end

	-- §5H: no setHAM / setMaxHAM. healDamage restores missing HEALTH.
	local missing = CreatureObject(pMob):getMaxHAM(0) - CreatureObject(pMob):getHAM(0)

	if (missing > 0) then
		CreatureObject(pMob):healDamage(missing, 0)
	end
end

function VolcanoBattlefield:placeCorpse(template, x, y)
	-- §5D: no POSTURE_DEAD. Knocked-down + invulnerable + idle template.
	local z = getWorldFloor(x, y, "mustafar")
	local pCorpse = spawnMobile("mustafar", template, 0, x, z, y, 0, 0)

	if (pCorpse == nil) then
		return nil
	end

	CreatureObject(pCorpse):setPosture(KNOCKEDDOWN)
	TangibleObject(pCorpse):setOptionBit(INVULNERABLE)
	AiAgent(pCorpse):setAITemplate("idle")
	return pCorpse
end

function VolcanoBattlefield:nearestPlayerNear(pFrom, radius)
	if (pFrom == nil) then
		return nil
	end

	local players = SceneObject(pFrom):getPlayersInRange(radius)

	if (players == nil or #players == 0) then
		return nil
	end

	local bx = SceneObject(pFrom):getWorldPositionX()
	local by = SceneObject(pFrom):getWorldPositionY()
	local best = nil
	local bestDist = radius + 1

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
			local dx = SceneObject(pPlayer):getWorldPositionX() - bx
			local dy = SceneObject(pPlayer):getWorldPositionY() - by
			local dist = math.sqrt(dx * dx + dy * dy)

			if (dist < bestDist) then
				bestDist = dist
				best = pPlayer
			end
		end
	end

	return best
end

function VolcanoBattlefield:countPlayersInVolume(cx, cy, radius)
	local count = 0

	self:forEachPlayerInside(function(pPlayer)
		local dx = SceneObject(pPlayer):getWorldPositionX() - cx
		local dy = SceneObject(pPlayer):getWorldPositionY() - cy

		if ((dx * dx + dy * dy) <= (radius * radius)) then
			count = count + 1
		end
	end)

	return count
end

-- Angle between vectors (ax,ay) and (bx,by) in degrees.
-- Live trial.getValidTargetsInCone(self, target, 96, 30) keeps candidates whose
-- bearing from the boss is within 30° of the boss→defender axis (15° either
-- side). cosθ = (A·B) / (|A||B|); in cone when θ ≤ 15°.
function VolcanoBattlefield:angleBetweenDeg(ax, ay, bx, by)
	local dot = ax * bx + ay * by
	local magA = math.sqrt(ax * ax + ay * ay)
	local magB = math.sqrt(bx * bx + by * by)

	if (magA < 0.001 or magB < 0.001) then
		return 180
	end

	local c = dot / (magA * magB)

	if (c > 1) then
		c = 1
	elseif (c < -1) then
		c = -1
	end

	return math.deg(math.acos(c))
end

--------------------------------------------------------------------------------
-- Messaging / players inside
--------------------------------------------------------------------------------

function VolcanoBattlefield:forEachPlayerInside(callback)
	local session = self:currentSession()
	local track = self.tracked[session]

	if (track == nil) then
		return
	end

	for i = 1, #track.players do
		local playerID = track.players[i]
		local pPlayer = getSceneObject(playerID)

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and readData(playerID .. ":volcanoBattlefield") == 1) then
			callback(pPlayer)
		end
	end
end

function VolcanoBattlefield:broadcastMessage(text)
	self:forEachPlayerInside(function(pPlayer)
		CreatureObject(pPlayer):sendSystemMessage(text)
	end)
end

function VolcanoBattlefield:broadcastMusic(sound)
	self:forEachPlayerInside(function(pPlayer)
		CreatureObject(pPlayer):playMusicMessage(sound)
	end)
end

function VolcanoBattlefield:countPlayersInside()
	local count = 0

	self:forEachPlayerInside(function(pPlayer)
		count = count + 1
	end)

	return count
end

function VolcanoBattlefield:trackPlayer(session, pPlayer)
	local track = self:getTrack(session)
	local id = SceneObject(pPlayer):getObjectID()

	for i = 1, #track.players do
		if (track.players[i] == id) then
			return
		end
	end

	table.insert(track.players, id)
end

--------------------------------------------------------------------------------
-- Entry
--------------------------------------------------------------------------------

function VolcanoBattlefield:enter(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (storyArcChaptersScreenPlay == nil) then
		printLuaError("VolcanoBattlefield: story_arc_chapters.lua is not loaded; refusing entry")
		return
	end

	if (not storyArcChaptersScreenPlay:mayEnterVolcanoBattlefield(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:not_ready")
		return
	end

	if (readData("volcanoBattlefield:active") == 1) then
		local ownerID = readData("volcanoBattlefield:owner")
		local pOwner = getSceneObject(ownerID)

		if (pOwner == nil or not CreatureObject(pPlayer):isGroupedWith(pOwner)) then
			-- Say why: a silent return is indistinguishable from a broken radial.
			CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
			return
		end

		if (self:countPlayersInside() >= self.maxPlayers) then
			CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
			return
		end
	else
		local session = self:currentSession() + 1

		writeData("volcanoBattlefield:session", session)
		writeData("volcanoBattlefield:active", 1)
		writeData("volcanoBattlefield:owner", SceneObject(pPlayer):getObjectID())
		writeData("volcanoBattlefield:startedAt", os.time())
		writeData("volcanoBattlefield:stage", 0)
		writeData("volcanoBattlefield:eventIdx", 1)
		writeData("volcanoBattlefield:won", 0)

		self.tracked[session] = nil
		self:getTrack(session)

		self:spawnSessionActors(session)
		-- event_one.java:21-27 is the only event that arms itself at attach.
		self:spawnEventArea(session, 1)
		createEvent(self.timeLimit * 1000, "VolcanoBattlefield", "onTimeout", nil, tostring(session))
	end

	local party = self:buildParty(pPlayer)
	local session = self:currentSession()

	for i = 1, #party do
		self:teleportIn(party[i], session)
	end
end

function VolcanoBattlefield:buildParty(pPlayer)
	local party = { pPlayer }

	if (not CreatureObject(pPlayer):isGrouped()) then
		return party
	end

	local groupSize = CreatureObject(pPlayer):getGroupSize()
	local callerID = SceneObject(pPlayer):getObjectID()

	for i = 0, groupSize - 1, 1 do
		if (#party >= self.maxPlayers) then
			break
		end

		local pMember = CreatureObject(pPlayer):getGroupMember(i)

		if (pMember ~= nil and SceneObject(pMember):isPlayerCreature()) then
			local memberID = SceneObject(pMember):getObjectID()

			if (memberID ~= callerID and CreatureObject(pMember):isInRangeWithObject(pPlayer, self.entryRange)) then
				table.insert(party, pMember)
			end
		end
	end

	return party
end

function VolcanoBattlefield:teleportIn(pMember, session)
	if (pMember == nil) then
		return
	end

	if (CreatureObject(pMember):isRidingMount()) then
		CreatureObject(pMember):dismount()
	end

	local id = SceneObject(pMember):getObjectID()

	writeData(id .. ":volcanoBattlefield", 1)
	self:trackPlayer(session, pMember)

	local height = getWorldFloor(self.entryX, self.entryY, "mustafar")

	SceneObject(pMember):switchZone("mustafar", self.entryX, height, self.entryY, 0)
end

--------------------------------------------------------------------------------
-- Exit
--------------------------------------------------------------------------------

function VolcanoBattlefield:sendToExit(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- An eject is itself a switchZone, which can re-enter this path. The flag
	-- makes the second pass a no-op (mustafar_instances.lua:708-746).
	if (readData(playerID .. ":volcanoBattlefieldOut") == 1) then
		return
	end

	writeData(playerID .. ":volcanoBattlefieldOut", 1)

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local height = getWorldFloor(self.exitX, self.exitY, "mustafar")

	SceneObject(pPlayer):switchZone("mustafar", self.exitX, height, self.exitY, 0)

	deleteData(playerID .. ":volcanoBattlefield")
	createEvent(2000, "VolcanoBattlefield", "clearEjecting", pPlayer, "")

	if (self:countPlayersInside() == 0 and readData("volcanoBattlefield:active") == 1) then
		self:resetArena("last player left")
	end
end

function VolcanoBattlefield:clearEjecting(pPlayer)
	if (pPlayer ~= nil) then
		deleteData(SceneObject(pPlayer):getObjectID() .. ":volcanoBattlefieldOut")
	end
end

function VolcanoBattlefield:ejectEveryone()
	local toEject = {}

	self:forEachPlayerInside(function(pPlayer)
		table.insert(toEject, pPlayer)
	end)

	for i = 1, #toEject do
		self:sendToExit(toEject[i])
	end
end

--------------------------------------------------------------------------------
-- Activation chain  --  live volcano_event_manager.java:174-198
--------------------------------------------------------------------------------

function VolcanoBattlefield:spawnEventArea(session, idx)
	local ev = self.events[idx]

	if (ev == nil) then
		return
	end

	local z = getWorldFloor(ev.x, ev.y, "mustafar")
	-- Idiom: story_arc_chapters.lua:1250-1262 / mustafar_boundaries.lua
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", ev.x, z, ev.y, ev.radius, 0)

	if (pArea == nil) then
		printLuaError("VolcanoBattlefield: failed to spawn event area " .. tostring(idx))
		return
	end

	local areaID = SceneObject(pArea):getObjectID()
	local track = self:getTrack(session)

	table.insert(track.areas, areaID)
	writeStringData(areaID .. ":volcanoEvent", tostring(idx))
	writeData(areaID .. ":volcanoSession", session)
	createObserver(ENTEREDAREA, "VolcanoBattlefield", "notifyEnteredEventArea", pArea)
end

function VolcanoBattlefield:notifyEnteredEventArea(pArea, pCreature)
	if (pArea == nil or pCreature == nil or not SceneObject(pCreature):isPlayerCreature()) then
		return 0
	end

	local areaID = SceneObject(pArea):getObjectID()
	local session = readData(areaID .. ":volcanoSession")

	if (not self:isSessionCurrent(session)) then
		return 0
	end

	local idx = tonumber(readStringData(areaID .. ":volcanoEvent"))

	if (idx == nil) then
		return 0
	end

	self:activateEncounter(session, idx)
	return 0
end

function VolcanoBattlefield:activateEncounter(session, idx)
	local track = self:getTrack(session)

	if (track.eventActive[idx] == true) then
		return
	end

	track.eventActive[idx] = true

	if (idx == 1) then
		self:activateEventOne(session)
	elseif (idx == 2) then
		self:activateEventTwo(session)
	elseif (idx == 3) then
		self:activateEventThree(session)
	elseif (idx == 4) then
		self:activateEventFour(session)
	elseif (idx == 5) then
		self:activateEventFive(session)
	elseif (idx == 6) then
		self:activateEventHk(session)
	end
end

function VolcanoBattlefield:eventDefeated(session, idx)
	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local finished = readData("volcanoBattlefield:eventIdx")

	if (finished ~= idx) then
		return
	end

	-- Destroy the finished area so it cannot re-fire.
	local still = {}

	for i = 1, #track.areas do
		local areaID = track.areas[i]
		local stored = tonumber(readStringData(areaID .. ":volcanoEvent"))

		if (stored == idx) then
			local pArea = getSceneObject(areaID)

			if (pArea ~= nil) then
				SceneObject(pArea):destroyObjectFromWorld()
			end

			deleteStringData(areaID .. ":volcanoEvent")
			deleteData(areaID .. ":volcanoSession")
		else
			table.insert(still, areaID)
		end
	end

	track.areas = still

	local nextIdx = idx + 1

	writeData("volcanoBattlefield:eventIdx", nextIdx)

	if (nextIdx > 6) then
		self:winTrial(session)
		return
	end

	self:spawnEventArea(session, nextIdx)
end

--------------------------------------------------------------------------------
-- Session spawn  --  live spawnActors stage 1: all bosses/guards at t=0
--------------------------------------------------------------------------------

function VolcanoBattlefield:spawnSessionActors(session)
	self:spawnEventOneActors(session)
	self:spawnEventTwoActors(session)
	self:spawnEventThreeActors(session)
	self:spawnEventFourActors(session)
	self:spawnEventFiveActors(session)
	self:spawnEventHkActors(session)
end

function VolcanoBattlefield:trackArmy(session, pMob)
	if (pMob == nil) then
		return 0
	end

	local oid = SceneObject(pMob):getObjectID()
	local track = self:getTrack(session)

	table.insert(track.army, oid)
	return oid
end

function VolcanoBattlefield:trackGuard(session, eventIdx, pMob)
	if (pMob == nil) then
		return 0
	end

	local oid = SceneObject(pMob):getObjectID()
	local track = self:getTrack(session)

	table.insert(track.army, oid)
	table.insert(track.guards, oid)

	if (track.eventGuards[eventIdx] == nil) then
		track.eventGuards[eventIdx] = {}
	end

	table.insert(track.eventGuards[eventIdx], oid)
	return oid
end

--------------------------------------------------------------------------------
-- EVENT ONE  --  the Taskmaster (LIVE-VOLCANO §2.1)
--------------------------------------------------------------------------------

function VolcanoBattlefield:spawnEventOneActors(session)
	local ev = self.events[1]
	local track = self:getTrack(session)
	local pBoss = self:spawnInvulnerableMobile("som_volcano_one_taskmaster", ev.x, ev.y, 0)

	if (pBoss ~= nil) then
		local oid = self:trackArmy(session, pBoss)
		track.eventBoss[1] = oid
		track.bossID = oid
		createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventOneBossDied", pBoss)
	end

	track.eventGuards[1] = {}

	for i = 1, #self.eventOneGuardOffsets do
		local off = self.eventOneGuardOffsets[i]
		local pGuard = self:spawnInvulnerableMobile("som_volcano_one_sustainer", ev.x + off[1], ev.y + off[2], 0)

		if (pGuard ~= nil) then
			self:trackGuard(session, 1, pGuard)
		end
	end
end

function VolcanoBattlefield:activateEventOne(session)
	local track = self:getTrack(session)
	local bossID = track.eventBoss[1]

	if (bossID == nil or bossID == 0) then
		return
	end

	local pBoss = getSceneObject(bossID)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_one.java:46-52 activateEncounter: boss only. Guards stay
	-- invulnerable -- that is the whole mechanic. Escalation buffs omitted (§5A);
	-- PRT_DROID_HEAL / PRT_INVULN_SHIELD omitted (§5F).
	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)

	-- Timers are started once per session and idle while eventActive[1] is
	-- false (wipe reset). Re-entry must not stack a second createEvent chain.
	if (track.eventOneLoops ~= true) then
		track.eventOneLoops = true
		createEvent(5000, "VolcanoBattlefield", "eventOneGuardHeal", nil, tostring(session))
		createEvent(1000, "VolcanoBattlefield", "eventOneRotateAttacker", nil, tostring(session))
		createEvent(self.winPoll * 1000, "VolcanoBattlefield", "eventOneResetPoll", nil, tostring(session))
	end
end

function VolcanoBattlefield:eventOneGuardHeal(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	-- After a wipe reset, eventActive[1] is cleared so these loops idle until
	-- the volume re-arms. Keep re-arming so a re-entry does not need a fresh
	-- createEvent from activateEventOne.
	if (track.eventActive[1] ~= true) then
		createEvent(5000, "VolcanoBattlefield", "eventOneGuardHeal", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[1] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_one_guard.java healBoss every 5 s → event_one_boss.java:125-137
	-- performGuardHeal addToHealth(self, 1000) per living guard.
	local guards = track.eventGuards[1] or {}

	for i = 1, #guards do
		local pGuard = getSceneObject(guards[i])

		if (pGuard ~= nil and not CreatureObject(pGuard):isDead()) then
			CreatureObject(pBoss):healDamage(1000, 0)
		end
	end

	createEvent(5000, "VolcanoBattlefield", "eventOneGuardHeal", nil, tostring(session))
end

function VolcanoBattlefield:eventOneRotateAttacker(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[1] ~= true) then
		createEvent(10000, "VolcanoBattlefield", "eventOneRotateAttacker", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[1] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_one.java:112-128 / chooseNewAttacker :137-206
	local guards = track.eventGuards[1] or {}
	local candidates = {}

	for i = 1, #guards do
		local oid = guards[i]

		if (oid ~= track.eventCurrentAttacker) then
			local pGuard = getSceneObject(oid)

			if (pGuard ~= nil and not CreatureObject(pGuard):isDead()) then
				table.insert(candidates, oid)
			end
		end
	end

	if (#candidates == 0) then
		createEvent(10000, "VolcanoBattlefield", "eventOneRotateAttacker", nil, tostring(session))
		return
	end

	local pick = candidates[getRandomNumber(#candidates)]

	-- Outgoing attacker: INVULNERABLE back on.
	-- Substitution (§5C): live clearHateList + stopCombat → clearCombatState + setOblivious.
	if (track.eventCurrentAttacker ~= 0) then
		local pOut = getSceneObject(track.eventCurrentAttacker)

		if (pOut ~= nil and not CreatureObject(pOut):isDead()) then
			TangibleObject(pOut):setOptionBit(INVULNERABLE)
			AiAgent(pOut):clearCombatState(true)
			AiAgent(pOut):setOblivious()
		end
	end

	local pIn = getSceneObject(pick)

	if (pIn ~= nil and not CreatureObject(pIn):isDead()) then
		TangibleObject(pIn):clearOptionBit(INVULNERABLE)

		-- event_one_guard.java beginAttack: nearest player within radius 80.
		local pTarget = self:nearestPlayerNear(pIn, 80)

		if (pTarget ~= nil) then
			AiAgent(pIn):setDefender(pTarget)
		end

		track.eventCurrentAttacker = pick
	end

	createEvent(10000, "VolcanoBattlefield", "eventOneRotateAttacker", nil, tostring(session))
end

function VolcanoBattlefield:eventOneResetPoll(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local bossID = track.eventBoss[1] or 0
	local pBoss = getSceneObject(bossID)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local ev = self.events[1]

	-- Live OnExitedCombat → resetEncounter. Port as a poll: boss alive, out of
	-- combat, no players inside the volume → restore starting state.
	if (not CreatureObject(pBoss):isInCombat() and self:countPlayersInVolume(ev.x, ev.y, ev.radius) == 0) then
		self:resetEventOne(session)
	end

	createEvent(self.winPoll * 1000, "VolcanoBattlefield", "eventOneResetPoll", nil, tostring(session))
end

function VolcanoBattlefield:resetEventOne(session)
	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[1] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	self:fullHeal(pBoss)
	TangibleObject(pBoss):setOptionBit(INVULNERABLE)
	AiAgent(pBoss):clearCombatState(true)
	AiAgent(pBoss):setOblivious()

	-- Destroy and respawn the eight sustainers (live clearAllAdds + spawnGuards).
	local old = track.eventGuards[1] or {}

	for i = 1, #old do
		local pGuard = getSceneObject(old[i])

		if (pGuard ~= nil) then
			SceneObject(pGuard):destroyObjectFromWorld()
		end
	end

	track.eventGuards[1] = {}
	track.eventCurrentAttacker = 0

	local ev = self.events[1]

	for i = 1, #self.eventOneGuardOffsets do
		local off = self.eventOneGuardOffsets[i]
		local pGuard = self:spawnInvulnerableMobile("som_volcano_one_sustainer", ev.x + off[1], ev.y + off[2], 0)

		if (pGuard ~= nil) then
			self:trackGuard(session, 1, pGuard)
		end
	end

	-- Allow the volume to re-arm the fight when players walk back in.
	track.eventActive[1] = false
end

function VolcanoBattlefield:eventOneBossDied(pBoss, pKiller)
	if (readData("volcanoBattlefield:active") ~= 1) then
		return 1
	end

	local session = self:currentSession()

	-- Only the boss counts; the guards never have to die.
	self:broadcastMessage("The Taskmaster has been defeated.") -- live taskmaster; no stf in tree
	self:eventDefeated(session, 1)
	return 1
end

--------------------------------------------------------------------------------
-- EVENT TWO  --  AK Prime (LIVE-VOLCANO §2.2)
--------------------------------------------------------------------------------

function VolcanoBattlefield:spawnEventTwoActors(session)
	local ev = self.events[2]
	local track = self:getTrack(session)
	local pBoss = self:spawnInvulnerableMobile("som_volcano_two_ak_prime", ev.x, ev.y, 0)

	if (pBoss ~= nil) then
		local oid = self:trackArmy(session, pBoss)
		track.eventBoss[2] = oid
		createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventTwoBossDied", pBoss)
		-- Live ai_lib.establishAgroLink(boss, guards): pulling the boss pulls
		-- all four. Core3 has no equivalent binding; DEFENDERADDED reproduces
		-- the effect (same substitution valley_battlefield.lua uses for the
		-- commander agro-link).
		createObserver(DEFENDERADDED, "VolcanoBattlefield", "eventTwoBossDefenderAdded", pBoss)
	end

	track.eventGuards[2] = {}

	for i = 1, #self.eventTwoGuardOffsets do
		local off = self.eventTwoGuardOffsets[i]
		local pGuard = self:spawnInvulnerableMobile("som_volcano_two_hk77", ev.x + off[1], ev.y + off[2], 0)

		if (pGuard ~= nil) then
			self:trackGuard(session, 2, pGuard)
		end
	end
end

function VolcanoBattlefield:activateEventTwo(session)
	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[2] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)

	local guards = track.eventGuards[2] or {}

	for i = 1, #guards do
		local pGuard = getSceneObject(guards[i])

		if (pGuard ~= nil and not CreatureObject(pGuard):isDead()) then
			TangibleObject(pGuard):clearOptionBit(INVULNERABLE)
		end
	end

	-- event_two_boss.java cycleNextAE every 18 s; first burst armed now.
	createEvent(1000, "VolcanoBattlefield", "eventTwoCycleAE", nil, tostring(session))
end

function VolcanoBattlefield:eventTwoBossDefenderAdded(pBoss, pDefender)
	if (pBoss == nil or pDefender == nil or readData("volcanoBattlefield:active") ~= 1) then
		return 0
	end

	local session = self:currentSession()
	local track = self.tracked[session]

	if (track == nil) then
		return 0
	end

	local guards = track.eventGuards[2] or {}

	for i = 1, #guards do
		local pGuard = getSceneObject(guards[i])

		if (pGuard ~= nil and not CreatureObject(pGuard):isDead()) then
			AiAgent(pGuard):setDefender(pDefender)
		end
	end

	return 0
end

function VolcanoBattlefield:eventTwoCycleAE(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[2] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_two_boss.java chooseAEType: random wave / airfall / cone.
	local aeType = getRandomNumber(3)

	if (aeType == 1) then
		-- live mustafar/volcano_battlefield stf keys for telegraphs are gone;
		-- announce in plain English so the burst is not invisible (§5F / §5G).
		self:broadcastMessage("AK Prime is charging a blast wave!") -- live wave pre-burst
		createEvent(4000, "VolcanoBattlefield", "eventTwoWaveBurst", pBoss, tostring(session))
	elseif (aeType == 2) then
		self:broadcastMessage("AK Prime is calling down an airburst!") -- live airfall pre-burst
		createEvent(4000, "VolcanoBattlefield", "eventTwoAirfallBurst", pBoss, tostring(session))
	else
		self:broadcastMessage("AK Prime is lining up a cone blast!") -- live cone pre-burst
		createEvent(4000, "VolcanoBattlefield", "eventTwoConeBurst", pBoss, tostring(session))
	end

	createEvent(18000, "VolcanoBattlefield", "eventTwoCycleAE", nil, tostring(session))
end

function VolcanoBattlefield:eventTwoWaveBurst(pBoss, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_two_boss.java:143-183, radius 96. Particles omitted (§5F).
	local players = SceneObject(pBoss):getPlayersInRange(96)

	if (players == nil) then
		return
	end

	local pDefender = AiAgent(pBoss):getFollowObject()
	local defenderID = 0

	if (pDefender ~= nil) then
		defenderID = SceneObject(pDefender):getObjectID()
	end

	local bx = SceneObject(pBoss):getWorldPositionX()
	local by = SceneObject(pBoss):getWorldPositionY()
	local bossID = SceneObject(pBoss):getObjectID()

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
			local dx = SceneObject(pPlayer):getWorldPositionX() - bx
			local dy = SceneObject(pPlayer):getWorldPositionY() - by
			local distance = math.sqrt(dx * dx + dy * dy)

			if (distance < 1) then
				distance = 1
			end

			if (SceneObject(pPlayer):getObjectID() == defenderID) then
				CreatureObject(pPlayer):inflictDamage(pBoss, 0, 2000, false)
				-- Fire DOT: duration 200, potency 60. Strength not separately
				-- recoverable from live's -1 argument; use the burst amount.
				CreatureObject(pPlayer):addDotState(pBoss, ONFIRE, 2000, HEALTH, 200, 60, bossID, 0)
			else
				local damage = math.floor(30000 / distance)
				CreatureObject(pPlayer):inflictDamage(pBoss, 0, damage, false)
				CreatureObject(pPlayer):addDotState(pBoss, ONFIRE, math.floor(damage / 10), HEALTH, 300, 60, bossID, 0)
			end
		end
	end
end

function VolcanoBattlefield:eventTwoAirfallBurst(pBoss, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_two_boss.java:193-224, radius 96. Live damage type ELECTRICAL --
	-- more damage the farther you are. inflictDamage has no element channel,
	-- so this lands as pool-0 (HEALTH) damage; the element does not survive.
	local players = SceneObject(pBoss):getPlayersInRange(96)

	if (players == nil) then
		return
	end

	local bx = SceneObject(pBoss):getWorldPositionX()
	local by = SceneObject(pBoss):getWorldPositionY()

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
			local dx = SceneObject(pPlayer):getWorldPositionX() - bx
			local dy = SceneObject(pPlayer):getWorldPositionY() - by
			local distance = math.sqrt(dx * dx + dy * dy)
			local modDistance = math.max(0.1, distance / 20)
			local damage = math.floor(modDistance * 3000)

			CreatureObject(pPlayer):inflictDamage(pBoss, 0, damage, false)
		end
	end
end

function VolcanoBattlefield:eventTwoConeBurst(pBoss, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_two_boss.java:234-270. Live trial.getValidTargetsInCone(self,
	-- target, 96, 30). No cone helper here: filter getPlayersInRange(96) by the
	-- angle between (boss → defender) and (boss → candidate) being ≤ 15° either
	-- side. Primary takes 2500; everyone else in the cone takes 8500 -- live's
	-- number, not a typo; the cone punishes the group, not the tank. Live COLD
	-- element lands as pool-0 damage (§6).
	local pDefender = AiAgent(pBoss):getFollowObject()

	if (pDefender == nil or not SceneObject(pDefender):isPlayerCreature()) then
		pDefender = self:nearestPlayerNear(pBoss, 96)
	end

	if (pDefender == nil) then
		return
	end

	local players = SceneObject(pBoss):getPlayersInRange(96)

	if (players == nil) then
		return
	end

	local bx = SceneObject(pBoss):getWorldPositionX()
	local by = SceneObject(pBoss):getWorldPositionY()
	local ax = SceneObject(pDefender):getWorldPositionX() - bx
	local ay = SceneObject(pDefender):getWorldPositionY() - by
	local defenderID = SceneObject(pDefender):getObjectID()

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
			local px = SceneObject(pPlayer):getWorldPositionX() - bx
			local py = SceneObject(pPlayer):getWorldPositionY() - by
			local ang = self:angleBetweenDeg(ax, ay, px, py)

			if (ang <= 15) then
				if (SceneObject(pPlayer):getObjectID() == defenderID) then
					CreatureObject(pPlayer):inflictDamage(pBoss, 0, 2500, false)
				else
					CreatureObject(pPlayer):inflictDamage(pBoss, 0, 8500, false)
				end
			end
		end
	end
end

function VolcanoBattlefield:eventTwoBossDied(pBoss, pKiller)
	if (readData("volcanoBattlefield:active") ~= 1) then
		return 1
	end

	local session = self:currentSession()

	self:broadcastMessage("AK Prime has been destroyed.") -- live ak_prime; no stf in tree
	self:eventDefeated(session, 2)
	return 1
end

--------------------------------------------------------------------------------
-- EVENT THREE  --  Forward Commander + corpse revive (LIVE-VOLCANO §2.3 / §3.1)
--------------------------------------------------------------------------------

function VolcanoBattlefield:spawnEventThreeActors(session)
	local ev = self.events[3]
	local track = self:getTrack(session)
	-- yaw 180 for boss and all fifteen guards (event_three.java:74-118)
	local pBoss = self:spawnInvulnerableMobile("som_volcano_three_forward_commander", ev.x, ev.y, 180)

	if (pBoss ~= nil) then
		local oid = self:trackArmy(session, pBoss)
		track.eventBoss[3] = oid
		track.originalBossID = oid
		track.commanders = { oid }
		createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventThreeCommanderDied", pBoss)
	end

	track.eventGuards[3] = {}
	track.deadGuards = 0
	track.deadBoss = 0
	track.corpseIdx = 0

	for i = 1, #self.eventThreeGuardOffsets do
		local off = self.eventThreeGuardOffsets[i]
		local pGuard = self:spawnInvulnerableMobile("som_volcano_three_hk77", ev.x + off[1], ev.y + off[2], 180)

		if (pGuard ~= nil) then
			self:trackGuard(session, 3, pGuard)
			createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventThreeGuardDied", pGuard)
		end
	end
end

function VolcanoBattlefield:activateEventThree(session)
	local track = self:getTrack(session)

	track.eventGuardIndex = 0
	-- event_three.java:53-58 → doGuardAttackCycle @1s
	createEvent(1000, "VolcanoBattlefield", "eventThreeReleaseGuard", nil, tostring(session))
end

function VolcanoBattlefield:eventThreeReleaseGuard(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local guards = track.eventGuards[3] or {}

	-- event_three.java:119-154: release one living guard per tick; a dead index
	-- costs no time -- skip it and take the next in the same tick.
	while (track.eventGuardIndex < #guards) do
		track.eventGuardIndex = track.eventGuardIndex + 1
		local pGuard = getSceneObject(guards[track.eventGuardIndex])

		if (pGuard ~= nil and not CreatureObject(pGuard):isDead()) then
			TangibleObject(pGuard):clearOptionBit(INVULNERABLE)

			local pTarget = self:nearestPlayerNear(pGuard, 100)

			if (pTarget ~= nil) then
				AiAgent(pGuard):setDefender(pTarget)
			end

			break
		end
	end

	if (track.eventGuardIndex < #guards) then
		createEvent(10000, "VolcanoBattlefield", "eventThreeReleaseGuard", nil, tostring(session))
	end
end

function VolcanoBattlefield:eventThreeGuardDied(pGuard, pKiller)
	if (readData("volcanoBattlefield:active") ~= 1) then
		return 1
	end

	local session = self:currentSession()
	local track = self:getTrack(session)

	track.deadGuards = track.deadGuards + 1
	self:placeEventThreeCorpse(session)

	-- Phase gate: all fifteen must die before the commander is touchable.
	if (track.deadGuards == 15) then
		self:activateEventThreeBoss(session)
	end

	return 1
end

function VolcanoBattlefield:placeEventThreeCorpse(session)
	local track = self:getTrack(session)

	if (track.corpseIdx >= #self.eventThreeCorpseOffsets) then
		return
	end

	track.corpseIdx = track.corpseIdx + 1
	local off = self.eventThreeCorpseOffsets[track.corpseIdx]
	local ev = self.events[3]
	-- Fresh object at a scripted spot, NOT the body where the guard fell
	-- (event_three.java:202-241).
	local pCorpse = self:placeCorpse("som_volcano_three_hk77", ev.x + off[1], ev.y + off[2])

	if (pCorpse ~= nil) then
		local oid = SceneObject(pCorpse):getObjectID()
		table.insert(track.corpses, oid)
		table.insert(track.army, oid)
	end
end

function VolcanoBattlefield:activateEventThreeBoss(session)
	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[3] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_three.java:242-252 activateBoss: beginAttack @3s, doResEffect @10s.
	createEvent(3000, "VolcanoBattlefield", "eventThreeBossBeginAttack", pBoss, tostring(session))
	createEvent(10000, "VolcanoBattlefield", "eventThreePerformRez", nil, tostring(session))
end

function VolcanoBattlefield:eventThreeBossBeginAttack(pBoss, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)

	local pTarget = self:nearestPlayerNear(pBoss, 100)

	if (pTarget ~= nil) then
		AiAgent(pBoss):setDefender(pTarget)
	end
end

function VolcanoBattlefield:eventThreePerformRez(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local livingCommanders = {}
	local livingCorpses = {}

	for i = 1, #track.commanders do
		local pCmd = getSceneObject(track.commanders[i])

		if (pCmd ~= nil and not CreatureObject(pCmd):isDead()) then
			table.insert(livingCommanders, track.commanders[i])
		end
	end

	track.commanders = livingCommanders

	for i = 1, #track.corpses do
		local pCorpse = getSceneObject(track.corpses[i])

		if (pCorpse ~= nil) then
			table.insert(livingCorpses, track.corpses[i])
		end
	end

	track.corpses = livingCorpses

	if (#livingCommanders == 0 or #livingCorpses == 0) then
		-- Still re-arm while corpses or commanders may appear from in-flight
		-- deaths; stop only when the encounter is already won.
		if (track.deadBoss < 16) then
			local delay = 35000

			if (#livingCommanders == 1) then
				delay = 18000
			end

			createEvent(delay, "VolcanoBattlefield", "eventThreePerformRez", nil, tostring(session))
		end

		return
	end

	-- event_three.java:292-320 performRez: index-pair commander[i] with
	-- corpse[i], all simultaneously. Fallback performSoloCorpseRez (:351-368)
	-- when exactly one commander is alive uses the faster 18 s cycle.
	local pairCount = math.min(#livingCommanders, #livingCorpses)
	local remainingCorpses = {}

	for i = 1, #livingCorpses do
		if (i <= pairCount) then
			local corpseID = livingCorpses[i]
			local pCorpse = getSceneObject(corpseID)

			if (pCorpse ~= nil) then
				local cx = SceneObject(pCorpse):getWorldPositionX()
				local cy = SceneObject(pCorpse):getWorldPositionY()

				SceneObject(pCorpse):destroyObjectFromWorld()

				local yaw = getRandomNumber(0, 359)
				local z = getWorldFloor(cx, cy, "mustafar")
				local pRisen = spawnMobile("mustafar", "som_volcano_three_risen_commander", 0, cx, z, cy, yaw, 0)

				if (pRisen ~= nil) then
					local oid = self:trackArmy(session, pRisen)
					table.insert(track.commanders, oid)
					createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventThreeCommanderDied", pRisen)

					local pTarget = self:nearestPlayerNear(pRisen, 100)

					if (pTarget ~= nil) then
						AiAgent(pRisen):setDefender(pTarget)
					end
				end
			end
		else
			table.insert(remainingCorpses, livingCorpses[i])
		end
	end

	track.corpses = remainingCorpses

	local delay = 35000

	if (#track.commanders == 1) then
		delay = 18000
	end

	createEvent(delay, "VolcanoBattlefield", "eventThreePerformRez", nil, tostring(session))
end

function VolcanoBattlefield:eventThreeCommanderDied(pBoss, pKiller)
	if (readData("volcanoBattlefield:active") ~= 1) then
		return 1
	end

	local session = self:currentSession()
	local track = self:getTrack(session)

	track.deadBoss = track.deadBoss + 1

	-- Bonus loot only on the original commander (event_three_boss.java:23-40).
	-- Live static-item item_tow_schematic_vehicle_02_02 ("Lava Transport Skiff")
	-- is not an object template in this tree. Substituted
	-- landspeeder_lava_skiff_deed.iff -- same family, registered, generates the
	-- actual Lava Transport Skiff. See THE REWARD reasoning in
	-- hidden_treasure.lua; keep live's 12% roll.
	if (pBoss ~= nil and SceneObject(pBoss):getObjectID() == track.originalBossID) then
		if (getRandomNumber(100) <= 12) then
			local pLootTo = pKiller

			if (pLootTo ~= nil and SceneObject(pLootTo):isAiAgent() and AiAgent(pLootTo):isPet()) then
				pLootTo = AiAgent(pLootTo):getOwner()
			end

			if (pLootTo ~= nil and SceneObject(pLootTo):isPlayerCreature()) then
				local pInventory = SceneObject(pLootTo):getSlottedObject("inventory")

				if (pInventory ~= nil) then
					giveItem(pInventory, "object/tangible/deed/vehicle_deed/landspeeder_lava_skiff_deed.iff", -1, true)
				end
			end
		end
	end

	-- Win: deadBoss == 16 -- the original plus fifteen revives. No other number.
	if (track.deadBoss == 16) then
		self:broadcastMessage("The Forward Commander and his risen host have fallen.") -- live; no stf
		self:eventDefeated(session, 3)
	end

	return 1
end

--------------------------------------------------------------------------------
-- Shared: switchTarget (§5C substitution)
--------------------------------------------------------------------------------

-- live switchTarget → pick a random player in range other than the current
-- defender and setDefender. Observable half only; enfeeble / hate re-weight
-- do not survive (part one §5A / §5C).
function VolcanoBattlefield:switchTargetOntoOther(pBoss, radius)
	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local players = SceneObject(pBoss):getPlayersInRange(radius)

	if (players == nil or #players < 2) then
		return
	end

	local pCurrent = AiAgent(pBoss):getFollowObject()
	local currentID = 0

	if (pCurrent ~= nil) then
		currentID = SceneObject(pCurrent):getObjectID()
	end

	local candidates = {}

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
			if (SceneObject(pPlayer):getObjectID() ~= currentID) then
				table.insert(candidates, pPlayer)
			end
		end
	end

	if (#candidates == 0) then
		return
	end

	local pick = candidates[getRandomNumber(1, #candidates)]
	AiAgent(pBoss):setDefender(pick)
end

--------------------------------------------------------------------------------
-- EVENT FOUR  --  the Cyborg Prototype (LIVE-VOLCANO §2.4)
--------------------------------------------------------------------------------

function VolcanoBattlefield:spawnEventFourActors(session)
	local ev = self.events[4]
	local track = self:getTrack(session)
	-- Boss yaw 195. No guards spawn here.
	local pBoss = self:spawnInvulnerableMobile("som_volcano_four_cym_prototype", ev.x, ev.y, 195)

	if (pBoss ~= nil) then
		local oid = self:trackArmy(session, pBoss)
		track.eventBoss[4] = oid
		createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventFourBossDied", pBoss)
	end
end

function VolcanoBattlefield:activateEventFour(session)
	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[4] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)

	local pNear = self:nearestPlayerNear(pBoss, 90)

	if (pNear ~= nil) then
		AiAgent(pBoss):setDefender(pNear)
	end

	-- Live OnEnteredCombat → doAEBurst @4 s, spawnAdd @6 s; doAEBurst → poison
	-- @1 s, force drain @8 s. First fires: beetles 6 s, poison 5 s, drain 12 s.
	-- doDiseaseAE is defined and never scheduled -- not ported (header).
	if (track.eventFourLoops ~= true) then
		track.eventFourLoops = true
		createEvent(6000, "VolcanoBattlefield", "eventFourBeetleWave", nil, tostring(session))
		createEvent(5000, "VolcanoBattlefield", "eventFourPoisonAE", nil, tostring(session))
		createEvent(12000, "VolcanoBattlefield", "eventFourForceDrainAE", nil, tostring(session))
	end
end

function VolcanoBattlefield:eventFourBeetleWave(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[4] ~= true) then
		createEvent(31000, "VolcanoBattlefield", "eventFourBeetleWave", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[4] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	local ev = self.events[4]

	-- event_four_boss.java:100-137 BEETLE_RESPAWN 31. One beetle at each of the
	-- four offsets. Live four_summon_add (trial.java:152).
	self:broadcastMessage("The Cyborg Prototype summons lava beetles!") -- live four_summon_add

	for i = 1, #self.eventFourBeetleOffsets do
		local off = self.eventFourBeetleOffsets[i]
		local yaw = getRandomNumber(0, 359)
		local z = getWorldFloor(ev.x + off[1], ev.y + off[2], "mustafar")
		local pBeetle = spawnMobile("mustafar", "som_volcano_four_lava_beetle", 0, ev.x + off[1], z, ev.y + off[2], yaw, 0)

		if (pBeetle ~= nil) then
			self:trackGuard(session, 4, pBeetle)
			createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventFourBeetleDied", pBeetle)

			local pNear = self:nearestPlayerNear(pBeetle, 90)

			if (pNear ~= nil) then
				AiAgent(pBeetle):setDefender(pNear)
			end
		end
	end

	createEvent(31000, "VolcanoBattlefield", "eventFourBeetleWave", nil, tostring(session))
end

function VolcanoBattlefield:eventFourPoisonAE(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[4] ~= true) then
		createEvent(35000, "VolcanoBattlefield", "eventFourPoisonAE", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[4] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- event_four_boss.java doPoisonAE: radius 200, strength 125, duration 455,
	-- potency 30. Argument shape from geoLab.lua:556 (part one §6).
	local players = SceneObject(pBoss):getPlayersInRange(200)

	if (players ~= nil) then
		local bossID = SceneObject(pBoss):getObjectID()

		for i = 1, #players do
			local pPlayer = players[i]

			if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
				CreatureObject(pPlayer):addDotState(pBoss, POISONED, 125, HEALTH, 455, 30, bossID, 0)
			end
		end
	end

	createEvent(35000, "VolcanoBattlefield", "eventFourPoisonAE", nil, tostring(session))
end

function VolcanoBattlefield:eventFourForceDrainAE(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[4] ~= true) then
		createEvent(22000, "VolcanoBattlefield", "eventFourForceDrainAE", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[4] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- live drainAttributes(target, 1000, 0). Port: inflictDamage on ACTION (3)
	-- and MIND (6) by 1000 each -- closest honest primitive; it is damage
	-- rather than a drain (part one §6).
	local players = SceneObject(pBoss):getPlayersInRange(200)

	if (players ~= nil) then
		for i = 1, #players do
			local pPlayer = players[i]

			if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
				CreatureObject(pPlayer):inflictDamage(pBoss, 3, 1000, false)
				CreatureObject(pPlayer):inflictDamage(pBoss, 6, 1000, false)
			end
		end
	end

	createEvent(22000, "VolcanoBattlefield", "eventFourForceDrainAE", nil, tostring(session))
end

function VolcanoBattlefield:eventFourBeetleDied(pBeetle, pKiller)
	if (readData("volcanoBattlefield:active") ~= 1 or pBeetle == nil) then
		return 1
	end

	local session = self:currentSession()

	-- Live plays PRT_KUBAZA_WARNING then nukeSelf @5 s. Effect omitted (§5F);
	-- broadcast the warning so the blast is not invisible and unfair.
	-- setMovementRun omitted -- no Lua binding found.
	-- OBJECTDESTRUCTION means the beetle is going away; capture its position
	-- now and blast from those coords in 5 s rather than holding the pointer.
	local bx = SceneObject(pBeetle):getWorldPositionX()
	local by = SceneObject(pBeetle):getWorldPositionY()

	self:broadcastMessage("A lava beetle is about to explode!") -- live PRT_KUBAZA_WARNING stand-in
	createEvent(5000, "VolcanoBattlefield", "eventFourBeetleNuke", nil, tostring(session) .. ":" .. tostring(bx) .. ":" .. tostring(by))
	return 1
end

function VolcanoBattlefield:eventFourBeetleNuke(pNil, args)
	local session, bx, by = string.match(args, "^(%d+):([^:]+):([^:]+)$")
	session = tonumber(session)
	bx = tonumber(bx)
	by = tonumber(by)

	if (not self:isSessionCurrent(session) or bx == nil or by == nil) then
		return
	end

	-- event_four_guard.java: radius 7, 2000 DAMAGE_ELEMENTAL_HEAT.
	-- inflictDamage has no element channel, so it lands as pool 0 (HEALTH).
	-- No SceneObject left at the blast point; walk tracked players.
	self:forEachPlayerInside(function(pPlayer)
		if (CreatureObject(pPlayer):isDead()) then
			return
		end

		local dx = SceneObject(pPlayer):getWorldPositionX() - bx
		local dy = SceneObject(pPlayer):getWorldPositionY() - by

		if ((dx * dx + dy * dy) <= (7 * 7)) then
			-- Attacker is gone; pass the player as both target and attacker source
			-- the way geoLab.lua does when no living attacker is available.
			CreatureObject(pPlayer):inflictDamage(pPlayer, 0, 2000, false)
		end
	end)
end

function VolcanoBattlefield:eventFourBossDied(pBoss, pKiller)
	if (readData("volcanoBattlefield:active") ~= 1) then
		return 1
	end

	local session = self:currentSession()

	self:broadcastMessage("The Cyborg Prototype has been destroyed.") -- live event four win; no stf
	self:eventDefeated(session, 4)
	return 1
end

--------------------------------------------------------------------------------
-- EVENT FIVE  --  the Oppressor Septipod (LIVE-VOLCANO §2.5, §3.2)
--------------------------------------------------------------------------------

function VolcanoBattlefield:spawnEventFiveActors(session)
	local ev = self.events[5]
	local track = self:getTrack(session)
	local pBoss = self:spawnInvulnerableMobile("som_volcano_five_boss_septipod", ev.x, ev.y, 195)

	if (pBoss ~= nil) then
		local oid = self:trackArmy(session, pBoss)
		track.eventBoss[5] = oid
		createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventFiveBossDied", pBoss)
	end

	track.deadGuards = 0
	track.spawned80 = false
	track.spawned60 = false
	track.spawned50 = false
	track.spawned40 = false
	track.spawned20 = false
	track.midguardScheduled = false
	track.midguardResumed = false
	track.midguards = {}
	track.midguardDead = {}
end

function VolcanoBattlefield:activateEventFive(session)
	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[5] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)

	local pNear = self:nearestPlayerNear(pBoss, 90)

	if (pNear ~= nil) then
		AiAgent(pBoss):setDefender(pNear)
	end

	-- Debuff AE / distraction / enfeeble omitted (§5A) -- named in the header.
	-- switchTarget ports its observable half only (§5C).
	if (track.eventFiveLoops ~= true) then
		track.eventFiveLoops = true
		createEvent(18000, "VolcanoBattlefield", "eventFiveSwitchTarget", nil, tostring(session))
		createEvent(3000, "VolcanoBattlefield", "eventFiveHealthLadder", nil, tostring(session))
		createEvent(self.winPoll * 1000, "VolcanoBattlefield", "eventFiveResetPoll", nil, tostring(session))
	end
end

function VolcanoBattlefield:eventFiveSwitchTarget(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[5] ~= true) then
		createEvent(18000, "VolcanoBattlefield", "eventFiveSwitchTarget", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[5] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- Skip while midguard invulnerable phase -- boss is oblivious.
	if (not TangibleObject(pBoss):hasOptionBit(INVULNERABLE)) then
		self:switchTargetOntoOther(pBoss, 90)
	end

	createEvent(18000, "VolcanoBattlefield", "eventFiveSwitchTarget", nil, tostring(session))
end

function VolcanoBattlefield:eventFiveHealthLadder(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[5] ~= true) then
		createEvent(3000, "VolcanoBattlefield", "eventFiveHealthLadder", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[5] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- Midguard gate: poll dead count rather than an observer (spec §2).
	if (track.spawned50 and not track.midguardResumed and #track.midguards > 0) then
		for i = 1, #track.midguards do
			local oid = track.midguards[i]

			if (track.midguardDead[oid] ~= true) then
				local pMg = getSceneObject(oid)

				if (pMg == nil or CreatureObject(pMg):isDead()) then
					track.midguardDead[oid] = true
					track.deadGuards = track.deadGuards + 1
				end
			end
		end

		if (track.deadGuards >= 6) then
			self:eventFiveResumeAttack(session)
		end
	end

	-- No damage observer: poll getHAM(0)/getMaxHAM(0) every 3 s. Fire every
	-- rung that has been crossed, not just the newest -- a big hit can skip
	-- two at once, and live's chained if does the same
	-- (event_five_boss.java:75-106).
	if (TangibleObject(pBoss):hasOptionBit(INVULNERABLE)) then
		createEvent(3000, "VolcanoBattlefield", "eventFiveHealthLadder", nil, tostring(session))
		return
	end

	local maxHam = CreatureObject(pBoss):getMaxHAM(0)

	if (maxHam <= 0) then
		createEvent(3000, "VolcanoBattlefield", "eventFiveHealthLadder", nil, tostring(session))
		return
	end

	local ratio = CreatureObject(pBoss):getHAM(0) / maxHam

	if (ratio <= 0.8 and not track.spawned80) then
		track.spawned80 = true
		self:eventFiveSpawnTrioAdd(session)
	end

	if (ratio <= 0.6 and not track.spawned60) then
		track.spawned60 = true
		self:eventFiveSpawnTrioAdd(session)
	end

	if (ratio <= 0.5 and not track.spawned50) then
		track.spawned50 = true
		self:eventFiveBeginMidguardPhase(session)
	end

	if (ratio <= 0.4 and not track.spawned40) then
		track.spawned40 = true
		self:eventFiveSpawnTrioAdd(session)
	end

	if (ratio <= 0.2 and not track.spawned20) then
		track.spawned20 = true
		self:eventFiveSpawnTrioAdd(session)
	end

	createEvent(3000, "VolcanoBattlefield", "eventFiveHealthLadder", nil, tostring(session))
end

function VolcanoBattlefield:eventFiveSpawnTrioAdd(session)
	local track = self:getTrack(session)
	local ev = self.events[5]

	-- live five_summon_trio (trial.java:153). Buff strip every 16 s omitted (§5B).
	self:broadcastMessage("The Oppressor summons a trio of septipods!") -- live five_summon_trio

	for i = 1, #self.eventFiveTrioSpawns do
		local off = self.eventFiveTrioSpawns[i]
		local yaw = getRandomNumber(0, 359)
		local z = getWorldFloor(ev.x + off[1], ev.y + off[2], "mustafar")
		local pAdd = spawnMobile("mustafar", "som_volcano_five_septipod", 0, ev.x + off[1], z, ev.y + off[2], yaw, 0)

		if (pAdd ~= nil) then
			self:trackGuard(session, 5, pAdd)

			local pNear = self:nearestPlayerNear(pAdd, 150)

			if (pNear ~= nil) then
				AiAgent(pAdd):setDefender(pNear)
			end
		end
	end
end

function VolcanoBattlefield:eventFiveBeginMidguardPhase(session)
	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[5] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead() or track.midguardScheduled) then
		return
	end

	-- event_five_boss.java:195-206 -- invulnerable, clear combat, schedule wall @5 s.
	-- clearHateList + stopCombat → clearCombatState + setOblivious (§5C).
	track.midguardScheduled = true
	TangibleObject(pBoss):setOptionBit(INVULNERABLE)
	AiAgent(pBoss):clearCombatState(true)
	AiAgent(pBoss):setOblivious()

	createEvent(5000, "VolcanoBattlefield", "eventFiveSpawnMidguard", nil, tostring(session))
end

function VolcanoBattlefield:eventFiveSpawnMidguard(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local ev = self.events[5]

	track.deadGuards = 0
	track.midguards = {}
	track.midguardDead = {}

	-- live five_summon_midguard (trial.java:154)
	self:broadcastMessage("The Oppressor raises a midguard wall!") -- live five_summon_midguard

	for i = 1, #self.eventFiveMidguardSpawns do
		local off = self.eventFiveMidguardSpawns[i]
		local yaw = getRandomNumber(0, 359)
		local z = getWorldFloor(ev.x + off[1], ev.y + off[2], "mustafar")
		local pMg = spawnMobile("mustafar", "som_volcano_five_midguard", 0, ev.x + off[1], z, ev.y + off[2], yaw, 0)

		if (pMg ~= nil) then
			local oid = SceneObject(pMg):getObjectID()
			table.insert(track.army, oid)
			table.insert(track.midguards, oid)

			local pNear = self:nearestPlayerNear(pMg, 150)

			if (pNear ~= nil) then
				AiAgent(pMg):setDefender(pNear)
			end
		end
	end
end

function VolcanoBattlefield:eventFiveResumeAttack(session)
	local track = self:getTrack(session)

	if (track.midguardResumed) then
		return
	end

	track.midguardResumed = true

	local pBoss = getSceneObject(track.eventBoss[5] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- resumeAttack (event_five_boss.java:161-172): clear INVULNERABLE, scan 200.
	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)

	local pNear = self:nearestPlayerNear(pBoss, 200)

	if (pNear ~= nil) then
		AiAgent(pBoss):setDefender(pNear)
	end
end

function VolcanoBattlefield:eventFiveResetPoll(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[5] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- live verifyHealthReset opens with if (isInvulnerable(self)) return;
	-- while midguards are up the boss will not reset. Preserve that.
	if (TangibleObject(pBoss):hasOptionBit(INVULNERABLE)) then
		createEvent(self.winPoll * 1000, "VolcanoBattlefield", "eventFiveResetPoll", nil, tostring(session))
		return
	end

	local ev = self.events[5]

	if (not CreatureObject(pBoss):isInCombat() and self:countPlayersInVolume(ev.x, ev.y, ev.radius) == 0) then
		self:resetEventFive(session)
	end

	createEvent(self.winPoll * 1000, "VolcanoBattlefield", "eventFiveResetPoll", nil, tostring(session))
end

function VolcanoBattlefield:resetEventFive(session)
	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[5] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	self:fullHeal(pBoss)
	TangibleObject(pBoss):setOptionBit(INVULNERABLE)
	AiAgent(pBoss):clearCombatState(true)
	AiAgent(pBoss):setOblivious()

	-- Clear every ladder flag including spawned50 so the midguard phase re-arms.
	track.spawned80 = false
	track.spawned60 = false
	track.spawned50 = false
	track.spawned40 = false
	track.spawned20 = false
	track.midguardScheduled = false
	track.midguardResumed = false
	track.deadGuards = 0

	local oldGuards = track.eventGuards[5] or {}

	for i = 1, #oldGuards do
		local pGuard = getSceneObject(oldGuards[i])

		if (pGuard ~= nil) then
			SceneObject(pGuard):destroyObjectFromWorld()
		end
	end

	track.eventGuards[5] = {}

	for i = 1, #track.midguards do
		local pMg = getSceneObject(track.midguards[i])

		if (pMg ~= nil) then
			SceneObject(pMg):destroyObjectFromWorld()
		end
	end

	track.midguards = {}
	track.midguardDead = {}
	track.eventActive[5] = false
end

function VolcanoBattlefield:eventFiveBossDied(pBoss, pKiller)
	if (readData("volcanoBattlefield:active") ~= 1) then
		return 1
	end

	local session = self:currentSession()

	self:broadcastMessage("The Oppressor Septipod has been destroyed.") -- live event five win; no stf
	self:eventDefeated(session, 5)
	return 1
end

--------------------------------------------------------------------------------
-- HK-47 FINALE  --  LIVE-VOLCANO §4
--------------------------------------------------------------------------------

function VolcanoBattlefield:spawnEventHkActors(session)
	local ev = self.events[6]
	local track = self:getTrack(session)
	local pBoss = self:spawnInvulnerableMobile("som_volcano_final_hk47", ev.x, ev.y, 25)

	if (pBoss ~= nil) then
		local oid = self:trackArmy(session, pBoss)
		track.eventBoss[6] = oid
		track.bossID = oid
		createObserver(OBJECTDESTRUCTION, "VolcanoBattlefield", "eventHkBossDied", pBoss)
	end
end

function VolcanoBattlefield:activateEventHk(session)
	local track = self:getTrack(session)

	-- hk_final.java:47-55: spawnSquadLeaders, landYt, doHkTaunt together.
	-- YT landing omitted -- see header. HK stays invulnerable.
	self:broadcastMessage("HK-47: Statement: Your destruction is inevitable.") -- live hk_prefight_taunt
	self:broadcastMusic(self.hkIntroMusic)
	self:spawnHkSquadWall(session)

	if (track.eventHkLoops ~= true) then
		track.eventHkLoops = true
		createEvent(3000, "VolcanoBattlefield", "eventHkTick", nil, tostring(session))
		createEvent(self.winPoll * 1000, "VolcanoBattlefield", "eventHkResetPoll", nil, tostring(session))
	end
end

function VolcanoBattlefield:spawnHkSquadWall(session)
	local track = self:getTrack(session)
	local ev = self.events[6]

	track.deadGuards = 0
	track.corpseIdx = 0
	track.squad = {}
	track.squadDead = {}
	track.hkActivated = false
	track.hkFightActive = false

	-- Live's leaderDied → low_morale on members omitted (§5A). Killing a leader
	-- has no effect on its squad in this port.
	for i = 1, #self.hkLeaderOffsets do
		local loff = self.hkLeaderOffsets[i]
		local lx = ev.x + loff[1]
		local ly = ev.y + loff[2]
		local z = getWorldFloor(lx, ly, "mustafar")
		local pLeader = spawnMobile("mustafar", "som_volcano_final_squadleader", 0, lx, z, ly, 25, 0)

		if (pLeader ~= nil) then
			local oid = SceneObject(pLeader):getObjectID()
			table.insert(track.army, oid)
			table.insert(track.squad, oid)
			-- Sentinel: hold until engaged; do not setDefender at spawn.
		end

		for j = 1, #self.hkMemberRelativeOffsets do
			local moff = self.hkMemberRelativeOffsets[j]
			local mx = lx + moff[1]
			local my = ly + moff[2]
			local mz = getWorldFloor(mx, my, "mustafar")
			local pMem = spawnMobile("mustafar", "som_volcano_final_squadmember", 0, mx, mz, my, 25, 0)

			if (pMem ~= nil) then
				local moid = SceneObject(pMem):getObjectID()
				table.insert(track.army, moid)
				table.insert(track.squad, moid)
			end
		end
	end
end

function VolcanoBattlefield:eventHkTick(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[6] ~= true) then
		createEvent(3000, "VolcanoBattlefield", "eventHkTick", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- Squad gate: poll deadGuards; do not rely on an observer for activateHK.
	for i = 1, #track.squad do
		local oid = track.squad[i]

		if (track.squadDead[oid] ~= true) then
			local pMob = getSceneObject(oid)

			if (pMob == nil or CreatureObject(pMob):isDead()) then
				track.squadDead[oid] = true
				track.deadGuards = track.deadGuards + 1
				self:placeHkCorpse(session)
			end
		end
	end

	if (track.deadGuards >= 14 and not track.hkActivated) then
		track.hkActivated = true
		createEvent(3000, "VolcanoBattlefield", "activateHK", nil, tostring(session))
	end

	-- Add ladder once HK is fighting.
	if (track.hkFightActive and not TangibleObject(pBoss):hasOptionBit(INVULNERABLE)) then
		local maxHam = CreatureObject(pBoss):getMaxHAM(0)

		if (maxHam > 0) then
			local ratio = CreatureObject(pBoss):getHAM(0) / maxHam

			-- Same 3 s poll as event five; every crossed rung fires.
			if (ratio <= 0.8 and not track.spawned80) then
				track.spawned80 = true
				self:eventHkSummonAdd(session, "som_volcano_final_lava_beetle", self.hkBeetleSpawns, "HK-47 summons lava beetles!") -- live four_summon_add / VOLCANO_CYM_BEETLE_NOTIFY
			end

			if (ratio <= 0.5 and not track.spawned50) then
				track.spawned50 = true
				-- Buff strip on septipods omitted (§5B).
				self:eventHkSummonAdd(session, "som_volcano_final_septipod", self.hkSeptipodSpawns, "HK-47 summons septipods!") -- live five_summon_trio / VOLCANO_OPP_ADD_NOTIFY
			end

			if (ratio <= 0.2 and not track.spawned20) then
				track.spawned20 = true
				self:eventHkSummonAdd(session, "som_volcano_final_walker", self.hkWalkerSpawns, "HK-47 summons walkers!") -- live hk_summon_walker
			end
		end
	end

	createEvent(3000, "VolcanoBattlefield", "eventHkTick", nil, tostring(session))
end

function VolcanoBattlefield:placeHkCorpse(session)
	local track = self:getTrack(session)
	local ev = self.events[6]

	track.corpseIdx = track.corpseIdx + 1

	if (track.corpseIdx > #self.hkCorpseOffsets) then
		return
	end

	local off = self.hkCorpseOffsets[track.corpseIdx]
	-- Fresh object at a scripted spot, not the body where the mob fell (same
	-- rule as event three).
	local pCorpse = self:placeCorpse("som_volcano_final_squadmember", ev.x + off[1], ev.y + off[2])

	if (pCorpse ~= nil) then
		table.insert(track.corpses, SceneObject(pCorpse):getObjectID())
	end
end

function VolcanoBattlefield:activateHK(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	TangibleObject(pBoss):clearOptionBit(INVULNERABLE)
	track.hkFightActive = true

	-- Clear ladder flags so the fight's own rungs arm from this activation.
	track.spawned80 = false
	track.spawned50 = false
	track.spawned20 = false

	local pNear = self:nearestPlayerNear(pBoss, 90)

	if (pNear ~= nil) then
		AiAgent(pBoss):setDefender(pNear)
	end

	-- Opening (hk_final_boss.java:71-77): raise @14, switch @24, damage AE @35.
	-- Poison first at 27 s from startAECycle (L329-335). DISEASE and FORCE_DRAIN
	-- are defined and never scheduled -- not ported. DEBUFF / distraction omitted (§5A).
	createEvent(14000, "VolcanoBattlefield", "eventHkRaiseGuard", nil, tostring(session))
	createEvent(24000, "VolcanoBattlefield", "eventHkSwitchTarget", nil, tostring(session))
	createEvent(35000, "VolcanoBattlefield", "eventHkDamageAE", nil, tostring(session))
	createEvent(27000, "VolcanoBattlefield", "eventHkPoisonAE", nil, tostring(session))

	if (track.eventHkHealLoop ~= true) then
		track.eventHkHealLoop = true
		createEvent(10000, "VolcanoBattlefield", "eventHkRisenHeal", nil, tostring(session))
	end
end

function VolcanoBattlefield:eventHkSummonAdd(session, template, offsets, message)
	local track = self:getTrack(session)
	local ev = self.events[6]

	self:broadcastMessage(message)

	for i = 1, #offsets do
		local off = offsets[i]
		local yaw = getRandomNumber(0, 359)
		local z = getWorldFloor(ev.x + off[1], ev.y + off[2], "mustafar")
		local pAdd = spawnMobile("mustafar", template, 0, ev.x + off[1], z, ev.y + off[2], yaw, 0)

		if (pAdd ~= nil) then
			self:trackGuard(session, 6, pAdd)
			createEvent(2000, "VolcanoBattlefield", "eventHkAddBeginAttack", pAdd, tostring(session))
		end
	end
end

function VolcanoBattlefield:eventHkAddBeginAttack(pAdd, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pAdd == nil or CreatureObject(pAdd):isDead()) then
		return
	end

	local pNear = self:nearestPlayerNear(pAdd, 90)

	if (pNear ~= nil) then
		AiAgent(pAdd):setDefender(pNear)
	end
end

function VolcanoBattlefield:eventHkRaiseGuard(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[6] ~= true or not track.hkFightActive) then
		createEvent(48000, "VolcanoBattlefield", "eventHkRaiseGuard", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- raiseGuard / performRez (hk_final_boss.java:282-315): scan corpses within
	-- 200, pick ONE at random -- deliberate contrast with event three's
	-- index-pairing. Destroy that corpse, spawn risen sustainer.
	local bx = SceneObject(pBoss):getWorldPositionX()
	local by = SceneObject(pBoss):getWorldPositionY()
	local inRange = {}

	for i = 1, #track.corpses do
		local oid = track.corpses[i]
		local pCorpse = getSceneObject(oid)

		if (pCorpse ~= nil) then
			local dx = SceneObject(pCorpse):getWorldPositionX() - bx
			local dy = SceneObject(pCorpse):getWorldPositionY() - by

			if ((dx * dx + dy * dy) <= (200 * 200)) then
				table.insert(inRange, { oid = oid, pCorpse = pCorpse })
			end
		end
	end

	if (#inRange > 0) then
		local pick = inRange[getRandomNumber(1, #inRange)]
		local cx = SceneObject(pick.pCorpse):getWorldPositionX()
		local cy = SceneObject(pick.pCorpse):getWorldPositionY()

		SceneObject(pick.pCorpse):destroyObjectFromWorld()

		local still = {}

		for i = 1, #track.corpses do
			if (track.corpses[i] ~= pick.oid) then
				table.insert(still, track.corpses[i])
			end
		end

		track.corpses = still

		local yaw = getRandomNumber(0, 359)
		local z = getWorldFloor(cx, cy, "mustafar")
		local pRisen = spawnMobile("mustafar", "som_volcano_final_risen_sustainer", 0, cx, z, cy, yaw, 0)

		if (pRisen ~= nil) then
			local oid = SceneObject(pRisen):getObjectID()
			table.insert(track.army, oid)
			table.insert(track.risenGuards, oid)
			createEvent(3000, "VolcanoBattlefield", "eventHkAddBeginAttack", pRisen, tostring(session))
		end
	end

	createEvent(48000, "VolcanoBattlefield", "eventHkRaiseGuard", nil, tostring(session))
end

function VolcanoBattlefield:eventHkRisenHeal(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[6] ~= true or not track.hkFightActive) then
		createEvent(10000, "VolcanoBattlefield", "eventHkRisenHeal", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- Each living risen guard heals HK healDamage(1000, 0) every 10 s -- same
	-- shape as event one's guard heal on the Taskmaster.
	for i = 1, #track.risenGuards do
		local pGuard = getSceneObject(track.risenGuards[i])

		if (pGuard ~= nil and not CreatureObject(pGuard):isDead()) then
			CreatureObject(pBoss):healDamage(1000, 0)
		end
	end

	createEvent(10000, "VolcanoBattlefield", "eventHkRisenHeal", nil, tostring(session))
end

function VolcanoBattlefield:eventHkDamageAE(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[6] ~= true or not track.hkFightActive) then
		createEvent(50000, "VolcanoBattlefield", "eventHkDamageAE", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- chooseAEType returns {"wave","wave"} -- only the wave is reachable;
	-- doAirfallBurst is dead code. Telegraphed at t+0, burst at t+4 s
	-- (live pre-burst @3 s / burst @7 s from performDamageAe).
	self:broadcastMessage("HK-47 is charging a blast wave!") -- live wave pre-burst; particles §5F
	createEvent(4000, "VolcanoBattlefield", "eventHkWaveBurst", pBoss, tostring(session))
	createEvent(50000, "VolcanoBattlefield", "eventHkDamageAE", nil, tostring(session))
end

function VolcanoBattlefield:eventHkWaveBurst(pBoss, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- hk_final_boss.java:447-486 radius 96. Combat spam shows 400; real damage
	-- to the defender is 1500 -- use 1500 and note the discrepancy.
	local players = SceneObject(pBoss):getPlayersInRange(96)

	if (players == nil) then
		return
	end

	local pDefender = AiAgent(pBoss):getFollowObject()
	local defenderID = 0

	if (pDefender ~= nil) then
		defenderID = SceneObject(pDefender):getObjectID()
	end

	local bx = SceneObject(pBoss):getWorldPositionX()
	local by = SceneObject(pBoss):getWorldPositionY()
	local bossID = SceneObject(pBoss):getObjectID()

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
			local dx = SceneObject(pPlayer):getWorldPositionX() - bx
			local dy = SceneObject(pPlayer):getWorldPositionY() - by
			local distance = math.sqrt(dx * dx + dy * dy)

			if (distance < 1) then
				distance = 1
			end

			if (SceneObject(pPlayer):getObjectID() == defenderID) then
				CreatureObject(pPlayer):inflictDamage(pBoss, 0, 1500, false)
			else
				local damage = math.floor(15000 / distance)
				CreatureObject(pPlayer):inflictDamage(pBoss, 0, damage, false)
				-- Fire DOT of damage/10 for duration 60.
				CreatureObject(pPlayer):addDotState(pBoss, ONFIRE, math.floor(damage / 10), HEALTH, 60, 60, bossID, 0)
			end
		end
	end
end

function VolcanoBattlefield:eventHkPoisonAE(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[6] ~= true or not track.hkFightActive) then
		createEvent(40000, "VolcanoBattlefield", "eventHkPoisonAE", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- hk_final_boss.java:532-552: radius 200, POISONED 125 / 235 / 30.
	local players = SceneObject(pBoss):getPlayersInRange(200)

	if (players ~= nil) then
		local bossID = SceneObject(pBoss):getObjectID()

		for i = 1, #players do
			local pPlayer = players[i]

			if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and not CreatureObject(pPlayer):isDead()) then
				CreatureObject(pPlayer):addDotState(pBoss, POISONED, 125, HEALTH, 235, 30, bossID, 0)
			end
		end
	end

	createEvent(40000, "VolcanoBattlefield", "eventHkPoisonAE", nil, tostring(session))
end

function VolcanoBattlefield:eventHkSwitchTarget(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	if (track.eventActive[6] ~= true or not track.hkFightActive) then
		createEvent(24000, "VolcanoBattlefield", "eventHkSwitchTarget", nil, tostring(session))
		return
	end

	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- §5C substitution; live enfeeble / removeHateTarget do not survive.
	self:switchTargetOntoOther(pBoss, 90)
	createEvent(24000, "VolcanoBattlefield", "eventHkSwitchTarget", nil, tostring(session))
end

function VolcanoBattlefield:eventHkResetPoll(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	-- Unlike event five there is NO isInvulnerable guard here -- that asymmetry
	-- is live's and must be preserved (hk_final_boss.java:112-133).
	local ev = self.events[6]

	if (not CreatureObject(pBoss):isInCombat() and self:countPlayersInVolume(ev.x, ev.y, ev.radius) == 0) then
		self:resetEventHk(session)
	end

	createEvent(self.winPoll * 1000, "VolcanoBattlefield", "eventHkResetPoll", nil, tostring(session))
end

function VolcanoBattlefield:resetEventHk(session)
	local track = self:getTrack(session)
	local pBoss = getSceneObject(track.eventBoss[6] or 0)

	if (pBoss == nil or CreatureObject(pBoss):isDead()) then
		return
	end

	self:fullHeal(pBoss)
	TangibleObject(pBoss):setOptionBit(INVULNERABLE)
	AiAgent(pBoss):clearCombatState(true)
	AiAgent(pBoss):setOblivious()

	track.spawned80 = false
	track.spawned50 = false
	track.spawned20 = false
	track.hkFightActive = false
	track.hkActivated = false
	track.deadGuards = 0
	track.corpseIdx = 0

	-- Destroy every add and every risen guard.
	local oldGuards = track.eventGuards[6] or {}

	for i = 1, #oldGuards do
		local pGuard = getSceneObject(oldGuards[i])

		if (pGuard ~= nil) then
			SceneObject(pGuard):destroyObjectFromWorld()
		end
	end

	track.eventGuards[6] = {}

	for i = 1, #track.risenGuards do
		local pR = getSceneObject(track.risenGuards[i])

		if (pR ~= nil) then
			SceneObject(pR):destroyObjectFromWorld()
		end
	end

	track.risenGuards = {}

	for i = 1, #track.squad do
		local pS = getSceneObject(track.squad[i])

		if (pS ~= nil) then
			SceneObject(pS):destroyObjectFromWorld()
		end
	end

	track.squad = {}
	track.squadDead = {}

	self:destroyIDList(track.corpses)
	track.corpses = {}

	-- Rebuild the entire 14-mob squad wall; group must clear all 14 again.
	self:spawnHkSquadWall(session)
	track.eventActive[6] = false
end

function VolcanoBattlefield:eventHkBossDied(pBoss, pKiller)
	if (readData("volcanoBattlefield:active") ~= 1) then
		return 1
	end

	local session = self:currentSession()

	-- 15% house loot omitted -- player_mustafar_house_lg.iff is a building with
	-- no deed in this tree; no substitution (header). Contrast event three.
	-- Message lives in winTrial (valley shape).
	self:eventDefeated(session, 6)
	return 1
end

--------------------------------------------------------------------------------
-- Win / timeout / reset
--------------------------------------------------------------------------------

function VolcanoBattlefield:winTrial(session)
	if (readData("volcanoBattlefield:won") == 1) then
		return
	end

	writeData("volcanoBattlefield:won", 1)
	self:broadcastMessage("HK-47 has been destroyed.")
	self:broadcastMusic(self.victoryMusic)

	-- Exit NPC: som_volcano_autopilot on the ground at the live YT landing site.
	-- Runtime radial replaces the object's menu entirely and does not survive a
	-- server restart -- fine, because the arena is torn down at cleanout
	-- (demolition_pack.lua SUBSTITUTION E). Smoke plume / takeoff / yt_controller
	-- self-destruct omitted with the ship (header).
	local z = getWorldFloor(self.ytLandingX, self.ytLandingY, "mustafar")
	local pPilot = spawnMobile("mustafar", "som_volcano_autopilot", 0, self.ytLandingX, z, self.ytLandingY, 0, 0)

	if (pPilot ~= nil) then
		local track = self:getTrack(session)
		table.insert(track.props, SceneObject(pPilot):getObjectID())
		SceneObject(pPilot):setObjectMenuComponent("VolcanoAutopilotMenuComponent")
	end

	self:forEachPlayerInside(function(pPlayer)
		if (self.victoryBadge ~= nil and _G[self.victoryBadge] ~= nil) then
			local pGhost = CreatureObject(pPlayer):getPlayerObject()

			if (pGhost ~= nil) then
				PlayerObject(pGhost):awardBadge(_G[self.victoryBadge])
			end
		end

		if (storyArcChaptersScreenPlay ~= nil and storyArcChaptersScreenPlay.onVolcanoVictory ~= nil) then
			storyArcChaptersScreenPlay:onVolcanoVictory(pPlayer)
		end
	end)

	createEvent(self.cleanOut * 1000, "VolcanoBattlefield", "cleanOutTimer", nil, tostring(session))
end

function VolcanoBattlefield:cleanOutTimer(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	self:resetArena("clean-out")
end

function VolcanoBattlefield:onTimeout(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	self:broadcastMessage("The volcano assault has timed out.") -- live instance timeout; no stf
	self:resetArena("timeout")
end

function VolcanoBattlefield:resetArena(reason)
	if (readData("volcanoBattlefield:active") ~= 1) then
		return
	end

	local session = self:currentSession()
	local track = self.tracked[session]

	-- Clear active first so sendToExit's "last player left" path cannot re-enter.
	writeData("volcanoBattlefield:active", 0)

	self:ejectEveryone()

	if (track ~= nil) then
		self:destroyIDList(track.army)
		self:destroyIDList(track.guards)
		self:destroyIDList(track.corpses)
		self:destroyIDList(track.props)

		for i = 1, #track.areas do
			local pArea = getSceneObject(track.areas[i])

			if (pArea ~= nil) then
				local areaID = track.areas[i]
				deleteStringData(areaID .. ":volcanoEvent")
				deleteData(areaID .. ":volcanoSession")
				SceneObject(pArea):destroyObjectFromWorld()
			end
		end
	end

	self.tracked[session] = nil

	-- Bump session so in-flight createEvent callbacks find a stale id and bail.
	self:clearSessionKeys()
	writeData("volcanoBattlefield:session", session + 1)
end

function VolcanoBattlefield:destroyIDList(list)
	if (list == nil) then
		return
	end

	for i = 1, #list do
		local pObj = getSceneObject(list[i])

		if (pObj ~= nil) then
			SceneObject(pObj):destroyObjectFromWorld()
		end
	end
end

--------------------------------------------------------------------------------
-- Exit radial  --  VolcanoAutopilotMenuComponent
--------------------------------------------------------------------------------

-- 20 is RadialOptions.h ITEM_USE; 3 is the callback value every existing Lua
-- menu component in this repo passes. Runtime setObjectMenuComponent REPLACES
-- the object's menu entirely and does not survive a server restart -- fine,
-- because resetArena tears the arena down at cleanout (demolition_pack.lua
-- SUBSTITUTION E).
VolcanoAutopilotMenuComponent = {}

function VolcanoAutopilotMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pMenuResponse == nil or pPlayer == nil) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "Leave the Volcano")
end

function VolcanoAutopilotMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (VolcanoBattlefield ~= nil) then
		VolcanoBattlefield:sendToExit(pPlayer)
	end

	return 0
end
