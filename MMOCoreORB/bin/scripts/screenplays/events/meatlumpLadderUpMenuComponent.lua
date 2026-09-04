MeatlumpLadderUpMenuComponent = {}

function MeatlumpLadderUpMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	-- OURS, NOT SOURCED (SOE key elevator_text:mtp_ladder_climb_up does not ship)
	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "Climb up")
end

function MeatlumpLadderUpMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 6)) then
		CreatureObject(pPlayer):sendSystemMessage("@elevator_text:too_far")
		return 0
	end

	-- Exit ladder is ungated in SOE (mtp_hideout_exit_ladder.java).
	local pEntrance = getSceneObject(MeatlumpHideoutScreenPlay.ENTRANCE_ID)

	if (pEntrance == nil) then
		-- OURS, NOT SOURCED (SOE key elevator_text:mtp_no_entrance does not ship)
		CreatureObject(pPlayer):sendSystemMessage("The entrance cannot be reached.")
		return 0
	end

	local pCell = BuildingObject(pEntrance):getNamedCell("bunker")

	if (pCell == nil) then
		-- OURS, NOT SOURCED (SOE key elevator_text:mtp_no_target_cell does not ship)
		CreatureObject(pPlayer):sendSystemMessage("The entrance cannot be reached.")
		return 0
	end

	local player = CreatureObject(pPlayer)

	if (player:isRidingMount()) then
		player:dismount()
	end

	-- SOE mtp_hideout_exit_ladder.java:36-37
	SceneObject(pPlayer):playEffect("clienteffect/elevator_rise.cef", "")
	SceneObject(pPlayer):switchZone("corellia", -515.0, 7.3, -4422.3, SceneObject(pCell):getObjectID())

	return 0
end
