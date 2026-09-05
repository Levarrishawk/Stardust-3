-- Separate combat/quest identities from the decorative and ordinary creatures.
-- Inherit existing appearances and stats; only identity and attackability differ.
kashyyyk_hunt_bantha = kashyyyk_bull_bantha:new {
	pvpBitmask = ATTACKABLE,
}
CreatureTemplates:addCreatureTemplate(kashyyyk_hunt_bantha, "kashyyyk_hunt_bantha")

kashyyyk_hunt_greyclimber = kashyyyk_hunt_bantha:new {
	customName = "Greyclimber",
	randomNameType = NAME_TAG,
	randomNameTag = false,
}
CreatureTemplates:addCreatureTemplate(kashyyyk_hunt_greyclimber, "kashyyyk_hunt_greyclimber")

kashyyyk_hunt_silkthrower = webweaver:new {
	customName = "Silkthrower",
	randomNameType = NAME_TAG,
	randomNameTag = false,
	pvpBitmask = ATTACKABLE,
}
CreatureTemplates:addCreatureTemplate(kashyyyk_hunt_silkthrower, "kashyyyk_hunt_silkthrower")

kashyyyk_hunt_stoneleg = walluga:new {
	customName = "Stoneleg",
	randomNameType = NAME_TAG,
	randomNameTag = false,
	pvpBitmask = ATTACKABLE,
}
CreatureTemplates:addCreatureTemplate(kashyyyk_hunt_stoneleg, "kashyyyk_hunt_stoneleg")

kashyyyk_hunt_spiketop = uller_stoneclaw:new {
	customName = "Spiketop",
	randomNameType = NAME_TAG,
	randomNameTag = false,
	pvpBitmask = ATTACKABLE,
}
CreatureTemplates:addCreatureTemplate(kashyyyk_hunt_spiketop, "kashyyyk_hunt_spiketop")

kashyyyk_hracca_kkorrwrot = kkorrwrot:new {
	pvpBitmask = ATTACKABLE,
}
CreatureTemplates:addCreatureTemplate(kashyyyk_hracca_kkorrwrot, "kashyyyk_hracca_kkorrwrot")
