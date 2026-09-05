--[[
	ep3_slave_camp_control_room_access  --  ep3_slave_camp_control_room_access

	ruling 2026-09-04

	THE TASK TREE
		task 0  Destroy Multiple and Loot  Warden Tosk / ep3_slaver_blackscale_warden_tosk
		task 1  Wait for Signal  Power Room / signalSlaverDisableLocks

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	IFF MATCH (not a look-alike): creatures.tab:1567 maps
		ep3_slaver_blackscale_warden_tosk -> ep3/ep3_blackscale_warden_tosk.iff;
		repo template ep3_blackscale_warden_tosk.lua:30 uses that same iff.
		Grant starts on the Tosk kill (stage 1). signalSlaverDisableLocks is stage 2 only.

	OPEN:
		grant site is theme_park/dungeon/trando_slave_camp/door_signal.java (OnReceivedItem), not a conversation
		Pass Key is a loot-flag name with no object template
		signalSlaverDisableLocks is raised by power_terminal.java (dungeon)
	XP: quest_experience[86][TIER_1] = 473.
]]

slaveCampControlRoomAccessScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "slaveCampControlRoomAccessScreenPlay",
	repeatable = true,
	turnInStage = 2,
	killCount = 1,
	lootDropPercent = 100,
	killTemplates = {
		"ep3_blackscale_warden_tosk",
	},
}
registerScreenPlay("slaveCampControlRoomAccessScreenPlay", true)

function slaveCampControlRoomAccessScreenPlay:start()
end

function slaveCampControlRoomAccessScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function slaveCampControlRoomAccessScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function slaveCampControlRoomAccessScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function slaveCampControlRoomAccessScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function slaveCampControlRoomAccessScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function slaveCampControlRoomAccessScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function slaveCampControlRoomAccessScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "slaveCampControlRoomAccessScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function slaveCampControlRoomAccessScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "slaveCampControlRoomAccessScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function slaveCampControlRoomAccessScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slave_camp_control_room_access:task00_journal_entry_title")

	if (n >= self.killCount) then
		self:ToskDefeated(pPlayer)
	end

	return 0
end

function slaveCampControlRoomAccessScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function slaveCampControlRoomAccessScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slave_camp_control_room_access:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slave_camp_control_room_access:task00_journal_entry_title")
	return true
end

function slaveCampControlRoomAccessScreenPlay:ToskDefeated(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_slave_camp_control_room_access:task01_journal_entry_title")
	return true
end

function slaveCampControlRoomAccessScreenPlay:signalSlaverDisableLocks(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_slave_camp_control_room_access")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)
	return true
end
