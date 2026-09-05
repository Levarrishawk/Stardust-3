--[[
	Meatlump hideout vendor.

	ruling 2026-09-04

	SOURCED: item/vendor/mtp_meatlump_vendor.tab (18 rows). resourceAmount is lump cost.
	OPEN: item_meatlump_lump_01_01 is not in the fork. priceFn is pluggable;
	the default always refuses with @set_bonus:vendor_cant_purchase and lists the cost.
]]

MtpVendor = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MtpVendor",
	REFUSE_KEY = "@set_bonus:vendor_cant_purchase",
	NOT_READY = "@set_bonus:vendor_not_ready",
	TOKEN = "item_meatlump_lump_01_01",
	stock = {
		{ item = "item_meatlump_camp_light_schematic_02_01", lumps = 55 },
		{ item = "item_meatlump_camp_light_schematic_02_02", lumps = 55 },
		{ item = "item_meatlump_grill_schematic_02_01", lumps = 65 },
		{ item = "item_meatlump_grill_schematic_02_02", lumps = 65 },
		{ item = "item_meatlump_pallet_schematic_02_01", lumps = 20 },
		{ item = "meatlump_officer_doll_leg_l_02_01", lumps = 30 },
		{ item = "meatlump_king_stuffing_02_01", lumps = 30 },
		{ item = "meatlump_newspaper_02_08", lumps = 30 },
		{ item = "meatlump_hench_stuffing_02_01", lumps = 10 },
		{ item = "meatlump_uniform_piece_02_01", lumps = 10 },
		{ item = "item_mtp_meatlump_king_reward", lumps = 100 },
		{ item = "mtp_meatlump_graffiti_reward_02_01", lumps = 25 },
		{ item = "mtp_meatlump_graffiti_reward_02_02", lumps = 25 },
		{ item = "mtp_meatlump_graffiti_reward_02_03", lumps = 25 },
		{ item = "mtp_meatlump_graffiti_reward_02_04", lumps = 25 },
		{ item = "mtp_meatlump_graffiti_reward_02_05", lumps = 25 },
		{ item = "mtp_meatlump_graffiti_reward_02_06", lumps = 25 },
		{ item = "mtp_meatlump_graffiti_reward_02_07", lumps = 25 },
	},
}

registerScreenPlay("MtpVendor", true)

function MtpVendor:start()
end

-- Pluggable price hook. Return true to allow the sale.
-- Default: lumps are not in the fork, so every buy refuses.
function MtpVendor.priceFn(pPlayer, entry)
	return false, entry.lumps, MtpVendor.TOKEN
end

function MtpVendor.canAfford(pPlayer, entry)
	local ok, need, token = MtpVendor.priceFn(pPlayer, entry)
	return ok, need, token
end

function MtpVendor:open(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local sui = SuiListBox.new("MtpVendor", "onPicked")
	sui.setTitle("@set_bonus:vendor_credits")
	sui.setPrompt("@set_bonus:vendor_cant_purchase") -- shipped refuse key; list is the 18-row stock

	for i = 1, #self.stock do
		local e = self.stock[i]
		sui.add(e.item .. " (" .. tostring(e.lumps) .. " " .. self.TOKEN .. ")", tostring(i))
	end

	sui.sendTo(pPlayer)
end

function MtpVendor:onPicked(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed or pPlayer == nil or args == nil or tonumber(args) < 0) then
		return
	end

	local idx = tonumber(args) + 1
	local entry = self.stock[idx]

	if (entry == nil) then
		return
	end

	local ok, need, token = MtpVendor.canAfford(pPlayer, entry)

	if (ok) then
		-- Future: deduct token and giveItem the schematic. Not reachable today.
		return
	end

	CreatureObject(pPlayer):sendSystemMessage(self.REFUSE_KEY)
	CreatureObject(pPlayer):sendSystemMessage("Need " .. tostring(need) .. "x " .. tostring(token) .. " for " .. entry.item)
end
