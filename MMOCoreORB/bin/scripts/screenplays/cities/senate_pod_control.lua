local controlsTemplate = "object/tangible/terminal/senate_pod_control.iff"
local liftTemplate = "object/tangible/terminal/senate_delegation_lift.iff"
local senateTemplate = "object/building/coruscant/imperial_senate.iff"
local windowType = 15242
local pi, sin, cos = math.pi, math.sin, math.cos
local galleryAngle = pi / 16
local tiers = {}
local sectors = {"south", "southeast", "east", "northeast", "north", "northwest", "west", "southwest"}

-- Pod local +Z points towards the rostrum. The elevator button mesh is
-- 1.14 m above its object origin. Lay its back against the sloped console.
local function control(radius, angle, level, lateral, forward, height, pitch)
	local yaw = pi - angle
	forward = forward - 1.14 * sin(pitch)
	return {
		x = (radius - forward) * sin(angle) + lateral * cos(angle),
		y = -(radius - forward) * cos(angle) + lateral * sin(angle),
		z = level + height - 1.14 * cos(pitch),
		ow = cos(yaw/2)*cos(pitch/2), ox = -cos(yaw/2)*sin(pitch/2),
		oy = sin(yaw/2)*cos(pitch/2), oz = sin(yaw/2)*sin(pitch/2)
	}
end

local function stop(radius, angle, height)
	return {x = radius * sin(angle), y = -radius * cos(angle), z = height}
end

-- Match the chamber builder's tier radii, stagger and three reserved bays.
for tier = 1, 14 do
	local row = tier - 1
	local radius, level = 67 + 7*row, -40 + 8*row
	local wall = radius * cos(pi/64)
	local gallery = control(wall, galleryAngle, level, 2.55, 7.98, 1.153, math.atan(1.1/.16))
	local layout = {gallery = gallery, arrival = stop(wall - 7.25, galleryAngle, level), pods = {}}
	tiers[tier] = layout
	local count = math.floor(2*pi*(radius - 5)/13 + .5)
	for bay = 0, count - 1 do
		local angle = (bay + (row % 2)*.5) * 2*pi/count
		local nearGallery = math.abs((angle - galleryAngle + pi) % (2*pi) - pi) * (radius - 5) < 10.5
		local nearDoor = (row == 5 and math.min(angle, 2*pi-angle) < .115) or (row == 6 and bay == 0)
		if not nearGallery and not nearDoor then
			local panel = control(radius - 5, angle, level - 1.48, 0, 3.135, 3.875, math.atan(.22/.26))
			panel.sector = sectors[math.floor(angle * 4/pi + .5) % 8 + 1]
			panel.arrival = stop(radius - 5 - 1.375, angle, level - 1.48 + 2.302)
			table.insert(layout.pods, panel)
		end
	end
end

SenatePodControl = {}

local function chamberCell(pCell)
	if pCell == nil or not SceneObject(pCell):isCellObject() then return false end
	local pBuilding = SceneObject(pCell):getParent()
	return pBuilding ~= nil and SceneObject(pBuilding):getTemplateObjectPath() == senateTemplate
		and BuildingObject(pBuilding):getCell(2) == pCell
end

local function tierAt(height)
	local tier = math.floor((height + 40)/8 + .5) + 1
	if tiers[tier] ~= nil and math.abs(height - (-40 + 8*(tier-1))) < 3 then return tier end
end

-- The same rounded key is used for authored coordinates and native float positions.
local function key(x, y, z)
	return string.format("%d/%d/%d", math.floor(x*10+.5), math.floor(y*10+.5), math.floor(z*10+.5))
end
local byPosition = {}
for tier, layout in ipairs(tiers) do
	byPosition[key(layout.gallery.x, layout.gallery.y, layout.gallery.z)] = {tier = tier, pod = 0}
	for pod, p in ipairs(layout.pods) do
		byPosition[key(p.x, p.y, p.z)] = {tier = tier, pod = pod}
	end
end

local function locate(pPlayer, pPanel)
	if pPlayer == nil or pPanel == nil then return end
	local player, panel = CreatureObject(pPlayer), SceneObject(pPanel)
	if player:getParentID() ~= panel:getParentID() or not player:isInRangeWithObject3d(pPanel, 4) then return end
	local pCell, template = panel:getParent(), panel:getTemplateObjectPath()
	local x, y, z = panel:getPositionX(), panel:getPositionY(), panel:getPositionZ()
	if not chamberCell(pCell) then return end
	if template == liftTemplate then return tierAt(z), 0, pCell end
	local info = byPosition[key(x,y,z)]
	if template == controlsTemplate and info then return info.tier, info.pod, pCell end
end

function SenatePodControl:isGallery(pPlayer,pPanel)
	local tier, role = locate(pPlayer,pPanel)
	return tier ~= nil and role == 0
end

function SenatePodControl:prepareTier(pCell, tier)
	if pCell ~= nil and tiers[tier] then
		createEvent(1, "SenatePodControl", "installTier", pCell, tostring(tier))
	end
