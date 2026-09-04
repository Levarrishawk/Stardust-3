--[[
INFO:

The playback is reached two ways, both of them live-sourced. The factory terminal
hands over entry 7 with the datapad (story_arc_chapters.lua:2113), and the datapad
itself lists all ten (HkHistoryDatapadMenuComponent.lua). registerTrigger and the
trigger index remain for a placed-object trigger, and still have no caller, because
nothing in the shipped data says which placed object carries which entry.

The HK-47 history playback -- ten recovered log entries read in sequence. Six are
the Neimoidian facility log (Entry #64951 through #64956, the last one written as
the Trade Federation dies on Mustafar); four are HK-47's own entries once the AI
has taken the factory over (#64957 through #64960, ending on the order that opens
the Mensix Mining Facility attack). Together they are the backstory the SOM story
arc pays off.

SOURCE OF RECORD

Ten one-task quests in the client TREs:

	quest/som_hk_history_one.qst   .. quest/som_hk_history_ten.qst

Every one is a single task of type "Comm Player" carrying a literal
`Comm Message Text` and an `NPC Appearance Server Template`. The prose in the
`entries` table below is quoted from those files -- including their typos, which
are shipped and are left alone:

	one    the quest title says Entry #64951, the message body says #64591
	       (transposed digits). Both files agree; both are reproduced.
	three  "we already striped the ship", "so sort of control override"
	five   opens "Entry: #64955:" with an extra colon, and spells the Viceroy
	       "Gunnary"
	six    "Sideous", "Vadar"

Four more typos were on this list until the string source changed -- three's "a
through study" and "thought patten", nine's "Flaw located" and "Initate". They
are artefacts of the quest/ground copy only. The copy that now renders spells
all four correctly. See the next section.

Cross-checked against the shipped string tables
string/en/quest/ground/som_hk_history_<n>.stf. All four carried fields
(task00_comm_message_text, journal_entry_title, journal_entry_description,
category) are byte-identical to the .qst on all ten entries -- 40 of 40
comparisons, no disagreement.

THERE IS A SECOND SHIPPED COPY, AND IT IS THE ONE USED

That 40-of-40 comparison covered two sources. It missed a third:
string/en/som/som_quest.stf carries the same ten bodies again under
hk_history_message_01 .. _10. It ships in mtg_patch_019.tre, which
conf/config.lua:176 loads.

This file used to hardcode the English bodies as literals, and said it did so
"so the text renders regardless of which client TREs a given install carries."
That reason does not survive checking. The datapad is the only object that
reaches all ten, and HkHistoryDatapadMenuComponent.lua already resolves six
@som/som_quest keys -- :20 the radial, :41-42 the window, :47 the per-entry row
label hk_history_datapad_01..10, :71 and :78 the error. An install missing
som_quest.stf shows raw keys for the radial and for every row in the list, so
the feature is broken before a body is ever rendered. A literal body could not
have rescued it. `message` is therefore the shipped key, matching the sibling
file and the tree's own convention for SUI prompts (corvetteSui.lua:6,
warrenComponents.lua:43). The English is kept inline as a trailing comment, the
way corvetteSui.lua keeps its own.

The som_quest copy also differs from the quest/ground copy in four places, and
in all four it is the correct spelling -- "a thorough study" (not "through"),
"thought patterns" (not "patten"), "Flaws located" (not "Flaw"), "Initiate"
(not "Initate"). Rendering now follows som_quest, so those four typos are gone.
The typos that appear in BOTH copies are genuinely shipped and still render:
entry one's transposed #64591, entry five's "Entry: #64955:" and "Gunnary",
entry six's "Sideous" and "Vadar". The key each string lives under in
string/en/quest/ground/ is still recorded per entry as `stf`.

The `.qst` files carry nothing else this port can act on. Planet is "tatooine"
and the location is 0,0,0 on all ten, which is the editor default for a task that
has no location -- createWaypoint is 0, so there is no waypoint to place.
musicOnActivate / musicOnComplete / musicOnFail are all empty, so no sound is
played here rather than inventing one. showSystemMessages is off on every task
(0 on nine of them, the string "false" on _ten), so the playback emits no system
message of its own.

DELIVERY -- WHY A MESSAGE BOX AND NOT A TALKING HEAD

"Comm Player" in the shipped client is the NPC comm window: the message plus a
portrait built from the task's `NPC Appearance Server Template`. Core3 cannot
reproduce that on the ground, and the search for it is worth recording so nobody
repeats it:

  * The only portrait-carrying comm path in the tree is space-only. It is
    ShipAiAgentImplementation.cpp:2255 `tauntPlayer`, which sends
    StartNpcConversation(player, agentID, 0, "", mobileCRC) at
    ShipAiAgentImplementation.cpp:2224 -- the 5th argument is the portrait
    template CRC. It is bound to Lua at LuaShipAiAgent.h:47 and needs a
    ShipAiAgent, so it cannot be used from a ground screenplay.
  * The ground conversation window is only reached player-initiated, through
    NpcConversationStartCommand.h:88 (`ghost->setConversatingObject(agent)`) and
    AiAgentImplementation.cpp:4122. Neither is exposed to Lua: LuaCreatureObject.h
    has getConversationSession and nothing that starts one, and LuaAiAgent.h has
    no conversation entry point at all. It also needs a real conversable NPC
    standing in the world, which is a placement this port does not have.
  * DirectorManager.cpp:432-561 is the whole list of Lua globals. There is no
    comm-message function in it.

So the entry is delivered with the SUI message box, which is what the rest of
this arc already uses for read-and-dismiss quest prose --
collectors_business.lua:254-265, historian.lua:532-543, hidden_treasure.lua:243-252,
cursed_shard.lua:366-369, reunite_shard.lua:494-499, over SuiMessageBox.lua:1-39.
The box is bound to the object the player is reading from when the caller passes
one, exactly as those five do.

The `NPC Appearance Server Template` is still recorded per entry, so the portrait
can be honoured the day the engine can do it. Both appearances are registered
creatures and spawn: `neimoidian` at mobile/custom_content/som/serverobjects.lua:19
(added with the fix that landed this week -- its header comment at lines 3-18 names
these ten quests as the reason) and `hk47` at the same file line 50.

PROGRESS TRACKING

None of these ten has a row in datatables/player/quests.iff, so there is no
journal entry and no quest id to set. Progress -- which entries this character has
read -- is held in persistent screenplay data, the same as map_exploration.lua.
No quest id is added to managers/quest/quest_manager.lua, because an id with no
table row does nothing.

The quest <list> carries allowRepeats = true on all ten, so a playback is
re-readable; `playEntry` therefore always shows the text and only records the
first read.

HOW THE PLAYBACK IS REACHED. There were never ten placed objects. One exterior
terminal grants one datapad and the datapad holds all ten behind a list -- which is
what string/en/som/som_quest.stf says in its own vocabulary:

	df_terminal_use           Access Factory Memory Banks
	df_terminal_datapad       You downloaded the factory recordings to a datapad.
	hk_history_datapad        Access Record Archives
	hk_history_datapad_01     Entry #64951
	  ..
	hk_history_datapad_10     Entry #64960
	hk_history_datapad_select Invalid Record: Please select a valid entry.

The terminal half is story_arc_chapters.lua (useFactoryTerminal, node 12112268). The
datapad half is HkHistoryDatapadMenuComponent.lua, attached declaratively to
object/tangible/item/som/droid_factory_history_datapad.iff. registerTrigger /
terminalUsed stay for the OBJECTRADIALUSED shape in case a placed object is ever
identified; nothing in the shipped data identifies one, so nothing calls them and
this file still places nothing and invents no coordinate.
--]]

somHkHistoryScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "somHkHistoryScreenPlay",

	-- One row per shipped quest, in reading order. `title` is the quest's
	-- journalEntryTitle, `radialText` its journalEntryDescription, `message` the
	-- task's Comm Message Text, `appearance` the task's NPC Appearance Server
	-- Template, `stf` the key the same string ships under in
	-- string/en/quest/ground/.
	entries = {
		{
			number = 1,
			quest = "som_hk_history_one",
			title = "Access Automated Entry #64951",
			radialText = "Start Playback",
			appearance = "object/mobile/som/neimoidian.iff",
			stf = "@quest/ground/som_hk_history_one:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_01", -- Entry #64591: Today we located a crashed vessel of that appears to be Old Republic in origin. All the ships systems seem to be off line but functional which have our engineers baffled as to the cause of the crash. The only occupant that we were able to find of the ship was a droid of unknown design. Surprisingly, after all this time, the droid seems to be in excellent condition and our engineers are confident that they will be able to reactivate it. Maybe it will have some clues about the origin of the vessel.",
		},
		{
			number = 2,
			quest = "som_hk_history_two",
			title = "Access Automated Entry #64952",
			radialText = "Start Playback",
			appearance = "object/mobile/som/neimoidian.iff",
			stf = "@quest/ground/som_hk_history_two:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_02", -- Entry #64952: What a disaster. Our engineers managed to turn the droid back on and it went on a rampage. It went through several of our engineers, three super battle droids, and even a droideka with incredible ease. Fortunately one of our smarter engineers installed a restraining bolt on it before we turned it back on and we were able to stop it. Viceroy Gunray has been informed of our discovery.",
		},
		{
			number = 3,
			quest = "som_hk_history_three",
			title = "Access Automated Entry #64953",
			radialText = "Start Playback",
			appearance = "object/mobile/som/neimoidian.iff",
			stf = "@quest/ground/som_hk_history_three:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_03", -- Entry #64953: As per Viceroy Gunray's orders, we have made a thorough study of this droid. It is like nothing we have ever seen before, amazing technology for something so old. Due to its incomprehensible thought matrix we were unable to perform a memory wipe. But one of our engineers came up with a solution; we were able to transfer the memory and thought patterns of the droid into a functioning sub-system of the crashed cruiser. Since we already striped the ship of everything of value, we should be safe from that homicidal droid there. On a side note our engineers said that in order to make the transfer they had to remove a sub-routine in the droid's thought pattern...so sort of control override.",
		},
		{
			number = 4,
			quest = "som_hk_history_four",
			title = "Access Automated Entry #64954",
			radialText = "Start Playback",
			appearance = "object/mobile/som/neimoidian.iff",
			stf = "@quest/ground/som_hk_history_four:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_04", -- Entry #64954: Without the knowledge of the local Mustafarians we finished construction of our new factory. Based off of the design of the droid found in the crashed ship, we were able to make a new combat droid of incredible power. The factory is fully stocked and ready to be activated. With these new droids we will be unstoppable. Viceroy Gunray announced that he will be arriving tomorrow. He will have the honor of activating our new factory.",
		},
		{
			number = 5,
			quest = "som_hk_history_five",
			title = "Access Automated Entry #64955",
			radialText = "Start Playback",
			appearance = "object/mobile/som/neimoidian.iff",
			stf = "@quest/ground/som_hk_history_five:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_05", -- Entry: #64955: Viceroy Gunnary arrived today but informed us that the factory will have to remain offline for a while longer. He is awaiting word from Sideous before he can take the next step. The factory remains at the ready and if early estimates of its production capabilities are any indication, we will have a massive army of these new droids shortly after it is turned on. On a side note, the droids AI seems to have melded with the ship and taken over its operational systems. Our engineers have never seen the like before. We have sealed up the ship and disconnected the uplink we set up on the ship for reasons of safety. Once we have a chance we will destroy the ship and that homicidal AI with it.",
		},
		{
			number = 6,
			quest = "som_hk_history_six",
			title = "Access Automated Entry #64956",
			radialText = "Start Playback",
			appearance = "object/mobile/som/neimoidian.iff",
			stf = "@quest/ground/som_hk_history_six:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_06", -- Entry #64956: This will be my last entry. Viceroy Gunray is dead and most of the federation along with him. Sideous' new apprentice killed everyone. I was only able to escape by chance. I have shut down most of the factory's systems and am preparing to go into hiding. I cannot take the risk that Vadar will come looking for me here.",
		},
		{
			number = 7,
			quest = "som_hk_history_seven",
			title = "Access Automated Entry #64957",
			radialText = "Start Playback",
			appearance = "object/mobile/som/hk47.iff",
			stf = "@quest/ground/som_hk_history_seven:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_07", -- Entry #64957: Access port number AG4. Begin factory start up sequence. Prepare automated systems override. Droid cycle process full click. Alter door passcode...37323.",
		},
		{
			number = 8,
			quest = "som_hk_history_eight",
			title = "Access Automated Entry #64958",
			radialText = "Start Playback",
			appearance = "object/mobile/som/hk47.iff",
			stf = "@quest/ground/som_hk_history_eight:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_08", -- Entry #64958: Interesting. The factory has an automated recorder installed into its main frame. Meatbags, seem to take comfort in keeping logs of their activities. I am amused by this behavior.",
		},
		{
			number = 9,
			quest = "som_hk_history_nine",
			title = "Access Automated Entry #64959",
			radialText = "Start Playback",
			appearance = "object/mobile/som/hk47.iff",
			stf = "@quest/ground/som_hk_history_nine:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_09", -- Entry #64959: Flaws located in model HK-57 and model HK-67. Initiate creation sequence for model HK-77, full capacity. Prepare and install humanoid elimination orders.",
		},
		{
			number = 10,
			quest = "som_hk_history_ten",
			title = "Access Automated Entry #64960",
			radialText = "Start Playback",
			appearance = "object/mobile/som/hk47.iff",
			stf = "@quest/ground/som_hk_history_ten:task00_comm_message_text",
			message = "@som/som_quest:hk_history_message_10", -- Entry #64960: Target initiated. Mensix Mining Facility. Limited defensive capabilities. Minimum force required to accomplish primary objective. Primary objective...elimination of meatbags.",
		},
	},

	-- Filled by registerTrigger. In-memory only and rebuilt on every boot, which
	-- is correct: it is derived from placements, and placements are re-made by
	-- start() each time.
	entryByObjectID = {},
}

