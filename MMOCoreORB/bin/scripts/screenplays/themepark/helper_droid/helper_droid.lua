local ObjectManager = require("managers.object.object_manager")

HelperDroid = ScreenPlay:new {
	questsEnable = false,

	professions = {"brawler", "marksman", "scout", "artisan", "medic", "entertainer"},
	skillStrings = {"combat_brawler_novice", "combat_marksman_novice", "outdoors_scout_novice", "crafting_artisan_novice", "science_medic_novice", "social_entertainer_novice"},

	droidGreetings = {
		"@new_player:droid_greeting_begin_01",
		"@new_player:droid_greeting_begin_02",
		"@new_player:droid_greeting_begin_03",
	},

	droidSounds = {
		"sound/dro_astromech_converse.snd",
		"sound/dro_astromech_whistle.snd",
		"sound/dro_astromech_ok.snd",
	},
}

registerScreenPlay("HelperDroid", false)

function HelperDroid:spaceInformation(pDroid, pPlayer, selection)
	if (pDroid == nil or pPlayer == nil) then
		return
	end

	self:playDroidSound(pPlayer)

	local sui = SuiMessageBox.new("HelperDroid", "noCallback")
	sui.setTitle(SceneObject(pDroid):getCustomObjectName())
	sui.setProperty("", "Size", "500,200")
	sui.setProperty("btnCancel", "Visible", "false")
	sui.setForceCloseDistance(10)

	if (selection == "findShip") then
		sui.setPrompt("@new_player:space_info_how_to_find_ship")
	elseif (selection == "checkEmail") then
		sui.setPrompt("@new_player:space_info_how_to_check_email")
	elseif (selection == "travel") then
		sui.setPrompt("@new_player:space_info_how_to_travel")
	elseif (selection == "makeMoney") then
		sui.setPrompt("@new_player:space_info_how_to_make_money")
	end

	sui.sendTo(pPlayer)
end

function HelperDroid:helperInformation(pDroid, pPlayer, selection)
	if (pDroid == nil or pPlayer == nil) then
		return
	end

	self:playDroidSound(pPlayer)

	if (selection == "general") then
		CreatureObject(pPlayer):sendOpenHolocronToPageMessage("WelcomeToSWG")
	elseif (selection == "travel") then
		CreatureObject(pPlayer):sendOpenHolocronToPageMessage("Navigation.LongDistanceTravel")
	elseif (selection == "cloning") then
		CreatureObject(pPlayer):sendOpenHolocronToPageMessage("ImportantBuildings.CloningFacility")
	elseif (selection == "vehicle") then
		CreatureObject(pPlayer):sendOpenHolocronToPageMessage("WelcomeToSWG")
	end
end

function HelperDroid:noCallback(pPlayer, pSui, eventIndex, ...)
end

function HelperDroid:professionQuest(pDroid, pPlayer, profession)
	if (pDroid == nil or pPlayer == nil) then
		return
	end

	self:playDroidSound(pPlayer)

	local playerID = SceneObject(pPlayer):getObjectID()
	local questsComplete = tonumber(getQuestStatus(playerID .. ":" .. profession .. ":HelperDroid:completeQuests:"))

	if (questsComplete == nil or questsComplete == 0) then
		HelperDroidQuest:startSui(pDroid, pPlayer, profession)
	else
		HelperDroidQuest:professionQuestSui(pDroid, pPlayer, profession)
	end
end

