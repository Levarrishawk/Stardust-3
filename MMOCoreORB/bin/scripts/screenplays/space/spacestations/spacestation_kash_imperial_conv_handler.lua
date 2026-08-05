local Logger = require("utils.logger")
require("utils.helpers")

SpacestationKashImperialConvoHandler = conv_handler:new {}

-- The base commander tracks how far the pilot has come with the Empire here.
-- The stage is stored per player and drives which shipped greeting is used.
SPACESTATION_KASH_IMPERIAL_STAGES = {
	[0] = "spacestation_kash_imperial_greeting",
	[1] = "spacestation_kash_imperial_greeting_hero", -- Ghrag plot against the station broken
	[2] = "spacestation_kash_imperial_greeting_escort_active", -- transport escort favor underway
	[3] = "spacestation_kash_imperial_greeting_escort_failed", -- transport escort botched
	[4] = "spacestation_kash_imperial_greeting_award", -- hologram award waiting
	[5] = "spacestation_kash_imperial_greeting_corvette_active", -- Gaaltura V intercept underway
	[6] = "spacestation_kash_imperial_greeting_corvette_failed", -- operative lost the Corvette
	[7] = "spacestation_kash_imperial_greeting_tie", -- Corvette taken, chassis waiting
}

SPACESTATION_KASH_IMPERIAL_STAGE_KEY = ":spacestation_kash_imperial:stage"
-- Set when the commander's escort favour is handed out, cleared once he has reacted to the result.
SPACESTATION_KASH_IMPERIAL_ESCORT_KEY = ":spacestation_kash_imperial:escort"
-- Set once the Imperial Command award has actually been transferred (s_393).
SPACESTATION_KASH_IMPERIAL_AWARD_KEY = ":spacestation_kash_imperial:award"
-- Set when the Gaaltura V job is handed out, so a never-taken job is not read as a failed one.
SPACESTATION_KASH_IMPERIAL_CORVETTE_KEY = ":spacestation_kash_imperial:corvette"
-- Set once the commander has settled the Gaaltura V job, so stage 7 is not offered forever.
SPACESTATION_KASH_IMPERIAL_TIE_KEY = ":spacestation_kash_imperial:tie"
-- Set once the pilot has taken the commander up on the hero branch, so the one-off speech
-- (s_292 -> s_296 -> s_300 -> s_304) is not replayed at every hail afterwards.
SPACESTATION_KASH_IMPERIAL_HERO_KEY = ":spacestation_kash_imperial:hero"

-- The quest the commander means by each branch of the shipped conversation.
SPACESTATION_KASH_IMPERIAL_DESTROY_DUTY = {type = "destroy_duty", name = "ep3_kash_station_destroy_duty_imperial"}
SPACESTATION_KASH_IMPERIAL_ESCORT_DUTY = {type = "escort_duty", name = "ep3_kash_station_escort_duty_imperial"}
SPACESTATION_KASH_IMPERIAL_ESCORT = {type = "escort", name = "ep3_kash_station_imperial_escort_alpha"}
SPACESTATION_KASH_IMPERIAL_CORVETTE = {type = "recovery", name = "ep3_red_tie_recovery"}

function SpacestationKashImperialConvoHandler:getStage(pPlayer)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. SPACESTATION_KASH_IMPERIAL_STAGE_KEY)
end

-- Stages 3 and 6 are failure states, not rungs above 2 and 5, so this setter is deliberately
-- NOT monotonic -- the two retry branches have to be able to walk the pilot back.
function SpacestationKashImperialConvoHandler:setStage(pPlayer, stage)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. SPACESTATION_KASH_IMPERIAL_STAGE_KEY

	deleteData(key)
	writeData(key, stage)
end

function SpacestationKashImperialConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function SpacestationKashImperialConvoHandler:setFlag(pPlayer, flagKey, value)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. flagKey

	deleteData(key)

	if (value ~= 0) then
		writeData(key, value)
	end
end

