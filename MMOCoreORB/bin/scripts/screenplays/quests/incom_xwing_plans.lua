local Journal = require("managers.quest.journal")

includeFile("quests/incom_xwing_plans_convo_handler.lua")
includeFile("quests/incom_xwing_plans_menu_component.lua")

IncomXwingPlans = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "IncomXwingPlans",
	questKey = "quest/incom_xwing_plans",
	terminalCell = 9825957,
	planTemplate = "object/tangible/mission/incom_xwing_plans.iff",
	rewardTemplate = "object/tangible/ship/crafted/chassis/incom_xwing_reward_deed.iff",
}

registerScreenPlay("IncomXwingPlans", true)

function IncomXwingPlans:start()
	if (isZoneEnabled("lok")) then
		local pNpc = spawnMobile("lok", "incom_partisan_contact", 1, -5655, 62, -4815, 225, 0)
		if (pNpc ~= nil) then
			AiAgent(pNpc):addObjectFlag(AI_STATIC)
			writeData("IncomXwingPlans:npc", SceneObject(pNpc):getObjectID())
		end
	end

	if (isZoneEnabled("corellia")) then
		local pCell = getSceneObject(self.terminalCell)
		if (pCell == nil or not SceneObject(pCell):isCellObject() or SceneObject(pCell):getZoneName() ~= "corellia") then
			printLuaError("IncomXwingPlans: terminal cell 9825957 is missing; install the matching Corellia snapshot.")
			return
		end

		local pTerminal = spawnSceneObject("corellia", "object/tangible/terminal/terminal_geo_bunker.iff", 0, 0.1, -5.4, self.terminalCell, 0)
		if (pTerminal ~= nil) then
			SceneObject(pTerminal):setCustomObjectName("Incom Flight Test Archive")
			SceneObject(pTerminal):setObjectMenuComponent("IncomXwingPlansMenuComponent")
			writeData("IncomXwingPlans:terminal", SceneObject(pTerminal):getObjectID())
		end
	end
end

function IncomXwingPlans:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function IncomXwingPlans:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	Journal.begin(pPlayer, self.questKey, false)
	if (stage >= 2) then
		Journal.task(pPlayer, self.questKey, 0, "complete", false)
	end
	if (stage == 1) then
		Journal.task(pPlayer, self.questKey, 0, "active", true)
	elseif (stage == 2) then
		Journal.task(pPlayer, self.questKey, 1, "active", true)
	elseif (stage == 3) then
		Journal.task(pPlayer, self.questKey, 1, "complete", false)
		Journal.complete(pPlayer, self.questKey, true)
	end
end

function IncomXwingPlans:canSpeak(pPlayer, pNpc)
	return pPlayer ~= nil and pNpc ~= nil and CreatureObject(pPlayer):getPlayerObject() ~= nil
		and SceneObject(pPlayer):getZoneName() == "lok"
		and SceneObject(pNpc):getObjectID() == readData("IncomXwingPlans:npc")
		and CreatureObject(pPlayer):isInRangeWithObject(pNpc, 6)
		and not CreatureObject(pPlayer):isInCombat()
		and not CreatureObject(pPlayer):isDead()
end

function IncomXwingPlans:accept(pPlayer, pNpc)
	if (not self:canSpeak(pPlayer, pNpc) or not CreatureObject(pPlayer):isRebel() or self:getStage(pPlayer) ~= 0) then
		return false
	end
	self:setStage(pPlayer, 1)
	self:giveWaypoint(pPlayer)
	return true
end

function IncomXwingPlans:giveWaypoint(pPlayer)
	if (self:getStage(pPlayer) == 1) then
		Journal.waypoint(pPlayer, self.questKey, "corellia", -5697, 5, -6422, "Incom Testing Facility", "Find the flight test archive inside the officer's shed.")
	elseif (self:getStage(pPlayer) == 2) then
		Journal.waypoint(pPlayer, self.questKey, "lok", -5655, 62, -4815, "Kessa Venn", "Deliver the X-Wing technical plans to Saw's camp.")
	end
end

function IncomXwingPlans:getPlans(pPlayer)
	local id = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "plans")) or 0
	local pPlans = getSceneObject(id)
	if (pPlans ~= nil and SceneObject(pPlans):getTemplateObjectPath() == self.planTemplate) then
		return pPlans
	end
	return nil
end

