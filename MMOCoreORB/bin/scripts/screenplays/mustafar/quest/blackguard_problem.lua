--[[
An Archeologist's Problem  --  som_blackguard_problem

SOURCE OF RECORD

quest/som_blackguard_problem.qst in the client TREs, cross-checked against
string/en/quest/ground/som_blackguard_problem.stf. Every title, description,
task name, signal name, count, social group, creature template and credit figure
below is quoted from one of those two files.

The .stf holds fifteen rows -- category, journal_entry_title,
journal_entry_description and a taskNN_journal_entry_title /
taskNN_journal_entry_description pair for tasks 01 through 06 -- and every one of
them is byte-for-byte the same string the .qst carries. It adds nothing the .qst
does not already have: no waypoint name, no item name, no menu text. There is no
counter string and no completion string in it either, which is why the progress
lines this file sends are built from the task titles rather than quoted.

THE TASK TREE, transcribed

	task 0  Nothing              isVisible false, showSystemMessages 0,
	                             no journal text, no music
	 task 1 Destroy Multiple     taskName blackguard_problem_one
	                             "Defeat 10 Blackguard"
	                             Social Group blackguard, Count 10,
	                             RewardCredits 0
	                             musicOnActivate mus_mustafar_quest_exception.snd
	  task 2 Wait for Signal     taskName blackguard_problem_two
	                             "Return to Dr. Lu"
	                             Signal Name blackguard_minion_defeated
	                             createWaypoint 0, waitMarkerCreate 0
	   task 3 Destroy Multiple   taskName blackguard_problem_three
	                             "Defeat Vansk of the Blackguard"
	                             Target Server Template som_vansk_blackguard
	                             Count 1, RewardCredits 0
	    task 4 Wait for Signal   taskName blackguard_problem_four
	                             "Return to Dr. Lu"
	                             Signal Name blackguard_vansk_defeated
	     task 5 Destroy Multiple taskName blackguard_problem_five
	                             "Defeat San'sii the Kursk"
	                             Target Server Template som_sansii_kursk
	                             Count 1, RewardCredits 0
	      task 6 Wait for Signal taskName blackguard_problem_six
	                             "Return to Dr. Lu"
	                             Signal Name blackguard_sansii_defeated
	       task 7 Reward         Bank Credits 5000, CountItem 1, lootCount 1,
	                             lootName item_tow_proc_ranged_03_01,
	                             Experience Amount 0, Faction Amount 0,
	                             isVisible false, showSystemMessages 0,
	                             musicOnComplete mus_mustafar_quest_success.snd

Every task is the single child of the one above it, so the quest is a straight
six-step ladder with no branching and no optional legs.

The quest <list> says journalEntryTitle "An Archeologist's Problem", category
Mustafar, journalVisible true, Level 70, Tier 4, Type solo, allowRepeats true,
Experience Type quest_combat, Experience Amount 0, Bank Credits 0,
completeWhenTasksComplete true. There is no grantGcwPoints attribute in this
file at all -- grep finds zero occurrences of the name -- so nothing GCW-related
is done here. (som_storm_lord, the sibling quest, does carry the attribute and
says false. This one simply predates it or was authored without it; either way
there is nothing to honour.)

CHAINED OR INDEPENDENT

Independent. grantQuestOnComplete, grantQuestOnFail, prerequisiteQuests,
exclusionQuests, prerequisiteTasks, exclusionTasks,
conditionalQuestGrantQuestsThatMustBeCompleted and
conditionalQuestGrantQuestToGive are present on every one of the eight tasks and
every one of them is empty. Nothing grants this quest and this quest grants
nothing, so it is its own screenplay rather than a chapter of another one.

SOCIAL GROUP IS NOT USABLE  --  templates enumerated instead

Task 1 matches kills by Social Group "blackguard". Every ported SOM creature in
this tree carries socialGroup "townsperson" or "" -- blackguard.lua:3,
blackguard_elite.lua:3 and blackguard_wilder.lua:3 all say "townsperson", the
same as roughly a hundred other SOM mobiles -- so a live group match would count
tanray and mining foremen as Blackguard. The group is therefore resolved to its
concrete members, which is the same set it would have picked, and that is exactly
what bounty_hunts.lua already does in this tree for its seven Social Group legs.

The three counted templates, all registered and all included in
mobile/custom_content/som/serverobjects.lua:

	blackguard          "a blackguard minion"        serverobjects.lua:27
	blackguard_elite    "a blackguard elite minion"  serverobjects.lua:28
	blackguard_wilder   "a blackguard wilder"        serverobjects.lua:29

Deliberately NOT counted: vansk_blackguard and sansii. They are the named targets
of tasks 3 and 5 and the .qst gives them their own Destroy Multiple legs rather
than folding them into the group count, so counting them twice would let a player
skip part of task 1 by killing the leaders first.

THE BLACKGUARD  --  already placed, so they are observed, not spawned

Nothing is spawned by this file. The whole Blackguard camp is already standing at
the Jedi enclave ruins in screenplays/mustafar/regions/smoking_forest_region.lua,
which this file does not touch:

	blackguard         x10  lines 106, 108, 110, 112, 114, 138, 140, 146,
	                        148 and 150, around (-4293 .. -4447, 3156 .. 3216)
	blackguard_elite    x6  lines 116, 118, 120, 126, 142, 144
	blackguard_wilder   x3  lines 132, 134, 136
	sansii              x1  line 123 at (-4379.2, 94.3, 3231.6)
	vansk_blackguard    x1  line 129 at (-4411.8, 85.1, 3154.6)

That is nineteen group members against a required Count of 10, and every one of
those spawnMobile calls passes 120 as its third argument, which
DirectorManager::spawnMobile (DirectorManager.cpp:2656-2677) reads as the respawn
timer in seconds -- so the camp refills and the leg stays repeatable, which
matters because the <list> says allowRepeats true.

managers/planet/mustafar_regions.lua:150 puts the blackguard_jedi_ruins region
around that camp at (-4373, 3255) with radius 200 and NOSPAWNAREA, so the camp is
the only thing in it. That is the "Jedi enclave ruins" the <list> description
names.

THE TWO NAMED TARGETS

Tasks 3 and 5 name creature templates with the .qst's "som_" authoring prefix.
Both resolve to registered, already-placed creatures and both are matched by
template name on the kill:

	som_vansk_blackguard -> vansk_blackguard  customName "Vansk of the Blackguard"
	                        mobile/custom_content/som/vansk_blackguard.lua,
	                        serverobjects.lua:177
	som_sansii_kursk     -> sansii            customName "Sans'ii the Kursk"
	                        mobile/custom_content/som/sansii.lua,
	                        serverobjects.lua:101

One spelling difference, recorded and NOT normalised in either direction: the
.qst and the .stf both write "San'sii the Kursk", and so does the shipped
conversation table string/en/conversation/som_doctor_lu.stf; the registered
creature's customName is "Sans'ii the Kursk". Renaming the creature would be a
change to somebody else's already-placed content, and rewriting the quoted
journal string would be inventing data, so both are left as they shipped. The
match below is on the registered template name, not on the display name, so the
difference has no runtime effect.

NO WAYPOINTS  --  the shipped data has none

All three Wait for Signal tasks say createWaypoint 0, waitMarkerCreate 0,
waitMarkerBuilding 0 and waitMarkerX / waitMarkerY / waitMarkerZ 0, and every
task in the file carries Planet "tatooine" with LocationX / LocationY /
LocationZ 0.0 -- the .qst editor's empty default, not a place. Dr. Lu's position
is nowhere in the shipped data. So this file hands out no waypoint at all. That
is a quoted absence, not an omission: som_glyph_hunt's equivalent hand-in tasks
DO carry createWaypoint true and real mustafar coordinates, so the field is
plainly meaningful in this format and this quest plainly does not use it.

THE REWARD

Bank Credits 5000, awarded. Experience Amount is 0 on the Reward task, and the
<list>'s Experience Type quest_combat with Experience Amount 0 is journal-level
data that only the quest system awards -- there is no quest system row here, so
nothing is invented to stand in for it. Faction Amount is 0 against Faction Name
"Rebel", so there is no faction award either; the name with a zero amount is the
editor's default.

lootCount 1 / lootName item_tow_proc_ranged_03_01 is NOT granted. lootName is a
live server-side static-item name, not an object template. Nothing in this tree
is called item_tow_proc_ranged_03_01, there is no datatables row anywhere in the
extract that maps it to a template, and string/en in the extract holds only
conversation/, quest/, dance_advancement.stf and performance.stf -- so there is
not even a display name for it to be matched by. It is left unresolved rather
than replaced with a guess. This is the same class of unresolvable reward already
recorded in hidden_treasure.lua and bounty_hunts.lua.

The Reward task's CountItem 1 / CountWeapon 1 / CountArmor 1 and its
Speed / Damage / Efficiency / Elemental Value / Quality 0.1 are the loot-quality
knobs that go with the unresolved lootName, so they are recorded here and go
nowhere as well.

NO GIVER  --  open question, deliberately not filled

Dr. Lu is named in five of the six journal entries and the shipped conversation
table string/en/conversation/som_doctor_lu.stf carries his entire dialogue tree,
in which he introduces himself as "Doctor Mi Fon Lu of the Theed Academy" and
walks the player through exactly this ladder -- minions, then Vansk, then
San'sii, then the relic. None of that says where he stands or what starts the
quest:

  * doc_lu is a registered creature (mobile/custom_content/som/doc_lu.lua,
    included at that directory's serverobjects.lua:48, customName "doc_lu") and
    it is spawned NOWHERE in this tree.
  * Its conversationTemplate is "" (doc_lu.lua:37) and there is no doctor-lu file
    in mobile/conversations/mustafar/ for it to point at.
  * There is no quest_start object for this quest in snapshot/mustafar.ws.

So this file spawns nobody, invents no position and writes no conversation.
grantQuest, signalMinionsDefeated, signalVanskDefeated and signalSansiiDefeated
are the seams a giver's conversation handler calls once Aaron says where Dr. Lu
stands. The three signal functions ARE blackguard_minion_defeated,
blackguard_vansk_defeated and blackguard_sansii_defeated -- the .qst raises all
three from the hand-in and there is nothing else in the shipped data that can
raise them.

NO JOURNAL

som_blackguard_problem has no row in datatables/player/quests.iff. The table the
server loads is stardust_03.tre's, which wins the TreFiles order in
conf/config.lua; its 307 rows contain no Mustafar entries but the 45 exploration
markers. Adding a row would mean authoring a TRE. So progress lives in persistent
screenplay data on the player and the journal text goes out as system messages,
the same as bounty_hunts.lua and map_exploration.lua. No id is added to
managers/quest/quest_manager.lua, because an id with no table row does nothing.

showSystemMessages is true on all six tasks that have journal text and 0 only on
task 0 and task 7, neither of which has any, so the flag is honoured as written.
--]]

somBlackguardProblemScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "somBlackguardProblemScreenPlay",

	-- [list] journalEntryTitle / journalEntryDescription / Level / Tier /
	-- allowRepeats / category.
	questTitle = "An Archeologist's Problem",
	questDescription = "You met a strange little fellow near one of the Jedi enclave ruins. He told you that he has been having trouble studying the ruins because of a group that call themselves the Blackguard. Perhaps a little forceful negotiations are in order.",
	questLevel = 70,
	questTier = 4,
	repeatable = true,

	-- task 1 musicOnActivate, task 7 musicOnComplete. "exception" is what the
	-- shipped file says on the activate leg; it is quoted, not corrected.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst. The kill counter has no shipped sound; this is the one
	-- map_exploration.lua:412 uses for its own counters.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	--[[ The ladder, in the order the .qst nests it.

	Each kill leg carries the stage it runs in, its own journal text, its Count,
	the set of registered templates that satisfies it, and the Wait for Signal
	task that follows it. Reading it as one table keeps the three legs identical
	in behaviour and makes the differences between them pure data.

		stage 1  task 1 + task 2   ten Blackguard, then blackguard_minion_defeated
		stage 3  task 3 + task 4   Vansk, then blackguard_vansk_defeated
		stage 5  task 5 + task 6   San'sii, then blackguard_sansii_defeated

	The even stages between them are the hand-ins: the kill leg is done and the
	quest is waiting on its signal.
	--]]
	legs = {
		{
			killStage = 1,
			waitStage = 2,

			-- task 1, Destroy Multiple.
			taskName = "blackguard_problem_one",
			title = "Defeat 10 Blackguard",
			description = "Perhaps you can convince the Blackguard to let Dr. Lu examine the ruins if you defeat a few of their members.",
			-- Social Group blackguard, resolved to its members; see SOCIAL GROUP
			-- IS NOT USABLE. Adding or removing a name here is the whole change.
			socialGroup = "blackguard",
			killTemplates = { ["blackguard"] = true, ["blackguard_elite"] = true, ["blackguard_wilder"] = true },
			count = 10,
			rewardCredits = 0,

			-- task 2, Wait for Signal.
			signalTaskName = "blackguard_problem_two",
			signalTitle = "Return to Dr. Lu",
			signalDescription = "Inform Dr. Lu that you have cleared out some of the Blackguard.",
			signal = "blackguard_minion_defeated",
		},
		{
			killStage = 3,
			waitStage = 4,

			-- task 3, Destroy Multiple. Target Server Template som_vansk_blackguard.
			taskName = "blackguard_problem_three",
			title = "Defeat Vansk of the Blackguard",
			description = "Since defeating the Blackguard minions didn't accomplish anything, perhaps it is time to take out one of the leaders. Defeat Vansk of the Blackguard.",
			targetServerTemplate = "som_vansk_blackguard",
			killTemplates = { ["vansk_blackguard"] = true },
			count = 1,
			rewardCredits = 0,

			-- task 4, Wait for Signal.
			signalTaskName = "blackguard_problem_four",
			signalTitle = "Return to Dr. Lu",
			signalDescription = "Return to Dr. Lu and inform him that you have defeated Vansk of the Blackguard.",
			signal = "blackguard_vansk_defeated",
		},
		{
			killStage = 5,
			waitStage = 6,

			-- task 5, Destroy Multiple. Target Server Template som_sansii_kursk.
			-- The .qst spells the display name "San'sii"; the registered creature
			-- says "Sans'ii". See THE TWO NAMED TARGETS.
			taskName = "blackguard_problem_five",
			title = "Defeat San'sii the Kursk",
			description = "Nothing you have done so far has helped Dr. Lu. It is time to strike at the leader of the Blackguard. Defeat San'sii the Kursk in battle.",
			targetServerTemplate = "som_sansii_kursk",
			killTemplates = { ["sansii"] = true },
			count = 1,
			rewardCredits = 0,

			-- task 6, Wait for Signal.
			signalTaskName = "blackguard_problem_six",
			signalTitle = "Return to Dr. Lu",
			signalDescription = "Return to Dr. Lu and tell him that he should no longer have any problems examining the ruins.",
			signal = "blackguard_sansii_defeated",
		},
	},

	-- task 7, Reward. lootName is recorded and not granted; see THE REWARD.
	rewardCredits = 5000,
	rewardLootName = "item_tow_proc_ranged_03_01",
	rewardLootCount = 1,

	-- The stage the ladder reaches when task 7 has paid out.
	finishedStage = 7,
}

