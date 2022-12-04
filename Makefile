KERNEL_OBJ = $(wildcard kernel/*.o)
BOOT_OBJ =$(wildcard boot/*.o)

kernel.bin: ${BOOT_OBJ} ${KERNEL_OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 boot/$(word 1,$^) $(word 2,$^) --oformat binary

kernel_entry.o: 
	cd boot && nasm kernel_entry.asm -f elf -o $@ -g && cd ../

kernel.o: 
	cd kernel && nasm kernel.asm -f elf -o $@ -g && cd ../

kernel.elf: ${BOOT_OBJ} ${KERNEL_OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

boot.bin:
	cd boot && nasm boot.asm -f bin -o $@ -g && cd ../

os-image.bin: boot.bin kernel.bin
	cat boot/$< $(word 2,$^) > $@

debug: os-image.bin kernel.elf
	qemu-system-i386 -s -S -fda $<  & gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

debug-qemu: os-image.bin kernel.elf
	qemu-system-i386 -fda $< -no-shutdown -no-reboot -d int -monitor stdio

run: os-image.bin
	qemu-system-i386 -fda $<

%.o: %.asm
	nasm $< -f elf -o $@ -g

%.bin: %.asm
	nasm $< -f bin -o $@ -g

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o
