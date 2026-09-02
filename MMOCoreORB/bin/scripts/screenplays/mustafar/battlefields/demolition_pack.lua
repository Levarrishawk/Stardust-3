--[[
Demolition Pack  --  SOE's valley battlefield player tool

WHAT THIS IS

Live split this across three scripts attached to three objects:
demolition_generator.java (the pack), demolition_detonator.java (the
detonator), demolition_pack.java (the planted charge). Core3 has no
per-object script attach of that shape, so all three live here as one
screenplay plus two ObjectMenuComponent tables -- the same pattern
corvetteMenuComponents.lua uses for multi-object radials.

The pack starts as a world prop (stage-1 spawn with demoInWorld set) and
becomes an inventory tool when picked up. The inventory copy plants a
charge and hands the player a detonator; the detonator either pages the
charge (fly text, kept) or detonates it (one-shot, destroyed).

SUBSTITUTIONS

SUBSTITUTION A -- damage type is dropped. Live calls
damage(target, DAMAGE_ELEMENTAL_HEAT, HIT_LOCATION_BODY, dmg). Core3 Lua's
CreatureObject:inflictDamage(attacker, damageType, damage, destroy) takes a
HAM pool index, not an elemental type
(CreatureObjectImplementation.cpp:1194, :1231; every existing call site
passes 0). Heat typing and hit location cannot be reproduced. Pass 0
(health). The attacker is the player who detonated, so threat and
attribution land correctly -- live's damage() has no attacker argument.

SUBSTITUTION B -- target search is the tracked set, not a world query.
Live uses getObjectsInRange. Core3 Lua has no world range query among the
117 globals DirectorManager.cpp registers. Substitute: iterate
ValleyBattlefield:getBlastCandidates() (army + allies + players) and
range-check each with isInRangeWithObject. Consequences: a charge
detonated with no active session hits nobody (effect still plays, charge
still destroys -- live's empty-targets branch); world objects the arena
did not spawn are not hit. Nothing else is in the arena.

SUBSTITUTION C -- the commando ladder is re-keyed onto the pre-CU tree.
Live counts class_commando_phase1_novice .. phase4_master (five boxes,
level 0..5). None of those names exist in this tree (grepped src/ and
bin/scripts/). Re-key onto the pre-CU thrown-weapon line, the explosives
branch: combat_commando_novice + thrownweapon_01..04 each +1, and
combat_commando_master forces 5. Same shape -- 0 for a non-commando, 5
for a master. Do not "fix" these back to the NGE names; they are not
here.

SUBSTITUTION D -- the 500 m anchor. Live's
verifyLocationBasedDestructionAnchor has no Core3 equivalent. At the same
trigger point (radial fill), if the player is more than 500 m from the
arena anchor, return an empty menu and reap the object. Distance via
ValleyBattlefield:isNearArena(pPlayer, 500). Two departures from live in
that reap. Live anchors each item at the spot it was made; this anchors on
the arena origin, which cannot matter because the arena is well under
500 m across, so the only thing the check has to catch is gear carried out
of it. And the destroy is deferred one tick through anchorExpired rather
than run inline, because live returns SCRIPT_OVERRIDE and lets a separate
anchor system do the destroying, whereas here the destroy would be running
inside the object's own fillObjectMenuResponse.

SUBSTITUTION G -- persistence. Live marks all three objects
trial.TEMP_OBJECT (demolition_pack.java:30, demolition_generator.java:99).
Core3 has no such flag, so every demo object is destroyed from the world
AND from the database, always paired, which is this repo's own idiom for a
consumed inventory item (corvetteMenuComponents.lua:194-195,
deathWatchForemanConvoHandler.lua:131-132, and ten more). One entry point:
DemolitionPack:destroyDemoObject.

SUBSTITUTION E -- the radial is runtime-set, not script-attached. Live
attachScripts and it persists. Core3 uses
SceneObject:setObjectMenuComponent("Name"), which falls through to
LuaObjectMenuComponent (SceneObjectImplementation.cpp:496-517) -- every
screenplay radial in this repo. A menu set this way REPLACES the object's
menu entirely. The radial does not survive a server restart; that is
acceptable only because ValleyBattlefield:resetArena destroys all demo
gear on the track.demo list, so a pack or detonator can never be stranded
without its radial.

SUBSTITUTION F -- playClientEffectLoc has no scale argument. Live passes
0.4f as a fourth argument; Core3's signature is seven args with no scale.
Dropped.

detonateRange from npc_landmines.tab is 1 on every row and is a
proximity-trigger field for NPC landmines. These charges are
command-detonated; live never reads it. Not ported.

All five string keys used here (pick_up_demo_pack, place_charge,
detonate_charge, page_charge, charge_page_text) are present in
string/en/npc_landmines.stf and mustafar/valley_battlefield.stf shipped
in mtg_patch_019.tre (conf/config.lua:176).
--]]

DemolitionPack = ScreenPlay:new {
	numberOfActs = 1,
	screenplayName = "DemolitionPack",

	packTemplate = "object/tangible/dungeon/mustafar/valley_battlefield/demo_pack.iff",
	detTemplate = "object/tangible/dungeon/mustafar/valley_battlefield/demo_detonator.iff",

	anchorRange = 500,     -- SUBSTITUTION D
	useRange = 8,          -- port constant; Core3 Lua radials do not enforce use range (glyph_hunt.lua house pattern). Live has no pick-up proximity check because SOE's radial system does.
	startingMines = 6,     -- valley_event_data.tab rows 11-12, scriptVar currentMineCount=6
}

registerScreenPlay("DemolitionPack", true)

-- datatables/combat/npc_landmines.tab rows 10-15 (tiers 0..5).
-- Columns used: mineTemplate, blastRadius, minDamage, maxDamage, effectOnExplode.
-- damageType is heat on every row -- dropped, see SUBSTITUTION A.
-- detonateRange is 1 on every row and is not read for command-detonated charges.
DemolitionPack.tiers = {
	[0] = {
		template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_charge_light.iff",
		blastRadius = 8,
		minDamage = 1445,
		maxDamage = 1605,
		effect = "clienteffect/exp_ap_landmine.cef",
	},
	[1] = {
		template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_charge_light.iff",
		blastRadius = 9,
		minDamage = 1825,
		maxDamage = 2055,
		effect = "clienteffect/exp_ap_landmine.cef",
	},
	[2] = {
		template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_charge_medium.iff",
		blastRadius = 10,
		minDamage = 2344,
		maxDamage = 2505,
		effect = "clienteffect/combat_grenade_proton.cef",
	},
	[3] = {
		template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_charge_medium.iff",
		blastRadius = 12,
		minDamage = 2948,
		maxDamage = 3200,
		effect = "clienteffect/combat_grenade_proton.cef",
	},
	[4] = {
		template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_charge_medium.iff",
		blastRadius = 14,
		minDamage = 3350,
		maxDamage = 3605,
		effect = "clienteffect/combat_grenade_proton.cef",
	},
	[5] = {
		template = "object/tangible/dungeon/mustafar/valley_battlefield/demo_charge_heavy.iff",
		blastRadius = 18,
		minDamage = 4200,
		maxDamage = 5000,
		effect = "clienteffect/combat_grenade_thermal_detonator.cef",
	},
}

--------------------------------------------------------------------------------
-- State helpers
--------------------------------------------------------------------------------

function DemolitionPack:clearKeys(oid)
	if (oid == nil) then
		return
	end

	deleteData(oid .. ":demoInWorld")
	deleteData(oid .. ":demoMines")
	deleteData(oid .. ":demoTier")
	deleteData(oid .. ":demoCharge")
	deleteData(oid .. ":demoSession")
end

-- Every demo object is consumable and must not survive a restart. Live marks all
-- three with trial.TEMP_OBJECT (demolition_pack.java:30,
-- demolition_generator.java:99), which is SOE's own "do not persist" flag; the
-- repo equivalent is destroying from world AND from the database, always paired
-- (corvetteMenuComponents.lua:194-195, deathWatchForemanConvoHandler.lua:131-132,
-- and ten more sites). destroyObjectFromWorld alone would leave the row behind.
function DemolitionPack:destroyDemoObject(pObj)
	if (pObj == nil) then
		return
	end

	self:clearKeys(SceneObject(pObj):getObjectID())
	SceneObject(pObj):destroyObjectFromWorld()
	SceneObject(pObj):destroyObjectFromDatabase()
end

-- Deferred destruction for the anchor-fail branch. Destroying an object from
-- inside its own fillObjectMenuResponse would free it while the response it is
-- building is still being written, so the destroy is pushed one tick out. Live
-- does not have this problem: it returns SCRIPT_OVERRIDE and lets the separate
-- anchor system do the destroying (demolition_pack.java:43-59).
function DemolitionPack:anchorExpired(pObj, args)
	self:destroyDemoObject(pObj)
end

--------------------------------------------------------------------------------
-- Pack menu  --  live demolition_generator.java OnObjectMenuRequest / Select
--------------------------------------------------------------------------------

-- 20 is RadialOptions.h ITEM_USE; 3 is the callback value every existing Lua
-- menu component in this repo passes.
SomDemoPackMenuComponent = {}

function SomDemoPackMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pMenuResponse == nil or pPlayer == nil) then
		return
	end

	-- SUBSTITUTION D: fail the 500 m anchor -> suppress the menu and reap the
	-- object next tick (see DemolitionPack:anchorExpired).
	if (ValleyBattlefield == nil or not ValleyBattlefield:isNearArena(pPlayer, DemolitionPack.anchorRange)) then
		createEvent(1000, "DemolitionPack", "anchorExpired", pSceneObject, "")
		return
	end

	local oid = SceneObject(pSceneObject):getObjectID()

	if (readData(oid .. ":demoInWorld") == 1) then
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@mustafar/valley_battlefield:pick_up_demo_pack")
	else
		LuaObjectMenuResponse(pMenuResponse):addRadialMenuItem(20, 3, "@npc_landmines:place_charge")
	end
