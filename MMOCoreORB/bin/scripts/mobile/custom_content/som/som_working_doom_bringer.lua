--[[ som_working_doom_bringer -- the Doom Bringer, Working Droid Factory trial
     boss. Live record: creatures.tab BaseLevel 85 / difficultyClass BOSS /
     stealingFlags CREDITS / where mustafar / socialGroup droid_army / pvpFaction
     droid_army / template som/union_sentry_droid.iff / minScale 1.3 / maxScale 1.3 /
     hue 0 / attackSpeed 1.4 / intLootRolls 1 / intRollPercent 100 / lootTable
     mustafar/mustafar_trial_doombringer / chronicleLootChance 100 /
     chronicleLootCategory doom_bringer / niche android / stunImmune 100 /
     mezImmune 100 / canNotPunish 1 / primary_weapon
     object/weapon/ranged/droid/droid_union_sentry_02.iff / primary_weapon_specials
     droid_special_6 / aggressive 6 / assist 9 / death_blow instant.

     TIER: BOSS 120. Live level 85 / difficultyClass BOSS maps to the BOSS 120 row
     of the ladder in scratch/MUSTAFAR-GAPS.md:1763 -- the same row
     som_sherkar_consort already uses. Stat row taken whole from that ladder /
     dark_jedi_master.lua:16. Live's own armour columns are NOT used -- the ladder
     is applied whole, same as every other retuned row.

     SOURCED:
       customName "the Doom Bringer" -- authored English; the trial's own boss
         waypoint key is literally doom_bringer
         (datatables/spawning/dungeon/som_working_droid_factory.tab).
       socialGroup "droid_army" -- live. pvpFaction droid_army has no Core3 field
         on this template; socialGroup carries it.
       creatureBitmask KILLER -- live death_blow = instant.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 / assist 9.
       scale 1.3 -- live minScale/maxScale. No hues key: live hue is 0.
       loot group doombringer_loot, lootChance 10000000 -- live intLootRolls 1,
         master_loot.tab chance 10000/10000.
       mobType MOB_DROID / defaultWeapon + defaultAttack -- droid convention
         already in this tree (union_sentry_droid.lua:66-67,
         som_volcano_five_boss_septipod.lua:56-57, mobile/lok/droideka.lua).

     WEAPON FALLBACK (known): Live's primary_weapon is
       object/weapon/ranged/droid/droid_union_sentry_02.iff, which is not
       registered anywhere in this repo -- som_volcano_five_boss_septipod.lua:4
       already records that same absence and takes the same fallback to
       droid_droideka_ranged.iff. Following that precedent rather than minting a
       second answer.

     Live's droid_special_6 profile row (ai_combat_profiles.tab:187) contains only
     the profile_id -- no actions at all. So no specials are authored. That is the
     live data, not an omission.

     chronicleLootChance / chronicleLootCategory are the Chronicles relic system,
     which this port does not implement. Recorded, not delivered. ]]
som_working_doom_bringer = Creature:new {
	customName = "the Doom Bringer",
	socialGroup = "droid_army",
	faction = "",
	mobType = MOB_DROID,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
	meatType = "",
	meatAmount = 0,
	hideType = "",
	hideAmount = 0,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = NONE,

	templates = {"object/mobile/som/union_sentry_droid.iff"},
	scale = 1.3,
	lootGroups = {
		{
			groups = {
				{group = "doombringer_loot", chance = 10000000}
			},
			lootChance = 10000000
		}
	},

	conversationTemplate = "",
	defaultWeapon = "object/weapon/ranged/droid/droid_droideka_ranged.iff",
	defaultAttack = "attack"
}

CreatureTemplates:addCreatureTemplate(som_working_doom_bringer, "som_working_doom_bringer")
