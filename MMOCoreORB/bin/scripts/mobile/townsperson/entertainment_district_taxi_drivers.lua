local driver = commoner:new {
	randomNameType = NAME_TAG,
	randomNameTag = false,
	socialGroup = "",
	faction = "",
	pvpBitmask = NONE,
	creatureBitmask = NONE,
	optionsBitmask = INVULNERABLE + INTERESTING + CONVERSABLE,
	conversationTemplate = "entertainmentDistrictTaxiConvoTemplate",
}

CreatureTemplates:addCreatureTemplate(driver:new {
	customName = "Nemm Varo (Entertainment District Taxi Driver)",
	templates = {"object/mobile/dressed_commoner_artisan_sullustan_male_01.iff"},
}, "entertainment_district_taxi_driver")

CreatureTemplates:addCreatureTemplate(driver:new {
	customName = "Ressa Pell (Entertainment District Taxi Driver)",
	templates = {"object/mobile/dressed_commoner_tatooine_rodian_female_01.iff"},
}, "opera_house_taxi_driver")