end

-- Core3 locks the event's target cell. Concurrent visits cannot install
-- duplicate controls. Previously placed buildings pick up the same controls.
function SenatePodControl:installTier(pCell, args)
	local tier = tonumber(args)
	local layout = tiers[tier]
	if layout == nil or not chamberCell(pCell) then return end
	local cell = SceneObject1(pCell)
	local zone, id = cell:getZoneName(), cell:getObjectID()
	local present = {}
	for i = 0, cell:getContainerObjectsSize()-1 do
		local p = cell:getContainerObject(i)
		if p ~= nil then
			local o = SceneObject(p)
			if o:getTemplateObjectPath() == controlsTemplate then
				present[key(o:getPositionX(),o:getPositionY(),o:getPositionZ())] = true
			end
		end
	end
	for i = 0, #layout.pods do
		local p = i == 0 and layout.gallery or layout.pods[i]
		if not present[key(p.x,p.y,p.z)] then
			local button = spawnSceneObject(zone, controlsTemplate, p.x,p.z,p.y, id, p.ow,p.ox,p.oy,p.oz)
			if button ~= nil then
				SceneObject(button):setCustomObjectName(i == 0 and "Delegation pod selector" or string.format("Tier %d, pod %02d: return to gallery",tier,i))
			end
		end
	end
end

function SenatePodControl:playerLoggedIn(pPlayer)
	local player = CreatureObject(pPlayer)
	local tier, pCell = tierAt(player:getPositionZ()), player:getParent()
	if tier and chamberCell(pCell) then self:prepareTier(pCell, tier) end
end

function SenatePodControl:fillObjectMenuResponse(pPanel, pMenu, pPlayer)
	local tier, pod = locate(pPlayer,pPanel)
	if tier then
		LuaObjectMenuResponse(pMenu):addRadialMenuItem(20, 3, pod == 0 and "Board a delegation pod" or "Return to tier gallery")
	end
end

local function movePlayer(pPlayer, pCell, pos)
	local cellID = SceneObject(pCell):getObjectID()
	SceneObject(pPlayer):teleport(pos.x,pos.z,pos.y,cellID)
end

function SenatePodControl:openList(pPlayer, pPanel)
	local tier, pod, pCell = locate(pPlayer,pPanel)
	if tier == nil or pod ~= 0 then return end
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	if pGhost == nil then return end
	self:prepareTier(pCell,tier)
	PlayerObject(pGhost):closeSuiWindowType(windowType)
	local sui = SuiListBox.new("SenatePodControl", "board")
	sui.setWindowType(windowType)
	sui.setTitle("Delegation pods - tier " .. tier)
	sui.setPrompt("Choose a pod. Numbering starts at the south side and proceeds toward the east.")
	for i, p in ipairs(tiers[tier].pods) do sui.add(string.format("Pod %02d (%s)", i, p.sector), "") end
	sui.setTargetNetworkId(SceneObject(pPanel):getObjectID())
	sui.setForceCloseDistance(4)
	sui.sendTo(pPlayer)
end

function SenatePodControl:handleObjectMenuSelect(pPanel, pPlayer, selection)
	if selection ~= 20 then return 0 end
	local tier, pod, pCell = locate(pPlayer,pPanel)
	if tier then
		if pod == 0 then self:openList(pPlayer,pPanel)
		else movePlayer(pPlayer,pCell,tiers[tier].arrival) end
	end
	return 0
end

function SenatePodControl:board(pPlayer, pSui, eventIndex, selectedRow)
	if pPlayer == nil or pSui == nil or tonumber(eventIndex) ~= 0 then return end
	local row = tonumber(selectedRow)
	if not row or row < 0 or row ~= math.floor(row) then return end
	local pPage = LuaSuiBoxPage(pSui):getSuiPageData()
	if pPage == nil then return end
	local source = getSceneObject(LuaSuiPageData(pPage):getTargetNetworkId())
	local tier, role, pCell = locate(pPlayer,source)
	if tier == nil or role ~= 0 then return end
	local dest = tiers[tier].pods[row+1]
	if dest == nil then return end
	-- Confirm that the return button exists before sending anyone out.
	local cell = SceneObject1(pCell)
	for i = 0, cell:getContainerObjectsSize()-1 do
		local p = cell:getContainerObject(i)
		if p ~= nil then
			local panel = SceneObject(p)
			if panel:getTemplateObjectPath() == controlsTemplate and
				math.abs(panel:getPositionX()-dest.x) < .02 and math.abs(panel:getPositionY()-dest.y) < .02 and
				math.abs(panel:getPositionZ()-dest.z) < .02 then
				movePlayer(pPlayer,pCell,dest.arrival)
				return
			end
		end
	end
	self:prepareTier(pCell,tier)
	CreatureObject(pPlayer):sendSystemMessage("That pod's return control is coming online. Please select the pod again.")
end
