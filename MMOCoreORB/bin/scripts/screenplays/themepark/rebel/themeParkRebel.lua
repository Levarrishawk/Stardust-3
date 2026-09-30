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
	makeMission("deliver", "alderaan", "Deliver relief medicine", "theme_park_rebel_civilian_contact", "a relief worker", "object/tangible/medicine/crafted/medpack_wound_health_a.iff", "Relief medicine", nil, reward(100),
		"A rural clinic missed its relief shipment. Take these medical supplies to our field worker.", "Keep the package sealed and avoid unnecessary Imperial attention.", "The clinic still needs that medicine.", "You helped people who had nowhere else to turn."),
	makeMission("escort", "alderaan", "Escort a relief courier", "theme_park_rebel_civilian_contact", "a relief courier", nil, nil, nil, reward(175),
		"One of our couriers believes she is being followed. Find her and bring her back quietly.", "If anyone asks, she is an employee returning from an inspection.", "Do not leave the courier exposed.", "She arrived safely, and no official report connects her to us."),
	makeMission("confiscate", "alderaan", "Recover seized relief manifests", "imperial_staff_corporal", "an Imperial quartermaster", "object/tangible/mission/mission_datadisk.iff", "Seized relief manifests", twoTroopers, reward(250),
		"An Imperial quartermaster seized manifests that identify vulnerable families. Recover them before they are copied.", "Recover the disk and bring it directly to me. Once you engage Voss, expect Imperial forces to treat you as a Combatant.", "The quartermaster still has the manifests.", "The families named in these records can disappear before the Empire comes looking."),
	makeMission("escort", "alderaan", "Extract an Alderaanian witness", "theme_park_rebel_civilian_contact", "an Alderaanian witness", nil, nil, twoTroopers, reward(325, 50),
		"A witness to an Imperial reprisal is prepared to testify. Bring him to Alderaanian protection.", "This may be the first time the Empire actively tries to stop you.", "The witness cannot remain in the open.", "Senator Organa has reviewed your work and agreed to meet you privately.")
}

attacheMissions[1].dialog.introduction = "My name is Mira Tane. I am an Attache to Senator Organa, responsible for coordinating Alderaanian relief work beyond the capital. Imperial inspections have delayed several of our shipments, and one rural clinic is now running short of medicine. I may need your help, but you should understand what you are stepping into first."
attacheMissions[1].dialog.acceptText = "I will deliver the medicine."
attacheMissions[1].dialog.declineText = "I understand. The clinic's need will not wait, but this must be your decision. Return if you reconsider."
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

attacheMissions[2].primarySpawns[1].npcName = "Sela Venn, a relief courier"
attacheMissions[2].dialog.introduction = "The medicine reached the clinic, and you handled the delivery without drawing attention to our office. That earns a measure of trust. Unfortunately, one of my couriers, Sela Venn, missed her return check-in. She reported being followed before her comlink went silent. I need her found before whoever is watching her decides to act."
attacheMissions[2].dialog.acceptText = "I will find Sela and bring her back."
attacheMissions[2].dialog.declineText = "I will send someone else if I can, but every delay gives her pursuers more time. Return quickly if you change your mind."
attacheMissions[2].dialog.information = {
	{
		prompt = "Who is Sela Venn?",
		text = "Sela has carried medicine, identity records, and evacuation notices for this office for nearly two years. She is careful and dependable. Missing a check-in is not like her, which is why I believe the danger is real."
	},
	{
		prompt = "Why would anyone follow a relief courier?",
		text = "Imperial Security has begun mapping everyone connected to aid shipments. Some recipients are families displaced after resisting new labor quotas. The Empire may suspect that our routes move more than medicine, or it may simply want names it can use as leverage."
	},
	{
		prompt = "How should I bring her back?",
		text = "Find Sela, confirm that you were sent by Mira Tane, and escort her back here. Do not confront anyone unless they move against you. If questioned, she is an employee returning from a routine inspection. Above all, do not let Imperial Security take her into custody."
	}
}

attacheMissions[3].primarySpawns[1].npcName = "Corporal Dalen Voss, an Imperial quartermaster"
attacheMissions[3].dialog.introduction = "Sela's return confirmed what we feared. The people following her were not watching one courier; they were tracing the entire relief route. An Imperial quartermaster named Dalen Voss has seized our distribution manifests. Those records identify clinics, field workers, and families already marked as politically unreliable. Voss is preparing to transfer them to Imperial Security."
attacheMissions[3].dialog.acceptText = "I will stop Voss and recover the manifests."
attacheMissions[3].dialog.declineText = "I understand. This is no longer a simple relief errand. But once those records reach Imperial Security, the people named in them will have nowhere left to hide."
attacheMissions[3].dialog.information = {
	{
		prompt = "What information is in the manifests?",
		text = "Names, delivery locations, medical requirements, and the identities of our field workers. In ordinary hands they are shipping records. Imperial Security can turn them into a map of everyone who has resisted a seizure, sheltered a fugitive, or accepted help without permission."
	},
	{
		prompt = "Why can Senator Organa not recover them legally?",
		text = "His office has already filed a formal challenge. Voss answered by moving the transfer forward. A public intervention now would reveal how important the records are and connect the Senator directly to everyone listed. The law may help us eventually. These families do not have eventually."
	},
	{
		prompt = "Are you asking me to attack Imperial personnel?",
		text = "I am asking you to intercept Voss before the transfer and recover the data disk. He travels with an armed escort and has orders to resist interference, so you should expect a fight. The moment you attack, the Empire will no longer regard you as a civilian; they will consider you to be an Insurgent. I will not conceal that cost from you."
	}
}

attacheMissions[4].primarySpawns[1].npcName = "Edrin Hal, an Alderaanian relief assessor"
attacheMissions[4].dialog.introduction = "The manifests are secure, and most of the people named in them are being moved. One of them, Edrin Hal, will not leave quietly. Edrin was a relief assessor in the Kellan district when an Imperial requisition detail opened fire on civilians who resisted the seizure of their winter stores. The official report calls those civilians armed agitators. Edrin saw what happened, and he preserved enough evidence to challenge that lie. Imperial Security now knows that he survived."
attacheMissions[4].dialog.acceptText = "I will bring Edrin into Alderaanian protection."
attacheMissions[4].dialog.declineText = "You have already taken considerable risks for us, and I will not pretend this one is smaller. But if Imperial Security reaches Edrin first, they will bury both the witness and the truth he carries."
attacheMissions[4].dialog.information = {
	{
		prompt = "Who is Edrin Hal?",
		text = "Edrin inspected clinics and food depots receiving aid through this office. He is neither a soldier nor an activist. He is a civil servant who kept careful records and happened to be present when an Imperial officer decided that an example mattered more than Alderaanian lives. That makes his account difficult for the Empire to dismiss and dangerous for it to leave unanswered."
	},
	{
		prompt = "Why not bring him here through official channels?",
		text = "The local security office has orders to detain him as a material witness to sedition. If Senator Organa intervenes publicly before Edrin is safe, the Empire will know exactly who is protecting him and why. We must first move him beyond their reach, preserve his evidence, and let the Senator decide how it can be used without condemning everyone involved."
	},
	{
		prompt = "What should I expect during the extraction?",
		text = "Find Edrin at the location I provide, identify yourself as coming from my office, and escort him back to me. An Imperial recovery detail is already searching the district. They may ignore an ordinary traveler, but they will try to stop anyone moving with Edrin. If you defend him, you should expect to be treated as a Combatant. Get him here alive; his testimony is the reason for this mission."
	}
}

