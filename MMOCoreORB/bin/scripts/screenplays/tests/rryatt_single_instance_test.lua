-- Standalone Lua 5.3+: native Rryatt gate identity, no overlap/fallback, and native map-frame anchors.
ScreenPlay = {new = function(self, t) return t end}
registerScreenPlay = function() end
local data, objects, spawns, destroyed = {}, {}, 0, 0
SceneObject = function(o) return o end
readData = function(k) return data[k] or 0 end
writeData = function(k,v) data[k] = v end
writeStringData = function() end
getSceneObject = function(id) return objects[id] end
local function object(id, zone, template)
 local o = {id=id, zone=zone, template=template}
 function o:getObjectID() return self.id end
 function o:getZoneName() return self.zone end
 function o:getParentID() return 0 end
 function o:getTemplateObjectPath() return self.template end
 function o:setObjectName() end
 function o:setObjectMenuComponent(c) self.component=c end
 function o:destroyObjectFromWorld() objects[self.id]=nil; destroyed=destroyed+1 end
 objects[id]=o
 return o
end
spawnSceneObject = function(zone, template)
 spawns=spawns+1
 return object(1000+spawns,zone,template)
end
dofile("MMOCoreORB/bin/scripts/screenplays/kashyyyk/kashyyyk_zone_transitions.lua")
local gates=KashyyykZoneTransitions
local rryatt
for _, g in ipairs(gates.gates) do if g.line == "rryatt_kachirho" then rryatt=g end end
assert(rryatt and rryatt.buildoutID == -141018963347066332)
assert(math.type(rryatt.buildoutID) == "integer", "Buildout ID lost 64-bit precision")
local key="KashyyykZoneTransitions:gate:rryatt_kachirho"
-- Missing native data must never silently spawn a duplicate interactive door.
gates:setupGate(rryatt)
assert(spawns==0 and data[key]==nil)
local native=object(rryatt.buildoutID,rryatt.zone,gates.gateTemplate)
local old=object(77,rryatt.zone,gates.gateTemplate)
data[key]=old.id
gates:setupGate(rryatt)
assert(objects[77]==nil and destroyed==1 and spawns==0)
assert(data[key]==native.id and native.component=="KashyyykZoneGateMenuComponent")
gates:setupGate(rryatt)
assert(destroyed==1 and spawns==0, "Native gate setup was not idempotent")
-- Other worlds retain their normal screenplay gate creation.
gates:setupGate(gates.gates[1]); assert(spawns==1)
assert(math.abs(rryatt.y-3362.17)<.001)
local arrival=gates.destinations.kachirho_rryatt
assert(arrival.x==-3817.315 and arrival.z==171.735 and arrival.y==3361.33)

package.loaded["scripts.managers.planet.regions"]=true
CIRCLE,RECTANGLE,SPAWNAREA,NOBUILDZONEAREA=1,2,3,4
dofile("MMOCoreORB/bin/scripts/managers/planet/kashyyyk_rryatt_trail_regions.lua")
local regions={}
for _, r in ipairs(kashyyyk_rryatt_trail_regions) do regions[r[1]]=r end
assert(#kashyyyk_rryatt_trail_regions==4)
for _, r in ipairs(kashyyyk_rryatt_trail_regions) do assert(r[5]==NOBUILDZONEAREA) end
dofile("MMOCoreORB/bin/scripts/screenplays/kashyyyk/kashyyyk_rryatt_population_data.lua")
local controllers={}
for _, c in ipairs(KashyyykRryattPopulationData.controllers) do controllers[c.id]=c end
assert(controllers["kashyyyk_rryatt_trail_lvl_4:4"].x==-3503.619)
assert(controllers["kashyyyk_rryatt_trail_lvl_1_and_2:34"].y==4454.01)
dofile("MMOCoreORB/bin/scripts/screenplays/kashyyyk/kashyyyk_patrol_paths.lua")
local trails=0
for _, route in ipairs(KashyyykPatrolPaths) do
 if route.spawnZone=="kashyyyk_rryatt_trail" then
  trails=trails+1
 end
end
assert(trails==0, "Rryatt patrols must have exactly one owner")
assert(#KashyyykRryattPopulationData.patrols==2)
print("PASS: native 64-bit Rryatt gate binding, overlap retirement, no missing-data fallback, repeated setup, unchanged other-zone gate creation, region/patrol anchors")
