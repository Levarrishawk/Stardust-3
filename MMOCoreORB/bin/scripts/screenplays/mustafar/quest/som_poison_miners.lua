--[[
Miner Madness  --  som_poison_miners

SOURCE OF RECORD

quest/som_poison_miners.qst in the client TREs, cross-read against
string/en/quest/ground/som_poison_miners.stf. The .stf carries exactly the same
prose as the .qst -- category, journal_entry_title, journal_entry_description,
task01..task06 title/description, task01_waypoint_name and task04_waypoint_name --
and the two agree word for word, so every string, coordinate, radius, count and
name below is quoted from the shipped files and nothing is paraphrased.

The whole task tree is one nested chain, so it is strictly sequential:

	task 0   Nothing            isVisible false
	                            musicOnActivate mus_mustafar_quest_exception.snd
	  task 2   Go to Location   "Travel to the Poisoned Miners' Camp"
	                            mustafar (-5596, 202, 951), Radius 50
	                            createWaypoint true, "Poisoned Miner's Camp"
	                            taskName mustafar_poison_miners_one
	    task 11  Wait for Signal  "Use the Tracking Computer"
	                              Signal Name poison_miners_signal_one
	                              taskName mustafar_poison_miners_two
	      task 12  Wait for Signal  "Wait for Track"
	                                Signal Name poison_miners_signal_two
	                                taskName mustafar_poison_miners_two_b
	        task 9   Go to Location  "Track the Crazed Miners"
	                                 mustafar (-5379, 224, 1766), Radius 25
	                                 createWaypoint true, "Homing Beacon Location"
	                                 taskName mustafar_poison_miners_three
	          task 10  Encounter      "Destroy the Crazed Miners"
	                                  Creature Type som_mustafarian_miner_crazed
	                                  Count 10, Min Distance 20, Max Distance 50
	                                  taskName mustafar_poison_miner_four
	            task 7   Wait for Signal  "Return to Chief Armstrong"
	                                      Signal Name mustafar_poison_miners_reward
	                                      createWaypoint 0
	                                      taskName mustafar_poison_miners_five
	              task 8   Reward           isVisible false
	                                        Bank Credits 0, Experience Amount 0
	                                        lootCount 1, lootName weapon_tow_pistol_02_01
	                                        musicOnComplete mus_mustafar_quest_success.snd

[list]: journalEntryTitle "Miner Madness", category Mustafar, journalVisible true,
allowRepeats true, completeWhenTasksComplete true, Level 70, Tier 4, Type solo,
Experience Type quest_combat with Experience Amount 0, Bank Credits 0.
The stored Experience Amount 0 is real; live still paid, because the server
recomputed from quest_experience (see mustafar_quest_xp.lua).

THREE JOBS, NOT ONE CHAIN

This is one of three Mensix mining jobs looked at together -- som_poison_miners,
som_striking_miners, som_sceismic_charges -- and they are three independent quests,
which is why each got its own file rather than one shared screenplay:

  * every grantQuestOnComplete field in all three .qst files is empty,
  * every prerequisiteTasks field on every task in all three is empty,
  * prerequisiteQuests and exclusionQuests are empty in all three [list] blocks,
  * and a grep of every .qst in _som/quest/ for the three names returns no hit
    outside the three files themselves.

That is the opposite of som_kenobi_symbiosis_1, whose last task is Immediately
Complete Quest with grantQuestOnComplete som_kenobi_symbiosis_2 and which therefore
shares symbiosis.lua with _2. Nothing links these three, so this file follows
symbiosis.lua's one-file-per-player-facing-quest shape rather than
story_arc_prelude.lua's several-.qst-one-file shape.

THE TRACKING COMPUTER  --  attached, not spawned

Task 11's computer is a snapshot prop. snapshot/mustafar.ws in stardust_03.tre
places it and PlanetManagerImplementation::loadSnapshotObject() instantiates each
node with objectID == the node ID, so getSceneObject(<nodeID>) returns the object
the client is already drawing:

	node 12113487  object/tangible/item/som/shared_tracking_computer.iff
	               (-5596.72, h 201.11, 941.55)

That is the only node of that template in the whole snapshot, and it stands 9.5 m
from task 2's waypoint (-5596, 202, 951) -- so the .qst's "The computer is located
inside the base camp of the missing miners" is literally true of this one object.
It is attached to, never respawned, exactly as story_arc_prelude.lua and
symbiosis.lua attach to their snapshot props.

(There is also a registered server template
object/tangible/quest/poison_miner_tracking_computer.iff --
object/custom_content/tangible/quest/poison_miner_tracking_computer.lua, included
from that folder's serverobjects.lua at line 314 -- if a second, spawned computer
is ever wanted somewhere else. It is deliberately not used: the shipped one is
already standing in the right place.)

THE RADIAL WORDING IS THIS FILE'S, AND ONLY THAT

Task 11 is a Wait for Signal, not a Retrieve Item, so it carries no
retrieveMenuText and the shipped data says nothing about how the player fires
poison_miners_signal_one. In live, using the computer object did it. "Use the
tracking computer" below is therefore this file's wording. It is the only invented
string in this screenplay; every other line of text is quoted.

THE TWO AREAS  --  and why the shipped heights are safe to pass through

Tasks 2 and 9 are Go to Location with Radius 50 and Radius 25. Those become
active areas. The .qst stores positions as LocationX / LocationY / LocationZ with
LocationY as the HEIGHT, which maps onto Core3's (x, z, y) argument order as
x = LocationX, z = LocationY, y = LocationZ -- the rule map_exploration.lua
documents. So (-5596, 202, 951) is passed as x -5596, z 202, y 951.

The shipped heights are passed straight through rather than being resolved with
getWorldFloor, because on the ground they cannot break anything: spawnActiveArea
sets a radius and never builds an areaShape (DirectorManager.cpp:3172-3173), and
with areaShape null GroundZoneImplementation.cpp:240,253 and
GroundZoneContainerComponent.cpp:61,73,126 all call the two-float
ActiveArea::containsPoint(px, py) overload, which compares horizontal x/y only
(ActiveAreaImplementation.cpp:24-33). Height is not part of the test on a ground
zone. Keeping the .qst's own numbers therefore costs nothing and keeps them
auditable. hidden_treasure.lua:165 passes its .qst height the same way.

THE CRAZED MINERS  --  substituted creature, quoted numbers

Task 10 names Creature Type som_mustafarian_miner_crazed. No creature template of
that name exists anywhere in this tree -- there is no file for it in
mobile/custom_content/som/ and no includeFile line for it in that folder's
serverobjects.lua -- and no .ws places one, because Encounter creatures were
server-side spawns and that data did not ship.

The stand-in is mustafarian_m_01, which is registered
(mobile/custom_content/som/mustafarian_m_01.lua:41,
CreatureTemplates:addCreatureTemplate(mustafarian_m_01, "mustafarian_m_01")) and is
"a Mustafarian Lava Miner" at level 70 with pvpBitmask ATTACKABLE and optionsBitmask
AIENABLED -- a Mustafarian miner the player can actually fight, at exactly the
[list] Level of this quest, and the same template mensix_facility_region.lua:30-60
already uses for the lava miners downhill from Mensix. The two other candidates were
rejected on the data: mustafarian_miner_01 and mustafarian_miner_02 carry
pvpBitmask NONE with optionsBitmask commented out, so they cannot be killed at all,
and miner_on_strike belongs to the strike camp 3500 m north.

What is NOT substituted is the name on screen: these are ordinary lava miners
wearing a lava miner's name, not "crazed" ones. Adding a real
som_mustafarian_miner_crazed template would mean a new file plus a new line in the
shared mobile/custom_content/som/serverobjects.lua, which is outside this Lua-only,
additive wave. Change encounter.template below and nothing else once that template
exists.

The count and the distances are quoted exactly: 10 miners, spawned 20 to 50 m from
the player, which is what Encounter Count / Min Distance / Max Distance say.

THE GIVER  --  Chief Armstrong, found and placed

An earlier pass of this file said he "does not exist" and left grantQuest and turnIn
hanging with nobody to call them. That was wrong, and it was wrong because the search
was done by name. SOE named this quest's data after the QUEST, not the NPC: his
conversation is miner_madness_chief_drono, and the live spawn row that places him
carries the script name, not "armstrong". Both were there the whole time.

He is now built and placed:

    mobile/custom_content/som/chief_armstrong.lua        the creature template
    mobile/conversations/mustafar/miner_madness_chief_drono.lua   SOE's tree
    .../quest/conversation/miner_madness_chief_drono_conv_handler.lua
    screenplays/mustafar/mensix/mensix_mining_facility_main.lua   the spawn

The spawn is in small_room_05 of the Mensix Mining Facility, cell 12112243, at the
position and heading the live data gives. His display name "Chief Armstrong" is
som_poison_miners.stf task06. His appearance is the one repo choice in the set --
no chief_armstrong model ships anywhere and the live spawn data carries no appearance
column at all, so he wears mustafarian_m_01, the same model this repo already gives
his crew. That single substitution is documented in chief_armstrong.lua itself.

grantQuest and turnIn below are the two entry points his handler calls. Task 7 still
carries createWaypoint 0 and no location, so nothing in this screenplay guesses a
position -- the position came from the live spawn data, not from us.

Everything between those two ends is fully wired and playable: the camp waypoint,
the arrival, the computer, the track, the beacon waypoint, the arrival, the ten
kills and the count.

NO JOURNAL

som_poison_miners has no row in datatables/player/quests.iff -- the table the server
loads is stardust_03.tre's, which wins the TreFiles order in conf/config.lua, and
its only Mustafar rows are the 45 exploration markers. Adding a row would mean
authoring a TRE. Progress therefore lives in persistent screenplay data on the
player, and the journalEntryTitle / journalEntryDescription of each task goes out as
a system message plus a waypoint description, which is the only channel left. Every
task of this quest says showSystemMessages true, so that is also what the shipped
data asks for.

THE REWARD  --  substituted, and the obvious substitute is deliberately refused

Task 8 pays Bank Credits 0 and Experience Amount 0, so the item is the whole
reward: lootCount 1, lootName weapon_tow_pistol_02_01. As with every other TOW
reward in this arc, that is a live server-side static-item name and not itself an
object-template path. The name resolves to "Mustafarian Modified Disruptor Pistol"
in string/en/static_item_n.stf, and unlike most of this arc an object carrying
that exact objectName does ship --
object/tangible/collection/shared_rare_pistol_mustafarian_modified_disruptor.iff
(and its server pair) -- but it is a non-functional display tangible
(SharedTangibleObjectTemplate, gameObjectType = 8211, no damage, no attackSpeed,
no xpType, no cert). Swapping the working pistol granted below for that display
piece would pay the quest out in an ornament the player cannot fire, and that is
not a choice anyone needs to make -- a reward that cannot be used is a defect.
The name-exact object is therefore refused on purpose and the reward stays a
substitution matched by description: a pistol, from Trials of Obi-Wan.

The obvious Mustafar-flavoured match is object/weapon/ranged/pistol/
som_disruptor_pistol.iff or som_ion_relic_pistol.iff. When this arc was written
both were refused on the data: their templates carried minDamage 99999999998 /
maxDamage 99999999999 / attackSpeed 1 -- the blue-frog placeholder values Core3
ships for templates whose real numbers are meant to come out of loot generation --
and they declared xpType combat_rangedspecialize_carbine and cert_carbine_cdef on
a pistol. giveItem() creates the object exactly as the template describes it, so
handing one of those over would have put a one-shot god pistol in a player's
inventory.

Both defects have since been corrected: the cert and xpType in commit 3f787292ca,
and the stats in the SoM ranged weapon pass (som_disruptor_pistol 257-513,
som_ion_relic_pistol 264-527, attackSpeed 3, maxRange 35, taken from the live
weapon_stats.tab rows weapon_tow_pistol_04_03 and
weapon_tow_pistol_ion_relic_05_01). So the original grounds for the refusal are
gone, and the reward is now som_disruptor_pistol.

That used to read "an open decision for Aaron". It was not a decision -- it was a
measurement nobody had taken. Taken now, against the live table
datatables/item/master_item/weapon_stats.tab:

	weapon_tow_pistol_02_01   244-488   tier 12   actual_dps 915   <- what this
	                                                                  quest pays
	som_disruptor_pistol      257-513   (weapon_tow_pistol_04_03, actual_dps 963)
	pistol_dl44                20-90

The whole TOW pistol family is one tier and one narrow band -- rows 90-99 run
235-470 to 264-527, every one tier_granted 12, target_dps 938. som_disruptor_pistol
lands 5% above the row this quest actually pays. pistol_dl44 lands an order of
magnitude below it, so the old reward was not a conservative substitute; it was
the wrong tier of weapon entirely, and a level-capped reward quest paid out
starter gear.

It is also what the arc already does elsewhere: symbiosis.lua grants
som_sword_obsidian for its own TOW melee reward rather than a generic blade. The
two now agree.

The pistol handed over is therefore object/weapon/ranged/pistol/som_disruptor_pistol.iff
(object/custom_content/weapon/ranged/som_disruptor_pistol.lua: minDamage 257,
maxDamage 513, attackSpeed 3, maxRange 35, xpType combat_rangedspecialize_pistol,
cert_pistol_cdef), registered with addTemplate at the end of that file and included
from custom_content/weapon/ranged/serverobjects.lua:155.

historian.lua:246-256 still hands out pistol_dl44, and that stays right: its
shipped reward says only "a pistol" with no live stats row behind it. This one
names a specific TOW pistol and has a row, so it is matched to the row.

It goes over with giveItem() into the player's inventory, which creates the object
for real. This is deliberately NOT addRewardedSchematic, which fails closed when
the path is not in scripts/managers/crafting/schematics.lua and would silently
grant nothing -- the defect hidden_treasure.lua's reward had to be corrected for.

If a closer match than som_disruptor_pistol is ever built -- a template cut to
weapon_tow_pistol_02_01's own 244-488 rather than 04_03's 257-513 -- only
rewardItem below changes. Nothing else in this file reads the reward path.

REPEATS

[list] allowRepeats true, so payout resets the player to un-started and keeps a run
count, the same way bounty_hunts.lua treats its own allowRepeats flag. Nothing here
refuses a second run.

THE LEVEL GATE

[list] Level 70, and grantQuest refuses a player below it -- because for this quest
the .qst number is the only number there is.

A .qst [list] level is a client-side display value, not a gate. The Mustafar quests
that are really gated -- collectors_business, cursed_shard, moral_choice -- are each
gated in the giver's server-side conversation, which tests level against 60, so all
three enforce 61 and ignore the 75 their .qst displays. This quest has no giver
carrying a level test, so nothing contradicts the 70 and there is nothing better to
put in its place.

That makes this the fallback case, not a precedent for trusting a [list] level. If
Aaron would rather the level be advisory, minimumLevel below is the single number to
change.

WHAT IS NOT MODELLED

  * Task 12, "Wait for Track", has no Timer task under it and no duration field
    anywhere in the .qst, yet its own text says "wait for it to return the location
    of the miners". A wait with no shipped length. trackDelay below is this file's
    number, 10 seconds, and it is the only number in this file that is not quoted.
  * Task 0's musicOnActivate cannot play on grant if no giver calls grantQuest, so
    it plays inside grantQuest itself rather than at some invented trigger.
  * Faction Name "Rebel" appears on the Reward task and in the [list], but Faction
    Amount is 0, so no faction is awarded. The name is the .qst editor's default
    with nothing behind it.
  * The [list] Experience Type quest_combat with Experience Amount 0 is journal-level
    data that only the quest system awards. There is no quest system row here and
    the amount is zero either way, so nothing is invented to stand in for it.
    The stored Experience Amount 0 is real; live still paid, because the server
    recomputed from quest_experience (see mustafar_quest_xp.lua).
--]]

somPoisonMinersScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "somPoisonMinersScreenPlay",

	-- [list] journalEntryTitle / journalEntryDescription.
	questTitle = "Miner Madness",
	questDescription = "Trilom gas emissions are a constant source of danger for miners on Mustafar. This deadly gas causes paranoia, dementia, and eventually, agonizing death. Armstrong discovered that one of his mining crews hit a pocket of this gas. There is no cure for Trilom poisoning, and the affected miners need to be destroyed before they can cause harm to others.",

	-- [list] Level 70. See THE LEVEL GATE.
	minimumLevel = 70,

	-- task 0 musicOnActivate and task 8 musicOnComplete. "exception" is what the
	-- shipped file says on the activate leg; quoted, not corrected.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst. The counter tick has no shipped sound; this is the one
	-- map_exploration.lua:412 and bounty_hunts.lua use for their own hunt ticks.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	-- task 2, Go to Location: mustafar (-5596, 202, 951), Radius 50,
	-- waypointName "Poisoned Miner's Camp".
	camp = {
		x = -5596, z = 202, y = 951, radius = 50,
		waypointName = "Poisoned Miner's Camp",
	},

	-- task 9, Go to Location: mustafar (-5379, 224, 1766), Radius 25,
	-- waypointName "Homing Beacon Location".
	beacon = {
		x = -5379, z = 224, y = 1766, radius = 25,
		waypointName = "Homing Beacon Location",
	},

	-- Snapshot node; see THE TRACKING COMPUTER.
	trackingComputerNodeID = 12113487,

	-- task 10, Encounter. Count / Min Distance / Max Distance are quoted; the
	-- template is substituted for som_mustafarian_miner_crazed, see THE CRAZED
	-- MINERS.
	encounter = {
		template = "mustafarian_m_01",
		count = 10,
		minDistance = 20,
		maxDistance = 50,
	},

	-- NOT SHIPPED. See WHAT IS NOT MODELLED -- the .qst has no timer between
	-- poison_miners_signal_one and poison_miners_signal_two.
	trackDelay = 10,

	-- task 8: Bank Credits 0, Experience Amount 0.
	rewardCredits = 0,
	-- Matched to the .qst's weapon_tow_pistol_02_01 (244-488, tier 12) by the
	-- weapon_stats.tab row som_disruptor_pistol comes from; see THE REWARD.
	rewardItem = "object/weapon/ranged/pistol/som_disruptor_pistol.iff",

	campAreaID = 0,
	beaconAreaID = 0,
}

