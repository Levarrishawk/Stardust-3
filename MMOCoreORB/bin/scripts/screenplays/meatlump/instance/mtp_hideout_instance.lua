-- mtp hideout instance (dungeon1 POB). ruling 2026-09-04
-- Mustafar instance shape: one building, claim on enter, timed eject.
-- Hub stays shared. This file is the per-player dungeon SOE ran in dungeon1.
-- No journal module: this branch has no managers/quest/journal.lua.
--
-- Ported here: entryb_controller at claim (delayAction:spawn_entryb_object /
-- mtp_escort_entryb_object wired to shared_mtp_hideout_instance_entryb_controller.iff),
-- escort p2 rows on startEscort, weak-security 150 HAM (ThemeParkLogic:normalizeNpc shape).
-- Named absent:
--   content_tools sequencer delayAction scripts -- Core3 has no sequencer
--   NGE combat scaling / the 65 minimum -- absent from this fork
--   mtp_hideout_instance_exit -- absent from the client; cell-1 ladder_exit stand-in stays
--   NGE instance login occupant check -- absent from this engine; session timer still ejects

MtpHideoutInstance = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "MtpHideoutInstance",
	planet = "dungeon1",
	-- SOURCED buildout/dungeon1/mtp_hideout_instance.tab:row1 server_template_crc
	buildingTemplate = "object/building/content/meatlump/mtp_instance_bunker.iff",
	-- SOURCED buildout/dungeon1/mtp_hideout_instance.tab:row1 px/py/pz
	buildingX = 150,
	buildingZ = 0,
	buildingY = 150,
	-- SOURCED instance_datatable.tab:mtp_hideout_instance enter_one
	enterCell = "entryb",
	enterX = 3.6,
	enterZ = -12.0,
	enterY = 29.7,
	-- OURS: java/brief warp. instance_datatable.tab:mtp_hideout_instance exit_one is -516,28,-4433,corellia
	exitPlanet = "corellia",
	exitX = -473,
	exitZ = -70,
	exitY = -4292,
	-- SOURCED instance_datatable.tab:mtp_hideout_instance time_limit
	sessionSeconds = 600,
	-- SOURCED questtask/mtp_hideout_instance_kill_all_droids.tab, questtask/mtp_hideout_instance_kill_specific_droids.tab,
	-- questtask/mtp_hideout_instance_recover_supplies.tab, questtask/mtp_hideout_instance_escort_trapped_meatlump.tab:
	-- row mtp_quest_timer (quest.task.ground.timer) MIN_TIME = MAX_TIME = 585 in each
	taskSeconds = 585,
	-- SOURCED instance_datatable.tab:mtp_hideout_instance max_players
	maxPlayers = 1,
	-- OURS: Mustafar copy-hold shape (live Mustafar uses 60 / 120)
	claimGrace = 15,
	sweepSeconds = 30,
}

MtpHideoutInstance.objectives = {
	{
		key = "kill_all",
		quest = "mtp_hideout_instance_kill_all_droids",
		fail = "mtp_hideout_instance_kill_all_droids_fail",
		success = "mtp_hideout_instance_kill_all_droids_success",
		enterSignal = "mtp_kill_all_droids",
		title = "@quest/ground/mtp_hideout_instance_kill_all_droids:journal_entry_title",
	},
	{
		key = "kill_specific",
		quest = "mtp_hideout_instance_kill_specific_droids",
		fail = "mtp_hideout_instance_kill_specific_droids_fail",
		success = "mtp_hideout_instance_kill_specific_droids_success",
		enterSignal = "mtp_kill_specific_droids",
		title = "@quest/ground/mtp_hideout_instance_kill_specific_droids:journal_entry_title",
	},
	{
		key = "recover_supplies",
		quest = "mtp_hideout_instance_recover_supplies",
		fail = "mtp_hideout_instance_recover_supplies_fail",
		success = "mtp_hideout_instance_recover_supplies_success",
		enterSignal = "mtp_recover_supplies",
		title = "@quest/ground/mtp_hideout_instance_recover_supplies:journal_entry_title",
	},
	{
		key = "escort",
		quest = "mtp_hideout_instance_escort_trapped_meatlump",
		fail = "mtp_hideout_instance_escort_trapped_meatlump_fail",
		success = "mtp_hideout_instance_escort_trapped_meatlump_success",
		enterSignal = "mtp_escort_trapped_meatlump",
		title = "@quest/ground/mtp_hideout_instance_escort_trapped_meatlump:journal_entry_title",
	},
}

