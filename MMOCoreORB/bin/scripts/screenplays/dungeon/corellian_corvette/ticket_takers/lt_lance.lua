lt_lance = { planetName = "corellia", npcTemplate = "lt_lance", x = -36.7, z = 1.6, y = 66.1, direction = 128, cellID = 1935692, position = SIT }

ticketTakerLtLance = CorvetteTicketTakerLogic:new {
	numberOfActs = 1,
	npc = lt_lance,
	pickupWaypoint = { x = -4995.8, z = 22.6, y = -2302.7 },
	takerName = "ticketTakerLtLance",
	faction = FACTIONREBEL,
	goodbyeString = "I'm just passing through.",
	helpMeString = "I'm here for the crew transfer.",
	nevermindString = "I'll come back later.",
	aboutMissionString = "I'm here for the crew transfer.",
}

registerScreenPlay("ticketTakerLtLance", true)

ticketTakerLtLanceConvoHandler = CorvetteTicketTakerConvoHandler:new {
	ticketTaker = ticketTakerLtLance
}
