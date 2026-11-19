SenateDelegationLift = {}

local buildingTemplate = "object/building/coruscant/imperial_senate.iff"
local panelTemplate = "object/tangible/terminal/senate_delegation_lift.iff"
local windowType = 15241
local lastTier = 14

local function buildingAtPanel(pPlayer, pPanel)
	if pPlayer == nil or pPanel == nil then return nil end
	local player, panel = CreatureObject(pPlayer), SceneObject(pPanel)
	if panel:getTemplateObjectPath() ~= panelTemplate or player:getParentID() ~= panel:getParentID()
		or math.abs(player:getPositionZ() - panel:getPositionZ()) > 3
		or not player:isInRangeWithObject(pPanel, 4) then return nil end

	local pCell = panel:getParent()
	if pCell == nil then return nil end
	local pBuilding = SceneObject(pCell):getParent()
	if pBuilding ~= nil and SceneObject(pBuilding):getTemplateObjectPath() == buildingTemplate then
		return pBuilding
	end
end

local function stopName(tier)
	if tier == 0 then return "Public concourse" end
	return "Delegation tier " .. tier
end

function SenateDelegationLift:fillObjectMenuResponse(pPanel, pMenu, pPlayer)
	LuaObjectMenuResponse(pMenu):addRadialMenuItem(20, 3, "Select Senate lift destination")
end

function SenateDelegationLift:handleObjectMenuSelect(pPanel, pPlayer, selection)
	if selection ~= 20 or buildingAtPanel(pPlayer, pPanel) == nil then return 0 end
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	if pGhost == nil then return 0 end
	PlayerObject(pGhost):closeSuiWindowType(windowType)

	local sui = SuiListBox.new("SenateDelegationLift", "travel")
	sui.setWindowType(windowType)
	sui.setTitle("Senate delegation lift")
	sui.setPrompt("Select the concourse or a delegation tier.")
	for tier = 0, lastTier do sui.add(stopName(tier), "") end
	sui.setTargetNetworkId(SceneObject(pPanel):getObjectID())
	sui.setForceCloseDistance(4)
	sui.sendTo(pPlayer)
	return 0
end

function SenateDelegationLift:travel(pPlayer, pSui, eventIndex, selectedRow)
	if pPlayer == nil or pSui == nil or tonumber(eventIndex) ~= 0 then return end
	local tier = tonumber(selectedRow)
	if tier == nil or tier ~= math.floor(tier) or tier < 0 or tier > lastTier then return end
	local pPage = LuaSuiBoxPage(pSui):getSuiPageData()
	if pPage == nil then return end
	local pSource = getSceneObject(LuaSuiPageData(pPage):getTargetNetworkId())
	local pBuilding = buildingAtPanel(pPlayer, pSource)
	if pBuilding == nil then return end

	-- Resolve a real destination panel in this instance. The two cells keep their
	-- existing numbers even when several Senate buildings are placed on a zone.
	local cellNumber = tier == 0 and 1 or 2
	local pCell = BuildingObject(pBuilding):getCell(cellNumber)
	if pCell == nil then return end
	-- SceneObject is rebound for every panel and for the player during teleport.
	local cell = SceneObject1(pCell)
	local floorHeight = tier == 0 and 0 or -40 + (tier - 1) * 8
	for i = 0, cell:getContainerObjectsSize() - 1 do
		local pObject = cell:getContainerObject(i)
		if pObject ~= nil then
			local obj = SceneObject(pObject)
			if obj:getTemplateObjectPath() == panelTemplate and math.abs(obj:getPositionZ() - floorHeight) < 1 then
				-- The controls face out from the back wall. Arrive two metres in
				-- front of the selected panel, on the corridor's walkable floor.
				local heading = obj:getDirectionAngle() * math.pi / 180
				local x = obj:getPositionX() + 2 * math.sin(heading)
				local y = obj:getPositionY() + 2 * math.cos(heading)
				SceneObject(pPlayer):teleport(x, floorHeight, y, cell:getObjectID())
				CreatureObject(pPlayer):sendSystemMessage("Senate lift: " .. stopName(tier) .. ".")
				return
			end
		end
	end
	CreatureObject(pPlayer):sendSystemMessage("That Senate lift stop is out of service.")
end
