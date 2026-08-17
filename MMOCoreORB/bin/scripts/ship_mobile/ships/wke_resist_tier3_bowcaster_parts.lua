--[[
	Wookiee Resistance courier carrying the missing bowcaster pieces.

	WHY THIS FILE EXISTS. inspect/ep3_wke_bowcaster_crafting gates on
	inspectCargo = "ep3_wke_bowcaster_parts", and SpaceInspectScreenplay:veryifyShipTargetAndCargo()
	requires BOTH that the inspected agent's template name is listed in inspectTargets AND that
	getHashCode(inspectCargo) equals the agent's cargoString hash
	(SpaceInspectScreenplay.lua:217-260 -> ShipInspectTask.cpp:49-75 ->
	ShipAiAgentImplementation.cpp:351 -> ShipAgentTemplate.cpp:141). No ship in the tree declared
	that cargoString, so the quest could never complete.

	The shared wke_resist_tier3 is deliberately NOT tagged: it appears in many attackShips lists
	across the Kashyyyk screenplays, and giving it a cargoString would make every Wookiee Resistance
	B-wing in the system a valid inspect target. This is a purpose-built agent instead, following
	civshuttle_cor_tier3_pilot_capture.lua, which is the only other quest-cargo courier in the tree
	(CorsecSquadronScreenplay.lua:732-733 + space_dathomir_spawner.lua:127).

	Base stats are wke_resist_tier3's, unchanged, except: aggressive stays 0 and shipBitmask stays
	NONE so a courier the pilot is meant to scan does not open fire, and the loot table is the
	civilian one because this is a hauler rather than a fighter on station.

	TARGET WIRING ONLY -- CORRECTED. This paragraph used to open with a bare "WIRED.", which was
	misleading: it described the inspectTargets/spawn wiring and nothing else, but it read as though
	the quest were reachable. It was not. Until the Lolo giver below was added, NOTHING in the repo
	granted inspect/ep3_wke_bowcaster_crafting -- zero :startQuest call sites, no parentQuest, no
	sideQuest, nobody's sideQuest -- so a correctly targeted, correctly spawned, correctly cargoed
	courier sat in space for a quest no player could hold.

	What IS wired, and always was:
	  - KashyyykHuntingScreenplay.lua:694-725, inspect_ep3_wke_bowcaster_crafting reads
			inspectTargets = {"wke_resist_tier3_bowcaster_parts"},
		(was {"wke_resist_tier3"}), matching inspectCargo = "ep3_wke_bowcaster_parts" against the
		cargoString below.
	  - space_kashyyyk_spawner.lua:197-199 (entry "kash_wke_bowcaster_parts_inspect"; the ship name is
		on line 198) spawns this agent at the quest's own targetLocation.

	THE GRANT now exists: Lolo, the Kachirho weaponsmith, hands the quest out on shipped line
	ep3_kachirho_lolo:s_97.
		mobile/conversations/space/neutral/kashyyyk_bowcaster/ep3_wke_lolo_convo.lua
		screenplays/space/conversations/neutral/kashyyyk_bowcaster/ep3WkeLoloConvoHandler.lua
	READ THAT HANDLER'S REACHABILITY PARAGRAPH BEFORE CALLING THIS QUEST PLAYABLE: ep3_wke_lolo is
	still not spawned anywhere, and bin/conf/config.lua ZonesEnabled has no Kashyyyk ground zone. The
	grant exists; the giver is not yet standing anywhere a player can reach it.

	CLIENT-TEXT NOTE: string/en/space/cargo.stf ships 124 cargo keys and none of them is a bowcaster
	part; "ep3_wke_bowcaster_parts" is ours, as the quest file already says. ShipInspectTask.cpp
	displays the cargo as "@space/cargo:<cargoString>", so an untranslated key will render raw.
]]

wke_resist_tier3_bowcaster_parts = ShipAgent:new {
	template = "bwing_tier3",
	pilotTemplate = "bomber_tier3",
	shipType = "fighter",

	experience = 1536,

	lootChance = 0.18,
	lootRolls = 1,
	lootTable = "space_civilian_tier3",

	minCredits = 160,
	maxCredits = 353,

	aggressive = 0,

	spaceFaction = "wke_resist",
	alliedFactions = {"wke_resist", "rebel", "civilian"},
	enemyFactions = {"imperial", "pirate", "ghrag", "chiss"},

	pvpBitmask = ATTACKABLE,
	shipBitmask = NONE,
	optionsBitmask = AIENABLED,

	customShipAiMap = "",

	conversationTemplate = "",
	conversationMobile = "object/mobile/shared_space_comm_wke_resist_01.iff",
	conversationMessage = "", --Too Far Message

	cargoString = "ep3_wke_bowcaster_parts",
}

ShipAgentTemplates:addShipAgentTemplate(wke_resist_tier3_bowcaster_parts, "wke_resist_tier3_bowcaster_parts")
