#!/usr/bin/env python3
"""Fill Core3 draft-schematic lua from shipped server tpf for collection loot schematics.

Usage:  build_loot_schematics.py <tpf-tree> <loot-schematics.json> <schematic-targets.json>
        [--scripts <path to bin/scripts>]

<tpf-tree> is the shipped object tree that contains draft_schematic/*.tpf
(no default). loot-schematics.json and schematic-targets.json are the maintainer's
measurements (no default). Writes the 34 drafts whose crafted target is in
the fork or has a client file; leaves the 25 client-absent drafts unregistered.
"""
from __future__ import print_function

import argparse
import json
import os
import re
import sys

# CraftingType (tpf `category`) -> craftingToolTab. Same bits as
# DraftSchematicObjectTemplate.h:22-45 and base_class.java:14278-14301
# (CT_weapon = 0x1 ... CT_space = 0x20000, CT_misc = 0x80000).
CRAFTING_TAB = {
    "CT_weapon": 1,
    "CT_armor": 2,
    "CT_food": 4,
    "CT_clothing": 8,
    "CT_vehicle": 16,
    "CT_droid": 32,
    "CT_chemical": 64,
    "CT_plantBreeding": 128,
    "CT_animalBreeding": 256,
    "CT_furniture": 512,
    "CT_installation": 1024,
    "CT_lightsaber": 2048,
    "CT_genericItem": 4096,
    "CT_genetics": 8192,
    "CT_mandalorianTailor": 16384,
    "CT_mandalorianArmorsmith": 32768,
    "CT_mandalorianDroidEngineer": 65536,
    "CT_space": 131072,
    "CT_reverseEngineering": 262144,
    "CT_misc": 524288,
    "CT_spaceComponent": 1048576,
    "CT_mission": 2147483648,
}

# xpPoints.type -> Core3 xpType string (xp.java:42-61 names).
XP_TYPE = {
    "XP_crafting": "crafting_general",
    "XP_craftingClothing": "crafting_clothing_general",
    "XP_craftingClothingArmor": "crafting_clothing_armor",
    "XP_craftingDroid": "crafting_droid_general",
    "XP_craftingFood": "crafting_food_general",
    "XP_craftingMedicine": "crafting_medical_general",
    "XP_craftingStructure": "crafting_structure_general",
    "XP_craftingWeapons": "crafting_weapons_general",
    "XP_craftingWeaponsMelee": "crafting_weapons_melee",
    "XP_craftingWeaponsRanged": "crafting_weapons_ranged",
    "XP_craftingWeaponsMunition": "crafting_weapons_munition",
    "XP_craftingScout": "scout",
    "XP_craftingCreature": "crafting_bio_engineer_creature",
    "XP_craftingTissue": "crafting_bio_engineer_tissue",
    "XP_jediGeneral": "jedi_general",
    "XP_dancing": "dancing",
    "XP_music": "music",
}

# draft_schematic.java:14-21 IngredientType -> DraftSlot.h:29-34 when
# the slot is required. Optional IT_template / IT_item -> 3
# (OPTIONALIDENTICALSLOT); optional IT_templateGeneric -> 4.
IT_TO_SLOT = {
    "IT_none": 0,
    "IT_item": 1,
    "IT_template": 1,
    "IT_resourceType": 0,
    "IT_resourceClass": 0,
    "IT_templateGeneric": 2,
    "IT_schematic": 1,
    "IT_schematicGeneric": 2,
}
IT_OPTIONAL = {
    "IT_item": 3,
    "IT_template": 3,
    "IT_templateGeneric": 4,
    "IT_schematic": 3,
    "IT_schematicGeneric": 4,
}

# OURS: NGE skillCommands is typically ["unskilled"] (not Pre-CU assembly
# skills). Map CraftingType to the fork's profession skills.
SKILLS_FOR_TAB = {
    "CT_weapon": ("weapon_assembly", "weapon_experimentation", "weapon_customization"),
    "CT_armor": ("armor_assembly", "armor_experimentation", "armor_customization"),
    "CT_food": ("food_assembly", "food_experimentation", "food_customization"),
    "CT_clothing": ("clothing_assembly", "clothing_experimentation", "clothing_customization"),
    "CT_droid": ("droid_assembly", "droid_experimentation", "droid_customization"),
    "CT_chemical": ("medicine_assembly", "medicine_experimentation", "medicine_customization"),
    "CT_furniture": ("structure_assembly", "structure_experimentation", "structure_customization"),
    "CT_installation": ("structure_assembly", "structure_experimentation", "structure_customization"),
    "CT_lightsaber": ("jedi_saber_assembly", "jedi_saber_experimentation", "jedi_customization"),
    "CT_genericItem": ("general_assembly", "general_experimentation", "clothing_customization"),
    "CT_misc": ("general_assembly", "general_experimentation", "clothing_customization"),
    "CT_space": ("chassis_assembly", "chassis_experimentation", "medicine_customization"),
    "CT_vehicle": ("general_assembly", "general_experimentation", "clothing_customization"),
}

