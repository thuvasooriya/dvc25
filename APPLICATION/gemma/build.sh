EXE_NAME=gemma_accelerator
export PATH=$PATH:../toolchain-bare/bin/:../util
make clean
make
riscv64-unknown-elf-objdump -D build/$EXE_NAME >build/$EXE_NAME.dump
riscv64-unknown-elf-objcopy -I elf32-littleriscv -O binary --remove-section .got --remove-section .got.plt --remove-section .sdata --remove-section .sbss --remove-section .bss --remove-section .comment --gap-fill 0x00 build/$EXE_NAME build/$EXE_NAME.bin

echo "[i] bin2hex: $EXE_NAME"
bin2hex --bit-width 128 build/$EXE_NAME.bin build/$EXE_NAME.hex
echo "[i] hex2mif: $EXE_NAME"
hex2mif.sh build/$EXE_NAME.hex
echo "[i] hex2coe: $EXE_NAME"
hex2coe.sh build/$EXE_NAME.hex build/$EXE_NAME.coe
echo "[i] hex2mem: $EXE_NAME"
hex2mem.sh build/$EXE_NAME.hex
cp build/$EXE_NAME.hex.mem build/$EXE_NAME.mem
