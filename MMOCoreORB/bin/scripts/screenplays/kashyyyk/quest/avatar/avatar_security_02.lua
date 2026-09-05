--[[
	ep3_avatar_security_02

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_avatar_security_02.qst. No quest stf ships for this
	name (strings-avatar.json has no ep3_avatar_security_02.stf). Questlist row
	is the short header (no LEVEL/TIER).

	THE TASK TREE
		task 0  Destroy Multiple and Loot  NumberItemsRequired 1, LootDropPercent 100
		                                   (no CreatureType, no LootItemName)
		task 1  Wait for Signal            techhall01_unlocked  -- taskName keySecurity02

	OPEN: no grant site in conversation java or the 45 theme-park scripts.
	OPEN: no CreatureType and no LootItemName. Loot flag still used (chunk shape).
	OPEN: no journal titles. No system-message keys to send.
	signal techhall01_unlocked is consumed here; no raise site in this arc.

	NO JOURNAL: the journal engine is not in this tree. The client already
	ships quest/ep3_avatar_security_02.qst. Do not call the journal API.

	XP: no LEVEL/TIER; passthrough of stored 0. See avatar_quest_xp.lua.
]]

avatarSecurity02ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "avatarSecurity02ScreenPlay",
	repeatable = true,
	lootDropPercent = 100,
	killTemplates = {
		-- OPEN: no CreatureType
	},
}

registerScreenPlay("avatarSecurity02ScreenPlay", true)

function avatarSecurity02ScreenPlay:start()
end

function avatarSecurity02ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function avatarSecurity02ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function avatarSecurity02ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function avatarSecurity02ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function avatarSecurity02ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "passcard")
	self:setStage(pPlayer, 0)
end

function avatarSecurity02ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)

	return true
end

function avatarSecurity02ScreenPlay:isKillTemplate(name)
	for i = 1, #self.killTemplates do
		if (self.killTemplates[i] == name) then
			return true
		end
	end

	return false
end

function avatarSecurity02ScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "avatarSecurity02ScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function avatarSecurity02ScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "avatarSecurity02ScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function avatarSecurity02ScreenPlay:notifyKilledCreature(pPlayer, pVictim)
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

	self:signalLootedPasscard(pPlayer)

	return 0
end

function avatarSecurity02ScreenPlay:signalLootedPasscard(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	writeScreenPlayData(pPlayer, self.screenplayName, "passcard", "1")
	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 2)

	return true
end

-- Raised under the SOE name techhall01_unlocked. No raise site in this arc.
function avatarSecurity02ScreenPlay:signalTechhall01Unlocked(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 2) then
		return false
	end

	KashyyykAvatarQuestXp:award(pPlayer, "ep3_avatar_security_02")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

	return true
end