registerScreenPlay("somBlackguardProblemScreenPlay", true)

-- Nothing is placed in the world at boot: the .qst names no giver, no terminal
-- and no location, and inventing one is not this screenplay's call. start() still
-- exists because DirectorManager::startScreenPlay (DirectorManager.cpp:3605-3611)
-- calls "start" by name on every screenplay registered with true.
function somBlackguardProblemScreenPlay:start()
end

--[[ State

Persistent screenplay data on the player, so the ladder survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0" on every read.

	stage       0  not started
	            1  task 1 live -- defeat ten Blackguard
	            2  task 2 live -- waiting on blackguard_minion_defeated
	            3  task 3 live -- defeat Vansk
	            4  task 4 live -- waiting on blackguard_vansk_defeated
	            5  task 5 live -- defeat San'sii
	            6  task 6 live -- waiting on blackguard_sansii_defeated
	            7  finished and paid
	kills_<n>   kills credited on leg n of the current run
	observer    1 while this player carries the KILLEDCREATURE observer
	runs        completed runs; allowRepeats is true, so this only counts
--]]

function somBlackguardProblemScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function somBlackguardProblemScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function somBlackguardProblemScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function somBlackguardProblemScreenPlay:getKills(pPlayer, index)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills_" .. index)) or 0
end

