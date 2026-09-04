--[[
The Strike  --  som_striking_miners

SOURCE OF RECORD

quest/som_striking_miners.qst in the client TREs, cross-read against
string/en/quest/ground/som_striking_miners.stf. The .stf carries the same twelve
fields the .qst does -- category, journal_entry_title, journal_entry_description,
task01..task04 title/description, task01_waypoint_name, task02_item_name,
task02_retrieve_menu_text and task03_waypoint_name -- and the two agree word for
word. Every string, coordinate, count, credit figure and item name below is
quoted from those two files. Where a number is this file's rather than SOE's it
says so at the point it appears, and again under WHAT IS NOT MODELLED.

The whole task tree is one nested chain, so it is strictly sequential:

	task 0   Nothing            isVisible false
	                            musicOnActivate mus_mustafar_quest_exception.snd
	  task 1   Wait for Signal  "Talk with Foreman Nurfa Laz'op"
	                            mustafar (-5380, 294, 4440)
	                            createWaypoint true, "Striking Miner's Camp"
	                            Signal Name mustafar_striking_miners_nurfa
	                            taskName mustafar_striking_miners_one
	    task 2   Retrieve Item   "Steal Tulrus Eggs"
	                             Server Object Template
	                               object/tangible/quest/tulrus_egg.iff
	                             Count 10, ItemName "Tulrus Egg"
	                             LootDropPercent 100
	                             retrieveMenuText "Steal Egg"
	                             createWaypoint 0
	                             taskName mustafar_striking_miners_two
	      task 3   Wait for Signal  "Return to Foreman Nurfa Laz'op"
	                                mustafar (-5380, 294, 4440)
	                                createWaypoint true, "Striking Miner's Camp"
	                                Signal Name mustafar_striking_miners_win
	                                taskName mustafar_striking_miners_three
	        task 4   Wait for Signal  "Return to Urup Fal'co"
	                                  createWaypoint 0, no location
	                                  Signal Name mustafar_striking_miners_reward
	                                  taskName mustafar_striking_miners_five
	          task 7   Reward           isVisible false
	                                    Bank Credits 10000
	                                    Experience Amount 0, Faction Amount 0
	                                    lootCount 1
	                                    lootName item_tow_clothing_03_02
	                                    musicOnComplete mus_mustafar_quest_success.snd

[list]: journalEntryTitle "The Strike", category Mustafar, journalVisible true,
allowRepeats true, completeWhenTasksComplete true, Level 75, Tier 4, Type solo,
Experience Type quest_combat with Experience Amount 0, Bank Credits 0.
The stored Experience Amount 0 is real; live still paid, because the server
recomputed from quest_experience (see mustafar_quest_xp.lua).

(Note that task 4's taskName is mustafar_striking_miners_five, not _four. There
is no _four anywhere in the file. That is SOE's own numbering, quoted as it
ships and not corrected, the same way som_sceismic_charges keeps its misspelling.)

THREE JOBS, NOT ONE CHAIN

This is one of three Mensix mining jobs looked at together -- som_poison_miners,
som_striking_miners, som_sceismic_charges -- and they are three independent
quests, which is why each got its own file rather than one shared screenplay:

  * every grantQuestOnComplete field in all three .qst files is empty,
  * every prerequisiteTasks field on every task in all three is empty,
  * prerequisiteQuests and exclusionQuests are empty in all three [list] blocks,
  * and a grep of every .qst in _som/quest/ for the three names returns no hit
    outside the three files themselves.

That is the opposite of som_kenobi_symbiosis_1, whose last task is Immediately
Complete Quest with grantQuestOnComplete som_kenobi_symbiosis_2 and which
therefore shares symbiosis.lua with _2. Nothing links these three, so this file
follows symbiosis.lua's one-file-per-player-facing-quest shape rather than
story_arc_prelude.lua's several-.qst-one-file shape.

THE OVERLAP WITH moral_choice.lua  --  same forest, different job

moral_choice.lua is already in this folder and is also about the Smoking Forest
strike. It is NOT this quest and nothing here duplicates or repoints it:

  * Different quest file. moral_choice.lua ports som_kenobi_moral_choice_1;
    this file ports som_striking_miners. Neither .qst names the other and
    neither [list] lists the other as a prerequisite or an exclusion.
  * Different anchor. moral_choice.lua:178-181 quotes its own task 0 waypoint,
    "Striking miners camp" at (-5267, 316, 4491). This quest's tasks 1 and 3
    quote "Striking Miner's Camp" at (-5380, 294, 4440). Those are 124 m apart
    (dx 113, dy 51), two separate parts of the same sprawl.
  * Different NPC. moral_choice.lua spawns som_kenobi_moral_strike_leader at
    (-5280, 4498) as its striker-side contact (moral_choice.lua:188-195) and
    som_kenobi_moral_exec inside the mining facility as its company-side one.
    This quest's contacts are Foreman Nurfa Laz'op and Urup Fal'co, who are
    different names in the shipped data and are not that pair.
  * No area collision. moral_choice.lua places no active area at its camp -- it
    quotes a waypoint and nothing else -- so the 20 m area this file puts at
    (-5380, 4440) touches nothing of its.

The one thing genuinely shared is the scenery: smoking_forest_region.lua:37-59
already stands eight miner_on_strike and two miner_foreman_on_strike around both
camps, and both quests read as happening among them. That file is not edited
here either.

FOREMAN NURFA LAZ'OP  --  already standing there, so not spawned again

He exists and he is already placed. mobile/custom_content/som/foreman_nurfa.lua
registers him at line 41 as "Foreman Nurfa Laz'op", level 70, MOB_NPC, pvpBitmask
NONE, optionsBitmask AIENABLED + CONVERSABLE + INTERESTING, on the appearance
object/mobile/som/mustafarian_02.iff; and smoking_forest_region.lua:34 spawns him:

	spawnMobile("mustafar", "foreman_nurfa", 120, -5396.5, 296.0, 4447.8, -163, 0)

That spawn is 18.2 m from this quest's own waypoint (-5380, 4440) -- dx 16.5,
dy 7.8. He is the right NPC, in the right place, put there by another wave's
file. This screenplay therefore spawns nobody: doing so would put a second
Foreman Nurfa Laz'op in the same clearing.

HOW THE PLAYER TALKS TO HIM  --  his real conversation, and the area now off

Tasks 1 and 3 are Wait for Signal. They carry no Target Server Template and no
menu text, because in the shipped game the signals came out of his conversation
tree. An earlier pass of this file could not find that tree and drove both legs
off a 20 m proximity area instead, with a note saying to switch the area off the
day he got a real conversation. That day has come.

The tree is SOE's own, transcribed node for node:

    mobile/conversations/mustafar/striking_miners_nurfa.lua
    .../quest/conversation/striking_miners_nurfa_conv_handler.lua

and foreman_nurfa.lua:37 now carries conversationTemplate = "striking_miners_nurfa".
The handler calls signalNurfa on his "It's a deal" reply and signalNurfaWin on the
hand-over of the eggs -- the two places SOE put mustafar_striking_miners_nurfa and
mustafar_striking_miners_win.

So campArea.radius is 0 and spawnCampArea returns without spawning anything. The
area code is left in place, unused, because the centre is the .qst's own waypoint
and the same table still supplies both legs' waypoints. Nothing is deleted; the
mechanism substitution is simply switched off now that the real one exists.

THE TEN EGGS  --  attached snapshot nodes, not spawns

Task 2's Server Object Template is object/tangible/quest/tulrus_egg.iff and it
resolves: object/custom_content/tangible/quest/tulrus_egg.lua:5 registers it on
the client template object/tangible/quest/shared_tulrus_egg.iff
(object/custom_content/tangible/quest/objects.lua:3604-3608), and it is included
from object/custom_content/tangible/quest/serverobjects.lua:469. So the item the
player ends up holding is the shipped one, not a substitute.

The eggs the player steals FROM are snapshot props, and there are exactly ten of
them -- the same number as the task's Count. snapshot/mustafar.ws places them and
PlanetManagerImplementation::loadSnapshotObject() instantiates each node with
objectID == the node ID, so getSceneObject(<nodeID>) returns the object the
client is already drawing. Both TREs that carry a mustafar.ws with this template
(stardust_03.tre index 92 and mtg_patch_023.tre index 101) agree on every id and
every position to the centimetre:

	node 12110479  (-1765.49, h 144.09, 3967.79)
	node 12110482  (-1901.03, h 150.35, 3678.63)
	node 12110483  (-1672.67, h 134.14, 3507.95)
	node 12110487  (-1635.41, h 114.83, 3296.08)
	node 12110488  (-1770.48, h  88.18, 3170.72)
	node 12110489  (-1570.70, h 125.75, 2940.95)
	node 12110490  (-1943.86, h 128.30, 2889.88)
	node 12112298  (-1540.31, h 107.65, 2697.92)
	node 12112303  (-1912.73, h 120.91, 2650.63)
	node 12112304  (-1524.68, h 121.43, 2770.62)

They run north to south down the strip between x -1520 and -1945, y 2650 to
3970, which is the ground managers/planet/mustafar_regions.lua:74-87 calls
tulrus_isle_1 through tulrus_isle_8 -- so the task's "travel to Tulrus Isle
which is located between the central volcano and Berken's flow" is literally
true of these ten objects. They are attached to, never respawned, exactly as
symbiosis.lua:166-175 attaches to its fluid container and
story_arc_prelude.lua attaches to its props. Nothing else in the scripts tree
references any of the ten ids, so no other screenplay's radial is displaced.

The radial label is the .qst's own retrieveMenuText, "Steal Egg", quoted. Each
node gives one egg per run and then refuses, so ten nodes make exactly the
Count of 10; LootDropPercent is 100, so the take never fails. The eggs are
handed over with giveItem() into the player's inventory, which creates the real
object, and the count that drives the quest is kept in screenplay data rather
than read back off the inventory -- so selling or dropping an egg cannot strand
the player mid-job.

THE GIVER  --  Urup Fal'co, found and placed

An earlier pass of this file said he "does not exist" and left grantQuest and
turnIn hanging with nobody to call them. That was wrong, and it was wrong because
the search was done by his display name. SOE named this quest's data after the
QUEST, not the NPC: his conversation script is striking_miners_urst, and the live
spawn row that places him carries that script name, not "fal'co". Both were there
the whole time. That is why this file keeps SOE's "urst" in the tree filename even
though every string on screen says Urup Fal'co (som_striking_miners.stf task04).

He is now built and placed:

    mobile/custom_content/som/urup_falco.lua                    the creature
    mobile/conversations/mustafar/striking_miners_urst.lua      SOE's tree
    .../quest/conversation/striking_miners_urst_conv_handler.lua
    screenplays/mustafar/mensix/mensix_mining_facility_main.lua the spawn

The spawn is in the conference room of the Mensix Mining Facility, cell 12112241,
at the position and heading the live data gives. His appearance is the one repo
choice: no urup_falco model ships anywhere and the live spawn data carries no
appearance column, so he wears the generic Mustafarian model, documented in
urup_falco.lua itself.

grantQuest and turnIn below are the two entry points his handler calls. Task 4
still carries createWaypoint 0 and no location, so this screenplay guesses no
position -- the position came from the live spawn data, not from us.

Everything between those two ends is fully wired and playable: the camp
waypoint, the arrival at Nurfa, the ten eggs, the count, the return leg and its
waypoint.

NO JOURNAL

som_striking_miners has no row in datatables/player/quests.iff. The table dumps
to 45 som_ rows and every one of them is an exploration marker
(som_berkens_flow, som_burning_plains, som_central_volcano, som_crystal_flats,
som_mining_field, som_nesting_grounds, som_smoking_forest and their _markers /
_markers_01..05 children); none of the three mining jobs is in it. Adding a row
would mean authoring a TRE. Progress therefore lives in persistent screenplay
data on the player, and each task's journalEntryDescription goes out as a system
message plus a waypoint description, which is the only channel left. Every
visible task of this quest says showSystemMessages true, so that is also what
the shipped data asks for.

THE REWARD  --  half quoted, half substituted

Task 7 pays Bank Credits 10000. That is quoted exactly and paid exactly.

The item is not recoverable. lootCount 1, lootName item_tow_clothing_03_02 --
a live server-side static-item name, not an object template. The name resolves to
"Mustafarian Mining Suit" in string/en/static_item_n.stf, but an exhaustive sweep
of every shipped shared_*.iff finds no object template carrying that objectName,
so granting the live item would mean authoring an object. It can only be matched
by description: one piece of clothing, from Trials of Obi-Wan.

Unlike som_poison_miners' pistol there is no SOM-flavoured wearable to fall back
on -- there is no som_ or mustafar_ wearable template anywhere in
object/tangible/wearables/. The substitute chosen is
object/tangible/wearables/bodysuit/bodysuit_sarlacc_coverall.iff, registered at
object/tangible/wearables/bodysuit/bodysuit_sarlacc_coverall.lua:89 and included
from that folder's serverobjects.lua:61. A coverall is workwear, which is what
a miners' job would hand over. That is the whole of the reasoning; it is a
stand-in and it is flagged as one.

It goes over with giveItem() into the player's inventory, which creates the
object for real. This is deliberately NOT addRewardedSchematic, which fails
closed when the path is not in scripts/managers/crafting/schematics.lua and
would silently grant nothing -- the defect hidden_treasure.lua's reward had to
be corrected for.

To restore the live item later, only rewardItem below changes.

REPEATS

[list] allowRepeats true, so payout resets the player to un-started, clears the
ten per-node flags and keeps a run count, the same way bounty_hunts.lua treats
its own allowRepeats flag. Nothing here refuses a second run. The eggs already
in the player's inventory are left alone -- the .qst says nothing about taking
them back, and destroying a player's items on a guess is not a thing to invent.

THE LEVEL GATE

[list] Level 75, and grantQuest refuses a player below it -- because for this
quest the .qst number is the only number there is.

That wants saying plainly, because a .qst [list] level is a client-side display
value, not a gate. Three Mustafar quests turned out to be really gated, and each
one was gated in its giver's server-side conversation rather than in its .qst:
collectors_business, cursed_shard and moral_choice all test level against 60, so
all three enforce 61 and all three ignore the 75 their .qst displays. This quest
has no such conversation -- no giver of it carries a level test -- so nothing
contradicts the 75 and nothing better is available to replace it with.

Do not read this as precedent for trusting a [list] level. It is the fallback
when the real gate is absent. If Aaron would rather the level be advisory,
minimumLevel below is the single number to change.

WHAT IS NOT MODELLED

  * Task 0's musicOnActivate. The .qst plays it on task activation, which the
    quest system does; with no quest-system row it plays inside grantQuest
    instead, which is the same moment from the player's side.
  * Faction Name "Rebel" appears on the Reward task and in the [list], but
    Faction Amount is 0, so no faction is awarded. The name is the .qst editor's
    default with nothing behind it.
  * The [list] Experience Type quest_combat with Experience Amount 0 is
    journal-level data that only the quest system awards. There is no quest
    system row here and the amount is zero either way, so nothing is invented to
    stand in for it. The stored Experience Amount 0 is real; live still paid,
    because the server recomputed from quest_experience (see mustafar_quest_xp.lua).
  * The eggs' snapshot props are not removed or re-dressed when taken. Snapshot
    objects are the client's own geometry; hiding one is not something a
    screenplay can do without touching the .ws.
--]]

