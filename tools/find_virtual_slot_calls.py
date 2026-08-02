import sys
from collections import deque

import pefile
from capstone import Cs, CS_ARCH_X86, CS_MODE_32
from capstone.x86 import X86_OP_MEM


path = sys.argv[1]
slot = int(sys.argv[2], 0)
pe = pefile.PE(path, fast_load=True)
base = pe.OPTIONAL_HEADER.ImageBase
md = Cs(CS_ARCH_X86, CS_MODE_32)
md.detail = True
md.skipdata = True

for section in pe.sections:
    if not (section.Characteristics & 0x20000000):
        continue
    history = deque(maxlen=10)
    start = base + section.VirtualAddress
    for insn in md.disasm(section.get_data(), start):
        matched = False
        if insn.mnemonic == "call" and insn.operands:
            op = insn.operands[0]
            matched = op.type == X86_OP_MEM and (op.mem.disp & 0xFFFFFFFF) == slot
        if matched:
            print(f"\nCALL_SITE={insn.address:08X}")
            for prior in history:
                print(f" {prior.address:08X} {prior.mnemonic:8} {prior.op_str}")
            print(f" {insn.address:08X} {insn.mnemonic:8} {insn.op_str}")
        history.append(insn)
