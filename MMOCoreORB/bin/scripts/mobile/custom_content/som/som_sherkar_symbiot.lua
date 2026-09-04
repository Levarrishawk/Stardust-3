--[[ som_sherkar_symbiot -- Sher Kar Symbiot, one of four guards
     monster_manager.java places in the Monster Lair. Live record:
     creatures.tab BaseLevel 85 / difficultyClass ELITE / HP 95000 (runtime from
     trial.java, header only -- Core3 has no matching HAM column; the tier
     ladder's baseHAM governs) / where mustafar / socialGroup sherkar /
     template som/sher_kar.iff / minScale 0.15 / maxScale 0.15 / hue 1 /
     intLootRolls 1 / intRollPercent 80 / lootTable BLANK / niche carnivore /
     meat 16 meat_insect / hide 24 hide_scaley / primary_weapon blank /
     primary_weapon_specials spider_5 / aggressive 6 / assist 6 /
     death_blow yes / script sher_kar.life_sapper.

     TIER: ELITE 85. Live level 85 / difficultyClass ELITE maps to the ELITE 85
     row of the ladder in scratch/MUSTAFAR-GAPS.md -- the same reading every
     prior Mustafar round took. Stat row taken whole from that ladder. Resists
     are R_BASE {0,0,0,0,0,0,0,-1,-1}.

     SOURCED:
       customName "Sher Kar Symbiot" -- live English name.
       socialGroup "sherkar" -- live.
       templates {"object/mobile/som/sher_kar.iff"}, hues { 1 }, scale 0.15 --
         live. Same sher_kar.iff body as the boss (scale 1.2); at 0.15 it reads
         as his brood, not a separate species. That is live's own data, not a
         choice.
       meat 16 meat_insect / hide 24 hide_scaley -- live; amounts match
         som_link_lava_beetle_defender.lua.
       primaryWeapon "unarmed" -- live primary_weapon blank.
       lootGroups {} -- live intLootRolls 1 / intRollPercent 80 with a blank
         lootTable; there is no group to name. Empty here is live's data, not
         an omission.
       creatureBitmask PACK + KILLER -- KILLER from live death_blow = yes;
         PACK because live calls ai_lib.establishAgroLink(guards[0], guards)
         and Core3 has no binding -- same substitution
         som_link_lava_beetle_defender.lua records.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 6 /
         assist 6.

       primaryAttacks { strongpoison, creatureareaattack }. Live specials come
         from AI profile spider_5 (ai_combat_profiles.tab:308) =
         bm_defensive_5 (once), bm_damage_poison_5 x2, bm_puncture_3. Mapped by
         the method som_link_lava_beetle_foreman.lua already records.
         bm_damage_poison_5 is the dominant action -- two of the four slots --
         and maps to Core3 poison. The tier picks the strength: the shipped
         spider family runs mildpoison at level 8-27
         (dathomir/cavern_spider.lua, gaping_spider.lua), mediumpoison at 44-46
         (cavern_spider_hunter.lua, cavern_spider_queen.lua) and strongpoison
         from 31 up (dathomir/chasmal_spider.lua:level 31). These guards are
         level 85, and the live action is tier 5, so strongpoison.
         bm_puncture_3 has no direct Core3 creature-command analogue, so the
         family's own verb is used -- sher_kar.lua ships
         creatureareaattack + creatureareaknockdown, and these three carry the
         same sher_kar.iff body at scale 0.3. bm_defensive_5 is a self-buff
         with no Core3 creature-command analogue and is dropped.
         The pairing is a judgement; what is sourced is "a tier-5 spider
         profile exists".
         CORRECTED IN H(h3): this file previously said spider_5 was "not ported
         this round". The row was readable all along at
         ai_combat_profiles.tab:308. ]]
som_sherkar_symbiot = Creature:new {
	customName = "Sher Kar Symbiot",
	socialGroup = "sherkar",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 85,
	chanceHit = 0.75,
	damageMin = 555,
	damageMax = 820,
	baseXp = 8130,
	baseHAM = 12000,
	baseHAMmax = 15000,
	armor = 1,
	resists = {0,0,0,0,0,0,0,-1,-1},
	meatType = "meat_insect",
	meatAmount = 16,
	hideType = "hide_scaley",
	hideAmount = 24,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = PACK + KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/sher_kar.iff"},
	hues = { 1 },
	scale = 0.15,
	lootGroups = {},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = { {"strongpoison",""}, {"creatureareaattack",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_sherkar_symbiot, "som_sherkar_symbiot")