local JournalMirror = require("managers.quest.journal_mirror")

somStrikingMinersScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "somStrikingMinersScreenPlay",

	-- [list] journalEntryTitle / journalEntryDescription.
	questTitle = "The Strike",
	questDescription = "The Mustafar Mining Company is having a number of problems. One of them is that a group of their miners is on strike. Talks between the miners and the company have broken down and the miners refuse to meet with the company to resolve the strike. Urup Fal'co needs an outsider to convince the miners to return to the discussions since they refuse to speak with any member of the company.",

	-- [list] Level 75. See THE LEVEL GATE.
	minimumLevel = 75,

	-- task 0 musicOnActivate and task 7 musicOnComplete. "exception" is what the
	-- shipped file says on the activate leg; quoted, not corrected.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst. The counter tick has no shipped sound; this is the one
	-- map_exploration.lua:412 and bounty_hunts.lua use for their own hunt ticks.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	-- tasks 1 and 3, both createWaypoint true on the same spot:
	-- mustafar (-5380, 294, 4440), waypointName "Striking Miner's Camp".
	-- The LocationY of the .qst is the HEIGHT, so it goes in as z; the rule is
	-- documented in map_exploration.lua.
	--
	-- radius 0 means the proximity stand-in is OFF; Nurfa has his real
	-- conversation now. See HOW THE PLAYER TALKS TO HIM. The rest of this table
	-- is still live: it is where both legs' waypoints come from.
	campArea = {
		x = -5380, z = 294, y = 4440, radius = 0,
		waypointName = "Striking Miner's Camp",
	},

	-- task 2, Retrieve Item. Everything here is quoted.
	egg = {
		template = "object/tangible/quest/tulrus_egg.iff",
		count = 10,
		itemName = "Tulrus Egg",
		lootDropPercent = 100,
		menuText = "Steal Egg",
	},

	-- The ten shared_tulrus_egg snapshot nodes; see THE TEN EGGS. Positions are
	-- recorded in the header, in the .ws's own (x, height, z) order.
	eggNodeIDs = {
		12110479, 12110482, 12110483, 12110487, 12110488,
		12110489, 12110490, 12112298, 12112303, 12112304,
	},

	-- task 7: Bank Credits 10000, quoted.
	rewardCredits = 10000,
	-- Substituted for the .qst's item_tow_clothing_03_02; see THE REWARD.
	rewardItem = "object/tangible/wearables/bodysuit/bodysuit_sarlacc_coverall.iff",

	campAreaID = 0,
}

