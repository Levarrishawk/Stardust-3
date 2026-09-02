--[[
A history lesson  --  som_kenobi_historian_1, som_kenobi_historian_smuggler and
som_kenobi_historian_2

SOURCE OF RECORD

quest/som_kenobi_historian_1.qst, som_kenobi_historian_smuggler.qst and
som_kenobi_historian_2.qst in the client TREs. The bunker location and its radius,
every message box title and body, both retrieveMenuText strings, the 60 % and 65 %
loot rates, the 20-45 s crack timer, both Level 75 [list] gates and the two reward
items are quoted from them. The conversation tree is
mobile/conversations/mustafar/som_kenobi_epo_qetora.lua and the handler that routes
it is quest/conversation/epo_qetora_conv_handler.lua.

All three .qst files are run by this one screenplay. _1 and _smuggler are the same
quest with one step swapped, so they cannot be two screenplays -- a player only ever
holds one of them and both feed the same turn-in. _2 follows from the same NPC and
reads _1's completion, which is why it lives here too rather than beside it.

THE TWO VARIANTS OF QUEST ONE

Both files run: go to the bunker, scan a terminal, deal with the encryption, use
the terminal again, go back to Epo. Only the middle differs.

  som_kenobi_historian_1        task 2 "Couldn't be that easy" -> task 3, Destroy
                                Multiple and Loot on Social Group orf_security for
                                a "Decryption key", LootDropPercent 60 -> task 4
                                "Success!" -> task 5 "Use decryption key"
  som_kenobi_historian_smuggler task 2 "Encryption" -> task 9, Timer Min 20 /
                                Max 45 -> task 4 "Success!" -> task 10
                                "Download data"

Which one a player gets is decided in the conversation, and live decides it on the
profession rather than on the skill box: som_kenobi_epo_qetora_condition_isSmuggler
is the single call hasSkill(player, "class_smuggler_phase1_novice"). This file used
to say slicing skill, read off the smuggler .qst's own message box -- "with your
skills, you will be able to crack it given a little time". That line is about what
the quest step does, not about who is offered it.

Nothing else in either file differs, and the reward task is identical in both.

WHERE THE OBJECTS COME FROM

The two quest-two props are snapshot props. snapshot/mustafar.ws places them and
PlanetManagerImplementation::loadSnapshotObject() instantiates each node with
objectID == the node ID, so getSceneObject(<nodeID>) returns the object the client
is already drawing:

    node 12110928  quest/som_kenobi_historian_corpse  (378.70, 217.20, 4365.42)
    node 12110929  quest/som_kenobi_historian_rubble  (328.69, 206.27, 4019.24)

The corpse sits 4.3 m from must_jeditemple_watchtower, which is the "old camp" _2's
journal text sends the player to.

The computer terminal is not a snapshot prop -- it is an interior object, and the
interior is an instance. som_kenobi_orf_computer.iff is spawned into every copy of
the Old Research Facility instead; see THE TERMINAL.

THE TERMINAL  --  quoted. It used to be placed, and that was wrong.

_1 task 0 puts the bunker at mustafar (-745, 87, 6048) Radius 65, and describes it
as "an old bunker that used to belong to what was known as the Old Republic". The
Old Research Facility instance's entry node, 12110161, stands at (-775.93, 89.14,
6088.28) -- inside that ring -- so the bunker the .qst means is the ORF, and the
terminal has to be inside it. That much still holds.

MustafarInstances pools twelve copies of that building (key old_republic_facility),
so the terminal is spawned into each one: a player who zones in gets his own.

This file used to say the terminal was PLACED, not quoted: cell smallroom6 was read
off the interior layout, and the position was the one floor_war_room_console_01 the
.ilf puts in that cell, at (101.064, -0.000, 39.194) with no heading. The argument
was that Core3 never calls InteriorLayoutTemplate, so the .ilf furniture is not
actually spawned and that spot is empty floor -- SOE's own console spot, nothing to
collide with.

The ORF's server-side dungeon spawn table has since been read, and it spawns this
exact object by template. It gives the room as smallroom6, the position as
98.4149 / 0.442719 / 48.6985 and the yaw as -180, and it names the object "Log
Access Terminal". So the terminal was never a placement problem: it is stated
outright, ~9.5m further down the room than the console spot, off the floor, and
facing the opposite way. The values below are now that row.

ROOT CAUSE: reaching for the client-side layout because it was the file already
open, without first asking whether anything server-side spawns the object. A .ilf
says what the building was furnished with; a dungeon spawn table says what the
server puts in it. Only the second one is a placement, and only the second one has
a heading -- the missing heading should have been the tell that the .ilf was
answering a different question. The one thing the old note got right it got by
luck: smallroom6 is the correct room, and live agrees.

THE DROIDS  --  RESOLVED. The invented picket line is gone.

_1 task 3 is a kill task, so the quest needs killable targets in the facility.
This screenplay used to spawn four of them itself, on an invented aisle at x 96 in
smallroom6, because nothing else in this repo populated the ORF at all.

That was wrong twice over. Live puts NO droid in smallroom6 -- the room holds a
Main Computer Terminal, the Log Access Terminal above, and som_orf_ancient_xandank
on a boss timer, so the room's guard is a boss, not a line of four sentries. And
live's real security droids stand in the halls and stairwells on the lower floors,
tens of metres below that room.

An earlier revision of this note recorded all of that and then LEFT the picket
line standing, on the argument that moving the droids would put the quest's only
targets in cells this screenplay does not spawn into. That argument only held
while this screenplay was the only thing spawning anything in the building. It
isn't any more.

mustafar_dungeon_population.lua now spawns the Old Republic Facility's whole live
creature table -- 42 rows -- into every copy of the pool, so the six real
som_orf_ancient_security_drone rows are standing in the building where live puts
them. The four invented posts and spawnFacilityDroids are deleted. This file still
spawns the terminal, and nothing else.

THE ORF IS UNPOPULATED  --  RESOLVED, and it was resolved here rather than deferred

An earlier revision of this note said "a proper ORF dungeon populator would make
the stand-in above unnecessary and is the right place to fix it. That is a piece of
missing content, not a defect in this file, so it is flagged and left."

The flag was right and leaving it was not. That populator now exists:
screenplays/mustafar/mustafar_dungeon_population.lua, included immediately after
mustafar_instances.lua. It carries the ORF's 42 creature rows plus the two droid
factories' 46, all quoted from the shipped dungeon spawn tables. Read that file for
the axis mapping, the sixteen template substitutions and the boot cost.

The count in the old note was also loose: the ORF table has 70 rows in total, of
which 42 are creatures and the rest are terminals, doors and fittings. "68 spawn
rows" was a whole-file number quoted as if it were a creature number.

THE CREATURE NAMES  --  substituted

_1 task 3 names its target by Social Group "orf_security". No creature in this tree
carries that social group, and no template named orf_security exists either. Live's
own name for the facility's security is som_orf_ancient_security_drone, which has no
template either -- it exists only as a string in the dungeon spawn table.

So the target is whatever the populator stands that name in as, and this file asks
it rather than naming a template of its own: getSubstitute("som_orf_ancient_security
_drone") returns union_sentry_droid (mobile/custom_content/som/union_sentry_droid.lua),
a level 70 sentry droid, which is what a decommissioned facility's security would be.
That is the same pick this file used to hardcode, so nothing about the encounter
changes -- only who owns the choice. If the substitution is ever revisited it is
revisited in one place.

som_ancient_guardian_droideka would have been the other candidate; it is claimed by
hidden_treasure.lua:130 and, in the populator, by the ORF's sentinel droid rows.

_2 task 3 names "som_kenobi_enclave_scavenger". An earlier revision said that name
"exists nowhere". It is a real live mobile name: the server-side spawn type table
kenobi_historian_scavengers names exactly that template, with a group size of 4.
What is genuinely missing is its APPEARANCE -- no shared_som_kenobi_enclave_
scavenger.iff ships in any of the 49 TREs, so the template cannot be stood up here
even though the name is now confirmed.

The six ruins_* humanoids in mobile/custom_content/som/ are still what this tree
stands in with, and the group size of 4 is now honoured rather than guessed: the
camp spawns four, cycling that list, so only the first four of the six land on a
given copy. The list stays six long because it is the substitution record, not a
spawn count. This wave also renamed them from "a townsperson" to scavengers and gave
them working weapons; before it they were unarmed townspeople with dead weapons and
attacks fields.

som_kenobi_historian_dark_jedi is quoted -- that template exists, is registered, and
ships an appearance (shared_som_kenobi_historian_dark_jedi.iff). Its own spawn type
table gives a group size of 4, so she is an ambush party rather than a single
duellist. She, not he: task 4's shipped message box is "In the robes of the slain
woman, you find one of the tablet pieces for Epo!", which this file already quotes
verbatim in notifyKilledCreature. An earlier revision of this header said "he".

AND SHE IS AN AMBUSH IN THE LITERAL SENSE -- this was inverted

Live ships a conversation for her, som_kenobi_historian_dark_jedi, and it is the
only one in the arc with no tree: two openings, both ending in action_attack and a
spatial line, and an OnNpcConversationResponse with no branches at all. She sits
with BEHAVIOR_SENTINEL and the "npc_meditate" mood, CONDITION_CONVERSABLE, and a
CONVERSE_START radial. She is bait. You hail her and she kills you for it.

Her mobile had pvpBitmask AGGRESSIVE and conversationTemplate "", which turns the
encounter inside out -- an aggressive agent charges on sight, so the player never
reaches the hail and every line of that conversation is unreachable. Both are
corrected, and the tree and handler are built:
mobile/conversations/mustafar/som_kenobi_historian_dark_jedi.lua and
quest/conversation/historian_dark_jedi_conv_handler.lua carry the detail.

Root cause: the mobile was written from the spawn type table, which gives a group
size and nothing else, plus the fact that she is an enemy. Being an enemy and being
aggressive are different things, and only the conversation script says which. Her
sibling som_kenobi_serpent_dark_jedi -- the same creature to the stat, and also a
taunt-then-fight -- was already ATTACKABLE + ENEMY with CONVERSABLE and a
conversation, so the correct shape was sitting in the next file the whole time.

PROGRESS TRACKING

Neither quest has a row in datatables/player/quests.iff -- the table the server
loads is stardust_03.tre's, which wins the TreFiles order in conf/config.lua, and
its only Mustafar rows are the 45 exploration markers. So there is no journal.
Progress lives in persistent screenplay data on the player's ghost, and the
journalEntryDescription lines go out as system messages and as waypoint
descriptions instead, which is where the player would otherwise have read them.

_2 has no Go to Location task at all -- its journal text is the only steer the
player ever gets ("somewhere around an old camp North East of the new mining
facility, South of the bunker you visited the last time"). With no journal to read
that in, the two fixed-location pieces get waypoints; the two kills do not, because
there is no location to point at, only a camp the player is already standing in.

THE REWARDS  --  half quoted, half substituted

Both Item rewards are quoted and real: som_kenobi_historian_data_disk.iff on quest
one and som_kenobi_historian_data_disk_2.iff on quest two, both registered server
templates in object/custom_content/tangible/quest/story_loot/.

Quest one's three reward signals also each carry lootName
armor_tow_helmet_acc_{assault,battle,recon}_02_01 -- live server-side static-item
names, not object templates. Nothing here resolves them, and that is now checked
rather than assumed: armor_tow appears nowhere in this repo except this comment,
there is no armor_attachment of any kind outside the loot groups, and there is no
Trials of Obi-Wan armour set. The live server scripts do not resolve them either --
armor_tow matches nothing at all in them -- so these three names exist only as .qst
lootName strings on the server side, with no template behind them to copy.

The client is the one place they DO resolve. static_item_n.stf carries all three,
and all three carry the SAME display name:

    armor_tow_helmet_acc_assault_02_01   Target Enhancement Helm
    armor_tow_helmet_acc_battle_02_01    Target Enhancement Helm
    armor_tow_helmet_acc_recon_02_01     Target Enhancement Helm

That is what _acc_ means: one accessory helm, offered in three armour classes so the
player keeps the class they already wear. It is a name, not a template -- static
items were built server-side from a datatable that did not ship in any form this
tree can read. So the substitution stands, and the description it matches is now the
shipped one: a helmet, in the assault, battle or recon class. Each pick hands over a
helmet from a neutral, non-faction set in that class:

    assault  armor_composite_helmet.iff
    battle   armor_chitin_s01_helmet.iff
    recon    armor_ubese_helmet.iff

Quest two's Reward task carries no lootName at all, only the data disk. Epo still
says "Not a problem. Here you go." to a player who asked him for a rifle, a carbine
or a pistol, so the weapon is this tree's substitution to make the shipped dialogue
true: rifle_dlt20a.iff, carbine_dh17.iff, pistol_dl44.iff.

Everything is handed over with giveItem() into the player's inventory, which creates
the object for real -- deliberately not addRewardedSchematic, which fails closed when
the path is not in scripts/managers/crafting/schematics.lua and would silently grant
nothing (the defect hidden_treasure.lua's reward had to be corrected for).

To restore the live items later, only rewardArmor and rewardWeapon below change.

WHERE EPO STANDS  --  live, quoted

An earlier revision said "nothing ships his position" and put him in the cantina on
a reading of his character. That was WRONG. The claim rested on a search of the
client TREs and this repo that never covered the server-side spawn data; his row
was there the whole time.

The Mensix Mining Facility's dungeon spawn table places som_kenobi_epo_qetora in
room small_room_04 at -16.4 / 19.1 (height) / -20.4, heading -75. That is cell
12112238 -- see THE CELL MAP in mensix_mining_facility_main.lua for how the 30 cell
ids are derived from the .pob and the snapshot.

small_room_04 is on the 19.1 floor and it is the arc's real hub: Q4P3
(collectors_business.lua) is 12 m away in the same room, and Ithes Olok
(jenha_tar_cube.lua) is 15 m away in it too. The cantina is medium_room_01, a
different room on the 10.8 floor about 62 m off, and only Pei Yi, Diskret Stahn,
Menth Paul, Ikt and the shard sucker stand there.

His creature template's conversationTemplate was empty and is set to
"som_kenobi_epo_qetora" by this wave.

WHAT IS NOT MODELLED

_1's tasks 1 and 5 and _smuggler's tasks 1 and 10 are Retrieve Item, so in live the
player carried "Log files", a "Decryption key" and a "Disk" between the steps. Their
Server Object Template is the terminal itself, which is SOE reusing the prop template
for the carried item and would look wrong in an inventory. They are progress markers
that nothing downstream reads, so those steps advance the stage and show their
message box without minting an item. The same goes for _2's four "Tablet piece"
markers -- the thing the player keeps is the data disk, handed over at the reward.

Task 7 on both quest-one files is a Wait for Signal on "successDone", and _2's task 7
waits on "piecesRetrieved". Those are the turn-in conversation, not tasks.
--]]

historianScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "historianScreenPlay",

	-- Both .qst [list] blocks -- a client-side display value. Epo's live
	-- conversation has now been read and defines seven conditions, none of them a
	-- level test, so there is nothing server-side to replace it with and nothing
	-- reads this field. Kept as the recorded .qst value; see NO LEVEL GATE in the
	-- conversation handler.
	requiredLevel = 75,

	-- Snapshot nodes; see WHERE THE OBJECTS COME FROM.
	corpseNodeID = 12110928,
	rubbleNodeID = 12110929,

	-- Live, quoted; see WHERE EPO STANDS. small_room_04 of the Mensix Mining
	-- Facility is cell 12112238, and the live row is -16.4 / 19.1 / -20.4 at
	-- heading -75. Cell coordinates, and 19.1 is the upper floor.
	questGiver = {
		template = "som_kenobi_epo_qetora",
		cell = 12112238,
		x = -16.4,
		z = 19.1,
		y = -20.4,
		heading = -75,
	},

	-- _1 / _smuggler task 0, Go to Location: mustafar (-745, 87, 6048), Radius 65.
	-- No waypointName ships, so the journalEntryTitle is used for it.
	bunker = { x = -745, y = 6048, radius = 65, waypointName = "Ancient bunker" },

	-- The terminal, one per instance copy. The droids are not here any more; the
	-- populator places them, from live's own rows. See THE DROIDS.
	facility = {
		pool = "old_republic_facility",
		cell = "smallroom6",

		-- Live, quoted: the ORF dungeon spawn table's own row for this template,
		-- named "Log Access Terminal". Was the .ilf console spot; see THE TERMINAL.
		computer = { template = "object/tangible/quest/som_kenobi_orf_computer.iff", x = 98.4149, z = 0.442719, y = 48.6985, heading = -180 },

		-- The LIVE name of _1 task 3's target, not a template. resolveDroidTemplate
		-- turns it into one by asking the populator; see THE CREATURE NAMES.
		droidLiveName = "som_orf_ancient_security_drone",
	},

	-- Filled at boot by resolveDroidTemplate. Empty means the kill step has no
	-- targets, and start() says so rather than letting it fail silently. Empty
	-- string rather than nil so the comparison in notifyKilledCreature can never
	-- match a template name by accident.
	droidTemplate = "",

	-- _2 tasks 2 and 3. The camp is the watchtower cluster the corpse lies beside;
	-- see THE CREATURE NAMES for why the scavengers are these six templates.
	-- Both counts are the live server-side spawn type tables' group sizes:
	-- kenobi_historian_dark_jedi and kenobi_historian_scavengers each carry 4.
	-- Four is deliberate -- of the 78 Mustafar ground spawn type tables the
	-- overwhelming default is 5, so these two were set by hand.
	camp = { x = 370, y = 4340, spread = 40 },
	darkJedi = { template = "som_kenobi_historian_dark_jedi", count = 4, respawn = 600 },
	scavengers = {
		count = 4,
		respawn = 300,
		-- Six substitutes for one missing appearance, cycled to fill the four
		-- posts.  The list stays six long so the substitution is visible.
		templates = {
			"ruins_leader",
			"ruins_human",
			"ruins_aqualish",
			"ruins_ithorian",
			"ruins_rodian",
			"ruins_weequay",
		},
	},

	-- _1 task 3 LootDropPercent, and _smuggler task 9 Timer Min / Max.
	keyDropPercent = 60,
	crackTimeMin = 20,
	crackTimeMax = 45,

	-- _2 task 3 LootDropPercent. Its other three tasks are all 100.
	scavengerDropPercent = 65,

	-- Quoted; see THE REWARDS.
	rewardDisk1 = "object/tangible/quest/story_loot/som_kenobi_historian_data_disk.iff",
	rewardDisk2 = "object/tangible/quest/story_loot/som_kenobi_historian_data_disk_2.iff",

	-- Substituted; see THE REWARDS.
	rewardArmor = {
		assault = "object/tangible/wearables/armor/composite/armor_composite_helmet.iff",
		battle = "object/tangible/wearables/armor/chitin/armor_chitin_s01_helmet.iff",
		recon = "object/tangible/wearables/armor/ubese/armor_ubese_helmet.iff",
	},
	rewardWeapon = {
		rifle = "object/weapon/ranged/rifle/rifle_dlt20a.iff",
		carbine = "object/weapon/ranged/carbine/carbine_dh17.iff",
		pistol = "object/weapon/ranged/pistol/pistol_dl44.iff",
	},

	STAGE_Q1 = 1,
	STAGE_Q1_TURNIN = 2,
	STAGE_Q1_DONE = 3,
	STAGE_Q2 = 4,
	STAGE_Q2_TURNIN = 5,
	STAGE_DONE = 6,

	-- q1step, the sub-state inside quest one.
	Q1_TRAVELLING = 0,
	Q1_ARRIVED = 1,
	Q1_SCANNED = 2,
	Q1_UNLOCKED = 3,

	-- What start() actually placed. None of it is snapshot data, so there is no
	-- world id to look any of it up by; recording the ids is the only way to find
	-- them again, and the only way a boot check can tell a silent failure from a
	-- success.
	bunkerAreaID = 0,
	questGiverID = 0,
	terminalIDs = {},
	campMobileIDs = {},
}

registerScreenPlay("historianScreenPlay", true)

function historianScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:resolveDroidTemplate()
		self:attachSnapshotObjects()
		self:spawnQuestGiver()
		self:spawnBunkerArea()
		self:spawnFacilityObjects()
		self:spawnCampMobiles()
	end
end

-- _1 task 3's kill target. The populator owns the substitution for every live
-- creature name in the ORF, so this file asks it instead of keeping a second copy
-- of the template string that could drift out of step with what is actually
-- standing in the building. Guarded, because a screenplay that is not loaded is a
-- nil global and this has to say what is lost rather than throw.
function historianScreenPlay:resolveDroidTemplate()
	if (MustafarDungeonPopulation == nil) then
		print("historianScreenPlay: mustafar_dungeon_population.lua is not loaded; the Old Republic Facility has no droids and quest one's kill step cannot be finished")
		return
	end

	local template = MustafarDungeonPopulation:getSubstitute(self.facility.droidLiveName)

	if (template == nil) then
		print("historianScreenPlay: the populator has no substitute for " .. self.facility.droidLiveName .. "; quest one's kill step cannot be finished")
		return
	end

	self.droidTemplate = template
end

function historianScreenPlay:attachSnapshotObjects()
	local props = {
		{ id = self.corpseNodeID, role = "corpse" },
		{ id = self.rubbleNodeID, role = "rubble" },
	}

	for i = 1, #props do
		local pProp = getSceneObject(props[i].id)

		if (pProp == nil) then
			print("historianScreenPlay: snapshot object " .. props[i].id .. " (" .. props[i].role .. ") was not found; that tablet piece will be unreachable")
		else
			writeStringData(props[i].id .. ":historianRole", props[i].role)
			SceneObject(pProp):setObjectMenuComponent("HistorianMenuComponent")
		end
	end
end

function historianScreenPlay:spawnQuestGiver()
	local giver = self.questGiver
	local pNpc = spawnMobile("mustafar", giver.template, 0, giver.x, giver.z, giver.y, giver.heading, giver.cell)

	if (pNpc == nil) then
		print("historianScreenPlay: failed to spawn " .. giver.template .. "; neither quest can be started")
	else
		self.questGiverID = SceneObject(pNpc):getObjectID()
	end
end

-- _1 / _smuggler task 0. The bunker step has no radial and no object to touch, so
-- an active area is the only thing that can complete it.
function historianScreenPlay:spawnBunkerArea()
	local z = getWorldFloor(self.bunker.x, self.bunker.y, "mustafar")
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.bunker.x, z, self.bunker.y, self.bunker.radius, 0)

	if (pArea == nil) then
		print("historianScreenPlay: failed to spawn the bunker area; quest one cannot be started")
		return
	end

	self.bunkerAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "historianScreenPlay", "notifyEnteredBunkerArea", pArea)
