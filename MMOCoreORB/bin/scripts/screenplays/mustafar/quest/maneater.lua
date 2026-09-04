--[[
	The Man-eater  --  som_maneater

	SOURCE OF RECORD
	----------------
	Every title, description, item name, count, drop percent, coordinate, radius,
	distance, signal name, sound and credit figure below is quoted verbatim from
	the shipped quest definition

		quest/som_maneater.qst    (297 lines)

	read as plain XML out of the client TREs.  Provenance comments name the .qst
	task each string came from.  Where a string had to be authored because the
	.qst has no line for it, the comment says so in as many words.

	It is its own screenplay, not part of the lava beetle pair or the jedi dog
	job, because its [list] block has prerequisiteQuests EMPTY, exclusionQuests
	EMPTY, and every grantQuestOnComplete field in the file is "".  Nothing in
	the shipped data links it to any other quest.

	THE TASK TREE, IN THE ORDER THE .qst RUNS IT
	--------------------------------------------
		task 0  Nothing                    musicOnActivate only
		task 6  Destroy Multiple and Loot  mustafar_maneater_one
		                                   Social Group "tulrus", CreatureType "",
		                                   LootItemName "Stomach Contents",
		                                   NumberItemsRequired 10,
		                                   LootDropPercent 100
		task 8  Comm Player                mustafar_maneater_two
		                                   NPC Appearance Server Template
		                                   object/mobile/som/must_foreman_chivos.iff
		task 3  Go to Location             mustafar_maneater_three
		                                   mustafar (-421, 58, 3067), Radius 40,
		                                   createWaypoint true
		task 4  Encounter                  mustafar_maneater_four
		                                   Creature Type som_tulrus_foehorn,
		                                   Count 1, Min Distance 25, Max Distance 50
		task 7  Wait for Signal            mustafar_maneater_five
		                                   Signal Name mustafar_maneater_reward
		task 5  Reward                     Bank Credits 5000, lootCount 1,
		                                   lootName item_tow_trophey_02_02,
		                                   musicOnComplete mus_mustafar_quest_success

	Every task other than task 3 has Planet "tatooine" and LocationX/Y/Z 0.0 --
	the quest editor's untouched defaults on task types that carry no location.
	Only task 3's mustafar coordinate is real.

	(The .qst stores LocationY as the HEIGHT, so LocationX/LocationY/LocationZ
	becomes Core3's x/z/y.  map_exploration.lua:43-81 documents this.)

	THE CREATURE DOES NOT SHIP -- SUBSTITUTED, AND FLAGGED
	------------------------------------------------------
	Task 4's Creature Type is "som_tulrus_foehorn".  It does not exist: a scoped
	grep over every .lua in this repo returns zero hits, and a binary-safe grep
	over all of C:\swg-extract\_som returns hits only inside this .qst itself.
	There is no mobile/custom_content/som template for it, so it cannot be spawned.

	It is substituted with mobile/custom_content/som/tulrus_magma_drenched (level
	70, registered at som/serverobjects.lua:175), renamed with
	setCustomObjectName("Foehorn").  That is the heaviest-flavoured shipped tulrus
	variant and task 4 calls the target "A huge and furious tulrus", but the pick
	is MINE, not a finding, and this comment is where it is recorded rather than
	deferred: som_tulrus_foehorn exists nowhere but its own .qst, so no further
	reading can settle what it looked like.

	SOCIAL GROUP IS NOT USABLE -- TEMPLATES ENUMERATED INSTEAD
	----------------------------------------------------------
	Task 6 names no CreatureType at all; it selects its targets with Social Group
	"tulrus".  That cannot be honoured here, because every ported SOM creature in
	mobile/custom_content/som carries socialGroup "townsperson" or "", so a social
	group test would match the whole planet.

	The tulrus roster is enumerated instead, and the set used is exactly the one
	this tree has already settled on twice for the same social group --
	bounty_hunts.lua:258 and map_exploration.lua:196 both use

		tulrus, tulrus_magma_drenched, orf_tulrus

	and both deliberately leave out som_kenobi_reunite_tulrus, which is a
	scripted unique owned by reunite_shard.lua:223.  This file follows that
	precedent unchanged rather than inventing a fourth reading of it.

	Foehorn is spawned from tulrus_magma_drenched, which is inside that set, so
	killing him also drops a stomach content if the collect leg is somehow still
	open.  That is correct: he is a tulrus.

	THE COMM PLAYER TASK -- SENT AS A MESSAGE BOX, PORTRAIT NOT HONOURED
	--------------------------------------------------------------------
	Task 8 is a "Comm Player" task: a full-screen NPC comm window with a talking
	head built from "NPC Appearance Server Template =
	object/mobile/som/must_foreman_chivos.iff".  There is no Lua-reachable ground
	comm path in this server -- hk_history.lua:47-80 walks the C++ and shows why
	-- so the shipped Comm Message Text goes out in a SuiMessageBox titled with
	task 8's own journalEntryTitle, exactly as hk_history.lua does for the same
	task type.  The talking head is lost.  Nothing else about the task changes.

	Worth recording because it is a shipped inconsistency and not a porting
	choice: the message is FROM "Chief Glost" in every string, but the portrait
	template is Foreman Chivos.  Both spellings are reproduced as shipped.  The
	[list] block also credits the "Mensix Mining Company" while task 6 credits
	the "Mustafar Mining Company"; both are reproduced as shipped too.

	THE GIVER -- CHIEF ULON GLOST, AND THE CORRECTION THAT FOUND HIM
	----------------------------------------------------------------
	An earlier revision of this header said Chief Glost "DOES NOT EXIST
	ANYWHERE" -- no template, no conversation table, no string row, no snapshot
	node -- and this screenplay was written to drive the whole quest itself with
	no giver.  That was WRONG, and the reason it was wrong matters more than the
	fact: the search that produced it covered the client TREs and this repo only.
	It never covered SOE's own server scripts.  Every one of the four "does not
	exist" claims falls the moment they are searched.

	What live actually has:

	  * A conversation script, conversation/maneater_ulon, which renames the mob
	    it is attached to "Chief Ulon Glost" -- the full name the .qst clips to
	    "Chief Glost".  It is the giver AND the turn-in, and it is ported node
	    for node in mobile/conversations/mustafar/maneater_ulon.lua.
	  * A shipped string table, string/en/conversation/maneater_ulon.stf,
	    15 rows.  It has been in the TREs the whole time.
	  * A spawn row in the Mensix Mining Facility's live spawn table: room
	    entrance_room_01, -9.5 / 10.8 / 52.6, heading 90, script column
	    conversation.maneater_ulon.  That is cell 12112222.
	    mensix_mining_facility_main.lua stands him up there.
	  * The four conditions the conversation dispatches on are this quest's own
	    tasks: mustafar_maneater_four (the Encounter) and mustafar_maneater_five
	    (the Wait for Signal), plus quest-active and quest-completed.

	He is a distinct NPC from must_foreman_chivos.  The .qst borrowing Chivos's
	template for task 8's comm portrait is a shipped inconsistency and stays
	recorded as one above; it is not evidence about who the giver is.

	The appearance is still a repo choice -- no chief_glost model ships and the
	spawn table carries no appearance column.  mobile/custom_content/som/
	chief_glost.lua says so in as many words.

	THE RETURN LEG -- DEVIATION RETIRED
	-----------------------------------
	Task 7 is a Wait for Signal on "mustafar_maneater_reward" and carries no
	location, so while there was no giver, killing Foehorn had to fire the signal
	itself or strand the player at a stage nothing could clear.  That deviation
	is gone.  The signal now fires exactly where live fires it: in the
	conversation, when the player walks back up to Chief Glost with task five
	live.  notifyFoehornKilled sets STAGE_RETURN and stops there.

	The three entry points the conversation handler calls:

		maneaterScreenPlay:grantManeater(pPlayer)     s_26, the grant
		maneaterScreenPlay:regrantManeater(pPlayer)   s_17, the lost-it retry
		maneaterScreenPlay:signalReward(pPlayer)      s_6,  the turn-in

	NO JOURNAL / PROGRESS TRACKING
	------------------------------
	som_maneater has no row in datatables/player/quests.iff.  The table the
	server loads is the one in stardust_03.tre, which wins the TreFiles order in
	conf/config.lua; it holds 307 rows whose only Mustafar entries are the 45
	exploration markers.  Adding a row would mean authoring a TRE, so nothing is
	added to managers/quest/quest_manager.lua and progress lives in persistent
	screenplay data instead: journalEntryTitle goes out as a system message and a
	waypoint name, journalEntryDescription as a system message and a waypoint
	description.

	THE REWARD -- CREDITS LITERAL, LOOT SUBSTITUTED
	-----------------------------------------------
	Task 5 pays Bank Credits 5000 and lootCount 1 of lootName
	item_tow_trophey_02_02.  Note that the [list] block's own Bank Credits field
	is 0 and its lootName is empty; the payout lives on the Reward task, and that
	is the one honoured.  Experience Amount 0 / quest_combat and Faction Amount 0
	/ Rebel are honoured literally: no XP, no faction.  The stored Experience
	Amount 0 is real; live still paid, because the server recomputed from
	quest_experience (see mustafar_quest_xp.lua).

	The 5000 credits are granted literally.  The loot stays a SUBSTITUTE.
	item_tow_trophey_02_02 resolves to "Mounted Tulrus Spine" in
	string/en/static_item_n.stf, but an exhaustive sweep of every shipped
	shared_*.iff finds no object template carrying that objectName, so granting
	the live item would mean authoring an object.

	What is granted instead is trophey_tulrus_spine.iff (registered at
	serverobjects.lua:49) -- a tulrus trophy for the man-eating tulrus, and the
	obvious thematic match from object/tangible/loot/mustafar/.  That substitute
	has the opposite defect: its shared template's objectName record carries an
	empty string table and the key trophey_tulrus_spine_n, which appears in no
	shipped STF (som_item.stf ships and does not contain it).  So the wanted item
	has a display name but no object, and the substitute has an object but no
	resolvable display name.  It is a SUBSTITUTE -- OPEN.

	lava_beetle_nests.lua resolved the sibling item_tow_trophey_02_01 to
	trophey_lava_beetle.iff by objectName; the two grants do not collide.

	REPEATS
	-------
	[list] allowRepeats = true, so STAGE_DONE is a record and not a lock:
	grantManeater resets from it and bumps a run counter.

	WHAT IS NOT MODELLED
	--------------------
	  * "Stomach Contents" is a counter, not a minted inventory item.  No such
	    server template ships and inventing one is content authoring nobody asked
	    for.  This is the same call trophy_hunts.lua:200-202 made for its four
	    progress markers.  OPEN.
	  * Task 6's "You'll find some in the isle due east" points at Tulrus Isle,
	    which the [list] also names.  The .qst attaches no coordinate, no radius
	    and no waypoint to task 6 (createWaypoint is 0 and its Planet is the
	    editor default "tatooine"), so no waypoint is set for the collect leg and
	    tulrus killed anywhere on Mustafar count.  Restricting it to the isle
	    would mean inventing a boundary the .qst does not give.
	  * The Reward task's CountItem / CountWeapon / CountArmor fields are all 1
	    with empty Item / lootName2 / exclusivelootName slots, and are unused.
	  * "Level 70", "Type solo" and "Tier 4" are recorded on the table but not
	    enforced.  That is live's behaviour, not an omission: conversation/
	    maneater_ulon has four dispatch conditions and none of them is a level
	    test.  Chief Glost hands the job to anyone who asks.  (Contrast the
	    Kenobi givers, which DO carry an explicit getLevel test.)
	  * The double space in task 6's shipped description ("only way to be
	    certain.  You'll find some") is reproduced as shipped.
--]]

maneaterScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "maneaterScreenPlay",

	-- task 0, Nothing: musicOnActivate.  task 5, Reward: musicOnComplete.
	musicOnActivate = "sound/mus_mustafar_quest_exception.snd",
	musicOnComplete = "sound/mus_mustafar_quest_success.snd",
	-- Not from the .qst.  Counter ticks have no shipped sound; this is the one
	-- map_exploration.lua:412 uses for its own hunt ticks.
	musicOnCount = "sound/ui_npe2_quest_counter.snd",

	STAGE_STOMACHS = 1,
	STAGE_TRAVEL = 2,
	STAGE_HUNT = 3,
	STAGE_RETURN = 4,
	STAGE_DONE = 5,

	-- [list]
	title = "The Man-eater",
	description = "The miners have been having problems with a man-eating tulrus in the area. It has attacked and killed eight of the miners who have been out on survey missions in the area near Tulrus Isle. The Mensix Mining Company wants to ensure the safety of its employees, and has hired you to kill this man-eating beast.",
	questLevel = 70,
	questTier = 4,

	-- task 6, Destroy Multiple and Loot (mustafar_maneater_one)
	stomachTitle = "Collect the Contents of Tulrus' Stomachs",
	stomachDescription = "The Mustafar Mining Company has no idea which tulrus is killing their men, but they will not take any chances. They want you to collect the contents of the stomachs of several tulrus to see if you can find the beast responsible. It is grisly work, but it is the only way to be certain.  You'll find some in the isle due east.",
	stomachItemName = "Stomach Contents",
	stomachsRequired = 10,
	stomachDropPercent = 100,
	-- .qst "Social Group = tulrus" is unusable here; enumerated per
	-- bounty_hunts.lua:258 and map_exploration.lua:196.  See the header.
	tulrusTemplates = {
		["tulrus"] = true,
		["tulrus_magma_drenched"] = true,
		["orf_tulrus"] = true,
	},

	-- task 8, Comm Player (mustafar_maneater_two).  The portrait template is
	-- object/mobile/som/must_foreman_chivos.iff and cannot be honoured -- header.
	commTitle = "Message from Chief Glost",
	commDescription = "Chief Glost has contacted you with an urgent message.",
	commMessageText = "This is urgent. We just received words that the Tulrus has struck again. Fortunately the attack wasn't fatal and it took place not far from where you are now. Maybe the Tulrus responsible is still in the area and if you hurry you will be able to destroy it.",

	-- task 3, Go to Location (mustafar_maneater_three).
	-- Planet mustafar, LocationX -421, LocationY 58 (height), LocationZ 3067,
	-- Radius(m) 40, createWaypoint true.
	attackX = -421,
	attackZ = 58,
	attackY = 3067,
	attackRadius = 40,
	attackWaypointName = "Most Recent Attack Location",
	travelTitle = "Travel to Area of Most Recent Attack",
	travelDescription = "The most recent attack was just a brief time ago. Hurry to that location to see if this man-eating tulrus is still in the area.",

	-- task 4, Encounter (mustafar_maneater_four).  Creature Type
	-- som_tulrus_foehorn, Count 1, Min Distance 25, Max Distance 50.
	-- Template SUBSTITUTED -- see the header.
	huntTitle = "Destroy Foehorn",
	huntDescription = "A huge and furious tulrus was prowling the area of the most recent attack. This is obviously the man-eater, and must be destroyed before it can get away.",
	foehornTemplate = "tulrus_magma_drenched",
	foehornName = "Foehorn",
	foehornCount = 1,
	foehornMinDistance = 25,
	foehornMaxDistance = 50,

	-- task 7, Wait for Signal (mustafar_maneater_five).
	-- Signal Name mustafar_maneater_reward.  No giver ships -- header.
	returnTitle = "Return to Chief Glost",
	returnDescription = "Return to Chief Glost and report your success in killing the man-eating tulrus.",

	-- task 5, Reward.  Bank Credits 5000, lootCount 1, lootName
	-- item_tow_trophey_02_02 (SUBSTITUTED -- header).
	rewardCredits = 5000,
	rewardItem = "object/tangible/loot/mustafar/trophey_tulrus_spine.iff",
	rewardName = "Tulrus Spine Trophy",

	attackAreaID = 0,
}