-- The leg whose kill stage the player is standing in, or nil when the quest is
-- not on a kill step at all.
function somBlackguardProblemScreenPlay:getActiveLeg(pPlayer)
	local stage = self:getStage(pPlayer)

	for i = 1, #self.legs do
		if (self.legs[i].killStage == stage) then
			return self.legs[i], i
		end
	end

	return nil, 0
end

function somBlackguardProblemScreenPlay:clearRunData(pPlayer)
	for i = 1, #self.legs do
		deleteScreenPlayData(pPlayer, self.screenplayName, "kills_" .. i)
	end
end

--[[ Entry points

grantQuest and the three signal functions are what Dr. Lu's conversation handler
calls once there is one. None of them sends a refusal: with no giver in the
shipped data there is no voice to put a refusal in, so they only report whether
they did anything and leave the wording to whoever ends up owning the
conversation.

	canGrantQuest(pPlayer)           may this character start it
	grantQuest(pPlayer)              task 1 goes live
	signalMinionsDefeated(pPlayer)   raise blackguard_minion_defeated -- task 2
	signalVanskDefeated(pPlayer)     raise blackguard_vansk_defeated  -- task 4
	signalSansiiDefeated(pPlayer)    raise blackguard_sansii_defeated -- task 6,
	                                 which is what fires the Reward
	reportProgress(pPlayer)          read-only progress, the missing journal page
--]]

function somBlackguardProblemScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	-- [list] allowRepeats true, read from the table rather than assumed.
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function somBlackguardProblemScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearRunData(pPlayer)
	self:setStage(pPlayer, self.legs[1].killStage)
	self:attachKillObserver(pPlayer)

	-- The [list] and task 1 journal text. There is no journal in this tree, so
	-- this is the only place the player ever reads it.
	CreatureObject(pPlayer):sendSystemMessage(self.questTitle)
	CreatureObject(pPlayer):sendSystemMessage(self.questDescription)
	CreatureObject(pPlayer):sendSystemMessage(self.legs[1].description)

	-- task 1 musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)

	return true
end

function somBlackguardProblemScreenPlay:signalMinionsDefeated(pPlayer)
	return self:raiseSignal(pPlayer, 1)
end

function somBlackguardProblemScreenPlay:signalVanskDefeated(pPlayer)
	return self:raiseSignal(pPlayer, 2)
end

function somBlackguardProblemScreenPlay:signalSansiiDefeated(pPlayer)
	return self:raiseSignal(pPlayer, 3)
end

-- One Wait for Signal task completing. The guard is what makes calling it early
-- do nothing: the signal only lands while its own leg is the one waiting.
function somBlackguardProblemScreenPlay:raiseSignal(pPlayer, index)
	if (pPlayer == nil) then
		return false
	end

	local leg = self.legs[index]

	if (self:getStage(pPlayer) ~= leg.waitStage) then
		return false
	end

	local nextLeg = self.legs[index + 1]

	if (nextLeg == nil) then
		-- task 6 was the last one, so its completion is what fires task 7.
		self:awardQuest(pPlayer)

		return true
	end

	self:setStage(pPlayer, nextLeg.killStage)

	CreatureObject(pPlayer):sendSystemMessage(nextLeg.title)
	CreatureObject(pPlayer):sendSystemMessage(nextLeg.description)

	return true