end

function SomDemoPackMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil or selectedID ~= 20) then
		return 0
	end

	local oid = SceneObject(pSceneObject):getObjectID()

	if (readData(oid .. ":demoInWorld") == 1) then
		if (not CreatureObject(pPlayer):isInRangeWithObject(pSceneObject, DemolitionPack.useRange)) then
			return 0
		end

		DemolitionPack:pickUp(pSceneObject, pPlayer)
	else
		DemolitionPack:placeCharge(pSceneObject, pPlayer)
	end

	return 0
end

--------------------------------------------------------------------------------
-- Detonator menu  --  live demolition_detonator.java
--------------------------------------------------------------------------------

-- 22 is RadialOptions.h ITEM_USE_OTHER (live's submenu under DETONATE).
SomDemoDetonatorMenuComponent = {}

function SomDemoDetonatorMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pMenuResponse == nil or pPlayer == nil) then
		return
	end

	if (ValleyBattlefield == nil or not ValleyBattlefield:isNearArena(pPlayer, DemolitionPack.anchorRange)) then
		createEvent(1000, "DemolitionPack", "anchorExpired", pSceneObject, "")
		return
	end

	local response = LuaObjectMenuResponse(pMenuResponse)
	response:addRadialMenuItem(20, 3, "@npc_landmines:detonate_charge")
	response:addRadialMenuItemToRadialID(20, 22, 3, "@npc_landmines:page_charge")