-- Any space mission sitting in the datapad. This is the same observable activateSpaceQuest()
-- walks for its duty gate, and it is what s_e8cb2563 ("you seem to be busy doing something
-- else. Finish your mission and we'll talk.") is reacting to.
function SpacestationKashImperialConvoHandler:isOnMission(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pDatapad = SceneObject(pPlayer):getSlottedObject("datapad")

	if (pDatapad == nil) then
		return false
	end

	for i = 1, SceneObject(pDatapad):getContainerObjectsSize(), 1 do
		local pObject = SceneObject(pDatapad):getContainerObject(i - 1)

		if (pObject ~= nil and SceneObject(pObject):isMissionObject()) then
			return true
		end
	end

	return false
end

-- Recompute which shipped greeting the base owes this pilot. The Gaaltura V job is checked first
-- because the commander calls it the challenge that outranks "the standard duty mission" (s_340).
function SpacestationKashImperialConvoHandler:refreshStage(pPlayer)
	if (pPlayer == nil) then
		return
	end

	--[[
		The Gaaltura V -- recovery/ep3_red_tie_recovery (KashyyykMiningScreenplay.lua:398).
		Its STF title is "Hidden Sabers - Help an Imperial Operative slice the navicomputer of an
		Alliance Corvette", which is s_344/s_348/s_352 word for word.
	]]
	if (self:getFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_CORVETTE_KEY) ~= 0) then
		local isComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASH_IMPERIAL_CORVETTE.type, SPACESTATION_KASH_IMPERIAL_CORVETTE.name)
		local isActive = SpaceHelpers:isSpaceQuestActive(pPlayer, SPACESTATION_KASH_IMPERIAL_CORVETTE.type, SPACESTATION_KASH_IMPERIAL_CORVETTE.name)

		-- s_266: "The mission was a success. Our special Operative sends her regards."
		if (isComplete and self:getFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_TIE_KEY) == 0) then
			self:setStage(pPlayer, 7)
			return
		end

		-- s_274: "You asked for the challenge... now do it!"
		if (isActive) then
			self:setStage(pPlayer, 5)
			return
		end

		-- SpaceHelpers:failSpaceQuest() clears the journal quest, so handed-out but neither active
		-- nor complete is a botched run. s_278: "You failed! Fortunately our operative managed to
		-- escape the Corvette..."
		if (not isComplete) then
			self:setStage(pPlayer, 6)
			return
		end
	end

	--[[
		The commander's escort favour -- escort/ep3_kash_station_imperial_escort_alpha
		(KashyyykStationScreenplay.lua:219, STF "An Imperial transport is in need of escort...
		Protect the transport as it departs the Kashyyyk system"), which is s_304 word for word.
	]]
	if (self:getFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_ESCORT_KEY) ~= 0) then
		local isComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASH_IMPERIAL_ESCORT.type, SPACESTATION_KASH_IMPERIAL_ESCORT.name)
		local isActive = SpaceHelpers:isSpaceQuestActive(pPlayer, SPACESTATION_KASH_IMPERIAL_ESCORT.type, SPACESTATION_KASH_IMPERIAL_ESCORT.name)

		-- s_362: "your award from Imperial Command arrived while you were on duty."
		if (isComplete and self:getFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_AWARD_KEY) == 0) then
			self:setStage(pPlayer, 4)
			return
		end

		-- s_276: "You've got a transport to escort, pilot! Get going."
		if (isActive) then
			self:setStage(pPlayer, 2)
			return
		end

		-- s_286: "This is unacceptable! The Emperor's transports must be protected."
		if (not isComplete) then
			self:setStage(pPlayer, 3)
			return
		end
	end

	-- s_292: "You are the one who foiled the Ghrag mercenaries' plot to eliminate this space
	-- station." The Ghrag hunt this base hands out is
	-- destroy_duty/ep3_kash_station_destroy_duty_imperial (s_318 "punish the Ghrag mercenary clan.
	-- Patrol the Kashyyyk system and destroy all Ghrag pilots you encounter").
	if (self:getFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_HERO_KEY) == 0 and
		SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASH_IMPERIAL_DESTROY_DUTY.type, SPACESTATION_KASH_IMPERIAL_DESTROY_DUTY.name)) then
		self:setStage(pPlayer, 1)
		return
	end

	self:setStage(pPlayer, 0)
end

function SpacestationKashImperialConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
	if (pPlayer == nil or pNpc == nil or pConvTemplate == nil) then
		return
	end

	local convoTemplate = LuaConversationTemplate(pConvTemplate)

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	if (not SceneObject(pShip):checkInConversationRange(pNpc)) then
		return convoTemplate:getScreen("out_of_range")
	end

	if (TangibleObject(pPlayer):isRebel()) then
		return convoTemplate:getScreen("spacestation_kash_imperial_greeting_rebel")
	end

	if (not TangibleObject(pPlayer):isImperial()) then
		return convoTemplate:getScreen("spacestation_kash_imperial_greeting_neutral")
	end

	-- s_358253b2: "There's nothing we can do for you while you're in that civilian ship." The only
	-- civilian hull a pilot can fly into this station is the SoroSuub space yacht.
	if (SpaceHelpers:isInYacht(pPlayer)) then
		return convoTemplate:getScreen("spacestation_kash_imperial_civilian_ship")
	end

	self:refreshStage(pPlayer)

	local stage = self:getStage(pPlayer)

	-- s_e8cb2563: "you seem to be busy doing something else. Finish your mission and we'll talk."
	-- Stages 2 and 5 are the base's OWN in-progress hails and must win over the generic one;
	-- stages 3, 4, 6 and 7 are pending hand-overs the commander opened himself.
	if (stage == 0 and self:isOnMission(pPlayer)) then
		return convoTemplate:getScreen("spacestation_kash_imperial_busy")
	end

	local screenID = SPACESTATION_KASH_IMPERIAL_STAGES[stage]

	if (screenID == nil) then
		return convoTemplate:getScreen("spacestation_kash_imperial_greeting")
	end

	return convoTemplate:getScreen(screenID)