local bailMissions = {
	makeMission("deliver", "alderaan", "Deliver sealed senatorial correspondence", "theme_park_rebel_civilian_contact", "a diplomatic courier", "object/tangible/mission/mission_datadisk.iff", "Sealed correspondence", nil, reward(400),
		"My office must communicate with people who cannot safely approach the Senate. Deliver this correspondence.", "Discretion protects more lives than courage alone.", "My courier is waiting.", "The message is where it needs to be."),
	makeMission("confiscate", "alderaan", "Recover Imperial surveillance records", "imperial_first_lieutenant", "an Imperial surveillance officer", "object/tangible/mission/mission_datadisk.iff", "Surveillance records", twoTroopers, reward(475),
		"Imperial Security is monitoring several charitable organizations. Obtain its surveillance records before arrests begin.", "Recover the records without creating a public incident.", "Those records continue to endanger innocent people.", "We can warn everyone on this list before the security bureau acts."),
	makeMission("escort", "alderaan", "Extract a community organizer", "theme_park_rebel_civilian_contact", "a community organizer", nil, nil, twoTroopers, reward(550),
		"A community organizer refused an Imperial labor decree. See that she reaches Alderaanian protection.", "She will be frightened. Give her reason to trust you.", "The organizer must be moved tonight.", "She is safe, and her people are not without leadership."),
	makeMission("deliver", "coruscant", "Deliver an antiquities inquiry", "theme_park_rebel_civilian_contact", "an antiquities broker", "object/tangible/mission/mission_datadisk.iff", "Antiquities inquiry", nil, reward(625, 75),
		"I require a discreet appraisal from a Coruscant antiquities dealer named Luthen Rael. Deliver this inquiry to Davo Sorn, then return to me before approaching Luthen.", "Deliver the inquiry to Sorn, then return directly to me. To anyone who asks, this concerns a private Alderaanian collection.", "Davo Sorn is waiting for the inquiry. Return to me after the handoff.", "I have received word from Davo Sorn. The inquiry was accepted, and an appointment has been made for you to meet with Luthen. Proceed to his shop in the Collective Commerce District on Coruscant. Luthen has agreed to receive you. Listen to what he asks, and what he does not say.")
}

bailMissions[1].primarySpawns[1].npcName = "Neris Kaal, a diplomatic courier"
bailMissions[1].dialog.introduction = "Mira has told me what you did for Edrin Hal and for the families named in those manifests. You acted when the protections promised by law had already failed them. That does not make this an audience for medals or speeches. It means I am prepared to entrust you with something quieter. Reports resembling Edrin's account are reaching me from other worlds. I need this correspondence placed in the hands of Neris Kaal, a courier who can carry it beyond Alderaan without entering it into the Senate registry."
bailMissions[1].dialog.acceptText = "I will deliver the correspondence to Neris Kaal."
bailMissions[1].dialog.declineText = "Prudence is not cowardice. If you are uncertain, say nothing about this conversation and return only when you are prepared to see the matter through."
bailMissions[1].dialog.completed = "Neris has confirmed receipt. The correspondence will now pass through hands that have no visible connection to this office. If the reports agree, we will know these abuses are not isolated, and we can begin warning people before Imperial Security reaches them. You handled this exactly as required: quietly, without exposing anyone else."
bailMissions[1].dialog.information = {
	{
		prompt = "Who will receive the message after Neris?",
		text = "People in public office, relief organizations, and local communities who have each seen part of the same pattern. Most do not know one another, and for now that is safer. I am asking them to compare what they know and determine whether these reprisals are isolated abuses or a policy being repeated across the Empire."
	},
	{
		prompt = "Why not use diplomatic channels?",
		text = "Official channels preserve a record of every sender and recipient. A routine inquiry can become a list of suspected dissidents in the hands of Imperial Security. Neris carries messages without exposing the entire chain of people involved, and even she will know only where the next handoff occurs."
	},
	{
		prompt = "What do you need me to do?",
		text = "Carry the sealed correspondence to Neris at the location my office provides, then return here. Do not open it, copy it, or identify yourself as acting for me. If questioned, you are delivering private material concerning an Alderaanian relief dispute. The message matters, but protecting the network around it matters more."
	}
}

bailMissions[2].primarySpawns[1].npcName = "Lieutenant Arven Rusk, an Imperial surveillance officer"
bailMissions[2].dialog.introduction = "Neris completed the handoff. The replies confirm that Edrin's district was not an exception: relief offices, labor councils, and local assemblies are being watched wherever they resist Imperial requisitions. Lieutenant Arven Rusk has compiled those connections into a surveillance archive. If his superiors receive it, dozens of lawful organizations will be treated as parts of a single conspiracy, and many of the people helping us will be arrested before they ever understand what they have been accused of joining."
bailMissions[2].dialog.acceptText = "I will recover Rusk's surveillance archive."
bailMissions[2].dialog.declineText = "This assignment asks more than discretion, and I will not disguise that fact. But Rusk's archive grows more dangerous with every name added to it."
bailMissions[2].dialog.completed = "This is more extensive than I feared. Rusk was not merely watching suspected dissidents; he was mapping every relationship around them, including relief workers, legal advocates, donors, and their families. My staff can warn most of the people in this archive before new detention orders are issued. Some, however, cannot simply disappear without abandoning entire communities. Recovering these records has bought us time. Now we must decide how best to use it."
bailMissions[2].dialog.information = {
	{
		prompt = "What is contained in the archive?",
		text = "Intercepted messages, travel records, donor lists, and the names of people who attend perfectly lawful meetings. Individually, most of it proves nothing. Arranged to suit Imperial Security, it can be made to describe a rebellion that does not yet exist and justify punishment before organized resistance can take shape."
	},
	{
		prompt = "Can the archive be challenged publicly?",
		text = "Only after the arrests begin. Rusk is conducting the surveillance under broad security authority, and a Senate challenge would warn his superiors that the archive matters to us. Recovering it lets us alert those in danger and learn how much of our communication the Empire can already see."
	},
	{
		prompt = "How am I supposed to obtain it?",
		text = "Intercept Lieutenant Rusk before he transfers the archive and take the data disk from him. He will be protected by Imperial personnel and will not surrender it voluntarily. Once you attack, you will be treated as a Combatant. If you accept, do so knowing this is an act against Imperial Security, not another relief delivery."
	}
}