end

function SomDemoDetonatorMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pSceneObject == nil or pPlayer == nil) then
		return 0
	end

	if (selectedID == 20) then
		DemolitionPack:detonate(pSceneObject, pPlayer)
	elseif (selectedID == 22) then
		DemolitionPack:page(pSceneObject, pPlayer)
	end

	return 0
end

--------------------------------------------------------------------------------
-- Pack actions  --  live regenerateInPlayerInventory / placeDetonationCharge
--------------------------------------------------------------------------------

function DemolitionPack:pickUp(pPack, pPlayer)
	if (pPack == nil or pPlayer == nil) then
		return
	end

	local worldOid = SceneObject(pPack):getObjectID()
	local mines = readData(worldOid .. ":demoMines")
	local session = readData(worldOid .. ":demoSession")

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		printLuaError("DemolitionPack:pickUp: player has no inventory")
		return
	end

	-- Four-arg giveItem; the fourth is overload, matching live's
	-- createObjectInInventoryAllowOverload (demolition_generator.java:54-65).
	local pNew = giveItem(pInventory, self.packTemplate, -1, true)

	if (pNew == nil) then
		printLuaError("DemolitionPack:pickUp: failed to create inventory demo_pack; world pack left in place")
		return
	end

	local newOid = SceneObject(pNew):getObjectID()

	-- Do NOT set demoInWorld on the inventory copy -- its absence is the mode flag
	-- (live hasBeenPickedUp: inWorld present means NOT picked up).
	writeData(newOid .. ":demoMines", mines)
	writeData(newOid .. ":demoSession", session)
	SceneObject(pNew):setObjectMenuComponent("SomDemoPackMenuComponent")

	if (ValleyBattlefield ~= nil) then
		ValleyBattlefield:trackDemoObject(newOid)
	end

	self:destroyDemoObject(pPack)
