--[[
Being a good samaritan  --  som_kenobi_samaritan_1 and som_kenobi_samaritan_2

SOURCE OF RECORD

quest/som_kenobi_samaritan_1.qst and quest/som_kenobi_samaritan_2.qst in the client
TREs. The camp location and its radius, the waypoint name, every message box title
and body, every journalEntryDescription, the 60 % loot rate, the 120-360 s timer, the
2-flea encounter at 30-50 m, samaritan_2's 60-420 s timer and its two thugs at 15-30 m
are all quoted from those two files. The conversation tree is
mobile/conversations/mustafar/som_kenobi_pwwoz_pwwa.lua and the handler that routes it
is quest/conversation/pwwoz_pwwa_conv_handler.lua.

THE SHAPE OF THE .QST

Task 0 is the Go to Location. Completing it fires two children at once: task 2's "A
flea in a haystack" box, under which the whole hunt hangs, and task 4's 120-360 s
Timer, whose only child is task 5's Encounter -- two fleas dropped 30-50 m from the
player. That encounter is flavour: it hurries the hunt along, it is not the hunt.

Task 3 is the hunt itself: Destroy Multiple and Loot against Social Group lava_flea,
NumberItemsRequired 1, LootDropPercent 60. Its child task 6 is the "One in a million"
box, and under that the quest forks into the two Wait for Signal tasks that give this
quest its name:

  task 7  keepCrystal  ->  reward, complete, and grantQuestOnComplete som_kenobi_samaritan_2
  task 8  giveCrystal  ->  task 9, Destroy Multiple on Pwwoz himself, then the
                           "Peace" box, the same reward, and complete

Both branches award the same lootName. The choice costs nothing and buys nothing; it
only decides whether the Ithorian lives and sends thugs after the player, or dies.

THE CREATURE NAMES  --  substituted

The two .qst files name four creatures. Three do not exist under those names, and
Unit A built each of them under the name the object templates actually ship:

  som_lava_flea             ->  lava_flea (and lava_flea_smoldering)
  som_kenobi_pwwoz_pwwa     ->  som_pwwoz_pwwa
  som_kenobi_pwwoz_thug_1   ->  som_pwwoz_thug_1
  som_kenobi_pwwoz_thug_2   ->  som_pwwoz_thug_2

Task 3 matches on Social Group lava_flea rather than on a template. Every lava flea in
this tree ships socialGroup = "" -- the field is empty in mobile/custom_content/som/
lava_flea.lua and lava_flea_smoldering.lua -- so a social-group match would never fire
and the hunt would be unwinnable. The match here is by creature template name against
both flea templates instead. That is a deviation, and it is the smallest one that
makes the .qst's own step work: SOE's group and this tree's two templates name the
same animal.

WHERE PWWOZ STANDS  --  live position, recovered

He is a creature template (object/mobile/som/som_pwwoz_pwwa.iff), not a snapshot node,
so his absence from every .ws is expected: in live he was a server-side spawn. An
earlier revision read that as "nothing ships his position" and placed him outdoors on
the Mensix settlement shelf at (-2492, 1660). That was wrong.

The facility's dungeon spawn table is the position. He stands INSIDE the facility, in
entrance_room_02 -- cell 12112224 -- at (-9.7, 10.8, 90.8) facing 86, with a respawn
of 120 seconds. The reasoning that put him outdoors was half right: it identified
Mensix as the place, because Mensix is the planet's only arrival point
(planet_manager.lua:726) and this arc's hub. It then stopped at the settlement instead
of going through the door.

His row carries two more fields worth recording, neither of which this screenplay acts
on. His death script is the generic dungeon death handler, and his ROOM -- the landing
deck, not his own -- carries the script that grants the Obi-Wan prelude. The prelude
grant is a trigger on the room a player walks into, not something Pwwoz hands over.
That belongs to the spine, and it is noted here only so the next reader of this row
does not mistake it for a seam of this quest's.

The outdoor derivation is dropped rather than kept, because unlike jenha_tar_cube's it
was not a method -- it was a guess dressed in measurements. The shelf really is flat
at h 225.0 and the travel point really does sample 100.68; both facts are true and
neither was ever evidence about where SOE put this NPC.

THE CAMP IS IN THE SNAPSHOT

Task 0 points at (-5385, 224, 1744), Radius 50, waypointName "Pwwoz' camp site", and
its box says "This must be where the Ithorian camped." snapshot/mustafar.ws places the
camp there already: nodes 12113279-12113292, 12113316 and 12113479 are a camp tent, a
cot, a lawn chair, a lantern, four spits, a stool, crates, a drum and gas and food
containers, centred about (-5398, 1770) at height 225 -- 27-35 m from the .qst's centre
and inside its radius. So nothing has to be built for the arrival step; the client
already draws what the box describes.

KILLING THE QUEST GIVER, AND WHY HE COMES BACK

Task 9 is a Destroy Multiple whose Target Server Template is Pwwoz himself, and s_226
in his string table is the conversation he has with the player afterwards: "Yes, I'm
still alive, friend. The Mustafarians managed to save me despite the serious
injuries." SOE wrote both, so he has to die and then be back.

He is spawned with a respawn timer, and the give branch possesses the world NPC in
place rather than spawning a copy beside him. AiAgentImplementation::notifyDespawn()
schedules a RespawnCreatureTask on the same object, so the id this screenplay recorded
and his conversation template both survive the fight -- and respawn() calls
reloadTemplate(), which calls loadTemplateData(), which does
setPvpStatusBitmask(npcTemplate->getPvpBitmask()). His template's bitmask is ATTACKABLE
alone. So the AGGRESSIVE bit set on him here is cleared by the engine when he comes
back, without this file having to remember to do it.

That leaves one case the engine does not cover: a player who takes the give branch and
then walks away leaves an aggressive NPC standing at the planet's travel pad forever,
because nothing kills him. So possessing him also schedules calmQuestGiver, which
clears the bit if he is still alive when the window closes.

Coming back re-arms both, but not on sight. This used to say the handler "routes
STAGE_POSSESSED back to s_186", the give screen. Live gives that player a screen of
his own -- s_82, "You will not escape my wrath, %TU!" -- and puts the re-aggro on the
one option under it rather than on the greeting. So he can be hailed and left alone
again, and only picking s_84 restarts the fight. See THE POSSESSED OPENING in the
conversation handler for the root cause.

The cost of possessing the shared NPC instead of a private copy is that he will swing
at bystanders for as long as the fight lasts. That is accepted: the .qst names this
exact template as the kill target, and a second Pwwoz standing next to the first would
be worse.

PROGRESS TRACKING

som_kenobi_samaritan_1 has no row in datatables/player/quests.iff -- the table the
server loads is stardust_03.tre's, whose only Mustafar rows are the 45 exploration
markers -- so there is no journal, in spite of the .qst's journalVisible = true. All
progress lives in persistent screenplay data on the player's ghost, and the
journalEntryDescription lines go out as system messages and as waypoint descriptions
instead, which is where the player would otherwise have read them.

THE LEVEL GATE

The [list] block says Level = 75 and it is enforced, in the conversation handler.

It is enforced for want of anything better, not because the .qst is authoritative. A
[list] level is a client-side display value; the Mustafar quests that are really gated
take their number from the giver's server-side conversation, and those test against 60
rather than 75. Pwwoz's live conversation has since been read: six conditions, none of
them a level test. So his 75 stands unopposed, and that is now checked rather than
inferred from his having no refusal line. The handler carries the full note, along with
the one piece of invented text in this quest and why it exists.

THE REWARD  --  substituted

Both Reward tasks award Bank Credits 0, Experience Amount 0 and lootName
item_tow_buff_crystal_02_01. The stored Experience Amount 0 is real; live still
paid, because the server recomputed from quest_experience (see
mustafar_quest_xp.lua). That is a live server-side static-item name, not an object
template, and nothing in this tree resolves it -- there is no item_tow_buff_crystal path
of any kind. What the name says is a Trials of Obi-Wan buff crystal, and the one buff
crystal this tree ships is object/tangible/dungeon/mustafar/obiwan_finale/
obiwan_finale_buff_crystal_usable.iff. reunite_shard.lua makes the same substitution
for _02_02 and serpent_shard.lua for _02_03, so all three shard quests hand out the
same kind of thing.

It is handed over with giveItem() into the player's inventory, which creates the object
for real -- deliberately not addRewardedSchematic, which fails closed when the path is
not in scripts/managers/crafting/schematics.lua and would silently grant nothing.

To restore the live item later, only rewardCrystal below changes.

SAMARITAN_2

The whole of som_kenobi_samaritan_2.qst is a 60-420 s Timer with two sibling Encounter
tasks under it, one per thug, each with its own Immediately Complete Quest. There is no
kill step, no reward and no journal (journalVisible = false), and its .stf shipped
completely empty -- not one string. It is the consequence of keeping the crystal and
nothing else: some time after the player walks away, two of Pwwoz's thugs turn up.

Both Encounters hang off the one timer, so both thugs arrive together.

WHAT IS NOT MODELLED

Task 3's LootItemName "Pwwoz crystal" is not minted as an item. It is a progress marker
that nothing downstream reads -- the thing the player keeps is the buff crystal, handed
over at the reward -- and an inventory item would have to be taken back off him again on
the give branch. The "One in a million" box is what tells the player he has it.

allowRepeats = true on both files is not modelled: stage stops at done, as it does in
every other quest in this wave.

Task 10 and task 11's Faction Name = Rebel, CountItem/CountWeapon/CountArmor and the
four 0.1 quality floats are the Reward task's unused columns -- the file grants no
faction points, no weapon and no armour. Nothing here reads them.
--]]

samaritanScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "samaritanScreenPlay",

	-- Quoted; see THE LEVEL GATE.
	requiredLevel = 75,

	-- Live position; see WHERE PWWOZ STANDS. Cell-local, inside the facility:
	-- entrance_room_02 = cell 12112224. respawn is the table's own 120, and it
	-- is in seconds -- DirectorManager::spawnMobile passes it to
	-- AiAgent::setRespawnTimer, and notifyDespawn multiplies by 1000 for the
	-- RespawnCreatureTask.
	questGiver = {
		template = "som_pwwoz_pwwa",
		cell = 12112224,
		x = -9.7,
		z = 10.8,
		y = 90.8,
		heading = 86,
		respawn = 120,
	},

	-- Task 0, Go to Location: mustafar (-5385, 224, 1744), Radius 50.
	camp = { x = -5385, y = 1744, radius = 50, waypointName = "Pwwoz' camp site" },

	-- Task 3's Social Group, substituted for the two templates that are it; see
	-- THE CREATURE NAMES.
	fleaTemplates = {
		lava_flea = true,
		lava_flea_smoldering = true,
	},

	-- Task 4's Timer and task 5's Encounter.
	fleaEncounter = {
		template = "lava_flea",
		count = 2,
		minDistance = 30,
		maxDistance = 50,
		delayMin = 120,
		delayMax = 360,
	},

	-- Task 3's LootDropPercent.
	lootDropPercent = 60,

	-- som_kenobi_samaritan_2 in full: tasks 1 and 2 under task 0's timer.
	thugs = {
		templates = { "som_pwwoz_thug_1", "som_pwwoz_thug_2" },
		minDistance = 15,
		maxDistance = 30,
		delayMin = 60,
		delayMax = 420,

		-- Not from the .qst; see spawnThugs.
		maxTries = 12,
	},

	-- Not from the .qst. How long a possessed Pwwoz stays hostile if nobody
	-- finishes him; see KILLING THE QUEST GIVER.
	calmSeconds = 300,

	-- Substituted; see THE REWARD.
	rewardCrystal = "object/tangible/dungeon/mustafar/obiwan_finale/obiwan_finale_buff_crystal_usable.iff",

	STAGE_ACTIVE = 1,
	STAGE_HUNT = 2,
	STAGE_DECIDE = 3,
	STAGE_POSSESSED = 4,
	STAGE_DONE_KEPT = 5,
	STAGE_DONE_KILLED = 6,

	-- What start() actually placed. Neither is snapshot data, so there is no world
	-- id to look either up by; recording the ids is the only way to find them again,
	-- and the only way a boot check can tell a silent failure from a success.
	questGiverID = 0,
	campAreaID = 0,
}

