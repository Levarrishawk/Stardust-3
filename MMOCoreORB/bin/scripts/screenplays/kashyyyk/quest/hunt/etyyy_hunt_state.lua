--[[
	Shared Etyyy hunt flags and signal bus.

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	NO JOURNAL: do not call the journal engine.
]]

EtyyyHuntState = {
	screenplayName = "EtyyyHuntState",
	spaceQuests = {
	{"delivery_no_pickup", "ep3_hunting_kerssoc_smuggle_goods"},
	{"escort", "ep3_hunting_kerssoc_supplies"},
	{"assassinate", "ep3_hunting_kerssoc_destroy_chiss_weapons"},
	{"recovery", "ep3_hunting_chrilooc_medical_supplies"},
	{"assassinate", "ep3_hunting_banol_destroy_tripps_goods"},
	{"recovery", "ep3_hunting_banol_capture_fordan"},
	{"rescue", "ep3_hunting_ziven_fordans_ship"},
	{"assassinate", "ep3_hunting_ziven_vs_sordaans_freighter_01"},
	{"assassinate", "ep3_hunting_ziven_vs_sordaans_freighter_02"},
	{"escort", "ep3_hunting_tripp_protect_shipment"},
	},
}

function EtyyyHuntState:betLevel(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "sordaanBetLevel")) or 0
end

function EtyyyHuntState:raiseBetLevel(pPlayer, level)
	if (self:betLevel(pPlayer) < level) then
		writeScreenPlayData(pPlayer, self.screenplayName, "sordaanBetLevel", tostring(level))
	end
end

function EtyyyHuntState:guessedWrong(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "guessedWrong")) == 1
end

function EtyyyHuntState:setGuessedWrong(pPlayer, v)
	if (v) then
		writeScreenPlayData(pPlayer, self.screenplayName, "guessedWrong", "1")
	else
		deleteScreenPlayData(pPlayer, self.screenplayName, "guessedWrong")
	end
end

function EtyyyHuntState:canDoBanol(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "canDoBanol")) == 1
end

function EtyyyHuntState:setCanDoBanol(pPlayer, v)
	if (v) then
		writeScreenPlayData(pPlayer, self.screenplayName, "canDoBanol", "1")
	end
end

function EtyyyHuntState:hasFunds(pPlayer, amount)
	if (pPlayer == nil) then
		return false
	end
	return (CreatureObject(pPlayer):getCashCredits() + CreatureObject(pPlayer):getBankCredits()) >= amount
end

function EtyyyHuntState:takeFunds(pPlayer, amount)
	if (pPlayer == nil or not self:hasFunds(pPlayer, amount)) then
		return false
	end
	local cash = CreatureObject(pPlayer):getCashCredits()
	if (cash >= amount) then
		CreatureObject(pPlayer):subtractCashCredits(amount)
		return true
	end
	CreatureObject(pPlayer):subtractCashCredits(cash)
	CreatureObject(pPlayer):subtractBankCredits(amount - cash)
	return true
end

function EtyyyHuntState:emoteWookieeConfusion(pPlayer, pNpc)
	if (pPlayer == nil) then
		return
	end
	-- OPEN: clienteffect voc_wookiee_med_4sec.cef / chat.thinkTo are not wired. Shipped think-text key.
	CreatureObject(pPlayer):sendSystemMessage("@ep3/sidequests:wke_convo_failure")
end

-- Java space_quest.hasQuest(player) with no type/name. SpaceHelpers:activateSpaceQuest
-- stores an active space quest as a datapad mission object (same check the Kashyyyk
-- station handlers use). Not the hunting-arc name list.
function EtyyyHuntState:hasAnySpaceQuest(pPlayer)
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

function EtyyyHuntState:hasAnySpaceHunt(pPlayer)
	return self:hasAnySpaceQuest(pPlayer)
end

function EtyyyHuntState:spaceFailed(pPlayer, questType, questName)
	if (SpaceHelpers:isSpaceQuestActive(pPlayer, questType, questName)) then
		return false
	end
	if (SpaceHelpers:isSpaceQuestComplete(pPlayer, questType, questName)) then
		return false
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "space_" .. questName)) == 1
end

function EtyyyHuntState:grantSpace(pPlayer, pNpc, screenplay, questType, questName)
	if (pPlayer == nil or screenplay == nil) then
		return false
	end
	writeScreenPlayData(pPlayer, self.screenplayName, "space_" .. questName, "1")
	screenplay:startQuest(pPlayer, pNpc)
	return SpaceHelpers:isSpaceQuestActive(pPlayer, questType, questName)
		or SpaceHelpers:isSpaceQuestComplete(pPlayer, questType, questName)
end

EtyyyHuntState.signalMap = EtyyyHuntState.signalMap or {}

function EtyyyHuntState:registerSignal(signalName, screenplay, method)
	if (self.signalMap[signalName] == nil) then
		self.signalMap[signalName] = {}
	end
	local rows = self.signalMap[signalName]
	for i = 1, #rows do
		if (rows[i].sp == screenplay and rows[i].fn == method) then
			return
		end
	end
	table.insert(rows, { sp = screenplay, fn = method })
end

function EtyyyHuntState:raise(pPlayer, signalName)
	if (pPlayer == nil or signalName == nil) then
		return false
	end
	local rows = self.signalMap[signalName]
	if (rows == nil) then
		return false
	end
	local any = false
	for i = 1, #rows do
		local fn = rows[i].sp[rows[i].fn]
		if (fn ~= nil) then
			if (fn(rows[i].sp, pPlayer, signalName)) then
				any = true
			end
		end
	end
	return any
