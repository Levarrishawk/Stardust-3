-- Echo Base entryway. Shape copied from starDestroyerEntryWay.lua (which copies
-- exarKunEntryWay.lua). The building itself is spawned by echoBase:start().
-- This screenplay only places the two Aurilia launch terminals.

echoBaseEntryWay = ScreenPlay:new {
  numberOfActs = 1,

  screenplayName = "echoBaseEntryWay"
}

registerScreenPlay("echoBaseEntryWay", true)

function echoBaseEntryWay:start()
  if (isZoneEnabled("dathomir")) then
    self:spawnSceneObjects()
  end
end

function echoBaseEntryWay:spawnSceneObjects()
  -- SOURCED: instance_datatable.tab echo_base exit_one/exit_two = "5426,0,-4169,dathomir"
  -- and datatables/buildout/dathomir/dathomir_7_2.tab:33-34, the two Aurilia
  -- area_spawner rows heroic_echo_base_rebel_launcher / _imperial_launcher.
  -- SOE exit = SOE entry (research-echo-base.md §0.8). Imperial is offset 2 m
  -- east so both radials are clickable; the SOE pair sat in the same cell.
  spawnSceneObject("dathomir", "object/tangible/terminal/terminal_echo_base_entrance_rebel.iff",
                   5426, 0, -4169, 0, math.rad(0))
  spawnSceneObject("dathomir", "object/tangible/terminal/terminal_echo_base_entrance_imperial.iff",
                   5428, 0, -4169, 0, math.rad(0))
end
