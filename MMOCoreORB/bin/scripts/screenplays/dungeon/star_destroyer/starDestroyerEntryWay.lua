-- Star Destroyer entryway. Shape copied from exarKunEntryWay.lua (33 lines).
-- The ship itself is spawned by starDestroyer:start() (ig88:start() -> spawnArena()
-- shape). This screenplay only places the Corellia boarding terminal.
-- Lev's empty spawnMobiles() stub is not copied -- it is dead weight in both his files.

starDestroyerEntryWay = ScreenPlay:new {
  numberOfActs = 1,

  screenplayName = "starDestroyerEntryWay"
}

registerScreenPlay("starDestroyerEntryWay", true)

function starDestroyerEntryWay:start()
  if (isZoneEnabled("corellia")) then
    self:spawnSceneObjects()
  end
end

function starDestroyerEntryWay:spawnSceneObjects()
  -- OURS, NOT SOURCED (the exact spot). Anchored on SOE's own instance EXIT coordinate,
  -- instance_datatable.tab:6 "-137,0,-4723,corellia", so entry and exit are the same place.
  spawnSceneObject("corellia", "object/tangible/terminal/terminal_star_destroyer_entrance.iff",
                   -137, 0, -4723, 0, math.rad(0))
end
