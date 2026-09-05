--[[
	ep3_trando_hssissk_zssik_10  --  ep3_trando_hssissk_zssik_10

	ruling 2026-09-04

	THE TASK TREE
		task 0  Destroy Multiple and Loot  Collect the Guard ID Cards / ep3_avatar_blackscale_captain
		task 1  Destroy Multiple  Fall of the Mighty / ep3_avatar_harwakokok_mighty
		task 2  Wait for Signal  Destruction of the Avatar / avatarDestructSequence
		task 3  Wait for Signal  Return to Hssissk / rewardHssissk
		task 4  Reward  Reward Issued / 

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
		ships the .qst; the journal row comes from the integration branch later. Do not call the journal engine.

	OPEN:
		ep3_avatar_blackscale_captain has no lair map / repo template
		ep3_avatar_harwakokok_mighty has no lair map / repo template
		avatarDestructSequence is raised by avatar_platform terminal_main_console (dungeon, not this fence)
		reward item object/tangible/ship/components/weapon/wpn_vulcan_cannon.iff has no repo template
		ep3_trando_hssissk_zssik_10: ep3_avatar_harwakokok_mighty -- no lair map and no repo template
	XP: quest_experience[86][TIER_6] = 234317.
]]

trandoHssisskZssik10ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "trandoHssisskZssik10ScreenPlay",
	repeatable = true,
	turnInStage = 2,
}
registerScreenPlay("trandoHssisskZssik10ScreenPlay", true)

function trandoHssisskZssik10ScreenPlay:start()
end

function trandoHssisskZssik10ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function trandoHssisskZssik10ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function trandoHssisskZssik10ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function trandoHssisskZssik10ScreenPlay:isTurnIn(pPlayer)
	local stage = self:getStage(pPlayer)

	if (self.turnInStage == nil) then
		return stage > 0
	end

	return stage == self.turnInStage
end

function trandoHssisskZssik10ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function trandoHssisskZssik10ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "kills")
	self:setStage(pPlayer, 0)
end

function trandoHssisskZssik10ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_trando_hssissk_zssik_10:journal_entry_title")
	return true
end

function trandoHssisskZssik10ScreenPlay:attachKillObserver(pPlayer)
end

function trandoHssisskZssik10ScreenPlay:detachKillObserver(pPlayer)
end

function trandoHssisskZssik10ScreenPlay:signalAvatarDestructSequence(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	if (1 == 2) then
		KashyyykQuestXp:award(pPlayer, "ep3_trando_hssissk_zssik_10")
		writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
		self:clearQuest(pPlayer)
	else
		self:setStage(pPlayer, 2)
	end

	return true
end

function trandoHssisskZssik10ScreenPlay:signalRewardHssissk(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	if (2 == 2) then
		KashyyykQuestXp:award(pPlayer, "ep3_trando_hssissk_zssik_10")
		writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
		self:clearQuest(pPlayer)
	else
		self:setStage(pPlayer, 3)
	end

	return true
end
