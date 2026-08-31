--[[
The serpent shard  --  som_kenobi_serpent_shard_1

SOURCE OF RECORD

quest/som_kenobi_serpent_shard_1.qst in the client TREs. The ruins location and its
radius, every message box title and body, both retrieveMenuText strings, the 10-20 s
encounter timer, the 15-20 m encounter distances, the 100 % loot rate and the 20,000
credit reward are quoted from it. The conversation trees are
mobile/conversations/mustafar/som_kenobi_ikt.lua and
mobile/conversations/mustafar/som_kenobi_serpent_thief.lua; the handlers that route
them are quest/conversation/ikt_conv_handler.lua and
quest/conversation/serpent_thief_conv_handler.lua.

THE SHAPE OF THE .QST

Tasks 1 and 3 are siblings under task 16 (Nothing), so both are live from the grant.
Task 1 is only the Go to Location and its "The ruins" box -- it gates nothing. Task
3, the altar, is inspectable from the moment the quest starts. That is deliberate in
the file and is kept: a player who walks to the altar without crossing the middle of
the ruins ring is not stuck.

Task 3 completing fires three children at once: task 18's "Hideout?" box, task 5's
Wait for Signal on talkedThief, and task 17's 10-20 s Timer, which fires task 4, the
Encounter that puts the thief 15-20 m from the player. So inspecting the altar is
what summons her, and speaking to her is what opens the kill.

THE ALTAR  --  quoted, and it is a snapshot prop

Task 3 and task 7 both name Server Object Template
object/tangible/quest/som_kenobi_sith_altar.iff. snapshot/mustafar.ws places exactly
one, node 12111381 at (-4536.96, 84.04, 3192.82), and
PlanetManagerImplementation::loadSnapshotObject() instantiates each node with
objectID == the node ID, so getSceneObject(12111381) returns the object the client is
already drawing.

That node is 174 m from task 1's centre (-4400, 3300), inside its Radius 200 -- the
altar is the thing the ruins step is pointing at, and it is the only sith_altar in
the whole snapshot.

The two rubble props beside it (nodes 12111383 and 12111384, 63 m and 70 m away) are
NOT touched here: collectors_business.lua already claims both.

THE CREATURE NAME  --  substituted

Tasks 4 and 6 name som_kenobi_serpent_thief. That name exists nowhere -- not as a
mobile template, not as a client .iff. som_kenobi_serpent_dark_jedi
(mobile/custom_content/som/som_kenobi_serpent_dark_jedi.lua) is what this tree has
for it: a level 70 "a Dark Jedi Thief" carrying a gen3 lightsaber, wired into no
screenplay anywhere and spawned by nothing. The name is the quest's own -- serpent,
thief -- and it is the only creature in the som set that is both.

She is CONVERSABLE and is not AGGRESSIVE (pvpBitmask ATTACKABLE + ENEMY), which is
exactly what task 5 needs: she has to be talkable, and she must not open on the
player before he has spoken to her.

WHERE IKT STANDS  --  live position, recovered

He is a creature template (object/mobile/som/som_mustafarian_ikt.iff), not a snapshot
node, so his absence from every .ws is expected: in live he was a server-side spawn.
An earlier revision read that as "nothing ships his position" and placed him by
reasoning. That was wrong. The facility's dungeon spawn table is the position, and it
posts him in medium_room_01 -- the Mensix cantina, cell 12112226 -- at (-94.3, 10.8,
53.1) facing 90, at the far end of the room from the bar.

The reasoning got the room right and the spot wrong: the cantina is the hub this arc
already uses for Q4P3, Pei Yi, Diskret Stahn and Epo Qetora, and a treasure hunter
looking to hire someone belongs at the planet's only travel point. But "the room is
right" is not "the position is known", and the guessed (-83.5, 69.5) facing 160 put
him about seventeen metres off and turned the wrong way.

Live names him som_kenobi_serpent_ikt. This tree keeps som_mustafarian_ikt because
that is the template with a shipped appearance -- shared_som_mustafarian_ikt.iff is
in the extracted asset set and no serpent_ikt file exists anywhere in it. His
creature template's conversationTemplate was empty and is set to
"som_mustafarian_ikt"'s tree by this wave.

PROGRESS TRACKING

The quest has no row in datatables/player/quests.iff -- the table the server loads is
stardust_03.tre's, whose only Mustafar rows are the 45 exploration markers. So there
is no journal. Progress lives in persistent screenplay data on the player's ghost,
and the journalEntryDescription lines go out as system messages and as waypoint
descriptions instead, which is where the player would otherwise have read them.

THE REWARD  --  half quoted, half substituted

Task 11's Bank Credits=20000 is quoted and paid as written.

Its lootName item_tow_buff_crystal_02_03 is a live server-side static-item name, not
an object template, and nothing in this tree resolves it -- there is no
item_tow_buff_crystal path of any kind. What the name says is a Trials of Obi-Wan
buff crystal, and the one buff crystal this tree actually ships is
object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_buff_crystal_usable.iff.
That is the same substitution reunite_shard.lua:265 already makes for
item_tow_buff_crystal_02_02, so the two shard quests hand out the same kind of thing,
which is what their own text says they should.

It is handed over with giveItem() into the player's inventory, which creates the
object for real -- deliberately not addRewardedSchematic, which fails closed when the
path is not in scripts/managers/crafting/schematics.lua and would silently grant
nothing.

To restore the live item later, only rewardCrystal below changes.

THE STAKEOUT CAN BE RE-ARMED  --  a deviation, on purpose

Task 17's timer runs once. In live, a player who inspected the altar and then walked
off before the thief arrived -- or who logged out during those 10-20 seconds -- had
no way to get her back, and the quest was dead. The .qst models no recovery at all.

So while the stakeout is running and the thief this player summoned is gone, the
altar offers "Closely inspect" again and re-arms the timer. It changes no stage and
grants nothing; it only re-fires task 17. Everything else follows the file.

WHAT IS NOT MODELLED

Tasks 3 and 7 are Retrieve Item, so in live the player carried a "Clue" and a
"Serpent shard" between the steps. Their Server Object Template is the altar itself,
which is SOE reusing the prop template for the carried item and would look wrong in
an inventory. They are progress markers that nothing downstream reads, so those steps
advance the stage and show their message box without minting an item. The thing the
player keeps is the buff crystal, handed over at the reward.

Task 11's Faction Name=Rebel, CountItem/CountWeapon/CountArmor and the four 0.1
quality floats are the Reward task's unused columns -- the file grants no faction
points, no weapon and no armour. Nothing here reads them.

Task 10 is a Wait for Signal on givenShard: that is the turn-in conversation, not a
task.
--]]

serpentShardScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "serpentShardScreenPlay",

	-- Snapshot node; see THE ALTAR.
	altarNodeID = 12111381,

	-- Live position, not placed; see WHERE IKT STANDS. Cell coordinates.
	-- medium_room_01 is cell 12112226, which is where the earlier guess had him
	-- too -- the room was reasoned correctly, the spot in it was not.
	questGiver = {
		template = "som_mustafarian_ikt",
		cell = 12112226,
		x = -94.3,
		z = 10.8,
		y = 53.1,
		heading = 90,
	},

	-- Task 1, Go to Location: mustafar (-4400, 83, 3300), Radius 200. No
	-- waypointName ships, so the journalEntryTitle is used for it.
	ruins = { x = -4400, y = 3300, radius = 200, waypointName = "Tracing back the steps" },

	-- Task 4's Encounter and task 17's Timer; see THE CREATURE NAME.
	thief = {
		template = "som_kenobi_serpent_dark_jedi",
		minDistance = 15,
		maxDistance = 20,
		delayMin = 10,
		delayMax = 20,
	},

	-- Quoted; see THE REWARD.
	rewardCredits = 20000,

	-- Substituted; see THE REWARD.
	rewardCrystal = "object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_buff_crystal_usable.iff",

	STAGE_ACTIVE = 1,
	STAGE_STAKEOUT = 2,
	STAGE_HUNT = 3,
	STAGE_INSERT = 4,
	STAGE_TURNIN = 5,
	STAGE_DONE = 6,

	-- What start() actually placed. Neither is snapshot data, so there is no world
	-- id to look either up by; recording the ids is the only way to find them again,
	-- and the only way a boot check can tell a silent failure from a success.
	questGiverID = 0,
	ruinsAreaID = 0,
}