-- JOURNAL MIRROR (J-3, 2026-09-04): stage -> client journal task bits, from the SOE task tree in
-- this header and scratch/mustafar-stage-task-map.md §som_striking_miners. Screenplay data stays truth.
somStrikingMinersScreenPlay.journalMap = {
	[1] = { quest = "som_striking_miners", complete = {0}, activate = {1} }, -- 1→t1 Wait for Signal _nurfa
	[2] = { quest = "som_striking_miners", complete = {1}, activate = {2} }, -- 2→t2 Retrieve Item ×10
	[3] = { quest = "som_striking_miners", complete = {2}, activate = {3} }, -- 3→t3 Wait for Signal _win
	[4] = { quest = "som_striking_miners", complete = {3, 4}, activate = {4}, finish = true }, -- 4→t4 live; t7 Reward on closeOut→0
}

registerScreenPlay("somStrikingMinersScreenPlay", true)

function somStrikingMinersScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachEggs()
		self:spawnCampArea()
	end
end

function somStrikingMinersScreenPlay:attachEggs()
	for i = 1, #self.eggNodeIDs do
		local nodeID = self.eggNodeIDs[i]
		local pEgg = getSceneObject(nodeID)

		if (pEgg == nil) then
			print("somStrikingMinersScreenPlay: snapshot object " .. nodeID .. " (tulrus egg) was not found; that nest cannot be robbed")
		else
			writeStringData(nodeID .. ":somStrikingMinersRole", "egg")
			SceneObject(pEgg):setObjectMenuComponent("SomStrikingMinersMenuComponent")
		end
	end