MtpHideoutInstance.givers = {
	{ template = "dressed_meatlump_hideout_male_09", convo = "mtp_destroy_all_droids_giver_convo", cells = { "arena" } },
	{ template = "dressed_meatlump_hideout_male_08", convo = "mtp_destroy_some_droids_giver_convo", cells = { "arena" } },
	{ template = "dressed_meatlump_hideout_female_04", convo = "mtp_meatlumps_supplies_giver_convo", cells = { "arena" } },
	{ template = "dressed_meatlump_hideout_female_03", convo = "mtp_trapped_meatlump_giver_convo", cells = { "arena" } },
	{ template = "dressed_meatlump_hideout_male_07", convo = "mtp_angry_meatlump_giver_convo", cells = { "rightguardroom" } },
}

registerScreenPlay("MtpHideoutInstance", true)

function MtpHideoutInstance:start()
	if (not isZoneEnabled(self.planet)) then
		return
	end

	local pBuilding = self:ensureBuilding()

	if (pBuilding ~= nil) then
		createEvent(10000, "MtpHideoutInstance", "wireGiversDelayed", pBuilding, "")
	end
end

function MtpHideoutInstance:ensureBuilding()
	local buildingID = readData("mtpHideoutInstance:buildingID")
	local pBuilding = getSceneObject(buildingID)

	if (pBuilding ~= nil) then
		self:printCellListOnce(pBuilding)
		self:ensureExitAnalogue(pBuilding)
		return pBuilding
	end

	pBuilding = spawnSceneObject(self.planet, self.buildingTemplate, self.buildingX, self.buildingZ, self.buildingY, 0, 0)

	if (pBuilding == nil) then
		print("[meatlump] instance bunker did not spawn in dungeon1")
		return nil
	end

	buildingID = SceneObject(pBuilding):getObjectID()
	writeData("mtpHideoutInstance:buildingID", buildingID)
	createObserver(ENTEREDBUILDING, "MtpHideoutInstance", "onEnteredBuilding", pBuilding)
	createObserver(EXITEDBUILDING, "MtpHideoutInstance", "onExitedBuilding", pBuilding)
	self:printCellListOnce(pBuilding)
	self:ensureExitAnalogue(pBuilding)

	return pBuilding
end

function MtpHideoutInstance:getBuilding()
	return getSceneObject(readData("mtpHideoutInstance:buildingID"))
end

function MtpHideoutInstance:cellId(pBuilding, cellName)
	if (pBuilding == nil or cellName == nil) then
		return nil
	end

	local pCell = BuildingObject(pBuilding):getNamedCell(cellName)

	if (pCell == nil) then
		return nil
	end

	return SceneObject(pCell):getObjectID()
end

function MtpHideoutInstance:printCellListOnce(pBuilding)
	if (pBuilding == nil or readData("mtpHideoutInstance:cellsPrinted") == 1) then
		return
	end

	writeData("mtpHideoutInstance:cellsPrinted", 1)

	local total = BuildingObject(pBuilding):getTotalCellNumber()
	print("[meatlump] instance bunker cells total=" .. tostring(total))

	for i = 1, total do
		local cellName = BuildingObject(pBuilding):getCellName(i)
		local pCell = BuildingObject(pBuilding):getCell(i)
		local oid = 0

		if (pCell ~= nil) then
			oid = SceneObject(pCell):getObjectID()
		end

		print("[meatlump] instance bunker cell " .. i .. " name=" .. tostring(cellName) .. " oid=" .. tostring(oid))
	end
end

function MtpHideoutInstance:ensureExitAnalogue(pBuilding)
	if (pBuilding == nil or readData("mtpHideoutInstance:exitPlaced") == 1) then
		return
	end

	self:spawnExitAnalogue(pBuilding)
	writeData("mtpHideoutInstance:exitPlaced", 1)
end

-- triggerId column of spawning/heroic/mtp_hideout_instance.tab.
-- Values used at claim: mtp_kill_all_droids, mtp_kill_specific_droids,
-- mtp_recover_supplies, mtp_escort_trapped_meatlump (the SUI enterSignal).
-- The tab default is s[default]; every transcribed row has a concrete triggerId,
-- so no blank-trigger always-on spawn-tab rows. A nil/empty lua trigger still
-- spawns for every objective.
function MtpHideoutInstance:rowMatchesTrigger(row, triggerId)
	if (row == nil) then
		return false
	end

	if (row.trigger == nil or row.trigger == "") then
		return true
	end

	return row.trigger == triggerId
end

function MtpHideoutInstance:rememberSpawn(oid)
	if (oid == nil or oid == 0) then
		return
	end

	local n = (readData("mtpHideoutInstance:spawnCount") or 0) + 1
	writeData("mtpHideoutInstance:spawn:" .. n, oid)
	writeData("mtpHideoutInstance:spawnCount", n)
