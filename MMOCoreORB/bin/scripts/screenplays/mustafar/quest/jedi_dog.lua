--[[
	The Jedi's Guard Dog  --  som_jedi_dog

	SOURCE OF RECORD
	----------------
	Every title, description, item name, count, drop percent, signal name, sound
	and credit figure below is quoted verbatim from the shipped quest definition

		quest/som_jedi_dog.qst    (294 lines)

	read as plain XML out of the client TREs.  Provenance comments name the .qst
	task each string came from.  Where a string had to be authored because the
	.qst has no line for it, the comment says so in as many words.

	It is its own screenplay, not part of the lava beetle pair or the man-eater
	job, because its [list] block has prerequisiteQuests EMPTY, exclusionQuests
	EMPTY, and every grantQuestOnComplete field in the file is "".  Nothing in
	the shipped data links it to any other quest.

	THE TASK TREE, IN THE ORDER THE .qst RUNS IT
	--------------------------------------------
		task 0  Nothing                    musicOnActivate only
		task 1  Comm Player                mustafar_jedi_dog_one
		                                   NPC Appearance Server Template
		                                   object/mobile/som/master_kah.iff
		task 5  Destroy Multiple and Loot  mustafar_jedi_dog_two
		                                   CreatureType som_xandank_cobak,
		                                   Social Group "",
		                                   LootItemName
		                                   "The tag on the collar reads: Cobak - 78452",
		                                   NumberItemsRequired 1,
		                                   LootDropPercent 100
		task 3  Wait for Signal            mustafar_jedi_dog_three
		                                   Signal Name mustafar_jedi_dog_reward
		task 6  Reward                     Bank Credits 10000, lootCount 1,
		                                   lootName item_tow_clothing_03_03,
		                                   musicOnComplete mus_mustafar_quest_success

	THERE IS NO COORDINATE ANYWHERE IN THIS .qst
	--------------------------------------------
	Every task in the file carries Planet "tatooine", LocationX/Y/Z 0.0 and
	createWaypoint 0 -- the quest editor's untouched defaults.  Not one task has
	a real location, a radius or a waypoint.  So this file sets NO waypoints:
	adding one would mean inventing a destination the shipped quest deliberately
	does not give.  Task 5's own text is the intended pointer and it is a hint,
	not a marker -- "In his recording, the Jedi appeared to be located in
	Berken's Flow. Maybe that would be a good place to start your search."

	WHAT THE WORLD DOES SHIP -- BOTH PROPS, BOTH PLACED
	---------------------------------------------------
	Nothing here spawns a prop.  snapshot/mustafar.ws in stardust_03.tre already
	places both of this quest's objects, and PlanetManagerImplementation::
	loadSnapshotObject() instantiates each snapshot node with objectID == the node
	id, so getSceneObject(<nodeID>) returns the exact object the client is already
	drawing.  Spawning our own copies would double them up.

		node 12113081  object/tangible/item/som/shared_jedi_watch_dog_datapad.iff
		                                              (-6017.03, 90.19,  -76.12)
		node 12110930  object/tangible/item/som/shared_jedi_watch_dog_chest.iff
		                                              (-1207.32, 58.08, 4829.58)

	Both server templates are registered:
	object/custom_content/tangible/item/som/serverobjects.lua lines 13 and 14.
	No other screenplay in this tree references either node id.

	The datapad is where the quest starts, and the shipped placement proves it.
	The [list] block says "While looking through the stolen goods in the bandit
	camp, you received a message that must be over twenty years old".
	managers/planet/mustafar_regions.lua:147 declares the region
	{"sw_bandit_camp", -6029, 0, {1, 100}, ...} -- a 100 m circle -- and the
	datapad node sits 77.1 m from its centre, inside it.
	screenplays/mustafar/regions/mensix_facility_region.lua:76-79 stands the
	salvage bandits themselves 134 m away at (-6016, 83.1, 58.5).  A
	"jedi_watch_dog_datapad" inside the salvage bandits' camp, in the quest whose
	own prose says the message reached the player among the bandit camp's stolen
	goods, is the quest's start object.

	That is an INFERENCE from the placement plus the [list] prose, not a field in
	the .qst -- the .qst names no giver and has no start hook.  It is wired
	anyway, because it is the only reading the world supports and the alternative
	is a quest with no way in at all.  grantJediDog() is exposed separately so a
	giver can be pointed at it later without touching the datapad.

	The chest is task 3, verbatim: "Open the Chest".

	(.ws stores x / height / z; Core3's spawn calls take x, z, y with z as the
	height, so a .ws triple maps across unchanged in that order.
	map_exploration.lua:43-81 documents this.)

	THE CREATURE DOES NOT SHIP -- SUBSTITUTED, AND FLAGGED
	------------------------------------------------------
	Task 5's CreatureType is "som_xandank_cobak".  It does not exist: a scoped
	grep over every .lua in this repo returns zero hits, and a binary-safe grep
	over all of C:\swg-extract\_som returns hits only inside this .qst itself.
	There is no mobile/custom_content/som template for it, so it cannot be spawned.

	It is substituted with mobile/custom_content/som/orf_xandank (level 70,
	registered at som/serverobjects.lua:101), renamed with
	setCustomObjectName("Cobak").

	orf_xandank rather than the plain "xandank" for one concrete reason, not
	flavour: trophy_hunts.lua:432-436 counts som_xandank_trophey's pack kills off
	a template set of { xandank, xandank_onyx_plated, xandank_patriarch }, with a
	deliberate fallback (trophy_hunts.lua:1174) that credits ANY creature of
	those templates when the recorded spawn ids do not match.  Building Cobak out
	of one of those three would make killing him tick that quest's pack counter
	even when he is not one of its recorded spawns.  orf_xandank is outside
	trophy_hunts' set, so it avoids exactly that.

	It does NOT avoid every counter, and saying so would be false.  Four xandank
	templates are registered (som/serverobjects.lua:101 orf_xandank, :190 xandank,
	:180 xandank_onyx_plated, :181 xandank_patriarch) and TWO other screenplays
	count all four together:

	    bounty_hunts.lua:275     killTemplates = { xandank, xandank_onyx_plated,
	    map_exploration.lua:186                    xandank_patriarch, orf_xandank }

	So killing Cobak credits those two quests' xandank legs no matter which of
	the four he is built from -- there is no xandank variant that dodges them.
	Whether a scripted unique should be excluded from those two sets (the way
	reunite_shard's som_kenobi_reunite_tulrus is excluded from the tulrus sets)
	is a real call and it is NOT made here: touching another screenplay's kill
	set would change quests nobody asked me to change.  OPEN.

	Which shipped xandank variant Cobak "should" be is still MINE, not a finding
	-- see OPEN DECISIONS in the report.

	Berken's Flow, where task 5 says to look: the chest sits 411.99 m outside the
	nearest Berken's Flow spawn ring, which is berkens_4 (centre -616 / 4433,
	radius 300, mustafar_regions.lua:98) -- nearest confirmed by measuring the
	chest against all ten berkens_* rows, not assumed; the next nearest are
	berkens_4a at the same 411.99 m, berkens_3 at 511.99 m and berkens_5 at
	588.73 m (-474 / 5120, radius 200, :101).  Those rings are creature spawn
	areas, not a named-place boundary, so this is a measurement and not a
	contradiction -- but it is recorded here because it is the only thing in the
	shipped data that could have located Cobak, and it does not locate him
	tightly.  He is placed on the chest's own shipped position instead, which is
	the one thing the world does assert.

	Berken's Flow's spawn rings list "mustafar_xandanks" in NINE rows --
	berkens_2 :93, _3 :95, _4 :98, _5 :101, _6 :104, _7 :105, _8 :108, _9 :110
	and _10 :113 -- so a xandank standing guard in that stretch is at least
	consistent with what the region is meant to hold.

	THE COMM PLAYER TASK -- SENT AS A MESSAGE BOX, PORTRAIT NOT HONOURED
	--------------------------------------------------------------------
	Task 1 is a "Comm Player" task: a full-screen NPC comm window with a talking
	head built from "NPC Appearance Server Template =
	object/mobile/som/master_kah.iff".  There is no Lua-reachable ground comm
	path in this server -- hk_history.lua:47-80 walks the C++ and shows why -- so
	the shipped Comm Message Text goes out in a SuiMessageBox titled with task
	1's own journalEntryTitle, exactly as hk_history.lua does for the same task
	type.  The talking head is lost.  Nothing else about the task changes.

	master_kah IS registered (som/serverobjects.lua:65) and no screenplay in this
	tree spawns him.  He is not stood up here either: task 1 borrows his face for
	a twenty-year-old recording, it does not put him in the world, and the quest
	is explicit that the Jedi who recorded it was hunted down during the Clone
	Wars.

	THE CODE ON THE COLLAR -- NOT AN INPUT BOX
	-------------------------------------------
	Task 3's text says the chest "is locked with a code. Perhaps the numbers
	written on Cobak's collar, 78452, might help."  The task itself is a bare
	Wait for Signal; it has no input field, no lock object and no code field --
	78452 exists only inside that sentence and inside task 5's LootItemName.

	So the collar IS the key.  The chest's radial is offered only to a player who
	has taken the collar off Cobak, and using it fires
	mustafar_jedi_dog_reward.  Putting a SuiInputBox in front of it would be
	inventing a UI the shipped quest does not describe; gating on the collar is
	what the shipped text actually says happens.

	NO JOURNAL / PROGRESS TRACKING
	------------------------------
	som_jedi_dog has no row in datatables/player/quests.iff.  The table the
	server loads is the one in stardust_03.tre, which wins the TreFiles order in
	conf/config.lua; it holds 307 rows whose only Mustafar entries are the 45
	exploration markers.  Adding a row would mean authoring a TRE, so nothing is
	added to managers/quest/quest_manager.lua and the .qst's journalEntryTitle
	and journalEntryDescription go out as system messages instead.

	THE REWARD -- CREDITS LITERAL, CLOTHING SUBSTITUTED
	---------------------------------------------------
	Task 6 pays Bank Credits 10000 and lootCount 1 of lootName
	item_tow_clothing_03_03.  Note that the [list] block's own Bank Credits field
	is 0 and its lootName is empty; the payout lives on the Reward task, and that
	is the one honoured.  Experience Amount 0 / quest_combat and Faction Amount 0
	/ Rebel are honoured literally: no XP, no faction.  The stored Experience
	Amount 0 is real; live still paid, because the server recomputed from
	quest_experience (see mustafar_quest_xp.lua).

	The 10000 credits are granted literally.  The loot name cannot be resolved
	to an object: item_tow_clothing_03_03 is a live server-side static-item name,
	not an object template.  The name resolves to "Mustafarian Miner's Boots" in
	string/en/static_item_n.stf, but an exhaustive sweep of every shipped
	shared_*.iff finds no object template carrying that objectName, so granting
	the live item would mean authoring an object.  (som_striking_miners.qst
	carries the sibling item_tow_clothing_03_02, which resolves to "Mustafarian
	Mining Suit" in the same STF and likewise has no shipped object; the
	screenplay for it substituted a coverall on the same reasoning.)

	The substitute granted here is object/tangible/wearables/robe/robe_s01.iff
	(addTemplate at robe_s01.lua:99, included from that folder's
	serverobjects.lua:63).  Reasoning, in full: the item comes out of a Jedi
	Knight's travel chest holding "most of my personal belongings", so a robe is
	the belonging the fiction asks for -- but eleven of the twelve robe_jedi_*
	templates in this tree carry certificationsRequired plus Force skillMods (all
	ten robe_jedi_light_s0N / robe_jedi_dark_s0N, and robe_jedi_padawan), so
	granting one would hand a non-Jedi an unequippable statted item.  The twelfth,
	robe_jedi_test, has neither field and IS registered (serverobjects.lua:61),
	but it is a developer test template and is not handed to a player as a quest
	reward.  robe_s01 is a plain cosmetic robe with no certificationsRequired and
	no skillMods at all (addTemplate at robe_s01.lua:99, registered at
	serverobjects.lua:63).  It is a SUBSTITUTE, not a resolution -- OPEN.

	REPEATS
	-------
	[list] allowRepeats = true, so STAGE_DONE is a record and not a lock:
	grantJediDog resets from it and bumps a run counter.  (The per-task
	allowRepeats fields are all 0; that is the task-level default and is
	unrelated.)

	WHAT IS NOT MODELLED
	--------------------
	  * The collar is a counter, not a minted inventory item.  No server template
	    for it ships and inventing one is content authoring nobody asked for.
	    This is the same call trophy_hunts.lua:200-202 made for its four progress
	    markers.  OPEN.
	  * The chest is not opened, emptied or animated, and nothing is removed from
	    the world.  It is a snapshot object the client draws; removing it would
	    remove it for everybody on the shard, and the quest is repeatable.
	  * The Reward task's CountItem / CountWeapon / CountArmor fields are all 1
	    with empty Item / lootName2 / exclusivelootName slots, and are unused.
	  * "Level 75", "Type solo" and "Tier 3" are recorded on the table for a giver
	    to gate on; nothing here enforces them.  Note that this is the only one of
	    the four SOM creature jobs looked at here that is Tier 3 rather than
	    Tier 4.
	  * The trailing space at the end of task 3's shipped description
	    ("...might help. ") is reproduced as shipped.
--]]

jediDogScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "jediDogScreenPlay",

	-- task 0, Nothing: musicOnActivate.  task 6, Reward: musicOnComplete.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",

	STAGE_FIND_COBAK = 1,
	STAGE_OPEN_CHEST = 2,
	STAGE_DONE = 3,

	-- [list]
	title = "The Jedi's Guard Dog",
	description = "While looking through the stolen goods in the bandit camp, you received a message that must be over twenty years old. Most of the message was garbled, but it was from a Jedi Knight stationed on Mustafar during the Clone Wars. He mentioned a locked crate that he had kept some of his equipment in, which is being guarded by someone or something named Cobak.",
	questLevel = 75,
	questTier = 3,

	-- task 1, Comm Player (mustafar_jedi_dog_one).  The portrait template is
	-- object/mobile/som/master_kah.iff and cannot be honoured -- see the header.
	commTitle = "A Message from the Past",
	commDescription = "You just received a message that must be at least twenty years old from a Jedi Knight serving during the Clone Wars.",
	commMessageText = "This will probably be my last entry. I managed to elude grey squad after they turned on me, but this morning I saw separatist vessels landing at the mining facility. It will only be a matter of time before either the droid or my own...correction, grey squad tracks me down. I have prepared for this event and stored most of my personal belongings in my travel chest. Cobak will watch over it and keep them safe. Hopefully, Master Yoda will find them and be able to figure out what is going on. Signing off.",

	-- task 5, Destroy Multiple and Loot (mustafar_jedi_dog_two).
	-- CreatureType som_xandank_cobak -- SUBSTITUTED, see the header.
	cobakTitle = "Find Cobak",
	cobakDescription = "The message was pretty old, but if Cobak is still alive maybe he knows where the Jedi's chest is. Find Cobak and see if you can get the chest from him. In his recording, the Jedi appeared to be located in Berken's Flow. Maybe that would be a good place to start your search.",
	collarItemName = "The tag on the collar reads: Cobak - 78452",
	collarsRequired = 1,
	collarDropPercent = 100,
	cobakTemplate = "orf_xandank",
	cobakName = "Cobak",
	-- Respawning, not one-shot: he is a permanent world guard shared by every
	-- player and the quest is repeatable.  Respawn re-inserts the SAME object,
	-- so the objectID recorded at start() survives it and is what the kill
	-- observer matches on.  trophy_hunts.lua:564-566 documents the same rule.
	cobakRespawn = 300,
	-- Placed, not quoted.  Derived at runtime from the chest node's own world
	-- position; the offset is MINE, chosen so the guard stands beside the thing
	-- he is guarding rather than inside its mesh.
	cobakOffsetX = 3,
	cobakOffsetY = 3,

	-- task 3, Wait for Signal (mustafar_jedi_dog_three).
	-- Signal Name mustafar_jedi_dog_reward.  Fired by the chest radial.
	chestTitle = "Open the Chest",
	chestDescription = "Cobak was apparently still standing guard over his master's chest after all these years. The chest appears to be undisturbed, but is locked with a code. Perhaps the numbers written on Cobak's collar, 78452, might help. ",

	-- task 6, Reward.  Bank Credits 10000, lootCount 1, lootName
	-- item_tow_clothing_03_03 (SUBSTITUTED -- header).
	rewardCredits = 10000,
	rewardItem = "object/tangible/wearables/robe/robe_s01.iff",
	rewardName = "robe from the Jedi's chest",

	-- snapshot/mustafar.ws.  See WHAT THE WORLD DOES SHIP in the header.
	datapadNodeID = 12113081,
	chestNodeID = 12110930,

	cobakID = 0,
}