bailMissions[3].primarySpawns[1].npcName = "Maren Quill, a community organizer"
bailMissions[3].dialog.introduction = "Rusk's archive gave us enough warning to scatter several vulnerable groups, but one name cannot simply disappear. Maren Quill organized dockworkers and farming communities against a new labor decree that permits the Empire to relocate workers without local consent. She has kept those communities supplied and united through peaceful refusal. Imperial Security intends to detain her before the next assembly and make her absence an example to everyone depending on her."
bailMissions[3].dialog.acceptText = "I will get Maren to safety."
bailMissions[3].dialog.declineText = "Maren chose to stand where others could see her. That courage deserves an honest answer from us, even if your answer is no."
bailMissions[3].dialog.information = {
	{
		prompt = "Why is Maren so important?",
		text = "Because she has taught ordinary people that they can protect one another without waiting for permission from Coruscant. She coordinates food, transport, and legal aid across communities the decree was designed to divide. Remove her without preserving that work, and fear will do what the detention order alone cannot."
	},
	{
		prompt = "Why will she agree to leave?",
		text = "She resisted when my staff first approached her. The surveillance archive changed her mind; it proves the Empire intends to arrest her entire committee if she remains visible. She will leave long enough for us to move the others and preserve their records, but she will need to hear that you were sent by my office."
	},
	{
		prompt = "What is the extraction plan?",
		text = "Meet Maren at the marked location and escort her back to Alderaanian protection. Rusk's people were already closing in when we last heard from her, so expect an interception. Avoid a confrontation if you can, but do not surrender her. Bringing Maren back alive is the only objective that matters."
	}
}

bailMissions[4].primarySpawns[1].npcName = "Davo Sorn, an antiquities broker"
bailMissions[4].primarySpawns[1].fixedSpawn = {x=9.0, z=0.5, y=-2.5, direction=-90, cellID=37000721}
bailMissions[4].staticCellID = 37000721
bailMissions[4].dialog.introduction = "Maren is safe, and the communities around her are reorganizing before the Empire can identify their new lines of support. You have now carried information, recovered what Imperial Security stole, and protected someone whose work is larger than any one mission. Those acts have also made you visible. If you intend to continue, you will need contacts beyond Alderaan and a better understanding of how such efforts remain separate while still serving the same purpose. A Coruscant antiquities dealer named Luthen Rael may be willing to speak with you."
bailMissions[4].dialog.acceptText = "I will deliver the inquiry to Sorn and return to you."
bailMissions[4].dialog.declineText = "That may be the wiser choice. Once you enter Luthen's world, good intentions will protect neither you nor the people around you."
bailMissions[4].dialog.completed = "I have received word from Davo Sorn. The inquiry was accepted, and an appointment has been made for you to meet with Luthen. Proceed to his shop in the Collective Commerce District on Coruscant. Luthen has agreed to receive you. Listen to what he asks, and what he does not say."
bailMissions[4].dialog.information = {
	{
		prompt = "Why an antiquities dealer?",
		text = "Because Luthen Rael is, quite genuinely, an antiquities dealer. His profession gives him reason to travel, meet private collectors, and move objects whose histories invite few public questions. Anything beyond that is his to tell you, if he decides that you should hear it."
	},
	{
		prompt = "Why introduce me to him now?",
		text = "Because courage without discipline creates casualties, and a network tied too closely to one senator can be destroyed with one investigation. Luthen understands compartmentalization, procurement, and the difference between a useful risk and a wasted life. Your work for Mira suggests you may understand those things as well. He will make his own judgment."
	},
	{
		prompt = "How do I make contact?",
		text = "Deliver this antiquities inquiry to Davo Sorn, a broker who handles acquisitions for Luthen's gallery. It contains nothing incriminating; its wording is the introduction. After the handoff, return here and report to me. I will confirm whether Luthen has accepted the introduction and tell you where to meet him. Do not approach Luthen before you have heard that confirmation."
	}
}

local luthenMissions = {
	makeMission("retrieve", "coruscant", "Recover a disputed antiquity", "theme_park_rebel_private_collector", "a private collector", "object/tangible/loot/misc/artifact_rare_s01.iff", "Disputed antiquity", nil, reward(700),
		"A client has mistaken possession for ownership. Recover a ceremonial vessel from him and return it to this gallery. You are retrieving art. Maintain that fiction.", "Recover the vessel, discuss nothing beyond its provenance, and return directly to me.", "The collector still has my property. Every delay gives him another opportunity to discover what he bought.", "The vessel is intact, and so is what was concealed inside it. You followed the instruction without demanding the whole design. That is rarer than discretion."),
	makeMission("confiscate", "coruscant", "Replace an Imperial cargo manifest", "imperial_staff_corporal", "an Imperial freight clerk", "object/tangible/mission/mission_datadisk.iff", "Imperial cargo manifest", twoTroopers, reward(775),
		"Corporal Jeran Voss carries tomorrow's certified inspection manifest. He spends his after-hours in a bar on lower city level 1312. Recover the manifest there and return it before his next shift.", "Find Jeran in the level 1312 bar, recover the official manifest, and return directly to me. My people will make the substitution.", "Jeran still has the manifest, and his next shift begins soon. The replacement is useless if the original reaches the freight office.", "The substitution is complete. By morning, several crates of generators, medicine, and communications parts will exist only as restoration supplies for respectable galleries."),
	makeMission("deliver", "coruscant", "Deliver an extraction packet to Tessa Kord", "theme_park_rebel_civilian_contact", "a compromised courier", "object/tangible/mission/mission_datadisk.iff", "Sealed extraction packet", nil, reward(850),
		"Tessa Kord missed two check-ins after reporting surveillance. She cannot come to this gallery without exposing everyone connected to it. Deliver a sealed extraction packet to her hiding place and return with her account of what happened.", "Give Tessa the packet, ask only whether she was followed to the hiding place, and return directly to me. The credentials inside will let her leave Coruscant through a route neither of you knows.", "Tessa is still waiting. The longer she remains in one place, the more likely Imperial Security is to reconstruct her movements.", "Tessa is alive, and she was not followed to the hiding place. The route is burned, the safe locations are being emptied, and everyone she knew will have to disappear from her life. Survival has costs the survivor is seldom allowed to choose."),
	makeMission("assassinate", "coruscant", "Silence an Imperial informant", "theme_park_rebel_bounty_hunter", "an Imperial informant", nil, nil, twoTroopers, reward(925),
		"An informant named Pell Daro has sold the names of an entire workers' circle. He will deliver them to Imperial Security tonight. Stop the transfer permanently.", "Find Pell, make certain the list cannot be recovered, and do not let anyone trace you back to this gallery.", "Pell is preparing to deliver those names. If he reaches Imperial Security, the arrests will begin before dawn.", "The list will not be delivered. The workers will wake tomorrow believing they were merely fortunate. Let them. The people who remain innocent of this work are the reason we accept its cost."),
	makeMission("retrieve", "coruscant", "Acquire military power regulators", "theme_park_rebel_hyperdrive_seller", "an unlicensed component dealer", "object/tangible/loot/misc/hyperdrive_part_s01.iff", "Military power regulators", nil, reward(1000, 100),
		"An unlicensed dealer has military power regulators meant for an Imperial buyer. Acquire them and return them here. They are needed by Saw Gerrera's cell on Lok.", "Recover the regulators and bring them back to me. I will arrange their movement; you will carry only an introduction to Saw.", "The regulators must not enter the Imperial supply chain. Recover them before the dealer completes the sale.", "The regulators are already being moved through channels that cannot identify this shop. Saw Gerrera has been told to expect you on Lok. He is not part of my network, and an introduction is not protection. Remember both facts.")
}