end

-- One terminal per copy of the Old Republic Facility; see THE TERMINAL. The four
-- droids that used to be spawned alongside it are the populator's now, and they
-- stand where live's own rows put them rather than in this room.
function historianScreenPlay:spawnFacilityObjects()
	if (MustafarInstances == nil) then
		print("historianScreenPlay: mustafar_instances.lua is not loaded; quest one cannot be finished")
		return
	end

	local buildings = MustafarInstances:getPoolBuildings(self.facility.pool)

	if (#buildings == 0) then
		print("historianScreenPlay: MustafarInstances has no " .. self.facility.pool .. " pool; quest one cannot be finished")
		return
	end

	local placed = 0

	for i = 1, #buildings do
		local pBuilding = getSceneObject(buildings[i])

		if (pBuilding == nil or not SceneObject(pBuilding):isBuildingObject()) then
			print("historianScreenPlay: " .. self.facility.pool .. " copy " .. buildings[i] .. " is missing; it gets no terminal")
		else
			local pCell = BuildingObject(pBuilding):getNamedCell(self.facility.cell)

			if (pCell == nil) then
				print("historianScreenPlay: copy " .. buildings[i] .. " has no cell named " .. self.facility.cell .. "; it gets no terminal")
			else
				local cellID = SceneObject(pCell):getObjectID()

				if (self:spawnFacilityComputer(cellID, buildings[i])) then
					placed = placed + 1
				end
			end
		end
	end

	if (placed == 0) then
		print("historianScreenPlay: no terminal was placed in any " .. self.facility.pool .. " copy; quest one cannot be finished")
	end
end

function historianScreenPlay:spawnFacilityComputer(cellID, buildingID)
	local computer = self.facility.computer
	local pComputer = spawnSceneObject("mustafar", computer.template, computer.x, computer.z, computer.y, cellID, math.rad(computer.heading))

	if (pComputer == nil) then
		print("historianScreenPlay: failed to spawn the terminal in copy " .. buildingID)
		return false
	end

	local computerID = SceneObject(pComputer):getObjectID()

	-- The spawn table names it as well as places it, and the template carries no
	-- name of its own, so the name is set here rather than left to the .iff.
	SceneObject(pComputer):setCustomObjectName("Log Access Terminal")

	writeStringData(computerID .. ":historianRole", "computer")
	SceneObject(pComputer):setObjectMenuComponent("HistorianMenuComponent")
	table.insert(self.terminalIDs, computerID)

	return true
end

-- _2 tasks 2 and 3. Neither creature has spawn data anywhere in this tree, so the
-- camp the journal text describes is populated here.
function historianScreenPlay:spawnCampMobiles()
	local camp = self.camp

	for i = 1, self.darkJedi.count do
		self:spawnCampMobile(self.darkJedi.template, self.darkJedi.respawn)
	end

	for i = 1, self.scavengers.count do
		local template = self.scavengers.templates[((i - 1) % #self.scavengers.templates) + 1]

		self:spawnCampMobile(template, self.scavengers.respawn)
	end
end

function historianScreenPlay:spawnCampMobile(template, respawn)
	local x = self.camp.x + getRandomNumber(-self.camp.spread, self.camp.spread)
	local y = self.camp.y + getRandomNumber(-self.camp.spread, self.camp.spread)
	local z = getWorldFloor(x, y, "mustafar")
	local pMobile = spawnMobile("mustafar", template, respawn, x, z, y, getRandomNumber(360) - 180, 0)

	if (pMobile == nil) then
		print("historianScreenPlay: failed to spawn " .. template .. "; quest two will be short a tablet piece")
	else
		-- A list, not a map keyed by template: the dark jedi spawns four times
		-- from one template and the scavenger list cycles, so a keyed store
		-- would silently drop every duplicate but the last.
		self.campMobileIDs[#self.campMobileIDs + 1] = SceneObject(pMobile):getObjectID()
	end
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage    0  not started
	         1  quest one active
	         2  quest one finished in the field; heading back to Epo
	         3  quest one turned in; quest two on offer
	         4  quest two active
	         5  all four pieces found; heading back to Epo
	         6  both turned in
	q1step   0  travelling to the bunker
	         1  inside the bunker area; the terminal can be scanned
	         2  terminal scanned; killing droids for the key, or cracking it
	         3  key found or crack finished; the terminal can be used again
	slice    1 if this player took som_kenobi_historian_smuggler
	got_corpse / got_rubble / got_darkjedi / got_scavenger
	         1 once that tablet piece is in hand
	wp_<key> waypoint id currently handed out for that objective, absent if none
--]]

function historianScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function historianScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function historianScreenPlay:rawQ1Step(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "q1step")) or 0
end

--[[ The slicer's crack is driven by createEvent, which does not survive a server restart,
     while q1step does. Reading the step settles an overdue crack as well, so a restart
     inside those 20-45 s cannot park a smuggler at Q1_SCANNED: the terminal offers no
     radial there, and notifyKilledCreature refuses the droid-key route to anyone carrying
     the "slice" flag, so finishCrack is that player's only exit. Both paths funnel into
     finishCrack, which is guarded on the raw step, so whichever arrives first wins. ]]
function historianScreenPlay:getQ1Step(pPlayer)
	local step = self:rawQ1Step(pPlayer)

	if (step == self.Q1_SCANNED) then
		local due = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "crackUntil")) or 0

		if (due ~= 0 and getTimestamp() >= due) then
			self:finishCrack(pPlayer)

			return self:rawQ1Step(pPlayer)
		end
	end

	return step
