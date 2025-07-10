#!/bin/bash

printf "\n"
printf "\e[1;34m--------------------------\e[0m"
printf "\e[1;34m|\e[1;32m!! Design & Verification Challenge !!\e[0m \e[1;34m|\e[0m"
printf "\e[1;34m--------------------------\e[0m\n"

rm -rf *.log *.jou *.str .Xil unisims_ver work transcript modelsim.ini

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# read -p $'\nWrite Your Main Directory Path:\n[ eg:- /home/Documents/DVCon_2025 ]\n> ' MDIR_PATH
# export MDIR_PATH="/Users/tony/dev/dvcon25/cdac"

if [ ! -d "$MDIR_PATH" ]; then
    printf "\n${RED}directory does not exist. please check the path.${NC}"
    exit 1
fi

# sed -i "s|set MDIR_PATH \".*\"|set MDIR_PATH \"$MDIR_PATH\"|" "$MDIR_PATH/TCL/DVCon_SIM.tcl"
# sed -i "s|set MDIR_PATH \".*\"|set MDIR_PATH \"$MDIR_PATH\"|" "$MDIR_PATH/TCL/DVCon_SYNTH.tcl"
while true; do
    printf "${GREEN}"
    echo "==========================================="
    echo " FPGA Project Tool Menu"
    echo " Main Directory: $MDIR_PATH"
    echo "==========================================="
    echo "1) Vivado Simulation"
    echo "2) FPGA Implementation"
    echo "3) FPGA Programming"
    echo "4) Exit"
    echo "==========================================="
    printf "${NC}"
    read -p "Select an option [1-4]: " choice

    case $choice in
    1)
        echo "Running Vivado Simulation..."
        vivado -source $MDIR_PATH/TCL/DVCon_SIM.tcl
        ;;
    2)
        echo ""
        printf "${GREEN}"
        echo "-------------------------------------------"
        echo "      FPGA Implementation Options"
        echo "-------------------------------------------"
        printf "${NC}"
        echo "  1)  Synthesis Only"
        echo "  2)  Full Implementation (Synthesis + Implementation + Bitstream)"
        echo "-------------------------------------------"
        read -p "Enter your choice [1-2]: " imp_choice
        echo ""
        case $imp_choice in
        1)
            echo "Running Synthesis Only..."
            vivado -mode batch -source $MDIR_PATH/TCL/DVCon_SYNTH.tcl
            ;;
        2)
            printf "\e[1;31m"
            printf "\n ----------------------------------------"
            printf " |  Will provide in the Next Stage...!! |"
            printf " ----------------------------------------"
            printf "${NC}"
            ;;
        *)
            echo "Invalid implementation option. Please choose 1 or 2."
            ;;
        esac
        ;;
    3)
        printf "\e[1;31m"
        printf "\n ----------------------------------------"
        printf " |  Will provide in the Next Stage...!! |"
        printf " ----------------------------------------"
        printf "${NC}"
        ;;
    4)
        echo "Exiting..."
        break
        ;;
    *)
        echo "Invalid option. Please choose between 1 and 4."
        ;;
    esac
    echo ""
done