registerScreenPlay("serpentShardScreenPlay", true)

function serpentShardScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachAltar()
		self:spawnQuestGiver()
		self:spawnRuinsArea()
	end
end

function serpentShardScreenPlay:attachAltar()
	local pAltar = getSceneObject(self.altarNodeID)

	if (pAltar == nil) then
		print("serpentShardScreenPlay: snapshot object " .. self.altarNodeID .. " (the sith altar) was not found; the quest cannot be finished")
		return
	end

	writeStringData(self.altarNodeID .. ":serpentShardRole", "altar")
	SceneObject(pAltar):setObjectMenuComponent("SerpentShardMenuComponent")
end

function serpentShardScreenPlay:spawnQuestGiver()
	local giver = self.questGiver
	local pNpc = spawnMobile("mustafar", giver.template, 0, giver.x, giver.z, giver.y, giver.heading, giver.cell)

	if (pNpc == nil) then
		print("serpentShardScreenPlay: failed to spawn " .. giver.template .. "; the quest cannot be started")
	else
		self.questGiverID = SceneObject(pNpc):getObjectID()
	end
end

-- Task 1. The ruins step has no radial and no object to touch, so an active area is
-- the only thing that can complete it.
function serpentShardScreenPlay:spawnRuinsArea()
	local z = getWorldFloor(self.ruins.x, self.ruins.y, "mustafar")
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.ruins.x, z, self.ruins.y, self.ruins.radius, 0)

	if (pArea == nil) then
		print("serpentShardScreenPlay: failed to spawn the ruins area; the arrival message box will never fire")
		return
	end

	self.ruinsAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "serpentShardScreenPlay", "notifyEnteredRuins", pArea)
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage    0  not started
	         1  quest active; travelling, and the altar can be inspected
	         2  altar inspected; the thief is on her way, or standing there
	         3  spoken to the thief; she can be killed for the shard
	         4  shard in hand; the altar can be opened with it
	         5  second shard found; heading back to Ikt
	         6  turned in
	arrived  1 once the ruins area has fired its box, so it only fires once
	thief    object id of the thief this player summoned, 0 if none
	wp       waypoint id currently handed out, absent if none
--]]

function serpentShardScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function serpentShardScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function serpentShardScreenPlay:hasFlag(pPlayer, key)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) == 1
end

function serpentShardScreenPlay:setFlag(pPlayer, key)
	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
end

