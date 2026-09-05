--[[
A collector's business  --  som_kenobi_collectors_business_1

SOURCE OF RECORD

quest/som_kenobi_collectors_business_1.qst in the client TREs. Both locations and
their radii, both waypoint names, the two radial texts ("Plug in scanner",
"Search rubble"), both message box titles and bodies, the comm text, the three
encounter creature names with their counts and distances, the 120-180 s timer and
the 10,000 bank credits are all quoted from it. The level gate is NOT the .qst's
75 -- the droid enforces 61; see the requiredLevel note below. The conversation
tree is mobile/conversations/mustafar/som_kenobi_q4p3.lua.

WHERE THE OBJECTS COME FROM

All three world objects are snapshot props. snapshot/mustafar.ws places them and
PlanetManagerImplementation::loadSnapshotObject() instantiates each node with
objectID == the node ID, so getSceneObject(<nodeID>) returns the object the client
is already drawing:

    node 12112927  quest_start/som_kenobi_broken_droid_1  (-4417.84, 68.18, 1658.95)
    node 12111383  quest_start/som_kenobi_rubble_2        (-4463.64, 82.95, 3255.01)
    node 12111384  quest_start/som_kenobi_rubble_1        (-4458.47, 82.94, 3260.74)

Those positions corroborate the .qst rather than the other way round: the droid
sits 83 m from task 0's waypoint, inside its Radius 100, and both rubble piles sit
within 6 m of task 3's waypoint, inside its Radius 10. rubble_2 is the one task 4
names, so rubble_2 is the Codex pile and rubble_1 is the empty one.

WHERE Q4P3 STANDS  --  live, quoted

An earlier revision of this header said "nothing ships his position" and placed
him in the cantina on a reading of one of his own jokes. That was WRONG, and the
reason it was wrong is worth recording: the search behind it covered the client
TREs and this repo, and never covered the server-side spawn data. His row has
been there the whole time.

The Mensix Mining Facility's dungeon spawn table places som_kenobi_pann_protocol_
droid in room small_room_04 at -28.8 / 19.1 (height) / -22, heading 29. That is
cell 12112238 -- see THE CELL MAP in mensix_mining_facility_main.lua for how the
30 cell ids are derived from the .pob and the snapshot.

The row names the template, not the character, so the identification is worth
showing: his own briefing line (s_70) is "My master is the honorable Pann!", and
the template is som_kenobi_pann_protocol_droid. He is Pann's protocol droid.

small_room_04 is upstairs on the 19.1 floor and it is a shared room: Epo Qetora
(historian.lua) and Ithes Olok (jenha_tar_cube.lua) stand in it too, all three
within 16 m of each other. It is not the cantina, which is medium_room_01 on the
10.8 floor about 62 m away.

His creature template's conversationTemplate was empty and is set to
"som_kenobi_q4p3" by this wave, the same way pei_yi carries "som_pei_yi".

THE COMM  --  substituted, and here is why

Task 2 is a Comm Player task: the client's holo-comm window, with
som_pann_protocol_droid.iff as the caller's appearance. This server has no comm
channel at all -- there is no comm packet anywhere in src/server/zone/packets, and
no Lua binding for one -- so the transmission cannot be driven. The .qst's text is
delivered verbatim in a SUI message box titled with the droid's name instead. The
words are his; the window is not.

PROGRESS TRACKING

The quest has no row in datatables/player/quests.iff -- the table the server loads
is stardust_03.tre's, which wins the TreFiles order in conf/config.lua, and its
only Mustafar rows are the 45 exploration markers. So there is no journal. Progress
lives in persistent screenplay data on the player's ghost, and the .qst's
journalEntryDescription lines go out as system messages and waypoint descriptions
instead, which is where the player would otherwise have read them.

The [list] block says allowRepeats true, so the two give-up screens put the player
back to stage 0 and the briefing can be taken again.

THE REWARD  --  half quoted, half substituted

Bank Credits 10000 is task 19 verbatim, and Q4P3 says the number out loud in both
turn-in branches ("I will deposit 10,000 credits to your bank account
immediately"). That half is exact.

The item is not. Task 19 awards lootCount 1 / lootName
item_tow_holocron_ab_immune_02_01, which is a live server-side static-item name,
not an object template. The name resolves to "Sith Holocron" in
string/en/static_item_n.stf, but an exhaustive sweep of every shipped
shared_*.iff finds no object template carrying that objectName, so granting the
live item would mean authoring an object. As with every other TOW reward in this
arc it can only be matched by description.

What the name and the dialogue say: a holocron from Trials of Obi-Wan; "a little
pyramid-shaped trinket"; "an information storage device"; "Something odd about
it... I think it has a secondary function"; and "You can keep this device".

What this tree has for that: object/tangible/quest/som_kenobi_recall_holocron.iff.
It is a registered server template
(object/custom_content/tangible/quest/som_kenobi_recall_holocron.lua, included from
that folder's serverobjects.lua) whose appearance ships in the client, it belongs to
this same Kenobi arc, and "recall holocron" is literally an information storage
device with a secondary function. It exists, which the live-named item does not.

It is handed over with giveItem() into the player's inventory, which creates the
object for real -- deliberately not addRewardedSchematic, which fails closed when
the path is not in scripts/managers/crafting/schematics.lua and would silently
grant nothing (the defect hidden_treasure.lua's reward had to be corrected for).

To restore the live item later, only rewardItem below changes.

WHAT IS NOT MODELLED

Tasks 1 and 4 are Retrieve Item, so in live the player carried "Memory data" and
"Codex" as inventory objects between the steps. Their Server Object Templates are
the world props themselves (som_kenobi_broken_droid_1.iff, som_kenobi_rubble_2.iff)
-- a broken droid and a pile of rubble -- which is SOE reusing the prop template for
the carried item and would look wrong in an inventory. Both are progress markers
that nothing downstream reads, so those steps advance the stage and show their
message box without minting an item. The thing the player actually keeps is handed
over at the reward, which is where the dialogue says he gets it.

Task 18 is a Wait for Signal on "talkedDroid" -- the turn-in conversation. That is
the conversation handler, not a task.
--]]

local JournalMirror = require("managers.quest.journal_mirror")

collectorsBusinessScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "collectorsBusinessScreenPlay",

	-- The gate Q4P3 actually applies.  His conversation tests
	-- getLevel(player) > 60 and opens the briefing only when that is true, so
	-- 61 is the first level that can take the job.  requiredLevel is compared
	-- with "<" in q4p3_conv_handler, so it holds the first QUALIFYING level.
	--
	-- (SOE named that condition "levelTooLow" and then used it as the pass
	-- test.  The name is backwards; the arithmetic is what runs.)
	--
	-- The .qst [list] Level field says 75.  That is the journal's difficulty
	-- label, not an entry check -- nothing reads it at grant time.  An earlier
	-- revision enforced the 75 because the conversation had not been found yet.
	requiredLevel = 61,

	-- Snapshot nodes; see the header.
	droidNodeID = 12112927,
	codexRubbleNodeID = 12111383,
	emptyRubbleNodeID = 12111384,

	-- Live, quoted; see WHERE Q4P3 STANDS. small_room_04 of the Mensix Mining
	-- Facility is cell 12112238, and the live row is -28.8 / 19.1 / -22 at
	-- heading 29. Cell coordinates, and 19.1 is the upper floor.
	questGiver = {
		template = "som_pann_protocol_droid",
		cell = 12112238,
		x = -28.8,
		z = 19.1,
		y = -22,
		heading = 29,
	},

	-- .qst task 0, Go to Location: mustafar (-4335, 90, 1669), Radius 100,
	-- waypointName "Last known droid coordinates".
	droidSite = { x = -4335, y = 1669, waypointName = "Last known droid coordinates" },

	-- .qst task 3, Go to Location: mustafar (-4465, 83, 3260), Radius 10,
	-- waypointName "Possible Codex location".
	codexSite = { x = -4465, y = 3260, waypointName = "Possible Codex location" },

	-- .qst task 12: Count 1, Min Distance 15, Max Distance 30. The repo template is
	-- som_trinity_assassin_zabrak_female; the .qst calls the same creature
	-- som_kenobi_trinity_assassin_zabrak_female. spawnMobile needs the repo name.
	charge = { template = "som_trinity_assassin_zabrak_female", minDistance = 15, maxDistance = 30 },

	-- .qst task 14: Timer Min 120 / Max 180, then tasks 15 and 16, each Count 1,
	-- Min Distance 30, Max Distance 30. Same repo-name rule.
	stalkDelayMin = 120,
	stalkDelayMax = 180,
	stalkers = {
		{ template = "som_trinity_assassin_nightsister_female", minDistance = 30, maxDistance = 30 },
		{ template = "som_trinity_assassin_ithorian_male", minDistance = 30, maxDistance = 30 },
	},

	-- .qst task 19 Bank Credits, quoted; the item is substituted, see THE REWARD.
	rewardCredits = 10000,
	rewardItem = "object/tangible/quest/som_kenobi_recall_holocron.iff",

	STAGE_FIND_DROID = 1,
	STAGE_FIND_CODEX = 2,
	STAGE_RETURN = 3,
	STAGE_DONE = 4,
}

-- JOURNAL MIRROR (J-3, 2026-09-04): stage -> client journal task bits, from the SOE task tree in
-- this header and scratch/mustafar-stage-task-map.md §collectors_business. Screenplay data stays truth.
collectorsBusinessScreenPlay.journalMap = {
	[1] = { quest = "som_kenobi_collectors_business_1", complete = {0}, activate = {1} }, -- 1→t1 find the broken droid
	[2] = { quest = "som_kenobi_collectors_business_1", complete = {1}, activate = {4} }, -- 2→t4 search rubble
	[3] = { quest = "som_kenobi_collectors_business_1", complete = {4} }, -- 3→t18 return to Q4P3 (t18 OOR, no bit)
	[4] = { quest = "som_kenobi_collectors_business_1", finish = true }, -- 4→t19/t20 Reward+Complete (both OOR)
}

registerScreenPlay("collectorsBusinessScreenPlay", true)

function collectorsBusinessScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachSnapshotObjects()
		self:spawnQuestGiver()
	end
end

function collectorsBusinessScreenPlay:attachSnapshotObjects()
	local props = {
		{ id = self.droidNodeID, role = "droid" },
		{ id = self.codexRubbleNodeID, role = "codexRubble" },
		{ id = self.emptyRubbleNodeID, role = "emptyRubble" },
	}

	for i = 1, #props do
		local pProp = getSceneObject(props[i].id)

		if (pProp == nil) then
			print("collectorsBusinessScreenPlay: snapshot object " .. props[i].id .. " (" .. props[i].role .. ") was not found; that step of the quest will be unreachable")
		else
			writeStringData(props[i].id .. ":collectorsRole", props[i].role)
			SceneObject(pProp):setObjectMenuComponent("CollectorsBusinessMenuComponent")
		end
	end
end

function collectorsBusinessScreenPlay:spawnQuestGiver()
	local giver = self.questGiver
	local pNpc = spawnMobile("mustafar", giver.template, 0, giver.x, giver.z, giver.y, giver.heading, giver.cell)

	if (pNpc == nil) then
		print("collectorsBusinessScreenPlay: failed to spawn " .. giver.template .. "; the quest cannot be started")
	end
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage         0  not started, or given up
	              1  briefed; looking for the broken mining droid
	              2  droid scanned; looking through the rubble
	              3  Codex found; heading back to Q4P3
	              4  turned in and rewarded
	emptyRubble   1 once the empty pile has been searched
	wp            waypoint id currently handed out, 0 if none
--]]

function collectorsBusinessScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function collectorsBusinessScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
	JournalMirror.applyStage(pPlayer, self.journalMap, stage)   -- J-3 journal mirror
end

-- Which radial, if any, this player should be offered on a given object.
function collectorsBusinessScreenPlay:getRadialText(pPlayer, role)
	local stage = self:getStage(pPlayer)

	if (role == "droid") then
		if (stage == self.STAGE_FIND_DROID) then
			return "Plug in scanner"                 -- .qst task 1 retrieveMenuText
		end
	elseif (role == "codexRubble") then
		if (stage == self.STAGE_FIND_CODEX) then
			return "Search rubble"                   -- .qst task 4 retrieveMenuText
		end
	elseif (role == "emptyRubble") then
		if (stage == self.STAGE_FIND_CODEX and (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "emptyRubble")) or 0) == 0) then
			return "Search rubble"                   -- .qst task 6 retrieveMenuText
		end
	end

	return nil
end

function collectorsBusinessScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("collectorsBusinessScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

-- The .qst message boxes are read-and-dismiss; nothing branches on the button.
function collectorsBusinessScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

function collectorsBusinessScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function collectorsBusinessScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

--[[ The quest ]]

-- Both accept screens land here; see the conversation handler.
-- .qst task 0, musicOnActivate sound/mus_mustafar_quest_exception.snd.
function collectorsBusinessScreenPlay:startQuest(pPlayer)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, self.STAGE_FIND_DROID)

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")

	-- task 0's journalEntryTitle / journalEntryDescription, and task 1's, going out
	-- as the waypoint and a system message because there is no journal here.
	self:giveWaypoint(pPlayer, self.droidSite.waypointName, "In search of a droid", self.droidSite.x, self.droidSite.y)
	CreatureObject(pPlayer):sendSystemMessage("Q4P3 provided you with coordinates to where the connection with the mining droid was lost. Scout the area and try to find the mining droid. If you find it, plug the scanner that Q4P3 gave you in to it.")
