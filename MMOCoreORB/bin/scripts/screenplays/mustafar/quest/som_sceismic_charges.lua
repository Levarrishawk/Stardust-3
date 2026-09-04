--[[
Seismic Charges  --  som_sceismic_charges

(SOE's own spelling of the filename is "sceismic". The quest id is kept exactly
as it ships. The journal title inside the same file spells it "Seismic Charges",
correctly. Both are quoted as they are.)

SOURCE OF RECORD

quest/som_sceismic_charges.qst in the client TREs, cross-read against
string/en/quest/ground/som_sceismic_charges.stf.

THIS QUEST DID NOT SHIP FINISHED, AND THAT IS THE WHOLE FINDING

The .stf is three strings long. Dumped, it contains exactly:

	category                    "Mustafar"
	journal_entry_title         "Seismic Charges"
	journal_entry_description   "The miners often use seismic charges ..."

There is no task01_*, no task02_*, no waypoint name, no item name, no retrieve
menu text -- none of the per-task keys the sibling files
som_poison_miners.stf and som_striking_miners.stf both carry. The string table
for the tasks was never written because the tasks were never filled in.

The .qst agrees. Every task exists as an empty shell. Transcribed in full, with
every non-empty field shown -- and everything not shown below is the empty
string, 0, or the editor's default of Planet "tatooine" at 0.0 / 0.0 / 0.0:

	task 0   Nothing         isVisible true
	                         -- no music, no location, no name
	  task 1   Retrieve Item   Count 1, LootDropPercent 100
	  task 2   Retrieve Item   Count 1, LootDropPercent 100
	  task 3   Retrieve Item   Count 1, LootDropPercent 100
	    task 6   Encounter       Count 1, Min Distance 5, Max Distance 50
	                             Spawn Offset Location X 0.0 / Z 0.0
	                             Creature Type EMPTY
	  task 4   Retrieve Item   Count 1, LootDropPercent 100
	  task 5   Retrieve Item   Count 1, LootDropPercent 100
	  task 7   Retrieve Item   Count 1, LootDropPercent 100
	  task 8   Wait for Tasks  Task1..Task6 Quest Filename EMPTY
	                           Task1..Task6 taskName        EMPTY
	                           Task1..Task6 Display String  EMPTY
	    task 9   Wait for Signal  Signal Name EMPTY
	      task 10  Reward           Bank Credits 0
	                                Experience Amount 0
	                                Faction Name "Rebel", Faction Amount 0
	                                no Item, no Weapon, no Armor
	                                no lootCount / lootName fields at all

Not one Retrieve Item carries a Server Object Template, an ItemName or a
retrieveMenuText. The Encounter carries no Creature Type. The Wait for Signal
carries no Signal Name. The Reward pays nothing and its loot fields are not just
empty -- unlike the other two quests, they are absent from the file.

The [list] is the only populated part of the whole quest, and it is shorter than
its siblings' too. In full, it is ten fields:

	journalEntryTitle        "Seismic Charges"
	journalEntryDescription  "The miners often use seismic charges to help find
	                          locations for good resources that are under the
	                          surface. They have already set up the locations
	                          where they want to explode the charges but they
	                          need someone to actually set off the charges.
	                          Travel around to the different locations and set
	                          off the explosives."
	category                 "Mustafar"
	journalVisible           true
	prerequisiteQuests       (empty)
	exclusionQuests          (empty)
	allowRepeats             true
	target                   (empty)
	parameter                (empty)
	completeWhenTasksComplete true

There is NO Level, NO Tier, NO Type, NO Experience Type, NO Bank Credits and no
loot block -- all of which som_poison_miners and som_striking_miners do carry.
So this quest has no level gate to enforce and no difficulty to state, and none
is invented here.

WHAT THE SHAPE STILL TELLS US, AND WHERE THAT STOPS

Two things are readable from the structure even though every field is blank, and
they are recorded because they are structure, not guesswork:

  * SIX Retrieve Item tasks -- ids 1, 2, 3, 4, 5 and 7 -- all siblings under
    task 0, each Count 1, then a gate that opens when all six are done. That
    matches the [list] prose's "Travel around to the different locations and set
    off the explosives".

    (An earlier draft of this header offered a second reason: that the Wait for
    Tasks carries "exactly SIX Task<n> slots". That is not evidence and the
    claim is withdrawn. TASK_QUEST_NAME_1..6 / TASK_TASK_NAME_1..6 /
    TASK_DISPLAY_STRING_1..6 is a fixed six-slot schema emitted for ANY quest
    containing a wait_for_tasks task -- checked against three unrelated quests,
    axkva_min_intro.tab, borvo_acklay_biceps.tab and borvo_acklay_boots_gloves.tab,
    all six columns on every one. Here all six are empty; this gate waits on
    nothing. The count of six stands on the retrieve tasks above and on task 0's
    TASKS_ON_COMPLETE=[1,2,3,5,6,7,8] in the live server table, which is a real
    field with real contents.)
  * One Encounter hanging off the THIRD charge only, Count 1, 5 to 50 m. One
    location was going to bite back.

Where it stops: WHICH six locations, WHAT object the player uses, WHAT creature
attacks, and WHAT the reward is are all absent. There is no coordinate anywhere
in this file. Every LocationX / LocationY / LocationZ in it is 0.0 on Planet
"tatooine", which is the .qst editor's unset default and not a position.

NOTHING IS PLACED, BECAUSE NOTHING WAS SHIPPED TO PLACE

The world data does not fill the gap either, and the search is recorded so
nobody repeats it:

  * There IS a registered server template for the prop --
    object/tangible/quest/seismic_charge_stations.iff, registered at
    object/custom_content/tangible/quest/seismic_charge_stations.lua:5 on the
    client template object/tangible/quest/shared_seismic_charge_stations.iff
    (object/custom_content/tangible/quest/objects.lua:2492-2496), included from
    that folder's serverobjects.lua:330. The name is plural: "charge stations".
  * But NOTHING places it. The mustafar world snapshot carries no node of that
    template. Both TREs that ship a snapshot/mustafar.ws with content were
    dumped -- stardust_03.tre (354 templates, 5947 nodes) and mtg_patch_023.tre
    (404 templates, 5929 nodes) -- and neither template list contains
    shared_seismic_charge_stations, or anything else matching charge / explos /
    seism / detona / bomb. The only near-misses in either list are
    object/static/particle/shared_pt_sparking_blast_md.iff and
    object/static/item/shared_item_comp_blaster_cannon.iff, which are unrelated
    scenery.
  * Nothing in the scripts tree spawns it either: the only hits for
    seismic_charge_stations are the two template files above and the
    serverobjects.lua include.

So the six locations the [list] says the miners "have already set up" were never
set up in any data this port can read. This file places nothing, invents no
coordinate, no creature, no item and no credit figure, and instead carries the
two strings that DID ship plus the seams a placement pass would call.

THIS QUEST WAS NEVER PLAYABLE ON LIVE EITHER -- THE FIVE GAPS ARE CLOSED

An earlier version of this header listed five items under "WHAT AARON HAS TO
RULE BEFORE THIS CAN BE PLAYED". That framing was wrong. They were never
Aaron's to rule -- they were an unfinished search. The search has now been run
against the live server source (SWG-Source/dsrc), against a fourth Mustafar
snapshot nobody had dumped, and against the public record. Four of the five have
hard answers and the fifth is a proven negative. Nothing here is waiting on a
decision.

  1. WHERE the six charge stations stand -- NOWHERE, on four independent
     authorities. (a) The live compiled task table
     datatables/questtask/quest/som_sceismic_charges.tab carries
     PLANET_NAME=tatooine, LOCATION_X/Y/Z=0.0 on every row -- a separate source
     from the client .qst, and it agrees. (b) The twelve live server buildout
     tables for this planet (mustafar_main_ne/nw/se/sw, mustafar_volcano,
     obiwan_crystal_cave, sher_kar_cave, uplink_cave, old_republic_facility,
     decrepit_droid_factory, working_droid_factory, mustafar_droid_army) DO place
     quest tangibles -- tulrus_egg x10, must_chem_locker x5,
     must_ventilation_station x4, som_mining_marker_01..05, som_vault_lever --
     and seismic_charge_stations is in none of them. (c) A grep for
     "seismic_charge_stations" over the whole live server source returns exactly
     one file: the template object/tangible/quest/seismic_charge_stations.tpf
     itself. Nothing places it, spawns it or names it. (d) The fourth snapshot,
     "snapshot/mustafar se.ws" in mtg_planets.tre (68,074 bytes, 127 templates,
     711 nodes), was extracted and dumped -- no shared_seismic_charge_stations.
     It carries the som_mining_marker_01..05 quest markers, so it is exactly the
     kind of file that would have held them.
  2. WHAT the player does at one -- ON LIVE, NOTHING. The station's .tpf attaches
     the script quest.task.ground.retrieve_item_on_item, whose OnObjectMenuRequest
     only adds the quest verb when groundquests.playerNeedsToRetrieveThisItem
     returns true. That function (groundquests.java:1292) requires the task's
     SERVER_TEMPLATE field to equal the item's template. SERVER_TEMPLATE is empty
     on every retrieve row of this quest, so it can never match, the quest verb is
     never added, and the only radial the live station ever had is the script's
     base menu_info_types.ITEM_USE -- plain "Use". The station does have a shipped
     NAME: @som/som_item:seismic_charge_station, "Seismic Charge Station".
     stationMenuText below is still this file's own wording. It is the one
     invented string here, it replaces a live default of "Use", and it stays
     because "Use" is worse, not because anyone must choose.
  3. WHAT attacks at the third one -- UNSHIPPED, confirmed twice. The live table's
     encounter row carries CREATURE_TYPE=[] with COUNT=[1], MIN_DISTANCE=[5],
     MAX_DISTANCE=[50]: the same blank as the client .qst, from an independent
     source. The "third station" reading is now confirmed rather than inferred --
     in the live table the encounter is task id 4 and it is activated by
     TASKS_ON_COMPLETE=[4] on the third retrieve item, id 3. stationWithAmbush = 3
     is right. ambush.template stays the empty string and spawnAmbush refuses to
     run rather than substituting a creature nobody chose.
  4. WHAT the reward is -- ZERO, and that is the live value. The live reward row
     reads EXPERIENCE_TYPE=[] EXPERIENCE_AMOUNT=[0] FACTION_NAME=[Rebel]
     FACTION_AMOUNT=[0] BANK_CREDITS=[0] ITEM=[] WEAPON=[] ARMOR=[]. The live
     questlist row carries no level, tier, type, XP or credit block at all.
     rewardCredits = 0 below is not a placeholder; it is the shipped figure.
  5. WHO gives it -- NOBODY, and the method is proven rather than assumed. No
     .java in the live server source mentions som_sceismic_charges: no grantQuest,
     no isQuestActive, no hasCompletedQuest. The same grep finds both siblings'
     givers immediately, so it is known-good --
     script/conversation/miner_madness_chief_drono.java:33 grants som_poison_miners
     and script/conversation/striking_miners_urst.java:33 grants som_striking_miners.
     This quest exists as a CRC (quest_crc_string_table.tab:1343, 0x7dd11d67), a
     compiled table of empty tasks, three strings and one unplaced prop. Nothing
     in the shipped game could hand it out. (One false lead, recorded so it is not
     chased again: unaccepted_quests.tab:389 lists it -- but that table has 1,386
     rows including 74 of the 76 som_ quests, and nothing in this server reads it.)

The public record agrees. The journal string "The miners often use seismic
charges to help find locations for good resources" returns zero hits anywhere.
All 43 quests in the SWG wiki's Mustafar category were enumerated and there is no
"Seismic Charges" entry; the S section runs Salvage or Die, Sher Kar, Sickness of
the Storm Lord, Skin the Blistmoks, Skull of the Jundak, Supplies for the Miners,
Symbiosis, Symbols of Chu-Gon Dar. No guide, wiki or forum ever transcribed it,
because nobody could ever play it.

So this file is complete as content: it is a faithful port of a quest SOE shipped
unfinished. grantQuest, registerStation, spawnAmbush and turnIn below are a
working quest waiting on six coordinates that were never authored. If those
coordinates are ever invented, they are new design, not restoration, and they
belong in a placement pass that says so.

NO JOURNAL

som_sceismic_charges has no row in datatables/player/quests.iff. That table
dumps to 45 som_ rows and every one of them is an exploration marker
(som_berkens_flow, som_burning_plains, som_central_volcano, som_crystal_flats,
som_mining_field, som_nesting_grounds, som_smoking_forest and their _markers /
_markers_01..05 children); none of the three mining jobs is in it. Adding a row
would mean authoring a TRE. Progress therefore lives in persistent screenplay
data on the player and the [list] prose goes out as a system message, which is
the only channel left.

Note that unlike its two siblings, every task in THIS quest carries
showSystemMessages 0. There is no per-task text to send anyway.

REPEATS

[list] allowRepeats true, so payout resets the player to un-started, clears the
six per-station flags and keeps a run count, the same way bounty_hunts.lua
treats its own allowRepeats flag.
--]]

somSceismicChargesScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "somSceismicChargesScreenPlay",

	-- [list] journalEntryTitle / journalEntryDescription. These two strings and
	-- the category are the entire shipped text of this quest.
	questTitle = "Seismic Charges",
	questDescription = "The miners often use seismic charges to help find locations for good resources that are under the surface. They have already set up the locations where they want to explode the charges but they need someone to actually set off the charges. Travel around to the different locations and set off the explosives.",

	-- Six Retrieve Item tasks, ids 1, 2, 3, 4, 5, 7, each Count 1, and a Wait
	-- for Tasks with six Task<n> slots. The COUNT is read off the file's
	-- structure; every field inside those six tasks is empty.
	stationCount = 6,

	-- The Encounter, task 6, hangs off the third Retrieve Item (id 3) only.
	stationWithAmbush = 3,

	-- The prop the quest is about. NOT from the .qst -- the .qst's Server Object
	-- Template fields are all empty. This is the registered template that
	-- matches the quest by name, recorded so a placement pass has it to hand.
	-- See NOTHING IS PLACED: nothing in the world snapshot uses it.
	stationTemplate = "object/tangible/quest/seismic_charge_stations.iff",

	-- task 6, Encounter. Count / Min Distance / Max Distance are quoted exactly;
	-- Creature Type shipped EMPTY and is left empty on purpose -- see finding 3
	-- in the header: the live table's encounter row carries CREATURE_TYPE=[] too,
	-- so nothing was ever specified here by anyone. spawnAmbush refuses to run
	-- rather than substitute a creature the shipped data never named.
	ambush = {
		template = "",
		count = 1,
		minDistance = 5,
		maxDistance = 50,
	},

	-- task 10, Reward: Bank Credits 0, Experience Amount 0, no loot fields in
	-- the file at all. Nothing is invented to stand in for that.
	rewardCredits = 0,
	rewardItem = "",

	-- Not shipped -- the Retrieve Item tasks carry no retrieveMenuText, and on
	-- live the quest verb never appeared at all (header, finding 2). This is the
	-- one invented string in this file. It stands in for a live default of "Use".
	stationMenuText = "Set off the seismic charge",

	-- Filled by registerStation(): object id -> station number, 1 to
	-- stationCount. Empty until something places the stations.
	stationByObjectID = {},
}

