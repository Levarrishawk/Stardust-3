-- Collector NPC conversation (ruling 2026-09-04): an empty tree whose handler opens the collector SUI --
-- see screenplays/collections/collector_npc.lua (collectorNpcConvoHandler). Prompt key ships in collection.stf.

collectorNpcConvoTemplate = ConvoTemplate:new {
	initialScreen = "start",
	templateType = "Lua",
	luaClassHandler = "collectorNpcConvoHandler",
	screens = {}
}

collectorNpcConvoStart = ConvoScreen:new {
	id = "start",
	leftDialog = "@collection:col_npc_prompt",
	stopConversation = "true",
	options = {}
}
collectorNpcConvoTemplate:addScreen(collectorNpcConvoStart)

addConversationTemplate("collectorNpcConvoTemplate", collectorNpcConvoTemplate)
