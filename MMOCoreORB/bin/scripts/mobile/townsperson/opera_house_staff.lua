local staff = commoner:new {
	randomNameType = NAME_TAG,
	randomNameTag = false,
	socialGroup = "",
	faction = "",
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = INVULNERABLE + INTERESTING,
}

local speaker = staff:new { optionsBitmask = INVULNERABLE + INTERESTING + CONVERSABLE }

CreatureTemplates:addCreatureTemplate(staff:new {
	customName = "Orrin Pell (House Doorman)",
	templates = {"object/mobile/dressed_noble_human_male_04.iff"},
}, "opera_house_doorman")

CreatureTemplates:addCreatureTemplate(speaker:new {
	customName = "P3-RL (House Protocol Droid)",
	mobType = MOB_DROID,
	templates = {"object/mobile/3po_protocol_droid_silver.iff"},
	conversationTemplate = "operaHouseProtocol",
}, "opera_house_protocol_droid")

CreatureTemplates:addCreatureTemplate(speaker:new {
	customName = "Dara Varo (Third Horn)",
	templates = {"object/mobile/opera_house_sullustan_musician.iff"},
	outfit = "opera_house_third_horn",
	conversationTemplate = "operaHouseMusician",
}, "opera_house_third_horn")

CreatureTemplates:addCreatureTemplate(staff:new {
	customName = "Seela Fen (Head Usher)",
	templates = {"object/mobile/dressed_noble_naboo_twilek_female_02.iff"},
	outfit = "opera_house_hand_reader",
}, "opera_house_head_usher")

CreatureTemplates:addCreatureTemplate(speaker:new {
	customName = "Nalo Venn (Water-Sculpture Technician)",
	templates = {"object/mobile/dressed_droidengineer_trainer_moncal_male_01.iff"},
	outfit = "opera_house_hand_reader",
	conversationTemplate = "operaHouseTechnician",
}, "opera_house_water_technician")

CreatureTemplates:addCreatureTemplate(speaker:new {
	customName = "Lieutenant Tessa Arlen (Imperial Protocol Aide)",
	templates = {"object/mobile/dressed_imperial_officer_f.iff"},
	outfit = "opera_house_hand_reader",
	conversationTemplate = "operaHouseBoxAide",
}, "opera_house_box_aide")