function HelperDroid:greetPlayer(pPlayer, pDroid)
	if (pPlayer == nil or pDroid == nil) then
		return
	end
	
	local zone = SceneObject(pPlayer):getZoneName()

	if (zone == "elysium") then
		self:playDroidSound(pPlayer)

		local playerID = SceneObject(pPlayer):getObjectID()
		local droidID = SceneObject(pDroid):getObjectID()

		writeData(playerID .. ":HelperDroidID:", droidID)

		local sui = SuiListBox.new("HelperDroid", "elysiumCallback")
		sui.setTitle(SceneObject(pDroid):getCustomObjectName())
		sui.setProperty("", "Size", "500,200")
		sui.setForceCloseDistance(10)
		sui.setPrompt("@new_player:droid_greeting_begin_01 Welcome to the afterlife, would you like to learn more about being dead?")
		sui.add("How did I get here?", "")

		sui.sendTo(pPlayer)
		return
	end

	self:playDroidSound(pPlayer)

	local playerID = SceneObject(pPlayer):getObjectID()
	local droidID = SceneObject(pDroid):getObjectID()

	writeData(playerID .. ":HelperDroidID:", droidID)

	local sui = SuiListBox.new("HelperDroid", "greetingCallback")
	sui.setTitle(SceneObject(pDroid):getCustomObjectName())
	sui.setProperty("", "Size", "500,200")
	sui.setForceCloseDistance(10)

	local randomGreeting = getRandomNumber(3)
	local promptStart = self.droidGreetings[randomGreeting]
	local playerName = " \\#pcontrast1 " .. CreatureObject(pPlayer):getFirstName() .. "\\#.,"
	local promptEnd = "@new_player:droid_greeting_end"

	local firstTime = true
	local professions = self.professions
	local totalProfs = 0
	local playerProfs = {}

	-- Check players current professions to list quest options
	for i = 1, #professions, 1 do
		local string = self.skillStrings[i]

		if (CreatureObject(pPlayer):hasSkill(string)) then
			local profession = professions[i]
			local questsComplete = tonumber(getQuestStatus(playerID .. ":" .. profession .. ":HelperDroid:completeQuests:"))

			if (questsComplete ~= nil) then
				firstTime = false
			end

			totalProfs = totalProfs + 1
			playerProfs[totalProfs] = profession

			profession = profession:gsub("^%l", string.upper)
			sui.add(profession, "")
		end
	end

	writeStringVectorSharedMemory(playerID .. ":HelperDroid:playerProfessions:", playerProfs)

	if (not firstTime) then
		promptEnd = "@new_player:droid_periodic_check_end"
	end

	local prompt = promptStart ..  playerName .. " " .. promptEnd
	sui.setPrompt(prompt)

	sui.sendTo(pPlayer)
end

function HelperDroid:greetingCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed) then
		deleteData(playerID .. ":HelperDroidID:")
		return
	end

	local droidID = readData(playerID .. ":HelperDroidID:")
	local pDroid = getSceneObject(droidID)
	local playerProfs = readStringVectorSharedMemory(playerID .. ":HelperDroid:playerProfessions:")

	local argNum = #playerProfs - tonumber(args)
	local playerProf = playerProfs[argNum]

	if (playerProf == nil) then
		deleteData(playerID .. ":HelperDroidID:")
		return;
	end

	deleteData(playerID .. ":HelperDroidID:")
	deleteStringVectorSharedMemory(playerID .. ":HelperDroid:playerProfessions:")

	local questsComplete = tonumber(getQuestStatus(playerID .. ":" .. playerProf .. ":HelperDroid:completeQuests:"))

	if (pDroid ~= nil) then
		if (questsComplete == nil or questComplete == 0) then
			HelperDroidQuest:startSui(pDroid, pPlayer, playerProf)
		else
			HelperDroidQuest:professionQuestSui(pDroid, pPlayer, playerProf)
		end
	end
end

function HelperDroid:skillTrained(pDroid, pPlayer, skill)
	if (pDroid == nil or pPlayer == nil or skill == "") then
		return
	end

	local profession = ""

	for i = 1, #self.skillStrings, 1 do
		local string = self.skillStrings[i]

		if (string == skill) then
			profession = self.professions[i]

			local message = "@new_player:" .. profession .. "_added"

			self:playDroidSound(pPlayer)
			spatialChat(pDroid, message)

			createEvent(1000, "HelperDroidQuest", "giveProfessionItem", pPlayer, profession)
			break
		end
	end
end

