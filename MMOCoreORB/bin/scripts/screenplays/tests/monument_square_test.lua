-- Run from MMOCoreORB with lua bin/scripts/screenplays/tests/monument_square_test.lua
-- Exercise the same registered callbacks as Core3, with in-memory zone objects.
local data, objects, events, roles, convos, goods = {}, {}, {}, {}, {}, {}
local nextId, enabled, failSpawn = 1000,false,nil
local trace = {}
local function export(kind,...)
	local row = {kind,...}
	for i=1,#row do row[i]=tostring(row[i]) end
	table.insert(trace,table.concat(row,","))
end
local function count(t) local n=0 for _ in pairs(t) do n=n+1 end return n end
local function pass(message) print("PASS", message) end
local function inherit(self,t) return setmetatable(t or {},{__index=self}) end
Object={new=inherit}; ScreenPlay=Object:new{}
function ScreenPlay:setMoodString(n,v) n.mood=v end
function ScreenPlay:setCustomName(n,v) n.name=v end
function registerScreenPlay(n,active) assert(_G[n] and active) end
NONE=0;AIENABLED=1;INVULNERABLE=2;CONVERSABLE=4;INTERESTING=8;NAME_TAG=4;CONSUMABLE=12
AI_PATROLLING=1; AI_STATIONARY=2; DESTINATIONREACHED=10; CREATUREDESPAWNED=11
for _,n in ipairs({"commoner","mouse_droid","le_repair_droid"}) do _G[n]=Object:new{} end
CreatureTemplates={addCreatureTemplate=function(_,v,k) assert(not roles[k]);roles[k]=v end}
ConvoTemplate=Object:new{addScreen=function(self,v) assert(not self.screens[v.id]);self.screens[v.id]=v end}
ConvoScreen=Object:new{}
function addConversationTemplate(n,v) assert(not convos[n]);convos[n]=v end
ObjectTemplates={addTemplate=function(_,v,k) assert(not goods[k]);goods[k]=v end}
for _,n in ipairs({"drink_caf","dessert_puffcake","dish_fire_stew","dessert_bofa_treat",
	"dish_ramorrean_capanata", "dish_teltier_noodles", "dish_braised_canron", "dessert_ryshcate"}) do
	_G["object_tangible_food_crafted_shared_"..n]=Object:new{parent=n}
end
object_tangible_furniture_decorative_shared_umate_pocket_holo=Object:new{}
dofile("bin/scripts/mobile/townsperson/monument_square.lua")
dofile("bin/scripts/mobile/conversations/misc/monument_square_conv.lua")
dofile("bin/scripts/screenplays/conv_handler.lua")
dofile("bin/scripts/screenplays/cities/monument_square_vendor_handler.lua")
dofile("bin/scripts/screenplays/cities/coruscant_monument_square.lua")
dofile("bin/scripts/object/tangible/food/monument_square.lua")
dofile("bin/scripts/object/custom_content/tangible/furniture/decorative/umate_pocket_holo.lua")
for id,role in pairs(roles) do
	assert(role.pvpBitmask==NONE and role.creatureBitmask==NONE)
	if role.conversationTemplate then assert(convos[role.conversationTemplate]) end
	for _,skin in ipairs(role.templates or {}) do export("skin",skin) end
end
for name,conv in pairs(convos) do
	local reachable={}
	local function follow(id)
		local screen=assert(conv.screens[id],id); if reachable[id] then return end; reachable[id]=true
		for _,option in ipairs(screen.options) do follow(option[2]) end
	end
	follow("hello")
	for id in pairs(conv.screens) do assert(reachable[id] or name=="monumentShop",id) end
end
function isZoneEnabled(n) return n=="coruscant" and enabled end
function readData(k) return data[k] or 0 end
function writeData(k,v) data[k]=v end
function deleteData(k) data[k]=nil end
function getSceneObject(id) return objects[id] end
SceneObject=function(p) return p end; CreatureObject=SceneObject; AiAgent=SceneObject
local actor=Object:new{}
function actor:getZoneName() return self.zone end
function actor:isDead() return self.dead == true end
function actor:getObjectID() return self.id end
function actor:getCreatureTemplateName() return self.mobile end
function actor:setMovementState(v) self.state=v end
function actor:addObjectFlag(v) self.flag=v;export("stationary",self.mobile,self.x,self.z) end
function actor:getPatrolPointsSize() return self.target and 1 or 0 end
function actor:setNextPosition(x,h,z,cell)
	assert(not self.target and self.state==AI_PATROLLING and cell==0 and h==40)
	self.target={x,z};export("leg",self.mobile,self.x,self.z,x,z)
end
function actor:updateDirection(v) self.heading=v end
function actor:doAnimation(v) self.anim=v;export("cue",self.mobile,v) end
local function newObject(t)
	nextId=nextId+1;t.id=nextId;t.observers={};objects[nextId]=actor:new(t);return objects[nextId]
end
function spawnMobile(zone,mobile,respawn,x,h,z,angle,cell)
	assert(roles[mobile] and zone=="coruscant" and h==40 and cell==0 and respawn==0)
	if failSpawn==mobile then failSpawn=nil;return nil end
	export("post",mobile,x,z)
	return newObject{mobile=mobile,x=x,z=z,zone=zone}
end
function spawnSceneObject(zone,path,x,h,z,cell,a)
	assert(zone=="coruscant" and cell==0)
	export("prop",path,x,h,z)
	return newObject{prop=path,x=x,z=z}
end
function createEvent(ms,screen,fn,n,args)
	assert(ms>0 and _G[screen][fn]);table.insert(events,{ms=ms,fn=fn,n=n,args=args})
