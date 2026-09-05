--[[
	Meatlump puzzle containers and the two drawable calibration pages.

	ruling 2026-09-05: "ensuring meatlump ... done"

	NO JOURNAL.

	OPEN: CollectionManager.modifyCollectionSlotValue is paid on a game3/game4
	win. The collections branch merges later; print when the global is absent.
	canCollectCollectible uses CollectionManager.hasCompletedCollectionSlotPrereq /
	hasCompletedCollection / hasCompletedCollectionSlot the same way; print and
	skip those three when the global is absent (OURS).

	OPEN: /Script.sliceTerminal, /Script.questionnaire, /Script.disarmBomb
	do not ship. Placeholder radial uses @meatlump/meatlump:you_have_debuff
	(no "not available" key in the 64 shipped keys).

	OURS: puzzle downer and buff are DirectorSharedMemory timers. This fork has
	no CreatureObject hasBuff/addBuff and the six *_puzzle_downer / *_puzzle_buff
	templates do not exist. downerUntil / applyDowner write
	playerOid .. ":mtpDowner:" .. kind = os.time() + 45 (buff.tab:1707-1712,
	<kind>_puzzle_downer DURATION 45). The -50 constitution/agility/stamina on
	those rows is NGE stat balance -> OPEN (not applied). hasPuzzleBuff reads
	playerOid .. ":mtpBuff:" .. kind (buff.tab:1713-1718 DURATION 120, +10 tries
	at destroy_food_supplies.java:110). Nothing grants it yet -> OPEN.
]]

