-- Run from MMOCoreORB with lua bin/scripts/screenplays/tests/monument_grill_test.lua.
local unpack = table.unpack or unpack
local function new(self, t) return setmetatable(t or {}, {__index=self}) end
Object={new=new}
ScreenPlay=Object:new{}
local npcs, db, events, lines, goods, templates, convos = {}, {}, {}, {}, {}, {}, {}
local now, nextId, enabled = 1000, 100, false
os.time=function() return now end
AI_PATROLLING=1; CONVERSABLE=4; INVULNERABLE=8; AIENABLED=16; INTERESTING=32; NONE=0; NAME_TAG=1; CONSUMABLE=12
function registerScreenPlay(id,active) assert(active and _G[id]) end
function readData(k) return db[k] or 0 end
function writeData(k,v) db[k]=v end
function deleteData(k) db[k]=nil end
function getSceneObject(id) return npcs[id] end
function isZoneEnabled(zone) return enabled and zone=="coruscant" end
function createEvent(ms,script,method,actor,args)
    assert(script=="MonumentGrill" and ms>0)
    events[#events+1]={due=now+ms/1000,method=method,actor=actor,args=args}
end
local Actor=Object:new{}
function Actor:getParentID() return self.cell end
function Actor:getObjectID() return self.id end
function Actor:getPositionX() return self.x end
function Actor:getPositionY() return self.z end
function Actor:getPositionZ() return self.height end
function Actor:getZoneName() return "coruscant" end
function Actor:getCreatureTemplateName() return self.role end
function Actor:updateDirection(a) self.heading=a end
function Actor:setCustomObjectName(n) self.name=n end
function Actor:setOptionBit(n) assert(n==CONVERSABLE); self.talk=true end
function Actor:clearOptionBit(n) assert(n==CONVERSABLE); self.talk=false end
function Actor:setMovementState(s) assert(s==AI_PATROLLING) end
function Actor:clearPatrolPoints() self.target=nil end
function Actor:clearCurrentPath() end
function Actor:setNextPosition(x,h,z,cell)
    assert(npcs[cell]); self.target={x,h,z,cell}; self.commands=(self.commands or 0)+1
end
function Actor:getPatrolPointsSize() return self.target and 1 or 0 end
function Actor:isInRangeWithObject(o,r) return (self.x-o.x)^2+(self.z-o.z)^2<=r*r end
local nearbyPlayers
function Actor:getPlayersInRange(range)
    assert(self.role and range == 64)
    return nearbyPlayers
end
function Actor:isPlayerCreature() return self.player end
function Actor:getCashCredits() return self.cash end
function Actor:subtractCashCredits(n) assert(self.cash>=n); self.cash=self.cash-n end
function Actor:getSlottedObject(id) assert(id=="inventory"); return self.inventory end
function Actor:isContainerFullRecursive() return self.full end
function Actor:getConversationSession() return self.session end
SceneObject=function(p)return p end
CreatureObject,AiAgent,LuaConversationScreen,LuaConversationTemplate,LuaConversationSession=SceneObject,SceneObject,SceneObject,SceneObject,SceneObject
function spatialChat(who,line) lines[#lines+1]={who.role,line,now} end
function spawnMobile(zone,role,delay,x,h,z,heading,cell)
    assert(zone=="coruscant" and (role=="monument_grill_waiter" or role=="monument_grill_robed_waiter") and cell==37000120 and templates[role] and delay==0)
    nextId=nextId+1; local p=Actor:new{id=nextId,role=role,x=x,height=h,z=z,cell=cell}
    npcs[nextId]=p; return p
end
function giveItem(inv,path,slot)
    assert(slot==-1 and goods[path],path)
    if inv.fail then return nil end
    local item=Actor:new{path=path}; inv[#inv+1]=item;return item
end
ConvoTemplate=Object:new{}
function ConvoTemplate:addScreen(s) self.screens[s.id]=s end
function ConvoTemplate:getScreen(id) return self.screens[id] end
function ConvoTemplate:getInitialScreen() return self:getScreen(self.initialScreen) end
ConvoScreen=Object:new{}
function ConvoScreen:getScreenID() return self.id end
function ConvoScreen:getOptionLink(i) local o=self.options[i+1];return o and o[2] or "" end
function ConvoScreen:cloneScreen()
    local options={}; for i,v in ipairs(self.options) do options[i]=v end
    return self:new{options=options}
end
function ConvoScreen:setCustomDialogText(s) self.text=s end
function ConvoScreen:addOption(s,id) self.options[#self.options+1]={s,id} end
function addConversationTemplate(n,t) convos[n]=t end
CreatureTemplates={addCreatureTemplate=function(_,t,n)templates[n]=t end}
ObjectTemplates={addTemplate=function(_,t,n)goods[n]=t end}
commoner=Object:new{}
for _,id in ipairs({"drink_caf","dessert_puffcake","dish_fire_stew","dessert_bofa_treat","dish_ramorrean_capanata","dish_teltier_noodles","dish_braised_canron","dessert_ryshcate",
"drink_vasarian_brandy","drink_ruby_bliel"}) do _G["object_tangible_food_crafted_shared_"..id]=Object:new{} end
local scripts="bin/scripts/"
dofile(scripts.."screenplays/conv_handler.lua")
dofile(scripts.."screenplays/cities/monument_square_vendor_handler.lua")
dofile(scripts.."screenplays/cities/monument_grill.lua")
dofile(scripts.."mobile/conversations/misc/monument_grill_conv.lua")
dofile(scripts.."mobile/townsperson/monument_grill.lua")
dofile(scripts.."object/tangible/food/monument_square.lua")
for _,id in ipairs({"desert_bloom","imported_utozz","ruby_bliel","hot_chocolate"}) do
    dofile(scripts.."object/tangible/food/bartender_drinks/"..id..".lua")
end
for cell=37000109,37000121 do npcs[cell]=Actor:new{cell=37000108,id=cell} end
for i,role in ipairs({"chef","line","prep","pass"}) do
    npcs[50+i]=Actor:new{id=50+i,cell=i<=2 and 37000119 or 37000121,role=role}
    writeData("CoruscantEntertainmentScreenPlay:grill:"..role,50+i)
end
local grill,handler=MonumentGrill,MonumentGrillMenuHandler
assert(templates.monument_grill_waiter.optionsBitmask==INVULNERABLE+AIENABLED+INTERESTING)
assert(templates.monument_grill_bartender.optionsBitmask==INVULNERABLE+CONVERSABLE+INTERESTING)
local convo=convos[templates.monument_grill_waiter.conversationTemplate]
assert(convo==convos[templates.monument_grill_bartender.conversationTemplate] and _G[convo.luaClassHandler]==handler)
local guest=Actor:new{id=4,player=true,inventory=Actor:new{},cash=2000}
local function talk(npc,id)
    return handler:runScreenHandlers(convo,guest,npc,0,assert(convo:getScreen(id)))
end
local function choose(npc,screen,i)
    guest.session={getLastConversationScreen=function()return screen end}
    local nextScreen=handler:getNextConversationScreen(convo,guest,i-1,npc)
    return talk(npc,nextScreen.id)
end
local function shop(npc,number,guestX,guestZ)
    guestX,guestZ=guestX or npc.x+.8,guestZ or npc.z
    guest.cell,guest.x,guest.z=npc.cell,guestX,guestZ
    local hello=talk(npc,"hello")
    assert(hello.text:find(number and string.format("%02d",number) or "bar",1,true))
    local menu=choose(npc,hello,1)
    assert(#menu.options==5 and menu.stopConversation=="false")
    for i=1,4 do
        menu=choose(npc,hello,1)
        local before,cash=#guest.inventory,guest.cash
        local name,price=menu.options[i][1]:match("^(.-) %((%d+) credits%)$")
        local result=choose(npc,menu,i)
        assert(#guest.inventory==before+1 and guest.inventory[#guest.inventory].name==name and cash-guest.cash==tonumber(price))
        assert(result.stopConversation=="true" and result.text:find(name,1,true))
        assert(talk(npc,"order"..i).id=="closed" and #guest.inventory==before+1)
    end
    local before,cash=#guest.inventory,guest.cash
    for _,failure in ipairs({"range","cell","cash","capacity","grant"}) do
        choose(npc,hello,1)
        if failure=="range" then guest.x=npc.x+12 elseif failure=="cell" then guest.cell=0
        elseif failure=="cash" then guest.cash=1 elseif failure=="capacity" then guest.inventory.full=true else guest.inventory.fail=true end
        local balance=guest.cash;talk(npc,"order1")
        assert(guest.cash==balance and #guest.inventory==before)
        guest.x,guest.cell,guest.cash=guestX,npc.cell,cash
        guest.inventory.full,guest.inventory.fail=false,false
    end
end

grill:start();assert(#events==0)
enabled=true;grill:start();local old=events;events={};grill:start()
for _,e in ipairs(old) do grill[e.method](grill,nil,e.args) end
assert(#events==2 and nextId==100)
local function event(method)
    for i,e in ipairs(events) do if e.method==method then table.remove(events,i);return e end end
    error("missing event "..method)
end
local function fire(method)
    local e=event(method);grill[method](grill,e.actor,e.args)
end
fire("rounds");assert(nextId==106)
local robedNames = {[1]="Maela Venn", [5]="Vessa Rin", [6]="Corin Hale"}
local function checkUniform(slot)
    local npc=npcs[readData("MonumentGrill:"..slot..":npc")]
    local name=robedNames[slot]
    if name then
        assert(npc.name==name.." (Wait Staff)" and npc.role=="monument_grill_robed_waiter")
        local t=templates[npc.role]
        assert(#t.templates==1 and t.templates[1]=="object/mobile/dressed_noble_naboo_twilek_female_02.iff")
        assert(t.conversationTemplate==templates.monument_grill_waiter.conversationTemplate)
        assert(t.optionsBitmask==templates.monument_grill_waiter.optionsBitmask)
    else
        assert(npc.role=="monument_grill_waiter")
    end
end
for slot=1,6 do checkUniform(slot) end
fire("kitchen");assert(#lines==0)
-- A missing zone can return nil, and a loaded zone with no players returns {}.
nearbyPlayers={};fire("kitchen");assert(#lines==0)
-- A player in the zone snapshot may already have left the kitchen.
guest.cell=0
nearbyPlayers={guest};fire("kitchen");assert(#lines==0)
guest.cell=37000120
for i=1,16 do
    local e=event("kitchen");now=math.ceil(e.due);grill:kitchen(nil,e.args)
    assert(#lines==i)
    if i%2==0 then assert(lines[i][1]~=lines[i-1][1] and lines[i][3]-lines[i-1][3]<=3)
    elseif i>1 then assert(lines[i][3]-lines[i-1][3]>=55) end
end
assert(lines[2][2]:find("Yes, Chef!",1,true))
-- Radius results may include the whole building. Apply the 18 m rule
-- in the dining room and exclude other rooms, even at the chef's position.
npcs[51].x,npcs[51].z=-27.51,-1.08
guest.x,guest.z=npcs[51].x+19,npcs[51].z
guest.cell=37000111;fire("kitchen");assert(#lines==16)
guest.cell,guest.x=37000110,npcs[51].x;fire("kitchen");assert(#lines==16)
local diner=Actor:new{id=5,player=true,cell=37000111,x=npcs[51].x+18,z=npcs[51].z}
nearbyPlayers={guest,diner};fire("kitchen");assert(#lines==17)
-- Leaving between call and reply suppresses that reply. The next scheduled
-- exchange must still run when another guest arrives.
diner.cell=0;fire("kitchen");assert(#lines==17)
guest.cell=37000119;fire("kitchen");assert(#lines==18 and lines[18][1]=="prep")
local missing=npcs[51];npcs[51]=nil
fire("kitchen");assert(#lines==18);npcs[51]=missing
guest.cell=37000121;fire("kitchen");fire("kitchen")
assert(#lines==20 and lines[19][1]=="line" and lines[20][1]=="chef")

local departed,returned,visits,homes={}, {}, {}, {}
local firstShop, lastDeparture, stale, held = false, 0, nil, false
for i=1,6 do
    departed[i],returned[i],visits[i]={},{},{}
    local r=grill.routes[i]; local home=r[#r]; local xy=home[2].."/"..home[4]
    assert(not homes[xy]);homes[xy]=true
end
now=1000
for tick=1,1800 do
    now=now+2
    local before={}
    for slot=1,6 do
        local key="MonumentGrill:"..slot..":"
        before[slot]={readData(key.."point"),readData(key.."atTable")}
        local npc=npcs[readData(key.."npc")]
        if npc.target then
            if slot==1 and not held and npc.commands==1 then
                npc.target=nil -- a dropped waypoint must be resubmitted, with no table interaction
                assert(talk(npc,"hello").id=="closed");held=true
            else npc.x,npc.height,npc.z,npc.cell=unpack(npc.target);npc.target=nil end
        end
    end
    fire("rounds")
    for slot=1,6 do
        local key="MonumentGrill:"..slot..":"
        local npc=npcs[readData(key.."npc")]
        local point,tableNo=readData(key.."point"),readData(key.."atTable")
        if point==1 and before[slot][1]==0 then
            assert(now-lastDeparture>=45);lastDeparture=now
            if #returned[slot]>0 then assert(now-returned[slot][#returned[slot]]>=300) end
            departed[slot][#departed[slot]+1]=now
        elseif point==0 and before[slot][1]~=0 then
            returned[slot][#returned[slot]+1]=now
            local r=grill.routes[slot];local home=r[#r]
            assert(npc.cell==home[1] and npc.x==home[2] and npc.z==home[4] and not npc.talk)
        end
        if tableNo>0 and before[slot][2]==0 then
            assert(npc.talk and grill.routes[slot][point][5]==tableNo)
            visits[slot][tableNo]=(visits[slot][tableNo] or 0)+1
            if not firstShop then
                shop(npc,tableNo);firstShop=true
                talk(npc,"menu");stale={npc,tableNo,#guest.inventory}
            end
        elseif tableNo==0 then assert(not npc.talk)
            if stale and npc==stale[1] then
                assert(talk(npc,"order2").id=="closed" and #guest.inventory==stale[3]);stale=nil
            end
        end
    end
    local done=true;for slot=1,6 do if #returned[slot]<2 then done=false end end
    if done then break end
end
local seen={}
for slot,r in ipairs(grill.routes) do
    assert(#departed[slot]>=2 and #returned[slot]>=2)
    for _,p in ipairs(r) do if p[5] then assert(not seen[p[5]] and visits[slot][p[5]]>=2);seen[p[5]]=slot end end
end
for i=1,40 do assert(seen[i]) end
assert(firstShop and held and not stale)
-- Spawn positions and guest positions across the nose and both long sides of the bar.
local stations={{8.6,.6,11.5,.6},{-.9,3.3,-.9,6.3},{-1.7,-2.4,-1.7,-5.35}}
assert(templates.monument_grill_bartender.indoorConversationHeight==1.5)
for i,p in ipairs(stations) do
    local bartender=Actor:new{id=200+i,cell=37000111,x=p[1],z=p[2],role="monument_grill_bartender"}
    assert((p[1]-p[3])^2+(p[2]-p[4])^2<25)
    shop(bartender,nil,p[3],p[4])
end
local oldNpc=readData("MonumentGrill:3:npc");npcs[oldNpc]=nil;fire("rounds")
assert(nextId==107 and readData("MonumentGrill:3:npc")~=oldNpc and readData("MonumentGrill:3:point")==0)
for slot in pairs(robedNames) do
    local key="MonumentGrill:"..slot..":npc"
    local replaced=readData(key)
    npcs[replaced]=nil
    fire("rounds")
    assert(readData(key)~=replaced)
    checkUniform(slot)
end
print("PASS fixed uniforms on initial spawn and replacement")
print("PASS six staggered routes, two complete rounds, 40 tables, home cooldowns, lost targets and staff replacement")
print("PASS table and bar conversations, all eight orders, stale orders and failed purchases")
print("PASS eight paired kitchen calls, guest departures, hearing range, missing speakers and timer continuity")

local hostConvo=assert(convos.monumentGrillHost)
local hostHandler=assert(_G[hostConvo.luaClassHandler])
local host=Actor:new{id=77,cell=37000109}
function Actor:getFirstName() return self.firstName end
local function hostReply(player, screen, option)
    player.session=screen and {getLastConversationScreen=function()return screen end} or nil
    local nextScreen=hostHandler:getNextConversationScreen(hostConvo,player,(option or 1)-1,host)
    return hostHandler:runScreenHandlers(hostConvo,player,host,0,nextScreen)
end
local function hostPath(player, choices)
    local screen=hostReply(player)
    assert(screen.id=="welcome" and screen.customDialogText:find("reservation",1,true))
    for _,choice in ipairs(choices) do
        assert(screen.stopConversation=="false" and screen.options[choice])
        screen=hostReply(player,screen,choice)
    end
    assert(screen.stopConversation=="true" and #screen.options==0)
    return screen.id
end
local first=Actor:new{firstName="Nera"}
local second=Actor:new{firstName="Tavi"}
local reserved=hostReply(first,hostReply(first),1)
local named=hostReply(first,reserved,1)
assert(named.text:find("Nera",1,true) and hostReply(second,reserved,1).text:find("Tavi",1,true))
assert(hostConvo:getScreen("reserved_size").text==nil)
assert(hostPath(first,{1,1,1,1})=="window_two" and hostPath(first,{1,2})=="wait")
assert(hostPath(first,{2,1,2})=="dining_room" and hostPath(first,{2,2,1})=="window_four")
assert(hostPath(first,{2,2,2})=="dining_room" and hostPath(first,{2,3,1})=="group_tables")
assert(hostPath(first,{2,3,2})=="wait" and hostPath(first,{2,4})=="wait")
assert(hostPath(first,{3,1})=="find_table" and hostPath(first,{3,2})=="wait" and hostPath(first,{4})=="bar")
print("PASS host reservations, walk-ins, party sizes, seating directions, foyer waiting and drinks")
