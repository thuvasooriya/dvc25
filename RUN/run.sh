#!/bin/bash

# color definitions for cross-platform compatibility
readonly CLEAR="\ec"
readonly NORMAL="\e[0m"
readonly BOLD="\e[1m"
readonly ITALIC="\e[3m"
readonly UNDERLINE="\e[4m"
readonly INVERT="\e[7m"
readonly HIDE="\e[8m"
readonly STRIKETHROUGH="\e[9m"
readonly BLACK="\e[30m"
readonly RED="\e[31m"
readonly GREEN="\e[32m"
readonly YELLOW="\e[33m"
readonly BLUE="\e[34m"
readonly MAGENTA="\e[35m"
readonly CYAN="\e[36m"
readonly WHITE="\e[37m"
readonly BG_BLACK="\e[40m"
readonly BG_RED="\e[41m"
readonly BG_GREEN="\e[42m"
readonly BG_YELLOW="\e[43m"
readonly BG_BLUE="\e[44m"
readonly BG_MAGENTA="\e[45m"
readonly BG_CYAN="\e[46m"
readonly BG_WHITE="\e[47m"

# configuration
readonly SCRIPT_NAME="FPGA Project Tool"
readonly TCL_DIR="$MDIR_PATH/TCL"
readonly HSPACE=" "

#============================================================================
# utility functions
#============================================================================

print_header() {
    printf "\n"
    printf "${BLUE}${BOLD}=================================${NORMAL}\n"
    printf "${BLUE}${BOLD}|${GREEN} $SCRIPT_NAME ${NORMAL}${BLUE}${BOLD}|${NORMAL}\n"
    printf "${BLUE}${BOLD}=================================${NORMAL}\n"
}

print_separator() {
    printf "${CYAN}-------------------------------------------${NORMAL}\n"
}

validate_environment() {
    if [ ! -d "$MDIR_PATH" ]; then
        printf "\n${RED}${BOLD}[✕] error: MDIR_PATH directory does not exist${NORMAL}\n"
        printf "${RED}[!] please check the path: $MDIR_PATH${NORMAL}\n"
        exit 1
    fi

    if [ ! -d "$TCL_DIR" ]; then
        printf "\n${RED}${BOLD}[✕] error: TCL directory does not exist${NORMAL}\n"
        printf "${RED}[!] please check the path: $TCL_DIR${NORMAL}\n"
        exit 1
    fi
}

cleanup_files() {
    printf "${YELLOW}[*] cleaning up temporary files...${NORMAL}\n"
    rm -rf *.log *.jou *.str .Xil unisims_ver work transcript modelsim.ini
}

run_vivado_script() {
    local script_name=$1
    local script_path="$TCL_DIR/$script_name"
    local mode=$2

    if [ ! -f "$script_path" ]; then
        printf "${RED}[✕] error: script not found: $script_path${NORMAL}\n"
        return 1
    fi

    printf "${GREEN}[+] executing: $script_name${NORMAL}\n"
    if [ "$mode" = "batch" ]; then
        vivado -mode batch -source "$script_path"
    else
        vivado -source "$script_path"
    fi
}

show_not_implemented() {
    printf "${RED}${BOLD}"
    printf "\n =========================================="
    printf "\n | [!] feature will be available soon... |"
    printf "\n =========================================="
    printf "${NORMAL}\n"
}

#============================================================================
# main menu system
#============================================================================