OURS_FIELDS = [
    "templateType = DRAFTSCHEMATIC (fork lua; tpf has no equivalent)",
    "customObjectName display text (OURS title-case of the crafted object's shipped objectName id; STF not in the tpf tree)",
    "customizationOptions / customizationStringNames / customizationDefaults = {} (fork lua; tpf has no customization lists on these drafts)",
    "additionalTemplates = {} (fork lua; tpf has no additionalTemplates)",
    "contribution = 100 per slot (fork lua; tpf Ingredient has no contribution)",
    "assemblySkill / experimentingSkill / customizationSkill when skillCommands is [unskilled] (NGE use-skill, not Pre-CU assembly; mapped from CraftingType)",
    "ingredientSlotType optional encoding (DraftSlot.h OPTIONALIDENTICALSLOT=3 / OPTIONALMIXEDSLOT=4; tpf uses a separate optional flag)",
    "resourceTypes shared_ iff rewrite for IT_template paths (fork lua convention; tpf stores the non-shared ingredient path)",
]

ADD_TEMPLATE = re.compile(r'ObjectTemplates:addTemplate\s*\(\s*([A-Za-z0-9_]+)\s*,\s*"([^"]+)"\s*\)')
NEW_HEAD = re.compile(r'^(.*?:new\s*\{)', re.DOTALL)
AVATAR_SHARED = """{shared} = SharedTangibleObjectTemplate:new {{
	clientTemplateFileName = "{client}"
}}

ObjectTemplates:addClientTemplate({shared}, "{client}")
"""
AVATAR_DERIVED = """{derived} = {shared}:new {{

}}
ObjectTemplates:addTemplate({derived}, "{iff}")
"""


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


def iff_to_shared(path):
    path = (path or "").replace("\\", "/")
    if not path.endswith(".iff") or path.startswith("shared_"):
        return path
    if "/shared_" in path:
        return path
    dirname, name = path.rsplit("/", 1)
    return dirname + "/shared_" + name


def to_shared_ingredient(path):
    path = (path or "").replace("\\", "/")
    if path.startswith("object/") and path.endswith(".iff"):
        return iff_to_shared(path)
    return path


def title_from_id(name):
    name = (name or "").strip()
    if name.endswith("_n") or name.endswith("_d"):
        name = name[:-2]
    parts = [p for p in re.split(r"[_\s]+", name) if p]
    return " ".join(p[:1].upper() + p[1:] for p in parts) if parts else name


def object_var_from_iff(iff, shared=False):
    rel = iff.replace("\\", "/")
    if rel.endswith(".iff"):
        rel = rel[:-4]
    if rel.startswith("object/"):
        rel = rel[len("object/"):]
    parts = rel.split("/")
    if shared and parts:
        parts[-1] = "shared_" + parts[-1]
    return "object_" + "_".join(parts)


def strip_comments(text):
    out = []
    i = 0
    n = len(text)
    in_str = False
    while i < n:
        ch = text[i]
        if in_str:
            out.append(ch)
            if ch == "\\" and i + 1 < n:
                out.append(text[i + 1])
                i += 2
                continue
            if ch == '"':
                in_str = False
            i += 1
            continue
        if ch == '"':
            in_str = True
            out.append(ch)
            i += 1
            continue
        if ch == "/" and i + 1 < n and text[i + 1] == "/":
            while i < n and text[i] not in "\n\r":
                i += 1
            continue
        out.append(ch)
        i += 1
    return "".join(out)


