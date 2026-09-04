#!/usr/bin/env python3
"""quest_crc_string_table.iff — unpack to a name list, or pack a name list into the client's CSTB table.

Layout (parsed from the shipped table, journal-client-capability.md §7.1):
  FORM CSTB / FORM 0000 / DATA(uint32 count) / CRCT(count x uint32 crc) / STRT(count x uint32 offset into STNG) / STNG(NUL names)
CRC = SWG's Crc::calculate (the same function Core3's String::hashCode uses); verified against every shipped entry by `verify`.

  crc_table.py unpack <table.iff> <names.txt>          # one name per line, in table order
  crc_table.py verify <table.iff>                      # recompute every CRC and compare with CRCT
  crc_table.py pack <names.txt> <table.iff>            # names sorted by CRC (the shipped table's order), duplicates dropped
  crc_table.py add <in.iff> <out.iff> name [name ...]  # append names to a shipped table and repack
"""
import struct, sys

_TABLE = []
for i in range(256):
    c = i << 24
    for _ in range(8):
        c = ((c << 1) ^ 0x04C11DB7) & 0xFFFFFFFF if c & 0x80000000 else (c << 1) & 0xFFFFFFFF
    _TABLE.append(c)


def swg_crc(s: str) -> int:
    """SWG Crc::calculate — MSB-first CRC-32 with the IEEE polynomial, init 0xFFFFFFFF, final NOT."""
    crc = 0xFFFFFFFF
    for b in s.encode("ascii"):
        crc = ((crc << 8) & 0xFFFFFFFF) ^ _TABLE[((crc >> 24) ^ b) & 0xFF]
    return (~crc) & 0xFFFFFFFF


def _chunks(buf, pos, end):
    while pos < end:
        tag = buf[pos:pos + 4].decode("ascii")
        size = struct.unpack(">I", buf[pos + 4:pos + 8])[0]
        yield tag, pos + 8, pos + 8 + size
        pos += 8 + size


def unpack(path):
    buf = open(path, "rb").read()
    assert buf[:4] == b"FORM" and buf[8:12] == b"CSTB", "not a CSTB form"
    inner = struct.unpack(">I", buf[4:8])[0]
    assert buf[12:16] == b"FORM" and buf[20:24] == b"0000"
    chunks = {}
    for tag, s, e in _chunks(buf, 24, len(buf)):
        chunks[tag] = buf[s:e]
    count = struct.unpack("<I", chunks["DATA"][:4])[0]
    crcs = struct.unpack("<%dI" % count, chunks["CRCT"][:4 * count])
    offs = struct.unpack("<%dI" % count, chunks["STRT"][:4 * count])
    stng = chunks["STNG"]
    names = []
    for o in offs:
        e = stng.index(b"\0", o)
        names.append(stng[o:e].decode("ascii"))
    return list(zip(crcs, names))


def pack(names, path):
    seen = set(); rows = []
    for n in names:
        n = n.strip()
        if not n or n in seen:
            continue
        seen.add(n); rows.append((swg_crc(n), n))
    rows.sort()
    stng = bytearray(); offs = []
    for _, n in rows:
        offs.append(len(stng)); stng += n.encode("ascii") + b"\0"
    def chunk(tag, data):
        return tag.encode("ascii") + struct.pack(">I", len(data)) + data
    inner = chunk("DATA", struct.pack("<I", len(rows))) + chunk("CRCT", struct.pack("<%dI" % len(rows), *[c for c, _ in rows])) \
        + chunk("STRT", struct.pack("<%dI" % len(rows), *offs)) + chunk("STNG", bytes(stng))
    form0 = b"FORM" + struct.pack(">I", len(inner) + 4) + b"0000" + inner
    out = b"FORM" + struct.pack(">I", len(form0) + 4) + b"CSTB" + form0
    open(path, "wb").write(out)
    return len(rows), len(out)


if __name__ == "__main__":
    cmd = sys.argv[1]
    if cmd == "unpack":
        rows = unpack(sys.argv[2])
        open(sys.argv[3], "w", newline="\n").write("\n".join(n for _, n in rows) + "\n")
        print("unpacked", len(rows), "names")
    elif cmd == "verify":
        rows = unpack(sys.argv[2]); bad = [(hex(c), n, hex(swg_crc(n))) for c, n in rows if swg_crc(n) != c]
        srt = [c for c, _ in rows] == sorted(c for c, _ in rows)
        print("entries", len(rows), "crc mismatches", len(bad), "sorted-by-crc", srt); print(bad[:5])
    elif cmd == "pack":
        print("packed", *pack(open(sys.argv[2]).read().splitlines(), sys.argv[3]))
    elif cmd == "add":
        rows = unpack(sys.argv[2]); names = [n for _, n in rows] + sys.argv[4:]
        print("packed", *pack(names, sys.argv[3]))
