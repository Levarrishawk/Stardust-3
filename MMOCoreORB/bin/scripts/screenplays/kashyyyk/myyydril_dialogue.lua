local questConditions = {
	Kallaarac = {myyydrilKivvaaaTalkto1ScreenPlay, 1},
	Helping = {myyydrilKivvaaaTalkto1ScreenPlay},
	Caverns = {myyydrilNawikaTalkto5ScreenPlay},
	Hero = {myyydrilKallaaracDestroy3ScreenPlay},
	Doctor = {myyydrilYrakaTalkto6ScreenPlay, 1},
	Lorn = {myyydrilKinesworthyEpic3ScreenPlay, 1},
	End = {myyydrilKinesworthyEpic3ScreenPlay},
}

local function meetsCondition(pPlayer, condition)
	if (condition == "_defaultCondition") then
		return true
	elseif (condition == "hasLanguage" or condition == "hasLnguage") then
		local player = CreatureObject(pPlayer)
		return not player:hasSkill("social_language_wookiee_comprehend")
			and not player:hasSkill("combat_smuggler_underworld_01")
	end
	local quest = questConditions[condition][1]
	local stage = questConditions[condition][2]
	if (stage ~= nil) then
		return quest:getStage(pPlayer) == stage
	end
	return quest:getRuns(pPlayer) > 0 and quest:getStage(pPlayer) == 0
end

local function getInitialScreen(self, pPlayer, pNpc, pConvTemplate)
	local template = LuaConversationTemplate(pConvTemplate)
	for _, row in ipairs(self.initialChoices) do
		if (meetsCondition(pPlayer, row[1])) then
			return template:getScreen(row[2])
		end
	end
end

for name, initial in pairs(MyyydrilDialogue) do
	_G[name .. "_conv_handler"] = conv_handler:new {initialChoices = initial, getInitialScreen = getInitialScreen}
end

myyydril_clone_droid_conv_handler = conv_handler:new {}

function ep3_myyydril_compactor_conv_handler:runScreenHandlers(pConvTemplate, pPlayer, pNpc, selectedOption, pConvScreen)
	local screen = LuaConversationScreen(pConvScreen)
	local id = screen:getScreenID()
	local pClone = screen:cloneScreen()
	if (id == "s_113" and #MyyydrilCompactor:getAllJunkItems(pPlayer) == 0) then
		local clone = LuaConversationScreen(pClone)
		clone:removeAllOptions()
		clone:addOption("@conversation/ep3_myyydril_compactor:s_119", "s_121")
	elseif (id == "s_117" and #MyyydrilCompactor:getAllJunkItems(pPlayer) > 0) then
		MyyydrilCompactor.open(pPlayer)
	end
	return pClone
end
