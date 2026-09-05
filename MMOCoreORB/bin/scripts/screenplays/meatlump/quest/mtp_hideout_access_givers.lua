--[[
	Persistent givers for the hideout-access chain.

	ruling 2026-09-04

	NO JOURNAL: do not call the journal module. The client ships the strings but NOT
	the .qst; the journal row comes from the integration branch later.

	None of these givers stand in the hideout spawn map. Spawned at sourced
	task waypoints (Kashyyyk radio shape). old_meatlump has no sourced waypoint; placed next to Kaiya.
]]

mtpHideoutAccessGiversScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "mtpHideoutAccessGiversScreenPlay",
	givers = {
		{ template = "dressed_corellia_vani_korr", planet = "corellia", x = -107, y = 28, z = -4465, heading = 0 },
		{ template = "dressed_meatlump_male_03", planet = "corellia", x = -597, y = 24, z = -3927, heading = 0 }, -- crate_maker stand-in; dressed_corran_horn is absent from the client
		{ template = "dressed_meatlump_male_04", planet = "corellia", x = -6152, y = 29, z = -2004, heading = 0 }, -- droid_farmer stand-in; dressed_quest_farmer is absent from the client
		{ template = "dressed_npe_dartas", planet = "talus", x = 843, y = 6, z = -3178, heading = 0 }, -- bike_racer
		{ template = "dressed_meatlump_lieutenant_02", planet = "corellia", x = -277, y = 28, z = -4144, heading = 0 }, -- kaiya_merel
		{ template = "dressed_meatlump_male_02", planet = "corellia", x = -280, y = 28, z = -4140, heading = 0 }, -- old_meatlump; no sourced waypoint, placed next to Kaiya
	},
}

registerScreenPlay("mtpHideoutAccessGiversScreenPlay", true)

function mtpHideoutAccessGiversScreenPlay:start()
	for i = 1, #self.givers do
		local g = self.givers[i]

		if (isZoneEnabled(g.planet)) then
			local z = getWorldFloor(g.x, g.z, g.planet)

			if (z == nil or z == 0) then
				z = g.y
			end

			spawnMobile(g.planet, g.template, 0, g.x, z, g.z, g.heading, 0)
		end
	end
end

function mtpHideoutAccessGiversScreenPlay:despawnNpc(pNpc)
	if (pNpc ~= nil) then
		SceneObject(pNpc):destroyObjectFromWorld()
	end
end
