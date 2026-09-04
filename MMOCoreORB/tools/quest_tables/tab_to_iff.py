#!/usr/bin/env python3
"""tab_to_iff.py -- SWG DATATABLE (.tab) -> IFF DTII writer, plus the inverse dumper.

The inverse of C:\\swg-extract\\iff_datatable.py.  Layout, confirmed byte-for-byte
against datatables/questtask/quest/test_nothing.iff (428 B) out of
mtg_patch_013_configurable_02.tre:

    FORM <be32 size> 'DTII'
      FORM <be32 size> '0001'
        COLS <be32 size>  u32le ncols, then ncols NUL-terminated column names
        TYPE <be32 size>  ncols NUL-terminated type strings (verbatim, incl. defaults)
        ROWS <be32 size>  u32le nrows, then packed cells, row-major

Chunk headers are BIG-endian, cell payloads are LITTLE-endian, and SWG's IFF does
NOT pad odd-sized chunks.

Cell serialisation follows Core3's reader exactly -- MMOCoreORB/src/templates/
datatables/DataTableIff.cpp:69-95 -- because Core3 is the consumer for any loose
file dropped under MMOCoreORB/bin/:

    'f'                               -> float32 LE          (DataTableCellFloat)
    's'                               -> NUL-terminated str  (DataTableCellString)
    'h'                               -> uint32  LE          (DataTableCellHex)
    'b'                               -> int32   LE          (DataTableCellBinary)
    'c' 'p' 'e' 'z' 'i' 'I' + default -> int32   LE          (DataTableCellInt)

  ^ NOTE the switch is CASE SENSITIVE.  'I' is handled as int on purpose; every
    other uppercase char -- notably 'S', used by the leak's questlist/questtask
    reward-stat columns DAMAGE / EFFICIENCY / ELEMENTAL_VALUE / SPEED -- falls to
    `default` and would be read as a 4-byte int.  No shipped .iff in the 49 client
    TREs uses 'S', so its real on-disk width is NOT determined by evidence.  This
    writer therefore lowercases alpha type letters by default (--verbatim-types
    turns that off), which makes 'S' serialise and deserialise as a string on both
    halves.  Flagged, not guessed.

Type strings may carry a default and/or an enum map, e.g. "i[0]", "b[1]", "f[1.0]",
"e(none=0,complete=1,clear=2)[none]".  Only the first char selects the width; the
parenthesised map converts an enum cell NAME to its int; the bracketed default
fills an EMPTY cell.

Usage:
  tab_to_iff.py pack   <in.tab> <out.iff> [--verbatim-types]
  tab_to_iff.py unpack <in.iff> <out.tab>            # iff -> tab (round-trip source)
  tab_to_iff.py roundtrip <file.iff> [...]           # iff -> tab -> iff, byte compare
"""
import os, re, struct, sys, tempfile

NUL = b"\x00"


# ---------------------------------------------------------------- type parsing
def parse_type(t):
    """'e(a=0,b=1)[a]' -> (kind_char, enum_map_or_None, default_str_or_None, raw)"""
    raw = t
    enum = None
    m = re.search(r"\(([^)]*)\)", t)
    if m:
        enum = {}
        for pair in m.group(1).split(","):
            if "=" in pair:
                k, v = pair.split("=", 1)
                enum[k.strip()] = int(v.strip())
        t = t[: m.start()] + t[m.end():]
    default = None
    m = re.search(r"\[([^\]]*)\]", t)
    if m:
        default = m.group(1)
        t = t[: m.start()] + t[m.end():]
    kind = t[0] if t else "s"
    return kind, enum, default, raw


def width_kind(kind):
    """Which serialiser Core3 will pick for this type char."""
    if kind == "f":
        return "f"
    if kind == "s":
        return "s"
    if kind == "h":
        return "h"
    if kind == "b":
        return "i"          # DataTableCellBinary is a 4-byte signed int on the wire
    return "i"              # 'c','p','e','z','i','I' and default