registerScreenPlay("maneaterScreenPlay", true)

-- ====================================================================
-- World setup
--
-- DirectorManager::startScreenPlay calls this by name on every screenplay
-- registered with true, so everything here runs once per server start.
--
-- The only thing placed is task 3's Radius 40 trigger.  Foehorn is not stood
-- up in the world: task 4 is an Encounter with Min/Max Distance, which is a
-- ring around the PLAYER, so he is spawned per run when the player arrives.
-- ====================================================================

function maneaterScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnAttackArea()
	end
end

function maneaterScreenPlay:spawnAttackArea()
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.attackX, self.attackZ, self.attackY, self.attackRadius, 0)

	if (pArea == nil) then
		print("maneaterScreenPlay: the attack-site active area failed to spawn; som_maneater cannot be finished")
		return
	end

	self.attackAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "maneaterScreenPlay", "notifyEnteredAttackSite", pArea)
end

-- ====================================================================
-- Player state
--
-- readScreenPlayData returns "" for a key that was never written and
-- tonumber("") is nil, hence "or 0" everywhere.
-- ====================================================================

function maneaterScreenPlay:getNumber(pPlayer, name)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, name)) or 0
end

function maneaterScreenPlay:setNumber(pPlayer, name, value)
	writeScreenPlayData(pPlayer, self.screenplayName, name, tostring(value))
