import difflib
import struct
import sys

import pefile
from capstone import Cs, CS_ARCH_X86, CS_MODE_32


def load(path):
    pe = pefile.PE(path, fast_load=True)
    data = open(path, "rb").read()
    md = Cs(CS_ARCH_X86, CS_MODE_32)
    md.skipdata = True
    return pe, data, md


def blob(pe, data, va, size=0x3000):
    off = pe.get_offset_from_rva(va - pe.OPTIONAL_HEADER.ImageBase)
    return data[off:off+size]


def sequence(pe, data, md, va):
    out = []
    for ins in md.disasm(blob(pe, data, va), va):
        if ins.mnemonic == ".byte":
            break
        # Keep branch/call kind and broad operand shape, discard version-specific addresses.
        shape = ins.mnemonic
        if "ptr" in ins.op_str:
            shape += ":mem"
        elif ins.op_str.startswith("0x"):
            shape += ":imm"
        elif ins.op_str:
            shape += ":reg"
        out.append(shape)
        if ins.mnemonic.startswith("ret"):
            break
        if len(out) >= 1200:
            break
    return out


stardust_slots = [
0x006295D0,0x0062A700,0x00B3D360,0x00B3D350,0x00B3D1F0,0x00629750,
0x006E5870,0x00B4B070,0x0062AA10,0x0062C980,0x0062CA20,0x006E4AC0,
0x0062A890,0x00639CF0,0x0062A940,0x0062A8A0,0x0062CFE0,0x0062FCC0,
0x0062DA20,0x0062FD90,0x0062DCE0,0x0062FE60,0x0062DFA0,0x0062FF30,
0x0062E260,0x00630000,0x0062E520,0x006300D0,0x0062E7E0,0x006301A0,
0x0062EAA0,0x00630270,0x0062F0B0,0x00630340,0x0062F6C0]
nge_slots = [
0x0073BF40,0x00736740,0x00A0B6C0,0x00A0B6B0,0x00A0B6E0,0x00A0B6D0,
0x00A0B700,0x00A0B6F0,0x00A0B5A0,0x0073FCC0,0x0074AEA0,0x00A19980,
0x00742160,0x00735120,0x007351E0,0x0074AB20,0x00734F00,0x00667100,
0x00735000,0x00736920,0x007355D0,0x0073F080,0x00739E80,0x0073F0A0,
0x00739F40,0x0073F0C0,0x0073A000,0x0073F0E0,0x0073A0C0,0x0073F100,
0x0073A180,0x0073F120,0x0073A240,0x0073F140,0x0073A300,0x0073F160,
0x0073A3C0,0x0073F180,0x0073A480,0x0073F1A0,0x0073A540,0x0073F1C0,
0x0073A600,0x0073F1E0,0x0073A6C0]

s_pe, s_data, s_md = load(sys.argv[1])
n_pe, n_data, n_md = load(sys.argv[2])
s_seq = {a: sequence(s_pe,s_data,s_md,a) for a in stardust_slots}
n_seq = {a: sequence(n_pe,n_data,n_md,a) for a in nge_slots}

for sa in stardust_slots:
    scores = []
    for na in nge_slots:
        score = difflib.SequenceMatcher(None, s_seq[sa], n_seq[na], autojunk=False).ratio()
        scores.append((score, na))
    scores.sort(reverse=True)
    print(f"S={sa:08X} LEN={len(s_seq[sa]):4d} " + " ".join(f"N={na:08X}:{score:.3f}:L{len(n_seq[na])}" for score,na in scores[:4]))
