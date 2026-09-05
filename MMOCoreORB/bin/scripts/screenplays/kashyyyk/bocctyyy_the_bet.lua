--[[
Bocctyyy the Bet  --  theme_park.kashyyyk.bocctyyy_bet_* + dungeon.bocctyyy_the_bet

ruling 2026-09-04: "ensure kashyyyk is fully done"

WHAT THIS IS

Live ran Bocctyyy Path as a space dungeon (theme_park.dungeon.space_dungeon_controller,
dungeon_name the_bet_bocctyyy). Core3 has no space-dungeon controller. The island
is outdoor surface of zone kashyyyk_south_dungeons, copy #0 only. Reach it with
KashyyykIslands.travelTo(pPlayer, "bocctyyy") -- defined in hracca_monster_island.lua.
The hunt-arc pilot conversation then calls BocctyyyTheBet:enter(pPlayer).

CONCURRENCY: OPEN. The island is shared outdoor surface. A second hunter is not
refused. Animals spawn on the first enter that still has a mapped template; a
later hunter with a different bet sees whatever is already standing. Occupancy
hits zero -> despawn. No party cap (live's pilot conversation capped at 6).

JAVA -> LUA

	bocctyyy_bet_controller.java     enter() picks the bet and fires spawners
	bocctyyy_bet_spawner.java        spawnAnimals: 3 per row (intSpawnCount 3)
	bocctyyy_bet_spawned_tracker.java
	                                 destroyObjectFromWorld on exit (no kill
	                                 counter -- live only unlisted the corpse)
	bocctyyy_the_bet/player.java     arrival signal, 5-minute eject
	                                 OPEN: instance attach, session verify,
	                                 CS logs, fiveMinuteTimer warnings

OPEN

	Outdoor isolation / the space-dungeon session model. ep3_etyyy_mouf_roarlord
	has no repo template (the etyyy_mouf lair header leaves it commented; same ruling). A mouf
	bet still raises sordaan_moufGoToBocctyyy and still ejects; it does not
	spawn a look-alike. walluga / webweaver placeholders are pvpBitmask NONE.

THE SPAWNER ROWS

	datatables/buildout/kashyyyk_south_dungeons/bocctyyy.tab rows 4-49
	(46 bocctyyy_bet_spawner.iff, intSpawnCount 3, radius 3 in the java).
	bocctyyy_bet_spawner.java getSpawnType:
		ep3_hunt_sordaan_uller_bet     -> ep3_etyyy_uller_warhoof
		ep3_hunt_sordaan_walluga_bet   -> ep3_etyyy_walluga_frenzied
		ep3_hunt_sordaan_mouf_bet      -> ep3_etyyy_mouf_roarlord   OPEN
		ep3_hunt_sordaan_webweaver_bet -> ep3_etyyy_webweaver_spiker
	Mapped from the kashyyyk_* lair headers:
		ep3_etyyy_uller_warhoof     -> uller_stoneclaw
		ep3_etyyy_walluga_frenzied  -> walluga
		ep3_etyyy_webweaver_spiker  -> webweaver

ARRIVAL SIGNALS  --  EtyyyHuntState:raise, guarded

	sordaan_ullerGoToBocctyyy / sordaan_wallugaGoToBocctyyy /
	sordaan_moufGoToBocctyyy / sordaan_webweaverGoToBocctyyy

ACTIVE BET

	readScreenPlayData(pPlayer, "huntSordaanUllerBetScreenPlay", "stage")
	(and walluga / mouf / webweaver likewise). Grant leaves stage > 0.
--]]

BocctyyyTheBet = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "BocctyyyTheBet",

	zoneName = "kashyyyk_south_dungeons",
	ejectMs = 5 * 60 * 1000,
	perSpawner = 3,

	bets = {
		{
			quest = "huntSordaanUllerBetScreenPlay",
			signal = "sordaan_ullerGoToBocctyyy",
			template = "uller_stoneclaw",
		},
		{
			quest = "huntSordaanWallugaBetScreenPlay",
			signal = "sordaan_wallugaGoToBocctyyy",
			template = "walluga",
		},
		{
			quest = "huntSordaanMoufBetScreenPlay",
			signal = "sordaan_moufGoToBocctyyy",
			template = nil, -- OPEN: no repo mouf template
		},
		{
			quest = "huntSordaanWebweaverBetScreenPlay",
			signal = "sordaan_webweaverGoToBocctyyy",
			template = "webweaver",
		},
	},

	-- bocctyyy.tab rows 4-49. {px, py, pz} identity heading.
	spawners = {
		{ 192.492, 11.6051, 124.957 },
		{ 209.235, 11.098, 116.853 },
		{ 198.301, 11.273, 90.1851 },
		{ 190.827, 11.6904, 55.6205 },
		{ 208.838, 11.5258, 49.6922 },
		{ 315.424, 12.7991, 52.7316 },
		{ 334.189, 12.1564, 51.3474 },
		{ 305.939, 12.8702, 62.7631 },
		{ 391.32, 12.1751, 83.5883 },
		{ 385.261, 12.0987, 104.758 },
		{ 420.138, 12.0608, 125.932 },
		{ 371.236, 11.9977, 154.176 },
		{ 279.047, 10.8948, 159.061 },
		{ 252.154, 10.6214, 171.673 },
		{ 296.34, 12.0519, 177.793 },
		{ 265.333, 10.4424, 165.027 },
		{ 282.164, 11.5686, 222.906 },
		{ 250.123, 12.2016, 242.071 },
		{ 183.466, 13.2242, 243.021 },
		{ 169.597, 12.9804, 268.221 },
		{ 233.675, 12.69, 326.622 },
		{ 246.175, 12.5098, 317.735 },
		{ 231.345, 12.5098, 308.761 },
		{ 194.302, 12.1842, 351.848 },
		{ 201.343, 12.7831, 316.515 },
		{ 113.101, 12.1602, 374.229 },
		{ 87.7257, 12.2771, 378.483 },
		{ 83.7653, 12.0392, 407.934 },
		{ 104.836, 11.8824, 394.328 },
		{ 131.793, 11.8824, 400.019 },
		{ 157.937, 12.8136, 423.92 },
		{ 241.009, 12.1646, 445.094 },
		{ 229.674, 11.7912, 420.632 },
		{ 215.081, 12.0177, 419.137 },
		{ 270.553, 10.5768, 358.875 },
		{ 294.527, 10, 344.055 },
		{ 311.019, 10.5656, 313.904 },
		{ 297.463, 11.4051, 318.623 },
		{ 388.048, 12.2693, 339.114 },
		{ 356.827, 12.5358, 415.835 },
		{ 348.708, 11.9837, 431.216 },
		{ 367.758, 12.637, 443.053 },
		{ 364.788, 11.7173, 429.265 },
		{ 441.734, 12.5122, 463.75 },
		{ 457.576, 12.4768, 450.21 },
		{ 464.32, 12.0496, 470.066 },
	},
}