end

-- Read-only; a giver can use it for "how am I doing", and it is the closest thing
-- to the journal page this quest does not have.
function somBlackguardProblemScreenPlay:reportProgress(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local leg, index = self:getActiveLeg(pPlayer)

	if (leg ~= nil) then
		CreatureObject(pPlayer):sendSystemMessage(self:progressLine(leg, self:getKills(pPlayer, index)))

		return
	end

	local stage = self:getStage(pPlayer)

	for i = 1, #self.legs do
		if (self.legs[i].waitStage == stage) then
			CreatureObject(pPlayer):sendSystemMessage(self.legs[i].signalTitle)
			CreatureObject(pPlayer):sendSystemMessage(self.legs[i].signalDescription)

			return
		end
	end
end

-- Both halves are quoted data: the task's own journalEntryTitle against its own
-- Count. The .stf ships no counter string, so nothing here pretends to be one.
function somBlackguardProblemScreenPlay:progressLine(leg, killed)
	return leg.title .. ": " .. killed .. " of " .. leg.count .. "."
end

--[[ Kill counting  --  tasks 1, 3 and 5 ]]

function somBlackguardProblemScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	-- Persistence 1 is createObserver's optional 5th argument; without it the
	-- observer is not saved with the player and kills stop being credited after a
	-- relog. The flag above keeps a second grant from attaching a duplicate that
	-- would count every kill twice.
	createObserver(KILLEDCREATURE, "somBlackguardProblemScreenPlay", "notifyKilledCreature", pPlayer, 1)

	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function somBlackguardProblemScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "somBlackguardProblemScreenPlay", "notifyKilledCreature", pPlayer)

	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function somBlackguardProblemScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	local leg, index = self:getActiveLeg(pPlayer)

	if (leg == nil) then
		-- Nothing to count on this player right now. The observer stays attached
		-- through the hand-in stages, because the next kill leg is one signal
		-- away; it is only dropped in awardQuest.
		return 0
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil or leg.killTemplates[victimTemplate] == nil) then
		return 0
	end

	self:creditKill(pPlayer, leg, index)

	return 0
