app:
    #!/bin/bash
    cd APPLICATION
    echo "{{ BLUE }}[i] checking for docker..{{ NORMAL }}"
    ./docker_scripts/install_and_load_docker.sh
    docker run -it --rm -v $(pwd)/../../cdac:/mnt/dvcon dvcon_2 sh -c "cd /mnt/dvcon && cd APPLICATION && ./docker_scripts/sim_app_compile.sh"
    # sudo chown -R $USER:$USER demo

run:
    #!/bin/bash
    export MDIR_PATH="{{ source_directory() }}"
    export SIM_RUN_TIME="1000"
    ./RUN/run.sh

mif_replace:
    #!/bin/bash
    ROM_FILE="RUN/rom_32KB_axi.mif"
    SRC_FILE="APPLICATION/demo/build/accelarator_test.hex.mif"
    BACKUP_DIR="RUN/backups"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/rom_32KB_axi.mif.bak.$TIMESTAMP"

    # ensure source and target exist
    if [[ ! -f "$ROM_FILE" ]]; then
      echo "{{ RED }}[✕] error: rarget ROM file '$ROM_FILE' does not exist{{ NORMAL }}" >&2
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