registerScreenPlay("BocctyyyTheBet", true)

function BocctyyyTheBet:start()
end

function BocctyyyTheBet:worldFromBuildout(px, py, pz)
	return px - 3968, py, pz + 2944
end

function BocctyyyTheBet:getActiveBet(pPlayer)
	if (pPlayer == nil) then
		return nil
	end

	for i = 1, #self.bets do
		local bet = self.bets[i]
		local stage = tonumber(readScreenPlayData(pPlayer, bet.quest, "stage")) or 0

		if (stage > 0) then
			return bet
		end
	end

	return nil
end

-- Pilot conversation calls this after KashyyykIslands.travelTo(pPlayer, "bocctyyy").
function BocctyyyTheBet:enter(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":BocctyyyTheBet") == 1) then
		return
	end

	writeData(playerID .. ":BocctyyyTheBet", 1)
	writeScreenPlayData(pPlayer, "KashyyykIslands", "island", "bocctyyy")
	writeData("BocctyyyTheBet:occupancy", readData("BocctyyyTheBet:occupancy") + 1)

	local bet = self:getActiveBet(pPlayer)

	if (bet ~= nil) then
		if EtyyyHuntState ~= nil then
			EtyyyHuntState:raise(pPlayer, bet.signal)
		else
			print("bocctyyy_the_bet.lua: EtyyyHuntState screenplay absent; " .. bet.signal .. " not raised")
		end

		if (readData("BocctyyyTheBet:spawned") ~= 1) then
			self:spawnAnimals(bet)
		end
	end

	createEvent(self.ejectMs, "BocctyyyTheBet", "ejectPlayer", pPlayer, "")
end

function BocctyyyTheBet:spawnAnimals(bet)
	if (bet.template == nil) then
		print("BocctyyyTheBet: " .. bet.quest .. " is OPEN (no repo template); arrival signal still raised")
		return
	end

	local spawned = 0

	for i = 1, #self.spawners do
		local row = self.spawners[i]
		local x, z, y = self:worldFromBuildout(row[1], row[2], row[3])

		for n = 1, self.perSpawner do
			local ox = (n - 2) * 1.2
			local pMobile = spawnMobile(self.zoneName, bet.template, 0, x + ox, z, y, 0, 0)

			if (pMobile ~= nil) then
				spawned = spawned + 1
				writeData("BocctyyyTheBet:mob:" .. spawned, SceneObject(pMobile):getObjectID())
			else
				print("BocctyyyTheBet: failed to spawn " .. bet.template .. " at bocctyyy.tab spawner " .. i)
			end
		end
	end

	writeData("BocctyyyTheBet:spawned", 1)
	writeData("BocctyyyTheBet:mobCount", spawned)
	print("BocctyyyTheBet: " .. spawned .. " " .. bet.template .. " placed on copy #0")
end

function BocctyyyTheBet:ejectPlayer(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (SceneObject(pPlayer):getZoneName() == self.zoneName) then
		KashyyykIslands.travelBack(pPlayer)
	else
		self:leave(pPlayer)
	end
end

-- Idempotent. travelBack calls this when the stored island is bocctyyy.
function BocctyyyTheBet:leave(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":BocctyyyTheBet") ~= 1) then
		return
	end

	deleteData(playerID .. ":BocctyyyTheBet")

	local occupancy = readData("BocctyyyTheBet:occupancy") - 1

	if (occupancy < 0) then
		occupancy = 0
	end

	writeData("BocctyyyTheBet:occupancy", occupancy)

	if (occupancy == 0) then
		self:despawnAnimals()
	end
end

function BocctyyyTheBet:despawnAnimals()
	local count = readData("BocctyyyTheBet:mobCount")

	for i = 1, count do
		local oid = readData("BocctyyyTheBet:mob:" .. i)
		deleteData("BocctyyyTheBet:mob:" .. i)

		if (oid ~= 0) then
			local pMobile = getSceneObject(oid)

			if (pMobile ~= nil) then
				SceneObject(pMobile):destroyObjectFromWorld()
			end
		end
	end

	deleteData("BocctyyyTheBet:mobCount")
	deleteData("BocctyyyTheBet:spawned")
end