end

function maneaterScreenPlay:getStage(pPlayer)
	return self:getNumber(pPlayer, "stage")
end

function maneaterScreenPlay:setStage(pPlayer, stage)
	self:setNumber(pPlayer, "stage", stage)
end

function maneaterScreenPlay:isActive(pPlayer)
	local stage = self:getStage(pPlayer)

	return stage > 0 and stage ~= self.STAGE_DONE
end

-- ====================================================================
-- Waypoints and messaging
--
-- No journal row exists, so journalEntryTitle goes out as a system message and
-- a waypoint name, journalEntryDescription as a system message and a waypoint
-- description.
-- ====================================================================

function maneaterScreenPlay:clearWaypoint(pPlayer)
	local waypointID = self:getNumber(pPlayer, "wp")

	if (waypointID == 0) then
		return
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost ~= nil) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

function maneaterScreenPlay:setWaypoint(pPlayer, name, description, x, y)
	self:clearWaypoint(pPlayer)

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)

	self:setNumber(pPlayer, "wp", waypointID)
end

function maneaterScreenPlay:announce(pPlayer, title, description)
	if (title ~= nil and title ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(title)
	end

	if (description ~= nil and description ~= "") then
		CreatureObject(pPlayer):sendSystemMessage(description)
	end
end

-- The stand-in for task 8's Comm Player window.  hk_history.lua:47-80 is the
-- proof that no ground comm path is reachable from Lua in this server, and
-- hk_history.lua's own showMessageBox is the shape copied here.
function maneaterScreenPlay:showMessageBox(pPlayer, title, prompt)
	local sui = SuiMessageBox.new("maneaterScreenPlay", "messageBoxCallback")

	sui.setTitle(title)
	sui.setPrompt(prompt)
	sui.sendTo(pPlayer)
end

function maneaterScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

-- ====================================================================
-- Grant  --  task 0 (Nothing) into task 6 (Destroy Multiple and Loot)
--
-- Called from maneater_ulon_conv_handler on screen "accept" (s_26), which is
-- where SOE's conversation calls startMission.
-- ====================================================================

function maneaterScreenPlay:grantManeater(pPlayer)
	if (pPlayer == nil or self:isActive(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, self.STAGE_STOMACHS)
	self:setNumber(pPlayer, "stomachs", 0)
	deleteScreenPlayData(pPlayer, self.screenplayName, "foehorn")
	self:attachKillObserver(pPlayer)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnActivate)
	self:announce(pPlayer, self.title, self.description)
	self:announce(pPlayer, self.stomachTitle, self.stomachDescription)

	-- task 6 has createWaypoint 0 and no coordinate; see WHAT IS NOT MODELLED.

	return true
end

-- ====================================================================
-- Retry  --  the "I had it and I lost it" path
--
-- SOE's branch 3 on s_15 calls clearMission then startMission, both on
-- som_maneater.  It is offered only while the Encounter task is live, which is
-- STAGE_HUNT: Foehorn was spawned and got away.  clearQuest wipes the task
-- tree, grantQuest lays it down again from the top, so the whole hunt reruns.
--
-- grantManeater refuses while isActive, so the clear has to happen first.  It
-- also has to take down the live Foehorn's back-link, or a stale entry sits in
-- the non-persistent store pointing this player at a mob that no longer counts.
-- ====================================================================

function maneaterScreenPlay:regrantManeater(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local foehornID = self:getNumber(pPlayer, "foehorn")

	if (foehornID ~= 0) then
		deleteData(foehornID .. ":maneaterPlayer")
		deleteScreenPlayData(pPlayer, self.screenplayName, "foehorn")
	end

	self:clearWaypoint(pPlayer)
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 0)

	return self:grantManeater(pPlayer)
end

-- ====================================================================
-- Kill observer
--
-- One persistent observer per player.  The 5th argument to createObserver is
-- the persistence flag; without it the counts stop after a relog.  Only the
-- stomach-content leg needs it -- Foehorn is watched by his own
-- OBJECTDESTRUCTION observer, because he is spawned by this file and can be
-- matched by objectID rather than by template.
-- ====================================================================

function maneaterScreenPlay:attachKillObserver(pPlayer)
	if (self:getNumber(pPlayer, "observer") == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "maneaterScreenPlay", "notifyKilledCreature", pPlayer, 1)
	self:setNumber(pPlayer, "observer", 1)
end

function maneaterScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "maneaterScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function maneaterScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	self:creditStomachContents(pPlayer, AiAgent(pVictim):getCreatureTemplateName())

	return 0
end

function maneaterScreenPlay:creditStomachContents(pPlayer, victimTemplate)
	if (self:getStage(pPlayer) ~= self.STAGE_STOMACHS) then
		return
	end

	if (self.tulrusTemplates[victimTemplate] ~= true) then
		return
	end

	local stomachs = self:getNumber(pPlayer, "stomachs")

	if (stomachs >= self.stomachsRequired) then
		return
	end

	-- task 6, LootDropPercent 100.  Kept as a roll anyway so the .qst field is
	-- honoured where it stands rather than compiled away.
	if (getRandomNumber(1, 100) > self.stomachDropPercent) then
		return
	end

	stomachs = stomachs + 1
	self:setNumber(pPlayer, "stomachs", stomachs)

	CreatureObject(pPlayer):playMusicMessage(self.musicOnCount)
	CreatureObject(pPlayer):sendSystemMessage(self.stomachItemName .. " " .. stomachs .. "/" .. self.stomachsRequired)

	if (stomachs >= self.stomachsRequired) then
		self:sendGlostComm(pPlayer)
	end
end

-- ====================================================================
-- task 8 (Comm Player) into task 3 (Go to Location)
-- ====================================================================

function maneaterScreenPlay:sendGlostComm(pPlayer)
	self:setStage(pPlayer, self.STAGE_TRAVEL)
	self:detachKillObserver(pPlayer)

	self:announce(pPlayer, self.commTitle, self.commDescription)
	self:showMessageBox(pPlayer, self.commTitle, self.commMessageText)

	self:announce(pPlayer, self.travelTitle, self.travelDescription)
	-- task 3, createWaypoint true, waypointName "Most Recent Attack Location"
	self:setWaypoint(pPlayer, self.attackWaypointName, self.travelDescription, self.attackX, self.attackY)
end

-- ====================================================================
-- task 4 (Encounter)  --  Foehorn
-- ====================================================================

function maneaterScreenPlay:notifyEnteredAttackSite(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local stage = self:getStage(pPlayer)

	if (stage == self.STAGE_TRAVEL) then
		self:arriveAtAttackSite(pPlayer)
	elseif (stage == self.STAGE_HUNT) then
		-- A restart takes spawned mobs with it.  Walking back into the site is
		-- what puts Foehorn back; nothing in the .qst covers this, it exists so
		-- a restart cannot strand the leg.
		self:refreshFoehorn(pPlayer)
	end

	return 0
end

function maneaterScreenPlay:arriveAtAttackSite(pPlayer)
	self:clearWaypoint(pPlayer)
	self:setStage(pPlayer, self.STAGE_HUNT)

	self:announce(pPlayer, self.huntTitle, self.huntDescription)
	self:spawnFoehorn(pPlayer)
end

function maneaterScreenPlay:refreshFoehorn(pPlayer)
	local foehornID = self:getNumber(pPlayer, "foehorn")

	if (foehornID ~= 0 and getSceneObject(foehornID) ~= nil) then
		return
	end

	self:announce(pPlayer, self.huntTitle, self.huntDescription)
	self:spawnFoehorn(pPlayer)
end

-- Encounter Min/Max Distance is a ring around the PLAYER, which is what
-- getSpawnPoint's last two arguments are.  hidden_treasure.lua:356-385 is the
-- same idiom.  respawnTimer 0 is deliberate: AiAgentImplementation.cpp:2283
-- only schedules a RespawnCreatureTask when the timer is above zero, so Foehorn
-- is a one-shot quest mob and does not keep coming back at the attack site.
function maneaterScreenPlay:spawnFoehorn(pPlayer)
	local spawnPoint = getSpawnPoint("mustafar", SceneObject(pPlayer):getWorldPositionX(), SceneObject(pPlayer):getWorldPositionY(), self.foehornMinDistance, self.foehornMaxDistance, true)

	if (spawnPoint == nil) then
		print("maneaterScreenPlay: no spawn point near the attack site for " .. self.foehornTemplate)
		-- Do not strand the player at a stage with nothing to kill.
		self:setStage(pPlayer, self.STAGE_TRAVEL)
		self:setWaypoint(pPlayer, self.attackWaypointName, self.travelDescription, self.attackX, self.attackY)
		return
	end

	local pFoehorn = spawnMobile("mustafar", self.foehornTemplate, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], 0, 0)

	if (pFoehorn == nil) then
		print("maneaterScreenPlay: failed to spawn " .. self.foehornTemplate)
		self:setStage(pPlayer, self.STAGE_TRAVEL)
		self:setWaypoint(pPlayer, self.attackWaypointName, self.travelDescription, self.attackX, self.attackY)
		return
	end

	local foehornID = SceneObject(pFoehorn):getObjectID()

	CreatureObject(pFoehorn):setCustomObjectName(self.foehornName)

	-- Spawned mobs do not survive a restart, so this bookkeeping is deliberately
	-- in the non-persistent store; the player's stage is what persists.
	writeData(foehornID .. ":maneaterPlayer", SceneObject(pPlayer):getObjectID())

	-- The reverse link, on the player, is what lets refreshFoehorn tell "still
	-- up" from "went away with the process".
	self:setNumber(pPlayer, "foehorn", foehornID)

	createObserver(OBJECTDESTRUCTION, "maneaterScreenPlay", "notifyFoehornKilled", pFoehorn)
	AiAgent(pFoehorn):setDefender(pPlayer)
end

-- Returns 1 on every path so the observer is dropped with the object;
-- hidden_treasure.lua:389-417 is the same shape.
--
-- The kill closes task 4 and opens task 7, and stops there.  The signal is
-- Chief Glost's to fire, in the conversation -- see THE RETURN LEG above.
function maneaterScreenPlay:notifyFoehornKilled(pFoehorn, pKiller)
	if (pFoehorn == nil) then
		return 1
	end

	local foehornID = SceneObject(pFoehorn):getObjectID()
	local ownerID = readData(foehornID .. ":maneaterPlayer")
	local pPlayer = getSceneObject(ownerID)

	deleteData(foehornID .. ":maneaterPlayer")

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 1
	end

	if (self:getStage(pPlayer) ~= self.STAGE_HUNT) then
		return 1
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "foehorn")

	self:setStage(pPlayer, self.STAGE_RETURN)
	-- task 4, Count 1: one kill closes the Encounter.
	CreatureObject(pPlayer):sendSystemMessage(self.huntTitle .. " 1/" .. self.foehornCount)
	self:announce(pPlayer, self.returnTitle, self.returnDescription)

	-- task 7 opens here and waits.  Chief Glost fires the signal, in his
	-- conversation, exactly as live does.  No waypoint is set for the return:
	-- task 7 is a Wait for Signal and carries no location, and the attack-site
	-- waypoint was already cleared on arrival (notifyEnteredAttackSite).  Live
	-- pointed nowhere either -- returnDescription names him and that is all
	-- the .qst gives.

	return 1
