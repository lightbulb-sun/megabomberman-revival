import struct

FILENAME_IN = 'hack.asm.bin'
FILENAME_OUT = 'hack.md'

CHECKSUM_OFFSET = 0x18e

with open(FILENAME_IN, 'rb') as inf:
    rom = inf.read()

total = 0
for (word, ) in struct.iter_unpack('>H', rom[0x200:]):
    total += word

total &= 0xffff
print(f'Writing checksum 0x{total:04x} at offset 0x{CHECKSUM_OFFSET:04x} to file {FILENAME_OUT}')

rom = rom[:CHECKSUM_OFFSET] + total.to_bytes(2, 'big') + rom[CHECKSUM_OFFSET+2:]

with open(FILENAME_OUT, 'wb') as outf:
    outf.write(rom)
