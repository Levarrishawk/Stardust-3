THEME_PARK_REBEL_BADGE = 107

local function reward(credits, faction, badge)
	local result = {{rewardType = "credits", amount = credits}}
	if faction ~= nil then result[#result + 1] = {rewardType = "faction", faction = "rebel", amount = faction} end
	if badge == true then result[#result + 1] = {rewardType = "badge", badge = THEME_PARK_REBEL_BADGE} end
	return result
end

local function makeMission(kind, planet, waypoint, target, targetName, item, itemName, guards, rewards, offer, accepted, working, completed)
	local items = {}
	if item ~= nil then items = {{itemTemplate = item, itemName = itemName or ""}} end
	return {
		missionType = kind, planetName = planet, missionDescription = waypoint,
		primarySpawns = {{npcTemplate = target, npcName = targetName}},
		secondarySpawns = guards or {}, itemSpawns = items, rewards = rewards,
		dialog = {offer = offer, accepted = accepted, working = working, completed = completed}
	}
end

local twoTroopers = {
	{npcTemplate = "stormtrooper", npcName = "an Imperial escort"},
	{npcTemplate = "stormtrooper", npcName = "an Imperial escort"}
}

local attacheMissions = {
	makeMission("deliver", "alderaan", "Deliver relief medicine", "commoner", "a relief worker", "object/tangible/medicine/crafted/medpack_wound_health_a.iff", "Relief medicine", nil, reward(100),
		"A rural clinic missed its relief shipment. Take these medical supplies to our field worker.", "Keep the package sealed and avoid unnecessary Imperial attention.", "The clinic still needs that medicine.", "You helped people who had nowhere else to turn."),
	makeMission("escort", "alderaan", "Escort a relief courier", "commoner", "a relief courier", nil, nil, nil, reward(175),
		"One of our couriers believes she is being followed. Find her and bring her back quietly.", "If anyone asks, she is an employee returning from an inspection.", "Do not leave the courier exposed.", "She arrived safely, and no official report connects her to us."),
	makeMission("confiscate", "alderaan", "Recover seized relief manifests", "imperial_staff_corporal", "an Imperial quartermaster", "object/tangible/mission/mission_datadisk.iff", "Seized relief manifests", twoTroopers, reward(250),
		"An Imperial quartermaster seized manifests that identify vulnerable families. Recover them before they are copied.", "There must be no trail leading back to this office.", "The quartermaster still has the manifests.", "The families named in these records can disappear before the Empire comes looking."),
	makeMission("escort", "alderaan", "Extract an Alderaanian witness", "noble", "an Alderaanian witness", nil, nil, twoTroopers, reward(325, 50),
		"A witness to an Imperial reprisal is prepared to testify. Bring him to Alderaanian protection.", "This may be the first time the Empire actively tries to stop you.", "The witness cannot remain in the open.", "Senator Organa has reviewed your work and agreed to meet you privately.")
}

attacheMissions[1].dialog.introduction = "My name is Mira Tane. I am an Attache to Senator Organa, responsible for coordinating Alderaanian relief work beyond the capital. Imperial inspections have delayed several of our shipments, and one rural clinic is now running short of medicine. I may need your help, but you should understand what you are stepping into first."
attacheMissions[1].dialog.information = {
	{
		prompt = "What does the Relief Office actually do?",
		text = "We supply clinics, relocate families displaced by Imperial seizures, and document abuses that local authorities are ordered to ignore. Most of that work is legal. The Empire has begun treating compassion as suspicious whenever it reaches the wrong people."
	},
	{
		prompt = "Why do you need someone outside your staff?",
		text = "My registered couriers are being stopped, searched, and followed. Sending another would draw attention to the clinic and to every family it serves. Your name reached me through someone I trust. You are not tied to this office, and you understand why discretion matters."
	},
	{
		prompt = "What exactly do you need me to do?",
		text = "A relief worker is waiting outside the capital with a sealed package of medicine. Deliver it to them so it can reach the clinic without passing through an Imperial checkpoint under our name. This is aid work, not a military operation, but discovery could expose the entire route."
	}
}

local bailMissions = {
	makeMission("deliver", "alderaan", "Deliver sealed senatorial correspondence", "noble", "a diplomatic courier", "object/tangible/mission/mission_datadisk.iff", "Sealed correspondence", nil, reward(400),
		"My office must communicate with people who cannot safely approach the Senate. Deliver this correspondence.", "Discretion protects more lives than courage alone.", "My courier is waiting.", "The message is where it needs to be."),
	makeMission("confiscate", "alderaan", "Recover Imperial surveillance records", "imperial_first_lieutenant", "an Imperial surveillance officer", "object/tangible/mission/mission_datadisk.iff", "Surveillance records", twoTroopers, reward(475),
		"Imperial Security is monitoring several charitable organizations. Obtain its surveillance records before arrests begin.", "Recover the records without creating a public incident.", "Those records continue to endanger innocent people.", "We can warn everyone on this list before the security bureau acts."),
	makeMission("escort", "alderaan", "Extract a community organizer", "businessman", "a community organizer", nil, nil, twoTroopers, reward(550),
		"A community organizer refused an Imperial labor decree. See that he reaches Alderaanian protection.", "He will be frightened. Give him reason to trust you.", "The organizer must be moved tonight.", "He is safe, and his people are not without leadership."),
	makeMission("deliver", "coruscant", "Deliver an antiquities inquiry", "noble", "an antiquities broker", "object/tangible/mission/mission_datadisk.iff", "Antiquities inquiry", nil, reward(625, 75),
		"I require a discreet appraisal from a Coruscant antiquities dealer named Luthen Rael. Deliver this inquiry, then visit his gallery.", "To anyone who asks, this concerns a private Alderaanian collection.", "The gallery is expecting an inquiry from my office.", "Rael has agreed to receive you. Listen to what he asks, and what he does not say.")
}

local luthenMissions = {
	makeMission("retrieve", "coruscant", "Recover a disputed antiquity", "theme_park_rebel_pirate", "a private collector", "object/tangible/loot/misc/artifact_rare_s01.iff", "Disputed antiquity", nil, reward(700),
		"A collector has an object that belongs in my gallery. What is concealed inside is considerably more valuable.", "You are retrieving art. Maintain that fiction.", "The collector still has my property.", "The object will be separated from its more useful contents."),
	makeMission("confiscate", "coruscant", "Replace an Imperial cargo manifest", "imperial_staff_corporal", "an Imperial freight clerk", "object/tangible/mission/mission_datadisk.iff", "Imperial cargo manifest", twoTroopers, reward(775),
		"A freight clerk carries tomorrow's inspection manifest. Bring it to me before the first shift.", "The Empire must believe its records were misplaced, not altered.", "We have a narrow window to change that manifest.", "Several crates will now pass inspection as restoration supplies."),
	makeMission("escort", "coruscant", "Extract a compromised courier", "information_broker", "a compromised courier", nil, nil, twoTroopers, reward(850),
		"A courier missed two check-ins. Find them before Imperial Security does.", "If the courier has been turned, recognize it before they reach this shop.", "Every minute makes the courier easier to find.", "The route is burned, but routes can be rebuilt."),
	makeMission("assassinate", "coruscant", "Silence an Imperial informant", "theme_park_rebel_bounty_hunter", "an Imperial informant", nil, nil, twoTroopers, reward(925),
		"An informant sold the names of an entire workers' circle. Ensure the transfer never happens.", "Do not be seen returning here.", "The informant is preparing to deliver the names.", "The circle survives. They will never know why."),
	makeMission("retrieve", "coruscant", "Acquire military power regulators", "theme_park_rebel_hyperdrive_seller", "an unlicensed component dealer", "object/tangible/loot/misc/hyperdrive_part_s01.iff", "Military power regulators", nil, reward(1000, 100),
		"A dealer has military power regulators. Recover them, then take them to Saw Gerrera on Lok.", "Gerrera is not part of my network. Remember that distinction.", "The regulators must not enter the Imperial supply chain.", "Saw will decide whether you are useful to him.")
}

local sawMissions = {
	makeMission("assassinate", "lok", "Eliminate an Imperial sensor patrol", "stormtrooper_squad_leader", "an Imperial patrol leader", nil, nil, twoTroopers, reward(1075),
		"An Imperial patrol is mapping this region. Wipe it out before it transmits its survey.", "Leave nothing that can identify this camp.", "That patrol is still closing in.", "They will send another. Next time we will be ready sooner."),
	makeMission("confiscate", "lok", "Recover stolen demolition charges", "theme_park_rebel_pirate", "a pirate quartermaster", "object/tangible/component/item/quest_item/directional_sensor.iff", "Demolition detonators", nil, reward(1150),
		"Pirates stole detonators from one of my teams. Recover them.", "The detonators belong to the fight, not profiteers.", "The pirates still have our detonators.", "We can replace explosives. Trained people are harder to replace."),
	makeMission("escort", "lok", "Rescue a Partisan demolition specialist", "rebel_commando", "a Partisan demolition specialist", nil, nil, twoTroopers, reward(1225),
		"One of my demolition specialists is cut off beyond an Imperial sweep. Bring her home.", "She knows what this cell is building. Do not let her be captured.", "My specialist is still out there.", "She will be back at work before the next charge is wired."),
	makeMission("confiscate", "lok", "Seize industrial power converters", "imperial_first_lieutenant", "an Imperial logistics officer", "object/tangible/mission/mission_datadisk.iff", "Power-converter release codes", twoTroopers, reward(1300),
		"An Imperial convoy carries industrial power converters. Take its release codes.", "We are taking back tools built with stolen labor.", "The convoy will move soon.", "Some converters stay here. The rest go to the jungle cell."),
	makeMission("assassinate", "lok", "Destroy an Imperial reprisals unit", "imperial_general", "an Imperial reprisals commander", nil, nil, twoTroopers, reward(1375, 125),
		"The officer who ordered reprisals against a mining settlement is traveling with his unit. End his campaign.", "This is not a warning. Remove the unit.", "That commander is still free to murder civilians.", "The people he intended to kill will call it survival.")
}

local mothmaMissions = {
	makeMission("deliver", "chandrila", "Deliver protected foundation records", "noble", "a foundation trustee", "object/tangible/mission/mission_datadisk.iff", "Protected foundation records", nil, reward(1450),
		"Deliver these charitable foundation records before an Imperial examiner arrives.", "Nothing in them is illegal. That will not protect the people named.", "The trustee must receive the records first.", "The foundation can continue without exposing its donors."),
	makeMission("escort", "chandrila", "Protect a Chandrilan labor organizer", "businessman", "a Chandrilan labor organizer", nil, nil, twoTroopers, reward(1525),
		"A labor organizer is accused of sedition for opposing compulsory quotas. Escort him to a legal delegation.", "His cause must remain public and peaceful.", "The delegation cannot proceed without him.", "The hearing will go forward. Public resistance still matters."),
	makeMission("confiscate", "chandrila", "Recover an Imperial surveillance index", "imperial_first_lieutenant", "an Imperial security liaison", "object/tangible/mission/mission_datadisk.iff", "Surveillance index", twoTroopers, reward(1600),
		"A security liaison compiled an index of opposition figures. Recover it before transmission.", "Make its disappearance appear to be bureaucratic incompetence.", "The index remains in Imperial hands.", "We can protect these people without revealing how we learned of the danger."),
	makeMission("deliver", "chandrila", "Secure a civilian shipping charter", "businessman", "an independent shipping representative", "object/tangible/mission/mission_datadisk.iff", "Civilian shipping charter", nil, reward(1675),
		"An independent carrier may service remote settlements. Deliver this charter and confirm its cooperation.", "The cargo is relief and construction material. Much of it truly is.", "We need that shipping commitment.", "A legitimate, regular, unremarkable route is a valuable route."),
	makeMission("escort", "chandrila", "Extract a threatened industrial supplier", "commoner_technician", "an industrial supplier", nil, nil, twoTroopers, reward(1750, 150),
		"The supplier who provided our generators has been threatened. Bring her to the Hanna City hotel.", "She risked herself for people she has never met.", "The supplier must be extracted tonight.", "She is safe. Her equipment is already being routed to Yavin Four.")
}

local yavinMissions = {
	makeMission("escort", "yavin4", "Escort a power engineer to the Yavin cell", "commoner_technician", "a resistance power engineer", nil, nil, nil, reward(1825),
		"Find the engineer who can synchronize our new generators and escort them through the jungle.", "An Imperial patrol would be worse than the wildlife.", "The engineer has not reached the base.", "We can now power the infirmary and communications room together."),
	makeMission("confiscate", "yavin4", "Recover stolen construction supplies", "theme_park_rebel_pirate", "a supply thief", "object/tangible/mission/mission_datadisk.iff", "Stolen supply locator", nil, reward(1900),
		"A thief intercepted part of our construction shipment. Recover its locator.", "We cannot request replacements without exposing the route.", "Recover those supplies.", "The missing crates are accounted for."),
	makeMission("retrieve", "yavin4", "Retrieve a long-range transmitter", "theme_park_rebel_supervisor", "a stranded communications technician", "object/tangible/loot/tool/recording_rod_broken.iff", "Long-range transmitter core", nil, reward(1975),
		"A communications team abandoned a transmitter core during an animal attack. Retrieve it.", "Without it, this cell remains isolated.", "The transmitter core is still in the jungle.", "We can communicate without commercial relays."),
	makeMission("assassinate", "yavin4", "Destroy an Imperial reconnaissance team", "stormtrooper_squad_leader", "an Imperial reconnaissance leader", nil, nil, twoTroopers, reward(2050),
		"An Imperial reconnaissance team landed beyond our watch. Stop it before it identifies the temple.", "No transmission can leave that team.", "The reconnaissance team is still within reporting range.", "The Empire will record another lost jungle patrol."),
	makeMission("escort", "yavin4", "Guide the first regular supply convoy to Yavin", "rebel_pilot", "a resistance convoy scout", nil, nil, twoTroopers, reward(2200, 300, true),
		"Meet the first regular convoy's scout and guide them past the Imperial search pattern.", "If this works, Yavin becomes more than a temporary camp.", "The convoy cannot approach until its scout reaches us.", "What began as scattered favors is now a supply line, and a supply line can sustain a rebellion.")
}

local npcMapRebel = {
	{spawnData = {planetName="alderaan", npcTemplate="alderaan_relief_attache", x=-20.9, z=3.2, y=22.2, direction=-90, cellID=610000026, position=STAND}, worldPosition={x=1120,y=-1420}, npcNumber=1, stfFile="", missions=attacheMissions, noFactionDialog="The Alderaanian Relief Office accepts donations through the public registry. If you require assistance, a clerk can direct you.", lockedDialog="The relief office cannot discuss protected cases with you.", completedDialog="Senator Organa is expecting you."},
	{spawnData = {planetName="alderaan", npcTemplate="bail_organa", x=-35.3, z=1.3, y=-2.8, direction=84, cellID=610000025, position=STAND, existingSpawn=true}, worldPosition={x=1120,y=-1420}, npcNumber=2, stfFile="", missions=bailMissions, noFactionDialog="I am afraid you have mistaken a public audience for a private appointment. My staff can assist with official senatorial business.", lockedDialog="My Attache handles relief matters. Please speak with her first.", completedDialog="Rael's gallery is on Coruscant."},
	{spawnData = {planetName="coruscant", npcTemplate="luthen_rael", x=0,z=0,y=0,direction=180,cellID=37002117,position=STAND}, worldPosition={x=-1918,y=-134}, npcNumber=4, stfFile="", missions=luthenMissions, noFactionDialog="I deal in antiquities. If you are not here to acquire something, I have other clients waiting.", lockedDialog="The gallery is open to serious clients only.", completedDialog="Saw Gerrera is waiting on Lok. Do not mistake an introduction for trust."},
	{spawnData = {planetName="lok", npcTemplate="saw_gerrera", x=-5660,z=38,y=-4820,direction=45,cellID=0,position=STAND}, worldPosition={x=-5660,y=-4820}, npcNumber=8, stfFile="", missions=sawMissions, noFactionDialog="You took a wrong turn. Leave before my people decide you were scouting the camp.", lockedDialog="Luthen did not clear you to speak for him.", completedDialog="The supplies are moving. Mothma will decide what becomes of them."},
	{spawnData = {planetName="chandrila", npcTemplate="mon_mothma", x=6,z=0.6,y=-5.5,direction=-90,cellID=35791665,position=STAND}, worldPosition={x=294,y=-2938}, npcNumber=16, stfFile="", missions=mothmaMissions, noFactionDialog="I am here on senatorial business. Please direct constituency matters to my staff.", lockedDialog="I am here on senatorial business.", completedDialog="The final shipments are being routed to a small cell on Yavin Four."},
	{spawnData = {planetName="yavin4", npcTemplate="yavin_cell_commander", x=-25,z=32,y=68,direction=180,cellID=3465358,position=STAND}, worldPosition={x=-3050,y=-2950}, npcNumber=32, stfFile="", missions=yavinMissions, noFactionDialog="This is restricted territory. Turn around, leave by the route you used, and do not return.", lockedDialog="This facility is not open to visitors.", completedDialog="The route is holding. You helped turn an isolated cell into something that can endure."}
}

local sceneObjectMapRebel = {
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/coffee_table_s01.iff",x=-5,z=0,y=2.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Display"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/loot/misc/artifact_rare_s01.iff",x=-5,z=0.5,y=2.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Ancient Ceremonial Vessel"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/coffee_table_s01.iff",x=0,z=0,y=4,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Display"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/item/lytus_family_artefact.iff",x=0,z=0.5,y=4,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Pre-Republic Sculpture"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/coffee_table_s01.iff",x=5,z=0,y=2.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Display"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/tatooine/frn_tato_vase_style_02.iff",x=5,z=0.5,y=2.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Outer Rim Funerary Urn"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/modern/bar_counter_s1.iff",x=0,z=0,y=-4.5,cellID=37002118,dw=1,dx=0,dy=0,dz=0},customObjectName="Gallery Consultation Counter"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/all/frn_all_data_terminal_free_s1.iff",x=-3,z=0,y=-2,cellID=37002119,dw=1,dx=0,dy=0,dz=0},customObjectName="Private Catalog Terminal"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/container/drum/large_plain_crate_s01.iff",x=3.5,z=0,y=-3.5,cellID=37002119,dw=1,dx=0,dy=0,dz=0},customObjectName="Uncatalogued Acquisition"}
	,{spawnData={planetName="lok",objectTemplate="object/static/structure/corellia/corl_tent_hut_s01.iff",x=-5665,z=38,y=-4818,cellID=0,dw=0.9239,dx=0,dy=0.3827,dz=0},customObjectName="Partisan Field Shelter"}
	,{spawnData={planetName="lok",objectTemplate="object/static/structure/corellia/corl_tent_hut_s01.iff",x=-5656,z=38,y=-4826,cellID=0,dw=0.3827,dx=0,dy=0.9239,dz=0},customObjectName="Partisan Supply Shelter"}
	,{spawnData={planetName="lok",objectTemplate="object/static/structure/general/campfire_smoldering.iff",x=-5660,z=38,y=-4823,cellID=0,dw=1,dx=0,dy=0,dz=0},customObjectName="Banked Campfire"}
	,{spawnData={planetName="lok",objectTemplate="object/static/structure/general/ins_shield_generator_stage1.iff",x=-5652,z=38,y=-4818,cellID=0,dw=0.7071,dx=0,dy=0.7071,dz=0},customObjectName="Salvaged Field Generator"}
}

ThemeParkRebel = ThemeParkLogic:new {
	npcMap=npcMapRebel, sceneObjectMap=sceneObjectMapRebel, permissionMap={},
	className="ThemeParkRebel", screenPlayState="rebel_theme_park", missionDescriptionStf="",
	missionCompletionMessageStf="@theme_park/messages:rebel_completion_message",
	requiredPlanets={"alderaan","coruscant","lok","chandrila","yavin4"}, faction=FACTIONREBEL
}

registerScreenPlay("ThemeParkRebel", true)

local function getDialog(themePark, pPlayer, pNpc)
	local number = themePark:getNpcNumber(pNpc)
	local current = themePark:getMission(number, themePark:getCurrentMissionNumber(number, pPlayer))
	return current ~= nil and current.dialog or nil
end

local function addInformationOptions(screen, dialog, currentTopic)
	screen:removeAllOptions()

	if currentTopic == 3 then
		screen:addOption("I will deliver the medicine.", "accept")
	end

	for i = 1, #dialog.information do
		if i ~= currentTopic then
			screen:addOption(dialog.information[i].prompt, "npc_" .. (i + 3) .. "_n")
		end
	end

	screen:addOption("I need some time to consider this.", "npc_3_n")
end

theme_park_rebel_mission_giver_conv_handler = mission_giver_conv_handler:new {themePark=ThemeParkRebel}

function theme_park_rebel_mission_giver_conv_handler:handleScreenNpc1(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNpc1(self,t,p,n,o,s); local screen=LuaConversationScreen(result); local d=getDialog(self.themePark,p,n)
	if d~=nil and d.introduction~=nil and d.information~=nil then screen:setCustomDialogText(d.introduction); addInformationOptions(screen,d,0); return result end
	if d~=nil then screen:setCustomDialogText(d.offer) end; screen:removeAllOptions(); screen:addOption("I can help.","accept"); screen:addOption("Not now.","npc_3_n"); return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNpc2(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNpc2(self,t,p,n,o,s); local d=getDialog(self.themePark,p,n); if d~=nil then LuaConversationScreen(result):setCustomDialogText(d.accepted) end; return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNpc3(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNpc3(self,t,p,n,o,s); local screen=LuaConversationScreen(result); local d=getDialog(self.themePark,p,n); if d~=nil and d.introduction~=nil then screen:setCustomDialogText("I understand. The clinic's need will not wait, but this must be your decision. Return if you reconsider.") else screen:setCustomDialogText("Then we have nothing further to discuss.") end; screen:setStopConversation(true); return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNpc4(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNpc4(self,t,p,n,o,s); local screen=LuaConversationScreen(result); local d=getDialog(self.themePark,p,n); if d~=nil and d.information~=nil then screen:setCustomDialogText(d.information[1].text); addInformationOptions(screen,d,1) end; return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNpc5(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNpc5(self,t,p,n,o,s); local screen=LuaConversationScreen(result); local d=getDialog(self.themePark,p,n); if d~=nil and d.information~=nil then screen:setCustomDialogText(d.information[2].text); addInformationOptions(screen,d,2) end; return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNpc6(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNpc6(self,t,p,n,o,s); local screen=LuaConversationScreen(result); local d=getDialog(self.themePark,p,n); if d~=nil and d.information~=nil then screen:setCustomDialogText(d.information[3].text); addInformationOptions(screen,d,3) end; return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenWork(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenWork(self,t,p,n,o,s); local screen=LuaConversationScreen(result); local d=getDialog(self.themePark,p,n); if d~=nil then screen:setCustomDialogText(d.working) end; screen:removeAllOptions(); screen:addOption("I cannot complete this assignment.","npc_reset"); screen:addOption("I am still working on it.","npc_backtowork"); return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenReward(t,p,n,o,s)
	local d=getDialog(self.themePark,p,n); local result=mission_giver_conv_handler.handleScreenReward(self,t,p,n,o,s); if d~=nil then LuaConversationScreen(result):setCustomDialogText(d.completed) end; return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNotYet(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNotYet(self,t,p,n,o,s); local data=self.themePark:getNpcData(self.themePark:getNpcNumber(n)); if data~=nil then LuaConversationScreen(result):setCustomDialogText(data.lockedDialog) end; return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNext(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNext(self,t,p,n,o,s); local data=self.themePark:getNpcData(self.themePark:getNpcNumber(n)); if data~=nil then LuaConversationScreen(result):setCustomDialogText(data.completedDialog) end; return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenReset(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenReset(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("Understood. This assignment is withdrawn."); return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenBackToWork(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenBackToWork(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("Then finish it and return when it is done."); return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenFailure(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenFailure(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("The opportunity is gone. We will have to find another way."); return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNoLoc(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNoLoc(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("The contact has gone silent. I am withdrawing the assignment."); return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNoFaction(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNoFaction(self,t,p,n,o,s); local data=self.themePark:getNpcData(self.themePark:getNpcNumber(n)); local dialog="There is nothing I can discuss with you."; if data~=nil and data.noFactionDialog~=nil then dialog=data.noFactionDialog end; LuaConversationScreen(result):setCustomDialogText(dialog); return result
end

theme_park_rebel_mission_target_conv_handler = mission_target_conv_handler:new {themePark=ThemeParkRebel}
function theme_park_rebel_mission_target_conv_handler:handleScreenSmuggle(t,p,n,o,s)
	local result=mission_target_conv_handler.handleScreenSmuggle(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("You are the contact? Good. Let us finish before anyone notices."); return result
end
function theme_park_rebel_mission_target_conv_handler:handleScreenTakeMe(t,p,n,o,s)
	local result=mission_target_conv_handler.handleScreenTakeMe(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("I was told someone might come. Get me out of here."); return result
end
function theme_park_rebel_mission_target_conv_handler:handleScreenBreech(t,p,n,o,s)
	local result=mission_target_conv_handler.handleScreenBreech(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("You have made a serious mistake coming here."); return result
end