def lower_types(types):
    out = []
    for t in types:
        if t and t[0].isalpha():
            t = t[0].lower() + t[1:]
        out.append(t)
    return out


# ---------------------------------------------------------------- IFF plumbing
def chunk(tag, payload):
    return tag + struct.pack(">I", len(payload)) + payload


def form(formtype, payload):
    return chunk(b"FORM", formtype + payload)


def walk(buf, pos, end, out):
    while pos + 8 <= end:
        tag = buf[pos:pos + 4]
        size = struct.unpack_from(">I", buf, pos + 4)[0]
        pos += 8
        be = pos + size
        if tag == b"FORM":
            walk(buf, pos + 4, be, out)
        else:
            out.append((tag, buf[pos:be]))
        pos = be          # no even-padding in SWG IFF
    return out


def cstrings(buf, n):
    out, i = [], 0
    for _ in range(n):
        j = buf.find(NUL, i)
        if j < 0:
            raise ValueError("ran out of NUL-terminated strings")
        out.append(buf[i:j].decode("latin-1"))
        i = j + 1
    return out


# ---------------------------------------------------------------- iff -> table
def read_iff(path):
    b = open(path, "rb").read()
    ch = {}
    for tag, data in walk(b, 0, len(b), []):
        ch.setdefault(tag, data)
    ncols = struct.unpack_from("<I", ch[b"COLS"], 0)[0]
    cols = cstrings(ch[b"COLS"][4:], ncols)
    types = cstrings(ch[b"TYPE"], ncols)
    rows_buf = ch[b"ROWS"]
    nrows = struct.unpack_from("<I", rows_buf, 0)[0]
    p = 4
    kinds = [width_kind(parse_type(t)[0]) for t in types]
    rows = []
    for _ in range(nrows):
        row = []
        for k in kinds:
            if k == "s":
                j = rows_buf.find(NUL, p)
                row.append(rows_buf[p:j].decode("latin-1"))
                p = j + 1
            elif k == "f":
                row.append(struct.unpack_from("<f", rows_buf, p)[0]); p += 4
            elif k == "h":
                row.append(struct.unpack_from("<I", rows_buf, p)[0]); p += 4
            else:
                row.append(struct.unpack_from("<i", rows_buf, p)[0]); p += 4
        rows.append(row)
    if p != len(rows_buf):
        raise ValueError("%s: %d trailing bytes in ROWS" % (path, len(rows_buf) - p))
    return cols, types, rows


def write_tab(path, cols, types, rows):
    kinds = [width_kind(parse_type(t)[0]) for t in types]
    out = ["\t".join(cols), "\t".join(types)]
    for row in rows:
        cells = []
        for v, k in zip(row, kinds):
            if k == "s":
                if "\t" in v or "\n" in v:
                    raise ValueError("cell contains a tab/newline; .tab cannot hold it")
                cells.append(v)
            elif k == "f":
                cells.append(repr(v))          # repr round-trips a Python float exactly
            else:
                cells.append(str(v))
        out.append("\t".join(cells))
    open(path, "w", encoding="latin-1", newline="\n").write("\n".join(out) + "\n")


# ---------------------------------------------------------------- table -> iff
def read_tab(path):
    txt = open(path, "r", encoding="latin-1", newline="").read()
    lines = txt.replace("\r\n", "\n").replace("\r", "\n").split("\n")
    while lines and lines[-1] == "":
        lines.pop()
    if len(lines) < 2:
        raise ValueError("%s: need at least a name row and a type row" % path)
    cols = lines[0].split("\t")
    types = lines[1].split("\t")
    if len(types) != len(cols):
        raise ValueError("%s: %d names vs %d types" % (path, len(cols), len(types)))
    rows = []
    for ln, line in enumerate(lines[2:], start=3):
        if line == "":
            continue
        cells = line.split("\t")
        if len(cells) < len(cols):
            cells += [""] * (len(cols) - len(cells))     # trailing empties get eaten
        elif len(cells) > len(cols):
            raise ValueError("%s:%d: %d cells for %d columns"
                             % (path, ln, len(cells), len(cols)))
        rows.append(cells)
    return cols, types, rows


