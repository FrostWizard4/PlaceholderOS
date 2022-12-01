

kernel.bin: kernel_entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 boot/$(word 1,$^) kernel/$(word 2,$^) --oformat binary

kernel_entry.o: 
	cd boot && nasm kernel_entry.asm -f elf -o $@ && cd ../

kernel.o: 
	nasm kernel/kernel.asm -f elf -o kernel/$@

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

boot.bin:
	cd boot && nasm boot.asm -f bin -o $@ && cd ../

os-image.bin: boot.bin kernel.bin
	cat boot/$< $(word 2,$^) > $@

debug: os-image.bin
	qemu-system-i386 -fda $< -no-shutdown -no-reboot -d int -monitor stdio

run: os-image.bin
	qemu-system-i386 -fda $<
clean:
	find . -type f -name '*.bin' -delete && find . -type f -name '*.o' -delete && find . -type f -name '*.dis' -delete
