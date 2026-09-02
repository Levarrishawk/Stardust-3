--[[
Valley Battlefield  --  SOE's mustafar_droid_army instance

WHAT THIS IS

Live ran this as an 8-player outdoor instance (instance_datatable.tab:12):
max_players 8, time_limit 3600 s, daily lockout, key mustafar_droid_army.
An HK-47 droid army marches on a Mustafarian mining camp over eleven waves;
players hold the line until the Forward Commander dies.

Core3 has no instance system for outdoor areas, so this is one off-map arena
at (600, -1600) on mustafar, one session at a time, entered and left by
teleport -- the same model mustafar_instances.lua uses for the six SOE dungeon
pools. Placement evidence is in scratch/PLACEMENT.md; do not move it.

COORDINATE TRANSFORM

Live's valley_event_data.tab rows are offsets from the controller at
374.501, 6.52941, 282.793, in SOE axis order locx, locy(HEIGHT), locz.
This repo's Lua order is x, z(HEIGHT), y. So:

	repo x = 600  + locx
	repo y = -1600 + locz
	repo z = getWorldFloor(x, y, "mustafar")   -- always resolved, never hardcoded

Live's height offsets (locy) are DROPPED on every row. The chosen band is dead
flat at -5.00 m (162 coarse samples + two 81-sample fine grids, spread 0.000);
applying live's locy values would leave the upper camp and its 22 fences
floating twelve metres in the air. Everything is ground-placed.

YAW

The yaw column is DEGREES. spawnMobile takes heading in degrees -- pass
straight through. spawnSceneObject takes a quaternion:
	local r = math.rad(yaw) / 2
	ow = math.cos(r), ox = 0, oy = math.sin(r), oz = 0
(mustafar_dungeon_population.lua:25-37).

DELIBERATE DIVERGENCE: live ignores the yaw column on creature rows entirely
(the creature branch never calls setYaw); miner scripts re-apply -70 at deploy.
We pass the authored yaw on every row. For the miners that lands where live
lands. For Foreman Koseyet it means he faces -133 here and 0 in live. Cosmetic.

SCOPED OMISSIONS / SUBSTITUTIONS

- Demo-pack radial (pick up / plant charge / detonator) is round F1(d), not
  built here. The two packs still place as props at stage 1; they have no
  radial yet. Stated, not silently skipped, and no fake radial is stubbed.

- Generator hate-on-tangible: live's 40 m trigger volume adds 1 hate to any
  isArmy droid on the generator (power_generator.java:56-58). Core3 AI cannot
  hold hate on a tangible, so the effect is reproduced directly: every 5 s,
  living tracked army mobs within 40 m deal 100 damage each via
  setConditionDamage. Port constant, not a live number -- live's droid DPS
  against a 65000 HP object is not recoverable from source. One droid alone
  needs 3250 s (longer than the instance); five need ~650 s.

- Live's two-band damage visuals (power_generator.java:76-102) are not ported
  -- no Lua hook for damage taken by a tangible in this tree. Live's lower
  band also plays nothing (the < fire branch computes a location and discards
  it), so half of what is being skipped never worked anyway.

- EVERY morale buff is omitted, because all of them are buffs and this tree has
  no Lua buff API. CreatureObject::addBuff takes a Buff object, Buff has no
  DirectorManager registration, and there is no way to construct one from Lua
  (reunite_shard.lua:192-196). Three live calls fall to this:

    winTrial          buff.applyBuff(player, "high_morale", 3600)
                      (valley_event_manager.java:323)
    commanderDied     debuffDroidArmy -- low_morale onto the army,
                      high_morale onto players and miners (:206-228)
    generatorDestroyed  debufMiners, 10 s later -- high_morale onto the army,
                      low_morale onto players, high_morale stripped off the
                      miners (:229-253, :261)

  All three were read in full before being dropped. Every one of them is a
  buff swap and nothing else: no health change, no stat change, no spawn, no
  message. So the omission costs the morale swing and costs nothing else, and
  there is no honest stand-in to write. Do not invent one -- an earlier draft
  of this file halved miner health here, which live never does.

- redirectArmy (valley_event_manager.java:270-300) re-paths the whole army
  through player_exit to end_point. It is DEAD CODE in live: the method is
  defined and never called from anywhere in the mustafar_trials tree
  (checked by grep across the whole tree). Deliberately not ported.

- Stage-1 mining leaders auto-deploy here. Live gated them on a conversation
  (som_battlefield_miner_leader); no conversation file and no .stf ship in
  this tree. Stage -1 leaders already autoDeployed in live. Divergence stated.

- Mining-droid radial reactivation is gated on class_engineering_phase2_novice
  + a deactivated scriptvar that nothing ever sets -- droids always auto-start.
  Port the auto-start; skip the dead radial.

- End-point monitor: object/tangible/ground_spawning/patrol_waypoint.iff is
  named in live but is not registered as a spawnable server template in this
  tree (checked; only mentioned as comments in dungeon tables). Leak scan
  runs from the pure coordinate (405, -1794) -- cleaner than inventing a
  marker prop.

- Commander agro-link: live calls ai_lib.establishAgroLink on the six elite
  guards. Core3 has no equivalent binding. Effect is reproduced with
  DEFENDERADDED observers: commander combat pulls guards onto the same
  defender, and vice versa.

- mustafar_miner loot group does not exist in this tree; Foreman Koseyet ships
  lootGroups = {}.
--]]

ValleyBattlefield = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "ValleyBattlefield",

	anchorX = 600,
	anchorY = -1600,

	-- live instance_datatable.tab:12 enter -79,12,-152 -> offsets, so anchor-relative
	entryX = 521,          -- 600 + (-79)
	entryY = -1752,        -- -1600 + (-152)

	-- live exit_one 541,155,-160,mustafar -> a REAL Mustafar world coordinate,
	-- 10.8 m from Chapter Three 01's scout post. This used to depend on a 60 m
	-- exemption inside mustafar_boundaries:notifySpawnAreaSe. That exemption was a
	-- one-way door out of the map and round G(d) deleted it; the exit point is free
	-- ground now because Se0/Se1/Se2 were moved instead. Nearest wall is Se1 at
	-- (825,-300) r256, 60.6 m away.
	exitX = 541,
	exitY = -160,

	maxPlayers = 8,        -- live max_players
	entryRange = 60,       -- group members within this of the caller come along
	timeLimit = 3600,      -- live time_limit, seconds
	waveDelay = 150,       -- trial.java:147 BATTLEFIELD_WAVE_DELAY
	rezDelay = 18,         -- trial.java:148 BATTLEFIELD_COMM_REZ_DELAY
	winPoll = 60,          -- validateDungeon re-arm, LIVE-VALLEY §5.1
	cleanOut = 300,        -- post-victory loot window, LIVE-VALLEY §5.1
	generatorHp = 65000,   -- trial.java:212 HP_BATTLEFIELD_GENERATOR
	generatorRange = 40,   -- power_generator.java:16 VOLUME_RANGE
	leakRange = 18,        -- end_point_monitor.java VOLUME_RANGE
	leakRescan = 10,       -- end_point_monitor.java RESCAN
	leakLimit = 4,         -- escalation 4 == loseTrial
	rezRange = 22,         -- forward_commander.java:702
	rezMax = 3,            -- forward_commander.java:704
	-- UPPERCASE, and it has to be. DirectorManager.cpp:863-869 registers every
	-- badge as a Lua global under badge->getKey().toUpperCase(), so a lowercase
	-- key makes the _G[] guard a permanent no-op. Corrected in round G(b1);
	-- volcano_battlefield.lua:256 had the same defect.
	victoryBadge = "BDG_MUST_VICTORY_ARMY",
	victoryMusic = "sound/mus_mustafar_quest_success.snd",
	introMusic = "sound/mus_mustafar_droid_invasion_intro.snd",

	-- In-memory tracked objects keyed by session id. A restart destroys the
	-- world objects anyway, so this is the honest store.
	tracked = {},
}