function serpentShardScreenPlay:isPresent(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	return pGhost ~= nil and PlayerObject(pGhost):isOnline() and SceneObject(pPlayer):getZoneName() == "mustafar"
end

-- One waypoint at a time: the quest never has two fixed-location objectives open.
-- See PROGRESS TRACKING for why it exists at all.
function serpentShardScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function serpentShardScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

function serpentShardScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("serpentShardScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

-- The .qst message boxes are read-and-dismiss; nothing branches on the button.
function serpentShardScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

--[[ The quest ]]

-- Both directions screens in Ikt's tree land here; see the conversation handler.
function serpentShardScreenPlay:startQuest(pPlayer)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, self.STAGE_ACTIVE)

	-- Persistence 1 so the observer object is saved and kill credit survives a
	-- logout. It is dropped at the turn-in.
	createObserver(KILLEDCREATURE, "serpentShardScreenPlay", "notifyKilledCreature", pPlayer, 1)

	self:giveWaypoint(pPlayer, self.ruins.waypointName, "The serpent shard", self.ruins.x, self.ruins.y)

	-- The quest's own journal_entry_description, then task 1's.
	CreatureObject(pPlayer):sendSystemMessage("A Mustafarian treasure hunter named Ikt found a strange little shard with a flaw shaped like a serpent on it. Shortly afterwards, Ikt was attacked and had the shard stolen from him. You've agreed to assist him in finding the thief and recover his lost shard.")
	CreatureObject(pPlayer):sendSystemMessage("Head to the ruins where Ikt found the small shard. He said they were located West of the giant volcano in the center of the continent, just across the lava river.")
end

-- Task 1 completing, which fires task 2's box. It gates nothing -- task 3 is task
-- 1's sibling, not its child; see THE SHAPE OF THE .QST.
function serpentShardScreenPlay:notifyEnteredRuins(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_ACTIVE or self:hasFlag(pPlayer, "arrived")) then
		return 0
	end

	self:setFlag(pPlayer, "arrived")
	self:removeWaypoint(pPlayer)

	-- Task 2.
	self:showMessageBox(pPlayer, nil, "The ruins",
		"This must be the location that Ikt was talking about. Search the ruins and the areas surrounding it and see if you can find any trace of the mysterious thief.")

	-- Task 3's journalEntryDescription, "Find the crystal".
	CreatureObject(pPlayer):sendSystemMessage("Search the area around the ruins and see if you can find any trace of the thief or clues to where the crystal is.")

	return 0
end

-- Task 3 completing, which fires tasks 18, 5 and 17 together.
function serpentShardScreenPlay:inspectAltar(pPlayer, pAltar)
	local stage = self:getStage(pPlayer)

	if (stage ~= self.STAGE_ACTIVE and stage ~= self.STAGE_STAKEOUT) then
		return
	end

	if (stage == self.STAGE_ACTIVE) then
		self:setStage(pPlayer, self.STAGE_STAKEOUT)
		self:removeWaypoint(pPlayer)

		-- Task 18.
		self:showMessageBox(pPlayer, pAltar, "Hideout?",
			"This looks like an altar of some kind. It has a carved-out symbol of what appears to be a serpent on it. Maybe this is where the thief is hiding... Wait and see if they come back.")

		-- Task 5's journalEntryDescription, "Stakeout".
		CreatureObject(pPlayer):sendSystemMessage("This could be where the thief went to. Wait for them to come back.")

		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
	end

	-- Task 17's Timer, Min 10 / Max 20. Re-armed on a second inspect; see THE
	-- STAKEOUT CAN BE RE-ARMED.
	createEvent(getRandomNumber(self.thief.delayMin, self.thief.delayMax) * 1000, "serpentShardScreenPlay", "spawnThief", pPlayer, "")
end

function serpentShardScreenPlay:getThief(pPlayer)
	local thiefID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "thief")) or 0

	if (thiefID == 0) then
		return nil
	end

	return getSceneObject(thiefID)
end

function serpentShardScreenPlay:isThiefWaiting(pPlayer)
	local pThief = self:getThief(pPlayer)

	return pThief ~= nil and not CreatureObject(pThief):isDead()
end

