-- object/tangible/terminal/terminal_echo_base_entrance_imperial.lua
-- Shape copied from object/tangible/terminal/terminal_star_destroyer_entrance.lua.
-- SOURCED: the shared client template is SD3's already-registered escape-pod security console
--   (object/custom_content/tangible/quest/township/objects.lua:177-181), the same prop the
--   Star Destroyer entrance uses. OURS, NOT SOURCED: the customName, and registering a
--   second server template over the same shared.
object_tangible_terminal_terminal_echo_base_entrance_imperial =
    object_tangible_quest_township_shared_star_destroyer_intro_security_console:new {
	customName = "an Echo Base Imperial Launch Console",     -- OURS, NOT SOURCED
	objectMenuComponent = "echoBaseEntryMenuComponent",
}

ObjectTemplates:addTemplate(object_tangible_terminal_terminal_echo_base_entrance_imperial,
    "object/tangible/terminal/terminal_echo_base_entrance_imperial.iff")
