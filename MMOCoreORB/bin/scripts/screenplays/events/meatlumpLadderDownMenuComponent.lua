MeatlumpLadderDownMenuComponent = {}

-- SOE mtp_hideout_entrance_ladder.java:30 gated on completed
-- mtp_hideout_access_07 or mtp_hideout_access_high_07 or god. Part 1 ships
-- the hideout gated on _07 / _high_07 screenplay state.
MeatlumpLadderDownMenuComponent.GATE_ENABLED = true
-- Gate uses MtpQuestEngine screenplay state (no Journal.* on this branch).

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

	-- GATE_ENABLED: screenplay state of _07 / _high_07 (no Journal.* on this branch).
	if (MeatlumpLadderDownMenuComponent.GATE_ENABLED) then
		local pGhost = CreatureObject(pPlayer):getPlayerObject()
		local done = MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_07") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_07")
		local priv = pGhost ~= nil and PlayerObject(pGhost):isPrivileged()

		if (not (done or priv)) then
			-- OURS, NOT SOURCED (SOE key elevator_text:mtp_unable_to_descend does not ship)
			CreatureObject(pPlayer):sendSystemMessage("You are unable to descend.")
			return 0
		end
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