luthenMissions[1].primarySpawns[1].npcName = "Calo Venn, a private collector"
luthenMissions[1].primarySpawns[1].fixedSpawn = {x=6.1, z=-0.7, y=-9.8, direction=-53, cellID=37000316}
luthenMissions[1].secondarySpawns = {
	{npcTemplate="bh_bodyguard", npcName="Casino Security", fixedSpawn={x=8.0, z=-0.7, y=-8.5, direction=-125, cellID=37000316}},
	{npcTemplate="bh_bodyguard", npcName="Casino Security", fixedSpawn={x=4.2, z=-0.7, y=-11.2, direction=40, cellID=37000316}}
}
luthenMissions[1].staticCellID = 37000316
luthenMissions[1].allowTargetCombat = true
luthenMissions[1].aggroSecondaryOnPrimaryAttack = true
luthenMissions[1].dialog.introduction = "Ah, Bail's new acquaintance. Welcome. You have arrived at an unusually fortunate moment; I have just received a piece from the old Hosnian schools, all severity from a distance and exquisite compromise up close. That is the trouble with history: everyone admires the finished object, and no one wishes to discuss what it cost. Now, the door is closed, so we can stop admiring it. Bail believes you can follow an instruction without turning curiosity into a liability. I prefer evidence."
luthenMissions[1].dialog.acceptText = "I will recover the vessel and preserve the fiction."
luthenMissions[1].dialog.declineText = "Then enjoy the gallery. A person may appreciate history without volunteering to become part of it."
luthenMissions[1].dialog.information = {
	{
		prompt = "What am I recovering?",
		text = "A ceremonial vessel purchased by Calo Venn, a collector with more appetite than judgment. Publicly, the piece was removed from my inventory during a disputed consignment. Privately, a compartment in its base contains a routing cipher. Calo does not know it is there. I would like to preserve his ignorance."
	},
	{
		prompt = "Why is the vessel so important?",
		text = "Because there is a routing cipher concealed in its base. Imperial inspectors understand contraband, weapons, and encrypted transmitters. They become impatient when confronted with provenance records and dead civilizations. My profession gives me a reason to move objects, meet wealthy strangers, and resent questions. A useful cover is one that remains true when examined."
	},
	{
		prompt = "Why send me?",
		text = "Because Bail trusts your intentions, and intentions are the least interesting part of a person. I need to know whether you can control your curiosity, preserve a harmless explanation, and return with exactly what I requested. Never carry anything you do not control, including the questions you ask."
	}
}

luthenMissions[2].primarySpawns[1].npcName = "Corporal Jeran Voss, an Imperial freight clerk"
luthenMissions[2].primarySpawns[1].fixedSpawn = {x = -28.3, z = -0.9, y = 22.6, direction = 103, cellID = 37000979}
luthenMissions[2].secondarySpawns = {
	{npcTemplate = "stormtrooper", npcName = "an Imperial escort", fixedSpawn = {x = -30.3, z = -0.9, y = 22.6, direction = 103, cellID = 37000979}},
	{npcTemplate = "stormtrooper", npcName = "an Imperial escort", fixedSpawn = {x = -26.3, z = -0.9, y = 22.6, direction = 103, cellID = 37000979}}
}
luthenMissions[2].staticCellID = 37000979
luthenMissions[2].dialog.introduction = "Calo will complain loudly, which is useful. A wounded collector is far more convincing than a silent conspirator. The cipher was untouched, and you did not decorate the assignment with improvisation. Good. Now we move from concealment to sabotage. Tomorrow morning, an Imperial freight office will inspect a shipment entering the district. Corporal Jeran Voss carries the only certified copy of its manifest. Fortunately, Jeran prefers to spend his after-hours drinking in a bar on lower city level 1312, far from the discipline of his post. We are going to change what the Empire believes it has seen."
luthenMissions[2].dialog.acceptText = "I will find Jeran, recover the manifest, and return before his shift."
luthenMissions[2].dialog.declineText = "Then leave it. An operation survives a refusal more easily than a reluctant participant."
luthenMissions[2].dialog.information = {
	{
		prompt = "What is in the shipment?",
		text = "Medical stores, compact generators, transmitter components, and machine tools. Nothing glorious. Glory does not keep a clinic lit or a hidden transmitter alive. Rebellion begins with ordinary things placed where the Empire has decided they may not go."
	},
	{
		prompt = "How will changing one manifest help?",
		text = "The replacement lists the crates as conservation equipment for several respectable galleries. The seals, routing numbers, and authorization chain will agree because careful people have spent weeks making them agree. We do not need to defeat the Imperial system. We need it to perform the wrong task with complete confidence."
	},
	{
		prompt = "Where will I find Jeran?",
		text = "In his preferred bar on lower city level 1312. It is a rough district even by lower-city standards. Bar fights, robberies, and bodies in alleys are common enough that the authorities seldom investigate unless someone important complains. Jeran will have two escorts, but no one there will raise an eyebrow if an Imperial freight clerk is gunned down. Once you attack, the Empire will recognize you as an enemy. Recover the manifest and leave before anyone decides the disturbance is worth remembering."
	}
}

