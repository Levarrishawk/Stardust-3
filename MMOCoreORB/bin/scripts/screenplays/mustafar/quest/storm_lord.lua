--[[
Sickness of the Storm Lord  --  som_storm_lord

SOURCE OF RECORD

quest/som_storm_lord.qst in the client TREs, cross-checked against
string/en/quest/ground/som_storm_lord.stf. Every title, description, task name,
signal name, count, creature template and credit figure below is quoted from one
of those two files.

The .stf holds nineteen rows -- category, journal_entry_title,
journal_entry_description and a taskNN_journal_entry_title /
taskNN_journal_entry_description pair for tasks 01 through 08 -- and every one of
them is byte-for-byte the same string the .qst carries. It adds nothing the .qst
does not already have: no waypoint name, no item name, no menu text, no counter
string, no completion string.

THE TASK TREE, transcribed

	task 0  Nothing              isVisible false, showSystemMessages 0,
	                             no journal text
	                             musicOnActivate mus_mustafar_quest_exception.snd
	 task 1 Destroy Multiple     taskName storm_lord_one
	                             "Destroy the Storm Lord Minions"
	                             Target Server Template som_storm_lord_minion
	                             Count 15, RewardCredits 0
	  task 2 Wait for Signal     taskName storm_lord_two
	                             "Return to Jural"
	                             Signal Name storm_lord_minions_defeated
	                             createWaypoint 0, waitMarkerCreate 0
	   task 3 Destroy Multiple   taskName storm_lord_three
	                             "Destroy the Storm Lord Zealots"
	                             Target Server Template som_storm_lord_touched
	                             Count 10, RewardCredits 0
	    task 4 Wait for Signal   taskName storm_lord_four
	                             "Return to Jural"
	                             Signal Name storm_lord_zealots_defeated
	     task 5 Destroy Multiple taskName storm_lord_five
	                             "Defeat the Prophet of the Storm Lord"
	                             Target Server Template som_storm_lord_prophet
	                             Count 1, RewardCredits 0
	      task 6 Wait for Signal taskName storm_lord_six
	                             "Return to Jural"
	                             Signal Name storm_lord_prophet_defeated
	       task 7 Destroy Mult   taskName storm_lord_seven
	                             "Defeat the Storm Lord"
	                             Target Server Template som_storm_lord
	                             Count 1, RewardCredits 0
	        task 8 Wait for Sig  taskName storm_lord_eight
	                             "Return to Jural"
	                             Signal Name storm_lord_defeated
	         task 9 Reward       Bank Credits 0, CountItem 1, lootCount 1,
	                             lootName item_tow_proc_generic_03_01,
	                             Experience Amount 0, Faction Amount 0,
	                             isVisible false, showSystemMessages true,
	                             musicOnComplete mus_mustafar_quest_success.snd

Every task is the single child of the one above it, so the quest is a straight
eight-step ladder with no branching and no optional legs. It is the same shape as
som_blackguard_problem with one extra kill-and-return pair.

The quest <list> says journalEntryTitle "Sickness of the Storm Lord", category
Mustafar, journalVisible true, Level 80, Tier 4, Type solo, allowRepeats true,
Experience Type quest_combat, Experience Amount 0, Bank Credits 0,
completeWhenTasksComplete true, grantGcwPoints false. grantGcwPoints false is
honoured by doing nothing GCW-related, which is what this file does.

CHAINED OR INDEPENDENT

Independent. grantQuestOnComplete, grantQuestOnFail, prerequisiteQuests,
exclusionQuests, prerequisiteTasks, exclusionTasks,
conditionalQuestGrantQuestsThatMustBeCompleted and
conditionalQuestGrantQuestToGive are present on every one of the ten tasks and
every one of them is empty. Nothing grants this quest and this quest grants
nothing, so it is its own screenplay rather than a chapter of another one.

THE FOUR TARGETS  --  what the .qst names, and what is actually standing there

All four Destroy Multiple tasks name creature templates with the .qst's "som_"
authoring prefix. All four resolve to registered creatures -- each has a file in
mobile/custom_content/som/ and an includeFile line for it in that directory's
serverobjects.lua -- but only two of the four are placed in the world, and that
is the single biggest open item in this port. Nothing is spawned or substituted
to paper over it.

	som_storm_lord_minion  -> storm_lord_minion   serverobjects.lua:160
	                          customName "a storm lord minion", socialGroup ""
	                          PLACED x13 in screenplays/mustafar/regions/
	                          storm_lord_region.lua lines 43, 45, 64, 66, 68, 70,
	                          72, 74, 78, 80, 82, 84, 86
	                          ALSO spawned dynamically: mobile/lair/
	                          creature_dynamic/mustafar_storm_lord_pack.lua:2
	                          puts 2 of them in each pack, the pack is the only
	                          lair in mobile/spawn/mustafar_storm_lord_minions.lua,
	                          and managers/planet/mustafar_regions.lua:138 hangs
	                          that group off the storm_lord_ruins spawn region at
	                          (193, 4163) radius 500.
	som_storm_lord_touched -> storm_lord_touched  serverobjects.lua:162
	                          customName "storm_lord_touched"
	                          PLACED NOWHERE. See OPEN DECISION 1.
	som_storm_lord_prophet -> storm_lord_prophet  serverobjects.lua:161
	                          customName "storm_lord_prophet"
	                          PLACED NOWHERE. See OPEN DECISION 2.
	som_storm_lord         -> storm_lord          serverobjects.lua:158
	                          customName "Storm Lord", level 70
	                          PLACED x1, storm_lord_region.lua:90 at
	                          (194.4, 266.7, 4096.3), respawn 1200 s, with five
	                          storm_lord_guard around him on lines 92-100.

The 13 static minions each pass 120 as the third argument to spawnMobile, which
DirectorManager::spawnMobile (DirectorManager.cpp:2656-2677) reads as the respawn
timer in seconds, and the storm_lord_ruins lairs keep producing more, so Count 15
is reachable even though only 13 are hand-placed. Task 7's Count 1 against one
Storm Lord on a 1200 s respawn is reachable too. Tasks 3 and 5 are not reachable
at all as the world stands.

OPEN DECISION 1  --  som_storm_lord_touched has no placement

Task 3 wants ten of them. storm_lord_touched is registered and can be spawned,
but a scoped grep of every .lua in scripts/ for the quoted name finds it in
exactly one place: its own template file and the includeFile line that loads it.
Nothing spawns it. So this leg counts kills of storm_lord_touched and only
storm_lord_touched, exactly as the .qst names it, and today it will sit at 0 of
10 forever. That is reported rather than worked around, because the alternatives
are both changes this port is not allowed to make on its own:

  * Spawning ten of them would mean editing storm_lord_region.lua, which is
    another agent's file this port must not touch, and it would mean inventing
    ten positions that nothing in the shipped data supplies.
  * Counting storm_lord_zealot instead would be a silent substitution.
    storm_lord_zealot IS a separate registered creature (serverobjects.lua:163,
    customName "a storm lord zealot") and it IS placed, once, at
    storm_lord_region.lua:47 -- one against a required ten. Its templates entry
    (storm_lord_zealot.lua:29) points at object/mobile/som/storm_lord_touched.iff
    rather than a zealot of its own, which is a known open item elsewhere and is
    NOT touched or relied on here. Note also that the task's own title and
    description call the target "zealots" while the .qst's Target Server Template
    says touched, so the two names really are the same creature in the fiction --
    but fiction is not a template match, and the .qst is the source of record.

killTemplates below is a table for exactly this reason: if Aaron rules that the
zealot counts, adding one name to one table is the whole change.

OPEN DECISION 2  --  som_storm_lord_prophet has no placement

Same situation, one target instead of ten. storm_lord_prophet is registered
(serverobjects.lua:161) with customName "storm_lord_prophet", which is a
placeholder name rather than a display name, and the same scoped grep finds no
spawn for it anywhere. The shipped conversation table
string/en/conversation/som_storm_lord_jural.stf describes him -- "Dr. Namdaot no
longer directly speaks to his followers. Instead, he only talks to his most
devoted follower, who then preaches to all the others" -- and Jural warns that
"the Prophet is nearly as strong as Dr. Namdaot is", but nothing that shipped
says where he stands. No position is invented.

NO WAYPOINTS  --  the shipped data has none

All four Wait for Signal tasks say createWaypoint 0, waitMarkerCreate 0,
waitMarkerBuilding 0 and waitMarkerX / waitMarkerY / waitMarkerZ 0, and every
task in the file carries Planet "tatooine" with LocationX / LocationY /
LocationZ 0.0 -- the .qst editor's empty default, not a place. Jural's position is
nowhere in the shipped data. So this file hands out no waypoint at all. That is a
quoted absence, not an omission: som_glyph_hunt's equivalent hand-in tasks DO
carry createWaypoint true and real mustafar coordinates, so the field is plainly
meaningful in this format and this quest plainly does not use it.

THE REWARD

Bank Credits is 0 on the Reward task and 0 in the <list>, so there is no credit
payout, and none is invented. Experience Amount is 0 and the <list>'s Experience
Type quest_combat with Experience Amount 0 is journal-level data that only the
quest system awards -- there is no quest system row here, so nothing stands in
for it. Faction Amount is 0 against Faction Name "Rebel", so there is no faction
award either; the name with a zero amount is the editor's default. grantGcwPoints
is false.

lootCount 1 / lootName item_tow_proc_generic_03_01 is NOT granted, and it is the
only thing this quest actually pays. lootName is a live server-side static-item
name, not an object template. Nothing in this tree is called
item_tow_proc_generic_03_01, there is no datatables row anywhere in the extract
that maps it to a template, and string/en in the extract holds only
conversation/, quest/, dance_advancement.stf and performance.stf -- so there is
not even a display name for it to be matched by. It is left unresolved rather
than replaced with a guess. This is the same class of unresolvable reward already
recorded in hidden_treasure.lua and bounty_hunts.lua, and it means that until
Aaron rules on the item, completing this quest pays nothing but the completion
message. That is stated plainly rather than hidden behind a stand-in reward.

The Reward task's CountItem 1 / CountWeapon 1 / CountArmor 1 and its
Speed / Damage / Efficiency / Elemental Value / Quality 0.1 are the loot-quality
knobs that go with the unresolved lootName, so they are recorded here and go
nowhere as well.

NO GIVER  --  open question, deliberately not filled

Jural is named in all four hand-in entries and in the first task's description,
and the shipped conversation table string/en/conversation/som_storm_lord_jural.stf
carries her entire dialogue tree -- she introduces herself as "Jural, a reporter
for the Corellian Times", her dying brother is Talper, and the Storm Lord is
"Dr. Namdaot" -- and it walks the player through exactly this ladder: minions,
then zealots, then the Prophet, then the Storm Lord, then "take this as payment
for saving the life of my brother". None of that says where she stands or what
starts the quest:

  * reporter_jural is a registered creature (mobile/custom_content/som/
    reporter_jural.lua, included at that directory's serverobjects.lua:93,
    customName "Reporter Jural") and it is spawned NOWHERE in this tree.
    Neither is reporter_talper (serverobjects.lua:94), the sick brother the whole
    quest is about.
  * Her conversationTemplate is "" (reporter_jural.lua:37) and there is no jural
    file in mobile/conversations/mustafar/ for it to point at.
  * There is no quest_start object for this quest in snapshot/mustafar.ws.

So this file spawns nobody, invents no position and writes no conversation.
grantQuest and the four signal functions are the seams a giver's conversation
handler calls once Aaron says where Jural stands. The four signal functions ARE
storm_lord_minions_defeated, storm_lord_zealots_defeated,
storm_lord_prophet_defeated and storm_lord_defeated -- the .qst raises all four
from the hand-in and there is nothing else in the shipped data that can raise
them.

NO JOURNAL

som_storm_lord has no row in datatables/player/quests.iff. The table the server
loads is stardust_03.tre's, which wins the TreFiles order in conf/config.lua; its
307 rows contain no Mustafar entries but the 45 exploration markers. Adding a row
would mean authoring a TRE. So progress lives in persistent screenplay data on
the player and the journal text goes out as system messages, the same as
bounty_hunts.lua and map_exploration.lua. No id is added to
managers/quest/quest_manager.lua, because an id with no table row does nothing.

showSystemMessages is true on all eight tasks that have journal text and 0 only
on task 0, which has none, so the flag is honoured as written. Task 9, the
Reward, says true and has no journal text of its own; its completion message is
the one this file sends.
--]]

somStormLordScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "somStormLordScreenPlay",

	-- [list] journalEntryTitle / journalEntryDescription / Level / Tier /
	-- allowRepeats / category / grantGcwPoints.
	questTitle = "Sickness of the Storm Lord",
	questDescription = "You have met a reporter from the Corellian Times whose brother has apparently been made sick by someone calling himself the Storm Lord. She believes that if you can reduce his worshippers her brother will recover.",
	questLevel = 80,
	questTier = 4,
	repeatable = true,
	grantGcwPoints = false,

	-- task 0 musicOnActivate, task 9 musicOnComplete. "exception" is what the
	-- shipped file says on the activate leg; it is quoted, not corrected.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst. The kill counter has no shipped sound; this is the one
	-- map_exploration.lua:412 uses for its own counters.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	--[[ The ladder, in the order the .qst nests it.

	Each kill leg carries the stage it runs in, its own journal text, its Count,
	the registered template that satisfies it, and the Wait for Signal task that
	follows it. Reading it as one table keeps the four legs identical in behaviour
	and makes the differences between them pure data.

		stage 1  task 1 + task 2   fifteen minions, then
		                           storm_lord_minions_defeated
		stage 3  task 3 + task 4   ten touched, then storm_lord_zealots_defeated
		stage 5  task 5 + task 6   the Prophet, then storm_lord_prophet_defeated
		stage 7  task 7 + task 8   the Storm Lord, then storm_lord_defeated

	The even stages between them are the hand-ins: the kill leg is done and the
	quest is waiting on its signal.

	killTemplates is a set rather than a single name on purpose. Each one holds
	exactly the template the .qst's Target Server Template resolves to and nothing
	else, so no substitution is happening -- but OPEN DECISION 1 is a one-name
	change to one of these tables if Aaron rules that way.
	--]]
	legs = {
		{
			killStage = 1,
			waitStage = 2,

			-- task 1, Destroy Multiple.
			taskName = "storm_lord_one",
			title = "Destroy the Storm Lord Minions",
			description = "Jural tells you that the Storm Lord seems to gain power from the number of people who worship him. If you were to kill fifteen of his minions perhaps it will weaken him enough to cure Jural's brother.",
			targetServerTemplate = "som_storm_lord_minion",
			killTemplates = { ["storm_lord_minion"] = true },
			count = 15,
			rewardCredits = 0,

			-- task 2, Wait for Signal.
			signalTaskName = "storm_lord_two",
			signalTitle = "Return to Jural",
			signalDescription = "Now that you have weakened the Storm Lord's power base, return to Jural and check on the status of her brother.",
			signal = "storm_lord_minions_defeated",
		},
		{
			killStage = 3,
			waitStage = 4,

			-- task 3, Destroy Multiple. Target Server Template
			-- som_storm_lord_touched, which is registered and placed nowhere;
			-- see OPEN DECISION 1. storm_lord_zealot is deliberately absent.
			taskName = "storm_lord_three",
			title = "Destroy the Storm Lord Zealots",
			description = "It would seem that defeating the Storm Lord's minions didn't have any effect on his power. Perhaps if you were to destroy ten of his zealots that would have some effect.",
			targetServerTemplate = "som_storm_lord_touched",
			killTemplates = { ["storm_lord_touched"] = true },
			count = 10,
			rewardCredits = 0,

			-- task 4, Wait for Signal.
			signalTaskName = "storm_lord_four",
			signalTitle = "Return to Jural",
			signalDescription = "Without his zealots, the Storm Lord's power should be reduced. Return to Jural to see if her brother is any better.",
			signal = "storm_lord_zealots_defeated",
		},
		{
			killStage = 5,
			waitStage = 6,

			-- task 5, Destroy Multiple. Target Server Template
			-- som_storm_lord_prophet, registered and placed nowhere; see
			-- OPEN DECISION 2.
			taskName = "storm_lord_five",
			title = "Defeat the Prophet of the Storm Lord",
			description = "Jural's brother is showing signs of recovery but is still very sick. The Storm Lord has a man who calls himself the Prophet of the Storm Lord and is the most faithful of all followers. Without his support the Storm Lord should lose a great deal of strength.",
			targetServerTemplate = "som_storm_lord_prophet",
			killTemplates = { ["storm_lord_prophet"] = true },
			count = 1,
			rewardCredits = 0,

			-- task 6, Wait for Signal.
			signalTaskName = "storm_lord_six",
			signalTitle = "Return to Jural",
			signalDescription = "The Storm Lord has lost his chief follower. Jural's brother should be feeling much better this time. Return to Jural and check on his status.",
			signal = "storm_lord_prophet_defeated",
		},
		{
			killStage = 7,
			waitStage = 8,

			-- task 7, Destroy Multiple. Target Server Template som_storm_lord.
			taskName = "storm_lord_seven",
			title = "Defeat the Storm Lord",
			description = "Although Jural's brother is feeling much better, he is still not recovered. The only answer is to defeat the Storm Lord, himself.",
			targetServerTemplate = "som_storm_lord",
			killTemplates = { ["storm_lord"] = true },
			count = 1,
			rewardCredits = 0,

			-- task 8, Wait for Signal.
			signalTaskName = "storm_lord_eight",
			signalTitle = "Return to Jural",
			signalDescription = "Now that the Storm Lord has been defeated, return to Jural and see if there has been any improvement in her brother's condition.",
			signal = "storm_lord_defeated",
		},
	},

	-- task 9, Reward. Bank Credits really is 0; lootName is recorded and not
	-- granted. See THE REWARD.
	rewardCredits = 0,
	rewardLootName = "item_tow_proc_generic_03_01",
	rewardLootCount = 1,

	-- The stage the ladder reaches when task 9 has paid out.
	finishedStage = 9,
}