registerScreenPlay("somSceismicChargesScreenPlay", true)

-- Places nothing. There is nothing shipped to place; see NOTHING IS PLACED.
-- The zone guard is kept so this reads like its siblings and so that attaching
-- to stations later is a one-line change here.
function somSceismicChargesScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self.stationByObjectID = {}
	end
end

--[[ State

Persistent screenplay data on the player, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0".

	stage        0  not granted
	             1  granted, setting off the six charges  (tasks 1-5, 7)
	             2  all six done, waiting on the hand-in  (tasks 8, 9)
	fired        charges set off this run, 0-6
	station_<n>  1 once station n has been set off this run
	runs         times this player has been paid; allowRepeats true, so this only
	             counts
--]]

somSceismicChargesScreenPlay.STAGE_NONE = 0
somSceismicChargesScreenPlay.STAGE_SET_CHARGES = 1
somSceismicChargesScreenPlay.STAGE_REPORT = 2

function somSceismicChargesScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function somSceismicChargesScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function somSceismicChargesScreenPlay:getFired(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "fired")) or 0
end

function somSceismicChargesScreenPlay:hasFiredStation(pPlayer, station)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "station_" .. station)) == 1
end

function somSceismicChargesScreenPlay:clearStations(pPlayer)
	writeScreenPlayData(pPlayer, self.screenplayName, "fired", "0")

	for i = 1, self.stationCount do
		deleteScreenPlayData(pPlayer, self.screenplayName, "station_" .. i)
	end