registerScreenPlay("somPoisonMinersScreenPlay", true)

function somPoisonMinersScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachTrackingComputer()
		self:spawnAreas()
	end
end

function somPoisonMinersScreenPlay:attachTrackingComputer()
	local pComputer = getSceneObject(self.trackingComputerNodeID)

	if (pComputer == nil) then
		print("somPoisonMinersScreenPlay: snapshot object " .. self.trackingComputerNodeID .. " (tracking computer) was not found; the tracking step will be unreachable")
		return
	end

	writeStringData(self.trackingComputerNodeID .. ":somPoisonMinersRole", "computer")
	SceneObject(pComputer):setObjectMenuComponent("SomPoisonMinersMenuComponent")
end

function somPoisonMinersScreenPlay:spawnAreas()
	local pCampArea = spawnActiveArea("mustafar", "object/active_area.iff", self.camp.x, self.camp.z, self.camp.y, self.camp.radius, 0)

	if (pCampArea == nil) then
		print("somPoisonMinersScreenPlay: failed to spawn the poisoned miners' camp area")
	else
		self.campAreaID = SceneObject(pCampArea):getObjectID()
		createObserver(ENTEREDAREA, "somPoisonMinersScreenPlay", "notifyEnteredCamp", pCampArea)
	end

	local pBeaconArea = spawnActiveArea("mustafar", "object/active_area.iff", self.beacon.x, self.beacon.z, self.beacon.y, self.beacon.radius, 0)

	if (pBeaconArea == nil) then
		print("somPoisonMinersScreenPlay: failed to spawn the homing beacon area")
	else
		self.beaconAreaID = SceneObject(pBeaconArea):getObjectID()
		createObserver(ENTEREDAREA, "somPoisonMinersScreenPlay", "notifyEnteredBeacon", pBeaconArea)
	end
