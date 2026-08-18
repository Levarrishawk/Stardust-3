--[[
Mustafar bounty hunts  --  the seven standalone hunting quests

	som_blistmok_hunt_25     "The Deadly Raptors"
	som_jundak_hunt_15       "The Jagged Teeth"
	som_lava_beetle_hunt_15  "A Strange Gem"
	som_lava_flea_hunt       "Lava Flea Hunt"
	som_tanray_hunt_20       "The Tasty Tanray"
	som_tulrus_hunt_20       "Beasts From the East"
	som_xandank_hunt_25      "Hunter Becomes the Hunted"

SOURCE OF RECORD

The seven .qst files of those names in the client TREs. Every title, description,
count, loot name, loot percentage, credit amount, taskName and level below is
quoted from them; the same five strings per quest also appear in
string/en/quest/ground/<name>.stf, which agrees with the .qst word for word.

All seven are the same three-task shape, so they are one table and one engine
rather than seven copies:

	task 0  Nothing              musicOnActivate mus_mustafar_quest_exception.snd
	task 1  Destroy Multiple     Social Group + Count
	        (or Destroy Multiple and Loot: Social Group + LootItemName +
	         NumberItemsRequired + LootDropPercent)
	task 2  Reward               Bank Credits, musicOnComplete
	                             mus_mustafar_quest_success.snd

The Reward hangs off the Destroy Multiple task as its child and the [list] says
completeWhenTasksComplete true, so the payout fires the moment the count is met.
There is no Wait for Signal anywhere in these seven and therefore no hand-in step
in the shipped data; turnInHunt below is that payout, exposed so a giver can also
drive it if one is ever built.

NO GIVER  --  open question, deliberately not filled

Nothing in any of the seven .qst files, nor in their .stf files, names a quest
giver, a terminal, a conversation or a location. Every task carries Planet
"tatooine" with LocationX/Y/Z 0,0,0 and createWaypoint 0, which is the .qst
editor's empty default rather than a place. So this screenplay spawns nothing and
hands out no waypoints; grantHunt / turnInHunt are the entry points a giver's
conversation handler calls once Aaron says who the giver is.

NO JOURNAL

None of the seven has a row in datatables/player/quests.iff -- the table the
server loads is stardust_03.tre's, whose only Mustafar rows are the 45
exploration markers -- so there are no journal entries to write and no ids to add
to managers/quest/quest_manager.lua. Progress is persistent screenplay data, the
same as map_exploration.lua, and the journalEntryDescription lines go out as
system messages because that is the only channel left. That is also why the
per-quest showSystemMessages flag is not honoured literally: task 1 of
som_jundak_hunt_15 says 0, and with no journal to fall back on that quest would
run completely silent and be indistinguishable from a broken one. The shipped
values are recorded next to each entry below.

SOCIAL GROUP IS NOT USABLE  --  templates enumerated instead

Task 1 of each quest matches kills by Social Group. Every ported SOM creature in
this tree carries socialGroup "townsperson" or "" (mobile/custom_content/som/),
so a group match would select everything or nothing. Each hunt therefore lists
the concrete creature templates of its group, which is the same set the group
would have picked. Every name below is registered -- each one has a file in
mobile/custom_content/som/ and an includeFile line for it in that directory's
serverobjects.lua; a diff of the two lists shows every file in the directory is
included, so nothing here is a dead name.

The five groups map_exploration.lua already resolved are reused unchanged
(map_exploration.lua:148, 158, 168, 186, 196), including its two rules: tamed
pets are left out (trained_blistmok) and the ORF instance variants are counted
(orf_tulrus, orf_xandank). jundak and tanray are new here and follow the same
rules -- orf_jundak is in, and tanray has exactly one template in the tree.

Deliberately NOT counted, and flagged rather than guessed:

  * som_kenobi_blistmok, som_kenobi_reunite_tulrus -- scripted spawns owned by
    kenobi_spine.lua and reunite_shard.lua. map_exploration excludes them too.
  * cinderclaw, deathsting, scorching_terror, tremor_foot -- named uniques.
    Their shared client templates borrow the group meshes (shared_cinderclaw.iff
    -> appearance/jundak.sat, shared_deathsting.iff and
    shared_scorching_terror.iff -> appearance/kubaza_beetle.sat,
    shared_tremor_foot.iff -> appearance/tulrus.sat), but a shared mesh is not a
    shared social group -- som_kenobi_blistmok borrows appearance/blistmok.sat
    and is certainly not a wild blistmok. Nothing that shipped states their group,
    so they are left out until Aaron rules.

REPEATS

Every [list] says allowRepeats true, on all seven, so every hunt resets to
grantable on payout and the run count is kept. The flag is read per quest from
the table below rather than assumed, so correcting one entry is enough if Aaron
rules differently. One anomaly, recorded not silently normalised: task 1 of
som_blistmok_hunt_25 says allowRepeats 0 while its own task 0, its Reward task
and its [list] all say true. A single-leg task fires once per run either way, so
the quest-level flag is the one that decides anything here.

THE TWO LOOT LEGS

som_jundak_hunt_15 and som_lava_beetle_hunt_15 are Destroy Multiple and Loot:
the kill only counts on a LootDropPercent roll (50 and 65). The roll is honoured;
no inventory item is minted for it. That follows samaritan.lua:479-511, which is
the same task type in this tree and rolls the percentage without minting -- and
"Jagged Jundak Tooth" and "Kubaza Beetle Bead" are live server-side static item
names, not object templates. object/tangible/item/som/lava_beetle_beads.iff does
exist and is registered (object/custom_content/tangible/item/som/
serverobjects.lua:18) if real beads are wanted later; there is no jundak tooth
template under any name.

THE REWARD

Bank Credits only. lootName on the Reward task is empty in all seven .qst files
(the attribute is present with no value), Experience Amount is 0, and the [list]
Experience Amount 1000 / quest_combat is journal-level data that only the quest
system awards -- there is no quest system row here, so nothing is invented to
stand in for it. addBankCredits matches "Bank Credits", as in
collectors_business.lua:425 and kenobi_spine.lua:781.

One shipped inconsistency, quoted and left alone: som_lava_flea_hunt's [list]
description says "a bounty of 7500 credits", while its Reward task says Bank
Credits 7000. The task is what pays.

KILL COUNTING

One persistent KILLEDCREATURE observer per player, the mechanism every hunt leg
in this tree uses (map_exploration.lua:346, historian.lua:583,
reunite_shard.lua:607, samaritan.lua:403, kenobi_spine.lua:1057). The 5th
argument 1 is createObserver's persistence flag -- without it the observer is not
saved with the player and the counts silently stop being credited after a
relog. Because several of these seven can be active at once, the observer is
created once and tracked by a screenplay-data flag so a second grant does not
attach a duplicate that would count every kill twice.
--]]

bountyHuntsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "bountyHuntsScreenPlay",

	-- task 0 musicOnActivate and task 2 musicOnComplete, identical on all seven.
	-- "exception" is what the shipped file says on the activate leg; it is quoted,
	-- not corrected.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst. The counter tick has no shipped sound; this is the one
	-- map_exploration.lua:412 uses for its own hunt ticks.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	hunts = {
		{
			key = "blistmok",
			quest = "som_blistmok_hunt_25",
			-- [list] journalEntryTitle / journalEntryDescription.
			questTitle = "The Deadly Raptors",
			questDescription = "The miners are under constant threat of being attacked by deadly blistmok. You should hunt a few of them down and make the world safer.",
			-- task 1, Destroy Multiple. No taskName in this file.
			-- showSystemMessages true, allowRepeats 0; see REPEATS.
			taskTitle = "Kill 25 Blistmoks",
			taskDescription = "Hunt down and kill 25 blistmoks that roam all over Mustafar.",
			socialGroup = "blistmok",
			count = 25,
			-- task 2 Bank Credits, [list] Level, [list] allowRepeats.
			rewardCredits = 7500,
			questLevel = 65,
			repeatable = true,
			-- map_exploration.lua:158. trained_blistmok is a pet.
			killTemplates = { ["blistmok"] = true, ["blistmok_shrieker"] = true, ["blistmok_trampler"] = true },
		},
		{
			key = "jundak",
			quest = "som_jundak_hunt_15",
			questTitle = "The Jagged Teeth",
			questDescription = "The image of the Mustafarian covered with those horrible wounds has made you realize that the jundak need to be destroyed. Maybe if you collect the instruments that they use to inflict such terrible wounds you can help keep the miners safe.",
			-- task 1, Destroy Multiple and Loot. No taskName. showSystemMessages 0.
			taskTitle = "Collect 15 Jagged Jundak Teeth",
			taskDescription = "Hunt down and kill jundak until you can collect 15 of their jagged teeth.",
			socialGroup = "jundak",
			-- NumberItemsRequired 15, LootItemName, LootDropPercent 50.
			count = 15,
			lootName = "Jagged Jundak Tooth",
			lootDropPercent = 50,
			rewardCredits = 8000,
			questLevel = 70,
			repeatable = true,
			-- Same rules map_exploration.lua uses for the other five groups.
			killTemplates = { ["jundak"] = true, ["jundak_devourer"] = true, ["orf_jundak"] = true },
		},
		{
			key = "lava_beetle",
			quest = "som_lava_beetle_hunt_15",
			questTitle = "A Strange Gem",
			-- The trailing space is in the shipped string; it is not a typo here.
			questDescription = "Kubaza beetles have developed a unique physiology. A lava beetle's blood is close in consistency and temperature to the lava flows where it makes its home. On death, the beetle's body bursts open, and the lava-like blood explodes everywhere. When this expulsed material cools, it occasionally forms into clear, smooth beads. These beads fetch a very high price on the open market. ",
			-- task 1, Destroy Multiple and Loot. showSystemMessages true.
			taskName = "mustafar_lava_beetle_hunt_one",
			taskTitle = "Collect Kubaza Beetle Beads",
			taskDescription = "Collect 15 of the kubaza beetle beads that occasionally form when a kubaza beetle dies and its body explodes. The beads do not always form, which might account for their value.",
			socialGroup = "lava_beetle",
			count = 15,
			lootName = "Kubaza Beetle Bead",
			lootDropPercent = 65,
			rewardCredits = 5000,
			questLevel = 70,
			repeatable = true,
			-- map_exploration.lua:168. The kubaza beetle is the lava beetle.
			killTemplates = { ["kubaza_beetle"] = true, ["kubaza_soldier_beetle"] = true, ["kubaza_worker_beetle"] = true },
		},
		{
			key = "lava_flea",
			quest = "som_lava_flea_hunt",
			questTitle = "Lava Flea Hunt",
			-- Says 7500; the Reward task pays 7000. See THE REWARD.
			questDescription = "The Mensix Mining company is offering a bounty of 7500 credits for every 15 lava fleas killed.",
			-- task 1, Destroy Multiple. showSystemMessages true. The other two tasks
			-- are named lava_flea_hunt_one (task 0) and lava_flea_hunt_three (task 2).
			taskName = "lava_flea_hunt_two",
			taskTitle = "Hunt 15 Lava Fleas",
			taskDescription = "Hunt down and eliminate fifteen lava fleas.",
			socialGroup = "lava_flea",
			count = 15,
			rewardCredits = 7000,
			questLevel = 65,
			repeatable = true,
			-- map_exploration.lua:148.
			killTemplates = { ["lava_flea"] = true, ["lava_flea_smoldering"] = true },
		},
		{
			key = "tanray",
			quest = "som_tanray_hunt_20",
			questTitle = "The Tasty Tanray",
			questDescription = "Mustafarians seem to love the taste of tanray meat. There is a very good market in the hunting of tanray.",
			-- task 1, Destroy Multiple. No taskName. showSystemMessages true.
			taskTitle = "Hunt Down 20 Tanray",
			taskDescription = "Hunt down 20 tanray for their meat.",
			socialGroup = "tanray",
			count = 20,
			rewardCredits = 7000,
			questLevel = 75,
			repeatable = true,
			-- tanray.lua is the only tanray in mobile/custom_content/som/; there is
			-- no variant and no orf_ version of it.
			killTemplates = { ["tanray"] = true },
		},
		{
			key = "tulrus",
			quest = "som_tulrus_hunt_20",
			questTitle = "Beasts From the East",
			questDescription = "Tulrus are large, dangerous creatures but for the most part they will not attack if unprovoked. The problem is that their numbers are increasing and miners are coming face to face with these beasts more frequently. The numbers of these creatures need to be reduced for safety.",
			-- task 1, Destroy Multiple. showSystemMessages true.
			taskName = "mustafar_tulrus_hunt_one",
			taskTitle = "Kill 20 Tulrus",
			taskDescription = "The Tulrus population has obviously gotten out of hand. Too often the miners are coming face to face with these dangerous creatures. It is important that the numbers of Tulrus be reduced.",
			socialGroup = "tulrus",
			count = 20,
			rewardCredits = 7000,
			questLevel = 75,
			repeatable = true,
			-- map_exploration.lua:196.
			killTemplates = { ["tulrus"] = true, ["tulrus_magma_drenched"] = true, ["orf_tulrus"] = true },
		},
		{
			key = "xandank",
			quest = "som_xandank_hunt_25",
			questTitle = "Hunter Becomes the Hunted",
			questDescription = "Xandank generally avoid the miners but when they get into large enough packs they become fearless. For the safety of the miners it is important to cull the numbers of Xandank that are roaming the area.",
			-- task 1, Destroy Multiple. showSystemMessages true.
			taskName = "mustafar_xandank_hunt_one",
			taskTitle = "Kill 25 Xandank",
			taskDescription = "Large Xandank packs are very dangerous and cause a serious hazard to the miners in the region. Culling the numbers of adult Xandank will go a long way to protecting the miners.",
			socialGroup = "xandank",
			count = 25,
			rewardCredits = 6500,
			questLevel = 75,
			repeatable = true,
			-- map_exploration.lua:186.
			killTemplates = { ["xandank"] = true, ["xandank_onyx_plated"] = true, ["xandank_patriarch"] = true, ["orf_xandank"] = true },
		},
	},
}

