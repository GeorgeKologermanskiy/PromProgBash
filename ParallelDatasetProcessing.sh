#!/usr/bin/env bash

WORKER_NUM=1
INPUT_FILE=""
OUTPUT_DIR=""
COL_NAME=""
HEAD=""

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
		--head)
			HEAD=$2
			shift 2
			;;
	esac
done
if [[ ! -f $INPUT_FILE ]]; then
	echo $INPUT_FILE "not exists"
	exit 0
fi
if [[ -z $COL_NAME ]]; then
	echo "Column name not defined"
	exit 0
fi

COL_POS=$(cat $INPUT_FILE | head -n1 | awk -v colname=$COL_NAME -f csv-parser.awk --source 'csv_find_colnum($0, colname)')

if [[ $COL_POS -eq -1 ]]; then
	echo "Column was not found"
	exit 0
fi

if [[ ! -d $OUTPUT_DIR ]]; then
	if ! mkdir -p $OUTPUT_DIR; then
		echo $OUTPUT_DIR "is not a directory and cant create dir"
		exit 0
	fi
fi

if [[ ! -z HEAD ]]; then
	awk -v colpos=$COL_POS -f csv-parser.awk --source 'csv_parse($0, colpos)' $INPUT_FILE | head -n${HEAD} | parallel -j ${WORKER_NUM} wget -q -P ${OUTPUT_DIR} {}
else
	awk -v colpos=$COL_POS -f csv-parser.awk --source 'csv_parse($0, colpos)' $INPUT_FILE | parallel -j ${WORKER_NUM} wget -q -P ${OUTPUT_DIR} {}
fi
