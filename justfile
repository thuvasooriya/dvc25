alias r := run
alias u := update_mif

# list all commands
help:
    just --list --list-heading ''

# run the simulation
run sim='100':
    #!/bin/bash
    export MDIR_PATH="{{ source_directory() }}"
    export SIM_RUN_TIME="{{ sim }}" # in us
    ./RUN/run.sh

# compile the application
compile_app:
    #!/bin/bash
    cd APPLICATION
    echo "{{ BLUE }}[i] checking for docker..{{ NORMAL }}"
    ./docker_scripts/install_and_load_docker.sh
    docker run -it --rm \
    -v "{{ source_directory() }}:/mnt/dvcon" \
    dvcon_2 \
    sh -c "cd /mnt/dvcon && cd APPLICATION && ./docker_scripts/sim_app_compile.sh"
    # sudo chown -R $USER:$USER demo

# update RUN/rom_32KB_axi.mif
update_mif: compile_app
    #!/bin/bash
    ROM_FILE="RUN/rom_32KB_axi.mif"
    SRC_FILE="APPLICATION/demo/build/accelarator_test.hex.mif"
    BACKUP_DIR="RUN/backups"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/rom_32KB_axi.mif.bak.$TIMESTAMP"

    # ensure source and target exist
    if [[ ! -f "$ROM_FILE" ]]; then
      echo "{{ RED }}[✕] error: target ROM file '$ROM_FILE' does not exist{{ NORMAL }}" >&2
      exit 1
    fi

    if [[ ! -f "$SRC_FILE" ]]; then
      echo "{{ RED }}[✕] error: source file '$SRC_FILE' does not exist{{ NORMAL }}" >&2
      exit 2
    fi

    mkdir -p "$BACKUP_DIR"

    cp "$ROM_FILE" "$BACKUP_FILE"
    echo "{{ GREEN }}[✓] backup created at '$BACKUP_FILE'{{ NORMAL }}"

    # replace the rom file
    cp "$SRC_FILE" "$ROM_FILE"
    echo "{{ GREEN }}[✓] ROM file replaced with '$SRC_FILE'{{ NORMAL }}"

stage_files:
    #!/bin/bash
    set -e # Exit immediately if a command exits with a non-zero status.

    # --- Configuration ---
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

    echo "{{ BLUE }}--- Staging Simulation Files ---{{ NORMAL }}"

    # --- Staging for .mif file ---
    echo "[→] Processing MIF file..."
    # Ensure source and destination exist
    if [[ ! -f "$SRC_MIF_FILE" ]]; then
      echo "{{ RED }}[✕] ERROR: Source MIF file '$SRC_MIF_FILE' does not exist. Run 'just app' first.{{ NORMAL }}" >&2
      exit 1
    fi
    if [[ ! -f "$DEST_MIF_FILE" ]]; then
      echo "{{ RED }}[✕] ERROR: Destination MIF file '$DEST_MIF_FILE' does not exist.{{ NORMAL }}" >&2
      exit 1
    fi

    # Create backup
    mkdir -p "$BACKUP_MIF_DIR"
    cp "$DEST_MIF_FILE" "$BACKUP_MIF_FILE"
    echo "    [✓] Backup of current MIF created at '$BACKUP_MIF_FILE'"

    # Replace the destination file
    cp "$SRC_MIF_FILE" "$DEST_MIF_FILE"
    echo "    [✓] Destination MIF file replaced with new content."

    # # --- Staging for .coe file ---
    # echo "[→] Processing COE file..."
    # # Ensure source and destination exist
    # if [[ ! -f "$SRC_COE_FILE" ]]; then
    #   echo "{{ RED }}[✕] ERROR: Source COE file '$SRC_COE_FILE' does not exist. Run 'just app' first.{{ NORMAL }}" >&2
    #   exit 1
    # fi
    # if [[ ! -f "$DEST_COE_FILE" ]]; then
    #   echo "{{ RED }}[✕] ERROR: Destination COE file '$DEST_COE_FILE' does not exist.{{ NORMAL }}" >&2
    #   exit 1
    # fi
    #
    # # Create backup
    # mkdir -p "$BACKUP_COE_DIR"
    # cp "$DEST_COE_FILE" "$BACKUP_COE_FILE"
    # echo "    [✓] Backup of current COE created at '$BACKUP_COE_FILE'"
    #
    # # Replace the destination file
    # cp "$SRC_COE_FILE" "$DEST_COE_FILE"
    # echo "    [✓] Destination COE file replaced with new content."

    echo "{{ GREEN }}--- Staging Complete ---{{ NORMAL }}"

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
      echo "[✕] GitHub CLI 'gh' not found. Install from https://cli.github.com/"
      exit 1
    fi

    # Toolchain Setup
    if [[ ! -d "$TOOLCHAIN_DIR" ]]; then
      echo "[→] Toolchain not found. Downloading from $REPO@$RELEASE_TAG..."
      mkdir -p "$TMP_DIR"
      gh release download "$RELEASE_TAG" \
        --repo "$REPO" \
        --pattern "$TOOLCHAIN_PATTERN" \
        --dir "$TMP_DIR"

      mkdir -p "$(dirname "$TOOLCHAIN_DIR")"
      tar -xzf "$TMP_DIR/$TOOLCHAIN_PATTERN" -C "$(dirname "$TOOLCHAIN_DIR")"
      echo "[✓] Toolchain extracted to '$TOOLCHAIN_DIR'"
    else
      echo "[✓] Toolchain already exists at '$TOOLCHAIN_DIR'. Skipping."
    fi

    # Docker image setup
    if [[ ! -f "$DOCKER_PATH" ]]; then
      echo "[→] Docker tarball not found. Downloading from $REPO@$RELEASE_TAG..."
      mkdir -p "$(dirname "$DOCKER_PATH")"
      gh release download "$RELEASE_TAG" \
        --repo "$REPO" \
        --pattern "$DOCKER_PATTERN" \
        --dir "$TMP_DIR"

      cp "$TMP_DIR/$DOCKER_PATTERN" "$DOCKER_PATH"
      echo "[✓] Docker image copied to '$DOCKER_PATH'"
    else
      echo "[✓] Docker image already exists at '$DOCKER_PATH'. Skipping."
    fi

    rm -rf "$TMP_DIR"

clean:
    rm -f vivado*.log
    rm -f vivado*.jou
    rm -f vivado*.str

batch_sim:
    #!/bin/bash
    echo "{{ BLUE }}[→] Starting ROBUST Batch-Mode Simulation...{{ NORMAL }}"
    # Set the environment variables needed by the TCL script
    export MDIR_PATH="{{ source_directory() }}"
    export SIM_RUN_TIME="100" # Keep it short for the "Hello World" test

    # Execute Vivado headlessly, passing it the batch-mode script
    vivado -mode batch -source "$MDIR_PATH/TCL/sim_nogui.tcl"

    echo "{{ GREEN }}[✓] Batch simulation finished.{{ NORMAL }}"
    echo "{{ GREEN }}[✓] Fast simulation finished. Check terminal output for UART messages.{{ NORMAL }}"