registerScreenPlay("ValleyBattlefield", true)

--------------------------------------------------------------------------------
-- Waypoints and paths (LIVE-VALLEY §7.2 / §7.3)
--------------------------------------------------------------------------------

ValleyBattlefield.waypoints = {
	mining_camp = { 21.200, -18.034 },
	camp_east = { 6.091, 118.885 },
	camp_west = { -41.719, -24.499 },
	player_exit = { -105.151, -27.966 },
	droid_1 = { -35.776, -22.225 },
	droid_2 = { -13.826, -29.189 },
	droid_3 = { 32.171, 46.578 },
	droid_4 = { 22.700, 75.273 },
	east_wall = { -91.431, 150.808 },
	hk_droid_exit = { -150.912, 105.985 },
	hk_droid_exit_top = { -196.380, 170.784 },
	hk_droid_exit_start = { -253.152, 187.599 },
	west_approach = { -155.840, -20.701 },
	western_flats = { -264.568, 27.328 },
	center_line = { -93.324, 54.671 },
	top_camp_2 = { -76.082, -156.699 },
	top_camp_0 = { -124.504, -124.095 },
	top_camp_1 = { -144.762, -119.817 },
	end_point = { -196.749, -189.703 },
	droid_exit_bridge = { -222.709, 175.079 },
	droid_exit_ramp = { -186.290, 143.862 },
	droid_east_bridge = { -123.790, 130.058 },
	east_camp_bridge = { -36.665, 135.346 },
	east_approach_bridge = { 14.304, 30.725 },
	exit_west_bridge = { -230.610, 87.441 },
	player_exit_ramp = { -103.648, -60.514 },
}

-- Repeated entries are deliberate. Live walks the list in order, so those
-- droids double back. Do not de-duplicate.
ValleyBattlefield.paths = {
	[0] = { "hk_droid_exit_start", "droid_exit_bridge", "hk_droid_exit_top", "droid_exit_ramp", "hk_droid_exit", "droid_east_bridge", "east_wall", "east_camp_bridge", "camp_east", "east_approach_bridge", "mining_camp", "player_exit", "player_exit_ramp", "top_camp_0", "end_point" },
	[1] = { "hk_droid_exit_start", "droid_exit_bridge", "hk_droid_exit_top", "droid_exit_ramp", "hk_droid_exit", "droid_east_bridge", "east_wall", "center_line", "player_exit", "camp_west", "mining_camp", "player_exit", "top_camp_1", "end_point" },
	[2] = { "hk_droid_exit_start", "droid_exit_bridge", "hk_droid_exit_top", "droid_exit_bridge", "hk_droid_exit", "exit_west_bridge", "west_approach", "player_exit", "camp_west", "mining_camp", "player_exit", "top_camp_1", "end_point" },
	[3] = { "hk_droid_exit_start", "droid_exit_bridge", "hk_droid_exit_top", "droid_exit_bridge", "hk_droid_exit", "exit_west_bridge", "west_approach", "center_line", "east_wall", "camp_east", "east_approach_bridge", "mining_camp", "player_exit", "top_camp_1", "end_point" },
	[4] = { "hk_droid_exit_start", "droid_exit_bridge", "hk_droid_exit_top", "exit_west_bridge", "western_flats", "west_approach", "player_exit", "camp_west", "mining_camp", "player_exit", "top_camp_2", "end_point" },
	[5] = { "hk_droid_exit_start", "droid_exit_bridge", "hk_droid_exit_top", "exit_west_bridge", "western_flats", "center_line", "camp_east", "east_approach_bridge", "mining_camp", "player_exit", "top_camp_0", "end_point" },
	[6] = { "western_flats", "center_line", "camp_west", "mining_camp", "player_exit", "top_camp_0", "end_point" },
	[7] = { "east_wall", "camp_east", "east_approach_bridge", "mining_camp", "player_exit", "top_camp_1", "end_point" },
	[8] = { "western_flats", "player_exit", "mining_camp", "player_exit", "top_camp_0", "end_point" },
	[9] = { "east_wall", "center_line", "west_approach", "player_exit", "mining_camp", "player_exit", "top_camp_0", "end_point" },
	[10] = { "west_approach", "mining_camp", "player_exit", "top_camp_1", "end_point" },
	[11] = { "mining_camp", "player_exit", "top_camp_0", "end_point" },
	[12] = { "mining_camp", "player_exit", "top_camp_2", "end_point" },
	[13] = { "west_approach", "mining_camp", "top_camp_0", "end_point" },
}

-- Six assault spawn anchors, offsets from the arena anchor (LIVE-VALLEY §3.5).
ValleyBattlefield.anchors = {
	A = { -253, 201 },
	B = { -294, 160 },
	C = { -148, 181 },
	D = { 41, 104 },
	E = { 1, 125 },
	F = { -268, 53 },
}

-- Stages 2-11: three spawns each. path index as given.
ValleyBattlefield.waves = {
	[2] = {
		{ template = "som_battlefield_droid_squad_leader", anchor = "A", path = 1 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "B", path = 8 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "C", path = 7 },
	},
	[3] = {
		{ template = "som_battlefield_ak_1a", anchor = "A", path = 2 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "C", path = 7 },
		{ template = "som_battlefield_ak_3", anchor = "B", path = 7 },
	},
	[4] = {
		{ template = "som_battlefield_droid_squad_leader", anchor = "B", path = 5 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "C", path = 6 },
		{ template = "som_battlefield_ak_1a", anchor = "A", path = 8 },
	},
	[5] = {
		{ template = "som_battlefield_ak_1a", anchor = "C", path = 7 },
		{ template = "som_battlefield_gk_5", anchor = "A", path = 4 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "B", path = 2 },
	},
	[6] = {
		{ template = "som_battlefield_droid_squad_leader", anchor = "A", path = 0 },
		{ template = "som_battlefield_gk_5", anchor = "B", path = 8 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "C", path = 7 },
	},
	[7] = {
		{ template = "som_battlefield_droid_squad_leader", anchor = "C", path = 5 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "B", path = 6 },
		{ template = "som_battlefield_ak_1a", anchor = "A", path = 8 },
	},
	[8] = {
		{ template = "som_battlefield_ak_3", anchor = "C", path = 7 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "A", path = 1 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "B", path = 8 },
	},
	[9] = {
		{ template = "som_battlefield_gk_5", anchor = "C", path = 7 },
		{ template = "som_battlefield_ak_1a", anchor = "A", path = 4 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "B", path = 2 },
	},
	[10] = {
		{ template = "som_battlefield_commander", anchor = "D", path = 12 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "D", path = 12 },
		{ template = "som_battlefield_ak_1a", anchor = "E", path = 11 },
	},
	[11] = {
		{ template = "som_battlefield_droid_squad_leader", anchor = "E", path = 12 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "F", path = 10 },
		{ template = "som_battlefield_droid_squad_leader", anchor = "F", path = 13 },
	},
}

