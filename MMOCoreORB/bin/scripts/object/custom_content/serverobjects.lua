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

--[[ Fourth instance of the same shape. Walking the include closure from
     object/serverobjects.lua (25,782 files, 24,633 templates) showed that none of
     the 23 SoM boss-drop weapon server templates the Mustafar loot chain needs are
     in it. Their client halves load from allobjects.lua
     (allobjects.lua:1262-1264 pulls the custom_content weapon objects.lua files),
     which is why the paths resolve everywhere and createObject still returns nil.
     Without these lines every boss loot roll that names one of those 23 silently
     drops the item.

     Ranged is included wholesale: custom_content/weapon/ranged/serverobjects.lua
     closes over 163 files / 157 templates with zero collisions against any path
     registered elsewhere in the tree, so it is safe.

     Melee is included file-by-file, never via custom_content/weapon/melee/
     serverobjects.lua. That wholesale closure is 138 files / 137 templates with
     three collisions, one of which overwrites a stock crafted saber
     (object/weapon/melee/polearm/crafted_saber/sword_lightsaber_polearm_gen5.iff)
     and another a quest 2h sword. Include order would decide which wins galaxy-
     wide. The eleven named files below carry none of the colliding paths.
     custom_content/weapon/melee/som_sword_obsidian.lua above is a different file
     from som_sword_obsidian_generic.lua and stays as it is.

     custom_content/draft_schematic/serverobjects.lua is already included at line
     10; SchematicMap is populated only from managers/crafting/schematics.lua, so
     registering an object template grants no Mustafar schematic and nothing here
     depends on it. ]]
includeFile("custom_content/weapon/ranged/serverobjects.lua")
includeFile("custom_content/weapon/melee/blacksun_razor_generic.lua")
includeFile("custom_content/weapon/melee/lance_kashyyk_generic.lua")
includeFile("custom_content/weapon/melee/massassiknuckler_generic.lua")
includeFile("custom_content/weapon/melee/som_2h_sword_massassi.lua")
includeFile("custom_content/weapon/melee/som_2h_sword_obsidian_generic.lua")
includeFile("custom_content/weapon/melee/som_2h_sword_tulrus_generic.lua")
includeFile("custom_content/weapon/melee/som_lance_obsidian_generic.lua")
includeFile("custom_content/weapon/melee/som_lance_xandank_generic.lua")
includeFile("custom_content/weapon/melee/som_sword_mustafar_bandit_generic.lua")
includeFile("custom_content/weapon/melee/som_sword_obsidian_generic.lua")
includeFile("custom_content/weapon/melee/sword_mace_junti_generic.lua")