end

function historianScreenPlay:setQ1Step(pPlayer, step)
	writeScreenPlayData(pPlayer, self.screenplayName, "q1step", tostring(step))
end

function historianScreenPlay:hasFlag(pPlayer, key)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) == 1
end

function historianScreenPlay:setFlag(pPlayer, key)
	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
end

--[[ Waypoints

Keyed, because quest two has two fixed-location objectives open at once. See
PROGRESS TRACKING for why they exist at all.
--]]

function historianScreenPlay:giveWaypoint(pPlayer, key, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer, key)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key, tostring(waypointID))
end

function historianScreenPlay:removeWaypoint(pPlayer, key)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp_" .. key)
end

function historianScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("historianScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

-- The .qst message boxes are read-and-dismiss; nothing branches on the button.
function historianScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

function historianScreenPlay:giveReward(pPlayer, template, what)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("historianScreenPlay: player has no inventory; " .. template .. " could not be handed over")
	elseif (giveItem(pInventory, template, -1, true) == nil) then
		print("historianScreenPlay: failed to create " .. template)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for " .. what .. ".")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have taken " .. what .. ".")
	end
end

--[[ Quest one ]]

-- Both pitch screens land here; isSmuggler picks between _1 and _smuggler. See
-- THE TWO VARIANTS OF QUEST ONE.
-- Task 0, musicOnActivate sound/mus_mustafar_quest_exception.snd.
function historianScreenPlay:startQuest1(pPlayer, isSmuggler)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, self.STAGE_Q1)
	self:setQ1Step(pPlayer, self.Q1_TRAVELLING)

	if (isSmuggler) then
		self:setFlag(pPlayer, "slice")
	end

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- Persistence 1 so the observer object is saved and kill credit survives a
	-- logout. It stays on the player through quest two and is dropped at the end.
	createObserver(KILLEDCREATURE, "historianScreenPlay", "notifyKilledCreature", pPlayer, 1)

	self:giveWaypoint(pPlayer, "bunker", self.bunker.waypointName, "A history lesson", self.bunker.x, self.bunker.y)

	-- Task 0's journalEntryDescription. _smuggler's opens "The historian who has
	-- hired you"; the rest of the line is identical, so _1's wording is used.
	CreatureObject(pPlayer):sendSystemMessage("The historian that has hired you came across an old bunker that used to belong to what was known as the Old Republic. It's located in the very North East edge of the continent.")
