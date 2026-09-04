-- Malfosa's only live drop. See mobile/custom_content/som/som_sherkar_consort.lua.
--
-- Live: datatables/loot/loot_items/mustafar/sher_kar_consort.tab holds exactly one
-- item, object/tangible/loot/mustafar/cube_loot/cube_loot_3r.iff.
--
-- READ THIS BEFORE "CORRECTING" THE PATH BELOW. The directObjectTemplate is
-- deliberately the SPLIT path "cube/loot", not "cube_loot". object/custom_content/tangible/loot/mustafar/cube_loot/cube_loot_3r.lua
-- registers the server template at that split path; the client template is registered
-- correctly. Same defect and same workaround as the three quest cubes -- see
-- screenplays/mustafar/quest/jenha_tar_cube.lua:124-137 and :271-273. Correcting the
-- object file is not this port's call.
--
-- No craftingValues: this is an inert quest cube, not equipment. Live's
-- cube_loot_3p + cube_loot_3q + cube_loot_3r assemble into object/tangible/item/som/
-- sher_kar_syringe.iff via datatables/item/loot_cube/republic_assembly_tool.tab:3.
-- customObjectName is left empty so the shipped STF name is used:
-- som/som_cube.stf cube_loot_3r_n = "a warmly glowing poison gland".

cube_loot_3r = {
	minimumLevel = 0,
	maximumLevel = -1,
	customObjectName = "",
	directObjectTemplate = "object/tangible/loot/mustafar/cube/loot/cube_loot_3r.iff",
	craftingValues = {},
	customizationStringNames = {},
	customizationValues = {}
}

addLootItemTemplate("cube_loot_3r", cube_loot_3r)
