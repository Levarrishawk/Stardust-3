local ObjectManager = require("managers.object.object_manager")


storm_lord_region = ScreenPlay:new {
  numberOfActs = 1,

  screenplayName = "storm_lord_region"
}

registerScreenPlay("storm_lord_region", true)

function storm_lord_region:start()
  if (isZoneEnabled("mustafar")) then
    self:spawnMobiles()
    self:spawnSceneObjects()
  end
end

function storm_lord_region:spawnSceneObjects()
--Entry
--  spawnSceneObject("yavin4", "object/tangible/terminal/terminal_elysium_crystal_01.iff", -11.5, -19.3, 38.3, 8525439, math.rad(0) )
 

end

function storm_lord_region:spawnMobiles()

-- Canyon Approach Phantom Bandits near Escape Pod

  local pPhantom1 = spawnMobile("mustafar", "som_mustafarian_phantom_bandit",120,457,129.1,5771.8,127,0)
  self:setMoodString(pPhantom1, "idlewander")
  -- 2, 3 and 4 all re-set pPhantom1's mood and left their own at the template default.
  local pPhantom2 = spawnMobile("mustafar", "som_mustafarian_phantom_bandit",120,465,129.1,5796.8,127,0)
  self:setMoodString(pPhantom2, "idlewander")
  local pPhantom3 = spawnMobile("mustafar", "som_mustafarian_phantom_bandit",120,483,128.7,5771.9,127,0)
  self:setMoodString(pPhantom3, "idlewander")
  local pPhantom4 = spawnMobile("mustafar", "som_mustafarian_phantom_bandit",120,464,129.7,5719.0,127,0)
  self:setMoodString(pPhantom4, "idlewander")
  local pPhantom5 = spawnMobile("mustafar", "som_mustafarian_phantom_bandit",120,459,131.1,5692,127,0)
  self:setMoodString(pPhantom5, "idlewander")
  
-- Lone Tower on East Hill
  local pMinion1 = spawnMobile("mustafar", "storm_lord_minion",120,388.7,200.5,4347.1,143,0)
  self:setMoodString(pMinion1, "neutral")
  local pMinion2 = spawnMobile("mustafar", "storm_lord_minion",120,395.3,201.9,4352.8,165,0)
  self:setMoodString(pMinion2, "neutral")
  local pZealot1 = spawnMobile("mustafar", "storm_lord_zealot",120,379.9,217.3,4369.3,143,0)
  self:setMoodString(pZealot1, "neutral")

-- Scavenger Camp 
  local pScavenger1 = spawnMobile("mustafar", "scavenger",120,309.1,129.9,4260,9,0)
  self:setMoodString(pScavenger1, "idlewander")
  local pScavenger2 = spawnMobile("mustafar", "scavenger",120,335,129.9,4253,143,0)
  self:setMoodString(pScavenger2, "idlewander")
  local pScavenger3 = spawnMobile("mustafar", "scavenger",120,323,129.9,4206,-29,0)
  self:setMoodString(pScavenger3, "neutral")
  local pScavenger4 = spawnMobile("mustafar", "scavenger",120,277,129.9,4282,143,0)
  self:setMoodString(pScavenger4, "idlewander")
  local pScavenger5 = spawnMobile("mustafar", "scavenger",120,308,129.9,4291,143,0)
  self:setMoodString(pScavenger5, "idlewander")
  local pScavenger6 = spawnMobile("mustafar", "scavenger",120,302,129.9,4286,-110,0)
  self:setMoodString(pScavenger6, "idlewander")
  
  local pMinion3 = spawnMobile("mustafar", "storm_lord_minion",120,299,129.5,4304,23,0)
  self:setMoodString(pMinion3, "idlewander")
  local pMinion4 = spawnMobile("mustafar", "storm_lord_minion",120,307,129.9,4318,43,0)
  self:setMoodString(pMinion4, "idlewander")
  local pMinion5 = spawnMobile("mustafar", "storm_lord_minion",120,273,129.8,4314,-43,0)
  self:setMoodString(pMinion5, "idlewander") 
  local pMinion6 = spawnMobile("mustafar", "storm_lord_minion",120,272,129.9,4227,43,0)
  self:setMoodString(pMinion6, "idlewander")
  local pMinion7 = spawnMobile("mustafar", "storm_lord_minion",120,281,129.9,4331,43,0)
  self:setMoodString(pMinion7, "idlewander")
  local pMinion8 = spawnMobile("mustafar", "storm_lord_minion",120,297,129.9,4336,43,0)
  self:setMoodString(pMinion8, "idlewander")
  