def pack(cols, types, rows, verbatim=False):
    if not verbatim:
        types = lower_types(types)
    parsed = [parse_type(t) for t in types]
    cols_payload = struct.pack("<I", len(cols)) + b"".join(
        c.encode("latin-1") + NUL for c in cols)
    type_payload = b"".join(t.encode("latin-1") + NUL for t in types)

    body = bytearray(struct.pack("<I", len(rows)))
    for row in rows:
        for ci, cell in enumerate(row):
            kind, enum, default, _ = parsed[ci]
            k = width_kind(kind)
            v = cell
            if isinstance(v, str) and v.strip() == "" and default is not None:
                v = default
            if k == "s":
                s = v if isinstance(v, str) else str(v)
                body += s.encode("latin-1") + NUL
            elif k == "f":
                body += struct.pack("<f", float(v) if str(v).strip() != "" else 0.0)
            elif k == "h":
                if isinstance(v, str):
                    s = v.strip()
                    v = int(s, 16) if s[:2].lower() == "0x" else (int(s) if s else 0)
                body += struct.pack("<I", int(v) & 0xFFFFFFFF)
            else:
                if isinstance(v, str):
                    s = v.strip()
                    if enum and s in enum:
                        v = enum[s]
                    elif s == "":
                        v = 0
                    elif s[:2].lower() == "0x":
                        v = int(s, 16)
                    else:
                        v = int(float(s)) if ("." in s or "e" in s.lower()) else int(s)
                body += struct.pack("<i", int(v))
    inner = (chunk(b"COLS", cols_payload)
             + chunk(b"TYPE", type_payload)
             + chunk(b"ROWS", bytes(body)))
    return form(b"DTII", form(b"0001", inner))


# ---------------------------------------------------------------- entry points
def cmd_pack(argv):
    verbatim = "--verbatim-types" in argv
    argv = [a for a in argv if not a.startswith("--")]
    cols, types, rows = read_tab(argv[0])
    open(argv[1], "wb").write(pack(cols, types, rows, verbatim))
    print("%s -> %s  (%d rows x %d cols, %d bytes)"
          % (argv[0], argv[1], len(rows), len(cols), os.path.getsize(argv[1])))


def cmd_unpack(argv):
    cols, types, rows = read_iff(argv[0])
    write_tab(argv[1], cols, types, rows)
    print("%s -> %s  (%d rows x %d cols)" % (argv[0], argv[1], len(rows), len(cols)))


def cmd_roundtrip(argv):
    ok = bad = 0
    for p in argv:
        orig = open(p, "rb").read()
        try:
            cols, types, rows = read_iff(p)
            with tempfile.NamedTemporaryFile("w", suffix=".tab", delete=False) as tf:
                tmp = tf.name
            write_tab(tmp, cols, types, rows)
            c2, t2, r2 = read_tab(tmp)
            rebuilt = pack(c2, t2, r2, verbatim=True)
            os.unlink(tmp)
        except Exception as e:
            print("ERR   %s: %s" % (p, e)); bad += 1; continue
        if rebuilt == orig:
            ok += 1
        else:
            bad += 1
            d = next((i for i in range(min(len(orig), len(rebuilt)))
                      if orig[i] != rebuilt[i]), min(len(orig), len(rebuilt)))
            print("DIFF  %s  (orig %dB, rebuilt %dB, first differing byte at 0x%x)"
                  % (p, len(orig), len(rebuilt), d))
    print("round-trip: %d byte-identical, %d differing" % (ok, bad))
    return 1 if bad else 0


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(2)
    cmd, rest = sys.argv[1], sys.argv[2:]
    sys.exit({"pack": cmd_pack, "unpack": cmd_unpack,
              "roundtrip": cmd_roundtrip}[cmd](rest) or 0)
