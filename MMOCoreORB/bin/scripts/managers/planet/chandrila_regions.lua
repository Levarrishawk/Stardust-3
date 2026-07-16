-- Planet Region Definitions
-- This file has been generated with the SWGEmu World Spawner Tool.
--
-- {"regionName", xCenter, yCenter, shape and size, tier, {"spawnGroup1", ...}, maxSpawnLimit}
-- Shape and size is a table with the following format depending on the shape of the area:
--   - Circle: {1, radius}
--   - Rectangle: {2, width, height}
--   - Ring: {3, inner radius, outer radius}
-- Tier is a bit mask with the following possible values where each hexadecimal position is one possible configuration.
-- That means that it is not possible to have both a spawn area and a no spawn area in the same region, but
-- a spawn area that is also a no build zone is possible.

require("scripts.managers.spawn_manager.regions")

chandrila_regions = {
        {"aakuan_champions_cave",4339,-4281,{1,150},NOSPAWNAREA + NOBUILDZONEAREA}, -- Crystal Canyon POI badge area     
        {"aakuan_tent",2475,2303,{1,150},NOSPAWNAREA + NOBUILDZONEAREA}, -- Lake Sah'ot    
        {"animal_skull",-80,4710,{1,300},NOSPAWNAREA + NOBUILDZONEAREA}, -- Chandriltech Facility      
        {"arch_and_torches",-5018,4084,{1,1000}, NOBUILDZONEAREA}, -- Gladean State Park
        {"@chandrila_region_names:hanna", 294, -2938, {CIRCLE, 800}, CITY + NOSPAWNAREA},
        
        

 
  

  {"world_spawner",0,0,{1,-1},SPAWNAREA + WORLDSPAWNAREA,{"corellia_world","global"},2048},

}