end

-- Task 0 completing, which fires task 1: the terminal becomes usable.
function historianScreenPlay:notifyEnteredBunkerArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_Q1 or self:getQ1Step(pPlayer) ~= self.Q1_TRAVELLING) then
		return 0
	end

	self:setQ1Step(pPlayer, self.Q1_ARRIVED)
	self:removeWaypoint(pPlayer, "bunker")

	-- Task 1's journalEntryDescription, "Data search".
	CreatureObject(pPlayer):sendSystemMessage("You've found the old bunker, now you need to venture inside and see if you can find a working computer terminal.")

	return 0
end

-- Task 1 completing. Both variants share it; they split on the message box it
-- fires, which is task 2 in each file.
function historianScreenPlay:scanTerminal(pPlayer, pComputer)
	if (self:getStage(pPlayer) ~= self.STAGE_Q1 or self:getQ1Step(pPlayer) ~= self.Q1_ARRIVED) then
		return
	end

	self:setQ1Step(pPlayer, self.Q1_SCANNED)

	if (self:hasFlag(pPlayer, "slice")) then
		-- _smuggler task 2, then task 9's Timer Min 20 / Max 45.
		self:showMessageBox(pPlayer, pComputer, "Encryption",
			"The log files on the computer terminal are heavily encrypted. You believe that with your skills, you will be able to crack it given a little time.")

		-- Task 9's journalEntryDescription, "Cracking the code".
		CreatureObject(pPlayer):sendSystemMessage("Your smuggling skills come in handy as you get to work on cracking the encryption on the computer terminal.")

		-- The deadline is stamped alongside the event so getQ1Step can settle the crack if
		-- the event is lost with the process.
		local crackDelay = getRandomNumber(self.crackTimeMin, self.crackTimeMax)

		writeScreenPlayData(pPlayer, self.screenplayName, "crackUntil", tostring(getTimestamp() + crackDelay))
		createEvent(crackDelay * 1000, "historianScreenPlay", "finishCrack", pPlayer, "")
	else
		-- _1 task 2, then task 3's Destroy Multiple and Loot.
		self:showMessageBox(pPlayer, pComputer, "Couldn't be that easy",
			"The log files on the computer terminal are heavily encrypted. You will need to find some sort of decryption key to access them. It's a long shot but maybe one of the droids in here has it?")

		-- Task 3's journalEntryDescription, "Computers...".
		CreatureObject(pPlayer):sendSystemMessage("The log files on the computer terminal you found are encrypted. You need to find a key to remove it with and all you can think of is that maybe one of the old droids has it.")
	end
