--[[
	Varactyl Eggs  --  ep3_kachirho_varactyl_egg

	ruling 2026-09-04: "ensure kashyyyk is done in full"

	SOURCE: quest/ep3_kachirho_varactyl_egg.qst and string/en/quest/ground/ep3_kachirho_varactyl_egg.stf.

	THE TASK TREE
		task 0  Destroy Multiple   Count 1, Target Server Template ep3_kachirho_varactyl_jaggedfang
		                           -> repo varactyl_jagged_fang (the lair headers)
		task 1  Retrieve Item      object/tangible/quest/kachirho_varactyl_egg.iff
		task 2  Reward             Item object/tangible/loot/quest/ep3/varactyl_egg.iff  -- OPEN, no repo template

	Egg world position from kashyyyk_main row 2141 (wx=929.26, wz=249.92).
	Giver ep3_pirus_gue has no celebrity buildout row (row 2141 is the egg object).
	Placement OPEN -- not spawned here. Conversation is attached to the mobile template.

	NO JOURNAL: do not call Journal.*. The client ships the .qst; the journal row
	comes from the integration branch later.

	XP: quest_experience[55][TIER_4] = 50754. See kashyyyk_quest_xp.lua / mustafar_quest_xp.lua.
]]

kachirhoVaractylEggScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "kachirhoVaractylEggScreenPlay",
	repeatable = true,
	killTemplate = "varactyl_jagged_fang",
	eggTemplate = "object/tangible/quest/kachirho_varactyl_egg.iff",
	eggX = 929.26,
	eggZ = 8.74844,
	eggY = 249.92,
}

registerScreenPlay("kachirhoVaractylEggScreenPlay", true)

function kachirhoVaractylEggScreenPlay:start()
	if (isZoneEnabled("kashyyyk")) then
		self:spawnEgg()
	end
end

function kachirhoVaractylEggScreenPlay:spawnEgg()
	local z = getWorldFloor(self.eggX, self.eggY, "kashyyyk")

	if (z == nil or z == 0) then
		z = self.eggZ
	end

	local pEgg = spawnSceneObject("kashyyyk", self.eggTemplate, self.eggX, z, self.eggY, 0, 0)

	if (pEgg ~= nil) then
		SceneObject(pEgg):setObjectMenuComponent("KashVaractylEggMenuComponent")
	end
end

function kachirhoVaractylEggScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function kachirhoVaractylEggScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function kachirhoVaractylEggScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function kachirhoVaractylEggScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function kachirhoVaractylEggScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 0)
end

function kachirhoVaractylEggScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, 1)
	self:attachKillObserver(pPlayer)
	CreatureObject(pPlayer):playMusicMessage("sound/mus_rodian_quest_accept.snd")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_varactyl_egg:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_varactyl_egg:task00_journal_entry_title")

	return true
end

function kachirhoVaractylEggScreenPlay:awardQuest(pPlayer)
	-- Reward Item object/tangible/loot/quest/ep3/varactyl_egg.iff is OPEN: no repo template.
	KashyyykQuestXp:award(pPlayer, "ep3_kachirho_varactyl_egg")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	self:setStage(pPlayer, 0)
end

function kachirhoVaractylEggScreenPlay:attachKillObserver(pPlayer)
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "kachirhoVaractylEggScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function kachirhoVaractylEggScreenPlay:detachKillObserver(pPlayer)
	dropObserver(KILLEDCREATURE, "kachirhoVaractylEggScreenPlay", "notifyKilledCreature", pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
end

function kachirhoVaractylEggScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	if (self:getStage(pPlayer) ~= 1) then
		deleteScreenPlayData(pPlayer, self.screenplayName, "observer")
		return 1
	end

	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()

	if (victimTemplate ~= self.killTemplate) then
		return 0
	end

	self:detachKillObserver(pPlayer)
	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_varactyl_egg:task01_journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_kachirho_varactyl_egg:task01_journal_entry_description")

	return 0
end

function kachirhoVaractylEggScreenPlay:getRadialText(pPlayer)
	if (self:getStage(pPlayer) ~= 2) then
		return nil
	end

	return "@quest/ground/ep3_kachirho_varactyl_egg:task01_journal_entry_title"
end

function kachirhoVaractylEggScreenPlay:takeEgg(pPlayer)
	if (self:getRadialText(pPlayer) == nil) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end

KashVaractylEggMenuComponent = {}

function KashVaractylEggMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local text = kachirhoVaractylEggScreenPlay:getRadialText(pPlayer)

	if (text ~= nil) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, text)
	end
end

function KashVaractylEggMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	kachirhoVaractylEggScreenPlay:takeEgg(pPlayer)

	return 0
end
