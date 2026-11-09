local leader = ConvoTemplate:new {
	initialScreen = "standby",
	templateType = "Lua",
	luaClassHandler = "som_battlefield_miner_leader_conv_handler",
	screens = {}
}

local stf = "@conversation/som_battlefield_miner_leader:"
for _, row in ipairs({
	{ "standby", "s_4", {{stf .. "s_6", "follow"}, {stf .. "s_14", "deploy"}} },
	{ "following", "s_4", {{stf .. "s_10", "stop"}, {stf .. "s_14", "deploy"}} },
	{ "deployed", "s_4", {{stf .. "s_18", "withdraw"}} },
	{ "follow", "s_8", {} },
	{ "stop", "s_12", {} },
	{ "deploy", "s_16", {} },
	{ "withdraw", "s_20", {} },
}) do
	leader:addScreen(ConvoScreen:new {
		id = row[1],
		leftDialog = stf .. row[2],
		stopConversation = #row[3] == 0 and "true" or "false",
		options = row[3]
	})
end

addConversationTemplate("som_battlefield_miner_leader", leader)
