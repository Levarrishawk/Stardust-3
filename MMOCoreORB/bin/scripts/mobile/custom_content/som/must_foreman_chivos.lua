--[[ Foreman Chivos, the giver of all three som_story_arc_prelude quests.

conversationTemplate was the empty string, and story_arc_prelude.lua read that as
"he shipped without a tree, so he needs a radial". He did not: SOE's
conversation/story_arc_prelude_chivos ships in the base
string/en/conversation/ set. The empty field is a hole in this repo's mobile, not
evidence about live. ROOT CAUSE: the search was scoped to the som_ name prefix,
which every quest in this arc carries and the conversation does not. Filling an
empty conversationTemplate is not repointing an existing one, so nothing in the
brief was ever in the way.

The flags below are live's own, not a repo preference. His conversation java's
OnAttach reads, verbatim: setCondition(self, CONDITION_CONVERSABLE);
setInvulnerable(self, true); setCondition(self, CONDITION_INTERESTING);
setName(self, "Foreman Chivos"). That is CONVERSABLE + INTERESTING + INVULNERABLE
and no attackability at all -- so pvpBitmask goes to NONE and STALKER goes, since a
man standing in his own office invulnerable and mid-conversation does not stalk.
--]]
must_foreman_chivos = Creature:new {
	customName = "Foreman Chivos",
	socialGroup = "townsperson",
	faction = "",
	mobType = MOB_NPC,
	level = 70,
	chanceHit = 0.27,
	damageMin = 550,
	damageMax = 800,
	baseXp = 235,
	baseHAM = 16000,
	baseHAMmax = 19000,
	armor = 0,
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
	pvpBitmask = NONE,
	creatureBitmask = PACK,
	optionsBitmask = AIENABLED + INVULNERABLE + CONVERSABLE + INTERESTING,
	diet = HERBIVORE,

	templates = {"object/mobile/som/must_foreman_chivos.iff"},
	lootGroups = {
		{
			groups = {},
			lootChance = 2100000
		}
	},
	primaryWeapon = "pirate_weapons_light",
	secondaryWeapon = "unarmed",
	conversationTemplate = "story_arc_prelude_chivos",
	primaryAttacks = merge(marksmannovice,brawlernovice),
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(must_foreman_chivos, "must_foreman_chivos")
