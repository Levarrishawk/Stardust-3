#!/usr/bin/env python3
"""Generate Core3 collection-loot items/groups, creature attach data, and consume-use flow.

Usage:  build_collection_loot.py <json> [--scripts <path to bin/scripts>]

Reads a transcription of creatures.tab collectionRoll/collectionLoot plus
datatables/loot/loot_items/collectible/collection_loot.tab (loot.java:1545
addCollectionLoot). Writes loot/items/collections/<column>.lua,
loot/groups/collections/<column>.lua, screenplays/collections/collection_loot.lua,
include lines, a guarded CollectionLoot.attachLootItemComponent plus
setCustomObjectName(displayName) on the grant path, and objectMenuComponent on
unique-template object luas. Group weights follow loot.java:1572-1575 (cell
count, duplicates included) and sum to 10000000. The JSON itself is never
committed. CollectionRoll chances are NGE tuning (OPEN); creature-to-column
content is shipped. CollectionLoot.ENABLED defaults to false.
"""
from __future__ import print_function

import argparse
import json
import os
import re
import sys
from collections import OrderedDict


ITEM_USE_COMPONENT = "CollectionLootItemMenuComponent"
LOOT_CHANCE_SCALE = 100000  # collectionRoll percent -> Core3 lootChance (1% = 100000 of 10000000)
INNER_CHANCE = 10000000
TOTAL_WEIGHT = 10000000

STATIC_ROW = re.compile(r'\["([^"]+)"\]=\{([^}]+)\}')
DISPLAY_NAME = re.compile(r'displayName="((?:\\.|[^"\\])*)"')
ADD_TEMPLATE = re.compile(r'ObjectTemplates:addTemplate\s*\([^,]+,\s*"([^"]+)"\s*\)')
ADD_CREATURE = re.compile(r'addCreatureTemplate\s*\([^,]+,\s*"([^"]+)"\s*\)')
GRANT_OLD = """\tlocal pItem = giveIffItem(pPlayer, info.template, stackAmount)
	if pItem ~= nil then
		if CollectionLoot ~= nil and info.consumeLoot == true then
			CollectionLoot.attachLootItemComponent(pItem)
		end
		if info.slot ~= nil and info.slot ~= "" then
			-- screenplays/collections: writeStringData(oid .. ":collection.slot", slot)
			local oid = SceneObject(pItem):getObjectID()
			writeStringData(oid .. ":collection.slot", info.slot)
		end
	end"""
GRANT_NEW = """\tlocal pItem = giveIffItem(pPlayer, info.template, stackAmount)
	if pItem ~= nil then
		if CollectionLoot ~= nil and info.consumeLoot == true then
			CollectionLoot.attachLootItemComponent(pItem)
		end
		if info.displayName ~= nil and info.displayName ~= "" then
			-- OURS: Core3 has no master_item string_name; setCustomObjectName (LuaSceneObject.cpp:39)
			SceneObject(pItem):setCustomObjectName(info.displayName)
		end
		if info.slot ~= nil and info.slot ~= "" then
			-- OURS: Core3 has no per-object item_stats; writeStringData(oid .. ":collection.slot", slot)
			local oid = SceneObject(pItem):getObjectID()
			writeStringData(oid .. ":collection.slot", info.slot)
		end
	end"""


def lua_str(value):
    return '"' + (
        (value or "")
        .replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
    ) + '"'


def read_text(path):
    with open(path, encoding="utf-8", errors="replace") as handle:
        return handle.read()


def write_text(path, text, newline="\n"):
    parent = os.path.dirname(path)
    if parent and not os.path.isdir(parent):
        os.makedirs(parent)
    if not text.endswith(newline):
        text += newline
    with open(path, "w", encoding="utf-8", newline=newline) as handle:
        handle.write(text)


def detect_nl(text):
    return "\r\n" if "\r\n" in text else "\n"


def unescape_lua_str(value):
    out = []
    i = 0
    while i < len(value):
        if value[i] == "\\" and i + 1 < len(value):
            out.append(value[i + 1])
            i += 2
        else:
            out.append(value[i])
            i += 1
    return "".join(out)


def parse_static_items(text):
    out = OrderedDict()
    for match in STATIC_ROW.finditer(text):
        name = match.group(1)
        body = match.group(2)
        tmpl_m = re.search(r'template="([^"]*)"', body)
        slot_m = re.search(r'slot="([^"]*)"', body)
        dn_m = DISPLAY_NAME.search(body)
        out[name] = {
            "template": tmpl_m.group(1) if tmpl_m else "",
            "slot": slot_m.group(1) if slot_m else "",
            "display_name": unescape_lua_str(dn_m.group(1)) if dn_m else "",
            "in_fork": "inFork=true" in body,
            "consume_loot": "consumeLoot=true" in body,
        }
    return out


