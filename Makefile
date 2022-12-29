all: build build/os-image.bin build/kernel.elf

build:
	mkdir -p $@

debug: build/os-image.bin build/kernel.elf
	qemu-system-i386 -s -S -fda $< & gdb -ex "target remote localhost:1234" -ex "symbol-file build/kernel.elf"

run: build/os-image.bin
	qemu-system-i386 -s -fda $<

build/kernel.elf: build/kernel.o build/kernel_entry.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

build/os-image.bin: boot/boot.bin build/kernel.bin
	cat $^ > $@

build/kernel.bin: build/kernel.o build/kernel_entry.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

build/kernel.o: kernel/kernel.asm
	nasm $< -f elf -I 'kernel/' -g -o $@

build/kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf -I 'boot/' -g -o $@

%.bin: %.asm
	nasm $< -f bin -I 'boot/' -g -o $@

clean-temps:
	find build -type f ! -name 'os-image.bin' ! -name *.elf -delete

clean:
	rm -rf build

dependencies:
	sudo apt-get install -y nasm qemu-system-i386

info:
	$(info make dependencies: apt-get dependencies)
	$(info make: build OS binary file)
	$(info make run: run qemu with the OS binary)
	$(info make debug: debug OS binary with qemu and gdb)
	$(info make clean-temps: clean all intermediary build files)
	$(info make clean: clean *ALL* build files)