end

function SpacestationKashImperialConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	if (pPlayer == nil or pConvScreen == nil) then
		return
	end

	local screen = LuaConversationScreen(pConvScreen)
	local screenID = screen:getScreenID()

	local pScreenClone = screen:cloneScreen()
	local pClonedConvo = LuaConversationScreen(pScreenClone)

	pClonedConvo:setDialogTextTU(CreatureObject(pPlayer):getFirstName())

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	if (screenID == "spacestation_kash_imperial_declare") then
		createEvent((30 * 1000), "SpaceHelpers", "declareOvert", pShip, "imperial")

	--[[
		Duty missions
	]]

	-- s_322 "Outstanding!" closes the destroy-duty branch (s_318). DUTY GATE: activateSpaceQuest()
	-- refuses a "_duty" quest while another space duty sits in the datapad and sends
	-- "@space/quest:duty_already" itself, so this can never fail silently.
	elseif (screenID == "spacestation_kash_imperial_destroy_granted") then
		destroy_duty_ep3_kash_station_destroy_duty_imperial:startQuest(pPlayer, pNpc)

	-- s_332 "Superb!" closes the escort-duty branch (s_328).
	elseif (screenID == "spacestation_kash_imperial_escort_granted") then
		escort_duty_ep3_kash_station_escort_duty_imperial:startQuest(pPlayer, pNpc)

	--[[
		The commander's one-off escort favour (stage 1)
	]]

	-- s_308 "Good luck, pilot." is the only terminal of the favour branch; s_304 that precedes it
	-- is the request itself.
	elseif (screenID == "spacestation_kash_imperial_favor_accept") then
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_HERO_KEY, 1)
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_ESCORT_KEY, 1)
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_AWARD_KEY, 0)

		escort_ep3_kash_station_imperial_escort_alpha:startQuest(pPlayer, pNpc)

	-- s_290: "Do not fail us again, pilot." -- the same transport run handed back out.
	elseif (screenID == "spacestation_kash_imperial_escort_retry") then
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_ESCORT_KEY, 1)

		escort_ep3_kash_station_imperial_escort_alpha:startQuest(pPlayer, pNpc)

	-- s_393 "You are welcome, pilot." closes the award hand-over.
	-- REWARD: station_imperial_base.stf s_300 ("a holographic projection system that produces a
	-- proud symbol of the Empire"), s_362 ("your award from Imperial Command arrived while you were
	-- on duty") and s_393 promise an Imperial symbol hologram. That object exists and is registered:
	-- object/tangible/furniture/ep3_rewards/hologram_insignia_imperial_01.iff
	-- (bin/scripts/object/custom_content/tangible/furniture/ep3_rewards/hologram_insignia_imperial_01.lua,
	-- reached through object/serverobjects.lua -> custom_content -> tangible -> furniture ->
	-- ep3_rewards/serverobjects.lua:13). Handed over here, on the terminal screen, so the award is
	-- only paid once -- SPACESTATION_KASH_IMPERIAL_AWARD_KEY gates stage 4 from being offered again.
	elseif (screenID == "spacestation_kash_imperial_award_granted") then
		SpaceHelpers:spaceItemReward(pPlayer, "object/tangible/furniture/ep3_rewards/hologram_insignia_imperial_01.iff")

		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_AWARD_KEY, 1)
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_ESCORT_KEY, 0)
		self:setStage(pPlayer, 0)

	--[[
		The Gaaltura V
	]]

	-- s_360: "Affirmative. Good luck, pilot."
	elseif (screenID == "spacestation_kash_imperial_corvette_accept") then
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_CORVETTE_KEY, 1)

		recovery_ep3_red_tie_recovery:startQuest(pPlayer, pNpc)

	-- s_282: "Outstanding!" -- the operative has rejoined the Alliance and the intercept is on again.
	elseif (screenID == "spacestation_kash_imperial_corvette_retry") then
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_CORVETTE_KEY, 1)

		recovery_ep3_red_tie_recovery:startQuest(pPlayer, pNpc)

	-- s_270: "Good hunting!"
	-- REWARD: s_356/s_266 promise the "'Crimson Guard' TIE Interceptor". That is the client's
	-- "tieinterceptor_imperial_guard" ship, and the deed for it is paid by the quest itself --
	-- recovery_ep3_red_tie_recovery.itemReward now grants
	-- object/tangible/ship/crafted/chassis/tieinterceptor_imperial_guard_reward_deed.iff on
	-- completion (KashyyykMiningScreenplay.lua). Nothing is granted a second time here on purpose;
	-- this branch only closes the state out so the base returns to normal service.
	elseif (screenID == "spacestation_kash_imperial_tie_granted") then
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_TIE_KEY, 1)
		self:setFlag(pPlayer, SPACESTATION_KASH_IMPERIAL_CORVETTE_KEY, 0)
		self:setStage(pPlayer, 0)
	end

	return pScreenClone
end
