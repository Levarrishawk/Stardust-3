--[[
	ep3_rodian_fop_1

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_fop_1.qst and the matching quest stf.

	THE TASK TREE (nested)
		task 3  Go to Location              kashyyyk (-516, 4, 383) Radius 12
		task 4  Destroy Multiple and Loot   CreatureType trandoshan_slaver,
		                                    LootItemName "Rodian Paystub",
		                                    NumberItemsRequired 3, LootDropPercent 100,
		                                    RewardCredits 25000

	Kill templates from the Kashyyyk lair headers (no look-alikes):
		ep3_npc_trandoshan_slavers / ep3_trandoshan_slavers -> ep3_trando_slaver

	"Rodian Paystub" has no object template; tracked as a per-player loot flag
	(varactyl_hunt.lua / glyph_hunt chunk shape).

	COMPLETE_WHEN_TASKS_COMPLETE 1: credits and XP fire when the loot count
	lands. No Wait for Signal in this .qst. ALLOW_REPEATS 0.

	Giver ep3_rodian_fop has no buildout row. OPEN: not placed. Conversation
	attaches to the repo template.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships quest/ep3_rodian_fop_1.qst; the journal row comes from the integration
	branch later. Do not call the journal engine.

	XP: quest_experience[28][TIER_3] = 10494. See rodian_quest_xp.lua.
]]

rodianFop1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianFop1ScreenPlay",
	repeatable = false,
	lootCount = 3,
	lootDropPercent = 100,
	rewardCredits = 25000,
	locX = -516,
	locZ = 4,
	locY = 383,
	locRadius = 12,
	killTemplates = {
		"ep3_trando_slaver",
	},
}

registerScreenPlay("rodianFop1ScreenPlay", true)

function rodianFop1ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnArea()
	end
end

function rodianFop1ScreenPlay:spawnArea()
	local z = getWorldFloor(self.locX, self.locY, "kashyyyk")

	if (z == nil or z == 0) then
		z = self.locZ
	end

	local pArea = spawnActiveArea("kashyyyk", "object/active_area.iff", self.locX, z, self.locY, self.locRadius, 0)

	if (pArea ~= nil) then
		createObserver(ENTEREDAREA, "rodianFop1ScreenPlay", "notifyEnteredArea", pArea)
	end
end

function rodianFop1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianFop1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianFop1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianFop1ScreenPlay:getLoot(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "paystubs")) or 0
end

function rodianFop1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianFop1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "paystubs")
	self:setStage(pPlayer, 0)
end

function rodianFop1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "paystubs")
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_1:task00_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_1:task00_journal_entry_description")

	return true
end

function rodianFop1ScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_rodian_fop_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "paystubs")
	self:setStage(pPlayer, 0)
end

function rodianFop1ScreenPlay:notifyEnteredArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 1) then
		return 0
	end

	self:setStage(pPlayer, 2)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_1:task01_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_1:task01_journal_entry_description")

	return 0
end

function rodianFop1ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function rodianFop1ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "rodianFop1ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function rodianFop1ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "rodianFop1ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function rodianFop1ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

	if (getRandomNumber(100) > self.lootDropPercent) then
		return 0
	end

	local loot = self:getLoot(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "paystubs", tostring(loot))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_1:task01_journal_entry_title")

	if (loot >= self.lootCount) then
		self:awardQuest(pPlayer)
	end

	return 0
end