class Parser(object):
    def __init__(self, text):
        self.text = strip_comments(text)
        self.i = 0
        self.n = len(self.text)

    def skip(self):
        text = self.text
        i = self.i
        n = self.n
        while i < n and text[i] in " \t\r\n,":
            i += 1
        self.i = i

    def peek(self):
        self.skip()
        return self.text[self.i] if self.i < self.n else ""

    def parse_string(self):
        self.skip()
        if self.i >= self.n or self.text[self.i] != '"':
            raise ValueError("expected string at %d" % self.i)
        self.i += 1
        out = []
        text = self.text
        while self.i < self.n:
            ch = text[self.i]
            if ch == "\\" and self.i + 1 < self.n:
                out.append(text[self.i + 1])
                self.i += 2
                continue
            if ch == '"':
                self.i += 1
                break
            out.append(ch)
            self.i += 1
        return "".join(out)

    def parse_ident(self):
        self.skip()
        m = re.match(r"[A-Za-z_][A-Za-z0-9_]*", self.text[self.i:])
        if not m:
            raise ValueError("expected ident at %d" % self.i)
        self.i += m.end()
        return m.group(0)

    def parse_key(self):
        self.skip()
        if self.peek() == '"':
            return self.parse_string()
        return self.parse_ident()

    def parse_number(self):
        self.skip()
        m = re.match(r"-?\d+(?:\.\d+)?", self.text[self.i:])
        if not m:
            raise ValueError("expected number at %d" % self.i)
        self.i += m.end()
        raw = m.group(0)
        if self.text[self.i:self.i + 2] == "..":
            self.i += 2
            m2 = re.match(r"-?\d+(?:\.\d+)?", self.text[self.i:])
            if not m2:
                raise ValueError("expected range end at %d" % self.i)
            self.i += m2.end()
            lo = float(raw) if "." in raw else int(raw)
            return lo
        if "." in raw:
            return float(raw)
        return int(raw)

    def parse_string_id_or_string(self):
        first = self.parse_string()
        self.skip()
        if self.peek() == '"':
            second = self.parse_string()
            return {"file": first, "id": second}
        return first

    def looks_like_struct(self):
        save = self.i
        self.skip()
        if self.i >= self.n:
            self.i = save
            return False
        if self.text[self.i] == "[":
            self.i = save
            return False
        if self.text[self.i] == '"':
            try:
                self.parse_string()
                self.skip()
                ok = self.peek() == "="
            except ValueError:
                ok = False
            self.i = save
            return ok
        m = re.match(r"[A-Za-z_][A-Za-z0-9_]*\s*=", self.text[self.i:])
        self.i = save
        return bool(m)

    def parse_value(self):
        ch = self.peek()
        if ch == "+":
            self.i += 1
            return self.parse_value()
        if ch == '"':
            return self.parse_string_id_or_string()
        if ch == "[":
            return self.parse_bracket()
        if ch in "-0123456789":
            return self.parse_number()
        ident = self.parse_ident()
        if ident == "true":
            return True
        if ident == "false":
            return False
        return ident

    def parse_bracket(self):
        self.skip()
        if self.text[self.i] != "[":
            raise ValueError("expected [ at %d" % self.i)
        self.i += 1
        self.skip()
        if self.peek() == "]":
            self.i += 1
            return []
        if self.looks_like_struct():
            data = {}
            while self.peek() and self.peek() != "]":
                key = self.parse_key()
                self.skip()
                if self.peek() != "=":
                    raise ValueError("expected = after %s at %d" % (key, self.i))
                self.i += 1
                data[key] = self.parse_value()
                self.skip()
            if self.peek() != "]":
                raise ValueError("expected ] at %d" % self.i)
            self.i += 1
            return data
        items = []
        while self.peek() and self.peek() != "]":
            items.append(self.parse_value())
            self.skip()
        if self.peek() != "]":
            raise ValueError("expected ] at %d" % self.i)
        self.i += 1
        return items

    def parse_file(self):
        fields = {}
        bases = []
        while self.i < self.n:
            self.skip()
            if self.i >= self.n:
                break
            if self.text.startswith("@base", self.i):
                self.i += 5
                self.skip()
                m = re.match(r"\S+", self.text[self.i:])
                if not m:
                    raise ValueError("expected @base path")
                bases.append(m.group(0).rstrip())
                self.i += m.end()
                continue
            if self.text.startswith("@class", self.i):
                while self.i < self.n and self.text[self.i] not in "\n\r":
                    self.i += 1
                continue
            key = self.parse_ident()
            self.skip()
            if self.peek() != "=":
                while self.i < self.n and self.text[self.i] not in "\n\r":
                    self.i += 1
                continue
            self.i += 1
            fields[key] = self.parse_value()
        return bases, fields


def parse_tpf_file(path):
    parser = Parser(read_text(path))
    return parser.parse_file()


def split_os(path):
    return path.replace("\\", os.sep).replace("/", os.sep)


def candidate_tpf_paths(tpf_root, iff):
    rel = iff.replace("\\", "/")
    if rel.endswith(".iff"):
        rel = rel[:-4] + ".tpf"
    out = []
    seen = set()

    def add(path):
        path = os.path.normpath(path)
        if path not in seen:
            seen.add(path)
            out.append(path)

    add(os.path.join(tpf_root, split_os(rel)))
    if rel.startswith("object/"):
        add(os.path.join(tpf_root, split_os(rel[len("object/"):])))
    else:
        add(os.path.join(tpf_root, "object", split_os(rel)))
    if "/draft_schematic/" in rel or rel.startswith("draft_schematic/"):
        tail = rel.split("draft_schematic/", 1)[-1]
        add(os.path.join(tpf_root, split_os(tail)))
    root = os.path.normpath(tpf_root)
    parts = re.split(r"[\\/]", root)
    if "object" in parts:
        idx = len(parts) - 1 - parts[::-1].index("object")
        object_root = os.sep.join(parts[: idx + 1])
        add(os.path.join(object_root, split_os(rel[len("object/"):] if rel.startswith("object/") else rel)))
        add(os.path.join(object_root, split_os(rel)))
    return out


