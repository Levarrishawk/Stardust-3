--[[
	Darth Vader as the Clone Relics ground giver, per quest/ep3_clone_relics_jedi_starfighter_4.qst
	(journal category "The Clone Relics, Fist of the Empire", task talkToVader1, "downstairs in the
	Imperial bunker").

	FLAGGED INTERPRETATION -- APPEARANCE. The client ships NO ep3 Vader mobile: object/custom_content/
	mobile/ep3/objects.lua carries 45 shared_ep3_clone_relics_*.iff appearances (admiral_krieg,
	kkrax, leia, durge, morkov ...) and none of them is Vader. The only shipped Vader appearance is the
	base-game object/mobile/darth_vader.iff, so that is what this mobile wears. If an ep3-specific
	Vader appearance is ever found in the tre set, swap the templates line and delete this note.

	FLAGGED INTERPRETATION -- WHY A NEW CREATURE TEMPLATE. The existing creature template
	"darth_vader" (mobile/quest/naboo/darth_vader.lua) already carries
	conversationTemplate = "theme_park_imperial_mission_giver_convotemplate" for the Imperial theme
	park. Setting the Clone Relics conversation on it would break that content, so this is a separate
	creature template on the same appearance instead. Verified by diff: the ONLY differences from
	mobile/quest/naboo/darth_vader.lua are the global name, the conversationTemplate line and the
	CreatureTemplates registration line. objectName, templates, scale, the stat block, the attack
	lists and every bitmask are byte-identical -- nothing about this mobile is authored.

	objectName is the shipped client key @mob/creature_names:darth_vader -- not an authored
	customName -- so the name plate is the client's own text.

	NOT SPAWNED. Nothing in this repo spawns this mobile, there are no Kashyyyk ground spawn areas,
	and bin/conf/config.lua ZonesEnabled has no Kashyyyk ground zone. The .qst says "downstairs in the
	Imperial bunker" but ships no coordinates, so no spawn was invented. This template and its
	conversation are correct and inert until a spawn exists.
]]

-- SOURCED (ruling 2026-09-04): socialGroup/faction from datatables/mob/creatures.tab line 526 (clone_relics_darth_vader, where=kashyyyk, BOSS).
-- Level/damage/HAM: OURS, unchanged -- the Kashyyyk curve is an open maintainer decision.
ep3_clone_relics_darth_vader = Creature:new {
	objectName = "@mob/creature_names:darth_vader",
	socialGroup = "imperial",
	faction = "imperial",
	mobType = MOB_NPC,
	level = 300,
	chanceHit = 30,
	damageMin = 1645,
	damageMax = 3000,
	baseXp = 28549,
	baseHAM = 385000,
	baseHAMmax = 471000,
	armor = 1,
	resists = {0,0,0,0,0,0,0,0,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = NONE,
	creatureBitmask = PACK,
	-- CONVERSABLE and conversationTemplate must be set together: LuaMobileTest.cpp asserts that any
	-- mobile carrying the CONVERSE option bit has a non-empty conversationTemplate. The template is
	-- ep3_clone_relics_darth_vader_convotemplate, defined in
	-- mobile/conversations/space/neutral/clone_relics/ep3_clone_relics_darth_vader_convo.lua.
	optionsBitmask = INVULNERABLE + CONVERSABLE,
	diet = HERBIVORE,
	scale = 1.25,

	templates = {"object/mobile/darth_vader.iff"},
	lootGroups = {},

	primaryWeapon = "darth_vader_weapons",
	secondaryWeapon = "none",
	conversationTemplate = "ep3_clone_relics_darth_vader_convotemplate",

	primaryAttacks = merge(lightsabermaster,forcepowermaster),
	secondaryAttacks = {}
}

CreatureTemplates:addCreatureTemplate(ep3_clone_relics_darth_vader, "ep3_clone_relics_darth_vader")