end

function EtyyyHuntState:bindQuestSignals(screenplay)
	if (screenplay.taskStages == nil) then
		return
	end
	for name, _st in pairs(screenplay.taskStages) do
		self:registerSignal(name, screenplay, "raiseSignal")
	end
end

EtyyyHuntRetrieveMenuComponent = {}

function EtyyyHuntRetrieveMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end
	local spName = readStringData(SceneObject(pSceneObject):getObjectID() .. ":etyyyHuntRetrieve")
	if (spName == nil or spName == "") then
		return
	end
	local title = readStringData(SceneObject(pSceneObject):getObjectID() .. ":etyyyHuntRetrieveTitle")
	if (title == nil or title == "") then
		title = "@quest/ground/ep3_hunt_manfred_steal_chiss_goods:task02_journal_entry_title"
	end
	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, title)
end

function EtyyyHuntRetrieveMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end
	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end
	local spName = readStringData(SceneObject(pSceneObject):getObjectID() .. ":etyyyHuntRetrieve")
	local sp = _G[spName]
	if (sp ~= nil and sp.collectRetrieve ~= nil) then
		sp:collectRetrieve(pPlayer)
	end
	return 0
end

function EtyyyHuntState:bindAll()
	EtyyyHuntState:bindQuestSignals(huntKerssocEnterEtyyyScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntKerssocBanthaPeltsScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntKerssocKillChissPoachersScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntChriloocSeekRodiansScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntChriloocSeekRodians02ScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntChriloocSeekJohnsonScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntWrelaacProofOfMadaScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntWrelaacToChriloocScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntMadaJohnsonToWrelaacScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanUllerBetScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanUllerBetWonScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanUllerBetLostScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanWallugaBetScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanWallugaBetWonScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanWallugaBetLostScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanMoufBetScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanMoufBetWonScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanMoufBetLostScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanWebweaverBetScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanWebweaverBetWonScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanWebweaverBetLostScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanAllBetsRewardScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanSeekHarroomScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntSordaanSeekSordaanScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntZivenCollectWebweaverEyesScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntZivenCollectWebweaverFangsScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntManfredStealChissGoodsScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntManfredCollectEnhancementsScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntManfredKillChissLeaderScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntTrippCollectMoufPeltsScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntTrippCollectMoufIncisorsScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntEharttCollectWallugaClawsScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntHarroomUllerRewardScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntHarroomWallugaRewardScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntHarroomMoufRewardScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntHarroomWebweaverRewardScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntIlunaGotoArconaCompoundScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntHraccaKkorrwrotHuntScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntTuwezzCollectUllerHornsScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntTuwezzKillDiseasedUllersScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntJohnsonHelpKaraScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntJohnsonRetrieveRyoosStashScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntJohnsonSeekKintScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntJohnsonBrodyJohnsonScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntJerrolSeekJohnsonScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntLootBrightclawKilledScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntLootCompletedAllScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntLootGreyclimberKilledScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntLootPaleclawKilledScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntLootSilkthrowerKilledScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntLootSpiketopKilledScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntLootStonelegKilledScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntVritolRewardMountScreenPlay)
	EtyyyHuntState:bindQuestSignals(huntReward2000CreditsScreenPlay)
	self:registerSignal("hracca_kkorrwrotKilled", huntHraccaKkorrwrotHuntScreenPlay, "raiseSignal")
	self:registerSignal("sordaan_ullerGoToBocctyyy", huntSordaanUllerBetScreenPlay, "signalGo")
	self:registerSignal("sordaan_ullerBetWon", huntSordaanUllerBetScreenPlay, "signalWin")
	self:registerSignal("sordaan_ullerBetLost", huntSordaanUllerBetScreenPlay, "signalLose")
	self:registerSignal("sordaan_wallugaGoToBocctyyy", huntSordaanWallugaBetScreenPlay, "signalGo")
	self:registerSignal("sordaan_wallugaBetWon", huntSordaanWallugaBetScreenPlay, "signalWin")
	self:registerSignal("sordaan_wallugaBetLost", huntSordaanWallugaBetScreenPlay, "signalLose")
	self:registerSignal("sordaan_moufGoToBocctyyy", huntSordaanMoufBetScreenPlay, "signalGo")
	self:registerSignal("sordaan_moufBetWon", huntSordaanMoufBetScreenPlay, "signalWin")
	self:registerSignal("sordaan_moufBetLost", huntSordaanMoufBetScreenPlay, "signalLose")
	self:registerSignal("sordaan_webweaverGoToBocctyyy", huntSordaanWebweaverBetScreenPlay, "signalGo")
	self:registerSignal("sordaan_webweaverBetWon", huntSordaanWebweaverBetScreenPlay, "signalWin")
	self:registerSignal("sordaan_webweaverBetLost", huntSordaanWebweaverBetScreenPlay, "signalLose")
end
registerScreenPlay("EtyyyHuntState", true)

function EtyyyHuntState:start()
	self:bindAll()
end
