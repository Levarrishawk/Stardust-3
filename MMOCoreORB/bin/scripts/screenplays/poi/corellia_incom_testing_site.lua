CorelliaIncomTestingSiteScreenPlay = ScreenPlay:new {
	numberOfActs = 1,

	screenplayName = "CorelliaIncomTestingSiteScreenPlay",

	-- Template, respawn seconds, x, z, y, heading. All positions are outdoors.
	mobiles = {
		-- Inside the perimeter near the southwest, southeast, and northwest gatehouses.
		{"fbase_stormtrooper_hard", 300, -5737, 5, -6453, 180},
		{"fbase_stormtrooper_hard", 300, -5733, 5, -6457, 180},
		{"fbase_stormtrooper_hard", 300, -5697, 5, -6459, 180},
		{"fbase_stormtrooper_hard", 300, -5694, 5, -6453, 90},
		{"fbase_stormtrooper_hard", 300, -5737, 5, -6425, -90},
		{"fbase_stormtrooper_hard", 300, -5733, 5, -6420, 0},

		-- Perimeter sentries and squad leaders between the two aircraft.
		{"fbase_stormtrooper_sniper_hard", 300, -5741, 5, -6435, -90},
		{"fbase_stormtrooper_sniper_hard", 300, -5692, 5, -6440, 90},
		{"fbase_stormtrooper_squad_leader_hard", 300, -5727, 5, -6437, 180},
		{"fbase_stormtrooper_squad_leader_hard", 300, -5706, 5, -6438, 0},

		-- Walkers in the open yard, clear of the X-wings and officer's shed.
		{"at_st", 600, -5734, 5, -6440, 180},
		{"at_st", 600, -5701, 5, -6442, 180},

		-- Outside the officer's shed (snapshot object 9825954).
		{"fbase_imperial_colonel_hard", 300, -5700, 5, -6433, 180},
		{"fbase_imperial_army_captain_hard", 300, -5695, 5, -6435, -90},

		-- Alongside the northern and southern X-wings (9825961 and 9825962).
		{"incom_technician", 300, -5726, 5, -6424, 90},
		{"incom_technician", 300, -5710, 5, -6424, -90},
		{"incom_technician", 300, -5722, 5, -6453, 90},
		{"incom_technician", 300, -5706, 5, -6453, -90},
	}
}

registerScreenPlay("CorelliaIncomTestingSiteScreenPlay", true)

function CorelliaIncomTestingSiteScreenPlay:start()
	if (isZoneEnabled("corellia")) then
		self:spawnMobiles()
		self:spawnDetectionArea()
	end
end

function CorelliaIncomTestingSiteScreenPlay:spawnDetectionArea()
	local pArea = spawnActiveArea("corellia", "object/active_area.iff", -5717, 5, -6441, 75, 0)
	if (pArea ~= nil) then
		createObserver(ENTEREDAREA, self.screenplayName, "notifyEnteredDetectionArea", pArea)
	end
end

function CorelliaIncomTestingSiteScreenPlay:notifyEnteredDetectionArea(pArea, pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return 0
	end
	if (CreatureObject(pPlayer):isRebel()) then
		CreatureObject(pPlayer):sendSystemMessage("Warning: Incom facility proximity sensors have detected unauthorized intrusion. Your faction status has been set to covert. Imperial security forces will attack on sight.")
		CreatureObject(pPlayer):setFactionStatus(COVERT)
	end
	return 0
end

function CorelliaIncomTestingSiteScreenPlay:spawnMobiles()
	for i = 1, #self.mobiles do
		local mobile = self.mobiles[i]
		spawnMobile("corellia", mobile[1], mobile[2], mobile[3], mobile[4], mobile[5], mobile[6], 0)
	end
end