end

-- The proximity stand-in for the conversation with Foreman Nurfa Laz'op. It is
-- OFF -- campArea.radius is 0, so this returns immediately. Kept because the
-- centre it reads is also the waypoint centre. See HOW THE PLAYER TALKS TO HIM.
function somStrikingMinersScreenPlay:spawnCampArea()
	if (self.campArea.radius <= 0) then
		return
	end

	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.campArea.x, self.campArea.z, self.campArea.y, self.campArea.radius, 0)

	if (pArea == nil) then
		print("somStrikingMinersScreenPlay: failed to spawn the striking miners' camp area")
		return
	end

	self.campAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "somStrikingMinersScreenPlay", "notifyEnteredCamp", pArea)
end

--[[ State

Persistent screenplay data on the player, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0".

	stage        0  not granted
	             1  granted, going to see Nurfa Laz'op        (task 1)
	             2  robbing the ten nests on Tulrus Isle      (task 2)
	             3  eggs in hand, going back to Nurfa Laz'op  (task 3)
	             4  Nurfa agreed, reporting to Urup Fal'co    (task 4)
	eggs         nests robbed this run, 0-10
	egg_<node>   1 once that particular nest has been robbed this run
	runs         times this player has been paid; allowRepeats true, so this only
	             counts
	wp           waypoint id currently handed out, 0 if none
--]]