def find_tpf(tpf_root, iff):
    for path in candidate_tpf_paths(tpf_root, iff):
        if os.path.isfile(path):
            return path
    return None


def shared_tree(tpf_root):
    parts = re.split(r"[\\/]", os.path.normpath(tpf_root))
    for i, part in enumerate(parts):
        if part == "sys.server":
            parts[i] = "sys.shared"
            return os.sep.join(parts)
    return None


def deep_merge(base, overlay):
    out = dict(base)
    for key, value in overlay.items():
        if key == "slots" and value:
            out[key] = value
        elif key == "skillCommands" and value:
            out[key] = value
        else:
            out[key] = value
    return out


def load_merged_tpf(tpf_root, iff, cache=None, required=True):
    if cache is None:
        cache = {}
    if iff in cache:
        return cache[iff]
    path = find_tpf(tpf_root, iff)
    if path is None:
        if required:
            raise SystemExit("missing tpf for %s under tpf-tree" % iff)
        cache[iff] = {}
        return {}
    bases, fields = parse_tpf_file(path)
    merged = {}
    for base in bases:
        base_iff = base.replace("\\", "/")
        if not base_iff.endswith(".iff"):
            base_iff += ".iff"
        parent = load_merged_tpf(tpf_root, base_iff, cache, required=False)
        merged = deep_merge(merged, parent)
    merged = deep_merge(merged, fields)
    merged["_tpf_path"] = path
    cache[iff] = merged
    return merged


def load_optional_tpf(tpf_root, iff, cache=None):
    return load_merged_tpf(tpf_root, iff, cache, required=False)


def slot_name_parts(name):
    if isinstance(name, dict):
        return name.get("file") or "", name.get("id") or ""
    if isinstance(name, (list, tuple)) and len(name) >= 2:
        return name[0], name[1]
    text = str(name or "")
    if " " in text:
        file_name, ident = text.split(" ", 1)
        return file_name.strip('"'), ident.strip('"')
    return "craft_item_ingredients_n", text


def first_option(slot):
    options = slot.get("options") or []
    if isinstance(options, dict):
        return options
    if options:
        return options[0]
    return {}


def first_ingredient(option):
    ingredients = option.get("ingredients") or []
    if isinstance(ingredients, dict):
        return ingredients
    if ingredients:
        return ingredients[0]
    return {}


def slot_type_for(option, optional):
    itype = option.get("ingredientType") or "IT_resourceClass"
    if optional and itype in IT_OPTIONAL:
        return IT_OPTIONAL[itype]
    return IT_TO_SLOT.get(itype, 0)


def xp_from_fields(fields, shared_fields):
    xp_type = "crafting_general"
    xp_value = 0
    xp_src = "default 0 (tpf xpPoints.value missing or 0)"
    points = fields.get("xpPoints")
    if isinstance(points, list) and points:
        point = points[0] if not isinstance(points[0], list) else (points[0][0] if points[0] else {})
        if isinstance(point, dict):
            raw = point.get("type")
            if raw:
                xp_type = XP_TYPE.get(raw, "crafting_general")
                xp_src = "xpPoints.type %s -> %s (xp.java)" % (raw, xp_type)
            if point.get("value") not in (None, 0):
                xp_value = int(point.get("value"))
                xp_src += "; xpPoints.value"
    attrs = shared_fields.get("attributes") or []
    if isinstance(attrs, dict):
        attrs = [attrs]
    for attr in attrs:
        if not isinstance(attr, dict):
            continue
        name = attr.get("name") or {}
        ident = name.get("id") if isinstance(name, dict) else name
        if ident == "xp":
            value = attr.get("value")
            if value not in (None, ""):
                xp_value = int(value)
                xp_src = "client shared attributes crafting xp"
            break
    return xp_type, xp_value, xp_src


def skills_from_fields(fields, category):
    commands = fields.get("skillCommands") or []
    if isinstance(commands, str):
        commands = [commands]
    usable = [c for c in commands if c and c != "unskilled"]
    if len(usable) >= 3:
        return usable[0], usable[1], usable[2], "skillCommands[0..2]"
    if len(usable) == 1 and usable[0].endswith("_assembly"):
        stem = usable[0][: -len("_assembly")]
        return (
            usable[0],
            stem + "_experimentation",
            stem + "_customization",
            "skillCommands[0] stem (OURS experiment/customization suffix)",
        )
    trio = SKILLS_FOR_TAB.get(category, SKILLS_FOR_TAB["CT_misc"])
    return trio[0], trio[1], trio[2], "OURS from CraftingType %s; skillCommands=%s" % (category, commands)


def custom_name_from(shared_crafted):
    name = shared_crafted.get("objectName")
    if isinstance(name, dict) and name.get("id"):
        return title_from_id(name.get("id")), name
    if isinstance(name, str) and name:
        return title_from_id(name), name
    return "", None


