--[[ Skar -- the NPC the "Skar tower" TODO in regions/storm_lord_region.lua:77 asked for.

     SOURCED: the name, the tier and the position.
       C:\swg-extract\ngecore_mustafar.md:190  "* Skar (CL84 Elite Jedi) [3068,1613]"
     Through the proven Mustafar offset (world_x = way_x - 2880, world_y = way_y + 2976,
     scratch/MUSTAFAR-GAPS.md) that /way is world (188, 4589), which is 4.45 m from
     must_jeditemple_watchtower at (183.96, h 176.87, 4587.14) -- snapshot/mustafar.ws
     node 12110953, unclaimed by anything in scripts/. That is a tighter anchor than the
     5.18 m one the Prophet already ships on (node 12110949), and the point sits inside
     the pMinion9-13 ring, which is what "Skar tower" names.

     That source's positions were checked twice against placements this repo made
     independently, from other sources: its Storm Lord Minion [3036,1598] -> (156, 4574)
     lands on the centroid of the existing pMinion9-13 cluster, and its Vansk of the
     Blackguard [-1532,183] -> (-4412, 3159) lands 4.4 m from the vansk_blackguard
     already placed at regions/smoking_forest_region.lua:131.

     CL84 is an NGE column and its number is not used here; it reads as ELITE, and the
     stat row below is the ELITE tier copied verbatim from the ladder anchor
     mobile/dathomir/spiderclan_crawler.lua. Nothing in this row is authored.

     THE TODO'S OWN GUESS IS TAKEN FOR THE APPEARANCE AND ONLY THE APPEARANCE. It reads
     "Closest appearance would be blackguard wilder", which is a judgement about art, and
     it is kept -- nothing named skar ships an appearance, so this is a substitution
     either way, the same trade storm_lord_zealot already makes by wearing
     storm_lord_touched.iff. The blackguard_wilder *template* is not used: it is
     socialGroup "wilder", STD level 70, and not a Jedi, which contradicts all three of
     "Elite Jedi", "Jedi watchtower" and "surrounded by Storm Lord minions".

     Everything else is copied from the nearest sibling that is already an ELITE-85 named
     Jedi in this same directory, djedi_hum_m_01.lua -- weapons, attacks and the loot
     block. Both weapon groups are registered and both are included by
     mobile/weapon/serverobjects.lua:109,112, which is the constraint that killed the
     jedi_dark attempt recorded in the census.

     OURS, NOT SOURCED: socialGroup "storm_lord" rather than "dark_jedi", so he assists
     and is assisted by the minion ring he stands in; and AGGRESSIVE, which every other
     named storm_lord in that camp carries. ]]

skar = Creature:new {
	customName = "Skar",
	socialGroup = "storm_lord",
	faction = "",
	mobType = MOB_NPC,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = ATTACKABLE + AGGRESSIVE,
	creatureBitmask = PACK + STALKER,
	optionsBitmask = AIENABLED,
	diet = HERBIVORE,

	templates = {"object/mobile/som/blackguard_wilder.iff"},
	lootGroups = {
		{
			groups = {
				{group = "dark_jedi_tier_4", chance = 6000000},
				{group = "color_crystals", chance = 2000000},
				{group = "power_crystals", chance = 1000000},
				{group = "holocron_dark", chance = 1000000}
			},
			lootChance = 5000000
		}
	},
	primaryWeapon = "dark_jedi_weapons_gen3",
	secondaryWeapon = "dark_jedi_weapons_ranged",
	conversationTemplate = "",
	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = forcepowermaster
}

CreatureTemplates:addCreatureTemplate(skar, "skar")
