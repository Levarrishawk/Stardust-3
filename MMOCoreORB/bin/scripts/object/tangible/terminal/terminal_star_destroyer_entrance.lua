-- object/tangible/terminal/terminal_star_destroyer_entrance.lua
-- Shape copied from object/tangible/terminal/terminal_exar_kun_entrance.lua:44-48 (Lev's
-- "a Smouldering Brazier") and terminal_axkva_min_entrance.lua ("Crystal of Binding").
-- SOURCED: the shared client template is SD3's already-registered escape-pod security console
--   (object/custom_content/tangible/quest/township/objects.lua:177-181), the same prop SOE's own
--   three intro quests use as the quest-item source (questtask/quest/star_destroyer_intro_imperial.tab
--   task 1, SERVER_TEMPLATE=object/tangible/quest/township/star_destroyer_intro_security_console.iff).
-- OURS, NOT SOURCED: the customName, and registering a second server template over the same shared.
object_tangible_terminal_terminal_star_destroyer_entrance =
    object_tangible_quest_township_shared_star_destroyer_intro_security_console:new {
	customName = "a Blackguard Escape Pod Console",     -- OURS, NOT SOURCED
	objectMenuComponent = "starDestroyerEntryMenuComponent",
}

ObjectTemplates:addTemplate(object_tangible_terminal_terminal_star_destroyer_entrance,
    "object/tangible/terminal/terminal_star_destroyer_entrance.iff")
