--[[
	journal_entry_title  --  ep3_hunt_sordaan_uller_bet

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_sordaan_uller_bet.qst and string/en/quest/ground/ep3_hunt_sordaan_uller_bet.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 5  d1  Wait for Signal  sordaan_ullerGoToBocctyyy  signal sordaan_ullerGoToBocctyyy
		task 2  d2  Timer  timer 1200-1209
		task 3  d3  Wait for Signal  sordaan_ullerBetLost  signal sordaan_ullerBetLost
		task 6  d4  Immediately Clear Quest
		task 1  d2  Destroy Multiple  sordaan_ullerBet  Target ep3_etyyy_uller_warhoof  Count 24
		task 4  d3  Wait for Signal  sordaan_ullerBetWon  signal sordaan_ullerBetWon
		task 7  d4  Immediately Complete Quest

	Bocctyyy contract (ruling 2026-09-04): the dungeon calls
		EtyyyHuntState:raise(pPlayer, "sordaan_ullerGoToBocctyyy") and reads
		readScreenPlayData(pPlayer, "huntSordaanUllerBetScreenPlay", "stage").
		Same signals and stage keys for the other three bets:
		sordaan_wallugaGoToBocctyyy / huntSordaanWallugaBetScreenPlay
		sordaan_moufGoToBocctyyy / huntSordaanMoufBetScreenPlay
		sordaan_webweaverGoToBocctyyy / huntSordaanWebweaverBetScreenPlay
		Grant leaves stage 1. Timer and kill observer start only when that
		signal arrives through EtyyyHuntState:raise.
	OPEN: Bocctyyy path ticket / space_dungeon.KASH_THE_BET is not in this tree.
	OPEN: KashyyykIslands / BocctyyyTheBet are loaded by the dungeons branch;
		this branch does not include them. Pilot travel is guarded until merge.
	OPEN: Timer is createEvent on Min Time seconds; win path is kill count, lose path is the timer.

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[47][TIER_-1] = 0. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntSordaanUllerBetScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntSordaanUllerBetScreenPlay",
	questKey = "ep3_hunt_sordaan_uller_bet",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 24,
	lootDropPercent = 0,
	killStage = 2,
	maxStage = 4,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 1200,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = { "uller_stoneclaw" },
	taskStages = { sordaan_ullerGoToBocctyyy = 1,
		sordaan_ullerBet = 2,
		sordaan_ullerBetWon = 3,
		sordaan_ullerBetLost = 4 },
}

registerScreenPlay("huntSordaanUllerBetScreenPlay", true)

function huntSordaanUllerBetScreenPlay:start()
end

function huntSordaanUllerBetScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntSordaanUllerBetScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntSordaanUllerBetScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntSordaanUllerBetScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntSordaanUllerBetScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntSordaanUllerBetScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntSordaanUllerBetScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntSordaanUllerBetScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntSordaanUllerBetScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntSordaanUllerBetScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function huntSordaanUllerBetScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function huntSordaanUllerBetScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "huntSordaanUllerBetScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function huntSordaanUllerBetScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "huntSordaanUllerBetScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function huntSordaanUllerBetScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function huntSordaanUllerBetScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_sordaan_uller_bet:journal_entry_title")
	return true
end

function huntSordaanUllerBetScreenPlay:signalGo(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:setStage(pPlayer, 2)
	self:attachKillObserver(pPlayer)
	createEvent(self.timerSeconds * 1000, "huntSordaanUllerBetScreenPlay", "notifyTimer", pPlayer, "")
	return true
end

function huntSordaanUllerBetScreenPlay:notifyTimer(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return
	end
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 4)
	EtyyyHuntState:setCanDoBanol(pPlayer, true)
	huntSordaanUllerBetLostScreenPlay:grantQuest(pPlayer)
end

function huntSordaanUllerBetScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end
	if (self:getStage(pPlayer) ~= 2) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end
	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()
	if (victimTemplate == nil or not self:isKillTemplate(victimTemplate)) then
		return 0
	end
	local kills = self:getKills(pPlayer) + 1
	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(kills))
	if (kills >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 3)
		huntSordaanUllerBetWonScreenPlay:grantQuest(pPlayer)
	end
	return 0
end

function huntSordaanUllerBetScreenPlay:signalWin(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end
	EtyyyHuntState:raiseBetLevel(pPlayer, 1)
	KashyyykQuestXp:award(pPlayer, self.questKey)
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	huntSordaanUllerBetWonScreenPlay:clearQuest(pPlayer)
	self:clearQuest(pPlayer)
	return true
end

function huntSordaanUllerBetScreenPlay:signalLose(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 4) then
		return false
	end
	EtyyyHuntState:setCanDoBanol(pPlayer, true)
	huntSordaanUllerBetLostScreenPlay:clearQuest(pPlayer)
	self:clearQuest(pPlayer)
	return true
end