end

-- _smuggler task 9 expiring, which fires task 4 and then task 10.
function historianScreenPlay:finishCrack(pPlayer)
	-- Raw, not getQ1Step: the catch-up path in getQ1Step calls this function.
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_Q1 or self:rawQ1Step(pPlayer) ~= self.Q1_SCANNED) then
		return
	end

	self:setQ1Step(pPlayer, self.Q1_UNLOCKED)
	deleteScreenPlayData(pPlayer, self.screenplayName, "crackUntil")

	-- _smuggler task 4.
	self:showMessageBox(pPlayer, nil, "Success!",
		"The encryption was no match for you. Unfortunately most of the data is damaged beyond repair but some information is intact Download it to a disk then head back to Epo Qetora.")

	-- Task 10's journalEntryDescription, "Collect data".
	CreatureObject(pPlayer):sendSystemMessage("Download the data from the computer terminal.")
end

-- _1 task 3 dropping its key, which fires task 4 and then task 5.
function historianScreenPlay:findDecryptionKey(pPlayer)
	self:setQ1Step(pPlayer, self.Q1_UNLOCKED)

	-- _1 task 4.
	self:showMessageBox(pPlayer, nil, "Success!",
		"Your hunch was correct. Among the remains of the old security droid you find what you're looking for. Now lets just hope it's the right one. Head back to the computer terminal.")

	-- Task 5's journalEntryDescription, "The right key?".
	CreatureObject(pPlayer):sendSystemMessage("You've found a decryption key on the remains of one of the old security droids. Head back to the terminal and check if it's the correct one.")

	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