registerScreenPlay("samaritanScreenPlay", true)

function samaritanScreenPlay:start()
	if (isZoneEnabled("mustafar")) then
		self:spawnQuestGiver()
		self:spawnCampArea()
	end
end

function samaritanScreenPlay:spawnQuestGiver()
	local giver = self.questGiver
	-- Cell-local, so no getWorldFloor: giver.z is the entrance room's own floor
	-- and a terrain sample inside a building means nothing.
	local pNpc = spawnMobile("mustafar", giver.template, giver.respawn, giver.x, giver.z, giver.y, giver.heading, giver.cell)

	if (pNpc == nil) then
		print("samaritanScreenPlay: failed to spawn " .. giver.template .. "; the quest cannot be started")
	else
		self.questGiverID = SceneObject(pNpc):getObjectID()
	end
end

-- Task 0. The camp step has no radial and no object to touch, so an active area is
-- the only thing that can complete it.
function samaritanScreenPlay:spawnCampArea()
	local z = getWorldFloor(self.camp.x, self.camp.y, "mustafar")
	local pArea = spawnActiveArea("mustafar", "object/active_area.iff", self.camp.x, z, self.camp.y, self.camp.radius, 0)

	if (pArea == nil) then
		print("samaritanScreenPlay: failed to spawn the camp area; the arrival message box will never fire")
		return
	end

	self.campAreaID = SceneObject(pArea):getObjectID()
	createObserver(ENTEREDAREA, "samaritanScreenPlay", "notifyEnteredCamp", pArea)