MtpMinigameObjects = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MtpMinigameObjects",
	ITEM_USE = 20, -- menu_info_types.ITEM_USE
	DEFAULT_TRIES = 10, -- destroy_food_supplies.java:33 / destroy_weapon_cache.java:34
	BUFF_TRIES_INCREASE = 10, -- java:34 / :35
	MAX_RANGE = 5, -- collection.MAX_RANGE_TO_COLLECT
	FORCE_CLOSE = 10, -- java setSUIMaxRangeToObject 10.0f
	DOWNER_SECONDS = 45, -- buff.tab:1707-1712 DURATION
	BUFF_SECONDS = 120, -- buff.tab:1713-1718 DURATION; nothing grants yet
	puzzleKind = {
		destroy_food_supplies = "food_supplies",
		destroy_weapon_cache = "weapons_cache",
		slicing_minigame = "safe",
		code_break_minigame = "locked_container",
		target_map_puzzle = "target_map",
		-- bomb_defuse: no placed container in the shipped tables; buff.tab:1712 / :1718
	},
	playerButtons = {
		"top.triangles.player.right.1",
		"top.triangles.player.right.2",
		"top.triangles.player.right.3",
		"top.triangles.player.left.2",
		"top.triangles.player.left.3",
		"top.triangles.player.left.1",
	}, -- destroy_weapon_cache.java:36-44
	serverButtons = {
		"top.triangles.server.right.1",
		"top.triangles.server.right.2",
		"top.triangles.server.right.3",
		"top.triangles.server.left.2",
		"top.triangles.server.left.3",
		"top.triangles.server.left.1",
	}, -- destroy_weapon_cache.java:45-53
	radialLabel = {
		code_break_minigame = "@meatlump/meatlump:meatlump_container_open",
		destroy_food_supplies = "@meatlump/meatlump:food_calibration_use",
		destroy_weapon_cache = "@meatlump/meatlump:weapon_calibration_use",
		slicing_minigame = "@meatlump/meatlump:meatlump_safe_open",
		target_map_puzzle = "@meatlump/meatlump:meatlump_decipher_map",
	},
	deviceTemplate = {
		code_break_minigame = "object/tangible/meatlump/event/slicing_device_meatlump_container.iff",
		destroy_food_supplies = "object/tangible/meatlump/event/slicing_device_meatlump_food.iff",
		destroy_weapon_cache = "object/tangible/meatlump/event/slicing_device_meatlump_weapon.iff",
		slicing_minigame = "object/tangible/meatlump/event/slicing_device_meatlump_safe.iff",
		target_map_puzzle = "object/tangible/meatlump/event/slicing_device_meatlump_map.iff",
	},
	containers = {
	{
		planet = "corellia",
		tab = "corellia_2_3",
		template = "object/tangible/meatlump/event/meatlump_container_01_09.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_09",
		x = -5700.916, z = 46.0827, y = -2326.01,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_2_3",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_05.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_05",
		x = -5704.521, z = 46.2903, y = -2327.61,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_2_3",
		template = "object/tangible/meatlump/event/meatlump_safe_01_06.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_06",
		x = -5702.17, z = 46.0393, y = -2326.14,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_2_3",
		template = "object/tangible/meatlump/event/meatlump_map_01_10.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_10",
		x = -5702.36, z = 46.55, y = -2329,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_2_3",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_07.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_07",
		x = -5704.113, z = 46.6928, y = -2332.29,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_3_6",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_10.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_10",
		x = -3961.477, z = 20.9543, y = 3156.22,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_3_6",
		template = "object/tangible/meatlump/event/meatlump_map_01_03.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_03",
		x = -3956.803, z = 21.5007, y = 3172.25,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_3_6",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_08.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_08",
		x = -3960.579, z = 20.8956, y = 3159.45,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_3_6",
		template = "object/tangible/meatlump/event/meatlump_container_01_02.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_02",
		x = -3957.247, z = 22.973, y = 3171.23,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_3_6",
		template = "object/tangible/meatlump/event/meatlump_safe_01_03.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_03",
		x = -3952.08, z = 22.1154, y = 3171.2,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_11.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_11",
		x = 42.9734, z = -36, y = 133.226,
		qw = 0.0292, qx = 0, qy = 0.99957, qz = 0,
		building = "main", cellName = "storage",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_11.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_11",
		x = -46.1251, z = -36, y = 83.3322,
		qw = 1, qx = 0, qy = 0, qz = 0,
		building = "main", cellName = "kitchen",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_safe_01_11.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_11",
		x = -79.9115, z = -36, y = 159.775,
		qw = 0.64483, qx = 0, qy = 0.76433, qz = 0,
		building = "main", cellName = "greathall",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_container_01_11.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_11",
		x = -83.6708, z = -36, y = 185.47,
		qw = 0.5403, qx = 0, qy = 0.84147, qz = 0,
		building = "main", cellName = "greathall",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_map_01_11.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_11",
		x = -43.1596, z = -35.9909, y = 235.665,
		qw = -0.42785, qx = -0.56165, qy = 0.56775, qz = 0.42326,
		building = "main", cellName = "quarters01",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_safe_01_12.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_12",
		x = -8.03518, z = -36, y = 256.012,
		qw = -0.68587, qx = 0, qy = 0.72773, qz = 0,
		building = "main", cellName = "quarters02",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_container_01_12.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_12",
		x = -19.894, z = -36, y = 182.433,
		qw = 0.74517, qx = 0, qy = 0.66687, qz = 0,
		building = "main", cellName = "quarters03",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_map_01_12.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_12",
		x = 80.258, z = -36, y = 216.843,
		qw = -0.26014, qx = -0.64882, qy = 0.66912, qz = 0.25225,
		building = "main", cellName = "premasterroom",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_12.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_12",
		x = 66.1972, z = -36, y = 159.255,
		qw = 1, qx = 0, qy = 0, qz = 0,
		building = "main", cellName = "masterroom",
	},
	{
		planet = "corellia",
		tab = "corellia_4_2",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_12.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_12",
		x = 78.587, z = -36, y = 159.922,
		qw = 1, qx = 0, qy = 0, qz = 0,
		building = "main", cellName = "masterroom",
	},
	{
		planet = "corellia",
		tab = "corellia_6_7",
		template = "object/tangible/meatlump/event/meatlump_map_01_01.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_01",
		x = 3605.01, z = 427.92, y = 5824.37,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_6_7",
		template = "object/tangible/meatlump/event/meatlump_safe_01_05.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_05",
		x = 3609.48, z = 427.655, y = 5825.32,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_6_7",
		template = "object/tangible/meatlump/event/meatlump_container_01_10.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_10",
		x = 3610.74, z = 427.866, y = 5826.2,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_6_7",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_08.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_08",
		x = 3608.33, z = 427.835, y = 5822.39,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "corellia",
		tab = "corellia_6_7",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_06.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_06",
		x = 3607.22, z = 427.721, y = 5825.61,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "lok",
		tab = "lok_5_7",
		template = "object/tangible/meatlump/event/meatlump_container_01_01.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_01",
		x = 270.709, z = 12.0285, y = 4638.23,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "lok",
		tab = "lok_5_7",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_09.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_09",
		x = 263.776, z = 12.0928, y = 4627.17,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "lok",
		tab = "lok_5_7",
		template = "object/tangible/meatlump/event/meatlump_map_01_02.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_02",
		x = 257.574, z = 12.0508, y = 4639.331,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "lok",
		tab = "lok_5_7",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_07.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_07",
		x = 273.067, z = 12.0356, y = 4638.43,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "lok",
		tab = "lok_5_7",
		template = "object/tangible/meatlump/event/meatlump_safe_01_04.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_04",
		x = 271.723, z = 12.0258, y = 4636.305,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_02.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_02",
		x = -5242.90658, z = 6.7, y = 3656.78058,
		qw = 1, qx = 0, qy = 0, qz = 0,
		nabooHouse = true, -- OPEN: SOE cell of ply_nboo_house_s_s02_fp1; no snapshot oid
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_04.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_04",
		x = -5244.92812, z = 6.7, y = 3660.04813,
		qw = 1, qx = 0, qy = 0, qz = 0,
		nabooHouse = true, -- OPEN: SOE cell of ply_nboo_house_s_s02_fp1; no snapshot oid
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_map_01_07.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_07",
		x = -5250.48569, z = 6.750249, y = 3661.39631,
		qw = 1, qx = 0, qy = 0, qz = 0,
		nabooHouse = true, -- OPEN: SOE cell of ply_nboo_house_s_s02_fp1; no snapshot oid
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_container_01_06.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_06",
		x = -5255.85045, z = 6.7, y = 3664.80777,
		qw = 1, qx = 0, qy = 0, qz = 0,
		nabooHouse = true, -- OPEN: SOE cell of ply_nboo_house_s_s02_fp1; no snapshot oid
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_safe_01_09.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_09",
		x = -5254.89261, z = 6.7, y = 3666.66794,
		qw = 1, qx = 0, qy = 0, qz = 0,
		nabooHouse = true, -- OPEN: SOE cell of ply_nboo_house_s_s02_fp1; no snapshot oid
	},
	{
		planet = "naboo",
		tab = "naboo_7_2",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_05.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_05",
		x = 4640.829, z = 6.30571, y = -5050.84,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "naboo",
		tab = "naboo_7_2",
		template = "object/tangible/meatlump/event/meatlump_container_01_07.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_07",
		x = 4639.978, z = 6.02221, y = -5057.69,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "naboo",
		tab = "naboo_7_2",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_03.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_03",
		x = 4633.669, z = 6.18935, y = -5058.75,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "naboo",
		tab = "naboo_7_2",
		template = "object/tangible/meatlump/event/meatlump_map_01_08.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_08",
		x = 4638.585, z = 6.19446, y = -5058.15,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "naboo",
		tab = "naboo_7_2",
		template = "object/tangible/meatlump/event/meatlump_safe_01_08.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_08",
		x = 4642.316, z = 5.76525, y = -5056.29,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "rori",
		tab = "rori_2_3",
		template = "object/tangible/meatlump/event/meatlump_safe_01_01.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_01",
		x = -5157.398, z = 79.9401, y = -2537.97,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "rori",
		tab = "rori_2_3",
		template = "object/tangible/meatlump/event/meatlump_map_01_05.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_05",
		x = -5153.587, z = 80.0414, y = -2538.24,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "rori",
		tab = "rori_2_3",
		template = "object/tangible/meatlump/event/meatlump_container_01_04.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_04",
		x = -5152.804, z = 80.937, y = -2537,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "rori",
		tab = "rori_2_3",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_10.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_10",
		x = -5164.809, z = 80.0054, y = -2549.43,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "rori",
		tab = "rori_2_3",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_02.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_02",
		x = -5149.148, z = 79.8611, y = -2550.84,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "talus",
		tab = "talus_6_7",
		template = "object/tangible/meatlump/event/meatlump_safe_01_02.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_02",
		x = 3959.47, z = 2, y = 5072.098,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "talus",
		tab = "talus_6_7",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_01.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_01",
		x = 3967.67, z = 1.99107, y = 5074.019,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "talus",
		tab = "talus_6_7",
		template = "object/tangible/meatlump/event/meatlump_container_01_03.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_03",
		x = 3959.2, z = 2.93753, y = 5070.421,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "talus",
		tab = "talus_6_7",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_09.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_09",
		x = 3959.01, z = 2, y = 5077.93,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "talus",
		tab = "talus_6_7",
		template = "object/tangible/meatlump/event/meatlump_map_01_04.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_04",
		x = 3964.85, z = 2.03578, y = 5070.951,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_2_1",
		template = "object/tangible/meatlump/event/meatlump_container_01_08.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_08",
		x = -5216.43, z = 75.8891, y = -6772.13,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_2_1",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_04.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_04",
		x = -5218.81, z = 75.6484, y = -6774.13,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_2_1",
		template = "object/tangible/meatlump/event/meatlump_safe_01_07.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_07",
		x = -5216.538, z = 75.9886, y = -6770.42,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_2_1",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_06.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_06",
		x = -5218.973, z = 75.2887, y = -6776.75,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_2_1",
		template = "object/tangible/meatlump/event/meatlump_map_01_09.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_09",
		x = -5213.993, z = 75.7447, y = -6773.5,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_6_6",
		template = "object/tangible/meatlump/event/meatlump_container_01_05.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_05",
		x = 3966.55, z = 9.16642, y = 2428.726,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_6_6",
		template = "object/tangible/meatlump/event/meatlump_food_palette_01_01.iff",
		kind = "destroy_food_supplies",
		slot = "col_meatlump_food_sabotage_01:meatlump_food_crate_01_01",
		x = 3962.26, z = 8.722, y = 2425.844,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_6_6",
		template = "object/tangible/meatlump/event/meatlump_map_01_06.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_06",
		x = 3967.05, z = 9.21367, y = 2425.633,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_6_6",
		template = "object/tangible/meatlump/event/meatlump_safe_01_10.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_10",
		x = 3966.9, z = 9.22049, y = 2427.449,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "tatooine",
		tab = "tatooine_6_6",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_03.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_03",
		x = 3961.06, z = 8.83652, y = 2428.477,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	}
}

