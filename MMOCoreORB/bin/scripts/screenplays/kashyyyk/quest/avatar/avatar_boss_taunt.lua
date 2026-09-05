--[[
	A Message From Harwakokok  --  ep3_avatar_boss_taunt

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOURCE: quest/ep3_avatar_boss_taunt.qst and string/en/quest/ground/ep3_avatar_boss_taunt.stf.

	THE TASK TREE
		task 0  Comm Player   NPC Appearance object/mobile/ep3/ep3_harwakokok_mighty.iff
		                      Comm Message Text is task00_comm_message_text
		                      taskName harwakokokTaunt

	Grant site is theme_park avatar_boss_fight_spawn: every player in the
	building receives grantQuest("ep3_avatar_boss_taunt") when the command-deck
	fight starts. completeWhenTasksComplete is true, so the comm is the whole quest.

	Comm Player is implemented as system messages from the shipped keys (takook_comm
	shape). The appearance iff exists (ep3_harwakokok_mighty). Not spawned here.

	NO JOURNAL: the journal engine is not in this tree. The client already
	ships quest/ep3_avatar_boss_taunt.qst. Do not call the journal API.

	XP: no LEVEL/TIER; passthrough of stored 0. See avatar_quest_xp.lua.
]]

avatarBossTauntScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "avatarBossTauntScreenPlay",
	repeatable = true,
}

registerScreenPlay("avatarBossTauntScreenPlay", true)

function avatarBossTauntScreenPlay:start()
end

function avatarBossTauntScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function avatarBossTauntScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function avatarBossTauntScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function avatarBossTauntScreenPlay:grantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_boss_taunt:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_avatar_boss_taunt:task00_comm_message_text")
	KashyyykAvatarQuestXp:award(pPlayer, "ep3_avatar_boss_taunt")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:setStage(pPlayer, 0)

	return true
end
