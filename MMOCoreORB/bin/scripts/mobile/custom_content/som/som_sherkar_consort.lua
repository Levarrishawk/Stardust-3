--[[ som_sherkar_consort -- Malfosa, the open-world Mustafar boss of the Sher Kar
     family. Live never puts it in the lair (monster_manager.java spawns som_sherkar,
     som_sherkar_praetorian, som_sherkar_karling, som_sherkar_symbiot and no consort).
     Live record: creatures.tab:4808, BaseLevel 80 / difficultyClass BOSS / where
     mustafar / socialGroup sherkar / template som/sher_kar.iff / minScale 0.65 /
     maxScale 0.65 / hue 3 / armorStun -1 / meat 19 meat_insect / hide 33 hide_scaley /
     lootTable mustafar/mustafar_sherkar_consort / primary_weapon_specials spider_5 /
     death_blow instant / aggressive 24 / assist 24 / stalker blank / herd blank.
     Live HP 225000 comes from trial.HP_SHER_KAR_CONSORT (trial.java:233) via the
     malfosa.java script, which does nothing else -- no special ability.

     TIER: BOSS 120. Live level 80 / difficultyClass BOSS does not map mechanically
     onto this port's ladder (scratch/MUSTAFAR-GAPS.md). Two independent inputs both
     land on BOSS 120: (1) live's own difficultyClass is BOSS -- consort and
     som_sherkar are the only two BOSS rows in the family; (2) live consort HP
     225000 is 25.4% of live Sher Kar's 885000, and the ladder's BOSS rung
     44000/54000 is 27.5%/27.7% of this repo's shipped sher_kar.lua RAID
     160000/195000 -- within ~2 points of live's own ratio. Stat row taken whole
     from MUSTAFAR-GAPS.md:1763 / dark_jedi_master.lua:16 -- same block
     som_dark_jedi_boss.lua already carries. DISCLOSED DIVERGENCE: live gives
     armorStun -1 (stun-vulnerable); the ladder's BOSS row gives stun 90. The
     ladder is applied whole, same as every other retuned row.

     SOURCED:
       customName "Malfosa" -- live shared template would read "Sher Kar"; no STF
         creature-name key for the consort. Chronicles string/en/collection_n.stf
         relic_destroy_malfosa = "Kill Malfosa", and the world spawner's strName
         objvar is literally malfosa. Standing ruling: author English, cite the key.
       socialGroup "sher_kar" -- live uses sherkar for both this and som_sherkar.
         This repo's shipped sher_kar.lua already chose sher_kar; matching keeps
         live's grouping intent with the repo's spelling.
       creatureBitmask KILLER -- live death_blow = instant is the KILLER flag
         (ObjectFlag.h:24 / Checks.h:230). stalker and herd are blank, so unlike
         sher_kar.lua there is no STALKER and no PACK.
       pvpBitmask AGGRESSIVE + ATTACKABLE + ENEMY -- live aggressive 24 / assist 24.
       scale 0.65 and hues { 3 } -- live minScale/maxScale/hue. scale is read at
         CreatureTemplate.cpp:149 and hues at :243-246; diskret_stahn.lua,
         obi_wan_ghost.lua, som_kenobi_obi_wan.lua and som_surveyor_keslev.lua
         already set scale. A one-element hues list is safe (random(0) -> index 0).
         Four volcano files in this pack falsely claim "Core3 Creature templates
         have no scale field" -- that claim is false; not edited this round.
       meat 19 meat_insect / hide 33 hide_scaley -- live. (shipped sher_kar.lua
         zeroes its own harvest even though live gives it 60/85 -- pre-existing
         sibling divergence, not copied here.)
       primaryWeapon unarmed -- live primary_weapon blank.

     OURS, NOT SOURCED:
       primaryAttacks { strongpoison, creatureareapoison }. Live specials come from
         AI combat profile spider_5 (ai_combat_profiles.tab:308) = bm_defensive_5,
         bm_damage_poison_5 x2, bm_puncture_3 -- a tier-5 poison spider. Nearest
         shipped Core3 creature commands are strongpoison (tier-5 poison) and
         creatureareapoison (area form). bm_defensive_5 and bm_puncture_3 have no
         Core3 creature-command analogue and are dropped. Exact pairing is a
         judgement; what is sourced is "poison, tier 5, and an area component." ]]
som_sherkar_consort = Creature:new {
	customName = "Malfosa",
	socialGroup = "sher_kar",
	faction = "",
	mobType = MOB_CARNIVORE,
	level = 120,
	chanceHit = 4.0,
	damageMin = 745,
	damageMax = 1200,
	baseXp = 11390,
	baseHAM = 44000,
	baseHAMmax = 54000,
	armor = 2,
	resists = {90,90,90,90,90,90,90,90,-1},
	meatType = "meat_insect",
	meatAmount = 19,
	hideType = "hide_scaley",
	hideAmount = 33,
	boneType = "",
	boneAmount = 0,
	milk = 0,
	tamingChance = 0,
	ferocity = 0,
	pvpBitmask = AGGRESSIVE + ATTACKABLE + ENEMY,
	creatureBitmask = KILLER,
	optionsBitmask = AIENABLED,
	diet = CARNIVORE,

	templates = {"object/mobile/som/sher_kar.iff"},
	hues = { 3 },
	scale = 0.65,
	lootGroups = {
		{
			groups = {
				{group = "sher_kar_consort", chance = 10000000}
			},
			lootChance = 909091
		}
	},

	primaryWeapon = "unarmed",
	secondaryWeapon = "none",
	conversationTemplate = "",

	primaryAttacks = { {"strongpoison",""}, {"creatureareapoison",""} },
	secondaryAttacks = { }
}

CreatureTemplates:addCreatureTemplate(som_sherkar_consort, "som_sherkar_consort")
