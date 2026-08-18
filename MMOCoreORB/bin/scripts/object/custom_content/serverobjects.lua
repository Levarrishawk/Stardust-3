--New Content


--Children folder includes
includeFile("custom_content/mobile/serverobjects.lua")
includeFile("custom_content/static/serverobjects.lua")
includeFile("custom_content/building/serverobjects.lua")
includeFile("custom_content/tangible/serverobjects.lua")
includeFile("custom_content/intangible/serverobjects.lua")
includeFile("custom_content/draft_schematic/serverobjects.lua")

--[[ custom_content/weapon/serverobjects.lua is not included from anywhere, so none of the
     custom weapon SERVER templates are registered -- only their client halves, which come
     in through allobjects.lua and cannot satisfy createObject. That leaves the Symbiosis
     reward sword uncreatable: giveItem returns nil and the player finishes the quest with
     nothing. Pulling in the one file the arc needs rather than the whole weapon tree,
     which would register 355 never-loaded templates in one go. Ordering is safe: main.lua
     runs allobjects.lua (which defines the shared parent) before this file. ]]
includeFile("custom_content/weapon/melee/som_sword_obsidian.lua")
