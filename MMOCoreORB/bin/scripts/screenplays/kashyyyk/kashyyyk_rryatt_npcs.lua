-- Kashyyyk Rryatt Trail static NPCs (ruling 2026-09-04: "ensure kashyyyk is fully done").
-- Celebrity spawners from the lvl 1-2 / lvl 4 / lvl 5 buildout tabs. Copy #0 only
-- (six copies of every level layout are the maintainer's ruling, same cut / 
-- used). World coords are x, z, y = wx, py, wz already offset to copy #0:
--   lvl 1-2  dx -3908  dz +3365
--   lvl 4    dx -3908  dz +2115
--   lvl 5    dx -2208  dz +2115
-- Heading is baked as degrees(2 * atan2(qy, qw)) from the placement quaternion:
-- no quaternion-to-heading converter exists in tools/ or screenplays (qx = qz = 0
-- on these rows). spawnMobile respawn is 0, matching unique static NPCs in
-- cities/*.lua (tatooine_wayfar.lua:169 informant_npc_lvl_2). spawnMobile does
-- not revive them; this screenplay does not add a despawn observer.
--
-- Template per row is the repo registration whose name equals the SOE spawns
-- name. A near-name (ep3_carl_mosik for ep3_rryatt_carl_mosik, guild_f for
-- guide_f) is a look-alike and is never substituted. Female guide rows spawn
-- the SOE name; those Creature:new files arrive with the rryatt arc branch.
-- lvl 3 has no celebrity_spawner rows and its offset is OPEN.

KashyyykRryattNpcs = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "KashyyykRryattNpcs",

	-- {template, x, z, y, heading, "<SOE spawns name> (<tab> row N)"}
	npcs = {
		{"ep3_rryatt_krepauk", -3766.64, 168.235, 3637.19, 183.919, "ep3_rryatt_krepauk (lvl 1-2 row 46)"}, -- registered name equals spawns
		-- OPEN: ep3_rryatt_carl_mosik (lvl 1-2 row 47) world (-3764.73, 168.235, 3590.66) heading -10.886 -- repo has ep3_carl_mosik, not the SOE spawns name, never a look-alike
		-- OPEN: ep3_rryatt_zhailaut (lvl 1-2 row 48) world (-3767.72, 168.235, 3589.84) heading 0 -- repo has ep3_zhailaut, not the SOE spawns name, never a look-alike
		{"ep3_rryatt_vritol", -3513.75, 143.421, 4058.75, 126.218, "ep3_rryatt_vritol (lvl 1-2 row 49)"}, -- registered name equals spawns
		-- OPEN: ep3_rryatt_negal_teklon (lvl 1-2 row 50) world (-3337.9, 140, 4039.61) heading -51.457 -- repo has ep3_negal_teklon, not the SOE spawns name, never a look-alike
		{"ep3_rryatt_tressk", -3040.29, 120, 4554.44, 123.186, "ep3_rryatt_tressk (lvl 1-2 row 51)"}, -- registered name equals spawns
		{"ep3_rryatt_trail_guide_f_01", -3182.25, 114.705, 4073.97, -33.232, "ep3_rryatt_trail_guide_f_01 (lvl 1-2 row 52)"}, -- template arrives with the rryatt arc branch
		{"ep3_rryatt_trail_guide_m_01", -2945.9, 70.1953, 4256.58, -66.457, "ep3_rryatt_trail_guide_m_01 (lvl 1-2 row 53)"}, -- registered name equals spawns
		{"ep3_rryatt_trail_guide_f_02", -2692.67, 120, 4210.16, -55.302, "ep3_rryatt_trail_guide_f_02 (lvl 1-2 row 54)"}, -- template arrives with the rryatt arc branch
		-- OPEN: ep3_rryatt_achonnko (lvl 1-2 row 56) world (-3782.1, 169.417, 3582.29) heading 53.286 -- no Creature:new
		{"ep3_rryatt_trail_guide_m_03", -3595.58, 140, 3080.84, 64.77, "ep3_rryatt_trail_guide_m_03 (lvl 4 row 62)"}, -- registered name equals spawns
		{"ep3_rryatt_trail_guide_f_04", -2592.53, 142.647, 3078.24, 252.596, "ep3_rryatt_trail_guide_f_04 (lvl 4 row 63)"}, -- template arrives with the rryatt arc branch
		{"ep3_rryatt_trail_guide_m_04", -1878.51, -23.4006, 2611.74, 137.177, "ep3_rryatt_trail_guide_m_04 (lvl 5 row 273)"}, -- registered name equals spawns
	}
}

registerScreenPlay("KashyyykRryattNpcs", true)

function KashyyykRryattNpcs:start()
	if (isZoneEnabled("kashyyyk_rryatt_trail")) then
		self:spawnNpcs()
	end
end

function KashyyykRryattNpcs:spawnNpcs()
	local npcs = self.npcs
	local placed = 0

	for i = 1, #npcs, 1 do
		local npc = npcs[i]
		local pNpc = spawnMobile("kashyyyk_rryatt_trail", npc[1], 0, npc[2], npc[3], npc[4], npc[5], 0)

		if (pNpc ~= nil) then
			placed = placed + 1
		end
	end

	print("KashyyykRryattNpcs: " .. placed .. " placed")
end
