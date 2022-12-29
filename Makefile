build: os-image.bin

debug: os-image.bin kernel.elf
	qemu-system-i386 -s -S -fda $< & gdb -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

run: os-image.bin
	qemu-system-i386 -s -fda $< 

kernel.elf: kernel.o kernel_entry.o 
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

os-image.bin: boot/boot.bin kernel.bin
	cat $^ > os-image.bin

kernel.bin: kernel.o kernel_entry.o 
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 $^ --oformat binary

kernel.o: kernel/kernel.asm
	nasm $< -f elf -I 'kernel/' -g -o $@

kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf -I 'boot/' -g -o $@

%.bin: %.asm
	nasm $< -f bin -I 'boot/' -g -o $@

clean:
	rm -rf *.o 
	rm -rf boot/*.o boot/*.bin kernel/*.o kernel/*.bin

dangerclean:
	rm -rf *.o *.bin *.elf
	rm -rf boot/*.o boot/*.bin kernel/*.o kernel/*.bin

dependencies:
	sudo apt-get install -y nasm qemu-system-i386

info:
	$(info make dependencies: apt-get dependencies)
	$(info make: build OS binary file)
	$(info make run: run qemu with the OS binary)
	$(info make debug: debug OS binary with qemu and gdb)
	$(info make clean: clean all intermediary build files)
	$(info make dangerclean: clean *ALL* build files)

