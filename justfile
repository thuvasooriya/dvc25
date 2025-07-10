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
