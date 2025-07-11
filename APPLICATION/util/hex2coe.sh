#!/bin/bash
# Description: Converts a file with one hex value per line to a Xilinx COE file.
# Usage: hex2coe.sh <input.hex> <output.coe>

IN_FILE="$1"
OUT_FILE="$2"

if [[ -z "$IN_FILE" || -z "$OUT_FILE" ]]; then
	echo "Usage: $0 <input.hex> <output.coe>"
	exit 1
fi

# Write the mandatory COE file header
echo "memory_initialization_radix=16;" >"$OUT_FILE"
echo "memory_initialization_vector=" >>"$OUT_FILE"

# Use 'paste' to join all lines from the input file with a comma,
# then append the final semicolon. This is a robust way to format the vector.
paste -sd, "$IN_FILE" >>"$OUT_FILE"
echo ";" >>"$OUT_FILE"