end

-- How many times this player has finished and been paid. A giver can use it to
-- tell a first-timer from a regular.
function somSceismicChargesScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

--[[ Entry points for a giver

Nobody is named as the giver anywhere in the shipped data, and no .java in the
live server source grants this quest either -- header, finding 5. There is no
giver to find. These two are what a giver's conversation handler would call if
one is ever written, in the same shape bounty_hunts.lua uses for its giver-less
hunts.
--]]

-- Task 0 firing. It carries no musicOnActivate, so nothing is played -- unlike
-- its two sibling quests, which both do carry one.
function somSceismicChargesScreenPlay:grantQuest(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_NONE) then
		return false
	end

	if (CreatureObject(pPlayer):getScreenPlayState("somSceismicChargesBlocked") ~= 0) then
		return false
	end

	-- The [list] carries no Level, so there is no level gate to enforce.

	self:setStage(pPlayer, self.STAGE_SET_CHARGES)
	self:clearStations(pPlayer)

	CreatureObject(pPlayer):sendSystemMessage(self.questDescription)

	return true
end

-- Task 9's Wait for Signal. Its Signal Name shipped empty, so there is no name
-- to key this on; it is exposed by what it does instead.
function somSceismicChargesScreenPlay:turnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_REPORT) then
		return false
	end

	self:giveReward(pPlayer)

	return true
