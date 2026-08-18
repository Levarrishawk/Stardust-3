--[[
A collector's business  --  som_kenobi_collectors_business_1

SOURCE OF RECORD

quest/som_kenobi_collectors_business_1.qst in the client TREs. Both locations and
their radii, both waypoint names, the two radial texts ("Plug in scanner",
"Search rubble"), both message box titles and bodies, the comm text, the three
encounter creature names with their counts and distances, the 120-180 s timer and
the 10,000 bank credits are all quoted from it. The Level 75 gate is its [list]
block, and the conversation tree is
mobile/conversations/mustafar/som_kenobi_q4p3.lua.

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

WHERE Q4P3 STANDS  --  placed, not quoted

Nothing ships his position. He is a creature template
(object/mobile/som/som_pann_protocol_droid.iff), not a snapshot node, so his
absence from every .ws is expected -- in live he was a server-side spawn and that
spawn data did not ship. No datatable, no Lua spawn, and no line of his dialogue
states where he is.

He is therefore placed in the Mensix mining facility cantina, cell 12112226,
beside Pei Yi and Diskret Stahn. The reasoning: his own rude-decline line (s_154)
is "A thousand apologies for keeping you from squandering all your credits in the
Cantina...I mean from your important business!", which is a joke that only lands if
he is standing where the player's credits are about to go. The cantina is also the
only interior on Mustafar this tree already uses as an NPC hub, and it is where the
other two hand-placed Mustafar conversation NPCs stand.

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
not an object template. Nothing here resolves it: no datatables/quest/* or
datatables/loot/* row in any TRE, no string/en STF row, and no tow_holocron or
ab_immune path anywhere in this tree. As with every other TOW reward in this arc it
can only be matched by description.

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

collectorsBusinessScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "collectorsBusinessScreenPlay",

	-- .qst [list] Level.
	requiredLevel = 75,

	-- Snapshot nodes; see the header.
	droidNodeID = 12112927,
	codexRubbleNodeID = 12111383,
	emptyRubbleNodeID = 12111384,

	-- Placed, not quoted; see WHERE Q4P3 STANDS. Cell 12112226 is the Mensix
	-- cantina, the same cell mensix_mining_facility_main puts Pei Yi (-77.1, 67.5)
	-- and Diskret Stahn (-75.4, 66.3) in. Cell coordinates, and 10.8 is their floor.
	questGiver = {
		template = "som_pann_protocol_droid",
		cell = 12112226,
		x = -79.2,
		z = 10.8,
		y = 68.9,
		heading = 40,
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