somStrikingMinersScreenPlay.STAGE_NONE = 0
somStrikingMinersScreenPlay.STAGE_MEET_NURFA = 1
somStrikingMinersScreenPlay.STAGE_STEAL_EGGS = 2
somStrikingMinersScreenPlay.STAGE_RETURN_NURFA = 3
somStrikingMinersScreenPlay.STAGE_REPORT_URUP = 4

function somStrikingMinersScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function somStrikingMinersScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	JournalMirror.applyStage(pPlayer, self.journalMap, stage)   -- J-3 journal mirror
end

function somStrikingMinersScreenPlay:getEggs(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "eggs")) or 0
end

function somStrikingMinersScreenPlay:hasRobbedNest(pPlayer, nodeID)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "egg_" .. nodeID)) == 1
end

function somStrikingMinersScreenPlay:clearNests(pPlayer)
	writeScreenPlayData(pPlayer, self.screenplayName, "eggs", "0")

	for i = 1, #self.eggNodeIDs do
		deleteScreenPlayData(pPlayer, self.screenplayName, "egg_" .. self.eggNodeIDs[i])
	end
end

-- How many times this player has finished and been paid. A giver can use it to
-- tell a first-timer from a regular.
function somStrikingMinersScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function somStrikingMinersScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function somStrikingMinersScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

