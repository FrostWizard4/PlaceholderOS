all: run

kernel.bin: kernel_entry.o kernel.o
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel_entry.asm
	nasm boot/$< -f elf -o boot/$@

kernel.o: kernel.asm
	nasm boot/$< -f elf -o boot/$@

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

boot.bin: boot.asm
	nasm boot/$< -f bin -o boot/$@

os-image.bin: boot.bin kernel.bin
	cat boot/$< kernel/$(word 2,$^) > $@

debug: os-image.bin
	qemu-system-i386 -fda $< -no-shutdown -no-reboot -d int -monitor stdio

run: os-image.bin
	qemu-system-i386 -fda $<
clean:
	rm *.bin *.o *.dis
