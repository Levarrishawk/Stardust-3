--[[
	Nak'tra Crystals and Swords  --  ep3_myyydril_treesh_craft_1

	ruling 2026-09-04

	SOURCE: quest/ep3_myyydril_treesh_craft_1.qst and string/en/quest/ground/ep3_myyydril_treesh_craft_1.stf.

	THE TASK TREE
		task 1  Nothing  
			task 2  Craft Item  Count 5; Server Object Template object/weapon/melee/knife/ep3/knife_naktra_crystal.iff
			        title Nak'tra Crystals and Swords
				task 4  Wait for Signal  Signal Name giveSwords
					task 5  Reward  Bank Credits 6000
					        title Reward Issued

	Craft Item: accept 5 knife_naktra_crystal.iff on turn-in.

	OPEN: object/draft_schematic/weapon/knife_naktra_crystal_false.iff has no repo template; not granted.
	Credits and XP still award. Appearance schematic weapon_appearance_knife_naktra_crystal.iff is granted.

	Giver is not spawned here. Dungeon rows already stand via the POB populator, or are OPEN.

	NO JOURNAL: this branch has no managers/quest/journal.lua. The client already
	ships the .qst; the journal row comes from the integration branch later.
	Do not call the journal API.

	XP: quest_experience[1][TIER_4] = 149. See myyydril_quest_xp.lua.
	ALLOW_REPEATS 0.
]]
myyydrilTreeshCraft1ScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "myyydrilTreeshCraft1ScreenPlay",
	repeatable = false,
	rewardCredits = 6000,
	craftTemplate = "object/weapon/melee/knife/ep3/knife_naktra_crystal.iff",
	craftCount = 5,
}

registerScreenPlay("myyydrilTreeshCraft1ScreenPlay", true)

function myyydrilTreeshCraft1ScreenPlay:start()
end

function myyydrilTreeshCraft1ScreenPlay:getStage(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "stage")) or 0
end

function myyydrilTreeshCraft1ScreenPlay:setStage(pPlayer, stage)
	writeScreenPlayData(pPlayer, self.screenplayName, "stage", tostring(stage))
end

function myyydrilTreeshCraft1ScreenPlay:getRuns(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "runs")) or 0
end

function myyydrilTreeshCraft1ScreenPlay:getCount(pPlayer)
	return tonumber(readScreenPlayData(pPlayer, self.screenplayName, "count")) or 0
end

function myyydrilTreeshCraft1ScreenPlay:canGrantQuest(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return false
	end

	if (self:getStage(pPlayer) ~= 0) then
		return false
	end

	return self.repeatable or self:getRuns(pPlayer) == 0
end

function myyydrilTreeshCraft1ScreenPlay:clearQuest(pPlayer)
	if (pPlayer == nil) then
		return
	end

	self:detachKillObserver(pPlayer)
	deleteScreenPlayData(pPlayer, self.screenplayName, "count")
	deleteScreenPlayData(pPlayer, self.screenplayName, "loot")

	self:setStage(pPlayer, 0)
end

function myyydrilTreeshCraft1ScreenPlay:grantQuest(pPlayer)
	if (not self:canGrantQuest(pPlayer)) then
		return false
	end

	self:clearQuest(pPlayer)
	self:setStage(pPlayer, 1)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_treesh_craft_1:journal_entry_title")
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_treesh_craft_1:task00_journal_entry_title")

	return true
end

function myyydrilTreeshCraft1ScreenPlay:awardQuest(pPlayer)
	MyyydrilQuestXp:award(pPlayer, "ep3_myyydril_treesh_craft_1")
	writeScreenPlayData(pPlayer, self.screenplayName, "runs", tostring(self:getRuns(pPlayer) + 1))
	CreatureObject(pPlayer):addBankCredits(self.rewardCredits, true)
	self:clearQuest(pPlayer)

end

function myyydrilTreeshCraft1ScreenPlay:attachKillObserver(pPlayer)
end

function myyydrilTreeshCraft1ScreenPlay:detachKillObserver(pPlayer)
end

function myyydrilTreeshCraft1ScreenPlay:hasCrafted(pPlayer)
	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		return false
	end

	local n = 0
	local size = SceneObject(pInventory):getContainerObjectsSize()

	for i = 0, size - 1 do
		local pItem = SceneObject(pInventory):getContainerObject(i)

		if (pItem ~= nil and SceneObject(pItem):getTemplateObjectPath() == self.craftTemplate) then
			n = n + 1
		end
	end

	return n >= self.craftCount
end

function myyydrilTreeshCraft1ScreenPlay:tryAdvanceCraft(pPlayer)
	if (pPlayer == nil or self:getStage(pPlayer) ~= 1) then
		return false
	end

	if (not self:hasCrafted(pPlayer)) then
		return false
	end

	self:setStage(pPlayer, 2)
	CreatureObject(pPlayer):sendSystemMessage("@quest/ground/ep3_myyydril_treesh_craft_1:task01_journal_entry_title")

	return true
end

function myyydrilTreeshCraft1ScreenPlay:signalTurnIn(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	self:tryAdvanceCraft(pPlayer)

	if (self:getStage(pPlayer) ~= 2) then
		return false
	end

	self:awardQuest(pPlayer)

	return true
end
