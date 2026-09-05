--[[
	Meatlump king: story quest, 26 offerings, finale reward.

	ruling 2026-09-04

	SOURCED: theme_park/meatlump/meatlump_king.tab (26 offering/reaction rows).
	SOURCED: questlist mtp_meatlump_king_story QUEST_REWARD_BANK_CREDITS=49918
	QUEST_REWARD_LOOT_NAME=item_mtp_king_corellia_times_story.
	OPEN: give-reaction collection items and lump tokens.
]]

MeatlumpKing = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MeatlumpKing",
	FLAVOR = { "s_25", "s_26", "s_27", "s_28", "s_29", "s_30", "s_31", "s_33", "s_35", "s_37", "s_39", "s_44" },
	offerings = {
		{ offering = "bow", reaction = "bow", chat = "", give = "" },
		{ offering = "item_meatlump_lump_01_01", reaction = "celebrate", chat = "mtp_king_lump", give = "meatlump_hench_doll_arm_r_02_01:meatlump_newspaper_02_09" },
		{ offering = "item_meatlump_lump_unfinished_01_01", reaction = "applause_polite", chat = "mtp_king_lump_unfinished", give = "item_meatlump_lump_01_01" },
		{ offering = "flirt", reaction = "2hot4u", chat = "mtp_king_flirt", give = "" },
		{ offering = "flutter", reaction = "refuse_offer_affection", chat = "mtp_king_flutter", give = "" },
		{ offering = "giggle", reaction = "shake_head_disgust", chat = "mtp_king_giggle", give = "" },
		{ offering = "grin", reaction = "pose_proudly", chat = "mtp_king_grin", give = "" },
		{ offering = "hero", reaction = "strut", chat = "mtp_king_hero", give = "" },
		{ offering = "hi5", reaction = "dismiss", chat = "mtp_king_hi5", give = "" },
		{ offering = "applaud", reaction = "applause_excited", chat = "mtp_king_applaud", give = "" },
		{ offering = "blowkiss", reaction = "refuse_offer_affection", chat = "mtp_king_blowkiss", give = "" },
		{ offering = "bouquet", reaction = "yawn", chat = "mtp_king_bouquet", give = "" },
		{ offering = "cheek", reaction = "embarrassed", chat = "mtp_king_cheek", give = "" },
		{ offering = "cheer", reaction = "celebrate", chat = "mtp_king_cheer", give = "" },
		{ offering = "clap", reaction = "clap_rousing", chat = "mtp_king_clap", give = "" },
		{ offering = "comfort", reaction = "hug_self", chat = "mtp_king_comfort", give = "" },
		{ offering = "dance", reaction = "applause_polite", chat = "mtp_king_dance", give = "" },
		{ offering = "embrace", reaction = "scared", chat = "mtp_king_embrace", give = "" },
		{ offering = "encourage", reaction = "hug_self", chat = "mtp_king_encourage", give = "" },
		{ offering = "kiss", reaction = "refuse_offer_affection", chat = "mtp_king_kiss", give = "" },
		{ offering = "hug", reaction = "scream", chat = "mtp_king_hug", give = "" },
		{ offering = "lick", reaction = "cuckoo", chat = "mtp_king_lick", give = "" },
		{ offering = "luck", reaction = "udaman", chat = "mtp_king_luck", give = "" },
		{ offering = "smile", reaction = "pose_proudly", chat = "mtp_king_smile", give = "" },
		{ offering = "snog", reaction = "refuse_offer_affection", chat = "mtp_king_snog", give = "" },
		{ offering = "tickle", reaction = "laugh", chat = "mtp_king_tickle", give = "" },
	},
}

registerScreenPlay("MeatlumpKing", true)

function MeatlumpKing:start()
end

function MeatlumpKing.flavorScreen()
	local n = getRandomNumber(1, #MeatlumpKing.FLAVOR)
	return MeatlumpKing.FLAVOR[n]
end

function MeatlumpKing.openOfferings(pPlayer, pNpc)
	if (pPlayer == nil or pNpc == nil) then
		return
	end

	writeData(SceneObject(pPlayer):getObjectID() .. ":mtpKingNpc", SceneObject(pNpc):getObjectID())

	local sui = SuiListBox.new("MeatlumpKing", "onOffering")
	sui.setTitle("@conversation/mtp_meatlump_king:s_4")
	sui.setPrompt("@conversation/mtp_meatlump_king:s_6")

	for i = 1, #MeatlumpKing.offerings do
		local o = MeatlumpKing.offerings[i]
		sui.add(o.offering, tostring(i))
	end

	sui.sendTo(pPlayer)
end

function MeatlumpKing:onOffering(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed or pPlayer == nil or args == nil or tonumber(args) < 0) then
		return
	end

	local idx = tonumber(args) + 1
	local o = self.offerings[idx]

	if (o == nil) then
		return
	end

	local npcOid = readData(SceneObject(pPlayer):getObjectID() .. ":mtpKingNpc")
	local pNpc = getSceneObject(npcOid)

	if (pNpc ~= nil and o.reaction ~= nil and o.reaction ~= "") then
		CreatureObject(pNpc):doAnimation(o.reaction)
	end

	if (o.chat ~= nil and o.chat ~= "" and pNpc ~= nil) then
		spatialChat(pNpc, "@theme_park/meatlump/meatlump_king:" .. o.chat)
	end

	if (o.give ~= nil and o.give ~= "") then
		-- OPEN: give-reaction items (doll parts, newspapers, lumps) are collection
		-- loot the collections branch owns. Token lumps are not in the fork.
		CreatureObject(pPlayer):sendSystemMessage("@set_bonus:vendor_cant_purchase")
		CreatureObject(pPlayer):sendSystemMessage("Need " .. o.offering .. " to receive " .. o.give)
	end
end