end

-- Both give-up screens land here. The [list] block says allowRepeats true, so this
-- clears progress rather than locking the player out.
function collectorsBusinessScreenPlay:abandonQuest(pPlayer)
	self:removeWaypoint(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "emptyRubble")
	self:setStage(pPlayer, 0)
end

-- .qst task 1 completing, which fires task 2 (Comm Player) and then task 3.
function collectorsBusinessScreenPlay:scanDroid(pPlayer, pDroid)
	if (self:getStage(pPlayer) ~= self.STAGE_FIND_DROID) then
		return
	end

	self:setStage(pPlayer, self.STAGE_FIND_CODEX)

	-- task 2's Comm Message Text, verbatim; see THE COMM in the header.
	self:showMessageBox(pPlayer, pDroid, "Q4P3",
		"How does this thing work again? There, can you hear me now? Good. This looks very promising. Please proceed to the coordinates that I'm uploading to your datapad, as soon as you are able to. Thank you! Q4P3 over and out.")

	self:giveWaypoint(pPlayer, self.codexSite.waypointName, "Target located", self.codexSite.x, self.codexSite.y)
	CreatureObject(pPlayer):sendSystemMessage("The mining droid had some information that got Q4P3 really excited. He has provided you with the coordinates from the mining droid, head over there and see what you can find.")
