#!/usr/bin/env python3
"""Transcribe SOE consume_click buildout rows into per-zone Lua spawn tables.

Usage:  build_collection_objects.py --objects <world-collection-objects.json>
                                 --offsets <area-offsets.json>
                                 [--out <path to screenplays/collections/objects>]

Reads the transcribed planet-table rows (collection.slotName + consume_click) and
the transcribed areas_<planet>.tab x1/z1 offsets. Emits one Lua file per Core3
zone. The SOE tables and the JSON inputs are never committed; only this tool and
its Lua output are.

World x = x1 + px, height = py, world y (Core3) = z1 + pz. Quaternion columns are
not in the JSON; spawned objects use the identity quaternion (OURS). Indoor cell
rows stay OPEN unless a parent building snapshot node is supplied later.
Kashyyyk surface tabs are remapped onto the merged zone with the fork's merge
offsets; rryatt_trail_lvl_3 has no copy-0 offset and is skipped with a print.
"""
from __future__ import print_function

import argparse
import json
import os
import sys


CONSUME_CLICK = "systems.collections.consume_click"

# Kashyyyk surface is one merged zone. rryatt is its own zone; copy #0 offsets
# replace areas_*.tab x1/z1. lvl-3 copy offset is OPEN.
KASHYYYK_TABS = {
    "kashyyyk_main": ("kashyyyk", -4096.0, -4096.0),
    "kashyyyk_dead_forest": ("kashyyyk", -3548.0, -548.0),
    "kashyyyk_rryatt_trail_lvl_1_and_2": ("kashyyyk_rryatt_trail", -3908.0, 3365.0),
    "kashyyyk_rryatt_trail_lvl_4": ("kashyyyk_rryatt_trail", -3908.0, 2115.0),
    "kashyyyk_rryatt_trail_lvl_5": ("kashyyyk_rryatt_trail", -2208.0, 2115.0),
}

RRYATT_LVL3_PREFIX = "kashyyyk_rryatt_trail_lvl_3"

ZONE_FILE_ORDER = (
    "corellia",
    "dantooine",
    "dathomir",
    "dungeon1",
    "endor",
    "kashyyyk",
    "kashyyyk_rryatt_trail",
    "lok",
    "mustafar",
    "naboo",
    "rori",
    "talus",
    "tatooine",
    "yavin4",
)


def lua_str(value):
    return '"' + (
        value.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
    ) + '"'


def lua_num(value):
    number = float(value)
    as_int = int(number)
    if number == as_int:
        return str(as_int)
    text = ("%.6f" % number).rstrip("0").rstrip(".")
    return text


def tab_stem(tab):
    name = (tab or "").replace("\\", "/").split("/")[-1]
    if name.endswith(".tab"):
        name = name[:-4]
    return name


def to_float(value):
    return float(value)


def load_json(path):
    with open(path, encoding="utf-8") as handle:
        return json.load(handle)


def resolve_zone_and_offset(stem, planet, offsets):
    if stem.startswith(RRYATT_LVL3_PREFIX):
        return "kashyyyk_rryatt_trail", None, "rryatt_lvl3"

    kash = KASHYYYK_TABS.get(stem)
    if kash is not None:
        zone, dx, dz = kash
        return zone, (dx, dz), None

    raw = offsets.get(stem)
    if raw is None:
        return planet, None, "missing_offset"

    return planet, (float(raw[0]), float(raw[1])), None


def transform_row(src, index_in_tab, offsets):
    stem = tab_stem(src.get("tab", ""))
    planet = (src.get("planet") or "").strip()
    zone, offset, special = resolve_zone_and_offset(stem, planet, offsets)
    cell = int(float(src.get("cell") or "0"))
    px = to_float(src.get("px") or "0")
    py = to_float(src.get("py") or "0")
    pz = to_float(src.get("pz") or "0")
    slot = (src.get("slot") or "").strip()
    template = (src.get("template") or "").strip()
    row_key = stem + ":" + str(index_in_tab)

    entry = {
        "row": row_key,
        "zone": zone,
        "template": template,
        "slot": slot,
        "cell": cell,
        "tab": stem,
    }

    if special == "rryatt_lvl3":
        entry["x"] = px
        entry["z"] = py
        entry["y"] = pz
        entry["open"] = True
        entry["openNote"] = "kashyyyk_rryatt_trail_lvl_3 copy offset OPEN"
        return entry, "rryatt_lvl3"

    if cell != 0:
        entry["x"] = px
        entry["z"] = py
        entry["y"] = pz
        entry["open"] = True
        entry["openNote"] = "cell " + str(cell) + "; parent building not resolved to a snapshot node"
        return entry, "cell"

    if offset is None:
        entry["x"] = px
        entry["z"] = py
        entry["y"] = pz
        entry["open"] = True
        entry["openNote"] = "no area offset for tab " + stem
        return entry, "missing_offset"

    dx, dz = offset
    entry["x"] = dx + px
    entry["z"] = py
    entry["y"] = dz + pz
    return entry, "placed"