end

-- _1 task 5 / _smuggler task 10 completing, which fires _1's task 6 and then, on
-- both, task 7: Wait for Signal successDone -- go back to Epo.
function historianScreenPlay:useTerminal(pPlayer, pComputer)
	if (self:getStage(pPlayer) ~= self.STAGE_Q1 or self:getQ1Step(pPlayer) ~= self.Q1_UNLOCKED) then
		return
	end

	self:setStage(pPlayer, self.STAGE_Q1_TURNIN)

	if (not self:hasFlag(pPlayer, "slice")) then
		-- _1 task 6. _smuggler has no box here; its task 4 already said this.
		self:showMessageBox(pPlayer, pComputer, "At last",
			"The key works, and you break the encryption on the log files. Unfortunately, most of the data is damaged beyond repair, but some information is intact, and you quickly download it to a disk. Head back to Epo Qetora.")
	end

	-- Task 7's journalEntryDescription, "Mission accomplished", on both files.
	CreatureObject(pPlayer):sendSystemMessage("You have found what you could from the old facility, hopefully it's what Qetora is looking for.")
end

-- The three armour-pick screens land here: task 8's Reward Item plus one of the
-- assaultPicked / battlePicked / reconPicked signals, then task 12's Immediately
-- Complete Quest, musicOnComplete sound/mus_mustafar_quest_success.snd.
function historianScreenPlay:finishQuest1(pPlayer, armorType)
	if (self:getStage(pPlayer) ~= self.STAGE_Q1_TURNIN) then
		return
	end

	self:setStage(pPlayer, self.STAGE_Q1_DONE)
	deleteScreenPlayData(pPlayer, self.screenplayName, "q1step")

	self:giveReward(pPlayer, self.rewardDisk1, "the data disk from the old facility")

	local armor = self.rewardArmor[armorType]

	if (armor ~= nil) then
		self:giveReward(pPlayer, armor, "the helmet Epo Qetora gave you")
	end

	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	-- Two quests, one function -- discriminator is hasFlag("slice").
	if (self:hasFlag(pPlayer, "slice")) then
		MustafarQuestXp:award(pPlayer, "som_kenobi_historian_smuggler")
	else
		MustafarQuestXp:award(pPlayer, "som_kenobi_historian_1")
	end

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
	CreatureObject(pPlayer):sendSystemMessage("You have completed Epo Qetora's task.")
