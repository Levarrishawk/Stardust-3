-- IG-88 factory entry panel radial. Copied from Lev's axkvaMinEntryMenuComponent.lua (the template,
-- ruling 2026-09-04): radial ids (20, 3) = axkvaMinEntryMenuComponent.lua:7, the 6 m range check =
-- :16, the mount guard = exarKunEntryMenuComponent.lua:23-26. Only the label text is OURS.
local ObjectManager = require("managers.object.object_manager")

ig88EntryMenuComponent = {  }

function ig88EntryMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	local response = LuaObjectMenuResponse(pMenuResponse)
	response:addRadialMenuItem(20, 3, "Enter the IG-88 Factory")	-- OURS, NOT SOURCED (label)
	
end

function ig88EntryMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if CreatureObject(pPlayer):isInCombat() or CreatureObject(pPlayer):isIncapacitated() or CreatureObject(pPlayer):isDead() then
		return 0
	end

	if not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 6) then	-- Lev, axkvaMinEntryMenuComponent.lua:16
		return 0
	end
	
	if (CreatureObject(pPlayer):isRidingMount()) then	-- Lev, exarKunEntryMenuComponent.lua:23
    CreatureObject(pPlayer):sendSystemMessage("You can not use this object while riding a mount.")  
    return 0
  end
	
	if not (CreatureObject(pPlayer):isGrouped()) then
	  CreatureObject(pPlayer):sendSystemMessage("You must be in a group to use this object.")  
	  return 0
	end

	if selectedID == 20 then
	  createEvent(1000, "ig88", "activate", pPlayer, "")
	  		 	
    
	end

	return 0
end