registerScreenPlay("jediDogScreenPlay", true)

-- ====================================================================
-- World setup
--
-- DirectorManager::startScreenPlay calls this by name on every screenplay
-- registered with true, so everything here runs once per server start.
-- ====================================================================

function jediDogScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:attachProps()
		self:spawnCobak()
	end
end

function jediDogScreenPlay:attachProp(nodeID, role, whatBreaks)
	local pProp = getSceneObject(nodeID)

	if (pProp == nil) then
		print("jediDogScreenPlay: snapshot object " .. nodeID .. " (" .. role .. ") was not found; " .. whatBreaks)
		return nil
	end

	writeStringData(nodeID .. ":jediDogRole", role)
	SceneObject(pProp):setObjectMenuComponent("JediDogMenuComponent")

	return pProp
end

function jediDogScreenPlay:attachProps()
	self:attachProp(self.datapadNodeID, "datapad", "som_jedi_dog cannot be started")
	self:attachProp(self.chestNodeID, "chest", "som_jedi_dog cannot be finished")
end

-- Cobak stands on the chest's own shipped position, offset far enough not to
-- sit inside its mesh.  Reading the chest's world position rather than
-- hard-coding one keeps him on the prop even if the snapshot ever moves.
function jediDogScreenPlay:spawnCobak()
	local pChest = getSceneObject(self.chestNodeID)

	if (pChest == nil) then
		print("jediDogScreenPlay: the chest snapshot object was not found; Cobak cannot be placed and som_jedi_dog cannot be finished")
		return
	end

	local x = SceneObject(pChest):getWorldPositionX() + self.cobakOffsetX
	local z = SceneObject(pChest):getWorldPositionZ()
	local y = SceneObject(pChest):getWorldPositionY() + self.cobakOffsetY

	local pCobak = spawnMobile("mustafar", self.cobakTemplate, self.cobakRespawn, x, z, y, 0, 0)

	if (pCobak == nil) then
		print("jediDogScreenPlay: " .. self.cobakTemplate .. " failed to spawn beside the chest; som_jedi_dog cannot be finished")
		return
	end

	CreatureObject(pCobak):setCustomObjectName(self.cobakName)
	self.cobakID = SceneObject(pCobak):getObjectID()
