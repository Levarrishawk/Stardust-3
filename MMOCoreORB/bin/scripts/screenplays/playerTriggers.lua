local KashyyykQuestJournal = require("screenplays.kashyyyk.quest.kashyyyk_quest_journal")

PlayerTriggers = { }

function PlayerTriggers:playerLoggedIn(pPlayer)
	if (pPlayer == nil) then
		return
	end
	ServerEventAutomation:playerLoggedIn(pPlayer)
	BestineElection:playerLoggedIn(pPlayer)
	MissionJournal:onPlayerLoggedIn(pPlayer)
	KashyyykQuestJournal.playerLoggedIn(pPlayer)
	for _, name in ipairs({"trandoBoshazZssik02ScreenPlay", "trandoSsiksikScreenPlay", "slaverGursanEntryQuestScreenPlay"}) do
		if (_G[name] ~= nil) then _G[name]:playerLoggedIn(pPlayer) end
	end
	ElysiumGuardian:playerLoggedIn(pPlayer)
end

function PlayerTriggers:playerLoggedOut(pPlayer)
	if (pPlayer == nil) then
		return
	end
	ServerEventAutomation:playerLoggedOut(pPlayer)
end
