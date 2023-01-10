####################################################
####################################################
##    __  ____       _                 ____  _____##
##   /  |/  (_)___  (_)___ ___  ____ _/ __ \/ ___/##
##  / /|_/ / / __ \/ / __ `__ \/ __ `/ / / /\__ \	##
## / /  / / / / / / / / / / / / /_/ / /_/ /___/ / ##
##/_/  /_/_/_/ /_/_/_/ /_/ /_/\__,_/\____//____/	##
####################################################
####################################################

####################################################
# Build Constants
####################################################

OUT_DIR		:= out
BIN_DIR		:= $(OUT_DIR)/bin
BUILD_DIR	:= $(OUT_DIR)/build


all: dir $(BIN_DIR)/os-image.bin $(BIN_DIR)/kernel.elf

debug: dir $(BIN_DIR)/os-image.bin $(BIN_DIR)/kernel.elf
	qemu-system-i386 -s -S -fda $(word 2, $^) & gdb -ex "target remote localhost:1234" -ex "symbol-file out/bin/kernel.elf"

run: dir $(BIN_DIR)/os-image.bin
	qemu-system-i386 -s -fda $(word 2, $^)

$(BIN_DIR)/kernel.elf: $(BUILD_DIR)/kernel.o $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/screen.o $(BUILD_DIR)/print_at_pm.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

$(BIN_DIR)/os-image.bin: boot/boot.bin $(BUILD_DIR)/kernel.bin
	cat $^ > $@

$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/kernel.o $(BUILD_DIR)/kernel_entry.o $(BUILD_DIR)/screen.o $(BUILD_DIR)/print_at_pm.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

$(BUILD_DIR)/kernel.o: kernel/kernel.asm
	nasm $< -f elf -I 'kernel/' -g -o $@

$(BUILD_DIR)/kernel_entry.o: boot/kernel_entry.asm
	nasm $< -f elf -I 'boot/' -g -o $@

$(BUILD_DIR)/screen.o: drivers/screen.asm
	nasm $< -f elf -I 'drivers/' -g -o $@

$(BUILD_DIR)/print_at_pm.o: kernel/print_at_pm.asm
	nasm $< -f elf -I 'kernel/' -g -o $@

%.bin: %.asm
	nasm $< -f bin -I 'boot/' -g -o $@

clean-temps:
	rm -rf $(BUILD_DIR)

clean:
	rm -rf $(OUT_DIR)

dependencies:
	sudo apt-get install -y nasm qemu-system-i386

dir:
	mkdir -p $(BUILD_DIR) $(BIN_DIR)

info:
	$(info make dependencies: apt-get dependencies)
	$(info make: build OS binary file)
	$(info make run: run qemu with the OS binary)
	$(info make debug: debug OS binary with qemu and gdb)
	$(info make clean-temps: clean all intermediary build files)
	$(info make clean: clean *ALL* build files)