ValleyBattlefield.stage1Creatures = {
	{ template = "som_battlefield_mining_droid", locx = 11, locz = 2, yaw = -70, role = "mining_droid" },
	{ template = "som_battlefield_mining_droid", locx = 10, locz = 4, yaw = -70, role = "mining_droid" },
	{ template = "som_battlefield_mining_droid", locx = 8, locz = -2, yaw = -70, role = "mining_droid" },
	{ template = "som_battlefield_mining_droid", locx = 6, locz = -5, yaw = -70, role = "mining_droid" },
	{ template = "som_battlefield_mining_droid", locx = 3, locz = -8, yaw = -70, role = "mining_droid" },
	{ template = "som_battlefield_mining_leader", locx = 2, locz = -3, yaw = -70, role = "mining_leader", autoDeploy = true },
	{ template = "som_battlefield_mining_leader", locx = 4, locz = 3, yaw = -70, role = "mining_leader", autoDeploy = true },
	{ template = "som_battlefield_foreman_koseyet", locx = -81, locz = -131, yaw = -133, role = "foreman" },
}

ValleyBattlefield.stage1Props = {
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_pack.iff", locx = -3, locz = 2, yaw = 0, isDemoPack = true },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_pack.iff", locx = -4, locz = 0, yaw = 0, isDemoPack = true },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/power_generator.iff", locx = 26, locz = -22, yaw = 25, isGenerator = true },
	{ template = "object/tangible/collection/rare_heavy_oppressor_flame_thrower.iff", locx = 10, locz = -35, yaw = 0 },
	-- lower camp
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = 17.7881, locz = -2.17578, yaw = 129.671 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = 26.9551, locz = 4.29785, yaw = 0 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = 37.3062, locz = -0.771973, yaw = -140.948 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = 40.063, locz = -13.8052, yaw = -64.7442 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = 33.2681, locz = -28.4541, yaw = -64.7442 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = 21.042, locz = -34.5688, yaw = 8.02144 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = 3.76514, locz = -30.873, yaw = 22.9183 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = 4.62305, locz = -21.707, yaw = 119.931 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_bunker.iff", locx = 28.457, locz = -5.55811, yaw = -122.613 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_cooling_unit.iff", locx = 17.7529, locz = -24.376, yaw = -153.162 },
	-- upper camp
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -107.007, locz = -186.509, yaw = -9.16729 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -122.785, locz = -186.548, yaw = 8.02144 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -139.671, locz = -183.098, yaw = 21.7724 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -145.455, locz = -180.295, yaw = 32.0857 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -156.384, locz = -176.184, yaw = 14.324 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -167.22, locz = -171.933, yaw = 38.9611 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -177.687, locz = -165.591, yaw = 28.6479 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -188.113, locz = -159.809, yaw = 28.6479 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -193.501, locz = -147.556, yaw = -61.8795 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -187.007, locz = -132.461, yaw = -71.0468 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -176.378, locz = -126.193, yaw = 14.324 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -164.898, locz = -135.306, yaw = 63.0253 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -157.255, locz = -142.249, yaw = 0 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -141.812, locz = -142.903, yaw = 0 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -129.958, locz = -140.175, yaw = -18.9076 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_16m.iff", locx = -115.585, locz = -142.313, yaw = 36.6693 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -108.162, locz = -151.486, yaw = -102.559 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -105.096, locz = -163.364, yaw = -102.559 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_fence_8m.iff", locx = -102.128, locz = -175.045, yaw = -102.559 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_bunker.iff", locx = -116.314, locz = -178.987, yaw = 13.1781 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_bunker.iff", locx = -138.045, locz = -154.052, yaw = -122.613 },
	{ template = "object/tangible/dungeon/mustafar/valley_battlefield/must_bandit_bunker.iff", locx = -152.869, locz = -169.947, yaw = 38.3881 },
}

ValleyBattlefield.stageMinus1Leaders = {
	{ locx = -98, locz = -150 },
	{ locx = -100, locz = -138 },
	{ locx = -115, locz = -125 },
	{ locx = -139, locz = -125 },
	{ locx = -162, locz = -118 },
	{ locx = -198, locz = -125 },
	{ locx = -175, locz = -116 },
	{ locx = -173, locz = -155 },
	{ locx = -134, locz = -171 },
}

ValleyBattlefield.minerBoxOffsets = {
	{ 2, 2 },
	{ 2, -2 },
	{ -2, 2 },
	{ -2, -2 },
}

ValleyBattlefield.droidWaypointNames = {
	"droid_1", "droid_2", "droid_3", "droid_4",
	"droid_exit_bridge", "droid_exit_ramp", "droid_east_bridge",
}

--------------------------------------------------------------------------------
-- Boot
--------------------------------------------------------------------------------

function ValleyBattlefield:start()
	if (not isZoneEnabled("mustafar")) then
		return
	end

	-- A crash or restart mid-session leaves active = 1 forever without this.
	self:clearSessionKeys()
	self.tracked = {}
end

function ValleyBattlefield:clearSessionKeys()
	deleteData("valleyBattlefield:active")
	deleteData("valleyBattlefield:session")
	deleteData("valleyBattlefield:owner")
	deleteData("valleyBattlefield:stage")
	deleteData("valleyBattlefield:startedAt")
	deleteData("valleyBattlefield:generatorID")
	deleteData("valleyBattlefield:leaks")
	deleteData("valleyBattlefield:commanderDead")
	deleteData("valleyBattlefield:won")
end

function ValleyBattlefield:currentSession()
	return readData("valleyBattlefield:session")
end

function ValleyBattlefield:isSessionCurrent(session)
	return readData("valleyBattlefield:active") == 1 and self:currentSession() == tonumber(session)
end

function ValleyBattlefield:getTrack(session)
	session = tonumber(session)

	if (self.tracked[session] == nil) then
		self.tracked[session] = {
			army = {},
			allies = {},
			props = {},
			players = {},
			corpses = {},
			guards = {},
			commanderID = 0,
			paths = {},
			rezzable = {},
			demo = {},
		}
	end

	return self.tracked[session]
end

--------------------------------------------------------------------------------
-- Accessors for the demolition tool
--
-- demolition_pack.lua goes through these three rather than reaching into
-- self.tracked, so the session bookkeeping stays owned by one file.
--------------------------------------------------------------------------------

