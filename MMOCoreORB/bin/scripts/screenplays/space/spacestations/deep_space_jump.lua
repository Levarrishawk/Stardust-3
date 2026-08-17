--[[
	Deep Space - Kessel jump (scrapbook 2.3 + 1.3):
	"Deep Space / Kessel is the prestige-gated endgame zone: master pilots spend
	faction prestige to reach Deep Space via factional 'Deep Space - Kessel jump'
	stations (Dantooine space for Rebel, Endor space for Imperial)."

	Jump mechanism: mirrors HyperspaceToLocationTask (src/server/zone/objects/ship/
	events/HyperspaceToLocationTask.h) from the Lua side using the exposed
	primitives - ShipObject:setHyperspacing() and SceneObject:switchZone() (the
	same core call the C++ task performs in its case 10).

	Prestige spend uses the negative awardExperience idiom
	(screenplays/village/convos/convohelpers/experience_converter.lua:305).
]]

local Logger = require("utils.logger")
require("utils.helpers")

DeepSpaceJumpScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "DeepSpaceJumpScreenPlay",

	DEEP_SPACE_ZONE = "space_heavy1",

	-- Scrapbook, "FAQ and Guide to Pilot v2.0": "After mastering Pilot you gain
	-- Prestige points instead of XP. This can be used to gain access to the PvP
	-- dedicated Deep Space sector (30k Prestige Points)."  Corroborated by the
	-- pilot loadout/RE guide ("well worth the 30k prestige").  Two independent
	-- player sources; SOE never published a figure, so this is [COMMUNITY].
	DEEP_SPACE_JUMP_PRESTIGE_COST = 30000,

	-- Arrival points inside Deep Space (space_heavy1), near the faction presence
	-- spawned by SpaceHeavy1Spawner (Freedom Station -6000,0,0 / Star Destroyer 6000,0,0).
	-- Freedom Station's -6000,0,0 is Live-attested: clientpoi.iff carries exactly one
	-- space_heavy1 row, {Name = "@clientpoi_n:hvy_rebel_station" ("Freedom Station"),
	-- Planet = "space_heavy1", X = -6000, Y = 0, Z = 0}.  There is no clientpoi row for
	-- the Star Destroyer, so 6000,0,0 is ours.
	-- Format: { x, z, y }
	arrivalPoints = {
		rebel = {-5500, 0, -300},
		imperial = {5500, 0, 300},
		-- The neutral station's own client text is explicit that a freelancer does not
		-- arrive unaligned - they pick a route in:
		--   battlefield_entry_station_neutral:s_a99b5897 "...The only way to get in is
		--   to pose as either an Imperial yourself, or to use the Rebel Alliance's
		--   hyperspace route."
		-- so the side they pick decides which side's arrival point they use.
		neutral = {0, 0, -5500},
		neutral_imperial = {5500, 0, 300},
		neutral_rebel = {-5500, 0, -300},
	},

	-- Kessel (space_light1).  Every prestige line in all three battlefield entry
	-- station string tables names Deep Space, never Kessel, and there is no Kessel
	-- cost/insufficient string anywhere - so this route carries no prestige fee.
	-- The Kessel option itself IS client-attested on all three stations:
	--   battlefield_entry_station_imperial:s_597d7f95 "I would like to go to Kessel."
	--   battlefield_entry_station_rebel:s_359fde4     "I want to go to Kessel."
	--   battlefield_entry_station_neutral:s_c4588d4d  "I want to go to Kessel"
	KESSEL_ZONE = "space_light1",

	-- clientpoi.iff has ZERO space_light1 rows and hyperspace_locations.iff has no
	-- space_light1 SCENE, so no Kessel arrival coordinate is Live-attested.  This
	-- point is ours: system centre, clear of every spawn anchor in
	-- space_light1_spawner.lua.
	-- Format: { x, z, y }
	kesselArrivalPoint = {0, 0, 0},

	-- Rage of the Wookiees space zone. hyperspace_locations.iff carries no Kashyyyk
	-- row and there is no TRE packer, so the same Lua jump the Deep Space stations
	-- use is the only server-side way into space_kashyyyk.
	KASHYYYK_ZONE = "space_kashyyyk",

	-- Kashyyyk is PvE, so the jump carries NO prestige cost and NO master-pilot
	-- gate - unlike the Deep Space jump above, which is untouched.
	-- station_kashyyyk sits at -5000, 250, -5000 and the scrapbook puts it "just
	-- 2 km from the nearest hyperspace point", so arrive 2000m off its bow.
	-- Format: { x, z, y }
	kashyyykArrivalPoint = {-3000, 250, -5000},
}