-- Skar tower
-- TODO CLOSED. The point is sourced: ngecore_mustafar.md:190 gives Skar at
-- /way (3068, 1613), which through the Mustafar offset is world (188, 4589),
-- 4.45 m from must_jeditemple_watchtower at (183.96, h 176.87, 4587.14) --
-- snapshot/mustafar.ws node 12110953, unclaimed. That is a tighter anchor than
-- the 5.18 m one the Prophet ships on below, it is the same watchtower template,
-- and it sits inside the minion ring that follows -- which is what "Skar tower"
-- means. The same source's positions land on two placements this repo already
-- made from other sources: its Storm Lord Minion (156, 4574) on the centroid of
-- pMinion9-13, and its Vansk (-4412, 3159) 4.4 m from smoking_forest_region.lua:131.
-- The TODO's appearance call is kept and its template guess is not -- see the
-- header of mobile/custom_content/som/skar.lua, which records both.
-- OURS, NOT SOURCED: the heading and the 600 s respawn. 600 s is what the Storm
-- Lord himself uses at :127; Skar is ELITE, two tiers below him.
-- No height ships for this point, so the floor is resolved at spawn, as with the
-- Prophet and the zealot camp above.
  local pSkar = spawnMobile("mustafar", "skar",600,188,getWorldFloor(188,4589,"mustafar"),4589,0,0)
  self:setMoodString(pSkar, "angry")

  local pMinion9 = spawnMobile("mustafar", "storm_lord_minion",120,147,159.9,4562,43,0)
  self:setMoodString(pMinion9, "idlewander")
  local pMinion10 = spawnMobile("mustafar", "storm_lord_minion",120,135,159.8,4573,56,0)
  self:setMoodString(pMinion10, "idlewander")
  local pMinion11 = spawnMobile("mustafar", "storm_lord_minion",120,145,161.4,4592,-73,0)
  self:setMoodString(pMinion11, "idlewander")
  local pMinion12 = spawnMobile("mustafar", "storm_lord_minion",120,168,161.4,4610,56,0)
  self:setMoodString(pMinion12, "idlewander")
  local pMinion13 = spawnMobile("mustafar", "storm_lord_minion",120,186,160.3,4558,56,0)
  self:setMoodString(pMinion13, "idlewander")
  
