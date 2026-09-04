--[[
Mustafar bounty-hunt givers -- the seven tangible objects that call grantHunt.

Live SWG server source (github.com/SWG-Source/dsrc) attaches a quest.som.* script
on each object's .tpf. Four are static Mensix props (shape A: radial grants
immediately). Three are loot items (shape B: radial only in inventory, confirm
SUI, destroy on accept). Every string and branch here is transcribed from those
scripts and from string/en/som/som_quest.stf; nothing is invented.

Attached declaratively via objectMenuComponent on the seven templates under
object/custom_content/tangible/item/som/, the same way
HkHistoryDatapadMenuComponent.lua attaches to droid_factory_history_datapad.
--]]

BountyHuntGiverMenuComponent = { }

-- Keyed by full template path, same lookup shape as
-- corvetteContainerComponents.lua:46.
BountyHuntGiverMenuComponent.givers = {
	["object/tangible/item/som/lava_flea_bounty.iff"] = {
		shape = "A",
		key = "lava_flea",
		examine = "@som/som_quest:lava_flea_bounty_examine",
		already = "@som/som_quest:lava_flea_bounty_already",
	},
	["object/tangible/item/som/lava_lizard_food.iff"] = {
		shape = "A",
		key = "tanray",
		examine = "@som/som_quest:lava_lizard_food_examine",
		already = "@som/som_quest:lava_lizard_food_already",
	},
	["object/tangible/item/som/lava_beetle_beads.iff"] = {
		shape = "A",
		key = "lava_beetle",
		examine = "@som/som_quest:lava_beetle_beads_examine",
		already = "@som/som_quest:lava_beetle_beads_already",
	},
	["object/tangible/item/som/jundak_hunter_hologram.iff"] = {
		shape = "A",
		key = "jundak",
		examine = "@som/som_quest:jundak_hunter_hologram_examine",
		already = "@som/som_quest:jundak_hunter_hologram_already",
	},
	["object/tangible/item/som/blistmok_heart.iff"] = {
		shape = "B",
		key = "blistmok",
		examine = "@som/som_quest:blistmok_heart_examine",
		already = "@som/som_quest:blistmok_heart_already",
		destroy = "@som/som_quest:blistmok_heart_destroy",
	},
	["object/tangible/item/som/tulrus_parts.iff"] = {
		shape = "B",
		key = "tulrus",
		-- Template is tulrus_parts, live script is tulrus_mandible, strings are tulrus_horn_*.
		examine = "@som/som_quest:tulrus_horn_examine",
		already = "@som/som_quest:tulrus_horn_already",
		destroy = "@som/som_quest:tulrus_horn_destroy",
	},
	["object/tangible/item/som/xandank_jaw.iff"] = {
		shape = "B",
		key = "xandank",
		examine = "@som/som_quest:xandank_jaw_examine",
		already = "@som/som_quest:xandank_jaw_already",
		destroy = "@som/som_quest:xandank_jaw_destroy",
	},
}

function BountyHuntGiverMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return
	end

	local giver = self.givers[SceneObject(pSceneObject):getTemplateObjectPath()]

	if (giver == nil) then
		return
	end

	-- Shape B: only add the radial when the item is in the player's possession,
	-- matching utils.getContainingPlayer(self) != null on live and the inventory
	-- guard in HkHistoryDatapadMenuComponent.lua:29.
	if (giver.shape == "B" and SceneObject(pSceneObject):isASubChildOf(pPlayer) == false) then
		return
	end

	local menuResponse = LuaObjectMenuResponse(pMenuResponse)

	menuResponse:addRadialMenuItem(20, 3, giver.examine)
end

function BountyHuntGiverMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pPlayer == nil or pSceneObject == nil or selectedID ~= 20) then
		return 0
	end

	local giver = self.givers[SceneObject(pSceneObject):getTemplateObjectPath()]

	if (giver == nil) then
		return 0
	end

	local hunts = _G["bountyHuntsScreenPlay"]

	if (hunts == nil) then
		return 0
	end

	if (giver.shape == "B") then
		if (SceneObject(pSceneObject):isASubChildOf(pPlayer) == false) then
			CreatureObject(pPlayer):sendSystemMessage("@som/som_quest:unable_to_examine")
			return 0
		end
	elseif (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		-- Shape A only. The live .java has no range check; this matches the
		-- in-tree sibling instead -- trophy_hunts.lua:1580 guards its own static
		-- Mensix props at 8m. Shape B needs no distance test because it is
		-- already required to be in the player's own inventory.
		return 0
	end

	if (hunts:isHuntActive(pPlayer, giver.key)) then
		CreatureObject(pPlayer):sendSystemMessage(giver.already)
		return 0
	end

	-- Shape A: furniture you click; grant immediately.
	if (giver.shape == "A") then
		hunts:grantHunt(pPlayer, giver.key)
		return 0
	end

	-- Shape B: confirm SUI, then grant and destroy. Object id and hunt key are
	-- stashed on bountyHuntsScreenPlay's screenplay data so the callback can
	-- recover them (mensix_mining_facility_main.lua:350 pattern).
	writeScreenPlayData(pPlayer, hunts.screenplayName, "giver_oid", tostring(SceneObject(pSceneObject):getObjectID()))
	writeScreenPlayData(pPlayer, hunts.screenplayName, "giver_key", giver.key)

	-- Two-button accept box, same strings and setup as
	-- ForceShrineMenuComponent.lua:69-74 / trophy_hunts.lua:1030-1035.
	local sui = SuiMessageBox.new("BountyHuntGiverMenuComponent", "questOfferCallback")
	sui.setTitle("@som/som_quest:begin_quest_title")
	sui.setPrompt("@som/som_quest:begin_quest_prompt")
	sui.setOkButtonText("@som/som_quest:quest_accept_ok")
	sui.setCancelButtonText("@som/som_quest:quest_accept_cancel")
	sui.setTargetNetworkId(SceneObject(pSceneObject):getObjectID())
	sui.sendTo(pPlayer)

	return 0
end

function BountyHuntGiverMenuComponent:questOfferCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local hunts = _G["bountyHuntsScreenPlay"]
	local screenplayName = "bountyHuntsScreenPlay"

	if (hunts ~= nil) then
		screenplayName = hunts.screenplayName
	end

	local objectId = tonumber(readScreenPlayData(pPlayer, screenplayName, "giver_oid")) or 0
	local key = readScreenPlayData(pPlayer, screenplayName, "giver_key")

	deleteScreenPlayData(pPlayer, screenplayName, "giver_oid")
	deleteScreenPlayData(pPlayer, screenplayName, "giver_key")

	-- eventIndex == 1 is cancel (HkHistoryDatapadMenuComponent.lua:57).
	if (eventIndex == 1) then
		CreatureObject(pPlayer):sendSystemMessage("@som/som_quest:quest_decline")
		return
	end

	if (eventIndex ~= 0 or hunts == nil or key == nil or key == "") then
		return
	end

	hunts:grantHunt(pPlayer, key)

	local pObject = getSceneObject(objectId)

	if (pObject == nil) then
		return
	end

	local giver = self.givers[SceneObject(pObject):getTemplateObjectPath()]

	if (giver ~= nil and giver.destroy ~= nil) then
		CreatureObject(pPlayer):sendSystemMessage(giver.destroy)
	end

	SceneObject(pObject):destroyObjectFromWorld()
	SceneObject(pObject):destroyObjectFromDatabase()
end