registerScreenPlay("bountyHuntsScreenPlay", true)

-- Nothing is placed in the world at boot: no .qst in this set names a giver, a
-- terminal or a location, and inventing one is not this screenplay's call. start()
-- still exists because DirectorManager::startScreenPlay
-- (DirectorManager.cpp:3605-3611) calls "start" by name on every screenplay
-- registered with true.
function bountyHuntsScreenPlay:start()
end

--[[ State

Persistent screenplay data on the player's ghost, so a hunt survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("")
is nil, hence the "or 0" on every read.

	active_<key>  1 while that hunt is running
	count_<key>   kills credited so far on the current run
	runs_<key>    hunts of that kind finished and paid
	observer      1 while this player has the KILLEDCREATURE observer attached
--]]

function bountyHuntsScreenPlay:getHunt(key)
	for i = 1, #self.hunts do
		if (self.hunts[i].key == key) then
			return self.hunts[i]
		end
	end

	return nil
end

function bountyHuntsScreenPlay:isHuntActive(pPlayer, key)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "active_" .. key)) or 0) == 1
end

function bountyHuntsScreenPlay:getHuntCount(pPlayer, key)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count_" .. key)) or 0
end

-- How many times this player has finished and been paid for that hunt. A giver
-- can use it to tell a first-timer from a regular; the engine uses it to refuse a
-- second run of anything whose [list] said allowRepeats false.
function bountyHuntsScreenPlay:getHuntRuns(pPlayer, key)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs_" .. key)) or 0
end

