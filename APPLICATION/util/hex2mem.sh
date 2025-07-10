#!/bin/sh
from=0x10000 
format="@%08x  "
file=$1
cat /dev/null>$1.mem
while IFS= read line
do        
	#echo "$line"
	printf "$format" "$from" >> $1.mem
	echo "$line" | tac -rs .. | echo "$(tr -d '\n')"| sed 's/\(..\)/\1  /g'|sed 's/ *$//' >> $1.mem
	from=$((from+16))
done <"$file"