registerScreenPlay("DeepSpaceJumpScreenPlay", false)

-- Returns the prestige experience pool the player would spend at this station,
-- or nil if they do not hold the required master skill.
--
-- Scrapbook (Zina's Corvette guide FAQ; "FAQ and Guide to Pilot v2.0"):
--   "Rebels get there from the Deep Space Station in the Dantooine System.
--    Imperials get there from the Empire Deep Space station in the Endor System.
--    Freelancers get there from the Neutral Deep Space Station in the Dathomir
--    System."
-- Each station is therefore keyed to ONE faction's prestige pool. The scrapbook
-- is also explicit that privateer prestige does not open the factional doors:
--   "As an overt Imperial or Rebel you do not have any Imp/Reb Prestige to gain
--    entry to deep space using the Factional deep space stations."
function DeepSpaceJumpScreenPlay:getPrestigeType(pPlayer, stationFaction)
	if (pPlayer == nil) then
		return nil
	end

	if (stationFaction == "rebel" and CreatureObject(pPlayer):hasSkill("pilot_rebel_navy_master")) then
		return "prestige_rebel"
	elseif (stationFaction == "imperial" and CreatureObject(pPlayer):hasSkill("pilot_imperial_navy_master")) then
		return "prestige_imperial"
	elseif ((stationFaction == "neutral" or stationFaction == "neutral_imperial" or stationFaction == "neutral_rebel")
			and CreatureObject(pPlayer):hasSkill("pilot_neutral_master")) then
		return "prestige_pilot"
	end

	return nil
end

-- @space/space_battlefields:not_enough_prestige
--   "You do not have enough %TO to enter this zone. You need %DI."
-- %TO is the prestige pool's own client name (@exp_n:prestige_rebel = "Rebel
-- Prestige", prestige_imperial = "Imperial Prestige", prestige_pilot = "Pilot
-- Prestige").
function DeepSpaceJumpScreenPlay:sendNotEnoughPrestige(pPlayer, prestigeType)
	if (pPlayer == nil) then
		return
	end

	local message = LuaStringIdChatParameter("@space/space_battlefields:not_enough_prestige")
	message:setTO("@exp_n:" .. tostring(prestigeType))
	message:setDI(self.DEEP_SPACE_JUMP_PRESTIGE_COST)

	CreatureObject(pPlayer):sendSystemMessage(message)
end

-- @space/space_battlefields:spent_x_amount_for_ticket
--   "You have spent %DI of %TO to enter this battlefield."
function DeepSpaceJumpScreenPlay:sendPrestigeSpent(pPlayer, prestigeType)
	if (pPlayer == nil) then
		return
	end

	local message = LuaStringIdChatParameter("@space/space_battlefields:spent_x_amount_for_ticket")
	message:setDI(self.DEEP_SPACE_JUMP_PRESTIGE_COST)
	message:setTO("@exp_n:" .. tostring(prestigeType))

	CreatureObject(pPlayer):sendSystemMessage(message)
end

function DeepSpaceJumpScreenPlay:getPrestigeBalance(pPlayer, prestigeType)
	if (pPlayer == nil or prestigeType == nil) then
		return 0
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()

	if (pGhost == nil) then
		return 0
	end

	return PlayerObject(pGhost):getExperience(prestigeType)
end

-- Invoked from the jump station conversation handlers via
-- createEvent(3500, "DeepSpaceJumpScreenPlay", "beginJump", pPlayer, stationFaction)
-- (mirrors the SpaceStationScreenPlay:landShip createEvent idiom).
function DeepSpaceJumpScreenPlay:beginJump(pPlayer, stationFaction)
	if (pPlayer == nil or stationFaction == nil) then
		return
	end

	local prestigeType = self:getPrestigeType(pPlayer, stationFaction)

	if (prestigeType == nil) then
		return
	end

	-- No client string covers a disabled zone or a non-pilot passenger, so these
	-- two paths fail silently rather than emit authored prose.
	if (not isZoneEnabled(self.DEEP_SPACE_ZONE)) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	-- Only the pilot can initiate the jump
	if (not CreatureObject(pPlayer):isPilotingShip()) then
		return
	end

	-- Check the prestige balance up front (the deduction itself happens in
	-- completeJump, after the in-ship recheck, so a bailed jump never costs prestige)
	local balance = self:getPrestigeBalance(pPlayer, prestigeType)

	if (balance < self.DEEP_SPACE_JUMP_PRESTIGE_COST) then
		self:sendNotEnoughPrestige(pPlayer, prestigeType)
		return
	end

	ShipObject(pShip):setHyperspacing(true)
	CreatureObject(pPlayer):sendSystemMessage("@space/space_interaction:hyperspace_route_begin")

	createEvent(5000, self.screenplayName, "completeJump", pPlayer, stationFaction .. ":" .. prestigeType)
end

function DeepSpaceJumpScreenPlay:completeJump(pPlayer, args)
	if (pPlayer == nil or args == nil) then
		return
	end

	local stationFaction, prestigeType = string.match(args, "^([^:]+):(.+)$")

	if (stationFaction == nil or prestigeType == nil) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	-- Spend prestige NOW (negative awardExperience idiom), re-checking the balance:
	-- if it no longer covers the cost, abort the jump instead of gouging.
	local balance = self:getPrestigeBalance(pPlayer, prestigeType)

	if (balance < self.DEEP_SPACE_JUMP_PRESTIGE_COST) then
		ShipObject(pShip):setHyperspacing(false)
		self:sendNotEnoughPrestige(pPlayer, prestigeType)
		return
	end

	CreatureObject(pPlayer):awardExperience(prestigeType, self.DEEP_SPACE_JUMP_PRESTIGE_COST * -1, false)
	self:sendPrestigeSpent(pPlayer, prestigeType)

	local point = self.arrivalPoints[stationFaction]

	if (point == nil) then
		point = self.arrivalPoints.rebel
	end

	-- Mirror HyperspaceToLocationTask case 9: randomize the arrival location
	local x = point[1] + getRandomNumber(100)
	local z = point[2] + getRandomNumber(100)
	local y = point[3] + getRandomNumber(100)

	-- Mirror HyperspaceToLocationTask case 10: switch the ships zone
	SceneObject(pShip):switchZone(self.DEEP_SPACE_ZONE, x, z, y, 0)

	-- Move the pilot with the ship so the client gets a scene reset
	-- (SpaceZoneComponent::switchZone ship-parent branch handles
	-- sendSceneResetToOwner + delayed sendObjectsToOwner)
	local parentID = SceneObject(pPlayer):getParentID()
	SceneObject(pPlayer):switchZone(self.DEEP_SPACE_ZONE, x, z, y, parentID)

	-- Mirror HyperspaceToLocationTask case 11: clear the hyperspace flag after arrival
	createEvent(6000, self.screenplayName, "clearHyperspace", pPlayer, "")
end

-- Invoked from the jump station conversation handlers via
-- createEvent(3500, "DeepSpaceJumpScreenPlay", "beginKesselJump", pPlayer, "")
-- Same jump primitives as beginJump, but no prestige spend and no skill gate:
-- the Kessel option on all three battlefield entry stations has no prestige
-- screen behind it in any of the three client string tables.
function DeepSpaceJumpScreenPlay:beginKesselJump(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not isZoneEnabled(self.KESSEL_ZONE)) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	-- Only the pilot can initiate the jump
	if (not CreatureObject(pPlayer):isPilotingShip()) then
		return
	end

	ShipObject(pShip):setHyperspacing(true)
	CreatureObject(pPlayer):sendSystemMessage("@space/space_interaction:hyperspace_route_begin")

	createEvent(5000, self.screenplayName, "completeKesselJump", pPlayer, "")
end

function DeepSpaceJumpScreenPlay:completeKesselJump(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	local point = self.kesselArrivalPoint

	-- Mirror HyperspaceToLocationTask case 9: randomize the arrival location
	local x = point[1] + getRandomNumber(100)
	local z = point[2] + getRandomNumber(100)
	local y = point[3] + getRandomNumber(100)

	-- Mirror HyperspaceToLocationTask case 10: switch the ships zone
	SceneObject(pShip):switchZone(self.KESSEL_ZONE, x, z, y, 0)

	-- Move the pilot with the ship so the client gets a scene reset
	local parentID = SceneObject(pPlayer):getParentID()
	SceneObject(pPlayer):switchZone(self.KESSEL_ZONE, x, z, y, parentID)

	-- Mirror HyperspaceToLocationTask case 11: clear the hyperspace flag after arrival
	createEvent(6000, self.screenplayName, "clearHyperspace", pPlayer, "")
end

-- UNREFERENCED as of the client-string rewrite of the three jump station
-- conversations.  The Kashyyyk destination was authored prose - no client string
-- anywhere offers a Kashyyyk route from these stations, whereas all three
-- stations DO carry a Kessel option - so the conversations now offer Kessel and
-- nothing calls this.  Kept, not deleted, pending the owner's ruling.
function DeepSpaceJumpScreenPlay:beginKashyyykJump(pPlayer)
	if (pPlayer == nil) then
		return
	end

	if (not isZoneEnabled(self.KASHYYYK_ZONE)) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	-- Only the pilot can initiate the jump
	if (not CreatureObject(pPlayer):isPilotingShip()) then
		return
	end

	ShipObject(pShip):setHyperspacing(true)
	CreatureObject(pPlayer):sendSystemMessage("@space/space_interaction:hyperspace_route_begin")

	createEvent(5000, self.screenplayName, "completeKashyyykJump", pPlayer, "")
end

function DeepSpaceJumpScreenPlay:completeKashyyykJump(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	local point = self.kashyyykArrivalPoint

	-- Mirror HyperspaceToLocationTask case 9: randomize the arrival location
	local x = point[1] + getRandomNumber(100)
	local z = point[2] + getRandomNumber(100)
	local y = point[3] + getRandomNumber(100)

	-- Mirror HyperspaceToLocationTask case 10: switch the ships zone
	SceneObject(pShip):switchZone(self.KASHYYYK_ZONE, x, z, y, 0)

	-- Move the pilot with the ship so the client gets a scene reset
	local parentID = SceneObject(pPlayer):getParentID()
	SceneObject(pPlayer):switchZone(self.KASHYYYK_ZONE, x, z, y, parentID)

	-- Mirror HyperspaceToLocationTask case 11: clear the hyperspace flag after arrival
	createEvent(6000, self.screenplayName, "clearHyperspace", pPlayer, "")
end

function DeepSpaceJumpScreenPlay:clearHyperspace(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local pShip = SceneObject(pPlayer):getRootParent()

	if (pShip == nil or not SceneObject(pShip):isShipObject()) then
		return
	end

	ShipObject(pShip):setHyperspacing(false)
end
