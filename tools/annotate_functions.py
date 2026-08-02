import string
import sys

import pefile
from capstone import Cs, CS_ARCH_X86, CS_MODE_32
from capstone.x86 import X86_OP_IMM, X86_OP_MEM


path = sys.argv[1]
addresses = [int(x, 16) for x in sys.argv[2:]]
pe = pefile.PE(path, fast_load=True)
data = open(path, "rb").read()
base = pe.OPTIONAL_HEADER.ImageBase
end_image = base + pe.OPTIONAL_HEADER.SizeOfImage
md = Cs(CS_ARCH_X86, CS_MODE_32)
md.detail = True
md.skipdata = True


def get_blob(va, size=0x8000):
    try:
        off = pe.get_offset_from_rva(va-base)
    except Exception:
        return b""
    return data[off:off+size]


def ascii_at(va):
    if not (base <= va < end_image):
        return None
    blob = get_blob(va, 300)
    if not blob:
        return None
    end = blob.find(b"\0")
    if end < 4:
        return None
    raw = blob[:end]
    if all(chr(c) in string.printable and c not in (10,13) for c in raw):
        return raw.decode("ascii", "replace")


for start in addresses:
    print(f"\nFUNCTION={start:08X}")
    count = 0
    strings_seen = set()
    calls = []
    for ins in md.disasm(get_blob(start), start):
        count += 1
        if ins.mnemonic == "call" and ins.operands and ins.operands[0].type == X86_OP_IMM:
            calls.append((ins.address, ins.operands[0].imm))
        for op in ins.operands:
            candidates = []
            if op.type == X86_OP_IMM:
                candidates.append(op.imm & 0xFFFFFFFF)
            elif op.type == X86_OP_MEM and op.mem.base == 0 and op.mem.index == 0:
                candidates.append(op.mem.disp & 0xFFFFFFFF)
            for candidate in candidates:
                text = ascii_at(candidate)
                if text and text not in strings_seen:
                    strings_seen.add(text)
                    print(f" STRING at={ins.address:08X} VA={candidate:08X} {text}")
        if ins.mnemonic.startswith("ret"):
            break
        if count >= 5000:
            break
    print(f" INSNS={count} DIRECT_CALLS={len(calls)}")
    if count <= 200:
        shown = 0
        for ins in md.disasm(get_blob(start), start):
            print(f"  {ins.address:08X} {ins.mnemonic:8} {ins.op_str}")
            shown += 1
            if ins.mnemonic.startswith("ret") or shown >= count:
                break
    for site,target in calls:
        print(f" CALL at={site:08X} target={target:08X}")

if "--xrefs" in sys.argv:
    print("\nDIRECT CALL XREFS")
    targets = set(addresses)
    for section in pe.sections:
        if not (section.Characteristics & 0x20000000):
            continue
        blob = section.get_data()
        section_base = base + section.VirtualAddress
        for ins in md.disasm(blob, section_base):
            if ins.mnemonic == "call" and ins.operands and ins.operands[0].type == X86_OP_IMM:
                target = ins.operands[0].imm & 0xFFFFFFFF
                if target in targets:
                    print(f" target={target:08X} caller={ins.address:08X}")
