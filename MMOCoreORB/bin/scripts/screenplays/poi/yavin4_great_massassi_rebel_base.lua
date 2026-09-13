Yavin4GreatMassassiRebelBaseScreenPlay = ScreenPlay:new {
	screenplayName = "Yavin4GreatMassassiRebelBaseScreenPlay",

	planet = "yavin4",

	-- {template, respawn, x, z, y, direction, cell, mood}
	mobiles = {
		-- Exterior approach and entry security
		{"rebel_specforce_pathfinder", 300, -3142.0, 70.0, -2974.0, 92, 0, ""},
		{"rebel_specforce_pathfinder", 300, -3142.0, 70.0, -2980.0, 88, 0, ""},
		{"rebel_trooper", 300, -3154.0, 70.0, -2964.0, 135, 0, ""},
		{"rebel_trooper", 300, -3154.0, 70.0, -2990.0, 45, 0, ""},
		{"rebel_commando", 300, -3182.0, 70.0, -2945.0, 155, 0, ""},
		{"rebel_commando", 300, -3182.0, 70.0, -3007.0, 25, 0, ""},
		{"rebel_army_captain", 300, -3165.0, 70.0, -2977.0, 90, 0, "npc_consoling"},
		{"rebel_pilot", 300, -3188.0, 70.0, -2996.0, -35, 0, "npc_conversation"},
		{"rebel_pilot", 300, -3186.0, 70.0, -2994.0, 145, 0, "npc_conversation"},

		-- Cell 1: foyer
		{"rebel_trooper", 300, -65.3, 2.0, 83.0, -90, 3465353, ""},
		{"rebel_trooper", 300, -67.7, 2.0, 83.0, 90, 3465353, ""},

		-- Cell 2: lower hall security checkpoint
		{"rebel_specforce_sergeant", 300, -55.4, 2.0, 71.8, 90, 3465354, ""},
		{"rebel_trooper", 300, -66.3, 2.0, 72.7, 180, 3465354, ""},
		{"rebel_trooper", 300, -83.5, 2.0, 67.3, 0, 3465354, ""},

		-- Cell 3: hangar and maintenance floor
		{"rebel_pilot", 300, 28.0, 2.0, 20.0, 120, 3465355, "npc_conversation"},
		{"rebel_pilot", 300, 31.0, 2.0, 18.0, -60, 3465355, "npc_conversation"},
		{"commoner_technician", 300, 20.0, 2.0, 28.0, 180, 3465355, "npc_use_terminal_high"},
		{"commoner_technician", 300, -22.0, 2.0, 19.0, 35, 3465355, "npc_use_terminal_low"},
		{"rebel_trooper", 300, 43.5, 2.0, 72.0, -90, 3465355, ""},
		{"rebel_trooper", 300, -43.5, 2.0, 72.0, 90, 3465355, ""},
		{"rebel_commando", 300, 0.0, 2.0, 52.0, 180, 3465355, ""},
		{"rebel_medic", 300, -31.0, 2.0, 91.0, 135, 3465355, "npc_survey"},

		-- Cell 4: first stair watch
		{"rebel_trooper", 300, -83.5, 12.0, 43.0, 90, 3465356, ""},

		-- Cell 5: operations-level hall
		{"rebel_commando", 300, -38.5, 32.0, 42.5, 90, 3465357, ""},
		{"rebel_trooper", 300, -33.5, 32.0, 74.5, 180, 3465357, ""},
		{"rebel_first_lieutenant", 300, -18.0, 32.0, 30.5, -90, 3465357, "npc_survey"},

		-- Cell 6: tactical war room
		{"rebel_colonel", 300, -25.0, 32.0, 64.0, 180, 3465358, "npc_survey"},
		{"rebel_first_lieutenant", 300, -20.0, 32.0, 58.0, -90, 3465358, "npc_use_terminal_high"},
		{"rebel_specforce_captain", 300, -30.0, 32.0, 58.0, 90, 3465358, "npc_use_terminal_high"},
		{"rebel_commando", 300, -32.5, 32.0, 49.5, 45, 3465358, ""},

		-- Cells 7-9: upper access and ceremony-hall antechamber
		{"rebel_trooper", 300, -12.0, 45.0, 75.0, 90, 3465359, ""},
		{"rebel_commando", 300, 13.5, 57.0, 74.5, -90, 3465360, ""},
		{"rebel_trooper", 300, 5.5, 57.0, 67.5, -90, 3465361, ""},
		{"rebel_trooper", 300, -5.5, 57.0, 67.5, 90, 3465361, ""},

		-- Cell 10: ceremony and assembly hall. The center remains open for
		-- formations, awards, mission briefings, and combat drills.
		{"rebel_trooper", 300, -8.0, 55.0, 50.0, 180, 3465362, "npc_attention"},
		{"rebel_trooper", 300, 8.0, 55.0, 50.0, 180, 3465362, "npc_attention"},
		{"rebel_army_captain", 300, 0.0, 55.0, 8.0, 180, 3465362, "npc_attention"},
		{"rebel_trooper", 300, -8.0, 55.0, -8.0, 0, 3465362, "npc_attention"},
		{"rebel_trooper", 300, 8.0, 55.0, -8.0, 180, 3465362, "npc_attention"},
		{"rebel_commando", 300, -14.0, 55.0, -35.0, 45, 3465362, "npc_combat"},
		{"rebel_commando", 300, 14.0, 55.0, -35.0, -45, 3465362, "npc_combat"},
	},

	-- {template, x, z, y, cell, direction}
	objects = {
		-- Portable Rebel illumination through the otherwise dark temple
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -65.0, 2.0, 88.0, 3465353, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -68.0, 2.0, 88.0, 3465353, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -55.0, 2.0, 73.5, 3465354, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -83.5, 2.0, 66.0, 3465354, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -43.5, 2.0, 100.0, 3465355, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 43.5, 2.0, 100.0, 3465355, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -43.5, 2.0, 45.0, 3465355, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 43.5, 2.0, 45.0, 3465355, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -77.5, 12.0, 43.0, 3465356, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -38.5, 32.0, 74.5, 3465357, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -18.0, 32.0, 30.0, 3465357, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -33.0, 32.0, 63.5, 3465358, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -18.0, 32.0, 63.5, 3465358, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 13.5, 57.0, 67.0, 3465360, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -5.5, 57.0, 65.0, 3465361, 0},

		-- Ceremony-hall perimeter; preserve the processional aisle and drill floor
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -17.0, 55.0, 8.0, 3465362, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 17.0, 55.0, 8.0, 3465362, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -24.0, 55.0, -25.0, 3465362, 0},
		{"object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 24.0, 55.0, -25.0, 3465362, 0},

		-- Strong rear backlight inspired by the Alliance award ceremony. The
		-- artefacts sit behind the stone uprights on the raised rear platform.
		{"object/tangible/item/lytus_family_artefact.iff", -8.0, 58.0, -52.5, 3465362, 0},
		{"object/tangible/item/lytus_family_artefact.iff", -4.0, 58.0, -52.5, 3465362, 0},
		{"object/tangible/item/lytus_family_artefact.iff", 0.0, 58.0, -52.5, 3465362, 0},
		{"object/tangible/item/lytus_family_artefact.iff", 4.0, 58.0, -52.5, 3465362, 0},
		{"object/tangible/item/lytus_family_artefact.iff", 8.0, 58.0, -52.5, 3465362, 0},

		-- Hangar work areas and stores
		{"object/tangible/furniture/all/frn_all_data_terminal_free_s1.iff", 20.0, 2.0, 30.0, 3465355, 180},
		{"object/tangible/furniture/all/frn_all_data_terminal_free_s2.iff", -22.0, 2.0, 17.0, 3465355, 0},
		{"object/tangible/container/drum/large_plain_crate_s01.iff", -37.0, 2.0, 12.0, 3465355, 15},
		{"object/tangible/container/drum/large_plain_crate_s02.iff", -34.5, 2.0, 12.5, 3465355, -10},
		{"object/tangible/container/drum/large_plain_crate_s03.iff", -36.0, 2.0, 15.0, 3465355, 30},

		-- Tactical war room
		{"object/tangible/furniture/all/frn_all_desk_map_table.iff", -25.0, 32.0, 58.0, 3465358, 0},
		{"object/tangible/furniture/all/frn_all_command_console.iff", -25.0, 32.0, 51.0, 3465358, 0},
		{"object/tangible/furniture/technical/chair_s01.iff", -20.0, 32.0, 56.5, 3465358, -90},
		{"object/tangible/furniture/technical/chair_s01.iff", -30.0, 32.0, 56.5, 3465358, 90},

	}
}

registerScreenPlay("Yavin4GreatMassassiRebelBaseScreenPlay", true)

function Yavin4GreatMassassiRebelBaseScreenPlay:start()
	if (isZoneEnabled(self.planet)) then
		self:spawnMobiles()
		self:spawnObjects()
	end
end

function Yavin4GreatMassassiRebelBaseScreenPlay:spawnMobiles()
	for i = 1, #self.mobiles do
		local mobile = self.mobiles[i]
		local pMobile = spawnMobile(self.planet, mobile[1], mobile[2], mobile[3], mobile[4], mobile[5], mobile[6], mobile[7])

		if (pMobile ~= nil) then
			if (mobile[8] ~= "") then
				CreatureObject(pMobile):setMoodString(mobile[8])
			end

			AiAgent(pMobile):addObjectFlag(AI_STATIC)
		end
	end
end

function Yavin4GreatMassassiRebelBaseScreenPlay:spawnObjects()
	for i = 1, #self.objects do
		local object = self.objects[i]
		spawnSceneObject(self.planet, object[1], object[2], object[3], object[4], object[5], math.rad(object[6]))
	end
end