registerScreenPlay("MtpMinigameObjects", true)

function MtpMinigameObjects:start()
	local spawned = 0
	local present = 0

	for i = 1, #self.containers do
		local row = self.containers[i]

		if (isZoneEnabled(row.planet)) then
			local existed = self:spawnIfMissing(row)

			if (existed) then
				present = present + 1
			else
				spawned = spawned + 1
			end
		end
	end

	print("[meatlump] minigame containers: present=" .. present .. " spawned=" .. spawned)
end

function MtpMinigameObjects:hideoutCell(cellName)
	if (MeatlumpHideoutScreenPlay == nil) then
		return nil
	end

	local pBuilding = getSceneObject(MeatlumpHideoutScreenPlay.MAIN_ID)

	if (pBuilding == nil) then
		return nil
	end

	return BuildingObject(pBuilding):getNamedCell(cellName)
end

function MtpMinigameObjects:spawnIfMissing(row)
	local cellID = 0
	local pCell = nil

	if (row.building == "main" and row.cellName ~= nil) then
		pCell = self:hideoutCell(row.cellName)

		if (pCell == nil) then
			print("[meatlump] minigame cell not found: " .. row.cellName)
			return false
		end

		cellID = SceneObject(pCell):getObjectID()

		for n = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
			local pObj = SceneObject(pCell):getContainerObject(n)

			if (pObj ~= nil and SceneObject(pObj):getTemplateObjectPath() == row.template) then
				self:wire(pObj, row)
				return true
			end
		end
	else
		local key = "mtpMinigame:" .. row.slot
		local oid = readData(key)

		if (oid ~= nil and oid ~= 0) then
			local pExisting = getSceneObject(oid)

			if (pExisting ~= nil) then
				self:wire(pExisting, row)
				return true
			end
		end
	end

	local pObj = spawnSceneObject(row.planet, row.template, row.x, row.z, row.y, cellID, row.qw, row.qx, row.qy, row.qz)

	if (pObj == nil) then
		print("[meatlump] minigame spawn failed: " .. row.template)
		return false
	end

	writeData("mtpMinigame:" .. row.slot, SceneObject(pObj):getObjectID())
	self:wire(pObj, row)
	return false
