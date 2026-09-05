--[[
	@quest/ground/ep3_trando_harwakokok_zssik_09:journal_entry_title  --  ep3_trando_harwakokok_zssik_09

	ruling 2026-09-04

	SOURCE: quest/ep3_trando_harwakokok_zssik_09.qst and string/en/quest/ground/ep3_trando_harwakokok_zssik_09.stf.

	THE TASK TREE
		task 0  Destroy Multiple and Loot  Scratch One Head
		task 1  Wait for Signal  Return to Harwakokok

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	XP: quest_experience[82][TIER_3] = 110902. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
	ALLOW_REPEATS 1.
]]

trandoHarwakokokZssik09ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoHarwakokokZssik09ScreenPlay",
	repeatable = true,
	turnInStage = 2,
	killCount = 1,
	lootDropPercent = 100,
	killTemplates = {
		"minstyngar",
	},
}

registerScreenPlay("trandoHarwakokokZssik09ScreenPlay", true)

function trandoHarwakokokZssik09ScreenPlay:start()
end

function trandoHarwakokokZssik09ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoHarwakokokZssik09ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoHarwakokokZssik09ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoHarwakokokZssik09ScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoHarwakokokZssik09ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoHarwakokokZssik09ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function trandoHarwakokokZssik09ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_harwakokok_zssik_09:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_harwakokok_zssik_09:task00_journal_entry_title")
	self:attachKillObserver(pPlayer)

	return true
end

function trandoHarwakokokZssik09ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function trandoHarwakokokZssik09ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "trandoHarwakokokZssik09ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function trandoHarwakokokZssik09ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "trandoHarwakokokZssik09ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function trandoHarwakokokZssik09ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 1) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate == nil or not self:isKillTemplate(victimTemplate)) then
		return 0
	end

	if (self.lootDropPercent ~= nil and getRandomNumber(100) > self.lootDropPercent) then
		return 0
	end

	local n = (tonumber(readScreenPlayData(pPlayer, self.screenplayName, "kills")) or 0) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "kills", tostring(n))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_harwakokok_zssik_09:task00_journal_entry_title")

	if (n >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_harwakokok_zssik_09:task01_journal_entry_title")
	end

	return 0
end

function trandoHarwakokokZssik09ScreenPlay:signalCompletedHarwakokok(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)
	return true
end

function trandoHarwakokokZssik09ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_trando_harwakokok_zssik_09")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):playMusicMessage("sound/mus_trandoshan_quest_sucess.snd")
	self:clearQuest(pPlayer)
end