-- One flat list of every object id the arena is tracking that a blast could
-- reach: the droid army, the allies fighting for you, and the players. This
-- stands in for live's getObjectsInRange, which Core3 Lua has no equivalent of.
-- Range and liveness filtering is the caller's job. Returns nil when there is no
-- live session -- a charge fired outside one hits nobody.
function ValleyBattlefield:getBlastCandidates()
	if (readData("valleyBattlefield:active") ~= 1) then
		return nil
	end

	local track = self.tracked[self:currentSession()]

	if (track == nil) then
		return nil
	end

	local out = {}

	for i = 1, #track.army do
		table.insert(out, track.army[i])
	end

	for i = 1, #track.allies do
		table.insert(out, track.allies[i])
	end

	for i = 1, #track.players do
		table.insert(out, track.players[i])
	end

	return out
end

-- Stands in for live's utils.verifyLocationBasedDestructionAnchor. Live anchors
-- each item at the spot it was made; this anchors on the arena origin instead.
-- The difference cannot matter: the whole arena is well under 500 m across, so
-- anything inside the fight passes either way, and the only thing this has to
-- catch is demo gear carried out of it.
function ValleyBattlefield:isNearArena(pPlayer, range)
	if (pPlayer == nil) then
		return false
	end

	local dx = SceneObject(pPlayer):getWorldPositionX() - self.anchorX
	local dy = SceneObject(pPlayer):getWorldPositionY() - self.anchorY

	return (dx * dx + dy * dy) <= (range * range)
end

-- Demo gear made mid-fight joins the session's demo list so resetArena reaps it.
-- That reaping is what makes the runtime-only radial safe -- see SUBSTITUTION E
-- in demolition_pack.lua. Silently ignores calls with no live session rather
-- than calling getTrack, which would build a phantom track for a dead session.
function ValleyBattlefield:trackDemoObject(oid)
	if (oid == nil or oid == 0) then
		return
	end

	local track = self.tracked[self:currentSession()]

	if (track == nil or track.demo == nil) then
		return
	end

	table.insert(track.demo, oid)
end

--------------------------------------------------------------------------------
-- Coordinate helpers
--------------------------------------------------------------------------------

function ValleyBattlefield:worldXY(locx, locz)
	return self.anchorX + locx, self.anchorY + locz
end

function ValleyBattlefield:waypointWorld(name)
	local wp = self.waypoints[name]

	if (wp == nil) then
		return nil
	end

	local x, y = self:worldXY(wp[1], wp[2])
	local z = getWorldFloor(x, y, "mustafar")

	return x, z, y
end

function ValleyBattlefield:yawQuaternion(yaw)
	local r = math.rad(yaw) / 2
	return math.cos(r), 0, math.sin(r), 0
end

function ValleyBattlefield:copyPath(pathIndex)
	local src = self.paths[pathIndex]
	local out = {}

	if (src == nil) then
		return out
	end

	for i = 1, #src do
		out[i] = src[i]
	end

	return out
end

function ValleyBattlefield:shuffleCopy(list)
	local out = {}

	for i = 1, #list do
		out[i] = list[i]
	end

	for i = #out, 2, -1 do
		local j = getRandomNumber(i)
		out[i], out[j] = out[j], out[i]
	end

	return out
end

--------------------------------------------------------------------------------
-- Messaging / players inside
--------------------------------------------------------------------------------

function ValleyBattlefield:forEachPlayerInside(callback)
	local session = self:currentSession()
	local track = self.tracked[session]

	if (track == nil) then
		return
	end

	for i = 1, #track.players do
		local playerID = track.players[i]
		local pPlayer = getSceneObject(playerID)

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature() and readData(playerID .. ":valleyBattlefield") == 1) then
			callback(pPlayer)
		end
	end
end

function ValleyBattlefield:broadcastMessage(text)
	self:forEachPlayerInside(function(pPlayer)
		CreatureObject(pPlayer):sendSystemMessage(text)
	end)
end

function ValleyBattlefield:broadcastMusic(sound)
	self:forEachPlayerInside(function(pPlayer)
		CreatureObject(pPlayer):playMusicMessage(sound)
	end)
end

function ValleyBattlefield:countPlayersInside()
	local count = 0

	self:forEachPlayerInside(function(pPlayer)
		count = count + 1
	end)

	return count
end

function ValleyBattlefield:trackPlayer(session, pPlayer)
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