end

--[[ The six charges

registerStation binds a placed object to a station number, 1 to stationCount.
Nothing calls it, and nothing ever will from shipped data -- four independent
authorities place no station anywhere (header, finding 1). It is the seam a
region file or a later placement pass uses if six coordinates are ever authored,
and it is the same shape hk_history.lua uses for registerTrigger.
--]]

function somSceismicChargesScreenPlay:registerStation(pObject, station)
	if (pObject == nil) then
		return false
	end

	if (station == nil or station < 1 or station > self.stationCount) then
		printLuaError("somSceismicChargesScreenPlay:registerStation, station " .. tostring(station) .. " is outside 1.." .. self.stationCount .. ".")
		return false
	end

	self.stationByObjectID[SceneObject(pObject):getObjectID()] = station

	createObserver(OBJECTRADIALUSED, "somSceismicChargesScreenPlay", "stationUsed", pObject)

	return true
end

function somSceismicChargesScreenPlay:stationUsed(pObject, pPlayer)
	if (pObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local station = self.stationByObjectID[SceneObject(pObject):getObjectID()]

	if (station == nil) then
		return 0
	end

	self:setOffCharge(pPlayer, station)

	return 0
end

-- One Retrieve Item task, Count 1, LootDropPercent 100 -- so setting a charge
-- off never fails on a roll. There is no Server Object Template and no
-- ItemName, so nothing is handed to the player: the charge is set off, not
-- picked up.
function somSceismicChargesScreenPlay:setOffCharge(pPlayer, station)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_SET_CHARGES) then
		return false
	end

	if (station == nil or station < 1 or station > self.stationCount) then
		return false
	end

	if (self:hasFiredStation(pPlayer, station)) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "station_" .. station, "1")

	local fired = self:getFired(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "fired", tostring(fired))

	-- task 6 hangs off the third Retrieve Item only.
	if (station == self.stationWithAmbush) then
		self:spawnAmbush(pPlayer)
	end

	if (fired < self.stationCount) then
		CreatureObject(pPlayer):sendSystemMessage("Charges set off: " .. fired .. "/" .. self.stationCount)

		return true
	end

	-- task 8, Wait for Tasks, is the gate that opens when all six are done.
	self:setStage(pPlayer, self.STAGE_REPORT)

	CreatureObject(pPlayer):sendSystemMessage("Charges set off: " .. fired .. "/" .. self.stationCount)

	return true
