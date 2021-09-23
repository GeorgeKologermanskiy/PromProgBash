#!/usr/bin/env bash

# input example - labelled_newscather_dataset.csv
INPUT_FILE=""
# output directory
OUTPUT_DIR=""

while [[ $# -gt 0 ]]
do
	key=$1
	case $key in
		-i|--input)
			INPUT_FILE=$2
			shift 2
			;;
		-o|--output-dir)
			OUTPUT_DIR=$2
			shift 2
			;;
	esac
done
if [[ ! -f $INPUT_FILE ]]; then
	echo $INPUT_FILE " not a reg. file"
	exit 0
fi

if [[ ! -d $OUTPUT_DIR ]]; then
	echo $OUTPUT_DIR "not a directory"
	exit 0
fi

cat $INPUT_FILE | ./mapper.sh | sort | ./reducer.sh >$OUTPUT_DIR/RES-00000