end

--[[ State

Persistent screenplay data on the player, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage   0  not granted
	        1  granted, travelling to the camp                 (task 2)
	        2  at the camp, the computer is waiting to be used (task 11)
	        3  the computer is running                         (task 12)
	        4  the track came back, travelling to the beacon   (task 9)
	        5  at the beacon, killing the ten miners           (task 10)
	        6  the ten are dead, reporting back to Armstrong   (task 7)
	kills   crazed miners killed this run, 0-10
	runs    times this player has been paid; allowRepeats true, so this only counts
	wp      waypoint id currently handed out, 0 if none
--]]

somPoisonMinersScreenPlay.STAGE_NONE = 0
somPoisonMinersScreenPlay.STAGE_TRAVEL_CAMP = 1
somPoisonMinersScreenPlay.STAGE_USE_COMPUTER = 2
somPoisonMinersScreenPlay.STAGE_TRACKING = 3
somPoisonMinersScreenPlay.STAGE_TRAVEL_BEACON = 4
somPoisonMinersScreenPlay.STAGE_HUNT = 5
somPoisonMinersScreenPlay.STAGE_REPORT = 6

function somPoisonMinersScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function somPoisonMinersScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function somPoisonMinersScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

-- How many times this player has finished and been paid. A giver can use it to
-- tell a first-timer from a regular.
function somPoisonMinersScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function somPoisonMinersScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function somPoisonMinersScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