end

-- .qst task 6 completing, which fires task 7's message box and nothing else.
function collectorsBusinessScreenPlay:searchEmptyRubble(pPlayer, pRubble)
	if (self:getStage(pPlayer) ~= self.STAGE_FIND_CODEX) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "emptyRubble", "1")

	self:showMessageBox(pPlayer, pRubble, "No luck",
		"While searching the rubble, you get an uneasy feeling that someone is watching you but can't see anyone. You finish going through the rubble but find nothing of interest. Keep looking around the area.")
end

-- .qst task 4 completing, which fires task 9's message box, then task 12's
-- encounter, then task 18's wait for the turn-in conversation.
function collectorsBusinessScreenPlay:searchCodexRubble(pPlayer, pRubble)
	if (self:getStage(pPlayer) ~= self.STAGE_FIND_CODEX) then
		return
	end

	self:setStage(pPlayer, self.STAGE_RETURN)
	self:removeWaypoint(pPlayer)

	self:showMessageBox(pPlayer, pRubble, "Codex?",
		"You dig through the rubble with your hands and spot what you guess could be the Codex, from Q4P3's description. As you grab it, you hear something behind you...")

	-- task 12 is the "something behind you": one assassin, 15-30 m out. Its
	-- journalEntryDescription is the only warning the player gets.
	CreatureObject(pPlayer):sendSystemMessage("A woman charges out from her hiding spot heading in your direction. She's obviously hostile.")
	self:spawnAssassin(pPlayer, self.charge)

	-- task 18: return to Q4P3 with the little pyramid shaped item.
	CreatureObject(pPlayer):sendSystemMessage("Return to Q4P3 with the little pyramid shaped item.")

	-- task 14: Timer 120-180 s, then the other two, silently.
	createEvent(getRandomNumber(self.stalkDelayMin, self.stalkDelayMax) * 1000, "collectorsBusinessScreenPlay", "springStalkers", pPlayer, "")
