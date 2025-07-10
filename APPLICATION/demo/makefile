#-----------------------------------------
# Flags
#-----------------------------------------
TOOLCHAIN_PATH=/home/hdg/NEWRISC/riscv-i/bin
CC=riscv64-unknown-elf-gcc #riscv64-unknown-elf-gcc
CFLAGS=-c -mcmodel=medany -march=rv32ima_zifencei_zicsr -mabi=ilp32 -O0 -Wall #fd #-march=rv64imafd -mabi=lp64d  # -O0 #-Wall
LIB=
LDFLAGS=
CFLAGS += -Wa,--noexecstack
LDFLAGS += -z noexecstack

EXECUTABLE_NAME=accelarator_test 
INC=-Iinclude

# Folders
BIN=build

#-----------------------------------------
# Rules
#-----------------------------------------
LINK_OPTS ?=  -march=rv32ima_zifencei -mabi=ilp32  -nostartfiles -nostdlib -lm -lgcc -T mbl.lds #-static  
EXECUTABLE_FILES = $(EXECUTABLE_NAME:%=$(BIN)/%)
OBJECT_FILES_C   = $(patsubst %.c, $(BIN)/%.o, $(wildcard *.c))
OBJECT_FILES_S   = $(patsubst %.S, $(BIN)/%.o,  $(wildcard *.S))

all: $(EXECUTABLE_FILES) 

clean:
	rm -r -f $(BIN)	
mrproper:
	rm -r -f $(BIN)	.version
.PHONY: build clean



$(EXECUTABLE_FILES): $(OBJECT_FILES_C) $(OBJECT_FILES_S) 
	@$(CC) $(LDFLAGS) -o $@ $^ $(LIB) $(LINK_OPTS)
	@echo "Build successful!"


$(OBJECT_FILES_C): $(BIN)/%.o: %.c
	@echo Compiling $<
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) $(INC) -o $@ $<

$(OBJECT_FILES_S): $(BIN)/%.o: %.S
	@echo Compiling $<
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) $(INC) -o $@ $<