end

--[[ Quest two ]]

-- Both grant screens land here. _2 has no Go to Location task at all; see
-- PROGRESS TRACKING.
function historianScreenPlay:startQuest2(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_Q1_DONE) then
		return
	end

	self:setStage(pPlayer, self.STAGE_Q2)

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- Task 6's journalEntryDescription, "A second lesson" -- the only steer _2 gives.
	CreatureObject(pPlayer):sendSystemMessage("Epo wants you to retrieve the missing pieces of the tablet he found. He believes there to be four more pieces and he thinks they are somewhere around an old camp North East of the new mining facility, South of the bunker you visited the last time you worked for Epo.")

	-- Task 6's own display strings, on the two pieces that have a fixed location.
	self:giveWaypoint(pPlayer, "rubble", "First tablet piece", "A history lesson, part II", 328.69, 4019.24)
	self:giveWaypoint(pPlayer, "corpse", "Second tablet piece", "A history lesson, part II", 378.70, 4365.42)
end

-- _2 task 1 (Search remains, 100 %) and task 4 (Search rubble, 100 %).
function historianScreenPlay:takeTabletPiece(pPlayer, pProp, role)
	if (self:getStage(pPlayer) ~= self.STAGE_Q2 or self:hasFlag(pPlayer, "got_" .. role)) then
		return
	end

	self:removeWaypoint(pPlayer, role)

	if (role == "corpse") then
		-- Task 1's message box.
		self:showMessageBox(pPlayer, pProp, "Tablet", "Among the remains, you find one of the tablet pieces for Epo!")
	else
		-- Task 4's message box.
		self:showMessageBox(pPlayer, pProp, "Tablet", "Among the rubble, you find one of the tablet pieces for Epo!")
	end

	self:collectTabletPiece(pPlayer, role)
end

