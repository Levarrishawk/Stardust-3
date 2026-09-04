-- Tusken Army (Mos Espa) entry radial. Copied from Lev's axkvaMinEntryMenuComponent.lua
-- (the template, Aaron 2026-09-04): radial ids (20, 3) = axkvaMinEntryMenuComponent.lua:7,
-- the 6 m range check = :16. Mount guard DROPPED (D10): SOE instance_datatable.tab
-- vehicle_allowed = 1 and the town is 656 m wide. Grouped-only kept.
local ObjectManager = require("managers.object.object_manager")

tuskenArmyEntryMenuComponent = {  }

function tuskenArmyEntryMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	local response = LuaObjectMenuResponse(pMenuResponse)
	response:addRadialMenuItem(20, 3, "Enter Mos Espa")	-- OURS, NOT SOURCED (label). SUI title is the shipped "Heroic: Tusken Army".

end

function tuskenArmyEntryMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if CreatureObject(pPlayer):isInCombat() or CreatureObject(pPlayer):isIncapacitated() or CreatureObject(pPlayer):isDead() then
		return 0
	end

	if not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 6) then	-- Lev, axkvaMinEntryMenuComponent.lua:16
		return 0
	end

	-- D10: no mount guard. SOURCED (SOE, instance_datatable.tab vehicle_allowed = 1).

	if not (CreatureObject(pPlayer):isGrouped()) then
	  CreatureObject(pPlayer):sendSystemMessage("You must be in a group to use this object.")
	  return 0
	end

	if selectedID == 20 then
	  createEvent(1000, "tuskenArmy", "activate", pPlayer, "")
	end

	return 0
end
