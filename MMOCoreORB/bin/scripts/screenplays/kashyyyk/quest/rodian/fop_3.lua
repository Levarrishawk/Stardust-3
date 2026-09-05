--[[
	ep3_rodian_fop_3

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_fop_3.qst and the matching quest stf.

	THE TASK TREE
		task 0  Go to Location   kashyyyk (-516, 4, 383) Radius 10.0

	Proximity uses spawnActiveArea / ENTEREDAREA (map_exploration.lua shape).

	COMPLETE_WHEN_TASKS_COMPLETE 1: XP fires on arrival. No credits in the .qst.
	ALLOW_REPEATS 0.

	Giver ep3_rodian_fop has no buildout row. OPEN: not placed.

	NO JOURNAL: do not call the journal engine. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: quest_experience[28][TIER_1] = 165. See rodian_quest_xp.lua.
]]

rodianFop3ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianFop3ScreenPlay",
	repeatable = false,
	locX = -516,
	locZ = 4,
	locY = 383,
	locRadius = 10,
}

registerScreenPlay("rodianFop3ScreenPlay", true)

function rodianFop3ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnArea()
	end
end

function rodianFop3ScreenPlay:spawnArea()
	local z = getWorldFloor(self.locX, self.locY, "kashyyyk")

	if (z == nil or z == 0) then
		z = self.locZ
	end

	local pArea = spawnActiveArea("kashyyyk", "object/active_area.iff", self.locX, z, self.locY, self.locRadius, 0)

	if (pArea ~= nil) then
		createObserver(ENTEREDAREA, "rodianFop3ScreenPlay", "notifyEnteredArea", pArea)
	end
end

function rodianFop3ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianFop3ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianFop3ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianFop3ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianFop3ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function rodianFop3ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_3:task00_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_rodian_fop_3:task00_journal_entry_description")

	return true
end

function rodianFop3ScreenPlay:notifyEnteredArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 1) then
		return 0
	end

	KashyyykQuestXp:award(pPlayer, "ep3_rodian_fop_3")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:setStage(pPlayer, 0)

	return 0
end
