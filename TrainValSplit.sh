#!/usr/bin/env bash

INPUT_PATH=""
TRAIN_RATIO=0
STRATISFIED=0
COL_NAME=""

# parse args
while [[ $# -gt 0 ]]
do
	key=$1
	case $key in
		-i|--input)
			INPUT_PATH=$2
			shift 2
			;;
		-t|--train_ratio)
			TRAIN_RATIO=$2
			shift 2
			;;
		--stratisfied)
			STRATISFIED=1
			shift 1
			;;
		--y_column)
			COL_NAME=$2
			shift 2
			;;
	esac
done
if [[ ! -f $INPUT_PATH  ]]; then
	echo $INPUT_FILE "not exists"
	exit 0
fi
if [[ -z $COL_NAME ]]; then
	echo "Column name not defined"
	exit 0
fi

# set train/test paths
TRAIN_PATH=$INPUT_PATH.train.csv
TEST_PATH=$INPUT_PATH.test.csv
INPUT_TEMP_PATH=$INPUT_PATH.tmp
if [[ -f $TRAIN_PATH ]]; then
	rm $TRAIN_PATH
fi
if [[ -f $TEST_PATH ]]; then
	rm $TEST_PATH
fi
if [[ -f $INPUT_TEMP_PATH ]]; then
	rm $INPUT_TEMP_PATH
fi

cat $INPUT_PATH | awk '{if (NR != 1) print $0}' | shuf >$INPUT_TEMP_PATH

FIRST_LINE=$(cat $INPUT_PATH | head -n1)

# calculate size
SIZE=$(expr $(cat $INPUT_PATH | wc -l) - 1)
TRAIN_SIZE=$(echo "$SIZE*$TRAIN_RATIO" | bc | awk '{print int($1)}')

# not stratisfied split
if [[ $STRATISFIED -eq 0 ]]; then
	# write train file
	echo $FIRST_LINE >$TRAIN_PATH
	awk -v barrier=$TRAIN_SIZE '{if (NR <= barrier) print $0}' $INPUT_TEMP_PATH >> $TRAIN_PATH
	
	# write test file
	echo $FIRST_LINE >$TEST_PATH
	awk -v barrier=$TRAIN_SIZE '{if (NR > barrier) print $0}' $INPUT_TEMP_PATH >> $TEST_PATH
	
	# delete tmp file
	rm $INPUT_TEMP_PATH
	exit 0
fi

COL_POS=$(echo $FIRST_LINE | awk -f csv-parser.awk -v col_name=$COL_NAME --source '{csv_find_colnum($0, col_name)}')


