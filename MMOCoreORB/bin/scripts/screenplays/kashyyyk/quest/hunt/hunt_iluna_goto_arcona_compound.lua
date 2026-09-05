--[[
	journal_entry_title  --  ep3_hunt_iluna_goto_arcona_compound

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_hunt_iluna_goto_arcona_compound.qst and string/en/quest/ground/ep3_hunt_iluna_goto_arcona_compound.stf.

	THE TASK TREE
		task 0  d0  Nothing
		task 1  d1  Go to Location  iluna_goToArconaCamp
		task 2  d2  Wait for Signal  iluna_askAboutBrody  signal iluna_askAboutBrody

	OPEN: java names the Go to Location ep3_hunt_iluna_goto_arcona_camp; the shipped
		.qst is ep3_hunt_iluna_goto_arcona_compound. Implemented the shipped .qst.
	OPEN: .qst LocationZ is planet-local; spawn uses LocationZ - 3000 to match the
		Etyyy world transform used by the other hunting-grounds waypoints.

	Giver already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the matching quest/*.qst; the journal row comes from the
		integration branch later. Do not call the journal engine.

	XP: quest_experience[45][TIER_1] = 237. See kashyyyk_hunt_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

huntIlunaGotoArconaCompoundScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntIlunaGotoArconaCompoundScreenPlay",
	questKey = "ep3_hunt_iluna_goto_arcona_compound",
	repeatable = true,
	rewardCredits = 0,
	rewardItem = "",
	killCount = 0,
	lootDropPercent = 0,
	killStage = 0,
	maxStage = 2,
	clearOnFinish = false,
	autoAward = false,
	timerSeconds = 0,
	retrieveCount = 0,
	retrieveTemplate = "",
	killTemplates = {  },
	taskStages = { iluna_goToArconaCamp = 1,
		iluna_askAboutBrody = 2 },
}

registerScreenPlay("huntIlunaGotoArconaCompoundScreenPlay", true)

function huntIlunaGotoArconaCompoundScreenPlay:start()
end

function huntIlunaGotoArconaCompoundScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function huntIlunaGotoArconaCompoundScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function huntIlunaGotoArconaCompoundScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function huntIlunaGotoArconaCompoundScreenPlay:isQuestActive(pPlayer)
	return self:getStage(pPlayer) > 0
end

function huntIlunaGotoArconaCompoundScreenPlay:hasCompletedQuest(pPlayer)
	return self:getRuns(pPlayer) > 0
end

function huntIlunaGotoArconaCompoundScreenPlay:isTaskActive(pPlayer, taskName)
	local st = self.taskStages[taskName]
	if (st == nil) then
		return false
	end
	return self:getStage(pPlayer) == st
end

function huntIlunaGotoArconaCompoundScreenPlay:hasCompletedTask(pPlayer, taskName)
	if (self:hasCompletedQuest(pPlayer)) then
		return true
	end
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName)) == 1
end

function huntIlunaGotoArconaCompoundScreenPlay:markTask(pPlayer, taskName)
	if (taskName ~= nil and taskName ~= "") then
		writeScreenPlayData(pPlayer, self.screenplayName, "done_" .. taskName, "1")
	end
end

function huntIlunaGotoArconaCompoundScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end
	if (self:getStage(pPlayer) ~= 0) then
		return false
	end
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function huntIlunaGotoArconaCompoundScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function huntIlunaGotoArconaCompoundScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end
	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:spawnGoArea(pPlayer)
	if (self.maxStage == 1 and self.autoAward) then
		self:awardQuest(pPlayer)
		return true
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_hunt_iluna_goto_arcona_compound:journal_entry_title")
	return true
end

function huntIlunaGotoArconaCompoundScreenPlay:raiseSignal(pPlayer, signalName)
	if (pPlayer == nil or signalName == nil) then
		return false
	end
	local need = self.taskStages[signalName]
	if (need == nil) then
		-- some Wait-for-Signal tasks use a taskName distinct from the signal
		for name, st in pairs(self.taskStages) do
			if (name == signalName) then
				need = st
				break
			end
		end
	end
	if (need == nil or self:getStage(pPlayer) ~= need) then
		return false
	end
	self:markTask(pPlayer, signalName)
	local nxt = need + 1
	if (nxt > 2) then
		if (self.clearOnFinish) then
			self:clearQuest(pPlayer)
		else
			self:awardQuest(pPlayer)
		end
		return true
	end
	self:setStage(pPlayer, nxt)

	return true
end

function huntIlunaGotoArconaCompoundScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, self.questKey)
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	if (self.rewardCredits > 0) then
		CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	end
	if (self.rewardItem ~= nil and self.rewardItem ~= "") then
		local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")
		if (pInv ~= nil) then
			giveItem(pInv, self.rewardItem, -1)
		end
	end
	self:clearQuest(pPlayer)
end


function huntIlunaGotoArconaCompoundScreenPlay:spawnGoArea(pPlayer)
	if (pPlayer == nil) then
		return
	end
	local x, z, y, radius = -490, 37, 831 - 3000, 20
	local pArea = spawnActiveArea("kashyyyk", "object/active_area.iff", x, z, y, radius, 0)
	if (pArea ~= nil) then
		local aid = SceneObject(pArea):getObjectID()
		writeData(SceneObject(pPlayer):getObjectID() .. ":ilunaGoArea", aid)
		createObserver(ENTEREDAREA, "huntIlunaGotoArconaCompoundScreenPlay", "notifyEnteredGoArea", pArea)
	end
end

function huntIlunaGotoArconaCompoundScreenPlay:notifyEnteredGoArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end
	if (self:getStage(pPlayer) ~= 1) then
		return 0
	end
	self:markTask(pPlayer, "iluna_goToArconaCamp")
	self:setStage(pPlayer, 2)
	return 1
end