end

-- .qst tasks 15 and 16. Both are isVisible false with showSystemMessages off, so
-- they arrive without any warning at all -- the point of the 120-180 s delay.
function collectorsBusinessScreenPlay:springStalkers(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_RETURN) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil or not PlayerObject(pGhost):isOnline() or SceneObject(pPlayer):getZoneName() ~= "mustafar") then
		return
	end

	for i = 1, #self.stalkers do
		self:spawnAssassin(pPlayer, self.stalkers[i])
	end
end

function collectorsBusinessScreenPlay:spawnAssassin(pPlayer, encounter)
	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()
	local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, encounter.minDistance, encounter.maxDistance, true)

	if (spawnPoint == nil) then
		print("collectorsBusinessScreenPlay: no spawn point near the player for " .. encounter.template)
		return
	end

	local pAssassin = spawnMobile("mustafar", encounter.template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

	if (pAssassin == nil) then
		print("collectorsBusinessScreenPlay: failed to spawn " .. encounter.template)
		return
	end

	AiAgent(pAssassin):setDefender(pPlayer)
end

-- .qst task 19 (Reward) and task 20 (Immediately Complete Quest, musicOnComplete
-- sound/mus_mustafar_quest_success.snd), fired from the screen where Q4P3 says he
-- is paying.
function collectorsBusinessScreenPlay:awardQuest(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_RETURN) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE)
	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_collectors_business_1")
	self:removeWaypoint(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "emptyRubble")

	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("collectorsBusinessScreenPlay: player has no inventory; the device could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		print("collectorsBusinessScreenPlay: failed to create " .. self.rewardItem)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for the device Q4P3 let you keep.")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have taken the device Q4P3 let you keep.")
	end

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
	CreatureObject(pPlayer):sendSystemMessage("You have completed Q4P3's task.")
end

--[[ Radial dispatch

One component table serves the broken droid and both rubble piles.
SceneObjectImplementation::setObjectMenuComponent() falls through to
LuaObjectMenuComponent when no C++ component of that name is registered, and
LuaObjectMenuComponent replaces the object's menu entirely -- so
fillObjectMenuResponse has to add every item we want to see, and adds nothing at
all when this player has no business touching the object.
--]]

CollectorsBusinessMenuComponent = {}

function CollectorsBusinessMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":collectorsRole")
	local text = collectorsBusinessScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function CollectorsBusinessMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":collectorsRole")

	if (role == "droid") then
		collectorsBusinessScreenPlay:scanDroid(pPlayer, pSceneObject)
	elseif (role == "codexRubble") then
		collectorsBusinessScreenPlay:searchCodexRubble(pPlayer, pSceneObject)
	elseif (role == "emptyRubble") then
		collectorsBusinessScreenPlay:searchEmptyRubble(pPlayer, pSceneObject)
	end

	return 0
end
