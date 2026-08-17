local Logger = require("utils.logger")
require("utils.helpers")

SpacestationKashRebelConvoHandler = conv_handler:new {}

-- The outpost commander tracks how far the pilot has come with the Alliance here.
-- The stage is stored per player and drives which shipped greeting is used.
SPACESTATION_KASH_REBEL_STAGES = {
	[0] = "spacestation_kash_rebel_greeting",
	[1] = "spacestation_kash_rebel_greeting_hero", -- Ghrag plot against the station broken
	[2] = "spacestation_kash_rebel_greeting_award", -- transport escort completed
	[3] = "spacestation_kash_rebel_greeting_failed", -- transport escort botched
	[4] = "spacestation_kash_rebel_greeting_xwing", -- corvette recovered, chassis waiting
}

SPACESTATION_KASH_REBEL_STAGE_KEY = ":spacestation_kash_rebel:stage"
-- Set when the one-off transport escort is handed out, cleared once the outpost has reacted to
-- the result. Without it a never-taken escort is indistinguishable from a botched one.
SPACESTATION_KASH_REBEL_TRANSPORT_KEY = ":spacestation_kash_rebel:transport"
-- Set once the outpost has paid out for the transport run, so stage 2 is not offered forever.
SPACESTATION_KASH_REBEL_AWARD_KEY = ":spacestation_kash_rebel:award"
-- Set once the pilot has taken the commander up on s_735 ("I have something else for you to do"),
-- so the one-off hero speech is not replayed every hail afterwards.
SPACESTATION_KASH_REBEL_HERO_KEY = ":spacestation_kash_rebel:hero"
-- Set once the outpost has settled the corvette job, so stage 4 is not offered forever.
SPACESTATION_KASH_REBEL_XWING_KEY = ":spacestation_kash_rebel:xwing"

-- The quest the commander means by each branch of the shipped conversation.
SPACESTATION_KASH_REBEL_DESTROY_DUTY = {type = "destroy_duty", name = "ep3_kash_station_destroy_duty_rebel"}
SPACESTATION_KASH_REBEL_ESCORT_DUTY = {type = "escort_duty", name = "ep3_kash_station_escort_duty_rebel"}
SPACESTATION_KASH_REBEL_TRANSPORT = {type = "escort", name = "ep3_kash_station_rebel_escort_alpha"}
SPACESTATION_KASH_REBEL_CORVETTE = {type = "recovery", name = "ep3_heavy_xwing_recovery"}

function SpacestationKashRebelConvoHandler:getStage(pPlayer)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. SPACESTATION_KASH_REBEL_STAGE_KEY)
end

-- Stage 3 (botched) is a side state, not a rung above stage 2, so this setter is deliberately
-- NOT monotonic -- the retry branch has to be able to walk the pilot back to stage 1.
function SpacestationKashRebelConvoHandler:setStage(pPlayer, stage)
	if (pPlayer == nil) then
		return
	end

	local key = SceneObject(pPlayer):getObjectID() .. SPACESTATION_KASH_REBEL_STAGE_KEY

	deleteData(key)
	writeData(key, stage)
end

function SpacestationKashRebelConvoHandler:getFlag(pPlayer, flagKey)
	if (pPlayer == nil) then
		return 0
	end

	return readData(SceneObject(pPlayer):getObjectID() .. flagKey)
end

function SpacestationKashRebelConvoHandler:setFlag(pPlayer, flagKey, value)
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
-- walks for its duty gate, and it is what s_717 "You look busy..." is reacting to.
function SpacestationKashRebelConvoHandler:isOnMission(pPlayer)
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

