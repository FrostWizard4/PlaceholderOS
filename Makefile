build: build-files/os-image.bin

build-files:
	mkdir -p $@

debug: build-files/os-image.bin build-files/kernel.elf
	qemu-system-i386 -s -S -fda $< & gdb -ex "target remote localhost:1234" -ex "symbol-file build-files/kernel.elf"

run: build-files/os-image.bin
	qemu-system-i386 -s -fda $<

build-files/kernel.elf: build-files/kernel.o build-files/kernel_entry.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

build-files/os-image.bin: boot/boot.bin build-files/kernel.bin
	cat $^ > $@

build-files/kernel.bin: build-files/kernel.o build-files/kernel_entry.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

build-files/kernel.o: kernel/kernel.asm
	nasm $< -f elf -I 'kernel/' -g -o $@

build-files/kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf -I 'boot/' -g -o $@

%.bin: %.asm
	nasm $< -f bin -I 'boot/' -g -o $@

clean:
	cd build-files
	rm -i -- !(file.txt)

dangerclean:


dependencies:
	sudo apt-get install -y nasm qemu-system-i386

info:
	$(info make dependencies: apt-get dependencies)
	$(info make: build OS binary file)
	$(info make run: run qemu with the OS binary)
	$(info make debug: debug OS binary with qemu and gdb)
	$(info make clean: clean all intermediary build files)
	$(info make dangerclean: clean *ALL* build files)
