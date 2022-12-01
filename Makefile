all: run

kernel.bin: kernel_entry.o kernel.o
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.asm
	nasm $< -f elf -o $@

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

boot.bin: boot.asm
	nasm $< -f bin -o $@

os-image.bin: bootsect.bin kernel.bin
	cat $^ > $@

debug: os-image.bin
	qemu-system-i386 -fda $< -no-shutdown -no-reboot -d int -monitor stdio

run: os-image.bin
	qemu-system-i386 -fda $<
clean:
	rm *.bin *.o *.dis