registerScreenPlay("somHkHistoryScreenPlay", true)

function somHkHistoryScreenPlay:start()
	self.entryByObjectID = {}

	-- This screenplay places nothing, and that is correct rather than pending.
	-- There was never a set of ten consoles to place. The trigger shipped as two
	-- objects, both already wired by story_arc_chapters.lua:
	--
	--   the exterior factory terminal, snapshot/mustafar.ws node 12112268
	--   (529.13, 66.15, 1968.60), plays entry 7 only -- story_arc_chapters.lua
	--   :928-938 claims its radial, :2069 useFactoryTerminal, :2093-2097 calls
	--   playEntry. Entry 7 is the arc's key: :2131-2140 refuses the door passcode
	--   37323 unless hasPlayedEntry(pPlayer, 7).
	--
	--   the droid factory history datapad, granted by that same terminal, plays
	--   all ten -- HkHistoryDatapadMenuComponent.lua:20 radial, :39-51 the list,
	--   :82 calls playEntry. It is bound declaratively in
	--   object/custom_content/tangible/item/som/droid_factory_history_datapad.lua:2.
	--
	-- The ten .qst files carry Planet tatooine / 0,0,0 / createWaypoint 0, so
	-- there is no location to derive and none was withheld. registerTrigger and
	-- terminalUsed below keep no caller on purpose: they are the seam for a third
	-- placed object, and no third object ships.
