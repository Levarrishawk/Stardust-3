-- The city patrol AI walks only to the sidewalk waypoints supplied by the screenplay.
local pedestrian = commoner:new {
	creatureBitmask = NONE,
	customAiMap = "cityPatrol",
}

CreatureTemplates:addCreatureTemplate(pedestrian, "coruscant_promenade_pedestrian")