--[[ Entry points for the giver

Chief Armstrong.  He is live-sourced on all three counts:

  * NAME -- som_poison_miners.stf task06 calls him "Chief Armstrong".
  * TREE -- SOE's own conversation/miner_madness_chief_drono.java, rebuilt node
    for node at mobile/conversations/mustafar/miner_madness_chief_drono.lua.
  * PLACE -- the live spawn table puts som_chief_armstrong in small_room_05 of
    the Mensix Mining Facility at -150, 18.6, -61, facing 0.  He is spawned
    there by mensix_mining_facility_main.lua.

miner_madness_chief_drono_conv_handler calls the three functions below, from
exactly the screens SOE hung the side effects on.  Only his APPEARANCE is a repo
choice -- no chief_armstrong.iff ships; see the header of
mobile/custom_content/som/chief_armstrong.lua.
--]]

-- Task 0 firing: musicOnActivate, then task 2 becomes the live step.
function somPoisonMinersScreenPlay:grantQuest(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_NONE) then
		return false
	end

	if (CreatureObject(pPlayer):getScreenPlayState("somPoisonMinersBlocked") ~= 0) then
		return false
	end

	-- [list] Level 70.
	if (CreatureObject(pPlayer):getLevel() < self.minimumLevel) then
		return false
	end

	self:setStage(pPlayer, self.STAGE_TRAVEL_CAMP)
	writeScreenPlayData(pPlayer, self.screenplayName, "kills", "0")

	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)
	CreatureObject(pPlayer):sendSystemMessage(self.questDescription)

	-- task 2 journalEntryDescription, and its createWaypoint true /
	-- waypointName "Poisoned Miner's Camp".
	CreatureObject(pPlayer):sendSystemMessage("All Mustafarian miners are equipped with a homing device to help find them in case of an emergency. These devices send a signal back to a computer that is located in the base camp. Armstrong has given you directions to the main camp. From there you can use the computer to find the miners.")
	self:giveWaypoint(pPlayer, self.camp.waypointName, "Travel to the Poisoned Miners' Camp", self.camp.x, self.camp.y)

	return true
