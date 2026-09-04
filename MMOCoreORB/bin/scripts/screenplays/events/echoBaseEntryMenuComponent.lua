local ObjectManager = require("managers.object.object_manager")

echoBaseEntryMenuComponent = { }

function echoBaseEntryMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	local response = LuaObjectMenuResponse(pMenuResponse)
	response:addRadialMenuItem(20, 3, "Travel to Echo Base")   -- OURS, NOT SOURCED
end

function echoBaseEntryMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if CreatureObject(pPlayer):isInCombat() or CreatureObject(pPlayer):isIncapacitated() or CreatureObject(pPlayer):isDead() then
		return 0
	end
	if not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, 6) then
		return 0
	end
	-- exarKunEntryMenuComponent.lua:23-26 has this guard; axkvaMinEntryMenuComponent.lua omits it.
	-- Keeping Lev's better version, same call H(ek) / H(sd) made.
	if (CreatureObject(pPlayer):isRidingMount()) then
		CreatureObject(pPlayer):sendSystemMessage("You can not use this object while riding a mount.")
		return 0
	end
	if not (CreatureObject(pPlayer):isGrouped()) then
		CreatureObject(pPlayer):sendSystemMessage("You must be in a group to use this object.")	-- Lev, axkvaMinEntryMenuComponent.lua:21
		return 0
	end
	if selectedID == 20 then
		-- Rebel = 1, Imperial = 2. SOE instance.getInstanceTeam() returns 1 or 2
		-- (echo_base_launch.java:91,103). Recorded for EB-c faction chains.
		local path = SceneObject(pSceneObject):getTemplateObjectPath()
		if (string.find(path, "imperial", 1, true) ~= nil) then
			writeData("echoBase:faction", 2)
		else
			writeData("echoBase:faction", 1)
		end
		createEvent(1000, "echoBase", "activate", pPlayer, "")
	end
	return 0
end