--[[ Entry points for the two givers

Urup Fal'co starts and ends this job; Foreman Nurfa Laz'op is the middle of it.
Both are live-sourced on all three counts:

  * NAMES -- som_striking_miners.stf names "Urup Fal'co" in the journal entry
    and task04, and "Foreman Nurfa Laz'op" in task01.
  * TREES -- SOE's own conversation/striking_miners_urst.java and
    conversation/striking_miners_nurfa.java, rebuilt node for node at
    mobile/conversations/mustafar/striking_miners_urst.lua and
    .../striking_miners_nurfa.lua.
  * PLACES -- the live spawn table puts som_urup_falco in the conference room of
    the Mensix Mining Facility at -152.7, 19.1, -17.4, facing -68; he is spawned
    there by mensix_mining_facility_main.lua.  Nurfa was already outdoors at the
    strike camp, smoking_forest_region.lua:34.

The four functions below are what the two conversation handlers call, from
exactly the screens SOE hung the side effects on.  Only Urup's APPEARANCE is a
repo choice -- no urup_falco.iff ships; see the header of
mobile/custom_content/som/urup_falco.lua.
--]]

-- Task 0 firing: musicOnActivate, then task 1 becomes the live step.
function somStrikingMinersScreenPlay:grantQuest(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_NONE) then
		return false
	end

	if (CreatureObject(pPlayer):getScreenPlayState("somStrikingMinersBlocked") ~= 0) then
		return false
	end

	-- [list] Level 75.
	if (CreatureObject(pPlayer):getLevel() < self.minimumLevel) then
		return false
	end

	self:setStage(pPlayer, self.STAGE_MEET_NURFA)
	self:clearNests(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)
	CreatureObject(pPlayer):sendSystemMessage(self.questDescription)

	-- task 1 journalEntryDescription, and its createWaypoint true /
	-- waypointName "Striking Miner's Camp".
	CreatureObject(pPlayer):sendSystemMessage("Travel to the outpost in the Smoking Forest and talk to the leader of the striking miners, Nurfa Laz'op. You need to convince Nurfa Laz'op to return to the talks with the Mustafar Mining Company so they can reach an agreement and end the strike.")
	self:giveWaypoint(pPlayer, self.campArea.waypointName, "Talk with Foreman Nurfa Laz'op", self.campArea.x, self.campArea.y)

	return true
