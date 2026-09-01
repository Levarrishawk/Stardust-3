-- Valley Battlefield (mustafar_droid_army) GK-5 assault killer. Live row
-- som_battlefield_gk_5, level 83 BOSS; level here is NAMED tier 100 from
-- volcano_cyborg_lt.lua, not live's 83. resists and socialGroup are live;
-- aggression blank on live so ATTACKABLE + ENEMY only. weapon schema from
-- union_sentry_droid.lua -- live's droid_union_sentry is unregistered.
-- customName is authored because no .stf ships in the extract.
som_battlefield_gk_5 = Creature:new {
	customName = "a GK-5 Assault Killer Bot",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_DROID,
	level = 100,
	chanceHit = 1,
	damageMin = 645,
	damageMax = 1000,
	baseXp = 9429,
	baseHAM = 24000,
	baseHAMmax = 30000,
	armor = 1,
	resists = {75,75,100,60,100,25,40,85,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE + ENEMY,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/union_sentry_droid.iff"},
	lootGroups = {
		{
			groups = {
				{group = "technician_tier_1", chance = 7000000},
				{group = "junk", chance = 3000000}
			}
		}
	},
	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(som_battlefield_gk_5, "som_battlefield_gk_5")
