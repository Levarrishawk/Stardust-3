#!/usr/bin/env python3
"""Transcribe SOE static-item rows into bin/scripts/managers/collections/collection_static_items.lua.

Usage:  build_static_items.py <json> [--scripts <path to bin/scripts>]

Reads a name -> {template, slot, scripts, unique, in_fork, ...} JSON transcription of
master_item.tab + item_stats.tab (static_item.java:16-19). Writes CollectionStaticItems,
sorted by name, deterministic. The JSON itself is never committed.
"""
from __future__ import print_function

import argparse
import json
import os
import sys


CONSUME_LOOT = "systems.collections.consume_loot"
LOOT_SCHEMATIC = "item.loot_schematic.loot_schematic"
AUTOSTACK = "object.autostack"


def lua_str(value):
    return '"' + (
        (value or "").replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
    ) + '"'


def lua_bool(value):
    return "true" if value else "false"


def lua_key(name):
    return "[" + lua_str(name) + "]"


def script_set(scripts):
    out = set()
    for part in (scripts or "").split(","):
        name = part.strip()
        if name:
            out.add(name)
    return out


def unique_flag(value):
    if value is True:
        return True
    if value is False or value is None:
        return False
    text = str(value).strip().lower()
    return text in ("1", "true", "yes")


def emit_row(name, rec):
    scripts = script_set(rec.get("scripts"))
    slot = rec.get("slot")
    if slot is None:
        slot = ""
    else:
        slot = str(slot)
    parts = [
        "template=" + lua_str(rec.get("template") or ""),
        "slot=" + lua_str(slot),
        "consumeLoot=" + lua_bool(CONSUME_LOOT in scripts),
        "lootSchematic=" + lua_bool(LOOT_SCHEMATIC in scripts),
        "autostack=" + lua_bool(AUTOSTACK in scripts),
        "inFork=" + lua_bool(rec.get("in_fork") is True),
        "unique=" + lua_bool(unique_flag(rec.get("unique"))),
    ]
    return "	" + lua_key(name) + "={" + ",".join(parts) + "},"


def main():
    parser = argparse.ArgumentParser(
        usage="build_static_items.py <json> [--scripts DIR]",
        description="Transcribe static-item JSON into collection_static_items.lua",
    )
    parser.add_argument("json", help="path to static-item JSON (required; never committed)")
    parser.add_argument(
        "--scripts",
        default=os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "bin", "scripts")),
        help="bin/scripts output root",
    )
    args = parser.parse_args()

    if not os.path.isfile(args.json):
        raise SystemExit("missing " + args.json)

    with open(args.json, encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise SystemExit("JSON root must be an object of name -> row")

    names = sorted(data.keys())
    n_slot = 0
    n_fork = 0
    n_consume = 0
    n_schematic = 0
    n_autostack = 0
    n_reward = 0
    for name in names:
        rec = data[name]
        if not isinstance(rec, dict):
            raise SystemExit("row is not an object: " + name)
        scripts = script_set(rec.get("scripts"))
        if rec.get("slot"):
            n_slot += 1
        if rec.get("in_fork") is True:
            n_fork += 1
        if CONSUME_LOOT in scripts:
            n_consume += 1
        if LOOT_SCHEMATIC in scripts:
            n_schematic += 1
        if AUTOSTACK in scripts:
            n_autostack += 1
        if rec.get("reward") is True:
            n_reward += 1

    dest_dir = os.path.join(args.scripts, "managers", "collections")
    os.makedirs(dest_dir, exist_ok=True)
    dest = os.path.join(dest_dir, "collection_static_items.lua")

    out = []
    out.append("-- SOURCED -- SOE master_item.tab + item_stats.tab, transcribed by tools/collections/build_static_items.py")
    out.append("-- static_item.java:16-19 (MASTER_ITEM_TABLE / ITEM_STAT_BALANCE_TABLE).")
    out.append("-- The source transcription is never committed. Do not hand-edit.")
    out.append("-- Counts: %d items, %d with slot, %d inFork, %d consumeLoot, %d lootSchematic, %d autostack, %d reward." % (
        len(names), n_slot, n_fork, n_consume, n_schematic, n_autostack, n_reward,
    ))
    out.append("CollectionStaticItems = {")
    for name in names:
        out.append(emit_row(name, data[name]))
    out.append("}")
    out.append("return CollectionStaticItems")
    out.append("")

    with open(dest, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(out))

    print("items", len(names), "slot", n_slot, "inFork", n_fork, file=sys.stderr)
    print("consumeLoot", n_consume, "lootSchematic", n_schematic, "autostack", n_autostack, "reward", n_reward, file=sys.stderr)
    print("->", dest, file=sys.stderr)


if __name__ == "__main__":
    main()
