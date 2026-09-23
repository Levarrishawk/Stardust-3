-- Tusken Army Instanced Dungeon (Mos Espa), in the shape of Levarris' Exar Kun and
-- Axkva Min instances, authored from SOE the way H(ig) authored IG-88.
-- Lev never built this one: neither SD1 nor SD3 has any tuskenArmy file under screenplays/.
-- The SHAPE below is his (screenplays/dungeon/exar_kun/exarKun.lua, H(ek) 2c76b9049a, and
-- H(ig) ig88.lua); the ENCOUNTER is SOE's (script/theme_park/heroic/tusken/*.java,
-- datatables/spawning/heroic/heroic_tusken_army.tab + tusken/*.tab); the BALANCE is
-- Stardust's. Every authored value is marked OURS, NOT SOURCED at the line that carries it.
--
-- Origin is a screenplay constant, not a spawned controller building: SOE's
-- tusken_army_controller.iff is a re-skinned Axkva Min lair POB (PART 2.2), and spawning
-- it would put a walkable cave in the middle of Mos Espa. OURS, NOT SOURCED.
-- Zone tatooine, off-map (-6800, 0, -6800) -- D1, H(ig) lok (-6000,0,6000) precedent.
-- Every building/spawn coordinate = origin + the tab delta (PART 2.3).
--
-- getTerrainHeight IS registered (DirectorManager.cpp:520, impl :4142) but the Lua
-- binding requires a CreatureObject already in the zone (creature, x, y). start() has
-- no creature, so every outdoor spawn uses originY = 0. The boot probe / in-client
-- reading (SC8) is what supplies the real height.
--
-- NOT SPAWNED this round (D9): the 15 scenery buildings (10 lockout + 5 unscripted).
-- lockout: rescuenorth, rescuesouth, commerce, slumsouth, slumsoutheast, slumnorth1-4,
-- outskirt2. unscripted: spwest, spsouth, speast, bank, outskirt1.
-- Commerce Hall is dead in SOE (PART 1.6) and is also in that 15.
--
-- Daily lockout (instance_datatable lockoutTimer = daily): recorded, not built.
-- Same call as H(ek) Part 12, H(am), H(ig).
-- key_required = heroic_tusken_army: replaced by occupiedState (PART 7 / 1.8).
-- cantina.java co-mount: empty class, not ported (PART 1.6).
--
-- D3: phase 2 without conversations. The rescued NPC follows the rescuing player
-- (AiAgent:setFollowObject) and is delivered by an ENTEREDAREA active area at each
-- unstaffed building -- Lev's active-area shape (exarKun.lua:307-335). Replaces
-- tusken_expert.java:44-91 (seven doPathAction destinations). Commerce dropped
-- (dead). OURS, NOT SOURCED.
--
-- D4: King's shared health (ai_lib.establishSharedHealth, tusken_king.java:26-57)
-- has no Core3 analogue -- not ported. Recorded on heroic_tusken_king.lua the way
-- the droideka shield was recorded for IG-88. The King carries RAID 200; adds fight
-- normally.
--
-- D5: SOE typo creature names heroic_tusken_citizen / heroic_tusken_mos_eisley_expect
-- map to heroic_tusken_mos_espa_citizen / _mos_espa_expert at the spawn sites.
--
-- D6: loot deferred. Token only.
-- D7: 7200 s. Lev's @dungeon/corvette:timer_N keys exist only for N <= 59, so the
-- ladder starts at 59 minutes. Start message is OURS text saying 120 minutes.
-- D8: token only. No badge (none ever existed). collection heroic_tusken_king_01 waits.
-- D10: vehicle_allowed = 1 -- mount guard dropped at entry. EXITEDBUILDING does not
-- apply outdoors; an EXITEDAREA bubble (500 m around town center) plus the 7200 s
-- timer reset the instance.
--
-- Lost, recorded not faked: Macy's queueCommand CRC, tusken_unity / tusken_bane /
-- apply_criticial_heal_buff, king's three abilities, kav_tusken_killer, wolf_5.

local ObjectManager = require("managers.object.object_manager")

tuskenArmy = ScreenPlay:new {
  -- Origin. OURS, NOT SOURCED (D1). Tab deltas SOURCED (SOE, heroic_tusken_army.tab:3-28).
  originX = -6800,
  originY = 0,
  originZ = -6800,
}

registerScreenPlay("tuskenArmy", true)

-- 11 sequenced buildings. SOURCED (SOE, heroic_tusken_army.tab:3-28). Yaw degrees.
-- firstCell is the first named cell that table uses (boot probe, PART 2.5 / 0.4).
tuskenArmy.buildings = {
  { id = "cantina",    template = "object/building/heroic/tusken_tatooine_cantina.iff",          x = -53.69, z = -35.83,  yaw = 73.13,  firstCell = "foyer1" },
  { id = "starport",   template = "object/building/heroic/tusken_tatooine_starport.iff",         x = 118.74, z = -128.40, yaw = -57.30, firstCell = "foyer1" },
  { id = "university", template = "object/building/heroic/tusken_tatooine_university.iff",       x = -110.28, z = -146.58, yaw = -15.95, firstCell = "foyer" },
  { id = "hotel",      template = "object/building/heroic/tusken_tatooine_hotel.iff",            x = -137.46, z = 5.21,    yaw = 164.05, firstCell = "r2" },
  { id = "hospital",   template = "object/building/heroic/tusken_tatooine_medical_center.iff",   x = -196.96, z = -102.24, yaw = -15.47, firstCell = "entryb" },
  { id = "rescuewest", template = "object/building/heroic/tusken_tatooine_house_large.iff",      x = -61.70, z = -247.50, yaw = 74.58,  firstCell = "bedroom2" },
  { id = "medium",     template = "object/building/heroic/tusken_tatooine_house_medium.iff",     x = 59.42,  z = 72.21,   yaw = 85.37,  firstCell = "bedroom4" },
  { id = "cloning",    template = "object/building/heroic/tusken_tatooine_cloning_center.iff",   x = -151.62, z = 81.61,   yaw = 164.43, firstCell = "insurance" },
  { id = "combat",     template = "object/building/heroic/tusken_tatooine_combat_guild.iff",     x = -67.28, z = 215.06,  yaw = 77.53,  firstCell = "foyer" },
  { id = "watto",      template = "object/building/heroic/tusken_tatooine_watto_shop.iff",       x = 51.36,  z = 216.77,  yaw = -33.80, firstCell = "r2" },
  { id = "slumsouth1", template = "object/building/heroic/tusken_tatooine_house_small.iff",      x = 71.62,  z = 171.39,  yaw = 1.90,   firstCell = "livingroom1" },
}

-- Garrison interiors. {template, x, y, z, yaw, cell}. Empty cell = outdoor, relative to the building.
-- SOURCED (SOE, tusken/<name>.tab). Cantina spawns at boot; the other seven wait for capture.
tuskenArmy.garrison = {
  cantina = {
    { "heroic_tusken_raider", 19, -1, 6, 113, "cantina" },
    { "heroic_tusken_raider", 19, -1, 76, 149, "cantina" },
    { "heroic_tusken_raider", -8.5, -1, -14.3, -87, "cantina" },
    { "heroic_tusken_raider", -9.3, -1, -8, -120, "cantina" },
    { "heroic_tusken_sniper", 12, -1, 2.5, 108, "cantina" },
    { "heroic_tusken_savage", -11, -1, 13, 114, "cantina" },
    { "heroic_tusken_savage", -27, -1, 22, 117, "private_room" },
    { "heroic_tusken_savage", -19, -1, 23, 172, "private_room" },
    { "heroic_tusken_raid_leader", 11.6, -1, -2.2, 66, "cantina" },
    { "heroic_tusken_raider", 5, 0, -56, 0, "" },
    { "heroic_tusken_savage", -36, 0, 61, 114, "" },
  },
  starport = {
    { "heroic_tusken_sniper", -7.8, 0.6, 73.93, 59, "foyer1" },
    { "heroic_tusken_raid_leader", 0, 0.6, 74.59, 0, "foyer1" },
    { "heroic_tusken_sniper", 6.7, 0.6, 74.43, -68.3, "foyer1" },
    { "heroic_tusken_massiff", 14.1, 0.6, 67.68, 0, "foyer4" },
    { "heroic_tusken_raider", -4.4, 0.6, 56.84, -37, "foyer4" },
    { "heroic_tusken_raider", 3.5, 0.6, 56.85, 42, "foyer4" },
    { "heroic_tusken_pack_master", 0.36, 0.6, 63.15, 176, "foyer4" },
    { "heroic_tusken_savage", 53.15, 0.97, 10.64, 0, "arrivals3" },
    { "heroic_tusken_sniper", 34.35, 0.63, 60.19, -76, "foyer6" },
    { "heroic_tusken_pack_master", 46.93, 0.6, 46.57, -90, "arrivals1" },
    { "heroic_tusken_massiff", 46.57, 0.63, 48.32, -90, "arrivals1" },
    { "heroic_tusken_pack_master", 40.5, 0.63, 39.63, -3, "arrivals1" },
    { "heroic_tusken_massiff", 38.23, 0.63, 40.51, 8, "arrivals1" },
    { "heroic_tusken_sniper", 49.56, 0.97, 23.25, 0, "arrivals2" },
    { "heroic_tusken_raider", -28.84, 1.6, 64.57, 108, "ticket2" },
    { "heroic_tusken_raider", -27.97, 1.6, 57.18, 70.45, "ticket2" },
    { "heroic_tusken_raid_leader", -36.29, 1.6, 62.45, 94, "ticket2" },
    { "heroic_tusken_sniper", -36.51, 1.6, 57.19, 79.93, "ticket2" },
    { "heroic_tusken_savage", -59.54, 2.6, 40, 100, "departures1" },
    { "heroic_tusken_raider", -49.3, 2.6, 41.59, 0, "departures1" },
    { "heroic_tusken_savage", -44.21, 0.97, 6.8, -69, "departures4" },
    { "heroic_tusken_savage", -44.59, 0.97, 11.89, -98, "departures4" },
    { "heroic_tusken_sniper", -56.37, 0.97, 9.6, 1.9, "departures2" },
    { "heroic_tusken_raider", -46.87, 2.6, 31.72, -17.96, "departures1" },
  },
  university = {
    { "heroic_tusken_massiff", -12.58, 2.5, 14, 0, "foyer" },
    { "heroic_tusken_pack_master", 0, 2.5, 11.5, 0, "foyer" },
    { "heroic_tusken_raider", 2.4, 2.4, 5.1, 41.5, "mainroom" },
    { "heroic_tusken_raider", -2.2, 2.5, 5.6, -42, "mainroom" },
    { "heroic_tusken_raid_leader", 0, 1.1, -12.7, 0, "meetingd" },
    { "heroic_tusken_savage", 2.6, 1.1, -10.66, -58.5, "meetingd" },
    { "heroic_tusken_sniper", -14.6, 1.1, -5, 91, "mainroom" },
    { "heroic_tusken_raider", 7.9, 1.1, -12.7, 33, "meetingc" },
    { "heroic_tusken_raider", 13.06, 1.1, -12.1, -23, "meetingc" },
    { "heroic_tusken_savage", 12, 1.1, 2.56, -178, "meetinga" },
  },
  -- Hotel dressing rows hotel.tab:48-57 name heroic_tusken_citizen (absent from creatures.tab);
  -- D5 maps that typo to heroic_tusken_mos_espa_citizen. Those rows are phase-2 visuals
  -- fired by citizen1..citizen10, not the garrison, and are not spawned here -- staffing
  -- is the follow-and-deliver count (D3).
  hotel = {
    { "heroic_tusken_savage", 3.1, 1, 19.78, -26, "r2" },
    { "heroic_tusken_savage", -2.4, 1, 19.78, 20, "r2" },
    { "heroic_tusken_massiff", 6.5, 1, 9.4, 0, "r4" },
    { "heroic_tusken_massiff", -17.2, 1, -3.4, 0, "r6" },
    { "heroic_tusken_sniper", 0, 1, 0, 0, "r4" },
    { "heroic_tusken_raider", 3, 1, 0, -20, "r4" },
    { "heroic_tusken_raider", -3, 1, 0, 20, "r4" },
    { "heroic_tusken_sniper", -23, 1.5, -1.7, 90, "r6" },
    { "heroic_tusken_sniper", -18, 1.6, 10.8, 138, "r6" },
    { "heroic_tusken_savage", -14.4, 1, -4.4, 0, "r6" },
    { "heroic_tusken_raid_leader", 23.8, 2, -15.9, -40, "r5" },
    { "heroic_tusken_raider", 16.6, 1.2, -11.8, 118.9, "r5" },
    { "heroic_tusken_raider", 22.9, 1.2, -8.24, 178.99, "r5" },
    { "heroic_tusken_savage", 25, 1.2, 9.8, 0, "r5" },
  },
  hospital = {
    { "heroic_tusken_massiff", 6.9, 0, -24.98, 0, "" },
    { "heroic_tusken_massiff", 13.2, 0.1, -14, 0, "entryb" },
    { "heroic_tusken_raid_leader", 2.19, 0, -0.89, 0, "mainroom" },
    { "heroic_tusken_savage", 4.929, 0, 9.22, 179, "mainroom" },
    { "heroic_tusken_savage", -2.88, 0, 9.9, -90, "mainroom" },
    { "heroic_tusken_sniper", -16.19, 0, -5.6, 91, "mainroom" },
    { "heroic_tusken_pack_master", -0.35, 0, -9.1, 2.36, "mainroom" },
    { "heroic_tusken_sniper", 15.79, 0, -2.7, -91, "mainroom" },
  },
  cloning = {
    { "heroic_tusken_savage", 6, 0, -6.1, -140, "insurance" },
    { "heroic_tusken_raider", -2, 0, -3, 80, "insurance" },
    { "heroic_tusken_raider", -2.3, 0, 2.2, 74, "insurance" },
    { "heroic_tusken_raid_leader", 3.2, 0, 4.98, -138, "insurance" },
    { "heroic_tusken_massiff", 1.4, 0, 9.9, 0, "insurance" },
    { "heroic_tusken_pack_master", 1.4, 0, 9.9, 0, "insurance" },
    { "heroic_tusken_savage", -8.4, -5.5, -13.9, 23, "spawn" },
    { "heroic_tusken_sniper", -2.2, -55.5, -14.2, -36, "spawn" }, -- SOE cloning.tab:18 loc_y=-55.5 transcribed
    { "heroic_tusken_sniper", 3.8, -5.5, -11.9, -86, "spawn" },
    { "heroic_tusken_savage", 2.2, -5.5, -3.9, -117, "spawn" },
  },
  combat = {
    { "heroic_tusken_savage", 21, 2.5, 0.11, 76, "" },
    { "heroic_tusken_savage", 19, 2.5, 8.9, 76, "" },
    { "heroic_tusken_raid_leader", 0.2, 2.5, 13.99, 0, "foyer" },
    { "heroic_tusken_sniper", 12, 1.41, 1.3, -180, "meetinga" },
    { "heroic_tusken_savage", 10.8, 1.1, -10.1, 0, "meetingc" },
    { "heroic_tusken_raider", -0.1, 1.1, -13.3, -179, "meetingd" },
    { "heroic_tusken_raider", 3.1, 1.1, -10.35, 22.75, "meetingd" },
    { "heroic_tusken_pack_master", -12, 1.1, 2.2, 178, "meetingb" },
    { "heroic_tusken_savage", -10.8, 1.1, -12.4, 0, "meetinge" },
    { "heroic_tusken_massiff", -12, 1.1, 2.2, 178, "meetingb" },
  },
  watto = {
    { "heroic_tusken_raid_leader", 5.3, -5, 3.1, -125, "r2" },
    { "heroic_tusken_raider", 3.6, 0, -10.8, -17, "r2" },
    { "heroic_tusken_raider", -0.2, 0, 2.6, -113, "r2" },
    { "heroic_tusken_pack_master", -2.4, -0.5, 0, 0, "r2" },
    { "heroic_tusken_massiff", -9, 0, 8.2, 0, "r1" },
    { "heroic_tusken_massiff", -7.8, 0, -9, 0, "r3" },
  },
}

-- Outdoor default-trigger creatures. SOURCED (SOE, heroic_tusken_army.tab). World = origin + delta.
tuskenArmy.outdoorDefault = {
  { "heroic_tusken_pack_master", 84, 0, 114, 0 },
  { "heroic_tusken_massiff", 84, 0, 114, 0 },
  { "heroic_tusken_massiff", 84, 0, 114, 0 },
  { "heroic_tusken_raider", 216, 0, 130, 0 },
  { "heroic_tusken_pack_master", 105, 0, 390, 0 },
  { "heroic_tusken_bantha", 25, 0, 408, 0 },
  { "heroic_tusken_massiff", -48, 0, 370, 0 },
  { "heroic_tusken_raider", -108, 0, 322, 0 },
  { "heroic_tusken_pack_master", -140, 0, 256, 0 },
  { "heroic_tusken_massiff", -119, 0, 173, 0 },
  { "heroic_tusken_bantha", -250, 0, 121, 0 },
  { "heroic_tusken_raider", -260, 0, -162, 0 },
  { "heroic_tusken_pack_master", -172, 0, -182, 0 },
  { "heroic_tusken_massiff", -93, 0, -330, 0 },
  { "heroic_tusken_bantha", -40, 0, -326, 0 },
  { "heroic_tusken_raider", 49, 0, -370, 0 },
  { "heroic_tusken_pack_master", 175, 0, -378, 0 },
  { "heroic_tusken_massiff", 286, 0, -158, 0 },
  { "heroic_tusken_bantha", 224, 0, -29, 0 },
  { "heroic_tusken_raider", 2, 0, -221, 0 },
  { "heroic_tusken_pack_master", 9, 0, -235, 0 },
  { "heroic_tusken_massiff", 61, 0, -243, 0 },
  { "heroic_tusken_bantha", 190, 0, -192, 0 },
  { "heroic_tusken_savage", 189, 0, -200, 0 },
  { "heroic_tusken_sniper", 190, 0, -184, 0 },
  { "heroic_tusken_raid_leader", 205, 0, -194, 0 },
  { "heroic_tusken_raider", 220, 0, -139, 0 },
  { "heroic_tusken_pack_master", 161, 0, -13, 0 },
  { "heroic_tusken_massiff", 19, 0, -123, 0 },
  { "heroic_tusken_sniper", 127, 0, -194, 0 },
}

-- Proximity-triggered outdoor packs. Radius SOURCED from trigger:<name>:player:<r>:...
tuskenArmy.proxPacks = {
  { name = "tusken_start_reinforcement", x = 247, z = 45, r = 15, mobs = {
      { "heroic_tusken_raider", 247, 0, 15, 0 },
      { "heroic_tusken_raider", 247, 0, 15, 0 },
      { "heroic_tusken_raider", 233, 0, 67.9, 0 },
      { "heroic_tusken_raider", 233, 0, 67.9, 0 },
    } },
  { name = "mid_town_reinforcement", x = 69, z = -5, r = 30, mobs = {
      { "heroic_tusken_savage", 69, 0, -5, 0 },
      { "heroic_tusken_raider", 129, 0, 24, 0 },
      { "heroic_tusken_savage", 133, 0, 72, 0 },
      { "heroic_tusken_raider", 89, 0, 82, 0 },
    } },
  { name = "nearCantina", x = -12, z = 12, r = 30, mobs = {
      { "heroic_tusken_raider", -41, 0, 37, 0 },
      { "heroic_tusken_pack_master", -3, 0, 49, 0 },
      { "heroic_tusken_massiff", -4, 0, 26, 0 },
      { "heroic_tusken_massiff", 4, 0, -20, 0 },
    } },
  { name = "northri", x = 24, z = 254, r = 30, mobs = {
      { "heroic_tusken_raider", 33, 0, 250, 0 },
      { "heroic_tusken_pack_master", 44, 0, 279, 0 },
      { "heroic_tusken_massiff", 22, 0, 275, 0 },
      { "heroic_tusken_massiff", 0, 0, 245, 0 },
    } },
  { name = "wcan", x = -123, z = -31, r = 30, mobs = {
      { "heroic_tusken_raid_leader", -126, 0, -96, 0 },
      { "heroic_tusken_savage", -106, 0, -82, 0 },
      { "heroic_tusken_bantha", -118, 0, -52, 0 },
    } },
  { name = "swr", x = -83, z = -194, r = 30, mobs = {
      { "heroic_tusken_savage", -95, 0, -198, 0 },
      { "heroic_tusken_sniper", -90, 0, -171, 0 },
      { "heroic_tusken_raid_leader", -57, 0, -157, 0 },
    } },
}

tuskenArmy.p1Squads = {
  { delay = 600, mobs = {
      { "heroic_tusken_warlord", 150, 0, -327, 0 },
      { "heroic_tusken_berserker", 154, 0, -334, 0 },
      { "heroic_tusken_berserker", 157, 0, -339, 0 },
      { "heroic_tusken_berserker", 159, 0, -342, 0 },
      { "heroic_tusken_berserker", 162, 0, -347, 0 },
    } },
  { delay = 780, mobs = {
      { "heroic_tusken_warlord", -123, 0, -303, 0 },
      { "heroic_tusken_berserker", -126, 0, -308, 0 },
      { "heroic_tusken_berserker", -128, 0, -313, 0 },
      { "heroic_tusken_berserker", -131, 0, -319, 0 },
      { "heroic_tusken_berserker", -133, 0, -324, 0 },
    } },
  { delay = 960, mobs = {
      { "heroic_tusken_warlord", -252, 0, 76, 0 },
      { "heroic_tusken_berserker", -258, 0, 77, 0 },
      { "heroic_tusken_berserker", -264, 0, 78, 0 },
      { "heroic_tusken_berserker", -269, 0, 79, 0 },
      { "heroic_tusken_berserker", -274, 0, 80, 0 },
    } },
  { delay = 1140, mobs = {
      { "heroic_tusken_warlord", -130, 0, 287, 0 },
      { "heroic_tusken_berserker", -134, 0, 289, 0 },
      { "heroic_tusken_berserker", -139, 0, 292, 0 },
      { "heroic_tusken_berserker", -145, 0, 295, 0 },
      { "heroic_tusken_berserker", -149, 0, 298, 0 },
    } },
}

-- Cantina assassin waves. SOURCED (SOE, cantina.tab:51-70). Outdoor relative to cantina.
-- L60 loc_z is "75.8." in the file; trailing period stripped to 75.8.
tuskenArmy.hunterWaves = {
  { delay = 60, mobs = {
      { "heroic_tusken_champion", 60, 0, -74, 0 },
      { "heroic_tusken_warrior", 64, 0, -77, 0 },
      { "heroic_tusken_warrior", 68, 0, -79, 0 },
      { "heroic_tusken_warrior", 74, 0, -82, 0 },
      { "heroic_tusken_warrior", 79, 0, -84, 0 },
    } },
  { delay = 180, mobs = {
      { "heroic_tusken_champion", -55, 0, 68, 0 },
      { "heroic_tusken_warrior", -57.9, 0, 71.5, 0 },
      { "heroic_tusken_warrior", -59.39, 0, 77.95, 0 },
      { "heroic_tusken_warrior", -59.39, 0, 82.72, 0 },
      { "heroic_tusken_warrior", -66.97, 0, 75.8, 0 },
    } },
  { delay = 360, mobs = {
      { "heroic_tusken_champion", -28.96, 0, -48.3, 0 },
      { "heroic_tusken_warrior", -33.5, 0, -47, 0 },
      { "heroic_tusken_warrior", -38.43, 0, -46.8, 0 },
      { "heroic_tusken_warrior", -43.5, 0, -46.07, 0 },
      { "heroic_tusken_warrior", -51, 0, -44.9, 0 },
    } },
  { delay = 540, mobs = {
      { "heroic_tusken_champion", 15.29, 0, 62, 0 },
      { "heroic_tusken_warrior", 20.2, 0, 62.35, 0 },
      { "heroic_tusken_warrior", 25.78, 0, 62.6, 0 },
      { "heroic_tusken_warrior", 32, 0, 62.88, 0 },
      { "heroic_tusken_warrior", 38, 0, 63.15, 0 },
    } },
}

tuskenArmy.staffBuildings = { "starport", "university", "hospital", "watto", "cloning", "combat" }
tuskenArmy.p1Buildings = { "starport", "university", "hotel", "hospital", "watto", "cloning", "combat" }

tuskenArmy.clearedKey = {
  cantina = "heroic_tusken_cantina_cleared",
  starport = "heroic_tusken_starport_cleared",
  university = "heroic_tusken_university_cleared",
  hotel = "heroic_tusken_hotel_cleared",
  hospital = "heroic_tusken_medical_cleared",
  cloning = "heroic_tusken_cloning_cleared",
  combat = "heroic_tusken_combat_cleared",
  watto = "heroic_tusken_watto_cleared",
}
tuskenArmy.takenKey = {
  cantina = "heroic_tusken_kav_taken_cantina",
  starport = "heroic_tusken_kav_taken_starport",
  university = "heroic_tusken_kav_taken_university",
  hotel = "heroic_tusken_kav_taken_hotel",
  hospital = "heroic_tusken_kav_taken_medical",
  cloning = "heroic_tusken_kav_taken_cloning",
  combat = "heroic_tusken_kav_taken_combat",
  watto = "heroic_tusken_kav_taken_watto",
}
tuskenArmy.expertKey = {
  starport = { "heroic_tusken_starport_expert_one", "heroic_tusken_starport_expert_two", "heroic_tusken_starport_expert_three" },
  university = { "heroic_tusken_university_expert_one", "heroic_tusken_university_expert_two", "heroic_tusken_university_expert_three" },
  hospital = { "heroic_tusken_medical_expert_one", "heroic_tusken_medical_expert_two", "heroic_tusken_medical_expert_three" },
  cloning = { "heroic_tusken_cloning_expert_one", "heroic_tusken_cloning_expert_two", "heroic_tusken_cloning_expert_three" },
  combat = { "heroic_tusken_combat_expert_one", "heroic_tusken_combat_expert_two", "heroic_tusken_combat_expert_three" },
  watto = { "heroic_tusken_watto_expert_one", "heroic_tusken_watto_expert_two", "heroic_tusken_watto_expert_three" },
}

-- Rescue houses. SOURCED (SOE, medium_rescue.tab / rescue_west.tab / slum_south1.tab).
-- randomTrigger:citizenN,expertN,expertN = 1-in-3 citizen, 2-in-3 expert.
tuskenArmy.rescues = {
  { id = "medium", bark = "heroic_tusken_kav_rescue_medium", slots = {
      { x = -7.6, y = -9.5, z = 7, yaw = -179, cell = "bedroom4" },
      { x = 7.6, y = -9.54, z = 0.8, yaw = -88, cell = "bedroom5" },
      { x = -10.92, y = -9.9, z = -8.67, yaw = -5, cell = "kitchen1" },
    }, hunters = {
      { 5.2, 0, -17, -50 }, { 3.4, 0, -21, -57 }, { 6.73, 0, -29, -21 },
      { 8.269, 0, -32.4, -16 }, { 19.43, 0, -38, 50 }, { 23.5, 0, -41.25, 63 },
    } },
  { id = "rescuewest", bark = "heroic_tusken_kav_rescue_south", slots = {
      { x = 10, y = 10.4, z = -8.9, yaw = -105, cell = "" },
      { x = 8.8, y = 10.51, z = -4, yaw = -156, cell = "" },
      { x = -10.65, y = 10.5, z = -0.71, yaw = 128, cell = "" },
      { x = 6.7, y = 6.25, z = -8.4, yaw = -90, cell = "bedroom2" },
      { x = -6.4, y = 6.2, z = -8.5, yaw = 89, cell = "bedroom1" },
    }, hunters = {
      { 15.17, 0, 13.57, 0 }, { 16.48, 0, 16.1, 0 }, { 27.07, 0, 22.58, 0 }, { 31.83, 0, 24.1, 0 },
      { 43.65, 0, 30.76, 0 }, { 48.17, 0, 32.31, 0 }, { 59.28, 0, 36.38, 0 }, { 64.48, 0, 38.99, 0 },
    } },
  { id = "slumsouth1", bark = "heroic_tusken_kav_rescue_slum_south", slots = {
      { x = 3.3, y = -0.7, z = -4.91, yaw = -61, cell = "livingroom1" },
      { x = -4.4, y = -0.7, z = -4.3, yaw = 6.7, cell = "livingroom1" },
      { x = 4.83, y = 0.25, z = 3.6, yaw = -68, cell = "foyer1" },
    }, hunters = {
      { 9.74, 0, 12.32, 0 }, { 12.77, 0, 13.769, 0 }, { 21.5, 0, 19.46, 0 }, { 29.15, 0, 17.47, 0 },
    } },
}

function tuskenArmy:start()
  if (isZoneEnabled("tatooine")) then
    self:spawnTown()
    writeData("tuskenArmy:occupiedState", 0)
    writeData("tuskenArmy:encounterState", 0)
    self:destroyArenaContents()
    self:clearEncounterKeys()
    self:spawnPhaseZero()
  end
end

function tuskenArmy:spawnTown()
  local existing = getSceneObject(readData("tuskenArmy:bld:cantina"))
  if (existing ~= nil) then
    return
  end
  for i = 1, #self.buildings do
    local b = self.buildings[i]
    local pB = spawnSceneObject("tatooine", b.template, self.originX + b.x, self.originY, self.originZ + b.z, 0, math.rad(b.yaw))
    if (pB == nil) then
      printLuaError("tuskenArmy: unable to spawn building " .. b.id)
    else
      writeData("tuskenArmy:bld:" .. b.id, SceneObject(pB):getObjectID())
    end
  end
  self:bootProbe()
end

function tuskenArmy:bootProbe()
  -- PART 2.5: for each spawned POB assert getTotalCellNumber() > 0 and getNamedCell(firstCell) non-nil.
  for i = 1, #self.buildings do
    local b = self.buildings[i]
    local pB = getSceneObject(readData("tuskenArmy:bld:" .. b.id))
    if (pB == nil) then
      printLuaError("tuskenArmy boot probe: missing building " .. b.id)
    else
      local n = BuildingObject(pB):getTotalCellNumber()
      if (n <= 0) then
        printLuaError("tuskenArmy boot probe: " .. b.id .. " getTotalCellNumber()=" .. tostring(n) .. " STOP")
        return
      end
      local pCell = BuildingObject(pB):getNamedCell(b.firstCell)
      if (pCell == nil) then
        printLuaError("tuskenArmy boot probe: " .. b.id .. " getNamedCell(" .. b.firstCell .. ") nil STOP")
        return
      end
    end
  end
end

function tuskenArmy:cell(buildingId, cellName)
  local pB = getSceneObject(readData("tuskenArmy:bld:" .. buildingId))
  if (pB == nil) then return nil end
  return BuildingObject(pB):getNamedCell(cellName)
end

function tuskenArmy:buildingWorld(buildingId)
  for i = 1, #self.buildings do
    if (self.buildings[i].id == buildingId) then
      return self.originX + self.buildings[i].x, self.originY, self.originZ + self.buildings[i].z
    end
  end
  return self.originX, self.originY, self.originZ
end

function tuskenArmy:track(pObj)
  if (pObj == nil) then return end
  local n = readData("tuskenArmy:contentCount") + 1
  writeData("tuskenArmy:contentCount", n)
  writeData("tuskenArmy:content" .. n, SceneObject(pObj):getObjectID())
end

function tuskenArmy:spawnWorld(templateName, dx, dy, dz, yaw)
  local pMob = spawnMobile("tatooine", templateName, 0, self.originX + dx, self.originY + dy, self.originZ + dz, yaw, 0)
  self:track(pMob)
  return pMob
end

function tuskenArmy:spawnAtBuilding(buildingId, templateName, x, y, z, yaw, cellName)
  if (cellName ~= nil and cellName ~= "") then
    local pCell = self:cell(buildingId, cellName)
    if (pCell == nil) then
      printLuaError("tuskenArmy: missing cell " .. tostring(cellName) .. " in " .. buildingId)
      return nil
    end
    local pMob = spawnMobile("tatooine", templateName, 0, x, y, z, yaw, SceneObject(pCell):getObjectID())
    self:track(pMob)
    return pMob
  end
  local bx, by, bz = self:buildingWorld(buildingId)
  local pMob = spawnMobile("tatooine", templateName, 0, bx + x, by + y, bz + z, yaw, 0)
  self:track(pMob)
  return pMob
end

function tuskenArmy:getPlayersInTown()
  local players = {}
  local pRef = getSceneObject(readData("tuskenArmy:trackerID"))
  if (pRef == nil) then
    pRef = getSceneObject(readData("tuskenArmy:bld:cantina"))
  end
  if (pRef == nil) then
    return players
  end
  -- SOURCED (SOE, tusken_controller.java:16) 1000 m sweep.
  return SceneObject(pRef):getPlayersInRange(1000)
end

function tuskenArmy:broadcast(msg)
  local players = self:getPlayersInTown()
  if (players == nil) then return end
  for i = 1, #players do
    if (players[i] ~= nil) then
      CreatureObject(players[i]):sendSystemMessage(msg)
    end
  end
end

function tuskenArmy:barkKav(key)
  local pKav = getSceneObject(readData("tuskenArmy:kavID"))
  if (pKav ~= nil) then
    spatialChat(pKav, "@sequencer_spam:" .. key)
    return
  end
  self:broadcast("@sequencer_spam:" .. key)
end

function tuskenArmy:banner(key)
  self:broadcast("@sequencer_spam:" .. key)
end

function tuskenArmy:activate(pPlayer)
  if (not isZoneEnabled("tatooine")) then
    CreatureObject(pPlayer):sendSystemMessage("That area is currently unavailable. Please try again later.")
    return false
  end

  if (readData("tuskenArmy:occupiedState") == 1) then
    CreatureObject(pPlayer):sendSystemMessage("That instance is currently occupied, please try a different instance.")
    return false
  end

  writeData("tuskenArmyStartTime", os.time())

  -- D7: 7200 s. Start message OURS, NOT SOURCED -- Lev's timer_N keys stop at 59.
  CreatureObject(pPlayer):sendSystemMessage("Instance Started: You have 120 minutes remaining to complete the instance.")
  createEvent(1000, "tuskenArmy", "transportPlayer", pPlayer, "")

  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()
    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if pMember ~= nil and pMember ~= pPlayer and CreatureObject(pPlayer):isInRangeWithObject(pMember, 50) and not SceneObject(pMember):isAiAgent() then
        self:sendAuthorizationSui(pMember, pPlayer)
      end
    end
  end

  writeData("tuskenArmy:occupiedState", 1)
  createEvent(1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  return true
end

function tuskenArmy:sendAuthorizationSui(pPlayer, pLeader)
  if (pPlayer == nil) then
    return
  end

  local sui = SuiMessageBox.new("tuskenArmy", "authorizationSuiCallback")
  -- SOURCED (SOE, instance.stf:heroic_tusken_army) = "Heroic: Tusken Army"
  sui.setTitle("Heroic: Tusken Army")
  -- OURS, NOT SOURCED -- Lev's prompt with the place name swapped.
  sui.setPrompt(CreatureObject(pLeader):getFirstName() .. " has granted you authorization to travel to Mos Espa.  Do you accept this travel offer?")
  sui.setOkButtonText("Yes")
  sui.setCancelButtonText("No")
  local pageId = sui.sendTo(pPlayer)
  createEvent(30 * 1000, "tuskenArmy", "closeAuthorizationSui", pPlayer, pageId)
end

function tuskenArmy:authorizationSuiCallback(pPlayer, pSui, eventIndex, args, ...)
  local cancelPressed = (eventIndex == 1)
  if (cancelPressed) then
    CreatureObject(pPlayer):sendSystemMessage("You decline to enter the instance.")
    return
  elseif (eventIndex == 0) then
    createEvent(1000, "tuskenArmy", "transportPlayer", pPlayer, "")
  end
end

function tuskenArmy:closeAuthorizationSui(pPlayer, pageId)
  local pGhost = CreatureObject(pPlayer):getPlayerObject()
  if (pGhost == nil) then
    return
  end
  PlayerObject(pGhost):removeSuiBox(pageId)
end

function tuskenArmy:transportPlayer(pPlayer)
  if pPlayer == nil then
    return
  end
  -- D10: no mount guard. enter_one = "321,0,52,none" -- SOURCED (SOE, instance_datatable.tab).
  SceneObject(pPlayer):switchZone("tatooine", self.originX + 321, self.originY, self.originZ + 52, 0)
end

function tuskenArmy:handleTimer(pPlayer)
  local startTime = readData("tuskenArmyStartTime")
  local timeLeftSecs = 7200 - (os.time() - startTime)
  local timeLeft = math.floor(timeLeftSecs / 60)

  if (timeLeft > 59) then
    -- D7: ladder starts at 59. Sleep until 59 minutes remain.
    createEvent((timeLeftSecs - 59 * 60) * 1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeft > 10) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(5 * 60 * 1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeft >= 3) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(60 * 1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeft >= 2) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 90) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 60) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(30 * 1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 30) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(20 * 1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  elseif (timeLeftSecs >= 10) then
    CreatureObject(pPlayer):sendSystemMessage("@dungeon/corvette:timer_" .. timeLeft)
    createEvent(10 * 1000, "tuskenArmy", "checkIfActiveForTimer", pPlayer, "")
  else
    self:checkIfActive(pPlayer)
  end
end

function tuskenArmy:checkIfActiveForTimer(pPlayer)
  if (readData("tuskenArmy:occupiedState") == 1) then
    createEvent(1, "tuskenArmy", "handleTimer", pPlayer, "")
  else
    self:resetInstance(pPlayer)
  end
end

function tuskenArmy:clearEncounterKeys()
  writeData("tuskenArmy:encounterState", 0)
  writeData("tuskenArmy:phase", 1)
  writeData("tuskenArmy:cantinaSecured", 0)
  writeData("tuskenArmy:p1Done", 0)
  writeData("tuskenArmy:p2Done", 0)
  writeData("tuskenArmy:p1PatStop", 0)
  writeData("tuskenArmy:citizenDead", 0)
  writeData("tuskenArmy:failArmed", 0)
  writeData("tuskenArmy:kavAttackBark", 0)
  writeData("tuskenArmy:kavID", 0)
  writeData("tuskenArmy:trackerID", 0)
  writeData("tuskenArmy:macyID", 0)
  writeData("tuskenArmy:kingID", 0)
  for i = 1, #self.p1Buildings do
    writeData("tuskenArmy:p1:" .. self.p1Buildings[i], 0)
    writeData("tuskenArmy:gAlive:" .. self.p1Buildings[i], 0)
  end
  writeData("tuskenArmy:p1:cantina", 0)
  writeData("tuskenArmy:gAlive:cantina", 0)
  for i = 1, #self.staffBuildings do
    writeData("tuskenArmy:staff:" .. self.staffBuildings[i], 0)
    writeData("tuskenArmy:staffed:" .. self.staffBuildings[i], 0)
  end
  writeData("tuskenArmy:staff:hotel", 0)
  writeData("tuskenArmy:staffed:hotel", 0)
  for i = 1, #self.proxPacks do
    writeData("tuskenArmy:prox:" .. self.proxPacks[i].name, 0)
  end
  writeData("tuskenArmy:rescueSeq", 0)
end

function tuskenArmy:destroyArenaContents()
  local n = readData("tuskenArmy:contentCount")
  for i = 1, n do
    local pObj = getSceneObject(readData("tuskenArmy:content" .. i))
    if (pObj ~= nil) then
      SceneObject(pObj):destroyObjectFromWorld()
    end
    writeData("tuskenArmy:content" .. i, 0)
  end
  writeData("tuskenArmy:contentCount", 0)
end

function tuskenArmy:spawnPhaseZero()
  -- Quest tracker prop. SOE heroic_tusken_army.tab:306 is patrol_waypoint.iff, which has
  -- no SD3 Lua template. Substitute the shipped green waypoint SOE uses as the "secured"
  -- marker (cantina.tab:36). OURS, NOT SOURCED for the substitute; the role (origin
  -- reference for the 1000 m player sweep) is SOE's.
  local pTrack = spawnSceneObject("tatooine", "object/static/structure/general/waypoint_large_green.iff", self.originX, self.originY, self.originZ, 0, math.rad(0))
  if (pTrack ~= nil) then
    writeData("tuskenArmy:trackerID", SceneObject(pTrack):getObjectID())
    self:track(pTrack)
  end

  -- Exit bubble. OURS, NOT SOURCED (D10). Town center ~ origin+(-24, 34), radius 500 m.
  local pExit = spawnSceneObject("tatooine", "object/active_area.iff", self.originX - 24, self.originY, self.originZ + 34, 0, 0)
  if (pExit ~= nil) then
    local area = LuaActiveArea(pExit)
    area:setRadius(500)
    createObserver(EXITEDAREA, "tuskenArmy", "notifyExitTown", pExit)
    self:track(pExit)
  end

  self:spawnGarrison("cantina")

  -- Kav greeter. SOURCED (SOE, cantina.tab:25) golderOne at cantina+(365,0,90.43), inv=1.
  local pKav = self:spawnAtBuilding("cantina", "heroic_tusken_kav_golder", 365, 0, 90.43, 112, "")
  if (pKav ~= nil) then
    TangibleObject(pKav):setOptionBit(INVULNERABLE)
    writeData("tuskenArmy:kavID", SceneObject(pKav):getObjectID())
    createObserver(OBJECTDESTRUCTION, "tuskenArmy", "kavDied", pKav)
  end

  for i = 1, #self.outdoorDefault do
    local m = self.outdoorDefault[i]
    local pMob = self:spawnWorld(m[1], m[2], m[3], m[4], m[5])
    if (pMob ~= nil) then
      writeData(SceneObject(pMob):getObjectID() .. ":tuskenPrey", 1)
    end
  end

  for i = 1, #self.proxPacks do
    local p = self.proxPacks[i]
    local pArea = spawnSceneObject("tatooine", "object/active_area.iff", self.originX + p.x, self.originY, self.originZ + p.z, 0, 0)
    if (pArea ~= nil) then
      local area = LuaActiveArea(pArea)
      area:setRadius(p.r)
      writeStringData(SceneObject(pArea):getObjectID() .. ":tuskenProx", p.name)
      createObserver(ENTEREDAREA, "tuskenArmy", "notifyProxPack", pArea)
      self:track(pArea)
    end
  end

  -- Delivery areas at the seven staffed buildings. OURS, NOT SOURCED (D3).
  local dest = { "starport", "university", "hospital", "watto", "cloning", "combat", "hotel" }
  for i = 1, #dest do
    local bx, by, bz = self:buildingWorld(dest[i])
    local pArea = spawnSceneObject("tatooine", "object/active_area.iff", bx, by, bz, 0, 0)
    if (pArea ~= nil) then
      local area = LuaActiveArea(pArea)
      area:setRadius(20)
      writeStringData(SceneObject(pArea):getObjectID() .. ":tuskenDest", dest[i])
      createObserver(ENTEREDAREA, "tuskenArmy", "notifyDelivery", pArea)
      self:track(pArea)
    end
  end

  -- Rescue-house follow areas.
  local houses = { "medium", "rescuewest", "slumsouth1" }
  for i = 1, #houses do
    local bx, by, bz = self:buildingWorld(houses[i])
    local pArea = spawnSceneObject("tatooine", "object/active_area.iff", bx, by, bz, 0, 0)
    if (pArea ~= nil) then
      local area = LuaActiveArea(pArea)
      area:setRadius(20)
      writeStringData(SceneObject(pArea):getObjectID() .. ":tuskenHouse", houses[i])
      createObserver(ENTEREDAREA, "tuskenArmy", "notifyRescueHouse", pArea)
      self:track(pArea)
    end
  end

  writeData("tuskenArmy:phase", 1)
end

function tuskenArmy:spawnGarrison(buildingId)
  local list = self.garrison[buildingId]
  if (list == nil) then return end
  local alive = 0
  for i = 1, #list do
    local m = list[i]
    local pMob = self:spawnAtBuilding(buildingId, m[1], m[2], m[3], m[4], m[5], m[6])
    if (pMob ~= nil) then
      alive = alive + 1
      writeStringData(SceneObject(pMob):getObjectID() .. ":tuskenGar", buildingId)
      writeData(SceneObject(pMob):getObjectID() .. ":tuskenPrey", 1)
      createObserver(OBJECTDESTRUCTION, "tuskenArmy", "garrisonKilled", pMob)
    end
  end
  writeData("tuskenArmy:gAlive:" .. buildingId, alive)
end

function tuskenArmy:garrisonKilled(pMob, pPlayer)
  if (pMob == nil) then return 0 end
  local oid = SceneObject(pMob):getObjectID()
  local bld = readStringData(oid .. ":tuskenGar")
  if (bld == nil or bld == "") then return 0 end
  if (bld ~= "cantina" and readData("tuskenArmy:cantinaSecured") ~= 1) then
    -- Other halls cannot clear until cantina_captured (heroic_tusken_army.tab:155-161).
    return 0
  end
  local left = readData("tuskenArmy:gAlive:" .. bld) - 1
  if (left < 0) then left = 0 end
  writeData("tuskenArmy:gAlive:" .. bld, left)
  if (left == 0) then
    self:buildingSecured(bld)
  end
  return 0
end

function tuskenArmy:buildingSecured(bld)
  if (readData("tuskenArmy:p1:" .. bld) == 1) then return end
  writeData("tuskenArmy:p1:" .. bld, 1)
  if (self.takenKey[bld] ~= nil) then
    self:barkKav(self.takenKey[bld])
  end
  if (self.clearedKey[bld] ~= nil) then
    self:banner(self.clearedKey[bld])
  end
  if (bld == "cantina") then
    self:onCantinaCaptured()
  else
    self:checkPhaseOne()
  end
end

function tuskenArmy:onCantinaCaptured()
  writeData("tuskenArmy:cantinaSecured", 1)
  -- Move Kav into the cantina. SOURCED (SOE, cantina.tab:31) golderTwo.
  local pOld = getSceneObject(readData("tuskenArmy:kavID"))
  if (pOld ~= nil) then
    SceneObject(pOld):destroyObjectFromWorld()
  end
  local pKav = self:spawnAtBuilding("cantina", "heroic_tusken_kav_golder", 23, -1, 1.3, 108, "cantina")
  if (pKav ~= nil) then
    writeData("tuskenArmy:kavID", SceneObject(pKav):getObjectID())
    writeData("tuskenArmy:kavAttackBark", 0)
    createObserver(OBJECTDESTRUCTION, "tuskenArmy", "kavDied", pKav)
    createObserver(DAMAGERECEIVED, "tuskenArmy", "kavAttack", pKav)
  end
  for i = 1, #self.p1Buildings do
    self:spawnGarrison(self.p1Buildings[i])
  end
  for i = 1, #self.hunterWaves do
    createEvent(self.hunterWaves[i].delay * 1000, "tuskenArmy", "spawnHunterWave", nil, tostring(i))
  end
  for i = 1, #self.p1Squads do
    createEvent(self.p1Squads[i].delay * 1000, "tuskenArmy", "spawnP1Squad", nil, tostring(i))
  end
end

function tuskenArmy:spawnHunterWave(pDummy, indexStr)
  if (readData("tuskenArmy:phase") ~= 1) then return end
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  local i = tonumber(indexStr)
  local wave = self.hunterWaves[i]
  if (wave == nil) then return end
  if (i == 1) then
    self:barkKav("heroic_tusken_kav_hunters_coming")
  end
  for j = 1, #wave.mobs do
    local m = wave.mobs[j]
    local pMob = self:spawnAtBuilding("cantina", m[1], m[2], m[3], m[4], m[5], "")
    if (pMob ~= nil) then
      writeData(SceneObject(pMob):getObjectID() .. ":tuskenPrey", 1)
    end
  end
end

function tuskenArmy:spawnP1Squad(pDummy, indexStr)
  if (readData("tuskenArmy:p1PatStop") == 1) then return end
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  local i = tonumber(indexStr)
  local squad = self.p1Squads[i]
  if (squad == nil) then return end
  for j = 1, #squad.mobs do
    local m = squad.mobs[j]
    local pMob = self:spawnWorld(m[1], m[2], m[3], m[4], m[5])
    if (pMob ~= nil) then
      writeData(SceneObject(pMob):getObjectID() .. ":tuskenPrey", 1)
    end
  end
  -- respawn = 75 until start_phase_three. SOURCED (SOE, heroic_tusken_army.tab:212-267).
  createEvent(75 * 1000, "tuskenArmy", "spawnP1Squad", nil, indexStr)
end

function tuskenArmy:checkPhaseOne()
  if (readData("tuskenArmy:p1Done") == 1) then return end
  for i = 1, #self.p1Buildings do
    if (readData("tuskenArmy:p1:" .. self.p1Buildings[i]) ~= 1) then
      return
    end
  end
  writeData("tuskenArmy:p1Done", 1)
  createEvent(7 * 1000, "tuskenArmy", "endPhaseOneSpam", nil, "")
  createEvent(120 * 1000, "tuskenArmy", "startPhaseTwo", nil, "")
end

function tuskenArmy:endPhaseOneSpam()
  self:barkKav("heroic_tusken_kav_end_phase_one")
end

function tuskenArmy:startPhaseTwo()
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  writeData("tuskenArmy:phase", 2)
  -- Kav phase-2. SOURCED (SOE, cantina.tab:41) golderThree, inv=1.
  local pOld = getSceneObject(readData("tuskenArmy:kavID"))
  if (pOld ~= nil) then
    SceneObject(pOld):destroyObjectFromWorld()
  end
  local pKav = self:spawnAtBuilding("cantina", "heroic_tusken_kav_golder", 12, -1, 2.5, 108, "cantina")
  if (pKav ~= nil) then
    TangibleObject(pKav):setOptionBit(INVULNERABLE)
    writeData("tuskenArmy:kavID", SceneObject(pKav):getObjectID())
    createObserver(OBJECTDESTRUCTION, "tuskenArmy", "kavDied", pKav)
  end
  self:doRescueEvent()
end

function tuskenArmy:doRescueEvent()
  if (readData("tuskenArmy:phase") ~= 2) then return end
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  local pick = getRandomNumber(1, #self.rescues)
  local r = self.rescues[pick]
  self:barkKav(r.bark)
  for i = 1, #r.slots do
    local s = r.slots[i]
    -- 1-in-3 citizen, 2-in-3 expert. SOURCED (SOE, randomTrigger:citizenN,expertN,expertN).
    local tmpl = "heroic_tusken_mos_espa_expert"
    local kind = 1
    if (getRandomNumber(1, 3) == 1) then
      tmpl = "heroic_tusken_mos_espa_citizen"
      kind = 0
    end
    local pNpc = self:spawnAtBuilding(r.id, tmpl, s.x, s.y, s.z, s.yaw, s.cell)
    if (pNpc ~= nil) then
      writeData(SceneObject(pNpc):getObjectID() .. ":tuskenKind", kind)
      writeData(SceneObject(pNpc):getObjectID() .. ":tuskenFollow", 0)
      writeData(SceneObject(pNpc):getObjectID() .. ":tuskenRescue", 1)
      if (kind == 0) then
        createObserver(OBJECTDESTRUCTION, "tuskenArmy", "citizenDied", pNpc)
      end
    end
  end
  createEvent(20 * 1000, "tuskenArmy", "spawnRescueHunters", nil, tostring(pick))
  createEvent(120 * 1000, "tuskenArmy", "doRescueEvent", nil, "")
end

function tuskenArmy:spawnRescueHunters(pDummy, indexStr)
  if (readData("tuskenArmy:phase") ~= 2) then return end
  local r = self.rescues[tonumber(indexStr)]
  if (r == nil) then return end
  for i = 1, #r.hunters do
    local h = r.hunters[i]
    local pH = self:spawnAtBuilding(r.id, "heroic_tusken_flesh_hunter", h[1], h[2], h[3], h[4], "")
    if (pH ~= nil) then
      writeData(SceneObject(pH):getObjectID() .. ":tuskenPrey", 1)
    end
  end
end

function tuskenArmy:notifyRescueHouse(pActiveArea, pMovingObject)
  if (pMovingObject == nil) then return 0 end
  if (not SceneObject(pMovingObject):isPlayerCreature()) then return 0 end
  if (readData("tuskenArmy:occupiedState") ~= 1) then return 0 end
  if (readData("tuskenArmy:phase") ~= 2) then return 0 end
  -- All unfollowed civilians in 25 m start following this player. OURS, NOT SOURCED (D3).
  local n = readData("tuskenArmy:contentCount")
  for i = 1, n do
    local pObj = getSceneObject(readData("tuskenArmy:content" .. i))
    if (pObj ~= nil and SceneObject(pObj):isAiAgent() and not CreatureObject(pObj):isDead()) then
      local oid = SceneObject(pObj):getObjectID()
      local kind = readData(oid .. ":tuskenKind")
      -- kind 0 citizen, 1 expert. tuskenRescue distinguishes from readData's 0-default.
      if (readData(oid .. ":tuskenRescue") == 1 and readData(oid .. ":tuskenFollow") ~= 1) then
        if (SceneObject(pObj):getDistanceTo(pMovingObject) <= 25) then
          writeData(oid .. ":tuskenFollow", 1)
          AiAgent(pObj):removeObjectFlag(AI_STATIONARY)
          AiAgent(pObj):addObjectFlag(AI_NOAIAGGRO)
          AiAgent(pObj):addObjectFlag(AI_ESCORT)
          AiAgent(pObj):addObjectFlag(AI_FOLLOW)
          AiAgent(pObj):setFollowObject(pMovingObject)
          AiAgent(pObj):setMovementState(AI_FOLLOWING)
          AiAgent(pObj):setAITemplate()
        end
      end
    end
  end
  return 0
end

function tuskenArmy:notifyDelivery(pActiveArea, pMovingObject)
  if (pMovingObject == nil) then return 0 end
  if (not SceneObject(pMovingObject):isAiAgent()) then return 0 end
  if (readData("tuskenArmy:phase") ~= 2) then return 0 end
  local oid = SceneObject(pMovingObject):getObjectID()
  if (readData(oid .. ":tuskenFollow") ~= 1) then return 0 end
  if (readData(oid .. ":tuskenRescue") ~= 1) then return 0 end
  local dest = readStringData(SceneObject(pActiveArea):getObjectID() .. ":tuskenDest")
  if (dest == nil or dest == "") then return 0 end
  local kind = readData(oid .. ":tuskenKind")
  writeData(oid .. ":tuskenFollow", 2)
  SceneObject(pMovingObject):destroyObjectFromWorld()
  if (dest == "hotel") then
    if (kind == 0) then
      local n = readData("tuskenArmy:staff:hotel") + 1
      writeData("tuskenArmy:staff:hotel", n)
      if (n >= 10 and readData("tuskenArmy:staffed:hotel") ~= 1) then
        writeData("tuskenArmy:staffed:hotel", 1)
      end
    end
  else
    if (kind == 1) then
      local n = readData("tuskenArmy:staff:" .. dest) + 1
      writeData("tuskenArmy:staff:" .. dest, n)
      local keys = self.expertKey[dest]
      if (keys ~= nil and n >= 1 and n <= 3) then
        self:banner(keys[n])
      end
      if (n >= 3 and readData("tuskenArmy:staffed:" .. dest) ~= 1) then
        writeData("tuskenArmy:staffed:" .. dest, 1)
        self:onBuildingStaffed(dest)
      end
    end
  end
  self:checkPhaseTwo()
  return 0
end

function tuskenArmy:onBuildingStaffed(dest)
  if (dest == "starport") then
    -- spawn_macy. SOURCED (SOE, starport.tab:45 / heroic_tusken_army.tab:271).
    -- D5: starport.tab:55-59 names heroic_tusken_mos_eisley_expect (absent from creatures.tab);
    -- mapped to heroic_tusken_mos_espa_expert. Those rows are staffing visuals, not spawned;
    -- delivered escorts increment the expert count instead (D3).
    local pMacy = self:spawnAtBuilding("starport", "heroic_tusken_macy_malo", 0, 0, 53.5, 0, "foyer4")
    if (pMacy ~= nil) then
      TangibleObject(pMacy):setOptionBit(INVULNERABLE)
      writeData("tuskenArmy:macyID", SceneObject(pMacy):getObjectID())
      createEvent(getRandomNumber(35, 60) * 1000, "tuskenArmy", "macyBomb", pMacy, "")
    end
  elseif (dest == "hospital") then
    createEvent(17 * 1000, "tuskenArmy", "spawnMedic", nil, "")
  elseif (dest == "combat") then
    createEvent(30 * 1000, "tuskenArmy", "spawnMilitiaSquad", nil, "1")
    createEvent(60 * 1000, "tuskenArmy", "spawnMilitiaSquad", nil, "2")
    createEvent(90 * 1000, "tuskenArmy", "spawnMilitiaSquad", nil, "3")
    createEvent(120 * 1000, "tuskenArmy", "spawnMilitiaSquad", nil, "4")
    createEvent(150 * 1000, "tuskenArmy", "spawnMilitiaSquad", nil, "5")
  end
  -- university apply_tusken_bane and cloning apply_criticial_heal_buff: no SD3 analogue (PART 8.6 item 8).
  -- watto pit/mse droids: flavour, not minted this round (PART 8.2).
end

function tuskenArmy:macyBomb(pMacy)
  if (pMacy == nil) then return end
  if (readData("tuskenArmy:phase") == 3) then return end
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  -- Effect of macy_malo.java:25-75: one-shot a random outdoor Tusken every 35-60 s.
  -- queueCommand CRC not bound; destroyObjectFromWorld is the portable effect. OURS, NOT SOURCED.
  local n = readData("tuskenArmy:contentCount")
  local prey = {}
  for i = 1, n do
    local pObj = getSceneObject(readData("tuskenArmy:content" .. i))
    if (pObj ~= nil and SceneObject(pObj):isAiAgent() and not CreatureObject(pObj):isDead()) then
      if (SceneObject(pObj):getParentID() == 0 and readData(SceneObject(pObj):getObjectID() .. ":tuskenPrey") == 1) then
        prey[#prey + 1] = pObj
      end
    end
  end
  if (#prey > 0) then
    local pT = prey[getRandomNumber(1, #prey)]
    if (pT ~= nil) then
      SceneObject(pT):destroyObjectFromWorld()
    end
  end
  createEvent(getRandomNumber(35, 60) * 1000, "tuskenArmy", "macyBomb", pMacy, "")
end

function tuskenArmy:spawnMedic()
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  local pMedic = self:spawnAtBuilding("hospital", "heroic_tusken_mos_espa_medic", -0.4, 0.18, 13, 9, "entrya")
  if (pMedic ~= nil) then
    createEvent(12 * 1000, "tuskenArmy", "medicHealTick", pMedic, "")
  end
  createEvent(90 * 1000, "tuskenArmy", "spawnMedic", nil, "")
end

function tuskenArmy:medicHealTick(pMedic)
  if (pMedic == nil or CreatureObject(pMedic):isDead()) then return end
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  -- medic.java:82-148: every rand(15,30) s heal every valid outdoor target within 25 m, cap 5000.
  local players = SceneObject(pMedic):getPlayersInRange(25)
  if (players ~= nil) then
    for i = 1, #players do
      if (players[i] ~= nil and SceneObject(players[i]):getParentID() == 0) then
        local missing = CreatureObject(players[i]):getMaxHAM(0) - CreatureObject(players[i]):getHAM(0)
        if (missing > 0) then
          local amt = missing
          if (amt > 5000) then amt = 5000 end
          CreatureObject(players[i]):healDamage(amt, 0)
          CreatureObject(players[i]):playEffect("clienteffect/bacta_bomb.cef", "")
        end
      end
    end
  end
  createEvent(getRandomNumber(15, 30) * 1000, "tuskenArmy", "medicHealTick", pMedic, "")
end

tuskenArmy.militiaSquads = {
  { { -19, 0, -281, 0 }, { -35, 0, -316, 0 }, { -64, 0, -326, 0 }, { -87, 0, -286, 0 } },
  { { 73, 0, -153, 0 }, { 88, 0, -148, 0 }, { 85, 0, -234, 0 }, { 65, 0, -249, 0 } },
  { { 102, 0, 66, 0 }, { 103, 0, 28, 0 }, { 87, 0, 3.17, 0 }, { 65, 0, 2, 0 } },
  { { 134, 0, -166, 0 }, { 143, 0, -126, 0 }, { 200, 0, -167, 0 }, { 139, 0, -227, 0 } },
  { { 73, 0, -453, 0 }, { 117, 0, -459, 0 }, { 124, 0, -410, 0 }, { 91, 0, -406, 0 } },
}

function tuskenArmy:spawnMilitiaSquad(pDummy, indexStr)
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  local squad = self.militiaSquads[tonumber(indexStr)]
  if (squad == nil) then return end
  for i = 1, #squad do
    local m = squad[i]
    self:spawnWorld("heroic_tusken_mos_espa_militia", m[1], m[2], m[3], m[4])
  end
end

function tuskenArmy:checkPhaseTwo()
  if (readData("tuskenArmy:p2Done") == 1) then return end
  -- end_phase_two: six staff buildings, hotel not in the gate (heroic_tusken_army.tab:179).
  for i = 1, #self.staffBuildings do
    if (readData("tuskenArmy:staffed:" .. self.staffBuildings[i]) ~= 1) then
      return
    end
  end
  writeData("tuskenArmy:p2Done", 1)
  -- cantina.tab:86-87 3 s delay then start_phase_three.
  createEvent(3 * 1000, "tuskenArmy", "startPhaseThree", nil, "")
end

function tuskenArmy:startPhaseThree()
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  writeData("tuskenArmy:phase", 3)
  writeData("tuskenArmy:p1PatStop", 1)
  local pMacy = getSceneObject(readData("tuskenArmy:macyID"))
  if (pMacy ~= nil) then
    SceneObject(pMacy):destroyObjectFromWorld()
  end
  -- Kav walks to kav_final (43,0,30) relative to cantina. SOURCED (SOE, cantina.tab:75,77).
  local pOld = getSceneObject(readData("tuskenArmy:kavID"))
  if (pOld ~= nil) then
    SceneObject(pOld):destroyObjectFromWorld()
  end
  local pKav = self:spawnAtBuilding("cantina", "heroic_tusken_kav_golder", 43, 0, 30, 0, "")
  if (pKav ~= nil) then
    TangibleObject(pKav):setOptionBit(INVULNERABLE)
    writeData("tuskenArmy:kavID", SceneObject(pKav):getObjectID())
  end
  -- Four militia + two medics around him. SOURCED (SOE, cantina.tab:78-83).
  self:spawnAtBuilding("cantina", "heroic_tusken_mos_espa_militia", 48, 0, 31, 141, "")
  self:spawnAtBuilding("cantina", "heroic_tusken_mos_espa_militia", 43, 0, 25, 141, "")
  self:spawnAtBuilding("cantina", "heroic_tusken_mos_espa_militia", 36, 0, 24, 141, "")
  self:spawnAtBuilding("cantina", "heroic_tusken_mos_espa_militia", 51, 0, 38, 141, "")
  local pMed1 = self:spawnAtBuilding("cantina", "heroic_tusken_mos_espa_medic", 46, 0, 37, 141, "")
  local pMed2 = self:spawnAtBuilding("cantina", "heroic_tusken_mos_espa_medic", 36, 0, 28, 141, "")
  if (pMed1 ~= nil) then createEvent(12 * 1000, "tuskenArmy", "medicHealTick", pMed1, "") end
  if (pMed2 ~= nil) then createEvent(12 * 1000, "tuskenArmy", "medicHealTick", pMed2, "") end
  createEvent(15 * 1000, "tuskenArmy", "startKingPath", nil, "")
end

function tuskenArmy:startKingPath()
  self:barkKav("heroic_tusken_kav_king_incoming")
  -- Five warlords +0/+2/+4/+6/+8 s, honor guards +82/+84/+86/+88 s, King +90 s.
  -- SOURCED (SOE, heroic_tusken_army.tab:281-299). All spawn at (125,0,-288), inv=1.
  createEvent(0, "tuskenArmy", "spawnMarcher", nil, "warlord:20:0:-29")
  createEvent(2 * 1000, "tuskenArmy", "spawnMarcher", nil, "warlord:20:0:-29")
  createEvent(4 * 1000, "tuskenArmy", "spawnMarcher", nil, "warlord:20:0:-29")
  createEvent(6 * 1000, "tuskenArmy", "spawnMarcher", nil, "warlord:20:0:-29")
  createEvent(8 * 1000, "tuskenArmy", "spawnMarcher", nil, "warlord:20:0:-29")
  createEvent(82 * 1000, "tuskenArmy", "spawnMarcher", nil, "guard:9.6:0:-30")
  createEvent(84 * 1000, "tuskenArmy", "spawnMarcher", nil, "guard:18.64:0:-20")
  createEvent(86 * 1000, "tuskenArmy", "spawnMarcher", nil, "guard:25.45:0:-21")
  createEvent(88 * 1000, "tuskenArmy", "spawnMarcher", nil, "guard:10:0:-37")
  createEvent(90 * 1000, "tuskenArmy", "spawnMarcher", nil, "king:20:0:-29")
end

function tuskenArmy:spawnMarcher(pDummy, spec)
  if (readData("tuskenArmy:occupiedState") ~= 1) then return end
  local kind, ex, ey, ez = string.match(spec, "([^:]+):([^:]+):([^:]+):([^:]+)")
  local tmpl = "heroic_tusken_warlord"
  if (kind == "guard") then tmpl = "heroic_tusken_honor_guard" end
  if (kind == "king") then tmpl = "heroic_tusken_king" end
  local pMob = self:spawnWorld(tmpl, 125, 0, -288, 0)
  if (pMob == nil) then return end
  writeData(SceneObject(pMob):getObjectID() .. ":tuskenPrey", 1)
  TangibleObject(pMob):setOptionBit(INVULNERABLE)
  if (kind == "king") then
    writeData("tuskenArmy:kingID", SceneObject(pMob):getObjectID())
    createObserver(OBJECTDESTRUCTION, "tuskenArmy", "kingDied", pMob)
  end
  writeData(SceneObject(pMob):getObjectID() .. ":tuskenEndX", tonumber(ex))
  writeData(SceneObject(pMob):getObjectID() .. ":tuskenEndZ", tonumber(ez))
  -- Shared approach: start -> com_view -> sp_view -> final_view -> own end.
  -- SOURCED (SOE, heroic_tusken_army.tab:272-280). createEvent chain is OURS.
  createEvent(2000, "tuskenArmy", "marchStep", pMob, "1")
end

tuskenArmy.marchWay = {
  { 115, 0, -260 },
  { 43, 0, -237 },
  { 14, 0, -122 },
  { 42, 0, -53 },
}

function tuskenArmy:marchStep(pMob, stepStr)
  if (pMob == nil or CreatureObject(pMob):isDead()) then return end
  local step = tonumber(stepStr)
  if (step <= #self.marchWay) then
    local w = self.marchWay[step]
    AiAgent(pMob):setNextPosition(self.originX + w[1], self.originY + w[2], self.originZ + w[3], 0)
    createEvent(12 * 1000, "tuskenArmy", "marchStep", pMob, tostring(step + 1))
  else
    local oid = SceneObject(pMob):getObjectID()
    local ex = readData(oid .. ":tuskenEndX")
    local ez = readData(oid .. ":tuskenEndZ")
    AiAgent(pMob):setNextPosition(self.originX + ex, self.originY, self.originZ + ez, 0)
    createEvent(12 * 1000, "tuskenArmy", "marchArrive", pMob, "")
  end
end

function tuskenArmy:marchArrive(pMob)
  if (pMob == nil or CreatureObject(pMob):isDead()) then return end
  TangibleObject(pMob):clearOptionBit(INVULNERABLE)
end

function tuskenArmy:kingDied(pKing, pPlayer)
  writeData("tuskenArmy:encounterState", 2)
  if (pPlayer ~= nil) then
    CreatureObject(pPlayer):sendSystemMessage("You and your group have defeated the Tusken King!  You will be removed from the instance in 300 seconds.")
    createEvent(1000, "tuskenArmy", "awardTokenToAll", pPlayer, "")
    -- SOURCED (SOE, tusken_controller.java:17) setClock 300 before the token; we award immediately and eject at 300 s.
    createEvent(300 * 1000, "tuskenArmy", "handleVictory", pPlayer, "")
  end
  return 0
end

function tuskenArmy:awardToken(pPlayer)
  if (pPlayer == nil) then return end
  local oid = SceneObject(pPlayer):getObjectID() .. ":" .. tostring(readData("tuskenArmyStartTime"))
  if (readData("tuskenArmy:token:" .. oid) == 1) then return end
  local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")
  if (pInventory ~= nil) then
    giveItem(pInventory, "object/tangible/loot/misc/tusken_token.iff", -1, true)
    writeData("tuskenArmy:token:" .. oid, 1)
  end
end

function tuskenArmy:awardTokenToAll(pPlayer)
  createEvent(1000, "tuskenArmy", "awardToken", pPlayer, "")
  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()
    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if pMember ~= nil and pMember ~= pPlayer and CreatureObject(pPlayer):isInRangeWithObject(pMember, 300) and not SceneObject(pMember):isAiAgent() then
        self:awardToken(pMember, pPlayer)
      end
    end
  end
end

function tuskenArmy:citizenDied(pNpc, pPlayer)
  local n = readData("tuskenArmy:citizenDead") + 1
  writeData("tuskenArmy:citizenDead", n)
  if (n == 1) then self:barkKav("heroic_tusken_kav_citizen_one") end
  if (n == 5) then self:barkKav("heroic_tusken_kav_citizen_five") end
  if (n == 10) then
    self:barkKav("heroic_tusken_kav_citizen_ten")
    createEvent(10 * 1000, "tuskenArmy", "failTenCitizens", pPlayer, "")
  end
  return 0
end

function tuskenArmy:failTenCitizens(pPlayer)
  self:barkKav("heroic_tusken_kav_fail_10_citizen")
  createEvent(10 * 1000, "tuskenArmy", "failInstance", pPlayer, "")
end

function tuskenArmy:kavAttack(pKav, pAttacker)
  if (readData("tuskenArmy:kavAttackBark") == 1) then
    return 0
  end
  writeData("tuskenArmy:kavAttackBark", 1)
  -- SOURCED (SOE, cantina.tab:49) messagePlayers:heroic_tusken_kav_hunters_attack on golder_attack / OnEnterCombat.
  self:barkKav("heroic_tusken_kav_hunters_attack")
  return 0
end

function tuskenArmy:kavDied(pKav, pPlayer)
  self:barkKav("heroic_tusken_kav_alas_am_dead")
  createEvent(10 * 1000, "tuskenArmy", "failInstance", pPlayer, "")
  return 0
end

function tuskenArmy:failInstance(pPlayer)
  if (readData("tuskenArmy:failArmed") == 1) then return end
  writeData("tuskenArmy:failArmed", 1)
  self:ejectAllPlayers(pPlayer)
  self:resetInstance(pPlayer)
end

function tuskenArmy:notifyProxPack(pActiveArea, pMovingObject)
  if (pMovingObject == nil) then return 0 end
  if (not SceneObject(pMovingObject):isPlayerCreature()) then return 0 end
  if (readData("tuskenArmy:occupiedState") ~= 1) then return 0 end
  local name = readStringData(SceneObject(pActiveArea):getObjectID() .. ":tuskenProx")
  if (name == nil or name == "") then return 0 end
  if (readData("tuskenArmy:prox:" .. name) == 1) then return 0 end
  writeData("tuskenArmy:prox:" .. name, 1)
  for i = 1, #self.proxPacks do
    if (self.proxPacks[i].name == name) then
      local mobs = self.proxPacks[i].mobs
      for j = 1, #mobs do
        local m = mobs[j]
        local pMob = self:spawnWorld(m[1], m[2], m[3], m[4], m[5])
        if (pMob ~= nil) then
          writeData(SceneObject(pMob):getObjectID() .. ":tuskenPrey", 1)
        end
      end
      break
    end
  end
  return 0
end

function tuskenArmy:notifyExitTown(pActiveArea, pMovingObject)
  if (pMovingObject == nil) then return 0 end
  if (not SceneObject(pMovingObject):isPlayerCreature()) then return 0 end
  if (readData("tuskenArmy:occupiedState") ~= 1) then return 0 end
  if (readData("tuskenArmy:encounterState") == 2) then return 0 end
  -- D10: outdoor stand-in for Lev's EXITEDBUILDING resetInstanceA.
  CreatureObject(pMovingObject):sendSystemMessage("One or more group members have left the dungeon.")
  self:resetInstance(pMovingObject)
  self:ejectAllGroupMembers(pMovingObject)
  return 0
end

function tuskenArmy:checkIfActive(pPlayer)
  if (readData("tuskenArmy:occupiedState") == 1) then
    self:ejectAllPlayers(pPlayer)
    self:resetInstance(pPlayer)
    return true
  end
end

function tuskenArmy:ejectAllPlayers(pPlayer)
  createEvent(1000, "tuskenArmy", "ejectPlayer", pPlayer, "")
  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()
    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if pMember ~= nil and pMember ~= pPlayer and CreatureObject(pPlayer):isInRangeWithObject(pMember, 300) and not SceneObject(pMember):isAiAgent() then
        self:ejectPlayer(pMember, pPlayer)
      end
    end
  end
end

function tuskenArmy:ejectAllGroupMembers(pPlayer)
  if (CreatureObject(pPlayer):isGrouped()) then
    local groupSize = CreatureObject(pPlayer):getGroupSize()
    for i = 0, groupSize - 1, 1 do
      local pMember = CreatureObject(pPlayer):getGroupMember(i)
      if pMember ~= nil and pMember ~= pPlayer and not SceneObject(pMember):isAiAgent() then
        self:ejectPlayer(pMember, pPlayer)
      end
    end
  end
end

function tuskenArmy:ejectPlayer(pPlayer)
  if pPlayer == nil then return end
  if (SceneObject(pPlayer):getZoneName() == "tatooine") then
    CreatureObject(pPlayer):sendSystemMessage("You are now being removed from the instance.")
    -- SOURCED (SOE, instance_datatable.tab exit_one = "-3051,0,2611,tatooine"). Height 0 is OURS, NOT SOURCED.
    SceneObject(pPlayer):switchZone("tatooine", -3051, 0, 2611, 0)
  end
end

function tuskenArmy:resetInstance(pPlayer)
  if (pPlayer ~= nil) then
    CreatureObject(pPlayer):sendSystemMessage("The instance has been reset.")
  end
  writeData("tuskenArmy:occupiedState", 0)
  self:destroyArenaContents()
  self:clearEncounterKeys()
  self:spawnPhaseZero()
end

function tuskenArmy:handleVictory(pPlayer)
  self:resetInstance(pPlayer)
  self:ejectAllPlayers(pPlayer)
end