def build_slot_lists(fields):
    slots = fields.get("slots") or []
    if isinstance(slots, dict):
        slots = [slots]
    titles = []
    templates = []
    types = []
    resources = []
    quantities = []
    contributions = []
    appearances = []
    maps = []
    for slot in slots:
        if not isinstance(slot, dict):
            continue
        file_name, ident = slot_name_parts(slot.get("name"))
        option = first_option(slot)
        ing = first_ingredient(option)
        itype = option.get("ingredientType") or "IT_resourceClass"
        optional = bool(slot.get("optional"))
        resource = ing.get("ingredient") or ""
        if isinstance(resource, dict):
            resource = resource.get("id") or resource.get("file") or ""
        count = ing.get("count")
        if count is None:
            count = 1
        appearance = slot.get("appearance") or ""
        templates.append(file_name or "craft_item_ingredients_n")
        titles.append(ident)
        types.append(slot_type_for(option, optional))
        resources.append(to_shared_ingredient(str(resource)))
        quantities.append(int(count))
        contributions.append(100)
        appearances.append(appearance if isinstance(appearance, str) else "")
        maps.append({
            "name": ident,
            "ingredientType": itype,
            "optional": optional,
            "ingredient": resource,
            "count": int(count),
            "appearance": appearance,
        })
    return {
        "ingredientTemplateNames": templates,
        "ingredientTitleNames": titles,
        "ingredientSlotType": types,
        "resourceTypes": resources,
        "resourceQuantities": quantities,
        "contribution": contributions,
        "ingredientAppearance": appearances,
        "slot_maps": maps,
    }


def lua_str_list(items):
    return "{" + ", ".join(lua_str(x) for x in items) + "}"


def lua_num_list(items):
    return "{" + ", ".join(str(int(x)) for x in items) + "}"


def format_body(data):
    lines = [
        "",
        "   templateType = DRAFTSCHEMATIC,",
        "",
        "   customObjectName = %s," % lua_str(data["customObjectName"]),
        "",
        "   craftingToolTab = %s, -- (See DraftSchematicObjectTemplate.h)" % int(data["craftingToolTab"]),
        "   complexity = %s, " % int(data["complexity"]),
        "   size = %s, " % int(data["size"]),
        "   factoryCrateType = %s," % lua_str(data["factoryCrateType"]),
        "   ",
        "   xpType = %s, " % lua_str(data["xpType"]),
        "   xp = %s, " % int(data["xp"]),
        "",
        "   assemblySkill = %s, " % lua_str(data["assemblySkill"]),
        "   experimentingSkill = %s, " % lua_str(data["experimentingSkill"]),
        "   customizationSkill = %s," % lua_str(data["customizationSkill"]),
        "   factoryCrateSize = %s, " % int(data["factoryCrateSize"]),
        "",
        "   customizationOptions = {},",
        "   customizationStringNames = {},",
        "   customizationDefaults = {},",
        "",
        "   ingredientTemplateNames = %s," % lua_str_list(data["ingredientTemplateNames"]),
        "   ingredientTitleNames = %s," % lua_str_list(data["ingredientTitleNames"]),
        "   ingredientSlotType = %s," % lua_num_list(data["ingredientSlotType"]),
        "   resourceTypes = %s," % lua_str_list(data["resourceTypes"]),
        "   resourceQuantities = %s," % lua_num_list(data["resourceQuantities"]),
        "   contribution = %s," % lua_num_list(data["contribution"]),
    ]
    appearances = data.get("ingredientAppearance") or []
    if any(appearances):
        lines.append("   ingredientAppearance = %s," % lua_str_list(appearances))
    lines.extend([
        "",
        "",
        "   targetTemplate = %s," % lua_str(data["targetTemplate"]),
        "",
        "   additionalTemplates = {",
        "             }",
        "",
    ])
    return "\n".join(lines)


def replace_new_body(existing, body):
    match = NEW_HEAD.match(existing)
    if not match:
        raise SystemExit("could not find :new { in draft lua")
    head = match.group(1)
    add = ADD_TEMPLATE.search(existing)
    if not add:
        raise SystemExit("could not find addTemplate in draft lua")
    tail = existing[add.start():]
    nl = detect_nl(existing)
    if nl == "\r\n":
        body = body.replace("\n", "\r\n")
    return head + body + "}\n" + tail


def find_draft_lua(scripts_root, iff):
    rel = iff.replace("\\", "/")
    if rel.endswith(".iff"):
        rel = rel[:-4]
    if rel.startswith("object/"):
        rel = rel[len("object/"):]
    rel_lua = rel.replace("/", os.sep) + ".lua"
    candidates = [
        os.path.join(scripts_root, "object", "custom_content", rel_lua),
        os.path.join(scripts_root, "object", rel_lua),
    ]
    for path in candidates:
        if os.path.isfile(path):
            return path
    return None