end

-- Task 7's signal, mustafar_poison_miners_reward: the hand-in at Chief Armstrong.
function somPoisonMinersScreenPlay:turnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_REPORT) then
		return false
	end

	self:giveReward(pPlayer)

	return true
end

--[[ The stuck player's retry, s_54 -> s_55

SOE's script runs groundquests.clearQuest then groundquests.grantQuest on
"som_poison_miners" back to back, which drops the player to un-started and hands
the job straight back so the tracking computer can be used again from the top.
This is that pair, in that order.  It is deliberately NOT a partial rewind: the
kill counter and the waypoint go with it, exactly as a clear would take them.
--]]
function somPoisonMinersScreenPlay:regrantQuest(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) == self.STAGE_NONE) then
		return false
	end

	self:removeWaypoint(pPlayer)
	self:setStage(pPlayer, self.STAGE_NONE)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")

	return self:grantQuest(pPlayer)
end

--[[ task 2  --  Go to Location, Radius 50 ]]

function somPoisonMinersScreenPlay:notifyEnteredCamp(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (SceneObject(pArea):getObjectID() ~= self.campAreaID or self:getStage(pPlayer) ~= self.STAGE_TRAVEL_CAMP) then
		return 0
	end

	self:setStage(pPlayer, self.STAGE_USE_COMPUTER)
	self:removeWaypoint(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)

	-- task 11 journalEntryDescription.
	CreatureObject(pPlayer):sendSystemMessage("The computer is located inside the base camp of the missing miners. Use the computer to track down where they have went.")

	return 0
end

--[[ task 11  --  poison_miners_signal_one, fired off the computer's radial ]]

function somPoisonMinersScreenPlay:useTrackingComputer(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_USE_COMPUTER) then
		return
	end

	self:setStage(pPlayer, self.STAGE_TRACKING)

	-- task 12 journalEntryDescription.
	CreatureObject(pPlayer):sendSystemMessage("Now that the computer is active, wait for it to return the location of the miners.")

	-- trackDelay is this file's number; the .qst has no timer here.
	createEvent(self.trackDelay * 1000, "somPoisonMinersScreenPlay", "trackReturned", pPlayer, "")
end

--[[ task 12  --  poison_miners_signal_two, the computer answering ]]

function somPoisonMinersScreenPlay:trackReturned(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_TRACKING) then
		return
	end

	self:setStage(pPlayer, self.STAGE_TRAVEL_BEACON)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)

	-- task 9 journalEntryDescription, and its createWaypoint true /
	-- waypointName "Homing Beacon Location".
	CreatureObject(pPlayer):sendSystemMessage("The tracking computer directed you where to find the miners.")
	self:giveWaypoint(pPlayer, self.beacon.waypointName, "Track the Crazed Miners", self.beacon.x, self.beacon.y)
end

--[[ task 9 and task 10  --  arrive, then fight ten ]]

function somPoisonMinersScreenPlay:notifyEnteredBeacon(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (SceneObject(pArea):getObjectID() ~= self.beaconAreaID or self:getStage(pPlayer) ~= self.STAGE_TRAVEL_BEACON) then
		return 0
	end

	self:setStage(pPlayer, self.STAGE_HUNT)
	self:removeWaypoint(pPlayer)
	writeScreenPlayData(pPlayer, self.screenplayName, "kills", "0")

	-- task 10 journalEntryDescription.
	CreatureObject(pPlayer):sendSystemMessage("The Trilom gas has made the miners extremely dangerous and unpredictable. Eventually the affected miners will suffer from an agonizing death. Since there is no cure for Trilom poisoning the best thing that can be done for the miners is to put them out of their misery.")

	-- Persistence 1 so kill credit survives a logout, the same call
	-- kenobi_spine.lua:1075 and reunite_shard.lua make for the same reason.
	createObserver(KILLEDCREATURE, "somPoisonMinersScreenPlay", "notifyKilledCreature", pPlayer, 1)

	self:spawnEncounter(pPlayer)

	return 0
end

-- task 10: Count 10, Min Distance 20, Max Distance 50.
function somPoisonMinersScreenPlay:spawnEncounter(pPlayer)
	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()

	for i = 1, self.encounter.count do
		local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, self.encounter.minDistance, self.encounter.maxDistance, true)

		if (spawnPoint == nil) then
			print("somPoisonMinersScreenPlay: no spawn point near the player for " .. self.encounter.template)
		else
			local pMiner = spawnMobile("mustafar", self.encounter.template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

			if (pMiner == nil) then
				print("somPoisonMinersScreenPlay: failed to spawn " .. self.encounter.template)
			else
				AiAgent(pMiner):setDefender(pPlayer)
			end
		end
	end
end

function somPoisonMinersScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil or self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return 0
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil or victimTemplate ~= self.encounter.template) then
		return 0
	end

	local killed = self:getKills(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(killed))

	if (killed < self.encounter.count) then
		CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
		CreatureObject(pPlayer):sendSystemMessage("Crazed miners destroyed: " .. killed .. "/" .. self.encounter.count)

		return 0
	end

	self:setStage(pPlayer, self.STAGE_REPORT)
	dropObserver(KILLEDCREATURE, "somPoisonMinersScreenPlay", "notifyKilledCreature", pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)

	-- task 7 journalEntryDescription. createWaypoint is 0 on that task and nothing
	-- ships Chief Armstrong's position, so no waypoint is handed out here.
	CreatureObject(pPlayer):sendSystemMessage("Report back to Chief Armstrong about the deaths of the miners.")

	return 0
end

--[[ task 8  --  Reward ]]

function somPoisonMinersScreenPlay:giveReward(pPlayer)
	-- Bank Credits 0 on the Reward task, so nothing is paid. The branch is kept so
	-- that correcting rewardCredits is the only change needed if Aaron rules
	-- otherwise.
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
		CreatureObject(pPlayer):sendSystemMessage("You have received " .. self.rewardCredits .. " credits.")
	end

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("somPoisonMinersScreenPlay: player has no inventory; the reward could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		print("somPoisonMinersScreenPlay: failed to create " .. self.rewardItem)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for Chief Armstrong's reward.")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have received a pistol from Chief Armstrong.")
	end

	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	-- Quest XP: quest_experience[70][TIER_4]. See mustafar_quest_xp.lua.
	-- Before closeOut: closeOut resets the stage.
	MustafarQuestXp:award(pPlayer, "som_poison_miners")

	self:closeOut(pPlayer)
end

-- [list] allowRepeats true: the run count goes up and the player is reset to
-- un-started so the job can be taken again.
function somPoisonMinersScreenPlay:closeOut(pPlayer)
	local runs = self:getRuns(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(runs))

	self:removeWaypoint(pPlayer)
	self:setStage(pPlayer, self.STAGE_NONE)

	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
end

--[[ Radial dispatch

SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely -- so
fillObjectMenuResponse has to add every item we want to see, and adds nothing at
all when this player has no business touching the computer.
--]]

SomPoisonMinersMenuComponent = {}

function SomPoisonMinersMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":somPoisonMinersRole")

	if (role ~= "computer") then
		return
	end

	if (somPoisonMinersScreenPlay:getStage(pPlayer) ~= somPoisonMinersScreenPlay.STAGE_USE_COMPUTER) then
		return
	end

	-- Not a shipped string; see THE RADIAL WORDING IS THIS FILE'S.
	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "Use the tracking computer")
end

function SomPoisonMinersMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":somPoisonMinersRole")

	if (role == "computer") then
		somPoisonMinersScreenPlay:useTrackingComputer(pPlayer)
	end

	return 0
end
