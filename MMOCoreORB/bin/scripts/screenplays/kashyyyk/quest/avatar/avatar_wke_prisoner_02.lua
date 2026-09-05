--[[
	Open Lockbox  --  ep3_avatar_wke_prisoner_02

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_avatar_wke_prisoner_02.qst and string/en/quest/ground/ep3_avatar_wke_prisoner_02.stf.

	THE TASK TREE
		task 1  Wait for Signal    lockBox02  -- avatar_lockbox_02 keypad 37986

	Grant site is theme_park avatar_wke_prisoner_02 handleFreedom.
	chat.chat THANKS / NO_QUEST from dungeon/avatar_platform.stf; not a
	conversation/*.java tree. No conv handler here.

	OPEN: giver creature ep3_avatar_wke_captive has no repo template (no
	look-alikes, not placed here). Lockbox keypad, credits, and
	object/weapon/ranged/carbine/ep3/carbine_wookiee_bowcaster.iff are dungeon loot.
	This screenplay consumes lockBox02.

	NO JOURNAL: the journal engine is not in this tree. The client already
	ships quest/ep3_avatar_wke_prisoner_02.qst. Do not call the journal API.

	XP: quest_experience[85][TIER_1] = 468. ALLOW_REPEATS 0. See avatar_quest_xp.lua.
]]

avatarWkePrisoner02ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "avatarWkePrisoner02ScreenPlay",
	repeatable = false,
}

registerScreenPlay("avatarWkePrisoner02ScreenPlay", true)

function avatarWkePrisoner02ScreenPlay:start()
end

function avatarWkePrisoner02ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function avatarWkePrisoner02ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function avatarWkePrisoner02ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function avatarWkePrisoner02ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function avatarWkePrisoner02ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function avatarWkePrisoner02ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_wookiee_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_wke_prisoner_02:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_wke_prisoner_02:task00_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_wke_prisoner_02:task00_journal_entry_description")

	return true
end

-- Raised by avatar_lockbox_02 under the SOE name lockBox02.
function avatarWkePrisoner02ScreenPlay:signalLockBox02(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	KashyyykAvatarQuestXp:award(pPlayer, "ep3_avatar_wke_prisoner_02")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:clearQuest(pPlayer)

	return true
end