end
function createObserver(id,screen,fn,n) assert(_G[screen][fn] and not n.observers[id]);n.observers[id]=fn end
local plaza=CoruscantMonumentSquare
plaza:start(); assert(count(objects)==0);enabled=true;failSpawn="monument_holographer";plaza:start()
assert(count(objects)==36);local retry
for _,e in ipairs(events) do if e.fn=="spawnSlot" then retry=e end end
assert(retry);plaza:spawnSlot(nil,retry.args);plaza:start()
assert(count(objects)==37)
local people,visitors,movers,visitorWalkers,stalls,rangers,droids,props=0,0,0,0,0,0,0,0
local shopNPCs={}
for _,n in pairs(objects) do
	if n.mobile then
		people=people+1
		assert(n.observers[CREATUREDESPAWNED])
		local v=n.mobile=="monument_visitor" or n.mobile=="monument_holographer"
		if v then visitors=visitors+1 end
		if n.state then
			movers=movers+1; if v then visitorWalkers=visitorWalkers+1 end
			assert(n.observers[DESTINATIONREACHED])
			for i=1,22 do
				plaza:depart(n); local t=assert(n.target);plaza:depart(n);assert(n.target==t)
				local before=#events;plaza:arrived(n);assert(#events==before)
				n.x,n.z=t[1],t[2];n.target=nil
				plaza:arrived(n);plaza:arrived(n)
				assert(#events==before+1 and events[#events].fn=="depart")
			end
		else assert(n.flag==AI_STATIONARY) end
		if n.mobile:match("_seller$") then stalls=stalls+1;table.insert(shopNPCs,n) end
		if n.mobile:match("_ranger$") then rangers=rangers+1 end
		if n.mobile=="monument_cleaner" or n.mobile=="monument_lamp_tech" then droids=droids+1 end
	else props=props+1 end
end
assert(people==32 and visitors==24 and movers==11 and visitorWalkers==8 and stalls==3 and rangers==2 and droids==3 and props==5)
pass("32 NPCs, correct role counts, five display pieces, duplicate starts, retries, and 22 legs per walker")
local victim=objects[assert(readData("CoruscantMonumentSquare:slot:1"))]
assert(plaza:despawned(victim)==1);objects[victim.id]=nil;local replacement=events[#events];assert(replacement.fn=="spawnSlot")
plaza:depart(victim);assert(not victim.target);plaza:spawnSlot(nil,replacement.args);plaza:spawnSlot(nil,replacement.args);assert(count(objects)==37)
plaza:despawned(victim);assert(count(objects)==37 and readData("CoruscantMonumentSquare:slot:1")~=0)
pass("despawn replacement and stale callbacks")
LuaConversationScreen=SceneObject
local sc=Object:new{}
function sc:getScreenID() return self.id end
function sc:cloneScreen() return sc:new{id=self.id,options={}} end
function sc:setCustomDialogText(v) self.text=v end
function sc:addOption(text,id) table.insert(self.options,{text,id}) end
local player=actor:new{cash=1000,inRange=true,zone="coruscant"}
function actor:isInRangeWithObject(n,r) return self.inRange and r==6 end
function actor:getCashCredits() return self.cash end
function actor:subtractCashCredits(n) assert(n<=self.cash);self.cash=self.cash-n end
function actor:getSlottedObject(key) assert(key=="inventory");return self.inv end
function actor:isContainerFullRecursive() return self.full end
function actor:setCustomObjectName(v) self.name=v end
local gifts={}
function giveItem(inv,path,slot)
	assert(slot==-1);if inv.failed then return nil end
	assert(goods[path] or path=="object/tangible/furniture/decorative/carved_bowl.iff",path)
	local item=actor:new{};table.insert(gifts,item);export("item",path);return item
end
LuaConversationTemplate=SceneObject
LuaConversationSession=SceneObject
function actor:getConversationSession() return self.session end
function sc:getOptionLink(zeroBased) local o=self.options[zeroBased+1];return o and o[2] or "" end
function ConvoTemplate:getScreen(id) return self.screens[id] end
function ConvoTemplate:getInitialScreen() return self.screens[self.initialScreen] end
local function talk(n,id)
	assert(convos.monumentShop.screens[id])
	return MonumentSquareVendorHandler:runScreenHandlers(nil,player,n,1,sc:new{id=id})
end
for _,n in ipairs(shopNPCs) do
	local menu=talk(n,"hello");assert(#menu.options==3 and menu.text)
	for i=1,2 do
		local opt=menu.options[i];local id=opt[2];local price=tonumber(opt[1]:match("%((%d+) credits%)"))
		player.session={getLastConversationScreen=function() return menu end}
		assert(MonumentSquareVendorHandler:getNextConversationScreen(convos.monumentShop,player,i-1,n).id==id and price)
		player.session=nil
		local before=#gifts;player.cash=1000;player.inv=nil;talk(n,id)
		player.inv=actor:new{full=true};talk(n,id);player.inv.full=false
		player.inRange=false;talk(n,id);player.inRange=true;player.zone="naboo";talk(n,id);player.zone="coruscant"
		player.inv.failed=true;talk(n,id);player.inv.failed=false;assert(player.cash==1000)
		player.cash=price-1;talk(n,id);assert(player.cash==price-1 and #gifts==before)
		player.cash=price;local receipt=talk(n,id)
		assert(#gifts==before+1 and gifts[#gifts].name==opt[1]:match("^(.-) %(") and player.cash==0 and receipt.text:find("credits"))
	end
end
pass("all six purchases and failure paths, vendor-specific prices, both ranger dialogue trees")
return table.concat(trace,"\n")
