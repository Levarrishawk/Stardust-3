incomXwingPlansConvoTemplate = ConvoTemplate:new {
	initialScreen = "",
	templateType = "Lua",
	luaClassHandler = "incomXwingPlansConvoHandler",
	screens = {}
}

local screens = {
	{"intro", "Kessa Venn. I handle intelligence for Saw's partisans. We've learned that Incom is developing a new fighter for the Empire. If the reports are right, its capabilities are extraordinary. I need someone who can get inside a place the Empire thinks is secure.", false, {
		{"What makes this fighter so special?", "fighter"},
		{"Where is Incom testing it?", "facility"},
		{"I'm not interested.", "decline"}
	}},
	{"fighter", "They're calling it the T-65 X-Wing. Four laser cannons, proton torpedoes, shields, an integrated hyperdrive and an astromech socket. A fighter that can strike hard, survive a hit, and reach its target without a carrier. In Imperial hands, that changes the odds against every cell like ours.", false, {
		{"How do we get the plans?", "facility"},
		{"I need time to think.", "decline"}
	}},
	{"facility", "Our people traced the test flights to Vreni Island on Corellia. Incom has a small facility there, but the security is anything but small: stormtroopers, officers and AT-STs. Their flight test archive is in the officer's shed. Infiltrate the compound, download the technical plans onto a datadisk, and bring it back to me.", false, {
		{"What's the reward?", "reward"},
		{"I'll steal the plans.", "accept"},
		{"Not this time.", "decline"}
	}},
	{"reward", "We have people who can put those plans to use. Bring me the complete technical archive and you'll receive a deed for a T-65 X-Wing chassis of your own. You'll still need the proper Rebel pilot training and flight components. One successful delivery, one deed. No second payments for copied files.", false, {
		{"I'm in. Give me the location.", "accept"},
		{"I'll pass.", "decline"}
	}},
	{"accept", "I've marked the Incom facility on your datapad. Find the archive terminal, download the T-65 technical plans and get out. Bring the datadisk back here to me on Lok. The mission is in your quest journal.", true, {}},
	{"in_progress", "The archive is inside the officer's shed at the Incom testing facility on Vreni Island. We need the technical plans, not a story about how many troopers you shot.", false, {
		{"Mark the facility again.", "waypoint"},
		{"I'm on my way.", "decline"}
	}},
	{"return_plans", "Did you get the complete T-65 archive? I need the original datadisk in your inventory before I can authorize your X-Wing deed.", false, {
		{"Here are the X-Wing Technical plans.", "deliver"},
		{"I lost the datadisk.", "missing_plans"},
		{"I'll return shortly.", "decline"}
	}},
	{"deliver", "Let me check the archive.", true, {}},
	{"rewarded", "This is it. Airframe, weapons, shields, hyperdrive integration... everything. Saw's people will get these to the engineers. You've earned this X-Wing deed. Fit the chassis with flight components, and give the Empire a reason to regret its investment.", true, {}},
	{"already_complete", "The plans are safely with our engineers, and you've received your X-Wing deed. You did good work. Keep that fighter out of Imperial hands.", true, {}},
	{"missing_plans", "Bring your datadisk out of storage and into your inventory. If it's been destroyed, return to the Incom archive and download another copy. I can't authorize a deed without the plans.", true, {}},
	{"inventory_full", "Make room for the deed in your inventory, then speak to me again. Keep the plans until we're ready to make the exchange.", true, {}},
	{"reward_failed", "I couldn't release the deed. Keep the plans and speak to me again; the exchange hasn't been completed.", true, {}},
	{"not_ready", "We haven't completed the operation yet. Bring me the technical plans from Incom's archive.", true, {}},
	{"waypoint", "I've refreshed the mission waypoint on your datapad.", true, {}},
	{"imperial", "An Imperial in Saw's camp? Leave. You won't learn anything from me.", true, {}},
	{"decline", "Keep your eyes open out there.", true, {}}
}

for _, entry in ipairs(screens) do
	incomXwingPlansConvoTemplate:addScreen(ConvoScreen:new {
		id = entry[1],
		customDialogText = entry[2],
		stopConversation = entry[3] and "true" or "false",
		options = entry[4]
	})
end

addConversationTemplate("incomXwingPlansConvoTemplate", incomXwingPlansConvoTemplate)
