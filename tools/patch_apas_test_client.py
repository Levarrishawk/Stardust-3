import hashlib
import shutil
import struct
import sys
from pathlib import Path

import pefile


EXPECTED_SHA256 = "4976269de1dbc26f2f79aaa3920195a672c5f5b2c994ba8b4116b1727ab76af3"
CALL_SITE_VA = 0x006E4E9C
BOUNDS_CHECK_VA = 0x00B5CD90
APAS_CHECK_VA = 0x00B5CE10
SECTION_NAME = b".apas\0\0\0"


def align(value, alignment):
    return (value + alignment - 1) & ~(alignment - 1)


def rel32(source_after_instruction, target):
    return struct.pack("<i", target - source_after_instruction)


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: patch_apas_test_client.py <SWGEmu_APAS_test.exe>")

    path = Path(sys.argv[1]).resolve()
    original = path.read_bytes()
    digest = hashlib.sha256(original).hexdigest()
    if digest != EXPECTED_SHA256:
        raise SystemExit(f"refusing: unexpected SHA-256 {digest}")

    pe = pefile.PE(data=original)
    image_base = pe.OPTIONAL_HEADER.ImageBase
    call_offset = pe.get_offset_from_rva(CALL_SITE_VA - image_base)
    expected_call = b"\xE8" + rel32(CALL_SITE_VA + 5, BOUNDS_CHECK_VA)
    if original[call_offset:call_offset + 5] != expected_call:
        raise SystemExit("refusing: original bounds-check call bytes do not match")

    file_alignment = pe.OPTIONAL_HEADER.FileAlignment
    section_alignment = pe.OPTIONAL_HEADER.SectionAlignment
    last = pe.sections[-1]
    new_rva = align(last.VirtualAddress + max(last.Misc_VirtualSize, last.SizeOfRawData), section_alignment)
    new_va = image_base + new_rva
    new_raw = align(len(original), file_alignment)

    # Preserve ECX and the Vector argument, require both the original bounds
    # validation and the existing APAS passability query, then return bool AL.
    stub = bytearray()
    stub += b"\x51"                         # push ecx
    stub += b"\xFF\x74\x24\x08"         # push dword ptr [esp+8]
    stub += b"\xE8" + rel32(new_va + len(stub) + 5, BOUNDS_CHECK_VA)
    stub += b"\x84\xC0"                   # test al, al
    stub += b"\x74\x0D"                   # jz bounds_failed
    stub += b"\x59"                         # pop ecx
    stub += b"\xFF\x74\x24\x04"         # push dword ptr [esp+4]
    stub += b"\xE8" + rel32(new_va + len(stub) + 5, APAS_CHECK_VA)
    stub += b"\xC2\x04\x00"             # ret 4
    stub += b"\x59\x32\xC0\xC2\x04\x00"  # bounds_failed

    section_table = pe.DOS_HEADER.e_lfanew + 4 + pe.FILE_HEADER.sizeof() + pe.FILE_HEADER.SizeOfOptionalHeader
    new_header_offset = section_table + pe.FILE_HEADER.NumberOfSections * 40
    if new_header_offset + 40 > pe.sections[0].PointerToRawData:
        raise SystemExit("refusing: no room for another PE section header")

    raw_size = align(len(stub), file_alignment)
    output = bytearray(original)
    if len(output) < new_raw:
        output.extend(b"\0" * (new_raw - len(output)))
    output.extend(stub)
    output.extend(b"\0" * (raw_size - len(stub)))

    section_header = struct.pack(
        "<8sIIIIIIHHI",
        SECTION_NAME,
        len(stub),
        new_rva,
        raw_size,
        new_raw,
        0, 0, 0, 0,
        0x60000020,
    )
    output[new_header_offset:new_header_offset + 40] = section_header
    struct.pack_into("<H", output, pe.DOS_HEADER.e_lfanew + 6, pe.FILE_HEADER.NumberOfSections + 1)
    size_of_image_offset = pe.OPTIONAL_HEADER.get_field_absolute_offset("SizeOfImage")
    struct.pack_into("<I", output, size_of_image_offset, align(new_rva + len(stub), section_alignment))
    output[call_offset:call_offset + 5] = b"\xE8" + rel32(CALL_SITE_VA + 5, new_va)

    backup = path.with_name(path.name + ".pre_apas_patch.bak")
    if backup.exists():
        raise SystemExit(f"refusing: backup already exists: {backup}")
    shutil.copy2(path, backup)
    path.write_bytes(output)

    patched_hash = hashlib.sha256(output).hexdigest()
    verify = pefile.PE(str(path), fast_load=False)
    names = [s.Name.rstrip(b"\0") for s in verify.sections]
    if b".apas" not in names:
        raise SystemExit("verification failed: .apas section is absent")
    print(f"backup={backup}")
    print(f"original_sha256={digest}")
    print(f"patched_sha256={patched_hash}")
    print(f"stub_va=0x{new_va:08X}")
    print(f"call_site_va=0x{CALL_SITE_VA:08X}")


if __name__ == "__main__":
    main()