function IncomXwingPlans:canUseTerminal(pPlayer, pTerminal)
	if (pPlayer == nil or pTerminal == nil or CreatureObject(pPlayer):getPlayerObject() == nil) then
		return false
	end
	local stage = self:getStage(pPlayer)
	return (stage == 1 or stage == 2) and CreatureObject(pPlayer):isRebel()
		and not CreatureObject(pPlayer):isInCombat() and not CreatureObject(pPlayer):isDead()
		and SceneObject(pPlayer):getZoneName() == "corellia"
		and SceneObject(pPlayer):getParentID() == self.terminalCell
		and SceneObject(pTerminal):getParentID() == self.terminalCell
		and SceneObject(pTerminal):getObjectID() == readData("IncomXwingPlans:terminal")
		and CreatureObject(pPlayer):isInRangeWithObject(pTerminal, 5)
end

function IncomXwingPlans:openTerminal(pPlayer, pTerminal)
	if (not self:canUseTerminal(pPlayer, pTerminal)) then
		return
	end
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local key = SceneObject(pPlayer):getObjectID() .. ":IncomXwingPlans:sui"
	local oldPage = readData(key)
	if (oldPage ~= 0) then
		PlayerObject(pGhost):removeSuiBox(oldPage)
	end
	local sui = SuiMessageBox.new("IncomXwingPlans", "downloadCallback")
	sui.setTitle("Incom Flight Test Archive")
	sui.setPrompt("RESTRICTED: T-65 X-Wing Fighter\n\nTechnical archive: S-foil assembly, four laser cannons, proton torpedo systems, shield generators, hyperdrive and astromech integration.\n\nDownload the complete technical plans to a datadisk?")
	sui.setOkButtonText("Download plans")
	sui.setCancelButtonText("Disconnect")
	sui.setTargetNetworkId(SceneObject(pTerminal):getObjectID())
	sui.setForceCloseDistance(5)
	writeData(key, sui.sendTo(pPlayer))
end

function IncomXwingPlans:downloadCallback(pPlayer, pSui, eventIndex)
	if (pPlayer == nil or pSui == nil) then
		return
	end
	local pPage = LuaSuiBoxPage(pSui):getSuiPageData()
	if (pPage == nil) then
		return
	end
	local page = LuaSuiPageData(pPage)
	local key = SceneObject(pPlayer):getObjectID() .. ":IncomXwingPlans:sui"
	if (readData(key) ~= page:getPageId()) then
		return
	end
	deleteData(key)
	if (eventIndex ~= 0) then
		return
	end
	local pTerminal = getSceneObject(page:getTargetNetworkId())
	if (not self:canUseTerminal(pPlayer, pTerminal)) then
		return
	end
	if (self:getPlans(pPlayer) ~= nil) then
		CreatureObject(pPlayer):sendSystemMessage("You already downloaded these plans. Retrieve your existing datadisk from your inventory or bank.")
		return
	end
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
	if (pInventory == nil or SceneObject(pInventory):isContainerFullRecursive()) then
		CreatureObject(pPlayer):sendSystemMessage("Make room in your inventory for the technical plans.")
		return
	end
	local pPlans = giveItem(pInventory, self.planTemplate, -1)
	if (pPlans == nil) then
		CreatureObject(pPlayer):sendSystemMessage("The download failed. Try the terminal again.")
		return
	end
	SceneObject(pPlans):setCustomObjectName("X-Wing Technical plans")
	writeScreenPlayData(pPlayer, self.screenplayName, "plans", tostring(SceneObject(pPlans):getObjectID()))
	self:setStage(pPlayer, 2)
	self:giveWaypoint(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("Download complete. Deliver the X-Wing Technical plans to Kessa Venn at Saw Gerrera's camp on Lok.")
end

function IncomXwingPlans:complete(pPlayer, pNpc)
	if (not self:canSpeak(pPlayer, pNpc) or not CreatureObject(pPlayer):isRebel() or self:getStage(pPlayer) ~= 2) then
		return "not_ready"
	end
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
	local pPlans = self:getPlans(pPlayer)
	if (pInventory == nil or pPlans == nil or not SceneObject(pPlans):isASubChildOf(pInventory)) then
		return "missing_plans"
	end
	-- Reserve reward space before consuming the player's only copy of the plans.
	if (SceneObject(pInventory):isContainerFullRecursive()) then
		return "inventory_full"
	end
	local pDeed = giveItem(pInventory, self.rewardTemplate, -1)
	if (pDeed == nil) then
		return "reward_failed"
	end
	self:setStage(pPlayer, 3)
	SceneObject(pPlans):destroyObjectFromWorld()
	SceneObject(pPlans):destroyObjectFromDatabase()
	writeScreenPlayData(pPlayer, self.screenplayName, "plans", "0")
	Journal.clearWaypoint(pPlayer, self.questKey)
	return "rewarded"
end