-- Recompute which shipped greeting the outpost owes this pilot. Evaluated in a fixed order so
-- two pending results can never fight over the hail:
--   1. the corvette job, because s_850 is a hand-over the commander opened himself
--   2. the transport escort result, because the commander asked for a report ("report back
--      when you are done", s_739)
--   3. the standing Ghrag plot, which is the lowest-value state and the one the others build on
function SpacestationKashRebelConvoHandler:refreshStage(pPlayer)
	if (pPlayer == nil) then
		return
	end

	-- s_850: "Excellent work bringing down that traitor and saving our engineers!" -- the traitor
	-- engineer and the loyal engineers are recovery/ep3_heavy_xwing_recovery
	-- (KashyyykMiningScreenplay.lua:243, STF quest_escort_t "Escort the Corvette to the Rebel Outpost").
	if (self:getFlag(pPlayer, SPACESTATION_KASH_REBEL_XWING_KEY) == 0 and
		SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASH_REBEL_CORVETTE.type, SPACESTATION_KASH_REBEL_CORVETTE.name)) then
		self:setStage(pPlayer, 4)
		return
	end

	if (self:getFlag(pPlayer, SPACESTATION_KASH_REBEL_TRANSPORT_KEY) ~= 0) then
		local isComplete = SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASH_REBEL_TRANSPORT.type, SPACESTATION_KASH_REBEL_TRANSPORT.name)
		local isActive = SpaceHelpers:isSpaceQuestActive(pPlayer, SPACESTATION_KASH_REBEL_TRANSPORT.type, SPACESTATION_KASH_REBEL_TRANSPORT.name)

		-- s_821: "The Alliance thanks you, my friend."
		if (isComplete and self:getFlag(pPlayer, SPACESTATION_KASH_REBEL_AWARD_KEY) == 0) then
			self:setStage(pPlayer, 2)
			return
		end

		-- SpaceHelpers:failSpaceQuest() clears the journal quest and fails the datapad mission, so
		-- a transport run that was handed out but is now neither active nor complete was botched.
		-- s_729: "Perhaps your reputation isn't so well-deserved."
		if (not isComplete and not isActive) then
			self:setStage(pPlayer, 3)
			return
		end

		-- Still out flying it. There is no shipped "escort under way" hail on the Rebel side, so
		-- this falls through to the busy hail (s_717) below.
	end

	-- s_735: "Seems you've single-handedly brought down a Ghrag mercenary plot to destroy this
	-- station." The Ghrag hunt this outpost hands out is destroy_duty/ep3_kash_station_destroy_duty_rebel
	-- (s_769 "hunt down their pilots and prevent them from interfering with our operations here").
	if (self:getFlag(pPlayer, SPACESTATION_KASH_REBEL_HERO_KEY) == 0 and
		SpaceHelpers:isSpaceQuestComplete(pPlayer, SPACESTATION_KASH_REBEL_DESTROY_DUTY.type, SPACESTATION_KASH_REBEL_DESTROY_DUTY.name)) then
		self:setStage(pPlayer, 1)
		return
	end

	self:setStage(pPlayer, 0)
end

function SpacestationKashRebelConvoHandler:getInitialScreen(pPlayer, pNpc, pConvTemplate)
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

	if (TangibleObject(pPlayer):isImperial()) then
		return convoTemplate:getScreen("spacestation_kash_rebel_greeting_imperial")
	end

	if (not TangibleObject(pPlayer):isRebel()) then
		return convoTemplate:getScreen("spacestation_kash_rebel_greeting_neutral")
	end

	-- s_713: "There's nothing we can do for you while you're in that civilian ship." The only
	-- civilian hull a pilot can fly into this station is the SoroSuub space yacht, which is also
	-- the hull hasCertifiedShip() is asked to skip everywhere else in the space scripts.
	if (SpaceHelpers:isInYacht(pPlayer)) then
		return convoTemplate:getScreen("spacestation_kash_rebel_civilian_ship")
	end

	self:refreshStage(pPlayer)

	local stage = self:getStage(pPlayer)

	-- s_717: "What's up, %TU? You look busy..." Only shown when the outpost owes nothing -- a
	-- pending hand-over (stages 2, 3 and 4) is the commander's own business and outranks it.
	if (stage ~= 2 and stage ~= 3 and stage ~= 4 and self:isOnMission(pPlayer)) then
		return convoTemplate:getScreen("spacestation_kash_rebel_busy")
	end

	local screenID = SPACESTATION_KASH_REBEL_STAGES[stage]

	if (screenID == nil) then
		return convoTemplate:getScreen("spacestation_kash_rebel_greeting")
	end

	return convoTemplate:getScreen(screenID)
end

