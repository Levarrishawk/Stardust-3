--[[ malfosa_region -- open-world spawn for som_sherkar_consort (Malfosa).

     THE LIVE COORDINATE IS NOT A WORLD COORDINATE. Spawner row is
     datatables/buildout/mustafar/mustafar_main_nw.tab line 13:
       -1391  0  object/tangible/ground_spawning/area_spawner.iff
       0  3799.34  19.9804  2505.76 ...
       scripts systems.spawning.spawner_area
       objvars fltMaxSpawnTime 20000 | fltMinSpawnTime 10800 | fltRadius 200
               | intSpawnCount 1 | strName malfosa | strSpawns mustafar/malfosa

     SWG buildout rows store px/pz relative to the buildout area's minimum corner,
     and py absolute. areas_mustafar.tab gives mustafar_main_nw x1 = -6880, z1 = +2848:
       world.x = px + x1 = 3799.34 + (-6880) = -3080.66
       height  = py                          =    19.98   (absolute, never offset)
       world.y = pz + z1 = 2505.76 + 2848    =  5353.76
     Do NOT use the originX/originZ columns -- they are (-2304, 2848) for all four
     quadrants (the shared inner corner) and are a trap.

     Offset proved three ways against values this repo already measured independently
     from snapshot/mustafar.ws (mustafar_instances.lua:205-210, scratch/PLACEMENT.md:86-95):
       must_sherkar_lair_exterior  computed -2128.267 / 4356.34  measured -2128.27 / 4356.34
       must_sherkar_door           computed -2077.074 / 4276.08  measured -2077.07 / 4276.08
       ORF door exterior           computed  -775.93  / 6088.28  measured  -775.93 / 6088.28
     NW quadrant separately checked: must_jeditemple_dome lands at (-4537, 3193)
     against mustafar_regions.lua:150 blackguard_jedi_ruins, and the jedi temple
     wall cluster lands inside nw_jedi_ruins at :151.

     Respawn 10800 is SOURCED -- live fltMinSpawnTime 10800 s (3 h), fltMaxSpawnTime
     20000 s (~5.5 h). Core3 spawnMobile takes a single respawn value, so the minimum
     is used. Far longer than any other Mustafar screenplay respawn (600 is the
     highest) and deliberate -- live means this to be a rare world boss.

     Height uses getWorldFloor, not the sourced 19.98. Live is an area spawner with
     fltRadius 200 and intGoodLocationSpawner 1, so the creature does not actually
     stand at the spawner's own point or height. This port places the creature
     directly at the spawner's centre, so the terrain floor is the honest z. Sourced
     19.98 recorded here as the cross-check. Same convention as
     storm_lord_region.lua:96 (pSkar).

     intSpawnCount 1 -- one consort, not a group. malfosa.tab has exactly one row
     (som_sherkar_consort 5); its fltSize 5 is a theater radius, not a count
     (script/library/qa.java:1677-1690).

     OURS, NOT SOURCED: the heading (0). No heading is derivable -- the row's
     quaternion is the spawner object's facing, not the creature's, and the creature
     is placed by the area spawner at a runtime-chosen good location anyway.

     cellID 0 -- outdoors. The point sits in open ground; nearest region in
     mustafar_regions.lua is burning_plains_5 at (-2776, 4593) r300, about 819 m
     away, so nothing covers it and no NOSPAWNAREA is added. ]]

malfosa_region = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "malfosa_region"
}

registerScreenPlay("malfosa_region", true)

function malfosa_region:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnMobiles()
	end
end

function malfosa_region:spawnMobiles()
	local pMalfosa = spawnMobile("mustafar", "som_sherkar_consort", 10800, -3080.66, getWorldFloor(-3080.66, 5353.76, "mustafar"), 5353.76, 0, 0)

	if (pMalfosa == nil) then
		print("malfosa_region: failed to spawn som_sherkar_consort at (-3080.66, 5353.76)")
	end
end