luthenMissions[3].primarySpawns[1].npcName = "Tessa Kord, a compromised courier"
luthenMissions[3].primarySpawns[1].fixedSpawn = {x = 4.5, z = -0.9, y = -16.4, direction = -98, cellID = 37000114}
luthenMissions[3].staticCellID = 37000114
luthenMissions[3].dialog.introduction = "The shipment cleared inspection. Somewhere beyond this district, people who will never know your name are unpacking the means to endure another month. That is victory at this stage: small, invisible, and never sufficient. One of the couriers who made that route possible has missed two check-ins. Tessa Kord reported surveillance before her comlink went silent. She reached a temporary hiding place, but bringing her to this gallery would turn caution into catastrophe. You will carry the means for her to disappear without bringing her anywhere near me."
luthenMissions[3].dialog.acceptText = "I will deliver the packet and return with Tessa's account."
luthenMissions[3].dialog.declineText = "Then I will close the route without her. That is colder, but delay would be crueler to everyone else using it."
luthenMissions[3].dialog.information = {
	{
		prompt = "Who is Tessa?",
		text = "A records clerk who learned that famine figures were being revised to justify new requisitions. She began moving messages for us because facts are useless when they cannot reach anyone willing to act on them. She is disciplined, observant, and now frightened. Do not confuse fear with betrayal. Do not confuse affection with proof of innocence."
	},
	{
		prompt = "What do you mean by compromised?",
		text = "It means I no longer control the conditions around her. Imperial Security may have followed her, fed her instructions, or allowed her to run so that she would expose the rest of us. You will ask whether anyone followed her to the hiding place and listen carefully to the answer. Do not mention this gallery, and do not invite her to follow you."
	},
	{
		prompt = "What is in the extraction packet?",
		text = "Forged transit credentials, enough credits to avoid official lodging, and a sequence of instructions that reveals only the next step. Tessa will move herself through people who cannot identify one another. Neither you nor she will know the complete route. That ignorance is part of the protection."
	},
	{
		prompt = "What happens to Tessa afterward?",
		text = "If her account holds together, the credentials will carry her off Coruscant under a new identity. This route will be dismantled either way. Tessa may survive and still lose her work, her home, and everyone who knows her. We ask people to sacrifice before we have earned the right to promise them a better world. Remember that when this begins to feel simple."
	}
}

luthenMissions[4].primarySpawns[1].npcName = "Pell Daro, an Imperial informant"
luthenMissions[4].primarySpawns[1].fixedSpawn = {x = -34, z = 40, y = 3120, cellID = 0}
luthenMissions[4].staticLoc = {{x = -34, y = 3120}}
luthenMissions[4].dialog.introduction = "Tessa was not turned. She was followed because someone sold the route from the other end. Pell Daro has spent months attending workers' meetings, listening to people speak as though solidarity made a room private. Tonight he intends to sell Imperial Security the names of everyone in that circle. If the transfer occurs, arrests begin before dawn. There is no extraction to arrange and no document we can replace. Pell must not complete the sale."
luthenMissions[4].dialog.acceptText = "I understand. Pell will not deliver the names."
luthenMissions[4].dialog.declineText = "Keep your refusal. It may be the last uncomplicated thing you own. I will still stop him."
luthenMissions[4].dialog.information = {
	{
		prompt = "Are you certain he is the informant?",
		text = "Three fragments of information were given to three people. Only Pell's fragment appeared in an Imperial detention order. We repeated the test. The result was the same. Certainty is expensive, so I paid for it before asking you to pay the consequence."
	},
	{
		prompt = "Can we move the workers instead?",
		text = "Some care for children, infirm parents, and entire neighborhoods. Moving them all would confirm the conspiracy Pell invented and abandon everyone who depends on them. Even if we succeeded, he would sell the next circle. Mercy for one informant becomes a sentence imposed on strangers."
	},
	{
		prompt = "Why ask me to do this?",
		text = "Because you have seen what our small victories require, and because I need to know whether you understand that resistance is not made clean by calling it necessary. If you accept, do not tell yourself Pell forced your hand. You will choose a life against many others. Own the choice, or do not make it."
	}
}

luthenMissions[5].primarySpawns[1].npcName = "Naro Bel, an unlicensed component dealer"
luthenMissions[5].primarySpawns[1].fixedSpawn = {x = 0.8, z = 0.2, y = 2.0, direction = -16, cellID = 37000714}
luthenMissions[5].staticCellID = 37000714
luthenMissions[5].dialog.introduction = "The workers' circle is safe. They will never know how close they came to disappearing into detention cells, and they should not have to thank us for preventing it. You have now carried secrets, altered an Imperial process, recovered one of our own, and accepted a consequence no speech can improve. I have one final task before I introduce you to a man who has little use for speeches. Saw Gerrera needs military power regulators on Lok. An unlicensed dealer named Naro Bel has a set promised to an Imperial buyer. Recover them first."
luthenMissions[5].dialog.acceptText = "I will recover the regulators and return them to you."
luthenMissions[5].dialog.declineText = "Then Saw remains my problem, not yours. There are worse boundaries to keep."
luthenMissions[5].dialog.information = {
	{
		prompt = "What does Saw need them for?",
		text = "Field generators, encrypted transmitters, and machinery his people keep alive by rebuilding it faster than it fails. Regulators are mundane enough to disappear in commerce and controlled tightly enough to cripple a cell that lacks them. The Empire understands that wars can be prevented by denying people the parts required to begin one."
	},
	{
		prompt = "Is Saw part of your network?",
		text = "No. That distinction protects both of us. Saw acts directly, accepts casualties I work to avoid, and believes caution becomes surrender long before I do. He is also fighting the same machinery of fear, and he has people who need what we can provide. Cooperation is not control. Never mistake one for the other."
	},
	{
		prompt = "Why send me to meet him?",
		text = "Because Saw judges commitment in person, and because the next stage of this work cannot be conducted entirely through galleries and senatorial offices. Return the regulators to me; my channels will move them without tying you to the shipment. Then go to Lok with only my introduction. Saw will decide what use he has for you."
	}
}

