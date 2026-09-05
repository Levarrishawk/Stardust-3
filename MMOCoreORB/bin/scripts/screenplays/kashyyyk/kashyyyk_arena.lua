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
	not refused. clearArena's 150 m creature wipe is not run -- those mobiles
	are the north-dungeons spawn areas. ep3_wirartu_arena has no repo template;
	never a look-alike. conversation.ep3_forest_wirartu_arena is not in the tree.
	endDungeonSession on a kerritamba_epic_6 death is OPEN (no session here).
	OURS: live player.java is OnIncapacitated. Core3 has no INCAPACITATED
	observer (DirectorManager.cpp:565-603). This file keeps PLAYERKILLED.

COORDINATE TRANSFORM

	kashyyyk_north_dungeons_regions.lua {#kash-offset}, copy #0:
		world_x = buildout_x - 3840
		world_y = buildout_z + 2816
	kashyyyk_regions.lua kashyyyk_dead_forest merge:
		kashyyyk_dead_forest.ws dx -1500, dz +1500
	space_dungeon.tab kash_the_arena start_loc is an offset from the controller
	(space_dungeon.java:831), same as the slave camp.

FOREST ARC

	KashyyykArena.enter(pPlayer)
--]]

KashyyykArena = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykArena",

	zoneDungeon = "kashyyyk_north_dungeons",
	zoneMain = "kashyyyk",

	championTemplate = "dressed_arena_champion",
	championYaw = 171,

	-- arena.tab kash_the_arena_control_object.iff
	-- buildout (411.935, 19.6667, 359.971) -> world (-3428.065, 19.6667, 3175.971)
	control = { x = 411.935 - 3840, z = 19.6667, y = 359.971 + 2816 },

	-- controller + space_dungeon.tab start_loc (9.6, 1.8, -63.9)
	landing = {
		x = (411.935 + 9.6) - 3840,
		z = 19.6667 + 1.8,
		y = (359.971 + (-63.9)) + 2816,
	},

	-- space_dungeon.tab exit_planet kashyyyk_dead_forest (-302, 38, -208)
	-- plus the merged-surface dx -1500 / dz +1500
	ejectPoint = { x = -302 - 1500, z = 38, y = -208 + 1500 },

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

	-- OPEN: no repo template ep3_wirartu_arena. Never a look-alike.
	print("KashyyykArena: OPEN spawn ep3_wirartu_arena (no repo template)")
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

	if (not isZoneEnabled(self.zoneMain)) then
		return
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	local dest = self.ejectPoint
	SceneObject(pPlayer):switchZone(self.zoneMain, dest.x, dest.z, dest.y, 0)
end
