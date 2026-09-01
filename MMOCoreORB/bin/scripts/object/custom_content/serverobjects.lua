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

--[[ The same shape one directory over: custom_content/tangible/serverobjects.lua
     includes every sibling except container/, so
     custom_content/tangible/container/loot/som_cube.lua never runs and
     object/tangible/container/loot/som_cube.iff has no SERVER template. Its client
     half IS loaded, from allobjects.lua, which is why the path resolves everywhere
     and createObject still returns nil. That leaves the Chu-Gon Dar cube
     uncreatable -- the jenha_tar_cube reward, and what hasCube and replaceCube
     both test. One file rather than the whole container tree, for the same reason
     as the sword above. ]]
includeFile("custom_content/tangible/container/loot/som_cube.lua")

--[[ Third instance of the same shape, and the widest of the three.
     custom_content/intangible/serverobjects.lua includes only vehicle/, so
     custom_content/intangible/pet/serverobjects.lua is never reached from anywhere --
     nothing in the tree includes it. That strands every custom_content pet control
     device: ~45 at the top level, 30 under beast_master/, and the 7 under som/. Their
     client halves ARE loaded (allobjects.lua:1128-1130 pulls all three objects.lua
     files), which is why the paths resolve and createObject still returns nil.

     This matters now because the som creature retune set tamingChance = 0.25 and
     controlDeviceTemplate = "object/intangible/pet/som/<x>.iff" on exactly the 7
     families that ship a device (blistmok, jundak, kubaza_beetle, lava_flea, tanray,
     tulrus, xandank). Without this line a successful tame calls createObject on an
     unregistered template.

     Pulling in the 7 som devices only, not custom_content/intangible/pet/serverobjects.lua,
     for the same reason as the sword and the cube above: the other ~75 devices are not
     this arc's to switch on, and whether they should be is upstream's call. Ordering is
     safe -- main.lua runs allobjects.lua before serverobjects.lua. ]]
includeFile("custom_content/intangible/pet/som/serverobjects.lua")
