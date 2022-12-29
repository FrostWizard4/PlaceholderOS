dir = build-files
# Directory to place files built by makefile

build: $(dir) $(dir)/os-image.bin $(dir)/kernel.elf

$(dir):
	mkdir -p $@

debug: $(dir)/os-image.bin $(dir)/kernel.elf
	qemu-system-i386 -s -S -fda $< & gdb -ex "target remote localhost:1234" -ex "symbol-file $(dir)/kernel.elf"

run: $(dir)/os-image.bin
	qemu-system-i386 -s -fda $<

$(dir)/kernel.elf: $(dir)/kernel.o $(dir)/kernel_entry.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

$(dir)/os-image.bin: boot/boot.bin $(dir)/kernel.bin
	cat $^ > $@

$(dir)/kernel.bin: $(dir)/kernel.o $(dir)/kernel_entry.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

$(dir)/kernel.o: kernel/kernel.asm
	nasm $< -f elf -I 'kernel/' -g -o $@

$(dir)/kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf -I 'boot/' -g -o $@

%.bin: %.asm
	nasm $< -f bin -I 'boot/' -g -o $@

clean-temps:
	find $(dir) -type f ! -name 'os-image.bin' ! -name *.elf -delete

clean:
	rm -rf $(dir)

dependencies:
	sudo apt-get install -y nasm qemu-system-i386

info:
	$(info make dependencies: apt-get dependencies)
	$(info make: build OS binary file)
	$(info make run: run qemu with the OS binary)
	$(info make debug: debug OS binary with qemu and gdb)
	$(info make clean-temps: clean all intermediary build files)
	$(info make clean: clean *ALL* build files)