def template_already_registered(scripts_root, iff):
    target = iff.replace("\\", "/")
    rel = target
    if rel.endswith(".iff"):
        rel = rel[:-4]
    if rel.startswith("object/"):
        rel = rel[len("object/"):]
    base = rel.rsplit("/", 1)[-1]
    candidates = [
        os.path.join(scripts_root, "object", split_os(rel) + ".lua"),
        os.path.join(scripts_root, "object", "custom_content", split_os(rel) + ".lua"),
        os.path.join(scripts_root, "object", "custom_content", "weapon", "ranged", base + ".lua"),
        os.path.join(scripts_root, "object", "custom_content", "weapon", "melee", base + ".lua"),
    ]
    quoted = '"%s"' % target
    for path in candidates:
        if not os.path.isfile(path):
            continue
        text = read_text(path)
        if "ObjectTemplates:addTemplate" in text and quoted in text:
            return path
    return None


def ensure_include(path, include_line):
    text = read_text(path) if os.path.isfile(path) else ""
    nl = detect_nl(text) if text else "\n"
    if include_line in text.replace("\r\n", "\n"):
        return False
    if text and not text.endswith(("\n", "\r\n")):
        text += nl
    write_text(path, text + include_line + nl, newline=nl)
    return True


def avatar_register(scripts_root, iff):
    """SharedTangibleObjectTemplate + addClientTemplate + derived addTemplate."""
    rel = iff.replace("\\", "/")
    if rel.endswith(".iff"):
        rel = rel[:-4]
    if rel.startswith("object/"):
        rel = rel[len("object/"):]
    client = iff_to_shared(iff.replace("\\", "/"))
    derived = object_var_from_iff(iff.replace("\\", "/"))
    shared = object_var_from_iff(iff.replace("\\", "/"), shared=True)
    folder = os.path.join(scripts_root, "object", "custom_content", split_os(os.path.dirname(rel)))
    base = os.path.basename(rel)
    objects_path = os.path.join(folder, "objects.lua")
    derived_path = os.path.join(folder, base + ".lua")
    server_path = os.path.join(folder, "serverobjects.lua")
    os.makedirs(folder, exist_ok=True)
    objects_block = AVATAR_SHARED.format(shared=shared, client=client)
    if os.path.isfile(objects_path):
        existing = read_text(objects_path)
        if shared not in existing:
            nl = detect_nl(existing)
            write_text(objects_path, existing.rstrip() + nl + objects_block, newline=nl)
    else:
        write_text(objects_path, objects_block)
    if not os.path.isfile(derived_path):
        write_text(derived_path, AVATAR_DERIVED.format(
            derived=derived, shared=shared, iff=iff.replace("\\", "/")))
    include_line = 'includeFile("custom_content/%s.lua")' % rel.replace("\\", "/")
    created_server = False
    if os.path.isfile(server_path):
        ensure_include(server_path, include_line)
    else:
        write_text(server_path, include_line + "\n")
        created_server = True
    return {
        "objects": objects_path,
        "derived": derived_path,
        "serverobjects": server_path,
        "created_serverobjects": created_server,
        "include": include_line,
    }


def parent_serverobjects_chain(scripts_root, iff):
    """Include the new folder from the parent custom_content serverobjects.lua."""
    rel = iff.replace("\\", "/")
    if rel.endswith(".iff"):
        rel = rel[:-4]
    if rel.startswith("object/"):
        rel = rel[len("object/"):]
    folder = os.path.dirname(rel).replace("\\", "/")
    parent = os.path.dirname(folder)
    notes = []
    if not parent:
        return notes
    child_include = 'includeFile("custom_content/%s/serverobjects.lua")' % folder
    parent_server = os.path.join(
        scripts_root, "object", "custom_content", split_os(parent), "serverobjects.lua")
    if os.path.isfile(parent_server):
        if ensure_include(parent_server, child_include):
            notes.append(parent_server)
        return notes
    walk = parent
    while walk and walk != ".":
        candidate = os.path.join(
            scripts_root, "object", "custom_content", split_os(walk), "serverobjects.lua")
        if os.path.isfile(candidate):
            if ensure_include(candidate, child_include):
                notes.append(candidate)
            break
        walk = os.path.dirname(walk)
    return notes


def patch_schematics(scripts_root, paths):
    path = os.path.join(scripts_root, "managers", "crafting", "schematics.lua")
    text = read_text(path)
    nl = detect_nl(text)
    existing = set(re.findall(r'path="([^"]+)"', text))
    new_paths = [p for p in paths if p not in existing]
    if not new_paths:
        return 0
    block_lines = [
        "",
        "  -- Collection loot-schematic drafts",
        "  ------------------------------------------------------------------",
    ]
    for iff in new_paths:
        block_lines.append('  {path="%s"},' % iff)
    block = nl.join(block_lines) + nl
    idx = text.rfind("};")
    if idx < 0:
        raise SystemExit("schematics.lua: missing closing };")
    write_text(path, text[:idx] + block + text[idx:], newline=nl)
    return len(new_paths)