local sawMissions = {
	makeMission("assassinate", "lok", "Eliminate an Imperial sensor patrol", "stormtrooper_squad_leader", "an Imperial patrol leader", nil, nil, twoTroopers, reward(1075),
		"An Imperial patrol is mapping this region. Wipe it out before it transmits its survey.", "Leave nothing that can identify this camp.", "That patrol is still closing in.", "They will send another. Next time we will be ready sooner."),
	makeMission("confiscate", "lok", "Recover stolen demolition charges", "theme_park_rebel_pirate", "a pirate quartermaster", "object/tangible/component/item/quest_item/directional_sensor.iff", "Demolition detonators", nil, reward(1150),
		"Pirates stole detonators from one of my teams. Recover them.", "The detonators belong to the fight, not profiteers.", "The pirates still have our detonators.", "We can replace explosives. Trained people are harder to replace."),
	makeMission("escort", "lok", "Rescue a Partisan demolition specialist", "theme_park_rebel_field_contact", "a Partisan demolition specialist", nil, nil, twoTroopers, reward(1225),
		"One of my demolition specialists is cut off beyond an Imperial sweep. Bring her home.", "She knows what this cell is building. Do not let her be captured.", "My specialist is still out there.", "She will be back at work before the next charge is wired."),
	makeMission("confiscate", "lok", "Seize industrial power converters", "imperial_first_lieutenant", "an Imperial logistics officer", "object/tangible/mission/mission_datadisk.iff", "Power-converter release codes", twoTroopers, reward(1300),
		"An Imperial convoy carries industrial power converters. Take its release codes.", "We are taking back tools built with stolen labor.", "The convoy will move soon.", "Some converters stay here. The rest go to the jungle cell."),
	makeMission("assassinate", "lok", "Destroy an Imperial reprisals unit", "imperial_general", "an Imperial reprisals commander", nil, nil, twoTroopers, reward(1375, 125),
		"The officer who ordered reprisals against a mining settlement is traveling with his unit. End his campaign.", "This is not a warning. Remove the unit.", "That commander is still free to murder civilians.", "The people he intended to kill will call it survival.")
}

local mothmaMissions = {
	makeMission("deliver", "chandrila", "Deliver protected foundation records", "theme_park_rebel_civilian_contact", "a foundation trustee", "object/tangible/mission/mission_datadisk.iff", "Protected foundation records", nil, reward(1450),
		"Deliver these charitable foundation records before an Imperial examiner arrives.", "Nothing in them is illegal. That will not protect the people named.", "The trustee must receive the records first.", "The foundation can continue without exposing its donors."),
	makeMission("escort", "chandrila", "Protect a Chandrilan labor organizer", "theme_park_rebel_civilian_contact", "a Chandrilan labor organizer", nil, nil, twoTroopers, reward(1525),
		"A labor organizer is accused of sedition for opposing compulsory quotas. Escort him to a legal delegation.", "His cause must remain public and peaceful.", "The delegation cannot proceed without him.", "The hearing will go forward. Public resistance still matters."),
	makeMission("confiscate", "chandrila", "Recover an Imperial surveillance index", "imperial_first_lieutenant", "an Imperial security liaison", "object/tangible/mission/mission_datadisk.iff", "Surveillance index", twoTroopers, reward(1600),
		"A security liaison compiled an index of opposition figures. Recover it before transmission.", "Make its disappearance appear to be bureaucratic incompetence.", "The index remains in Imperial hands.", "We can protect these people without revealing how we learned of the danger."),
	makeMission("deliver", "chandrila", "Secure a civilian shipping charter", "theme_park_rebel_civilian_contact", "an independent shipping representative", "object/tangible/mission/mission_datadisk.iff", "Civilian shipping charter", nil, reward(1675),
		"An independent carrier may service remote settlements. Deliver this charter and confirm its cooperation.", "The cargo is relief and construction material. Much of it truly is.", "We need that shipping commitment.", "A legitimate, regular, unremarkable route is a valuable route."),
	makeMission("escort", "chandrila", "Extract a threatened industrial supplier", "theme_park_rebel_technician_contact", "an industrial supplier", nil, nil, twoTroopers, reward(1750, 150),
		"The supplier who provided our generators has been threatened. Bring her to the Hanna City hotel.", "She risked herself for people she has never met.", "The supplier must be extracted tonight.", "She is safe. Her equipment is already being routed to Yavin Four.")
}

local yavinMissions = {
	makeMission("escort", "yavin4", "Escort a power engineer to the Yavin cell", "theme_park_rebel_technician_contact", "a resistance power engineer", nil, nil, nil, reward(1825),
		"Find the engineer who can synchronize our new generators and escort them through the jungle.", "An Imperial patrol would be worse than the wildlife.", "The engineer has not reached the base.", "We can now power the infirmary and communications room together."),
	makeMission("confiscate", "yavin4", "Recover stolen construction supplies", "theme_park_rebel_pirate", "a supply thief", "object/tangible/mission/mission_datadisk.iff", "Stolen supply locator", nil, reward(1900),
		"A thief intercepted part of our construction shipment. Recover its locator.", "We cannot request replacements without exposing the route.", "Recover those supplies.", "The missing crates are accounted for."),
	makeMission("retrieve", "yavin4", "Retrieve a long-range transmitter", "theme_park_rebel_supervisor", "a stranded communications technician", "object/tangible/loot/tool/recording_rod_broken.iff", "Long-range transmitter core", nil, reward(1975),
		"A communications team abandoned a transmitter core during an animal attack. Retrieve it.", "Without it, this cell remains isolated.", "The transmitter core is still in the jungle.", "We can communicate without commercial relays."),
	makeMission("assassinate", "yavin4", "Destroy an Imperial reconnaissance team", "stormtrooper_squad_leader", "an Imperial reconnaissance leader", nil, nil, twoTroopers, reward(2050),
		"An Imperial reconnaissance team landed beyond our watch. Stop it before it identifies the temple.", "No transmission can leave that team.", "The reconnaissance team is still within reporting range.", "The Empire will record another lost jungle patrol."),
	makeMission("escort", "yavin4", "Guide the first regular supply convoy to Yavin", "theme_park_rebel_field_contact", "a resistance convoy scout", nil, nil, twoTroopers, reward(2200, 300, true),
		"Meet the first regular convoy's scout and guide them past the Imperial search pattern.", "If this works, Yavin becomes more than a temporary camp.", "The convoy cannot approach until its scout reaches us.", "What began as scattered favors is now a supply line, and a supply line can sustain a rebellion.")
}

