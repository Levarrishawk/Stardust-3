-- DSRC creatures.tab: ep3_npc_ceremonial_captain uses this appearance.
-- Retain the existing Core3 ceremonial-guard combat, XP and loot profile.
ep3_wke_cerimonial_captain = ep3_wke_cerimonial_guard_01:new {
	customName = "Ceremonial Captain",
	templates = {"object/mobile/ep3/ep3_wke_cerimonial_captain.iff"},
}

CreatureTemplates:addCreatureTemplate(ep3_wke_cerimonial_captain, "ep3_wke_cerimonial_captain")