end

--[[ Lookup ]]

function somHkHistoryScreenPlay:getEntry(number)
	for i = 1, #self.entries do
		if (self.entries[i].number == number) then
			return self.entries[i]
		end
	end

	return nil
end

--[[ Entry points

These are the seams a terminal, a radial or a conversation handler calls. They
are keyed by entry number, 1 to 10, in the reading order the log is written in.

	playEntry(pPlayer, number, pSource)  play entry `number` for this player.
	                                     pSource is optional -- the object being
	                                     read from, used to bind the window.
	getRadialText(pPlayer, number)       the label to hang on a radial.
	registerTrigger(pObject, number)     bind a placed object to an entry and
	                                     start listening for its radial.
	terminalUsed(pObject, pPlayer)       OBJECTRADIALUSED callback for one of
	                                     those objects.
--]]

-- The .qst quest-level journalEntryDescription is "Start Playback" on all ten,
-- which is what the shipped radial said. pPlayer is taken so a caller can gate
-- the label later without changing the seam.
function somHkHistoryScreenPlay:getRadialText(pPlayer, number)
	local entry = self:getEntry(number)

	if (entry == nil) then
		return nil
	end

	return entry.radialText
end

function somHkHistoryScreenPlay:registerTrigger(pObject, number)
	if (pObject == nil) then
		return false
	end

	local entry = self:getEntry(number)

	if (entry == nil) then
		printLuaError("somHkHistoryScreenPlay:registerTrigger, no entry numbered " .. tostring(number) .. ".")
		return false
	end

	self.entryByObjectID[SceneObject(pObject):getObjectID()] = entry.number

	createObserver(OBJECTRADIALUSED, "somHkHistoryScreenPlay", "terminalUsed", pObject)

	return true
