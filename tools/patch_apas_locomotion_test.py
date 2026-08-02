import hashlib
import struct
import sys
from pathlib import Path

import pefile


EXPECTED_SHA256 = "4976269de1dbc26f2f79aaa3920195a672c5f5b2c994ba8b4116b1727ab76af3"
IMAGE_BASE = 0x00400000
TRANSFORM_COMPARE_VA = 0x00AB9A60
GET_TERRAIN_VA = 0x00B5B720
APAS_QUERY_VA = 0x00B5CE10
HOOK_SITES = (0x0062A7E3, 0x0062A829)
SECTION_NAME = b".apas\0\0\0"


def align(value, alignment):
    return (value + alignment - 1) & ~(alignment - 1)


def rel32(source_after_instruction, target):
    return struct.pack("<i", target - source_after_instruction)


def call_bytes(site, target):
    return b"\xE8" + rel32(site + 5, target)


def emit_call(code, stub_va, target):
    site = stub_va + len(code)
    code += b"\xE8" + rel32(site + 5, target)


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: patch_apas_locomotion_test.py <SWGEmu_APAS_test.exe>")

    path = Path(sys.argv[1]).resolve()
    original = path.read_bytes()
    digest = hashlib.sha256(original).hexdigest()
    if digest != EXPECTED_SHA256:
        raise SystemExit(f"refusing: unexpected SHA-256 {digest}")

    backup = path.with_name(path.name + ".pre_apas_patch.bak")
    if not backup.exists() or hashlib.sha256(backup.read_bytes()).hexdigest() != EXPECTED_SHA256:
        raise SystemExit("refusing: verified original backup is missing")

    pe = pefile.PE(data=original)
    for site in HOOK_SITES:
        off = pe.get_offset_from_rva(site - IMAGE_BASE)
        if original[off:off + 5] != call_bytes(site, TRANSFORM_COMPARE_VA):
            raise SystemExit(f"refusing: call bytes mismatch at 0x{site:08X}")

    last = pe.sections[-1]
    section_alignment = pe.OPTIONAL_HEADER.SectionAlignment
    file_alignment = pe.OPTIONAL_HEADER.FileAlignment
    new_rva = align(last.VirtualAddress + max(last.Misc_VirtualSize, last.SizeOfRawData), section_alignment)
    stub_va = IMAGE_BASE + new_rva
    new_raw = align(len(original), file_alignment)

    code = bytearray()
    code += b"\x55\x8B\xEC\x56\x57"          # frame; save esi, edi
    code += b"\x8B\xF1"                        # esi = proposed Transform
    code += b"\xFF\x75\x10\xFF\x75\x0C\xFF\x75\x08"
    code += b"\x8B\xCE"                        # ecx = proposed Transform
    emit_call(code, stub_va, TRANSFORM_COMPARE_VA)
    code += b"\x84\xC0"                        # unchanged? preserve original result
    jne_offset = len(code)
    code += b"\x75\x00"                        # jne return_result
    emit_call(code, stub_va, GET_TERRAIN_VA)
    code += b"\x85\xC0"
    no_terrain_offset = len(code)
    code += b"\x74\x00"                        # no terrain -> allow
    code += b"\x83\xEC\x0C"                  # Vector on stack
    code += b"\xD9\x46\x0C\xD9\x1C\x24"  # x
    code += b"\xD9\x46\x1C\xD9\x5C\x24\x04"  # y
    code += b"\xD9\x46\x2C\xD9\x5C\x24\x08"  # z
    code += b"\x54\x8B\xC8"                  # push vector; ecx = TerrainObject
    emit_call(code, stub_va, APAS_QUERY_VA)
    code += b"\x83\xC4\x0C\x84\xC0"
    passable_offset = len(code)
    code += b"\x75\x00"                        # passable -> allow
    code += b"\x8B\xFE\x8B\x75\x08\xB9\x0C\x00\x00\x00\xF3\xA5"
    code += b"\xB0\x01"                        # blocked: report unchanged
    return_offset = len(code)
    code += b"\x5F\x5E\x5D\xC2\x0C\x00"
    allow_offset = len(code)
    code += b"\x32\xC0"                        # changed and allowed
    code += b"\xEB" + bytes([(return_offset - (len(code) + 2)) & 0xFF])

    def patch_short_jump(op_offset, target_offset):
        displacement = target_offset - (op_offset + 2)
        if not -128 <= displacement <= 127:
            raise SystemExit("internal error: short jump out of range")
        code[op_offset + 1] = displacement & 0xFF

    patch_short_jump(jne_offset, return_offset)
    patch_short_jump(no_terrain_offset, allow_offset)
    patch_short_jump(passable_offset, allow_offset)

    section_table = pe.DOS_HEADER.e_lfanew + 4 + pe.FILE_HEADER.sizeof() + pe.FILE_HEADER.SizeOfOptionalHeader
    new_header_offset = section_table + pe.FILE_HEADER.NumberOfSections * 40
    if new_header_offset + 40 > pe.sections[0].PointerToRawData:
        raise SystemExit("refusing: no room for another section header")

    raw_size = align(len(code), file_alignment)
    output = bytearray(original)
    output.extend(b"\0" * (new_raw - len(output)))
    output.extend(code)
    output.extend(b"\0" * (raw_size - len(code)))
    output[new_header_offset:new_header_offset + 40] = struct.pack(
        "<8sIIIIIIHHI", SECTION_NAME, len(code), new_rva, raw_size, new_raw,
        0, 0, 0, 0, 0x60000020,
    )
    struct.pack_into("<H", output, pe.DOS_HEADER.e_lfanew + 6, pe.FILE_HEADER.NumberOfSections + 1)
    struct.pack_into(
        "<I", output, pe.OPTIONAL_HEADER.get_field_absolute_offset("SizeOfImage"),
        align(new_rva + len(code), section_alignment),
    )
    for site in HOOK_SITES:
        off = pe.get_offset_from_rva(site - IMAGE_BASE)
        output[off:off + 5] = call_bytes(site, stub_va)

    path.write_bytes(output)
    patched = hashlib.sha256(output).hexdigest()
    verify = pefile.PE(str(path))
    if b".apas" not in [s.Name.rstrip(b"\0") for s in verify.sections]:
        raise SystemExit("verification failed: .apas section missing")
    print(f"original_sha256={digest}")
    print(f"patched_sha256={patched}")
    print(f"stub_va=0x{stub_va:08X}")
    print("hook_sites=" + ",".join(f"0x{x:08X}" for x in HOOK_SITES))


if __name__ == "__main__":
    main()
