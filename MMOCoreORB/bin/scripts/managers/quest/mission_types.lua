-- Terminal mission journal rows. Design (D): one static generic row per type.
-- Client titles/categories are shipped @stf:key only (no new stf).
-- "Mission (Destroy)" is not a shipped string; categories use the closest
-- existing key (R15). Bounty category is the shipped "Bounty Hunter".

local MissionTypes = {
	destroy = {
		category = "@kb/kb_missions_n:destroy", -- "Destroy Missions" (kb_missions_n header, R15)
		title = "@ui_mission:name_destroy",
		description = "@kb/kb_missions_d:destroy",
		tasks = {
			[0] = "@ui_mission:accept", -- "Accept Mission"
			[1] = "@quest/ground/crash_site_01_imp_domestics:task00_journal_entry_title", -- "Travel to the site"
			[2] = "@ui_mission:destroy_tab", -- "Destroy"
		},
	},
	deliver = {
		category = "@kb/kb_missions_n:deliver", -- "Deliver Missions" (kb_missions_n header, R15)
		title = "@ui_mission:name_deliver",
		description = "@kb/kb_missions_d:deliver",
		tasks = {
			[0] = "@ui_mission:accept",
			[1] = "@ui_mission:deliver_start", -- "Collect the item from here:"
			[2] = "@ui_mission:deliver_end", -- "Take the item to:"
		},
	},
	crafting = {
		category = "@kb/kb_missions_n:crafting", -- "Crafting Missions" (kb_missions_n header, R15)
		title = "@ui_mission:name_crafting",
		description = "@kb/kb_missions_d:crafting",
		tasks = {
			[0] = "@ui_mission:accept",
			[1] = "@mission/mission_generic:crafting_components_received",
			[2] = "@ui_mission:deliver_end",
		},
	},
	bounty = {
		category = "@collection_n:bounty_hunter_kill", -- "Bounty Hunter"
		title = "@ui_mission:name_bounty", -- "Bounty Mission"
		description = "@kb/kb_missions_d:bounty",
		tasks = {
			[0] = "@ui_mission:accept",
			[1] = "@mission/mission_generic:probe_droid_program", -- "Transmit Biological Signature"
			[2] = "@ui_mission:kill_start", -- "Find your target here:"
			[3] = "@mission/mission_generic:probe_droid_find_target", -- "Find Bounty Target"
		},
	},
	hunting = {
		category = "@ui_mission:hunting_tab", -- "Hunting"
		title = "@ui_mission:kill", -- "Kill Mission"
		description = "@mission/mission_generic:hunting_kills_remaining",
		tasks = {
			[0] = "@ui_mission:accept",
			[1] = "@ui_mission:hunting_tab",
		},
	},
	survey = {
		category = "@kb/kb_missions_n:survey", -- "Survey Missions" (kb_missions_n header, R15)
		title = "@ui_mission:name_survey",
		description = "@kb/kb_missions_d:survey",
		tasks = {
			[0] = "@ui_mission:accept",
			[1] = "@ui_mission:survey_tab", -- "Survey"
		},
	},
	recon = {
		category = "@kb/kb_missions_n:recon", -- "Recon Missions" (kb_missions_n header, R15)
		title = "@ui_mission:recon_tab", -- "Recon"
		description = "@kb/kb_missions_d:recon",
		tasks = {
			[0] = "@ui_mission:accept",
			[1] = "@quest/ground/crash_site_01_imp_domestics:task00_journal_entry_title",
		},
	},
	dancer = {
		category = "@kb/kb_missions_n:dancer", -- "Dancer Gigs" (kb_missions_n header, R15)
		title = "@ui_mission:dancer_tab", -- "Dancer"
		description = "@kb/kb_missions_d:dancer",
		tasks = {
			[0] = "@ui_mission:accept",
			[1] = "@quest/ground/crash_site_01_imp_domestics:task00_journal_entry_title",
			[2] = "@ui_mission:dancer_tab",
		},
	},
	musician = {
		category = "@kb/kb_missions_n:musician", -- "Musician Gigs" (kb_missions_n header, R15)
		title = "@ui_mission:musician_tab", -- "Musician"
		description = "@kb/kb_missions_d:musician",
		tasks = {
			[0] = "@ui_mission:accept",
			[1] = "@quest/ground/crash_site_01_imp_domestics:task00_journal_entry_title",
			[2] = "@ui_mission:musician_tab",
		},
	},
}

return MissionTypes