end

-- task 6, Encounter: Count 1, Min Distance 5, Max Distance 50 -- all quoted.
-- Creature Type shipped EMPTY, so this refuses to spawn anything rather than
-- picking a creature nobody chose. Fill ambush.template and it runs.
function somSceismicChargesScreenPlay:spawnAmbush(pPlayer)
	if (self.ambush.template == "") then
		return false
	end

	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()

	for i = 1, self.ambush.count do
		local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, self.ambush.minDistance, self.ambush.maxDistance, true)

		if (spawnPoint == nil) then
			print("somSceismicChargesScreenPlay: no spawn point near the player for " .. self.ambush.template)
		else
			local pNpc = spawnMobile("mustafar", self.ambush.template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

			if (pNpc == nil) then
				print("somSceismicChargesScreenPlay: failed to spawn " .. self.ambush.template)
			else
				AiAgent(pNpc):setDefender(pPlayer)
			end
		end
	end

	return true
end

--[[ task 10  --  Reward

As shipped this pays nothing: Bank Credits 0, Experience Amount 0, and no loot
fields in the file at all. Both branches are kept so that correcting
rewardCredits or rewardItem is the only change needed if Aaron rules otherwise;
neither runs as the data stands.
--]]

function somSceismicChargesScreenPlay:giveReward(pPlayer)
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
		CreatureObject(pPlayer):sendSystemMessage("You have received " .. self.rewardCredits .. " credits.")
	end

	if (self.rewardItem ~= "") then
		local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

		if (pInventory == nil) then
			print("somSceismicChargesScreenPlay: player has no inventory; the reward could not be handed over")
		elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
			print("somSceismicChargesScreenPlay: failed to create " .. self.rewardItem)
			CreatureObject(pPlayer):sendSystemMessage("You have no room for your reward.")
		end
	end

	-- task 10 carries no musicOnComplete either, so nothing is played.

	self:closeOut(pPlayer)
end

-- [list] allowRepeats true: the run count goes up, the six stations are made
-- usable again and the player is reset to un-started so the job can be taken
-- again.
function somSceismicChargesScreenPlay:closeOut(pPlayer)
	local runs = self:getRuns(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(runs))

	self:setStage(pPlayer, self.STAGE_NONE)
	self:clearStations(pPlayer)

	deleteScreenPlayData(pPlayer, self.screenplayName, "fired")
end

--[[ Radial label

Exposed rather than hard-wired because the wording is invented, not quoted --
the live station's only radial was a plain "Use" (header, finding 2). Whatever
places the stations calls this for the label, so correcting the wording stays a
one-line change here.
--]]

function somSceismicChargesScreenPlay:getStationMenuText(pPlayer, station)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_SET_CHARGES) then
		return nil
	end

	if (station == nil or self:hasFiredStation(pPlayer, station)) then
		return nil
	end

	return self.stationMenuText
end