local npcMapRebel = {
	{spawnData = {planetName="alderaan", npcTemplate="alderaan_relief_attache", x=-20.9, z=3.2, y=22.2, direction=-90, cellID=610000026, position=STAND}, worldPosition={x=1120,y=-1420}, useNpcWorldPosition=true, npcNumber=1, stfFile="", missions=attacheMissions, noFactionDialog="The Alderaanian Relief Office accepts donations through the public registry. If you require assistance, a clerk can direct you.", lockedDialog="The relief office cannot discuss protected cases with you.", completedDialog="Senator Organa is expecting you."},
	{spawnData = {planetName="alderaan", npcTemplate="bail_organa", x=-35.3, z=1.3, y=-2.8, direction=84, cellID=610000025, position=STAND, existingSpawn=true}, worldPosition={x=1120,y=-1420}, useNpcWorldPosition=true, useCellWorldPosition=true, existingObjectIdLabel="alderaCity:bailOrganaObjectID", npcNumber=2, stfFile="", missions=bailMissions, noFactionDialog="I am afraid you have mistaken a public audience for a private appointment. My staff can assist with official senatorial business.", lockedDialog="My Attache handles relief matters. Please speak with her first.", completedDialog="Luthen's shop is in the Collective Commerce District on Coruscant. He is expecting you."},
	{spawnData = {planetName="coruscant", npcTemplate="luthen_rael", x=1.0,z=0.9,y=3.2,direction=180,cellID=37002117,position=STAND}, worldPosition={x=-1918,y=-134}, npcNumber=4, stfFile="", missions=luthenMissions, noFactionDialog="Welcome. The gallery is open, though I am afraid today's private appointments are already spoken for. Please, take your time with the collection. Antiquities reward patience, and discretion even more so.", lockedDialog="I remember you, of course. Senatorial circles do send the most fascinating clients. Our business, however, cannot proceed until your earlier obligation is complete. Provenance matters; one unfinished history can compromise an entire collection.", completedDialog="Saw Gerrera is waiting on Lok. Go without the regulators; they are traveling by a safer route. Give him my name once, then let him decide what it is worth. He is not part of my network, and an introduction is not trust."},
	{spawnData = {planetName="lok", npcTemplate="saw_gerrera", x=-5660,z=62,y=-4820,direction=45,cellID=0,position=STAND}, worldPosition={x=-5660,y=-4820}, npcNumber=8, stfFile="", missions=sawMissions, noFactionDialog="You took a wrong turn. Leave before my people decide you were scouting the camp.", lockedDialog="Luthen did not clear you to speak for him.", completedDialog="The supplies are moving. Mothma will decide what becomes of them."},
	{spawnData = {planetName="chandrila", npcTemplate="mon_mothma", x=6,z=0.6,y=-5.5,direction=-90,cellID=35791665,position=STAND}, worldPosition={x=294,y=-2938}, npcNumber=16, stfFile="", missions=mothmaMissions, noFactionDialog="I am here on senatorial business. Please direct constituency matters to my staff.", lockedDialog="I am here on senatorial business.", completedDialog="The final shipments are being routed to a small cell on Yavin Four."},
	{spawnData = {planetName="yavin4", npcTemplate="yavin_cell_commander", x=-25,z=32,y=68,direction=180,cellID=3465358,position=STAND}, worldPosition={x=-3050,y=-2950}, npcNumber=32, stfFile="", missions=yavinMissions, noFactionDialog="This is restricted territory. Turn around, leave by the route you used, and do not return.", lockedDialog="This facility is not open to visitors.", completedDialog="The route is holding. You helped turn an isolated cell into something that can endure."}
}

local sceneObjectMapRebel = {
	-- Luthen's public gallery. The end-table mesh has a low pivot, so the plinths sit at 1.0.
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=-0,z=0.9,y=5.1,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=-0,z=1.3,y=5.1,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/loot/misc/artifact_rare_s01.iff",x=-0,z=1.75,y=5.1,cellID=37002117,dw=0.9239,dx=0,dy=0.3827,dz=0},customObjectName="Ancient Ceremonial Vessel"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=2.0,z=0.9,y=5.1,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=2.0,z=1.3,y=5.1,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/item/lytus_family_artefact.iff",x=2.0,z=1.75,y=5.1,cellID=37002117,dw=0.7071,dx=0,dy=0.7071,dz=0},customObjectName="Pre-Republic Devotional Sculpture"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=4.0,z=0.9,y=5.1,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=4.0,z=1.3,y=5.1,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/tatooine/frn_tato_vase_style_02.iff",x=4.0,z=1.75,y=5.1,cellID=37002117,dw=0.9239,dx=0,dy=-0.3827,dz=0},customObjectName="Outer Rim Funerary Urn"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/all/frn_all_lamp_free_s03_lit.iff",x=-10.3,z=0.9,y=2.9,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Gallery Light"},
	{spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/all/frn_all_lamp_free_s03_lit.iff",x=-1.8,z=0.9,y=0.8,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Gallery Light"},

  --
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=7.2,z=0.9,y=0.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=7.2,z=1.3,y=0.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/tatooine/frn_tato_vase_style_01.iff",x=7.2,z=1.75,y=0.5,cellID=37002117,dw=0.9239,dx=0,dy=0.3827,dz=0},customObjectName="Gilded Tatooine Ceremonial Vase"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=4.7,z=0.9,y=0.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=4.7,z=1.3,y=0.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/all/frn_all_decorative_sm_s1.iff",x=4.7,z=1.75,y=0.5,cellID=37002117,dw=0.7071,dx=0,dy=0.7071,dz=0},customObjectName="Old Republic Reliquary"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=1.5,z=0.9,y=0.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=1.5,z=1.3,y=0.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/all/frn_all_decorative_sm_s2.iff",x=1.5,z=1.75,y=0.5,cellID=37002117,dw=0.9239,dx=0,dy=-0.3827,dz=0},customObjectName="Archaic Navigation Instrument"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=2.7,z=0.9,y=2.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/elegant/end_table_s01.iff",x=2.7,z=1.2,y=2.5,cellID=37002117,dw=1,dx=0,dy=0,dz=0},customObjectName="Antiquities Plinth"},
  {spawnData={planetName="coruscant",objectTemplate="object/tangible/furniture/all/frn_all_decorative_sm_s3.iff",x=2.7,z=1.75,y=2.5,cellID=37002117,dw=0.7071,dx=0,dy=0.7071,dz=0},customObjectName="Pre-Imperial Court Sculpture"},

	{spawnData={planetName="lok",objectTemplate="object/static/structure/corellia/corl_tent_hut_s01.iff",x=-5665,z=62,y=-4818,cellID=0,dw=0.9239,dx=0,dy=0.3827,dz=0},customObjectName="Partisan Field Shelter"},
	{spawnData={planetName="lok",objectTemplate="object/static/structure/corellia/corl_tent_hut_s01.iff",x=-5656,z=62,y=-4826,cellID=0,dw=0.3827,dx=0,dy=0.9239,dz=0},customObjectName="Partisan Supply Shelter"},
	{spawnData={planetName="lok",objectTemplate="object/static/structure/general/campfire_smoldering.iff",x=-5660,z=62,y=-4823,cellID=0,dw=1,dx=0,dy=0,dz=0},customObjectName="Banked Campfire"},
	--{spawnData={planetName="lok",objectTemplate="object/static/structure/general/ins_shield_generator_stage1.iff",x=-5652,z=62,y=-4818,cellID=0,dw=0.7071,dx=0,dy=0.7071,dz=0},customObjectName="Salvaged Field Generator"}
}

