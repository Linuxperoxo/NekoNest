# Files

BOOTLOADER_SRC = src/bootloader.s
BOOTLOADER_BIN = $(BIN_DIR)/bootloader

# Dirs

BUILD_DIR = build
BIN_DIR   = build/bin
OBJ_DIR   = build/obj

# Execs

ASM  = /usr/bin/nasm
QEMU = /usr/bin/qemu-system-i386
LD   = /usr/bin/ld

# Flags

ASMFLAGS   = -f bin
QEMU_FLAGS = -drive file=$(BOOTLOADER_BIN),format=raw 

# Rules

all: $(BOOTLOADER_BIN)

$(BUILD_DIR): 
	mkdir -p $(BIN_DIR) $(OBJ_DIR)


$(BOOTLOADER_BIN): $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $(BOOTLOADER_SRC) -o $@

clean:
	rm -rf $(BUILD_DIR)

run: $(BOOTLOADER_BIN)
	$(QEMU) $(QEMU_FLAGS)