def patch_collection_manager(scripts_root, absent_iffs):
    path = os.path.join(scripts_root, "managers", "collections", "collection_manager.lua")
    text = read_text(path)
    nl = detect_nl(text)
    rows = []
    for iff in absent_iffs:
        rows.append('\t[%s]=true,' % lua_str(iff))
    table = (
        "\n-- The 25 drafts whose crafted object has no client file. Use must not\n"
        "-- claim a grant (addRewardedSchematic is not called).\n"
        "CollectionManager.LOOT_SCHEMATIC_CLIENT_ABSENT = {\n"
        + "\n".join(rows) + "\n}\n"
    )
    marker = "CollectionManager.LOOT_SCHEMATIC_CLIENT_ABSENT"
    if marker in text:
        text = re.sub(
            r"-- The 25 drafts whose crafted object has no client file\..*?CollectionManager\.LOOT_SCHEMATIC_CLIENT_ABSENT = \{.*?\}\n",
            table.lstrip("\n"),
            text,
            count=1,
            flags=re.DOTALL,
        )
    else:
        insert_at = text.find("CollectionManager.LOOT_SCHEMATIC_BEAST")
        if insert_at < 0:
            raise SystemExit("collection_manager.lua: missing LOOT_SCHEMATIC_BEAST")
        text = text[:insert_at] + table + "\n" + text[insert_at:]
    check = (
        "\tif CollectionManager.LOOT_SCHEMATIC_CLIENT_ABSENT[schematic] == true then\n"
        '\t\tprint("CollectionManager: schematic\'s crafted object absent from this client")\n'
        "\t\treturn 0\n"
        "\tend\n\n"
    )
    if "LOOT_SCHEMATIC_CLIENT_ABSENT[schematic]" not in text:
        needle = "\tlocal uses = readData(oid .. \":collection.lootSchematicUses\")"
        idx = text.find(needle)
        if idx < 0:
            raise SystemExit("collection_manager.lua: missing uses read")
        text = text[:idx] + check + text[idx:]
    write_text(path, text, newline=nl)


def default_scripts_root():
    here = os.path.dirname(os.path.abspath(__file__))
    return os.path.abspath(os.path.join(here, "..", "..", "bin", "scripts"))


def client_target_set(targets):
    out = set()
    for shared in (targets.get("clientIff") or {}):
        path = shared.replace("\\", "/")
        out.add(path)
        name = path.rsplit("/", 1)[-1]
        dirname = path[: path.rfind("/") + 1] if "/" in path else ""
        if name.startswith("shared_"):
            out.add(dirname + name[len("shared_"):])
        if "/shared_" in path:
            out.add(path.replace("/shared_", "/"))
    return out