end

-- ====================================================================
-- task 5, Reward
--
-- Bank Credits 5000 granted literally.  Experience Amount 0 and Faction Amount
-- 0 are honoured literally too: nothing is granted for either.  [list]
-- allowRepeats is true, so STAGE_DONE is a record, not a lock.
-- ====================================================================

function maneaterScreenPlay:signalReward(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_RETURN) then
		return false
	end

	self:clearWaypoint(pPlayer)
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, self.STAGE_DONE)
	-- Quest XP: quest_experience[70][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_maneater")
	self:setNumber(pPlayer, "runs", self:getNumber(pPlayer, "runs") + 1)

	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	-- Written here; the .qst has no line for handing the payout over.
	CreatureObject(pPlayer):sendSystemMessage("You have been paid " .. self.rewardCredits .. " credits for killing the man-eating tulrus.")

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("maneaterScreenPlay: player has no inventory; " .. self.rewardName .. " could not be handed over")
	elseif (giveItem(pInventory, self.rewardItem, -1, true) == nil) then
		CreatureObject(pPlayer):sendSystemMessage("You have no room for the " .. self.rewardName .. ".")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have received the " .. self.rewardName .. ".")
	end

	CreatureObject(pPlayer):playMusicMessage(self.musicOnComplete)

	return true
end