end

--[[ State

Persistent screenplay data on the player's ghost, so progress survives a restart.
readScreenPlayData returns "" for a key that was never written and tonumber("") is
nil, hence the "or 0".

	stage    0  not started
	         1  quest active; travelling to the camp
	         2  at the camp; hunting fleas
	         3  crystal in hand; back to Pwwoz to decide
	         4  gave it to him; he is possessed and has to be put down
	         5  kept it; samaritan_2 is running or has run
	         6  gave it and killed him
	arrived  1 once the camp area has fired its box, so it only fires once
	fleas    1 once task 4's timer has dropped its two fleas
	q2       0 samaritan_2 not granted, 1 timer armed, 2 thugs sent or given up on
	q2tries  how many times the ambush has been re-armed off-planet
	wp       waypoint id currently handed out, absent if none
--]]

function samaritanScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function samaritanScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function samaritanScreenPlay:hasFlag(pPlayer, key)
	return (tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0) == 1
end

function samaritanScreenPlay:setFlag(pPlayer, key)
	writeScreenPlayData(pPlayer, self.screenplayName, key, "1")
end

function samaritanScreenPlay:isPresent(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	return pGhost ~= nil and PlayerObject(pGhost):isOnline() and SceneObject(pPlayer):getZoneName() == "mustafar"
end

-- One waypoint at a time: the quest never has two fixed-location objectives open.
-- See PROGRESS TRACKING for why it exists at all.
function samaritanScreenPlay:giveWaypoint(pPlayer, name, description, x, y)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return
	end

	self:removeWaypoint(pPlayer)

	local waypointID = PlayerObject(pGhost):addWaypoint("mustafar", name, description, x, 0, y, WAYPOINT_YELLOW, true, true, WAYPOINTQUESTTASK)
	writeScreenPlayData(pPlayer, self.screenplayName, "wp", tostring(waypointID))
end

function samaritanScreenPlay:removeWaypoint(pPlayer)
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local waypointID = tonumber(readScreenPlayData(pPlayer, self.screenplayName, "wp")) or 0

	if (pGhost ~= nil and waypointID ~= 0) then
		PlayerObject(pGhost):removeWaypoint(waypointID, true)
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "wp")
end

function samaritanScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("samaritanScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

-- The .qst message boxes are read-and-dismiss; nothing branches on the button.
function samaritanScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end

function samaritanScreenPlay:giveReward(pPlayer, template, what)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		print("samaritanScreenPlay: player has no inventory; " .. template .. " could not be handed over")
	elseif (giveItem(pInventory, template, -1, true) == nil) then
		print("samaritanScreenPlay: failed to create " .. template)
		CreatureObject(pPlayer):sendSystemMessage("You have no room for " .. what .. ".")
	else
		CreatureObject(pPlayer):sendSystemMessage("You have taken " .. what .. ".")
	end
end

--[[ The quest ]]

-- Both directions screens in Pwwoz's tree land here; see the conversation handler.
function samaritanScreenPlay:startQuest(pPlayer)
	if (self:getStage(pPlayer) ~= 0) then
		return
	end

	self:setStage(pPlayer, self.STAGE_ACTIVE)

	-- Persistence 1 so the observer object is saved and kill credit survives a
	-- logout. It is removed by returning 1 from the handler, or dropped on the
	-- keep branch, whichever the player takes.
	createObserver(KILLEDCREATURE, "samaritanScreenPlay", "notifyKilledCreature", pPlayer, 1)

	self:giveWaypoint(pPlayer, self.camp.waypointName, "Being a good samaritan", self.camp.x, self.camp.y)

	-- The quest's own journal_entry_description, then task 0's.
	CreatureObject(pPlayer):sendSystemMessage("An Ithorian geologist named Pwwoz Pwwa has asked for your help in retrieving a crystal he lost out in the wild. You suspect that there's something seriously wrong with this Ithorian, but have decided to play along for now.")
	CreatureObject(pPlayer):sendSystemMessage("Pwwoz showed you where he lost the crystal on your map. Travel out there to hunt the lava fleas in the surrounding area and see if you can find it.")

	-- Task 0's musicOnActivate.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_exception.snd")
end

-- Task 0 completing, which fires task 2's box and task 4's timer together.
function samaritanScreenPlay:notifyEnteredCamp(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= self.STAGE_ACTIVE or self:hasFlag(pPlayer, "arrived")) then
		return 0
	end

	self:setFlag(pPlayer, "arrived")
	self:setStage(pPlayer, self.STAGE_HUNT)
	self:removeWaypoint(pPlayer)

	-- Task 2.
	self:showMessageBox(pPlayer, nil, "A flea in a haystack",
		"This must be where the Ithorian camped. Start hunting lava fleas in the area; maybe you will get lucky.")

	-- Task 3's journalEntryDescription, "A flea in a haystack".
	CreatureObject(pPlayer):sendSystemMessage("Hunt the lava fleas around this area and see if you can find the lava flea thief.")

	CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

	-- Task 4's Timer, Min 120 / Max 360.
	if (not self:hasFlag(pPlayer, "fleas")) then
		self:setFlag(pPlayer, "fleas")
		createEvent(getRandomNumber(self.fleaEncounter.delayMin, self.fleaEncounter.delayMax) * 1000, "samaritanScreenPlay", "spawnFleaEncounter", pPlayer, "")
	end

	return 0
end

-- Task 5's Encounter: Count 2, Min Distance 30, Max Distance 50. Flavour -- the hunt
-- itself is task 3, against whatever fleas the world spawner has already put out
-- there. mustafar_regions.lua's world_spawner row carries mustafar_lava_fleas across
-- the whole planet, so the area is never empty.
function samaritanScreenPlay:spawnFleaEncounter(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_HUNT or not self:isPresent(pPlayer)) then
		return
	end

	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()

	for i = 1, self.fleaEncounter.count do
		local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, self.fleaEncounter.minDistance, self.fleaEncounter.maxDistance, true)

		if (spawnPoint == nil) then
			print("samaritanScreenPlay: no spawn point near the player for " .. self.fleaEncounter.template)
		elseif (spawnMobile("mustafar", self.fleaEncounter.template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0) == nil) then
			print("samaritanScreenPlay: failed to spawn " .. self.fleaEncounter.template)
		end
	end
end

--[[ Kill credit

One observer, created when the quest starts. It carries both kill steps: task 3's
fleas and, on the give branch, task 9's Pwwoz. It is removed by returning 1 the moment
either branch closes out -- ScreenPlayObserverImplementation::notifyObserverEvent
treats a non-zero return as "remove observer" -- and dropped explicitly on the keep
branch, which closes out inside a conversation rather than on a kill.
--]]

function samaritanScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	local stage = self:getStage(pPlayer)
	local victim = AiAgent(pVictim):getCreatureTemplateName()

	if (stage == self.STAGE_HUNT) then
		if (not self.fleaTemplates[victim]) then
			return 0
		end

		-- Task 3's LootDropPercent, 60. getRandomNumber(100) is 1-100 inclusive.
		if (getRandomNumber(100) > self.lootDropPercent) then
			return 0
		end

		self:setStage(pPlayer, self.STAGE_DECIDE)

		-- Task 6.
		self:showMessageBox(pPlayer, nil, "One in a million",
			"Lodged between the teeth of one of the fleas, you see a red glimmer. Amazingly enough, Pwwoz was right. His crystal is right there. As you rip it out, you feel overwhelmed by the forces emanating from it. When you look at it, you can swear that you see the shapes of a face twisting and turning inside like it's trying to break out.")

		-- Task 8's journalEntryDescription, "A decision to be made".
		CreatureObject(pPlayer):sendSystemMessage("As you return to Pwwoz, you ponder if you should give him the crystal or not. The powers within it feel so sweet...")

		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")

		self:giveWaypoint(pPlayer, "A decision to be made", "Being a good samaritan", self.questGiver.x, self.questGiver.y)

		return 0
	end

	if (stage == self.STAGE_POSSESSED and victim == self.questGiver.template) then
		self:setStage(pPlayer, self.STAGE_DONE_KILLED)

		-- Task 13.
		self:showMessageBox(pPlayer, nil, "Peace",
			"As you put poor Pwwoz to peace at last, you notice that the smashed crystal pieces are still scattered on the ground. You collect them in a little box, and can feel that the power within them is still there. The taint of the entity that was locked inside is almost gone.")

		-- Task 10's lootName.
		self:giveReward(pPlayer, self.rewardCrystal, "the crystal you took from Pwwoz Pwwa")

		-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
		MustafarQuestXp:award(pPlayer, "som_kenobi_samaritan_1")

		-- Task 14's musicOnComplete.
		CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")
		CreatureObject(pPlayer):sendSystemMessage("You have completed Pwwoz Pwwa's task.")

		-- The quest is over on this branch; take the observer with it.
		return 1
	end

	return 0
end

--[[ The decision ]]

-- Task 8's Signal Name giveCrystal, then task 9. Two screens in Pwwoz's tree land
-- here: give, which hands the crystal over, and enraged_fight, which is the player
-- accepting the fight a second time. Idempotent on purpose -- the second call only
-- re-aggros. See THE POSSESSED OPENING in the conversation handler.
function samaritanScreenPlay:giveCrystal(pPlayer, pNpc)
	if (pPlayer == nil or pNpc == nil) then
		return
	end

	local stage = self:getStage(pPlayer)

	if (stage ~= self.STAGE_DECIDE and stage ~= self.STAGE_POSSESSED) then
		return
	end

	if (stage == self.STAGE_DECIDE) then
		self:setStage(pPlayer, self.STAGE_POSSESSED)
		self:removeWaypoint(pPlayer)

		-- Task 9's journalEntryDescription, "Possessed".
		CreatureObject(pPlayer):sendSystemMessage("Pwwoz has lost control! Some being inside the crystal has taken over him. He's got murder in his eyes! You have no choice but to end his misery.")

		CreatureObject(pPlayer):playMusicMessage("sound/ui_npe2_quest_counter.snd")
	end

	-- He is not AGGRESSIVE, so the fight has to be started for him. The bit is set
	-- as well as the defender or he drops the player the moment he breaks line of
	-- sight and goes back to being a talkable NPC.
	TangibleObject(pNpc):setPvpStatusBit(AGGRESSIVE)
	AiAgent(pNpc):setDefender(pPlayer)

	-- See KILLING THE QUEST GIVER: the engine clears the bit on respawn, this
	-- clears it when nobody finishes him.
	createEvent(self.calmSeconds * 1000, "samaritanScreenPlay", "calmQuestGiver", pNpc, "")
end

