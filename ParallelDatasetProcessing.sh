#!/usr/bin/env bash

WORKER_NUM=1
INPUT_FILE=""
OUTPUT_DIR=""
COL_NAME=""

# parse args
while [[ $# -gt 0 ]]
do
	key=$1
	case $key in
		-w|--worker-num)
			WORKER_NUM=$2
			shift 2
			;;
		-i|--input)
			INPUT_FILE=$2
			shift 2
			;;
		-o|--output)
			OUTPUT_DIR=$2
			shift 2
			;;
		-c|--column)
			COL_NAME=$2
			shift 2
			;;
	esac
done
if [[ ! -f $INPUT_FILE ]]; then
	echo $INPUT_FILE "not exists"
	exit 0
fi
if [[ ! -d $OUTPUT_DIR  ]]; then
	echo $OUTPUT_DIR "not a directory"
	exit 0
fi
if [[ -z $COL_NAME ]]; then
	echo "Column name not defined"
	exit 0
fi


