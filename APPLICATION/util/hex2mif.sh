#!/bin/sh
file=$1
cat /dev/null >$1.mif
while IFS= read line; do
	echo $line | xxd -p -r | xxd -b -g 0 -c 16 | cut -c11-138 >>$1.mif #| cut -c11-74
done <"$file"
