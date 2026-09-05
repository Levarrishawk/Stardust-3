--[[
	Meatlump puzzle containers: two calibration pages and four TEXT puzzles.

	ruling 2026-09-05: "finish up meatlumps ... in full"

	NO JOURNAL.

	CollectionManager.modifyCollectionSlotValue is paid on a win (paySlot, guarded).
	canCollectCollectible uses CollectionManager.hasCompletedCollectionSlotPrereq /
	hasCompletedCollection / hasCompletedCollectionSlot the same way; print and
	skip those three when the global is absent (OURS).

	OURS: /Script.sliceTerminal, /Script.questionnaire, /Script.disarmBomb
	do not ship. SOE's own scripts drive them as TEXT pages:
	code_break_minigame.java:113-150, slicing_minigame.java:130-141,
	target_map_puzzle.java:448-466 build a coloured prompt string
	(sui.colorWhite/Red/Green/Blue, sui.newLine) into details.lblPrompt
	and read the player's typed answer back; disarm_bomb_puzzle.java:165-174
	sets the prompt and the caption and offers the cut choices. Core3's
	generic boxes carry exactly that: SuiInputBox (prompt + a typed answer)
	for code break, slicing and target map, and SuiListBox (prompt + choices)
	for the bomb's steps. OURS presentation on SOURCED logic -- the colours
	become plain text, everything else is the java's.

	OURS: puzzle downer and buff are DirectorSharedMemory timers. This fork has
	no CreatureObject hasBuff/addBuff and the six *_puzzle_downer / *_puzzle_buff
	templates do not exist. downerUntil / applyDowner write
	playerOid .. ":mtpDowner:" .. kind = os.time() + 45 (buff.tab:1707-1712,
	<kind>_puzzle_downer DURATION 45). The -50 constitution/agility/stamina on
	those rows has no Pre-CU equivalent; the lockout carries the mechanic.
	hasPuzzleBuff reads playerOid .. ":mtpBuff:" .. kind (buff.tab:1713-1718
	DURATION 120, +10 tries at destroy_food_supplies.java:110). Grep of the six
	puzzle java files: applyBuff is only used for *_puzzle_downer; the shipped
	scripts never apply *_puzzle_buff (hasBuff is a reader only).
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
	BUFF_SECONDS = 120, -- buff.tab:1713-1718 DURATION; shipped scripts never apply *_puzzle_buff
	puzzleKind = {
		destroy_food_supplies = "food_supplies",
		destroy_weapon_cache = "weapons_cache",
		slicing_minigame = "safe",
		code_break_minigame = "locked_container",
		target_map_puzzle = "target_map",
		disarm_bomb_puzzle = "bomb_defuse", -- no placed container; buff.tab:1712 / :1718
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
		disarm_bomb_puzzle = "@meatlump/meatlump:meatlump_defuse_bomb",
	},
	deviceTemplate = {
		code_break_minigame = "object/tangible/meatlump/event/slicing_device_meatlump_container.iff",
		destroy_food_supplies = "object/tangible/meatlump/event/slicing_device_meatlump_food.iff",
		destroy_weapon_cache = "object/tangible/meatlump/event/slicing_device_meatlump_weapon.iff",
		slicing_minigame = "object/tangible/meatlump/event/slicing_device_meatlump_safe.iff",
		target_map_puzzle = "object/tangible/meatlump/event/slicing_device_meatlump_map.iff",
		disarm_bomb_puzzle = "object/tangible/meatlump/event/slicing_device_meatlump_bomb.iff",
	},
	cutLabel = {
		cut_red = "Cut Red",
		cut_black = "Cut Black",
		cut_brown = "Cut Brown",
		cut_yellow = "Cut Yellow",
		cut_white = "Cut White",
		cut_green = "Cut Green",
		cut_red_black = "Cut Red Black",
		cut_yellow_green = "Cut Yellow Green",
		cut_yellow_brown = "Cut Yellow Brown",
		cut_black_white = "Cut Black White",
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
		-- naboo_2_6.tab line 229; cellNode 601455727 parent ply_nboo_house_s_s02_fp1
		cellNode = 601455727,
		x = 5.88742, z = 0.7, y = -6.01942,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_weapon_palette_01_04.iff",
		kind = "destroy_weapon_cache",
		slot = "col_meatlump_weapon_sabotage_01:meatlump_weapon_crate_01_04",
		-- naboo_2_6.tab line 232; cellNode 601455727 parent ply_nboo_house_s_s02_fp1
		cellNode = 601455727,
		x = 3.86588, z = 0.7, y = -2.75187,
		qw = 0.993956, qx = 0, qy = 0.109778, qz = 0,
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_map_01_07.iff",
		kind = "target_map_puzzle",
		slot = "col_meatlump_map_01:meatlump_map_01_07",
		-- naboo_2_6.tab line 238; cellNode 601455732 parent ply_nboo_house_s_s02_fp1
		cellNode = 601455732,
		x = -1.69169, z = 0.750249, y = -1.40369,
		qw = -0.703845, qx = 0, qy = 0, qz = 0.710353,
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_container_01_06.iff",
		kind = "code_break_minigame",
		slot = "col_meatlump_container_01:meatlump_container_01_06",
		-- naboo_2_6.tab line 239; cellNode 601455732 parent ply_nboo_house_s_s02_fp1
		cellNode = 601455732,
		x = -7.05645, z = 0.7, y = 2.00777,
		qw = 1, qx = 0, qy = 0, qz = 0,
	},
	{
		planet = "naboo",
		tab = "naboo_2_6",
		template = "object/tangible/meatlump/event/meatlump_safe_01_09.iff",
		kind = "slicing_minigame",
		slot = "col_meatlump_safe_01:meatlump_safe_01_09",
		-- naboo_2_6.tab line 241; cellNode 601455732 parent ply_nboo_house_s_s02_fp1
		cellNode = 601455732,
		x = -6.09861, z = 0.7, y = 3.86794,
		qw = 1, qx = 0, qy = 0, qz = 0,
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

	if (row.cellNode ~= nil) then
		pCell = getSceneObject(row.cellNode)

		if (pCell == nil or not SceneObject(pCell):isCellObject()) then
			print("[meatlump] naboo house cell not a cell: " .. tostring(row.cellNode))
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
	elseif (row.building == "main" and row.cellName ~= nil) then
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

-- Java pays collection.slotName on a win (guarded CollectionManager).
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

-- OURS: DirectorSharedMemory stand-in for <kind>_puzzle_buff. The shipped scripts
-- never apply it (grep of the six puzzle java files: applyBuff is only *_puzzle_downer).
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

function MtpMinigameObjects.stripColor(text)
	if (text == nil) then
		return ""
	end

	return (string.gsub(text, "\\#%x%x%x%x%x%x", ""))
end

function MtpMinigameObjects.closePid(pPlayer, pidKey)
	if (pPlayer == nil or pidKey == nil) then
		return
	end

	local pageId = readData(SceneObject(pPlayer):getObjectID() .. pidKey)

	if (pageId == nil or pageId == 0) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		PlayerObject(pGhost):removeSuiBox(pageId)
	end
end

function MtpMinigameObjects.splitGuessList(list)
	local out = {}

	if (list == nil or list == "") then
		return out
	end

	for part in string.gmatch(list, "[^,]+") do
		local trimmed = string.match(part, "^%s*(.-)%s*$")

		if (trimmed ~= nil and trimmed ~= "") then
			out[#out + 1] = trimmed
		end
	end

	return out
end

function MtpMinigameObjects.replaceChar(text, from, to)
	if (text == nil or from == nil or to == nil or from == to) then
		return text
	end

	local out = {}

	for i = 1, string.len(text) do
		local ch = string.sub(text, i, i)

		if (ch == from) then
			out[#out + 1] = to
		else
			out[#out + 1] = ch
		end
	end

	return table.concat(out)
end

-- slicing_minigame.java:475-508; returns scrambled (reversedPassword is built and discarded)
function MtpMinigameObjects.scramblePassword(password)
	if (password == nil or password == "") then
		return password
	end

	local scrambled = ""

	for i = 1, string.len(password) do
		local ch = string.sub(password, i, i)

		if (getRandomNumber(0, 1) == 1) then
			scrambled = scrambled .. ch
		else
			scrambled = ch .. scrambled
		end
	end

	if (string.len(scrambled) ~= string.len(password)) then
		return password
	end

	return scrambled
end

function MtpMinigameObjects.shuffleCopy(list)
	local out = {}

	for i = 1, #list do
		out[i] = list[i]
	end

	for i = 1, #out do
		local j = getRandomNumber(1, #out)
		out[i], out[j] = out[j], out[i]
	end

	return out
end

function MtpMinigameObjects.shufflePaired(listA, listB)
	local a = {}
	local b = {}

	for i = 1, #listA do
		a[i] = listA[i]
		b[i] = listB[i]
	end

	for i = 1, #a do
		local j = getRandomNumber(1, #a)
		a[i], a[j] = a[j], a[i]
		b[i], b[j] = b[j], b[i]
	end

	return a, b
end

function MtpMinigameObjects.cleanupCode(pPlayer)
	local playerID = SceneObject(pPlayer):getObjectID()
	local n = readData(playerID .. ":mtpCode:n") or 0

	deleteData(playerID .. ":mtpCode:n")
	deleteData(playerID .. ":mtpCode:pos")
	deleteData(playerID .. ":mtpCode:oid")
	deleteData(playerID .. ":mtpCode:Pid")

	for i = 1, n do
		deleteData(playerID .. ":mtpCode:secret" .. i)
		deleteData(playerID .. ":mtpCode:guesses" .. i)
		deleteStringData(playerID .. ":mtpCode:stars" .. i)
		deleteStringData(playerID .. ":mtpCode:hint" .. i)
	end
end

function MtpMinigameObjects.cleanupSafe(pPlayer)
	local playerID = SceneObject(pPlayer):getObjectID()

	deleteData(playerID .. ":mtpSafe:oid")
	deleteData(playerID .. ":mtpSafe:row")
	deleteData(playerID .. ":mtpSafe:need")
	deleteData(playerID .. ":mtpSafe:have")
	deleteData(playerID .. ":mtpSafe:thresh")
	deleteData(playerID .. ":mtpSafe:wrong")
	deleteData(playerID .. ":mtpSafe:Pid")
	deleteStringData(playerID .. ":mtpSafe:password")
	deleteStringData(playerID .. ":mtpSafe:scrambled")
	deleteStringData(playerID .. ":mtpSafe:guesses")
end

function MtpMinigameObjects.cleanupMap(pPlayer)
	local playerID = SceneObject(pPlayer):getObjectID()

	deleteData(playerID .. ":mtpMap:oid")
	deleteData(playerID .. ":mtpMap:Pid")
	deleteStringData(playerID .. ":mtpMap:solve")
	deleteStringData(playerID .. ":mtpMap:prefix")
	deleteStringData(playerID .. ":mtpMap:target")
	deleteStringData(playerID .. ":mtpMap:trail")
	deleteStringData(playerID .. ":mtpMap:planet")
	deleteStringData(playerID .. ":mtpMap:prefixScr")
	deleteStringData(playerID .. ":mtpMap:targetScr")
	deleteStringData(playerID .. ":mtpMap:trailScr")
	deleteStringData(playerID .. ":mtpMap:planetScr")
end

function MtpMinigameObjects.cleanupBomb(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = readData(playerID .. ":mtpBomb:oid")
	local n = readData(playerID .. ":mtpBomb:n") or 0

	if (oid ~= nil and oid ~= 0) then
		deleteData(oid .. ":mtpBomb:defuser")
	end

	deleteData(playerID .. ":mtpBomb:oid")
	deleteData(playerID .. ":mtpBomb:Pid")
	deleteData(playerID .. ":mtpBomb:n")
	deleteData(playerID .. ":mtpBomb:button")
	deleteData(playerID .. ":mtpBomb:timer")
	deleteData(playerID .. ":mtpBomb:max")
	deleteData(playerID .. ":mtpBomb:running")
	writeData(playerID .. ":mtpBomb:gen", (readData(playerID .. ":mtpBomb:gen") or 0) + 1)
	deleteData(playerID .. ":mtpBomb:buff")

	for i = 1, n do
		deleteStringData(playerID .. ":mtpBomb:wire" .. i)
		deleteStringData(playerID .. ":mtpBomb:color" .. i)
		deleteStringData(playerID .. ":mtpBomb:cut" .. i)
	end
end

-- code_break_minigame.java:80-169 createSui; :243-317 getRandomNumberCombinations
function MtpMinigameObjects:openCodeBreak(pPlayer, pObj)
	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = SceneObject(pObj):getObjectID()
	local n = readData(playerID .. ":mtpCode:n") or 0

	if (n > 0 and readData(playerID .. ":mtpCode:oid") ~= oid) then
		self.cleanupCode(pPlayer)
		n = 0
	end

	if (n <= 0) then
		n = getRandomNumber(4, 6)

		if (self.hasPuzzleBuff(pPlayer, "locked_container")) then
			n = MtpMinigameData.BUFF_COMBO_AMOUNT
		end

		writeData(playerID .. ":mtpCode:n", n)
		writeData(playerID .. ":mtpCode:pos", 1)
		writeData(playerID .. ":mtpCode:oid", oid)

		for i = 1, n do
			local secret = getRandomNumber(0, MtpMinigameData.MAX_INT_COMBO[i])
			writeData(playerID .. ":mtpCode:secret" .. i, secret)
			writeData(playerID .. ":mtpCode:guesses" .. i, 0)
			writeStringData(playerID .. ":mtpCode:stars" .. i, string.rep("*", string.len(tostring(secret))))
			writeStringData(playerID .. ":mtpCode:hint" .. i, "")
		end
	end

	local pos = readData(playerID .. ":mtpCode:pos") or 1
	local prompt = getStringId("@meatlump/meatlump:slicing_minigame_text") .. "\n\n"

	for i = 1, n do
		prompt = prompt .. "Number combination " .. i .. ": "

		if (pos <= i) then
			prompt = prompt .. readStringData(playerID .. ":mtpCode:stars" .. i)
			local hint = readStringData(playerID .. ":mtpCode:hint" .. i)

			if (hint ~= nil and hint ~= "") then
				prompt = prompt .. "\n" .. hint
			end

			prompt = prompt .. "\n\n"
		else
			prompt = prompt .. tostring(readData(playerID .. ":mtpCode:secret" .. i)) .. "\n\n"
		end
	end

	local sui = SuiInputBox.new("MtpMinigameObjects", "codeBreakCallback")
	sui.setTargetNetworkId(oid)
	sui.setForceCloseDistance(self.FORCE_CLOSE)
	sui.setTitle("LOCK BREAKER")
	sui.setPrompt(prompt)

	local pageId = sui.sendTo(pPlayer)
	writeData(playerID .. ":mtpCode:Pid", pageId)
end

function MtpMinigameObjects:codeBreakCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local pageId = readData(playerID .. ":mtpCode:Pid")

	if (pageId == 0) then
		return
	end

	if (eventIndex == 1) then
		self.applyDowner(pPlayer, "locked_container")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_canceled_early")
		self.cleanupCode(pPlayer)
		return
	end

	local oid = readData(playerID .. ":mtpCode:oid")
	local pObj = getSceneObject(oid)

	if (pObj == nil) then
		self.cleanupCode(pPlayer)
		return
	end

	local pos = readData(playerID .. ":mtpCode:pos") or 1
	local n = readData(playerID .. ":mtpCode:n") or 0
	local secret = readData(playerID .. ":mtpCode:secret" .. pos)
	local result = MtpMinigameData.evaluateCodeBreakGuess(secret, args)

	if (result == "correct") then
		writeData(playerID .. ":mtpCode:pos", pos + 1)

		if (pos >= n) then
			local counts = {}

			for i = 1, n do
				counts[i] = readData(playerID .. ":mtpCode:guesses" .. i) or 0
			end

			MtpMinigameData.evaluateCodeBreakThresholds(counts, n)
			self.paySlot(pPlayer, readStringData(oid .. ":mtpSlot"))
			self.cleanupCode(pPlayer)
			return
		end

		self:openCodeBreak(pPlayer, pObj)
		return
	end

	if (result == "too_high" or result == "too_low") then
		local nGuess = tonumber(args)
		local guesses = (readData(playerID .. ":mtpCode:guesses" .. pos) or 0) + 1
		writeData(playerID .. ":mtpCode:guesses" .. pos, guesses)

		if (result == "too_high") then
			writeStringData(playerID .. ":mtpCode:hint" .. pos, " (" .. nGuess .. " too high)")
		else
			writeStringData(playerID .. ":mtpCode:hint" .. pos, " (" .. nGuess .. " too low)")
		end
	end

	self:openCodeBreak(pPlayer, pObj)
end

-- slicing_minigame.java:88-166 createSafeSui; :333-396 getRandomPassword
function MtpMinigameObjects:openSlicing(pPlayer, pObj)
	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = SceneObject(pObj):getObjectID()
	local password = readStringData(playerID .. ":mtpSafe:password")

	if (password ~= nil and password ~= "" and readData(playerID .. ":mtpSafe:oid") ~= oid) then
		self.cleanupSafe(pPlayer)
		password = ""
	end

	if (password == nil or password == "") then
		local idx = getRandomNumber(1, #MtpMinigameData.passwords)
		local row = MtpMinigameData.passwords[idx]
		local need = row.pointsNeeded
		local thresh = row.threshold
		local scrambled = row.password
		local iteration = 0

		while (scrambled == row.password and iteration < 2) do
			scrambled = self.scramblePassword(row.password)
			iteration = iteration + 1
		end

		if (self.hasPuzzleBuff(pPlayer, "safe")) then
			if (need > 1) then
				need = need - MtpMinigameData.BUFF_POINTS_NEEDED_DECREASE
			end

			thresh = thresh + MtpMinigameData.BUFF_THRESHOLD_INCREASE
		end

		writeData(playerID .. ":mtpSafe:oid", oid)
		writeData(playerID .. ":mtpSafe:row", idx)
		writeData(playerID .. ":mtpSafe:need", need)
		writeData(playerID .. ":mtpSafe:have", 0)
		writeData(playerID .. ":mtpSafe:thresh", thresh)
		writeData(playerID .. ":mtpSafe:wrong", 0)
		writeStringData(playerID .. ":mtpSafe:password", row.password)
		writeStringData(playerID .. ":mtpSafe:scrambled", scrambled)
		writeStringData(playerID .. ":mtpSafe:guesses", "")
		password = row.password
	end

	local scrambled = readStringData(playerID .. ":mtpSafe:scrambled")
	local need = readData(playerID .. ":mtpSafe:need") or 0
	local have = readData(playerID .. ":mtpSafe:have") or 0
	local thresh = readData(playerID .. ":mtpSafe:thresh") or 0
	local wrong = readData(playerID .. ":mtpSafe:wrong") or 0
	local guessList = readStringData(playerID .. ":mtpSafe:guesses")
	local prompt = getStringId("@meatlump/meatlump:safe_minigame_text") .. "\n\n"
	prompt = prompt .. "Scrambled Password: " .. scrambled .. "\n"
	prompt = prompt .. "Total Fail Attempts: " .. wrong .. "\n"
	prompt = prompt .. "Maximum Fail Attempts Allowed: " .. (thresh + 1) .. "\n"
	prompt = prompt .. "Points Needed: " .. need .. "\n"
	prompt = prompt .. "Current Points: " .. have .. "\n\n"

	if (guessList ~= nil and guessList ~= "") then
		prompt = prompt .. guessList .. "\n"
	end

	local sui = SuiInputBox.new("MtpMinigameObjects", "slicingCallback")
	sui.setTargetNetworkId(oid)
	sui.setForceCloseDistance(self.FORCE_CLOSE)
	sui.setTitle("OLD SAFE")
	sui.setPrompt(prompt)

	local pageId = sui.sendTo(pPlayer)
	writeData(playerID .. ":mtpSafe:Pid", pageId)
end

function MtpMinigameObjects.slicingFail(pPlayer)
	MtpMinigameObjects.applyDowner(pPlayer, "safe")
	CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_failed")
	MtpMinigameObjects.cleanupSafe(pPlayer)
end

function MtpMinigameObjects.slicingIncrementWrong(pPlayer, thresh)
	local playerID = SceneObject(pPlayer):getObjectID()
	local current = readData(playerID .. ":mtpSafe:wrong") or 0

	if (current >= thresh) then
		return false
	end

	writeData(playerID .. ":mtpSafe:wrong", current + 1)
	return true
end

function MtpMinigameObjects:slicingCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local pageId = readData(playerID .. ":mtpSafe:Pid")

	if (pageId == 0) then
		return
	end

	if (eventIndex == 1) then
		self.applyDowner(pPlayer, "safe")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_canceled_early")
		self.cleanupSafe(pPlayer)
		return
	end

	local oid = readData(playerID .. ":mtpSafe:oid")
	local pObj = getSceneObject(oid)

	if (pObj == nil) then
		self.cleanupSafe(pPlayer)
		return
	end

	local idx = readData(playerID .. ":mtpSafe:row")
	local row = MtpMinigameData.passwords[idx]

	if (row == nil) then
		self.cleanupSafe(pPlayer)
		return
	end

	local guess = args or ""
	-- slicing_minigame.java:191 isNameReserved(playerGuess, RESERVED_RULES_TO_IGNORE).
	-- The array is an ignore list (number/syntax/fictionally_reserved/reserved),
	-- not a reject list. Remaining engine rules (profane, developer, racial,
	-- empty, in use) have no Lua NameManager binding on this tree, so the
	-- reserved gate is not applied; the guess goes to evaluateSlicingGuess.
	local work = {
		password = readStringData(playerID .. ":mtpSafe:password"),
		anagrams = row.anagrams,
		pointsNeeded = readData(playerID .. ":mtpSafe:need") or row.pointsNeeded,
		threshold = readData(playerID .. ":mtpSafe:thresh") or row.threshold,
	}
	local result = MtpMinigameData.evaluateSlicingGuess(work, guess, self.splitGuessList(readStringData(playerID .. ":mtpSafe:guesses")), readData(playerID .. ":mtpSafe:have") or 0, readData(playerID .. ":mtpSafe:wrong") or 0)

	if (result == "win") then
		self.paySlot(pPlayer, readStringData(oid .. ":mtpSlot"))
		self.cleanupSafe(pPlayer)
		return
	end

	if (result == "anagram") then
		local list = readStringData(playerID .. ":mtpSafe:guesses")

		if (list == nil or list == "") then
			writeStringData(playerID .. ":mtpSafe:guesses", guess)
		else
			writeStringData(playerID .. ":mtpSafe:guesses", list .. ", " .. guess)
		end

		writeData(playerID .. ":mtpSafe:have", (readData(playerID .. ":mtpSafe:have") or 0) + MtpMinigameData.DEFAULT_ANAGRAM_POINT)
		self:openSlicing(pPlayer, pObj)
		return
	end

	if (result == "already") then
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:safe_guessed_previous")
	end

	if (not self.slicingIncrementWrong(pPlayer, work.threshold)) then
		self.slicingFail(pPlayer)
		return
	end

	self:openSlicing(pPlayer, pObj)
end

-- target_map_puzzle.java:411-489 createMapText; :625-780 getRandomText
function MtpMinigameObjects:openMap(pPlayer, pObj)
	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = SceneObject(pObj):getObjectID()
	local solve = readStringData(playerID .. ":mtpMap:solve")

	if (solve ~= nil and solve ~= "" and readData(playerID .. ":mtpMap:oid") ~= oid) then
		self.cleanupMap(pPlayer)
		solve = ""
	end

	if (solve == nil or solve == "") then
		local row = MtpMinigameData.mapText[getRandomNumber(1, #MtpMinigameData.mapText)]
		local hasBuff = self.hasPuzzleBuff(pPlayer, "target_map")
		local cipher = MtpMinigameData.CIPHER_1

		if (hasBuff) then
			cipher = MtpMinigameData.CIPHER_3
		elseif (getRandomNumber(1, 2) == 2) then
			cipher = MtpMinigameData.CIPHER_2
		end

		local newTarget = MtpMinigameData.applyCipher(row.target, cipher)
		local newPrefix = row.prefix
		local newTrail = row.trail
		local newPlanet = row.planet

		for s = 1, string.len(row.target) do
			local src = string.sub(row.target, s, s)
			-- the glyph for this character, not a byte of the ciphered string
			-- (ciphers 2 and 3 are multi-byte) -- target_map_puzzle.java:625-780
			local dst = MtpMinigameData.cipherGlyph(src, cipher)
			newPrefix = self.replaceChar(newPrefix, src, dst)
			newTrail = self.replaceChar(newTrail, src, dst)
			newPlanet = self.replaceChar(newPlanet, src, dst)
		end

		solve = "target"

		if (hasBuff) then
			if (getRandomNumber(2, 3) == 2) then
				solve = "location"
			else
				solve = "planet"
			end
		end

		writeData(playerID .. ":mtpMap:oid", oid)
		writeStringData(playerID .. ":mtpMap:solve", solve)
		writeStringData(playerID .. ":mtpMap:prefix", row.prefix)
		writeStringData(playerID .. ":mtpMap:target", row.target)
		writeStringData(playerID .. ":mtpMap:trail", row.trail)
		writeStringData(playerID .. ":mtpMap:planet", row.planet)
		writeStringData(playerID .. ":mtpMap:prefixScr", newPrefix)
		writeStringData(playerID .. ":mtpMap:targetScr", newTarget)
		writeStringData(playerID .. ":mtpMap:trailScr", newTrail)
		writeStringData(playerID .. ":mtpMap:planetScr", newPlanet)
	end

	local markTarget = ""
	local markLoc = ""
	local markPlanet = ""

	if (solve == "target") then
		markTarget = "RED "
	elseif (solve == "location") then
		markLoc = "RED "
	else
		markPlanet = "RED "
	end

	local prompt = getStringId("@meatlump/meatlump:decipher_map_text") .. "\n\n"
	prompt = prompt .. readStringData(playerID .. ":mtpMap:prefixScr") .. "\n\n"
	prompt = prompt .. "Target: " .. markTarget .. readStringData(playerID .. ":mtpMap:targetScr") .. "\n\n"
	prompt = prompt .. "Target Location: " .. markLoc .. readStringData(playerID .. ":mtpMap:trailScr") .. "\n\n"
	prompt = prompt .. "Target Planet: " .. markPlanet .. readStringData(playerID .. ":mtpMap:planetScr") .. "\n\n"
	prompt = prompt .. "Solve the RED text."

	local sui = SuiInputBox.new("MtpMinigameObjects", "mapCallback")
	sui.setTargetNetworkId(oid)
	sui.setForceCloseDistance(self.FORCE_CLOSE)
	sui.setTitle("Target Map")
	sui.setPrompt(prompt)

	local pageId = sui.sendTo(pPlayer)
	writeData(playerID .. ":mtpMap:Pid", pageId)
end

function MtpMinigameObjects:mapCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local pageId = readData(playerID .. ":mtpMap:Pid")

	if (pageId == 0) then
		return
	end

	if (eventIndex == 1) then
		self.applyDowner(pPlayer, "target_map")
		CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_canceled_early")
		self.cleanupMap(pPlayer)
		return
	end

	local oid = readData(playerID .. ":mtpMap:oid")
	local solve = readStringData(playerID .. ":mtpMap:solve")
	local phrase = ""

	if (solve == "target") then
		phrase = readStringData(playerID .. ":mtpMap:target")
	elseif (solve == "location") then
		phrase = readStringData(playerID .. ":mtpMap:trail")
	else
		phrase = readStringData(playerID .. ":mtpMap:planet")
	end

	if (MtpMinigameData.evaluateMapGuess(phrase, args or "") == "win") then
		self.paySlot(pPlayer, readStringData(oid .. ":mtpSlot"))
		self.cleanupMap(pPlayer)
		return
	end

	self.applyDowner(pPlayer, "target_map")
	self.cleanupMap(pPlayer)
end

-- disarm_bomb_puzzle.java:134-214 createBombUI; :216-283 initializePlayer; :285-335 getBombData
function MtpMinigameObjects.bombTimerNow(pPlayer)
	local playerID = SceneObject(pPlayer):getObjectID()
	return readData(playerID .. ":mtpBomb:timer") or 0
end

function MtpMinigameObjects:openBomb(pPlayer, pObj)
	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = SceneObject(pObj):getObjectID()
	local n = readData(playerID .. ":mtpBomb:n") or 0

	if (n > 0 and readData(playerID .. ":mtpBomb:oid") ~= oid) then
		self.cleanupBomb(pPlayer)
		n = 0
	end

	if (n <= 0) then
		local wires = self.shuffleCopy(MtpMinigameData.WIRE_LIST)
		local colors, cuts = self.shufflePaired(MtpMinigameData.COLOR_LIST, MtpMinigameData.CUT_LIST)
		n = #wires
		local timer = MtpMinigameData.DEFAULT_BOMB_TIMER
		local hasBuff = self.hasPuzzleBuff(pPlayer, "bomb_defuse")

		if (hasBuff) then
			timer = timer + MtpMinigameData.BUFF_TIMER_INCREASE
		end

		writeData(playerID .. ":mtpBomb:oid", oid)
		writeData(playerID .. ":mtpBomb:n", n)
		writeData(playerID .. ":mtpBomb:button", 1)
		writeData(playerID .. ":mtpBomb:timer", timer)
		writeData(playerID .. ":mtpBomb:max", timer)
		writeData(playerID .. ":mtpBomb:running", 0)
		writeData(playerID .. ":mtpBomb:buff", hasBuff and 1 or 0)
		writeData(oid .. ":mtpBomb:defuser", playerID)

		local gen = (readData(playerID .. ":mtpBomb:gen") or 0) + 1
		writeData(playerID .. ":mtpBomb:gen", gen)

		for i = 1, n do
			writeStringData(playerID .. ":mtpBomb:wire" .. i, wires[i])
			writeStringData(playerID .. ":mtpBomb:color" .. i, colors[i])
			writeStringData(playerID .. ":mtpBomb:cut" .. i, cuts[i])
		end

		createEvent(MtpMinigameData.DEFUSE_TIME_OUT_SECONDS * 1000, "MtpMinigameObjects", "bombIdleTimeout", pPlayer, tostring(gen))
	end

	local timer = self.bombTimerNow(pPlayer)
	local prompt = "Timer: " .. timer .. "\n\n"
	prompt = prompt .. getStringId("@meatlump/meatlump:bomb_intro_text") .. "\n\n"

	for i = 1, n do
		prompt = prompt .. i .. ". " .. self.stripColor(readStringData(playerID .. ":mtpBomb:wire" .. i)) .. " is " .. self.stripColor(readStringData(playerID .. ":mtpBomb:color" .. i)) .. "\n"
	end

	local sui = SuiListBox.new("MtpMinigameObjects", "bombCallback")
	sui.setTargetNetworkId(oid)
	sui.setForceCloseDistance(self.FORCE_CLOSE)
	sui.setTitle("Disarm Bomb")
	sui.setPrompt(prompt)

	local button = readData(playerID .. ":mtpBomb:button") or 1
	local hasBuff = (readData(playerID .. ":mtpBomb:buff") or 0) == 1
	local used = {}

	if (hasBuff) then
		for i = 1, button - 1 do
			used[readStringData(playerID .. ":mtpBomb:cut" .. i)] = true
		end
	end

	for i = 1, #MtpMinigameData.CUT_LIST do
		local cut = MtpMinigameData.CUT_LIST[i]

		if (not used[cut]) then
			sui.add(self.cutLabel[cut], cut)
		end
	end

	local pageId = sui.sendTo(pPlayer)
	writeData(playerID .. ":mtpBomb:Pid", pageId)
end

function MtpMinigameObjects.bombExplode(pPlayer)
	MtpMinigameObjects.closePid(pPlayer, ":mtpBomb:Pid")
	MtpMinigameObjects.applyDowner(pPlayer, "bomb_defuse")
	CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_failed")
	MtpMinigameObjects.cleanupBomb(pPlayer)
end

function MtpMinigameObjects:bombIdleTimeout(pPlayer, pGen)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local gen = tonumber(pGen) or 0

	if ((readData(playerID .. ":mtpBomb:gen") or 0) ~= gen) then
		return
	end

	if ((readData(playerID .. ":mtpBomb:running") or 0) == 1) then
		return
	end

	self.closePid(pPlayer, ":mtpBomb:Pid")
	CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:took_too_long")
	self.cleanupBomb(pPlayer)
end

function MtpMinigameObjects:bombTick(pPlayer, pGen)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local gen = tonumber(pGen) or 0

	if ((readData(playerID .. ":mtpBomb:gen") or 0) ~= gen) then
		return
	end

	local timer = (readData(playerID .. ":mtpBomb:timer") or 0) - 1
	writeData(playerID .. ":mtpBomb:timer", timer)

	if (timer < 0) then
		self.bombExplode(pPlayer)
		return
	end

	createEvent(1000, "MtpMinigameObjects", "bombTick", pPlayer, tostring(gen))
end

function MtpMinigameObjects:bombCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local pageId = readData(playerID .. ":mtpBomb:Pid")

	if (pageId == 0) then
		return
	end

	local timer = readData(playerID .. ":mtpBomb:timer") or 0
	local maxTimer = readData(playerID .. ":mtpBomb:max") or 0
	local started = (readData(playerID .. ":mtpBomb:running") or 0) == 1 or (timer < maxTimer)

	if (eventIndex == 1 or args == nil or tonumber(args) < 0) then
		if (started) then
			self.bombExplode(pPlayer)
		else
			self.applyDowner(pPlayer, "bomb_defuse")
			CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_canceled_early")
			self.cleanupBomb(pPlayer)
		end

		return
	end

	local oid = readData(playerID .. ":mtpBomb:oid")
	local pObj = getSceneObject(oid)

	if (pObj == nil) then
		self.cleanupBomb(pPlayer)
		return
	end

	local pPageData = LuaSuiBoxPage(pSui):getSuiPageData()

	if (pPageData == nil) then
		self.bombExplode(pPlayer)
		return
	end

	local wire = LuaSuiPageData(pPageData):getStoredData(tostring(args))
	local n = readData(playerID .. ":mtpBomb:n") or 0
	local button = readData(playerID .. ":mtpBomb:button") or 1
	local cutArray = {}

	for i = 1, n do
		cutArray[i] = readStringData(playerID .. ":mtpBomb:cut" .. i)
	end

	local result = MtpMinigameData.evaluateBombCut(cutArray, button, wire)

	if (result == "explode" or result == "cancel") then
		self.bombExplode(pPlayer)
		return
	end

	if (result == "win") then
		self.paySlot(pPlayer, readStringData(oid .. ":mtpSlot"))
		self.cleanupBomb(pPlayer)
		return
	end

	writeData(playerID .. ":mtpBomb:timer", timer - MtpMinigameData.BUTTON_PENALTY)
	writeData(playerID .. ":mtpBomb:button", button + 1)

	if ((readData(playerID .. ":mtpBomb:running") or 0) ~= 1) then
		writeData(playerID .. ":mtpBomb:running", 1)
		createEvent(1000, "MtpMinigameObjects", "bombTick", pPlayer, tostring(readData(playerID .. ":mtpBomb:gen") or 0))
	end

	self:openBomb(pPlayer, pObj)
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
	local oid = SceneObject(pSceneObject):getObjectID()

	if (kind == "destroy_food_supplies" or kind == "destroy_weapon_cache" or kind == "code_break_minigame" or kind == "slicing_minigame" or kind == "target_map_puzzle" or kind == "disarm_bomb_puzzle") then
		if (not MtpMinigameObjects.canCollectCollectible(pPlayer, pSceneObject)) then
			return 0
		end

		if (MtpMinigameObjects.downerUntil(pPlayer, puzzleKind) > os.time()) then
			CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_have_debuff")
			return 0
		end

		if (kind == "disarm_bomb_puzzle") then
			local defuser = readData(oid .. ":mtpBomb:defuser") or 0

			if (defuser ~= 0) then
				CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:currently_being_defused")
				return 0
			end
		end

		if (not MtpMinigameObjects.consumeDevice(pPlayer, kind)) then
			CreatureObject(pPlayer):sendSystemMessage("@meatlump/meatlump:you_need_device")
			return 0
		end

		if (kind == "destroy_food_supplies") then
			MtpMinigameObjects:openFood(pPlayer, pSceneObject)
		elseif (kind == "destroy_weapon_cache") then
			MtpMinigameObjects:openWeapon(pPlayer, pSceneObject)
		elseif (kind == "code_break_minigame") then
			MtpMinigameObjects:openCodeBreak(pPlayer, pSceneObject)
		elseif (kind == "slicing_minigame") then
			MtpMinigameObjects:openSlicing(pPlayer, pSceneObject)
		elseif (kind == "target_map_puzzle") then
			MtpMinigameObjects:openMap(pPlayer, pSceneObject)
		else
			MtpMinigameObjects:openBomb(pPlayer, pSceneObject)
		end

		return 0
	end

	return 0
end
