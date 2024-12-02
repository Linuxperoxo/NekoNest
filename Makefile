# Files
BOOTLOADER_SRC = $(SRC_DIR)/bootloader.s
BOOTLOADER_BIN = $(BIN_DIR)/bootloader
LOADER_SRC = $(SRC_DIR)/loader.s
LOADER_BIN = $(BIN_DIR)/loader
IMG_FILE = $(IMG_DIR)/os.img

# Dirs
BUILD_DIR = build
BIN_DIR   = $(BUILD_DIR)/bin
SRC_DIR   = src
IMG_DIR   = $(BUILD_DIR)/img

# Execs
ASM  = /usr/bin/nasm
QEMU = /usr/bin/qemu-system-i386
LD   = /usr/bin/ld

# Flags
ASMFLAGS   = -f bin
QEMU_FLAGS = -drive file=$(IMG_FILE),format=raw 

# Rules
all: $(BUILD_DIR) $(LOADER_BIN) $(BOOTLOADER_BIN) $(IMG_FILE)

$(BUILD_DIR): 
	mkdir -p $(BIN_DIR) $(OBJ_DIR) $(IMG_DIR)

$(LOADER_BIN): 
	$(ASM) $(ASMFLAGS) $(LOADER_SRC) -o $@

$(BOOTLOADER_BIN):
	$(ASM) $(ASMFLAGS) $(BOOTLOADER_SRC) -o $@

$(IMG_FILE): $(BOOTLOADER_BIN) $(LOADER_BIN)
	cat $^ > $@

clean:
	rm -rf $(BUILD_DIR)

run: image
	$(QEMU) $(QEMU_FLAGS)
