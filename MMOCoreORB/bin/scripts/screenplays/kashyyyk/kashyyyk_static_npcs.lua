-- Kashyyyk surface static NPCs (ruling 2026-09-04: "ensure kashyyyk is done in full").
-- Celebrity spawners from the three surface buildout tabs. World coords are
-- x, z, y = wx, py, wz. Heading is baked as degrees(2 * atan2(qy, qw)) from the
-- placement quaternion: no quaternion-to-heading converter exists in tools/ or
-- screenplays (qx = qz = 0 on these rows). spawnMobile respawn is 0, matching unique
-- static NPCs in cities/*.lua (tatooine_wayfar.lua:169 informant_npc_lvl_2).
-- spawnMobile does not revive them; this screenplay does not add a despawn observer.

KashyyykStaticNpcsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykStaticNpcsScreenPlay",

	-- {template, x, z, y, heading, "<SOE spawns name> (main|hunting|dead forest row N)"}
	npcs = {
		{"ep3_tien_wallub", -508.77, 18.2927, -66.29, 80.787, "ep3_tien_wallub (main row 9)"}, -- registered name equals spawns
		{"ep3_kymayrr", -502.2, 18.7602, -74.1, -73.339, "ep3_kymayrr (main row 15)"}, -- registered name equals spawns
		{"ep3_etyyy_kerssoc", 577.3, 23.9216, -639.23, -37.724, "ep3_etyyy_kerssoc (main row 1615)"}, -- registered name equals spawns
		{"ep3_etyyy_chrilooc", -701.06, 17.127, 11.24, 195.133, "ep3_etyyy_chrilooc (main row 1616)"}, -- registered name equals spawns
		{"ep3_etyyy_wrelaac", -507.5, 179.535, -112.16, 35.349, "ep3_etyyy_wrelaac (main row 1617)"}, -- registered name equals spawns
		{"ep3_etyyy_mada_johnson", -478.41, 211.338, -92.74, 100.098, "ep3_etyyy_mada_johnson (main row 1618)"}, -- registered name equals spawns
		{"ep3_harwakokok_mighty", -419.1, 179.386, -88.78, 245.408, "ep3_harwakokok_mighty (main row 1619)"}, -- registered name equals spawns
		{"ep3_cmd_richards", -635.95, 22.8335, -119.63, 73.911, "ep3_cmd_richards (main row 1620)"}, -- registered name equals spawns
		{"ep3_dr_price", -660.88, 25.8335, -111.88, 125.478, "ep3_dr_price (main row 1621)"}, -- registered name equals spawns
		{"ep3_olima_grunc", 220.82, 18.5518, 40.51, 81.933, "ep3_olima_grunc (main row 1622)"}, -- registered name equals spawns
		{"ep3_boshaz", 110.01, 26.9675, 168.42, 146.104, "ep3_boshaz (main row 1623)"}, -- registered name equals spawns
		{"ep3_mssikss", 125.71, 22.3529, 195.29, 49.847, "ep3_mssikss (main row 1624)"}, -- registered name equals spawns
		{"ep3_ysith", 132.92, 22.3529, 204.68, 191.55, "ep3_ysith (main row 1625)"}, -- registered name equals spawns
		{"ep3_borantok", 461.49, 19.0716, 258.7, 233.376, "ep3_borantok (main row 1626)"}, -- registered name equals spawns
		{"ep3_dakar", 522.8, 24.8102, 267.3, 97.403, "ep3_dakar (main row 1627)"}, -- registered name equals spawns
		{"ep3_tempal_buncho", 497.19, 27.0588, 275.74, 0, "ep3_tempal_buncho (main row 1628)"}, -- registered name equals spawns
		{"ep3_musolium", 518.99, 24.7059, 433.37, 84.798, "ep3_musolium (main row 1629)"}, -- registered name equals spawns
		{"ep3_lesnorr", 539.24, 30.7403, 482.95, 206.265, "ep3_lesnorr (main row 1630)"}, -- registered name equals spawns
		{"ep3_pressk", -93.15, 18.3847, 98.56, -25.783, "ep3_pressk (main row 1632)"}, -- registered name equals spawns
		{"ep3_eyma", -549.64, 18.9918, -132.42, -46.262, "ep3_eyma (main row 1633)"}, -- registered name equals spawns
		{"ep3_clone_relics_ovarra", -425.85, 179.545, -85.21, 187.54, "ep3_clone_relics_ovarra (main row 1634)"}, -- registered name equals spawns
		{"ep3_clone_relics_geonosian_ikvizi", -513.05, 19.3062, -108.74, 194.232, "ep3_clone_relics_geonosian_ikvizi (main row 1635)"}, -- registered name equals spawns
		{"ep3_ssiksik", 208.81, 26.7459, 109.15, 146.677, "ep3_ssiksik (main row 1636)"}, -- registered name equals spawns
		{"ep3_ortha_ledox", 553.86, 24.7059, -654.79, 0, "ep3_ortha_ledox (main row 1637)"}, -- registered name equals spawns
		{"ep3_clone_relics_wookie_prisoner_04", 546.26, 30.9634, 463.49, 206.447, "ep3_clone_relics_wookiee_prisoner_04 (main row 1638)"}, -- numbered variant _04 (no exact name, no _01)
		{"ep3_dr_farnsworth", -504.27, 179.411, -98.91, 150.87, "ep3_dr_farnsworth (main row 1639)"}, -- registered name equals spawns
		{"ep3_unluto_bartender", -465.44, 158.143, -19.46, 225.544, "ep3_unluto_bartender (main row 1640)"}, -- registered name equals spawns
		{"ep3_col_gurnst", -457.65, 158.415, -26.9, -72.766, "ep3_col_gurnst (main row 1641)"}, -- registered name equals spawns
		{"ep3_orooroo_betrayer", 545.23, 24.7059, 402.08, -54.431, "ep3_orooroo_betrayer (main row 1642)"}, -- registered name equals spawns
		{"ep3_kachirho_chatook", -448.43, 158.584, -102.85, -28.073, "ep3_kachirho_chatook (main row 1643)"}, -- registered name equals spawns
		{"ep3_fezrik_bendledon", -442.75, 211.198, -74.56, 232.803, "ep3_fezrik_bendledon (main row 1644)"}, -- registered name equals spawns
		{"ep3_marium_valmont", -578.87, 18.8235, -68.11, 176.474, "ep3_marium_valmont (main row 1645)"}, -- registered name equals spawns
		{"ep3_criss_nepomi", -495.54, 179.491, -109.9, -59.015, "ep3_criss_nepomi (main row 1646)"}, -- registered name equals spawns
		{"ep3_stren_colo", -667.66, 18.8235, -116.09, 168.632, "ep3_stren_colo (main row 1647)"}, -- registered name equals spawns
		{"ep3_belga_daeri", -441.41, 158.434, -63.77, 244.262, "ep3_belga_daeri (main row 1648)"}, -- registered name equals spawns
		{"ep3_cheyerooto", -432.37, 179.608, -96.57, 44.691, "ep3_cheyerooto (main row 1649)"}, -- registered name equals spawns
		{"ep3_gursan_bryes", -556.01, 19.8111, -71.23, 214.47, "ep3_gursan_bryes (main row 1650)"}, -- registered name equals spawns
		{"ep3_rroow", -501.77, 179.43, -113.02, 0, "ep3_rroow (main row 1651)"}, -- registered name equals spawns
		{"ep3_sera_jossi", -236.18, 6.4583, 59.79, 192.124, "ep3_sera_jossi (main row 1652)"}, -- registered name equals spawns
		{"ep3_wke_merchant_03", -548.04, 19.2773, -108.26, 0, "ep3_wke_merchant_03 (main row 1653)"}, -- registered name equals spawns
		{"ep3_wke_merchant_03", -512.49, 17.8367, -69.99, 197.67, "ep3_wke_merchant_03 (main row 1654)"}, -- registered name equals spawns
		{"ep3_wke_merchant_04", 554.85, 24.2538, -644.07, 0, "ep3_wke_merchant_04 (main row 1655)"}, -- registered name equals spawns
		{"space_ep3_chassis_broker_05", -682.21, 18.8235, -160.87, 0, "ep3_chassis_broker_05 (main row 1656)"}, -- single repo candidate
		{"ep3_mining_flash_harrison", -453.74, 158.428, -20.06, 264.915, "ep3_mining_flash_harrison (main row 1657)"}, -- registered name equals spawns
		{"ep3_mining_captain_koh", -441.35, 211.219, -75.77, 265.462, "ep3_mining_captain_koh (main row 1658)"}, -- registered name equals spawns
		{"ep3_rawarok", -131.81, 22.7451, 861.22, 262.024, "ep3_rawarok (main row 1659)"}, -- registered name equals spawns
		{"ep3_chewbacca", -587.29, 18.5615, -104.16, -21.772, "chewbacca (main row 1660)"}, -- single repo candidate
		{"ep3_wke_vryyyr", -589.23, 18.4857, -103.28, 26.357, "ep3_wke_vryyyr (main row 1661)"}, -- registered name equals spawns
		{"ep3_hssissk_bloodscale", 517.05, 24.7059, 426.54, 88.808, "ep3_hssissk_bloodscale (main row 1672)"}, -- registered name equals spawns
		{"ep3_etyyy_sordaan_xris", 276.31, 48, -2505.77, -72.766, "ep3_etyyy_sordaan_xris (hunting row 356)"}, -- registered name equals spawns
		{"ep3_etyyy_ziven_tissak", 419.72, 47.8055, -2478.99, 204.878, "ep3_etyyy_ziven_tissak (hunting row 357)"}, -- registered name equals spawns
		{"ep3_etyyy_banol_starkiller", 246.27, 40.9675, -2540.74, 25.628, "ep3_etyyy_banol_starkiller (hunting row 358)"}, -- registered name equals spawns
		{"ep3_etyyy_manfred_carter", 115.31, 33.4733, -2554.67, 175.382, "ep3_etyyy_manfred_carter (hunting row 359)"}, -- registered name equals spawns
		{"ep3_etyyy_tripp_rar", 169.81, 43.9677, -2391.63, 157.915, "ep3_etyyy_tripp_rar (hunting row 360)"}, -- registered name equals spawns
		{"ep3_etyyy_ehartt_brihnt", 182.29, 24.7251, -2537.58, 126.051, "ep3_etyyy_ehartt_brihnt (hunting row 361)"}, -- registered name equals spawns
		{"ep3_etyyy_harroom", 292.17, 48, -2491.05, 237.918, "ep3_etyyy_harroom (hunting row 362)"}, -- registered name equals spawns
		{"ep3_etyyy_iluna_mystuk", 176.94, 40.3682, -2450.12, 33.905, "ep3_etyyy_iluna_mystuk (hunting row 363)"}, -- registered name equals spawns
		{"ep3_etyyy_kint_zsam", -99.77, 25.7985, -3249.88, 42.543, "ep3_etyyy_kint_zsam (hunting row 364)"}, -- registered name equals spawns
		{"ep3_etyyy_tuwezz_vol", -28.78, 17.5286, -3201.51, 157.341, "ep3_etyyy_tuwezz_vol (hunting row 365)"}, -- registered name equals spawns
		{"ep3_etyyy_johnson_smith", -392.8, 80.5588, -2132.74, 218.18, "ep3_etyyy_johnson_smith (hunting row 366)"}, -- registered name equals spawns
		{"ep3_etyyy_kara_corlon", -383.62, 80.5588, -2146.36, -58.206, "ep3_etyyy_kara_corlon (hunting row 367)"}, -- registered name equals spawns
		{"ep3_etyyy_jerrol_chupapa", -621.99, 9.0258, -2085, 132.52, "ep3_etyyy_jerrol_chupapa (hunting row 368)"}, -- registered name equals spawns
		{"ep3_etyyy_ryoo_finn", -614.96, 8.7683, -2148.77, 0, "ep3_etyyy_ryoo_finn (hunting row 369)"}, -- registered name equals spawns
		{"ep3_etyyy_pilot_to_bocctyyy", 381.47, 41.7397, -2388.2, 243.577, "ep3_etyyy_pilot_to_bocctyyy (hunting row 370)"}, -- registered name equals spawns
		{"ep3_rodian_camp_doctor_01", 224.39, 23.0029, -2429, 119.358, "ep3_etyyy_rodian_camp_doctor_01 (hunting row 371)"}, -- single repo candidate
		{"ep3_rodian_trader", 185.39, 40.3779, -2452.82, -64.174, "ep3_etyyy_rodian_trader (hunting row 372)"}, -- single repo candidate
		{"dressed_forest_outcast_informant", -1616.63, 31.9644, 1332.17, 0, "ep3_forest_outcast_informant (dead forest row 123)"}, -- single repo candidate
		{"dressed_ep3_forest_outcast_male_02", -1708.35, 17.4895, 1338.09, 180.664, "ep3_forest_outcast_male_02 (dead forest row 125)"}, -- single repo candidate
		{"arena_guard_outer", -1799.65, 38.7284, 1288.17, -22.345, "ep3_forest_arena_guard_outer (dead forest row 126)"}, -- single repo candidate
		{"dressed_ep3_forest_ardon", -1690.23, 31.6392, 1375.36, 95.684, "ep3_forest_ardon (dead forest row 131)"}, -- single repo candidate
		{"dressed_ep3_forest_kerritamba_dealer", -1663.23, 31.64, 1326.31, -20.626, "ep3_forest_kerritamba_dealer (dead forest row 132)"}, -- single repo candidate
		{"dressed_ep3_forest_npc_greeter", -1477.77, 26.4235, 1147.87, 126.806, "ep3_forest_npc_greeter (dead forest row 133)"}, -- single repo candidate
	}
}

registerScreenPlay("KashyyykStaticNpcsScreenPlay", true)

function KashyyykStaticNpcsScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnNpcs()
	end
end

function KashyyykStaticNpcsScreenPlay:spawnNpcs()
	local npcs = self.npcs

	for i = 1, #npcs, 1 do
		local npc = npcs[i]
		spawnMobile("kashyyyk", npc[1], 0, npc[2], npc[3], npc[4], npc[5], 0)
	end
end