function bountyHuntsScreenPlay:hasAnyHuntActive(pPlayer)
	for i = 1, #self.hunts do
		if (self:isHuntActive(pPlayer, self.hunts[i].key)) then
			return true
		end
	end

	return false
end

--[[ Entry points

grantHunt and turnInHunt are what a giver's conversation handler calls. Neither
sends a refusal message: with no giver in the shipped data there is no voice to
put a refusal in, so both just report whether they did anything and leave the
wording to whoever ends up owning the conversation.
--]]

function bountyHuntsScreenPlay:canGrantHunt(pPlayer, key)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	local hunt = self:getHunt(key)

	if (hunt == nil or self:isHuntActive(pPlayer, key)) then
		return false
	end

	-- [list] allowRepeats, read per quest rather than assumed.
	if (not hunt.repeatable and self:getHuntRuns(pPlayer, key) > 0) then
		return false
	end

	return true
end

function bountyHuntsScreenPlay:grantHunt(pPlayer, key)
	if (not self:canGrantHunt(pPlayer, key)) then
		return false
	end

	local hunt = self:getHunt(key)

	writeScreenPlayData(pPlayer, self.screenplayName, "active_" .. key, "1")
	writeScreenPlayData(pPlayer, self.screenplayName, "count_" .. key, "0")

	self:attachKillObserver(pPlayer)

	-- The [list] and task 1 journal text. There is no journal in this tree, so
	-- this is the only place the player ever reads it; cursed_shard.lua does the
	-- same with its own journalEntryDescription lines.
	CreatureObject(pPlayer):sendSystemMessage(hunt.questTitle)
	CreatureObject(pPlayer):sendSystemMessage(hunt.questDescription)
	CreatureObject(pPlayer):sendSystemMessage(hunt.taskDescription)

	-- task 0 musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)

	return true
