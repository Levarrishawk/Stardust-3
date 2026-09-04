-- Cobak, the xandank guarding the Jedi's chest in som_jedi_dog (jedi_dog.lua).
--
-- The .qst names CreatureType "som_xandank_cobak" and no such template ships,
-- so this one is built for it.  Every stat below is orf_xandank.lua verbatim and
-- it reuses orf_xandank's shipped appearance -- reusing another template's .iff
-- is the tree's ordinary convention, not a special case (3385 of 6223 creature
-- templates do it; bageraset_bruiser -> bageraset_hue.iff is a nearby example).
--
-- It exists for one reason: the registered NAME is what quests count kills by.
-- ScreenPlayObserver reads AiAgent:getCreatureTemplateName(), so a creature
-- spawned as "orf_xandank" is counted by every set that lists orf_xandank --
-- bounty_hunts.lua:281 and map_exploration.lua:193 both do.  Cobak is a scripted
-- unique and killing him should not tick a xandank culling quest, which is how
-- live behaved: som_xandank_cobak was its own CreatureType there too.  Under
-- this name he is outside all three xandank sets, matching how
-- som_kenobi_reunite_tulrus sits outside the tulrus sets.
som_xandank_cobak = Creature:new {
	customName = "Xandank",
	socialGroup = "xandank",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 70,
	chanceHit = 0.65,
	damageMin = 430,
	damageMax = 570,
	baseXp = 6747,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "meat_carnivore",
	meatAmount = 250,
	hideType = "hide_leathery",
	hideAmount = 180,
	boneType = "bone_mammal",
	boneAmount = 120,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/orf_xandank.iff"},
	lootGroups = {},
	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",
	primaryAttacks = { {"stunattack",""}, {"intimidationattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_xandank_cobak, "som_xandank_cobak")
