--[[
	ep3_rodian_hunter_1

	ruling 2026-09-04

	SOURCE: quest/ep3_rodian_hunter_1.qst.

	THE TASK TREE
		task 0  Go to Location   kashyyyk (-606, 15, 395) Radius 2
		                         "Talk to the Wookiee Benefactor"

	Proximity uses spawnActiveArea / ENTEREDAREA (map_exploration.lua shape).

	OPEN: the Wookiee shaman named by the journal is not this arc. The Go to
	Location still completes on proximity. The hunter_2 grant is gated on
	ep3_wookiee_benefactor_2; defined by the arc that owns
	ep3_wookiee_benefactor_2 (see ep3_rodian_hunter_conv_handler).

	COMPLETE_WHEN_TASKS_COMPLETE 1. No credits in the .qst. ALLOW_REPEATS 0.
	Questlist has no LEVEL/TIER: XP passthrough 0.

	Giver ep3_rodian_hunter has no buildout row. OPEN: not placed.

	OPEN: no shipped quest stf for ep3_rodian_hunter_1. No system-message keys sent.

	NO JOURNAL: do not call the journal engine. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: no LEVEL/TIER. See rodian_quest_xp.lua.
]]

rodianHunter1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "rodianHunter1ScreenPlay",
	repeatable = false,
	locX = -606,
	locZ = 15,
	locY = 395,
	locRadius = 2,
}

registerScreenPlay("rodianHunter1ScreenPlay", true)

function rodianHunter1ScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnArea()
	end
end

function rodianHunter1ScreenPlay:spawnArea()
	local z = getWorldFloor(self.locX, self.locY, "kashyyyk")

	if (z == nil or z == 0) then
		z = self.locZ
	end

	local pArea = spawnActiveArea("kashyyyk", "object/active_area.iff", self.locX, z, self.locY, self.locRadius, 0)

	if (pArea ~= nil) then
		createObserver(ENTEREDAREA, "rodianHunter1ScreenPlay", "notifyEnteredArea", pArea)
	end
end

function rodianHunter1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function rodianHunter1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function rodianHunter1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function rodianHunter1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function rodianHunter1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:setStage(pPlayer, 0)
end

function rodianHunter1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")

	return true
end

function rodianHunter1ScreenPlay:notifyEnteredArea(pArea, pPlayer)
	if (pArea == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 1) then
		return 0
	end

	KashyyykQuestXp:award(pPlayer, "ep3_rodian_hunter_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:setStage(pPlayer, 0)

	return 0
end
