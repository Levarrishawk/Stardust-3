--[[
	Myyydril signal bus. SOE sendSignal is named; several quests share a name.
	Each screenplay's signalTurnIn already checks stage, so a broadcast is safe.

	ruling 2026-09-04
	NO JOURNAL: do not call the journal API.

	Encounter contract (names on this bus, raised via MyyydrilSignals:raise):
		signalLornRetrieveCompleted -- grievous_player OnAttach; consumed here
		                            -- (myyydrilLornRetrieve6ScreenPlay:signalTurnIn).
		signalCompleteGrievousPrequest -- grievous_encounter_lock prequest complete;
		                               -- no consumer in this arc; still exposed.
]]

MyyydrilSignals = {}

function MyyydrilSignals:raise(pPlayer, name)
	self:send(pPlayer, name)
end

function MyyydrilSignals:signalLornRetrieveCompleted(pPlayer)
	self:send(pPlayer, "signalLornRetrieveCompleted")
end

function MyyydrilSignals:signalCompleteGrievousPrequest(pPlayer)
	self:send(pPlayer, "signalCompleteGrievousPrequest")
end

function MyyydrilSignals:send(pPlayer, name)
	if (pPlayer == nil or name == nil) then
		return
	end

	if (name == "giveLoot") then
		myyydrilAttieraEscort2ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "giveNeat") then
		myyydrilIsdanRetrieve5ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "giveStuff") then
		myyydrilKallaaracDestroy2ScreenPlay:signalTurnIn(pPlayer)
		myyydrilKallaaracRetrieve1ScreenPlay:signalTurnIn(pPlayer)
		myyydrilKallaaracDestroy3ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "talktotalaoree") then
		myyydrilKallaaracTalkto2ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "phatLewts") then
		myyydrilKinesworthyEpic1ScreenPlay:signalTurnIn(pPlayer)
		myyydrilKinesworthyEpic2ScreenPlay:signalTurnIn(pPlayer)
		myyydrilKinesworthyEpic3ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "giveReward") then
		myyydrilKirirrGather1ScreenPlay:signalTurnIn(pPlayer)
		myyydrilNawikaEscort1ScreenPlay:signalTurnIn(pPlayer)
		myyydrilTalaoreeDestroy1ScreenPlay:signalTurnIn(pPlayer)
		myyydrilYrakaDestroyloot1ScreenPlay:signalTurnIn(pPlayer)
		myyydrilYrakaRetrieve2ScreenPlay:signalTurnIn(pPlayer)
		myyydrilYrakaRetrieve3ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "talktonawika") then
		myyydrilKirrirTalkto4ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "talktokallaarac") then
		myyydrilKivvaaaTalkto1ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "signalLornRetrieveCompleted") then
		myyydrilLornRetrieve6ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "signalCompleteGrievousPrequest") then
	end

	if (name == "lorn") then
		myyydrilLornTalktoScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "talktochief") then
		myyydrilNawikaTalkto5ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "giveLewtSmug") then
		myyydrilPersRetrieve4ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "finddagger") then
		myyydrilRensalla1ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "giveSwords") then
		myyydrilTreeshCraft1ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "partsrule") then
		myyydrilYrakaEpic1ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "talktokines") then
		myyydrilYrakaTalkto6ScreenPlay:signalTurnIn(pPlayer)
	end

	if (name == "talktokirrir") then
		myyydrilTalaoreeTalkto3ScreenPlay:signalTurnIn(pPlayer)
	end

end
