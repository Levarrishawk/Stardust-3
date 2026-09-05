--[[
	Quelling the Varactyl  --  ep3_kachirho_varactyl_hunt

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	SOURCE: quest/ep3_kachirho_varactyl_hunt.qst and string/en/quest/ground/ep3_kachirho_varactyl_hunt.stf.

	THE TASK TREE
		task 0  Destroy Multiple and Loot   Social Group kachirho_varactyl,
		                                    LootItemName "Varactyl Plumes",
		                                    NumberItemsRequired 8, LootDropPercent 100
		task 1  Wait for Signal             varactylReward  -- conversation turn-in
		task 2  Reward                      Bank Credits 8000

	Kill templates from the the lair headers (no look-alikes, not Jagged Fang):
		ep3_kachirho_varactyl            -> varactyl_deathspine
		ep3_kachirho_varactyl_preystalker -> varactyl_preystalker
		varactyl_stalker                 (repo kachirho varactyl, not the matriarch)

	"Varactyl Plumes" is a live static-item name with no object template; tracked as a
	kill/loot flag the same way glyph_hunt.lua tracks "Missing Chunk of Glyph".

	Journal text names the turn-in "Janno". The buildout giver is ep3_ortha_ledox,
	already standing via kashyyyk_static_npcs.lua. Quoted; not renamed.

	NO JOURNAL: do not call Journal.*. The client ships quest/ep3_kachirho_varactyl_hunt.qst;
	the journal row comes from the integration branch later.

	XP: quest_experience[28][TIER_1] = 165. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
]]

kachirhoVaractylHuntScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "kachirhoVaractylHuntScreenPlay",
	repeatable = false,
	killCount = 8,
	lootDropPercent = 100,
	rewardCredits = 8000,
	killTemplates = {
		"varactyl_deathspine",
		"varactyl_preystalker",
		"varactyl_stalker",
	},
}

registerScreenPlay("kachirhoVaractylHuntScreenPlay", true)

function kachirhoVaractylHuntScreenPlay:start()
end

function kachirhoVaractylHuntScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kachirhoVaractylHuntScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function kachirhoVaractylHuntScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function kachirhoVaractylHuntScreenPlay:getPlumes(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "plumes")) or 0
end

function kachirhoVaractylHuntScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	-- [list] ALLOW_REPEATS 0. Conversation still offers a repeat; grant refuses.
	return self.repeatable or self:getRuns(pPlayer) == 0
end

function kachirhoVaractylHuntScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "plumes")
	self:setStage(pPlayer, 0)
end

function kachirhoVaractylHuntScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, "plumes")
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_varactyl_hunt:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_varactyl_hunt:task00_journal_entry_title")

	return true
end

function kachirhoVaractylHuntScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

function kachirhoVaractylHuntScreenPlay:awardQuest(pPlayer)
	KashyyykQuestXp:award(pPlayer, "ep3_kachirho_varactyl_hunt")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "plumes")
	self:setStage(pPlayer, 0)
end

function kachirhoVaractylHuntScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function kachirhoVaractylHuntScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "kachirhoVaractylHuntScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function kachirhoVaractylHuntScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "kachirhoVaractylHuntScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function kachirhoVaractylHuntScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

	if (getRandomNumber(100) > self.lootDropPercent) then
		return 0
	end

	local plumes = self:getPlumes(pPlayer) + 1

	writeScreenPlayData(pPlayer, self.screenplayName, "plumes", tostring(plumes))
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_varactyl_hunt:task00_journal_entry_title")

	if (plumes >= self.killCount) then
		self:detachKillObserver(pPlayer)
		self:setStage(pPlayer, 2)
		CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_varactyl_hunt:task01_journal_entry_title")
	end

	return 0
end
