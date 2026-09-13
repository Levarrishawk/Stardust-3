-- Arkon uses the Tier 4 portion of the Havoc conversation screens. Those screens
-- reference conversation/corellia_rebel_tier4.stf; shared eligibility screens are
-- retained for players who have not reached him legitimately.
arkon_convo = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "arkonConvoHandler",
	screens = kreezo_convo.screens
}

addConversationTemplate("arkon_convo", arkon_convo)