end

function DemolitionPack:placeCharge(pPack, pPlayer)
	if (pPack == nil or pPlayer == nil) then
		return
	end

	local tier = self:commandoLevel(pPlayer)
	local row = self.tiers[tier]

	if (row == nil) then
		printLuaError("DemolitionPack:placeCharge: unknown tier " .. tostring(tier))
		return
	end

	local x = SceneObject(pPlayer):getWorldPositionX()
	local z = SceneObject(pPlayer):getWorldPositionZ()
	local y = SceneObject(pPlayer):getWorldPositionY()

	-- Identity quaternion -- live does not orient the charge.
	-- Argument order is x, z(height), y -- same convention valley_battlefield.lua documents.
	local pCharge = spawnSceneObject("mustafar", row.template, x, z, y, 0, 1, 0, 0, 0)

	if (pCharge == nil) then
		printLuaError("DemolitionPack:placeCharge: failed to spawn charge; mine count untouched")
		return
	end

	local chargeOid = SceneObject(pCharge):getObjectID()
	local packOid = SceneObject(pPack):getObjectID()
	local session = readData(packOid .. ":demoSession")

	writeData(chargeOid .. ":demoTier", tier)
	writeData(chargeOid .. ":demoSession", session)

	if (ValleyBattlefield ~= nil) then
		ValleyBattlefield:trackDemoObject(chargeOid)
	end

	local pInventory = SceneObject(pPlayer):getSlottedObject("inventory")

	if (pInventory == nil) then
		-- Live creates the charge BEFORE the detonator and does not roll the charge
		-- back if the detonator fails (demolition_generator.java:74-85, :121-134).
		-- A failed detonator leaves a live charge in the world that nobody can
		-- trigger, and does not consume a mine. Keep that ordering.
		printLuaError("DemolitionPack:placeCharge: player has no inventory; charge left in world, mine count untouched")
		return
	end

	local pDet = giveItem(pInventory, self.detTemplate, -1, true)

	if (pDet == nil) then
		printLuaError("DemolitionPack:placeCharge: failed to create detonator; charge left in world, mine count untouched")
		return
	end

	local detOid = SceneObject(pDet):getObjectID()

	writeData(detOid .. ":demoCharge", chargeOid)
	writeData(detOid .. ":demoSession", session)
	SceneObject(pDet):setObjectMenuComponent("SomDemoDetonatorMenuComponent")

	if (ValleyBattlefield ~= nil) then
		ValleyBattlefield:trackDemoObject(detOid)
	end

	-- Mine count decremented LAST, from inside generateDetonationDevice in live,
	-- so a failed detonator also does not consume a mine.
	self:decrementMines(pPack)
end

function DemolitionPack:decrementMines(pPack)
	if (pPack == nil) then
		return
	end

	local oid = SceneObject(pPack):getObjectID()
	local mines = readData(oid .. ":demoMines") - 1

	-- live decrimentMineCount (demolition_generator.java:146-158)
	if (mines <= 0) then
		self:destroyDemoObject(pPack)
		return
	end

	writeData(oid .. ":demoMines", mines)
end

-- SUBSTITUTION C -- pre-CU thrown-weapon ladder. Live's class_commando_phase*
-- names do not exist in this tree.
function DemolitionPack:commandoLevel(pPlayer)
	if (pPlayer == nil) then
		return 0
	end

	local level = 0

	if (CreatureObject(pPlayer):hasSkill("combat_commando_novice")) then
		level = level + 1
	end

	if (CreatureObject(pPlayer):hasSkill("combat_commando_thrownweapon_01")) then
		level = level + 1
	end

	if (CreatureObject(pPlayer):hasSkill("combat_commando_thrownweapon_02")) then
		level = level + 1
	end

	if (CreatureObject(pPlayer):hasSkill("combat_commando_thrownweapon_03")) then
		level = level + 1
	end

	if (CreatureObject(pPlayer):hasSkill("combat_commando_thrownweapon_04")) then
		level = level + 1
	end

	if (CreatureObject(pPlayer):hasSkill("combat_commando_master")) then
		return 5
	end

	return level
end