function SpacestationKashRebelConvoHandler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
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

	if (screenID == "spacestation_kash_rebel_declare") then
		createEvent((30 * 1000), "SpaceHelpers", "declareOvert", pShip, "rebel")

	--[[
		Duty missions
	]]

	-- s_773 is literally "Grant mission: Destroy Duty". DUTY GATE: activateSpaceQuest() refuses a
	-- "_duty" quest while another space duty sits in the datapad and sends
	-- "@space/quest:duty_already" itself, so this can never fail silently.
	elseif (screenID == "spacestation_kash_rebel_destroy_granted") then
		destroy_duty_ep3_kash_station_destroy_duty_rebel:startQuest(pPlayer, pNpc)

	-- s_783: "Grant mission: Escort duty."
	elseif (screenID == "spacestation_kash_rebel_escort_granted") then
		escort_duty_ep3_kash_station_escort_duty_rebel:startQuest(pPlayer, pNpc)

	--[[
		The one-off transport escort (stage 1)
	]]

	-- Two terminals take this job. s_747 "Good luck." is the straight "Roger that." accept, and
	-- s_759 "No problem. Good luck!" is the end of the what-do-I-get branch -- that branch has no
	-- route back to the accept option, so the sign-off IS the accept.
	elseif (screenID == "spacestation_kash_rebel_transport_accept" or screenID == "spacestation_kash_rebel_hologram_thanks") then
		self:setFlag(pPlayer, SPACESTATION_KASH_REBEL_HERO_KEY, 1)
		self:setFlag(pPlayer, SPACESTATION_KASH_REBEL_TRANSPORT_KEY, 1)
		self:setFlag(pPlayer, SPACESTATION_KASH_REBEL_AWARD_KEY, 0)

		escort_ep3_kash_station_rebel_escort_alpha:startQuest(pPlayer, pNpc)

	-- s_825 "You deserve it!" closes the payout for the transport run.
	-- REWARD: station_rebel_outpost.stf s_755 ("an Alliance Symbol Hologram"), s_821 ("your award
	-- from Alliance Command arrived while you were on duty") and s_825 promise an Alliance symbol
	-- hologram. That object exists and is registered:
	-- object/tangible/furniture/ep3_rewards/hologram_insignia_rebel_01.iff
	-- (bin/scripts/object/custom_content/tangible/furniture/ep3_rewards/hologram_insignia_rebel_01.lua,
	-- reached through object/serverobjects.lua -> custom_content -> tangible -> furniture ->
	-- ep3_rewards/serverobjects.lua:14). Handed over here, on the terminal screen, so the award is
	-- only paid once -- SPACESTATION_KASH_REBEL_AWARD_KEY gates stage 2 from being offered again.
	elseif (screenID == "spacestation_kash_rebel_award_granted") then
		SpaceHelpers:spaceItemReward(pPlayer, "object/tangible/furniture/ep3_rewards/hologram_insignia_rebel_01.iff")

		self:setFlag(pPlayer, SPACESTATION_KASH_REBEL_AWARD_KEY, 1)
		self:setFlag(pPlayer, SPACESTATION_KASH_REBEL_TRANSPORT_KEY, 0)
		self:setStage(pPlayer, 0)

	-- s_733: "Better luck, this time!" -- the commander hands the same transport run back out.
	elseif (screenID == "spacestation_kash_rebel_retry") then
		self:setFlag(pPlayer, SPACESTATION_KASH_REBEL_TRANSPORT_KEY, 1)

		escort_ep3_kash_station_rebel_escort_alpha:startQuest(pPlayer, pNpc)

	--[[
		The stolen Corellian Corvette
	]]

	-- s_803: "For the Alliance!" is the only terminal of the accept branch; s_799 that precedes it
	-- says "I will upload the mission package right now!"
	elseif (screenID == "spacestation_kash_rebel_for_the_alliance") then
		recovery_ep3_heavy_xwing_recovery:startQuest(pPlayer, pNpc)

	-- s_1111: "You deserve it! The Force be with you!"
	-- REWARD: s_815/s_850 promise a prototype Heavy X-wing chassis. That is the client's
	-- "advanced_xwing" ship, and the deed for it is paid by the quest itself --
	-- recovery_ep3_heavy_xwing_recovery.itemReward now grants
	-- object/tangible/ship/crafted/chassis/advanced_xwing_reward_deed.iff on completion
	-- (KashyyykMiningScreenplay.lua). Nothing is granted a second time here on purpose; this branch
	-- only closes the state out so the station returns to normal service.
	elseif (screenID == "spacestation_kash_rebel_xwing_granted") then
		self:setFlag(pPlayer, SPACESTATION_KASH_REBEL_XWING_KEY, 1)
		self:setStage(pPlayer, 0)
	end

	return pScreenClone
end