end

-- Task 4's signal, mustafar_striking_miners_reward: the hand-in at Urup Fal'co.
function somStrikingMinersScreenPlay:turnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_REPORT_URUP) then
		return false
	end

	self:giveReward(pPlayer)

	return true
end

--[[ tasks 1 and 3  --  the two legs at Foreman Nurfa Laz'op

Both are Wait for Signal on the same waypoint. Nurfa's conversation handler calls
these two by their shipped signal names, from the screens SOE hung them on. The
area below is off and calls nothing.
--]]

-- Signal Name mustafar_striking_miners_nurfa.
function somStrikingMinersScreenPlay:signalNurfa(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_MEET_NURFA) then
		return false
	end

	self:setStage(pPlayer, self.STAGE_STEAL_EGGS)
	self:removeWaypoint(pPlayer)
	self:clearNests(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)

	-- task 2 journalEntryDescription. createWaypoint is 0 on that task, so no
	-- waypoint is handed out for the isle; the description is the only direction
	-- the shipped data gives.
	CreatureObject(pPlayer):sendSystemMessage("Nurfa Laz'op wants to make sure that you are not just a company man. You are to be tested by gathering ten eggs of the Tulrus. In order to find these eggs you will need to travel to Tulrus Isle which is located between the central volcano and Berken's flow. The only known pass onto the isle is from a bridge in the southern section of Berken's Flow.")

	return true
end

-- Signal Name mustafar_striking_miners_win.
function somStrikingMinersScreenPlay:signalNurfaWin(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_RETURN_NURFA) then
		return false
	end

	self:setStage(pPlayer, self.STAGE_REPORT_URUP)
	self:removeWaypoint(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)

	-- task 4 journalEntryDescription. createWaypoint is 0 on that task and
	-- nothing ships Urup Fal'co's position, so no waypoint is handed out here.
	CreatureObject(pPlayer):sendSystemMessage("Nurfa Laz'op has agreed to return to the talks with the Mustafar Mining Company. You need to let Urup know that your mission has been a success.")

	return true
end

function somStrikingMinersScreenPlay:notifyEnteredCamp(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (SceneObject(pArea):getObjectID() ~= self.campAreaID) then
		return 0
	end

	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_MEET_NURFA) then
		self:signalNurfa(pPlayer)
	elseif (stage == self.STAGE_RETURN_NURFA) then
		self:signalNurfaWin(pPlayer)
	end

	return 0
end

--[[ task 2  --  Retrieve Item, Count 10, "Steal Egg" ]]

