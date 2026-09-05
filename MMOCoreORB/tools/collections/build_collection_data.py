#!/usr/bin/env python3
"""Transcribe SOE collection datatables into bin/scripts/managers/collections/collection_data.lua.

Usage:  build_collection_data.py --dsrc <sys.shared datatables root> --server <sys.server datatables root>
                                 [--scripts <path to bin/scripts>]

Reads collection/collection.tab (shared), collection/rewards.tab, collection/collection_npc.tab and
collection/collection_live_conversion.tab (server). Carries the sparse-indent hierarchy FORWARD: a
bookName row opens a book, a pageName row opens a page under it, a collectionName row opens a
collection under that, a slotName row is a leaf. The SOE tables themselves are never committed;
only this tool and its Lua output are.
"""
from __future__ import print_function

import argparse
import csv
import os
import sys


def read_tab(path):
    with open(path, encoding="utf-8", errors="replace", newline="") as handle:
        rows = list(csv.reader(handle, delimiter="\t", quotechar='"'))
    if len(rows) < 2:
        raise SystemExit("empty or truncated tab: " + path)
    header = [(cell or "").strip() for cell in rows[0]]
    data = []
    for raw in rows[2:]:
        if not any((cell or "").strip() for cell in raw):
            continue
        rec = {}
        for i, name in enumerate(header):
            rec[name] = (raw[i] if i < len(raw) else "").strip()
        data.append(rec)
    return header, data


def lua_str(value):
    return '"' + (
        value.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
    ) + '"'


def lua_key(name):
    return "[" + lua_str(name) + "]"


def to_int(value, default=0):
    text = (value or "").strip()
    if text == "":
        return default
    try:
        return int(float(text))
    except ValueError:
        return default


def to_float(value):
    text = (value or "").strip()
    if text == "":
        return None
    try:
        return float(text)
    except ValueError:
        return None


def nonempty_list(row, prefix, count):
    out = []
    for i in range(1, count + 1):
        item = (row.get(prefix + str(i), "") or "").strip()
        if item:
            out.append(item)
    return out


def emit_string_list(values):
    return "{" + ",".join(lua_str(v) for v in values) + "}"


def emit_fields(row, is_slot):
    """Stable field order for a book/page/collection/slot node. Omits empty/default values."""
    parts = ["name=" + lua_str(row["_name"])]
    if is_slot:
        parts.append("beginId=" + str(to_int(row.get("beginSlotId"))))
        parts.append("endId=" + str(to_int(row.get("endSlotId"), -1)))
        parts.append("maxValue=" + str(to_int(row.get("maxSlotValue"), -1)))
    categories = nonempty_list(row, "category", 11)
    if categories:
        parts.append("categories=" + emit_string_list(categories))
    prereqs = nonempty_list(row, "prereqSlotName", 5)
    if prereqs:
        parts.append("prereqs=" + emit_string_list(prereqs))
    icon = (row.get("icon") or "").strip()
    if icon:
        parts.append("icon=" + lua_str(icon))
    music = (row.get("music") or "").strip()
    if music:
        parts.append("music=" + lua_str(music))
    show = (row.get("showIfNotYetEarned") or "").strip()
    if show and show != "gray":
        parts.append("showIfNotYetEarned=" + lua_str(show))
    if to_int(row.get("hidden")) == 1:
        parts.append("hidden=1")
    if to_int(row.get("title")) == 1:
        parts.append("title=1")
    alts = nonempty_list(row, "alternateTitle", 5)
    if alts:
        parts.append("alternateTitles=" + emit_string_list(alts))
    if to_int(row.get("noReward")) == 1:
        parts.append("noReward=1")
    if to_int(row.get("trackServerFirst")) == 1:
        parts.append("trackServerFirst=1")
    string_name = (row.get("string_name") or "").strip()
    if string_name:
        parts.append("stringName=" + lua_str(string_name))
    string_detail = (row.get("string_detail") or "").strip()
    if string_detail:
        parts.append("stringDetail=" + lua_str(string_detail))
    return ",".join(parts)


