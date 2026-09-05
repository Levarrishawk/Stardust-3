--[[
	Find Missing Son  --  ep3_kachirho_missing_son

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	SOURCE: quest/ep3_kachirho_missing_son.qst and string/en/quest/ground/ep3_kachirho_missing_son.stf.

	THE TASK TREE
		task 0  Wait for Signal            takookTale  -- recorder Comm Player / takook_comm
		task 2  Destroy Multiple and Loot  CreatureType ep3_lobarorr -> ep3_kachirho_lobarorr,
		                                   LootItemName "Spear of Chatook", LootDropPercent 100
		task 3  Wait for Signal            tellSadTaleChatook  -- conversation turn-in
		task 4  Reward                     Bank Credits 2500,
		                                   Item object/weapon/melee/polearm/lance_kashyyk.iff

	OPEN: ep3_kachirho_lobarorr ships pvpBitmask NONE, so the kill cannot land until a
	later round makes him attackable. Observer still matches that template. Lobarorr is
	not spawned here (no buildout row in the giver dump).

	"Spear of Chatook" has no object template; tracked as a loot flag (glyph_hunt shape).

	Giver ep3_kachirho_chatook already stands via kashyyyk_static_npcs.lua. Not spawned here.

	NO JOURNAL: do not call Journal.*. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: quest_experience[60][TIER_4] = 62139. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
]]

kachirhoMissingSonScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "kachirhoMissingSonScreenPlay",
	repeatable = true,
	killTemplate = "ep3_kachirho_lobarorr",
	lootDropPercent = 100,
	rewardCredits = 2500,
	rewardItem = "object/weapon/melee/polearm/lance_kashyyk.iff",
}

registerScreenPlay("kachirhoMissingSonScreenPlay", true)

function kachirhoMissingSonScreenPlay:start()
end

function kachirhoMissingSonScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kachirhoMissingSonScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function kachirhoMissingSonScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function kachirhoMissingSonScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function kachirhoMissingSonScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "spear")
	self:setStage(pPlayer, 0)
end

function kachirhoMissingSonScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_wookiee_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_missing_son:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_missing_son:task00_journal_entry_title")

	return true
end

-- Raised by the Takook recorder (takook_comm) when the player uses it.
function kachirhoMissingSonScreenPlay:signalTakookTale(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	self:setStage(pPlayer, 2)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_missing_son:task01_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_missing_son:task01_journal_entry_description")

	return true
end

function kachirhoMissingSonScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 3) then
		return false
	end

	KashyyykQuestXp:award(pPlayer, "ep3_kachirho_missing_son")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_wookiee_quest_sucess.snd")

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory ~= nil) then
		giveItem(pInventory, self.rewardItem, -1, true)
	end

	self:clearQuest(pPlayer)

	return true
end

function kachirhoMissingSonScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "kachirhoMissingSonScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function kachirhoMissingSonScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "kachirhoMissingSonScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function kachirhoMissingSonScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 2) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate ~= self.killTemplate) then
		return 0
	end

	if (getRandomNumber(100) > self.lootDropPercent) then
		return 0
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "spear", "1")
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 3)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_missing_son:task02_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_missing_son:task02_journal_entry_description")

	return 0
end
