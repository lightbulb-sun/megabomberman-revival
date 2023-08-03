hack.md: fixchecksum.py hack.asm.bin
	python $<

hack.asm.bin: hack.asm
	asmx -e -b -C 68k $< || { rm -rf $@; exit 1; }

clean:
	rm -rf hack.asm.bin hack.md
