--[[
	Named Etyyy hunt trophies.

	ruling 2026-09-04: "ensure kashyyyk is fully done"

	SOE quest_start items grant the matching ep3_hunt_loot_* .qst when looted.
	Core3 has no quest_start grant hook. A kill observer on the lair-mapped
	templates grants the loot quest, gives the trophy iff when the repo has
	it, and raises the Wait-for-Signal. Conversation turn-in still raises
	that signal as the Java conversation does.

	Paleclaw / Brightclaw have no mouf creature template. OPEN. Not substituted.

	NO JOURNAL: do not call the journal engine.
]]

huntLootNamedKillsScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "huntLootNamedKillsScreenPlay",
	rows = {
	{ quest = "ep3_hunt_loot_silkthrower_killed", sp = huntLootSilkthrowerKilledScreenPlay, signal = "lootQuest_defeatedSilkthrower", item = "object/tangible/quest/quest_start/ep3_hunt_loot_silkthrower_fang.iff", templates = { "kashyyyk_hunt_silkthrower" } },
	{ quest = "ep3_hunt_loot_stoneleg_killed", sp = huntLootStonelegKilledScreenPlay, signal = "lootQuest_defeatedStoneleg", item = "object/tangible/quest/quest_start/ep3_hunt_loot_stoneleg_heart.iff", templates = { "kashyyyk_hunt_stoneleg" } },
	{ quest = "ep3_hunt_loot_spiketop_killed", sp = huntLootSpiketopKilledScreenPlay, signal = "lootQuest_defeatedSpiketop", item = "object/tangible/quest/quest_start/ep3_hunt_loot_spiketop_horn.iff", templates = { "kashyyyk_hunt_spiketop" } },
	{ quest = "ep3_hunt_loot_greyclimber_killed", sp = huntLootGreyclimberKilledScreenPlay, signal = "lootQuest_defeatedGreyclimber", item = "object/tangible/quest/quest_start/ep3_hunt_loot_greyclimber_eye.iff", templates = { "kashyyyk_hunt_greyclimber" } },
	{ quest = "ep3_hunt_loot_paleclaw_killed", sp = huntLootPaleclawKilledScreenPlay, signal = "lootQuest_defeatedPaleclaw", item = "object/tangible/quest/quest_start/ep3_hunt_loot_paleclaw_jaw.iff", templates = {  } },
	{ quest = "ep3_hunt_loot_brightclaw_killed", sp = huntLootBrightclawKilledScreenPlay, signal = "lootQuest_defeatedBrightclaw", item = "object/tangible/quest/quest_start/ep3_hunt_loot_brightclaw_jaw.iff", templates = {  } },
	},
}

registerScreenPlay("huntLootNamedKillsScreenPlay", true)

function huntLootNamedKillsScreenPlay:start()
end

function huntLootNamedKillsScreenPlay:attachPlayer(pPlayer)
	if (pPlayer == nil) then
		return
	end
	if ((tonumber(readScreenPlayData(pPlayer, self.screenplayName, "observer")) or 0) == 1) then
		return
	end
	createObserver(KILLEDCREATURE, "huntLootNamedKillsScreenPlay", "notifyKilledCreature", pPlayer, 1)
	writeScreenPlayData(pPlayer, self.screenplayName, "observer", "1")
end

function huntLootNamedKillsScreenPlay:isRowTemplate(row, name)
	for i = 1, #row.templates do
		if (row.templates[i] == name) then
			return true
		end
	end
	return false
end

function huntLootNamedKillsScreenPlay:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end
	local victimTemplate = AiAgent(pVictim):getCreatureTemplateName()
	if (victimTemplate == nil) then
		return 0
	end
	for i = 1, #self.rows do
		local row = self.rows[i]
		if (#row.templates > 0 and self:isRowTemplate(row, victimTemplate)) then
			if (row.sp ~= nil and row.sp.canGrantQuest ~= nil and row.sp:canGrantQuest(pPlayer)) then
				row.sp:grantQuest(pPlayer)
				if (row.item ~= nil and row.item ~= "") then
					local pInv = CreatureObject(pPlayer):getSlottedObject("inventory")
					if (pInv ~= nil) then
						giveItem(pInv, row.item, -1)
					end
				end
			end
			if (row.signal ~= nil and row.signal ~= "") then
				EtyyyHuntState:raise(pPlayer, row.signal)
			end
		end
	end
	return 0
end
