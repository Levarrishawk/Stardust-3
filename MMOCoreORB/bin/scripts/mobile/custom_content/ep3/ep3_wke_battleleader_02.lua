-- DSRC ep3_npc_wookiee_battleleader uses the ep3_wke_battleleader appearance group.
-- Retain the existing Core3 Wookiee Commando combat, XP and loot profile.
ep3_wke_battleleader_02 = ep3_wke_commando_01:new {
	customName = "Wookiee Battle Leader",
	templates = {"object/mobile/ep3/ep3_wke_battleleader_02.iff"},
}

CreatureTemplates:addCreatureTemplate(ep3_wke_battleleader_02, "ep3_wke_battleleader_02")