def emit_reward(row):
    parts = ["collectionName=" + lua_str(row.get("collection_name") or "")]
    xp = to_float(row.get("xpModifier"))
    if xp is not None:
        if xp == int(xp):
            parts.append("xpModifier=" + str(int(xp)))
        else:
            parts.append("xpModifier=" + repr(xp))
    if to_int(row.get("is_space_xp")) == 1:
        parts.append("isSpaceXp=1")
    for src, dest in (
        ("slot_name", "slotName"),
        ("quest", "quest"),
        ("item", "item"),
    ):
        val = (row.get(src) or "").strip()
        if val:
            parts.append(dest + "=" + lua_str(val))
    stack = row.get("stackAmount") or ""
    if stack != "":
        parts.append("stackAmount=" + str(to_int(stack, 1)))
    if to_int(row.get("grantRandomItem")) == 1:
        parts.append("grantRandomItem=1")
    if to_int(row.get("grantWeightedRandom")) == 1:
        parts.append("grantWeightedRandom=1")
    for src, dest in (
        ("command", "command"),
        ("skill_mod", "skillMod"),
    ):
        val = (row.get(src) or "").strip()
        if val:
            parts.append(dest + "=" + lua_str(val))
    if (row.get("skill_mod_amount") or "").strip() != "":
        parts.append("skillModAmount=" + str(to_int(row.get("skill_mod_amount"), 1)))
    if (row.get("skill_mod_max") or "").strip() != "":
        parts.append("skillModMax=" + str(to_int(row.get("skill_mod_max"), 10)))
    for src, dest in (
        ("quest_signal", "questSignal"),
        ("crafting_template", "craftingTemplate"),
        ("category", "category"),
        ("reward_text", "rewardText"),
    ):
        val = (row.get(src) or "").strip()
        if val:
            parts.append(dest + "=" + lua_str(val))
    return "{" + ",".join(parts) + "},"


def build_hierarchy(rows):
    books = []
    unplaced = []
    book = page = collection = None
    for line_no, row in enumerate(rows, start=3):
        book_name = (row.get("bookName") or "").strip()
        page_name = (row.get("pageName") or "").strip()
        col_name = (row.get("collectionName") or "").strip()
        slot_name = (row.get("slotName") or "").strip()
        filled = sum(1 for name in (book_name, page_name, col_name, slot_name) if name)
        if book_name:
            if filled != 1:
                unplaced.append({"line": line_no, "reason": "book row with extra names", "slot": slot_name})
            node = dict(row)
            node["_name"] = book_name
            node["_pages"] = []
            books.append(node)
            book, page, collection = node, None, None
        elif page_name:
            if book is None:
                unplaced.append({"line": line_no, "reason": "page with no open book", "name": page_name})
                continue
            if filled != 1:
                unplaced.append({"line": line_no, "reason": "page row with extra names", "name": page_name})
            node = dict(row)
            node["_name"] = page_name
            node["_collections"] = []
            book["_pages"].append(node)
            page, collection = node, None
        elif col_name:
            if page is None:
                unplaced.append({"line": line_no, "reason": "collection with no open page", "name": col_name})
                continue
            if filled != 1:
                unplaced.append({"line": line_no, "reason": "collection row with extra names", "name": col_name})
            node = dict(row)
            node["_name"] = col_name
            node["_slots"] = []
            page["_collections"].append(node)
            collection = node
        elif slot_name:
            if collection is None:
                unplaced.append({"line": line_no, "reason": "slot with no open collection", "name": slot_name})
                continue
            if filled != 1:
                unplaced.append({"line": line_no, "reason": "slot row with extra names", "name": slot_name})
            node = dict(row)
            node["_name"] = slot_name
            collection["_slots"].append(node)
        else:
            unplaced.append({"line": line_no, "reason": "row with no hierarchy name"})
    return books, unplaced


def build_npcs(header, rows):
    collectors = []
    for i in range(0, len(header), 2):
        if i + 1 >= len(header):
            break
        col_name = header[i]
        slot_col = header[i + 1]
        entries = []
        for row in rows:
            collection = (row.get(col_name) or "").strip()
            slot = (row.get(slot_col) or "").strip()
            if collection or slot:
                entries.append((collection, slot))
        collectors.append((col_name, slot_col, entries))
    return collectors