def transcribe_one(tpf_root, shared_root, rec, cache, shared_cache):
    iff = rec["iff"].replace("\\", "/")
    fields = load_merged_tpf(tpf_root, iff, cache)
    shared_fields = {}
    if shared_root:
        shared_iff = fields.get("sharedTemplate") or iff_to_shared(iff)
        if isinstance(shared_iff, str):
            shared_fields = load_optional_tpf(shared_root, shared_iff, shared_cache)
    crafted = rec.get("target") or fields.get("craftedObjectTemplate") or ""
    if isinstance(crafted, dict):
        crafted = crafted.get("id") or ""
    crafted = str(crafted).replace("\\", "/")
    shared_crafted = {}
    if shared_root and crafted:
        shared_crafted = load_optional_tpf(shared_root, iff_to_shared(crafted), shared_cache)
    category = fields.get("category") or "CT_misc"
    tab = CRAFTING_TAB.get(category)
    if tab is None:
        tab = CRAFTING_TAB["CT_misc"]
        tab_src = "OURS CT_misc; unknown category %s" % category
    else:
        tab_src = "tpf category %s -> %s (DraftSchematicObjectTemplate.h / base_class.java CraftingType)" % (
            category, tab)
    complexity = fields.get("complexity")
    if complexity is None:
        complexity = 1
        complexity_src = "OURS 1; tpf complexity missing"
    else:
        complexity_src = "tpf complexity"
    volume = fields.get("volume")
    if volume is None:
        volume = 1
        volume_src = "OURS 1; tpf volume missing"
    else:
        volume_src = "tpf volume"
    crate = fields.get("crateObjectTemplate") or "object/factory/factory_crate_generic_items.iff"
    crate_src = "tpf crateObjectTemplate"
    items = fields.get("itemsPerContainer")
    if items is None:
        items = 0
        items_src = "OURS 0; tpf itemsPerContainer missing"
    else:
        items_src = "tpf itemsPerContainer"
    xp_type, xp_value, xp_src = xp_from_fields(fields, shared_fields)
    assembly, experiment, custom, skill_src = skills_from_fields(fields, category)
    display, name_src = custom_name_from(shared_crafted)
    if not display:
        display = title_from_id(os.path.basename(iff)[:-4] if iff.endswith(".iff") else iff)
        name_src = "OURS title-case of schematic basename; crafted objectName missing"
    else:
        name_src = "crafted objectName %s; display is OURS title-case of the id" % (name_src,)
    slots = build_slot_lists(fields)
    data = {
        "iff": iff,
        "customObjectName": display,
        "craftingToolTab": int(tab),
        "complexity": int(complexity),
        "size": int(volume),
        "factoryCrateType": crate,
        "factoryCrateSize": int(items),
        "xpType": xp_type,
        "xp": int(xp_value),
        "assemblySkill": assembly,
        "experimentingSkill": experiment,
        "customizationSkill": custom,
        "targetTemplate": crafted,
        "category": category,
        "sources": {
            "customObjectName": name_src,
            "craftingToolTab": tab_src,
            "complexity": complexity_src,
            "size": volume_src,
            "factoryCrateType": crate_src,
            "factoryCrateSize": items_src,
            "xp": xp_src,
            "skills": skill_src,
            "slots": "tpf slots (name, option.ingredientType, ingredient, count); contribution OURS 100",
            "targetTemplate": "tpf craftedObjectTemplate",
        },
    }
    data.update(slots)
    return data, fields


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("tpf_tree")
    parser.add_argument("loot_schematics_json")
    parser.add_argument("schematic_targets_json")
    parser.add_argument("--scripts", default=None)
    args = parser.parse_args(argv)

    tpf_root = os.path.abspath(args.tpf_tree)
    if not os.path.isdir(tpf_root):
        raise SystemExit("tpf-tree is not a directory")
    scripts_root = os.path.abspath(args.scripts) if args.scripts else default_scripts_root()
    loot = json.loads(read_text(args.loot_schematics_json))
    targets = json.loads(read_text(args.schematic_targets_json))
    client_targets = client_target_set(targets)
    shared_root = shared_tree(tpf_root)

    registerable = []
    absent = []
    for rec in loot:
        target = (rec.get("target") or "").replace("\\", "/")
        if rec.get("targetInFork") or target in client_targets:
            registerable.append(rec)
        else:
            absent.append(rec)

    # Distinct by iff, stable order.
    seen = set()
    distinct_reg = []
    for rec in registerable:
        iff = rec["iff"].replace("\\", "/")
        if iff not in seen:
            seen.add(iff)
            distinct_reg.append(rec)
    seen_abs = set()
    distinct_abs = []
    for rec in absent:
        iff = rec["iff"].replace("\\", "/")
        if iff not in seen_abs:
            seen_abs.add(iff)
            distinct_abs.append(rec)

    cache = {}
    shared_cache = {}
    written = []
    field_maps = {}
    example_iffs = [
        "object/draft_schematic/furniture/furniture_collection_fish_tank.iff",
        "object/draft_schematic/clothing/clothing_collection_jeweled_necklace.iff",
        "object/draft_schematic/weapon/appearance/weapon_appearance_pistol_dd6.iff",
    ]
    avatar_notes = []
    for rec in distinct_reg:
        data, _fields = transcribe_one(tpf_root, shared_root, rec, cache, shared_cache)
        lua_path = find_draft_lua(scripts_root, rec["iff"])
        if lua_path is None:
            raise SystemExit("no draft lua shell for %s" % rec["iff"])
        existing = read_text(lua_path)
        write_text(lua_path, replace_new_body(existing, format_body(data)), newline=detect_nl(existing))
        written.append({"iff": data["iff"], "lua": lua_path, "target": data["targetTemplate"]})
        if data["iff"] in example_iffs:
            field_maps[data["iff"]] = data
        target = data["targetTemplate"]
        if target in client_targets and not rec.get("targetInFork"):
            already = template_already_registered(scripts_root, target)
            if already:
                avatar_notes.append({"iff": target, "already": already, "action": "skipped"})
            else:
                info = avatar_register(scripts_root, target)
                parent_serverobjects_chain(scripts_root, target)
                avatar_notes.append({"iff": target, "action": "registered", "files": info})

    added = patch_schematics(scripts_root, [r["iff"].replace("\\", "/") for r in distinct_reg])
    patch_collection_manager(
        scripts_root, [r["iff"].replace("\\", "/") for r in distinct_abs])

    summary = {
        "written": len(written),
        "registered": len(distinct_reg),
        "absent": [{"iff": r["iff"], "target": r.get("target")} for r in distinct_abs],
        "schematics_lua_added": added,
        "avatar": avatar_notes,
        "ours": OURS_FIELDS,
        "field_maps": field_maps,
        "written_iffs": [w["iff"] for w in written],
    }
    json.dump(summary, sys.stdout, indent=1, sort_keys=True)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
