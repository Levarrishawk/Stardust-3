CoruscantMonumentSquare = ScreenPlay:new {
	screenplayName = "CoruscantMonumentSquare",
	numberOfActs = 1,
}

registerScreenPlay("CoruscantMonumentSquare", true)

-- World X/Z, pause in seconds, optional facing and action. All posts are on
-- the outdoor deck at height 40. Returning along the same lane keeps walkers
-- clear of the summit aperture, pavilion walls and the cantina facade.
local arrivals = {
	{1538,774,16}, {1542,748,13,100}, {1540,726,1}, {1539,695,1}, {1537,670,28,168,"point_down"},
}
local westWalk = {
	{1503,655,7}, {1478,655,1}, {1453,654,2}, {1453,624,19,-165,"point_left"},
}
local northGallery = {
	{1476,738,14,-123}, {1496,735,1}, {1503,722,6,-120}, {1505,710,15,-94},
}
local eastGallery = {
	{1609,709,16,-95}, {1615,697,2}, {1632,696,1}, {1651,700,19,88},
}
local cantina = {
	{1598,548,18,137}, {1585,548,1}, {1577,553,1}, {1558,563,1}, {1545,574,1}, {1540,585,1}, {1540,616,12,0},
}
local supper = {
	{1566,622,17,-140}, {1574,625,1}, {1595,625,2}, {1617,625,1}, {1622,608,1},
	{1619,592,1}, {1605,578,1}, {1598,568,1}, {1597,549,20,138},
}
local southWalk = {
	{1524,643,14,-142}, {1514,634,2}, {1512,617,1}, {1506,604,11,-90},
}
local slots = {}
local function walker(mobile, route, start, step, offset, delay, name)
	table.insert(slots, {mobile=mobile, route=route, start=start, step=step, offset=offset, delay=delay, name=name})
end
local function post(mobile, x, z, facing, mood)
	table.insert(slots, {mobile=mobile, x=x, z=z, facing=facing, mood=mood})
end
local visitor = "monument_visitor"
-- Two travel companions share stops but occupy separate lanes.
walker(visitor, arrivals, 1, 1, 0, 5)
walker("monument_holographer", arrivals, 1, 1, -1.7, 5)
walker(visitor, westWalk, 4, -1, 0, 10)
walker(visitor, northGallery, 2, 1, 0, 7)
walker(visitor, eastGallery, 3, -1, 0, 4)
walker(visitor, cantina, 1, 1, 0, 11)
walker(visitor, supper, 3, 1, 0, 6)
walker(visitor, southWalk, 3, -1, 0, 8)

-- Summit watchers, friends at the projection, shoppers and people on breaks.
post(visitor, 1528,667,130,"curious")
post(visitor, 1530,669,143,"entertained")
post(visitor, 1555,660,-103,"neutral")
post(visitor, 1547,643,-27,"curious")
post(visitor, 1443,619,125,"entertained")
post(visitor, 1445,621,143,"happy")
post(visitor, 1457,611,-65,"curious")
post(visitor, 1543.4,743.5,55,"neutral")
post(visitor, 1543.6,741.8,24,"happy")
post(visitor, 1566,617,-45,"neutral")
post(visitor, 1482,560,170,"curious")
post(visitor, 1484,561,-138,"entertained")
post(visitor, 1505,705,-80,"neutral")
post(visitor, 1608,713,-107,"happy")
post(visitor, 1573,561,115,"conversation")
post(visitor, 1575,560,-64,"conversation")

post("monument_caf_seller",1545,745,-90)
post("monument_food_seller",1565.8,619,100)
post("monument_keepsake_seller",1481,558,10)
post("monument_welcome_ranger",1534,762,15)
post("monument_summit_ranger",1532,669.5,27)

walker("monument_cleaner", {{1547,740,4},{1547,730,2},{1549,730,3},{1549,740,5}}, 1,1,0,3,"MSE-C4 (Pavement Cleaner)")
walker("monument_cleaner", {{1568,616,4},{1572,616,2},{1572,607,3},{1570,607,5}}, 3,-1,0,6,"MSE-C8 (Pavement Cleaner)")
walker("monument_lamp_tech", {{1544.5,698.3,18,-90,"manipulate_low"},{1544.5,715,15,-90,"manipulate_low"},{1544.5,731.7,20,-90,"manipulate_low"}}, 1,1,0,16)

local tableTemplate = "object/tangible/furniture/all/frn_all_table_s03.iff"
local displays = {
	{"cafTable",tableTemplate,1543.8,40,745},
	-- The cup mesh starts 0.75 m above its origin. The inset tabletop here is at 40.73956 m.
	{"cafCup","object/static/item/item_con_tato_cup_s2.iff",1543.8,39.98956,745.25},
	{"cafPitcher","object/static/item/item_con_pitcher_full.iff",1543.8,40.75,744.78},
	{"keepsakeTable",tableTemplate,1481.2,40,559.2},
	{"displayHolo","object/tangible/furniture/decorative/umate_pocket_holo.iff",1481.2,40.75,559.2},
}