end

-- ====================================================================
-- Player state
--
-- readScreenPlayData returns "" for a key that was never written and
-- tonumber("") is nil, hence "or 0" everywhere.
-- ====================================================================

function jediDogScreenPlay:getNumber(pPlayer, name)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, name)) or 0
end

function jediDogScreenPlay:setNumber(pPlayer, name, value)
	writeScreenPlayData(pPlayer, self.screenplayName, name, tostring(value))
end

function jediDogScreenPlay:getStage(pPlayer)
	return self:getNumber(pPlayer, "stage")
end

function jediDogScreenPlay:setStage(pPlayer, stage)
	self:setNumber(pPlayer, "stage", stage)
end

function jediDogScreenPlay:isActive(pPlayer)
	local stage = self:getStage(pPlayer)

	return stage > 0 and stage ~= self.STAGE_DONE
end

-- No journal row exists, so journalEntryTitle and journalEntryDescription go
-- out as system messages.  No waypoints -- see THERE IS NO COORDINATE ANYWHERE
-- IN THIS .qst.
function jediDogScreenPlay:announce(pPlayer, title, description)
	if (title ~= nil and title ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(title)
	end

	if (description ~= nil and description ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(description)
	end
end

-- The stand-in for task 1's Comm Player window.  hk_history.lua:47-80 is the
-- proof that no ground comm path is reachable from Lua in this server, and
-- hk_history.lua's own showMessageBox is the shape copied here.
function jediDogScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("jediDogScreenPlay", "messageBoxCallback")

	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

function jediDogScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

-- ====================================================================
-- Grant  --  task 0 (Nothing) into task 1 (Comm Player) into task 5
--
-- Called by the datapad radial, and exposed so a giver can call it instead.
-- ====================================================================

function jediDogScreenPlay:grantJediDog(pPlayer, pDatapad)
	if (pPlayer == nil or self:isActive(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, self.STAGE_FIND_COBAK)
	self:setNumber(pPlayer, "collar", 0)
	self:attachKillObserver(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)
	self:announce(pPlayer, self.title, self.description)

	-- task 1: the recording itself.
	self:announce(pPlayer, self.commTitle, self.commDescription)
	self:showMessageBox(pPlayer, pDatapad, self.commTitle, self.commMessageText)

	-- task 5.  No waypoint: createWaypoint is 0 and the task has no coordinate.
	self:announce(pPlayer, self.cobakTitle, self.cobakDescription)

	return true
end

-- ====================================================================
-- task 5 (Destroy Multiple and Loot)  --  the collar
--
-- One persistent observer per player.  The 5th argument to createObserver is
-- the persistence flag; without it the credit stops after a relog.  Cobak is
-- matched by objectID rather than by template so that an ordinary orf_xandank
-- somewhere else on the planet cannot hand over the collar.
-- ====================================================================

function jediDogScreenPlay:attachKillObserver(pPlayer)
	if (self:getNumber(pPlayer, "observer") == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "jediDogScreenPlay", "notifyKilledCreature", pPlayer, 1)
	self:setNumber(pPlayer, "observer", 1)
end

function jediDogScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "jediDogScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function jediDogScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	self:creditCollar(pPlayer, SceneObject(pVictim):getObjectID())

	return 0
end

function jediDogScreenPlay:creditCollar(pPlayer, victimID)
	if (self:getStage(pPlayer) ~= self.STAGE_FIND_COBAK) then
		return
	end

	if (self.cobakID == 0 or victimID ~= self.cobakID) then
		return
	end

	local collars = self:getNumber(pPlayer, "collar")

	if (collars >= self.collarsRequired) then
		return
	end

	-- task 5, LootDropPercent 100.  Kept as a roll anyway so the .qst field is
	-- honoured where it stands rather than compiled away.
	if (getRandomNumber(1, 100) > self.collarDropPercent) then
		return
	end

	collars = collars + 1
	self:setNumber(pPlayer, "collar", collars)

	CreatureObject(pPlayer):sendSystemMessage(self.collarItemName)
	CreatureObject(pPlayer):sendSystemMessage(self.cobakTitle .. " " .. collars .. "/" .. self.collarsRequired)

	if (collars >= self.collarsRequired) then
		self:openChestLeg(pPlayer)
	end
end

function jediDogScreenPlay:openChestLeg(pPlayer)
	self:setStage(pPlayer, self.STAGE_OPEN_CHEST)
	self:detachKillObserver(pPlayer)

	-- task 3's text.  The chest's radial is what fires its signal.
	self:announce(pPlayer, self.chestTitle, self.chestDescription)
end

-- ====================================================================
-- task 3's signal, mustafar_jedi_dog_reward, and task 6, Reward
--
-- Bank Credits 10000 granted literally.  Experience Amount 0 and Faction
-- Amount 0 are honoured literally too: nothing is granted for either.
-- [list] allowRepeats is true, so STAGE_DONE is a record, not a lock.
-- ====================================================================

function jediDogScreenPlay:signalReward(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_OPEN_CHEST) then
		return false
	end

	self:setStage(pPlayer, self.STAGE_DONE)
	-- Quest XP: quest_experience[75][TIER_3]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_jedi_dog")
	self:setNumber(pPlayer, "runs", self:getNumber(pPlayer, "runs") + 1)
	self:detachKillObserver(pPlayer)

	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	-- Written here; the .qst has no line for handing the payout over.
	CreatureObject(pPlayer):sendSystemMessage("The code from Cobak's collar opens the chest. Inside are " .. self.rewardCredits .. " credits and the Jedi's belongings.")

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("jediDogScreenPlay: player has no inventory; the " .. self.rewardName .. " could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		CreatureObject(pPlayer):sendSystemMessage("You have no room for the " .. self.rewardName .. ".")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have received the " .. self.rewardName .. ".")
	end

	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	return true
end

--[[ Radial dispatch

One component table serves the datapad and the chest.  SceneObjectImplementation::
setObjectMenuComponent() falls through to LuaObjectMenuComponent when no C++
component of that name is registered, and LuaObjectMenuComponent replaces the
object's menu entirely -- so fillObjectMenuResponse has to add every item we
want to see, and adds nothing at all when this player has no business touching
the object.

Both radial labels are the .qst's own wording: "A Message from the Past" is
task 1's journalEntryTitle and "Open the Chest" is task 3's.  Neither task
carries a retrieveMenuText, so no player-visible text is invented here.
--]]

JediDogMenuComponent = {}

function jediDogScreenPlay:getRadialText(pPlayer, role)
	if (role == "datapad") then
		-- allowRepeats is true, so a finished player may play it again and
		-- restart the quest; only a run already in progress hides it.
		if (not self:isActive(pPlayer)) then
			return self.commTitle
		end
	elseif (role == "chest") then
		if (self:getStage(pPlayer) == self.STAGE_OPEN_CHEST) then
			return self.chestTitle
		end
	end

	return nil
end

function JediDogMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":jediDogRole")
	local text = jediDogScreenPlay:getRadialText(pPlayer, role)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function JediDogMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local role = readStringData(SceneObject(pSceneObject):getObjectID() .. ":jediDogRole")

	if (role == "datapad") then
		jediDogScreenPlay:grantJediDog(pPlayer, pSceneObject)
	elseif (role == "chest") then
		jediDogScreenPlay:signalReward(pPlayer)
	end

	return 0
end
