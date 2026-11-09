--[[
Kashyyyk Arena  --  theme_park.dungeon.kashyyyk_the_arena.*

ruling 2026-09-04: "ensure kashyyyk is fully done"

WHAT THIS IS

Live ran the Arena as a space dungeon (theme_park.dungeon.space_dungeon_controller,
dungeon_name kash_the_arena) on kashyyyk_north_dungeons. Core3 has no space-dungeon
controller. Copy #0 is shared outdoor surface. The forest-arc giver sends the
player with KashyyykArena.enter(pPlayer).

JAVA -> LUA

	arena_controller.java:23-36   dressed_arena_champion at the control object, yaw 171
	celebrity_spawner.java        Rhylis at the arena_guard_inner spawner
	player.java                   signalArenaChallengeAccepted, kerritamba_epic_6 mark,
	                             death -> ejected_by_death + 3 s eject + clear
	                             ep3_forest_wirartu_epic_1

QUEST STATE  --  sibling-arc screenplay names, never quest names

	forestKerritambaEpic6ScreenPlay stage (arena flag lives there;
	forest conv handler writes "arena" on that screenplay, not ep3_arena_challenge)
	forest has no signalArenaChallengeAccepted; the function is
	arenaChallengeScreenPlay:signalArenaChallengeAccepted (trando sibling).
	forestWirartuEpic1ScreenPlay:clearQuest
	Calls are guarded; an absent global prints and does not write a quest-name key.
	KashyyykArena.enter(pPlayer) stays exported.

OPEN

	Outdoor isolation / the space-dungeon session model. A second challenger is
	not refused. The DSRC arena buildout has no area or patrol spawners.
	endDungeonSession on a kerritamba_epic_6 death is OPEN (no session here).
	OURS: live player.java is OnIncapacitated. Core3 has no INCAPACITATED
	observer (DirectorManager.cpp:565-603). This file keeps PLAYERKILLED.

COORDINATE TRANSFORM

	areas_kashyyyk_north_dungeons.tab, first arena area:
		world_x = buildout_x + 88
		world_y = buildout_z - 2192
	space_dungeon.tab kash_the_arena start_loc is an offset from the controller
	(space_dungeon.java:831), same as the slave camp.

FOREST ARC

	KashyyykArena.enter(pPlayer)
--]]

KashyyykArena = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykArena",

	zoneDungeon = "kashyyyk_north_dungeons",

	championTemplate = "dressed_arena_champion",
	championYaw = 171,

	-- arena.tab kash_the_arena_control_object.iff
	control = { x = 411.935 + 88, z = 19.6667, y = 359.971 - 2192 },

	-- arena_guard_inner.iff is a server-only spawner. Celebrity spawns add 0.5 m.
	guard = { x = 430.679 + 88, z = 21.2941 + 0.5, y = 280.743 - 2192 },

	-- controller + space_dungeon.tab start_loc (9.6, 1.8, -63.9)
	landing = {
		x = 411.935 + 88 + 9.6,
		z = 19.6667 + 1.8,
		y = 359.971 - 2192 - 63.9,
	},

	-- space_dungeon.tab exit_planet kashyyyk_dead_forest (-302, 38, -208)
	ejectPoint = { x = -302, z = 38, y = -208 },

	deathMessage = "@dungeon/kash_the_arena:ejected_by_death",
	ejectMs = 3 * 1000,

	kerritambaScreenPlay = "forestKerritambaEpic6ScreenPlay",
}

registerScreenPlay("KashyyykArena", true)

function KashyyykArena:start()
	if (not isZoneEnabled(self.zoneDungeon)) then
		return
	end

	self:spawnChampion()

	local g = self.guard
	local pGuard = spawnMobile(self.zoneDungeon, "arena_guard_inner", 0, g.x, g.z, g.y, getRandomNumber(0, 359), 0)
	if (pGuard == nil) then
		print("KashyyykArena: failed to spawn Rhylis at the arena guard spawner")
	elseif (SceneObject(pGuard):isAiAgent()) then
		AiAgent(pGuard):addObjectFlag(AI_STATIONARY)
	end
end

function KashyyykArena:questStage(pPlayer, screenplayName)
	return tonumber(readScreenPlayData(pPlayer, screenplayName, "stage")) or 0
end

function KashyyykArena:spawnChampion()
	if (readData("KashyyykArena:champion") ~= 0) then
		local existing = getSceneObject(readData("KashyyykArena:champion"))

		if (existing ~= nil) then
			return
		end
	end

	local c = self.control
	local pChampion = spawnMobile(self.zoneDungeon, self.championTemplate, 0, c.x, c.z, c.y, self.championYaw, 0)

	if (pChampion == nil) then
		print("KashyyykArena: failed to spawn " .. self.championTemplate .. " at arena.tab control object")
		return
	end

	writeData("KashyyykArena:champion", SceneObject(pChampion):getObjectID())
end

-- Forest-arc giver calls this. SwitchZone + arrival work, KashyyykIslands style.
function KashyyykArena.enter(pPlayer)
	KashyyykArena:doEnter(pPlayer)
end

function KashyyykArena:doEnter(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (not isZoneEnabled(self.zoneDungeon)) then
		return
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local dest = self.landing
	SceneObject(pPlayer):switchZone(self.zoneDungeon, dest.x, dest.z, dest.y, 0)

	if arenaChallengeScreenPlay ~= nil then
		arenaChallengeScreenPlay:signalArenaChallengeAccepted(pPlayer)
	else
		print("kashyyyk_arena.lua: arenaChallenge screenplay absent; signalArenaChallengeAccepted not raised")
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (self:questStage(pPlayer, self.kerritambaScreenPlay) > 0) then
		writeData(playerID .. ":KashyyykArena:kerritamba", 1)
	else
		deleteData(playerID .. ":KashyyykArena:kerritamba")
	end

	createObserver(PLAYERKILLED, "KashyyykArena", "notifyPlayerKilled", pPlayer)
end

function KashyyykArena:notifyPlayerKilled(pPlayer, pKiller)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	CreatureObject(pPlayer):sendSystemMessage(self.deathMessage)
	createEvent(self.ejectMs, "KashyyykArena", "onDeathEject", pPlayer, "")

	return 1
end

function KashyyykArena:onDeathEject(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if forestWirartuEpic1ScreenPlay ~= nil then
		forestWirartuEpic1ScreenPlay:clearQuest(pPlayer)
	else
		print("kashyyyk_arena.lua: forestWirartuEpic1 screenplay absent; clearQuest not raised")
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":KashyyykArena:kerritamba") == 1) then
		deleteData(playerID .. ":KashyyykArena:kerritamba")
		-- OPEN: live endDungeonSession on the kerritamba_epic_6 death. No session here.
	end

	CreatureObject(pPlayer):setPosture(0)
	CreatureObject(pPlayer):healDamage(100000, 0)
	CreatureObject(pPlayer):healDamage(100000, 1)
	CreatureObject(pPlayer):healDamage(100000, 2)

	self:eject(pPlayer)
end

function KashyyykArena:eject(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local zone, offsetX, offsetY = KashyyykDeadForestPopulation:getLayout()
	if (zone == nil) then
		return
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local dest = self.ejectPoint
	SceneObject(pPlayer):switchZone(zone, dest.x + offsetX, dest.z, dest.y + offsetY, 0)
end