def emit_entry(entry):
    lines = ["	{"]
    lines.append("		row = " + lua_str(entry["row"]) + ",")
    lines.append("		zone = " + lua_str(entry["zone"]) + ",")
    lines.append("		template = " + lua_str(entry["template"]) + ",")
    lines.append("		x = " + lua_num(entry["x"]) + ", z = " + lua_num(entry["z"]) + ", y = " + lua_num(entry["y"]) + ",")
    lines.append("		cell = " + str(entry["cell"]) + ",")
    lines.append("		slot = " + lua_str(entry["slot"]) + ",")
    if entry.get("open"):
        lines.append("		open = true,")
        lines.append("		openNote = " + lua_str(entry["openNote"]) + ",")
    lines.append("	},")
    return lines


def write_zone_file(path, zone, rows):
    out = [
        "-- Generated by tools/collections/build_collection_objects.py. Do not edit.",
        "-- consume_click rows for zone " + zone + ".",
        "-- Quaternion is identity (OURS): the JSON has px/py/pz only.",
        "",
        "CollectionObjectSpawns = CollectionObjectSpawns or {}",
        "",
        "CollectionObjectSpawns." + zone + " = {",
    ]
    for entry in rows:
        out.extend(emit_entry(entry))
    out.append("}")
    out.append("")
    with open(path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(out))


def main():
    parser = argparse.ArgumentParser(description="Build per-zone collection object spawn tables.")
    parser.add_argument("--objects", required=True, help="world-collection-objects.json")
    parser.add_argument("--offsets", required=True, help="area-offsets.json")
    parser.add_argument(
        "--out",
        default=os.path.join("MMOCoreORB", "bin", "scripts", "screenplays", "collections", "objects"),
        help="output directory for <zone>.lua files",
    )
    args = parser.parse_args()

    rows = load_json(args.objects)
    offsets = load_json(args.offsets)

    consume = []
    for src in rows:
        scripts = (src.get("scripts") or "").strip()
        if scripts != CONSUME_CLICK:
            continue
        consume.append(src)

    tab_seq = {}
    by_zone = {}
    counts = {}

    for src in consume:
        stem = tab_stem(src.get("tab", ""))
        tab_seq[stem] = tab_seq.get(stem, 0) + 1
        entry, kind = transform_row(src, tab_seq[stem], offsets)
        zone = entry["zone"]
        by_zone.setdefault(zone, []).append(entry)
        bucket = counts.setdefault(zone, {"placed": 0, "cell": 0, "rryatt_lvl3": 0, "missing_offset": 0, "total": 0})
        bucket["total"] += 1
        bucket[kind] = bucket.get(kind, 0) + 1
        if kind == "rryatt_lvl3":
            print("CollectionObjects: skip " + entry["row"] + " (kashyyyk_rryatt_trail_lvl_3 copy offset OPEN)")

    os.makedirs(args.out, exist_ok=True)

    written = set()
    zone_names = list(ZONE_FILE_ORDER)
    for zone in sorted(by_zone.keys()):
        if zone not in zone_names:
            zone_names.append(zone)

    for zone in zone_names:
        entries = by_zone.get(zone)
        if not entries:
            continue
        dest = os.path.join(args.out, zone + ".lua")
        write_zone_file(dest, zone, entries)
        written.add(zone + ".lua")
        print("->", dest, "rows", len(entries), "placed", counts[zone]["placed"], "open-cell", counts[zone]["cell"], "open-lvl3", counts[zone]["rryatt_lvl3"])

    for name in os.listdir(args.out):
        if name.endswith(".lua") and name not in written:
            os.remove(os.path.join(args.out, name))
            print("removed stale", name)

    print("consume_click", len(consume), "zones", len(written))
    print("zone\tplaced\topen_cell\topen_lvl3\tmissing_offset\ttotal")
    for zone in zone_names:
        if zone not in counts:
            continue
        c = counts[zone]
        print("\t".join(str(x) for x in (
            zone, c["placed"], c["cell"], c["rryatt_lvl3"], c["missing_offset"], c["total"],
        )))


if __name__ == "__main__":
    main()