end

function MtpMinigameObjects:wire(pObj, row)
	local oid = SceneObject(pObj):getObjectID()

	writeStringData(oid .. ":mtpKind", row.kind)
	writeStringData(oid .. ":mtpSlot", row.slot)
	SceneObject(pObj):setObjectMenuComponent("MtpMinigameMenuComponent")
end

function MtpMinigameObjects.slotLeaf(slot)
	if (slot == nil) then
		return nil
	end

	local colon = string.find(slot, ":", 1, true)

	if (colon == nil) then
		return slot
	end

	return string.sub(slot, colon + 1)
end

-- collection.java:1204-1210: split collection.slotName on ':'
function MtpMinigameObjects.splitSlot(slot)
	if (slot == nil or slot == "") then
		return nil, nil
	end

	local colon = string.find(slot, ":", 1, true)

	if (colon == nil) then
		return nil, slot
	end

	return string.sub(slot, 1, colon - 1), string.sub(slot, colon + 1)
end

-- OPEN: collections branch merges later. Java pays collection.slotName on a win.
function MtpMinigameObjects.paySlot(pPlayer, slot)
	if (pPlayer == nil or slot == nil) then
		return
	end

	local leaf = MtpMinigameObjects.slotLeaf(slot)

	if (CollectionManager == nil or CollectionManager.modifyCollectionSlotValue == nil) then
		print("[meatlump] CollectionManager absent; slot " .. tostring(slot) .. " not paid")
		return
	end

	CollectionManager.modifyCollectionSlotValue(pPlayer, leaf, 1)
end

-- collection.java:323-340
function MtpMinigameObjects.checkState(pPlayer)
	if (CreatureObject(pPlayer):isInCombat()) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:click_not_combat")
		return false
	end

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:click_not_mounted")
		return false
	end

	if (CreatureObject(pPlayer):isDead() or CreatureObject(pPlayer):isIncapacitated()) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:click_not_dead_incap")
		return false
	end

	return true