def kind_occupancy(rewards):
    keys = (
        "xpModifier", "is_space_xp", "slot_name", "quest", "item", "stackAmount",
        "grantRandomItem", "grantWeightedRandom", "command", "skill_mod",
        "quest_signal", "crafting_template", "reward_text",
    )
    counts = {key: 0 for key in keys}
    iff_parts = 0
    static_parts = 0
    static_names = []
    for row in rewards:
        for key in keys:
            if (row.get(key) or "").strip():
                counts[key] += 1
        item = (row.get("item") or "").strip()
        if not item:
            continue
        for part in item.split(","):
            part = part.strip()
            if not part:
                continue
            if ".iff" in part or part.startswith("object/"):
                iff_parts += 1
            else:
                static_parts += 1
                static_names.append(part)
    return counts, iff_parts, static_parts, static_names


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dsrc", required=True, help="sys.shared .../datatables root")
    parser.add_argument("--server", required=True, help="sys.server .../datatables root")
    parser.add_argument(
        "--scripts",
        default=os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "bin", "scripts")),
        help="bin/scripts output root",
    )
    args = parser.parse_args()

    collection_path = os.path.join(args.dsrc, "collection", "collection.tab")
    rewards_path = os.path.join(args.server, "collection", "rewards.tab")
    npc_path = os.path.join(args.server, "collection", "collection_npc.tab")
    live_path = os.path.join(args.server, "collection", "collection_live_conversion.tab")
    for path in (collection_path, rewards_path, npc_path, live_path):
        if not os.path.isfile(path):
            raise SystemExit("missing " + path)

    _, collection_rows = read_tab(collection_path)
    _, reward_rows = read_tab(rewards_path)
    npc_header, npc_rows = read_tab(npc_path)
    _, live_rows = read_tab(live_path)

    books, unplaced = build_hierarchy(collection_rows)
    npcs = build_npcs(npc_header, npc_rows)

    n_books = len(books)
    n_pages = sum(len(book["_pages"]) for book in books)
    n_cols = sum(len(page["_collections"]) for book in books for page in book["_pages"])
    n_slots = sum(
        len(col["_slots"])
        for book in books
        for page in book["_pages"]
        for col in page["_collections"]
    )

    dest_dir = os.path.join(args.scripts, "managers", "collections")
    os.makedirs(dest_dir, exist_ok=True)
    dest = os.path.join(dest_dir, "collection_data.lua")

    out = []
    out.append("-- SOURCED -- SOE collection datatables, transcribed by tools/collections/build_collection_data.py")
    out.append("--   datatables/collection/collection.tab (sys.shared)")
    out.append("--   datatables/collection/rewards.tab (sys.server)")
    out.append("--   datatables/collection/collection_npc.tab (sys.server)")
    out.append("--   datatables/collection/collection_live_conversion.tab (sys.server)")
    out.append("-- Hierarchy is carried forward: a bookName row opens a book, a pageName row opens a page")
    out.append("-- under it, a collectionName row opens a collection under that, a slotName row is a leaf.")
    out.append("-- The SOE tables themselves are never committed. Do not hand-edit.")
    out.append("-- Counts: %d books, %d pages, %d collections, %d slots, %d rewards, %d npc rows, %d liveConversion." % (
        n_books, n_pages, n_cols, n_slots, len(reward_rows), len(npc_rows), len(live_rows),
    ))
    out.append("CollectionData = {")
    out.append("	books = {")

    book_by_name = []
    page_by_name = []
    collection_by_name = []
    slot_by_name = []
    slot_by_id = []

    for bi, book in enumerate(books, start=1):
        book_by_name.append((book["_name"], bi))
        out.append("		{")
        out.append("			" + emit_fields(book, False) + ",")
        out.append("			pages = {")
        for pi, page in enumerate(book["_pages"], start=1):
            page_by_name.append((page["_name"], bi, pi))
            out.append("				{")
            out.append("					" + emit_fields(page, False) + ",")
            out.append("					collections = {")
            for ci, col in enumerate(page["_collections"], start=1):
                collection_by_name.append((col["_name"], bi, pi, ci))
                out.append("						{")
                out.append("							" + emit_fields(col, False) + ",")
                out.append("							slots = {")
                for si, slot in enumerate(col["_slots"], start=1):
                    slot_by_name.append((slot["_name"], bi, pi, ci, si))
                    begin_id = to_int(slot.get("beginSlotId"))
                    end_id = to_int(slot.get("endSlotId"), -1)
                    if end_id >= begin_id and end_id != -1:
                        for slot_id in range(begin_id, end_id + 1):
                            slot_by_id.append((slot_id, slot["_name"]))
                    else:
                        slot_by_id.append((begin_id, slot["_name"]))
                    out.append("								{" + emit_fields(slot, True) + "},")
                out.append("							},")
                out.append("						},")
            out.append("					},")
            out.append("				},")
        out.append("			},")
        out.append("		},")
    out.append("	},")

    out.append("	rewards = {")
    for row in reward_rows:
        out.append("		" + emit_reward(row))
    out.append("	},")

    out.append("	npcs = {")
    for col_name, slot_col, entries in npcs:
        out.append("		{")
        out.append("			collector=" + lua_str(col_name) + ", slotColumn=" + lua_str(slot_col) + ",")
        out.append("			entries = {")
        for collection, slot in entries:
            out.append("				{collection=" + lua_str(collection) + ", slot=" + lua_str(slot) + "},")
        out.append("			},")
        out.append("		},")
    out.append("	},")

    out.append("	liveConversion = {")
    for row in live_rows:
        out.append("		{completedCollections=" + lua_str(row.get("completed_collections") or "")
                   + ", slotToGrant=" + lua_str(row.get("slot_to_grant") or "")
                   + ", incrementAmount=" + str(to_int(row.get("increment_amount"), 1)) + "},")
    out.append("	},")

    out.append("	counts = {books=%d, pages=%d, collections=%d, slots=%d, rewards=%d, npcRows=%d, liveConversion=%d}," % (
        n_books, n_pages, n_cols, n_slots, len(reward_rows), len(npc_rows), len(live_rows),
    ))
    if unplaced:
        out.append("	unplaced = {")
        for item in unplaced:
            bits = ["line=" + str(item["line"]), "reason=" + lua_str(item["reason"])]
            if item.get("name"):
                bits.append("name=" + lua_str(item["name"]))
            out.append("		{" + ",".join(bits) + "},")
        out.append("	},")
    else:
        out.append("	unplaced = {},")
    out.append("}")

    out.append("CollectionData.bookByName = {")
    for name, bi in book_by_name:
        out.append("	" + lua_key(name) + "=" + str(bi) + ",")
    out.append("}")
    out.append("CollectionData.pageByName = {")
    for name, bi, pi in page_by_name:
        out.append("	" + lua_key(name) + "={" + str(bi) + "," + str(pi) + "},")
    out.append("}")
    out.append("CollectionData.collectionByName = {")
    for name, bi, pi, ci in collection_by_name:
        out.append("	" + lua_key(name) + "={" + str(bi) + "," + str(pi) + "," + str(ci) + "},")
    out.append("}")
    out.append("CollectionData.slotByName = {")
    for name, bi, pi, ci, si in slot_by_name:
        out.append("	" + lua_key(name) + "={" + str(bi) + "," + str(pi) + "," + str(ci) + "," + str(si) + "},")
    out.append("}")
    out.append("CollectionData.slotById = {")
    for slot_id, name in slot_by_id:
        out.append("	[" + str(slot_id) + "]=" + lua_str(name) + ",")
    out.append("}")
    out.append("CollectionData.rewardsByName = {")
    rewards_by_name = {}
    for i, row in enumerate(reward_rows, start=1):
        key = (row.get("collection_name") or "").strip()
        if not key:
            continue
        rewards_by_name.setdefault(key, []).append(i)
    for key, indices in rewards_by_name.items():
        out.append("	" + lua_key(key) + "={" + ",".join(str(i) for i in indices) + "},")
    out.append("}")
    out.append("return CollectionData")
    out.append("")

    with open(dest, "w", encoding="utf-8", newline="\n") as handle:
        handle.write("\n".join(out))

    occupancy, iff_parts, static_parts, static_names = kind_occupancy(reward_rows)
    print("books", n_books, "pages", n_pages, "collections", n_cols, "slots", n_slots, file=sys.stderr)
    print("rewards", len(reward_rows), "npcRows", len(npc_rows), "liveConversion", len(live_rows), file=sys.stderr)
    print("unplaced", len(unplaced), file=sys.stderr)
    print("reward occupancy", occupancy, file=sys.stderr)
    print("item iff parts", iff_parts, "static parts", static_parts, file=sys.stderr)
    print("->", dest, file=sys.stderr)


if __name__ == "__main__":
    main()
