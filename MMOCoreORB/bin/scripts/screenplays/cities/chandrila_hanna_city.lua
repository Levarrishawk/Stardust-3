local ObjectManager = require("managers.object.object_manager")

HannaCityScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "HannaCityScreenPlay"
}

registerScreenPlay("HannaCityScreenPlay", true)

function HannaCityScreenPlay:start()
	if (isZoneEnabled("chandrila")) then
		self:spawnMobiles()
		self:spawnSceneObjects()
	end
end

function HannaCityScreenPlay:spawnSceneObjects()

	--Cantina Static Objects
	spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 27.1, -0.9, 12.0, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 27.1, -0.9, -10.9, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", -16.4, -0.9, 0.4, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 15.0, -0.9, -3.9, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 15.6, -0.9, 5.7, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", -1.2, -0.9, 11.3, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 11.8, -0.9, -10.2, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", -1.1, -0.9, -10.3, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", -11.4, -0.9, -7.6, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 34.4, 0.1, 1.6, 35791443, math.rad(0) )
  spawnSceneObject("chandrila", "object/tangible/gambling/wheel/roulette.iff", 34.4, 0.1, 1.6, 35791443, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_green_style_01_on.iff", 31.7, 0.1, -6.8, 35791443, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_red_style_02_on.iff", -16.7, -0.9, 26.4, 35791453, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_red_style_02_on.iff", -31.7, -0.9, 17.1, 35791453, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/particle/pt_sparking_blast_md.iff", 24.5, 3, 9.5, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/particle/pt_flocking_glowzees.iff", 24.5, 0, 9.5, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/tangible/painting/painting_rodian_m.iff", 27.5, 0.6, -5.8, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/item/item_scrolling_screen.iff", 9.8, 3.6, 0.1, 35791444, math.rad(0) )
  spawnSceneObject("chandrila", "object/tangible/furniture/tatooine/frn_tato_meat_rack.iff", -26, -0.9, 3.0, 35791452, math.rad(0) )
  spawnSceneObject("chandrila", "object/tangible/furniture/tatooine/frn_tato_meat_rack.iff", -26, -0.9, -2.5, 35791452, math.rad(0) )
  
 


    
-- Starport Static Objects
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", 12.2, 0.6, 50.2, 35791476, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -0.2, 0.6, 48.1, 35791476, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/general/streetlamp_small_blue_style_01_on.iff", -13.5, 0.6, 50.9, 35791476, math.rad(0) )
  
 -- spawnSceneObject("chandrila", "object/tangible/terminal/terminal_event_buffs.iff", -5.8, 0.3, 4.4, 35791495, math.rad(-45) )
  
  
  spawnSceneObject("chandrila", "object/building/corellia/garage_corellia.iff", 220, 6, -2758, 0, math.rad(0) ) 
  
  spawnSceneObject("chandrila", "object/static/structure/corellia/corl_imprv_wall_4x16_s02.iff", 336, 6, -2760, 0, math.rad(0) )
  spawnSceneObject("chandrila", "object/static/structure/corellia/corl_imprv_wall_4x16_s02.iff", 336, 6, -2737, 0, math.rad(0) )

  -- Med
 -- spawnSceneObject("chandrila", "object/tangible/terminal/terminal_event_buffs.iff", 424, 15.0, 4652, 0, 0)
  
	--Hotel
--	spawnSceneObject("corellia", "object/static/structure/general/droid_r4_powerdown.iff", 6.0, 1.0, 20.2, 2365805, math.rad(143) )

end