registerScreenPlay("somStormLordScreenPlay", true)

-- Nothing is placed in the world at boot: the .qst names no giver, no terminal
-- and no location, and inventing one is not this screenplay's call. The two
-- unplaced targets are reported as open decisions rather than spawned from here,
-- because storm_lord_region.lua owns that valley's placements. start() still
-- exists because DirectorManager::startScreenPlay (DirectorManager.cpp:3605-3611)
-- calls "start" by name on every screenplay registered with true.
function somStormLordScreenPlay:start()
end

--[[ State

Persistent screenplay data on the player, so the ladder survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0" on every read.

	stage       0  not started
	            1  task 1 live -- fifteen minions
	            2  task 2 live -- waiting on storm_lord_minions_defeated
	            3  task 3 live -- ten touched
	            4  task 4 live -- waiting on storm_lord_zealots_defeated
	            5  task 5 live -- the Prophet
	            6  task 6 live -- waiting on storm_lord_prophet_defeated
	            7  task 7 live -- the Storm Lord
	            8  task 8 live -- waiting on storm_lord_defeated
	            9  finished
	kills_<n>   kills credited on leg n of the current run
	observer    1 while this player carries the KILLEDCREATURE observer
	runs        completed runs; allowRepeats is true, so this only counts
--]]

function somStormLordScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function somStormLordScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function somStormLordScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function somStormLordScreenPlay:getKills(pPlayer, index)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills_" .. index)) or 0
end

-- The leg whose kill stage the player is standing in, or nil when the quest is
-- not on a kill step at all.
function somStormLordScreenPlay:getActiveLeg(pPlayer)
	local stage = self:getStage(pPlayer)

	for i = 1, #self.legs do
		if (self.legs[i].killStage == stage) then
			return self.legs[i], i
		end
	end

	return nil, 0
end

function somStormLordScreenPlay:clearRunData(pPlayer)
	for i = 1, #self.legs do
		deleteScreenPlayData(pPlayer, self.screenplayName, "kills_" .. i)
	end
end

--[[ Entry points

grantQuest and the four signal functions are what Jural's conversation handler
calls once there is one. None of them sends a refusal: with no giver in the
shipped data there is no voice to put a refusal in, so they only report whether
they did anything and leave the wording to whoever ends up owning the
conversation.

	canGrantQuest(pPlayer)            may this character start it
	grantQuest(pPlayer)               task 1 goes live
	signalMinionsDefeated(pPlayer)    raise storm_lord_minions_defeated  -- task 2
	signalZealotsDefeated(pPlayer)    raise storm_lord_zealots_defeated  -- task 4
	signalProphetDefeated(pPlayer)    raise storm_lord_prophet_defeated  -- task 6
	signalStormLordDefeated(pPlayer)  raise storm_lord_defeated -- task 8, which is
	                                  what fires the Reward
	reportProgress(pPlayer)           read-only progress, the missing journal page
--]]

function somStormLordScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	-- [list] allowRepeats true, read from the table rather than assumed.
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function somStormLordScreenPlay:grantQuest(pPlayer)
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

	-- task 0 musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)

	return true
end

function somStormLordScreenPlay:signalMinionsDefeated(pPlayer)
	return self:raiseSignal(pPlayer, 1)
end

function somStormLordScreenPlay:signalZealotsDefeated(pPlayer)
	return self:raiseSignal(pPlayer, 2)
end

function somStormLordScreenPlay:signalProphetDefeated(pPlayer)
	return self:raiseSignal(pPlayer, 3)
end

function somStormLordScreenPlay:signalStormLordDefeated(pPlayer)
	return self:raiseSignal(pPlayer, 4)
end

-- One Wait for Signal task completing. The guard is what makes calling it early
-- do nothing: the signal only lands while its own leg is the one waiting.
function somStormLordScreenPlay:raiseSignal(pPlayer, index)
	if (pPlayer == nil) then
		return false
	end

	local leg = self.legs[index]

	if (self:getStage(pPlayer) ~= leg.waitStage) then
		return false
	end

	local nextLeg = self.legs[index + 1]

	if (nextLeg == nil) then
		-- task 8 was the last one, so its completion is what fires task 9.
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
function somStormLordScreenPlay:reportProgress(pPlayer)
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
function somStormLordScreenPlay:progressLine(leg, killed)
	return leg.title .. ": " .. killed .. " of " .. leg.count .. "."