def normalize_iff(path):
    path = (path or "").replace("\\", "/")
    if path and not path.endswith(".iff"):
        path += ".iff"
    return path


def iff_to_lua_candidates(scripts_root, iff):
    iff = normalize_iff(iff)
    if iff.startswith("object/"):
        rel = iff[len("object/"):-4]
    elif iff.endswith(".iff"):
        rel = iff[:-4]
    else:
        rel = iff
    rel_lua = rel.replace("/", os.sep) + ".lua"
    return [
        os.path.join(scripts_root, "object", "custom_content", rel_lua),
        os.path.join(scripts_root, "object", rel_lua),
    ]


def resolve_object_lua(scripts_root, iff, object_map):
    for candidate in iff_to_lua_candidates(scripts_root, iff):
        if os.path.isfile(candidate):
            return candidate
    return object_map.get(normalize_iff(iff))


def scan_object_luas(object_root):
    mapping = {}
    for walk_root, _dirs, files in os.walk(object_root):
        for fn in files:
            if not fn.endswith(".lua"):
                continue
            path = os.path.join(walk_root, fn)
            text = read_text(path)
            for match in ADD_TEMPLATE.finditer(text):
                iff = normalize_iff(match.group(1))
                rel = os.path.relpath(path, object_root).replace("\\", "/")
                prefer_custom = "/custom_content/" in ("/" + rel)
                prev = mapping.get(iff)
                if prev is None:
                    mapping[iff] = path
                elif prefer_custom and "/custom_content/" not in prev.replace("\\", "/"):
                    mapping[iff] = path
    return mapping


def scan_creature_names(mobile_root):
    names = set()
    if not os.path.isdir(mobile_root):
        return names
    for walk_root, _dirs, files in os.walk(mobile_root):
        for fn in files:
            if not fn.endswith(".lua"):
                continue
            text = read_text(os.path.join(walk_root, fn))
            for match in ADD_CREATURE.finditer(text):
                names.add(match.group(1))
    return names


def unique_keep_order(items):
    seen = set()
    out = []
    for item in items:
        if item in seen:
            continue
        seen.add(item)
        out.append(item)
    return out


def equal_weights(count):
    if count <= 0:
        return []
    base = TOTAL_WEIGHT // count
    rem = TOTAL_WEIGHT - base * count
    return [base + (1 if i < rem else 0) for i in range(count)]


