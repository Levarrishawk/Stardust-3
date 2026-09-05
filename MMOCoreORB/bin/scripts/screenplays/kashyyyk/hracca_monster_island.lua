--[[
Hracca Monster Island  --  theme_park.kashyyyk.hracca_* + dungeon.hracca_monster_island

ruling 2026-09-04: "ensure kashyyyk is fully done"

WHAT THIS IS

Live ran Hracca Glade as a space dungeon (theme_park.dungeon.space_dungeon_controller,
dungeon_name monster_island_hracca). Core3 has no space-dungeon controller. The
island is outdoor surface of zone kashyyyk_south_dungeons, copy #0 only. Reach it
with KashyyykIslands.travelTo(pPlayer, "hracca"); the hunt-arc pilot / Kint
conversation is that branch's job.

JAVA -> LUA

	hracca_controller.java       this file: kill count, countdown, roar, boss spawn
	hracca_spawner.java          spawnPoachers / spawnBoss at the tab rows
	hracca_spawned_tracker.java  OBJECTDESTRUCTION observers
	hracca_monster_island/player.java
	                             OPEN: instance attach, five-minute dungeon timer,
	                             session verify, CS logs
	exit_terminal.java           spawnExitTerminal + SUI confirm + travelBack

OPEN

	Outdoor isolation / concurrency / the space-dungeon session model. Copy #0
	is a shared surface. Kill count is island-wide (writeData), not per party.
	The shared encounter resets five minutes after boss completion.
	Chiss fog particles and the fog-end PRT are not placed. The boss inherits
	the existing level-4 stats; the level curve remains an open ruling.

COORDINATE TRANSFORM

	kashyyyk_south_dungeons_regions.lua {#kash-offset}, copy #0:
		world_x = buildout_x - 3968
		world_y = buildout_z + 2944    -- Core3 y is SOE pz
		world_z = buildout_y           -- height
	kashyyyk_hunting (merged zone kashyyyk), kashyyyk_regions.lua {#kash-offset}:
		world_x = buildout_x - 2048
		world_y = buildout_z - 5048

	spawnMobile wants x, z(height), y, heading-degrees.

THE 40 SPAWNER ROWS

	datatables/buildout/kashyyyk_south_dungeons/hracca.tab rows 4-43:
	39 chiss (spawnType chiss) + row 24 kkorrwrot. intSpawnCount 1.
	Live create.object("ep3_hracca_chiss_poacher_hunter") / "ep3_hracca_kkorrwrot".
	Mapped like the kashyyyk_* lair headers under mobile/lair/creature_dynamic/ (rotate numbered set members):
		ep3_hracca_chiss_poacher_hunter -> ep3_etyyy_chiss_poacher_hracca_01..08
		ep3_hracca_kkorrwrot            -> kkorrwrot
	Boss spawn is the kkorrwrot spawner row, not the control object -- that is
	what hracca_spawner.java does when spawnKkorrwrot is set. The control object
	is the travel landing.

HUNT SIGNAL

	EtyyyHuntState:raise(pPlayer, "hracca_kkorrwrotKilled"), guarded.
	The hunt tree does not yet register that signal; an absent global prints.

TELEPORT  --  KashyyykIslands

	travelTo(pPlayer, island)   island is "hracca" or "bocctyyy"
	travelBack(pPlayer)         returns to that island's hunting-camp ticket NPC
	Pilot conversations call these. BocctyyyTheBet:enter is separate and is
	called by the bocctyyy pilot conversation after travelTo.
--]]

KashyyykIslands = {
	zoneDungeon = "kashyyyk_south_dungeons",
	zoneHunt = "kashyyyk",

	-- hracca.tab row 3, hracca_control_object.iff
	-- buildout (863.474, 12.9327, 395.632)
	hraccaLanding = { x = 863.474 - 3968, z = 12.9327, y = 395.632 + 2944 },

	-- bocctyyy.tab row 3, bocctyyy_bet_control_object.iff
	-- buildout (55.6356, 11.5686, 63.7562)
	bocctyyyLanding = { x = 55.6356 - 3968, z = 11.5686, y = 63.7562 + 2944 },

	-- kashyyyk_hunting.tab etyyy_kint_zsam.iff (ticket NPC for monster_island_hracca)
	-- buildout (1948.23, 25.7985, 1798.12) -> merged kashyyyk
	hraccaCamp = { x = 1948.23 - 2048, z = 25.7985, y = 1798.12 - 5048 },

	-- kashyyyk_hunting.tab etyyy_pilot_to_bocctyyy.iff (ticket NPC for the_bet_bocctyyy)
	-- buildout (2429.47, 41.7397, 2659.8) -> merged kashyyyk
	bocctyyyCamp = { x = 2429.47 - 2048, z = 41.7397, y = 2659.8 - 5048 },
}

function KashyyykIslands.travelTo(pPlayer, island)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (not isZoneEnabled(KashyyykIslands.zoneDungeon)) then
		return
	end

	local dest = nil

	if (island == "hracca") then
		dest = KashyyykIslands.hraccaLanding
	elseif (island == "bocctyyy") then
		dest = KashyyykIslands.bocctyyyLanding
	else
		return
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	writeScreenPlayData(pPlayer, "KashyyykIslands", "island", island)
	SceneObject(pPlayer):switchZone(KashyyykIslands.zoneDungeon, dest.x, dest.z, dest.y, 0)
end

function KashyyykIslands.travelBack(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (not isZoneEnabled(KashyyykIslands.zoneHunt)) then
		return
	end

	local island = readScreenPlayData(pPlayer, "KashyyykIslands", "island")
	local dest = KashyyykIslands.bocctyyyCamp

	if (island == "hracca") then
		dest = KashyyykIslands.hraccaCamp
	elseif (island == "bocctyyy") then
		dest = KashyyykIslands.bocctyyyCamp
	else
		dest = KashyyykIslands:inferCamp(pPlayer)
	end

	-- The from-bocctyyy pilot conversation also lands here. Occupancy and
	-- animal despawn are idempotent.
	if (island == "bocctyyy" and BocctyyyTheBet ~= nil) then
		BocctyyyTheBet:leave(pPlayer)
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	deleteScreenPlayData(pPlayer, "KashyyykIslands", "island")
	SceneObject(pPlayer):switchZone(KashyyykIslands.zoneHunt, dest.x, dest.z, dest.y, 0)
end

function KashyyykIslands:inferCamp(pPlayer)
	local x = SceneObject(pPlayer):getWorldPositionX()
	local y = SceneObject(pPlayer):getWorldPositionY()
	local dxh = x - self.hraccaLanding.x
	local dyh = y - self.hraccaLanding.y
	local dxb = x - self.bocctyyyLanding.x
	local dyb = y - self.bocctyyyLanding.y

	if ((dxh * dxh + dyh * dyh) <= (dxb * dxb + dyb * dyb)) then
		return self.hraccaCamp
	end

	return self.bocctyyyCamp
end

HraccaMonsterIsland = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "HraccaMonsterIsland",

	zoneName = "kashyyyk_south_dungeons",

	-- Live create.object("ep3_hracca_chiss_poacher_hunter"); numbered set
	-- ep3_etyyy_chiss_poacher_hracca_01..08, rotated row by row.
	poacherTemplates = {
		"ep3_etyyy_chiss_poacher_hracca_01",
		"ep3_etyyy_chiss_poacher_hracca_02",
		"ep3_etyyy_chiss_poacher_hracca_03",
		"ep3_etyyy_chiss_poacher_hracca_04",
		"ep3_etyyy_chiss_poacher_hracca_05",
		"ep3_etyyy_chiss_poacher_hracca_06",
		"ep3_etyyy_chiss_poacher_hracca_07",
		"ep3_etyyy_chiss_poacher_hracca_08",
	},

	bossTemplate = "kashyyyk_hracca_kkorrwrot",
	resetDelay = 5 * 60 * 1000,

	-- theme_park/kashyyyk/hracca.stf -- hracca_controller.java:85-110
	countdownKeys = {
		[38] = "@theme_park/kashyyyk/hracca:chiss_report_38",
		[20] = "@theme_park/kashyyyk/hracca:chiss_report_20",
		[10] = "@theme_park/kashyyyk/hracca:chiss_report_10",
		[5] = "@theme_park/kashyyyk/hracca:chiss_report_5",
		[2] = "@theme_park/kashyyyk/hracca:chiss_report_2",
		[1] = "@theme_park/kashyyyk/hracca:chiss_report_1",
	},

	-- hracca_controller.java:133 play2dNonLoopingSound
	roarSound = "sound/quest_hracca_kkorrwrot_roar.snd",

	-- dungeon/space_dungeon.stf -- exit_terminal.java SID_EJECT / SID_EJECT_CONFIRM
	exitTitle = "@dungeon/space_dungeon:hracca_exit",
	exitConfirm = "@dungeon/space_dungeon:hracca_exit_confirm",

	huntSignal = "hracca_kkorrwrotKilled",

	-- OURS: live sent the countdown to the dungeon session's players; Core3 has no session,
	-- so the island's players are found by range. 1024 m covers copy #0 of the island.
	broadcastRange = 1024,

	-- hracca.tab rows 4-23 and 25-43. {px, py, pz, qw, qy}
	poachers = {
		{ 710.945, 12.8105, 346.476, 1, 0 },
		{ 767.346, 13.6792, 346.145, 0.935897, -0.352274 },
		{ 762.396, 13.5511, 344.717, 0.935897, -0.352274 },
		{ 714.323, 13.0196, 348.223, 1, 0 },
		{ 624.875, 13.4309, 381.333, 1, 0 },
		{ 623.698, 13.3759, 385.478, 1, 0 },
		{ 549.174, 14.1613, 364.95, 1, 0 },
		{ 553.255, 14.2011, 368.946, 1, 0 },
		{ 546.786, 14.1176, 375.894, 1, 0 },
		{ 550.65, 14.1611, 378.421, 1, 0 },
		{ 542.534, 14.1176, 367.45, 1, 0 },
		{ 475.872, 13.1495, 458.011, 1, 0 },
		{ 469.445, 14.0642, 465.645, 1, 0 },
		{ 463.146, 14.4432, 469.04, 1, 0 },
		{ 373.875, 14.1147, 429.918, 1, 0 },
		{ 375.918, 14.2576, 432.789, 1, 0 },
		{ 379.676, 14.2576, 437.575, 1, 0 },
		{ 425.969, 13.111, 528.666, 1, 0 },
		{ 429.357, 13.4619, 518.753, 1, 0 },
		{ 423.262, 12.9555, 522.388, 1, 0 },
		{ 301.918, 14.0877, 476.017, 0.597834, 0.80162 },
		{ 302.826, 14.2056, 480.377, 0.597834, 0.80162 },
		{ 237.716, 14.1707, 425.531, 1, 0 },
		{ 246.481, 14.1176, 424.332, 1, 0 },
		{ 248.674, 13.8894, 433.278, 1, 0 },
		{ 273.338, 15.0107, 550.042, 0.870293, -0.492535 },
		{ 277.543, 14.7385, 546.96, 0.870293, -0.492535 },
		{ 257.872, 13.5191, 619.054, 1, 0 },
		{ 267.487, 13.7584, 624.644, 1, 0 },
		{ 158.404, 14.3856, 536.615, 1, 0 },
		{ 169.418, 14.2374, 527.328, 1, 0 },
		{ 158.779, 14.1255, 528.406, 1, 0 },
		{ 138.547, 13.9182, 625.373, 0.90687, -0.42141 },
		{ 157.018, 14.0575, 624.438, 0.90687, -0.42141 },
		{ 149.573, 13.8501, 629.623, 0.90687, -0.42141 },
		{ 151.75, 14.3242, 613.755, 0.90687, -0.42141 },
		{ 140.151, 14.154, 614.981, 1, 0 },
		{ 164.745, 14.3922, 703.086, 1, 0 },
		{ 165.16, 14.5091, 708.039, 1, 0 },
	},

	-- hracca.tab row 24 hracca_kkorrwrot_spawner.iff
	bossRow = { 267.698, 13.5824, 579.107, 1, 0 },

	-- hracca.tab row 242 thm_kash_zonegate_door_simple.iff (exit_terminal script)
	-- Prompt named terminal_free_sui.iff; this tree registers terminal_free_s1.iff.
	exitRow = { 888.169, 17.8734, 449.382, -0.0107962, 0, 0.999942, 0 },
	exitTemplate = "object/tangible/dungeon/terminal_free_s1.iff",
}

registerScreenPlay("HraccaMonsterIsland", true)

function HraccaMonsterIsland:start()
	if (not isZoneEnabled(self.zoneName)) then
		return
	end

	self:spawnPoachers()
	self:spawnExitTerminal()
end

function HraccaMonsterIsland:worldFromBuildout(px, py, pz)
	return px - 3968, py, pz + 2944
end

function HraccaMonsterIsland:headingFromQuat(qw, qy)
	return math.deg(2 * math.atan2(qy, qw))
end

function HraccaMonsterIsland:spawnPoachers()
	local spawned = 0

	for i = 1, #self.poachers do
		local row = self.poachers[i]
		local x, z, y = self:worldFromBuildout(row[1], row[2], row[3])
		local heading = self:headingFromQuat(row[4], row[5])
		local template = self.poacherTemplates[((i - 1) % #self.poacherTemplates) + 1]
		local pMobile = spawnMobile(self.zoneName, template, 0, x, z, y, heading, 0)

		if (pMobile ~= nil) then
			createObserver(OBJECTDESTRUCTION, "HraccaMonsterIsland", "notifyPoacherKilled", pMobile)
			spawned = spawned + 1
		else
			print("HraccaMonsterIsland: failed to spawn " .. template .. " at hracca.tab poacher " .. i)
		end
	end

	writeData("HraccaMonsterIsland:remaining", spawned)
	writeData("HraccaMonsterIsland:boss", 0)
	print("HraccaMonsterIsland: " .. spawned .. " Chiss poachers placed on copy #0")
end

function HraccaMonsterIsland:spawnExitTerminal()
	local row = self.exitRow
	local x, z, y = self:worldFromBuildout(row[1], row[2], row[3])
	local pTerminal = spawnSceneObject(self.zoneName, self.exitTemplate, x, z, y, 0, row[4], row[5], row[6], row[7])

	if (pTerminal == nil) then
		print("HraccaMonsterIsland: failed to spawn the exit terminal at hracca.tab row 242")
		return
	end

	createObserver(OBJECTRADIALUSED, "HraccaMonsterIsland", "notifyExitUsed", pTerminal)
	writeData("HraccaMonsterIsland:terminal", SceneObject(pTerminal):getObjectID())
end

function HraccaMonsterIsland:notifyExitUsed(pTerminal, pPlayer)
	if (pTerminal == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local sui = SuiMessageBox.new("HraccaMonsterIsland", "exitConfirmCallback")
	sui.setTitle(self.exitTitle)
	sui.setPrompt(self.exitConfirm)
	sui.sendTo(pPlayer)

	return 0
end

function HraccaMonsterIsland:exitConfirmCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	-- eventIndex 0 is OK; anything else is Cancel or a closed window.
	if (eventIndex ~= 0) then
		return
	end

	writeScreenPlayData(pPlayer, "KashyyykIslands", "island", "hracca")
	KashyyykIslands.travelBack(pPlayer)
end

function HraccaMonsterIsland:notifyPoacherKilled(pVictim, pKiller)
	if (pVictim == nil) then
		return 1
	end

	local remaining = readData("HraccaMonsterIsland:remaining") - 1

	if (remaining < 0) then
		remaining = 0
	end

	writeData("HraccaMonsterIsland:remaining", remaining)

	local key = self.countdownKeys[remaining]

	if (key ~= nil) then
		self:broadcastMessage(pVictim, key)
	end

	if (remaining == 0) then
		self:onPoachersCleared(pVictim)
	end

	return 1
end

function HraccaMonsterIsland:onPoachersCleared(pFrom)
	self:broadcastRoar(pFrom)
	self:spawnBoss()
end

function HraccaMonsterIsland:spawnBoss()
	if (readData("HraccaMonsterIsland:boss") == 1) then
		return
	end

	local row = self.bossRow
	local x, z, y = self:worldFromBuildout(row[1], row[2], row[3])
	local heading = self:headingFromQuat(row[4], row[5])
	local pBoss = spawnMobile(self.zoneName, self.bossTemplate, 0, x, z, y, heading, 0)

	if (pBoss == nil) then
		print("HraccaMonsterIsland: failed to spawn " .. self.bossTemplate .. " at hracca.tab row 24")
		return
	end

	writeData("HraccaMonsterIsland:boss", 1)
	createObserver(OBJECTDESTRUCTION, "HraccaMonsterIsland", "notifyBossKilled", pBoss)
end

function HraccaMonsterIsland:notifyBossKilled(pVictim, pKiller)
	if (pVictim == nil) then
		return 1
	end

	self:raiseHuntSignal(pVictim)
	self:scheduleReset()

	return 1
end

function HraccaMonsterIsland:scheduleReset()
	if (readData("HraccaMonsterIsland:resetPending") == 1) then
		return
	end

	writeData("HraccaMonsterIsland:resetPending", 1)
	createEvent(self.resetDelay, "HraccaMonsterIsland", "resetEncounter", nil, "")
end

function HraccaMonsterIsland:resetEncounter()
	if (readData("HraccaMonsterIsland:resetPending") ~= 1) then
		return
	end

	deleteData("HraccaMonsterIsland:resetPending")
	if (isZoneEnabled(self.zoneName)) then
		self:spawnPoachers()
	end
end

function HraccaMonsterIsland:raiseHuntSignal(pFrom)
	local players = self:playersInRange(pFrom)

	if (players == nil) then
		return
	end

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature()) then
			if EtyyyHuntState ~= nil then
				EtyyyHuntState:raise(pPlayer, self.huntSignal)
			else
				print("hracca_monster_island.lua: EtyyyHuntState screenplay absent; " .. self.huntSignal .. " not raised")
			end
		end
	end
end

function HraccaMonsterIsland:broadcastMessage(pFrom, key)
	local players = self:playersInRange(pFrom)

	if (players == nil) then
		return
	end

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature()) then
			-- CreatureObject::sendSystemMessage, LuaCreatureObject.cpp
			CreatureObject(pPlayer):sendSystemMessage(key)
		end
	end
end

function HraccaMonsterIsland:broadcastRoar(pFrom)
	local players = self:playersInRange(pFrom)

	if (players == nil) then
		return
	end

	for i = 1, #players do
		local pPlayer = players[i]

		if (pPlayer ~= nil and SceneObject(pPlayer):isPlayerCreature()) then
			-- Live used play2dNonLoopingSound. That binding is not registered.
			-- playMusicMessage is the Lua binding for a .snd
			-- (LuaCreatureObject.cpp playMusicMessage).
			-- playClientEffectLoc (DirectorManager.cpp) takes an effect file
			-- (clienteffect/*.cef, appearance/*.prt), not a .snd.
			CreatureObject(pPlayer):playMusicMessage(self.roarSound)
		end
	end
end

function HraccaMonsterIsland:playersInRange(pFrom)
	if (pFrom == nil) then
		local terminalID = readData("HraccaMonsterIsland:terminal")

		if (terminalID ~= 0) then
			pFrom = getSceneObject(terminalID)
		end
	end

	if (pFrom == nil) then
		return nil
	end

	return SceneObject(pFrom):getPlayersInRange(self.broadcastRange)
end