function HannaCityScreenPlay:spawnMobiles()

  spawnMobile("chandrila", "informant_npc_lvl_3", 1, 323, 7, 4685, 0, 0)
  

	--Outdoors
	local pNpc = spawnMobile("chandrila", "surgical_droid_21b",60,3.1,0.1,11.5,0,0)
	self:setMoodString(pNpc, "neutral")
	
  pNpc = spawnMobile("chandrila", "at_st", 60, 443, 6, -2928, 0, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("chandrila", "at_st", 60, 443, 6, -2946, 0, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("chandrila", "at_st", 60, 388, 6, -2935, 0, 0)
  self:setMoodString(pNpc, "neutral")
  --AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("chandrila", "at_st", 60, 325, 6, -2935, 0, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("chandrila", "at_st", 60, 282, 6, -2936, 0, 0)
  self:setMoodString(pNpc, "neutral")
  --AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("chandrila", "at_st", 60, 262, 6, -2918, 0, 0)
  self:setMoodString(pNpc, "neutral")
 -- AiAgent(pMobile):addCreatureFlag(AI_STATIC)
  
  pNpc = spawnMobile("chandrila", "at_st", 60, 262, 6, -2955, 0, 0)
  self:setMoodString(pNpc, "neutral")
  --AiAgent(pMobile):addCreatureFlag(AI_STATIC)

	pNpc = spawnMobile("chandrila", "commoner",60,247.0,6.0,-2898.4,20,0)
	self:setMoodString(pNpc, "conversation")
	pNpc = spawnMobile("chandrila", "commoner",60,248.5,6.0,-2896.1,-150,0)
	self:setMoodString(pNpc, "conversation")
	
	pNpc = spawnMobile("chandrila", "commoner",60,335.6,6.0,-2955.2,44,0)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "commoner",60,338.9,6.0,-2952.5,-133,0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("chandrila", "noble",60,291.7,6.0,-2936.9,-90,0)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  
  pNpc = spawnMobile("chandrila", "commoner",60,288.8,6.0,-2935.4,114,0)
  self:setMoodString(pNpc, "conversation")
  
	
	pNpc = spawnMobile("chandrila", "entertainer",60,347,6.0,-2977.9,-96,0)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "commoner",60,339.2,6.0,-2982.2,80,0)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("chandrila", "commoner",60,339.2,6.0,-2980.1,83,0)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("chandrila", "commoner",60,339.1,6.0,-2976.2,91,0)
  self:setMoodString(pNpc, "npc_sitting_chair")
  CreatureObject(pNpc):clearOptionBit(AIENABLED)
  pNpc = spawnMobile("chandrila", "commoner",60,339.2,6.0,-2974.3,94,0)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  
	
	pNpc = spawnMobile("chandrila", "stormtrooper",60,249.9,6.0,-2942.1,84,0)
  self:setMoodString(pNpc, "angry")
	pNpc = spawnMobile("chandrila", "stormtrooper",60,249.9,6.0,-2931.5,84,0)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,219.7,6.0,-3027.8,51,0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("chandrila", "imperial_pilot",60,194.9,6.0,-3026.8,-80,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "imperial_pilot",60,172.5,6.0,-3021.2,29,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "imperial_pilot",60,160.2,6.0,-3014.5,-143,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "imperial_pilot",60,141.5,6.0,-3030.8,96,0)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("chandrila", "imperial_first_lieutenant",60,145.5,6.0,-3031.7,-74,0)
  self:setMoodString(pNpc, "conversation")
	
	pNpc = spawnMobile("chandrila", "stormtrooper",60,121.9,6.0,-3100.0,-160,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,143.0,6.0,-3069.9,-91,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,187.3,6.0,-3080.6,90,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,275.0,6.0,-2883.4,-132,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,341.8,6.0,-2829.1,-105,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,442.1,6.0,-2814.6,164,0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("chandrila", "commoner",60,403.7,6.0,-2927.8,-141,0)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "commoner",60,401.1,6.0,-2930.8,34,0)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("chandrila", "stormtrooper",60,11.7,-0.9,-0.8,-69,35791444)
  self:setMoodString(pNpc, "npc_accusing")
  
  pNpc = spawnMobile("chandrila", "stormtrooper",60,663.4,6.0,-2928.1,90,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,663.4,6.0,-2945.7,90,0)
  self:setMoodString(pNpc, "neutral")
  -- Capitol
  pNpc = spawnMobile("chandrila", "noble",60,0.0,3.1,-9.5,-2,35791552)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "commoner",60,5.3,0.3,-3.9,-168,35791552)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("chandrila", "commoner",60,3.7,0.3,-2.5,-84,35791552)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("chandrila", "commoner",60,4.1,0.3,0.3,-169,35791552)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("chandrila", "commoner",60,-2.5,0.3,-0.2,-96,35791552)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("chandrila", "commoner",60,-5.3,0.3,-1.7,-126,35791552)
  self:setMoodString(pNpc, "angry")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,-0.1,3.1,22.8,177,35791551)
  self:setMoodString(pNpc, "neutral")
  
 -- spawnMobile("chandrila", "at_xt",60,711.7,6.0,-2934.5,-90,0)
  
  
  pNpc = spawnMobile("chandrila", "stormtrooper",60,668.0,6.6,-3074.0,-2,0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("chandrila", "stormtrooper",60,721,6,-3022.4,1,0)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "stormtrooper",60,721,6,-3013.6,-178,0)
  self:setMoodString(pNpc, "neutral")
  
  pNpc = spawnMobile("chandrila", "stormtrooper",60,546.4,6,-3199.7,-90,0)
  self:setMoodString(pNpc, "neutral")
  
  -- Theater
  pNpc = spawnMobile("chandrila", "noble",60,0.5,2.1,50.2,-3,35791775)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "commoner",60,-5.0,1.0,39.7,24,35791775)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "commoner",60,2.8,1.4,35.9,-9,35791775)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "commoner",60,7.0,0.7,43.3,-34,35791775)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "commoner",60,3.5,1.8,31.4,-7,35791775)
  self:setMoodString(pNpc, "neutral")
  pNpc = spawnMobile("chandrila", "commoner",60,-5.1,2.2,27.3,8,35791775)
  self:setMoodString(pNpc, "neutral")
  -- Squalls
  spawnMobile("chandrila", "squall",60,350.5,6.0,-2965.1,34,0)
  spawnMobile("chandrila", "squall",60,352.0,7.0,-2947.7,9,0)
  spawnMobile("chandrila", "squall",60,356.5,7.0,-2935.7,34,0)
  spawnMobile("chandrila", "squall",60,359.5,7.0,-2937.6,-50,0)
  spawnMobile("chandrila", "squall",60,361.7,7.0,-2934.0,34,0)
  spawnMobile("chandrila", "squall",60,363.9,7.0,-2928.2,19,0)
  spawnMobile("chandrila", "squall",60,387.6,7.0,-2884.3,-165,0)
  spawnMobile("chandrila", "squall",60,463.1,7.0,-2915.1,11,0)
  spawnMobile("chandrila", "squall",60,402.6,7.0,-3108.0,156,0)
  spawnMobile("chandrila", "squall",60,464.1,7.1,-3169.6,62,0)
  spawnMobile("chandrila", "squall",60,468.1,7.1,-3167.2,-133,0)
  spawnMobile("chandrila", "squall",60,614.6,7.0,-3065.1,146,0)
  spawnMobile("chandrila", "squall",60,532.3,7.0,-2969.3,-172,0)
  spawnMobile("chandrila", "squall",60,534.3,7.0,-2970.2,-84,0)
  spawnMobile("chandrila", "squall",60,531.4,7.0,-2897.7,166,0)
  
  -- Trainers
  spawnMobile("chandrila", "trainer_entertainer",60,-8.3,0.6,-6.7,29,35791665)
  spawnMobile("chandrila", "trainer_entertainer",60,20.8,-0.9,-18.2,-8,35791445)
  
  -- Starport
  pNpc = spawnMobile("chandrila", "bartender",60,-33.0,1.6,49.9,25,35791481)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "patron",60,-27.4,1.6,49.5,0,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,-25.8,1.6,50.9,-87,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,-27.2,1.6,52.4,-179,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("chandrila", "patron",60,-34.5,1.6,64.2,-52,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,-34.8,1.6,66.2,-139,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,-36.6,1.6,63.8,37,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,-29.2,1.6,66.2,-118,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,-27.1,1.6,65.4,-116,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,-29.7,1.6,64.2,62,35791481)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  pNpc = spawnMobile("chandrila", "patron",60,-43.5,1.6,50.1,36,35791482)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "patron",60,-41.0,1.6,52.2,-129,35791482)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("chandrila", "stormtrooper",60,-56.9,1.0,8.7,-6,35791486)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "patron",60,-56.9,1.0,10.9,179,35791486)
  self:setMoodString(pNpc, "conversation")
  
  pNpc = spawnMobile("chandrila", "patron",60,47.8,0.6,46.0,4,35791479)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,48.1,0.6,48.9,-175,35791479)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,43.4,0.6,47.4,-67,35791479)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,36.0,0.6,35.5,73,35791479)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  -- Senate Building
        -- Exterior
  pNpc = spawnMobile("chandrila", "stormtrooper",60,458.2,6.0,-2930.6,-90,0)
  self:setMoodString(pNpc, "angry") 
  pNpc = spawnMobile("chandrila", "stormtrooper",60,458.2,6.0,-2945.6,-90,0)
  self:setMoodString(pNpc, "happy")      

  

 
  
  
	-- Cantina
	
  pNpc = spawnMobile("chandrila", "bartender",60,-11.5,-0.9,2,230,35791444)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "businessman",60,10.65,-0.894992,1.91,330,35791444)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("chandrila", "businessman",60,-4.11,-0.894992,5.4,26.8951,35791444)
  self:setMoodString(pNpc, "happy")
  pNpc = spawnMobile("chandrila", "commoner",60,10.17,-0.894992,2.74,125.098,35791444)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "commoner_fat",60,2.11,-0.894992,5.4,180,35791444)
  self:setMoodString(pNpc, "npc_standing_drinking")
  
  pNpc = spawnMobile("chandrila", "commoner_fat",60,-3.2,-0.9,-10.8,65,35791444)
  self:setMoodString(pNpc, "npc_sitting_table_eating")
  pNpc = spawnMobile("chandrila", "commoner_naboo",60,3.11,0,5.4,161.005,35791444)
  self:setMoodString(pNpc, "bored")
  pNpc = spawnMobile("chandrila", "commoner_naboo",60,1.11,0,5.4,330.024,35791444)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("chandrila", "commoner_naboo",60,-3.11,0,5.4,16.6733,35791444)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("chandrila", "commoner_naboo",60,16.1,-0.9,4.1,340,35791444)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "commoner_tatooine",60,4.11,-0.894992,5.4,158.443,35791444)
  self:setMoodString(pNpc, "npc_standing_drinking")
  pNpc = spawnMobile("chandrila", "commoner_tatooine",60,1.99,-0.894992,-8.44,325.01,35791444)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "commoner_tatooine",60,1.19,-0.894992,-7.63,152.004,35791444)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "entertainer",60,9.4,0,3.9,310,35791444)
  self:setMoodString(pNpc, "conversation")
  pNpc = spawnMobile("chandrila", "noble",60,8.49,-0.894992,4.64,128.74,35791444)
  self:setMoodString(pNpc, "conversation")
  
  --
  pNpc = spawnMobile("chandrila", "patron",60,13.7,-0.9,-5.6,67,35791444)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,13.6,-0.9,-2.4,147,35791444)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,16.3,-0.9,-5.6,320,35791444)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron",60,23.5,-0.9,-8.9,51,35791444)
  self:setMoodString(pNpc, "npc_sitting_table")
  pNpc = spawnMobile("chandrila", "patron",60,26.3,-0.9,-8.8,317,35791444)
  self:setMoodString(pNpc, "npc_sitting_table_eating")
  pNpc = spawnMobile("chandrila", "patron",60,19.1,-0.9,6.1,41,35791444)
  self:setMoodString(pNpc, "entertained")
  pNpc = spawnMobile("chandrila", "patron",60,22.2,-0.9,4.3,22,35791444)
  self:setMoodString(pNpc, "entertained")
  pNpc = spawnMobile("chandrila", "patron",60,-3.1,-0.9,11.6,97,35791444)
  self:setMoodString(pNpc, "npc_sitting_table")
  
  
  pNpc = spawnMobile("chandrila", "patron",60,1.2,-0.9,11.6,269,35791444)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron_ithorian",60,14.1,-0.9,4.3,51,35791444)
  self:setMoodString(pNpc, "npc_sitting_table")
  pNpc = spawnMobile("chandrila", "patron_klaatu",60,14.4,-0.9,7.5,139,35791444)
  self:setMoodString(pNpc, "npc_sitting_chair")
  pNpc = spawnMobile("chandrila", "patron_quarren",60,17.1,-0.9,7.8,226,35791444)
  self:setMoodString(pNpc, "npc_sitting_chair")
  
  
  --
  
  -- Profession Trainers
  spawnMobile("chandrila", "trainer_armorsmith",60,3.6,1.1,-9.8,-91,35791542)
  spawnMobile("chandrila", "trainer_weaponsmith",60,-3.4,1.1,-13.3,55,35791542)
  
  spawnMobile("chandrila", "trainer_chef",60,7.5,1.1,-9.9,91,35791541)
  spawnMobile("chandrila", "trainer_tailor",60,3.6,1.1,-9.8,-91,35791542)
  
  spawnMobile("chandrila", "trainer_artisan",60,12.2,1.1,4.6,-177,35791539)
  spawnMobile("chandrila", "trainer_architect",60,9.5,1.1,0.2,75,35791539)
  
  spawnMobile("chandrila", "trainer_politician",60,-14.0,1.1,-11.1,90,35791543)
  
  spawnMobile("chandrila", "trainer_droidengineer",60,-12.5,1.1,4.7,177,35791540)
  
  spawnMobile("chandrila", "trainer_bioengineer",60,-3.4,1.1,-13.5,36,35791522)
  spawnMobile("chandrila", "trainer_creaturehandler",60,4.0,1.1,-11.6,-88,35791522)
  
  spawnMobile("chandrila", "trainer_scout",60,-8.5,1.1,-11.6,-94,35791523)
  spawnMobile("chandrila", "trainer_ranger",60,-14.1,1.1,-11.4,86,35791523)
  
  spawnMobile("chandrila", "trainer_shipwright",60,-11.6,1.1,5.1,177,35791520)
  
  spawnMobile("chandrila", "trainer_marksman",60,-0.4,1.1,-14.4,-7,35791512)
  spawnMobile("chandrila", "trainer_pistol",60,4.2,1.1,-13.7,-50,35791512)
  spawnMobile("chandrila", "trainer_carbine",60,3.3,1.1,-9.0,-90,35791512)
  spawnMobile("chandrila", "trainer_rifleman",60,-3.8,1.1,-13.2,90,35791512)
  
  spawnMobile("chandrila", "trainer_brawler",60,-8.8,1.1,-13.3,-50,35791513)
  spawnMobile("chandrila", "trainer_unarmed",60,-7.0,1.1,-11.3,-95,35791513)
  spawnMobile("chandrila", "trainer_1hsword",60,-14.6,1.1,-12.4,60,35791513)
  spawnMobile("chandrila", "trainer_2hsword",60,-14.6,1.1,-9.4,60,35791513)
  spawnMobile("chandrila", "trainer_polearm",60,-13.4,1.1,-13.8,31,35791513)
  
  spawnMobile("chandrila", "trainer_smuggler",60,-12.0,1.1,5.2,177,35791510)
  spawnMobile("chandrila", "trainer_bountyhunter",60,10.8,1.1,-11.7,0,35791511)
  spawnMobile("chandrila", "trainer_commando",60,12.5,1.1,3.7,-171,35791509)
  
  spawnMobile("chandrila", "trainer_medic",60,-17.9,0.3,11.0,171,35791495)
  spawnMobile("chandrila", "trainer_combatmedic",60,-8.9,0.3,-1.3,-157,35791495)
  spawnMobile("chandrila", "trainer_doctor",60,-26.0,0.3,-10.6,42,35791495)
  
  spawnMobile("chandrila", "trainer_imagedesigner",60,0.3,0.6,-5.5,-70,35791665)
  spawnMobile("chandrila", "trainer_musician",60,23.0,-0.9,18.1,-92,35791446)
  spawnMobile("chandrila", "trainer_dancer",60,6.0,-0.9,-4.7,-11,35791444)
  
  spawnMobile("chandrila", "trainer_squadleader",60,0.0,1.1,-13.0,-2,35791532)
	spawnMobile("chandrila", "trainer_merchant",60,-14.1,1.1,-8.7,85,35791533)
	
	

end