-- Zealot Camp on the West Shelf
-- The .qst's task 3 target is som_storm_lord_touched. Nothing in the repo placed
-- it, so that leg counted 0 of 10 forever. The camp is sourced: two
-- must_smuggler_bunker at (188.21, h 207.25, 4247.13) and (165.98, h 207.25,
-- 4226.39) -- snapshot/mustafar.ws nodes 12110937 and 12110938 -- a built camp
-- the repo left empty. It is a different camp from the Scavenger Camp above,
-- which sits on the lower east bench at h ~130 (nodes 12110946/47/48).
-- The live-era wording for this leg is "found all around the ruins", and the
-- wiki gives the zealot location as literally "(area)", so this is an area
-- population, not a cluster.
-- OURS, NOT SOURCED: the count of ten, the individual positions, the headings
-- and the 120 s respawn. No shipped or live data records any of them. Ten
-- matches the kill requirement the way the thirteen static minions match theirs;
-- 120 s is the interval every other static in this file uses.
-- No height ships for these points, so the floor is resolved at spawn -- the
-- same pattern storm_lord.lua:438 uses for the quest giver.
  local pTouched1 = spawnMobile("mustafar", "storm_lord_touched",120,185.4,getWorldFloor(185.4,4243.8,"mustafar"),4243.8,143,0)
  self:setMoodString(pTouched1, "neutral")
  local pTouched2 = spawnMobile("mustafar", "storm_lord_touched",120,192.6,getWorldFloor(192.6,4250.1,"mustafar"),4250.1,-37,0)
  self:setMoodString(pTouched2, "neutral")
  local pTouched3 = spawnMobile("mustafar", "storm_lord_touched",120,183.1,getWorldFloor(183.1,4251.6,"mustafar"),4251.6,56,0)
  self:setMoodString(pTouched3, "idlewander")
  local pTouched4 = spawnMobile("mustafar", "storm_lord_touched",120,178.6,getWorldFloor(178.6,4240.2,"mustafar"),4240.2,-110,0)
  self:setMoodString(pTouched4, "neutral")
  local pTouched5 = spawnMobile("mustafar", "storm_lord_touched",120,172.3,getWorldFloor(172.3,4234.7,"mustafar"),4234.7,23,0)
  self:setMoodString(pTouched5, "idlewander")
  local pTouched6 = spawnMobile("mustafar", "storm_lord_touched",120,169.4,getWorldFloor(169.4,4229.8,"mustafar"),4229.8,165,0)
  self:setMoodString(pTouched6, "neutral")
  local pTouched7 = spawnMobile("mustafar", "storm_lord_touched",120,162.9,getWorldFloor(162.9,4222.1,"mustafar"),4222.1,-73,0)
  self:setMoodString(pTouched7, "idlewander")
  local pTouched8 = spawnMobile("mustafar", "storm_lord_touched",120,168.7,getWorldFloor(168.7,4219.4,"mustafar"),4219.4,43,0)
  self:setMoodString(pTouched8, "neutral")
  local pTouched9 = spawnMobile("mustafar", "storm_lord_touched",120,176.0,getWorldFloor(176.0,4224.9,"mustafar"),4224.9,-29,0)
  self:setMoodString(pTouched9, "idlewander")
  local pTouched10 = spawnMobile("mustafar", "storm_lord_touched",120,196.8,getWorldFloor(196.8,4241.3,"mustafar"),4241.3,147,0)
  self:setMoodString(pTouched10, "neutral")

-- Storm Lord Promentory
  local pStormlord = spawnMobile("mustafar", "storm_lord",600,194.4,266.7,4096.3,-22,0)  
  self:setMoodString(pStormlord, "angry")
  local pGuard1 = spawnMobile("mustafar", "storm_lord_guard",300,191.3,264.5,4096.3,-37,0)  
  self:setMoodString(pGuard1, "neutral")
  local pGuard2 = spawnMobile("mustafar", "storm_lord_guard",300,182.4,264.5,4112.7,-37,0)  
  self:setMoodString(pGuard2, "neutral")
  local pGuard3 = spawnMobile("mustafar", "storm_lord_guard",300,178.9,264.5,4094.2,-110,0)  
  self:setMoodString(pGuard3, "neutral")  
  local pGuard4 = spawnMobile("mustafar", "storm_lord_guard",300,196.4,264.1,4083.4,145,0)  
  self:setMoodString(pGuard4, "neutral")
  local pGuard5 = spawnMobile("mustafar", "storm_lord_guard",300,204.6,263.7,4085.8,147,0)  
  self:setMoodString(pGuard5, "neutral")

-- Prophet of the Storm Lord
-- The .qst's task 5 target is som_storm_lord_prophet, and nothing placed it, so
-- that leg was unreachable. The point is sourced: the live-era point (315, 3746)
-- is 5.2 m from must_jeditemple_watchtower at (313.49, h 171.49, 3750.96),
-- snapshot/mustafar.ws node 12110949. That watchtower is a
-- SharedStaticObjectTemplate (object/custom_content/building/mustafar/
-- structures/objects.lua:146) with no cells and no children, so cellID 0 is
-- right and there is no interior to place him in.
-- OURS, NOT SOURCED: the heading and the 1200 s respawn. The Storm Lord himself
-- is the tier above and respawns on 600 s (see his spawn above); the Prophet is
-- the tier below him and takes twice that. (This note used to cite "line 90" for
-- the Storm Lord and to call 1200 s his interval; both were wrong -- he is spawned
-- under "Storm Lord Promentory" on 600, not 1200.)
-- No height ships for this point, so the floor is resolved at spawn.
  local pProphet = spawnMobile("mustafar", "storm_lord_prophet",1200,315,getWorldFloor(315,3746,"mustafar"),3746,0,0)
  self:setMoodString(pProphet, "angry")
   
end