function historianScreenPlay:collectTabletPiece(pPlayer, role)
	self:setFlag(pPlayer, "got_" .. role)

	local pieces = { "corpse", "rubble", "scavenger", "darkjedi" }
	local collected = 0

	for i = 1, #pieces do
		if (self:hasFlag(pPlayer, "got_" .. pieces[i])) then
			collected = collected + 1
		end
	end

	if (collected < #pieces) then
		CreatureObject(pPlayer):sendSystemMessage("Tablet pieces recovered: " .. collected .. " of " .. #pieces .. ".")
		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
		return
	end

	-- Task 6 (Wait for Tasks) completing, which fires task 7: Wait for Signal
	-- piecesRetrieved -- go back to Epo.
	self:setStage(pPlayer, self.STAGE_Q2_TURNIN)

	-- Task 7's journalEntryDescription, "All done, hopefully..".
	CreatureObject(pPlayer):sendSystemMessage("You've found four pieces of the tablet. Return to Epo and see if that completes the tablet.")
end

-- The three weapon-pick screens land here: task 8's Reward Item, then Immediately
-- Complete Quest, musicOnComplete sound/mus_mustafar_quest_success.snd.
function historianScreenPlay:finishQuest2(pPlayer, weaponType)
	if (self:getStage(pPlayer) ~= self.STAGE_Q2_TURNIN) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE)

	-- Dropped here rather than left to the observer's own "return 1" -- it was
	-- created persistent, so an unfired one would sit in the database forever on a
	-- player who finishes the arc and never kills anything again.
	dropObserver(KILLEDCREATURE, "historianScreenPlay", "notifyKilledCreature", pPlayer)

	self:giveReward(pPlayer, self.rewardDisk2, "the second data disk")

	local weapon = self.rewardWeapon[weaponType]

	if (weapon ~= nil) then
		self:giveReward(pPlayer, weapon, "the weapon Epo Qetora gave you")
	end

	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_historian_2")

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
	CreatureObject(pPlayer):sendSystemMessage("You have completed Epo Qetora's task.")
end

--[[ Kill credit

One observer covers both quests: _1 task 3's decryption key off the security droids
and _2 tasks 2 and 3's tablet pieces off the dark Jedi and the scavengers. It is
created when quest one starts and dropped when quest two is turned in, so a player
mid-arc keeps exactly one.

The template match is enough on its own on all three, and on the droid it is now
enough for a better reason than it used to be. The old note here said
"union_sentry_droid is spawned by nothing but this screenplay". That is no longer
true and it did not need to be: the populator spawns it, and it spawns it ONLY as
the Old Republic Facility's six som_orf_ancient_security_drone rows. So the
template still identifies exactly one thing -- an ORF security droid -- which is
what _1 task 3's Social Group orf_security asks for. The match went from being
true by isolation to being true by meaning.

Nothing else on Mustafar spawns union_sentry_droid; that was checked, not assumed.
There is a near-miss name to not be caught by: union_sentry_droid_crafted is a
separate craftable pet template with its own registration, and
getCreatureTemplateName returns that string, not this one, so the two never
collide.

som_kenobi_historian_dark_jedi exists nowhere else on the planet, and the six
ruins_* humanoids had no spawn anywhere until this wave placed them at the camp.
--]]

function historianScreenPlay:isScavenger(templateName)
	for i = 1, #self.scavengers.templates do
		if (self.scavengers.templates[i] == templateName) then
			return true
		end
	end

	return false
end

function historianScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil) then
		return 0
	end

	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_Q1) then
		-- _1 task 3: LootDropPercent 60, NumberItemsRequired 1. The smuggler
		-- variant never kills for the key -- it cracks the encryption instead.
		if (self:hasFlag(pPlayer, "slice") or self:getQ1Step(pPlayer) ~= self.Q1_SCANNED) then
			return 0
		end

		-- "" when the populator did not resolve, which matches no template name,
		-- so an unpopulated facility fails closed instead of crediting every kill.
		if (self.droidTemplate == "" or victimTemplate ~= self.droidTemplate) then
			return 0
		end

		if (getRandomNumber(1, 100) > self.keyDropPercent) then
			return 0
		end

		self:findDecryptionKey(pPlayer)
	elseif (stage == self.STAGE_Q2) then
		-- _2 task 2: the dark Jedi, 100 %.
		if (victimTemplate == self.darkJedi.template and not self:hasFlag(pPlayer, "got_darkjedi")) then
			self:showMessageBox(pPlayer, nil, "Tablet", "In the robes of the slain woman, you find one of the tablet pieces for Epo!")
			self:collectTabletPiece(pPlayer, "darkjedi")
		-- _2 task 3: the scavengers, LootDropPercent 65.
		elseif (self:isScavenger(victimTemplate) and not self:hasFlag(pPlayer, "got_scavenger")) then
			if (getRandomNumber(1, 100) > self.scavengerDropPercent) then
				return 0
			end

			self:showMessageBox(pPlayer, nil, "Tablet", "In the scavengers backpack, you find one of the tablet pieces for Epo!")
			self:collectTabletPiece(pPlayer, "scavenger")
		end
	end

	return 0
end

--[[ Radial dispatch

One component table serves the terminal in every facility copy and both snapshot
props. SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely -- so
fillObjectMenuResponse has to add every item we want to see, and adds nothing at all
when this player has no business touching the object.
--]]

-- Which radial, if any, this player should be offered on a given object.
function historianScreenPlay:getRadialText(pPlayer, role)
	local stage = self:getStage(pPlayer)

	if (role == "computer") then
		if (stage ~= self.STAGE_Q1) then
			return nil
		end

		local step = self:getQ1Step(pPlayer)

		if (step == self.Q1_ARRIVED) then
			return "Scan terminal"                       -- task 1 retrieveMenuText
		elseif (step == self.Q1_UNLOCKED) then
			if (self:hasFlag(pPlayer, "slice")) then
				return "Download data"               -- _smuggler task 10
			end

			return "Use decryption key"                  -- _1 task 5
		end
	elseif (role == "corpse") then
		if (stage == self.STAGE_Q2 and not self:hasFlag(pPlayer, "got_corpse")) then
			return "Search remains"                      -- _2 task 1 retrieveMenuText
		end
	elseif (role == "rubble") then
		if (stage == self.STAGE_Q2 and not self:hasFlag(pPlayer, "got_rubble")) then
			return "Search rubble"                       -- _2 task 4 retrieveMenuText
		end
	end

	return nil
end

HistorianMenuComponent = {}

function HistorianMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":historianRole")
	local text = historianScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function HistorianMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":historianRole")

	if (role == "computer") then
		if (historianScreenPlay:getQ1Step(pPlayer) == historianScreenPlay.Q1_ARRIVED) then
			historianScreenPlay:scanTerminal(pPlayer, pSceneObject)
		else
			historianScreenPlay:useTerminal(pPlayer, pSceneObject)
		end
	elseif (role == "corpse" or role == "rubble") then
		historianScreenPlay:takeTabletPiece(pPlayer, pSceneObject, role)
	end

	return 0
end