function CoruscantMonumentSquare:setupDisplays()
	local retry = false
	for _,prop in ipairs(displays) do
		local key = self.screenplayName .. ":display:" .. prop[1]
		if not getSceneObject(readData(key)) then
			local pProp = spawnSceneObject("coruscant",prop[2],prop[3],prop[4],prop[5],0,0)
			if pProp then writeData(key,SceneObject(pProp):getObjectID()) else retry = true end
		end
	end
	if retry then createEvent(60000,self.screenplayName,"setupDisplays",nil,"") end
end

function CoruscantMonumentSquare:start()
	if not isZoneEnabled("coruscant") then return end
	self:setupDisplays()
	for slot=1,#slots do self:spawnSlot(nil,slot) end
end

local function slotKey(slot)
	return "CoruscantMonumentSquare:slot:" .. slot
end

local function actorKey(pNpc)
	return "CoruscantMonumentSquare:actor:" .. SceneObject(pNpc):getObjectID()
end

function CoruscantMonumentSquare:spawnSlot(pUnused, args)
	local slot = tonumber(args)
	local spec = slots[slot]
	if not spec or not isZoneEnabled("coruscant") then return end
	if getSceneObject(readData(slotKey(slot))) ~= nil then return end

	local x,z,heading = spec.x,spec.z,spec.facing
	if spec.route then
		local point = spec.route[spec.start]
		local nextPoint = spec.route[spec.start + spec.step]
		x,z = point[1] + spec.offset,point[2]
		heading = math.deg((math.atan2 or math.atan)(nextPoint[1]-point[1], nextPoint[2]-z))
	end
	local pNpc = spawnMobile("coruscant",spec.mobile,0,x,40,z,heading,0)
	if pNpc == nil then
		createEvent(60000,self.screenplayName,"spawnSlot",nil,tostring(slot))
		return
	end

	local key = actorKey(pNpc)
	writeData(slotKey(slot),SceneObject(pNpc):getObjectID())
	writeData(key,slot)
	createObserver(CREATUREDESPAWNED,self.screenplayName,"despawned",pNpc)
	if spec.name then self:setCustomName(pNpc,spec.name) end
	if spec.mood then self:setMoodString(pNpc,spec.mood) end
	if spec.route then
		writeData(key .. ":point",spec.start)
		-- Direction is encoded as 1 (forwards) or 2 (backwards) in unsigned shared data.
		writeData(key .. ":direction",spec.step == 1 and 1 or 2)
		AiAgent(pNpc):setMovementState(AI_PATROLLING)
		createObserver(DESTINATIONREACHED,self.screenplayName,"arrived",pNpc)
		createEvent(spec.delay*1000,self.screenplayName,"depart",pNpc,"")
	else
		AiAgent(pNpc):addObjectFlag(AI_STATIONARY)
	end
end

function CoruscantMonumentSquare:depart(pNpc)
	if pNpc == nil then return end
	local key = actorKey(pNpc)
	local spec = slots[readData(key)]
	if not spec or not spec.route or readData(key .. ":moving") ~= 0 then return end
	if SceneObject(pNpc):getZoneName() ~= "coruscant" or CreatureObject(pNpc):isDead() then return end
	local i = readData(key .. ":point")
	local direction = readData(key .. ":direction")
	if i == 1 then direction = 1 elseif i == #spec.route then direction = 2 end
	i = i + (direction == 1 and 1 or -1)
	local point = spec.route[i]
	writeData(key .. ":direction",direction)
	writeData(key .. ":point",i)
	writeData(key .. ":moving",1)
	AiAgent(pNpc):setNextPosition(point[1]+spec.offset,40,point[2],0)
end

function CoruscantMonumentSquare:arrived(pNpc)
	if pNpc == nil then return 1 end
	local key = actorKey(pNpc)
	local spec = slots[readData(key)]
	if not spec then return 1 end
	if readData(key .. ":moving") == 0 then return 0 end
	local point = spec.route[readData(key .. ":point")]
	if AiAgent(pNpc):getPatrolPointsSize() ~= 0 then return 0 end
	deleteData(key .. ":moving")
	if point[4] then SceneObject(pNpc):updateDirection(math.rad(point[4])) end
	if point[5] then
		local action = spec.mobile == "monument_holographer" and "check_wrist_device" or point[5]
		CreatureObject(pNpc):doAnimation(action)
	end
	createEvent(point[3]*1000,self.screenplayName,"depart",pNpc,"")
	return 0
end

function CoruscantMonumentSquare:despawned(pNpc)
	if pNpc == nil then return 1 end
	local key = actorKey(pNpc)
	local slot = readData(key)
	deleteData(key)
	deleteData(key .. ":point")
	deleteData(key .. ":direction")
	deleteData(key .. ":moving")
	if slots[slot] and readData(slotKey(slot)) == SceneObject(pNpc):getObjectID() then
		deleteData(slotKey(slot))
		createEvent(60000,self.screenplayName,"spawnSlot",nil,tostring(slot))
	end
	return 1
end