end

function somHkHistoryScreenPlay:terminalUsed(pObject, pPlayer)
	if (pObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local number = self.entryByObjectID[SceneObject(pObject):getObjectID()]

	if (number == nil) then
		return 0
	end

	self:playEntry(pPlayer, number, pObject)

	return 0
end

-- Plays one entry. Returns true if the entry exists and was shown.
--
-- The quest <list> carries allowRepeats = true on all ten, so this never refuses
-- a re-read; only the first read is recorded.
function somHkHistoryScreenPlay:playEntry(pPlayer, number, pSource)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	local entry = self:getEntry(number)

	if (entry == nil) then
		printLuaError("somHkHistoryScreenPlay:playEntry, no entry numbered " .. tostring(number) .. ".")
		return false
	end

	self:showMessageBox(pPlayer, pSource, entry.title, entry.message)

	if (not self:hasPlayedEntry(pPlayer, entry.number)) then
		writeScreenPlayData(pPlayer, self.screenplayName, "played_" .. entry.number, "1")
	end

	return true
end

--[[ State

Persistent screenplay data on the player, one key per entry. readScreenPlayData
returns "" for a key that was never written and tonumber("") is nil, hence the
comparison against 1 rather than a truthiness test.

	played_<n>  1 once this character has read entry n
--]]

function somHkHistoryScreenPlay:hasPlayedEntry(pPlayer, number)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "played_" .. number)) == 1
end

function somHkHistoryScreenPlay:getPlayedCount(pPlayer)
	local count = 0

	for i = 1, #self.entries do
		if (self:hasPlayedEntry(pPlayer, self.entries[i].number)) then
			count = count + 1
		end
	end

	return count
end

function somHkHistoryScreenPlay:hasPlayedAll(pPlayer)
	return self:getPlayedCount(pPlayer) == #self.entries
end

--[[ Delivery ]]

function somHkHistoryScreenPlay:showMessageBox(pPlayer, pObject, title, prompt)
	local sui = SuiMessageBox.new("somHkHistoryScreenPlay", "messageBoxCallback")
	sui.setTitle(title)
	sui.setPrompt(prompt)

	if (pObject ~= nil) then
		sui.setTargetNetworkId(SceneObject(pObject):getObjectID())
		sui.setForceCloseDistance(15)
	end

	sui.sendTo(pPlayer)
end

-- A playback is read-and-dismiss; nothing in the .qst branches on the button.
function somHkHistoryScreenPlay:messageBoxCallback(pPlayer, pSui, eventIndex, args)
end
