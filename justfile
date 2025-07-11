alias r := run
alias u := stage_files
alias s := start

# list all commands
@help:
    just --list --list-heading ''

# whole workflow from app compilation to gui sim
start: clean setup stage_files run

# run vivado simulation in batch mode - no gui
sim sim_time_us='1000':
    #!/bin/bash
    printf "{{ BLUE }}[→] starting batch simulation...{{ NORMAL }}"
    export MDIR_PATH="{{ source_directory() }}"
    export SIM_RUN_TIME="{{ sim_time_us }}"

    # execute vivado headlessly, passing it the batch-mode script
    vivado -mode batch -source "$MDIR_PATH/TCL/sim_nogui.tcl"

    printf "{{ GREEN }}[✓] simulation finished.{{ NORMAL }}"

# run the simulation in gui
run sim_time_us='1000':
    #!/bin/bash
    export MDIR_PATH="{{ source_directory() }}"
    export SIM_RUN_TIME="{{ sim_time_us }}" # in us
    vivado -source "$MDIR_PATH/TCL/DVCon_SIM.tcl"

# compile the application
compile_app:
    #!/bin/bash
    cd APPLICATION
    printf "{{ BLUE }}[i] checking for docker..{{ NORMAL }}"
    ./docker_scripts/install_and_load_docker.sh
    docker run -it --rm \
    -v "{{ source_directory() }}:/mnt/dvcon" \
    dvcon_2 \
    sh -c "cd /mnt/dvcon && cd APPLICATION && ./docker_scripts/sim_app_compile.sh"
    # sudo chown -R $USER:$USER demo

# update RUN/rom_32KB_axi.mif
stage_files: compile_app
    #!/bin/bash
    set -e # exit immediately if a command exits with a non-zero status.

    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    # .mif file paths
    SRC_MIF_FILE="APPLICATION/demo/build/accelarator_test.hex.mif"
    DEST_MIF_FILE="DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.mif"
    BACKUP_MIF_DIR="DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/backups"
    BACKUP_MIF_FILE="$BACKUP_MIF_DIR/rom_32KB_axi.mif.bak.$TIMESTAMP"

    # .coe file paths
    SRC_COE_FILE="APPLICATION/demo/build/accelarator_test.coe"
    DEST_COE_FILE="DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.coe"
    BACKUP_COE_DIR="DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/backups"
    BACKUP_COE_FILE="$BACKUP_COE_DIR/rom_32KB_axi.coe.bak.$TIMESTAMP"

    printf "{{ BLUE }}--- staging simulation files ---{{ NORMAL }}"

    printf "[→] processing MIF file..."
    # Ensure source and destination exist
    if [[ ! -f "$SRC_MIF_FILE" ]]; then
      printf "{{ RED }}[✕] source MIF file '$SRC_MIF_FILE' does not exist. run 'just compile_app' first.{{ NORMAL }}" >&2
      exit 1
    fi
    if [[ ! -f "$DEST_MIF_FILE" ]]; then
      printf "{{ RED }}[✕] destination MIF file '$DEST_MIF_FILE' does not exist.{{ NORMAL }}" >&2
      exit 1
    fi

    # Create backup
    mkdir -p "$BACKUP_MIF_DIR"
    cp "$DEST_MIF_FILE" "$BACKUP_MIF_FILE"
    printf "    [✓] backup of current MIF created at '$BACKUP_MIF_FILE'"

    # Replace the destination file
    cp "$SRC_MIF_FILE" "$DEST_MIF_FILE"
    printf "    [✓] destination MIF file replaced with new content."

    # # --- Staging for .coe file ---
    # printf "[→] Processing COE file..."
    # # Ensure source and destination exist
    # if [[ ! -f "$SRC_COE_FILE" ]]; then
    #   printf "{{ RED }}[✕] ERROR: Source COE file '$SRC_COE_FILE' does not exist. Run 'just app' first.{{ NORMAL }}" >&2
    #   exit 1
    # fi
    # if [[ ! -f "$DEST_COE_FILE" ]]; then
    #   printf "{{ RED }}[✕] ERROR: Destination COE file '$DEST_COE_FILE' does not exist.{{ NORMAL }}" >&2
    #   exit 1
    # fi
    #
    # # Create backup
    # mkdir -p "$BACKUP_COE_DIR"
    # cp "$DEST_COE_FILE" "$BACKUP_COE_FILE"
    # printf "    [✓] Backup of current COE created at '$BACKUP_COE_FILE'"
    #
    # # Replace the destination file
    # cp "$SRC_COE_FILE" "$DEST_COE_FILE"
    # printf "    [✓] Destination COE file replaced with new content."

    printf "{{ GREEN }}--- staging complete ---{{ NORMAL }}"

# initialize the required files
setup:
    #!/bin/bash
    set -euo pipefail

    REPO="thuvasooriya/dvc25"
    RELEASE_TAG="v1.0"

    TOOLCHAIN_PATTERN="toolchain-bare.tar.gz"
    TOOLCHAIN_DIR="APPLICATION/toolchain-bare"

    DOCKER_PATTERN="docker.tar"
    DOCKER_PATH="APPLICATION/docker_scripts/docker.tar"

    TMP_DIR=".gh_asset_cache"

    # Check for gh CLI
    if ! command -v gh >/dev/null 2>&1; then
      printf "[✕] GitHub CLI 'gh' not found. Install from https://cli.github.com/"
      exit 1
    fi

    # Toolchain Setup
    if [[ ! -d "$TOOLCHAIN_DIR" ]]; then
      printf "[→] Toolchain not found. Downloading from $REPO@$RELEASE_TAG..."
      mkdir -p "$TMP_DIR"
      gh release download "$RELEASE_TAG" \
        --repo "$REPO" \
        --pattern "$TOOLCHAIN_PATTERN" \
        --dir "$TMP_DIR"

      mkdir -p "$(dirname "$TOOLCHAIN_DIR")"
      tar -xzf "$TMP_DIR/$TOOLCHAIN_PATTERN" -C "$(dirname "$TOOLCHAIN_DIR")"
      printf "[✓] Toolchain extracted to '$TOOLCHAIN_DIR'"
    else
      printf "[✓] Toolchain already exists at '$TOOLCHAIN_DIR'. Skipping."
    fi

    # Docker image setup
    if [[ ! -f "$DOCKER_PATH" ]]; then
      printf "[→] Docker tarball not found. Downloading from $REPO@$RELEASE_TAG..."
      mkdir -p "$(dirname "$DOCKER_PATH")"
      gh release download "$RELEASE_TAG" \
        --repo "$REPO" \
        --pattern "$DOCKER_PATTERN" \
        --dir "$TMP_DIR"

      cp "$TMP_DIR/$DOCKER_PATTERN" "$DOCKER_PATH"
      printf "[✓] Docker image copied to '$DOCKER_PATH'"
    else
      printf "[✓] Docker image already exists at '$DOCKER_PATH'. Skipping."
    fi

    rm -rf "$TMP_DIR"

clean:
    rm -f vivado*.log
    rm -f vivado*.jou
    rm -f vivado*.str
    rm -rf *.log *.jou *.str .Xil unisims_ver work transcript modelsim.ini