end

function MtpHideoutInstance:forgetSpawnTags(oid)
	if (oid == nil or oid == 0) then
		return
	end

	deleteStringData(oid .. ":mtpSocialGroup")
	deleteStringData(oid .. ":mtpSpawnName")
	deleteStringData(oid .. ":mtpTrigger")
	deleteStringData(oid .. ":mtpQuest")
	deleteStringData(oid .. ":mtpTask")
	deleteData(oid .. ":mtpEscortFollow")
	deleteData(oid .. ":mtpEscortOwner")
end

function MtpHideoutInstance:despawnRunPopulation()
	local occupant = readData("mtpHideoutInstance:occupant")
	local pPlayer = getSceneObject(occupant)
	local oids = {}
	local n = readData("mtpHideoutInstance:spawnCount") or 0

	for i = 1, n do
		local oid = readData("mtpHideoutInstance:spawn:" .. i)

		if (oid ~= nil and oid ~= 0) then
			oids[#oids + 1] = oid
			local pObj = getSceneObject(oid)

			if (pObj ~= nil) then
				SceneObject(pObj):destroyObjectFromWorld()
			end

			self:forgetSpawnTags(oid)
		end

		deleteData("mtpHideoutInstance:spawn:" .. i)
	end

	deleteData("mtpHideoutInstance:spawnCount")
	deleteData("mtpHideoutInstance:lostNpc")
	deleteData("mtpHideoutInstance:rescueEndpoint")

	if (occupant ~= 0) then
		deleteData(occupant .. ":mtpEscortNpc")
	end

	MtpQuestEngine.clearRunScopedState(pPlayer, occupant, oids)
end

function MtpHideoutInstance:populateForRun(pBuilding, objective)
	if (pBuilding == nil or objective == nil) then
		return
	end

	self:despawnRunPopulation()

	local triggerId = objective.enterSignal
	local rows = MtpHideoutInstancePopulation.rows

	for i = 1, #rows do
		if (self:rowMatchesTrigger(rows[i], triggerId)) then
			self:spawnRow(pBuilding, rows[i])
		end
	end

	local props = MtpHideoutInstancePopulation.props

	for i = 1, #props do
		if (self:rowMatchesTrigger(props[i], triggerId)) then
			self:spawnProp(pBuilding, props[i])
		end
	end
end

function MtpHideoutInstance:spawnRow(pBuilding, row)
	if (row.mapped == nil or row.mapped == "") then
		return
	end

	local cellID = self:cellId(pBuilding, row.cell)

	if (cellID == nil) then
		print("[meatlump] instance cell not found: " .. tostring(row.cell))
		return
	end

	local pMob = spawnMobile(self.planet, row.mapped, row.respawn or 0, row.x, row.z, row.y, row.heading or 0, cellID)

	if (pMob == nil) then
		return
	end

	local oid = SceneObject(pMob):getObjectID()
	self:rememberSpawn(oid)

	if (row.social ~= nil and row.social ~= "") then
		writeStringData(oid .. ":mtpSocialGroup", row.social)
	end

	if (row.soe ~= nil) then
		writeStringData(oid .. ":mtpSpawnName", row.soe)
	end

	if (row.trigger ~= nil) then
		writeStringData(oid .. ":mtpTrigger", row.trigger)
	end

	if (row.soe == "mtp_instance_lost_meatlump") then
		CreatureObject(pMob):setOptionBit(CONVERSABLE)
		CreatureObject(pMob):setOptionBit(INVULNERABLE)
		AiAgent(pMob):setConvoTemplate("mtp_trapped_meatlump_target_convo")
		writeData("mtpHideoutInstance:lostNpc", oid)
	elseif (row.social == "mtp_droid_target" or row.social == "mtp_security_droid") then
		CreatureObject(pMob):clearOptionBit(INVULNERABLE)
		CreatureObject(pMob):setPvpStatusBitmask(ATTACKABLE)
	end

	-- SOURCED spawning/heroic/mtp_hideout_instance.tab script mtp_instance_weak_security.
	-- ThemeParkLogic:normalizeNpc HAM loop (themeParkLogic.lua:930-947), ham=150. NGE combat scaling is absent from this fork.
	if (row.script ~= nil and string.find(row.script, "mtp_instance_weak_security", 1, true) ~= nil) then
		local ham = 150

		for i = 0, 8 do
			if (i % 3 == 0) then
				CreatureObject(pMob):setHAM(i, ham)
				CreatureObject(pMob):setBaseHAM(i, ham)
				CreatureObject(pMob):setMaxHAM(i, ham)
			else
				CreatureObject(pMob):setHAM(i, ham / 100)
				CreatureObject(pMob):setBaseHAM(i, ham / 100)
				CreatureObject(pMob):setMaxHAM(i, ham / 100)
			end
		end
	end
end

function MtpHideoutInstance:spawnProp(pBuilding, prop)
	if (prop.iff == nil or prop.iff == "") then
		return
	end

	local cellID = self:cellId(pBuilding, prop.cell)

	if (cellID == nil) then
		print("[meatlump] instance cell not found: " .. tostring(prop.cell))
		return
	end

	local pObj = spawnSceneObject(self.planet, prop.iff, prop.x, prop.z, prop.y, cellID, math.rad(prop.yaw or 0))

	if (pObj == nil) then
		return
	end

	self:rememberSpawn(SceneObject(pObj):getObjectID())

	if (prop.iff == "object/tangible/meatlump/hideout/mtp_hideout_instance_supplies.iff") then
		writeStringData(SceneObject(pObj):getObjectID() .. ":mtpQuest", "mtp_hideout_instance_recover_supplies")
		writeStringData(SceneObject(pObj):getObjectID() .. ":mtpTask", "1")
		SceneObject(pObj):setObjectMenuComponent("MtpHideoutSupplyMenuComponent")
	elseif (prop.iff == "object/tangible/meatlump/hideout/mtp_hideout_instance_entryb_controller.iff") then
		SceneObject(pObj):setObjectMenuComponent("MtpHideoutInstanceExitMenuComponent")
		writeData("mtpHideoutInstance:rescueEndpoint", SceneObject(pObj):getObjectID())
	end
end

function MtpHideoutInstance:spawnExitAnalogue(pBuilding)
	-- mtp_hideout_instance_exit.iff is absent from the client (no shared client file).
	-- Cell-1 ladder_exit stand-in from the buildout row stays.
	local pCell = BuildingObject(pBuilding):getCell(1)

	if (pCell == nil) then
		return
	end

	local pExit = spawnSceneObject(self.planet, "object/tangible/meatlump/hideout/mtp_hideout_ladder_exit.iff", 1.15392, 1.85331, 9.30145, SceneObject(pCell):getObjectID(), -0.707106, 0, 0.707107, 0)

	if (pExit ~= nil) then
		SceneObject(pExit):setObjectMenuComponent("MtpHideoutInstanceExitMenuComponent")
	end
end

function MtpHideoutInstance:wireGiversDelayed()
	self:wireGivers()
end

function MtpHideoutInstance:wireGivers()
	local pRetry = self:getBuilding()

	if (MeatlumpHideoutScreenPlay == nil) then
		if (pRetry ~= nil) then
			createEvent(10000, "MtpHideoutInstance", "wireGiversDelayed", pRetry, "")
		end

		return
	end

	local pMain = getSceneObject(MeatlumpHideoutScreenPlay.MAIN_ID)

	if (pMain == nil) then
		if (pRetry ~= nil) then
			createEvent(10000, "MtpHideoutInstance", "wireGiversDelayed", pRetry, "")
		end

		return
	end

	for i = 1, #self.givers do
		local giver = self.givers[i]

		for c = 1, #giver.cells do
			local pCell = BuildingObject(pMain):getNamedCell(giver.cells[c])

			if (pCell ~= nil) then
				self:wireGiverInCell(pCell, giver)
			end
		end
	end
end

function MtpHideoutInstance:wireGiverInCell(pCell, giver)
	for i = 0, SceneObject(pCell):getContainerObjectsSize() - 1 do
		local pObj = SceneObject(pCell):getContainerObject(i)

		if (pObj ~= nil and SceneObject(pObj):isAiAgent()) then
			local name = AiAgent(pObj):getCreatureTemplateName()

			if (name == giver.template) then
				CreatureObject(pObj):setOptionBit(CONVERSABLE)
				CreatureObject(pObj):setOptionBit(INVULNERABLE)
				AiAgent(pObj):setConvoTemplate(giver.convo)
			end
		end
	end
end

function MtpHideoutInstance:mayEnter(pPlayer)
	if (pPlayer == nil) then
		return false
	end

	local pGhost = CreatureObject(pPlayer):getPlayerObject()
	local done = MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_07") or MtpQuestEngine.isQuestComplete(pPlayer, "mtp_hideout_access_high_07")
	local priv = pGhost ~= nil and PlayerObject(pGhost):isPrivileged()

	return done or priv
end

function MtpHideoutInstance:showObjectiveList(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (not self:mayEnter(pPlayer)) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:not_authorized")
		return
	end

	local sui = SuiListBox.new("MtpHideoutInstance", "onObjectivePicked")
	sui.setTitle("Lower Maintenance") -- OURS, NOT SOURCED (java mtp_instance_terminal strings were not in the dump)
	sui.setPrompt("Select an objective.") -- OURS, NOT SOURCED

	for i = 1, #self.objectives do
		sui.add(self.objectives[i].title, self.objectives[i].key)
	end

	sui.sendTo(pPlayer)
end

function MtpHideoutInstance:onObjectivePicked(pPlayer, pSui, eventIndex, args)
	local cancelPressed = (eventIndex == 1)

	if (cancelPressed or pPlayer == nil or args == nil or tonumber(args) < 0) then
		return
	end

	local pPageData = LuaSuiBoxPage(pSui):getSuiPageData()

	if (pPageData == nil) then
		return
	end

	local key = LuaSuiPageData(pPageData):getStoredData(tostring(args))
	local objective = self:objectiveByKey(key)

	if (objective == nil) then
		return
	end

	self:enterInstance(pPlayer, objective)
end

function MtpHideoutInstance:objectiveByKey(key)
	for i = 1, #self.objectives do
		if (self.objectives[i].key == key) then
			return self.objectives[i]
		end
	end

	return nil
end

function MtpHideoutInstance:objectiveForQuest(questName)
	for i = 1, #self.objectives do
		if (self.objectives[i].quest == questName or self.objectives[i].fail == questName or self.objectives[i].success == questName) then
			return self.objectives[i]
		end
	end

	return nil
end

function MtpHideoutInstance:enterInstance(pPlayer, objective)
	if (pPlayer == nil or objective == nil or not self:mayEnter(pPlayer)) then
		return
	end

	local pBuilding = self:ensureBuilding()

	if (pBuilding == nil) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
		return
	end

	local buildingID = SceneObject(pBuilding):getObjectID()
	local occupied = readData("mtpHideoutInstance:occupied")
	local occupant = readData("mtpHideoutInstance:occupant")
	local playerID = SceneObject(pPlayer):getObjectID()

	if (occupied == 1 and occupant ~= 0 and occupant ~= playerID) then
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
		return
	end

	local pCell = BuildingObject(pBuilding):getNamedCell(self.enterCell)

	if (pCell == nil) then
		print("[meatlump] instance has no cell named " .. self.enterCell)
		CreatureObject(pPlayer):sendSystemMessage("@dungeon/space_dungeon:unable_to_find_dungeon")
		return
	end

	if (not MtpQuestEngine.isQuestActive(pPlayer, objective.quest)) then
		self:clearNamed(pPlayer, objective.quest)
		self:clearNamed(pPlayer, objective.fail)
		self:clearNamed(pPlayer, objective.success)
		MtpQuestEngine.grantByName(pPlayer, objective.quest)
	end

	writeData("mtpHideoutInstance:occupied", 1)
	writeData("mtpHideoutInstance:occupant", playerID)
	writeData("mtpHideoutInstance:claimedAt", os.time())
	writeData(playerID .. ":mtpInstance", buildingID)
	self:populateForRun(pBuilding, objective)

	local taskGen = (readData(playerID .. ":mtpInstTaskGen") or 0) + 1
	local sessGen = (readData(playerID .. ":mtpInstSessGen") or 0) + 1
	writeData(playerID .. ":mtpInstTaskGen", taskGen)
	writeData(playerID .. ":mtpInstSessGen", sessGen)

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	SceneObject(pPlayer):switchZone(self.planet, self.enterX, self.enterZ, self.enterY, SceneObject(pCell):getObjectID())
	MtpQuestEngine.sendSignalAny(pPlayer, objective.enterSignal)
	self:attachKillObserver(pPlayer)
	createEvent(self.taskSeconds * 1000, "MtpHideoutInstance", "onTaskTimer", pPlayer, tostring(taskGen))
	createEvent(self.sessionSeconds * 1000, "MtpHideoutInstance", "onSessionTimer", pPlayer, tostring(sessGen))
	createEvent(self.sweepSeconds * 1000, "MtpHideoutInstance", "checkCopy", pBuilding, "")
end

function MtpHideoutInstance:attachKillObserver(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":mtpInstKillObs") == 1) then
		return
	end

	createObserver(KILLEDCREATURE, "MtpHideoutInstance", "notifyKilledCreature", pPlayer)
	writeData(playerID .. ":mtpInstKillObs", 1)
end

function MtpHideoutInstance:detachKillObserver(pPlayer)
	if (pPlayer == nil) then
		return
	end

	dropObserver(KILLEDCREATURE, "MtpHideoutInstance", "notifyKilledCreature", pPlayer)
	deleteData(SceneObject(pPlayer):getObjectID() .. ":mtpInstKillObs")
end

function MtpHideoutInstance:notifyKilledCreature(pPlayer, pVictim)
	if (pPlayer == nil or pVictim == nil) then
		return 0
	end

	local social = readStringData(SceneObject(pVictim):getObjectID() .. ":mtpSocialGroup")

	if (social == nil or social == "") then
		return 0
	end

	for i = 1, #self.objectives do
		local objective = self.objectives[i]
		local sp = MtpQuestEngine.byName(objective.quest)

		if (sp ~= nil and MtpQuestEngine.isActive(sp, pPlayer)) then
			self:countDestroyKill(sp, pPlayer, objective, social)
		end
	end

	return 0
end

function MtpHideoutInstance:countDestroyKill(sp, pPlayer, objective, social)
	local active = MtpQuestEngine.getActive(sp, pPlayer)

	for i = 1, #active do
		local task = sp.tasks[active[i] + 1]

		if (task ~= nil and task.type == "destroy_multi" and task.socialGroup == social) then
			local key = "kills_" .. tostring(task.id)
			local kills = (tonumber(MtpQuestEngine.read(sp, pPlayer, key)) or 0) + 1
			MtpQuestEngine.write(sp, pPlayer, key, tostring(kills))

			if (kills >= (task.count or 1)) then
				local grantName = self:grantNameAfter(sp, task)
				MtpQuestEngine.finishTask(sp, pPlayer, task.id)

				if (grantName ~= nil) then
					MtpQuestEngine.grantByName(pPlayer, grantName)
				end

				if (grantName == objective.success) then
					self:bumpTaskGen(pPlayer)
				end
			end
		end
	end
end

function MtpHideoutInstance:grantNameAfter(sp, task)
	if (task == nil or task.onComplete == nil or #task.onComplete == 0) then
		return nil
	end

	local nextTask = sp.tasks[task.onComplete[1] + 1]

	if (nextTask ~= nil and nextTask.grantQuest ~= nil and nextTask.grantQuest ~= "") then
		return nextTask.grantQuest
	end

	return nil
end

function MtpHideoutInstance:bumpTaskGen(pPlayer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	writeData(playerID .. ":mtpInstTaskGen", (readData(playerID .. ":mtpInstTaskGen") or 0) + 1)
end

function MtpHideoutInstance:onTaskTimer(pPlayer, gen)
	if (pPlayer == nil) then
		return
	end

	if ((tonumber(gen) or 0) ~= readData(SceneObject(pPlayer):getObjectID() .. ":mtpInstTaskGen")) then
		return
	end

	self:failActiveObjective(pPlayer)
end

function MtpHideoutInstance:onSessionTimer(pPlayer, gen)
	if (pPlayer == nil) then
		return
	end

	if ((tonumber(gen) or 0) ~= readData(SceneObject(pPlayer):getObjectID() .. ":mtpInstSessGen")) then
		return
	end

	self:failActiveObjective(pPlayer)
	self:sendToExit(pPlayer, true)
end

function MtpHideoutInstance:failActiveObjective(pPlayer)
	for i = 1, #self.objectives do
		local objective = self.objectives[i]
		local sp = MtpQuestEngine.byName(objective.quest)

		if (sp ~= nil and MtpQuestEngine.isActive(sp, pPlayer)) then
			MtpQuestEngine.clearQuest(sp, pPlayer)
			MtpQuestEngine.grantByName(pPlayer, objective.fail)
			self:bumpTaskGen(pPlayer)
			return
		end
	end
end

function MtpHideoutInstance:hasActiveObjective(pPlayer)
	for i = 1, #self.objectives do
		if (MtpQuestEngine.isQuestActive(pPlayer, self.objectives[i].quest)) then
			return true
		end
	end

	return false
end

function MtpHideoutInstance:onEnteredBuilding(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	local buildingID = SceneObject(pBuilding):getObjectID()

	if (readData("mtpHideoutInstance:occupied") ~= 1) then
		writeData("mtpHideoutInstance:occupied", 1)
		writeData("mtpHideoutInstance:occupant", SceneObject(pPlayer):getObjectID())
		writeData("mtpHideoutInstance:claimedAt", os.time())
		createEvent(self.sweepSeconds * 1000, "MtpHideoutInstance", "checkCopy", pBuilding, "")
	end

	writeData(SceneObject(pPlayer):getObjectID() .. ":mtpInstance", buildingID)

	return 0
end

function MtpHideoutInstance:onExitedBuilding(pBuilding, pPlayer)
	if (pBuilding == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end

	self:sendToExit(pPlayer, false)
	createEvent(3000, "MtpHideoutInstance", "releaseIfEmpty", pBuilding, "")

	return 0
end

function MtpHideoutInstance:sendToExit(pPlayer, fromTimer)
	if (pPlayer == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()

	if (readData(playerID .. ":mtpInstanceEjecting") == 1) then
		return
	end

	if (self:hasActiveObjective(pPlayer) and not fromTimer) then
		self:failActiveObjective(pPlayer)
	end

	writeData(playerID .. ":mtpInstanceEjecting", 1)
	self:detachKillObserver(pPlayer)
	writeData(playerID .. ":mtpInstSessGen", (readData(playerID .. ":mtpInstSessGen") or 0) + 1)
	writeData(playerID .. ":mtpInstTaskGen", (readData(playerID .. ":mtpInstTaskGen") or 0) + 1)

	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):dismount()
	end

	SceneObject(pPlayer):switchZone(self.exitPlanet, self.exitX, self.exitZ, self.exitY, 0)
	deleteData(playerID .. ":mtpInstance")
	createEvent(2000, "MtpHideoutInstance", "clearEjecting", pPlayer, "")
end

function MtpHideoutInstance:clearEjecting(pPlayer)
	if (pPlayer ~= nil) then
		deleteData(SceneObject(pPlayer):getObjectID() .. ":mtpInstanceEjecting")
	end
end

function MtpHideoutInstance:countPlayersInside(pBuilding)
	if (pBuilding == nil) then
		return 0
	end

	local count = 0

	for i = 1, BuildingObject(pBuilding):getTotalCellNumber() do
		local pCell = BuildingObject(pBuilding):getCell(i)

		if (pCell ~= nil) then
			for j = 1, SceneObject(pCell):getContainerObjectsSize() do
				local pObject = SceneObject(pCell):getContainerObject(j - 1)

				if (pObject ~= nil and SceneObject(pObject):isPlayerCreature()) then
					count = count + 1
				end
			end
		end
	end

	return count
end

function MtpHideoutInstance:releaseCopy()
	self:despawnRunPopulation()
	deleteData("mtpHideoutInstance:occupied")
	deleteData("mtpHideoutInstance:occupant")
	deleteData("mtpHideoutInstance:claimedAt")
end

function MtpHideoutInstance:releaseIfEmpty(pBuilding)
	if (pBuilding == nil) then
		return
	end

	if (self:countPlayersInside(pBuilding) == 0) then
		self:releaseCopy()
	end
end

function MtpHideoutInstance:checkCopy(pBuilding)
	if (pBuilding == nil or readData("mtpHideoutInstance:occupied") ~= 1) then
		return
	end

	local claimedAt = readData("mtpHideoutInstance:claimedAt")

	if (self:countPlayersInside(pBuilding) == 0 and os.time() - claimedAt >= self.claimGrace) then
		self:releaseCopy()
		return
	end

	createEvent(self.sweepSeconds * 1000, "MtpHideoutInstance", "checkCopy", pBuilding, "")
end

function MtpHideoutInstance:clearNamed(pPlayer, name)
	local sp = MtpQuestEngine.byName(name)

	if (sp == nil or pPlayer == nil) then
		return
	end

	MtpQuestEngine.clearQuest(sp, pPlayer)
	MtpQuestEngine.delete(sp, pPlayer, "runs")
end

function MtpHideoutInstance:nextFourAm()
	local now = os.time()
	local d = os.date("*t", now)
	d.hour = 4
	d.min = 0
	d.sec = 0
	local four = os.time(d)

	if (now >= four) then
		four = four + 86400
	end

	return four
end

function MtpHideoutInstance:isGiverLocked(pPlayer, key)
	if (pPlayer == nil or key == nil) then
		return false
	end

	local untilTime = tonumber(readScreenPlayData(pPlayer, self.screenplayName, key)) or 0

	return untilTime > os.time()
end

function MtpHideoutInstance:lockGiver(pPlayer, key)
	if (pPlayer == nil or key == nil) then
		return
	end

	writeScreenPlayData(pPlayer, self.screenplayName, key, tostring(self:nextFourAm()))
end

function MtpHideoutInstance:unlockGiver(pPlayer, key)
	if (pPlayer == nil or key == nil) then
		return
	end

	deleteScreenPlayData(pPlayer, self.screenplayName, key)
end

function MtpHideoutInstance:startEscort(pPlayer, pNpc)
	if (pPlayer == nil or pNpc == nil) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local npcID = SceneObject(pNpc):getObjectID()

	AiAgent(pNpc):removeObjectFlag(AI_STATIONARY)
	AiAgent(pNpc):addObjectFlag(AI_NOAIAGGRO)
	AiAgent(pNpc):addObjectFlag(AI_ESCORT)
	AiAgent(pNpc):addObjectFlag(AI_FOLLOW)
	AiAgent(pNpc):setFollowObject(pPlayer)
	AiAgent(pNpc):setMovementState(AI_FOLLOWING)
	AiAgent(pNpc):setAITemplate()

	writeData(npcID .. ":mtpEscortFollow", 1)
	writeData(npcID .. ":mtpEscortOwner", playerID)
	writeData(playerID .. ":mtpEscortNpc", npcID)
	createEvent(5000, "MtpHideoutInstance", "escortTick", pNpc, tostring(playerID))

	-- SOURCED triggerId mtp_escort_trapped_meatlump_p2: spawn extra rows without despawning the escort NPC.
	local pBuilding = self:getBuilding()

	if (pBuilding ~= nil) then
		local rows = MtpHideoutInstancePopulation.rows

		for i = 1, #rows do
			if (rows[i].trigger == "mtp_escort_trapped_meatlump_p2") then
				self:spawnRow(pBuilding, rows[i])
			end
		end
	end
end

function MtpHideoutInstance:stopEscort(pNpc)
	if (pNpc == nil) then
		return
	end

	AiAgent(pNpc):setFollowObject(nil)
	AiAgent(pNpc):removeObjectFlag(AI_FOLLOW)
	deleteData(SceneObject(pNpc):getObjectID() .. ":mtpEscortFollow")
end

function MtpHideoutInstance:escortTick(pNpc, ownerArg)
	if (pNpc == nil) then
		return
	end

	local npcID = SceneObject(pNpc):getObjectID()

	if (readData(npcID .. ":mtpEscortFollow") ~= 1) then
		return
	end

	local ownerID = tonumber(ownerArg) or readData(npcID .. ":mtpEscortOwner")
	local pPlayer = getSceneObject(ownerID)

	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		self:stopEscort(pNpc)
		return
	end

	local pBuilding = self:getBuilding()
	local entryCell = self:cellId(pBuilding, self.enterCell)
	local parentID = SceneObject(pNpc):getParentID()

	if (entryCell ~= nil and parentID == entryCell) then
		self:completeEscort(pPlayer, pNpc)
		return
	end

	createEvent(5000, "MtpHideoutInstance", "escortTick", pNpc, tostring(ownerID))
end

function MtpHideoutInstance:completeEscort(pPlayer, pNpc)
	if (pPlayer == nil) then
		return
	end

	local quest = "mtp_hideout_instance_escort_trapped_meatlump"
	local sp = MtpQuestEngine.byName(quest)

	if (sp == nil or not MtpQuestEngine.isTaskActive(sp, pPlayer, "escort_trapped_meatlump")) then
		return
	end

	MtpQuestEngine.sendSignalAny(pPlayer, "escort_trapped_meatlump")
	self:stopEscort(pNpc)
	MtpQuestEngine.grantByName(pPlayer, "mtp_hideout_instance_escort_trapped_meatlump_success")
	self:bumpTaskGen(pPlayer)
end

MtpHideoutInstanceMenuComponent = {}

function MtpHideoutInstanceMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "Enter lower maintenance") -- OURS, NOT SOURCED
end

function MtpHideoutInstanceMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	MtpHideoutInstance:showObjectiveList(pPlayer)

	return 0
end

MtpHideoutInstanceExitMenuComponent = {}

function MtpHideoutInstanceExitMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "Leave the instance") -- OURS, NOT SOURCED
end

function MtpHideoutInstanceExitMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 8)) then
		return 0
	end

	local escortID = readData(SceneObject(pPlayer):getObjectID() .. ":mtpEscortNpc")
	local pNpc = getSceneObject(escortID)

	if (pNpc ~= nil) then
		MtpHideoutInstance:completeEscort(pPlayer, pNpc)
	end

	MtpHideoutInstance:sendToExit(pPlayer, false)

	return 0
end

MtpHideoutSupplyMenuComponent = {}

function MtpHideoutSupplyMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	MtpQuestItemMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
end

function MtpHideoutSupplyMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pPlayer == nil) then
		return 0
	end

	local wasActive = MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_instance_recover_supplies")
	MtpQuestItemMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)

	if (wasActive and not MtpQuestEngine.isQuestActive(pPlayer, "mtp_hideout_instance_recover_supplies")) then
		MtpQuestEngine.grantByName(pPlayer, "mtp_hideout_instance_recover_supplies_success")
		MtpHideoutInstance:bumpTaskGen(pPlayer)
	end

	return 0
end