function samaritanScreenPlay:calmQuestGiver(pNpc)
	if (pNpc == nil or CreatureObject(pNpc):isDead()) then
		return
	end

	-- Hailing Pwwoz again re-arms this timer, so an earlier arm can land in the middle
	-- of the fight it was meant to clean up after. Leave a live fight alone and come back
	-- for it: a bare return would strand him AGGRESSIVE for good when the player walks
	-- away and the fight ends without anyone finishing him, since only giveCrystal arms
	-- this and respawn only clears the bit if he actually dies.
	if (AiAgent(pNpc):isInCombat()) then
		createEvent(self.calmSeconds * 1000, "samaritanScreenPlay", "calmQuestGiver", pNpc, "")
		return
	end

	TangibleObject(pNpc):clearPvpStatusBit(AGGRESSIVE)
	TangibleObject(pNpc):broadcastPvpStatusBitmask()
	AiAgent(pNpc):clearCombatState(true)
end

-- Task 7's Signal Name keepCrystal, then tasks 11 and 12. The keep screen and s_195
-- both land here; see the conversation handler.
function samaritanScreenPlay:keepCrystal(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= self.STAGE_DECIDE) then
		return
	end

	self:setStage(pPlayer, self.STAGE_DONE_KEPT)
	self:removeWaypoint(pPlayer)

	-- Created persistent, and this branch closes the quest out inside a
	-- conversation rather than on a kill, so there is no return value to remove it
	-- with. An unfired one would sit in the database forever.
	dropObserver(KILLEDCREATURE, "samaritanScreenPlay", "notifyKilledCreature", pPlayer)

	-- Task 7's journalEntryDescription, "Keep the Crystal".
	CreatureObject(pPlayer):sendSystemMessage("You decided to keep the crystal.")

	-- Task 11's lootName.
	self:giveReward(pPlayer, self.rewardCrystal, "the crystal you kept from Pwwoz Pwwa")

	-- Quest XP: quest_experience[75][TIER_4]. See mustafar_quest_xp.lua.
	MustafarQuestXp:award(pPlayer, "som_kenobi_samaritan_1")

	-- Task 12's musicOnComplete.
	CreatureObject(pPlayer):playMusicMessage("sound/mus_mustafar_quest_success.snd")

	-- Task 12's grantQuestOnComplete.
	self:startSamaritan2(pPlayer)
end

--[[ som_kenobi_samaritan_2 ]]

-- Task 0's Timer, Min 60 / Max 420.
function samaritanScreenPlay:startSamaritan2(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "q2")) or 0) ~= 0) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "q2", "1")
	createEvent(getRandomNumber(self.thugs.delayMin, self.thugs.delayMax) * 1000, "samaritanScreenPlay", "spawnThugs", pPlayer, "")
end

-- Tasks 1 and 2, both Encounters under the one timer: Count 1 each, Min Distance 15,
-- Max Distance 30. They are AGGRESSIVE + ATTACKABLE + ENEMY in their own templates,
-- so nothing has to start the fight for them.
function samaritanScreenPlay:spawnThugs(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- The player logged out or left the planet. Pwwoz keeps his grudge and the
	-- ambush is re-armed rather than lost -- but bounded, so a player who never
	-- comes back to Mustafar does not leave an event rescheduling itself forever.
	if (not self:isPresent(pPlayer)) then
		local tries = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "q2tries")) or 0) + 1

		if (tries > self.thugs.maxTries) then
			writeScreenPlayData(pPlayer, self.screenplayName, "q2", "2")
			return
		end

		writeScreenPlayData(pPlayer, self.screenplayName, "q2tries", tostring(tries))
		createEvent(getRandomNumber(self.thugs.delayMin, self.thugs.delayMax) * 1000, "samaritanScreenPlay", "spawnThugs", pPlayer, "")
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "q2", "2")

	local worldX = SceneObject(pPlayer):getWorldPositionX()
	local worldY = SceneObject(pPlayer):getWorldPositionY()

	for i = 1, #self.thugs.templates do
		local template = self.thugs.templates[i]
		local spawnPoint = getSpawnPoint("mustafar", worldX, worldY, self.thugs.minDistance, self.thugs.maxDistance, true)

		if (spawnPoint == nil) then
			print("samaritanScreenPlay: no spawn point near the player for " .. template)
		else
			local pThug = spawnMobile("mustafar", template, 0, spawnPoint[1], spawnPoint[2], spawnPoint[3], getRandomNumber(360) - 180, 0)

			if (pThug == nil) then
				print("samaritanScreenPlay: failed to spawn " .. template)
			else
				AiAgent(pThug):setDefender(pPlayer)
			end
		end
	end
end
