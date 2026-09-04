MeatlumpLadderDownMenuComponent = {}

-- SOE mtp_hideout_entrance_ladder.java:30 gated on completed
-- mtp_hideout_access_07 or mtp_hideout_access_high_07 or god. Part 1 ships
-- the hideout open (orchestrator D1).
MeatlumpLadderDownMenuComponent.GATE_ENABLED = false
-- When GATE_ENABLED flips to true, the check is:
--   Journal.done(pPlayer, "mtp_hideout_access_07") or Journal.done(pPlayer, "mtp_hideout_access_high_07")
--   or PlayerObject(pGhost):isPrivileged()
--   via require("managers.quest.journal")
-- TODO: do not add that require now (the module lives on branch journal-1-module).

function MeatlumpLadderDownMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	-- OURS, NOT SOURCED (SOE key elevator_text:mtp_ladder_climb_down does not ship)
	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "Climb down")
end

function MeatlumpLadderDownMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 6)) then
		CreatureObject(pPlayer):sendSystemMessage("@elevator_text:too_far")
		return 0
	end

	-- GATE_ENABLED is false this round; the live-faithful body is the TODO above.
	if (MeatlumpLadderDownMenuComponent.GATE_ENABLED) then
		-- TODO: require("managers.quest.journal") -- module is on another branch.
		-- Intended check:
		--   local pGhost = CreatureObject(pPlayer):getPlayerObject()
		--   if (not (Journal.done(pPlayer, "mtp_hideout_access_07") or Journal.done(pPlayer, "mtp_hideout_access_high_07") or (pGhost ~= nil and PlayerObject(pGhost):isPrivileged()))) then
		--     CreatureObject(pPlayer):sendSystemMessage("You are unable to descend.") -- OURS, NOT SOURCED (SOE key elevator_text:mtp_unable_to_descend does not ship)
		--     return 0
		--   end
	end

	local pMain = getSceneObject(MeatlumpHideoutScreenPlay.MAIN_ID)

	if (pMain == nil) then
		-- OURS, NOT SOURCED (SOE key elevator_text:mtp_no_hideout does not ship)
		CreatureObject(pPlayer):sendSystemMessage("The hideout cannot be reached.")
		return 0
	end

	local pCell = BuildingObject(pMain):getNamedCell("rightguardroom")

	if (pCell == nil) then
		-- OURS, NOT SOURCED (SOE key elevator_text:mtp_no_target_cell does not ship)
		CreatureObject(pPlayer):sendSystemMessage("The hideout cannot be reached.")
		return 0
	end

	local player = CreatureObject(pPlayer)

	if (player:isRidingMount()) then
		player:dismount()
	end

	-- SOE mtp_hideout_entrance_ladder.java:43-44
	SceneObject(pPlayer):playEffect("clienteffect/elevator_descend.cef", "")
	SceneObject(pPlayer):switchZone("corellia", -577.3, -46.0, -4337.4, SceneObject(pCell):getObjectID())

	return 0
end