-- Called from the radial on one of the ten snapshot nests.
function somStrikingMinersScreenPlay:stealEgg(pPlayer, nodeID)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_STEAL_EGGS) then
		return false
	end

	if (self:hasRobbedNest(pPlayer, nodeID)) then
		return false
	end

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("somStrikingMinersScreenPlay: player has no inventory; the egg could not be handed over")
		return false
	end

	-- LootDropPercent 100, so the take never fails on a roll -- only on a full
	-- inventory, and then the nest is left unrobbed so it can be tried again.
	if (giveItem(pInventory, self.egg.template, -1, true) == nil) then
		CreatureObject(pPlayer):sendSystemMessage("You have no room for another " .. self.egg.itemName .. ".")
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "egg_" .. nodeID, "1")

	local taken = self:getEggs(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "eggs", tostring(taken))
	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)

	if (taken < self.egg.count) then
		-- ItemName "Tulrus Egg", Count 10, both quoted.
		CreatureObject(pPlayer):sendSystemMessage(self.egg.itemName .. "s taken: " .. taken .. "/" .. self.egg.count)

		return true
	end

	self:setStage(pPlayer, self.STAGE_RETURN_NURFA)

	-- task 3 journalEntryDescription, and its createWaypoint true /
	-- waypointName "Striking Miner's Camp" -- the same spot as task 1.
	CreatureObject(pPlayer):sendSystemMessage("With your ill gotten eggs in hand, return to Nurfa Laz'op and report your success in this task.")
	self:giveWaypoint(pPlayer, self.campArea.waypointName, "Return to Foreman Nurfa Laz'op", self.campArea.x, self.campArea.y)

	return true
end

--[[ task 7  --  Reward ]]

function somStrikingMinersScreenPlay:giveReward(pPlayer)
	-- Bank Credits 10000, quoted.
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
		CreatureObject(pPlayer):sendSystemMessage("You have received " .. self.rewardCredits .. " credits.")
	end

	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_striking_miners")

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("somStrikingMinersScreenPlay: player has no inventory; the reward could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		print("somStrikingMinersScreenPlay: failed to create " .. self.rewardItem)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for Urup Fal'co's reward.")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have received a set of clothing from Urup Fal'co.")
	end

	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	self:closeOut(pPlayer)
end

-- [list] allowRepeats true: the run count goes up, the ten nests are made
-- robbable again and the player is reset to un-started so the job can be taken
-- again. The eggs already in the player's inventory are deliberately left
-- alone; see REPEATS.
function somStrikingMinersScreenPlay:closeOut(pPlayer)
	local runs = self:getRuns(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(runs))

	self:removeWaypoint(pPlayer)
	self:setStage(pPlayer, self.STAGE_NONE)
	self:clearNests(pPlayer)

	deleteScreenPlayData(pPlayer, self.screenplayName, "eggs")
end

--[[ Radial dispatch

SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely -- so
fillObjectMenuResponse has to add every item we want to see, and adds nothing at
all when this player has no business robbing the nest.
--]]

SomStrikingMinersMenuComponent = {}

function SomStrikingMinersMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local nodeID = SceneObject(pSceneObject):getObjectID()
	local role = readStringData(nodeID .. ":somStrikingMinersRole")

	if (role ~= "egg") then
		return
	end

	if (somStrikingMinersScreenPlay:getStage(pPlayer) ~= somStrikingMinersScreenPlay.STAGE_STEAL_EGGS) then
		return
	end

	if (somStrikingMinersScreenPlay:hasRobbedNest(pPlayer, nodeID)) then
		return
	end

	-- task 2 retrieveMenuText, quoted.
	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, somStrikingMinersScreenPlay.egg.menuText)
end

function SomStrikingMinersMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local nodeID = SceneObject(pSceneObject):getObjectID()
	local role = readStringData(nodeID .. ":somStrikingMinersRole")

	if (role == "egg") then
		somStrikingMinersScreenPlay:stealEgg(pPlayer, nodeID)
	end

	return 0
end