end

-- Task 2, the Reward. It is the child of the Destroy Multiple task, so the count
-- being met is what fires it and creditKill calls this directly. Exposed because
-- it is also the natural hand-in hook if a giver ever wants one; the guards mean
-- calling it early does nothing.
function bountyHuntsScreenPlay:turnInHunt(pPlayer, key)
	if (pPlayer == nil or not self:isHuntActive(pPlayer, key)) then
		return false
	end

	local hunt = self:getHunt(key)

	if (self:getHuntCount(pPlayer, key) < hunt.count) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "active_" .. key)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count_" .. key)
	writeScreenPlayData(pPlayer, self.screenplayName, "runs_" .. key, tostring(self:getHuntRuns(pPlayer, key) + 1))

	-- Bank Credits, the whole of the Reward task: lootName is empty and
	-- Experience Amount is 0 on all seven.
	CreatureObject(pPlayer):addBankCredits(hunt.rewardCredits, true)
	CreatureObject(pPlayer):sendSystemMessage("You have received " .. hunt.rewardCredits .. " credits.")
	CreatureObject(pPlayer):sendSystemMessage("You have completed " .. hunt.questTitle .. ".")

	-- task 2 musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	if (not self:hasAnyHuntActive(pPlayer)) then
		self:detachKillObserver(pPlayer)
	end

	return true
end

-- Read-only; a giver can use it for "how am I doing", and it is the closest thing
-- to the journal page these quests do not have.
function bountyHuntsScreenPlay:reportHuntProgress(pPlayer, key)
	local hunt = self:getHunt(key)

	if (hunt == nil or pPlayer == nil) then
		return
	end

	if (not self:isHuntActive(pPlayer, key)) then
		return
	end

	CreatureObject(pPlayer):sendSystemMessage(self:progressLine(hunt, self:getHuntCount(pPlayer, key)))
end

-- Both halves of the line are quoted data: the loot legs count a named item, the
-- plain kill legs count against the task's own title.
function bountyHuntsScreenPlay:progressLine(hunt, killed)
	local label = hunt.lootName or hunt.taskTitle

	return label .. ": " .. killed .. " of " .. hunt.count .. "."
end

--[[ Kill counting ]]

function bountyHuntsScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	-- Persistence 1 is createObserver's optional 5th argument; without it the
	-- observer is not saved with the player and kills stop being credited after a
	-- relog. Several of these hunts can run at once, so the flag above is what
	-- keeps a second grant from attaching a duplicate that would double-count.
	createObserver(KILLEDCREATURE, "bountyHuntsScreenPlay", "notifyKilledCreature", pPlayer, 1)

	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function bountyHuntsScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "bountyHuntsScreenPlay", "notifyKilledCreature", pPlayer)

	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function bountyHuntsScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (not self:hasAnyHuntActive(pPlayer)) then
		-- Nothing left to count on this player. A non-zero return is how
		-- ScreenPlayObserverImplementation removes an observer, so this also
		-- clears a stale one left over from an older character.
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")

		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil) then
		return 0
	end

	for i = 1, #self.hunts do
		local hunt = self.hunts[i]

		if (hunt.killTemplates[victimTemplate] ~= nil and self:isHuntActive(pPlayer, hunt.key)) then
			self:creditKill(pPlayer, hunt)

			-- The template sets are disjoint, so one kill can only ever answer one
			-- of the seven.
			return 0
		end
	end

	return 0
end

function bountyHuntsScreenPlay:creditKill(pPlayer, hunt)
	-- Destroy Multiple and Loot: the kill only counts if the drop lands.
	-- getRandomNumber(100) is 1-100 inclusive, the same roll samaritan.lua:493
	-- makes against its own LootDropPercent. A failed roll is silent on purpose;
	-- the tick below is what tells the player anything happened.
	if (hunt.lootDropPercent ~= nil and getRandomNumber(100) > hunt.lootDropPercent) then
		return
	end

	local killed = self:getHuntCount(pPlayer, hunt.key) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "count_" .. hunt.key, tostring(killed))

	if (killed >= hunt.count) then
		self:turnInHunt(pPlayer, hunt.key)

		return
	end

	CreatureObject(pPlayer):sendSystemMessage(self:progressLine(hunt, killed))
	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
end