--------------------------------------------------------------------------------
-- Detonator actions  --  live detonateCharge / pageDetonationCharge
--------------------------------------------------------------------------------

function DemolitionPack:detonate(pDetonator, pPlayer)
	if (pDetonator == nil or pPlayer == nil) then
		return
	end

	local detOid = SceneObject(pDetonator):getObjectID()
	local chargeOid = readData(detOid .. ":demoCharge")

	if (chargeOid == 0) then
		printLuaError("DemolitionPack:detonate: no chargeId; destroying detonator")
		self:destroyDemoObject(pDetonator)
		return
	end

	local pCharge = getSceneObject(chargeOid)

	if (pCharge == nil) then
		printLuaError("DemolitionPack:detonate: charge missing; destroying detonator")
		self:destroyDemoObject(pDetonator)
		return
	end

	self:blast(pCharge, pPlayer)

	-- Detonate is one-shot -- destroy the detonator after messaging the charge
	-- (demolition_detonator.java:49-67).
	self:destroyDemoObject(pDetonator)
end

function DemolitionPack:page(pDetonator, pPlayer)
	if (pDetonator == nil or pPlayer == nil) then
		return
	end

	local detOid = SceneObject(pDetonator):getObjectID()
	local chargeOid = readData(detOid .. ":demoCharge")

	if (chargeOid == 0) then
		printLuaError("DemolitionPack:page: no chargeId; destroying detonator")
		self:destroyDemoObject(pDetonator)
		return
	end

	local pCharge = getSceneObject(chargeOid)

	if (pCharge == nil) then
		printLuaError("DemolitionPack:page: charge missing; destroying detonator")
		self:destroyDemoObject(pDetonator)
		return
	end

	-- Page is free -- leave the detonator alone (demolition_detonator.java:68-84).
	-- showFlyText file is bare "npc_landmines" with no @, matching warren.lua:489.
	-- Green is live's colors.GREEN. charge_page_text renders as "-- PING --".
	SceneObject(pCharge):showFlyText("npc_landmines", "charge_page_text", 0, 255, 0)
end

--------------------------------------------------------------------------------
-- Charge blast  --  live applyChargeEffects / verifyMine / getTargetsInBlastRadius
--------------------------------------------------------------------------------

function DemolitionPack:blast(pCharge, pPlayer)
	if (pCharge == nil or pPlayer == nil) then
		return
	end

	local chargeOid = SceneObject(pCharge):getObjectID()
	local tier = readData(chargeOid .. ":demoTier")
	local row = self.tiers[tier]

	-- live verifyMine (demolition_pack.java:43-59), relocated to the point of use
	-- because Core3 has no OnAttach for Lua.
	if (row == nil) then
		self:destroyDemoObject(pCharge)
		return
	end

	local targets = {}

	-- SUBSTITUTION B
	if (ValleyBattlefield ~= nil) then
		local candidates = ValleyBattlefield:getBlastCandidates()

		if (candidates ~= nil) then
			for i = 1, #candidates do
				local pTarget = getSceneObject(candidates[i])

				if (pTarget ~= nil and SceneObject(pCharge):isInRangeWithObject(pTarget, row.blastRadius)) then
					if (SceneObject(pTarget):isPlayerCreature() or SceneObject(pTarget):isAiAgent()) then
						if (not CreatureObject(pTarget):isDead() and not CreatureObject(pTarget):isIncapacitated()) then
							table.insert(targets, pTarget)
						end
					end
				end
			end
		end
	end

	local x = SceneObject(pCharge):getWorldPositionX()
	local z = SceneObject(pCharge):getWorldPositionZ()
	local y = SceneObject(pCharge):getWorldPositionY()

	-- Plays whether or not there are targets (live applyChargeEffects empty branch).
	-- SUBSTITUTION F: no scale argument.
	playClientEffectLoc(pCharge, row.effect, "mustafar", x, z, y, SceneObject(pCharge):getParentID())

	for i = 1, #targets do
		-- Fresh roll per target -- do not hoist out of the loop (live :97-126).
		local dmg = getRandomNumber(row.minDamage, row.maxDamage)
		-- SUBSTITUTION A: HAM pool 0 (health). destroy=false -- live damage() does
		-- not force a kill; the normal death path runs.
		CreatureObject(targets[i]):inflictDamage(pPlayer, 0, dmg, false)
	end

	self:destroyDemoObject(pCharge)
end