def cell_count_weights(unique_items, cells):
    """Weight each unique name by how many times it appears in cells. Sums to TOTAL_WEIGHT."""
    if not unique_items:
        return []
    counts = []
    for name in unique_items:
        n = 0
        for cell in cells:
            if cell == name:
                n += 1
        counts.append(n)
    total = sum(counts)
    if total <= 0:
        return equal_weights(len(unique_items))
    bases = [(TOTAL_WEIGHT * c) // total for c in counts]
    rem = TOTAL_WEIGHT - sum(bases)
    for i in range(rem):
        bases[i] += 1
    return bases


def name_ambiguous_rows(static, by_template):
    """Shared-template display names that map to more than one distinct slot."""
    ambiguous = []
    resolved_same_slot = []
    for template, names in sorted(by_template.items()):
        if len(names) <= 1:
            continue
        by_dn = OrderedDict()
        for name in names:
            dn = static[name].get("display_name") or ""
            by_dn.setdefault(dn, []).append(name)
        for dn, items in by_dn.items():
            if len(items) <= 1:
                continue
            rows = [(n, static[n].get("slot") or "") for n in items]
            slots = unique_keep_order([slot for _name, slot in rows])
            if len(slots) == 1:
                resolved_same_slot.append((template, dn, slots[0], rows))
            else:
                ambiguous.append((template, dn, rows))
    return ambiguous, resolved_same_slot


def grantable(info):
    return (
        info is not None
        and info.get("in_fork") is True
        and bool(info.get("template"))
    )


def consume_grantable(info):
    return grantable(info) and bool(info.get("slot")) and info.get("consume_loot") is True


def emit_loot_item(name, template, display_name):
    lines = [
        "-- SOURCED -- collection_loot.tab static item; template from CollectionStaticItems; customObjectName is master_item.tab string_name.",
        name + " = {",
        "	minimumLevel = 0,",
        "	maximumLevel = -1,",
        "	customObjectName = " + lua_str(display_name) + ",",
        "	directObjectTemplate = " + lua_str(template) + ",",
        "	craftingValues = {",
        "	},",
        "	customizationStringNames = {},",
        "	customizationValues = {}",
        "}",
        "",
        "addLootItemTemplate(" + lua_str(name) + ", " + name + ")",
        "",
    ]
    return "\n".join(lines)


def emit_loot_group(column, items, weights):
    lines = [
        "-- SOURCED -- collection_loot.tab column " + column + "; cell-count weights (loot.java:1572-1575 rand among cells, duplicates included).",
        column + " = {",
        "	description = \"\",",
        "	minimumLevel = 0,",
        "	maximumLevel = 0,",
        "	lootItems = {",
    ]
    for i, name in enumerate(items):
        comma = "," if i + 1 < len(items) else ""
        lines.append("		{itemTemplate = " + lua_str(name) + ", weight = " + str(weights[i]) + "}" + comma)
    lines.extend([
        "	}",
        "}",
        "",
        "addLootGroupTemplate(" + lua_str(column) + ", " + column + ")",
        "",
    ])
    return "\n".join(lines)


def emit_creature_row(rec):
    cols = ", ".join(lua_str(c) for c in rec["columns"])
    return (
        "		{name="
        + lua_str(rec["name"])
        + ", roll="
        + str(int(rec["roll"]))
        + ", columns={"
        + cols
        + "}},"
    )


def emit_snippets(in_fork):
    lines = [
        "--[[ OPEN: hand-merge into each creature's lootGroups when CollectionLoot.ENABLED",
        "     is ruled. Lua cannot amend a registered CreatureTemplate: creatures.lua",
        "     CreatureTemplates:addCreatureTemplate calls C++ addTemplate, and",
        "     CreatureTemplate.cpp:187 lootgroups.readObject copies the table at",
        "     registration. getCreatureTemplate looks up CreatureTemplates[crc], which",
        "     addCreatureTemplate never populates. lootChance is OPEN (NGE collectionRoll).",
        "     Engine: LootGroupCollectionEntry.h:39 reads lootChance;",
        "     LootManagerImplementation.cpp:711 rolls System::random(10000000), so 1% is",
        "     100000 (collectionRoll * 100000), not per-mille. Inner chance is the group's",
        "     share of that entry (LootGroupEntry.h:30). One entry per column as specified;",
        "     SOE instead picks ONE column after the roll (loot.java:1569-1571).",
        "",
    ]
    for rec in in_fork:
        lines.append(rec["name"] + ":")
        seen = set()
        for col in rec["columns"]:
            if col in seen:
                continue
            seen.add(col)
            loot_chance = int(rec["roll"]) * LOOT_CHANCE_SCALE
            lines.append("	{")
            lines.append("		groups = {")
            lines.append("			{group = " + lua_str(col) + ", chance = " + str(INNER_CHANCE) + "}")
            lines.append("		},")
            lines.append("		lootChance = " + str(loot_chance))
            lines.append("	},")
        lines.append("")
    lines.append("]]")
    return "\n".join(lines)


def emit_open_creatures(out_fork):
    lines = [
        "-- OPEN: NGE-only / no mobile template of this name in the fork ("
        + str(len(out_fork))
        + " rows).",
    ]
    for rec in out_fork:
        cols = ",".join(rec["columns"])
        lines.append("--   " + rec["name"] + " roll=" + str(int(rec["roll"])) + " columns=" + cols)
    return "\n".join(lines)


SCREENPLAY_BODY = r'''
registerScreenPlay("CollectionLoot", true)

function CollectionLoot.attachLootItemComponent(pItem)
	if (pItem == nil) then
		return
	end

	-- OURS: Core3 ObjectMenuComponent instead of consume_loot.java on the static-item script.
	SceneObject(pItem):setObjectMenuComponent("CollectionLootItemMenuComponent")
end

local function buildTemplateMap()
	local map = {}

	if (CollectionStaticItems == nil) then
		return map
	end

	for name, info in pairs(CollectionStaticItems) do
		if (info ~= nil and info.template ~= nil and info.template ~= "") then
			local template = info.template

			if (string.sub(template, -4) ~= ".iff") then
				template = template .. ".iff"
			end

			if (map[template] == nil) then
				map[template] = {}
			end

			local list = map[template]
			list[#list + 1] = {name = name, slot = info.slot or "", displayName = info.displayName or ""}
		end
	end

	return map
end

CollectionLoot.templateMap = buildTemplateMap()

function CollectionLoot:start()
	self:printAmbiguousTemplates()

	if (not self.ENABLED) then
		return
	end

	print("CollectionLoot: ENABLED is true but Lua cannot amend registered creature lootGroups. creatures.lua CreatureTemplates:addCreatureTemplate calls C++ addTemplate; CreatureTemplate.cpp:187 copies lootGroups at registration; getCreatureTemplate looks up CreatureTemplates[crc] which is never populated. OPEN: merge the lootGroups snippets in this file by hand.")
end

function CollectionLoot:printAmbiguousTemplates()
	local names = {}

	for template, list in pairs(self.templateMap) do
		if (list ~= nil and #list > 1) then
			local byName = {}

			for i = 1, #list do
				local dn = list[i].displayName or ""

				if (byName[dn] == nil) then
					byName[dn] = {}
				end

				local bucket = byName[dn]
				bucket[#bucket + 1] = list[i]
			end

			for dn, rows in pairs(byName) do
				if (#rows > 1) then
					local slot = rows[1].slot or ""
					local same = true

					for j = 2, #rows do
						if ((rows[j].slot or "") ~= slot) then
							same = false
							break
						end
					end

					if (not same) then
						names[#names + 1] = {template = template, displayName = dn, rows = rows}
					end
				end
			end
		end
	end

	table.sort(names, function(a, b)
		if (a.template == b.template) then
			return a.displayName < b.displayName
		end

		return a.template < b.template
	end)

	for i = 1, #names do
		local rec = names[i]
		local parts = {}

		for j = 1, #rec.rows do
			parts[#parts + 1] = rec.rows[j].name .. "=" .. (rec.rows[j].slot or "")
		end

		print("CollectionLoot: OPEN ambiguous name " .. rec.displayName .. " on " .. rec.template .. " (" .. table.concat(parts, ", ") .. ")")
	end
end

function CollectionLoot:slotOf(pItem)
	if (pItem == nil) then
		return nil
	end

	-- OURS: Core3 has no per-object item_stats; grant path stores the slot in shared memory.
	local stored = readStringData(SceneObject(pItem):getObjectID() .. ":collection.slot")

	if (stored ~= nil and stored ~= "") then
		return stored
	end

	local template = SceneObject(pItem):getTemplateObjectPath()
	local list = self.templateMap[template]

	if (list == nil or #list == 0) then
		return nil
	end

	-- OURS: match SceneObject:getCustomObjectName() (LuaSceneObject.cpp:74) to
	-- CollectionStaticItems.displayName among rows sharing this template.
	local customName = SceneObject(pItem):getCustomObjectName()

	if (customName ~= nil and customName ~= "") then
		local matches = {}

		for i = 1, #list do
			if (list[i].displayName == customName) then
				matches[#matches + 1] = list[i]
			end
		end

		if (#matches == 1) then
			local slot = matches[1].slot

			if (slot == nil or slot == "") then
				return nil
			end

			return slot
		end

		if (#matches > 1) then
			local slot = matches[1].slot or ""
			local same = true

			for i = 2, #matches do
				if ((matches[i].slot or "") ~= slot) then
					same = false
					break
				end
			end

			if (same and slot ~= "") then
				return slot
			end

			return nil
		end
	end

	if (#list == 1) then
		local slot = list[1].slot

		if (slot == nil or slot == "") then
			return nil
		end

		return slot
	end

	return nil
end

function CollectionLoot:parseSlotPairs(full)
	local out = {}

	if (full == nil or full == "") then
		return out
	end

	for part in string.gmatch(full, "[^|]+") do
		local parts = {}

		for piece in string.gmatch(part, "[^:]+") do
			parts[#parts + 1] = piece
		end

		if (#parts == 1) then
			out[#out + 1] = {collection = nil, slot = parts[1]}
		else
			local j = 1

			while (j < #parts) do
				out[#out + 1] = {collection = parts[j], slot = parts[j + 1]}
				j = j + 2
			end
		end
	end

	return out
end

function CollectionLoot:availablePairs(pPlayer, slotPairs)
	local avail = {}

	for i = 1, #slotPairs do
		local pair = slotPairs[i]

		if (pair.slot ~= nil and pair.slot ~= "") then
			local finishedCol = pair.collection ~= nil and CollectionManager.hasCompletedCollection(pPlayer, pair.collection)
			local haveSlot = CollectionManager.hasCompletedCollectionSlot(pPlayer, pair.slot)
			local prereq = CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, pair.slot)

			if ((not finishedCol) and (not haveSlot) and prereq) then
				avail[#avail + 1] = pair
			end
		end
	end

	return avail
end

function CollectionLoot:sendClosedMessage(pPlayer, slotPairs)
	if (#slotPairs == 1) then
		local pair = slotPairs[1]

		if (pair.collection ~= nil and CollectionManager.hasCompletedCollection(pPlayer, pair.collection)) then
			CreatureObject(pPlayer):sendSystemMessage("@collection:already_finished_collection")
			return
		end

		if (CollectionManager.hasCompletedCollectionSlot(pPlayer, pair.slot)) then
			CreatureObject(pPlayer):sendSystemMessage("@collection:already_have_slot")
			return
		end
	end

	CreatureObject(pPlayer):sendSystemMessage("@collection:need_to_activate_collection")
end

function CollectionLoot:onUse(pPlayer, pItem)
	if (pPlayer == nil or pItem == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	if (SceneObject(pItem):isASubChildOf(pPlayer) == false) then
		return
	end

	local full = self:slotOf(pItem)

	if (full == nil) then
		return
	end

	local slotPairs = self:parseSlotPairs(full)

	if (#slotPairs == 0) then
		return
	end

	local avail = self:availablePairs(pPlayer, slotPairs)

	if (#avail == 0) then
		self:sendClosedMessage(pPlayer, slotPairs)
		return
	end

	if (#avail == 1) then
		self:confirmConsume(pPlayer, pItem, avail[1])
		return
	end

	self:showCollectionList(pPlayer, pItem, avail)
end

function CollectionLoot:confirmConsume(pPlayer, pItem, pair)
	local playerID = SceneObject(pPlayer):getObjectID()
	writeData(playerID .. ":CollectionLoot:oid", SceneObject(pItem):getObjectID())
	writeStringData(playerID .. ":CollectionLoot:slot", pair.slot)
	writeStringData(playerID .. ":CollectionLoot:collection", pair.collection or "")

	local sui = SuiMessageBox.new("CollectionLoot", "confirmCallback")
	sui.setTitle("@collection:consume_item_title")
	sui.setPrompt("@collection:consume_item_prompt")
	sui.setTargetNetworkId(SceneObject(pItem):getObjectID())
	sui.sendTo(pPlayer)
end

function CollectionLoot:confirmCallback(pPlayer, pSui, eventIndex)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	self:finishConsume(pPlayer)
end

function CollectionLoot:showCollectionList(pPlayer, pItem, avail)
	local playerID = SceneObject(pPlayer):getObjectID()
	writeData(playerID .. ":CollectionLoot:oid", SceneObject(pItem):getObjectID())

	local sui = SuiListBox.new("CollectionLoot", "listCallback")
	sui.setTitle("@collection:collection_list_title")
	sui.setPrompt("@collection:collection_list_prompt")
	sui.setTargetNetworkId(SceneObject(pItem):getObjectID())
	sui.setOkButtonText("@ui:ok")

	for i = 1, #avail do
		local label = avail[i].collection

		if (label == nil or label == "") then
			label = avail[i].slot
		end

		sui.add("@collection:" .. label, avail[i].slot)
	end

	sui.sendTo(pPlayer)
end

function CollectionLoot:listCallback(pPlayer, pSui, eventIndex, args)
	if (pPlayer == nil or eventIndex == 1) then
		return
	end

	local selected = ""
	local row = tonumber(args)

	if (row ~= nil) then
		local pPageData = LuaSuiBoxPage(pSui):getSuiPageData()

		if (pPageData ~= nil) then
			selected = LuaSuiPageData(pPageData):getStoredData(tostring(row)) or ""
		end
	end

	if (selected == "") then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	writeStringData(playerID .. ":CollectionLoot:slot", selected)
	self:finishConsume(pPlayer)
end

function CollectionLoot:finishConsume(pPlayer)
	if (pPlayer == nil or not SceneObject(pPlayer):isPlayerCreature()) then
		return
	end

	local playerID = SceneObject(pPlayer):getObjectID()
	local oid = readData(playerID .. ":CollectionLoot:oid")
	local slotName = readStringData(playerID .. ":CollectionLoot:slot")
	local pItem = getSceneObject(oid)

	if (pItem == nil or slotName == nil or slotName == "") then
		return
	end

	if (SceneObject(pItem):isASubChildOf(pPlayer) == false) then
		return
	end

	if (not CollectionManager.hasCompletedCollectionSlotPrereq(pPlayer, slotName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:need_to_activate_collection")
		return
	end

	local slotInfo = CollectionManager.getCollectionSlotInfo(slotName)

	if (slotInfo ~= nil and CollectionManager.hasCompletedCollection(pPlayer, slotInfo[3])) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:already_finished_collection")
		return
	end

	if (CollectionManager.hasCompletedCollectionSlot(pPlayer, slotName)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:already_have_slot")
		return
	end

	if (not CollectionManager.modifyCollectionSlotValue(pPlayer, slotName, 1)) then
		CreatureObject(pPlayer):sendSystemMessage("@collection:report_consume_item_fail")
		return
	end

	SceneObject(pItem):destroyObjectFromWorld()
	SceneObject(pItem):destroyObjectFromDatabase()
end

CollectionLootItemMenuComponent = { }

function CollectionLootItemMenuComponent:fillObjectMenuResponse(pSceneObject, pMenuResponse, pPlayer)
	if (pSceneObject == nil or pPlayer == nil) then
		return
	end

	if (SceneObject(pSceneObject):isASubChildOf(pPlayer) == false) then
		return
	end

	-- OURS: ITEM_USE radial (20) is this fork's Lua menu; java consume_loot.java:28 uses SERVER_MENU3.
	local menuResponse = LuaObjectMenuResponse(pMenuResponse)
	menuResponse:addRadialMenuItem(20, 3, "@collection:consume_item")
end

function CollectionLootItemMenuComponent:handleObjectMenuSelect(pSceneObject, pPlayer, selectedID)
	if (pPlayer == nil or pSceneObject == nil or selectedID ~= 20) then
		return 0
	end

	CollectionLoot:onUse(pPlayer, pSceneObject)
	return 0
end
'''


def emit_screenplay(in_fork, out_fork, open_items, ambiguous, resolved_same_slot):
    header = [
        "-- Collection creature loot drops + consume-loot Use (ruling 2026-09-05:",
        "-- \"the items across the galaxy, everything\").",
        "-- SOURCED drop: loot.java:1545 addCollectionLoot -- on a kill, rand(1,100) <=",
        "-- creatures.tab collectionRoll; pick ONE column at random from collectionLoot;",
        "-- pick ONE item at random from that column of collection_loot.tab; create the",
        "-- static item in the corpse inventory. Chances are NGE tuning -> OPEN.",
        "-- Which creature drops which collection is content and is listed below.",
        "-- SOURCED use: consume_loot.java:23 OnObjectMenuRequest ITEM_USE",
        "-- @collection:consume_item; :32 OnObjectMenuSelect: need_to_activate_collection,",
        "-- already_have_slot / already_finished_collection / modifyCollectionSlotValue",
        "-- then destroy, or report_consume_item_fail. :216 multi-slot `a|b|c` uses",
        "-- collection_list_prompt / collection_list_title.",
        "-- OURS (Core3 translation): CollectionLootItemMenuComponent implements Use",
        "-- (ITEM_USE 20; SharedTangibleObjectTemplate.lua:114 / SharedObjectTemplate.cpp:169).",
        "-- OURS: CollectionLoot.ENABLED = false until collectionRoll chances are ruled.",
        "-- OURS: grant path records the slot as writeStringData(oid .. \":collection.slot\")",
        "-- (Core3 has no per-object item_stats).",
        "-- OURS: after that stored record, slot resolution matches",
        "-- SceneObject:getCustomObjectName() (LuaSceneObject.cpp:74) to",
        "-- CollectionStaticItems.displayName among rows sharing the template; if the",
        "-- name is unique or every duplicate maps to the same slot, use it; else the",
        "-- unique-template reverse map. Loot customObjectName and grant",
        "-- setCustomObjectName (LuaSceneObject.cpp:39) are SOURCED master_item.tab",
        "-- string_name.",
        "-- lootChance scale: LootGroupCollectionEntry.h:39 + LootManagerImplementation.cpp:711",
        "-- System::random(10000000). SharedTangibleObjectTemplate.lua:114 objectMenuComponent;",
        "-- SharedObjectTemplate.cpp:169 parses it.",
        "",
        "CollectionLoot = ScreenPlay:new {",
        "	numberOfActs = 1,",
        "	screenplayName = \"CollectionLoot\",",
        "	ENABLED = false, -- OURS: collectionRoll chances held until ruled (NGE tuning OPEN)",
        "	creatures = {",
    ]
    for rec in in_fork:
        header.append(emit_creature_row(rec))
    header.append("	},")
    header.append("}")
    header.append("")
    header.append(emit_open_creatures(out_fork))
    header.append("")
    if open_items:
        header.append("-- OPEN: static items in used columns that are not consume-grantable")
        header.append("-- (empty slot / consumeLoot=false). " + str(len(open_items)) + " items.")
        for name in open_items:
            header.append("--   " + name)
        header.append("")
    if resolved_same_slot:
        header.append("-- Duplicate display names that map to the SAME slot (resolved).")
        for template, dn, slot, rows in resolved_same_slot:
            names = ",".join(n for n, _s in rows)
            header.append("--   " + template + " name=" + dn + " slot=" + (slot or "(empty)") + " " + names)
        header.append("")
    if ambiguous:
        header.append("-- OPEN: duplicate display names on a shared template that map to different slots.")
        for template, dn, rows in ambiguous:
            parts = ",".join(n + "=" + slot for n, slot in rows)
            header.append("--   " + template + " name=" + dn + " " + parts)
        header.append("")
    header.append(emit_snippets(in_fork))
    header.append(SCREENPLAY_BODY)
    return "\n".join(header)


def ensure_includes(path, rel_includes, header="-- Collections"):
    text = read_text(path)
    nl = detect_nl(text)
    missing = [inc for inc in rel_includes if 'includeFile("' + inc + '")' not in text]
    if not missing:
        return False
    block_lines = [header]
    for inc in missing:
        block_lines.append('includeFile("' + inc + '")')
    block = nl.join(block_lines) + nl
    if header == "-- Collections" and "-- Collections" in text and path.endswith("screenplays.lua"):
        needle = 'includeFile("collections/collection_objects.lua")'
        if needle in text and 'includeFile("collections/collection_loot.lua")' not in text:
            text = text.replace(
                needle,
                needle + nl + 'includeFile("collections/collection_loot.lua")',
                1,
            )
            write_text(path, text, newline="")
            return True
    if not text.endswith(nl):
        text += nl
    text += nl + block
    write_text(path, text, newline="")
    return True


def patch_grant_path(path):
    text = read_text(path)
    if GRANT_NEW in text:
        return False
    if GRANT_OLD not in text:
        raise SystemExit("grantRewardItem attach site not found in " + path)
    text = text.replace(GRANT_OLD, GRANT_NEW, 1)
    write_text(path, text, newline="")
    return True


def patch_object_menu(path):
    text = read_text(path)
    nl = detect_nl(text)
    if 'objectMenuComponent = "' + ITEM_USE_COMPONENT + '"' in text:
        return "already"
    if "objectMenuComponent" in text:
        return "other"
    match = re.search(r":new\s*\{", text)
    if match is None:
        return "no-new"
    insert = match.end()
    text = text[:insert] + nl + "	objectMenuComponent = \"" + ITEM_USE_COMPONENT + "\"," + text[insert:]
    write_text(path, text, newline="")
    return "patched"


def load_json(path):
    with open(path, encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise SystemExit("JSON root must be an object")
    creatures = data.get("creatures")
    columns = data.get("columns")
    if not isinstance(creatures, list) or not isinstance(columns, dict):
        raise SystemExit("JSON needs creatures[] and columns{}")
    return creatures, columns


def main():
    parser = argparse.ArgumentParser(
        usage="build_collection_loot.py <json> [--scripts DIR]",
        description="Generate collection loot items/groups and consume-use flow",
    )
    parser.add_argument("json", help="path to collection-loot JSON (required; never committed)")
    parser.add_argument(
        "--scripts",
        default=os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "bin", "scripts")),
        help="bin/scripts output root",
    )
    args = parser.parse_args()

    if not os.path.isfile(args.json):
        raise SystemExit("missing " + args.json)

    creatures, columns = load_json(args.json)
    scripts = args.scripts
    static_path = os.path.join(scripts, "managers", "collections", "collection_static_items.lua")
    if not os.path.isfile(static_path):
        raise SystemExit("missing " + static_path)

    static = parse_static_items(read_text(static_path))
    creature_names = scan_creature_names(os.path.join(scripts, "mobile"))
    object_map = scan_object_luas(os.path.join(scripts, "object"))

    for rec in creatures:
        rec["columns"] = [c for c in rec.get("columns") or [] if c]
        rec["in_fork"] = rec.get("name") in creature_names
        rec["roll"] = int(rec.get("roll") or 0)

    creatures.sort(key=lambda r: r["name"])
    in_fork = [r for r in creatures if r["in_fork"]]
    out_fork = [r for r in creatures if not r["in_fork"]]

    used_columns = OrderedDict()
    for name in sorted(columns.keys()):
        used_columns[name] = list(columns[name] or [])

    all_items = unique_keep_order([item for items in used_columns.values() for item in items])
    open_items = [n for n in all_items if not consume_grantable(static.get(n))]
    loot_items = [n for n in all_items if grantable(static.get(n))]
    skipped = [n for n in all_items if not grantable(static.get(n))]

    items_dir = os.path.join(scripts, "loot", "items", "collections")
    groups_dir = os.path.join(scripts, "loot", "groups", "collections")
    if not os.path.isdir(items_dir):
        os.makedirs(items_dir)
    if not os.path.isdir(groups_dir):
        os.makedirs(groups_dir)

    emitted_items = set()
    item_includes = []
    group_includes = []
    rows_per_column = OrderedDict()

    for column, cells in used_columns.items():
        unique_items = unique_keep_order(cells)
        grant_in_col = [n for n in unique_items if grantable(static.get(n))]
        open_in_col = [n for n in unique_items if n not in grant_in_col]
        rows_per_column[column] = {
            "cells": len(cells),
            "unique": len(unique_items),
            "grantable": len(grant_in_col),
            "open": open_in_col,
            "weight_sum": 0,
            "weights": [],
        }

        item_chunks = []
        if open_in_col:
            item_chunks.append("-- OPEN: not grantable in CollectionStaticItems: " + ", ".join(open_in_col))
            item_chunks.append("")
        for name in grant_in_col:
            if name in emitted_items:
                continue
            emitted_items.add(name)
            item_chunks.append(emit_loot_item(
                name,
                normalize_iff(static[name]["template"]),
                static[name].get("display_name") or "",
            ))
        if item_chunks:
            write_text(os.path.join(items_dir, column + ".lua"), "\n".join(item_chunks).rstrip() + "\n")
            item_includes.append("items/collections/" + column + ".lua")

        if grant_in_col:
            weights = cell_count_weights(grant_in_col, cells)
            rows_per_column[column]["weight_sum"] = sum(weights)
            rows_per_column[column]["weights"] = list(zip(grant_in_col, weights))
            write_text(os.path.join(groups_dir, column + ".lua"), emit_loot_group(column, grant_in_col, weights))
            group_includes.append("groups/collections/" + column + ".lua")

    # Reverse-map uniqueness across the whole bridge (consume-use, not just loot columns).
    by_template = OrderedDict()
    for name, info in static.items():
        template = normalize_iff(info.get("template"))
        if not template:
            continue
        by_template.setdefault(template, []).append(name)

    loot_name_set = set(all_items)
    unique_slotted = []
    for template, names in sorted(by_template.items()):
        loot_hit = [n for n in names if n in loot_name_set]
        if not loot_hit:
            continue
        # A template shared by several static items resolves its slot by the shipped display name at
        # use time (OURS), so it takes the menu component too.
        usable = [n for n in names if consume_grantable(static[n])]
        if not usable:
            continue
        unique_slotted.append((template, usable[0]))

    ambiguous, resolved_same_slot = name_ambiguous_rows(static, by_template)

    patched = []
    skipped_object = []
    for template, name in unique_slotted:
        lua_path = resolve_object_lua(scripts, template, object_map)
        if lua_path is None:
            skipped_object.append((template, name, "no-object-lua"))
            continue
        rel = os.path.relpath(lua_path, os.path.join(scripts, "object")).replace("\\", "/")
        result = patch_object_menu(lua_path)
        if result == "patched" or result == "already":
            patched.append((rel, name, template, result))
        else:
            skipped_object.append((rel, name, result))

    ensure_includes(os.path.join(scripts, "loot", "items.lua"), item_includes)
    ensure_includes(os.path.join(scripts, "loot", "groups.lua"), group_includes)
    ensure_includes(
        os.path.join(scripts, "screenplays", "screenplays.lua"),
        ["collections/collection_loot.lua"],
    )
    patch_grant_path(os.path.join(scripts, "managers", "collections", "collection_manager.lua"))

    screenplay = emit_screenplay(in_fork, out_fork, open_items, ambiguous, resolved_same_slot)
    write_text(os.path.join(scripts, "screenplays", "collections", "collection_loot.lua"), screenplay)

    print("creatures", len(creatures), "in_fork", len(in_fork), "open", len(out_fork))
    print("columns", len(used_columns), "distinct_items", len(all_items), "loot_items", len(emitted_items), "open_items", len(open_items), "skipped", len(skipped))
    print("unique_slotted_templates", len(unique_slotted), "object_menu_edits", len(patched), "ambiguous_names", len(ambiguous), "resolved_same_slot", len(resolved_same_slot))
    for column, stats in rows_per_column.items():
        extra = ""
        if stats["open"]:
            extra = " OPEN:" + ",".join(stats["open"])
        print("column", column, "cells", stats["cells"], "unique", stats["unique"], "grantable", stats["grantable"], "weight_sum", stats["weight_sum"], extra)
        if stats["cells"] != stats["unique"] and stats["weights"]:
            for name, weight in stats["weights"]:
                print("  weight", name, weight)
    print("USAGE: build_collection_loot.py <json> [--scripts DIR]")
    if resolved_same_slot:
        print("resolved_same_slot:")
        for template, dn, slot, rows in resolved_same_slot:
            print(" ", template, "name=" + dn, "slot=" + (slot or "(empty)"), ",".join(n for n, _s in rows))
    if ambiguous:
        print("ambiguous_names:")
        for template, dn, rows in ambiguous:
            print(" ", template, "name=" + dn, ",".join(n + "=" + slot for n, slot in rows))
    print("object_menu:")
    for row in patched:
        print(" ", row[2], "->", row[0], row[3], row[1])
    if skipped_object:
        print("object_menu_skipped:")
        for row in skipped_object:
            print(" ", row)
    if skipped:
        print("not_in_bridge:")
        for name in skipped:
            print(" ", name)


if __name__ == "__main__":
    main()
