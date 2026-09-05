--[[
	Radial on meatlump_hideout_map_location.iff.

	ruling 2026-09-04

	SOURCED: grant_map_quest_object -- SUI yes/no, then grant the objvar quest_string.
	Hub-placed objects have no objectMenuComponent (template not edited).
	MtpWebGivers attaches this component at start.
]]

MtpMapQuestMenuComponent = {}

MtpMapQuestMenuComponent.OFFER_TITLE = "@quest/ground/mtp_map_quest_corellia_01:journal_entry_title" -- per-object override below
MtpMapQuestMenuComponent.ALREADY = "@theme_park/meatlump/mtp:you_already_have_quest" -- shipped grant_map_quest_object; stf may be thin

function MtpMapQuestMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@quest/ground/mtp_map_quest_corellia_01:task02_journal_entry_title")
end

function MtpMapQuestMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	if (CreatureObject(pPlayer):isInCombat()) then
		CreatureObject(pPlayer):sendSystemMessage("@spam:not_in_combat")
		return 0
	end

	local questName = readStringData(SceneObject(pSceneObject):getObjectID() .. ":mtpMapQuest")

	if (questName == nil or questName == "") then
		return 0
	end

	if (MtpQuestEngine.isQuestActiveOrComplete(pPlayer, questName)) then
		CreatureObject(pPlayer):sendSystemMessage("@theme_park/meatlump/mtp:you_already_have_quest")
		return 0
	end

	writeStringData(SceneObject(pPlayer):getObjectID() .. ":mtpMapOffer", questName)

	local sui = SuiMessageBox.new("MtpMapQuestMenuComponent", "notifyOffer")
	sui.setTitle("@quest/ground/" .. questName .. ":journal_entry_title")
	sui.setPrompt("@quest/ground/" .. questName .. ":journal_entry_description")
	sui.setOkButtonText("@ok")
	sui.setCancelButtonText("@cancel")
	sui.sendTo(pPlayer)
	return 0
end

function MtpMapQuestMenuComponent:notifyOffer(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed or pPlayer == nil) then
		return
	end

	local questName = readStringData(SceneObject(pPlayer):getObjectID() .. ":mtpMapOffer")
	deleteStringData(SceneObject(pPlayer):getObjectID() .. ":mtpMapOffer")

	if (questName == nil or questName == "") then
		return
	end

	MtpWebTasks.grant(pPlayer, questName)
end