ThemeParkRebel = ThemeParkLogic:new {
	npcMap=npcMapRebel, sceneObjectMap=sceneObjectMapRebel, permissionMap={},
	className="ThemeParkRebel", screenPlayState="rebel_theme_park", missionDescriptionStf="",
	missionCompletionMessageStf="@theme_park/messages:rebel_completion_message",
	requiredPlanets={"alderaan","coruscant","lok","chandrila","yavin4"}, faction=FACTIONREBEL, allowOnLeave=true
}

registerScreenPlay("ThemeParkRebel", true)

function ThemeParkRebel:spawnNpcs()
	if not ThemeParkLogic.spawnNpcs(self) then return false end

	local partisans = {
		{"rebel_commando", "a Partisan sentry", -5668, -4826, -135},
		{"rebel_commando", "a Partisan sentry", -5668, -4812, -45},
		{"rebel_commando", "a Partisan sentry", -5650, -4812, 45},
		{"rebel_commando", "a Partisan sentry", -5650, -4828, 135},
		{"rebel_specforce_urban_guerrilla", "a Partisan fighter", -5662, -4825, 45},
		{"rebel_specforce_urban_guerrilla", "a Partisan fighter", -5659, -4826, -20},
		{"rebel_specforce_urban_guerrilla", "a Partisan fighter", -5658, -4822, -100},
		{"rebel_specforce_urban_guerrilla", "a Partisan fighter", -5663, -4822, 110},
		{"rebel_trooper", "a Partisan supply handler", -5658, -4829, 90},
		{"rebel_trooper", "a Partisan supply handler", -5653, -4829, -90},
		{"rebel_trooper", "a Partisan mechanic", -5652, -4815, 180},
		{"rebel_trooper", "a Partisan mechanic", -5649, -4818, -90}
	}
	for _, partisan in ipairs(partisans) do
		local pNpc = spawnMobile("lok", partisan[1], 60, partisan[3], 62, partisan[4], partisan[5], 0)
		if pNpc == nil then
			printLuaError("ThemeParkRebel: unable to spawn Partisan camp NPC.")
			return false
		end
		CreatureObject(pNpc):setCustomObjectName(partisan[2])
		AiAgent(pNpc):addObjectFlag(AI_STATIONARY)
	end
	return true
end

local function getDialog(themePark, pPlayer, pNpc)
	local number = themePark:getNpcNumber(pNpc)
	local current = themePark:getMission(number, themePark:getCurrentMissionNumber(number, pPlayer))
	return current ~= nil and current.dialog or nil
end

local function addInformationOptions(screen, dialog, currentTopic)
	screen:removeAllOptions()

	if currentTopic == 3 then
		screen:addOption(dialog.acceptText or "I will take the assignment.", "accept")
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
	local result=mission_giver_conv_handler.handleScreenNpc3(self,t,p,n,o,s); local screen=LuaConversationScreen(result); local d=getDialog(self.themePark,p,n); if d~=nil and d.declineText~=nil then screen:setCustomDialogText(d.declineText) else screen:setCustomDialogText("Then we have nothing further to discuss.") end; screen:setStopConversation(true); return result
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
function theme_park_rebel_mission_giver_conv_handler:giveSawWaypoint(pPlayer)
	if pPlayer == nil then return end
	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local sawData = self.themePark:getNpcData(8)
	if pGhost == nil or sawData == nil then return end
	local spawn = sawData.spawnData
	PlayerObject(pGhost):removeWaypointBySpecialType(WAYPOINTTHEMEPARK)
	PlayerObject(pGhost):addWaypoint(spawn.planetName, "Meet Saw Gerrera", "", spawn.x, spawn.z, spawn.y, WAYPOINT_PURPLE, true, true, WAYPOINTTHEMEPARK, 0)
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenReward(t,p,n,o,s)
	local npcNumber = self.themePark:getNpcNumber(n)
	local missionNumber = self.themePark:getCurrentMissionNumber(npcNumber,p)
	local d=getDialog(self.themePark,p,n); local result=mission_giver_conv_handler.handleScreenReward(self,t,p,n,o,s); if d~=nil then LuaConversationScreen(result):setCustomDialogText(d.completed) end
	if npcNumber == 4 and missionNumber == #luthenMissions then self:giveSawWaypoint(p) end
	return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNotYet(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNotYet(self,t,p,n,o,s); local data=self.themePark:getNpcData(self.themePark:getNpcNumber(n)); if data~=nil then LuaConversationScreen(result):setCustomDialogText(data.lockedDialog) end; return result
end
function theme_park_rebel_mission_giver_conv_handler:handleScreenNext(t,p,n,o,s)
	local result=mission_giver_conv_handler.handleScreenNext(self,t,p,n,o,s); local npcNumber=self.themePark:getNpcNumber(n); local data=self.themePark:getNpcData(npcNumber); if data~=nil then LuaConversationScreen(result):setCustomDialogText(data.completedDialog) end
	if npcNumber == 4 then self:giveSawWaypoint(p) end
	return result
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
	local npcNumber=self.themePark:getActiveNpcNumber(p); local missionNumber=self.themePark:getCurrentMissionNumber(npcNumber,p)
	local result=mission_target_conv_handler.handleScreenSmuggle(self,t,p,n,o,s); local screen=LuaConversationScreen(result)
	if npcNumber==2 and missionNumber==4 then
		screen:setCustomDialogText("The inquiry is in order. I will send word through the agreed channel. Return to Senator Organa and wait for him to confirm whether an appointment has been made. Do not approach Luthen's shop before you receive that confirmation.")
	else
		screen:setCustomDialogText("You are the contact? Good. Let us finish before anyone notices.")
	end
	return result
end
function theme_park_rebel_mission_target_conv_handler:handleScreenTakeMe(t,p,n,o,s)
	local result=mission_target_conv_handler.handleScreenTakeMe(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("I was told someone might come. Get me out of here."); return result
end
function theme_park_rebel_mission_target_conv_handler:handleScreenBreech(t,p,n,o,s)
	local result=mission_target_conv_handler.handleScreenBreech(self,t,p,n,o,s); LuaConversationScreen(result):setCustomDialogText("You have made a serious mistake coming here."); return result
end