end

-- collection.java:1185-1236
function MtpMinigameObjects.canCollectCollectible(pPlayer, pObj)
	if (pPlayer == nil or pObj == nil) then
		return false
	end

	if (not MtpMinigameObjects.checkState(pPlayer)) then
		return false
	end

	local slot = readStringData(SceneObject(pObj):getObjectID() .. ":mtpSlot")

	if (slot == nil or slot == "") then
		return false
	end

	local collectionName, slotName = MtpMinigameObjects.splitSlot(slot)

	if (collectionName == nil or collectionName == "") then
		return false
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pObj, MtpMinigameObjects.MAX_RANGE)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:not_close_enough")
		return false
	end

	if (CollectionManager == nil or CollectionManager.hasCompletedCollectionSlotPrereq == nil or CollectionManager.hasCompletedCollection == nil or CollectionManager.hasCompletedCollectionSlot == nil) then
		print("[meatlump] CollectionManager absent; collection checks skipped")
		return true
	end

	if (not CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, slotName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:need_to_activate_collection")
		return false
	end

	if (CollectionManager.hasCompletedCollection(pPlayer, collectionName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:already_finished_collection")
		return false
	end

	if (slotName == nil or slotName == "" or CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:already_have_slot")
		return false
	end

	return true
end

-- OURS: DirectorSharedMemory stand-in for <kind>_puzzle_downer (buff.tab DURATION 45)
function MtpMinigameObjects.downerUntil(pPlayer, kind)
	if (pPlayer == nil or kind == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. ":mtpDowner:" .. kind) or 0
end

function MtpMinigameObjects.applyDowner(pPlayer, kind)
	if (pPlayer == nil or kind == nil) then
		return
	end

	writeData(SceneObject(pPlayer):getObjectID() .. ":mtpDowner:" .. kind, os.time() + MtpMinigameObjects.DOWNER_SECONDS)
end

function MtpMinigameObjects.consumeDevice(pPlayer, kind)
	local template = MtpMinigameObjects.deviceTemplate[kind]

	if (template == nil) then
		return true
	end

	local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")

	if (pInv == nil) then
		return false
	end

	local pDev = getContainerObjectByTemplate(pInv, template, true)

	if (pDev == nil) then
		return false
	end

	SceneObject(pDev):destroyObjectFromWorld()
	SceneObject(pDev):destroyObjectFromDatabase()
	return true
end

-- OURS: DirectorSharedMemory stand-in for <kind>_puzzle_buff. OPEN: nothing grants
-- playerOid .. ":mtpBuff:" .. kind = os.time() + BUFF_SECONDS yet.
function MtpMinigameObjects.hasPuzzleBuff(pPlayer, kind)
	if (pPlayer == nil or kind == nil) then
		return false
	end

	local expiry = readData(SceneObject(pPlayer):getObjectID() .. ":mtpBuff:" .. kind) or 0

	return expiry > os.time()
end

function MtpMinigameObjects.num2hex(num)
	local hexstr = "0123456789abcdef"
	local s = ""
	local n = math.floor(num)

	while (n > 0) do
		local mod = math.fmod(n, 16)
		s = string.sub(hexstr, mod + 1, mod + 1) .. s
		n = math.floor(n / 16)
	end

	if (s == "") then
		s = "0"
	end

	return s
end

function MtpMinigameObjects.grayHex(value)
	local pct = value / 100
	local dec = math.floor(255 * pct)
	local hex = MtpMinigameObjects.num2hex(dec)

	if (string.len(hex) == 1) then
		hex = "0" .. hex
	end

	return "#" .. hex .. hex .. hex
end

function MtpMinigameObjects.cleanupFood(pPlayer)
	local playerID = SceneObject(pPlayer):getObjectID()

	deleteData(playerID .. ":mtpFood:tries")
	deleteData(playerID .. ":mtpFood:maxTries")
	deleteData(playerID .. ":mtpFood:oid")
	deleteData(playerID .. ":mtpFood:Pid")

	for i = 1, 3 do
		deleteData(playerID .. ":mtpFood:goal" .. i)
	end
end

function MtpMinigameObjects.cleanupWeapon(pPlayer)
	local playerID = SceneObject(pPlayer):getObjectID()

	deleteData(playerID .. ":mtpWeapon:tries")
	deleteData(playerID .. ":mtpWeapon:maxTries")
	deleteData(playerID .. ":mtpWeapon:oid")
	deleteData(playerID .. ":mtpWeapon:Pid")

	for i = 1, 6 do
		deleteData(playerID .. ":mtpWeapon:goal" .. i)
		deleteData(playerID .. ":mtpWeapon:current" .. i)
	end
end

function MtpMinigameObjects:openFood(pPlayer, pObj)
	local sui = SuiCalibrationGame3.new("MtpMinigameObjects", "foodCallback")
	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = SceneObject(pObj):getObjectID()

	sui.setTargetNetworkId(oid)
	sui.setForceCloseDistance(self.FORCE_CLOSE)

	local tries = self.DEFAULT_TRIES

	if (self.hasPuzzleBuff(pPlayer, "food_supplies")) then
		tries = tries + self.BUFF_TRIES_INCREASE
	end

	writeData(playerID .. ":mtpFood:oid", oid)
	writeData(playerID .. ":mtpFood:tries", tries)
	writeData(playerID .. ":mtpFood:maxTries", tries)

	for i = 1, 3 do
		local goal = getRandomNumber(0, 100)
		writeData(playerID .. ":mtpFood:goal" .. i, goal)
		sui.setProperty("top.sliders." .. i .. ".slider", "Value", "100")
		sui.setProperty("top.bars.server." .. i, "Color", self.grayHex(goal))
	end

	sui.setSliderTitle(1, "@meatlump/meatlump:food_calibration_slider1")
	sui.setSliderTitle(2, "@meatlump/meatlump:food_calibration_slider2")
	sui.setSliderTitle(3, "@meatlump/meatlump:food_calibration_slider3")
	sui.setTitle("Mix Biological Yeast")
	sui.setDescription("@meatlump/meatlump:food_calibration_description")
	sui.setAttemptsDesc("@meatlump/meatlump:food_calibration_attempts_remaining" .. " 100%")
	sui.subscribeToEvent(SuiEventType.SET_onButton, "btnOk", "MtpMinigameObjects:foodCallback")
	sui.subscribeToPropertyForEvent(SuiEventType.SET_onButton, "top.sliders.1.slider", "Value")
	sui.subscribeToPropertyForEvent(SuiEventType.SET_onButton, "top.sliders.2.slider", "Value")
	sui.subscribeToPropertyForEvent(SuiEventType.SET_onButton, "top.sliders.3.slider", "Value")

	local pageId = sui.sendTo(pPlayer)
	writeData(playerID .. ":mtpFood:Pid", pageId)
end

function MtpMinigameObjects:foodCallback(pPlayer, pSui, eventIndex, ...)
	if (pPlayer == nil) then
		return
	end

	local cancelPressed = (eventIndex == 1)
	local playerID = SceneObject(pPlayer):getObjectID()
	local pageId = readData(playerID .. ":mtpFood:Pid")

	if (pageId == 0) then
		return
	end

	if (cancelPressed) then
		self.applyDowner(pPlayer, "food_supplies")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_canceled_early")
		self.cleanupFood(pPlayer)
		return
	end

	local oid = readData(playerID .. ":mtpFood:oid")
	local pObj = getSceneObject(oid)

	if (pObj == nil) then
		self.cleanupFood(pPlayer)
		return
	end

	local pPageData = LuaSuiBoxPage(pSui):getSuiPageData()

	if (pPageData == nil) then
		self.applyDowner(pPlayer, "food_supplies")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_canceled_early")
		self.cleanupFood(pPlayer)
		return
	end

	local suiPageData = LuaSuiPageData(pPageData)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		PlayerObject(pGhost):addSuiBox(pSui)
	end

	local args = {...}
	local tries = readData(playerID .. ":mtpFood:tries")
	local maxTries = readData(playerID .. ":mtpFood:maxTries")
	local win = true

	for i = 1, 3 do
		local goal = readData(playerID .. ":mtpFood:goal" .. i)
		local current = tonumber(args[i]) or 0
		local delta = goal - current

		suiPageData:setProperty("top.sliders." .. i .. ".slider", "Value", tostring(current))
		suiPageData:setProperty("top.bars.player." .. i, "Color", self.grayHex(current))

		if (delta < -5 or delta > 5) then
			win = false
		end
	end

	tries = tries - 1
	local integrity = math.floor((tries / maxTries) * 100)

	if (win) then
		self.paySlot(pPlayer, readStringData(oid .. ":mtpSlot"))
		self.cleanupFood(pPlayer)
		return
	elseif (tries <= 0) then
		suiPageData:setProperty("btnOk", "Visible", "false")
		suiPageData:setProperty("top.sliders.1.slider", "GetsInput", "false")
		suiPageData:setProperty("top.sliders.2.slider", "GetsInput", "false")
		suiPageData:setProperty("top.sliders.3.slider", "GetsInput", "false")
		suiPageData:setProperty("description.desc", "Text", "@meatlump/meatlump:food_calibration_failure")
		suiPageData:setProperty("description.attempts", "Text", "@meatlump/meatlump:food_calibration_attempts_remaining" .. " " .. integrity .. "%")
		suiPageData:sendUpdateTo(pPlayer)
		self.applyDowner(pPlayer, "food_supplies")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_failed")
		self.cleanupFood(pPlayer)
		return
	end

	suiPageData:setProperty("description.attempts", "Text", "@meatlump/meatlump:food_calibration_attempts_remaining" .. " " .. integrity .. "%")
	writeData(playerID .. ":mtpFood:tries", tries)
	suiPageData:sendUpdateTo(pPlayer)
end

-- destroy_weapon_cache.java:206-277; Lua tables are 1-based
function MtpMinigameObjects.toggleWeaponButton(config, button)
	local secondary1 = -1
	local secondary2 = -1

	if (button == 1) then
		secondary1 = 4
		secondary2 = 5
	elseif (button == 2) then
		secondary1 = 5
		secondary2 = 6
	elseif (button == 3) then
		secondary1 = 4
		secondary2 = 6
	elseif (button == 4) then
		secondary1 = 1
		secondary2 = 3
	elseif (button == 5) then
		secondary1 = 1
		secondary2 = 2
	elseif (button == 6) then
		secondary1 = 2
		secondary2 = 3
	end

	if (secondary1 < 0) then
		return config
	end

	local function flip(i)
		if (config[i] == 0) then
			config[i] = 1
		else
			config[i] = 0
		end
	end

	flip(button)
	flip(secondary1)
	flip(secondary2)
	return config
end

function MtpMinigameObjects:openWeapon(pPlayer, pObj)
	local sui = SuiCalibrationGame4.new("MtpMinigameObjects", "weaponCallback")
	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = SceneObject(pObj):getObjectID()

	sui.setTargetNetworkId(oid)
	sui.setForceCloseDistance(self.FORCE_CLOSE)

	local goal = { 0, 0, 0, 0, 0, 0 }
	local current = { 0, 0, 0, 0, 0, 0 }
	local lastRand = -1
	local mixed = false

	while (not mixed) do
		for i = 1, 6 do
			goal[i] = 0
		end

		for i = 1, 6 do
			local r = -1

			repeat
				r = getRandomNumber(1, 6)
			until (r ~= lastRand)

			lastRand = r
			goal = self.toggleWeaponButton(goal, r)
		end

		for i = 1, 6 do
			if (goal[i] ~= current[i]) then
				mixed = true
			end
		end
	end

	local tries = self.DEFAULT_TRIES

	if (self.hasPuzzleBuff(pPlayer, "weapons_cache")) then
		tries = tries + self.BUFF_TRIES_INCREASE
	end

	writeData(playerID .. ":mtpWeapon:oid", oid)
	writeData(playerID .. ":mtpWeapon:tries", tries)
	writeData(playerID .. ":mtpWeapon:maxTries", tries)

	for i = 1, 6 do
		writeData(playerID .. ":mtpWeapon:goal" .. i, goal[i])
		writeData(playerID .. ":mtpWeapon:current" .. i, current[i])

		if (goal[i] == 1) then
			sui.setProperty(self.serverButtons[i], "Color", "#000000")
		end

		sui.setProperty(self.serverButtons[i], "IsCancelButton", "false")
		sui.setProperty(self.playerButtons[i], "IsCancelButton", "false")
		sui.subscribeToEvent(SuiEventType.SET_onButton, self.playerButtons[i], "MtpMinigameObjects:weaponCallback")
	end

	sui.setProperty("bg.mmc.close", "IsCancelButton", "true")
	sui.setTitle("Calibrate Power Cell Abatement")
	sui.setDescription("@meatlump/meatlump:weapon_calibration_description")
	sui.setAttemptsDesc("@meatlump/meatlump:weapon_calibration_attempts_remaining" .. " 100%")

	local pageId = sui.sendTo(pPlayer)
	writeData(playerID .. ":mtpWeapon:Pid", pageId)
end

function MtpMinigameObjects:weaponNoCallback(pPlayer, pSui, eventIndex)
end

function MtpMinigameObjects:weaponCallback(pPlayer, pSui, eventIndex, ...)
	if (pPlayer == nil) then
		return
	end

	local cancelPressed = (eventIndex == 1)
	local playerID = SceneObject(pPlayer):getObjectID()
	local pageId = readData(playerID .. ":mtpWeapon:Pid")

	if (pageId == 0) then
		return
	end

	if (cancelPressed) then
		self.applyDowner(pPlayer, "weapons_cache")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_canceled_early")
		self.cleanupWeapon(pPlayer)
		return
	end

	local oid = readData(playerID .. ":mtpWeapon:oid")
	local pObj = getSceneObject(oid)

	if (pObj == nil) then
		self.cleanupWeapon(pPlayer)
		return
	end

	local pPageData = LuaSuiBoxPage(pSui):getSuiPageData()

	if (pPageData == nil) then
		self.applyDowner(pPlayer, "weapons_cache")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_canceled_early")
		self.cleanupWeapon(pPlayer)
		return
	end

	local suiPageData = LuaSuiPageData(pPageData)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		PlayerObject(pGhost):addSuiBox(pSui)
	end

	local button = eventIndex - 1

	if (button < 1 or button > 6) then
		return
	end

	local goal = {}
	local current = {}

	for i = 1, 6 do
		goal[i] = readData(playerID .. ":mtpWeapon:goal" .. i)
		current[i] = readData(playerID .. ":mtpWeapon:current" .. i)
		suiPageData:setProperty(self.playerButtons[i], "Color", "#FFFFFF")
	end

	current = self.toggleWeaponButton(current, button)
	local win = true

	for i = 1, 6 do
		if (current[i] == 1) then
			suiPageData:setProperty(self.playerButtons[i], "Color", "#000000")
		end

		if (current[i] ~= goal[i]) then
			win = false
		end
	end

	local tries = readData(playerID .. ":mtpWeapon:tries") - 1
	local maxTries = readData(playerID .. ":mtpWeapon:maxTries")
	local integrity = math.floor((tries / maxTries) * 100)

	if (win) then
		suiPageData:setProperty("top.description.desc", "Text", "@meatlump/meatlump:weapon_calibration_success")

		for i = 1, 6 do
			suiPageData:setProperty(self.playerButtons[i], "GetsInput", "false")
			suiPageData:subscribeToEvent(SuiEventType.SET_onButton, self.playerButtons[i], "MtpMinigameObjects:weaponNoCallback")
		end

		suiPageData:sendUpdateTo(pPlayer)
		self.paySlot(pPlayer, readStringData(oid .. ":mtpSlot"))
		self.cleanupWeapon(pPlayer)
		return
	elseif (tries <= 0) then
		suiPageData:setProperty("top.description.desc", "Text", "@meatlump/meatlump:weapon_calibration_failure")
		suiPageData:setProperty("top.description.attempts", "Text", "@meatlump/meatlump:weapon_calibration_attempts_remaining" .. " " .. integrity .. "%")

		for i = 1, 6 do
			suiPageData:setProperty(self.playerButtons[i], "GetsInput", "false")
			suiPageData:subscribeToEvent(SuiEventType.SET_onButton, self.playerButtons[i], "MtpMinigameObjects:weaponNoCallback")
		end

		suiPageData:sendUpdateTo(pPlayer)
		self.applyDowner(pPlayer, "weapons_cache")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_failed")
		self.cleanupWeapon(pPlayer)
		return
	end

	suiPageData:setProperty("top.description.attempts", "Text", "@meatlump/meatlump:weapon_calibration_attempts_remaining" .. " " .. integrity .. "%")
	writeData(playerID .. ":mtpWeapon:tries", tries)

	for i = 1, 6 do
		writeData(playerID .. ":mtpWeapon:current" .. i, current[i])
	end

	suiPageData:sendUpdateTo(pPlayer)
end

MtpMinigameMenuComponent = {}

function MtpMinigameMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local kind = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mtpKind")
	local label = MtpMinigameObjects.radialLabel[kind]

	if (label == nil) then
		label = "@ui_radial:item_use"
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(MtpMinigameObjects.ITEM_USE, 3, label)
end

function MtpMinigameMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= MtpMinigameObjects.ITEM_USE) then
		return 0
	end

	local kind = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mtpKind")
	local puzzleKind = MtpMinigameObjects.puzzleKind[kind]

	if (kind == "destroy_food_supplies" or kind == "destroy_weapon_cache") then
		if (not MtpMinigameObjects.canCollectCollectible(pPlayer, pSceneObject)) then
			return 0
		end

		if (MtpMinigameObjects.downerUntil(pPlayer, puzzleKind) > os.time()) then
			CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_have_debuff")
			return 0
		end

		if (not MtpMinigameObjects.consumeDevice(pPlayer, kind)) then
			CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_need_device")
			return 0
		end

		if (kind == "destroy_food_supplies") then
			MtpMinigameObjects:openFood(pPlayer, pSceneObject)
		else
			MtpMinigameObjects:openWeapon(pPlayer, pSceneObject)
		end

		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, MtpMinigameObjects.MAX_RANGE)) then
		return 0
	end

	-- OPEN: meatlump.stf has no "not available" key among the 64. Closest shipped
	-- line is you_have_debuff (TSV 106091).
	CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_have_debuff")
	return 0
end