-- Task 4's Encounter: Count 1, Min Distance 15, Max Distance 20.
function serpentShardScreenPlay:spawnThief(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_STAKEOUT) then
		return
	end

	if (self:isThiefWaiting(pPlayer)) then
		return
	end

	if (not self:isPresent(pPlayer)) then
		-- The stakeout is not lost: the altar re-arms the timer.
		return
	end

	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()
	local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, self.thief.minDistance, self.thief.maxDistance, true)

	if (spawnPoint == nil) then
		print("serpentShardScreenPlay: no spawn point near the player for " .. self.thief.template)
		return
	end

	local pThief = spawnMobile("mustafar", self.thief.template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

	if (pThief == nil) then
		print("serpentShardScreenPlay: failed to spawn " .. self.thief.template)
		return
	end

	-- She spawns invulnerable and talkedThief drops it. Live's action_talked ends with
	-- setInvulnerable(npc, false), which only makes sense if she was invulnerable to
	-- begin with -- and it is what stops a player killing her before the conversation,
	-- which would leave task 5 unsignalled with the only thief in the quest dead.
	TangibleObject(pThief):setOptionBit(INVULNERABLE)

	writeScreenPlayData(pPlayer, self.screenplayName, "thief", tostring(SceneObject(pThief):getObjectID()))
end

-- Task 5's Signal Name talkedThief. All four fight screens in her tree land here;
-- see the conversation handler.
function serpentShardScreenPlay:talkedThief(pPlayer, pThief)
	if (pPlayer == nil or pThief == nil) then
		return
	end

	if (self:getStage(pPlayer) == self.STAGE_STAKEOUT) then
		self:setStage(pPlayer, self.STAGE_HUNT)

		-- Task 6 opening: Destroy Multiple and Loot, NumberItemsRequired 1.
		CreatureObject(pPlayer):sendSystemMessage("The thief has the shard on her. Take it back.")
	end

	-- live's action_talked, second half: setInvulnerable(npc, false). Must come before
	-- the aggro, or the first swing lands on a mob that cannot be hurt.
	TangibleObject(pThief):clearOptionBit(INVULNERABLE)

	-- She is not AGGRESSIVE, so the fight has to be started for her. The bit is set
	-- as well as the defender or she drops the player the moment he breaks line of
	-- sight and goes back to being a talkable NPC holding a quest item.
	TangibleObject(pThief):setPvpStatusBit(AGGRESSIVE)
	AiAgent(pThief):setDefender(pPlayer)
end

--[[ Kill credit

One observer, created when the quest starts and dropped at the turn-in.

The template match is enough on its own: som_kenobi_serpent_dark_jedi is spawned by
nothing but this screenplay.
--]]

function serpentShardScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return 0
	end

	if (AiAgent(pVictim):getCreatureTemplateName() ~= self.thief.template) then
		return 0
	end

	-- Task 6's LootDropPercent is 100, so there is nothing to roll.
	self:setStage(pPlayer, self.STAGE_INSERT)
	deleteScreenPlayData(pPlayer, self.screenplayName, "thief")

	-- Task 8.
	self:showMessageBox(pPlayer, nil, "Shard retrieved",
		"You find the shard on the corpse of the mysterious thief. When you touch the crystal you hear a faint, hissing voice,  \"...the altar...we wish to be placed on the altar.\"  Maybe you should try and see if it fits into the indentation on the altar?")

	-- Task 7's journalEntryDescription, "Shard retrieved".
	CreatureObject(pPlayer):sendSystemMessage("You find the shard on the corpse of the mysterious thief. Maybe you should try and see if it fits into the indentation on the altar.")

	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	self:giveWaypoint(pPlayer, "The serpent altar", "The serpent shard", -4536.96, 3192.82)

	return 0
end

-- Task 7 completing, which fires task 15's box and then task 10: go back to Ikt.
function serpentShardScreenPlay:insertShard(pPlayer, pAltar)
	if (self:getStage(pPlayer) ~= self.STAGE_INSERT) then
		return
	end

	self:setStage(pPlayer, self.STAGE_TURNIN)
	self:removeWaypoint(pPlayer)

	-- Task 15.
	self:showMessageBox(pPlayer, pAltar, "Secret compartment",
		"As you insert the shard into the indentation on the altar, a small, hidden compartment flips open. Inside, you find another shard that looks almost exactly the same as the first. You should take it back to Ikt.")

	-- Task 10's journalEntryDescription, "Another one".
	CreatureObject(pPlayer):sendSystemMessage("As you insert the shard in the indentation on the altar, a hidden compartment flips open. Inside you find another shard that looks almost exactly the same as the first. You should take it back to Ikt.")

	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
end

--[[ Walking away.

Live's action_removeQuest, fired from s_147 and s_143 -- the two mid-quest
"Disappointing. Guess I will have to find someone else." screens in Ikt's tree.
This handler used to fire nothing there, on the reading that the .qst models no
abandon. The .qst does not, but the CONVERSATION does, and the conversation is
what the player touches.

Stage 0 is the same state as never having asked, so Ikt offers the job again --
which is what live does too: with the quest gone, condition_onQuest stops
matching and the tree falls back to its default root, s_110.

The thief goes with it. She is a per-player world spawn with no despawn timer of
her own, so abandoning while she is standing at the ruins would leave her there
for good, and the next run would find isThiefWaiting true and never spawn one.
--]]
function serpentShardScreenPlay:abandonQuest(pPlayer)
	local stage = self:getStage(pPlayer)

	if (stage == 0 or stage > self.STAGE_INSERT) then
		return
	end

	local pThief = self:getThief(pPlayer)

	if (pThief ~= nil) then
		SceneObject(pThief):destroyObjectFromWorld()
	end

	-- Created persistent by startQuest, so it has to be dropped by hand or it sits
	-- in the database forever. Same reason finishQuest drops it.
	dropObserver(KILLEDCREATURE, "serpentShardScreenPlay", "notifyKilledCreature", pPlayer)

	self:removeWaypoint(pPlayer)

	deleteScreenPlayData(pPlayer, self.screenplayName, "thief")
	deleteScreenPlayData(pPlayer, self.screenplayName, "arrived")
	deleteScreenPlayData(pPlayer, self.screenplayName, "stage")

	CreatureObject(pPlayer):sendSystemMessage("You have abandoned Ikt's task.")
end

-- Both reward screens in Ikt's tree land here: task 11's Bank Credits and lootName,
-- then task 13's Immediately Complete Quest.
function serpentShardScreenPlay:finishQuest(pPlayer)
	if (self:getStage(pPlayer) ~= self.STAGE_TURNIN) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE)

	-- Dropped here rather than left to the observer's own "return 1" -- it was
	-- created persistent, so an unfired one would sit in the database forever on a
	-- player who finishes the quest and never kills anything again.
	dropObserver(KILLEDCREATURE, "serpentShardScreenPlay", "notifyKilledCreature", pPlayer)

	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	CreatureObject(pPlayer):sendSystemMessage("You have received " .. self.rewardCredits .. " credits.")

	self:giveReward(pPlayer, self.rewardCrystal, "the crystal Ikt gave you")

	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
	CreatureObject(pPlayer):sendSystemMessage("You have completed Ikt's task.")