function ValleyBattlefield:enter(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (storyArcChaptersScreenPlay == nil) then
		printLuaError("ValleyBattlefield: story_arc_chapters.lua is not loaded; refusing entry")
		return
	end

	if (not storyArcChaptersScreenPlay:mayEnterValleyBattlefield(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:not_ready")
		return
	end

	if (readData("valleyBattlefield:active") == 1) then
		local ownerID = readData("valleyBattlefield:owner")
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

		writeData("valleyBattlefield:session", session)
		writeData("valleyBattlefield:active", 1)
		writeData("valleyBattlefield:owner", SceneObject(pPlayer):getObjectID())
		writeData("valleyBattlefield:startedAt", os.time())
		writeData("valleyBattlefield:stage", 0)
		writeData("valleyBattlefield:leaks", 0)
		writeData("valleyBattlefield:commanderDead", 0)
		writeData("valleyBattlefield:won", 0)
		writeData("valleyBattlefield:generatorID", 0)

		self.tracked[session] = nil
		self:getTrack(session)

		self:runStage1(session)
		createEvent(self.waveDelay * 1000, "ValleyBattlefield", "spawnNextStage", nil, tostring(session))
		createEvent(self.timeLimit * 1000, "ValleyBattlefield", "onTimeout", nil, tostring(session))
		createEvent(5000, "ValleyBattlefield", "generatorTick", nil, tostring(session))
		createEvent(4000, "ValleyBattlefield", "pathWalker", nil, tostring(session))
	end

	local party = self:buildParty(pPlayer)
	local session = self:currentSession()

	for i = 1, #party do
		self:teleportIn(party[i], session)
	end
end

function ValleyBattlefield:buildParty(pPlayer)
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

function ValleyBattlefield:teleportIn(pMember, session)
	if (pMember == nil) then
		return
	end

	if (CreatureObject(pMember):isRidingMount()) then
		CreatureObject(pMember):dismount()
	end

	local id = SceneObject(pMember):getObjectID()

	writeData(id .. ":valleyBattlefield", 1)
	self:trackPlayer(session, pMember)

	local height = getWorldFloor(self.entryX, self.entryY, "mustafar")

	SceneObject(pMember):switchZone("mustafar", self.entryX, height, self.entryY, 0)
end

--------------------------------------------------------------------------------
-- Exit
--------------------------------------------------------------------------------

function ValleyBattlefield:sendToExit(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	-- An eject is itself a switchZone, which can re-enter this path. The flag
	-- makes the second pass a no-op (mustafar_instances.lua:708-746).
	if (readData(playerID .. ":valleyBattlefieldOut") == 1) then
		return
	end

	writeData(playerID .. ":valleyBattlefieldOut", 1)

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local height = getWorldFloor(self.exitX, self.exitY, "mustafar")

	SceneObject(pPlayer):switchZone("mustafar", self.exitX, height, self.exitY, 0)

	deleteData(playerID .. ":valleyBattlefield")
	createEvent(2000, "ValleyBattlefield", "clearEjecting", pPlayer, "")

	if (self:countPlayersInside() == 0 and readData("valleyBattlefield:active") == 1) then
		self:resetArena("last player left")
	end
end

function ValleyBattlefield:clearEjecting(pPlayer)
	if (pPlayer ~= nil) then
		deleteData(SceneObject(pPlayer):getObjectID() .. ":valleyBattlefieldOut")
	end
end

function ValleyBattlefield:ejectEveryone()
	local toEject = {}

	self:forEachPlayerInside(function(pPlayer)
		table.insert(toEject, pPlayer)
	end)

	for i = 1, #toEject do
		self:sendToExit(toEject[i])
	end
end

--------------------------------------------------------------------------------
-- Stage 1
--------------------------------------------------------------------------------

function ValleyBattlefield:runStage1(session)
	writeData("valleyBattlefield:stage", 1)

	for i = 1, #self.stage1Creatures do
		local row = self.stage1Creatures[i]
		local x, y = self:worldXY(row.locx, row.locz)
		local z = getWorldFloor(x, y, "mustafar")
		local pMob = spawnMobile("mustafar", row.template, 0, x, z, y, row.yaw, 0)

		if (pMob ~= nil) then
			local track = self:getTrack(session)

			table.insert(track.allies, SceneObject(pMob):getObjectID())

			if (row.role == "mining_droid") then
				self:setupMiningDroid(pMob, session)
			elseif (row.role == "mining_leader") then
				self:setupMiningLeader(pMob, session, row.autoDeploy == true)
			elseif (row.role == "foreman") then
				createObserver(DAMAGERECEIVED, "ValleyBattlefield", "allyDamaged", pMob)
			end
		end
	end

	for i = 1, #self.stage1Props do
		local row = self.stage1Props[i]
		local x, y = self:worldXY(row.locx, row.locz)
		local z = getWorldFloor(x, y, "mustafar")
		local ow, ox, oy, oz = self:yawQuaternion(row.yaw)
		local pObj = spawnSceneObject("mustafar", row.template, x, z, y, 0, ow, ox, oy, oz)

		if (pObj ~= nil) then
			local track = self:getTrack(session)
			local oid = SceneObject(pObj):getObjectID()

			if (row.isGenerator) then
				table.insert(track.props, oid)
				TangibleObject(pObj):setMaxCondition(self.generatorHp)
				TangibleObject(pObj):setConditionDamage(0)
				writeData("valleyBattlefield:generatorID", oid)
				createObserver(OBJECTDESTRUCTION, "ValleyBattlefield", "generatorDestroyed", pObj)
				createObserver(OBJECTDISABLED, "ValleyBattlefield", "generatorDestroyed", pObj)
			elseif (row.isDemoPack and DemolitionPack ~= nil) then
				-- track.demo, not track.props: the demo list is the one resetArena
				-- clears writeData keys for, and these rows carry three of them.
				-- Object ids get reused, so a pack left in props would leave
				-- demoInWorld/demoMines/demoSession behind on a recycled id.
				table.insert(track.demo, oid)
				writeData(oid .. ":demoInWorld", 1)
				writeData(oid .. ":demoMines", DemolitionPack.startingMines)
				writeData(oid .. ":demoSession", session)
				SceneObject(pObj):setObjectMenuComponent("SomDemoPackMenuComponent")
			else
				table.insert(track.props, oid)

				if (row.isDemoPack) then
					printLuaError("ValleyBattlefield: DemolitionPack is not loaded; demo pack radial not attached")
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Allies
--------------------------------------------------------------------------------

function ValleyBattlefield:setupMiningDroid(pMob, session)
	TangibleObject(pMob):setOptionBit(INVULNERABLE)
	AiAgent(pMob):addObjectFlag(AI_STATIONARY)
	AiAgent(pMob):setAITemplate()

	createEvent(8000, "ValleyBattlefield", "startMiningDroid", pMob, tostring(session))
end

function ValleyBattlefield:startMiningDroid(pMob, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pMob == nil or CreatureObject(pMob):isDead()) then
		return
	end

	TangibleObject(pMob):clearOptionBit(INVULNERABLE)
	AiAgent(pMob):removeObjectFlag(AI_STATIONARY)
	AiAgent(pMob):setAITemplate()

	local track = self:getTrack(session)
	local oid = SceneObject(pMob):getObjectID()
	local path = self:shuffleCopy(self.droidWaypointNames)

	track.paths[oid] = { list = path, index = 1, kind = "ally" }
end

function ValleyBattlefield:setupMiningLeader(pMob, session, autoDeploy)
	TangibleObject(pMob):setOptionBit(INVULNERABLE)
	AiAgent(pMob):addObjectFlag(AI_STATIONARY)
	AiAgent(pMob):setAITemplate()
	createObserver(DAMAGERECEIVED, "ValleyBattlefield", "allyDamaged", pMob)

	if (autoDeploy) then
		createEvent(5000, "ValleyBattlefield", "deployMinerForces", pMob, tostring(session))
	end
end

function ValleyBattlefield:deployMinerForces(pMob, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pMob == nil or CreatureObject(pMob):isDead()) then
		return
	end

	TangibleObject(pMob):clearOptionBit(INVULNERABLE)
	AiAgent(pMob):removeObjectFlag(AI_STATIONARY)
	AiAgent(pMob):setAITemplate()

	local lx = SceneObject(pMob):getPositionX()
	local ly = SceneObject(pMob):getPositionY()
	local track = self:getTrack(session)

	for i = 1, #self.minerBoxOffsets do
		local off = self.minerBoxOffsets[i]
		local x = lx + off[1]
		local y = ly + off[2]
		local z = getWorldFloor(x, y, "mustafar")
		local pMiner = spawnMobile("mustafar", "som_battlefield_miner", 0, x, z, y, -70, 0)

		if (pMiner ~= nil) then
			table.insert(track.allies, SceneObject(pMiner):getObjectID())
			createObserver(DAMAGERECEIVED, "ValleyBattlefield", "allyDamaged", pMiner)
			AiAgent(pMiner):setFollowObject(pMob)
		end
	end
end

-- A player who shoots a miner heals it. Anti-grief design; load-bearing.
function ValleyBattlefield:allyDamaged(pAlly, pAttacker, damage)
	if (pAlly == nil or pAttacker == nil) then
		return 0
	end

	local isPlayer = SceneObject(pAttacker):isPlayerCreature()
	local isPet = SceneObject(pAttacker):isAiAgent() and AiAgent(pAttacker):isPet()

	if (not isPlayer and not isPet) then
		return 0
	end

	local amount = tonumber(damage) or 0

	if (amount > 0) then
		CreatureObject(pAlly):healDamage(amount, 0)
	end

	CreatureObject(pAlly):dropFromThreatMap(pAttacker)
	CreatureObject(pAlly):forcePeace()

	return 0
end

--------------------------------------------------------------------------------
-- Wave scheduler
--------------------------------------------------------------------------------

function ValleyBattlefield:spawnNextStage(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local stage = readData("valleyBattlefield:stage") + 1

	if (stage > 11) then
		return
	end

	writeData("valleyBattlefield:stage", stage)

	local wave = self.waves[stage]

	if (wave ~= nil) then
		for i = 1, #wave do
			self:spawnArmyRow(session, wave[i])
		end
	end

	if (stage == 2) then
		self:broadcastMusic(self.introMusic)
	elseif (stage == 10) then
		self:broadcastMusic(self.introMusic)
		self:broadcastMessage("The Forward Commander has arrived.")
		createEvent(self.winPoll * 1000, "ValleyBattlefield", "validateDungeon", nil, tostring(session))
	end

	if (stage < 11) then
		createEvent(self.waveDelay * 1000, "ValleyBattlefield", "spawnNextStage", nil, tostring(session))
	end
end

function ValleyBattlefield:spawnArmyRow(session, row)
	local anchor = self.anchors[row.anchor]

	if (anchor == nil) then
		return
	end

	local x, y = self:worldXY(anchor[1], anchor[2])
	local z = getWorldFloor(x, y, "mustafar")
	local pMob = spawnMobile("mustafar", row.template, 0, x, z, y, 0, 0)

	if (pMob == nil) then
		return
	end

	self:registerArmyMob(session, pMob, self:copyPath(row.path), 1, row.template == "som_battlefield_commander")

	if (row.template == "som_battlefield_droid_squad_leader") then
		for j = 0, 3 do
			createEvent((j + 2) * 1000, "ValleyBattlefield", "spawnSquadSoldier", pMob, tostring(session) .. ":" .. tostring(j))
		end
	elseif (row.template == "som_battlefield_commander") then
		createEvent(2000, "ValleyBattlefield", "spawnEliteGuards", pMob, tostring(session))
		createEvent(self.rezDelay * 1000, "ValleyBattlefield", "performRez", pMob, tostring(session))
	end
end

function ValleyBattlefield:registerArmyMob(session, pMob, pathList, pathIndex, isCommander)
	local track = self:getTrack(session)
	local oid = SceneObject(pMob):getObjectID()

	table.insert(track.army, oid)
	track.paths[oid] = { list = pathList, index = pathIndex, kind = "army" }
	track.rezzable[oid] = true

	createObserver(OBJECTDESTRUCTION, "ValleyBattlefield", "armyDestroyed", pMob)

	if (isCommander) then
		track.commanderID = oid
		createObserver(DEFENDERADDED, "ValleyBattlefield", "commanderDefenderAdded", pMob)
		createObserver(OBJECTDESTRUCTION, "ValleyBattlefield", "commanderDied", pMob)
	end
end

function ValleyBattlefield:spawnSquadSoldier(pLeader, args)
	local sep = string.find(args, ":")
	local session = tonumber(string.sub(args, 1, sep - 1))

	if (not self:isSessionCurrent(session) or pLeader == nil or CreatureObject(pLeader):isDead()) then
		return
	end

	local track = self:getTrack(session)
	local leaderID = SceneObject(pLeader):getObjectID()
	local leaderPath = track.paths[leaderID]
	local pathCopy = {}

	if (leaderPath ~= nil) then
		for i = 1, #leaderPath.list do
			pathCopy[i] = leaderPath.list[i]
		end
	end

	local x = SceneObject(pLeader):getPositionX()
	local y = SceneObject(pLeader):getPositionY()
	local z = getWorldFloor(x, y, "mustafar")
	local pSoldier = spawnMobile("mustafar", "som_battlefield_droid_soldier", 0, x, z, y, 0, 0)

	if (pSoldier == nil) then
		return
	end

	local startIndex = 1

	if (leaderPath ~= nil) then
		startIndex = leaderPath.index
	end

	self:registerArmyMob(session, pSoldier, pathCopy, startIndex, false)
end

function ValleyBattlefield:spawnEliteGuards(pCommander, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session) or pCommander == nil or CreatureObject(pCommander):isDead()) then
		return
	end

	local track = self:getTrack(session)
	local commanderID = SceneObject(pCommander):getObjectID()
	local commanderPath = track.paths[commanderID]
	local x = SceneObject(pCommander):getPositionX()
	local y = SceneObject(pCommander):getPositionY()
	local z = getWorldFloor(x, y, "mustafar")

	for i = 1, 6 do
		local pathCopy = {}

		if (commanderPath ~= nil) then
			for n = 1, #commanderPath.list do
				pathCopy[n] = commanderPath.list[n]
			end
		end

		local pGuard = spawnMobile("mustafar", "som_battlefield_elite_guard", 0, x, z, y, 0, 0)

		if (pGuard ~= nil) then
			local oid = SceneObject(pGuard):getObjectID()
			local startIndex = 1

			if (commanderPath ~= nil) then
				startIndex = commanderPath.index
			end

			table.insert(track.army, oid)
			table.insert(track.guards, oid)
			track.paths[oid] = { list = pathCopy, index = startIndex, kind = "army" }
			-- Elite guards are never rezzable -- live never marks them as corpses.
			track.rezzable[oid] = false

			createObserver(OBJECTDESTRUCTION, "ValleyBattlefield", "armyDestroyed", pGuard)
			createObserver(DEFENDERADDED, "ValleyBattlefield", "guardDefenderAdded", pGuard)
		end
	end
end

--------------------------------------------------------------------------------
-- Commander agro-link (effect of ai_lib.establishAgroLink)
--------------------------------------------------------------------------------

function ValleyBattlefield:commanderDefenderAdded(pCommander, pDefender)
	if (pCommander == nil or pDefender == nil or readData("valleyBattlefield:active") ~= 1) then
		return 0
	end

	local session = self:currentSession()
	local track = self.tracked[session]

	if (track == nil) then
		return 0
	end

	for i = 1, #track.guards do
		local pGuard = getSceneObject(track.guards[i])

		if (pGuard ~= nil and not CreatureObject(pGuard):isDead()) then
			AiAgent(pGuard):setDefender(pDefender)
		end
	end

	return 0
end

function ValleyBattlefield:guardDefenderAdded(pGuard, pDefender)
	if (pGuard == nil or pDefender == nil or readData("valleyBattlefield:active") ~= 1) then
		return 0
	end

	local session = self:currentSession()
	local track = self.tracked[session]

	if (track == nil or track.commanderID == 0) then
		return 0
	end

	local pCommander = getSceneObject(track.commanderID)

	if (pCommander ~= nil and not CreatureObject(pCommander):isDead()) then
		AiAgent(pCommander):setDefender(pDefender)
	end

	return 0
end

--------------------------------------------------------------------------------
-- Commander rez loop
--------------------------------------------------------------------------------

function ValleyBattlefield:armyDestroyed(pMob, pKiller)
	if (pMob == nil or readData("valleyBattlefield:active") ~= 1) then
		return 1
	end

	local session = self:currentSession()
	local track = self.tracked[session]

	if (track == nil) then
		return 1
	end

	local oid = SceneObject(pMob):getObjectID()
	local pathInfo = track.paths[oid]
	local remaining = {}
	local startIndex = 1

	if (pathInfo ~= nil) then
		startIndex = pathInfo.index

		for i = startIndex, #pathInfo.list do
			table.insert(remaining, pathInfo.list[i])
		end
	end

	if (track.rezzable[oid]) then
		local template = AiAgent(pMob):getCreatureTemplateName()

		table.insert(track.corpses, {
			oid = oid,
			template = template,
			x = SceneObject(pMob):getPositionX(),
			y = SceneObject(pMob):getPositionY(),
			z = SceneObject(pMob):getPositionZ(),
			path = remaining,
		})
	end

	track.paths[oid] = nil

	return 1
end

function ValleyBattlefield:commanderDied(pCommander, pKiller)
	if (readData("valleyBattlefield:active") ~= 1) then
		return 1
	end

	writeData("valleyBattlefield:commanderDead", 1)
	self:broadcastMessage("The Forward Commander has fallen.")

	-- Live's commanderDied also calls debuffDroidArmy (valley_event_manager.java
	-- :303). That is a buff swap and nothing else, so it has no port -- header.
	--
	-- bumpSession equivalent: performRez checks commanderDead / session and stops.
	return 1
end

function ValleyBattlefield:performRez(pCommander, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	if (readData("valleyBattlefield:commanderDead") == 1) then
		return
	end

	if (pCommander == nil or CreatureObject(pCommander):isDead()) then
		return
	end

	local track = self:getTrack(session)
	local cx = SceneObject(pCommander):getPositionX()
	local cy = SceneObject(pCommander):getPositionY()
	local rezCount = 0
	local stillCorpses = {}

	for i = 1, #track.corpses do
		local corpse = track.corpses[i]

		if (rezCount < self.rezMax) then
			local dx = corpse.x - cx
			local dy = corpse.y - cy
			local dist = math.sqrt(dx * dx + dy * dy)

			if (dist <= self.rezRange) then
				self:rezOneCorpse(session, corpse)
				rezCount = rezCount + 1

				local pOld = getSceneObject(corpse.oid)

				if (pOld ~= nil) then
					SceneObject(pOld):destroyObjectFromWorld()
				end
			else
				table.insert(stillCorpses, corpse)
			end
		else
			table.insert(stillCorpses, corpse)
		end
	end

	track.corpses = stillCorpses

	-- Always re-arm while the commander lives, whether or not anything revived.
	createEvent(self.rezDelay * 1000, "ValleyBattlefield", "performRez", pCommander, tostring(session))
end

function ValleyBattlefield:rezTemplateFor(deadTemplate)
	if (string.find(deadTemplate, "ak_1a") ~= nil or string.find(deadTemplate, "ak_3") ~= nil or string.find(deadTemplate, "cww") ~= nil) then
		return "som_battlefield_ak_3"
	end

	if (string.find(deadTemplate, "gk_5") ~= nil or string.find(deadTemplate, "union") ~= nil) then
		return "som_battlefield_gk_5"
	end

	return "som_battlefield_droid_soldier"
end

function ValleyBattlefield:rezOneCorpse(session, corpse)
	local template = self:rezTemplateFor(corpse.template)
	local z = getWorldFloor(corpse.x, corpse.y, "mustafar")
	local pMob = spawnMobile("mustafar", template, 0, corpse.x, z, corpse.y, 0, 0)

	if (pMob == nil) then
		return
	end

	-- Inherit the dead mob's remaining list, the way live copies patrolPoints.
	self:registerArmyMob(session, pMob, corpse.path, 1, false)
end

--------------------------------------------------------------------------------
-- Path walker
--------------------------------------------------------------------------------

function ValleyBattlefield:pathWalker(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local track = self:getTrack(session)

	self:walkList(track, track.army)
	self:walkList(track, track.allies)

	createEvent(4000, "ValleyBattlefield", "pathWalker", nil, tostring(session))
end

function ValleyBattlefield:walkList(track, idList)
	for i = 1, #idList do
		local oid = idList[i]
		local pathInfo = track.paths[oid]

		if (pathInfo ~= nil and pathInfo.index <= #pathInfo.list) then
			local pMob = getSceneObject(oid)

			if (pMob == nil or CreatureObject(pMob):isDead()) then
				track.paths[oid] = nil
			elseif (not CreatureObject(pMob):isInCombat()) then
				local name = pathInfo.list[pathInfo.index]
				local tx, tz, ty = self:waypointWorld(name)

				if (tx ~= nil) then
					local dx = SceneObject(pMob):getPositionX() - tx
					local dy = SceneObject(pMob):getPositionY() - ty
					local dist = math.sqrt(dx * dx + dy * dy)

					if (dist <= 12) then
						pathInfo.index = pathInfo.index + 1

						if (pathInfo.index > #pathInfo.list) then
							track.paths[oid] = nil
						else
							local nx, nz, ny = self:waypointWorld(pathInfo.list[pathInfo.index])

							if (nx ~= nil) then
								AiAgent(pMob):setNextPosition(nx, nz, ny, 0)
							end
						end
					else
						AiAgent(pMob):setNextPosition(tx, tz, ty, 0)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Power generator
--------------------------------------------------------------------------------

function ValleyBattlefield:generatorTick(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	local genID = readData("valleyBattlefield:generatorID")

	if (genID == 0) then
		return
	end

	local pGen = getSceneObject(genID)

	if (pGen == nil) then
		return
	end

	local track = self:getTrack(session)
	local gx = SceneObject(pGen):getPositionX()
	local gy = SceneObject(pGen):getPositionY()
	local near = 0

	for i = 1, #track.army do
		local pMob = getSceneObject(track.army[i])

		if (pMob ~= nil and not CreatureObject(pMob):isDead()) then
			local dx = SceneObject(pMob):getPositionX() - gx
			local dy = SceneObject(pMob):getPositionY() - gy

			if ((dx * dx + dy * dy) <= (self.generatorRange * self.generatorRange)) then
				near = near + 1
			end
		end
	end

	if (near > 0) then
		local damage = TangibleObject(pGen):getConditionDamage() + (near * 100)

		TangibleObject(pGen):setConditionDamage(damage)

		-- setConditionDamage alone does not fire OBJECTDESTRUCTION; inflictDamage
		-- is not bound on TangibleObject. Trigger the destroy path ourselves when
		-- HP is exhausted.
		if (damage >= self.generatorHp) then
			self:generatorDestroyed(pGen, nil)
			return
		end
	end

	createEvent(5000, "ValleyBattlefield", "generatorTick", nil, tostring(session))
end

function ValleyBattlefield:generatorDestroyed(pGen, pKiller)
	if (readData("valleyBattlefield:active") ~= 1) then
		return 1
	end

	local genID = readData("valleyBattlefield:generatorID")

	if (genID == 0) then
		return 1
	end

	-- Prevent re-entry from both OBJECTDESTRUCTION and OBJECTDISABLED / tick.
	writeData("valleyBattlefield:generatorID", 0)

	self:broadcastMessage("The power generator has been destroyed.")

	local session = self:currentSession()

	-- Live also does messageTo(self, "handleDebufMiners", null, 10, false) here
	-- (valley_event_manager.java:261). That handler is a pure buff swap and
	-- nothing else, so it has no port -- see the header. Not stubbed.
	self:runStageMinus1(session)

	if (pGen ~= nil) then
		SceneObject(pGen):destroyObjectFromWorld()
	end

	return 1
end

--------------------------------------------------------------------------------
-- Stage -1 (generator destruction only)
--------------------------------------------------------------------------------

function ValleyBattlefield:runStageMinus1(session)
	for i = 1, #self.stageMinus1Leaders do
		local row = self.stageMinus1Leaders[i]
		local x, y = self:worldXY(row.locx, row.locz)
		local z = getWorldFloor(x, y, "mustafar")
		local pMob = spawnMobile("mustafar", "som_battlefield_mining_leader", 0, x, z, y, 0, 0)

		if (pMob ~= nil) then
			local track = self:getTrack(session)

			table.insert(track.allies, SceneObject(pMob):getObjectID())
			self:setupMiningLeader(pMob, session, true)
		end
	end

	-- Leak monitor: no registered patrol_waypoint.iff; scan from the coordinate.
	createEvent(1000, "ValleyBattlefield", "leakScan", nil, tostring(session))
end

function ValleyBattlefield:leakScan(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	if (readData("valleyBattlefield:won") == 1) then
		return
	end

	-- (-195, -194) is where live puts the monitor itself: the patrol_waypoint row
	-- at stage -1 of valley_event_data.tab carries end_point_monitor. Not the
	-- "end_point" pathing waypoint, which is a different object 5 m away.
	local mx, my = self:worldXY(-195, -194)
	local track = self:getTrack(session)
	local inRange = 0
	local living = false

	for i = 1, #track.army do
		local pMob = getSceneObject(track.army[i])

		if (pMob ~= nil) then
			local dx = SceneObject(pMob):getPositionX() - mx
			local dy = SceneObject(pMob):getPositionY() - my

			if ((dx * dx + dy * dy) <= (self.leakRange * self.leakRange)) then
				inRange = inRange + 1

				if (not CreatureObject(pMob):isDead() and not CreatureObject(pMob):isInCombat()) then
					living = true
				end
			end
		end
	end

	local leaks = readData("valleyBattlefield:leaks")

	-- live end_point_monitor.java checkForDroidArmy, branch for branch: droids in
	-- the volume but none of them free and alive DECREMENTS AND RETURNS, so it
	-- never re-announces on the way back down. Empty volume decrements and does
	-- fall through. Keep that asymmetry.
	if (inRange > 0 and not living) then
		leaks = leaks - 1

		if (leaks < 0) then
			leaks = 0
		end

		writeData("valleyBattlefield:leaks", leaks)
		createEvent(self.leakRescan * 1000, "ValleyBattlefield", "leakScan", nil, tostring(session))
		return
	end

	if (living) then
		leaks = leaks + 1
	else
		leaks = leaks - 1

		if (leaks < 0) then
			leaks = 0
		end
	end

	writeData("valleyBattlefield:leaks", leaks)

	if (leaks == 1) then
		self:broadcastMessage("Droids are breaking through to the end point.")
	elseif (leaks == 2) then
		self:broadcastMessage("More droids are leaking past the line.")
	elseif (leaks == 3) then
		self:broadcastMessage("The end point is almost overrun.")
	elseif (leaks >= self.leakLimit) then
		self:loseTrial("leakage")
		return
	end

	createEvent(self.leakRescan * 1000, "ValleyBattlefield", "leakScan", nil, tostring(session))
end

--------------------------------------------------------------------------------
-- Win / lose / timeout / reset
--------------------------------------------------------------------------------

function ValleyBattlefield:validateDungeon(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	if (readData("valleyBattlefield:won") == 1) then
		return
	end

	if (readData("valleyBattlefield:commanderDead") == 1 and self:livingArmyCount(session) == 0) then
		self:winTrial(session)
		return
	end

	createEvent(self.winPoll * 1000, "ValleyBattlefield", "validateDungeon", nil, tostring(session))
end

function ValleyBattlefield:livingArmyCount(session)
	local track = self:getTrack(session)
	local count = 0

	for i = 1, #track.army do
		local pMob = getSceneObject(track.army[i])

		if (pMob ~= nil and not CreatureObject(pMob):isDead()) then
			count = count + 1
		end
	end

	return count
end

function ValleyBattlefield:winTrial(session)
	if (readData("valleyBattlefield:won") == 1) then
		return
	end

	writeData("valleyBattlefield:won", 1)
	self:broadcastMessage("The droid army has been defeated.")
	self:broadcastMusic(self.victoryMusic)

	self:forEachPlayerInside(function(pPlayer)
		if (self.victoryBadge ~= nil and _G[self.victoryBadge] ~= nil) then
			local pGhost = CreatureObject(pPlayer):getPlayerObject()

			if (pGhost ~= nil) then
				PlayerObject(pGhost):awardBadge(_G[self.victoryBadge])
			end
		end

		if (storyArcChaptersScreenPlay ~= nil) then
			storyArcChaptersScreenPlay:onBattlefieldVictory(pPlayer)
		end
	end)

	createEvent(self.cleanOut * 1000, "ValleyBattlefield", "cleanOutTimer", nil, tostring(session))
end

function ValleyBattlefield:cleanOutTimer(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	self:resetArena("clean-out")
end

function ValleyBattlefield:loseTrial(reason)
	self:broadcastMessage("The battlefield has been lost.")
	self:resetArena(reason)
end

function ValleyBattlefield:onTimeout(pNil, args)
	local session = tonumber(args)

	if (not self:isSessionCurrent(session)) then
		return
	end

	self:broadcastMessage("The battlefield assault has timed out.")
	self:resetArena("timeout")
end

function ValleyBattlefield:resetArena(reason)
	if (readData("valleyBattlefield:active") ~= 1) then
		return
	end

	local session = self:currentSession()
	local track = self.tracked[session]

	-- Clear active first so sendToExit's "last player left" path cannot re-enter.
	writeData("valleyBattlefield:active", 0)

	self:ejectEveryone()

	if (track ~= nil) then
		self:destroyIDList(track.army)
		self:destroyIDList(track.allies)
		self:destroyIDList(track.props)

		-- Demo gear is reaped through DemolitionPack, not destroyIDList: some of it
		-- is sitting in a player's inventory, so it needs the database destroy as
		-- well as the world one, and its writeData keys have to be cleared first
		-- because object ids get reused. This reaping is what makes the runtime-only
		-- radial safe -- see SUBSTITUTION E in demolition_pack.lua.
		if (track.demo ~= nil and DemolitionPack ~= nil) then
			for i = 1, #track.demo do
				DemolitionPack:destroyDemoObject(getSceneObject(track.demo[i]))
			end
		end
	end

	self.tracked[session] = nil

	-- Bump session so in-flight createEvent callbacks find a stale id and bail.
	self:clearSessionKeys()
	writeData("valleyBattlefield:session", session + 1)
end

function ValleyBattlefield:destroyIDList(list)
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
