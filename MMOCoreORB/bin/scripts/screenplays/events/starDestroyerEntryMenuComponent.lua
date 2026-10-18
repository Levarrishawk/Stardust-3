local ObjectManager = require("managers.object.object_manager")

starDestroyerEntryMenuComponent = { }

function starDestroyerEntryMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	local response = LuaObjectMenuResponse(pMenuResponse)
	response:addRadialMenuItem(20, 3, "Board the Star Destroyer Blackguard")   -- OURS, NOT SOURCED
end

function starDestroyerEntryMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if CreatureObject(pPlayer):isInCombat() or CreatureObject(pPlayer):isIncapacitated() or CreatureObject(pPlayer):isDead() then
		return 0
	end
	if not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 6) then
		return 0
	end
	-- exarKunEntryMenuComponent.lua:23-26 has this guard; axkvaMinEntryMenuComponent.lua omits it.
	-- Keeping Lev's better version, same call H(ek) made.
	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):sendSystemMessage("You can not use this object while riding a mount.")
		return 0
	end
	if not (CreatureObject(pPlayer):isGrouped()) then
		CreatureObject(pPlayer):sendSystemMessage("You must be in a group to use this object.")
		return 0
	end
	if selectedID == 20 then
		createEvent(1000, "starDestroyer", "activate", pPlayer, "")
	end
	return 0
end