end

function serpentShardScreenPlay:giveReward(pPlayer, template, what)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("serpentShardScreenPlay: player has no inventory; " .. template .. " could not be handed over")
	elseif (giveItem(pInventory, template, -1, true) == nil) then
		print("serpentShardScreenPlay: failed to create " .. template)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for " .. what .. ".")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have taken " .. what .. ".")
	end
end

--[[ Radial dispatch

The altar carries both of the quest's Retrieve Item steps. SceneObjectImplementation::
setObjectMenuComponent() falls through to LuaObjectMenuComponent when no C++ component
of that name is registered, and LuaObjectMenuComponent replaces the object's menu
entirely -- so fillObjectMenuResponse has to add every item we want to see, and adds
nothing at all when this player has no business touching the object.
--]]

-- Which radial, if any, this player should be offered on the altar.
function serpentShardScreenPlay:getRadialText(pPlayer, role)
	if (role ~= "altar") then
		return nil
	end

	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_ACTIVE) then
		return "Closely inspect"                        -- task 3 retrieveMenuText
	elseif (stage == self.STAGE_STAKEOUT and not self:isThiefWaiting(pPlayer)) then
		return "Closely inspect"                        -- re-arms task 17's timer
	elseif (stage == self.STAGE_INSERT) then
		return "Insert shard"                           -- task 7 retrieveMenuText
	end

	return nil
end

SerpentShardMenuComponent = {}

function SerpentShardMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":serpentShardRole")
	local text = serpentShardScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function SerpentShardMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	if (readStringData(SceneObject(pSceneObject):getObjectID() .. ":serpentShardRole") ~= "altar") then
		return 0
	end

	if (serpentShardScreenPlay:getStage(pPlayer) == serpentShardScreenPlay.STAGE_INSERT) then
		serpentShardScreenPlay:insertShard(pPlayer, pSceneObject)
	else
		serpentShardScreenPlay:inspectAltar(pPlayer, pSceneObject)
	end

	return 0
end
