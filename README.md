## dvcon25 workflow

install just command runner
https://github.com/casey/just

the first time you clone the repo you wont have the required toolchain and docker image.

you should have access to the private repo and setup the authentication with gh cli tool before this inorder to download the files seamlessly. or you'll have to manually go to the repo download the files from relases and place them in the required places.

if you have gh cli installed and authenticated then run `just setup` to download the required files and set them up in the required places.

> [!NOTE]
> `just setup` downloads and places 2 important files for the workflow. if you couldn't complete the setup command for some reason, you can manually download them from thr releases (check justfile for links) and place them in the required places.

now you can use the following commands

```bash
just run # run vivado simulation
just app # build the baremetal demo application ( you need docker for this )
just mif_replace # backup existing mif file and replace it with the new one from app command
```

### requirements

1. have docker installed
2. just command runner
   you can use the following command. replace `DEST` with where you want to install it. `$HOME/.local/bin` is recommended. but if you don't have that in `$PATH` already use some path that you already have in `$PATH`

   ```bash
   # !!! replace DEST with your path
   curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to DEST

   # the following command download and move to $HOME/.local/bin
   curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to $HOME/.local/bin
   ```

3. gh cli tool: https://cli.github.com/

## directory structure

```
│── DVCon_SoC_SRC/                 # Main source files
│   ├── TOP/
│   │   └── Top.vhd                # Top-level VHDL entity
│   ├── TB/
│   │   ├── test_bench.vhd         # Main VHDL testbench
│   │   ├── glbl.v                 # Global Verilog module
│   │   └── unisims_ver/           # Xilinx simulation libraries
│   ├── AT1051_SYSTEM/
│   │   ├── AT1051_SYSTEM_TOP.v    # Processor system (simulation)
│   │   └── AT1051_SYSTEM_TOP.edn  # Processor system (synthesis)
│   ├── ACCELERATOR_IP/
│   │   ├── Accelerator_Top.vhd    # VHDL accelerator wrapper
│   │   ├── Accelerator_Top.v      # Verilog accelerator wrapper
│   │   ├── matrix_multiply_64.v   # Matrix multiplier core
│   │   └── axi_acc_dwidth_converter_0/ # AXI width converter IP
│   └── MEMORY_IP/
│       └── rom_32KB_axi/          # 32KB ROM IP core
├── TCL/
│   ├── DVCon_SIM.tcl             # simulation script
│   └── DVCon_SYNTH.tcl           # synthesis script
├── RUN/
│   ├── run.sh                     # Original run script
│   └── rom_32KB_axi.mif          # ROM initialization file
├── APPLICATION/                   # Software/firmware
│   ├── demo/
│   ├── toolchain-bare/            # Bare-metal toolchain
│   ├── util/                      # Utilities
│   └── sim_app_compile.sh         # App compilation script
├── GEN_BIT_OUT/                   # Generated outputs
│   └── DVCon_SoC_Simulation_Waveform.wcfg # Waveform config
└── VIVADO_PROJECT/                # Original project directory
```