end

function somBlackguardProblemScreenPlay:creditKill(pPlayer, leg, index)
	local killed = self:getKills(pPlayer, index) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "kills_" .. index, tostring(killed))

	if (killed >= leg.count) then
		-- The Destroy Multiple task is done; its Wait for Signal child is now the
		-- live task and the quest sits there until the giver raises the signal.
		self:setStage(pPlayer, leg.waitStage)

		CreatureObject(pPlayer):sendSystemMessage(leg.signalTitle)
		CreatureObject(pPlayer):sendSystemMessage(leg.signalDescription)

		return
	end

	CreatureObject(pPlayer):sendSystemMessage(self:progressLine(leg, killed))
	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
end

--[[ task 7  --  Reward ]]

function somBlackguardProblemScreenPlay:awardQuest(pPlayer)
	self:setStage(pPlayer, self.finishedStage)
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))

	self:detachKillObserver(pPlayer)

	-- Bank Credits 5000. Experience Amount is 0, Faction Amount is 0 and lootName
	-- cannot be resolved; see THE REWARD.
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	CreatureObject(pPlayer):sendSystemMessage("You have received " .. self.rewardCredits .. " credits.")
	CreatureObject(pPlayer):sendSystemMessage("You have completed " .. self.questTitle .. ".")

	-- task 7 musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	-- allowRepeats true: reset so Dr. Lu can hand it out again.
	self:clearRunData(pPlayer)
	self:setStage(pPlayer, 0)
end