function HelperDroid:playDroidSound(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local randSound = getRandomNumber(3)
	local sound = self.droidSounds[randSound]

	CreatureObject(pPlayer):playMusicMessage(sound)
end

function HelperDroid:elysiumCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (eventIndex == 1) then
		deleteData(playerID .. ":HelperDroidID:")
		return
	end

	local droidID = readData(playerID .. ":HelperDroidID:")
	local pDroid = getSceneObject(droidID)

	deleteData(playerID .. ":HelperDroidID:")

	if (pDroid == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return
	end

	spatialChat(pDroid, "You are here because you have died and cloned more than five times. Complex cloning data loses its integrity with each subsequent copy made. On the other hand, now you and I have an eternity to explore the Netherworld of the Force together! Hurrah!")
end

function HelperDroid:elysiumProgression(pDroid, pPlayer)
	if (pDroid == nil or pPlayer == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return
	end

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage >= ElysiumJediProgression.SHRINE_SEARCH_ACTIVE) then
		ElysiumJediProgression:syncScreenPlayState(pPlayer)
		return
	end

	self:playDroidSound(pPlayer)

	local playerID = SceneObject(pPlayer):getObjectID()
	local droidID = SceneObject(pDroid):getObjectID()

	writeData(playerID .. ":HelperDroid:ElysiumProgressionDroidID:", droidID)

	local sui = SuiListBox.new("HelperDroid", "elysiumProgressionCallback")
	sui.setTitle(SceneObject(pDroid):getCustomObjectName())
	sui.setProperty("", "Size", "500,200")
	sui.setForceCloseDistance(10)
	sui.setPrompt(ElysiumJediProgression:getDroidPrompt(pPlayer))

	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")) then
		sui.add("My path through the Force has already begun.", "")
	elseif (stage == ElysiumJediProgression.NOT_STARTED) then
		sui.add("I am ready to learn why I am here.", "")
	elseif (stage == ElysiumJediProgression.DROID_QUEST_ACTIVE) then
		sui.add("Remind me what I must do.", "")
	elseif (stage == ElysiumJediProgression.SHRINE_SEARCH_ACTIVE) then
		sui.add("Tell me again about the structure you detected.", "")
	elseif (stage == ElysiumJediProgression.NPC_SEARCH_ACTIVE) then
		sui.add("Can your sensors locate the person I must find?", "")
	else
		sui.add("Tell me what comes next.", "")
	end

	sui.sendTo(pPlayer)
end

function HelperDroid:elysiumProgressionCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local dataKey = playerID .. ":HelperDroid:ElysiumProgressionDroidID:"

	if (eventIndex == 1) then
		deleteData(dataKey)
		return
	end

	local droidID = readData(dataKey)
	local pDroid = getSceneObject(droidID)

	deleteData(dataKey)

	if (pDroid == nil or SceneObject(pPlayer):getZoneName() ~= "elysium") then
		return
	end

	if (CreatureObject(pPlayer):hasSkill("force_title_jedi_novice")) then
		spatialChat(pDroid, "Your connection to the Force has already awakened. Your path now lies beyond Elysium.")
		return
	end

	local stage = ElysiumJediProgression:getStage(pPlayer)

	if (stage == ElysiumJediProgression.NOT_STARTED) then
		if (ElysiumJediProgression:startDroidQuest(pPlayer)) then
			ElysiumJediProgression:completeDroidQuest(pPlayer)
			spatialChat(pDroid, "I can't be more precise. My sensors can't really lock onto anything here, it's like the whole place isn't actually for a lack of better term, real.")
		end
	elseif (stage == ElysiumJediProgression.DROID_QUEST_ACTIVE) then
		if (ElysiumJediProgression:completeDroidQuest(pPlayer)) then
			spatialChat(pDroid, "I can't be more precise. My sensors can't really lock onto anything here, it's like the whole place isn't actually for a lack of better term, real.")
		end
	elseif (stage == ElysiumJediProgression.SHRINE_SEARCH_ACTIVE) then
		spatialChat(pDroid, "The artificial structure is close to where you entered Elysium. You should be able to reach it on foot.")
	elseif (stage == ElysiumJediProgression.NPC_SEARCH_ACTIVE) then
		spatialChat(pDroid, "I cannot locate the individual from the structure's vision. You will have to search Elysium yourself.")
	else
		spatialChat(pDroid, ElysiumJediProgression:getDroidPrompt(pPlayer))
	end
end
