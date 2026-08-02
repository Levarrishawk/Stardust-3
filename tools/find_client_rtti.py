import struct
import sys

import pefile


path, term = sys.argv[1], sys.argv[2].encode("ascii")
pe = pefile.PE(path, fast_load=True)
data = open(path, "rb").read()
base = pe.OPTIONAL_HEADER.ImageBase


def va(off):
    return base + pe.get_rva_from_offset(off)


def off(address):
    return pe.get_offset_from_rva(address - base)


def u32(address):
    return struct.unpack_from("<I", data, off(address))[0]


def refs(address):
    needle = struct.pack("<I", address)
    pos = 0
    while True:
        pos = data.find(needle, pos)
        if pos < 0:
            return
        try:
            yield va(pos)
        except Exception:
            pass
        pos += 1


pos = 0
while True:
    pos = data.find(term, pos)
    if pos < 0:
        break
    begin = data.rfind(b"\0", max(0, pos - 256), pos) + 1
    end = data.find(b"\0", pos)
    text = data[begin:end].decode("ascii", "replace") if end >= 0 else ""
    print(f"STRING VA={va(begin):08X} TEXT={text}")
    if text.startswith(".?") and begin >= 8:
        typedesc = va(begin - 8)
        for tdref in refs(typedesc):
            col = tdref - 12
            try:
                if u32(col) != 0:
                    continue
            except Exception:
                continue
            for colref in refs(col):
                vt = colref + 4
                slots = []
                for i in range(80):
                    try:
                        ptr = u32(vt + i*4)
                    except Exception:
                        break
                    if ptr < base or ptr >= base + pe.OPTIONAL_HEADER.SizeOfImage:
                        break
                    slots.append(ptr)
                print(f" RTTI TD={typedesc:08X} COL={col:08X} VTABLE={vt:08X} SLOTS={len(slots)}")
                for i, ptr in enumerate(slots):
                    print(f"  SLOT[{i:02d}]={ptr:08X}")
    pos += 1