end

--[[ Kill counting  --  tasks 1, 3, 5 and 7 ]]

function somStormLordScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	-- Persistence 1 is createObserver's optional 5th argument; without it the
	-- observer is not saved with the player and kills stop being credited after a
	-- relog. The flag above keeps a second grant from attaching a duplicate that
	-- would count every kill twice.
	createObserver(KILLEDCREATURE, "somStormLordScreenPlay", "notifyKilledCreature", pPlayer, 1)

	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function somStormLordScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "somStormLordScreenPlay", "notifyKilledCreature", pPlayer)

	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function somStormLordScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

function somStormLordScreenPlay:creditKill(pPlayer, leg, index)
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

--[[ task 9  --  Reward ]]

function somStormLordScreenPlay:awardQuest(pPlayer)
	self:setStage(pPlayer, self.finishedStage)
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))

	self:detachKillObserver(pPlayer)

	-- Bank Credits is 0 here, so there is deliberately no addBankCredits call:
	-- paying anything would be inventing a reward. Experience Amount is 0,
	-- Faction Amount is 0, grantGcwPoints is false, and lootName cannot be
	-- resolved; see THE REWARD. The completion line is all this task can honestly
	-- deliver today.
	CreatureObject(pPlayer):sendSystemMessage("You have completed " .. self.questTitle .. ".")

	-- task 9 musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	-- allowRepeats true: reset so Jural can hand it out again.
	self:clearRunData(pPlayer)
	self:setStage(pPlayer, 0)
end