display_menu() {
    printf "\n"
    printf "${BLUE}${BOLD}╔════════════════════════════════════════════════════════════════╗${NORMAL}\n"
    printf "${BLUE}${BOLD}║                        DVCON 25 SYNTH-Z                        ║${NORMAL}\n"
    printf "${BLUE}${BOLD}╚════════════════════════════════════════════════════════════════╝${NORMAL}\n"
    printf "\n"
    printf "  ${CYAN}[i] workspace: ${GREEN}$MDIR_PATH${NORMAL}\n"
    printf "\n"

    printf "${BLUE}${HSPACE}════════════════════════════════════════════════════════════════${NORMAL}\n"
    printf "${BLUE}${BOLD}${HSPACE}SIMULATION${NORMAL}\n"
    printf "${BLUE}${HSPACE}════════════════════════════════════════════════════════════════${NORMAL}\n"
    printf "  ${YELLOW}[1]${NORMAL} fast simulation        ${CYAN}(non-project, console only)${NORMAL}\n"
    printf "  ${YELLOW}[2]${NORMAL} batch simulation       ${CYAN}(project mode, no GUI)${NORMAL}\n"
    printf "  ${YELLOW}[3]${NORMAL} GUI simulation         ${CYAN}(full GUI with waveforms)${NORMAL}\n"
    printf "\n"

    printf "${MAGENTA}${HSPACE}════════════════════════════════════════════════════════════════${NORMAL}\n"
    printf "${MAGENTA}${BOLD}${HSPACE}IMPLEMENTATION${NORMAL}\n"
    printf "${MAGENTA}${HSPACE}════════════════════════════════════════════════════════════════${NORMAL}\n"
    printf "  ${YELLOW}[5]${NORMAL} synthesis only         ${CYAN}(quick synthesis check)${NORMAL}\n"
    printf "  ${YELLOW}[6]${NORMAL} full implementation    ${CYAN}(synthesis + P&R + bitstream)${NORMAL}\n"
    printf "\n"

    printf "${GREEN}${HSPACE}════════════════════════════════════════════════════════════════${NORMAL}\n"
    printf "${GREEN}${BOLD}${HSPACE}MISC${NORMAL}\n"
    printf "${GREEN}${HSPACE}════════════════════════════════════════════════════════════════${NORMAL}\n"
    printf "  ${YELLOW}[7]${NORMAL} programming            ${CYAN}(device programming)${NORMAL}\n"
    printf "  ${YELLOW}[8]${NORMAL} clean & exit           ${CYAN}(cleanup and exit)${NORMAL}\n"
    printf "\n"
}

process_choice() {
    local choice=$1

    case $choice in
    1)
        printf "\n${GREEN}[+] starting fast simulation...${NORMAL}\n"
        printf "${CYAN}[*] features: non-project mode, console output only, fastest execution${NORMAL}\n"
        run_vivado_script "sim_npm.tcl" "batch"
        ;;
    2)
        printf "\n${GREEN}[+] starting batch simulation...${NORMAL}\n"
        printf "${CYAN}[*] features: project mode, no GUI, moderate speed${NORMAL}\n"
        run_vivado_script "sim_nogui.tcl" "batch"
        ;;
    3)
        printf "\n${GREEN}[+] starting GUI simulation...${NORMAL}\n"
        printf "${CYAN}[*] features: full GUI, waveform viewing, interactive debugging${NORMAL}\n"
        run_vivado_script "DVCon_SIM.tcl" "gui"
        ;;
    5)
        printf "\n${GREEN}[+] starting synthesis only...${NORMAL}\n"
        printf "${CYAN}[*] features: quick synthesis check, no implementation${NORMAL}\n"
        run_vivado_script "DVCon_SYNTH.tcl" "batch"
        ;;
    6)
        printf "\n${GREEN}[+] starting full implementation...${NORMAL}\n"
        show_not_implemented
        ;;
    7)
        printf "\n${GREEN}[+] starting FPGA programming...${NORMAL}\n"
        show_not_implemented
        ;;
    8)
        printf "\n${GREEN}[+] cleaning up and exiting...${NORMAL}\n"
        cleanup_files
        printf "${GREEN}[✓] goodbye!${NORMAL}\n"
        exit 0
        ;;
    *)
        printf "\n${RED}[✕] invalid option. please choose between 1-8${NORMAL}\n"
        ;;
    esac
}

main() {
    validate_environment

    while true; do
        display_menu
        read -p "[*] select an option: " choice
        process_choice "$choice"

        printf "\n${YELLOW}[*] press enter to continue...${NORMAL}"
        read -r
    done
}

main "$@"
