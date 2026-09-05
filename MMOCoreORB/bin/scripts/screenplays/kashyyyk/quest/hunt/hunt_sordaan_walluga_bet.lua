--[[
	journal_entry_title  --  ep3_hunt_sordaan_walluga_bet

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_sordaan_walluga_bet.qst and string/en/quest/ground/ep3_hunt_sordaan_walluga_bet.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 5  d1  Wait for Signal  sordaan_wallugaGoToBocctyyy  signal sordaan_wallugaGoToBocctyyy
		task 2  d2  Timer  timer 1200-1209
		task 3  d3  Wait for Signal  sordaan_wallugaBetLost  signal sordaan_wallugaBetLost
		task 6  d4  Immediately Clear Quest
		task 1  d2  Destroy Multiple  sordaan_wallugaBet  Target ep3_etyyy_walluga_frenzied  Count 20
		task 4  d3  Wait for Signal  sordaan_wallugaBetWon  signal sordaan_wallugaBetWon
		task 7  d4  Immediately Complete Quest

	OPEN: pvpBitmask NONE on walluga; observer still matches
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

	XP: quest_experience[48][TIER_-1] = 0. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntSordaanWallugaBetScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntSordaanWallugaBetScreenPlay",
	questKey = "ep3_hunt_sordaan_walluga_bet",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 20,
	lootDropPercent = 0,
	killStage = 2,
	maxStage = 4,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 1200,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = { "walluga" },
	taskStages = { sordaan_wallugaGoToBocctyyy = 1,
		sordaan_wallugaBet = 2,
		sordaan_wallugaBetWon = 3,
		sordaan_wallugaBetLost = 4 },
}

registerScreenPlay("huntSordaanWallugaBetScreenPlay", true)

function huntSordaanWallugaBetScreenPlay:start()
end

function huntSordaanWallugaBetScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntSordaanWallugaBetScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntSordaanWallugaBetScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntSordaanWallugaBetScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntSordaanWallugaBetScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntSordaanWallugaBetScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntSordaanWallugaBetScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntSordaanWallugaBetScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntSordaanWallugaBetScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntSordaanWallugaBetScreenPlay:getKills(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0
end

function huntSordaanWallugaBetScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end
	return false
end

function huntSordaanWallugaBetScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "huntSordaanWallugaBetScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function huntSordaanWallugaBetScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "huntSordaanWallugaBetScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function huntSordaanWallugaBetScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function huntSordaanWallugaBetScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_sordaan_walluga_bet:journal_entry_title")
	return true
end

function huntSordaanWallugaBetScreenPlay:signalGo(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end
	self:setStage(pPlayer, 2)
	self:attachKillObserver(pPlayer)
	createEvent(self.timerSeconds * 1000, "huntSordaanWallugaBetScreenPlay", "notifyTimer", pPlayer, "")
	return true
end

function huntSordaanWallugaBetScreenPlay:notifyTimer(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return
	end
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 4)
	EtyyyHuntState:setCanDoBanol(pPlayer, true)
	huntSordaanWallugaBetLostScreenPlay:grantQuest(pPlayer)
end

function huntSordaanWallugaBetScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
		huntSordaanWallugaBetWonScreenPlay:grantQuest(pPlayer)
	end
	return 0
end

function huntSordaanWallugaBetScreenPlay:signalWin(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end
	EtyyyHuntState:raiseBetLevel(pPlayer, 2)
	KashyyykQuestXp:award(pPlayer, self.questKey)
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	huntSordaanWallugaBetWonScreenPlay:clearQuest(pPlayer)
	self:clearQuest(pPlayer)
	return true
end

function huntSordaanWallugaBetScreenPlay:signalLose(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 4) then
		return false
	end
	EtyyyHuntState:setCanDoBanol(pPlayer, true)
	huntSordaanWallugaBetLostScreenPlay:clearQuest(pPlayer)
	self:clearQuest(pPlayer)
	return true
end
